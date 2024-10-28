(* Project 2 - Multiprocessing Tree *)

open Riot

(* Defining a binary tree *)
type tree =
  | Empty
  | Node of int * tree * tree

(* Function to insert an element into the binary tree *)
let rec insert x = function
  | Empty -> Node(x, Empty, Empty)
  | Node(v, left, right) ->
      if x < v then
        Node(v, insert x left, right)
      else
        Node(v, left, insert x right)

(* Function to create a binary tree from a list of integers *)
let tree_of_list lst =
    let tree = ref Empty in
    let pids = ref [] in
    List.iter (fun x ->
      pids := (Riot.spawn (fun () -> tree := insert x !tree)) :: !pids
    ) lst;
    Riot.wait_pids !pids;
    !tree


let () =
    Riot.run @@ fun () ->
      let lst = [5; 3; 8; 1; 4; 7; 10] in
      let tree = tree_of_list lst in
      (* You can add code here to print or manipulate the tree *)
      Riot.shutdown ()