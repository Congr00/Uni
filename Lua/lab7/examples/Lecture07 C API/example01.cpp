#include <stdio.h>
#include <string.h>
#include <lua.hpp> 

// Styl łamany: C/C++

int main (void) 
{
  char buff[256];
  int error;
  lua_State *L = luaL_newstate();  // tworzymy nowy stan Lua
  luaL_openlibs(L);                // otwieramy biblioteki standardowe 
  while (fgets(buff, sizeof(buff), stdin) != NULL) 
  {
    error = luaL_loadstring(L, buff)    // kompilujemy bufor za pomocą 'loadstring'
              || lua_pcall(L, 0, 0, 0); // i uruchamiamy z wierzchu stosu przy użyciu 'pcall'
    if (error) 
    {
      fprintf(stderr, "%s", lua_tostring(L, -1)); // drukujemy pozostawiony na stosie komunikat błędu
      lua_pop(L, 1);                              // i zrzucamy go ze stosu
    }
  }
  lua_close(L);
  return 0;
}

// Pełny C++
/*
#include <string>
#include <iostream>
using namespace std;
int main (void) 
{
  string line;
  int error;
  lua_State *L = luaL_newstate();
  luaL_openlibs(L);
  while (!getline(cin,line).eof()) 
  {
    error = luaL_loadstring(L, line.c_str()) || lua_pcall(L, 0, 0, 0);
    if (error) 
    {
      std::cerr << lua_tostring(L, -1);
      lua_pop(L, 1); 
    }
  }
  lua_close(L);
  return 0;
}
*/
