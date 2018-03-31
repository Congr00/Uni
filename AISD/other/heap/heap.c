/*
author   : Łukasz Klasiński
lib      : heap || heap-min-max
language : C
file     : heap.c
*/

#include "heap.h"



static void heap__resize_array(heap_* h){
    h->arr = (long*)realloc((void*)h->arr,h->length * sizeof(long));
    if(h->arr == NULL)
        exit(EXIT_FAILURE);
}
static void heap__resize_array_mm(heap_mm* h){
    heap__resize_array((heap_*)h);
}
static void heap__swap(HEAP_TYPE* arr, int i, int j){
    int t  = arr[i];
    arr[i] = arr[j];
    arr[j] = t;
}
heap_* heap__init(void){
    heap_* h  = (heap_*)(malloc(sizeof(heap_)));
    h->count  = 0;
    h->length = heap__init_size;
    h->arr    = NULL;
    heap__resize_array(h);
    return h;
}
heap_mm* heap__init_mm(void){
    return (heap_mm*)heap__init();
}

static void heap__fix_max(heap_mm* h, size_t i){   
    unsigned int grandson = (i << 1 | 1) << 1 | 1;
    unsigned int max_index = grandson;    
    unsigned int parent = ((i+1) >> 1) - 1;   
    unsigned int grandparent = (((i+1) >> 1) >> 1) - 1;      
    if(i != 0){
        if(h->arr[parent] > h->arr[i]){                         
            heap__swap(h->arr, parent, i);                    
            heap__fix_min(h, parent);
            heap__fix_max(h, i);
        }
    }
    if(grandson > h->length){
        for(int j = 0; j < 4; ++j)
            if(grandson + i > h->length)
                if(h->arr[grandson+i] >= h->arr[max_index])
                    max_index = grandson+i;
        if(h->arr[max_index] > h->arr[i]){
            heap__swap(h->arr, max_index, i);
            heap__fix_max(h, max_index);
        }
    }
    if(i > 2){
        if(grandparent || i == 2){
            if(h->arr[grandparent] < h->arr[i]){
                heap__swap(h->arr, grandparent, i);
                heap__fix_max(h, grandparent);
            }
        }
    }
}


static void heap__fix_min(heap_mm* h, size_t i){  
    unsigned int grandson = (i << 1 | 1) << 1 | 1;
    int min_index = grandson;  
    unsigned int parent = ((i+1) >> 1) - 1;     
    unsigned int grandparent = (((i+1) >> 1) >> 1) - 1;      
    if(i != 0){
        if(h->arr[parent] < h->arr[i]){
            heap__swap(h->arr, parent, i);
            heap__fix_max(h, parent);            
            heap__fix_min(h, i);            
        }
    }   
    if(grandson > h->length){
        for(int j = 0; j < 4; ++j)
            if(grandson + i > h->length)
                if(h->arr[grandson+i] <= h->arr[min_index])
                    min_index = grandson+i;
        if(h->arr[min_index] < h->arr[i]){             
            heap__swap(h->arr, min_index, i);
            heap__fix_min(h, min_index);
        }
    }
    if(i > 2){
        if(grandparent || (i >= 3 && i <= 6)){
            if(h->arr[grandparent] > h->arr[i]){   
                heap__swap(h->arr, grandparent, i);
                heap__fix_min(h, grandparent);
            }
        }
    }
}

static void heap__fix(heap_mm* h, size_t i){
    if((int)floor(log2(i+1)) % 2)
        heap__fix_max(h, i);
    else
        heap__fix_min(h, i);
}

