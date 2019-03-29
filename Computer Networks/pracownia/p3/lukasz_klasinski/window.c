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
    char progress[20];
    sprintf(progress, "%%%.2f\n", ((float)start_pckg / (float)pckg_to_send) * 100);
    size_t k = 0;
    while(start_pckg != end_pckg){
        char tmp[20];
        //print % done
        sprintf(tmp, "%%%.2f\n", ((float)start_pckg / (float)pckg_to_send) * 100);     
        if(strcmp(tmp, progress) != 0){
            printf("%s", progress);  
            memset(progress, 0, strlen(progress));
            strcpy(progress, tmp);
        }     
        //send all packages from window that are missing
        send_pckg(serv_addr);                                   
        //recive packages
        rcv_pckg();
        //write prefix of recived packages
        write_data();
        k++;
    }
}

void rcv_pckg(){

    struct timeval tv;
    tv.tv_sec = 0;
    tv.tv_usec = select_wait;   
    //recive packages till timeval is 0
    while(recive_package(&tv, window, start_pckg) != -1);
}
void write_data(void){
    for(size_t i = start_pckg; i < end_pckg; ++i){
        if(window[i % WINDOW_SIZE].valid){
            //check for errors

            if(fwrite(window[i % WINDOW_SIZE].data, sizeof(char), window[i % WINDOW_SIZE].size, file) != (size_t)window[i % WINDOW_SIZE].size){
                RET_F_ERROR(FWRITE_ERROR);
            }
            window[i % WINDOW_SIZE].valid = false;
            //increase window size
            start_pckg++;
            //increase end till we reach ending package
            if(end_pckg < pckg_to_send)
                end_pckg++;                 
        }
        //write only prefix of ready packages:
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
