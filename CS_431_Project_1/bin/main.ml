let addone x = x + 1;;

let intermediate x i func =
  x.(i) <- func x.(i);;

let parallelmap (arr, func) =
  let pids = [] in
  let results = Array.make (Array.length arr) 0 in
    for i = 0 to Array.length arr - 1 do
      let pids = Riot.spawn (fun () -> intermediate arr i func)
    done;
  Riot.shutdown();
  results;;

let a = [|1;2;3;4|];;
let b = Riot.run parallelmap (a, addone);;
b;;