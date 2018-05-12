/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: Andrzej Łukaszewski
plik:       reciver.c
*/

#include "reciver.h"

int recive_package(struct timeval* tv, msg* win, size_t start_pckg){

    fd_set descriptors_;
    FD_ZERO(&descriptors_);
    FD_SET(sockfd, &descriptors_);

    //avoid active waiting using select
    int ready = select(sockfd+1, &descriptors_, NULL, NULL, tv);
    if(ready < 0){
        RET_F_ERROR(SELECT_ERROR);
    }
    // select ran out of time
    if(ready == 0){  
        return -1;
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
        return 0;
    };
    //if diffrent port
    if(ntohs(sender.sin_port) != port){
        return 0;
    }
    //parse data from buffer
    size_t start, size;
    sscanf((char*)buffer, "DATA %lu %lu\n", &start, &size);
    
    // if package from prev window size, throw it
    if((size_t)start / PCKG_SIZE < start_pckg)
        return 0;
    //if package with that number is already recived, throw it
    size_t nr = (start/PCKG_SIZE) % WINDOW_SIZE; 
    if(win[nr].valid){
        return 0;
    }
    // get starting point of data
    size_t rd = 0;
    for(size_t i = 0; i < 19; ++i)
        if((char)buffer[i] == '\n'){
            rd = i+1;
            break;
        }
    win[nr].start = start;
    win[nr].size = size;
    win[nr].valid = true;
    //copy data from buffer to window
    memcpy(win[nr].data, (buffer+rd), win[nr].size);

    return 1;
}
