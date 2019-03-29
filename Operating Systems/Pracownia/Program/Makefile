default: program

main.o : main.c
	gcc -c main.c -o main.o

program: main.o
	gcc main.o -o program -Wall

clean:
	-rm -f main.o
	-rm -f program
	-rm -f file*