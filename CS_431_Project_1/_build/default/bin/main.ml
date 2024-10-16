let addone x = x + 1;;

let intermediate ar i func =
  ar.(i) <- func ar.(i);;

Riot.run @@ fun () ->
  let ar = [|1;2|] in
  let pids = ref [] in
  for i = 0 to (Array.length ar) - 1 do
    pids := (Riot.spawn (fun () -> intermediate ar i addone)) :: !pids
  done;
  Riot.wait_pids !pids;
  for i = 0 to (Array.length ar) - 1 do
    Format.printf "%d " ar.(i);
  done;
  Riot.shutdown ()