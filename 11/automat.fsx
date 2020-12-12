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


let tick (seats: List<string>) =
  let cols = seats.[0].Length
  let rows = seats.Length
  List.map (fun linenum ->
    List.map (fun seatnum ->
      match seats.[linenum].[seatnum] with
      | x when x = 'L' && occupied(linenum, seatnum, seats) = 0 -> '#'
      | x when x = '#' && occupied(linenum, seatnum, seats) > 3 -> 'L'
      | x -> x
    ) [0..cols - 1]
    |> List.map string
    |> List.reduce (+)
  ) [0..rows - 1]

// part one
let lines = System.IO.File.ReadLines("input");;
let seats = Seq.toList lines

let rec find (seats: List<string>) =
  let next = tick seats
  if next = seats then next
  else find(next)

let occupied seats =
  List.map (fun (line) -> Seq.toList(line)) seats 
  |> List.reduce (@)
  |> List.filter (fun (c) -> c = '#')

let soln = find seats
printfn "%A\n" (occupied(soln)).Length

// part two

let rec visible (seats: List<string>, ox, oy, slope) =
  let width = seats.[0].Length - 1
  let height = seats.Length - 1
  let dx, dy = slope
  let x = ox + dx
  let y = oy + dy

  match x with
  | -1 -> 0
  | x when x > height -> 0
  | _ ->
    match y with
    | -1 -> 0
    | y when y > width -> 0
    | y when seats.[x].[y] = 'L' -> 0
    | y when seats.[x].[y] = '#' -> 1
    | _ -> visible(seats, x, y, slope)


let spotted (row: int, col: int, seats: List<string>) =
  let slopes = [(-1, -1); (-1, 0); (-1, 1); (1, 1); (1, 0); (1, -1); (0, 1); (0, -1)]
  List.map (fun (slope) -> visible(seats, row, col, slope)) slopes
  |> List.reduce (+)


let ticker (seats: List<string>) =
  let cols = seats.[0].Length
  let rows = seats.Length
  List.map (fun line ->
    List.map (fun seat ->
      match seats.[line].[seat] with
      | x when x = 'L' && spotted(line, seat, seats) = 0 -> '#'
      | x when x = '#' && spotted(line, seat, seats) > 4 -> 'L'
      | x -> x
    ) [0..cols - 1]
    |> List.map string
    |> List.reduce (+)
  ) [0..rows - 1]

let rec findtwo seats =
  let next = ticker seats
  if next = seats then next
  else findtwo next

let soln2 = findtwo seats
printfn "%A\n" (occupied(soln2)).Length
