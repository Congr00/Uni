#include "avl_array.h"

void _cp_subtree(size_t index){
    //check buff
    if(!__tree_str->tree[index].init)
        return;
    __tree_buffer[index] = __tree_str->tree[index];
    //if(LEFT_CHILD(index) < __tree_str->array_length)
        _cp_subtree(LEFT_CHILD(index));
    //if(RIGHT_CHILD(index) < __tree_str->array_length)
        _cp_subtree(RIGHT_CHILD(index));
}

void _rp_subtree(size_t index1, size_t index2, int buff){
    //CHECK_BUFF bef callin?
    if(!__tree_str->tree[index1].init && !__tree_buffer[index2].init)
        return; 
    if(buff == 2 || buff == -2){
        __avl_verticle tmp       = __tree_str->tree[index1];
        __tree_str->tree[index1] = __tree_str->tree[index2];
        if(buff == 2)
            __tree_str->tree[index2] = tmp;
    }
    else{
        if(buff == 1){
            __avl_verticle tmp       = __tree_str->tree[index1];
            __tree_str->tree[index1] = __tree_buffer[index2]   ;  
            __tree_buffer[index1]    = tmp                     ;
            __tree_buffer[index2].init = false;

        }     
        else{
            __tree_str->tree[index1] = __tree_buffer[index2]   ;  
            __tree_buffer[index2].init = false;            
        }
    }
    _rp_subtree(LEFT_CHILD(index1), LEFT_CHILD(index2), buff);
    _rp_subtree(RIGHT_CHILD(index1), RIGHT_CHILD(index2), buff);    
}

void _avl_rotate(size_t index){
    size_t lp_child = LEFT_CHILD(PARENT(index));
    if(lp_child == index)
        _avl_rotatel(index);
    else
        _avl_rotater(index);
}

void _avl_rotatel(size_t index){
    size_t p = PARENT(index);
    _cp_subtree(index);    
    _rp_subtree(index,  RIGHT_CHILD(index), NO_RPL);    
    _rp_subtree(p, index, BUFF_CP);          
    _rp_subtree(RIGHT_CHILD(p), p, BUFF_RMV);


   /* puts("");
    for(size_t i = 0; i < __tree_str->elements_count*10; ++i){
        if(__tree_buffer[i].init)
            printf("%d ", __tree_buffer[i].key);
        else
            printf("- ");
    }        
    puts("\n");     
*/
    //_avl_print(1);
}

void _avl_rotater(size_t index){
    size_t p = PARENT(index);
    _cp_subtree(index);
    _rp_subtree(index,  LEFT_CHILD(index), NO_RPL);  
    _rp_subtree(p, index, BUFF_CP);  
    _rp_subtree(LEFT_CHILD(p), p, BUFF_RMV);
}

void  _avl_print(bool buff){
    if(__tree_str == NULL){
        printf("Cannot print NULL object \n");
        exit(EXIT_FAILURE);
    }
    size_t i,j, level = 0;
    size_t el = 0;
    size_t tree_lvls = (size_t)ceil(log2(__tree_str->elements_count));
    tree_lvls++;    
    size_t elements_lst = (1 << (tree_lvls - 1));
    __avl_verticle* tree = (!buff) ? __tree_str->tree : __tree_buffer;
    for(i = 0; i < tree_lvls; ++i){
        for(j = 0; j < ((elements_lst-(1 << i))*3)/2; ++j)
            printf(" "); 
        for(j = 0; j < (size_t)(1 << i); ++j){
            if(!tree[el].init){
                el++;
                printf(" 0 ");
                continue;
            }            
            
            if((size_t)floor(log10(abs(tree[i].key))) < 1){
                if(tree[i].key >= 0)
                    printf(" ");
                printf("%d ", tree[el++].key);
            }
            else{
                if(tree[i].key < 0)
                    printf("%d", tree[el++].key);
                else
                    printf("%d ", tree[el++].key);
            }
        }
        for(j = 0; j < ((elements_lst-(1 << i))*3)/2; ++j)
            printf(" ");
        printf("\n");
        level++;
    }
}

