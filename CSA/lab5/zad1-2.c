#include <stdio.h>

int puzzle(long x, unsigned n){
// puzzle	
		if(n == 0)
				return n;
		long res = 0;
		int i;
		for(i = 0; i != n; i++){
				res += (x & 1);
				x >>= 1;
		}

		return 0;
		
// L3
}


long puzzle2(char* s, char* d){
	char* res = s;
	while(1){
		char s_byte = *(res);
		for(char*i = d; *(i) != s_byte; i++){
			
			if(*(i) == 0){
				res -= s;
				return (long)res;
			}
		}
		res++;
	}
}// ile charow pod rzad wystepuje w 2

int main(){

		int tmp = puzzle(10, 10);
		//printf("%d\n",tmp);
		printf("%ld\n",puzzle2("xAz", "Abcx"));
		return 0;
}
