public class LiczbySlownie {

// URUCHOMIENIE java -Dfile.encoding=iso-8859-10 LiczbySlownie
//                                            ^--- ???, inaczej nie dzia³a
// KOMPILACJA   javac -encoding "ISO-8859-2" LiczbySlownie.java

    public static String[][] Names = {{"", "jeden", "dwa", "trzy", "cztery", "piêæ", "sze¶æ", "siedem", "osiem", "dziewiêæ"},
    {"", "dziesiêæ", "dwadzie¶cia", "trzydzie¶ci", "czterdzie¶ci", "piêædziesi±t", "sze¶ædziesi±t", "siedemdziesi±t", "osiemdziesi±t", "dziewiêædziesi±t"},
    {"", "sto", "dwie¶cie", "trzysta", "czterysta", "piêæset", "sze¶æset", "siedemset", "osiemset", "dziewiêæset"}};
    public static String[] teens =    {"dziesiêæ", "jedena¶cie", "dwana¶cie", "trzyna¶cie", "czterna¶cie", "piêtna¶cie", "szesna¶cie", "siedemna¶cie", "osiemna¶cie", "dziewiêtna¶cie"};



    public static void print_hund(int[] num, String single_name, String alt_name, String mult_name){
        if(num[0] == 0 && num[1] == 0 && num[2] == 1){
            System.out.print(single_name + " ");
            return;
        }

        if(num[0] != 0){
            System.out.print(Names[2][num[0]] + " ");     
        }
        if(num[1] != 0){
            if(num[1] != 1)
                System.out.print(Names[1][num[1]] + " ");
            else{
                System.out.print(teens[num[2]] + " " + mult_name + " ");
                num[2] = 0;
            }
        }
        if(num[2] != 0){
            if(num[2] < 5)
                System.out.print(Names[0][num[2]] + " " + alt_name + " ");             
            else 
                System.out.print(Names[0][num[2]] + " " + mult_name + " "); 
        }    
    }

    public static void main(String[] args) {
        for(String arg : args){
            int input;
            try{
            input = Integer.parseInt(arg);
            }catch(NumberFormatException e){
                System.out.println("error " + e.getMessage());
                return;
            }
            System.out.print("Liczba " + input + ":\n");
            if(input == 0)
                System.out.println("zero");
            if(input < 0){
                input *= -1;
                System.out.print("minus ");
            }
            int[] singles = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
            for(int i = 10, j = 0; i <= 1000000000; i*=10, j++){
                singles[j] = (input % i) / (i / 10);
                input -= singles[j] * (i / 10);
            } 
            singles[9] = input / 1000000000;
            print_hund(new int[]{0, 0, singles[9]}, "miliard", "miliardy", "miliardów");
            print_hund(new int[]{singles[8], singles[7], singles[6]}, "milion", "miliony", "milionów");
            print_hund(new int[]{singles[5], singles[4], singles[3]}, "tysi±c", "tysi±ce", "tysiêcy");           
            print_hund(new int[]{singles[2], singles[1], singles[0]}, "jeden", "",  "");   
            System.out.print("\n");  
        }
    }
}