import java.io.*;
import java.util.*;

public class Calc {
  private static long two(String line) {
    String buf = "";
    int stack = 0;
    List<Long> args = new ArrayList<Long>();
    List<Character> ops = new ArrayList<Character>();

    for (char c : line.replace(" ", "").toCharArray()) {
      if (c == '(') { stack++; }
      if (stack > 0) {
        buf += c;
        if (c == ')') {
          stack--;
          if (stack == 0) {
            args.add(two(buf.substring(1, buf.length() - 1)));
            buf = "";
          }
        }
      } else {
        if (c == '+' || c == '*') { ops.add(c); }
        else if (c != '(' && c != ')') { args.add(Long.parseLong("" + c)); }
      }
    }

    while (ops.contains('+')) {
      int idx = ops.indexOf('+');
      args.add(idx, args.remove(idx) + args.remove(idx));
      ops.remove(idx);
    }

    while (ops.contains('*')) {
      int idx = ops.indexOf('*');
      args.add(idx, args.remove(idx) * args.remove(idx));
      ops.remove(idx);
    }

    return args.remove(0);
  }

  private static long eval(String line) {
    int stack = 0;
    List<Long> args = new ArrayList<Long>();
    String expr = "";
    char op = '+';

    for (char c : line.replace(" ", "").toCharArray()) {
      if (c == '(') {
        stack++;
      }

      if (stack > 0) {
        if (c == ')') {
          stack--;
        }

        if (stack == 0) {
          args.add(eval(expr.substring(1)));
          expr = "";
        } else {
          expr += c;
        }
      } else {
        if (c == '+') {
          op = '+';
        } else if (c == '*') {
          op = '*';
        } else if (c != '(') {
          args.add(Long.parseLong("" + c));
        }
      }

      // if we have two args, apply the op and throw it back as the first arg
      if (args.size() == 2) {
        if (op == '+') {
          args.add(args.remove(0) + args.remove(0));
        } else {
          args.add(args.remove(0) * args.remove(0));
        }
      }
    }

    return args.remove(0);
  }

  public static void main (String[] args) throws IOException {
    BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
    long sum = 0;
    long tsum = 0;
    while (true) {
      String line = br.readLine();
      if (line == null) {
        break;
      } else {
        sum += eval(line);
        tsum += two(line);
      }
    }
    System.out.println("one: " + sum);
    System.out.println("two: " + tsum);
  }
}
