import gleeunit
import calibration
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn parse_test() {
  calibration.parse("eightwothree")
  |> should.equal(83)

  calibration.parse("hczsqfour3nxm5seven4")
  |> should.equal(44)

  calibration.parse("two1nine\neightwothree")
  |> should.equal(23)

  calibration.parse("3twone")
  |> should.equal(31)
}
