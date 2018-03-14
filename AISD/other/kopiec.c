/*
author:     Łukasz Klasiński
indeks:     290043
lib   :     heap | heap-min-max
*/

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#define EMPTY_HEAP_OPERATION "Attempt to operate on empty heap\n"

typedef struct{
    int* arr;
    unsigned int count;
    unsigned int length;
} heap;

typedef struct{
    int* arr;
    unsigned int count;
    unsigned int length;
} heap_min_max;

void pace_min(heap_min_max* h, unsigned int i);
void pace_max(heap_min_max* h, unsigned int i);

void resize_array(heap* h){
    printf("WTF:%d\n", h->length);
    void* sumshit = (int*)realloc((void*)h->arr,h->length * sizeof(int));
    h -> arr = sumshit;
    if(h->arr == NULL)
        exit(EXIT_FAILURE);
    return;
}
void resize_array_mm(heap_min_max* h){
    resize_array((heap*)h);
}
void swap(int* arr, int i, int j){
    int t = arr[i];
    arr[i] = arr[j];
    arr[j] = t;
}

heap* init_heap(unsigned int initial_size){
    heap* h   = (heap*)(malloc(sizeof(heap*)));
    h->count  = 0;
    h->length = initial_size;
    h->arr    = NULL;
    resize_array(h);
    return h;
}
heap_min_max* init_heap_mm(unsigned int initial_size){
    return (heap_min_max*)init_heap(initial_size);
}

void pace_max(heap_min_max* h, unsigned int i){   
    if(i != 0){
        unsigned int parent = ((i+1) >> 1) - 1; 
        if(h->arr[parent] > h->arr[i]){                         
            swap(h->arr, parent, i);                    
            pace_min(h, parent);
            pace_max(h, i);
        }
    }
    unsigned int grandson = (i << 1 | 1) << 1 | 1;
    unsigned int max_index = grandson;
    if(grandson > h->length){
        for(int j = 0; j < 4; ++j)
            if(grandson + i > h->length)
                if(h->arr[grandson+i] >= h->arr[max_index])
                    max_index = grandson+i;
        if(h->arr[max_index] > h->arr[i]){
            swap(h->arr, max_index, i);
            pace_max(h, max_index);
        }
    }
    if(i > 2){
        unsigned int grandparent = (((i+1) >> 1) >> 1) - 1;
        if(grandparent || i == 2){
            if(h->arr[grandparent] < h->arr[i]){
                swap(h->arr, grandparent, i);
                pace_max(h, grandparent);
            }
        }
    }
}

void pace_min(heap_min_max* h, unsigned int i){  
    if(i != 0){
        unsigned int parent = ((i+1) >> 1) - 1;
        if(h->arr[parent] < h->arr[i]){
            swap(h->arr, parent, i);
            pace_max(h, parent);            
            pace_min(h, i);            
        }
    }
    int grandson = (i << 1 | 1) << 1 | 1;
    int min_index = grandson;    
    if(grandson > h->length){
        for(int j = 0; j < 4; ++j)
            if(grandson + i > h->length)
                if(h->arr[grandson+i] <= h->arr[min_index])
                    min_index = grandson+i;
        if(h->arr[min_index] < h->arr[i]){             
            swap(h->arr, min_index, i);
            pace_min(h, min_index);
        }
    }
    if(i > 2){
        int grandparent = (((i+1) >> 1) >> 1) - 1;
        if(grandparent || (i >= 3 && i <= 6)){
            if(h->arr[grandparent] > h->arr[i]){   
                swap(h->arr, grandparent, i);
                pace_min(h, grandparent);
            }
        }
    }
    return;
}

void pace(heap_min_max* h, unsigned int i){
    if((int)floor(log2(i+1)) % 2)
        pace_max(h, i);
    else
        pace_min(h, i);
    return;
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

void add_key_mm(heap_min_max* h, int key){
    if(h->count == h->length){
        h->length <<= 1;
        resize_array((heap*)h);
    }
    h->arr[h->count] = key;    
    h->count++;    
    pace(h, h->count-1);
    return;
}

int get_min(heap* h){
    return h->arr[0];
}

void check_zero(unsigned int l, const char* msg){
    if(l == 0){
        fprintf(stderr,"%s", msg);
        exit(EXIT_FAILURE);
    }
}

int get_min_mm(heap_min_max* h){
    check_zero(h->count, EMPTY_HEAP_OPERATION);
    return h->arr[0];
}

int get_max_mm(heap_min_max* h){
    check_zero(h->count, EMPTY_HEAP_OPERATION);
    if(h->count == 1)
        return h->arr[0];
    else
        return (h->arr[1] >= h->arr[2]) ? h->arr[1] : h->arr[2];
}

void remove_min_mm(heap_min_max* h){
    check_zero(h->count, EMPTY_HEAP_OPERATION);
    swap(h->arr, 0, h->count);
    h->count--;
    pace_min(h, 0);
}

void remove_max_mm(heap_min_max* h){
    check_zero(h->count, EMPTY_HEAP_OPERATION);
    int i;
    if(h->count == 0)
        i = 0;
    else if(h->count == 1)
        i = 1;
    else i = (h->arr[1] >= h->arr[2]) ? h->arr[1] : h->arr[2];
    swap(h->arr, i, h->count);
    h->count--;
    pace_max(h, i);
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

#define SIZE 128

int rand_num(int a, int b){
    return (rand() % (b + 1 - a)) + a;
}

int main(){
/*
    int* arr = (int*)malloc(sizeof(int)* SIZE);
    srand(time(NULL));
    for(int i = 0; i < SIZE; i++)
        arr[i] = rand_num(-100, 100);
    heapsort_naive(arr, SIZE);
    for(int i = 0; i < SIZE; i++)
        printf("%d ", arr[i]);
    printf("\n");*/


    heap_min_max* h = init_heap_mm(1);
    for(int i = 0; i < SIZE; ++i){
        add_key_mm(h, rand_num(-1000, 1000));
    }
    printf("min:%d, max:%d\n", get_min_mm(h), get_max_mm(h));
    int max = -2000;
    int min = 2000;
    for(int i = 0; i < h->count; ++i){
        if(h->arr[i] > max)
            max = h->arr[i];
        if(h->arr[i] < min)
            min = h->arr[i];
    }
    printf("min:%d, max:%d\n", min, max);
//    print((heap*)h);

    return 0;
}


