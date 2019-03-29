default: router

main.o : main.c
	gcc -std=gnu99 -c main.c -o main.o -Wall -Wextra

sender.o : sender.c
	gcc -std=gnu99 -c sender.c -o sender.o -Wall -Wextra

reciver.o : reciver.c
	gcc -std=gnu99 -c reciver.c -o reciver.o -Wall -Wextra

utils.o : utils.c
	gcc -std=gnu99 -c utils.c -o utils.o -Wall -Wextra	

router: main.o sender.o reciver.o utils.o
	gcc -std=gnu99 main.o sender.o reciver.o utils.o -o router

main32.o : main.c
	gcc -std=gnu99 -c main.c -o main32.o -m32 -Wall -Wextra

sender32.o : sender.c
	gcc -std=gnu99 -m32 -c sender.c -o sender32.o -Wall -Wextra

reciver32.o : reciver.c
	gcc -std=gnu99 -m32 -c reciver.c -o reciver32.o -Wall -Wextra

utils32.o : utils.c
	gcc -std=gnu99 -m32 -c utils.c -o utils32.o -Wall -Wextra	

router32: main32.o sender32.o reciver32.o utils32.o
	gcc -std=gnu99 -m32 main32.o sender32.o reciver32.o utils32.o -o router32

clean:
	-rm -f *.o
distclean:
	-rm -f *.o
	-rm -f router	
	-rm -f router32	