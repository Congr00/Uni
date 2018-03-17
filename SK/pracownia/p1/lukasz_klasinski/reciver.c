/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: Andrzej Łukaszewski
plik: reciver.c
*/

//in memory of Marcin Witkowski
#define loop for(;;)

#include "reciver.h"

float timediff(struct timeval t0, struct timeval t1){
    return (t1.tv_sec - t0.tv_sec) * 1000.0f + (t1.tv_usec - t0.tv_usec) / 1000.0f;
}

//helpfull to print full package contents (mostly debugging)
void print_hex(int length, u_int8_t* buff){
    for(int i = 0; i < length; ++i){
        if( (i % 16) == 0 ) printf( "\n0x%.3x | ", i );
        printf("%.2x ", *(buff + i));
    }
    printf("\n");
}

struct package* get_packet(int sockid, int id, int* seq, int seql, const char* ip_dst, float wait_time){
    struct package* res = (struct package*)malloc(sizeof(struct package));

    fd_set descriptors;
    FD_ZERO(&descriptors);
    FD_SET(sockid, &descriptors);
    struct timeval tv, start, stop;
    float passed = 0;
    tv.tv_sec = 0;
    tv.tv_usec = 1000*wait_time;

    //select checks if there is a package awaiting in a buffer
    gettimeofday(&start, NULL);
    int ready = select(sockid+1, &descriptors, NULL, NULL, &tv);
    gettimeofday(&stop, NULL);
    passed = timediff(start, stop) + 1000.0f - wait_time;

    if(ready < 0){
        fprintf(stderr, SELECT_ERROR, strerror(errno));
        exit(EXIT_FAILURE);
    }
    else if(ready == 0){
        //no packages awaits and select went out of $wait_time
        res->valid = 0;
        return res;
    }
    loop {
        //parsing package contents to structures
        struct    sockaddr_in sender;
        socklen_t sender_len = sizeof(sender);
        u_int8_t  buffer[IP_MAXPACKET];        
        struct    package* p  = (struct package*)malloc(sizeof(struct package));
        ssize_t   packet_len = recvfrom(sockid, buffer, IP_MAXPACKET, MSG_DONTWAIT, 
        (struct sockaddr*)&sender, &sender_len);

        if(packet_len < 0 && packet_len != -1){
            //something went wrong with recvfrom
            fprintf(stderr, RECIVE_ERROR, strerror(errno));
            exit(EXIT_FAILURE);
        }
        if(packet_len == -1){
            //no more packages
            res->valid = 0;
            free(p);
            return res;
        }
        inet_ntop(AF_INET, &(sender.sin_addr), p->ip, sizeof(p->ip));
        p->ip_header = (struct iphdr*)buffer;

        //check if it's ttl or normal response to ICMP
        if(!strcmp(ip_dst, p->ip))
            p->icmp_packet = buffer + ICMP_PADDING * p->ip_header->ihl;
        else
            p->icmp_packet = buffer + ICMP_PADDING_TTL * p->ip_header->ihl + ICMP_PADDING_TTL;

        p->icmp_header = (struct icmphdr*)p->icmp_packet;           
        p->w_time      = passed;

        //make sure it's not someone elses package!
        int foreign_p = 1;
        for(int i = 0; i < seql; ++i)
            if(p->icmp_header->un.echo.sequence == seq[i])
                foreign_p = 0;
        if(id == p->icmp_header->un.echo.id && !foreign_p){
            //one correct package at the time
            p->valid = 1;
            free(res);
            return p;            
        }
        free(p);
    }
}