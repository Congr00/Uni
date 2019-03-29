
#include <stdio.h>
#include <stdlib.h>

typedef struct{
		unsigned long lcm, gcd;
} result_t;

result_t lcm_gcd(unsigned long, unsigned long);

int main(int argc, char* argv[]){
		if(argc == 3){
			long v1 = atol(argv[1]);
			long v2 = atol(argv[2]);
			result_t res = lcm_gcd(v1, v2);
			printf("dla liczb %ld, %ld, gcd: %ld | lcm: %ld\n",v1, v2, res.gcd, res.lcm);
		}
		else
			return EXIT_FAILURE;
		return EXIT_SUCCESS;
}
