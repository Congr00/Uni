package game;

public class Player extends Character implements java.io.Serializable{

    private int presNum;
    private boolean lost = false;
    private boolean won  = false;
    public void setPresNum(int n){this.presNum = n;}
    public int  getPresNum()  {return this.presNum;}
    public synchronized void setLost(boolean v){lost = v;}
    public boolean getLost(){return lost;}
    public void setWin(boolean w){this.won = w;}
    public boolean getWin(){return won;}

    public void run(){}
    public status Status(){
        return status.OK;
    }
    
    Player(Pair loc, int speed, String img, Board board, int cnt){
        super(loc, speed, img, board);
        this.presNum = cnt;
    }
}