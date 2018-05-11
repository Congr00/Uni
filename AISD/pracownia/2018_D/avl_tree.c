
#include "avl_tree.h"

us _avl_rotatel(us  X, us Z){
    us t23 = PTR(Z).left;
    PTR(X).right = t23;
    if(t23 != 0)
        PTR(t23).parent = X;
    PTR(Z).left = X; 
    PTR(X).parent = Z;
    if(PTR(Z).weight == 0){
        PTR(X).weight = 1;
        PTR(Z).weight = -1;
    }
    else{
        PTR(X).weight = 0;
        PTR(Z).weight = 0;
    }    
    return Z;
}
us _avl_rotater(us  X, us Z){
    us t23 = PTR(Z).right;
    PTR(X).left = t23;
    if(t23 != 0)
        PTR(t23).parent = X;
    PTR(Z).right = X; 
    PTR(X).parent = Z;
    if(PTR(Z).weight == 0){
        PTR(X).weight = -1;
        PTR(Z).weight = 1;
    }
    else{
        PTR(X).weight = 0;
        PTR(Z).weight = 0;
    }    
    return Z;
}

us _avl_rotaterl(us X, us Z){   
    us Y  = PTR(Z).left;
    us t3 = PTR(Y).right;
    PTR(Z).left = t3;
    if(t3 != 0)
        PTR(t3).parent = Z;
    PTR(Y).right = Z;
    PTR(Z).parent = Y;
    us t2 = PTR(Y).left;
    PTR(X).right = t2;
    if(t2 != 0)
        PTR(t2).parent = X;
    PTR(Y).left = X;
    PTR(X).parent = Y;
    if(PTR(Y).weight > 0){
        PTR(X).weight = -1;
        PTR(Z).weight = 0;
    } 
    else{
        if(PTR(Y).weight == 0){
            PTR(X).weight = 0;
            PTR(Z).weight = 0;
        }
        else{
            PTR(X).weight = 0;
            PTR(Z).weight = 1;
        }
    }
    PTR(Y).weight = 0;
    return Y;
}

us _avl_rotatelr(us X, us Z){   
    us Y  = PTR(Z).right;
    us t3 = PTR(Y).left;
    PTR(Z).right = t3;
    if(t3 != 0)
        PTR(t3).parent = Z;
    PTR(Y).left = Z;
    PTR(Z).parent = Y;
    us t2 = PTR(Y).right;
    PTR(X).left = t2;
    if(t2 != 0)
        PTR(t2).parent = X;
    PTR(Y).right = X;
    PTR(X).parent = Y;
    if(PTR(Y).weight > 0){
        PTR(X).weight = 0;
        PTR(Z).weight = -1;
    } 
    else{
        if(PTR(Y).weight == 0){
            PTR(X).weight = 0;
            PTR(Z).weight = 0;
        }
        else{
            PTR(X).weight = 1;
            PTR(Z).weight = 0;
        }
    }
    PTR(Y).weight = 0;
    return Y;
}

void _avl_insert_r(long key, us r, us p){
    if(r != 0){
        if(PTR(r).key == key)
            return;     
        if(PTR(r).key < key){         
            if(PTR(r).right != 0){
                _avl_insert_r(key, PTR(r).right, r);
                return;
            }
            PTR(r).right = POP();
            p = r;
            RIGHT(r).id = PTR(r).right;
            r = RIGHT(r).id;
        }
        else{
            if(LEFT(r).id != 0){
                _avl_insert_r(key, PTR(r).left, r);
                return;
            }
            PTR(r).left = POP();
            p = r;
            LEFT(r).id = PTR(r).left;
            r = LEFT(r).id;
        }         
    }  
    if(r == 0)
        r = POP();
    PTR(r).weight = 0;
    PTR(r).key = key;
    PTR(r).left = 0;
    PTR(r).right = 0;
    PTR(r).id = r;
    PTR(r).parent = p;          
    if(p == 0){
        __tree = r;
        return;
    }
    _avl_check_i(r);     
}

