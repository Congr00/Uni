#include "avl.h"

int main(){
    _avl_init(1000, sizeof(int), sizeof(int));

    _avl_insert(0, 5);
    _avl_insert(0, 4);
    _avl_insert(0, 6);
    _avl_insert(0, 3);
    _avl_insert(0, 7);
    _avl_insert(0, 2);
    _avl_insert(0, 8);
    _avl_insert(0, 1);
    _avl_insert(0, 9);
    _avl_insert(0, 0);
    _avl_insert(0, 10);                                        
    _avl_insert(0, 5);
    _avl_print();
    _avl_uninit();
    return 0;
}   