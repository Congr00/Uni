#include <limits.h>
#include <stdio.h>


int main(){
	int x,y;
	x = INT_MIN;
	y = INT_MIN;
	if(x + y == (unsigned int)y + (unsigned int)x)
	printf("PRAWDA\n");
	else printf("FALSZ!!!\n");
	return 0;
}


//1 x = int MIN
//2 zawsze prawda
//3 INT_MAX/2
//4 zawsze prawda
//5 x = INT_MIN
//6 zawsze prawda
//7 zawsze prawda
