#define STDOUT_ADDR 0xf0000000
#define EXIT_ADDR 0xff000000

void myputchar(const char c);  // print character
int myputs(const char *str);   // print string

int main(void)
{
  myputs("Hello World !\n");

#ifndef DEBUG
  *(volatile int *)(EXIT_ADDR) = 0;
#endif
  return 0;
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

  for (i = 0; str[i] != '\0'; ++i) {
      myputchar(str[i]);
  }

  return i;
}
