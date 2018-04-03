/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: Andrzej Łukaszewski
plik:       reciver.c
*/

#include "reciver.h"

void create_inet_data_ip(char ip[15], int32_t mask, reg* var){
    u_int32_t ip_bytes, broadcast, subnet = 0u;   
    
    inet_pton(AF_INET, ip, &ip_bytes);
    ip_bytes = endian_swap(ip_bytes) ;

    for(int32_t i = 0; i < mask; ++i)
        subnet += ip_bytes & (FIRST_BYTE >> i);   

    broadcast = subnet;

    for(int32_t i = mask; i < 32; ++i)      
        broadcast += (FIRST_BYTE >> i); 

    subnet    = endian_swap(subnet)   ;  
    broadcast = endian_swap(broadcast);

    inet_ntop(AF_INET, &broadcast, var->broadcast, sizeof(var->broadcast));
    inet_ntop(AF_INET, &subnet   , var->subnet   , sizeof(var->subnet   ));     
}

void create_broadcast(u_int32_t ip, int32_t mask, reg* var){
    u_int32_t broadcast;  
    ip = endian_swap(ip);
    broadcast = ip;
    for(int32_t i = mask; i < 32; ++i)      
        broadcast += (FIRST_BYTE >> i); 
    broadcast = endian_swap(broadcast);
    inet_ntop(AF_INET, &broadcast, var->broadcast, sizeof(var->broadcast));         
}

reg recive_package(void){

    struct    sockaddr_in  sender        ;	
    socklen_t sender_len = sizeof(sender);
    u_int8_t  buffer[IP_MAXPACKET+1]     ;
    reg       package                    ;
    s_package* package_up                ;

    ssize_t datagram_len = recvfrom (_sockfd, buffer, IP_MAXPACKET, 0, (struct sockaddr*)&sender, &sender_len);
    if (datagram_len < 0) {
        fprintf(stderr, RECV_ERROR, strerror(errno)); 
        exit(EXIT_FAILURE);
    }

    char sender_ip_str[15]; 
    inet_ntop(AF_INET, &(sender.sin_addr), sender_ip_str, sizeof(sender_ip_str));
    printf ("Received UDP packet from IP address: %s, port: %d\n", sender_ip_str, ntohs(sender.sin_port));

    buffer[datagram_len] = 0;
    printf ("%ld-byte message: +%s+\n", datagram_len, buffer);
    
    package_up = (s_package*)buffer;
    inet_ntop(AF_INET, &package_up->ip, package.subnet, sizeof(package.subnet));
    package.mask          = (u_int32_t)package_up->mask;
    package.distance      = package_up->distance       ;
    package.last_msg      = ROUND_WAIT                 ;
    package.direct        = false                      ;
    package.broadcast_inf = INF_BR                     ;

    strcpy(package.ip_address, sender_ip_str);
    
    create_broadcast(package_up->ip, package.mask, &package);
    return package;
}

void run_server(semaphore* sem){
    fd_set descriptors;
    FD_ZERO(&descriptors);
    FD_SET(_sockfd, &descriptors);
    struct timeval tv;
    tv.tv_sec = SELECT_WAIT;
    tv.tv_usec = 0.f;
    while(1){
        if(tv.tv_sec == 0){
            wait_s();
            update_reg(sem);              
            signal_s();
            tv.tv_sec = SELECT_WAIT;
        }
        reg package;
        //select checks if there is a package awaiting in a buffer
        int ready = select(_sockfd+1, &descriptors, NULL, NULL, &tv);
        if(ready < 0){
            fprintf(stderr, SELECT_ERROR, strerror(errno));
            exit(EXIT_FAILURE);
        }
        else if(ready == 0)
            continue;
        package = recive_package();
        wait_s();
        insert_reg(sem, package);
        signal_s();
    }
}

void insert_reg(semaphore* sem, reg r){
    for(uint32_t i = 0; i < sem->_route_cnt; ++i){
        if(sem->_route_tbl[i].broadcast_inf != LOST || sem->_route_tbl[i].direct)
            if(strcmp(r.subnet, sem->_route_tbl[i].subnet)){
                if(sem->_route_tbl[i].distance > r.distance)
                    sem->_route_tbl[i].distance = r.distance;
                sem->_route_tbl[i].last_msg = ROUND_WAIT;
                strcpy(sem->_route_tbl[i].ip_address, r.ip_address);
                strcpy(sem->_route_tbl[i].broadcast, r.broadcast);
                sem->_route_tbl[i].mask = r.mask;
                sem->_route_tbl[i].broadcast_inf = r.broadcast_inf;
                return;
            }
    }
    resize_reg(sem);
    sem->_route_tbl[sem->_route_cnt++] = r;  
}

void resize_reg(semaphore* sem){
    if(sem->_route_cnt == sem->_route_len){
        sem->_route_tbl = (reg*)realloc(sem->_route_tbl, sizeof(reg) * 2 * sem->_route_len);
        if(sem->_route_tbl == NULL){
            fprintf(stderr, "%s\n", strerror(errno));
            exit(EXIT_FAILURE);                    
        }
        sem->_route_len *= 2;
    }
}

void update_reg(semaphore* sem){
    for(uint32_t i = 0; i < sem->_route_cnt; ++i){
        if(sem->_route_tbl[i].last_msg == 0)
            continue;
        if(sem->_route_tbl[i].distance != INF)
            if(--sem->_route_tbl[i].last_msg == 0)
                sem->_route_tbl[i].distance = INF;
    }
}