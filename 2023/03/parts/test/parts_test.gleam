import gleeunit
import gleeunit/should
import parts

pub fn main() {
  gleeunit.main()
}

pub fn symbols_test() {
  let contents = "012..?678\n*123..6!."
  parts.symbols(contents)
  |> should.equal([#(0, 5), #(1, 0), #(1, 7)])
}

pub fn index_of_test() {
  parts.index_of("bc", "abc", 0)
  |> should.equal(Ok(1))

  parts.index_of("br", "abracadabra", 3)
  |> should.equal(Ok(8))
}

pub fn numbers_test() {
  let contents = "467..114..\n...*......\n..35..633."
  parts.numbers(contents)
  |> should.equal([#(114, 0, 5), #(467, 0, 0), #(633, 2, 6), #(35, 2, 2)])
}

pub fn one_test() {
  let numbers = [#(114, 0, 5), #(467, 0, 0), #(633, 2, 6), #(35, 2, 2)]
  let symbols = [#(1, 3)]

  parts.one(numbers, symbols)
  |> should.equal(467 + 35)
}
