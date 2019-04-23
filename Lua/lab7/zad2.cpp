#include <stdio.h>
#include <string.h>
#include <cstdlib>
#include <string>
#include <iostream>
#include <lua.hpp> 

using namespace std;

void error (lua_State *L, const char *fmt, ...) 
{
  va_list argp;
  va_start(argp, fmt);
  vfprintf(stderr, fmt, argp);
  va_end(argp);
  lua_close(L);
  exit(1);
}

// zwracamy wartość typu int zapisaną w globalnej zmiennej varname
int getglobalint (lua_State *L, const char *varname)
{
  int isnum, result;
  
  lua_getglobal(L, varname); // wstawiamy zmienną globalną varname na stos
  result = (int)lua_tointegerx(L, -1, &isnum); // odczytujemy ze stosu jej wartość
  
  if (!isnum) // sprawdzamy czy się poprawnie wczytała
    error(L, "'%s' should be a number\n", varname);
    
  lua_pop(L, 1); // usuwamy wczytaną wartość ze stosu
  return result;
}

float getglobalfloat(lua_State *L, const char *varname){
  int isnum;
  float result;
  lua_getglobal(L, varname); // wstawiamy zmienną globalną varname na stos
  result = (float)lua_tonumberx(L, -1, &isnum); // odczytujemy ze stosu jej wartość
  if (!isnum) // sprawdzamy czy się poprawnie wczytała
    error(L, "'%s' should be a number\n", varname);
  lua_pop(L, 1); // usuwamy wczytaną wartość ze stosu
  return result;
}

std::string getglobalstring(lua_State *L, const char *varname){
  std::string result;
  lua_getglobal(L, varname); // wstawiamy zmienną globalną varname na stos
  const char* ptr = lua_tostring(L, -1); // odczytujemy ze stosu jej wartość
  if (ptr == NULL) // sprawdzamy czy się poprawnie wczytała
    error(L, "'%s' should be a string\n", varname);
  result = std::string(ptr);
  lua_pop(L, 1); // usuwamy wczytaną wartość ze stosu
  return result;
}



void load_cfg (lua_State *L, const char *fname, std::string& verbose_lvl, int& h, float& ratio ) 
{
  if (luaL_loadfile(L, fname)  || lua_pcall(L, 0, 0, 0))
    error(L, "cannot load config file: %s\n", lua_tostring(L, -1));

  h = getglobalint(L, "window_height");
  ratio = getglobalfloat(L, "window_ratio");
  verbose_lvl = getglobalstring(L, "verbose_level");
}


int main (void) 
{
  int height;
  std::string verb_lvl;
  float ratio;

  lua_State *L = luaL_newstate();
  
  lua_pushinteger(L, 100);
  lua_setglobal(L, "verbose");


  load_cfg(L, "zad2.lua", verb_lvl, height, ratio);

  cout << "> config file loaded" << endl;

  cout << "height: " << height << endl << "verbose level: " << verb_lvl << endl << "ratio: " << ratio << endl;

  lua_pushinteger(L, 5);
  lua_setglobal(L, "verbose");

  load_cfg(L, "zad2.lua", verb_lvl, height, ratio);

  cout << "> config file loaded with diffrent verbose" << endl;

  cout << "height: " << height << endl << "verbose level: " << verb_lvl << endl << "ratio: " << ratio << endl; 

  lua_pushinteger(L, 2);
  lua_setglobal(L, "verbose");

  load_cfg(L, "zad2.lua", verb_lvl, height, ratio);

  cout << "> config file loaded with diffrent verbose" << endl;

  cout << "height: " << height << endl << "verbose level: " << verb_lvl << endl << "ratio: " << ratio << endl;    

  lua_close(L);

  return 0;
}