package struktury;

/**
 * Klasa reprezentujaca zbior na tablicy o stalej pamieci
 */
public class ZbiorNaTablicy extends Zbior{
    /**
     * Konstruktor zbioru
     * @param size maksymakla ilosc elementow
     */
    public ZbiorNaTablicy(int size){
        if(size < 0)
            throw new IllegalArgumentException("Wielkosc tablicy nie moze byc mniejsza niz 0!");
        this.data = new Para[size];
        this.size = size;
    }
    @Override public Para szukaj(String k){
        for(int i = 0; i < this.ptr; i++)
            if(this.data[i].klucz.equals(k))
                return this.data[i];
        throw new UnknownError("Podany klucz \'" + k + "\' nie istnieje w bazie");      
    }
    @Override public void wstaw(Para p){
        if(this.size == ptr)
            throw new OutOfMemoryError("Brak miejsca na nowy element");
        this.data[ptr++] = p;
    }
    @Override public double czytaj(String k){
        return this.szukaj(k).getValue();
    } 
    @Override public void ustaw(Para p){
        // probojemy znalezc
        try{
            Para t = this.szukaj(p.klucz);
            t.setValue(p.getValue());
        }
        // nie udalo sie, wstawiamy jak nowy element
        catch(Exception ex){
            this.wstaw(p);
        }
    }
    @Override public void czysc(){
        this.ptr  = 0;
        this.data = new Para[this.size];
    }
    @Override public int ile(){
        return this.ptr;
    }
}