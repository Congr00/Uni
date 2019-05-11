#include <lua.hpp> 
#include <vector>


#include <iostream>
#include <string>


#define MAX_LINE 10

std::string format_string(std::string res){
    int diff = MAX_LINE - res.length();
    if (diff < 0) return res;
    return res.append(std::string(diff, ' '));
} 

static void stackDump (lua_State *L) 
{
    std::cout << "===>BoS" << std::endl;
    int top = lua_gettop(L);
    for(int i = 1; i <= top; i++){
        int t = lua_type(L, i);        
        std::cout << format_string(std::to_string(-top + i - 1)) << " ";
        std::string val_str;
        switch(t){
            case LUA_TSTRING  : val_str = lua_tostring(L, i);                  break;
            case LUA_TNUMBER  : val_str = std::to_string(lua_tonumber(L, i));  break;
            case LUA_TBOOLEAN : val_str = std::to_string(lua_toboolean(L, i)); break;
            default           : val_str = std::to_string(t);                    break;
        }
        std::cout << format_string(val_str) << " " << format_string(lua_typename(L, t)) << " " << i << std::endl;
    }
    std::cout << "EoS<===" << std::endl;
}


void error (lua_State *L, const char *fmt, ...) 
{
  va_list argp;
  va_start(argp, fmt);
  vfprintf(stderr, fmt, argp);
  va_end(argp);
  lua_close(L);
  exit(1);
}

static int summation(lua_State *L){
    double sum = 0;
    int top = lua_gettop(L);
    for(int i = 1; i <= top; i++){
        double num = luaL_checknumber(L, -1);
        sum += num;
        lua_pop(L, 1);
    }
    lua_pushnumber(L, sum);
    return 1;
}

static int filter(lua_State *L){
    if(! lua_istable(L, -1))
        error(L, "second argument isnt table!");

    lua_newtable(L); //result table
    int j = 1;

    int i;
    for(i = 1; ; i++){

        lua_pushnil(L);
        lua_copy(L, 1, -1); // copy function to call it

        lua_pushinteger(L, i);     
        lua_gettable(L, -4); // get ith value from input table
        if (lua_isnil(L, -1)){
            lua_pop(L, 2);
            break;
        }
        if (lua_pcall(L, 1, 1, 0) != LUA_OK)
            error(L, "error running function!");

        if(!lua_isboolean(L, -1))
            error(L, "'f' must return boolean values!");

        bool res = lua_toboolean(L, -1); // get result of Lua function
        lua_pop(L, 1);
        if (res){
            lua_pushinteger(L, j++); // key 

            lua_pushinteger(L, i);           
            lua_gettable(L, 2);      // value       
            
            lua_settable(L, 3);      // insert into result array            
        }
    } 
    return 1;
}

static int reverse(lua_State *L){
    if(! lua_istable(L, 1))
        error(L, "argument isnt table!");

    size_t len = lua_rawlen(L,1);

    for(size_t i = 1,j = len; i < j; ++i, --j){
        lua_pushinteger(L, i);        
        lua_pushinteger(L, j);
        lua_gettable(L, 1);
        lua_pushinteger(L, j);
        lua_pushinteger(L, i);
        lua_gettable(L, 1);        

        lua_settable(L, 1);
        lua_settable(L, 1);
    }     
    return 1;
}

static int join(lua_State *L){
    int top = lua_gettop(L);
    if(! lua_istable(L, 1))
        error(L, "argument isnt seqence!");    
    size_t len = lua_rawlen(L,1);

    for(int i = 2; i <= top; i++){
        if(! lua_istable(L, i))
            error(L, "argument isnt seqence!");           
        size_t sub_len = lua_rawlen(L, i);
        for(size_t j = 1; j <= sub_len; ++j){
            lua_pushinteger(L, ++len);
            lua_pushinteger(L, j);
            lua_gettable(L, i);
            lua_settable(L, 1);
        }
    }
    lua_pushnil(L);
    lua_copy(L, 1, top+1);
    return 1;
}

static int merge(lua_State *L){
    int top = lua_gettop(L);
    if(! lua_istable(L, 1))
        error(L, "argument isnt seqence!");    

    for(int i = 2; i <= top; i++){
        if(! lua_istable(L, i))
            error(L, "argument isnt seqence!");           
     /* table is in the stack at index 't' */
        lua_pushnil(L);  /* first key */
        while (lua_next(L, i) != 0) {
            /* uses 'key' (at index -2) and 'value' (at index -1) */

            // check if key exists in stack[1]
            // if doesnt insert it!
            //copy key from -2
            lua_pushnil(L);
            lua_copy(L, -3, -1);
            lua_gettable(L, 1);
            if (lua_isnil(L, -1)){
                lua_pop(L, 1);
                lua_pushnil(L);
                lua_pushnil(L);
                lua_copy(L, -4, -2);
                lua_copy(L, -3, -1);
                lua_settable(L, 1);
            }
            else{
                lua_pop(L, 1);
            }
            /* removes 'value'; keeps 'key' for next iteration */
            lua_pop(L, 1);
        }        
    }
    lua_pushnil(L);
    lua_copy(L, 1, top+1);
    return 1;
}

static const struct luaL_Reg zad1 [] = {
    {"summation", summation},
    {"filter", filter},
    {"reverse", reverse},
    {"join", join},
    {"merge", merge},
    {NULL, NULL}
};

extern "C" int luaopen_funcs(lua_State *L){
    luaL_newlib(L, zad1);
    return 1;
}