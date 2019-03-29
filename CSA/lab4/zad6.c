#include <stdio.h>

__asm__(
"little_to_big:;"
	"movq $0x0, %rax;"
	"rol $8, %rdi;"
	"movq %rdi, %r8;"
	"movq $0x000000FF000000FF, %r9;"
	"andq %r9, %r8;"
	"orq %r8, %rax;"
	"rol $16, %rdi;"
	"movq %rdi, %r8;"
	"movq $0x0000FF000000FF00, %r9;"
	"andq %r9, %r8;"
	"orq %r8, %rax;"
	"rol $32, %rdi;"
	"movq %rdi, %r8;"
	"movq $0xFF000000FF000000, %r9;"
	"andq %r9, %r8;"
	"orq %r8, %rax;"
	"rol $42, %rdi;"
	"movq $0x00FF000000FF0000, %r9;"
	"andq %r9, %rdi;"
	"orq %rdi, %rax;"
	"ret;"
);

void print_bits(long val){
		for(int i = 63; i >= 0; i--)
				printf("%ld",((val & (1 << i)) >> i));
		printf("\n");
}

//01234567
//76543210 rol $1
//65432107 rol $2
//   X   X
//43210765 rol $4
//  X   X
//07654321 rol $6
//X   X
//21076543
// X   X

int main(){
	long x = 7;
	print_bits(x);
	long res = little_to_big(x);
	print_bits(res);


	return 0;
}
