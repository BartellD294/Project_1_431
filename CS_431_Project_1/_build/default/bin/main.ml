let addone x = x + 1;;

let multimap ar func =
  let intermediate a i f =
    a.(i) <- f a.(i) in
  let pids = ref [] in
  for i = 0 to (Array.length ar) - 1 do
    pids := (Riot.spawn (fun () -> intermediate ar i func)) :: !pids
  done;
  Riot.wait_pids !pids;;

let multireduce ar =
  let sum = ref 0 in
  let intermediate sum a =
    sum := !sum + a in
  let pids = ref [] in
  for i = 0 to (Array.length ar) - 1 do
    pids := (Riot.spawn (fun () -> intermediate sum ar.(i))) :: !pids
  done;
  let () = Riot.wait_pids !pids in
  !sum;;


Riot.run @@ fun () ->
  let ar = [|1;2|] in
  multimap ar addone;
  let sum = multireduce ar in
  Format.printf "%d " sum;
  for i = 0 to (Array.length ar) - 1 do
    Format.printf "%d " ar.(i);
  done;
  Riot.shutdown ()