package labirynt;

import java.awt.*;
import java.awt.event.*;
import java.awt.image.*;
import java.io.*;
import javax.imageio.*;
import java.util.Timer;
import java.util.TimerTask;


import javax.sound.sampled.LineEvent.Type;

public class MojeOkno extends Frame
{
    private static final long serialVersionUID = 1234;

    private int windowWidth;
    private int windowHeight;
    private int playerX;
    private int playerY;
    private Labirynt lab;
    private Image img = null;
    private MyCanvas plotno;
    private boolean win;

    private int exitX,  exitY;
    private int startX, startY;

    private static final int SCALE = 40;
    private static final int SCALE_P = 34;
    private static final Color WALL_COLOR = Color.BLACK;
    private static final Color HALL_COLOR = Color.GRAY;
    private static final Color ENTRANCE_COLOR = Color.GREEN;
    private static final Color EXIT_COLOR = Color.RED;
    private static final Color FONT_COLOR = Color.BLUE;
    
    private static final String FONT    = "TimesRoman";
    private static final String WIN_MSG = "GRATULACJE WYGRALES!!!";

    /**
     * Wczytaj zdjecie
     */
    {
        try { img = ImageIO.read(new File("labirynt/player.png")); }
        catch (IOException e) { System.out.println(e.toString()); }
    }

    /**
     * Subklasa po ktorej rysujemy
     */
    private class MyCanvas extends Canvas{

        private  int labX,labY;
        private static final long serialVersionUID = 1234; 
        private static final int WALL_THICK = SCALE * 1/8;

        /**
         * Kontruktor plutna
         * @param x  szerokosc plutna
         * @param y  dlugosc plutna
         * @param lx poczatek rysowania X
         * @param ly poczatek rysowania Y
         */
        public MyCanvas (int x, int y, int lx, int ly) {
            setBackground (Color.darkGray);
            setSize(x, y);
            this.labX = lx;
            this.labY = ly;            
        }
        /**
         * Rysuje cale plotno
         */
        public void paint(Graphics g) {
            super.paint(g);
            drawLab(g);
        }
        private void drawWinMsg(Graphics g){
            if(playerX == 1 && playerY == 1){
                g.fillRect(250, 520, 1000, 300);
                g.setFont(new Font(FONT, Font.PLAIN, 70));    
                g.setColor(FONT_COLOR);        
                FontMetrics fm = g.getFontMetrics();
                g.drawString(WIN_MSG, 300, 700);
            }
        }    
        private void drawWall(Graphics g, int i, int j){
            if(!lab.northWall(i-1, j-1))
                g.fillRect(i*SCALE, j*SCALE, SCALE, WALL_THICK);
            if(!lab.southWall(i-1, j-1))
                g.fillRect(i*SCALE, (j+1)*SCALE - WALL_THICK, SCALE, WALL_THICK);
            if(!lab.westWall(i-1, j-1))
                g.fillRect(i*SCALE, j*SCALE - WALL_THICK, WALL_THICK, SCALE+WALL_THICK*2);
            if(!lab.eastWall(i-1, j-1))
                g.fillRect((i+1) * SCALE - WALL_THICK, j*SCALE - WALL_THICK, WALL_THICK, SCALE+WALL_THICK*2);
            if(j == labX)
                g.fillRect(i*SCALE, (j+1)*SCALE, SCALE, WALL_THICK);
            if(j == 1)
                g.fillRect(i*SCALE, SCALE-WALL_THICK, SCALE, WALL_THICK);
            if(i == labY)
                g.fillRect((i+1)*SCALE, j*SCALE - WALL_THICK, WALL_THICK, SCALE + WALL_THICK*2);
            if(i == 1)
                g.fillRect(SCALE - WALL_THICK, j*SCALE - WALL_THICK, WALL_THICK, SCALE + WALL_THICK*2);  
        }
        private void drawLab(Graphics g){          
            g.setColor(ENTRANCE_COLOR);
            g.fillRect(labX*SCALE, labY*SCALE, SCALE, SCALE);
            g.setColor(EXIT_COLOR);
            g.fillRect(SCALE, SCALE, SCALE, SCALE);

            g.setColor(WALL_COLOR);  

            for(int i = 1; i < labX+1; ++i)
                for(int j = 1; j < labY+1; ++j)         
                    drawWall(g, i,j);
            
            g.drawImage(img, playerX*SCALE + (SCALE-SCALE_P)/2, playerY*SCALE + (SCALE-SCALE_P)/2, SCALE_P, SCALE_P, this);                         
            drawWinMsg(g);
        }        
    }

    private WindowListener frameList = new WindowAdapter()
    {
        @Override
        public void windowClosing (WindowEvent ev)
        {
            MojeOkno.this.dispose();
        }
    };
    private KeyListener keyList = new KeyAdapter()
    {
        @Override
        public void keyPressed (KeyEvent ev)
        {
            switch (ev.getKeyCode())
            {
            case KeyEvent.VK_R:
                repaintP();
                break;
            case KeyEvent.VK_UP:
                if(lab.northWall(playerX-1,playerY-1))
                    playerY--;
                break;
            case KeyEvent.VK_DOWN:
                if(lab.southWall(playerX-1,playerY-1))     
                    playerY++;
                break;
            case KeyEvent.VK_LEFT:
                if(lab.westWall(playerX-1,playerY-1))
                    playerX--;
                break;
            case KeyEvent.VK_RIGHT:
                if(lab.eastWall(playerX-1,playerY-1))          
                    playerX++;
                break;                
            default:
                break;
            }
            if(playerX == 1 && playerY == 1)
                win = true;
            plotno.repaint();      
        }
    };
    private class LabTimer extends TimerTask {
        public void run() {
            if(!lab.finished()){
                lab.singleStep();
                plotno.repaint();
            }
        }
    }

    private void repaintP(){
        this.playerX = startX;
        this.playerY = startY;

        win = false;
        Timer timer = new Timer(true);
        LabTimer tsk = new LabTimer();
        lab.reset();
        lab.generateStart();
        /*timer.schedule(tsk, 0, 5);
        while(!lab.finished());
        tsk.cancel();
        timer.cancel();*/
        lab.generate();
        plotno.repaint();       
    }

    /**
     * Klasa okna labiryntu
     * @param labX szerokosc okna
     * @param labY dlugosc okna
     */
    public MojeOkno(int labX, int labY)
    {
        super("Labirynt");

        this.windowWidth =  (labX + 2) * SCALE + 10;
        this.windowHeight = (labY + 2) * SCALE + 13;

        this.playerX = labX;
        this.playerY = labY;

        this.startX = labX;
        this.startY = labY;
        this.exitX = 1;
        this.exitY = 1;
        this.win = false;

        lab = new Labirynt(labX, labY, startX-1, startY-1, exitX-1, exitY-1);     

        // set window size
        setSize(windowWidth, windowHeight);
        // set position to middle of screen        
        Dimension dim = Toolkit.getDefaultToolkit().getScreenSize();
        setLocation((int)(dim.getWidth() - windowWidth) / 2, (int)(dim.getHeight() - windowHeight) / 2);
        plotno = new MyCanvas(windowWidth, windowHeight, labX, labY);
        add(plotno, BorderLayout.CENTER);
        addWindowListener(frameList);

        plotno.addKeyListener(keyList);
        plotno.setFocusable(true);
        plotno.requestFocus();
 
        setVisible(true);

        repaintP();
    }
}