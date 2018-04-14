/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: Andrzej Łukaszewski
plik:       reciver.c
*/

#include "reciver.h"

#include "sender.h"

void create_inet_data_ip(char ip[15], int32_t mask, reg* var){
    u_int32_t ip_bytes, broadcast, subnet = 0u;   
    //change string to bytes
    inet_pton(AF_INET, ip, &ip_bytes);
    //swap couse inet is in BIG_ENDIAN
    ip_bytes = ntohl(ip_bytes) ;
    //calculate subnet address
    for(int32_t i = 0; i < mask; ++i)
        subnet += ip_bytes & (FIRST_BYTE >> i);   

    broadcast = subnet;
    //calculate broadcast address
    for(int32_t i = mask; i < 32; ++i)      
        broadcast += (FIRST_BYTE >> i); 

    //change back into BIG ENDIAN
    subnet    = htonl(subnet)   ;  
    broadcast = htonl(broadcast);
    //convert to bytes
    inet_ntop(AF_INET, &broadcast, var->broadcast, sizeof(var->broadcast));
    inet_ntop(AF_INET, &subnet   , var->subnet   , sizeof(var->subnet   ));     
}

void create_broadcast(u_int32_t ip, int32_t mask, reg* var){
    u_int32_t broadcast;  
    ip = htonl(ip);
    broadcast = ip;
    for(int32_t i = mask; i < 32; ++i)      
        broadcast += (FIRST_BYTE >> i); 
    broadcast = ntohl(broadcast);
    inet_ntop(AF_INET, &broadcast, var->broadcast, sizeof(var->broadcast));         
}

reg recive_package(void){

    struct    sockaddr_in  sender        ;	
    socklen_t sender_len = sizeof(sender);
    u_int8_t  buffer[IP_MAXPACKET+1]     ;
    reg       package                    ;
    s_package* package_up                ;
    //get awaiting package
    ssize_t datagram_len = recvfrom (_sockfd, buffer, IP_MAXPACKET, 0, (struct sockaddr*)&sender, &sender_len);
    if (datagram_len < 0) {
        fprintf(stderr, RECV_ERROR, strerror(errno)); 
        exit(EXIT_FAILURE);
    }

    char sender_ip_str[15];
    //get sender ip address 
    inet_ntop(AF_INET, &(sender.sin_addr), sender_ip_str, sizeof(sender_ip_str));
    buffer[datagram_len] = 0;
    //parse data from buffer
    package_up = (s_package*)buffer;
    
    inet_ntop(AF_INET, &package_up->ip, package.subnet, sizeof(package.subnet));
    package.mask          = (u_int32_t)package_up->mask;
    package.distance      = ntohl(package_up->distance);
    package.last_msg      = ROUND_WAIT                 ;
    package.direct        = false                      ;
    package.broadcast_inf = INF_BR                     ;

    strcpy(package.ip_address, sender_ip_str);
    //create table reg
    create_broadcast(package_up->ip, package.mask, &package);
    return package;
}

