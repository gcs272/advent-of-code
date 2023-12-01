import simplifile
import gleam/io
import gleam/string
import gleam/list
import gleam/regex
import gleam/int

pub fn main() {
  let assert Ok(contents) = simplifile.read("input")
  let assert Ok(re) = regex.from_string("\\d")

  string.split(string.trim(contents), "\n")
  |> list.map(fn(line) {
    let matches = regex.scan(re, line)
    |> list.map(fn(x) {
      let assert Ok(v) = int.base_parse(x.content, 10)
      v
    })

    let assert [Ok(first), Ok(last)] = [list.first(matches), list.last(matches)]
    first * 10 + last
  })
  |> list.reduce(fn(acc, x) { acc + x })
  |> io.debug
}
