package labirynt;

import java.util.ArrayDeque;
import java.util.Iterator;
import java.util.Vector;

import java.util.Random;

public class Labirynt{
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
    public class Wall{
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
        public int revSide(int wall){return wall ^ 2;}
        public boolean west (){return walls[WEST];}
        public boolean north(){return walls[NORTH];}
        public boolean east (){return walls[EAST];}
        public boolean south(){return walls[SOUTH];}
    }

    public int w,h;
    private Wall[][] map;
    private ArrayDeque<Wall> wallStack;
    private Random rand;

    private static final Pair BAD_PAIR = new Pair(-1, -1);

    public enum TYPE{
        hall, entry, exit, uncontested;
    }
    public Labirynt(int w, int h){
        this.w = w;
        this.h = h;
        this.wallStack = new ArrayDeque<>();
        this.rand      = new Random();
        this.map       = new Wall[w][h];

        for(int i = 0; i < this.w; ++i)
            for(int j = 0; j < this.h; ++j){
                this.map[i][j] = new Wall(pair(i, j));
            }
    }
    private static Pair pair(int x, int y){
        return new Pair(x, y);
    } 
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
        return (p.x - 1 >= 0) ? pair(p.x - 1, p.y)     : BAD_PAIR;
    }
    private Pair eastWall(Pair p){
        return (p.x + 1 < this.w) ? pair(p.x + 1, p.y) : BAD_PAIR;
    }
    private Pair northWall(Pair p){
        return (p.y - 1 >= 0) ? pair(p.x, p.y - 1) : BAD_PAIR;
    }
    private Pair southWall(Pair p){
        return (p.y + 1 < this.h) ? pair(p.x, p.y + 1)     : BAD_PAIR;
    }
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
    @Override
    public String toString(){
        return "";
    }
    public Wall[][] getMap(){
        return this.map;
    }
    public void generateStart(){
        // randomise starting point
        int randX = h-1;//rand.nextInt(this.w);
        int randY = 0;//rand.nextInt(this.h);
        // turn into hall
        this.map[randX][randY].type = TYPE.hall;
        // add neib walls to stack
        addWalls(pair(randX, randY), Wall.WEST);
        addWalls(pair(randX, randY), Wall.EAST);
        addWalls(pair(randX, randY), Wall.NORTH);
        addWalls(pair(randX, randY), Wall.SOUTH);
    }
    public void singleStep(){
        while(!wallStack.isEmpty()){
            // randomise wall from stack
            int randZ = rand.nextInt(wallStack.size());
            int i = 0;
            Wall wall;
            Iterator<Wall> it = wallStack.iterator();
            //System.out.println(Integer.toString(wallStack.size()));
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
                        System.out.println(p.loc.x + " " + p.loc.y + "\n" + res.x + " " + res.y + "\n" + 
                        p.vector + "\n");
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
            break;
        }
    }
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
            //System.out.println(Integer.toString(wallStack.size()));
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
        map[0][0].type = TYPE.exit;
        map[w-1][h-1].type = TYPE.entry;
    }
}