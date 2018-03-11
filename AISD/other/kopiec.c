#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

typedef struct{
    int* arr;
    unsigned int count;
    unsigned int length;
} heap;

void resize_array(heap* h){
    h->arr = (int*)realloc(h->arr, h->length * sizeof(int));
    if(h->arr == NULL)
        exit(EXIT_FAILURE);
    return;
}

heap* init_heap(unsigned int initial_size){
    heap* h   = (heap*)(malloc(sizeof(heap*)));
    h->count  = 0;
    h->length = initial_size;
    h->arr    = NULL;
    resize_array(h);
    return h;
}

void add_keymn(heap* h, int key){
    if(h->count == h->length){
        h->length <<= 1;
        resize_array(h);
    }
    h->arr[h->count] = key;
    int n = h->count;
}

void add_key(heap* h, int key){
    if(h->count == h->length){
        h->length <<= 1;
        resize_array(h);
    }
    h->arr[h->count] = key;
    int n = h->count;
    while(n != 0){
        if(h->arr[n >> 1] > h->arr[n]){
            h->arr[n]      ^= h->arr[n >> 1];
            h->arr[n >> 1] ^= h->arr[n];
            h->arr[n]      ^= h->arr[n >> 1];
            n >>= 1;
        }
        else
            break;
    }
    h->count++;
    return;
}

int get_min(heap* h){
    return h->arr[0];
}

void remove_min(heap* h){
    h->arr[0] = h->arr[h->count-1];
    h->count--;
    int n = 0;
    while(1){
        unsigned int lchild;
        int t = (n << 1) | 1;
        if(t < h->count)
            if(t + 1 < h->count)
                lchild = (h->arr[t] <= h->arr[t+1]) ? t : t+1;
            else
                lchild = t;
        else
            return;
        if(h->arr[n] > h->arr[lchild]){
            h->arr[n]      ^= h->arr[lchild];
            h->arr[lchild] ^= h->arr[n];
            h->arr[n]      ^= h->arr[lchild];            
            n = lchild;
        }
        else
            return;
    }
}

void print(heap* h){
    int st = 2;
    for(int i = 0; i < h->count; ++i){
        if(i+1 == st){
            printf("\n");
            st *= 2;
        }
        printf("%d ", h->arr[i]);
    }
    printf("\n");
}

int pow2(const int x){
    int res = 1;
    for(int i = 0; i < x; i++)
        res <<= 1;
    return res;
}

void heapsort_naive(int* arr, const int size){
    heap* h = init_heap(pow2((int)floor(log2(size))));
    for(int i = 0; i < size; ++i)
        add_key(h, arr[i]);
    for(int i = 0; i < size; ++i){
        arr[i] = get_min(h);
        remove_min(h);
    }
}

void heapsort_fast(int* arr, const int size){
    heap* h = init_heap(pow2((int)floor(log2(size))));
    h->count = size;    
    int w = (int)floor(log2(size));
    int j = 0;
    for(int i = pow2(w)-1; i < size; ++i, j++)
        h->arr[i] = arr[j];
    while(w > 0){
        w--;        
        int max = pow2(w+1);
        for(int i = pow2(w) - 1; i < max-1; i++, j++){
            h->arr[i] = arr[j];
            int n = i;
            while(1){
                    unsigned int lchild;
                    int t = (n << 1) | 1;
                    if(t < h->count)
                        if(t + 1 < h->count)
                            lchild = (h->arr[t] <= h->arr[t+1]) ? t : t+1;
                        else
                            lchild = t;
                    else
                        break;
                    if(h->arr[n] > h->arr[lchild]){
                        h->arr[n]      ^= h->arr[lchild];
                        h->arr[lchild] ^= h->arr[n];
                        h->arr[n]      ^= h->arr[lchild];
                        n = lchild;
                    }
                    else
                        break;
                }
        }
    }
    for(int i = 0; i < size; i++){
        arr[i] = h->arr[0];
        int n = 0;
        while(1){
            unsigned int lchild;
            int t = (n << 1) | 1;
            if(t < h->count)
                if(t + 1 < h->count)
                    lchild = (h->arr[t] <= h->arr[t+1]) ? t : t+1;
                else
                    lchild = t;
            else
                break;
            h->arr[n] = h->arr[lchild];
            n = lchild;
        }
        if(n != h->count-1){
            h->arr[n] = h->arr[h->count-1];
            while(n != 0){
                if(h->arr[n >> 1] > h->arr[n]){
                    h->arr[n]      ^= h->arr[n >> 1];
                    h->arr[n >> 1] ^= h->arr[n];
                    h->arr[n]      ^= h->arr[n >> 1];
                    n >>= 1;
                }
                else
                    break;
            }
        }   
        h->count--;  
    }    
}

#define SIZE 100

int rand_num(int a, int b){
    return (rand() % (b + 1 - a)) + a;
}

int main(){

    int* arr = (int*)malloc(sizeof(int)* SIZE);
    srand(time(NULL));
    for(int i = 0; i < SIZE; i++)
        arr[i] = rand_num(-100, 100);
    heapsort_naive(arr, SIZE);
    for(int i = 0; i < SIZE; i++)
        printf("%d ", arr[i]);
    printf("\n");
    return 0;
}


