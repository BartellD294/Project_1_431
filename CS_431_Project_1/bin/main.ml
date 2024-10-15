let addone x = x + 1;;
let parallelmap (x, func) =
  let promises = Array.map (fun v -> Riot.spawn (fun () -> func v)) x in
  let results = Array.map Riot.join promises in
  Riot.shutdown();
  results;;

let a = [|1;2;3;4|];;
let b = Riot.run parallelmap (a, addone);;
b;;