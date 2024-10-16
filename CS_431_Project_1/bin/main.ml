let addone x = x + 1;;

let multimap ar func =
  let intermediate a i f =
    a.(i) <- f a.(i) in
  let pids = ref [] in
  for i = 0 to (Array.length ar) - 1 do
    pids := (Riot.spawn (fun () -> intermediate ar i func)) :: !pids
  done;
  Riot.wait_pids !pids;;

Riot.run @@ fun () ->
  let ar = [|1;2|] in
  multimap ar addone;
  for i = 0 to (Array.length ar) - 1 do
    Format.printf "%d " ar.(i);
  done;
  Riot.shutdown ()