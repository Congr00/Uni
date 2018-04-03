/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: Andrzej Łukaszewski
plik:       sender.h
*/

#include "utils.h"

void broadcast_package(reg addr, char dst[15]);
void run_client       (semaphore* sem)        ;
void send_all         (semaphore* sem)        ;
void print_all        (semaphore* sem)        ;
void remove_inf       (semaphore* sem)        ;
void remake_reg       (semaphore* sem)        ;
