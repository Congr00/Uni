/*
author   : Łukasz Klasiński
lib      : heap || heap-min-max
language : C
file     : heap.h
*/

#include <stdio.h>
#include <sys/types.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <stdbool.h>

#define EMPTY_HEAP_OPERATION "Attempt to get element from an empty heap\n"

#define HEAP_TYPE long
#define COMPARE_EQ HEAP_TYPE bool (*heap__comp(HEAP_TYPE, HEAP_TYPE))
#define COMPARE_M HEAP_TYPE bool (*heap__comp(HEAP_TYPE, HEAP_TYPE))

#define SIZE 65

static size_t heap__init_size = 32;

typedef struct{
    long* arr;
    size_t count;
    size_t length;
} heap_;

typedef struct{
    long* arr;
    size_t count;
    size_t length;
} heap_mm;

/*
helper functions 
*/
static void heap__swap(HEAP_TYPE* arr, int i, int j);
static void heap__check_zero(size_t l, const char* msg);
static void heap__print(heap_* h);
//static bool heap__compf_eq(int x, int y);
//static bool heap__compf_m(int x, int y);


static bool heap__compf_eq(int x, int y){
    return (x == y) ? true : false;
}
static bool heap__compf_m(int x, int y){
    return (x > y) ? true : false;
}

typedef bool (*heap__comp_eq(HEAP_TYPE, HEAP_TYPE));
typedef bool (*heap__comp_m(HEAP_TYPE, HEAP_TYPE));



/*
min/max heap functions
*/
static void heap__resize_array_mm(heap_mm* h);
static heap_mm* heap__init_mm(void);
static void heap__fix_max(heap_mm* h, size_t i);
static void heap__fix_min(heap_mm* h, size_t i);
static void heap__fix(heap_mm* h, size_t i);
/*
heap functions
*/
static void heap__resize_array(heap_* h);
static heap_* heap__init(void);

/*
user manipulation funtions
*/
void      __heapPush_(heap_* h, HEAP_TYPE key);
void      __heapPush_mm(heap_mm* h, HEAP_TYPE key);
HEAP_TYPE __heapMin_(heap_* h);
void      __heapRMin_(heap_* h);
HEAP_TYPE __heapMin_mm(heap_mm* h);
void      __heapRMin_mm(heap_mm* h);
HEAP_TYPE __heapMax_mm(heap_mm* h);
void      __heapRMax_mm(heap_mm* h);
void __heapSort_naive(HEAP_TYPE* arr, const size_t size);
void __heapSort(HEAP_TYPE* arr, const size_t size);