default: router

main.o : main.c
	gcc -c main.c -o main.o -std=c99 -Wall -Wextra

sender.o : sender.c
	gcc -c sender.c -o sender.o -std=c99 -Wall -Wextra

reciver.o : reciver.c
	gcc -c reciver.c -o reciver.o -std=c99 -Wall -Wextra

utils.o : utils.c
	gcc -c utils.c -o utils.o -std=c99 -Wall -Wextra	

router: main.o sender.o reciver.o utils.o
	gcc main.o sender.o reciver.o utils.o -o router

clean:
	-rm -f main.o
	-rm -f sender.o
	-rm -f reciver.o
	-rm -f utils.o
	-rm -f .fmap

distclean:
	-rm -f main.o
	-rm -f sender.o
	-rm -f reciver.o	
	-rm -f utils.o
	-rm -f router
	-rm -f .fmap