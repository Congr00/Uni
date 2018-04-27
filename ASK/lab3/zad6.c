#include <stdio.h>
#include <stdint.h>
int main(){
		

		int val = 0;
		int div3;
		float f1 = 0.25;
		printf("%f\n",f1);
		val = *(int*)&f1;
		div3 = 0x3EAAAAAB;
		for(int i = 31; i >= 0; i--){
				printf("%d",((val >> i) & 1));
				if(i == 31 || i == 23)
						printf(" ");
		}
		printf("\n");

		
		int result;
		int i = 3;
		if(((val << 1) >> 24) == 255)
				result = val;
		else{
			int mant = ((val << 1) >> 1) >> 24;
			mant += i;
			
		}

		return 0;
}
