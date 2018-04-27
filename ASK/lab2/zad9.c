#include <stdio.h>
#include <limits.h>

int main(){
/* */
	int x = INT_MIN+1;
	x ^= x >> 16;
x ^= x >> 8;
	x ^= x >> 4;
	x &= 0xf;
	printf("%d\n", 1^((0x6996 >> x) & 1));
	//0110 1001 1001 0110
	return 0;
}
