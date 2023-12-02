import gleam/io
import gleam/int
import gleam/string
import gleam/list
import simplifile

pub fn parse(line: String) {
  // Break off the game id and results
  let assert ["Game " <> sid, inventory] = string.split(line, ": ")
  let assert Ok(id) = int.base_parse(sid, 10)

  let cubes =
    inventory
    |> string.split("; ")
    |> list.map(fn(game) {
      string.split(game, ", ")
      |> list.map(fn(res) {
        let assert [sval, color] = string.split(res, " ")
        let assert Ok(val) = int.base_parse(sval, 10)

        case color {
          "red" -> #(val, 0, 0)
          "green" -> #(0, val, 0)
          "blue" -> #(0, 0, val)
        }
      })
      |> list.fold(
        #(0, 0, 0),
        fn(acc, res) { #(acc.0 + res.0, acc.1 + res.1, acc.2 + res.2) },
      )
    })

  #(id, cubes)
}

pub fn maximum(picks: List(#(Int, Int, Int))) {
  list.fold(
    picks,
    #(0, 0, 0),
    fn(acc, round) {
      #(
        int.max(acc.0, round.0),
        int.max(acc.1, round.1),
        int.max(acc.2, round.2),
      )
    },
  )
}

pub fn main() {
  let assert Ok(contents) = simplifile.read("input")

  // Part one
  contents
  |> string.trim
  |> string.split("\n")
  |> list.map(parse)
  |> list.filter_map(fn(game) {
    let #(id, picks) = game
    let max = maximum(picks)

    case max.0 <= 12 && max.1 <= 13 && max.2 <= 14 {
      True -> Ok(id)
      False -> Error(0)
    }
  })
  |> list.reduce(fn(acc, x) { acc + x })
  |> io.debug
}
