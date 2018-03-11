/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: Andrzej Łukaszewski
plik: sender.c
*/

#include "sender.h"

u_int16_t compute_icmp_checksum(const void* buff, int length){
    u_int32_t sum;
    const u_int16_t* ptr = buff;
    assert(length % 2 == 0);
    for(sum = 0; length > 0; length -= 2)
        sum += *ptr++;
    sum = (sum >> 16) + (sum & 0xffff);
    return (u_int16_t)(~(sum + (sum >> 16)));
}


int send_packet(int seqnr, const char* dst_addr, int ttl, int sockid){
    struct icmphdr icmp_header;
    icmp_header.type = ICMP_ECHO;
    icmp_header.code = 0;
    icmp_header.un.echo.id = getpid();
    icmp_header.un.echo.sequence = seqnr;
    icmp_header.checksum = 0;
    icmp_header.checksum = compute_icmp_checksum((u_int16_t*)&icmp_header, sizeof(icmp_header));

    struct sockaddr_in recipient;
    bzero(&recipient, sizeof(recipient));
    recipient.sin_family = AF_INET;
    inet_pton(AF_INET, dst_addr, &recipient.sin_addr);

    setsockopt(sockid, IPPROTO_IP, IP_TTL, &ttl, sizeof(int));
    ssize_t bytes_send = sendto(sockid, &icmp_header, sizeof(icmp_header), 0, 
    (struct sockaddr*)&recipient, sizeof(recipient));
    return (int)bytes_send;
}
