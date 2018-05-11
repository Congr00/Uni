#include "avl_tree.h"

int main(){
    queue_c = 1;
    queue = (__avl_verticle*)malloc(sizeof(__avl_verticle)*SIZE);
    __tree = 0;
    for(us i = 1; i < SIZE; ++i)
        queue_nr[i] = i;
    size_t N;
    scanf("%lu", &N);
    for(size_t i = 0; i < N; ++i){   
        char t;
        long in;
        long res;
        scanf(" %c %ld", &t, &in);
        switch(t){
            case 'I':;
                _avl_insert_r(in, __tree, 0);              
            break;
            case 'D':;
                if(_avl_delete(in))
                    printf("OK\n");
                else
                    printf("BRAK\n");
            break;
            case 'U':;
                res = _avl_upper(in, __tree);
                if(res == LONG_MAX)
                    printf("BRAK\n");
                else
                    printf("%ld\n", res);
            break;
            case 'L':;
                res = _avl_lower(in, __tree);
                if(res == LONG_MIN)
                    printf("BRAK\n");
                else
                    printf("%ld\n", res);
            break;         
        }
    };        
    return 0;
}   
