/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: Andrzej Łukaszewski
plik:       main.c
description:
Implementation of routing tables server
*/

#define _POSIX_SOURCE

#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <signal.h>

#include "reciver.h"
#include "sender.h"

#define FMAP       ".fmap"

#define WRONG_ARGUMENT_MSG "Wrong argument\n"
#define WRONG_IP_ADDRESS   "%s\n"
#define SOCKET_ERROR       "Socket error: %s\n"
#define BIND_ERROR         "Bind error: %s\n"
#define MMAP_ERROR         "Failed to map shared memory: %s\n"

void      parse_argument(char ip[15], int32_t mask, uint32_t dst, int32_t i);
void      print_record  (reg in)                                             ;
int       isValidIp     (char* addr)                                         ;
int       createFMap    (void)                                               ;

int main(void){

    int32_t neib_cnt;
    int fd = createFMap();
    scanf("%d", &neib_cnt);
    if(neib_cnt < 0){
        printf(WRONG_ARGUMENT_MSG);        
        return EXIT_FAILURE;        
    }

    __semaphore = mmap(NULL, sizeof(semaphore), PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
    if(__semaphore == MAP_FAILED){
        fprintf(stderr, MMAP_ERROR, strerror(errno));
        return EXIT_FAILURE;        
    }
    __semaphore->_route_tbl  = (reg*)malloc(sizeof(reg) * neib_cnt);
    if(__semaphore->_route_tbl == NULL){
        fprintf(stderr, "%s\n", strerror(errno));
        return EXIT_FAILURE;                
    }
    __semaphore->_route_cnt  = neib_cnt                            ;
    __semaphore->_route_len  = neib_cnt                            ;
    __semaphore->_val        = 1                                   ;
        // remember to unmanp
    char       in  [18];
    char       ip  [15];    
    char       dsts[ 8];
    int32_t    mask    ;    
    int64_t    dst     ;
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
        parse_argument(ip, mask, dst, i);
    }

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

	if (bind (_sockfd, (struct sockaddr*)&server_address, sizeof(server_address)) < 0) {
		fprintf(stderr, BIND_ERROR, strerror(errno)); 
		return EXIT_FAILURE;
	}

    int pid = fork();
    if(pid < 0){
		fprintf(stderr, "%s\n", strerror(errno)); 
		return EXIT_FAILURE;        
    }else if(!pid){
        // child process;
        //server here
        run_server(__semaphore);
        exit(EXIT_SUCCESS);
    }
    //parent
    // sending values and printing here
    run_client(__semaphore);
    kill(pid, SIGTERM);
    munmap(__semaphore, sizeof(semaphore));
    close(fd);
    return EXIT_SUCCESS;
}

int isValidIp(char* addr){
    struct sockaddr_in sa;
    int res = inet_pton(AF_INET, addr, &(sa.sin_addr));
    return res != 0;
}

void print_record(reg in){
    printf("record:\nip address %s\nbroadcast  %s\nsubnet     %s\nmask       %u\ndistance   %u\n",
    in.ip_address, in.broadcast, in.subnet, in.mask, in.distance);
}

void parse_argument(char ip[15], int32_t mask, uint32_t dst, int32_t i){
    strcpy(__semaphore->_route_tbl[i].ip_address, ip);
    __semaphore->_route_tbl[i].mask          = mask       ;
    __semaphore->_route_tbl[i].distance      = dst        ;
    __semaphore->_route_tbl[i].last_msg      = ROUND_WAIT ;
    __semaphore->_route_tbl[i].direct        = true       ;
    __semaphore->_route_tbl[i].broadcast_inf = INF_BR     ;
    
    create_inet_data_ip(ip, mask, &__semaphore->_route_tbl[i]);
    print_record(__semaphore->_route_tbl[i]);
}


int createFMap(void){
    int fd, result;
    fd = open(FMAP, O_RDWR | O_CREAT | O_TRUNC, (mode_t)0600);
    if (fd == -1) {
        fprintf(stderr, "%s\n", strerror(errno));
        exit(EXIT_FAILURE);
    }
    result = lseek(fd, sizeof(semaphore)-1, SEEK_SET);
    if (result == -1) {
        close(fd);
        fprintf(stderr, "%s\n", strerror(errno));
        exit(EXIT_FAILURE);
    }    
    result = write(fd, "", 1);
    if (result != 1) {
        close(fd);
        fprintf(stderr, "%s\n", strerror(errno));
        exit(EXIT_FAILURE);
    }    
    return fd;
}