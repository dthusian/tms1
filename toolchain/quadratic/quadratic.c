#include<stdio.h>
#include<stdlib.h>
#include<math.h>

int _read(int fd, char* ptr, int len);
int _write(int fd, char* ptr, int len);

int readchar() {
  char c;
  _read(0, &c, 1);
  return c;
}

char* budget_fgets(char* buf, int, FILE*) {
  char c = readchar();
  while(c != '\n') {
    *(buf++) = c;
    c = readchar();
  }
}

void main() {
  char buf[105];
  double a, b, c;
  printf("hello world!\n");

  printf("a: ");
  fgets(buf, 100, stdin);
  a = strtod(buf, NULL);

  printf("b: ");
  fgets(buf, 100, stdin);
  b = strtod(buf, NULL);

  printf("c: ");
  fgets(buf, 100, stdin);
  c = strtod(buf, NULL);

  double discrim = b * b - 4 * a * c;
  double two_a = 2 * a;
  if(discrim < 0) {
    printf("no solutions\n");
  } else if(discrim == 0) {
    double s = -b / two_a;
    printf("solution: %d\n", s);
  } else if(discrim > 0) {
    double sqrt_discrim = sqrt(discrim);
    double s1 = (-b + sqrt_discrim) / two_a;
    double s2 = (-b - sqrt_discrim) / two_a;
    printf("solution 1: %d\n", s1);
    printf("solution 2: %d\n", s2);
  }
}