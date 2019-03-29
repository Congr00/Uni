/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: Andrzej Łukaszewski
plik:       window.h
*/

#ifndef WINDOW_H 
#define WINDOW_H

#include "utils.h"
#include "sender.h"
#include "reciver.h"

//first package in window
size_t start_pckg;
//last package in window
size_t end_pckg;
//number of packages to send
size_t pckg_to_send;

msg window[WINDOW_SIZE];

void rcv_pckg(void);
void write_data(void);
void send_pckg(struct sockaddr_in* serv_addr);
void download_file(struct sockaddr_in* serv_addr);

#endif //WINDOW_H