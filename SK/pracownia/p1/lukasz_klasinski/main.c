/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: Andrzej Łukaszewski
plik: main.c
description:
My own implementation of popular tracing program "traceroute".
*/

#include "reciver.h"
#include "sender.h"

#define WRONG_ARGUMENT_MSG "%s\nUsage:\ntraceroute [destination addres]\n"
#define WRONG_IP_ADDRESS   "%s\n"
#define SOCKET_ERROR       "Socket error: %s\n"
#define TLE                "*\n"
#define SEND_ERROR         "Sending package error: %s\n"
#define UNCALC_MEDIAN      "???\n"

#define WAIT_TIME   1.0f //how long wait for packages
#define S_PACKAGE_C 3    //number of packages to send (default = 3)
#define TTL_LIMIT   30   //limit of ttl


int isValidIp(char* addr);
void print_results(struct package* in[S_PACKAGE_C], int cnt);
void parse_arguments(int argc, char** argv);

int   socketid;
int   pid;
char* dst_addr;

int main(int argc, char** argv){
    parse_arguments(argc, argv);

    socketid = socket(AF_INET, SOCK_RAW, IPPROTO_ICMP);
    if(socketid < 0){
        fprintf(stderr, SOCKET_ERROR, strerror(errno));
        return EXIT_FAILURE;
    }

    pid       = getpid();
    dst_addr  = argv[1];
    int ttl   = 1;
    int seqnr = 0;
    int cnt   = 1;

    while(ttl <= TTL_LIMIT){
        int i;
        //send packages
        for(i = 0; i < S_PACKAGE_C; ++i){
            int res = send_packet(seqnr+i, dst_addr, ttl, socketid);
            if(res < 0){
                fprintf(stderr, SEND_ERROR, strerror(errno));
                return EXIT_FAILURE;
            }
        }
        //increase ttl after every iteration
        ttl++;

        struct timeval start, stop;
        struct package* in[S_PACKAGE_C];
        for(i = 0; i < S_PACKAGE_C; ++i)
            in[i] = NULL;
        int seqa[S_PACKAGE_C];
        for(i = 0; i < S_PACKAGE_C; ++i)
            seqa[i] = seqnr + i;            
        //useful when measuring passed time (we wait max 1 sec for all packages to arrive)
        gettimeofday(&start, NULL);
        gettimeofday(&stop, NULL);
        
        //WAIT_TIME*1000 = 1sec
        while(timediff(start, stop) < WAIT_TIME*1000){               
            struct package* r = get_packet(socketid,  pid , seqa, S_PACKAGE_C, dst_addr
            , 1000*WAIT_TIME - timediff(start, stop));

            if(r->valid == 0){
                //package didn't deliver or we ran out of time
                free(r);
                gettimeofday(&stop, NULL);                
                continue;
            }                   
            //parse collected package with corresponding seqence number
            for(i = 0; i < S_PACKAGE_C; ++i)
                if(r->icmp_header->un.echo.sequence == seqa[i])
                    in[i] = r;
            //if we've caugth them all, nothing more to do here
            int all = 1;
            for(i = 0; i < S_PACKAGE_C; ++i)
                if(in[i] == NULL)
                    all = 0;
            if(all)
                break;
            //update passed time
            gettimeofday(&stop, NULL);
        }    
        print_results(in, cnt);
        cnt++;
        seqnr += S_PACKAGE_C;     

        char ip[20];
        for(i = 0; i < S_PACKAGE_C; ++i)
            if(in[i] != NULL){
                memcpy(ip, in[i]->ip, 20);
                break;
            }
        //if we reached destination SUCCESS!                               
        if(!strcmp(ip, dst_addr))       
            return EXIT_SUCCESS;
        for(i = 0; i < S_PACKAGE_C; ++i)
            if(in[i] != NULL)
                free(in[i]);                
    }
    //we ran out of ttl limit before reaching destination ;(
    return EXIT_SUCCESS;
}

int isValidIp(char* addr){
    struct sockaddr_in sa;
    int res = inet_pton(AF_INET, addr, &(sa.sin_addr));
    return res != 0;
}

void print_results(struct package* in[S_PACKAGE_C], int cnt){
    int i;
    if(cnt < 10)
        printf(" ");
    printf("%d. ", cnt);  
    int isaNULL = 1;
    for(i = 0; i < S_PACKAGE_C; ++i)
        if(in[i] != NULL)
            isaNULL = 0;
    //if every ip is empty, print "*"
    if(isaNULL){
        printf(TLE);
        return;
    }
    char* addr[S_PACKAGE_C];
    for(i = 0; i < S_PACKAGE_C; ++i)
        addr[i] = NULL;
    int addrc = 0;
    //get nonempty addresses and print every diffrent
    for(i = 0; i < S_PACKAGE_C; ++i)
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
    //if there is an empty address, cant calculate median time
    for(i = 0; i < S_PACKAGE_C; ++i)
        if(in[i] == NULL)
            isaNULL = 1;
    if(isaNULL)
        printf(UNCALC_MEDIAN);
    else{
        float median = 0.0f;
        for(i = 0; i < S_PACKAGE_C; ++i)
            median += in[i]->w_time;
        printf("%.0fms\n", median / S_PACKAGE_C);
    }
}

void parse_arguments(int argc, char** argv){
    if(argc != 2){
        fprintf(stderr, WRONG_ARGUMENT_MSG, strerror(E2BIG));        
        exit(EXIT_FAILURE);
    }
    if(!isValidIp(argv[1])){
        fprintf(stderr, WRONG_IP_ADDRESS, strerror(EINVAL));
        exit(EXIT_FAILURE);
    }
}