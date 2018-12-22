package game;

import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Random;
import java.util.Iterator;

public class Board implements java.io.Serializable{

    private Random rand;
    private int N,M;
    private Player player;
    private Npc npcs[];
    private ArrayDeque<Pair> presentLoc;
    private int npcCnt;

    private static final int NPC_SPEED    = 14;
    private static final int PLAYER_SPEED = 7;

    private static final String NPC_IMG    = "game/images/npc.png";
    private static final String PLAYER_IMG = "game/images/player.png";

    Board(int N, int M, int npcCount){
        if(N < 10)
            N = 10;
        if(M < 10)
            M = 10;
        if(npcCount < 1)
            npcCount = 1;
        this.npcCnt = npcCount;
        
        this.npcs = new Npc[npcCount];

        this.N = N;
        this.M = M;
        this.rand = new Random();
        presentLoc = new ArrayDeque<>();
    }
    public void GenerateStarters(){
        player = new Player(Pair.New(rand.nextInt(N), rand.nextInt(M)), PLAYER_SPEED, PLAYER_IMG, this, npcCnt);
        for(int i = 0; i < this.npcCnt; ++i){
            Pair n = Pair.New(rand.nextInt(N), rand.nextInt(M));
            if(n.equals(player.getLoc())){
                i--;
                continue;
            }
            for(int j = 0; j < i; ++j){
                if(n.equals(npcs[j].getLoc()) || n.equals(player.getLoc())){
                    i--;
                }
            }
            npcs[i] = new Npc(n, NPC_SPEED, NPC_IMG, this, i);
        }
    }
    public void AddPresent(Pair loc){
        presentLoc.push(loc);
    }
    public void RemovePresent(Pair loc){
        Iterator<Pair> it = presentLoc.iterator();
        while(it.hasNext()){
            if(loc.equals(it.next())){
                it.remove();
                break;
            }
        }
    }
    public Pair offsetPair(Pair loc){
        Pair res = Pair.New(0, 0);
        if(loc.X() < 0)
            res = new Pair(N-1-loc.X(), res.Y());
        else if(loc.X() > N)
            res = new Pair(0+loc.X()-N-1, res.Y());
        else
            res = new Pair(loc.X(), res.Y());
        if(loc.Y() < 0)
            res = new Pair(res.X(), M-1-loc.Y());
        else if(loc.Y() > M)
            res = new Pair(res.X(), 0+loc.Y()-M-1);
        else
            res = new Pair(res.X(), loc.Y());
        return res;
    }
    
    public Pair[] neibLocs(Pair loc){
        Pair locs[] = {offsetPair(new Pair(loc.X()-1, loc.Y())), offsetPair(new Pair(loc.X()+1, loc.Y()))
            , offsetPair(new Pair(loc.X(), loc.Y()-1)), offsetPair(new Pair(loc.X(), loc.Y()+1))};
        return locs;
    }

    public synchronized Character.vector scanForPresent(Pair loc){
        Pair locs[] = neibLocs(loc);
        Character.vector map[] = {Character.vector.LEFT, Character.vector.RIGHT, Character.vector.UP, Character.vector.DOWN};
        for(int i = 0; i < 4; ++i){
            if(presentLoc.contains(locs[i])){
                return map[i];
            }
        }
        return Character.vector.ZERO;
    }

    public synchronized Pair scanForPlayer(Pair loc, int range){
        for(int i = 0; i < range+1; ++i){
            for(int j = 0; j < range+1; ++j){
                if(offsetPair(new Pair(loc.X()-i, loc.Y()-j)).equals(player.getLoc()))
                    return new Pair(loc.X()-i, loc.Y()-j);
                if(offsetPair(new Pair(loc.X()+i, loc.Y()+j)).equals(player.getLoc()))
                    return new Pair(loc.X()+i, loc.Y()+j); 
                if(offsetPair(new Pair(loc.X()-i, loc.Y()+j)).equals(player.getLoc()))
                    return new Pair(loc.X()-i, loc.Y()+j);     
                if(offsetPair(new Pair(loc.X()+i, loc.Y()-j)).equals(player.getLoc()))
                    return new Pair(loc.X()+i, loc.Y()-j);                                     
            }
        }
        return null;
    }

