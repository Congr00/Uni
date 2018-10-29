package obliczenia;


public abstract class Wyrazenie implements Obliczalny{
    public static double suma(Wyrazenie... wyr){
        double res = 0.0;
        for (Wyrazenie var : wyr) {
            res += var.oblicz();
        }
        return res;
    }
    public static double iloczyn(Wyrazenie... wyr){
        double res = 1.0;
        for (Wyrazenie var : wyr) {
            res *= var.oblicz();
        }
        return res;
    }
}