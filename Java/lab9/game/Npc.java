package game;

public class Npc extends Character implements java.io.Serializable{
    
    private int number;
    private int chaseStep = 0;
    private boolean gifted = false;
    private static final int CHASE_RANGE_MIN = 4;
    private static final int CHASE_RANGE_MAX = 8;
    private static final int LOOKUP_RANGE    = 5;  
    private static final int SLEEP_RANGE_L = 1000;
    private static final int SLEEP_RANGE_R = 5000; 
    private static final int FUN_RANGE_L = 1000;
    private static final int FUN_RANGE_R = 3000; 
    private static final int PAUSE_NUM = 5000;
    private static final int STATE_PAUSE = 500;

    public void run(){
        Pair sant = new Pair();
        while(runThread){
            try{
                if(this.st == status.SLEEP){
                    Thread.sleep(rand.nextInt(SLEEP_RANGE_R) + SLEEP_RANGE_L);
                    // scan for presents, set state to give dir if present
                    setState(board.scanForPresent(this.loc));
                    // we go to collect present, so bot is gifted with present
                    if(this.state != Character.vector.ZERO){
                        // gift that is occupied by another child
                        vector tmp = this.state;
                        Pair l = getCurrentLoc();
                        this.state = Character.vector.ZERO;
                        if(!board.childFree(l)){
                            this.state = Character.vector.ZERO;
                            this.st = status.IDLE;
                            continue;
                        }
                        this.state = tmp;
                        runThread = false;
                        try{Thread.sleep(PAUSE_NUM);}
                        catch(InterruptedException e){}
                        gifted = true;
                    }                    
                    this.st = status.IDLE;
                }
                else if(this.st == status.IDLE){
                    
                    //check for potential santa chase
                    sant = board.scanForPlayer(loc, LOOKUP_RANGE);
                    // there is santa present nearby!
                    if(sant != null){
                        this.st = status.FOUND;
                    }
                    // else perform walk into random unoccupied location
                    else{
                        int cnt = 0;
                        Pair locs[] = board.neibLocs(loc);   
                        vector map[] = {Character.vector.LEFT, Character.vector.RIGHT, Character.vector.UP, Character.vector.DOWN};
                        vector rndMap[] = new vector[4];
                                             
                        for(int i = 0; i < 4; ++i){
                            if(board.childFree(locs[i]) && board.presentFree(locs[i])){
                                rndMap[cnt++] = map[i];
                            }
                        }
                        // no empty blocks
                        if(cnt == 0){
                            setState(Character.vector.ZERO);
                            try{Thread.sleep(STATE_PAUSE);}
                            catch(InterruptedException e){}
                        }
                        else{
                            setState(rndMap[rand.nextInt(cnt)]);
                            try{Thread.sleep(PAUSE_NUM);}
                            catch(InterruptedException e){}
                        }
                        this.st = status.FUN;
                    }
                    
                }
                else if(this.st == status.FUN){
                    // we perform fun - random sleep but we dont check for presents
                    Thread.sleep(rand.nextInt(FUN_RANGE_R) + FUN_RANGE_L);         
                    this.st = status.IDLE;                               
                }
                else if(this.st == status.FOUND){
                    Thread.sleep(PAUSE_NUM);    
                    this.st = status.CHASE;                    
                    this.chaseStep = rand.nextInt(CHASE_RANGE_MAX) + CHASE_RANGE_MIN;
                }
                else if(this.st == status.CHASE){
                    if(this.chaseStep-- == 0){
                        this.st = status.SLEEP;
                        continue;
                    }
                    sant = board.getPlayer().getLoc();
                    Pair [] dir = board.closestBlocks(this.loc, sant);
                    Pair locs[] = board.neibLocs(loc); 


                    vector map[] = {Character.vector.LEFT, Character.vector.RIGHT, Character.vector.UP, Character.vector.DOWN};                    
                    for(int i = 0; i < 4; ++i){
                        if(board.childFree(dir[i]) && board.presentFree(dir[i])){
                            for(int j = 0; j < 4; ++j){
                                if(locs[j].equals(dir[i])){
                                    this.state = map[j];
                                    break;
                                }
                            }
                            if(this.state != Character.vector.ZERO)
                                break;
                        }
                    } 
                    if(this.state != vector.ZERO){
                        try{Thread.sleep(PAUSE_NUM);}
                        catch(InterruptedException e){Thread.sleep(STATE_PAUSE);}
                        // check if we stepped on player
                        if(board.getPlayer().getLoc().equals(this.getLoc())){
                            board.getPlayer().setLost(true);
                            runThread = false;
                            break;
                        }
                    }     
                }
                else if(this.st == status.OK){
                    // not implemented
                }
            }
            catch(InterruptedException ex){
                System.out.println(ex);
                return;
            }
        }
        this.state = Character.vector.ZERO;
        this.st = status.IDLE;        
    }
    public synchronized status Status(){
        return this.st;
    }

    public boolean Gifted(){return this.gifted;}

    Npc(Pair loc, int speed, String img, Board board, int n){
        super(loc, speed, img, board);
        this.number = n;
    }
}