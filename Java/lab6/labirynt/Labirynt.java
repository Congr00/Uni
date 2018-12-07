package labirynt;

import java.util.ArrayDeque;
import java.util.Iterator;
import java.util.Vector;

import java.util.Random;

public class Labirynt{
    /**
     * Klasa pomocnicza - para wartosci
     */
    private static class Pair{
        public int x,y;
        public Pair(int x, int y){
            this.x = x;
            this.y = y;
        }
        public boolean equals(Pair b){
            return (this.x == b.x && this.y == b.y);
        }
    }
    /**
     * Klasa reprezentujaca pojedyncza komorke labiryntu
     */
    private class Wall{

        public Pair loc;
        public boolean walls[] = {false, false ,false, false};
        public static final int WEST  = 0;
        public static final int NORTH = 1;
        public static final int EAST  = 2;
        public static final int SOUTH = 3;

        public TYPE type;
        public int vector;

        public Wall(Pair x, int v, TYPE type){
            this.loc = x;
            this.vector = v;
            this.type = type;
        }
        public Wall(Pair x){
            this.loc = x;
            this.vector = -1;
            this.type = TYPE.uncontested;           
        }
        public Wall(Pair x, int vec){
            this.loc = x;
            this.vector = vec;
            this.type = TYPE.uncontested;                
        }
        public void cWall(){
            this.walls[0] = true;
            this.walls[1] = true;
            this.walls[2] = true;
            this.walls[3] = true;
        }
        public int     revSide(int wall){return wall ^ 2;}
        public boolean west   ()        {return walls[WEST];}
        public boolean north  ()        {return walls[NORTH];}
        public boolean east   ()        {return walls[EAST];}
        public boolean south  ()        {return walls[SOUTH];}
    }

    private int w,h;
    private Wall[][] map;
    private ArrayDeque<Wall> wallStack;
    private Random rand;

    private int gStartX, gStartY;
    private int exitX, exitY;
    private int startX, startY;

    /**
     * Sprawdza czy komorka [x,y] zawiera sciane *
     * @param x x komorki
     * @param y y komorki
     * @return wartosc boolowska czy komorka zawiera dana sciane
     */
    public boolean westWall  (int x, int y) {return map[x][y].west();}
    public boolean northWall (int x, int y) {return map[x][y].north();}
    public boolean eastWall  (int x, int y) {return map[x][y].east();}
    public boolean southWall (int x, int y) {return map[x][y].south();}

    public boolean finished(){return wallStack.isEmpty();}

    public int getWidth (){return w;}
    public int getHeight(){return h;}

