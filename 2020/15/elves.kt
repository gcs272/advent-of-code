// run: kotlinc elves.kt -include-runtime -d elves.jar && java -jar elves.jar
fun game(initial: List<Int>, limit: Int): Int {
  var last = initial.last()
  val numbers = initial.slice(0..initial.size-2).mapIndexed { i, it -> it to i }.toMap().toMutableMap()
  for (i in numbers.size..(limit - 2)) {
    if (last in numbers) {
      val next = i - (numbers[last] ?: 0)
      numbers[last] = i
      last = next
    } else {
      numbers[last] = i
      last = 0
    }
  }
  return last
}

fun main() {
  val initial = listOf(8, 0, 17, 4, 1, 12)
  println("one=" + game(initial, 2020))
  println("two=" + game(initial, 30000000))
}
