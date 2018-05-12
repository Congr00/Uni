/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: Andrzej Łukaszewski
plik:       utils.h
*/

#ifndef UTILS_H
#define UTILS_H

#include <netinet/ip.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <stdbool.h>
#include <sys/time.h>


//config values
#define SERVER_IP   "156.17.4.30"
#define MAX_PORT    65535
#define MIN_PORT    1
#define WINDOW_SIZE 1000
#define PCKG_SIZE   1000
float select_wait;


#define RET_ERROR(msg)   \
        printf(msg); exit(EXIT_FAILURE);
#define RET_F_ERROR(msg) \
		fprintf(stderr, msg, strerror(errno)); exit(EXIT_FAILURE);

#define RECV_ERROR     "recvfrom error: %s\n"
#define SELECT_ERROR   "select error:%s\n"
#define SOCKET_ERROR   "Socket error: %s\n"
#define BIND_ERROR     "Bind error: %s\n"
#define WRONG_ARGCNT   "Wrong agrument count\n"
#define WRONG_PORT     "Wrong port number\n"
#define WRONG_FILENAME "Wrong file name\n"
#define WRONG_FILESIZE "Wrong file size\n"
#define FWRITE_ERROR   "%s\n"
#define FILE_ERROR     "%s\n"

//package struct
typedef struct{
    int start;
    int size;
    char data[1000];
    bool valid;
}msg;

int   port;
int   file_size;
char  file_name[32];
int   sockfd;
FILE* file;

#endif //UTILS_H