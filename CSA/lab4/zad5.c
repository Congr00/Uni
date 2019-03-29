#include <stdio.h>


long decode2(long x, long y, long z){
	long result;
	y = y - z;
	x = x * y;
	result = y;
	result = result << 63;
	result = result >> 63;
	result = result ^ x;
	return result;
}

int main(){
	


	return 0;
}
