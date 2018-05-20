/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: Andrzej Łukaszewski
plik:       reciver.c
*/

#include "reciver.h"

int recive_data(int fd, char* buff){

    struct timeval tv; 
    tv.tv_sec  = TIMEOUTS; 
    tv.tv_usec = 0;
    fd_set descriptors;
    FD_ZERO (&descriptors);
    FD_SET (fd, &descriptors);

    // wait max TIMEOUTS sec for package (default 1 sec)
    int ready = select(fd+1, &descriptors, NULL, NULL, &tv);
    if(ready < 0){
        RET_F_ERROR(SELECT_ERR);
    }
    // timeout
    if (ready == 0)
        return -2;
    int bytes_read = recv(fd, buff, RECV_BUFFER, 0);
    return bytes_read;
}