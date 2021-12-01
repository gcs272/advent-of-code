// scalac Nessie.scala && cat input | scala Nessie
import scala.io.StdIn

object Nessie extends App {
  def satisfies(record: String, seq: Array[Int], rules: Map[Int,String]): Boolean = {
    // If the record and sequence are empty, then it satisfies the rule set
    if (record == "" || seq.length == 0) {
      record == "" && seq.length == 0
    } else {
      rules.get(seq.head) match {
        case None => false
        case Some(rule) => {
          // consider the first rule in the sequence, it can check against a char, expand, or branch
          if (rule == "\"a\"" || rule == "\"b\"") {
            rule.substring(1,2) == record.substring(0,1) && satisfies(record.substring(1), seq.tail, rules)
          } else if (rule.contains(" | ")) {
            val sections = rule.split('|').map(_.trim)
            satisfies(record, sections(0).split(" ").map(Integer.parseInt) ++ seq.tail, rules) ||
              satisfies(record, sections(1).split(" ").map(Integer.parseInt) ++ seq.tail, rules)
          } else {
            satisfies(record, rule.split(" ").map(Integer.parseInt) ++ seq.tail, rules)
          }
        }
      }
    }
  }

  var lines: List[String] = List()
  var line: String = ""
  while ({line = StdIn.readLine(); line != null}) {
    lines = lines.appended(line)
  }

  val sections = lines.mkString("\n").split("\n\n")
  val rules = sections(0).split("\n").foldLeft(Map[Int, String]()) {
    (acc, l) => {
      val p = l.split(": ")
      acc + (Integer.parseInt(p(0)) -> p(1))
    }
  }

  println("answer=" + sections(1).split("\n").filter(rec => satisfies(rec, Array(0), rules)).length)
}
