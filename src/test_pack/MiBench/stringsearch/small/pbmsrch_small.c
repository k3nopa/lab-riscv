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
#define RESULTS_NUM                        57

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
      char *find_strings[] = {"abb",  "you", "not", "it", "dad", "yoo", "hoo",
                              "oo", "oh", "xx", "xx", "x", "x", "field", "new", "row",
			      "regime", "boom", "that", "impact", "and", "zoom", "texture",
			      "magnet", "doom", "loom", "freq", "current", "phase",
			      "images", 
			      "appears", "phase", "conductor", "wavez", 
			      "normal", "free", "termed",
			      "provide", "for", "and", "struct", "about", "have",
			      "proper",
			      "involve",
			      "describedly",
			      "thats",
			      "spaces",
			      "circumstance",
			      "the",
			      "member",
			      "such",
			      "guide",
			      "regard",
			      "officers",
			      "implement",
			      "principalities",			      
			      NULL};
      char *search_strings[] = {"cabbie", "your", "It isn't here",
                                "But it is here", "hodad", "yoohoo", "yoohoo",
                                "yoohoo", "yoohoo", "yoohoo", "xx", "x", ".", 
				"In recent years, the field of photonic ",
				"crystals has found new",
				"applications in the RF and microwave",
				"regime. A new type of metallic",
				"electromagnetic crystal has been", 
				"developed that is having a",
				"significant impact on the field of", 
				"antennas. It consists of a",
				"conductive surface, covered with a",
				"special texture which alters its",
				"electromagnetic properties. Made of solid",
				"metal, the structure",
				"conducts DC currents, but over a",
				"particular frequency range it does",
				"not conduct AC currents. It does not",
				"reverse the phase of reflected",
				"waves, and the effective image currents",

				"appear in-phase, rather than",
				"out-of-phase as they are on normal",
				"conductors. Furthermore, surface",
				"waves do not propagate, and instead",
				"radiate efficiently into free",
				"space. This new material, termed a",
				"high-impedance surface, provides",
				"a useful new ground plane for novel",
				"low-profile antennas and other",
				"electromagnetic structures.",
				"The recent protests about the Michigamua",
				"student organization have raised an",
				"important question as to the proper nature",
				"and scope of University involvement",
				"with student organizations. Accordingly",
				"the panel described in my Statement of",
				"February 25, 2000 that is considering the",
				"question of privileged space also will",
				"consider under what circumstances and in", 
				"what ways the University, its",
				"administrators and faculty members should",
				"be associated with such organizations",
				"and it will recommend guiding principles",
				"in this regard. The University's",
				"Executive Officers and I will then decide",
				"whether and how to implement such",
				"principles."			       
      };

      int i;
      int Result_here[RESULTS_NUM] =
	{  1,  0, -1,  4,  2,  0,  3,  1,  2, -1,  0,  0, -1, 21, 19, 30,  0, -1, 10, 12,
	  -1, -1,  8,  7, -1, -1, 11, 15, 12, -1, -1,  7,  0, -1, -1, -1, -1, -1, -1, -1,
	  -1, -1, -1, -1, -1, -1, -1, -1, 20, 10, 27, 19, -1,  8, -1, 19, -1 };

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
