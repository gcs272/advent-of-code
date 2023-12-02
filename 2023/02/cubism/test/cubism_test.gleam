import gleeunit
import gleeunit/should
import cubism

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  1
  |> should.equal(1)
}

pub fn parse_test() {
  cubism.parse("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green")
  |> should.equal(#(1, [#(4, 0, 3), #(1, 2, 6), #(0, 2, 0)]))
}

pub fn maximums_test() {
  cubism.maximum([#(4, 0, 3), #(3, 2, 5), #(1, 1, 1)])
  |> should.equal(#(4, 2, 5))
}
