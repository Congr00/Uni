/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: Andrzej Łukaszewski
plik:       reciver.c
*/

#include "reciver.h"

msg recive_package(struct timeval* tv, fd_set* descriptors){

    msg package;
    int ready = select(sockfd+1, descriptors, NULL, NULL, tv);
    if(ready < 0){
        RET_F_ERROR(SELECT_ERROR);
    }
    if(ready == 0){
        package.valid = false;
        package.size  = -2;
        return package;
    }
    struct    sockaddr_in  sender        ;	
    socklen_t sender_len = sizeof(sender);
    u_int8_t  buffer[IP_MAXPACKET+1]     ;

    //get awaiting package
    ssize_t datagram_len = recvfrom (sockfd, buffer, IP_MAXPACKET, 0, (struct sockaddr*)&sender, &sender_len);
    if (datagram_len < 0) {
        RET_F_ERROR(RECV_ERROR);
    }
    char sender_ip_str[15];
    //get sender ip address 
    inet_ntop(AF_INET, &(sender.sin_addr), sender_ip_str, sizeof(sender_ip_str));
    
    //if wrong ip package
    if(strcmp(sender_ip_str, SERVER_IP) != 0){
        package.valid = false;
        package.size  = -1;
        return package;
    };
    //if diffrent port
    if(ntohs(sender.sin_port) != port){
        package.valid = false;
        package.size  = -1;
        return package;        
    }

    //buffer += 5; // skip DATA string
    //parse data from buffer
    sscanf((char*)buffer, "DATA %d %d\n", &package.start, &package.size);
    size_t rd = 0;
    for(size_t i = 0; i < 19; ++i)
        if((char)buffer[i] == '\n'){
            rd = i+1;
            break;
        }
    memcpy(package.data, (buffer+rd), package.size);
    package.valid = true;
    //printf("got %d %d\n", package.start, package.size);

    return package;
}
