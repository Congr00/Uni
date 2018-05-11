/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: Andrzej Łukaszewski
plik:       window.c
*/

#include "window.h"

void download_file(struct sockaddr_in* serv_addr){
    start_pckg = 0;
    pckg_to_send = (file_size / PCKG_SIZE);
    if(pckg_to_send * PCKG_SIZE != (size_t)file_size)
        pckg_to_send++;

    if(pckg_to_send < WINDOW_SIZE)
        end_pckg = pckg_to_send;
    else
        end_pckg = WINDOW_SIZE;
    //set default values for window
    for(size_t i = start_pckg; i < end_pckg; ++i){
        window[i].valid = false;
        window[i].start = i * PCKG_SIZE;
    }
    //set descriptor
    fd_set descriptors;
    FD_ZERO(&descriptors);
    FD_SET(sockfd, &descriptors);

    size_t k = 0;
    while(start_pckg != end_pckg){
        //print % done
        puts("");
        if(!(k % 10))
            printf("%%%f\n", ((float)start_pckg / (float)pckg_to_send) * 100);   
        //send all packages from window that are missing
        send_pckg(serv_addr);
        //recive packages
        rcv_pckg(&descriptors);
        //write prefix of recived packages
        write_data();
        k++;
    }
}

void rcv_pckg(fd_set* descriptors){

    struct timeval tv;
    tv.tv_sec = 0;
    tv.tv_usec = select_wait;   
    msg pckg;
    pckg.valid = false;
    pckg.size = -1;

    //recive packages till timeval is 0
    while(!pckg.valid && pckg.size != -2){
        pckg = recive_package(&tv, descriptors);
        //if package from good ip and port
        if(pckg.valid){
            //check is package is outdated
            if((size_t)pckg.start / PCKG_SIZE < start_pckg)
                continue;
            size_t nr = (pckg.start/PCKG_SIZE) % WINDOW_SIZE;          
            window[nr] = pckg;
            window[nr].valid = true;
        }
    } 
}
void write_data(void){
    for(size_t i = start_pckg; i < end_pckg; ++i){
        if(window[i % WINDOW_SIZE].valid){
            //check for errors
            fwrite(window[i % WINDOW_SIZE].data, sizeof(char), window[i % WINDOW_SIZE].size, file);
            window[i % WINDOW_SIZE].valid = false;
            start_pckg++;
            if(end_pckg < pckg_to_send)
                end_pckg++;
        }
        //send only prefix of ready packages
        else
            break;
    }
}

void send_pckg(struct sockaddr_in* serv_addr){
    for(size_t i = start_pckg; i < end_pckg; ++i)
        if(!window[i % WINDOW_SIZE].valid){    
            if(PCKG_SIZE*(i+1) <= (size_t)file_size)
                send_package(i*PCKG_SIZE, PCKG_SIZE, serv_addr);
            //send last not full sized package
            else
                send_package(i*PCKG_SIZE, 
                (PCKG_SIZE - ((i+1)*PCKG_SIZE - file_size)), serv_addr); 
        }              
}
