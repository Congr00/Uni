default: avl

main.o : main.c
	gcc -c main.c -o main.o -Wall -Wextra

avl.o  : avl.c
	gcc -c avl.c -o avl.o -Wall -Wextra

avl: main.o avl.o
	gcc main.o avl.o -o avl -lm

clean:
	-rm -f *.o
distclean:
	-rm -f *.o
	-rm -f avl