#include "avl_list.h"


void pop(us* i){
    *(i) = queue_nr[queue_c++];
    queue[*(i)].id = queue_c-1;
}
void push(us* i){
    queue_nr[--queue_c] = i;
}

us _avl_rotater(us pr, us ch){
    us tmp = RIGHT(ch);
    LEFT(pr) = tmp;
    if(tmp != NULL)
        tmp->parent = pr;
    ch->right = pr; 
    pr->parent = ch; 
    if(!ch->weight){
        pr->weight++;
        ch->weight--;
    } 
    else{
        pr->weight = 0;
        ch->weight = 0;
    }    
    return ch;
}

__avl_verticle* _avl_rotatel(__avl_verticle* pr, __avl_verticle* ch){
    __avl_verticle* tmp = ch->left;
    pr->right = tmp;
    if(tmp != NULL)
        tmp->parent = pr;
    ch->left = pr; 
    pr->parent = ch; 
    if(!ch->weight){
        pr->weight++;
        ch->weight--;
    } 
    else{
        pr->weight = 0;
        ch->weight = 0;
    }
    return ch;
}

__avl_verticle* _avl_rotaterl(__avl_verticle* pr, __avl_verticle* ch){
    __avl_verticle* gc  = ch->left;
    __avl_verticle* tmp = gc->right;
    ch->left = tmp;
    if(tmp != NULL)
        tmp->parent = ch;
    gc->right = ch;
    ch->parent = gc;
    tmp = gc->left;
    pr->right = tmp;
    if(tmp != NULL)
        tmp->parent = pr;
    ch->left = pr; 
    pr->parent = gc; 
    if(gc->weight > 0){
        pr->weight = -1;    
        ch->weight = 0;
    } 
    else{
        if(!gc->weight){
            pr->weight = 0;
            ch->weight = 0;
        }
        else{
            pr->weight = 0;
            ch->weight++;
        }
    }
    gc->weight = 0;
    return gc;
}

__avl_verticle* _avl_rotatelr(__avl_verticle* pr, __avl_verticle* ch){
    __avl_verticle* gc  = ch->left;
    __avl_verticle* tmp = gc->right;
    ch->right = tmp;
    if(tmp != NULL)
        tmp->parent = ch;
    gc->left = ch;
    ch->parent = gc;
    tmp = gc->right;
    pr->left = tmp;
    if(tmp != NULL)
        tmp->parent = pr;
    ch->right = pr; 
    pr->parent = gc; 
    if(gc->weight > 0){
        pr->weight = -1;    
        ch->weight = 0;
    } 
    else{
        if(!gc->weight){
            pr->weight = 0;
            ch->weight = 0;
        }
        else{
            pr->weight = 0;
            ch->weight++;
        }
    }
    gc->weight = 0;
    return gc;
}
//usage key, root, NULL);
void _avl_insert_r(int key, __avl_verticle* r, __avl_verticle* p){
    if(r != NULL){
        //dont insert same value
        if(r->key == key)
            return;
        if(r->key < key){
            if(r->right != NULL){
                _avl_insert_r(key, r->right, r);
                return;
            }
            r->right = &queue[queue_nr[queue_c++]];
            r->right->id = queue_c-1;
            p = r;
            r = r->right;
        }
        else{
            if(r->left != NULL){
                _avl_insert_r(key, r->left, r);
                return;
            }
            r->left = &queue[queue_nr[queue_c++]];
            r->left->id = queue_c-1;
            p = r;     
            r = r->left;      
        }       
    }
    if(r == NULL){
        r = &queue[queue_nr[queue_c++]];
        r->id = queue_c-1;
    }
    r->weight = 0;
    r->key = key;
    r->left = NULL;
    r->right = NULL;
    r->parent = p;
    if(p == NULL){
        __tree = r;
        return;
    }
    _avl_check_i(r);
}

bool left_child(__avl_verticle* i){
    if(i->parent->left != NULL){
        if(i->parent->left->key == i->key)
            return true;
        return false;
    }
    return false;
}

void  _avl_check_d(__avl_verticle* child){
    __avl_verticle* tmp = NULL;
    __avl_verticle* tmp2 = NULL;
    short t;
    for(__avl_verticle* parent = child->parent; parent != NULL; parent = tmp){
        tmp = parent->parent;
        if(left_child(child)){
            if(parent->weight > 0){
                tmp2 = parent->right;
                t = tmp2->weight;
                if(t < 0)
                    child = _avl_rotaterl(parent, tmp2);
                else
                    child = _avl_rotatel(parent, tmp2);
            }
            else{
                if(!parent->weight){
                    parent->weight++;
                    break;
                }
                child = parent;
                child->weight = 0;
                continue;
            }
        }
        else{
            if(parent->weight < 0){
                tmp2 = parent->left;
                t = tmp2->weight;
                if(t > 0)
                    child = _avl_rotatelr(parent, tmp2);
                else
                    child = _avl_rotater(parent, tmp2);
            }
            else{
                if(!parent->weight){
                    parent->weight--;
                    break;
                }
                child = parent;
                child->weight = 0;
                continue;
            }
        }
        child->parent = tmp;
        if(tmp != NULL){
            if(left_child(parent))
                tmp->left = child;
            else
                tmp->right = child;
            if(t == 0)
                break;
        }
        else
            __tree = child;
    }
}

