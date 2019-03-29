/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: Andrzej Łukaszewski
plik:       utils.h
*/

#ifndef UTILS_H
#define UTILS_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <arpa/inet.h>
#include <netinet/ip.h>
#include <ctype.h>
#include <errno.h>
#include <stdbool.h>
#include <stdint.h>
#include <unistd.h>
#include <dirent.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#define MAX_PORT    65535
#define MIN_PORT    1
#define DIR_LEN     33
#define BACKLOG     64
#define RECV_BUFFER 1024
#define TIMEOUTS    1

#define FORBIDDEN "HTTP/1.1 403 Forbidden\n\n <h2>Forbidden Content</h2>"
#define NOTIMPL   "HTTP/1.1 501 Not Implemented\n\n<h2>Wrong request</h2>"
#define MOVEDPR   "HTTP/1.1 301 Moved Permanently\r"
#define NOTFND    "HTTP/1.1 404 Not Found\n\n<h2>404 FILE NOT FOUND</h2>"
#define OK        "HTTP/1.1 200 OK"
#define DEFREDIR  "index.html"

#define RET_ERROR(msg)   \
        printf(msg); exit(EXIT_FAILURE);
#define RET_F_ERROR(msg) \
		fprintf(stderr, msg, strerror(errno)); exit(EXIT_FAILURE);


#define WRONG_ARGCNT "Usage: $directory $port\n"
#define WRONG_PORT   "Wrong port number\n"
#define WRONG_DIR    "Wrong directory\n" 
#define RET_F        "%s\n"
#define DIR_TOO_LONG "Directory is too long (max 32 characters)\n"
#define BIND_ERR     "%s\n"
#define LISTEN_ERR   "%s\n"
#define ACCEPT_ERR   "%s\n"
#define SELECT_ERR   "%s\n"
#define CLOSE_ERR    "%s\n"
#define SEND_ERR     "%s\n"

char directory[DIR_LEN];

int   port;
int sockfd;

struct sockaddr_in server_address;

#endif //UTILS_H
