/* compute napier constant */

#include <stdio.h>

#define RADIX 10000        // !do not change
#define RADIX_POW10 4      // !do not change

#define NUM_DEGITS 2500    // syousuutenn NUM_DIGITS made motomeru
#define N_NEWLINE 5        // insert newline per N_CONMA*10 num

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

#ifdef DEBUG
  if (t != 0)
    printf("overflow\n");
#endif

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
{
  int i, c_nl;
  char str[RADIX_POW10 + 1], *p_str;

  c_nl = 0;
  printf("  int e_ans[WORK] =\n");
  printf("    { %d,\n      ", a[0]);
  for (i = 1; i < WORK - 1; ++i){
    printf("%4d, ", a[i]);
    ++c_nl;

    if (c_nl == N_NEWLINE) {
      printf("\n      ");
      c_nl = 0;
    }
  }
  printf("%4d };\n", a[WORK - 1]);

}
