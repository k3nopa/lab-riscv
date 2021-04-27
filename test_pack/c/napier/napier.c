/* compute pi using Machin's formula */

/*  Machin's formula
  pi = 16 * arctan(1/5) - 4 * arctan(1/239)
*/

#include <stdio.h>

#define RADIX 10000        // !do not change
#define RADIX_POW10 4      // !do not change

#define NUM_DEGITS 1000           // syousuutenn NUM_DIGITS made motomeru
#define N_SPACE 10                // insert space per 10 char
#define N_NEWLINE (N_SPACE * 10)  // insert newline per N_SPACE*10 char

#define WORK ((NUM_DEGITS / RADIX_POW10) + 2)

void init(int a[], int n);
int top(int a[], int p);
void ladd(int a[], int b[], int c[]);  /* a = b + c */
void ldiv(int a[], int b[], int n, int p);  /* a = b/n */
void napier(int e[]);  /* get Napier's constant */
void showData(int a[]);

int main(void)
{
  int e[WORK];

  napier(e);

  /** print result **/
  showData(e);

  return 0;

}

void init(int a[], int n)
{
  int i;

  a[0] = n;
  for (i = 1; i < WORK; ++i)
    a[i] = 0;
}

int top(int a[], int p)
{
  while (p < WORK && a[p] == 0)
    ++p;
  return(p);
}

void ladd(int a[], int b[], int c[]) /* a=b+c */
{
  int t, x, i;

  t = 0;
  for (i = WORK - 1; i >= 0; --i){
    x = b[i] + c[i] + t;
    a[i] = x % RADIX;
    t = x / RADIX;
  }

  if (t != 0)
    fprintf(stderr, "overflow\n");
}

void ldiv(int a[], int b[], int n, int p) /* a=b/n */
{
  int t, x, i;

  t = 0;
  for (i = p; i < WORK; ++i){
    x = t * RADIX + b[i];
    a[i] = x / n;
    t = x % n;
  }
}

void napier(int e[]) /* get Napier's constant */
{
  int a[WORK];
  int p, i;

  //  a: 1/(i!)

  init(e, 2);  // e = 2
  init(a, 1);  // a = 0
  p = 0;
  i = 2;
  while(1) {
    ldiv(a, a, i, p);  // a = a / i
    p = top(a, p);

    if (p == WORK)  // if underflow of a occur
      break;

    ladd(e, e, a);     // e = e + a

    ++i;
  }
}

void showData(int a[])
/*
  1. print seisuu-bu
    printf("%d.", a[0]);
  2. print shyousuu-bu
    print a[1]...a[WORK-2] in "%04d", inserting space(newline) per N_SPACE(N_NEWLINE) charactor.

  Example
   input:
     N_SPACE 5
     N_NEWLINE 10
     a[] = {3, 4, 135, 566, 234, 223, 334, 1345, 893, 13, 9847}

   stdout:
     3.
     00040 13505
     66023 40223
     03341 34508
     93001 39847
*/
{
  int i, c_sp, c_nl;
  char str[5], *p_str;

  /** print seisuu-bu **/
  printf("%d.\n", a[0]);

  /** print shyousuu-bu **/
  c_sp = 0;
  c_nl = 0;
  for (i = 1; i < WORK - 1; ++i){
    sprintf(str, "%04d", a[i]);
    for (p_str = str; *p_str; ++p_str) {
      putchar(*p_str);
      ++c_sp;
      ++c_nl;

      if (c_sp == N_SPACE) {
	putchar(' ');
	c_sp = 0;
      }

      if (c_nl == N_NEWLINE) {
	putchar('\n');
	c_nl = 0;
      }
    }
  }
}