    public int closestWest(Pair loc, Pair dst){
        int lenWest = N, lenEast = N;
        if(loc.X() > dst.X()){
            lenEast = N - loc.X() + dst.X() + 1;
            lenWest = loc.X() - dst.X();
        }
        else if(loc.X() == dst.X()){
            lenEast = 0;
            lenWest = 0;
        }
        else{
            lenEast = dst.X() - loc.X();
            lenWest = N - dst.X() + loc.X() + 1;
        }
        //System.out.println("lenWest " + lenWest + "| lenEast " + lenEast);
        return lenWest-lenEast;
    }

    public int closestNorth(Pair loc, Pair dst){
        int lenNorth = M, lenSouth = M;
        if(loc.Y() > dst.Y()){
            lenSouth = M - loc.Y() + dst.Y() + 1;
            lenNorth = loc.Y() - dst.Y();
        }
        else if(loc.Y() == dst.Y()){
            lenSouth = 0;
            lenNorth = 0;
        }
        else{
            lenSouth = dst.Y() - loc.Y();
            lenNorth = M - dst.Y() + loc.Y() + 1;
        }
        //System.out.println("lenSouth " + lenSouth + "| lenNorth " + lenNorth);
        return  lenNorth-lenSouth;        
    }

    Pair randomSet(ArrayList<Pair> v){
        int index = rand.nextInt(v.size());
        Iterator<Pair> iter = v.iterator();
        for (int i = 0; i < index; i++) {
            iter.next();
        }
        Pair res = iter.next();
        iter.remove();
        return res;     
    }

