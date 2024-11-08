(* Project 2 - Multiprocessing Tree *)

(* open Riot *)

(* Defining a binary tree *)
type tree =
  | Empty
  | Node of int * tree * tree;;

(* Get size of binary tree *)
let _size t =
  let sizepids = ref [] in
    let count = ref 0 in
    let rec helper t=
      match t with
      | Empty -> ()
      | Node (_, l, r) -> count := (!count + 1);
              let left_pid = Riot.spawn (fun () -> helper l) in
              let right_pid = Riot.spawn (fun () -> helper r) in
              sizepids := left_pid :: right_pid :: !sizepids in

    helper t;
    Riot.wait_pids !sizepids;
    !count;;

(* Function to insert an element into the binary tree *)
let rec insert x = function
  | Empty -> Node(x, Empty, Empty)
  | Node(v, left, right) ->
      if x < v then
        Node(v, insert x left, right)
      else
        Node(v, left, insert x right);;

(* Function to merge two binary trees *)
let rec merge_trees t1 t2 =
  Printf.printf "Merging trees\n"; flush stdout;
  match t2 with
  | Empty -> t1
  | Node (v, l, r) ->
      let merged_left = merge_trees t1 l in
      let merged_right = merge_trees merged_left r in
      insert v merged_right

      let rec chunks_of n lst =
        Printf.printf "Starting chunks_of\n"; flush stdout;
        if n <= 0 then invalid_arg "chunks_of"
        else
          let rec take n lst =
            match n, lst with
            | 0, _ | _, [] -> []
            | n, x::xs -> x :: take (n-1) xs
          in
          let rec drop n lst =
            match n, lst with
            | 0, _ | _, [] -> lst
            | n, _::xs -> drop (n-1) xs
          in
          match lst with
          | [] -> []
          | _ -> let chunk = take n lst in
                  Printf.printf "Chunk created: %d elements\n" (List.length chunk); flush stdout;
                  let remaining = drop n lst in
                  if remaining = [] then [chunk]
                  else chunk :: chunks_of n remaining

(* Function to create a binary tree from a list of integers *)
let tree_of_list lst =
  Printf.printf "Starting tree_of_list\n"; flush stdout;
  let chunk_size = (List.length lst + 3) / 4 in
  let chunks = chunks_of chunk_size lst in
  Printf.printf "Chunks created\n"; flush stdout;
  let subtrees = List.map (fun chunk ->
    let subtree = ref Empty in
    let pid = Riot.spawn (fun () ->
      try
        List.iter (fun x -> Printf.printf "Processing %d\n" x; flush stdout) chunk;
        subtree := List.fold_left (fun acc x -> insert x acc) Empty chunk;
        Printf.printf "Finished processing chunk\n"; flush stdout;
      with e ->
        Printf.printf "Error in process: %s\n" (Printexc.to_string e); flush stdout;
        raise e
    ) in
    (pid, subtree)
  ) chunks in
  let pids = List.map fst subtrees in
  Printf.printf "Waiting for pids: %d\n" (List.length pids); flush stdout;
  Riot.wait_pids pids;
  Printf.printf "Subtrees created\n"; flush stdout;
  Printf.printf "Finished waiting for pids\n"; flush stdout;
  let subtrees = List.map (fun (_, subtree) -> !subtree) subtrees in
  let result = List.fold_left merge_trees Empty subtrees in
  Printf.printf "Finished merging trees\n"; flush stdout;
  result

(* Get boolean of whether element is in tree *)
let find_element t x =
  Printf.printf "Finding element %d\n" x; flush stdout;
  let findpids = ref [] in
  let found = ref false in
  let rec helper t =
    match t with
    | Empty -> ()
    | Node (a, l, r) ->
        if !found then ()  (* Check if element is already found *)
        else if a = x then found := true
        else
          let left_pid = Riot.spawn (fun () -> helper l) in
          let right_pid = Riot.spawn (fun () -> helper r) in
          findpids := left_pid :: right_pid :: !findpids
  in
  helper t;
  Printf.printf "Waiting for pids: %d\n" (List.length !findpids); flush stdout;
  Riot.wait_pids !findpids;
  !found

let rec print_tree = function
  | Empty -> ()
  | Node (a, l, r) -> 
      Format.printf "%d " a;
      print_tree l;
      print_tree r
  

(* Main/run section *)
let () =
  Riot.run @@ fun () ->
    Printf.printf "Starting main\n"; flush stdout;
    let lst = [5; 3; 8; 1; 4; 7; 10] in
    let tree = tree_of_list lst in
    Printf.printf "Finished tree_of_list\n"; flush stdout;
    let t = insert 5 tree in
    Printf.printf "Finished list insert\n"; flush stdout;
    Format.print_bool (find_element t 5);
    Format.printf "\nPre-order: "; flush stdout;
    print_tree t;
    (* Format.printf "%d " (size t); *)
    Riot.shutdown ()