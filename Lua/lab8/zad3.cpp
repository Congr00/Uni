#include <stdio.h>
#include <string.h>
#include <cstdlib>
#include <string>
#include <iostream>
#include <utility>
#include <vector>
#include <lua.hpp>



void error (lua_State *L, const char *fmt, ...) 
{
  va_list argp;
  va_start(argp, fmt);
  vfprintf(stderr, fmt, argp);
  va_end(argp);
  lua_close(L);
  exit(1);
}

void load_file(lua_State *L, const char *fname) 
{
  if (luaL_loadfile(L, fname)  || lua_pcall(L, 0, 0, 0))
    error(L, "cannot load file: %s\n", lua_tostring(L, -1));
}

std::vector<std::vector<std::string>> board;

bool find_global(lua_State* L, const char *gname){
    lua_getglobal(L, gname);
    if (! lua_istable (L , -1)){
        std::cout << "global " << gname << " doesn't exists!\n";
        lua_pop(L, 1);
        return false;
    }
    std:: cout << "trying global " << gname << "\n";     
    for(int i = 0; ;i++){    
        std::vector<std::string> row;
        board.push_back(row);
        lua_pushinteger(L, i+1);
        lua_gettable(L, -2);

        if(! lua_istable(L, -1)){
            break;        
            lua_pop(L, 1);
        }
        for(int j = 0; ; j++){
            lua_pushinteger(L, j+1);
            lua_gettable(L, -2);            
            if (lua_isstring(L, -1) != 0){
                std::string res = lua_tostring(L, -1);
                board[i].push_back(res);
                lua_pop(L, 1);
            }
            else{
                lua_pop(L, 1);                
                break;
            }
        }

        lua_pop(L, 1);
    }
    lua_pop(L, 2);
    return true; 
}

void find_all(lua_State* L){
    lua_pushglobaltable (L);
    lua_pushnil(L);
     while (lua_next(L, -2) != 0) {
       std::string key = lua_tostring(L, -2);
        if(key.substr(0, 6) == "level_"){
            find_global(L, key.c_str());
            for(unsigned int i = 0; i < board.size(); ++i){
                for(unsigned int j = 0; j < board[i].size(); ++j)
                    std::cout << board[i][j] << " ";
                std::cout << "\n";
            }               
            board.clear();          
        }
       lua_pop(L, 1);
     }          
}

int main(int argc, char** argv){

    lua_State *L = luaL_newstate();
    luaL_openlibs(L);    

    load_file(L, "boards.lua");

    while(true){
        std::string in = "";
        std::cin >> in;

        if(in == ("ALL")){
            // display all
            find_all(L);
        }
        else{
            find_global(L, ("level_" + in).c_str());
        }

        for(unsigned int i = 0; i < board.size(); ++i){
            for(unsigned int j = 0; j < board[i].size(); ++j)
                std::cout << board[i][j] << " ";
            std::cout << "\n";
        }

        board.clear();
    }


    return EXIT_SUCCESS;
}