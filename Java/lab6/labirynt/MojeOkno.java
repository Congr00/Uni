package labirynt;

import java.awt.*;
import java.awt.event.*;

public class MojeOkno extends Frame
{
    private Color kolor = Color.BLACK;

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
            Graphics gr = plotno.getGraphics();
            gr.setColor(kolor);
            gr.fillRect(ev.getX() - 10, ev.getY() - 10, 20, 20);
        }
    };
    private KeyListener keyList = new KeyAdapter()
    {
        @Override
        public void keyPressed (KeyEvent ev)
        {
            switch (ev.getKeyCode())
            {
            case KeyEvent.VK_R: // klawisz 'R'
                kolor = Color.RED;
                break;
            case KeyEvent.VK_G: // klawisz 'G'
                kolor = Color.GREEN;
                break;
            case KeyEvent.VK_B: // klawisz 'B'
                kolor = Color.BLUE;
                break;
            default: // inne klawisze
                kolor = Color.BLACK;
                break;
            }
        }
    };

    private Canvas plotno = new Canvas();

    public MojeOkno()
    {
        super("kolorowe kwadraty");
        setSize(900, 900);
        setLocation(100, 100);
        add(plotno, BorderLayout.CENTER);
        plotno.addKeyListener(keyList);
        plotno.addMouseListener(mouseList);
        plotno.setFocusable(true);
        plotno.requestFocus();
        addWindowListener(frameList);
        setVisible(true);
    }
}