    public Pair[] closestBlocks(Pair loc, Pair dst){
        int cnt = 0;
        Pair res[] = new Pair[4];
        if(loc.X() == dst.X()){
            if(closestNorth(loc, dst) < 0){
                res[cnt++] = offsetPair(new Pair(loc.X(), loc.Y()-1));
                ArrayList<Pair> ar = new ArrayList<>();
                ar.add(offsetPair(new Pair(loc.X()-1, loc.Y())));
                ar.add(offsetPair(new Pair(loc.X(), loc.Y()+1)));
                ar.add(offsetPair(new Pair(loc.X()+1, loc.Y())));
                for(int i = 0; i < 3; ++i){
                    res[cnt++] = randomSet(ar);
                }    
            }
            else if(closestNorth(loc, dst) > 0){
                res[cnt++] = offsetPair(new Pair(loc.X(), loc.Y()+1));
                ArrayList<Pair> ar = new ArrayList<>();
                ar.add(offsetPair(new Pair(loc.X(), loc.Y()-1)));
                ar.add(offsetPair(new Pair(loc.X()-1, loc.Y())));
                ar.add(offsetPair(new Pair(loc.X()+1, loc.Y())));
                for(int i = 0; i < 3; ++i){
                    res[cnt++] = randomSet(ar);
                }                
            }
        }
        else if(loc.Y() == dst.Y()){
            if(closestWest(loc, dst) < 0){
                res[cnt++] = offsetPair(new Pair(loc.X()-1, loc.Y()));
                ArrayList<Pair> ar = new ArrayList<>();
                ar.add(offsetPair(new Pair(loc.X(), loc.Y()-1)));
                ar.add(offsetPair(new Pair(loc.X(), loc.Y()+1)));
                ar.add(offsetPair(new Pair(loc.X()+1, loc.Y())));
                for(int i = 0; i < 3; ++i){
                    res[cnt++] = randomSet(ar);
                } 
            }
            else if(closestWest(loc, dst) > 0){
                res[cnt++] = offsetPair(new Pair(loc.X()+1, loc.Y()));
                ArrayList<Pair> ar = new ArrayList<>();
                ar.add(offsetPair(new Pair(loc.X(), loc.Y()-1)));
                ar.add(offsetPair(new Pair(loc.X(), loc.Y()+1)));
                ar.add(offsetPair(new Pair(loc.X()-1, loc.Y())));
                for(int i = 0; i < 3; ++i){
                    res[cnt++] = randomSet(ar);
                }                    
            }            
        }
        else{
            if(closestWest(loc, dst) < 0){
                if(closestNorth(loc, dst) < 0){
                    ArrayList<Pair> ar = new ArrayList<>();
                    ar.add(offsetPair(new Pair(loc.X()-1, loc.Y())));
                    ar.add(offsetPair(new Pair(loc.X(), loc.Y()-1)));
                    for(int i = 0; i < 2; ++i){
                        res[cnt++] = randomSet(ar);
                    }
                    ar.add(offsetPair(new Pair(loc.X()+1, loc.Y())));
                    ar.add(offsetPair(new Pair(loc.X(), loc.Y()+1)));
                    for(int i = 0; i < 2; ++i){
                        res[cnt++] = randomSet(ar);
                    }                    
                }
                else{
                    ArrayList<Pair> ar = new ArrayList<>();
                    ar.add(offsetPair(new Pair(loc.X()-1, loc.Y())));
                    ar.add(offsetPair(new Pair(loc.X(), loc.Y()+1)));
                    for(int i = 0; i < 2; ++i){
                        res[cnt++] = randomSet(ar);
                    }
                    ar.add(offsetPair(new Pair(loc.X()+1, loc.Y())));
                    ar.add(offsetPair(new Pair(loc.X(), loc.Y()-1)));
                    for(int i = 0; i < 2; ++i){
                        res[cnt++] = randomSet(ar);
                    }                      
                }
            }
            else{
                if(closestNorth(loc, dst) < 0){
                    ArrayList<Pair> ar = new ArrayList<>();
                    ar.add(offsetPair(new Pair(loc.X()+1, loc.Y())));
                    ar.add(offsetPair(new Pair(loc.X(), loc.Y()-1)));
                    for(int i = 0; i < 2; ++i){
                        res[cnt++] = randomSet(ar);
                    }
                    ar.add(offsetPair(new Pair(loc.X()-1, loc.Y())));
                    ar.add(offsetPair(new Pair(loc.X(), loc.Y()+1)));
                    for(int i = 0; i < 2; ++i){
                        res[cnt++] = randomSet(ar);
                    }                    
                }
                else{
                    ArrayList<Pair> ar = new ArrayList<>();
                    ar.add(offsetPair(new Pair(loc.X()+1, loc.Y())));
                    ar.add(offsetPair(new Pair(loc.X(), loc.Y()+1)));
                    for(int i = 0; i < 2; ++i){
                        res[cnt++] = randomSet(ar);
                    }
                    ar.add(offsetPair(new Pair(loc.X()-1, loc.Y())));
                    ar.add(offsetPair(new Pair(loc.X(), loc.Y()-1)));
                    for(int i = 0; i < 2; ++i){
                        res[cnt++] = randomSet(ar);
                    }                      
                }
            }
        }
        return res;
    }

    public synchronized boolean childFree(Pair loc){
        for(int j = 0; j < npcCnt; ++j){
            if(loc.equals(npcs[j].getCurrentLoc()))
                return false;
        }
        return true;    
    }

    public synchronized boolean presentFree(Pair loc){
        if(presentLoc.contains(loc)){
            return false;
        }
        return true;    
    }

    public Iterator<Pair> getPresentIterator(){
        return presentLoc.iterator();
    }
    public Npc[] getNpcs(){
        return npcs;
    }
    public Player getPlayer(){ return this.player;}
    public int getNpcsCnt(){return this.npcCnt;}

    public void runNpc(int number){
        this.npcs[number].start();
    }
    public int getN(){return N;}
    public int getM(){return M;}

    public void reloadImg(){
        for (Character var : getNpcs()) {
            var.reloadImg(NPC_IMG);
        }
        player.reloadImg(PLAYER_IMG);        
    }
}