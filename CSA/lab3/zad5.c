#include <stdio.h>
#include <stdint.h>
#include <limits.h>
#include <float.h>

int main(){
		
		int x;
		float f;
		double d;

		x = INT_MAX;

		if(x != (int32_t)(double)x)
			printf("1: falsz dla x=: %d\n", x);
		else
			printf("1: zawsze prawda!\n");

		x = INT_MAX;

		if(x != (int32_t)(float)x)
			printf("2: falsz dla x=: %d\n",x);
		else
			printf("2: zawsze prawda!\n");

		d = DBL_MAX;

		if(d != (double)(float)d)
			printf("3: falsz dla d=: DBL_MAX\n");
		else
			printf("3: zawsze prawda!\n");

		f = FLT_MAX;

		if(f != (float)(double)f)
			printf("4: falsz dla d=: %f\n",d);
		else
			printf("4: zawsze prawda\n");

		f = FLT_MIN;

		if(f != -(-f))
			printf("5: falsz dla f=: %f\n",f);
		else 
			printf("5: zawsze prawda\n");

		if((1.0 / 2) == (1 / 2.0))
			printf("6: prawda\n");
		else
			printf("6: falsz\n");

		d = DBL_MIN/2 + 1;

		if(d * d >= 0.0)
			printf("7: zawsze prawda %f\n", d * d);
		else
			printf("7: falsz dla d=: %f\n",d);
		
		f = FLT_MAX;
		d = DBL_MAX;
		printf("%f\n", DBL_MAX + FLT_MAX);

		if((f+d) -f == d)
			printf("8: zawsze prawda %f \n",f+d);
		else 
			printf("8: falsz dla f=: %f i d=: %f\n",f,d);

		return 0;
}
