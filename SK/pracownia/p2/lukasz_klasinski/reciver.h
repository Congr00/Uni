/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: Andrzej Łukaszewski
plik:       reciver.h
*/

#include "utils.h"

#define RECV_ERROR   "recvfrom error: %s\n"
#define SELECT_ERROR "select error:%s\n"

reg       recive_package      (void)                               ;
void      create_inet_data_ip (char ip[15], int32_t mask, reg* var);
void      create_broadcast    (uint32_t ip, int32_t mask, reg* var);
uint32_t  endian_swap         (uint32_t val)                       ;
void      run_server          (semaphore* sem)                     ;
void      insert_reg          (semaphore* sem, reg r)              ;
void      resize_reg          (semaphore* sem)                     ;
void      update_reg          (semaphore* sem)                     ;
