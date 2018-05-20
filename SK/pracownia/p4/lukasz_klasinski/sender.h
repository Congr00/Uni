/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: Andrzej Łukaszewski
plik:       sender.h
*/

#ifndef SENDER_H
#define SENDER_H

#include "utils.h"

void send_data(int fd, char* buff);
int  generate_resp(char* buff);
int  is_dir(const char *path);
int  file_to_buff(char** buff, int fd, int file_size, int offset);

char* resp_msg;

#endif //SENDER_H