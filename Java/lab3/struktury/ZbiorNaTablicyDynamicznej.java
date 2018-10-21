package struktury;

/**
 * Klasa reprezentujaca zbior dynamicznie allokujacy pamiec
 */
public class ZbiorNaTablicyDynamicznej extends ZbiorNaTablicy{
    private static int FixedSize = 2;
    
    /**
     * Kontruktor tablicy dynamicznej nie przyjmuje parametrow, poczatkowo ustawia rozmiar tablicy na FixedSize = 2
     */
    public ZbiorNaTablicyDynamicznej(){
        super(FixedSize);
    }
    @Override public void wstaw(Para p){
        if(this.size == this.ptr){
            this.size *= 2;
            Para[] cp = new Para[this.size];
            for(int i = 0; i < this.ptr; i++)
                cp[i] = data[i];
            this.data = cp;
        }
        this.data[ptr++] = p;
    }
}
