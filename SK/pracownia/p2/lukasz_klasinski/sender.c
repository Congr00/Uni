/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: Andrzej Łukaszewski
plik:       sender.c
*/

#include "sender.h"

void broadcast_package(reg addr, reg dst, uint32_t ind){

	struct sockaddr_in server_address;
    s_package message;

	bzero (&server_address, sizeof(server_address));
	server_address.sin_family = AF_INET;
	server_address.sin_port   = htons(PORT);


	inet_pton(AF_INET, dst.broadcast , &server_address.sin_addr);
    inet_pton(AF_INET, addr.subnet   , &message.ip             );

    message.mask     = (char)addr.mask     ;
    message.distance = htonl(addr.distance);
	if (sendto(_sockfd, &message, sizeof(s_package), 0, (struct sockaddr*) &server_address, sizeof(server_address)) != sizeof(s_package)) {
		//network unreachable
		__semaphore->_route_tbl[ind].distance = INF;	
	}    	
}

void run_client(void){
	uint32_t turn = 0;
	while(1){
		wait_s();
		//send table to neibs
		send_all();
		//remove values with inf (if not neib)
		remove_inf();
		//print everything 		
		print_all();
		//every 30th turn rewrite array of regs
		//if(turn % 30)
		//	remake_reg(__semaphore);		
		signal_s();
		//wait for next turn
		sleep(TURN);
		turn++;
	}
}

void send_all(void){
    for(uint32_t i = 0; i < __semaphore->_route_cnt; ++i){
        if(__semaphore->_route_tbl[i].broadcast_inf != LOST && __semaphore->_route_tbl[i].direct){
			for(uint32_t j = 0; j < __semaphore->_route_cnt; ++j){
				if( __semaphore->_route_tbl[j].broadcast_inf != LOST){
					broadcast_package(__semaphore->_route_tbl[j], __semaphore->_route_tbl[i], i);	
				}
			}
		}
	}
}

void print_all(void){
	puts("");
	for(uint32_t i = 0; i < __semaphore->_route_cnt; ++i){
		if(__semaphore->_route_tbl[i].broadcast_inf != LOST || __semaphore->_route_tbl[i].direct){
			printf("%s/%d ", __semaphore->_route_tbl[i].subnet, __semaphore->_route_tbl[i].mask);
			if(__semaphore->_route_tbl[i].distance != INF)
				printf("distance %u ", __semaphore->_route_tbl[i].distance);				
			else
				printf("unreachable ");
			if(__semaphore->_route_tbl[i].direct)
				printf("connected directly");
			else
				printf("via %s", __semaphore->_route_tbl[i].ip_address);
			printf(" last msg:%u int:%d\n", __semaphore->_route_tbl[i].last_msg, __semaphore->_route_tbl[i].broadcast_inf);
		}
	}
	puts("");	
}

void remove_inf(void){
    for(uint32_t i = 0; i < __semaphore->_route_cnt; ++i){
        if(__semaphore->_route_tbl[i].broadcast_inf != LOST && __semaphore->_route_tbl[i].distance == INF)
			__semaphore->_route_tbl[i].broadcast_inf--;
	}
}

void remake_reg(void){
	reg* nreg = (reg*)malloc(sizeof(reg)*__semaphore->_route_len);
	if(nreg == NULL){
		fprintf(stderr, "%s\n", strerror(errno));
		exit(EXIT_FAILURE);                    
	}
	uint32_t j = 0;
	for(uint32_t i = 0; i < __semaphore->_route_cnt; ++i)
		if(__semaphore->_route_tbl[i].broadcast_inf != LOST || __semaphore->_route_tbl[i].direct)
			nreg[j++] = __semaphore->_route_tbl[i];
	free(__semaphore->_route_tbl);
	__semaphore->_route_tbl = nreg;
	__semaphore->_route_cnt = j   ;
}