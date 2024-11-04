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
              sizepids := Riot.spawn (fun () -> helper l)::!sizepids;
              sizepids := Riot.spawn (fun () -> helper r)::!sizepids in

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

(* Function to create a binary tree from a list of integers *)
let tree_of_list lst =
    let tree = ref Empty in
    let treelistpids = ref [] in
    List.iter (fun x ->
      treelistpids := (Riot.spawn (fun () -> tree := insert x !tree)) :: !treelistpids
    ) lst;
    Riot.wait_pids !treelistpids;
    !tree;;

(* Get boolean of whether element is in tree *)
let find_element t x=
  let findpids = ref [] in
    let found = ref false in
    let rec helper t=
      match t with
      | Empty -> ()
      | Node (a, l, r) -> if a == x then found:= true;
              findpids := Riot.spawn (fun () -> helper l)::!findpids;
              findpids := Riot.spawn (fun () -> helper r)::!findpids in

    helper t;
    Riot.wait_pids !findpids;
    !found;;
  

(* Main/run section *)
let () =
    Riot.run @@ fun () ->
      let lst = [5; 3; 8; 1; 4; 7; 10] in
      let tree = tree_of_list lst in
      let t = insert 5 tree in
      Format.print_bool (find_element t 5);
      (*Format.printf "%d " (size t);*)
      Riot.shutdown ();;