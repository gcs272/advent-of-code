#include <stdio.h>
#include <string.h>
#include <limits.h>

#define MAXLINE 1024

int main() {
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

  printf("bus %d arrives in %d minutes, answer=%d", bus, wait, bus * wait);
  return 0;
}
