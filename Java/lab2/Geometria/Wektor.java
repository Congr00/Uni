package Geometria;

public class Wektor{
    public final double x,y;
    private Wektor(double x, double y){
        this.x = x;
        this.y = y;
    }
    public static Wektor W(double x, double y)
    {
        return new Wektor(x, y);
    }
}