package game;


import java.awt.*;
import javax.imageio.*;
import java.io.*;

import java.util.Random;

public abstract class Character extends Thread implements java.io.Serializable {

    public static enum status{
        OK,IDLE,CHASE,SLEEP,FOUND,FUN;
    }
    public static enum vector{
        LEFT,RIGHT,UP,DOWN,ZERO;
    }

    protected Board board;

    public final static int SIZE_X = 32, SIZE_Y = 32;

    protected Pair loc;
    protected Pair offset;
    protected boolean block    = false;
    protected boolean overFlow = false;
    protected boolean runThread = true;
    protected Random rand = new Random();

    protected vector state = vector.ZERO;
    protected status st = status.SLEEP;

    private int frameSpeed;
    
    public Pair   getLoc    (){return loc       ;}
    public int    getSpeed  (){return frameSpeed;}
    public Image  getImg    (){return this.img  ;}
    public Pair   getOff    (){return offset    ;}
    public status getStatus (){return this.st   ;}
    public void setStatus(status s){this.st = s;}

    public Pair getCurrentLoc(){
        switch(state){
            case UP    :return board.offsetPair(new Pair(loc.X(), loc.Y()-1));
            case DOWN  :return board.offsetPair(new Pair(loc.X(), loc.Y()+1));
            case LEFT  :return board.offsetPair(new Pair(loc.X()-1, loc.Y()));
            case RIGHT :return board.offsetPair(new Pair(loc.X()+1, loc.Y()));
            default    :return this.loc; 
        }
    }

    public boolean getBlock(){return this.block;}

    public boolean Overflow(){return this.overFlow;}
    
    public int   getDrawX(){return loc.X()*SIZE_X + offset.X();}
    public int   getDrawY(){return loc.Y()*SIZE_Y + offset.Y();}
    public void  flipOverflow(){this.overFlow = true;}
    public int   getOverflowX(){
        if(block == false)
            return getDrawX();
        switch(state){
            case LEFT : return (board.getM()+1)*SIZE_X + offset.X();
            case RIGHT: return -SIZE_X + offset.X();
            default   : return getDrawX();
        }
    }
    public int getOverflowY(){
        if(block == false)
            return getDrawY();
        switch(state){
            case UP   : return (board.getN()+1)*SIZE_Y + offset.Y();
            case DOWN : return -SIZE_Y + offset.Y();
            default   : return getDrawY();
        }
    }    

    public synchronized vector getStates(){return this.state;}
    public synchronized void setState(vector s){this.state = s; this.block = true;}

    public synchronized void zeroState(){
        if(this.overFlow){
            switch(state){
                case LEFT  : loc = Pair.New(board.getM(), loc.Y()); break;
                case RIGHT : loc = Pair.New(0, loc.Y());              break;
                case UP    : loc = Pair.New(loc.X(), board.getN()); break;
                case DOWN  : loc = Pair.New(loc.X(), 0);              break;
                default    : break;
            }
        }
        
        this.offset = new Pair();            
        this.block = false;  
        this.overFlow = false;
        this.state = vector.ZERO;         
    }


    public synchronized void setLoc(Pair p){this.loc = p ;}
    public synchronized void setOff(Pair p){this.offset = p ;}
    public void stopThread(){this.runThread = false;}

    public abstract void run();
    public abstract status Status();

    private transient Image img = null;
    public void reloadImg(String img){
        try { this.img = ImageIO.read(new File(img)); }
        catch (IOException e) { System.out.println(e.toString()); }        
    }

    Character(Pair loc, int frameSpeed, String img, Board board){
        this.loc = loc;
        this.frameSpeed = frameSpeed;
        this.board = board;
        try { this.img = ImageIO.read(new File(img)); }
        catch (IOException e) { System.out.println(e.toString()); }
        // stop game
        this.offset = Pair.New(0,0);
    }
}