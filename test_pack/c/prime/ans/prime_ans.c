#include <stdio.h>

#define N_PRIME 2200
#define N_NEWLINE 5   // insert newline per 5 number

int getPrimeNumbers(unsigned int a[], int n_max);
void showData(unsigned int a[], int n);

int main(void)
{
  unsigned int prime_list[N_PRIME];
  int n;

  n = getPrimeNumbers(prime_list, N_PRIME);

  showData(prime_list, n);

  return 0;
}

int getPrimeNumbers(unsigned int a[], int n_max)
{
  unsigned int i, j, n;

  /** initialize prime_list **/
  a[0] = 2;
  n = 1;

  /** get prime numbers **/
  for (i = 2; n < n_max && i <= 0xffffffff; ++i) {
    for (j = 0; j < n; ++j) {  // check
      if (i % a[j] == 0)
	break;
    }

    if (j == n)
      a[n++] = i;
  }

  return n;

}

void showData(unsigned int a[], int n)
{
  int i, j;

  j = 0;
  printf("  unsigned int prime_list_ans[N_PRIME] =\n");
  printf("    { ");
  for (i = 0; i < n - 1; ++i) {
    printf("%d, ", a[i]);
    ++j;
    if (j == N_NEWLINE) {
      printf("\n      ");
      j = 0;
    }
  }
  printf("%d };\n", a[n - 1]);
}
