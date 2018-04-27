#define AVL_TREE
//#ifndef AVL_TREE


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <stdbool.h>
#include <strings.h>
#include <math.h>

#define LEFT_CHILD(I) \
                 (I<<1)+1
#define RIGHT_CHILD(I) \
                 (I<<1)+2
#define PARENT(I)      \
                 ((I-1)>>1)

typedef struct{
    int    value  ;
    int    key    ;
    size_t lt_size;
    size_t rt_size;
    bool   init   ;
}__avl_verticle;

typedef struct{
    size_t type_length   ;
    size_t key_length    ;
    size_t array_length  ;
    size_t elements_count;
    __avl_verticle* tree ;
}__avl_tree;

static __avl_tree* __tree_str = NULL;

void  _avl_insert(int value, int key);
void  _avl_insert_r(int value, int key, size_t index);
void  _avl_delete(void* value);
void* _avl_search(void* value);
void  _avl_uninit(void)       ;
void  _avl_print ()           ;
void  _avl_rotate(size_t index);
void  _avl_init  (size_t init_size, size_t type_length, size_t key_length);

//#endif //AVL_TREE