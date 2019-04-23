#include <stdio.h>
#include <string.h>
#include <lua.hpp> 


static void stackDump (lua_State *L) 
{
  int i;
  int top = lua_gettop(L);
  for (i = 1; i <= top; i++) // odwiedzamy elementy od dołu
  {
    int t = lua_type(L, i);
    switch (t) 
    {
    case LUA_TSTRING: // napis
      printf("’%s’", lua_tostring(L, i));
      break;
    case LUA_TBOOLEAN: // wartość logiczna
      printf(lua_toboolean(L, i) ? "true" : "false");
      break;
    case LUA_TNUMBER: // liczby
      //printf("%g", lua_tonumber(L, i)); // jeśli nie chcemy rozróżniać int/float (Lua < 5.3)
      if (lua_isinteger(L, i)) // integer
        printf("%lld", lua_tointeger(L, i));
      else // float
        printf("%g", lua_tonumber(L, i));
      break;
    default: // pozostałe
      printf("%s", lua_typename(L, t)); // drukuje nazwę typu
      break;
    }
    printf(" "); // separator
  }
  printf("\n");
}


int main (void) 
{
  lua_State *L = luaL_newstate();
  
  lua_pushboolean(L, 1);
  lua_pushnumber(L, 10);
  lua_pushnil(L);
  lua_pushstring(L, "hello");
                        stackDump(L); // true 10 nil ’hello’ 
  lua_pushvalue(L, -4); stackDump(L); // true 10 nil ’hello’ true 
  lua_replace(L, 3);    stackDump(L); // true 10 true ’hello’ 
  lua_settop(L, 6);     stackDump(L); // true 10 true ’hello’ nil nil 
  lua_rotate(L, 3, 1);  stackDump(L); // true 10 nil true 'hello' nil 
  lua_remove(L, -3);    stackDump(L); // true 10 nil 'hello' nil 
  lua_settop(L, -5);    stackDump(L); // true 

  lua_close(L);

  return 0;
}