package game;


/**
 * Klasa po ktorej rysujemy
 */

import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Dimension;
import java.awt.*;
import java.util.*;
import java.io.*;
import javax.imageio.*;

import javax.swing.JPanel;

public class CanvasFace extends JPanel{
    
    private Board board;
    private static final int PR_X = 32, PR_Y = 32;
    private static final int FONT_SIZE = 15;
    private static final Font font = new Font("Serif", Font.PLAIN, FONT_SIZE);
    private int x, y;
    
    private Image presentImg;
    {
        try { presentImg = ImageIO.read(new File("game/images/present.png")); }
        catch (IOException e) { System.out.println(e.toString()); }
    }    

    public CanvasFace (int x, int y, Color c, Board board) {
        setBackground (c);
        setIgnoreRepaint(true);            
        setPreferredSize(new Dimension(x, y));      
        this.board = board;
        this.x = x;
        this.y = y;
    }
    public void paint(Graphics g) {
        super.paint(g);
        Graphics2D g2 = (Graphics2D)g;
        g.setColor(Color.BLACK);
        Iterator<Pair> it = board.getPresentIterator();
        
        while(it.hasNext()){
            Pair n = it.next();
            g.drawImage(presentImg, n.X() * PR_X, n.Y() * PR_Y, PR_X, PR_Y, this);
        }

        Player ch = board.getPlayer();        
        g.drawImage(ch.getImg(), ch.getDrawX(), ch.getDrawY(), Character.SIZE_X, Character.SIZE_Y, this);
        if(ch.Overflow())
            g.drawImage(ch.getImg(), ch.getOverflowX(), ch.getOverflowY(), Character.SIZE_X, Character.SIZE_Y, this);

        Npc[] npcs = board.getNpcs();
        for (Npc np : npcs) {
            g.drawImage(np.getImg(), np.getDrawX(), np.getDrawY(), Npc.SIZE_X, Npc.SIZE_Y, this);
            if(np.Overflow()){
                g.drawImage(np.getImg(), np.getOverflowX(), np.getOverflowY(), Npc.SIZE_X, Npc.SIZE_Y, this);
            }            
            drawStatus(np, g);
        }

        g2.setFont(font);
        g2.drawString("presents: " + ch.getPresNum(), 0, FONT_SIZE);
        if(board.getPlayer().getLost()){
            g.drawString("YOU LOST!!!", x/3, y/2);
        }
        else if(board.getPlayer().getWin()){
            g.drawString("YOU WON!!!", x/3, y/2);
        }
    }      
    void drawStatus(Npc n, Graphics g){
        switch (n.getStatus()){
            case FUN:
                g.setColor(Color.BLUE);
                g.drawString("@", n.getOverflowX(), n.getOverflowY()+(Npc.SIZE_Y/3));
                break;
            case FOUND:
                g.setColor(Color.RED);
                g.drawString("!!!", n.getOverflowX(), n.getOverflowY()+(Npc.SIZE_Y/3));            
                break;
            case SLEEP:
                g.setColor(Color.ORANGE);
                g.drawString("zzz", n.getOverflowX(), n.getOverflowY()+(Npc.SIZE_Y/3));            
                break;
            case CHASE:
                g.setColor(Color.GREEN);
                g.drawString("^", n.getOverflowX(), n.getOverflowY()+(Npc.SIZE_Y/3));
            default:
        }
        g.setColor(Color.BLACK);
    }
}