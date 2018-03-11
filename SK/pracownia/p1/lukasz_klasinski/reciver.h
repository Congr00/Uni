/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: Andrzej Łukaszewski
plik: reciver.h
*/

#include <arpa/inet.h>
#include <netinet/ip.h>
#include <stdlib.h>
#include <sys/select.h>
#include <netinet/ip_icmp.h>
#include <stdio.h>
#include <string.h>
#include <sys/time.h>

#define MAX_PACKAGE_COUNT 10
#define ICMP_PADDING 4
#define ICMP_PADDING_TTL 8

struct package{
    char            ip[20];
    struct iphdr*   ip_header;    
    struct icmphdr* icmp_header;
    u_int8_t*       icmp_packet;
    float           w_time;
};

struct unpacked{
    struct package* arr[MAX_PACKAGE_COUNT];
    int            packet_cnt;
    int            valid;
};

float timediff(struct timeval t0, struct timeval t1);
void print_hex(int length, u_int8_t* buff);
struct unpacked* get_packet(int sockid, int id, int seq[3], const char* ip_dst, float wait_time); 

