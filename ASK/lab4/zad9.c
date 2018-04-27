#include <stdio.h>
#include <limits.h>

/*
__ass__{
	"movq %rdi, %r8;"
	"movq %rsi, %r9;"
	"movq $0x8000000000000000, $r10;"
	"sarq $63, %r10;"
	"andq %r10, %r8;"
	"andq %r10, %r9;"
	"xorq %r8,%r9;"
	"notq %r9;"
	"addq %rsi, %rdi;"
	"movq %rdi, %r11;"
	"andq %r10, %r11;"
	"movq %r11, %r10;" // r10 - znak po dodaniu
	"xorq %r8, %r10;"
	"andq %r9, %r11;"
	// %r11 1 gdy overflow 0 wpp
	"movq %r10, %r8;" //S minus ? LONG_MAX : LONG_MIN
	"ror $1, %r10;"   //sarq???	
	"sarq $63, %r10;"
	"notq %r8;"
	"ror $1, %r8;"
	"sarq $63, %r8";
	"andq $0x7FFFFFFFFFFFFFFF, $r10;"
	"andq $0x8000000000000000, $r8;"
	"addq %r10,%r8;" // MIN gdy S == 0, MAX wpp
	"movq %r11,%r10;" // czy jest over ? S : x + y
	"notq %r10;"
	"ror $1, %r11;"
	"sarq $63,%r11;"
	"andq %r8,%r11;"
	"ror $1, %r10;"
	"sarq $63, %r11;"
	"andq %rdi, %r10;"
	"addq %r10,%r11;"
	"movq %r11,%rax;"
	"ret;"
}

*/


		
		__asm__("tmp:;"
				"sarq $2, %rdi;"
				"movq %rdi, %rax;"
				"ret;"
			   );


int main(){
		long t = tmp(-1);
		printf("%ld", t);
		return 0;
}
