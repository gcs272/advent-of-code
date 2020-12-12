let print (seats: List<string>) =
  printfn("")
  List.iter (printfn "%s") seats

let occupied (col:int, row:int, seats: List<string>) =
  // find the number of neighbors that exist
  let maxcol = seats.[0].Length - 1
  let maxrow = seats.Length - 1
  let neighbors = [
    (col - 1, row - 1); (col - 1, row); (col - 1, row + 1);
    (col, row - 1); (col, row + 1);
    (col + 1, row - 1); (col + 1, row); (col + 1, row + 1)
  ]

  List.map (fun p ->
    let x, y = p
    match x with
    | -1 -> 0
    | x when x > maxrow -> 0
    | _ ->
      match y with
      | -1 -> 0
      | y when y > maxcol -> 0
      | y when seats.[x].[y] = '#' -> 1
      | _ -> 0
  ) neighbors
  |> List.reduce (+)


let transform(col: int, row: int, seats: List<string>) =
  match seats.[col].[row] with
  | x when x = 'L' && occupied(col, row, seats) = 0 -> '#'
  | x when x = '#' && occupied(col, row, seats) > 3 -> 'L'
  | x -> x


let tick (seats: List<string>) =
  let cols = seats.[0].Length
  let rows = seats.Length
  List.map (fun linenum ->
    List.map (fun seatnum ->
      transform(linenum, seatnum, seats)
    ) [0..cols - 1]
    |> List.map string
    |> List.reduce (+)
  ) [0..rows - 1]

let lines = System.IO.File.ReadLines("input");;
let seats = Seq.toList lines

let rec find (seats: List<string>) =
  let next = tick seats
  if next = seats then next
  else find(next)

let soln = find seats
let occupied =
  List.map (fun line ->
    let chars = Seq.toList(line)
    List.map (fun c ->
      match c with
      | '#' -> 1
      | _ -> 0
    ) chars
    |> List.reduce (+)
  ) soln
  |> List.reduce (+)

printf "%A" occupied
