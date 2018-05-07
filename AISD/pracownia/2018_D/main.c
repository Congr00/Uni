#include "avl_list.h"



int main(){
    queue_c = 0;
    queue = (__avl_verticle*)malloc(sizeof(__avl_verticle)*50000);
    __tree = NULL;
    for(unsigned short i = 0; i < 50000; ++i)
        queue_nr[i] = i;
    size_t N;
    scanf("%lu", &N);

    for(size_t i = 0; i < N; ++i){
        char t;
        int in;
        int res;
        scanf(" %c %d", &t, &in);
        switch(t){
            case 'I':
                _avl_insert_r(in, __tree, NULL);
            break;
            case 'D':
                if(_avl_delete(in))
                    printf("OK\n");
                else
                    printf("BRAK\n");
            break;
            case 'U':
                ;
                res = _avl_upper(in, __tree, INT_MAX);
                if(res == INT_MAX)
                    printf("BRAK\n");
                else
                    printf("%d\n", res);
            break;
            case 'L':;
                res = _avl_lower(in, __tree, INT_MIN);
                if(res == INT_MIN)
                    printf("BRAK\n");
                else
                    printf("%d\n", res);
            break;         
        }
    }
    if(__tree != NULL){
    puts("printin contents");        
    print_all(__tree);
    puts("");
    printf("root: %d\n", __tree->key);
    }
    else
        printf("TREE NULL\n");
    
    return 0;
}   
