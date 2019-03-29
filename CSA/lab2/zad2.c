#include <stdio.h>

int main(){


	int x = 10;
	int y = 20;
	x ^= y;
	y ^= x;
	x ^= y;


	printf("%d %d\n", x, y);
	return 0;
}
