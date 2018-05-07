/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: Andrzej Łukaszewski
plik:       reciver.h
*/

#ifndef RECIVER_H
#define RECIVER_H

#include "utils.h"

msg recive_package(struct timeval* tv, fd_set* descriptors);

#endif //RECIVER_H