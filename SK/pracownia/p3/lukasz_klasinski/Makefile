default: transport

main.o : main.c
	gcc -std=gnu99 -c main.c -o main.o -Wall -Wextra

sender.o : sender.c
	gcc -std=gnu99 -c sender.c -o sender.o -Wall -Wextra

reciver.o : reciver.c
	gcc -std=gnu99 -c reciver.c -o reciver.o -Wall -Wextra

window.o : window.c
	gcc -std=gnu99 -c window.c -o window.o -Wall -Wextra

transport: main.o sender.o reciver.o window.o
	gcc -std=gnu99 main.o sender.o reciver.o window.o -o transport

clean:
	-rm -f *.o
distclean:
	-rm -f *.o
	-rm -f transport