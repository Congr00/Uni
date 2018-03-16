default: program

main.o : kopiec.c
	gcc -c kopiec.c -o kopiec.o -static -g

program: kopiec.o
	gcc kopiec.o -o kopiec -static -g -lm

clean:
	-rm -f kopiec.o
	-rm -f kopiec