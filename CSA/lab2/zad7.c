#include <stdio.h>
#include <limits.h>
int main(){

	int abs = INT_MIN + 1;
	
	int mask = (abs >> 31);
	printf("%d %d\n", (abs + (abs >> 31)) ^ (abs >> 31), mask);

	return 0;
}
