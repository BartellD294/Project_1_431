let addone x = x + 1;;

let intermediate x i func =
  x.(i) <- func x.(i);;

let parallelmap (ar, func) =
  let ar2 = Array.copy ar in
  let pid = Riot.spawn (fun () -> intermediate ar2 0 func) in
  Riot.wait_pids [pid];
  Riot.shutdown();
  ar2;;

let a = [|1;2;3;4|];;
let b = Riot.run parallelmap (a, addone);;
b;;

Riot.run @@ fun () ->
  let parallelmap (ar, func) =
    let ar2 = Array.copy ar in
    let pid = Riot.spawn (fun () -> intermediate ar2 0 func) in
    Riot.wait_pids [pid];
    Riot.shutdown();
    ar2;;
  let pid = spawn (fun () -> Format.printf "Hello, %a!" Pid.pp (self ())) in
  wait_pids [ pid ];
  shutdown ()