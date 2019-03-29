/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: Andrzej Łukaszewski
plik:       sender.c
*/

#include "sender.h"

void send_package(int start, int size, struct sockaddr_in* server_address){

	char message[19];
	/*message template : "GET %start %size\n"
		%start - start byte of file to recive
		%size  - number of bytes to recive
	*/
	sprintf(message, "GET %d %d\n", start, size);
	size_t i;
	// get where \n is to calculate total size of string
	for(i = 0; i < 20; ++i)
		if(message[i] == '\n')
			break;

	int res = sendto(sockfd, message, i+1, 0, 
	(struct sockaddr*) server_address, sizeof(*server_address));
	if(res == -1){
		RET_F_ERROR("%s\n");
	}
}
