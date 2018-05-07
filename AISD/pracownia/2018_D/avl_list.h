#define AVL_TREE
//#ifndef AVL_TREE


#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdbool.h>
#include <limits.h>

typedef unsigned short us;
typedef struct __avl_verticle __avl_verticle;
struct __avl_verticle{
    int key;
    short  weight;
    unsigned short id;
    unsigned short left;
    unsigned short right;
    unsigned short parent;
};

__avl_verticle* queue;
unsigned short queue_nr[50000];
unsigned short queue_c;

#define LEFT(ptr) \
        queue[queue[ptr].left].id;
#define RIGHT(ptr) \
        queue[queue[ptr].right].id;
#define PARENT(ptr) \
        queue[ptr->parent].id;
#define PTR(ptr) \
        queue[ptr].id;


void pop(__avl_verticle* i);
void push(__avl_verticle* i);

unsigned short __tree;
 
void  _avl_insert_r(int key, __avl_verticle* r, __avl_verticle* p);
bool  _avl_delete(int value);
__avl_verticle* _avl_search(int value, __avl_verticle* index);
__avl_verticle* _avl_rotatel(__avl_verticle* pr, __avl_verticle* ch);
__avl_verticle* _avl_rotater(__avl_verticle* pr, __avl_verticle* ch);
__avl_verticle* _avl_rotaterl(__avl_verticle* pr, __avl_verticle* ch);
__avl_verticle* _avl_rotatelr(__avl_verticle* pr, __avl_verticle* ch);    
void  _avl_check_i(__avl_verticle* child);
void  _avl_check_d(__avl_verticle* child);
__avl_verticle* _avl_min(__avl_verticle* index);
__avl_verticle* _avl_max(__avl_verticle* index);
void  _avl_del_i(__avl_verticle* index);
bool  _check_bt(size_t index);
int _avl_lower(int value, __avl_verticle* upp, int u);
int _avl_upper(int value, __avl_verticle* upp, int u);
void print_all(__avl_verticle* index);
void update_parent(__avl_verticle* i);
//#endif //AVL_TREE