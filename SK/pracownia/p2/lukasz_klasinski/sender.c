/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: Andrzej Łukaszewski
plik:       sender.c
*/

#include "sender.h"

void broadcast_package(reg addr, char dst[15]){

	struct sockaddr_in server_address;
    s_package message;

	bzero (&server_address, sizeof(server_address));
	server_address.sin_family = AF_INET;
	server_address.sin_port   = htons(PORT);

	inet_pton(AF_INET, dst		     , &server_address.sin_addr);
    inet_pton(AF_INET, addr.broadcast, &message.ip             );

    message.mask     = (char)addr.mask    ;
    message.distance =       addr.distance;

	if (sendto(_sockfd, &message, sizeof(s_package), 0, (struct sockaddr*) &server_address, sizeof(server_address)) != sizeof(s_package)) {
		fprintf(stderr, "sendto error: %s\n", strerror(errno)); 
		exit(EXIT_FAILURE);		
	}    
}

void run_client(semaphore* sem){
	int turn = 0;
	while(1){
		wait_s();
		send_all(sem);
		remove_inf(sem);
		print_all(sem);
		signal_s();
		sleep(TURN);
		turn++;
	}
}

void send_all(semaphore* sem){
    for(uint32_t i = 0; i < sem->_route_cnt; ++i){
        if(sem->_route_tbl[i].broadcast_inf != LOST && sem->_route_tbl[i].direct){
			for(uint32_t j = 0; j < sem->_route_cnt; ++j){
				if(i != j && sem->_route_tbl[j].broadcast_inf != LOST)
					broadcast_package(sem->_route_tbl[j], sem->_route_tbl[i].ip_address);			
			}
		}
	}
}

void print_all(semaphore* sem){
	for(uint32_t i = 0; i < sem->_route_cnt; ++i){
		if(sem->_route_tbl[i].broadcast_inf != LOST || sem->_route_tbl[i].direct){
			printf("%s/%d ", sem->_route_tbl[i].subnet, sem->_route_tbl[i].mask);
			int tmp = 15 - strlen(sem->_route_tbl[i].subnet);
			if(sem->_route_tbl[i].mask > 9)
				tmp += 1;
			for(int j = 0; j < tmp; ++j)
				printf(" ");
			if(sem->_route_tbl[i].distance != INF){
				printf("distance %u ", sem->_route_tbl[i].distance);
				//tmp = sem->_route_tbl[i].distance / 10;
				//for(int j = 0; j < tmp; ++j)
			//		printf(" ");					
			}
			else
				printf("unreachable ");
			if(sem->_route_tbl[i].direct)
				printf("connected directly\n");
			else
				printf("via %s\n", sem->_route_tbl[i].ip_address);
		}
	}
}

void remove_inf(semaphore* sem){
    for(uint32_t i = 0; i < sem->_route_cnt; ++i){
        if(sem->_route_tbl[i].broadcast_inf != LOST && sem->_route_tbl[i].distance == INF)
			sem->_route_tbl[i].broadcast_inf--;
	}
}

void remake_reg(semaphore* sem){
	reg* nreg = (reg*)malloc(sizeof(reg)*sem->_route_len);
	if(nreg == NULL){
		fprintf(stderr, "%s\n", strerror(errno));
		exit(EXIT_FAILURE);                    
	}
	uint32_t j = 0;
	for(uint32_t i = 0; i < sem->_route_cnt; ++i)
		if(sem->_route_tbl[i].broadcast_inf != LOST || sem->_route_tbl[i].direct)
			nreg[j++] = sem->_route_tbl[i];
	free(sem->_route_tbl);
	sem->_route_tbl = nreg;
	sem->_route_cnt = j;
}