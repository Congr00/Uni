package Geometria;

public class Odcinek
{
    private Punkt x, y;
    {
        x = new Punkt();
        y = new Punkt(0,1);
    }    
    public Odcinek(Punkt x, Punkt y){
        if(Punkt.Porownaj(x, y))
            throw new IllegalArgumentException("Odcinek nie moze miec tych samych punktow");
        this.x = x;
        this.y = y;
    }
    public void Przesun(Wektor v){
        this.x.Przesun(v);
        this.y.Przesun(v);
    }
    public void Obroc(Punkt p, double kat){
        x.Obroc(p, kat);
        y.Obroc(p, kat);
    }
    public void Odbij(Prosta p){
        x.Odbij(p);
        y.Odbij(p);
    }
    public String toString ()
    {
        return "Odcinek "+x.toString()+", "+y.toString();
    }    
}