bool left_child(us i){
    if(PARENT(i).left != 0){
        if(PTR(PARENT(i).left).key == PTR(i).key)
            return true;
        return false;
    }
    return false;
}

void  _avl_check_d(us N){
    if(N == 0)
        return;
    if(PTR(N).weight == 0 && PTR(N).parent != 0){
        if(left_child(N))
            PARENT(N).weight++;
        else
            PARENT(N).weight--;
        _avl_check_d(PTR(N).parent);
    }
    else if(PTR(N).weight == -2){
        us g   = PTR(N).parent;
        us res = 0;
        if(LEFT(N).weight == 1){
            res = _avl_rotatelr(N, PTR(N).left);
        }      
        else{
            res = _avl_rotater(N, PTR(N).left);
        }
        PTR(res).parent = g;
        if(g != 0){
            if(N == PTR(g).left)
                PTR(g).left = res;
            else
                PTR(g).right = res;
        }
        else{
            __tree = res;
            return;
        }
        _avl_check_d(res);
    }
    else if(PTR(N).weight == 2){
        us g   = PTR(N).parent;
        us res = 0;
        if(RIGHT(N).weight == -1){     
            res = _avl_rotaterl(N, PTR(N).right);
        }
        else{
            res = _avl_rotatel(N, PTR(N).right);
        }
        PTR(res).parent = g;     
        if(g != 0){
            if(N == PTR(g).left)
                PTR(g).left = res;
            else
                PTR(g).right = res;
        }
        else{
            __tree = res;
            return;
        }
        _avl_check_d(res);        
    }
}

void _avl_check_i(us Z){
    for(us X = PTR(Z).parent; X != 0; X = PTR(Z).parent){
        us G  = 0;
        us N  = 0;
        bool isleft = left_child(X);
        if(!left_child(Z)){
            if(PTR(X).weight > 0){
                G = PTR(X).parent;
                if(PTR(Z).weight < 0)
                    N = _avl_rotaterl(X, Z);
                else
                    N = _avl_rotatel(X, Z);
            }
            else{
                if(PTR(X).weight < 0){
                    PTR(X).weight = 0;
                    break;
                }
                PTR(X).weight = 1;
                Z = X;
                continue;
            }
        }
        else{
            if(PTR(X).weight < 0){
                G = PTR(X).parent;
                if(PTR(Z).weight > 0)
                    N = _avl_rotatelr(X, Z);
                else
                    N = _avl_rotater(X, Z);
                
            }
            else{
                if(PTR(X).weight > 0){
                    PTR(X).weight = 0;
                    break;
                }
                PTR(X).weight = -1;
                Z = X;
                continue;
            }
        }
        PTR(N).parent = G;
        if(G != 0){
            if(isleft)
                PTR(G).left = N;
            else
                PTR(G).right = N;
            break;
        }
        else{
            __tree = N;
            break;
        }  
    }    
}

void update_parent(us i, us v){        
    if(PTR(i).parent != 0){
        if(left_child(i))
            PARENT(i).left = v;//0
        else
            PARENT(i).right = v;//0       
        return;
    }
}   
void switch_vars(us* i, us* j){ 
    us tmp = *i;    
    *i = *j;
    *j = tmp;
}

