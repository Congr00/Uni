/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: MBI

*/

#include <stdio.h>
#include <stdlib.h>

// queue for dfs algorithm
int* queue;
int counter = 0;
int pop(){
    if(counter == 0)
        return 0;
    else{
        int res = queue[counter];
        counter--;
        return res;
    }
}
void push(int val){
    queue[++counter] = val;
}

void dfsn(int* in, int* out, int* index, int* length, int* tree, int v, int nr){
    push(v);
    while(1){
        nr++;
        int cv = pop();
        if(cv == 0)
            return;          
        else if(cv < 0){
            nr--;
            out[cv*(-1)-1] = nr;
            continue;
        }
        in[cv-1] = nr;            
        if(length[cv-1] == 0){
            out[cv-1] = nr;   
            continue;
        }               
        push(-cv);     
        for(int i = 0; i < length[cv-1]; ++i){
            push(tree[index[cv-1]+i]);
        }
    } 
}

int main(){

    int n,q;
    int size = 0;
    int prev = 1;
    scanf("%d %d", &n, &q);
    int* index  = (int*)calloc(sizeof(int),n);
    int* length = (int*)calloc(sizeof(int),n);
    int* in     = (int*)calloc(sizeof(int), n);
    int* out    = (int*)malloc(sizeof(int)*n);
    int* treep  = (int*)malloc(sizeof(int)*n);
    int q1,q2;
    index[0] = 0;
    for(int i = 1; i < n; ++i){
        int tmp;
        scanf("%d", &tmp);
        out[i-1] = tmp;
        length[tmp-1]++;
    }
    index[0] = 0;
    // set index
    for(int i = 1;i < n; i++)
        index[i] = (index[i-1] + length[i-1]);
    // switch elements
    for(int i = 1; i < n; i++){
        treep[index[out[i-1]-1] + in[out[i-1]-1]] = i+1;
        in[out[i-1]-1]++;
    }
    queue = (int*)malloc(sizeof(int)*n*2);
    dfsn(in, out, index, length, treep, 1, -1);       
    for(int i = 0; i < q; i++){
        scanf("%d %d", &q1, &q2);
        if((in[q2-1] >= in[q1-1]) && (in[q2-1] <= out[q1-1])){
            printf("TAK\n");
        }
        else
            printf("NIE\n");        
    } 
    /*for(int i = 0; i < n; i++){
        printf("nr: %d, index: %d, ln: %d, in: %d\n", i+1, index[i], length[i], in[i]);
    }
    for(int i = 0; i < n; i++)
        printf("treep[%d]: %d\n", i, treep[i]);
*/
    return 0;
}   