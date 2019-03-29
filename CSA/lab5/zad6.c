
#include <stdio.h>


union elem{
		struct{
				long*p;
				long y;
		}el1;
		struct{
				long x;
				union elem* next;
		}el2;
}elem;//size = 16
void proc(union elem* el){

	union elem* next = el->el2.next;
	long* p = next->el1.p;
	long res = *(p);
	res -= next->el1.y;
	el->el2.x = res;
};




int main(){

		//printf("%d\n",ww);

		return 0;
}
