#include <stdio.h>
#include <limits.h>

int main(){

	int x,y,s;

	x = INT_MIN;
	y = -10;

	s = x + y;

	int tmp = (x >> 31) & 1;

		if((   ~((s >> 31) & 1) & ( ( (x >> 31) & 1) & ( (y >> 31) & 1)))
	| ((s >> 31) & 1) & ((~((x >> 31) & 1) & ~((y >> 31) & 1))))
	printf("WYKRACZA\n");
else
printf("NIE! %d %d\n", s,tmp);
	return 0;
}
