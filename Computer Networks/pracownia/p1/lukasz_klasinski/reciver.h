/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: Andrzej Łukaszewski
plik: reciver.h
*/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <arpa/inet.h>
#include <netinet/ip.h>
#include <netinet/ip_icmp.h>
#include <sys/select.h>
#include <sys/time.h>
#include <errno.h>

#define ICMP_PADDING     4
#define ICMP_PADDING_TTL 8
#define SELECT_ERROR       "Select error: %s\n"
#define RECIVE_ERROR       "Reciver error: %s\n"

struct package{
    char            ip[20];
    struct iphdr*   ip_header;    
    struct icmphdr* icmp_header;
    u_int8_t*       icmp_packet;
    float           w_time;
    short           valid;
};

float timediff(struct timeval t0, struct timeval t1);
void print_hex(int length, u_int8_t* buff);
struct package* get_packet(int sockid, int id, int* seq, int seql, const char* ip_dst, float wait_time); 