void  _avl_insert(int value, int key){
    if(++__tree_str->elements_count ==  __tree_str->array_length){
        //realloc
    }
    _avl_insert_r(value, key, 0);    
}

void _avl_insert_r(int value, int key, size_t index){
    if(__tree_str->tree[index].init){
        if(__tree_str->tree[index].key < key){
            //add increasing left/right subtree height and rotation if diffrence if > 1
            _avl_insert_r(value, key, RIGHT_CHILD(index));
        }
        else{
            _avl_insert_r(value, key, LEFT_CHILD(index));
        }
    }
    else{
        __tree_str->tree[index].init  = true;
        //__tree_str->tree[index].value = value;
        __tree_str->tree[index].weight =   0; 
        __tree_str->tree[index].key    = key;
        _avl_check_h(index, false);
    }
}

void _avl_check_h(size_t index, bool del){
    if(index == 0)
        return;
    size_t p = PARENT(index);
    if(index == LEFT_CHILD(p)){
        if(!del)
            __tree_str->tree[p].weight--;
        else{
            __tree_str->tree[p].weight++;
            index = RIGHT_CHILD(p);
        }         
    }
    else{
        if(!del)
            __tree_str->tree[p].weight++;
        else{
            __tree_str->tree[p].weight--; 
            index = LEFT_CHILD(p);
        }   
    }

    if(__tree_str->tree[p].weight == -2){  
        if(__tree_str->tree[index].weight <= 0){
            _avl_rotatel(index);
            __tree_str->tree[RIGHT_CHILD(p)].weight = 0;
            __tree_str->tree[p].weight = 0;
        }
        else{
            _avl_rotater(RIGHT_CHILD(index));
            _avl_rotatel(index);
            if(__tree_str->tree[p].weight == -1){
                __tree_str->tree[index].weight = 1;
                __tree_str->tree[RIGHT_CHILD(p)].weight = 0;
            }
            else{
                __tree_str->tree[index].weight = 0;
                __tree_str->tree[RIGHT_CHILD(p)].weight = -1;
            }
            __tree_str->tree[p].weight = 0;         
        }
        return;
    }         
    else if(__tree_str->tree[p].weight == 2){   
        if(__tree_str->tree[index].weight >= 0){   
            _avl_rotater(index);            
            __tree_str->tree[LEFT_CHILD(p)].weight = 0;
            __tree_str->tree[p].weight = 0;                
        }
        else{
            _avl_rotatel(LEFT_CHILD(index));
            _avl_rotater(index);
            if(__tree_str->tree[p].weight == -1){
                __tree_str->tree[index].weight = 1;
                __tree_str->tree[LEFT_CHILD(p)].weight = 0;
            }
            else{
                __tree_str->tree[index].weight = 0;
                __tree_str->tree[LEFT_CHILD(p)].weight = -1;
            }
            __tree_str->tree[p].weight = 0;                    
        }
        return;              
    }      
    if(__tree_str->tree[p].weight != 0 && !del)
        _avl_check_h(p, false);
    if(__tree_str->tree[p].weight == 0 && del){

        _avl_check_h(p, true);
    }
}
void _avl_del_i(size_t index){
    if(!__tree_str->tree[LEFT_CHILD(index)].init && 
    !__tree_str->tree[RIGHT_CHILD(index)].init){
        __tree_str->tree[index].init = false;
        _avl_check_h(index, true);
        return;
    }
    else if(!__tree_str->tree[LEFT_CHILD(index)].init &&
    __tree_str->tree[RIGHT_CHILD(index)].init){
        __tree_str->tree[index].key = __tree_str->tree[RIGHT_CHILD(index)].key;
        _avl_del_i(RIGHT_CHILD(index));
        return;
    }
    else if(__tree_str->tree[LEFT_CHILD(index)].init &&
    !__tree_str->tree[RIGHT_CHILD(index)].init){
        __tree_str->tree[index].key = __tree_str->tree[LEFT_CHILD(index)].key;
        _avl_del_i(LEFT_CHILD(index));
        return;
    }
    size_t mnin = _avl_min(RIGHT_CHILD(index));
    __tree_str->tree[index].key = __tree_str->tree[mnin].key;         
    _avl_del_i(mnin); 
}
bool _avl_delete(int value){
    int index = _avl_search(value, 0);
    if(index == -1)
        return false;
    _avl_del_i((size_t)index);
    __tree_str->elements_count--;
    return true;
}
int _avl_search(int value, size_t index){
    if(__tree_str->tree[index].init){
        if(__tree_str->tree[index].key == value)
            return index;
        else if(__tree_str->tree[index].key < value){
            //add increasing left/right subtree height and rotation if diffrence if > 1
            return _avl_search(value, RIGHT_CHILD(index));
        }
        else{
            return _avl_search(value, LEFT_CHILD(index));
        }
    }
    return -1;
}
size_t _avl_min(size_t index){
    if(__tree_str->tree[index].init)
        return _avl_min(LEFT_CHILD(index));
    return PARENT(index);            
}

