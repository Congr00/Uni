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
#include <limits.h>

#define LEFT_CHILD(I) \
                 (I<<1)+1
#define RIGHT_CHILD(I) \
                 (I<<1)+2
#define PARENT(I)      \
                 ((I-1)>>1)

#define D_SIZE (1 >> 16)
#define BUFF_RMV -1
#define BUFF_CP   1
#define NO_RPL   -2
#define RPL       2
#define NORM      0

#define CHECK_BUFF \
            if(__tree_buffer == NULL){printf("buffer is not initialized!\n");exit(EXIT_FAILURE);}


typedef struct{
    //int  value ;
    int key    ;
    int  weight;
    bool init  ;
}__avl_verticle;

typedef struct{
    size_t type_length   ;
    size_t key_length    ;
    size_t array_length  ;
    size_t elements_count;
    __avl_verticle* tree ;
}__avl_tree;

__avl_tree*     __tree_str   ;
__avl_verticle* __tree_buffer ;
 
void  _avl_insert(int value, int key);
void  _avl_insert_r(int value, int key, size_t index);
bool  _avl_delete(int value);
int   _avl_search(int value, size_t index);
void  _avl_uninit(void)       ;
void  _avl_print (bool buff)  ;
void  _avl_rotate(size_t index);
void  _avl_rotatel(size_t index);
void  _avl_rotater(size_t index);
void  _avl_init  (size_t init_size, size_t type_length, size_t key_length);
void  _cp_subtree(size_t index);
void  _rp_subtree(size_t index1, size_t index2, int buff);
void  _avl_check_h(size_t index, bool del);
size_t _avl_min(size_t index);
size_t _avl_max(size_t index);
void  _avl_del_i(size_t index);
bool  _check_bt(size_t index);
int   _avl_valueAt(size_t index);
int _avl_lower(int value, size_t lowest, int l);
int _avl_upper(int value, size_t upp, int u);
//#endif //AVL_TREE