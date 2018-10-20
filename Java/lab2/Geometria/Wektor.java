package Geometria;

public class Wektor{
    public final double x,y;
    public Wektor(double x, double y){
        this.x = x;
        this.y = y;
    }
    public static Wektor W(Wektor x,Wektor y){
        return new Wektor(x.x + y.x, y.x + y.y);
    }
}