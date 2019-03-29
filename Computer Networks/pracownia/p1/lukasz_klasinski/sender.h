/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: Andrzej Łukaszewski
plik: sender.h
*/


#include <unistd.h>
#include <stdio.h>
#include <arpa/inet.h>
#include <netinet/ip_icmp.h>
#include <strings.h>
#include <netinet/ip.h>
#include <assert.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

#define SENDTO_ERROR "sendto error: %s\n"

u_int16_t compute_icmp_checksum(const void* buff, int length);

int send_packet(int seqnr, const char* dst_addr, int ttl, int sockid);