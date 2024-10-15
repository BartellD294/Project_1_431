let addone x = x + 1;;
let parallelmap x =
  for i = 0 to Array.length x - 1 do
    Riot.spawn(addone x.(i))
  done;;
  Riot.shutdown();;

let a = [1;2;3;4];;
let b = Riot.run parallelmap a;;
