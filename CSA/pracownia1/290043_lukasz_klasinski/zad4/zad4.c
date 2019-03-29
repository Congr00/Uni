
#include <stdio.h>
#include <stdlib.h>

unsigned long fibonacci(unsigned long);

int main(int argc, char* argv[]){
		if(argc == 2){
			printf("fib(%ld) : %ld\n",atol(argv[1]),fibonacci(atol(argv[1])));
		}
		else
			return EXIT_FAILURE;
		return EXIT_SUCCESS;
}
