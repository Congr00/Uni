import obliczenia.*;

public class Tester{
    public static void main(String[] args){
        Wyrazenie wyr = new Dodaj(new Liczba(3), new Liczba(5));
        System.out.println("Wyrazenie: " + wyr.toString() + "\nWynik: " + wyr.oblicz());

        Zmienna x = new Zmienna("x");
        x.Set(new Liczba(2.0));
        Wyrazenie wyr2 = new Dodaj(
            new Liczba(5), 
            new Pomnoz(
                new Zmienna("x"),
                new Liczba(5)
            )
        );
        System.out.println("Wyrazenie: " + wyr2.toString() + "\nWynik: " + wyr2.oblicz());  
        Wyrazenie wyr3 = new Arctan(
            new Podziel(
                new Pomnoz(
                    new Dodaj(
                        new Zmienna("x"),
                        new Liczba(13)
                    ),
                    new Zmienna("x")
                ),
                new Liczba(2)
            )
        );  
        System.out.println("Wyrazenie: " + wyr3.toString() + "\nWynik: " + wyr3.oblicz()); 
        Zmienna y = new Zmienna("y");
        y.Set(new Liczba(8));
        Wyrazenie wyr4 = new Dodaj(
            new Poteguj(
                new Liczba(2),
                new Liczba(5)
            ),
            new Pomnoz(
                new Zmienna("x"),
                new Log(new Liczba(2), new Zmienna("y"))
            )
        );  
        System.out.println("Wyrazenie: " + wyr4.toString() + "\nWynik: " + wyr4.oblicz());          
    }
}