void switch_nodes(us i, us j){
   short tmp = PTR(i).weight;
   PTR(i).weight = PTR(j).weight;
   PTR(j).weight = tmp;
    if(PTR(i).parent == 0){
        __tree = j;
        if(PTR(i).id != PTR(j).parent){
            if(left_child(j))
                PARENT(j).left = i;
            else
                PARENT(j).right = i;
        }
    }
    else{
        //if i is left child, update parent left node to j
        if(left_child(i))
            PARENT(i).left = j;
        else
            PARENT(i).right = j;
        //i isnt parent of j        
        if(PTR(i).id != PTR(j).parent){
            if(left_child(j))
                PARENT(j).left = i;
            else
                PARENT(j).right = i;
        }
    }
    
    //change parents of i and j
    //if i isnt parent of j
    if(PTR(i).id != PTR(j).parent)
        switch_vars(&PTR(i).parent, &PTR(j).parent);
    //else i's new parent is j, j is still i's old parent
    else{
        PTR(j).parent = PTR(i).parent;
        PTR(i).parent = j;
    }
    //update i,j sons pointers to them if they exist and j (PTR(i))snt i's new parent
    if(PTR(i).left == j){
        switch_vars(&PTR(j).right, &PTR(i).right);
        PTR(i).left = PTR(j).left;          
        PTR(j).left = i;
    }
    else if(PTR(i).right == j){
        switch_vars(&PTR(j).left, &PTR(i).left);
        PTR(i).right = PTR(j).right;          
        PTR(j).right = i;        
    }
    else{
        switch_vars(&PTR(j).left, &PTR(i).left);
        switch_vars(&PTR(j).right, &PTR(i).right);
    }
    //update new parents to sons of i and j
    if(PTR(i).left != 0)
        LEFT(i).parent = i;
    if(PTR(i).right != 0)
        RIGHT(i).parent = i;
    if(PTR(j).left != 0)
        LEFT(j).parent = j;
    if(PTR(j).right != 0)
        RIGHT(j).parent = j;
    
}

void _avl_del_i(us index){
    if(PTR(index).left == 0 && PTR(index).right == 0){    
        PUSH(index);           
        if(PTR(index).parent == 0){
            __tree = 0;            
            return;
        }               
        _avl_check_d(index);
        update_parent(index, 0);                            
        return;
    }
    else if(PTR(index).right != 0){    
        us mnix = _avl_min(RIGHT(index).id);           
        switch_nodes(index, mnix);
        _avl_del_i(index);
    }
    else{      
        us mnin = _avl_max(LEFT(index).id);           
        switch_nodes(index, mnin);
        _avl_del_i(index);
    }
}
bool _avl_delete(long value){
    us index = _avl_search(value, __tree);
    if(index == 0)
        return false;
    _avl_del_i(index);
    return true;
}
us _avl_search(long value, us index){
    if(index != 0){
        if(PTR(index).key == value)
            return index;
        else if(PTR(index).key < value)
            return _avl_search(value, PTR(index).right);
        else
            return _avl_search(value, PTR(index).left);
    }
    return 0;
}
us _avl_min(us index){
    if(index == 0)
        return 0;
    if(PTR(index).left != 0)
        return _avl_min(PTR(index).left);
    return index;
}
us _avl_max(us index){
    if(index == 0)
        return 0;
    if(PTR(index).right != 0)
        return _avl_max(PTR(index).right);
    return index;               
}
long _avl_upper(long value, us upp){
    if(upp == 0)
        return LONG_MAX;   
    if(value == PTR(upp).key)
        return value;
    long max = LONG_MAX;
    while(upp != 0){
        if(value == PTR(upp).key)
            return value;
        else if(value > PTR(upp).key)
            upp = PTR(upp).right;
        else{
            if(max > PTR(upp).key)
                max = PTR(upp).key;
            upp = PTR(upp).left;
        }
    }
    return max;
}
long _avl_lower(long value, us upp){  
    if(upp == 0)
        return LONG_MIN;   
    if(value == PTR(upp).key)
        return value;
    long min = LONG_MIN;
    while(upp != 0){
        if(value == PTR(upp).key)
            return value;
        else if(value < PTR(upp).key)
            upp = PTR(upp).left;
        else{
            if(min < PTR(upp).key)
                min = PTR(upp).key;
            upp = PTR(upp).right;
        }
    }
    return min;
}
void print_all(us index){
    if(index != 0){
        printf("%ld ", PTR(index).key);
        print_all(PTR(index).left);
        print_all(PTR(index).right);
    }
}

void print_ptr(us ptr){
    printf("key: %ld\nweight: %d\nid: %d\nleft: %ld\nright: %ld\n parent: %ld\narg: %d\n",
        PTR(ptr).key,
        PTR(ptr).weight,
        PTR(ptr).id,
        PTR(PTR(ptr).left).key,
        PTR(PTR(ptr).right).key,
        PTR(PTR(ptr).parent).key,
        ptr
    );
}