import std.array;
import std.conv;
import std.format;
import std.stdio;
import std.string;

long mask_int(long val, string mask) {
  char[36] vmut;
  string vbin = val.to!string(2).rightJustify(36, '0');

  foreach (i, v; vmut) {
    if (mask[i] != 'X') {
      vmut[i] = mask[i];
    } else {
      vmut[i] = vbin[i];
    }
  }

  return vmut.to!string().to!long(2);
}

void one() {
  string mask = "";
  long[int] regs;

  foreach (line; stdin.byLine()) {
    if (line[0..4] == "mask") {
      mask = to!string(line[7..$]);
    } else {
      int reg;
      long val;

      line.formattedRead!"mem[%d] = %d"(reg, val);
      regs[reg] = mask_int(val, mask);
    }
  }

  long sum = 0;
  foreach (key, value; regs) {
    sum += value;
  }

  writefln("sum: %d", sum);
}

void two() {
  string mask = "";
  long[long] regs;

  foreach (line; stdin.byLine()) {
    if (line[0..4] == "mask") {
      mask = to!string(line[7..$]);
    } else {
      long val, reg;
      line.formattedRead!"mem[%d] = %d"(reg, val);

      foreach(addr; addresses(reg, cast(char[]) mask)) {
        regs[addr] = val;
      }
    }
  }

  long sum = 0;
  foreach (key, value; regs) {
    sum += value;
  }

  writefln("sum: %d", sum);
}

long[] addresses(long val, char[] mask) {
  if (mask.indexOf('X') == -1) {
    long mv = mask.to!string().to!long(2);
    return [val | mv];
  }

  foreach (i, v; mask) {
    if (v == 'X') {
      char[36] m = mask.dup();
      m[i] = '0';

      return addresses(val, m) ~ addresses(val ^ (2^^(35-i)), m);
    }
  }

  return [];
}

void main() {
  //one();
  two();
}
