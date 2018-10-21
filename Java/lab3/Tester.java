import struktury.*;
import struktury.ZbiorNaTablicyDynamicznej;
import struktury.ZbiorNaTablicyDynamicznej;
import struktury.ZbiorNaTablicy;

public class Tester{
    public static void main(String[] args){
        // testowanie struktury Para
        Para p1 = new Para("Klucz", 10);
        System.out.println(p1.toString());    
        p1.setValue(11);
        System.out.println(p1.toString()); 
        // testowanie pustego klucza
        try{Para p2 = new Para("", 10);}
        catch(IllegalArgumentException ex){ System.out.println(ex.getMessage()+"\n\n");}
        // testowanie struktury ZbiorNaTablicy
        System.out.println("Testowanie struktury ZbiorNaTablicy...");
        ZbiorNaTablicy zbr = new ZbiorNaTablicy(3);
        zbr.wstaw(p1);
        // czytamwy wartosc p1 -> 11
        System.out.println(zbr.czytaj(p1.klucz));
        zbr.wstaw(new Para("Klucz new", 16));
        System.out.println((zbr.szukaj("Klucz new")).toString());
        try{zbr.szukaj("Klucz nieistniejacy");}
        catch(UnknownError ex){System.out.println(ex.getMessage());}
        p1.setValue(-11);
        zbr.ustaw(p1);
        System.out.println(zbr.czytaj(p1.klucz));
        System.out.println("Ilosc elementow: " + zbr.ile());
        zbr.wstaw(new Para("Klucz new2", -16));
        System.out.println("Ilosc elementow: " + zbr.ile());
        try{zbr.wstaw(new Para("Brak miejsca", 0));}
        catch(OutOfMemoryError ex){System.out.println(ex.getMessage());}
        zbr.czysc();
        System.out.println("Ilosc elementow: " + zbr.ile());
        try{zbr.wstaw(new Para("Brak miejsca", 0));}
        catch(OutOfMemoryError ex){System.out.println(ex.getMessage());}                
        System.out.println("Ilosc elementow: " + zbr.ile());
        // testowanie dynamicznego zbioru
        System.out.println("\n\nZbior dynamiczny...");
        ZbiorNaTablicyDynamicznej zbrD = new ZbiorNaTablicyDynamicznej();
        // dodajemy 100 elementow (na poczatku tablica = 0)
        System.out.println(zbrD.ile());
        for(int i = 0; i < 100; i++)
            zbrD.wstaw(new Para(String.valueOf(i), i+100));

        System.out.println(zbrD.ile());
        for(int i = 0; i < 100; i++){
            try{System.out.print(zbrD.szukaj(String.valueOf(i)) + " ");}
            catch(UnknownError ex){System.out.println("Test czy sa wszystkie elementy");}
        }        
        zbrD.czysc();
        System.out.println("\n" + zbrD.ile());
        try{System.out.print(zbrD.szukaj(String.valueOf(1)) + " ");}
        catch(UnknownError ex){System.out.println("Nie ma, bo wyczyscilismy dane");}        
    }
}