/* +++Date last modified: 05-Jul-1997 */

/*
**  BITCNTS.C - Test program for bit counting functions
**
**  public domain by Bob Stout & Auke Reitsma
*/

#ifdef DEBUG
#include <stdio.h>
#endif
#include <limits.h>

#define STDOUT_ADDR 0xf0000000
#define EXIT_ADDR 0xff000000

#define FUNCS 7

static char bits[256] =
{
      0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4,  /* 0   - 15  */
      1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,  /* 16  - 31  */
      1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,  /* 32  - 47  */
      2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,  /* 48  - 63  */
      1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,  /* 64  - 79  */
      2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,  /* 80  - 95  */
      2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,  /* 96  - 111 */
      3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,  /* 112 - 127 */
      1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,  /* 128 - 143 */
      2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,  /* 144 - 159 */
      2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,  /* 160 - 175 */
      3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,  /* 176 - 191 */
      2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,  /* 192 - 207 */
      3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,  /* 208 - 223 */
      3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,  /* 224 - 239 */
      4, 5, 5, 6, 5, 6, 6, 7, 5, 6, 6, 7, 6, 7, 7, 8   /* 240 - 255 */
};

void myputchar(const char c);  // print character
int myputs(const char *str);   // print string

int bit_count(long x);
int bitcount(long i);
int ntbl_bitcnt(long x);
int ntbl_bitcount(long int x);
int BW_btbl_bitcount(long int x);
int AR_btbl_bitcount(long int x);
int bit_shifter(long int x);

int main(void)
{
  int i;
  long j, n, seed;
//   int (* pBitCntFunc[FUNCS])(long) = {
//     bit_count,
//     bitcount,
//     ntbl_bitcnt,
//     ntbl_bitcount,
//     /*            btbl_bitcnt, DOESNT WORK*/
//     BW_btbl_bitcount,
//     AR_btbl_bitcount,
//     bit_shifter
//   };

  char *text[FUNCS] = {
    "Optimized 1 bit/loop counter",
    "Ratko's mystery algorithm",
    "Recursive bit count by nybbles",
    "Non-recursive bit count by nybbles",
    /*            "Recursive bit count by bytes",*/
    "Non-recursive bit count by bytes (BW)",
    "Non-recursive bit count by bytes (AR)",
    "Shift and count bits"
  };

  int iterations = 1125000;
  int inputNums[FUNCS] = { 1804289383, 846930886, 1681692777, 1714636915, 1957747793, 424238335, 719885386 };
  int Results[FUNCS] = { 18563087, 17272864, 17116098, 18244704, 18730970, 16962481, 17759895 };

  myputs("Bit counter algorithm benchmark\n");

  for (i = 0; i < FUNCS; i++) {
    myputchar('1' + (char)i);
    myputs(": ");
    myputs(text[i]);
    myputchar('\n');
    n = 0;
    seed = inputNums[i];
    switch(i) {
      case 0:
	for (j = 0; j < iterations; j++, seed += 13)
	  n += bit_count(seed);
	break;
      case 1:
	for (j = 0; j < iterations; j++, seed += 13)
	  n += bitcount(seed);
	break;
      case 2:
	for (j = 0; j < iterations; j++, seed += 13)
	  n += ntbl_bitcnt(seed);
	break;
      case 3:
	for (j = 0; j < iterations; j++, seed += 13)
	  n += ntbl_bitcount(seed);
	break;
      case 4:
	for (j = 0; j < iterations; j++, seed += 13)
	  n += BW_btbl_bitcount(seed);
	break;
      case 5:
	for (j = 0; j < iterations; j++, seed += 13)
	  n += AR_btbl_bitcount(seed);
	break;
      case 6:
	for (j = 0; j < iterations; j++, seed += 13)
	  n += bit_shifter(seed);
	break;
      defaults:
        myputs("ERROR!!\n");
#ifndef DEBUG
	*(volatile int *)(EXIT_ADDR) = 0;
#endif
	return 1;
    }

    if (n == Results[i])
      myputs("CHECK PASSED !!\n");
    else
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

int bit_count(long x)
{
        int n = 0;
/*
** The loop will execute once for each bit of x set, this is in average
** twice as fast as the shift/test method.
*/
        if (x) do
              n++;
        while (0 != (x = x&(x-1))) ;
        return(n);
}

int bitcount(long i)
{
      i = ((i & 0xAAAAAAAAL) >>  1) + (i & 0x55555555L);
      i = ((i & 0xCCCCCCCCL) >>  2) + (i & 0x33333333L);
      i = ((i & 0xF0F0F0F0L) >>  4) + (i & 0x0F0F0F0FL);
      i = ((i & 0xFF00FF00L) >>  8) + (i & 0x00FF00FFL);
      i = ((i & 0xFFFF0000L) >> 16) + (i & 0x0000FFFFL);
      return (int)i;
}

/*
**  Count bits in each nybble
**
**  Note: Only the first 16 table entries are used, the rest could be
**        omitted.
*/

int ntbl_bitcnt(long x)
{
      int cnt = bits[(int)(x & 0x0000000FL)];

      if (0L != (x >>= 4))
            cnt += ntbl_bitcnt(x);

      return cnt;
}

/*
**  Count bits in each nybble
**
**  Note: Only the first 16 table entries are used, the rest could be
**        omitted.
*/

int ntbl_bitcount(long int x)
{
      return
            bits[ (int) (x & 0x0000000FUL)       ] +
            bits[ (int)((x & 0x000000F0UL) >> 4) ] +
            bits[ (int)((x & 0x00000F00UL) >> 8) ] +
            bits[ (int)((x & 0x0000F000UL) >> 12)] +
            bits[ (int)((x & 0x000F0000UL) >> 16)] +
            bits[ (int)((x & 0x00F00000UL) >> 20)] +
            bits[ (int)((x & 0x0F000000UL) >> 24)] +
            bits[ (int)((x & 0xF0000000UL) >> 28)];
}

/*
**  Count bits in each byte
**
**  by Bruce Wedding, works best on Watcom & Borland
*/

int BW_btbl_bitcount(long int x)
{
      union
      {
            unsigned char ch[4];
            long y;
      } U;

      U.y = x;

      return bits[ U.ch[0] ] + bits[ U.ch[1] ] +
             bits[ U.ch[3] ] + bits[ U.ch[2] ];
}

/*
**  Count bits in each byte
**
**  by Auke Reitsma, works best on Microsoft, Symantec, and others
*/

int AR_btbl_bitcount(long int x)
{
      unsigned char * Ptr = (unsigned char *) &x ;
      int Accu ;

      Accu  = bits[ *Ptr++ ];
      Accu += bits[ *Ptr++ ];
      Accu += bits[ *Ptr++ ];
      Accu += bits[ *Ptr ];
      return Accu;
}

int bit_shifter(long int x)
{
  int i, n;
  
  for (i = n = 0; x && (i < (sizeof(long) * CHAR_BIT)); ++i, x >>= 1)
    n += (int)(x & 1L);
  return n;
}
