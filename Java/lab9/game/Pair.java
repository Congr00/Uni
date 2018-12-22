package game;

public class Pair implements java.io.Serializable{

    private Integer x,y;
    
    public int X(){return this.x;}
    public int Y(){return this.y;}
    public static final Pair BAD_PAIR = null;


    Pair(int x, int y){
        this.x = x;
        this.y = y;
    }
    Pair(){
        this.x = 0;
        this.y = 0;
    }
    public static Pair New(int x, int y){
        return new Pair(x, y);
    }

    @Override
    public boolean equals(Object other){
        Pair p = (Pair)other;
        return ((p.x).equals(this.x)) && ((p.y).equals(this.y));
    }
    @Override
    public String toString(){
        return "[" + this.x.toString() + "," + this.y.toString() + "]";
    }
    public int hashCode() {
        return ((Integer)(x*y)).hashCode();
    }
        
}