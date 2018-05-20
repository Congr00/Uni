/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: Andrzej Łukaszewski
plik:       main.c
description: 
Implementation of simple http server
*/

#include "utils.h"
#include "sender.h"
#include "reciver.h"

void parse_args(int argc, char** argv);

int main(int argc, char** argv){
    // parse args
    parse_args(argc, argv);

    // init socket to listen on port from argument
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    bzero (&server_address, sizeof(server_address));
    server_address.sin_family      = AF_INET;
    server_address.sin_port        = htons(port);
    server_address.sin_addr.s_addr = htonl(INADDR_ANY);
    // bind socket to port
    if(bind(sockfd, (struct sockaddr*)&server_address, sizeof(server_address)) < 0){
        RET_F_ERROR(BIND_ERR);
    }
    // listen to on port
    if(listen(sockfd, BACKLOG) < 0){
        RET_F_ERROR(LISTEN_ERR);
    }

    // main loop
    while(true){
        struct sockaddr_in client_address;
        socklen_t len = sizeof(client_address);
        int conn_sockfd;
        // wait for connection 
        if ( (conn_sockfd = accept(sockfd, (struct sockaddr*)&client_address, &len)) < 0){
            RET_F_ERROR(ACCEPT_ERR);
        }
        // process client request
        int res;
        // msg buffer - default 1024B
        char buffer[RECV_BUFFER];
        // recive data till we get timeout (1 sec)
        while((res = recive_data(conn_sockfd, buffer)) != -2){
            // send response
            send_data(conn_sockfd, buffer);
            // if Connection field is set to close end connection
            if(strstr(buffer, "Connection: close") != NULL)
                break;
        }
        // close connection
        if(close(conn_sockfd) < 0){
            RET_F_ERROR(CLOSE_ERR);
        }

    }

    return EXIT_SUCCESS;
}

void parse_args(int argc, char** argv){
    if(argc != 3){
        RET_ERROR(WRONG_ARGCNT);
    }
    // port in range
    port = atoi(argv[1]);
    if(port < MIN_PORT || port > MAX_PORT){
        RET_ERROR(WRONG_PORT);
    }

    DIR* dir = opendir(argv[2]);
    if (dir)
        // Directory exists
        closedir(dir);
    else if (ENOENT == errno){
        // Directory does not exist       
        RET_ERROR(WRONG_DIR);
    }
    else{
        // opendir() failed
        RET_F_ERROR(RET_F);
    }    
    if(strlen(argv[2]) > 32){
        RET_ERROR(DIR_TOO_LONG);
    }
    strcpy(directory, argv[2]);
}