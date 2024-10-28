let addone x = x + 1;;

let multimap ls func =
  let ar = (Array.of_list ls) in
    let intermediate a i f =
      a.(i) <- f a.(i) in
      let pids = ref [] in
        for i = 0 to (Array.length ar) - 1 do
          pids := (Riot.spawn (fun () -> intermediate ar i func)) :: !pids
        done;
  let () = Riot.wait_pids !pids in
  Array.to_list ar;;

let multireduce ls =
  let sum = ref 0 in
  let intermediate sum a =
    sum := !sum + a in
  let pids = ref [] in
  for i = 0 to (List.length ls) - 1 do
    pids := (Riot.spawn (fun () -> intermediate sum (List.nth ls i))) :: !pids
  done;
  let () = Riot.wait_pids !pids in
  !sum;;


Riot.run @@ fun () ->
  let ls = [1;2] in
  let newls = multimap ls addone in
  let sum = multireduce ls in
  Format.printf "%d " sum;
  for i = 0 to (List.length newls) - 1 do
    Format.printf "%d " (List.nth newls i);
  done;
  Riot.shutdown ()