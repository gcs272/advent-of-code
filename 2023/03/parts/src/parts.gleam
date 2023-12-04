import gleam/io
import gleam/string
import gleam/list
import gleam/result
import gleam/regex
import gleam/int
import simplifile

pub fn symbols(content: String) {
  let assert Ok(symre) = regex.from_string("[^0-9.]")

  string.split(content, "\n")
  |> list.index_map(fn(y, line) {
    string.to_graphemes(line)
    |> list.index_map(fn(x, c) {
      case regex.check(symre, c) {
        True -> Ok(#(y, x))
        False -> Error(#(y, x))
      }
    })
    |> result.values
  })
  |> list.flatten
}

pub fn index_of(
  needle: String,
  haystack: String,
  offset: Int,
) -> Result(Int, Int) {
  let sliced = string.slice(haystack, offset, string.length(haystack) - offset)
  let [before, ..] = string.split(sliced, needle)
  Ok(string.length(before) + offset)
}

pub fn numbers(content: String) {
  let assert Ok(digitre) = regex.from_string("[0-9]+")

  string.split(content, "\n")
  |> list.index_map(fn(y, line) {
    // Convert the line into part numbers
    regex.scan(digitre, line)
    |> list.fold(
      #(0, []),
      fn(acc, match) {
        let assert Ok(pos) = index_of(match.content, line, acc.0)
        let assert Ok(num) = int.parse(match.content)

        #(pos + string.length(match.content), [#(num, y, pos), ..acc.1])
      },
    )
    |> fn(res: #(Int, List(#(Int, Int, Int)))) { res.1 }
  })
  |> list.flatten
}

pub fn one(numbers: List(#(Int, Int, Int)), symbols: List(#(Int, Int))) {
  numbers
  |> list.filter(fn(n) {
    let y = #(n.1 - 1, n.1 + 1)
    let x = #(n.2 - 1, n.2 + string.length(int.to_string(n.0)))

    list.any(
      symbols,
      fn(s) { y.0 <= s.0 && s.0 <= y.1 && x.0 <= s.1 && s.1 <= x.1 },
    )
  })
  |> list.map(fn(x) { x.0 })
  |> list.fold(0, fn(acc, x) { acc + x })
}

pub fn main() {
  let assert Ok(contents) = simplifile.read("input")

  one(numbers(contents), symbols(contents))
  |> io.debug
}
