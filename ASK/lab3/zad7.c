#include <stdio.h>

int main(){
		
		float val = 10;
		float val2 = 10;
		int x = *(int*)&val;
		int x2 = x;
		//zmiana znaku
		int y = ((x << 1) >> 1);
		int y2 =*(int*)&val2;

		x ^= 0x80000000;
		x = (x >> 31) << 31;
		x += y; 
		//log2
		x = (x + (x >> 31) ^ (x >> 31));
		x = (x >> 23) - 127;
		//x == y
		
		if( x2 == y2 | ( (((x2 << 1)>>1) == 1) & (((y2 << 1)>>1) == 0)	 	
						))
			printf("Rowne\n");
		
		// x <= y
		//1) kiedy znak x == 1 i znak y == 0 ||
		//2) bierzemy ceche, jesli znak x i y == 1, to odejmujemy, gdy znak bedzie 0, to x jest mniejsze
		//3) bierzemy ceche, jesli znak x i y == 0, to odejmujemy, gdy znak bedzie 1, to x jest mniejsze
		//4) gdy cecha x == cecha y, bierzemy mantyse i to samo co w (2) i (3)
		//5) to samo co w x == y.
		printf("%d\n",x);

		return 0;
}
