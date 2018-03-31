default: heap

heap.o : heap.c
	gcc -c heap.c -o heap.o -Wall -Wextra -lm 

heap: heap.o
	gcc heap.o -o heap -lm 

clean:
	-rm -f heap.o
	-rm -f heap
