
#include <stdio.h>
#include <stdlib.h>

void insert_sort(long* first, long* last);

int main(int argc, char* argv[]){

		size_t size = argc - 1;
			
		if(size > 0){
			long* table = (long*)malloc(sizeof(long) * size);
			long* endtable = (table + (size));
			printf("tablica przed sortowaniem: \n");
			for(size_t i = 0; i < size; i++){
					table[i] = atol(argv[i + 1]);
					printf("%ld ", table[i]);
			}
			insert_sort(table, endtable);
				printf("\npo: \n");
			for(size_t i = 0; i < size; i++)
					printf("%ld ", table[i]);

			printf("\n");
		}
		else
			return EXIT_FAILURE;
		return EXIT_SUCCESS;
}
