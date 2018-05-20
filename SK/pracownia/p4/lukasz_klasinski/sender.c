/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: Andrzej Łukaszewski
plik:       sender.c
*/

#include "sender.h"

void send_data(int fd, char* buff){
    // generate response msg
    int res = (int)generate_resp(buff);
    // send package
    if (send(fd, resp_msg, res, 0) < res){
        RET_F_ERROR(SEND_ERR);
    }
    // release memory
    free(resp_msg);
}

int generate_resp(char* buff){
    char file_dir[64] = "\0";
    char https[64];
    char content_type[64] = "Content-Type: ";
    char http_type[64];
    char domain[64] = "\0";
    char file_domain[64];
    char content_len[64];
    
    sscanf(buff, "GET %s %s\r\nHost: %s", file_dir, https, domain);
    printf("request: %s\nhttps: %s\ndomain: %s\n\n", file_dir, https, domain);

    //remove port from domain
    for(size_t i= 0; i < strlen(domain); ++i){
        if(domain[i] == ':')
            file_domain[i] = '\0';
        else
            file_domain[i] = domain[i];
    }
    
    // check if implemented
    if((strcmp(https, "HTTP/1.1") != 0 && 
       strcmp(https, "HTTP/1.0") != 0  &&
       strcmp(https, "HTTP/2")   != 0) || 
       strcmp(domain  , "\0") == 0     ||
       strcmp(file_dir, "\0") == 0){
        //return Not implemented
        resp_msg = (char*)malloc(sizeof(NOTIMPL));     
        strcpy(resp_msg, NOTIMPL);      
        return strlen(resp_msg);
    }

    // check if there is ../
    char* rch = strstr(file_dir, "../");
    // if outside of domen, return forbidden msg  
    if(rch != NULL){ 
        resp_msg = (char*)malloc(sizeof(FORBIDDEN));          
        strcpy(resp_msg, FORBIDDEN);
        return strlen(resp_msg);
    }

    // find lass occurence of . to get type of file
    rch = strrchr(file_dir, (int)'.');

    if(rch == NULL)
    // it's binary file
        strcat(content_type, "application/octet-stream");   
    // set content type
    else if(!strcmp(rch, ".txt"))
        strcat(content_type, "text");
    else if(!strcmp(rch, ".html"))
        strcat(content_type, "text/html");
    else if(!strcmp(rch, ".css"))
        strcat(content_type, "text/css");
    else if(!strcmp(rch, ".jpg")) 
        strcat(content_type, "image/jpg");
    else if(!strcmp(rch, ".jpeg")) 
        strcat(content_type, "image/jpeg");    
    else if(!strcmp(rch, ".png"))
        strcat(content_type, "image/png");
    else if(!strcmp(rch, ".pdf"))
        strcat(content_type, "application/pdf");
    else
        // everything else is also binary file
        strcat(content_type, "application/octet-stream");     

    char file_path[64]; // check for sizes
    sprintf(file_path, "%s%s%s", directory, file_domain, file_dir);
    //if dir, redirect to default index.html
    if(is_dir(file_path)){        
        char tmp[64];
        sprintf(tmp, "Location: http://%s/%s\r", domain, DEFREDIR);
        resp_msg = (char*)malloc(sizeof(MOVEDPR) + 5 + strlen(tmp)); 
        sprintf(resp_msg, "%s\n%s\n\r\n", MOVEDPR, tmp);;
        return strlen(resp_msg);
    }
    else
        // else itss default response
        strcpy(http_type, OK);

    // load file size
    struct stat st;
    int fd = open(file_path, O_RDONLY);
    if (fd == -1){
        //file doesnt exist return 404        
        resp_msg = (char*)malloc(sizeof(NOTFND));                  
        strcpy(resp_msg, NOTFND);  
        return strlen(resp_msg);
    }
    if(fstat(fd, &st) < 0){
        RET_F_ERROR("%s\n");
    }
    // get file size
    off_t file_size = st.st_size;
    // calculate total pckg size
    int pckg_size = strlen(http_type) + strlen(content_type) + 3 + file_size;
    // create string from file size
    char tmp[32];
    sprintf(tmp, "%ld", file_size);
    // increase pckg size by it
    pckg_size += 16 + 1 + strlen(tmp);
    // create content-length field
    sprintf(content_len, "Content-Length: %ld", file_size);
    // malloc memory for buffer
    resp_msg = (char*)malloc(pckg_size);  
    // create response message   
    sprintf(resp_msg, "%s\n%s\n%s\n\n", http_type, content_type, content_len);    
    // load file at the end of buffor
    if((file_to_buff(&resp_msg, fd, file_size, pckg_size-file_size)) == 0){
        //file doesnt exist return 404      
        strcpy(resp_msg, NOTFND);         
        return strlen(resp_msg);
    }
    return pckg_size;
}
// check if path is an existing directory
int is_dir(const char *path) {
   struct stat statbuf;
   if (stat(path, &statbuf) != 0)
       return 0;
   return S_ISDIR(statbuf.st_mode);
}

// load whole file to buffer
int file_to_buff(char** buff, int fd, int file_size, int offset){
    FILE* fp = fdopen(fd, "r");
    if (fp == NULL)
        return 0;  
    fread((*buff)+offset, 1, file_size, fp); 
    return (int)file_size;
}