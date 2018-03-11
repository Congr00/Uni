/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: Andrzej Łukaszewski
plik: reciver.c
*/

#define loop for(;;)

#include "reciver.h"


float timediff(struct timeval t0, struct timeval t1){
    return (t1.tv_sec - t0.tv_sec) * 1000.0f + (t1.tv_usec - t0.tv_usec) / 1000.0f;
}

void print_hex(int length, u_int8_t* buff){
    for(int i = 0; i < length; ++i){
        if( (i % 16) == 0 ) printf( "\n0x%.3x | ", i );
        printf("%.2x ", *(buff + i));
    }
    puts("");
}

struct unpacked* get_packet(int sockid, int id, int seq[3], const char* ip_dst, float wait_time){
    struct unpacked* res = (struct unpacked*)malloc(sizeof(struct unpacked));

    fd_set descriptors;
    FD_ZERO(&descriptors);
    FD_SET(sockid, &descriptors);
    struct timeval tv, start, stop;
    float passed = 0;
    tv.tv_sec = 0;
    tv.tv_usec = 1000*wait_time;

    gettimeofday(&start, NULL);
    int ready = select(sockid+1, &descriptors, NULL, NULL, &tv);
    gettimeofday(&stop, NULL);
    passed = timediff(start, stop) + 1000.0f - wait_time;

    if(ready < 0){
        res->valid = ready;
        return res;
    }
    else if(ready == 0){
        res->valid = 0;
        return res;
    }

    int count = 0;  
    loop {
        struct    sockaddr_in sender;
        socklen_t sender_len = sizeof(sender);
        u_int8_t  buffer[IP_MAXPACKET];        
        struct    package* p;      
        p = (struct package*)malloc(sizeof(struct package));
        ssize_t   packet_len = recvfrom(sockid, buffer, IP_MAXPACKET, MSG_DONTWAIT, 
        (struct sockaddr*)&sender, &sender_len);
        
        if(packet_len < 0 && packet_len != -1){
            res->valid = -100;
            return res;
        }
        else if(packet_len == -1 || MAX_PACKAGE_COUNT == count){
            res->valid      = 1;
            res->packet_cnt = count;       
            return res;
        }
        inet_ntop(AF_INET, &(sender.sin_addr), p->ip, sizeof(p->ip));
        p->ip_header = (struct iphdr*)buffer;

        if(!strcmp(ip_dst, p->ip))
            p->icmp_packet = buffer + ICMP_PADDING * p->ip_header->ihl;
        else
            p->icmp_packet = buffer + ICMP_PADDING_TTL * p->ip_header->ihl + ICMP_PADDING_TTL;

        p->icmp_header = (struct icmphdr*)p->icmp_packet;           
        p->w_time      = passed;      
        
        if(id == p->icmp_header->un.echo.id && 
           (p->icmp_header->un.echo.sequence == seq[0] || 
            p->icmp_header->un.echo.sequence == seq[1] ||
            p->icmp_header->un.echo.sequence == seq[2])){
            res->arr[count] = p;  
            res->packet_cnt = 1;
            res->valid = 1;
            return res;
            count++;            
        }
    }
}