#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>

__asm__(
		"kekker:;"
			"leaq (%rdi,%rdi,2),%rax;"
			"ret;"
	   );


//B = 8
//A = 8


struct test2{
	int x[5][9];
	long y;
}test2;

struct test{
		char array[5];
		int t;
		short s[9];
		long u;
} test;

// 288

//40i = 280
//i = 7
//CNT = 7
//sizeof(a_str) = 40
// rdx = ap->idx
// sizeof(ap->x = 8)

struct ap{
		long l;
		long id;
		long x[3];
};

//
//2
//i = 2
//int tab[20]i
//tab + 2 * 4 + 4;
//int t;
//40
//2 =40 + 40 + 40 = 120 + 3= 124
//40 + 4 = 44


// rdi /rsi /rdx/ rcx
// R * S * T = 455
// rax = j * j * 2
// rax = j * rax * 4
// j^3*8
// i /= 2^6
// i/2^6 + i + j^3*8 + k)*8 = 455
//
// i += i << 6
// i += rax
// rax += i;
//455
//3j*4 = 12j + j = 13j
//i << 6 + i + 13j + k = 455; 104 + 320 + 5
//R = 7 S = 5 T = 13
//
//1 << 6 + 1 = 65 / 13 = 5
//S = 5
//

void tmp(){
		printf("%d\n", offsetof(struct test2, y));
}

int main(){
		printf("%d\n",sizeof(test));
		printf("%d\n",sizeof(short));
		tmp();
		printf("%ld\n",sizeof(long));	
		return 0;
}
