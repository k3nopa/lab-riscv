/* +++Date last modified: 05-Jul-1997 */

/*
**        A Pratt-Boyer-Moore string search, written by Jerry Coffin
**  sometime or other in 1991.  Removed from original program, and
**  (incorrectly) rewritten for separate, generic use in early 1992.
**  Corrected with help from Thad Smith, late March and early
**  April 1992...hopefully it's correct this time. Revised by Bob Stout.
**
**  This is hereby placed in the Public Domain by its author.
**
**  10/21/93 rdg  Fixed bug found by Jeff Dunlop
*/

#ifdef DEBUG
#include <stdio.h>
#endif

#include <stddef.h>
#include <limits.h>

#ifndef DEBUG
#define STDOUT_ADDR 0xf0000000
#define EXIT_ADDR 0xff000000
#endif

#define N_NEWLINE                          20     // insert newline per 20 number
#define RESULTS_NUM                        7

static size_t table[UCHAR_MAX + 1] = {0};
static size_t len = 0;
static char *findme = NULL;

void myputchar(const char c);  // print character
int myputs(const char *str);   // print string
size_t mystrlen(const char *s);
int mystrncmp(const char *s1, const char *s2, size_t n);
void init_search(const char *string);
int strsearch(const char *string);

int main()
{
      int here;
      char *find_strings[] = {"abb", "you", "not", "it", "dad", "yoo", "hoo", NULL};
      char *search_strings[] = {"cabbie", "your", "It isn't here",
                                "But it is here", "hodad", "yoohoo", "yoohoo" };

      int i;
      int Result_here[RESULTS_NUM] = {  1,  0, -1,  4,  2,  0,  3 };

      for (i = 0; find_strings[i]; i++)
      {
            init_search(find_strings[i]);
	    here = strsearch(search_strings[i]);

	    if (here != Result_here[i]) {
	      myputs("CHECK FAILED !!\n");
#ifdef DEBUG
	      exit(1);
#else
	      *(volatile int *)(EXIT_ADDR) = 0;
#endif
	    }
      }

      if (i == RESULTS_NUM) {
	myputs("CHECK PASSED !!\n");
      } else {
	myputs("CHECK FAILED !!\n");
      }

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

size_t mystrlen(const char *s)
{
  int len = 0;

  while(s[len] != '\0') ++len;

  return len;
}

int mystrncmp(const char *s1, const char *s2, size_t n)
{
  int i = 0;

  while(i < n - 1 && s1[i] == s2[i] && s1[i] != '\0' && s2[i] != '\0') {
    i++;
  }

  if (s1[i] > s2[i]) {
    return 1;
  }

  if (s1[i] < s2[i]) {
    return -1;
  }

  return 0;
}

/*
**  Call this with the string to locate to initialize the table
*/

void init_search(const char *string)
{
      size_t i;

      len = mystrlen(string);
      for (i = 0; i <= UCHAR_MAX; i++)                      /* rdg 10/93 */
            table[i] = len;
      for (i = 0; i < len; i++)
            table[(unsigned char)string[i]] = len - i - 1;
      findme = (char *)string;
}

/*
**  Call this with a buffer to search
*/

//char *strsearch(const char *string)
int strsearch(const char *string)
{
      register size_t shift;
      register size_t pos = len - 1;
      char *here;
      size_t limit=mystrlen(string);

      while (pos < limit)
      {
            while( pos < limit &&
                  (shift = table[(unsigned char)string[pos]]) > 0)
            {
                  pos += shift;
            }
            if (0 == shift)
            {
                  if (0 == mystrncmp(findme,
                        here = (char *)&string[pos-len+1], len))
                  {
		    //                        return(here);
                        return(pos-len+1);
                  }
                  else  pos++;
            }
      }
      //      return NULL;
      return -1;
}