size_t _avl_max(size_t index){
    if(__tree_str->tree[index].init)
        return _avl_max(RIGHT_CHILD(index));
    return PARENT(index);              
}

void  _avl_init  (size_t init_size, size_t key_length, size_t value_length){
    if(__tree_str != NULL){
        printf("Avl tree is already initialized!\n");
        exit(EXIT_FAILURE);
    }
    __tree_str = (__avl_tree*)malloc(sizeof(__avl_tree));
    __tree_str->type_length    = value_length;
    __tree_str->key_length     = key_length  ;
    __tree_str->array_length   = init_size   ;
    __tree_str->elements_count = 0           ;
    __tree_str->tree = (__avl_verticle*)malloc(sizeof(__avl_verticle) * init_size);       
    if(__tree_str->tree == NULL){
        fprintf(stderr, "%s\n", strerror(errno));
        exit(EXIT_FAILURE);
    }  
    if(__tree_buffer != NULL){
        printf("Avl buffer is already initialized!\n");
        exit(EXIT_FAILURE);
    }
    __tree_buffer = (__avl_verticle*)malloc(sizeof(__avl_verticle) * init_size);
    if(__tree_buffer == NULL){
        fprintf(stderr, "%s\n", strerror(errno));
        exit(EXIT_FAILURE);
    }
    size_t i;
    for(i = 0; i < init_size; ++i){
        __tree_str->tree[i].init = false;
        __tree_buffer[i].init    = false;
    }
}
void _avl_uninit(void){
    printf("weigth %d\n", __tree_str->tree[2].weight);
    free(__tree_str->tree);
    free(__tree_str);
    free(__tree_buffer);
    __tree_buffer = NULL;
    __tree_str    = NULL;
}

bool _check_bt(size_t index){
    if(!__tree_str->tree[index].init)
        return true;
    bool t1 = true;
    bool t2 = true;
    if(__tree_str->tree[LEFT_CHILD(index)].init){
        if(__tree_str->tree[LEFT_CHILD(index)].key > __tree_str->tree[index].key)
            return false;
        t1 = _check_bt(LEFT_CHILD(index));
    }
    if(__tree_str->tree[RIGHT_CHILD(index)].init){
        if(__tree_str->tree[RIGHT_CHILD(index)].key < __tree_str->tree[index].key)
            return false;
        t2 = _check_bt(RIGHT_CHILD(index));
    }
    if(!t1 || !t2){
        return false;
    }
    return true;
}

int _avl_valueAt(size_t index){
    return __tree_str->tree[index].key;
}