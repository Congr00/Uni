#include <stdio.h>
#include <stdlib.h>

typedef struct{
    unsigned long a1;
    unsigned long a2;
    long i;
    unsigned long w;
    int o;
} coords;

typedef struct{
    coords a1;
    coords a2;
} tunnel;

unsigned long cnt = 0;
unsigned long qi  = 0;
unsigned long dnsc = 0;
long* queue;
coords* dnsq;
tunnel* tunnels;
coords* neib;
coords* inde;
unsigned long* id;
unsigned long* length;
unsigned long* padding;
coords tmp;
unsigned long t = 0;
unsigned long ptr;
unsigned long idf;
void push(coords c){
    dnsq[--dnsc] = c;
}
int pop(){
    if(dnsc == t*2)
        return 0;
    tmp = dnsq[dnsc++];
    return 1;
}

void add(coords c){
    queue[ptr--] = c.i;
}

void printc(coords c){
    printf("(%lu, %lu), id:%ld, w: %lu\n", c.a1, c.a2, c.i, c.w);
}

void topol2(coords s){
    if(inde[s.i].o == -1){
        inde[s.i].o = 0;
    }else
        return;
    for(unsigned int i = id[s.i]; i < id[s.i]+length[s.i]; ++i){     
        if(inde[neib[i].i].o == -1)   
            topol2(neib[i]);        
    }
    add(s);
}

void topol(coords s){     
    push(s);        
    while(pop()){          
        if(tmp.o == -2){       
            add(tmp);
            continue;
        }
        if(inde[tmp.i].o == -1){
            inde[tmp.i].o = 0;
        }  
        else
            continue;
        tmp.o = -2;
        push(tmp);      
        if(tmp.i >= t)
            continue;                            
        for(unsigned int i = id[tmp.i]; i < id[tmp.i]+length[tmp.i]; ++i){     
            if(inde[neib[i].i].o == -1)           
                push(neib[i]);
        }
    }  
}
void top(){
    if(queue[ptr+1] != -1 || queue[ptr+1] < t){
        for(unsigned long j = id[queue[ptr+1]]; j < id[queue[ptr+1]] + length[queue[ptr+1]]; ++j){
            inde[neib[j].i].w = 1;
        }  
    }
    for(unsigned long i = ptr+2; i < t*2; ++i){
        if(queue[i] != -1 && queue[i] < t)
            for(unsigned long j = id[queue[i]]; j < id[queue[i]] + length[queue[i]]; ++j){    
                inde[neib[j].i].w += inde[queue[i]].w;
                inde[neib[j].i].w %= 999979;
            }
    }
}

