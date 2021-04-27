FILE0 = bmhasrch.c  bmhisrch.c  bmhsrch.c  pbmsrch_test.c 
FILE1 = bmhasrch.c  bmhisrch.c  bmhsrch.c  pbmsrch_small.c 
FILE2 = bmhasrch.c  bmhisrch.c  bmhsrch.c  pbmsrch_large.c 

all: search_test search_small search_large

search_test: ${FILE0} Makefile
	gcc -static ${FILE0} -O3 -o search_test

search_small: ${FILE1} Makefile
	gcc -static ${FILE1} -O3 -o search_small

search_large: ${FILE2} Makefile
	gcc -static ${FILE2} -O3 -o search_large

clean:
	rm -rf search_test search_small search_large output*
