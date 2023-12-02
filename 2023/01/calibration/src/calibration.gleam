import simplifile
import gleam/io
import gleam/string
import gleam/list
import gleam/regex

pub fn parse(line: String) -> Int {
  let assert Ok(pat) = regex.from_string("[0-9]|one|two|three|four|five|six|seven|eight|nine")

  let to_digit = fn(s: String) -> Int {
    case s {
      "1" | "one" -> 1
      "2" | "two" -> 2
      "3" | "three" -> 3
      "4" | "four" -> 4
      "5" | "five" -> 5
      "6" | "six" -> 6
      "7" | "seven" -> 7
      "8" | "eight" -> 8
      "9" | "nine" -> 9
      _ -> 0
    }
  }

  // Forward
  let first =
    string.to_graphemes(line)
    |> list.fold_until(
      "",
      fn(acc, c) {
        let buf = acc <> c
        case regex.scan(pat, buf) {
          [match] -> list.Stop(match.content)
          _ -> list.Continue(buf)
        }
      },
    )
    |> to_digit

  // Backwards
  let second =
    string.to_graphemes(line)
    |> list.reverse
    |> list.fold_until(
      "",
      fn(acc, c) {
        let buf = c <> acc
        case regex.scan(pat, buf) {
          [match] -> list.Stop(match.content)
          _ -> list.Continue(buf)
        }
      },
    )
    |> to_digit

  first * 10 + second
}

pub fn main() {
  let assert Ok(contents) = simplifile.read("input")

  contents
  |> string.trim
  |> string.split("\n")
  |> list.map(parse)
  |> list.reduce(fn(acc, x) { acc + x })
  |> io.debug
}
