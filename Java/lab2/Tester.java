import Geometria.*;

public class Tester{
    public static void main(String[] args){
        // testowanie 
        Punkt p1 = new Punkt(0,2);
        System.out.println(p1.toString());
        // przesuwanie o wektor
        Wektor v = Wektor.W(2, 2);
        p1.Przesun(v);
        p1.Przesun(Wektor.W(-5, -8));
        System.out.println(p1.toString());
        p1.Obroc(new Punkt(0,0), -90);
        System.out.println("obrocony: " + p1.toString());
        Punkt p2 = new Punkt(2,2);
        // ukosna prosta przez 0
        p2.Odbij(Prosta.P(-1, -1, 0));
        System.out.println("Odbity punkt (2,2): " + p2.toString());
        try{
        Odcinek o1 = new Odcinek(new Punkt(0, 0), new Punkt(0,0));
        }
        catch(IllegalArgumentException arg){
            System.out.println("Zly argument dla odcinka: " + arg.getMessage());
        }
        Odcinek o1 = new Odcinek(new Punkt(0,0), new Punkt(0, 10));
        System.out.println("Przed przesunieciem: " + o1.toString());
        o1.Przesun(v);
        System.out.println("Po przesunieciu: " + o1.toString());
        try{Trojkat t1 = new Trojkat(new Punkt(0,0), new Punkt(0,10), new Punkt(0, -10));}
        catch(IllegalArgumentException arg){System.out.println("Zle dane do trojkata: " + arg.getMessage());}
        Trojkat t1 = new Trojkat(new Punkt(0,0), new Punkt(0, 10), new Punkt(10, 0));
        System.out.println("Przed przesunieciem: " + t1.toString());
        t1.Przesun(v);
        System.out.println("Po przesunieciu: " + t1.toString());
        Prosta p = Prosta.P(0,1,0);
        Prosta pp = Prosta.P(0,1,2);
        Prosta ppp = Prosta.P(1,0,0);
        System.out.println(Prosta.toString(p));
        System.out.println("Prosta po przesunieciu: " + Prosta.toString(Prosta.Przesun(p, Wektor.W(0, 2))));
        System.out.println("Rownolegle :" + Prosta.Rownolegle(p, pp));
        System.out.println("Rownolegle :" + Prosta.Rownolegle(p, ppp)); 
        System.out.println("Prostopadle :" + Prosta.Prostopadle(p, pp));
        System.out.println("Prostopadle :" + Prosta.Prostopadle(p, ppp));    
        System.out.println("Wspolny pkt: " + Prosta.Przeciecie(Prosta.P(-1, -1, 0),  Prosta.P(-1, 1, 0)));            
    }
}