/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: Andrzej Łukaszewski
plik:       reciver.h
*/

#ifndef RECIVER_H
#define RECIVER_H

#include "utils.h"

int recive_package(struct timeval* tv, msg* win, size_t start_pckg);

#endif //RECIVER_H