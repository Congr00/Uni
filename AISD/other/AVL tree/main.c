#include "avl_array.h"

#define ROOT 0

int main(){
    _avl_init(131072, sizeof(int), sizeof(int));    
    size_t N;
    scanf("%lu", &N);
    for(size_t i = 0; i < N; ++i){
        char t;
        int in;
        int res;
        scanf("%c %d", &t, &in);
        switch(t){
            case 'I':
                _avl_insert(ROOT, in);
            break;
            case 'D':
                if(_avl_delete(in))
                    printf("OK");
                else
                    printf("BRAK");
            break;
            case 'U':
                ;
                res = _avl_upper(in, ROOT, INT_MAX);
                if(res == INT_MAX)
                    printf("BRAK\n");
                else
                    printf("%d\n", res);
            break;
            case 'L':;
                res = _avl_lower(in, ROOT, INT_MIN);
                if(res == INT_MIN)
                    printf("BRAK\n");
                else
                    printf("%d\n", res);
            break;            
        }
    }
/*


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
    int v = _avl_lower(1, 0, INT_MIN);
    if(v != INT_MIN)
        printf("lower: %d\n", v);
    else
        printf("BRAK\n");
        */
    _avl_uninit();
    return 0;
}   