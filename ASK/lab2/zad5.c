#include <stdio.h>
#include <limits.h>


void print_bits(int x){
	printf("bits for %d\n", x);
	for(int i = 31; i >= 0; i--)
		printf("%d", (x >> i) & 1);
	printf("\n");
}

int less(int xs,int ys){
	return ( (xs != ys) & (~((~((xs >> 31)& 1)) & ((ys >> 31) & 1))) & ( (((xs >> 31)&1)) & (~((ys >> 31) & 1)) |  (((xs >> 31) & 1) & ((ys >> 31) & 1) & (~(((ys - xs)>>31)&1)))  |  ((ys -xs) >> 31) & 1 ^ 1));
}

int main(){
	int x = INT_MAX;/*
	printf("mniejsze? %d, | %d < %d\n",less(x, INT_MIN - x - x), x,INT_MIN - x - x);
	if( (x == INT_MIN) | (x == INT_MAX) | (less(INT_MAX - x - x, x) & (~((x >> 31) & 1))) | (less(x, INT_MIN - x - x) & ((x >> 31) & 1)))
		printf("wyjdzie!!\n");
	else
		printf("its ok.\n");



	if((((x + x) >> 31) & 1) ^ ((x >> 31) & 1) | (((x + x + x) >> 31) & 1) ^ ((x >> 31) & 1))
		printf("wyjdzie2\n");
	else
		printf("its ok2\n");
*/
	x >>= 2;
	x  = x + x + x;


	printf("%d\n", x);
	return 0;
}


