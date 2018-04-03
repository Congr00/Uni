#ifndef UTILS_H
#define UTILS_H

#include <netinet/ip.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <stdbool.h>
#include <sys/time.h>

#define PORT        54321
#define FIRST_BYTE  0x80000000
#define ROUND_WAIT  6
#define INF_BR      5
#define SELECT_WAIT 20
#define INF         0xfffffffe
#define TURN        15
#define PRINT       15
#define LOST        -1

// force package to have a size of 9
#pragma pack(push, 1)
typedef struct{
    uint32_t ip      ;
    char      mask    ;
    uint32_t distance;
}s_package;
#pragma pack(pop)

typedef struct{
    char     ip_address[15];
    char     broadcast [15];    
    char     subnet    [15];
    int32_t  mask          ;
    uint32_t distance      ; 
    uint16_t last_msg      ;
    int16_t  broadcast_inf ;
    bool     direct        ;
}reg;

typedef struct{
    reg*      _route_tbl;
    int32_t   _val      ;     
    uint32_t _route_cnt;
    uint32_t _route_len;
}semaphore;

void     wait_s     (void)        ;
void     signal_s   (void)        ;
uint32_t endian_swap(uint32_t val);

semaphore* __semaphore;
int        _sockfd    ;

#endif