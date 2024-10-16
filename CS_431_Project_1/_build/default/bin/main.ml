let addone x = x + 1;;

let intermediate ar i func =
  ar.(i) <- func ar.(i);;

Riot.run @@ fun () ->
  let ar = [|1;2|] in
  for i = 0 to (Array.length ar) - 1 do
    let () = Riot.spawn (fun () -> intermediate ar i addone);
  done;
  for i = 0 to (Array.length ar) - 1 do
    Format.printf "%d " ar.(i);
  done;
  Riot.shutdown ()