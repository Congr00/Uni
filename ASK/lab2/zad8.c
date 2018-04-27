#include <stdio.h>

int main(){

	int x = -100;
	printf("%d\n", (x != 0) | (x >> 31));
	return 0;
}
