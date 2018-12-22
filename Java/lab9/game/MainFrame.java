package game;

import java.awt.*;
import java.awt.event.*;
import java.awt.Color;
import javax.swing.Timer;
import java.util.Stack;
import java.util.Iterator;
import java.io.*;

public class MainFrame extends Frame
{
    private static final long serialVersionUID = 1234;
    private int windowWidth;
    private int windowHeight;
    private int N,M;
    private static final int SCALE = 32;
    private static final int MS_FRAME = 20;
    private Board board;
    private Timer timer;

    private static final String TITLE = "Christmas Game";

    private CanvasFace canvas;

    private WindowListener frameList = new WindowAdapter()
    {
        @Override
        public void windowClosing (WindowEvent ev)
        {
            timer.stop();
            MainFrame.this.dispose();
            if(!board.getPlayer().getLost() && !board.getPlayer().getWin()){
                try {
                    FileOutputStream fileOut =
                    new FileOutputStream("save.ser");
                    ObjectOutputStream out = new ObjectOutputStream(fileOut);
                    out.writeObject(board);
                    out.close();
                    fileOut.close();
                } catch (IOException i) {
                    i.printStackTrace();
                }      
            }    
            else{
                File file = new File("save.ser"); 
                file.delete();
            }
            System.exit(0);
        }
    };
    private KeyListener keyList = new KeyAdapter()
    {
        @Override
        public void keyPressed (KeyEvent ev)
        {
            Player pl = board.getPlayer();
            if(pl.getBlock())
                return;
            // or child is in the way
            
            switch (ev.getKeyCode())
            {
            case KeyEvent.VK_UP:
                pl.setState(Character.vector.UP);
                break;
            case KeyEvent.VK_DOWN:
                pl.setState(Character.vector.DOWN);
                break;
            case KeyEvent.VK_LEFT:
                pl.setState(Character.vector.LEFT);
                break;
            case KeyEvent.VK_RIGHT:
                pl.setState(Character.vector.RIGHT);
                break;
            case KeyEvent.VK_SPACE:
                if(board.presentFree(pl.getLoc())){
                    if(pl.getPresNum() != 0){
                        board.AddPresent(pl.getLoc());
                        pl.setPresNum(pl.getPresNum()-1);
                    }
                }
                else{
                    board.RemovePresent(pl.getLoc());
                    pl.setPresNum(pl.getPresNum()+1);
                }
                break;           
            default:
                break;
            } 
        }
    };

    private void stopNpcs(){
        for (Npc var : board.getNpcs()) {
            var.stopThread();
            var.setStatus(Character.status.IDLE);
        }
    }

    private void animUpdate(){

        for(Npc var : board.getNpcs()){
            if(board.getPlayer().getLoc().equals(var.getLoc())){
                board.getPlayer().setLost(true);
                break;
            }
        }

        if(board.getPlayer().getLost()){
            stopNpcs();
            return;
        }
        int cnt = 0;
        for(Npc var : board.getNpcs()){
            if(!var.Gifted())
                break;
            cnt++;
        }
        if(cnt == board.getNpcsCnt()){
            stopNpcs();
            board.getPlayer().setWin(true);
        }

        Stack<Character> st = new Stack<>();
        for (Character var : board.getNpcs()) {
            st.add(var);
        }
        st.add(board.getPlayer());
        
        for (Character pl : st){
            if(pl.getStates() != Character.vector.ZERO){
                switch(pl.getStates()){
                    case LEFT:
                    if(pl.getOff().X() <= -Character.SIZE_X){
                        pl.setLoc(Pair.New(pl.getLoc().X()-1, pl.getLoc().Y()));
                        pl.zeroState();    
                        pl.interrupt();     
                    }
                    else{
                        pl.setOff(Pair.New(pl.getOff().X()-(int)((1.0 / (float)pl.getSpeed())*Character.SIZE_X), pl.getOff().Y()));
                        if(pl.getLoc().X() == 0)
                            pl.flipOverflow();
                    }                    
                    break;      
                    case RIGHT:
                    if(pl.getOff().X() >= Character.SIZE_X){
                        pl.setLoc(Pair.New(pl.getLoc().X()+1, pl.getLoc().Y()));
                        pl.zeroState();  
                        pl.interrupt();                       
                    }
                    else{
                        pl.setOff(Pair.New(pl.getOff().X()+(int)((1.0 / (float)pl.getSpeed())*Character.SIZE_X), pl.getOff().Y()));
                        if(pl.getLoc().X() == board.getM())
                            pl.flipOverflow();
                    }                    
                    break;      
                    case UP:               
                    if(pl.getOff().Y() <= -Character.SIZE_Y){                   
                        pl.setLoc(Pair.New(pl.getLoc().X(), pl.getLoc().Y()-1));
                        pl.zeroState();   
                        pl.interrupt();                      
                    }
                    else{
                        pl.setOff(Pair.New(pl.getOff().X(), pl.getOff().Y()-(int)((1.0 / (float)pl.getSpeed())*Character.SIZE_Y)));                       
                        if(pl.getLoc().Y() == 0)
                            pl.flipOverflow();
                    }                    
                    break;      
                    case DOWN:                  
                    if(pl.getOff().Y() >= Character.SIZE_Y){
                        pl.setLoc(Pair.New(pl.getLoc().X(), pl.getLoc().Y()+1));
                        pl.zeroState();      
                        pl.interrupt();            
                    }
                    else{
                        pl.setOff(Pair.New(pl.getOff().X(), pl.getOff().Y()+(int)((1.0f / (float)pl.getSpeed())*Character.SIZE_Y)));
                        if(pl.getLoc().Y() == board.getN())
                            pl.flipOverflow();
                    }
                    break;
                    default:                                                                                           
                }
            }
        }
    }

    public MainFrame(int width, int height, int child_num)
    {
        super(TITLE);
        this.windowWidth =  (width) * SCALE + SCALE + 7;
        this.windowHeight = (height) * SCALE + SCALE + 7;
        this.N = height;
        this.M = width;

        setIgnoreRepaint(true);
        // set window size
        setSize(windowWidth, windowHeight);
        // set position to middle of screen        
        Dimension dim = Toolkit.getDefaultToolkit().getScreenSize();
        setLocation((int)(dim.getWidth() - windowWidth) / 2, (int)(dim.getHeight() - windowHeight) / 2);

        boolean loaded = false;
        try {
            FileInputStream fileIn = new FileInputStream("save.ser");
            ObjectInputStream in = new ObjectInputStream(fileIn);
            this.board = (Board) in.readObject();
            in.close();
            fileIn.close();
            loaded = true;
            board.reloadImg();
        } catch (IOException i) {} 
        catch (ClassNotFoundException c) {}
        if(!loaded){
            this.board = new Board(N, M, child_num);
            board.GenerateStarters();
        }
        // create canvas        
        canvas = new CanvasFace(windowWidth-SCALE, windowHeight-SCALE, Color.GRAY, board);
        add(canvas, BorderLayout.CENTER);
        canvas.addKeyListener(keyList);
        timer = new Timer(MS_FRAME, new ActionListener(){
            @Override
            public void actionPerformed(ActionEvent arg0) {
                animUpdate();
                canvas.repaint();                
            }
        });
        timer.start();
        addWindowListener(frameList);
        canvas.setFocusable(true);
        canvas.requestFocus();
        setVisible(true);


        for(int i = 0; i < board.getNpcsCnt(); ++i){
            board.runNpc(i);
        }
    }
}