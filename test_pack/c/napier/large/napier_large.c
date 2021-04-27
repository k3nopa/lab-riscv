/* compute Napier's constant */

#ifdef DEBUG
#include <stdio.h>
#endif

#define STDOUT_ADDR 0xf0000000
#define EXIT_ADDR 0xff000000

#define RADIX 10000        // !do not change
#define RADIX_POW10 4      // !do not change

#define NUM_DEGITS 2500           // syousuutenn NUM_DIGITS made motomeru
#define N_SPACE 10                // insert space per 10 char
#define N_NEWLINE (N_SPACE * 10)  // insert newline per N_SPACE*10 char

#define WORK ((NUM_DEGITS / RADIX_POW10) + 2)

int numTostr(char *s, int n, int base);  // convert number to string.
void myputchar(const char c);  // print character
int myputs(const char *str);   // print string

void init(int a[], int n);
int top(int a[], int p);
void ladd(int a[], int b[], int c[]);  /* a = b + c */
void ldiv(int a[], int b[], int n, int p);  /* a = b/n */
void napier(int e[]);  /* get Napier's constant */
void showData(int a[]);
int checkResult(int a[], int ans[]);

int main(void)
{
  int e[WORK];
  int f;
  int e_ans[WORK] =
    { 2,
      7182, 8182, 8459,  452, 3536, 
       287, 4713, 5266, 2497, 7572, 
      4709, 3699, 9595, 7496, 6967, 
      6277, 2407, 6630, 3535, 4759, 
      4571, 3821, 7852, 5166, 4274, 
      2746, 6391, 9320,  305, 9921, 
      8174, 1359, 6629,  435, 7290, 
       334, 2952, 6059, 5630, 7381, 
      3232, 8627, 9434, 9076, 3233, 
      8298, 8075, 3195, 2510, 1901, 
      1573, 8341, 8793,  702, 1540, 
      8914, 9934, 8841, 6750, 9244, 
      7614, 6066, 8082, 2648,   16, 
      8477, 4118, 5374, 2345, 4424, 
      3710, 7539,  777, 4499, 2069, 
      5517,  276, 1838, 6062, 6133, 
      1384, 5830,   75, 2044, 9338, 
      2656,  297, 6067, 3711, 3200, 
      7093, 2870, 9127, 4437, 4704, 
      7230, 6969, 7720, 9310, 1416, 
      9283, 6819,  255, 1510, 8657, 
      4637, 7211, 1252, 3897, 8442, 
      5056, 9536, 9677,  785, 4499, 
      6996, 7946, 8644, 5490, 5987, 
      9316, 3688, 9230,  987, 9312, 
      7736, 1782, 1542, 4999, 2295, 
      7635, 1482, 2082, 6989, 5193, 
      6680, 3318, 2528, 8693, 9849, 
      6465, 1058, 2093, 9239, 8294, 
      8879, 3320, 3625,  944, 3117, 
      3012, 3819, 7068, 4161, 4039, 
      7019, 8376, 7932,  683, 2823, 
      7646, 4804, 2953, 1180, 2328, 
      7825,  981, 9455, 8153,  175, 
      6717, 3613, 3206, 9811, 2509, 
      9618, 1881, 5930, 4169,  351, 
      5988, 8851, 9345, 8072, 7386, 
      6738, 5894, 2287, 9228, 4998, 
      9208, 6805, 8257, 4927, 9610, 
      4841, 9844, 4363, 4632, 4496, 
      8487, 5602, 3362, 4827,  419, 
      7862, 3209,   21, 6099,  235, 
      3043, 6994, 1849, 1463, 1409, 
      3431, 7381, 4364,  546, 2531, 
      5209, 6183, 6908, 8870, 7016, 
      7683, 9642, 4378, 1405, 9271, 
      4563, 5490, 6130, 3107, 2085, 
      1038, 3750, 5101, 1574, 7704, 
      1718, 9861,  687, 3969, 6552, 
      1267, 1546, 8895, 7035,  354, 
       212, 3407, 8498, 1933, 4321, 
       681, 7012, 1005, 6278, 8023, 
      5193,  332, 2474, 5015, 8539, 
       473,  419, 9577, 7709, 3503, 
      6604, 1699, 7329, 7250, 8868, 
      7696, 6403, 5557,  716, 2268, 
      4471, 6256,  798, 8265, 1787, 
      1341, 9512, 4665, 2010, 3059, 
      2123, 6677, 1943, 2527, 8675, 
      3985, 5894, 4896, 9709, 6409, 
      7545, 9185, 6956, 3802, 3637, 
       162, 1120, 4774, 2722, 8364, 
      8961, 3422, 5164, 4507, 8182, 
      4423, 5294, 8636, 3721, 4174, 
       238, 8934, 4124, 7963, 5743, 
      7026, 3755, 2944, 4833, 7998, 
       161, 2549, 2278, 5092, 5778, 
      2562,  926, 2264, 8326, 2779, 
      3338, 6566, 4816, 2772, 5164, 
       191,  590,  491, 6449, 9828, 
      9315,  566,  472, 5802, 7786, 
      3186, 4155, 1956, 5324, 4258, 
      6982, 9469, 5930, 8019, 1529, 
      8721, 1725, 5634, 7546, 3964, 
      4791,  145, 9040, 9058, 6298, 
      4967, 9128, 7406, 8705,  489, 
      5858, 6717, 4798, 5466, 7757, 
      5732,  568, 1288, 4592,  541, 
      3340, 5392, 2000, 1137, 8630, 
       945, 5606, 8816, 6740,  169, 
      8420, 5580, 4033, 6379, 5376, 
      4520, 3040, 2432, 2566, 1352, 
      7836, 9511, 7788, 3863, 8744, 
      3966, 2532, 2498, 5065, 4995, 
      8862, 3428, 1899, 7077, 3327, 
      6171, 7839, 2803, 4946, 5014, 
      3455, 8897,  719, 4258, 6398, 
      7727, 5471,  962, 9537, 4152, 
      1115, 1368, 3506, 2752, 6023, 
      2648, 4728, 7039, 2076, 4310, 
       595, 8411, 6612,  545, 2970, 
      3023, 6472, 5492, 9666, 9381, 
      1513, 7322, 7536, 4509, 8889, 
       313, 6020, 5724, 8176, 5851, 
      1806, 3036, 4428, 1231, 4965, 
      5070, 4751,  254, 4650, 1172, 
      7211, 5551, 9486, 6850, 8003, 
      6853, 2281, 8315, 2196,   37, 
      3562, 5279, 4495, 1582, 8418, 
      8294, 7876, 1085, 2639, 8139, 
      5599,   67, 3764, 8292, 2443, 
      7528, 7184, 6245, 7803, 6192, 
      9819, 7139, 9147, 5644, 8826, 
      2603, 9033, 8144, 1823, 2625, 
      1509, 7482, 7987, 7799, 6437, 
      3089, 9703, 8886, 7782, 2713, 
      8360, 5772, 9788, 2412, 5611, 
      9071, 7663, 9465,  706, 3304, 
      5279, 5466, 1855,  966, 6618, 
      5664, 7097, 1134, 4474,  160, 
      7046, 2621, 5680, 7174, 8187, 
      7844, 3714, 3698, 8218, 5596, 
      7095, 9102, 5968, 6200, 2353, 
      7185, 8874, 8569, 6522,    5, 
       311, 7343, 9207, 3211, 3908, 
       329, 3634, 4797, 2735, 5955, 
      2773, 4907, 1783, 7934, 2163, 
      7012,  500, 5451, 3263, 8354, 
      4000, 1863, 2399, 1490, 7054, 
      7977, 8056, 6978, 5335, 8048, 
      9669,  629, 5119, 4324, 7309, 
      9587, 6552, 3681, 2859,  413, 
      8324, 1160, 7226,  299, 8330, 
      5353, 7087, 6138, 9396, 3917, 
      7957, 4540, 1613, 7223, 6187, 
      8444 };

  myputs("Program Start !\n");
  myputs("Calculating Napier's constant ... \n");

  napier(e);

  myputs("Complete !!\n");

  /** print result **/
  //  myputs("\nResult:\n");
  //  showData(e);

  f = checkResult(e, e_ans);
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

// convert number to string. return string size
int numTostr(char *s, int n, int base)
{
  int i;
  char tmp;
  char *p = s;

  for (i = base; i <= n; i = i * base);

  for (i = i / base; i != 0; i = i / base) {
    tmp = (char)(n / i);
    n = n % i;
    if (tmp < 10) {
      *(p++) = tmp + '0';
    } else {
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

  for (i = 0; str[i] != '\0'; ++i) {
    myputchar(str[i]);
  }

  return i;
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
    t = x / RADIX;
    a[i] = x % RADIX;
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
  char *p_str, str_real[2 * RADIX_POW10];
  char *str = &str_real[RADIX_POW10 - 1];

  for (i = 0; i < RADIX_POW10 - 1; i++) {
    str_real[i] = '0';
  }
  str_real[i] = '\0';

  /** print seisuu-bu **/
  numTostr(str, a[0], 10);
  myputs(str);
  myputchar('.');
  myputchar('\n');

  /** print shyousuu-bu **/
  c_sp = 0;
  c_nl = 0;
  for (i = 1; i < WORK - 1; ++i){
    for (p_str = str - RADIX_POW10 + numTostr(str, a[i], 10); *p_str; ++p_str) {
      myputchar(*p_str);
      ++c_sp;
      ++c_nl;

      if (c_sp == N_SPACE) {
	myputchar(' ');
	c_sp = 0;
      }

      if (c_nl == N_NEWLINE) {
	myputchar('\n');
	c_nl = 0;
      }
    }
  }
}

int checkResult(int a[], int ans[])
{
  int i;

  for (i = 0; i < WORK; ++i) {
    if (a[i] != ans[i])
      return 1;
  }

  return 0;
}