void run_server(void){
    fd_set descriptors;
    FD_ZERO(&descriptors);
    FD_SET(_sockfd, &descriptors);
    struct timeval tv;
    tv.tv_sec = SELECT_WAIT;
    tv.tv_usec = 0.f;
    while(1){    
        //if end of round
        if(tv.tv_sec == 0){
            wait_s();
            //update infs
            update_reg();         
            signal_s();
            //stupid but doesnt work otherwise ???
            FD_ZERO(&descriptors);
            FD_SET(_sockfd, &descriptors);            
            struct timeval tv2;
            tv2.tv_sec = SELECT_WAIT;
            tv2.tv_usec = 0.f       ;   
            tv = tv2                ;     
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
        //there is a package so get it
        package = recive_package();
        wait_s();
        //insert new or edit existing reg       
        insert_reg(package);      
        signal_s();    
    }
}

void insert_reg(reg r){ 
    // if package if from our ip discard it
    if(!not_mine(r.ip_address))
        return;
    // 'guess' from which direct subnet orginates ip (via prefix) 
    reg dst = get_dist(r.ip_address);   

    for(uint32_t i = 0; i < __semaphore->_route_cnt; ++i){
        if(__semaphore->_route_tbl[i].broadcast_inf != LOST || 
        __semaphore->_route_tbl[i].direct == true){
            if(!strcmp(r.subnet, __semaphore->_route_tbl[i].subnet)){
                // reconnected to interface
                if(!strcmp(dst.subnet, r.subnet) && __semaphore->_route_tbl[i].direct){
                    if(__semaphore->_route_tbl[i].broadcast_inf == LOST){                   
                        for(uint32_t j = 0; j < __semaphore->_route_cnt; ++j){
                            if(i != j && (__semaphore->_route_tbl[j].broadcast_inf != LOST)){
                                if(!strcmp(r.subnet, __semaphore->_route_tbl[j].subnet)){
                                    __semaphore->_route_tbl[j].broadcast_inf = LOST;
                                    break;
                                }
                            }
                        }
                    }
                    __semaphore->_route_tbl[i].broadcast_inf = INF_BR;
                    __semaphore->_route_tbl[i].last_msg      = ROUND_WAIT;             
                    __semaphore->_route_tbl[i].distance      = __semaphore->_route_tbl[i].distance_d;       
                    return;
                }
                if(r.distance == INF){
                    // if inf is from our 'via'
                    if(!strcmp(r.ip_address, __semaphore->_route_tbl[i].ip_address)){
                        __semaphore->_route_tbl[i].distance = INF;
                    }
                    return;
                }

                // shorter path exists
                if(__semaphore->_route_tbl[i].distance > r.distance + dst.distance){
                    //if direct network is inf, look for a way around
                    if(__semaphore->_route_tbl[i].direct && __semaphore->_route_tbl[i].distance == INF){
                      for(uint32_t j = 0; j < __semaphore->_route_cnt; ++j){
                            if(i != j && __semaphore->_route_tbl[j].broadcast_inf != LOST){
                                if(!strcmp(r.subnet, __semaphore->_route_tbl[j].subnet)){
                                    // if such a value exists, update its info(we found shorter path)
                                    __semaphore->_route_tbl[i].distance = r.distance + dst.distance;
                                    strcpy(__semaphore->_route_tbl[i].ip_address, r.ip_address);
                                    strcpy(__semaphore->_route_tbl[i].broadcast, r.broadcast);
                                    __semaphore->_route_tbl[i].mask = r.mask; 
                                    __semaphore->_route_tbl[i].broadcast_inf = INF_BR;  
                                    __semaphore->_route_tbl[i].last_msg = ROUND_WAIT;                                  
                                    return;
                                }
                            }
                        }
                        break;
                    }
                    // we broadcast infs for a few turns before changing it to alternative path
                    if(__semaphore->_route_tbl[i].broadcast_inf > 0 && __semaphore->_route_tbl[i].distance == INF){
                        return;
                    }
                    __semaphore->_route_tbl[i].distance = r.distance + dst.distance;
                    strcpy(__semaphore->_route_tbl[i].ip_address, r.ip_address);
                    strcpy(__semaphore->_route_tbl[i].broadcast, r.broadcast);
                    __semaphore->_route_tbl[i].mask = r.mask; 
                    __semaphore->_route_tbl[i].broadcast_inf = INF_BR;  
                    __semaphore->_route_tbl[i].last_msg = ROUND_WAIT;                 
                }
                // connecting update from same address
                else if(__semaphore->_route_tbl[i].distance == r.distance + dst.distance && 
                !strcmp(__semaphore->_route_tbl[i].ip_address, r.ip_address)){
                    __semaphore->_route_tbl[i].last_msg = ROUND_WAIT;
                }

                return;
            }

        }
    }
    // we dont want to write infs
    if(r.distance == INF)
        return;
    // add new entry
    r.distance += dst.distance;
    resize_reg();   
    __semaphore->_route_tbl[__semaphore->_route_cnt++] = r;
  
}

void resize_reg(void){
    if(__semaphore->_route_cnt == __semaphore->_route_len){
    reg* t = (reg*)mmap(NULL, sizeof(reg) * __semaphore->_route_len*2, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, 0, 0);
    if(t == MAP_FAILED){
        fprintf(stderr, MMAP_ERROR, strerror(errno));
        exit(EXIT_FAILURE);       
    }        
        __semaphore->_route_tbl = (reg*)realloc(__semaphore->_route_tbl, sizeof(reg) * 2 * __semaphore->_route_len);
        if(__semaphore->_route_tbl == NULL){
            fprintf(stderr, "%s\n", strerror(errno));
            exit(EXIT_FAILURE);                    
        }
        __semaphore->_route_len *= 2;
    }
}

void update_reg(void){
    for(uint32_t i = 0; i < __semaphore->_route_cnt; ++i){
        if(__semaphore->_route_tbl[i].last_msg == 0)
            continue;
        if(__semaphore->_route_tbl[i].distance != INF && __semaphore->_route_tbl[i].direct == false)
            if(--__semaphore->_route_tbl[i].last_msg == 0){
                __semaphore->_route_tbl[i].distance = INF;        
            }
    }
}

reg get_dist(char ip[15]){
    int max = 0       ;
    int max_index = -1;

    for(uint32_t i = 0; i < __semaphore->_route_cnt; ++i){
        int tmp = 0;
        if((__semaphore->_route_tbl[i].direct) == false)
            continue;
        for(uint32_t j = 0; j < 15; ++j){
            if(ip[j] == __semaphore->_route_tbl[i].ip_address[j])
                tmp++;
        }
        if(tmp > max){
            max_index = i;
            max = tmp    ;
        }
    }
    //just in case
    if(max_index == -1){
        reg tmp               ;
        tmp.broadcast_inf = -1;
        return tmp;
    }
    return __semaphore->_route_tbl[max_index];
}