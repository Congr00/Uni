/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: Andrzej Łukaszewski
plik:       main.c
description:
Implementation of routing tables server and client
*/

#include <sys/stat.h>
#include <fcntl.h>
#include <signal.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/types.h>

#include "reciver.h"
#include "sender.h"

#define WRONG_ARGUMENT_MSG "Wrong argument\n"
#define WRONG_IP_ADDRESS   "%s\n"
#define SOCKET_ERROR       "Socket error: %s\n"
#define BIND_ERROR         "Bind error: %s\n"

void      parse_argument(char ip[15], int32_t mask, uint32_t dst, int32_t i);
int       isValidIp     (char* addr)                                         ;                                          ;

int main(void){

    scanf("%d", &neib_cnt);
    if(neib_cnt < 0){
        printf(WRONG_ARGUMENT_MSG);        
        return EXIT_FAILURE;        
    }
    _ip_addr = (ip_addr*)malloc(sizeof(ip_addr) * neib_cnt);
    if(_ip_addr == NULL){
        fprintf(stderr, "%s\n", strerror(errno));
        return EXIT_FAILURE;          
    }
    //create shared memory
    __semaphore = (semaphore*)mmap(NULL, sizeof(semaphore), PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, 0, 0);
    if(__semaphore == MAP_FAILED){
        fprintf(stderr, MMAP_ERROR, strerror(errno));
        return EXIT_FAILURE;        
    }
    __semaphore->_route_tbl = (reg*)mmap(NULL, sizeof(reg) * 64, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, 0, 0);
    if(__semaphore->_route_tbl == MAP_FAILED){
        fprintf(stderr, MMAP_ERROR, strerror(errno));
        return EXIT_FAILURE;        
    }
    //set starting values
    __semaphore->_route_cnt  = neib_cnt ;
    __semaphore->_route_len  = ROUTE_LEN;
    __semaphore->_val        = 1        ;

    char       in  [18];
    char       ip  [15];    
    char       dsts[ 8];
    int32_t    mask    ;    
    int64_t    dst     ;
    //get every addres from unput and check if correct, also parse and insert into array
    for(int32_t i = 0; i < neib_cnt; ++i){
        scanf("%s %s %ld", in, dsts, &dst);
        char* tok = strtok(in, "/");
        if(tok == NULL){
            printf(WRONG_ARGUMENT_MSG);
            return EXIT_FAILURE;
        }
        if(!isValidIp(tok)){
            fprintf(stderr, WRONG_IP_ADDRESS, strerror(EINVAL));
            return EXIT_FAILURE;
        }
        //get mask via tokens by '/'
        strcpy(ip, tok);
        uint16_t strl = strlen(tok);
        mask = atoi(in + strl + 1);
        if(mask < 0 || mask > 32){
            printf(WRONG_ARGUMENT_MSG);
            return EXIT_FAILURE;            
        }
        if(dst < 1){
            printf(WRONG_ARGUMENT_MSG);
            return EXIT_FAILURE; 
        }
        //parse and insert broadcast, network address
        parse_argument(ip, mask, dst, i);
    }

    //create socket
	_sockfd = socket(AF_INET, SOCK_DGRAM, 0);
	if (_sockfd < 0) {
		fprintf(stderr, SOCKET_ERROR, strerror(errno)); 
		return EXIT_FAILURE;
	}

	struct sockaddr_in server_address;
	bzero (&server_address, sizeof(server_address));
	server_address.sin_family      = AF_INET;
	server_address.sin_port        = htons(PORT);
	server_address.sin_addr.s_addr = htonl(INADDR_ANY);
    //bind for udp
	if (bind (_sockfd, (struct sockaddr*)&server_address, sizeof(server_address)) < 0) {
		fprintf(stderr, BIND_ERROR, strerror(errno)); 
		return EXIT_FAILURE;
	}
    //set broadcast permission
    int on = 1;
    setsockopt(_sockfd, SOL_SOCKET, SO_BROADCAST, &on, sizeof(on));
    //create process for server and client
    int pid = fork();
    if(pid < 0){
		fprintf(stderr, "%s\n", strerror(errno)); 
		return EXIT_FAILURE;        
    }else if(!pid){
        //child process;
        // server here
        run_server();
        exit(EXIT_SUCCESS);
    }
    //parent
    // client here
    run_client();
    kill(pid, SIGTERM);
    munmap(__semaphore->_route_tbl, sizeof(reg)* __semaphore->_route_len);
    munmap(__semaphore, sizeof(semaphore));
    //close(fd);
    return EXIT_SUCCESS;
}

int isValidIp(char* addr){
    struct sockaddr_in sa;
    int res = inet_pton(AF_INET, addr, &(sa.sin_addr));
    return res != 0;
}

void parse_argument(char ip[15], int32_t mask, uint32_t dst, int32_t i){
    strcpy(__semaphore->_route_tbl[i].ip_address, ip);
    strcpy(_ip_addr[i].ip, ip);
    __semaphore->_route_tbl[i].mask          = mask       ;
    __semaphore->_route_tbl[i].distance      = dst        ;
    __semaphore->_route_tbl[i].last_msg      = ROUND_WAIT ;
    __semaphore->_route_tbl[i].direct        = true       ;
    __semaphore->_route_tbl[i].broadcast_inf = INF_BR     ;
    __semaphore->_route_tbl[i].distance_d    = dst        ;

    create_inet_data_ip(ip, mask, &__semaphore->_route_tbl[i]);
}