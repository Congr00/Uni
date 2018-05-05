#include "avl_array.h"

int main(){
    _avl_init(1000, sizeof(int), sizeof(int));

    _avl_insert(0, 5);
    _avl_insert(0, 3);
    _avl_insert(0, 6);
    _avl_insert(0, 2);
    _avl_insert(0, 4);
    _avl_insert(0, 10);  
    _avl_insert(0, 11);  
    _avl_insert(0, 8);  
    _avl_insert(0, 1);    
    _avl_insert(0, -2);   
    _avl_insert(0, -6); 
    _avl_insert(0, -1); 

    _avl_insert(0, 9);        
    _avl_insert(0, 15);        
    _avl_insert(0, 18);     
    _avl_insert(0, 20);             
    _avl_insert(0, -5);             
    _avl_delete(5);              
    _avl_delete(15);              
    _avl_delete(9);
    
    _avl_delete(11);             
    _avl_delete(4);
       _avl_print(0);     
   _avl_delete(20);    
//printf("heheheh:%d\n", __tree_str->tree[_avl_search(1, 0)].weight);                                                            
    _avl_print(0);   
    if(_check_bt(0)) 
         printf("OK\n"); 
    else printf("BAD\n");
    printf("min:%d\n", _avl_valueAt(_avl_min(0)));
    printf("max:%d\n", _avl_valueAt(_avl_max(0)));    
    printf("min index:%lu\n", _avl_valueAt(_avl_min(2)));
    _avl_uninit();
    return 0;
}   