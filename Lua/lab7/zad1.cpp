
#include <lua.hpp> 
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


int main (void) 
{
    lua_State *L = luaL_newstate();
                                 stackDump(L);
    lua_pushnumber(L, 3.5);      stackDump(L); 
    lua_pushstring(L, "hello");  stackDump(L);
    lua_pushstring(L, "word");   stackDump(L);    
    lua_pushnil(L);              stackDump(L);
    lua_pushvalue(L, -2);        stackDump(L);
    lua_remove(L, 1);            stackDump(L);
    lua_insert(L, -2);           stackDump(L);     

    lua_close(L);

    return 0;
}