#include <stdlib.h>
#include <stdio.h>

typedef struct{
    long dist;
    unsigned long cost;
    long          val ;
}p_station;

long          road_l;
unsigned long n     ;
long          tank  ;

unsigned long total_cost = 0;
unsigned long total_l    = 0;

p_station* stat;

int main(){
    scanf("%lu %lu %ld", &n, &road_l, &tank);
    stat = (p_station*)malloc(sizeof(p_station) * n);
    for(unsigned long i = 0; i < n; ++i){
        scanf("%lu %lu", &stat[i].dist, &stat[i].cost);
        stat[i].val = -1;
    }

    for(unsigned long i = 0; i < n; ++i){
        if(stat[i].dist - tank <= 0){
            stat[i].val = 0;
        }
        else
            break;
    }
//    for(unsigned long i = 0; i < n; ++i){
//        printf("STACJA NR:%lu, val:%ld, dist:%lu, cost:%lu\n", i, stat[i].val, stat[i].dist, stat[i].cost);
//    }
    if(stat[0].val == -1){
        printf("NIE");
        return 0;
    }
    if(tank - road_l >= 0){
        printf("0");
        return 0;
    }
    for(unsigned long i = 0; i < n-1; ++i){
        printf("%d\n", i);
        for(unsigned long j = i+1; j < n; ++j){
            if(stat[j].dist - (stat[i].dist + tank) <= 0){
                if(stat[j].val == -1)
                    stat[j].val = stat[i].val + stat[i].cost;
                else if(stat[j].val > stat[i].val + stat[i].cost){
                    stat[j].val = stat[i].val + stat[i].cost;
                }
            }
            else
                break;
        }
    }
    //for(unsigned long i = 0; i < n; ++i){
    //    printf("STACJA NR:%lu, val:%ld, dist:%lu, cost:%lu\n", i, stat[i].val, stat[i].dist, stat[i].cost);
    //}    
    long min = -1;
    long i;
    for(i = n-1; i >= 0; --i){
        if(stat[i].val == -1)
            continue;
        //printf("%d %d %d\n", min, stat[i].val, stat[i].cost);                    
        if(stat[i].dist + tank < road_l)
            break;
        if(min == -1)
            min = stat[i].val + stat[i].cost;
        else if(min > stat[i].val + stat[i].cost)
            min = stat[i].val + stat[i].cost;
    }
    if(min == -1)
        printf("NIE");
    else
        printf("%ld", min);
    return 0;
}