#include <stdio.h>
#include <stdlib.h>

#define MAX 200000
#define N 100000

int main(void)
{
  int i, j;

  j = 0;
  for (i = 0; i < N; ++i)
  {
      printf("%d, ", rand() % MAX);
      ++j;
      if (j == 10) {
	putchar('\n');
	j = 0;
      }
  }
}