void _avl_check_i(__avl_verticle* child){
    for(__avl_verticle* parent = child->parent; parent != NULL; parent = parent->parent){
        __avl_verticle* tmp = NULL;
        __avl_verticle* tmp2 = NULL;       
        if(!left_child(child)){
            if(parent->weight > 0){
                tmp = parent->parent;
                if(child->weight < 0)
                    tmp2 = _avl_rotaterl(parent, child);
                else
                    tmp2 = _avl_rotatel(parent, child);
            }
            else{
                if(parent->weight < 0){
                    parent->weight = 0;
                    break;
                }
                parent->weight++;
                child = parent;
                continue;
            }
        }
        else{
            if(parent->weight < 0){
                tmp = parent->parent;
                if(child->weight > 0)
                    tmp2 = _avl_rotatelr(parent, child);
                else
                    tmp2 = _avl_rotater(parent, child);
                
            }
            else{
                if(parent->weight > 0){
                    parent->weight = 0;
                    break;
                }
                parent->weight--;
                child = parent;
                continue;
            }
        }
        tmp2->parent = tmp;
        if(tmp != NULL){
            if(!left_child(parent))
                tmp->left = tmp2;
            else
                tmp->right = tmp2;
        }
        else{
            __tree = tmp2;
            break;
        }
    }
}

void update_parent(__avl_verticle* i){        
    if(i->parent != NULL){
        if(left_child(i))
            i->parent->left = NULL;            
        else
            i->parent->right = NULL;             
        return;
    }
}

void _avl_del_i(__avl_verticle* index){
    
    // right not left null
    if(index->left == NULL && index->right == NULL){   
        _avl_check_d(index);           
        if(index->parent == NULL)
            __tree = NULL;     
        update_parent(index);            
        push(index); 
        return;
    }
    else if(index->left == NULL && index->right != NULL){                
        update_parent(index);        
        if(index->parent == NULL)
            __tree = index->right;       
        index->right->parent = index->parent;    
        index->parent = index->right;        
        index->left = index->right->left;
        if(index->left != NULL)
            index->left->parent = index;
        index->right = index->right->right;
        if(index->right != NULL)
            index->right->parent = index;
        index->parent->left  = NULL;
        index->parent->right = index;   
        _avl_del_i(index);
        return;
    }
    else if(index->left != NULL && index->right == NULL){
        update_parent(index);
        if(index->parent == NULL)
            __tree = index->left;
        index->left->parent = index->parent;
        index->parent = index->left;
        index->left = index->left->left;
        if(index->left != NULL)
            index->left->parent = index;
        index->right = index->left->right;
        if(index->right != NULL)
            index->right->parent = index;
        index->parent->right = NULL;
        index->parent->left = index;
        _avl_del_i(index);
        return;
    }
    __avl_verticle* mnin = _avl_min(index->right);
    if(index->parent != NULL){
        if(left_child(index))
            index->parent->left = mnin;          
        else
            index->parent->right = mnin;             
        return;
    }
    else
        __tree = mnin;     

    __avl_verticle* tmp = mnin->parent;
    mnin->parent = index->parent;
    if(mnin->key != index->right->key)
            index->parent = tmp;
    else
        index->parent = mnin;
    if(tmp->left != NULL){
        if(tmp->left->key == mnin->key){
            tmp->left = index;
        }
        else
            tmp->right = index;
    }
    else
        tmp->right = index;
    tmp = index->left;
    index->left = mnin->left;
    if(index->left != NULL)
        mnin->left->parent = index;
    mnin->left = tmp;
    tmp = index->right;            
    index->right = mnin->right;
    if(index->right != NULL)
        mnin->right->parent = index;
    if(tmp->key != mnin->key)
        mnin->right = tmp;       
    else
        mnin->right = index;   
    _avl_del_i(index);
}
bool _avl_delete(int value){
    __avl_verticle* index = _avl_search(value, __tree);
    if(index == NULL)
        return false;
    _avl_del_i(index);
    return true;
}
__avl_verticle* _avl_search(int value, __avl_verticle* index){
    if(index != NULL){
        if(index->key == value)
            return index;
        else if(index->key < value)
            return _avl_search(value, index->right);
        else
            return _avl_search(value, index->left);
    }
    return NULL;
}
__avl_verticle* _avl_min(__avl_verticle* index){
    if(index == NULL)
        return NULL;
    if(index->left != NULL)
        return _avl_min(index->left);
    return index;           
}
__avl_verticle* _avl_max(__avl_verticle* index){
    if(index == NULL)
        return NULL;
    if(index->right != NULL)
        return _avl_max(index->right);
    return index;               
}
int _avl_lower(int value, __avl_verticle* upp, int u){
    if(upp == NULL)
        return u;
    if(upp->key == value){
        return value;
    }
    if(upp->key > value)
        return _avl_lower(value, upp->left, u);
    else if(upp->key > u || u == INT_MIN)
        return _avl_lower(value, upp->right, upp->key);
    return u;
}
int _avl_upper(int value, __avl_verticle* upp, int u){
    if(upp == NULL)
        return u;
    if(upp->key == value){
        return value;
    }
    if(upp->key < value)
        return _avl_upper(value, upp->right, u);
    else if(upp->key < u || u == INT_MAX)
        return _avl_upper(value, upp->left, upp->key);
    return u;
}
void print_all(__avl_verticle* index){
    if(index != NULL){
        printf("%d ", index->key);
        print_all(index->left);
        print_all(index->right);
    }
}