package Geometria;

public class Trojkat
{
    private Punkt x, y, z;
    {
        x = new Punkt(0,0);
        y = new Punkt(0,2);
        z = new Punkt(1,1);
    }    
    public Trojkat(Punkt x, Punkt y, Punkt z){
        double a,b,c;
        a = Punkt.length(x, y);
        b = Punkt.length(y, z);
        c = Punkt.length(z, x);
        if(a >= b + c || b >= a + c || c >= a + b)
            throw new IllegalArgumentException("Z podanych punktow nie da sie utworzyc trojkata");
        this.x = x;
        this.y = y;
        this.z = z;
    }    
    public void Przesun(Wektor v){
        this.x.Przesun(v);
        this.y.Przesun(v);
        this.z.Przesun(v);
    }
    public void Obroc(Punkt p, double kat){
        x.Obroc(p, kat);
        y.Obroc(p, kat);
        z.Obroc(p, kat);                 
    }    
    public void Odbij(Prosta p){
        x.Odbij(p);
        y.Odbij(p);
        z.Odbij(p);
    }    
    public String toString ()
    {
        return "Trojkat"+x.toString()+", "+y.toString()+", "+z.toString();
    }    
}
