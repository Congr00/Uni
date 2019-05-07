#include <stdio.h>
#include <string.h>
#include <cstdlib>
#include <string>
#include <iostream>
#include <utility>
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


char board[3][3] = {
    {' ', ' ', ' '},
    {' ', ' ', ' '},
    {' ', ' ', ' '}};


char check_win(){      
    for(int i = 0; i < 3; ++i){
        if((board[i][0] == board[i][1]) && (board[i][1] == board[i][2]) && (board[i][1] != ' '))
            return board[i][0]; 
        else if((board[0][i] == board[1][i]) && (board[1][i] == board[2][i]) && (board[0][i] != ' '))
            return board[0][i];    
                     
    }
    if((board[0][0] == board[1][1]) && (board[1][1] == board[2][2]) && (board[0][0] != ' '))
        return board[0][0];
    if((board[2][0] == board[1][1]) && (board[1][1] == board[0][2]) && (board[1][1] != ' '))
        return board[2][0];
    for(int i = 0; i < 3; ++i){
        for(int j = 0; j < 3; ++j)
            if((board[i][j] == ' ') || (board[j][i] == ' '))
                return ' ';
    }
    return '\0';
}

void clear_board(){
    for(int i = 0; i < 3; ++i)
        for(int j = 0;j < 3; ++j)
            board[i][j] = ' ';
}

void print_board(){
    std::cout << board[0][0] << "|" << board[0][1] << "|" << board[0][2] << "\n";
    std::cout << "-----\n";
    std::cout << board[1][0] << "|" << board[1][1] << "|" << board[1][2] << "\n";
    std::cout << "-----\n";
    std::cout << board[2][0] << "|" << board[2][1] << "|" << board[2][2] << "\n";    
}


const char DRAW = '\0';
const char IN_PROGRESS = ' ';
char AI_WON1 = 'O';
char AI_WON2 = 'X';

void load_ai(lua_State *L, const char *fname) 
{
  if (luaL_loadfile(L, fname)  || lua_pcall(L, 0, 0, 0))
    error(L, "cannot load ai file: %s\n", lua_tostring(L, -1));
}

void l_pushtablestring(lua_State* L , int key , char* value) {
    lua_pushinteger(L, key);
    lua_pushlstring(L, value, 1);
    lua_settable(L, -3);
}



std::pair<int, int> make_move(lua_State *L, const char* symbol){
    lua_getglobal(L, "AI");
    // check if its function
    lua_pushstring(L, symbol);
    lua_newtable(L);     
    for(int i = 0; i < 3; ++i){
        lua_pushinteger(L, i+1);         
        lua_newtable(L);       
        for(int j = 0; j < 3; ++j)
            l_pushtablestring(L, j+1, &board[i][j]);                  
    }

    lua_settable(L, 3);     
    lua_settable(L, 3); 
    lua_settable(L, 3);     
    
    if (lua_pcall(L, 2, 2, 0) != LUA_OK)
        error(L, "error running AI");
    std::pair<int, int> res;
    int isnum;
    res.first = lua_tonumberx(L, -1, &isnum) - 1;
    if(!isnum || res.first < 0)
        error(L, "AI function returned wrong number!");
    lua_pop(L, 1);
    res.second = lua_tonumberx(L, -1, &isnum) - 1;
    if(!isnum || res.second < 0)
        error(L, "AI function returned wrong number!");
    lua_pop(L, 1);
    return res;    
}

int check_cond(bool print){
    char cond = check_win();
    if (cond == AI_WON1){
        if(print)
            std::cout << "AI1 won!!!\n";
        return 1;
    }
    else if (cond == AI_WON2){
        if(print)
            std::cout << "AI2 won!!!\n";
        return 2;
    }
    else if(cond == DRAW){
        if(print) 
            std::cout << "DRAW\n";
        return 0;
    }
    return -1;
}

int main(int argc, char** argv){



    lua_State *AI1 = luaL_newstate();
    lua_State *AI2 = luaL_newstate();

    luaL_openlibs(AI1);    
    luaL_openlibs(AI2);

    if((argc != 3) && (argc != 4)){
        std::cout << "need 2 ai files...\n";
        return EXIT_FAILURE; 
    }

    int count = 1;
    if (argc == 4)
        count = std::atoi(argv[3]);


    load_ai(AI1, argv[1]);
    load_ai(AI2, argv[2]);
    if(argc != 4)
        print_board();

    lua_State* players[2] = {AI1, AI2};
    int who[2] = {0, 1};
    int scores[2] = {0, 0};

    for(int i = 0; i < count; ++i){
        // who.shuffle()
        who[0] = rand() & 1; who[1] = !who[0];
        int cond = 0;


        while(true){
            if(argc != 4){
                int k = 0;
                std::cin >> k;
            }

            auto res = make_move(players[who[0]], "O");
            board[res.second][res.first] = 'O';
            if(argc != 4){
                std::cout<< "first ai moved:\n";
                print_board();
            }
            cond = check_cond(argc != 4);
            if(cond != -1) break;

            res = make_move(players[who[1]], "X");
            board[res.second][res.first] = 'X';

            if(argc != 4){
                std::cout<< "second ai moved:\n";
                print_board();        
            }
            cond = check_cond(argc != 4);
            if(cond != -1) break;        
        }

        //if(cond == 1)      ai1_s++;
        //else if(cond == 2) ai2_s++;

        if(cond == 1) scores[who[0]] ++;
        else if(cond == 2) scores[who[1]] ++;
        clear_board();
    }
    //count = ai1_s + ai2_s;
    count = scores[0] + scores[1];
    if(argc == 4)
        std::cout << "AI1 win: " << scores[0] * 100 / count  << "% AI2 win: " << scores[1] * 100 / count << "%\n";  
    

    return EXIT_SUCCESS;
}
