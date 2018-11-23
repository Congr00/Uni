package labirynt;

import java.awt.*;
import java.awt.event.*;
import java.awt.image.*;
import java.io.*;
import javax.imageio.*;



import javax.sound.sampled.LineEvent.Type;

public class MojeOkno extends Frame
{
    private Color kolor = Color.BLACK;

    private  int windowWidth;
    private  int windowHeight;
    private  int playerX;
    private  int playerY;

    private static final int SCALE = 40;
    private static final int SCALE_P = 34;
    private static final Color WALL_COLOR = Color.BLACK;
    private static final Color HALL_COLOR = Color.GRAY;
    private static final Color ENTRANCE_COLOR = Color.GREEN;
    private static final Color EXIT_COLOR = Color.RED;

    private WindowListener frameList = new WindowAdapter()
    {
        @Override
        public void windowClosing (WindowEvent ev)
        {
            MojeOkno.this.dispose();
        }
    };
    private MouseListener mouseList = new MouseAdapter()
    {
        @Override
        public void mouseClicked(MouseEvent ev)
        {
            //lab.singleStep();
            plotno.repaint();
        }
    };
    private KeyListener keyList = new KeyAdapter()
    {
        @Override
        public void keyPressed (KeyEvent ev)
        {
            Labirynt.Wall[][] map = lab.getMap();
            switch (ev.getKeyCode())
            {
            case KeyEvent.VK_R: // klawisz 'R'
                playerX = lab.w;
                playerY = lab.h;
                lab.reset();
                lab.generateStart();
                lab.generate();
                break;
            case KeyEvent.VK_UP:
                if(map[playerX-1][playerY-1].walls[Labirynt.Wall.NORTH])
                    playerY--;
                break;
            case KeyEvent.VK_DOWN:
                if(map[playerX-1][playerY-1].walls[Labirynt.Wall.SOUTH])            
                    playerY++;
                break;
            case KeyEvent.VK_LEFT:
                if(map[playerX-1][playerY-1].walls[Labirynt.Wall.WEST])
                    playerX--;
                break;
            case KeyEvent.VK_RIGHT:
                if(map[playerX-1][playerY-1].walls[Labirynt.Wall.EAST])            
                    playerX++;
                break;                
            default: // inne klawisze
                break;
            }
            if(playerX == 1 && playerY == 1)
                System.out.println("GRATULACJE DOTARLES DO WYJSCIA!!!");
            plotno.repaint();            
        }
    };
    private Labirynt lab;

    private Image img = null;
    {
        try { img = ImageIO.read(new File("labirynt/player.png")); }
        catch (IOException e) { System.out.println(e.toString()); }
    }
    private class MyCanvas extends Canvas{
        private  int labX,labY;
        public MyCanvas (int x, int y, int lx, int ly) {
            setBackground (Color.darkGray);
            setSize(x, y);
            this.labX = lx;
            this.labY = ly;
         }        
         public void paint(Graphics g) {
            super.paint(g);
            drawLab(g);
        }         
        private void drawLab(Graphics g){
            final int WALL_THICK = SCALE * 1/8;
            lab.generate();            
            Labirynt.Wall [][] map = lab.getMap();      
            g.setColor(ENTRANCE_COLOR);
            g.fillRect(labX*SCALE, labY*SCALE, SCALE, SCALE);

            g.setColor(EXIT_COLOR);
            g.fillRect(SCALE, SCALE, SCALE, SCALE);

            g.setColor(WALL_COLOR);             
            for(int i = 1; i < labX+1; ++i){
                for(int j = 1; j < labY+1; ++j){
                    Labirynt.Wall w = map[i-1][j-1];                    
                    if(!w.north())
                        g.fillRect(i*SCALE, j*SCALE, SCALE, WALL_THICK);
                    if(!w.south())
                        g.fillRect(i*SCALE, (j+1)*SCALE - WALL_THICK, SCALE, WALL_THICK);
                    if(!w.west())
                        g.fillRect(i*SCALE, j*SCALE - WALL_THICK, WALL_THICK, SCALE+WALL_THICK*2);
                    if(!w.east())
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
            }       
            g.drawImage(img, playerX*SCALE + (SCALE-SCALE_P)/2, playerY*SCALE + (SCALE-SCALE_P)/2, SCALE_P, SCALE_P, this);                         
        }        
    }
    private MyCanvas plotno;


    public MojeOkno(int labX, int labY)
    {
        super("Labirynt");

        lab = new Labirynt(labX, labY);
        lab.generateStart();

        this.windowWidth =  (labX + 2) * SCALE + 10;
        this.windowHeight = (labY + 2) * SCALE + 13;

        this.playerX = labX;
        this.playerY = labY;

        // set window size
        setSize(windowWidth, windowHeight);
        // set position to middle of screen        
        Dimension dim = Toolkit.getDefaultToolkit().getScreenSize();
        setLocation((int)(dim.getWidth() - windowWidth) / 2, (int)(dim.getHeight() - windowHeight) / 2);
        plotno = new MyCanvas(windowWidth, windowHeight, labX, labY);
        add(plotno, BorderLayout.CENTER);
        addWindowListener(frameList);

        plotno.addKeyListener(keyList);
        plotno.addMouseListener(mouseList);
        plotno.setFocusable(true);
        plotno.requestFocus();
 
        setVisible(true);
    }
}