int comp(const void* a, const void* b);
int comp2(const void* a, const void* b);
int main(){
     
    unsigned long long m, n, i;
    scanf("%llu %llu %lu", &m, &n, &t);
     
    ptr = t*2 - 1;
    idf = 0;
    dnsc = t*2;
     
    tunnels = (tunnel*)(malloc(sizeof(tunnel) * t));
    neib = (coords*)(malloc(sizeof(coords) * t));
    inde = (coords*)(malloc(sizeof(coords) * (t*2)));
    id = (unsigned long*)(calloc(sizeof(unsigned long), t));
    length = (unsigned long*)(calloc(sizeof(unsigned long), t));
    padding = (unsigned long*)(calloc(sizeof(unsigned long), t)); 
     
    for(i = 0; i < t; ++i){
        scanf("%lu %lu %lu %lu", &tunnels[i].a1.a1, &tunnels[i].a1.a2, &tunnels[i].a2.a1, &tunnels[i].a2.a2);
        tunnels[i].a1.i = -1;
        tunnels[i].a2.i = -1;
        inde[i].i = -1;
        tunnels[i].a1.w = 0;
        tunnels[i].a2.w = 0;
        tunnels[i].a1.o = -1;
        tunnels[i].a2.o = -1;
    }
     
    for(; i < t*2; ++i)
        inde[i].i = -1;
         
    qsort(tunnels, t, sizeof(coords)*2, comp);

    coords t1 = tunnels[0].a1;
    unsigned long t2 = 0;
    tunnels[0].a1.i = t2;
    length[0]++;
    inde[0] = tunnels[0].a1;
     
    for(i = 1; i < t; ++i){
        if(!comp(&tunnels[i].a1, &t1)){
            tunnels[i].a1.i = t2;
        }
        else{
            tunnels[i].a1.i = ++t2;
            t1 = tunnels[i].a1;
            inde[t2] = t1;
            if(tunnels[i].a1.a1 == m && tunnels[i].a1.a1 == n)
                idf = t2;          
        }
        length[tunnels[i].a1.i]++;        
    }
     
    id[0] = 0;
    for(i = 1; i < t; ++i)
        id[i] = id[i-1] + length[i-1];
    qsort(tunnels, t, sizeof(coords)*2, comp2);
    unsigned long l = 0;
    unsigned long r = 0;
    unsigned long maxl = t2;
    unsigned long maxr = t;
    unsigned long l_index = maxl;
    while(1){
        if(inde[l].i == -1){         
            break;

        }
        if(r == maxr){
            break;
        }
        if(comp(&inde[l], &tunnels[r].a2) == -1){ // left is less then rigth
            l++;
            continue;
        }
        if(comp(&inde[l], &tunnels[r].a2) == 0){ // left is eq to right
            tunnels[r].a2.i = inde[l].i;
            r++;
            continue;
        }
        else{ // left is less then right
            if(comp(&inde[l_index], &tunnels[r].a2) != 0){ // if last index isnt the same
                tunnels[r].a2.i = ++l_index;            
                inde[l_index] = tunnels[r].a2;
                if(tunnels[r].a2.a1 == m && tunnels[r].a2.a2 == n)
                    idf = l_index;
            }
            else
                tunnels[r].a2.i = l_index;
            r++;
            continue;
        }
    }
    for(; r < maxr; ++r){
        if(comp(&inde[l_index], &tunnels[r].a2) != 0){ // if last index isnt the same
            tunnels[r].a2.i = ++l_index;            
            inde[l_index] = tunnels[r].a2;
            if(tunnels[r].a2.a1 == m && tunnels[r].a2.a2 == n)
                idf = l_index;            
        }
        else
            tunnels[r].a2.i = l_index;     
    }
    for(i = 0; i < t; ++i){
        neib[id[tunnels[i].a1.i] + padding[tunnels[i].a1.i]] = tunnels[i].a2;
        padding[tunnels[i].a1.i]++;
    }
    free(padding);
    free(tunnels);
    dnsq = (coords*)malloc(sizeof(coords)*t*2);       
    queue = (long*)(malloc(sizeof(long) * (t*2)));    

    topol(inde[0]);
    top();
    if(idf != 0){
        printf("%lu\n", inde[idf].w);
    }
    else{
        printf("0\n");
    }
    return 0;
}
int comp(const void* a, const void* b){
    coords a1 = *(coords*)a;
    coords b1 = *(coords*)b;
    if(a1.a1 < b1.a1)
        return -1;
    else if(a1.a1 == b1.a1){
        if(a1.a2 < b1.a2)
            return -1;
        else if(a1.a2 == b1.a2)
            return 0;
        else 
            return 1;
    }
    return 1;
}
int comp2(const void* a, const void* b){
    coords a1 = *(coords*)(a + sizeof(coords));
    coords b1 = *(coords*)(b + sizeof(coords));
    if(a1.a1 < b1.a1)
        return -1;
    else if(a1.a1 == b1.a1){
        if(a1.a2 < b1.a2)
            return -1;
        else if(a1.a2 == b1.a2)
            return 0;
        else 
            return 1;
    }
    return 1;
}