    /**
     * Symbolizuje zla pare
     */
    private static final Pair BAD_PAIR = new Pair(-1, -1);
    /**
     * Typ ktory moze przyjac komorka
     */
    public enum TYPE{
        hall, entry, exit, uncontested;
    }
    /**
     * Publiczny konstruktor
     * @param w szerokosc labiryntu
     * @param h wysokosc labiryntu
     */
    public Labirynt(int w, int h, int sx, int sy, int ex, int ey){
        this.w = w;
        this.h = h;
        this.wallStack = new ArrayDeque<>();
        this.rand      = new Random();
        this.map       = new Wall[w][h];
        this.exitX = ex;
        this.exitY = ey;
        this.startX = sx;
        this.startY = sy;

        //gStartX = h-1;
        //gStartY = 0;
        gStartX = rand.nextInt(w);
        gStartY = rand.nextInt(h);



        // inicjalizacja mapy
        for(int i = 0; i < this.w; ++i)
            for(int j = 0; j < this.h; ++j){
                this.map[i][j] = new Wall(pair(i, j));
            }
    }
    private static Pair pair(int x, int y){
        return new Pair(x, y);
    }
    /**
     *  Funkcja resetuje labirynt 
     */ 
    public void reset(){
        for(int i = 0; i < this.w; ++i)
            for(int j = 0; j < this.h; ++j){
                this.map[i][j] = new Wall(pair(i, j));
            }
    }
    private void addWalls(Pair coords, int vect){
        this.wallStack.push(new Wall(coords, vect, map[coords.x][coords.y].type));    
    }
    private Pair westWall(Pair p){
        return (p.x - 1 >= 0) ? pair(p.x - 1, p.y) : BAD_PAIR;
    }
    private Pair eastWall(Pair p){
        return (p.x + 1 < this.w) ? pair(p.x + 1, p.y) : BAD_PAIR;
    }
    private Pair northWall(Pair p){
        return (p.y - 1 >= 0) ? pair(p.x, p.y - 1) : BAD_PAIR;
    }
    private Pair southWall(Pair p){
        return (p.y + 1 < this.h) ? pair(p.x, p.y + 1) : BAD_PAIR;
    }
    // czy dana komorka nie ma inego polaczenia
    private boolean singletonWall(Wall wall){
        Pair res = null;
        switch(wall.vector){
            case Wall.EAST : res = eastWall (wall.loc); break;
            case Wall.WEST : res = westWall (wall.loc); break;
            case Wall.NORTH: res = northWall(wall.loc); break;
            case Wall.SOUTH: res = southWall(wall.loc); break;
        }
        if(res.equals(BAD_PAIR))
            return false;
        return (map[res.x][res.y].type == TYPE.uncontested);
    }
    /**
     * Funkcja inicjalizuje poczatkowe wartosci labiryntu
     */
    public void generateStart(){
        // pick starting point
        int randX = gStartX;
        int randY = gStartY;
        // turn into hall
        this.map[randX][randY].type = TYPE.hall;
        // add neib walls to stack
        addWalls(pair(randX, randY), Wall.WEST);
        addWalls(pair(randX, randY), Wall.EAST);
        addWalls(pair(randX, randY), Wall.NORTH);
        addWalls(pair(randX, randY), Wall.SOUTH);
    }
    /**
     * Generate only single step
     */
    public void singleStep(){
        if(!wallStack.isEmpty()){
            // randomise wall from stack
            // randomise wall from stack
            int randZ = rand.nextInt(2);
            if(randZ == 0)
                randZ = rand.nextInt(wallStack.size());
            else randZ = rand.nextInt(3);
            Wall wall;
            int i = 0;
            Iterator<Wall> it = wallStack.iterator();
            while(it.hasNext()){
                Wall p = it.next();
                if(i++ == randZ){
                    if(singletonWall(p)){
                        Pair res = null;
                        switch(p.vector){
                            case Wall.EAST : res = eastWall (p.loc); break;
                            case Wall.WEST : res = westWall (p.loc); break;
                            case Wall.NORTH: res = northWall(p.loc); break;
                            case Wall.SOUTH: res = southWall(p.loc); break;
                        }
                        map[res.x][res.y].type = TYPE.hall;

                        map[res.x][res.y].walls[p.revSide(p.vector)] = true;
                        map[p.loc.x][p.loc.y].walls[p.vector] = true;
                        addWalls(res, Wall.WEST);   
                        addWalls(res, Wall.EAST);
                        addWalls(res, Wall.NORTH);
                        addWalls(res, Wall.SOUTH);
                    }
                    it.remove();
                    break;
                }
            }       
        }
        else{
            map[exitX][exitY].type = TYPE.exit;
            map[startX][startY].type = TYPE.entry;               
        }
    }
    /**
     * Generate whole lab at the time using prime's algorithm
     */
    public void generate(){
        // while stack isnt empty repeat
        while(!wallStack.isEmpty()){
            // randomise wall from stack
            int randZ = rand.nextInt(2);
            if(randZ == 0)
                randZ = rand.nextInt(wallStack.size());
            else randZ = rand.nextInt(3);
            int i = 0;
            Wall wall;
            Iterator<Wall> it = wallStack.iterator();
            while(it.hasNext()){
                Wall p = it.next();
                if(i++ == randZ){
                    if(singletonWall(p)){
                        Pair res = null;
                        switch(p.vector){
                            case Wall.EAST : res = eastWall (p.loc); break;
                            case Wall.WEST : res = westWall (p.loc); break;
                            case Wall.NORTH: res = northWall(p.loc); break;
                            case Wall.SOUTH: res = southWall(p.loc); break;
                        }
                        map[res.x][res.y].type = TYPE.hall;
                        map[res.x][res.y].walls[p.revSide(p.vector)] = true;
                        map[p.loc.x][p.loc.y].walls[p.vector] = true;
                        addWalls(pair(res.x, res.y), Wall.WEST);
                        addWalls(pair(res.x, res.y), Wall.EAST);
                        addWalls(pair(res.x, res.y), Wall.NORTH);
                        addWalls(pair(res.x, res.y), Wall.SOUTH);
                    }
                    it.remove();
                    break;
                }
            }       
        }
        map[exitX][exitY].type = TYPE.exit;
        map[startX][startY].type = TYPE.entry;         
    }
}