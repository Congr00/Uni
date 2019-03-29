
#include <stdio.h>
#include <stdlib.h>

int clz(long);

int main(int argc, char* argv[]){
		if(argc == 2){
			printf("wiodace zera dla %ld : %d\n",atol(argv[1]),clz(atol(argv[1])));
		}
		else
			return EXIT_FAILURE;
		return EXIT_SUCCESS;
}
