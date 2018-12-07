package grafika;

import java.awt.*;
import java.awt.event.*;
import java.awt.image.*;
import java.io.*;
import javax.imageio.*;
import java.util.Timer;
import java.util.TimerTask;
import javax.swing.*;

public class MainFrame extends Frame
{
    private static final long serialVersionUID = 1234;
    private int windowWidth;
    private int windowHeight;
    private static final int SCALE = 40;

    private static final String TITLE = "Paint";

    private CanvasFace canvas;
    private ToolBar toolBar;

    private WindowListener frameList = new WindowAdapter()
    {
        @Override
        public void windowClosing (WindowEvent ev)
        {
            MainFrame.this.dispose();
        }
    };


    /**
     * Klasa okna labiryntu
     * @param labX szerokosc okna
     * @param labY dlugosc okna
     */
    public MainFrame(int width, int height)
    {
        super(TITLE);

        this.windowWidth =  (width) * SCALE + 10;
        this.windowHeight = (height) * SCALE + 13;
        setIgnoreRepaint(true);
        // set window size
        setSize(windowWidth, windowHeight);
        // set position to middle of screen        
        Dimension dim = Toolkit.getDefaultToolkit().getScreenSize();
        setLocation((int)(dim.getWidth() - windowWidth) / 2, (int)(dim.getHeight() - windowHeight) / 2);
        // create toolbar
        toolBar = new ToolBar();
        add(toolBar, BorderLayout.NORTH);
        // create canvas        
        canvas = new CanvasFace(windowWidth-100, windowHeight-100, toolBar.getColor1());
        add(canvas, BorderLayout.SOUTH);

        toolBar.setCanv(canvas);
        // create scroller
        JScrollPane scroller = new JScrollPane(canvas);
        scroller.setPreferredSize(new Dimension(200,200));
        add(scroller, BorderLayout.CENTER);            
        toolBar.setScroll(scroller);
        addWindowListener(frameList);
        canvas.setFocusable(true);
        canvas.requestFocus();
 
        setVisible(true);

    }
}