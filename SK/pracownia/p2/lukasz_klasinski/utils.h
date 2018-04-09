/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: Andrzej Łukaszewski
plik:       utils.h
*/


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
#include <sys/mman.h>

#define _GNU_SOURCE

#define PORT        54321
#define FIRST_BYTE  0x80000000
#define ROUND_WAIT  2
#define INF_BR      3
#define SELECT_WAIT 15
#define INF         0xFFFFFFFF
#define TURN        10
#define PRINT       15
#define ROUTE_LEN   64
#define LOST        -1
#define MMAP_ERROR  "Failed to map shared memory: %s\n"

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
    uint32_t distance_d    ;
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

typedef struct{
    char ip[15];
}ip_addr;

void     wait_s      (void)        ;
void     signal_s    (void)        ;
uint32_t endian_swap (uint32_t val);
void     print_record(reg in)      ;
bool     not_mine    (char ip[15]) ;

semaphore* __semaphore;
ip_addr*   _ip_addr   ;
int        _sockfd    ;
int32_t    neib_cnt   ;
#endif