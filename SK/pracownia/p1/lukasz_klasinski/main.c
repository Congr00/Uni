/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: Andrzej Łukaszewski
plik: main.c
*/

#include "sender.h"
#include "reciver.h"

#include <arpa/inet.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>

#define WRONG_ARGUMENT_MSG "Usage:\ntraceroute [src_addres]\n"
#define WRONG_IP_ADDRESS   "Wrong ip address!\n"
#define SOCKET_ERROR       "Socket error: %s\n"
#define TLE                "*\n"
#define SELECT_ERROR       "Select error: %s\n"
#define RECIVE_ERROR       "Reciver error: %s\n"
#define SEND_ERROR         "Sending package error: %s\n"
#define WAIT_TIME          1.0f
#define TLE_MESSAGE       "???\n"

int isValidIp(char* addr){
    struct sockaddr_in sa;
    int res = inet_pton(AF_INET, addr, &(sa.sin_addr));
    return res != 0;
}

void print_results(struct package* in[3], int cnt){
    if(cnt < 10)
        printf(" ");
    printf("%d. ", cnt);    
    if(in[0] == NULL && in[1] == NULL && in[2] == NULL){
        printf(TLE);
        return;
    }
    char* addr[3] = {NULL, NULL, NULL};
    int addrc = 0;
    for(int i = 0; i < 3; ++i)
        if(in[i] != NULL){
            int tmp = 0;
            for(int j = 0; j < addrc; ++j)
                if(!strcmp(addr[j],in[i]->ip)){
                    tmp = 1;
                    break;
                }
            if(tmp)
                continue;
            addr[addrc] = in[i]->ip;
            printf("%s ", addr[addrc]);
            for(int j = strlen(addr[addrc]); j < 16; j++)
                printf(" ");
            addrc++;
        }
    if(in[0] == NULL || in[1] == NULL || in[2] == NULL)
        printf(TLE_MESSAGE);
    else
        printf("%.0fms\n", (in[0]->w_time + in[1]->w_time + in[2]->w_time)/3);
}

int   socketid;
int   pid;
char* dst_addr;

int main(int argc, char** argv){

    if(argc != 2){
        printf(WRONG_ARGUMENT_MSG);
        return EXIT_FAILURE;
    }
    if(!isValidIp(argv[1])){
        printf(WRONG_IP_ADDRESS);
        return EXIT_FAILURE;
    }

    socketid = socket(AF_INET, SOCK_RAW, IPPROTO_ICMP);
    if(socketid < 0){
        fprintf(stderr, SOCKET_ERROR, strerror(errno));
        return EXIT_FAILURE;
    }

    pid       = getpid();
    dst_addr  = argv[1];
    int tle   = 1;
    int seqnr = 0;
    int cnt   = 1;

    while(tle <= 30){
        for(int i = 0; i < 3; ++i){
            int res = send_packet(seqnr+i, dst_addr, tle, socketid);
            if(res < 0){
                fprintf(stderr, SEND_ERROR, strerror(errno));
                return EXIT_FAILURE;
            }
        }
        tle++;

        struct timeval start, stop;
        struct package* in[3] = {NULL, NULL, NULL};
        gettimeofday(&start, NULL);
        gettimeofday(&stop, NULL);

        while(timediff(start, stop) < WAIT_TIME*1000){               
            int seqa[3] = {seqnr, seqnr+1, seqnr+2};
            struct unpacked* r = get_packet(socketid,  pid , seqa, dst_addr, 1000*WAIT_TIME - timediff(start, stop));
            if(r->valid < 0 && r->valid != -100){
                fprintf(stderr, SELECT_ERROR, strerror(errno));
                return EXIT_FAILURE;
            }
            else if(r->valid == -100){
                fprintf(stderr, RECIVE_ERROR, strerror(errno));
                return EXIT_FAILURE;
            }
            else if(r->valid == 0){
                gettimeofday(&stop, NULL);                
                continue;
            }        
            for(int i = 0; i < r->packet_cnt; ++i){
                struct package* p = (struct package*)malloc(sizeof(struct package));
                memcpy(p, r->arr[i], sizeof(*p));
                if(p->icmp_header->un.echo.sequence == seqa[0])
                    in[0] = p;
                else if(p->icmp_header->un.echo.sequence == seqa[1])
                    in[1] = p;
                else if(p->icmp_header->un.echo.sequence == seqa[2])
                    in[2] = p; 
            }    
            free(r);
            if(in[0] != NULL && in[1] != NULL && in[2] != NULL){
                break;
            }
            gettimeofday(&stop, NULL);
        }    
        print_results(in, cnt);
        cnt++;
        seqnr += 3;     

        char* ip = "";
        if(in[0] != NULL)
            ip = in[0]->ip;
        else if(in[1] != NULL)
            ip = in[1]->ip;
        else if(in[2] != NULL)
            ip = in[2]->ip;
        if(!strcmp(ip, dst_addr)){
            return EXIT_SUCCESS;
        }
        if(in[0] != NULL)
            free(in[0]);
        if(in[1] != NULL)
            free(in[1]);
        if(in[2] != NULL)
            free(in[2]);
            
    }
}
