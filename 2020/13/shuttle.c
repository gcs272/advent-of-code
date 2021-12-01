#include <stdio.h>
#include <string.h>
#include <limits.h>

#define MAXLINE 1024
#define MAXBUSSES 1024

int one() {
  int minute;
  char line[MAXLINE];
  char *token;
  int bus;
  int wait = INT_MAX;

  scanf("%d", &minute);
  scanf("%s", line);

  token = strtok(line, ",");
  while(1) {
    if (*token != 'x') {
      int cbus, cwait;
      sscanf(token, "%d", &cbus);

      cwait = (1 + (minute / cbus)) * cbus - minute;
      if (cwait < wait) {
        bus = cbus;
        wait = cwait;
      }
    }

    // get the next token in line
    token = strtok(NULL, ",");
    if (token == NULL) {
      break;
    }
  }

  return bus * wait;
}

long int two() {
  char line[MAXLINE];
  char *token;
  int delay = 0;
  long int timestamp = 0;
  long int stride = 1;

  scanf("%*d%s", line);

  token = strtok(line, ",");
  while(1) {
    // skip the 'x' records'
    if (*token != 'x') {
      long int cbus;
      sscanf(token, "%ld", &cbus);
      printf("\nreading record: %d\t%ld\t(timestamp=%ld, stride=%ld)", delay, cbus, timestamp, stride);
      fflush(stdout);

      // find the first instance and stride for the
      // accumulated pair and the current bus
      long int next_ts = -1;
      while(1) {
        timestamp = timestamp + stride;
        if (timestamp % cbus == (delay % cbus)) {
          if (next_ts == -1) {
            next_ts = timestamp;
          } else {
            stride = timestamp - next_ts;
            timestamp = next_ts;
            break;
          }
        }
      }
    }

    // get the next token in line
    token = strtok(NULL, ",");
    if (token == NULL) {
      return stride - timestamp;
    }
    delay++;
  }
}

int main() {
  //printf("\npart one=%d", one());
  printf("\npart two=%ld", two());
}
