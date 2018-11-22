package narzedzia;
import java.io.BufferedWriter;
import java.text.DateFormat;
import java.util.Scanner;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Calendar;
import java.util.Date;
import java.io.FileWriter;
import java.io.IOException;

/**
 * Klasa opakowujaca interfejs kalkulatora ONP
 * Polecenia:
 * calc 'ONP' - oblicza wyrazenie w postaci onp
 * calc 'ONP' x1 = x2 = ... xn = - oblicza wyrazenie oraz przypisuje wynik do podanych zmiennych
 * clear x - usuwa zmienna x z dziedziny. Brak argumentow usuwa dziedzine
 * exit - wyjscie z kalkulatora
 * 
 * format ONP: 
 * spacja miedzy kazdym znakiem
 * wszystko co nie zostanie rozpoznane jako ponizsze symbole funkcyjne zostanie uznane za zmienna
 * dostepne funkcje: abs, sgn, floor, ceil, frac, sin, cos, atan, acot, ln, exp, min, max, log, pow, +, -, *, /, e, pi, phi
 */
public class Kalkulator{

    private static final String HelloWord = "-------WITAJ W INTERAKTYWNYM KALKULATORZE ONP-------"; 
    private static final String FuncError = "Nie rozpoznano polecenia";
    private static final String CalcError = "Funkcja 'calc' wymaga argumentu";
    private static final String fileName  = "calc.log";
    private static final String HelloLog  = "\nLog operacji z dnia: ";

    private Zbior z;
    private Scanner reader;
    private int Count = 1;
    
    private BufferedWriter writer;
    /**
     * Publiczny konstruktor kalkulatora
     */
    public Kalkulator(){
        init();    
        while(true){
            String in = this.reader.nextLine();
            String mode = in.split(" ")[0];
            if(mode.equals("calc"))
                calc(in);
            else if(mode.equals("clear"))
                clear(in);
            else if(mode.equals("exit"))
                break;
            else System.out.println(FuncError + ": '" + mode + "'");
        }
        reader.close();   
        try{writer.close();}
        catch(IOException ex){System.out.println("Critical error: " + ex.toString());}     
    }
    private void calc(String in){
        if(in.length() < 6){
            System.out.println(CalcError);
            return;
        }
        String onp = in.substring(5);
        double res = 0;
        Wyrazenie w = new Wyrazenie(this.z);        
        try{
            res = w.Oblicz(onp);
        ;}
        catch(WyjatekONP ex){
            System.out.println(ex.getMessage());
            try{writer.append("Operacja nr: " + Integer.toString(Count++) + " wyrazenie: '" + in + "' " + ex.getMessage() + "\r\n");}
            catch(IOException ex1){System.out.println("Critical error: " + ex1.toString());}  
            return;
        }
        System.out.println("Wynik: " + res);
        try{writer.append("Operacja nr: " + Integer.toString(Count++) + " wyrazenie: '" + in + "' wynik: " + Double.toString(res) + "\r\n");}
        catch(IOException ex){System.out.println("Critical error: " + ex.toString());}  
    }
    private void clear(String in){
        String[] spl = in.split(" ");
        if(spl.length == 1){
            this.z.Clear();
            return;
        }
        for(int i = 1; i < spl.length; ++i)
            this.z.Remove(spl[i]);
    }
    private void init(){
        this.z = new Zbior();
        this.reader = new Scanner(System.in);
        System.out.println(HelloWord);     
        try{writer = new BufferedWriter(new FileWriter(fileName, true));}
        catch(IOException ex){System.out.println("Critical error: " + ex.toString());} 

        Date date = new Date();    
        DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        try{writer.append(HelloLog + dateFormat.format(date) + "\r\n");}
        catch(IOException ex){System.out.println("Critical error: " + ex.toString());}  
    }
}