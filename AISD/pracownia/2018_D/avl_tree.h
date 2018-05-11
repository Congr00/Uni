#ifndef AVL_TREE
#define AVL_TREE


#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdbool.h>
#include <limits.h>

#define SIZE 50001

typedef unsigned short us;
typedef struct __avl_verticle __avl_verticle;
struct __avl_verticle{
    long key;
    short  weight;
    unsigned short id;
    unsigned short left;
    unsigned short right;
    unsigned short parent;
};

__avl_verticle* queue;
unsigned short queue_nr[SIZE];
unsigned short queue_c;

#define LEFT(ptr) \
        queue[queue[ptr].left]
#define RIGHT(ptr) \
        queue[queue[ptr].right]
#define PARENT(ptr) \
        queue[queue[ptr].parent]
#define PTR(ptr) \
        queue[ptr]
#define POP() \
        queue_nr[queue_c++]
#define PUSH(ptr) \
        queue_nr[--queue_c] = ptr

unsigned short __tree;
 
void  _avl_insert_r(long key, us r, us p);
bool  _avl_delete(long value);
us _avl_search(long value, us index);
us _avl_rotatel(us pr, us ch);
us _avl_rotater(us pr, us ch);
us _avl_rotaterl(us pr, us ch);
us _avl_rotatelr(us pr, us ch);    
void  _avl_check_i(us child);
void  _avl_check_d(us child);
us _avl_min(us index);
us _avl_max(us index);
void  _avl_del_i(us index);
bool  _check_bt(size_t index);
long _avl_lower(long value, us upp);
long _avl_upper(long value, us upp);
void print_all(us index);
void update_parent(us i, us v);
void print_ptr(us i);
void switch_vars(us* i, us* j);
void switch_nodes(us i, us j);
#endif //AVL_TREE