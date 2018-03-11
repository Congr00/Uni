default: program

main.o : kopiec.c
	gcc -c kopiec.c -o kopiec.o

program: kopiec.o
	gcc kopiec.o -o kopiec -Wall -lm

clean:
	-rm -f kopiec.o
	-rm -f kopiec