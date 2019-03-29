default: traceroute

main.o : main.c
	gcc -c main.c -o main.o -std=c99 -Wall -Wextra

reciver.o: reciver.c
	gcc -c reciver.c -o reciver.o -std=c99 -Wall -Wextra

sender.o: sender.c
	gcc -c sender.c -o sender.o -std=c99 -Wall -Wextra

traceroute: main.o sender.o reciver.o
	gcc main.o sender.o reciver.o -o traceroute

clean:
	-rm -f main.o
	-rm -f sender.o
	-rm -f reciver.o

distclean:
	-rm -f main.o
	-rm -f sender.o
	-rm -f reciver.o
	-rm -f traceroute