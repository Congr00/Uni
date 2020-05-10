#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <limits.h>
typedef struct{
    long dist;
    long cost;
    long long  val;
}p_station;

long          road_l;
unsigned long n     ;
long          tank  ;

unsigned long          r_i = 0;

p_station* stat ;
p_station* deque;
long front = 0;
long back  = 0;
void push_back(p_station p){
    deque[back++] = p;
}
int pop_front(){
    if(++front == back)
        return 0;
    return 1;
}

int pop_back(){
    if(--back == front)
        return 0;
    return 1;
}

int main(){
    scanf("%lu %lu %ld", &n, &road_l, &tank);
    stat  = (p_station*)malloc(sizeof(p_station) * n);
    deque = (p_station*)malloc(sizeof(p_station) * n);

    for(unsigned long i = 0; i < n; ++i){
        scanf("%lu %lu", &stat[i].dist, &stat[i].cost);
        stat[i].val = -1;
    }

    for(unsigned long i = 0; i < n; ++i){      
        if(stat[i].dist - tank <= 0){
            stat[i].val = 0;            
        r_i++;            
        }
        else
            break;
    }

    if(stat[0].val == -1){
        printf("NIE");
        return 0;
    }
    if(tank - road_l >= 0){
        printf("0");
        return 0;
    }
    long long min = -1;
    for(unsigned long i = 0; i < r_i; ++i){
        while(front != back && 
        (deque[back-1].val + deque[back-1].cost >= stat[i].cost + stat[i].val))
            pop_back();
        push_back(stat[i]);
        while(front != back &&
        (deque[front].dist + tank < stat[r_i].dist))
            pop_front();        
        if(stat[i].dist + tank >= road_l){
            if((stat[i].cost + stat[i].val < min) || min == -1)
                min = stat[i].val + stat[i].cost;
        } 
    }
    for(unsigned long i  = r_i; i < n; ++i){
        if(front == back)
            break;
        stat[i].val = deque[front].cost + deque[front].val;
        if(stat[i].dist + tank >= road_l){
            if((stat[i].cost + stat[i].val < min) || min == -1)
                min = stat[i].val + stat[i].cost;
        }
        if(n-1 == r_i)
            break;
        while(front != back && 
        (deque[back-1].val + deque[back-1].cost >= stat[i].cost + stat[i].val))
            pop_back();
        push_back(stat[i]);
        while(front != back &&
        (deque[front].dist + tank < stat[i+1].dist))
            pop_front();
    }
    if(min == -1)
        printf("NIE");
    else
        printf("%lld", min);
    
    return 0;
}