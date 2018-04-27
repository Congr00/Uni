#include "avl.h"

void _avl_rotate(size_t index){
    size_t tmp = __tree_str->tree[index];
    size_t parent = PARENT(index);
    size_t l_child = LEFT_CHILD(index);
    size_t r_child = RIGHT_CHILD(index);
    size_t lp_child = LEFT_CHILD(PARENT(index));
    size_t rp_child = RIGHT_CHILD(PARENT(index));
    if(lp_child == index){
        __tree_str->tree[index] = __tree_str->tree[l_child];
        //propably need to switch to listed tree
        //impossible(?) to do rotation with O(1) time using tree stored in an array
        //after that its ezz and lazz and definitly in O(1)
    }
    else{ // we are right child
    }
}

void  _avl_print(){
    if(__tree_str == NULL){
        printf("Cannot print NULL object \n");
        exit(EXIT_FAILURE);
    }
    size_t i,j, level = 0;
    size_t el = 0;
    size_t tree_lvls = (size_t)ceil(log2(__tree_str->elements_count));
    size_t elements_lst = (1 << (tree_lvls - 1));
    for(i = 0; i < tree_lvls; ++i){
        for(j = 0; j < ((elements_lst-(1 << i))*3)/2; ++j)
            printf(" "); 
        for(j = 0; j < (size_t)(1 << i); ++j){
            if(!__tree_str->tree[i].init){
                printf("  ");
                continue;
            }            
            if((size_t)floor(log10(__tree_str->tree[i].key)) < 1){
                if(__tree_str->tree[i].key >= 0)
                    printf(" ");
                printf("%d ", __tree_str->tree[el++].key);
            }
            else{
                if(__tree_str->tree[i].key < 0)
                    printf("%d", __tree_str->tree[el++].key);
                else
                    printf("%d ", __tree_str->tree[el++].key);
            }
        }
        for(j = 0; j < ((elements_lst-(1 << i))*3)/2; ++j)
            printf(" ");
        printf("\n");
        level++;
    }
}

void  _avl_insert(int value, int key){
    if(++__tree_str->elements_count == __tree_str->array_length){
        //realloc
    }
    _avl_insert_r(value, key, 0);
}

void _avl_insert_r(int value, int key, size_t index){
    if(__tree_str->tree[index].init){
        if(__tree_str->tree[index].key <= key){
            //add increasing left/right subtree height and rotation if diffrence if > 1
            _avl_insert_r(value, key, RIGHT_CHILD(index));
        }
        else{
            _avl_insert_r(value, key, LEFT_CHILD(index));
        }
    }
    else{
        __tree_str->tree[index].init  = true;
        __tree_str->tree[index].value = value;
        __tree_str->tree[index].key   = key;
    }
}
void  _avl_delete(void* value){

}
void* _avl_search(void* value){
// just copy-paste insert and remove useless parts
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
    size_t i;
    for(i = 0; i < init_size; ++i)
        __tree_str->tree[i].init = false;
}
void _avl_uninit(void){
    free(__tree_str->tree);
    free(__tree_str);
    __tree_str = NULL;
}