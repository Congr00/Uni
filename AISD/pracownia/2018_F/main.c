#include <stdio.h>
#include <stdlib.h>

typedef unsigned int ui;

typedef struct{
    ui x;
    ui y;
    ui val;
}pair;

typedef struct{
    ui val;
    ui r;
}rpr;


void check_neib(ui x, ui y, pair ch, ui max);

rpr  isl [1000000];
pair srt [1000000];
ui   islc[1000000];
ui   yr  [100000];

ui icnt = 0;
ui m, n, t;

ui indx(ui x, ui y){
    return x*m + y;
}

ui fnd(rpr a){
    if(isl[a.r].r == a.r)
        return a.r;
    ui fna = fnd(isl[a.r]);
    isl[a.r].r = fna;
    return fna;
}

int uni(rpr a, rpr b){
    ui fna = fnd(a);
    ui fnb = fnd(b);
    if(fna == fnb) 
        return 0;
    if(islc[fna] <= islc[fnb]){
        islc[fnb] += islc[fna];
        isl[fna].r = fnb;
        return 1;
    }
    islc[fna] += islc[fnb];
    isl[fnb].r = fna;
    return 1;
}

int cmp(const void* a, const void* b){
    if(((pair*)a)->val > ((pair*)b)->val)
        return -1;
    else if(((pair*)a)->val == ((pair*)b)->val)
        return 0;
    return 1;
}

int main(){
    // get input
    scanf("%u %u\n", &n, &m);
    ui i;
    for(i = 0; i < n; ++i)
        for(ui j = 0; j < m; ++j){
            rpr tmpr;
            scanf("%u ", &tmpr.val);
            tmpr.r = indx(i, j);
            isl[indx(i, j)] = tmpr;
            pair tmp;
            tmp.x = i;
            tmp.y = j;
            tmp.val = isl[indx(i, j)].val;
            srt[indx(i, j)] = tmp;
            islc[indx(i, j)] = 1;
        }
    scanf("%u", &t);
    for(i = 0; i < t; ++i)
        scanf("%u ", &yr[i]);

    qsort(srt, n*m, sizeof(pair), cmp);
    i = t-1;
    ui j = 0;
    while(1){
        ui tmp = j;
        while(1){
            if(srt[tmp].val <= yr[i])
                break;
            else
                icnt++;
            tmp++;
            if(tmp == n*m)
                break;
        }
        while(1){         
            if(srt[j].val <= yr[i]){           
                yr[i] = icnt;                
                break;
            }
            if(srt[j].x > 0){ // check up
                check_neib(srt[j].x-1, srt[j].y, srt[j], yr[i]);
            }
            if(srt[j].x < n - 1){ // check down
                check_neib(srt[j].x+1, srt[j].y, srt[j], yr[i]);        
            }
            if(srt[j].y > 0){ // check left
                check_neib(srt[j].x, srt[j].y-1, srt[j], yr[i]);
            }
            if(srt[j].y < m - 1){ // check right
                check_neib(srt[j].x, srt[j].y+1, srt[j], yr[i]);
            }
            j++;
            if(j == n*m){
            yr[i] = icnt;                               
                break;
            }
        }
        if(i == 0)
            break;   
        i--;
    }

    //print output    
    for(i = 0; i < t; ++i)
        printf("%u ", yr[i]);
    
    return 0;
}

void check_neib(ui x, ui y, pair ch, ui max){
    if(isl[indx(x, y)].val > max){
        if(uni(isl[indx(x, y)], isl[indx(ch.x, ch.y)]))
            icnt--; // if the werent concatenated, island count down
    }
}