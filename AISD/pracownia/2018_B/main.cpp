#include <stdio.h>
#include <stdlib.h>

#include <string>
#include <unordered_map>
#include <sstream>

typedef struct{
    unsigned long a1;
    unsigned long a2;
    unsigned long w;
    unsigned long l;
    unsigned long s;
    int o;
} coords;

typedef struct{
    coords a1;
    coords a2;
} tunnel;

unsigned long cnt = 0;
unsigned long qi  = 0;
unsigned long dnsc = 0;
coords* queue;
coords* dnsq;
tunnel* tunnels;
coords* neib;
unsigned long* padding;
coords tmp;
unsigned long t;
unsigned long ptr;
    std::unordered_map<std::string, coords> map;
unsigned long idf;
void push(coords c){
    dnsq[--dnsc] = c;
}
int pop(){
    if(dnsc == t)
        return 0;
    tmp = dnsq[dnsc++];
    return 1;
}

void add(coords c){
    queue[ptr--] = c;
}


void printc(coords c){
  //  printf("(%lu, %lu), id:%ld, w: %lu\n", c.a1, c.a2, c.i, c.w);
}

std::string toS(coords c){
    std::ostringstream ss;
    ss << c.a1 << c.a2;
    return ss.str();
}

void topol(coords s);
void top();



int comp(const void* a, const void* b);
int comp2(const void* a, const void* b);
int main(){
    unsigned long m, n, i;
    scanf("%lu %lu %lu", &m, &n, &t);
    if(t == 0){
        printf("0\n");
        return 0;
    }
    ptr = t+1;
    dnsc = t;
    tunnels = (tunnel*)(malloc(sizeof(tunnel) * t));
    neib = (coords*)(malloc(sizeof(coords) * t));
    padding = (unsigned long*)(calloc(sizeof(unsigned long), t));
    queue = (coords*)(malloc(sizeof(coords) * (t+2)));
    dnsq = (coords*)malloc(sizeof(coords)*t);    
    for(i = 0; i < t; ++i){
        scanf("%lu %lu %lu %lu", &tunnels[i].a1.a1, &tunnels[i].a1.a2, &tunnels[i].a2.a1, &tunnels[i].a2.a2);
        tunnels[i].a1.w = 0;
        tunnels[i].a2.w = 0;
        tunnels[i].a1.o = -1;
        tunnels[i].a2.o = -1;
        std::string tmp = toS(tunnels[i].a1);
        auto el = map.find(tmp);
        if(el == map.end()){
            tunnels[i].a1.l = 1;
            map[tmp] = tunnels[i].a1;
        }
        else{
            el->second.l++;
        }
        tmp = toS(tunnels[i].a2);
        el = map.find(tmp);
        if(el == map.end()){
            map[toS(tunnels[i].a2)] = tunnels[i].a2;
        }
    }
    auto ttt = map.find("00");
    if(ttt == map.end()){
        printf("0\n");
        return 0;
    }    
    coords c;
    c.a1 = m;
    c.a2 = n;   
    auto ttt2 = map.find(toS(c));
    if(ttt2 == map.end()){
        printf("0\n");
        return 0;
    }
    auto it = map.begin();
    it->second.s = 0;
    auto tmp = map.begin();
    it++;
    for(;it != map.end(); it++){
        it->second.s = tmp->second.s + tmp->second.l;
        tmp++;
    }
    for(i = 0; i < t; ++i){
        auto tmp = map.find(toS(tunnels[i].a1));
        neib[tmp->second.s + padding[tmp->second.s]] = tunnels[i].a2;
        padding[tmp->second.s]++;
    }
    free(padding);

    //for(i = 0; i < t; ++i)
    //    printf("neib: (%lu, %lu), index:%ld\n", neib[i].a1, neib[i].a2, neib[i].i);      
    topol(ttt->second);
   // for(int i = ptr + 1; i < t+2; ++i){
   //     printf("(%lu, %lu)\n", queue[i].a1, queue[i].a2);
   // }
    top();
 //   for(auto itr = map.begin(); itr != map.end(); itr++){
//        printf("(%lu, %lu), start:%lu, length:%lu, number:%ld\n", itr->second.a1, itr->second.a2, itr->second.s, itr->second.l, itr->second.w);
//    }    

    printf("%lu\n", map.find(toS(c))->second.w);
    return 0;
}

void topol(coords s){     
    push(s);        
    while(pop()){         
        if(tmp.o == -2){       
            add(tmp);
            continue;
        }
        auto ttr = map.find(toS(tmp));
        if(ttr->second.o == -1){
           ttr->second.o = 0;
        }
        else{
            continue;
        }
        tmp.o = -2;
        push(tmp);                                  
        for(unsigned int i = ttr->second.s; i < ttr->second.s + ttr->second.l; ++i){     
            auto ttr2 = map.find(toS(neib[i]));
            if(ttr2->second.o == -1)           
                push(neib[i]);
        }
    }   
}
void top(){    
    auto tmp = map.find("00");
    if(tmp == map.end())
        return;
    for(unsigned long j = tmp->second.s; j < tmp->second.s + tmp->second.l; ++j){      
        map.find(toS(neib[j]))->second.w += tmp->second.w+1;              
    }
    for(unsigned long i = ptr+2; i < t+2; ++i){
        tmp = map.find(toS(queue[i]));
        for(unsigned long j = tmp->second.s; j < tmp->second.s + tmp->second.l; ++j){      
            auto tmp2 = map.find(toS(neib[j]));
            map.find(toS(neib[j]))->second.w += tmp->second.w;            
        }
    }
}

