/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: Andrzej Łukaszewski
plik:       sender.h
*/

#ifndef SENDER_H
#define SENDER_H

#include "utils.h"

void send_package(int start, int size, struct sockaddr_in* server_address);

#endif //SENDER_H