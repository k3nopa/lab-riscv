#ifdef DEBUG
#include <stdio.h>
#endif

#define STDOUT_ADDR 0xf0000000
#define EXIT_ADDR 0xff000000

#define N_PRIME 40
#define N_NEWLINE 10  // insert newline per 10 number

int getPrimeNumbers(unsigned int a[], int n_max);
void showData(unsigned int a[], int n);
int checkResult(unsigned int a[], unsigned int ans[], int n);

int numTostr(char *s, int n, int base);  // convert number to string.
void myputchar(const char c);  // print character
int myputs(const char *str);   // print string

int main(void)
{
  unsigned int prime_list[N_PRIME];
  int n, f;

  unsigned int prime_list_ans[N_PRIME] =
    {   2,   3,   5,   7,  11,  13,  17,  19,  23, 29,
       31,  37,  41,  43,  47,  53,  59,  61,  67, 71,
       73,  79,  83,  89,  97, 101, 103, 107, 109, 113,
      127, 131, 137, 139, 149, 151, 157, 163, 167, 173 };

  myputs("Program Start !\n");
  myputs("Obtaining Prime Numbers ... \n");
  n = getPrimeNumbers(prime_list, N_PRIME);
  myputs("Complete !!\n");

  //  myputs("\nResult:\n");
  //  showData(prime_list, n);

  f = checkResult(prime_list, prime_list_ans, n);
  if(f == 0) {
    myputs("\nCHECK PASSED !!\n");
  } else if (f == 1){
    myputs("\nCHECK FAILED !!\n");
  } else {
    myputs("\nINVALID ??\n");
  }

#ifndef DEBUG
  *(volatile int *)(EXIT_ADDR) = 0;
#endif
  return 0;

}

int getPrimeNumbers(unsigned int a[], int n_max)
{
  unsigned int i, j, n;

  /** initialize prime_list **/
  a[0] = 2;
  n = 1;

  /** get prime numbers **/
  for (i = 2; n < n_max && i <= 0xffffffff; ++i)
  {
    for (j = 0; j < n; ++j)
    { // check
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
  char str[11];

  j = 0;
  for (i = 0; i < n; ++i)
  {
    numTostr(str, a[i], 10);
    myputs(str);
    myputchar(' ');
    ++j;
    if (j == N_NEWLINE)
    {
      myputchar('\n');
      j = 0;
    }
  }
}

int checkResult(unsigned int a[], unsigned int ans[], int n)
{
  int i;

  for (i = 0; i < n; ++i)
  {
    if (a[i] != ans[i])
      return 1;
  }

  return 0;
}

// convert number to string. return string size
int numTostr(char *s, int n, int base)
{
  int i;
  char tmp;
  char *p = s;

  for (i = base; i <= n; i = i * base)
    ;

  for (i = i / base; i != 0; i = i / base)
  {
    tmp = (char)(n / i);
    n = n % i;
    if (tmp < 10)
    {
      *(p++) = tmp + '0';
    }
    else
    {
      *(p++) = tmp - 10 + 'a';
    }
  }

  *p = '\0';

  return (int)(p - s);
}

void myputchar(const char c)
{
#ifdef DEBUG
  putchar(c);
#else
  *(volatile char *)(STDOUT_ADDR) = c;
#endif
}

int myputs(const char *str)
{
  int i;

  for (i = 0; str[i] != '\0'; ++i)
  {
    myputchar(str[i]);
  }

  return i;
}
