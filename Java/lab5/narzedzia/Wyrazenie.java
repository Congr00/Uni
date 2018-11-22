package narzedzia;

/**
 * Klasa reprezentujaca wyrazenie w notacji ONP
 */
public class Wyrazenie
{
    private Kolejka kolejka; // kolejka symboli wyrazenia ONP (elementy typu Symbol)
    private Stos    stos; // stos z wynikami posrednimi obliczen (elementy typu Double)
    private Zbior   zmienne; // lista zmiennych czyli pary klucz-wartosc (String-Double)

    private int checkStar(String[] split) throws WyjatekONP{
        int starInt = split.length;   
        for(int i = 0; i < split.length; ++i){
            if(split[i].equals("=")){
                if(i == 0)
                    throw new ONP_BledneWyrazenie("Znak '=' musi byc poprzedzony zmienna!");
                starInt = i-1;
                break;
            }
        }
        return starInt;
    }
    /**
     * 
     * @param onp string zawierajacy wyrazenie w onp
     * @return wynik obliczenia onp
     * @throws WyjatekONP blad skladni onp lub brak zmiennych w dziedzinie
     */
    public double Oblicz(String onp) throws WyjatekONP{
        String[] split = onp.split(" ");
        int starInt = checkStar(split); // Sprawdz czy mamy =* mode

        for(int i = 0; (i < split.length) && (i < starInt); ++i){   
            Symbol s;          
            try{s = getSymbol(split[i]);}                    // pobierz nastepny symbol
            catch(WyjatekONP ex){throw ex;}
            if(s.getType() == Symbol.Typ.Operand)            // kiedy odczytalismy liczbe/zmienna
                this.stos.Push(((Operand)s).oblicz());       // dodaj na stos
            else this.kolejka.Push(s);                       // jesli funkcja to do kolejki
            Evaluate();
        }
        Evaluate();
        Double res; // Wynik powinien pozostac na stosie
        try{res = this.stos.Pop();}
        catch(ONP_PustyStos ex){
            throw new ONP_BledneWyrazenie("Zla skladnia ONP!"); // W przeciwnym wypadku mamy zle wyrazenie ONP
        }

        if(!this.stos.isEmpty() || this.kolejka.Len() != 0)  // Upewniamy sie ze kolejka oraz stos jest pusty
            throw new ONP_BledneWyrazenie("Zla skladnia ONP!");

        if(!split[split.length-1].equals("=") && starInt != split.length) // Sprawdzamy poprawnosc modu *=
            throw new ONP_BledneWyrazenie("Przypisywanie nie konczy sie na '='");

        if(starInt != split.length){
            for(int i = starInt; i < split.length-1; i+=2){
                this.zmienne.Add(split[i], res);    // Dodajemy zmienne do dziedziny
                if(!split[i+1].equals("="))
                    throw new ONP_BledneWyrazenie("Zla skladnia przypisywania");
            }
        }
        return res;     
    }
    /**
     * Publiczny konstruktor wyrazenia
     * @param zm zbior zawierajacy dziedzine zmiennych
     */
    public  Wyrazenie (Zbior zm){
        this.zmienne = zm;
        stos = new Stos();
        kolejka = new Kolejka();
    }
    private Symbol getSymbol(String s) throws WyjatekONP{
        Double val;
        try{
            val = Double.valueOf(s);
        }
        catch(NumberFormatException ex){
            val = null;
        }
        if(val != null)
            return new Liczba(val);
        switch(s){
            case "+"     :return new Dodawanie();
            case "-"     :return new Odejmowanie();
            case "*"     :return new Mnozenie();
            case "/"     :return new Dzielenie();
            case "max"   :return new Max();
            case "min"   :return new Min();
            case "log"   :return new Log();
            case "pow"   :return new Pow();
            case "abs"   :return new Abs();
            case "sgn"   :return new Sgn();
            case "floor" :return new Floor();
            case "ceil"  :return new Ceil();
            case "frac"  :return new Frac();
            case "sin"   :return new Sin();
            case "cos"   :return new Cos();
            case "atan"  :return new Atan();
            case "acot"  :return new Acot();
            case "ln"    :return new Ln();
            case "exp"   :return new Exp();
            case "e"     :return new E();
            case "pi"    :return new Pi();
            case "phi"   :return new Phi();

            default:
                try{val = zmienne.Get(s);}
                catch(ONP_NieznanySymbol ex){
                    throw ex;
                }
                return new Zmienna(val, s);
        }
    }
    private void Evaluate() throws WyjatekONP{
        Funkcja s;
        try{s = (Funkcja)kolejka.get(); }
        catch(ONP_PustyStos ex){ return;}
        while(s.brakujaceArg() > 0){
            Double val;
            try{val = this.stos.Pop();}
            catch(ONP_PustyStos ex){return;}
            s.dodajArgument(val);
        }
        try{kolejka.Pop();}catch(ONP_PustyStos ex){}
        Double res = s.oblicz();
        this.stos.Push(res);
    }

}