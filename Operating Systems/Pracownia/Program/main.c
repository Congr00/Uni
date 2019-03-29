/*
@author Łukasz Klasiński
@date   18/01/30
@topic  Using Semaphores in philosophers problem
*/
#include <sys/types.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <sys/mman.h>
#include <stdbool.h>

typedef struct{
    int val;
    char file[20];
    bool stolen;
    bool dirty;
} semaphore;

static semaphore** mox;

int wait_s(semaphore* s, semaphore* holder){
    s->stolen = true;
    if(holder != NULL){
        while(s->val <= 0){
            if(holder->stolen && !holder->dirty)
                return false;
        }
    }
    else{
        while(s->val <= 0);
    }
    s->val--;
    s->stolen = false;
    return true;
}

void signal_s(semaphore* s){
    s->val++;
}

int rand_num(int a, int b){
    return (rand() % (b + 1 - a)) + a;
}

void run_process(int i, semaphore* s1, semaphore* s2, int min, int max, int iterate){
    while(iterate-- != 0){
        usleep(rand_num(min, max));
        wait_s(s1, NULL);
        // got access to file 1
        while(true){
            if(wait_s(s2, s1))
                break;
            else{
                s1->dirty = false;
                signal_s(s1);
                wait_s(s1, NULL);
            }
        }
        // got access to file 2
        usleep(rand_num(min, max));     // holding files        
        FILE *fp = fopen(s1->file, "a+");
        fprintf(fp, "process %d eated this file!\n", i);
        fclose(fp);
        fp = fopen(s2->file, "a+");
        fprintf(fp, "process %d eated this file!\n", i);
        fclose(fp);
        printf("process %d eated!\n", i);
        s1->dirty = true;
        s2->dirty = true;
        if(s1->stolen)
            s1->dirty = false;
        if(s2->stolen)
            s2->dirty = false;
        signal_s(s1);
        signal_s(s2);   
    }
    exit(EXIT_SUCCESS);
}

int main(int argc, char** argv){
    int procn = 0;
    int min = 0;
    int max = 0;
    int iterate = -1;
    if(argc >= 4){
        procn = atoi(argv[1]);
        min   = atoi(argv[2]);
        max   = atoi(argv[3]);
    }
    else{
        printf("need at least 3 arguments");
        return EXIT_FAILURE;
    }
    if(argc >= 5){
        iterate = atoi(argv[4]);
    }
        

    int *forkid = (int*)malloc(sizeof(int)*procn);
    mox = mmap(NULL, sizeof(semaphore*)*procn, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);

    for(int i = 0; i < procn; i++){
        *(mox+i) = (semaphore*)malloc(sizeof(semaphore));
        (*(mox+i))->val = 1;
        sprintf((*(mox+i))->file, "file_%d.txt", i);
        FILE *fp = fopen((*(mox+i))->file, "w+");
        fclose(fp);
        (*(mox+i))->stolen = false;
        (*(mox+i))->dirty  = true;
    }
    for(int i = 0; i < procn; i++){
        int pid = fork();
        if(pid < 0){
            exit(EXIT_FAILURE);
        }
        if(!pid){
            // process
            srand(time(NULL)+i);            
            run_process(i, *(mox+i), *(mox+(((i-1)%procn)+procn)%procn), min, max, iterate);
        }
        else{
            forkid[i] = pid;
            //parent
        }
    }
    char c;
    while(true){
        scanf("%c", &c);
        if(c == 'e')
        {
            for(int i = 0; i < procn; ++i){
                free(*(mox+i));
                kill(forkid[i], SIGKILL);
            }
            munmap(mox, sizeof(semaphore*)*procn);
            printf("processes killed, exiting!\n");
            return EXIT_SUCCESS;
        }
    }
}