(* Increment function *)
let addone x = x + 1;;

(* Parallel map function *)
let multimap ls func =
  let ar = Array.of_list ls in
  let apply_func a i f = 
    a.(i) <- f a.(i) in
  let pids = ref [] in
  Array.iteri (fun i _ ->
    pids := (Riot.spawn (fun () -> apply_func ar i func)) :: !pids
  ) ar;
  let () = Riot.wait_pids !pids in
  Array.to_list ar;;

(* Parallel fold (sum) function *)
let multifold ls =
  let total_sum = ref 0 in
  let accumulate a = 
    total_sum := !total_sum + a in
  let pids = ref [] in
  List.iter (fun a ->
    pids := (Riot.spawn (fun () -> accumulate a)) :: !pids
  ) ls;
  let () = Riot.wait_pids !pids in
  !total_sum;;

(* Parallel filter function *)
let multifilter pred ls =
  let ar = Array.of_list ls in
  let results = Array.make (Array.length ar) false in
  let apply_pred a i p = 
    results.(i) <- p a.(i) in
  let pids = ref [] in
  Array.iteri (fun i _ ->
    pids := (Riot.spawn (fun () -> apply_pred ar i pred)) :: !pids
  ) ar;
  let () = Riot.wait_pids !pids in
  (* Collect the results based on the results array *)
  let filtered = ref [] in
  List.iteri (fun i _ ->
    if results.(i) then 
      filtered := ar.(i) :: !filtered
  ) ls;
  List.rev !filtered;;

(* Main execution block *)
Riot.run @@ fun () ->
  let ls = [1; 2; 3; 4; 5] in

  (* Test multimap *)
  let newls = multimap ls addone in
  Format.printf "After multimap (addone): ";
  List.iter (fun x -> Format.printf "%d " x) newls;
  Format.printf "\n";

  (* Test multifold *)
  let sum = multifold ls in
  Format.printf "Sum using multifold: %d\n" sum;

  (* Test multifilter *)
  let is_even x = x mod 2 = 0 in
  let filtered_ls = multifilter is_even ls in
  Format.printf "Filtered (even numbers): ";
  List.iter (fun x -> Format.printf "%d " x) filtered_ls;
  Format.printf "\n";

  Riot.shutdown ()
