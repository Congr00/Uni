package Geometria;

import static java.lang.Math.*;

public class Punkt
{
    private double x, y;{
        x = 0;
        y = 0;
    }
    public Punkt (double x, double y){
        this.x = x;
        this.y = y; 
    }
    public Punkt (){
        this(0,0);
    }
    public void Przesun (Wektor v){
        x += v.x;
        y += v.y;
    }
    public static double length (Punkt a, Punkt b){
        double dx = b.x-a.x, dy = b.y-a.y;
        return sqrt(dx*dx+dy*dy);
    }
    public String toString (){
        return "Punkt("+x+", "+y+")";
    }
    public static boolean Porownaj(Punkt a, Punkt b){
        if(a.x == b.x && a.y == b.y)
            return true;
        return false;
    }
    public void Obroc(Punkt p, double kat){
        double cos = Math.cos(Math.toRadians(kat));
        double sin = Math.sin(Math.toRadians(kat));
        double x = cos * (this.x - p.x) - sin * (this.y - p.y) + p.x;
        this.y = sin * (this.x - p.x) + cos * (this.y - p.y) + p.y;
        this.x = x;
    }    
    public void Odbij(Prosta p){
        double x = (this.x *(p.a * p.a - p.b * p.b) - 2*p.b * (p.a*this.y + p.c)) / (p.a * p.a + p.b * p.b);
        this.y = (this.y *(p.b * p.b - p.a * p.a) - 2*p.a * (p.b*this.x + p.c)) / (p.a * p.a + p.b * p.b);
        this.x = x;
    }
}