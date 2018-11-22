package labirynt;

import java.util.Vector;

public class Labirynt{
    private int x,y;
    private Vector<Vector> map;


    Labirynt(int x, int y){
        this.x = x;
        this.y = y;
        this.map = new Vector<>();
        for(int i = 0; i < x; ++i){
            map.add(i, new Vector());
            for(int j = 0; j < y; ++j)
                map.elementAt(i).
        }
    }

}