void __heapPush_(heap_* h,HEAP_TYPE key){
    if(h->count == h->length){
        h->length <<= 1;
        heap__resize_array(h);
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
}

void __heapPush_mm(heap_mm* h, HEAP_TYPE key){
    if(h->count == h->length){
        h->length <<= 1;
        heap__resize_array((heap_*)h);
    }
    h->arr[h->count] = key;    
    h->count++;    
    heap__fix(h, h->count-1);
    return;
}

HEAP_TYPE __heapMin_(heap_* h){
    heap__check_zero(h->count, EMPTY_HEAP_OPERATION);
    return h->arr[0];
}

static void heap__check_zero(size_t l, const char* msg){
    if(!l){
        fprintf(stderr,"%s", msg);
        exit(EXIT_FAILURE);
    }
}

HEAP_TYPE __heapMin_mm(heap_mm* h){
    heap__check_zero(h->count, EMPTY_HEAP_OPERATION);
    return h->arr[0];
}

HEAP_TYPE __heapMax_mm(heap_mm* h){
    heap__check_zero(h->count, EMPTY_HEAP_OPERATION);
    if(h->count == 1)
        return h->arr[0];
    else
        return (h->arr[1] >= h->arr[2]) ? h->arr[1] : h->arr[2];
}

void __heapRMin_mm(heap_mm* h){
    heap__check_zero(h->count, EMPTY_HEAP_OPERATION);
    heap__swap(h->arr, 0, h->count);
    h->count--;
    heap__fix_min(h, 0);
}

void __heapRMax_mm(heap_mm* h){
    heap__check_zero(h->count, EMPTY_HEAP_OPERATION);
    int i;
    if(h->count == 0)
        i = 0;
    else if(h->count == 1)
        i = 1;
    else i = (h->arr[1] >= h->arr[2]) ? h->arr[1] : h->arr[2];
    heap__swap(h->arr, i, h->count);
    h->count--;
    heap__fix_max(h, i);
}

void __heapRMin_(heap_* h){
    h->arr[0] = h->arr[h->count-1];
    h->count--;
    int n = 0;
    while(1){
        unsigned int lchild;
        unsigned int t = (n << 1) | 1;
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

void heap__print(heap_* h){
    unsigned int st = 2;
    for(unsigned int i = 0; i < h->count; ++i){
        if(i+1 == st){
            printf("\n");
            st *= 2;
        }
        printf("%ld ", h->arr[i]);
    }
    printf("\n");
}

void __heapSort_naive(HEAP_TYPE* arr, const size_t size){
    heap_* h = heap__init();
    h->count = size;    
    heap__resize_array(h);    
    for(unsigned int i = 0; i < size; ++i)
        __heapPush_(h, arr[i]);
    for(unsigned int i = 0; i < size; ++i){
        arr[i] = __heapMin_(h);
        __heapRMin_(h);
    }
}

void __heapSort(HEAP_TYPE* arr, const size_t size){
    heap_* h = heap__init();
    h->count = size;    
    heap__resize_array(h);
    int w = (int)floor(log2(size));
    unsigned int j = 0;
    for(unsigned int i = (1 << w) -1; i < size; ++i, j++)
        h->arr[i] = arr[j];
    while(w > 0){
        w--;        
        unsigned int max = 1 << (w+1);
        for(unsigned int i = (1 << w) - 1; i < max-1; i++, j++){
            h->arr[i] = arr[j];
            unsigned int n = i;
            while(1){
                    unsigned int lchild;
                    unsigned int t = (n << 1) | 1;
                    if(t < h->count)
                        if(t + 1 < h->count)
                            lchild = (h->arr[t] <= h->arr[t+1]) ? t : t+1;
                        else
                            lchild = t;
                    else
                        break;
                    if(h->arr[n] > h->arr[lchild]){
                        heap__swap(h->arr, n, lchild);
                        n = lchild;
                    }
                    else
                        break;
                }
        }
    }
    for(unsigned int i = 0; i < size; i++){
        arr[i] = h->arr[0];
        unsigned int n = 0;
        while(1){
            unsigned int lchild;
            unsigned int t = (n << 1) | 1;
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
                    heap__swap(h->arr, n, n >> 1);
                    n >>= 1;
                }
                else
                    break;
            }
        }   
        h->count--;  
    }    
}

int rand_num(int a, int b){
    return (rand() % (b + 1 - a)) + a;
}


int main(){
    heap_mm* h = heap__init_mm();
    __heapPush_mm(h, 10);
    __heapPush_mm(h, 18);    
    __heapPush_mm(h, 22);    
    __heapPush_mm(h, 11);    
    __heapPush_mm(h, 4);
    __heapPush_mm(h, -21);     
    heap__print((heap_*)h);      
    __heapRMin_mm(h);
    __heapRMax_mm(h);
    printf("min: %ld, max: %ld\n", __heapMin_mm(h), __heapMax_mm(h));
    heap__print((heap_*)h);
    free(h->arr);
    free(h);
    return 0;
}


