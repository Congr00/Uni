#include <stdio.h>

void print_in_Q16(unsigned int val){
	float af = 0.0;
	unsigned int bf = (val >> 15);
	float pow = 1;
	for(int i = 0, j = 15; i < 16; i++){
			pow /= 2;
			if((val >> j) & 1){
				af += pow; 
			}
	}
	printf("val: %f\n", af + bf);
}

unsigned int bytes_to_val(const char* val){
		unsigned int result = 0U;
		for(int i = 0, j = 31; i < 32; i++, j--){
				if(val[j] == '1'){
						result += (1 << i); 
				}
		}
		return result;
}

int main(){
		
		char* val = "00000000000000000000000000001111";
		char* val2 = "00000000000000000000000000000001";
		unsigned int value = bytes_to_val(val);
		unsigned int value2 = bytes_to_val(val2);

		int a,a1,b,b2;
		a = ((value >> 16) << 16);
		a1 = ((value << 16) >> 16);
		b = ((value2 >> 16) << 16);
		b1 = ((value2 << 16) >> 16);
		
		ares = a1 - b2;
		bres = b1 - b2;
	   	
		unsigned int strata = (ares & 0xFFFF0000);
		strata = (strata << 16)
		unsigned int strata2 = (ares & 0xFFFF0000);
		ares = ((ares << 16) >> 16);
		strata += strata2;
		


		return 0;
}
