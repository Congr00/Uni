/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: Andrzej Łukaszewski
plik:       main.c
description:
Implementation of TCP transport protocol using UDP
*/

#include "window.h"

void  parse_arg(int argc, char** argv);
float timediff (struct timeval t0, struct timeval t1);

int main(int argc, char** argv ){
    //parse arguments
    file_name[0] = '\0';    
    parse_arg(argc, argv);    
    select_wait = 500000.0f; // 1 sec

    //create socket
	sockfd = socket(AF_INET, SOCK_DGRAM, 0);
	if (sockfd < 0) {
        RET_F_ERROR(SOCKET_ERROR);
	} 

    //create server info for sender
	struct sockaddr_in server_address;
	bzero (&server_address, sizeof(server_address));
	server_address.sin_family      = AF_INET;
	server_address.sin_port        = htons(port);
	server_address.sin_addr.s_addr = htonl(INADDR_ANY);
	inet_pton(AF_INET, SERVER_IP, &server_address.sin_addr);    

    //bind for udp
	if (bind (sockfd, (struct sockaddr*)&server_address, sizeof(server_address)) < 0) {
        RET_F_ERROR(BIND_ERROR);
	}
    //create file for write
    file = fopen(file_name, "w");
    if(file == NULL){
        RET_F_ERROR(FILE_ERROR);
    }

    //calculate total downlaod time
    struct timeval start, stop;
    gettimeofday(&start, NULL);

    download_file(&server_address);

    gettimeofday(&stop, NULL);
    char byte_type[3];
    int file_b;
    if(file_size < 1024){
        file_b = file_size;
        strcpy(byte_type, "B");
    }
    else if(file_size < 1024*1024){
        file_b = file_size / 1024;
        strcpy(byte_type, "MB");
    }
    else{
        file_b = (file_size / 1024) / 1024;
        strcpy(byte_type, "GB");
    }
    printf("sent %d %s in %fs\n", file_b, byte_type, timediff(stop, start));
    close(sockfd);
    fclose(file);
    return EXIT_SUCCESS;
}
void parse_arg(int argc, char** argv){
    if(argc != 4){
        RET_ERROR(WRONG_ARGCNT);
    }
    port = atoi(argv[1]);
    if(port < MIN_PORT || port > MAX_PORT){
        RET_ERROR(WRONG_PORT);
    }
    strcpy(file_name, argv[2]);
    if(file_name[0] == '\0'){
        RET_ERROR(WRONG_FILENAME);
    }

    file_size = atoi(argv[3]);
    if(file_size < 1){
        RET_ERROR(WRONG_FILESIZE);
    } 
}

float timediff(struct timeval t0, struct timeval t1){
    return (t1.tv_sec - t0.tv_sec) * 1000.0f + (t1.tv_usec - t0.tv_usec) / 1000.0f;
}