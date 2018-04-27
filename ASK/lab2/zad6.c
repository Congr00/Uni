#include <limits.h>
#include <stdio.h>

int main(){

	unsigned int x = 100;

	unsigned int y = 50;


	int xs = 10;//INT_MAX - INT_MAX - INT_MAX;
	int ys = 100;


	if((((x - y) >> 31) & 1) | (((y - x) >> 31) & 1))
	printf("x jest mniejsze\n");
	else
	printf("x jest wieksze!\n");

	if( (xs != ys) & (~((~((xs >> 31)& 1)) & ((ys >> 31) & 1))) & ( (((xs >> 31)&1)) & (~((ys >> 31) & 1)) |  (((xs >> 31) & 1) & ((ys >> 31) & 1) & (~(((ys - xs)>>31)&1)))  |  ((ys -xs) >> 31) & 1 ^ 1))
	printf("%d jest mniejsze od %d | %d\n",xs,ys, ys - xs);
	else
	printf("%d jest wieksze od %d | %d\n",xs,ys, ys - xs);



//printf("%d\n", ((((xs - ys) >> 31) & 1) | (((ys - xs) >> 31) & 1) | ((~((xs - ys) | (ys - xs))) >> 31) & 1));
	return 0;
}
