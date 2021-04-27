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

#include <stddef.h>
#include <string.h>
#include <limits.h>

#define N_NEWLINE                          20     // insert newline per 20 number
#define MAX_RESULTS                        10000  // space for Result_here. set large enough

static size_t table[UCHAR_MAX + 1];
static size_t len;
static char *findme;

/*
**  Call this with the string to locate to initialize the table
*/

void init_search(const char *string)
{
      size_t i;

      len = strlen(string);
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
      size_t limit=strlen(string);

      while (pos < limit)
      {
            while( pos < limit &&
                  (shift = table[(unsigned char)string[pos]]) > 0)
            {
                  pos += shift;
            }
            if (0 == shift)
            {
                  if (0 == strncmp(findme,
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

#include <stdio.h>

void showResult(char *name, int a[], int n)
{
  int i, j;

  printf("#define RESULTS_NUM %d\n", n);

  j = 0;
  printf("  int %s[RESULTS_NUM] =\n", name);
  printf("    { ");
  for (i = 0; i < n - 1; ++i) {
    printf("%2d, ", a[i]);
    ++j;
    if (j == N_NEWLINE) {
      printf("\n      ");
      j = 0;
    }
  }
  printf("%2d };\n", a[n - 1]);
}

main()
{
  //      char *here;
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
      int Result_here[MAX_RESULTS];

      for (i = 0; find_strings[i]; i++)
      {
            init_search(find_strings[i]);
	    Result_here[i] = here = strsearch(search_strings[i]);
	    /** original print code (can't use) **/
	    //            printf("\"%s\" is%s in \"%s\"", find_strings[i],
	    //                  here ? "" : " not", search_strings[i]);
	    //            if (here)
	    //                  printf(" [\"%s\"]", here);
	    //            putchar('\n');
            /***************/

	    //	    printf("\"%s\" is%s in \"%s\"", find_strings[i],
	    //		   here != -1 ? "" : " not", search_strings[i]);
	    //	    if (here != -1)
	    //	      printf(" [\"%s\"]", &search_strings[i][here]);
	    //            putchar('\n');

      }

      showResult("Result_here", Result_here, i);

      return 0;
}

