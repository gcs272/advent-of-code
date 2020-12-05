import os
import strconv

lines := os.get_lines()
vals := lines.map(strconv.atoi(it))

println("\npart one")
for v in vals {
  soln := vals.filter(it + v == 2020)
  if soln.len > 0 {
    println(v * soln[0])
    break
  }
}

println("\npart two")
for a in vals {
  for b in vals {
    soln := vals.filter(it + a + b == 2020)
    if soln.len > 0 {
      println(a * b * soln[0])
      break
    }
  }
}
