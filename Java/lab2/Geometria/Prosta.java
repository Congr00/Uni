package Geometria;

public class Prosta{
    public final double a, b, c;
    public Prosta(double a, double b, double c){
        if(a == 0 && b == 0 && c != 0)
            throw new IllegalArgumentException("Zle rownanie prostej");             
        this.a = a;
        this.b = b;
        this.c = c;
    }
    public static Prosta Przesun(Prosta p, Wektor v){
        return new Prosta(p.a, p.b, p.c + v.y + p.a * v.x);
    }
    public static boolean Rownolegle(Prosta a, Prosta b){
        return (a.a*b.b == b.a*a.b);
    }
    public static boolean Prostopadle(Prosta a, Prosta b){
        return (a.a*b.a == -a.b*b.b);
    }
    public static Punkt Przeciecie(Prosta a, Prosta b){
        if(Rownolegle(a, b))
            throw new IllegalArgumentException("Proste nie moga miec wspolnego punktu");
        // metoda wyznacznikow
        double W, Wx, Wy;
        W = a.a * b.b - b.a * a.b;
        Wx = (-a.c) * b.b - (-b.c) * a.b;
        Wy = a.a * (-b.c) - b.a * (-a.c);
        return new Punkt(Wx / W, Wy / W);
    }
    public static String toString(Prosta p){
        return p.a + "X + " + p.b + "Y + " + p.c + " = 0";
    }
}