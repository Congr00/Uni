/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: Andrzej Łukaszewski
plik:       utils.c
*/

#include "utils.h"

void wait_s(){
    while(__semaphore->_val <= 0);
    __semaphore->_val--;
}

void signal_s(){
   __semaphore->_val++;
}

uint32_t endian_swap(uint32_t val){
    return
    (val>>24) |
    ((val>>8) & 0x0000ff00) |
    ((val<<8) & 0x00ff0000) |
    (val<<24);
}

void print_record(reg in){
    printf("record:\nip address %s\nbroadcast  %s\nsubnet     %s\nmask       %u\ndistance   %u\nlast_msg  %u\nbroadcast_inf %d\n direct %d\n",
    in.ip_address, in.broadcast, in.subnet, in.mask, in.distance, in.last_msg, in.broadcast_inf, in.direct);
}

bool not_mine(char ip[15]){
    for(int32_t i = 0; i < neib_cnt; ++i){
        if(!strcmp(ip, _ip_addr[i].ip)){
            return false;
        }
    }
    return true;
}