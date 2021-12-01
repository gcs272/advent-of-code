import strscans

type Record = tuple
  min: int
  max: int
  c: char
  password: string


iterator readRecords(path: string): Record =
  for line in lines(path):
    var minlen, maxlen: int
    var c, pass: string

    if strscans.scanf(line, "$i-$i $w: $+", minlen, maxlen, c, pass):
      yield (min: minlen, max: maxlen, c: c[0], password: pass)


var valid: int
for rec in readRecords("day2.input"):
  var matched: int
  for letter in rec.password:
    if letter == rec.c:
      matched += 1
  if matched >= rec.min and matched <= rec.max:
    valid += 1

echo "part one: ", valid

valid = 0
for rec in readRecords("day2.input"):
  if rec.password[rec.min - 1] == rec.c xor rec.password[rec.max - 1] == rec.c:
    valid += 1

echo "part two: ", valid
