package grafika;


/**
 * Klasa po ktorej rysujemy
 */

import java.awt.Canvas;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.event.*;
import java.awt.image.BufferStrategy;
import java.awt.image.BufferedImage;
import java.awt.Dimension;
import javax.swing.*;
import javax.swing.event.MouseInputAdapter;
import java.awt.*;
import java.awt.event.*;
import java.util.*;
import java.util.List;

import javax.swing.JPanel;

public class CanvasFace extends JPanel{

    private Color drawColor1;
    private Color drawColor2;
    
    private Integer scale = 4;
    private BufferedImage bcgImg = null;
    private Image scaledBcg = null;

    private class Pair{
        Dimension dim;
        Color col;
        Integer scale;
        public Pair(Dimension d, Color c, int s){
            this.dim = d;
            this.col = c;
            this.scale = s;
        }
        public Dimension first(){return this.dim;}
        public Color second(){return this.col;}
        public Integer third(){return this.scale;}
    }
    private List<Pair> coords = new ArrayList<Pair> ();

    //public void setScrollX(int x){this.scrollX = x;}
    //public void setScrollY(int y){this.scrollY = y;}

    public BufferedImage exportImage(){
        BufferedImage img = new BufferedImage(getWidth(), getHeight(), BufferedImage.TYPE_INT_RGB);
        Graphics2D graphics = img.createGraphics();
        paint(graphics);
        graphics.dispose();
        return img;  
    }

    public void rescale(double div){
        if((scale == 8 && div > 1) || (scale == 1 && div < 1))
            return;
        
        Double s = scale.doubleValue();
        s *= div;
        scale = s.intValue();

        if(bcgImg != null){
            setPreferredSize(new Dimension(bcgImg.getWidth()*scale, bcgImg.getHeight()*scale));
            scaledBcg = bcgImg.getScaledInstance(bcgImg.getWidth()*scale, bcgImg.getHeight()*scale, 0); 
        }
        else//** do poprawy */
            setPreferredSize(new Dimension(getWidth()*scale, getHeight()*scale));
        revalidate();        
        repaint();
    }
    public void setBackgroundImg(BufferedImage img){     
        bcgImg = img;
        scale = 1;
        setPreferredSize(new Dimension((bcgImg.getWidth()), bcgImg.getHeight()));      
        scaledBcg = bcgImg.getScaledInstance(bcgImg.getWidth(), bcgImg.getHeight(), 0);   
        coords.clear(); 
        revalidate();                    
        repaint();
    }
    public void setDrawColor1(Color c){
        this.drawColor1 = c;
    }
    public void setDrawColor2(Color c){
        this.drawColor2 = c;
    }    
    public CanvasFace (int x, int y, Color c) {
        setBackground (c);
        setIgnoreRepaint(true);            
        setPreferredSize(new Dimension(x, y));      
        addMouseListener(mouseList);
        addMouseMotionListener(mouseDrag);
    }
    private int dX = -1,dY = -1;
    /**
     * Rysuje cale plotno
     */
    public void paint(Graphics g) {
        super.paint(g);
        Graphics2D g2 = (Graphics2D)g;  
        if(scaledBcg != null)
            g2.drawImage(scaledBcg, 0, 0, null);

        for (Pair p : coords) {
            g2.setColor(p.second());
            Integer tmp = p.first().width;
            Double scaledX = tmp.doubleValue();
            tmp = p.first().height;
            Double scaledY = tmp.doubleValue();
            scaledX *= (scale.doubleValue() / p.third().doubleValue());
            scaledY *= (scale.doubleValue() / p.third().doubleValue());
            g2.fillRect(scaledX.intValue(), scaledY.intValue(), scale, scale);                             
        }   
    }
    private MouseListener mouseList = new MouseAdapter()
    {
        @Override
        public void mouseClicked(MouseEvent ev)
        {
            dX = ev.getX();
            dY = ev.getY();
            if(ev.getButton() == MouseEvent.BUTTON1)
                coords.add(new Pair(new Dimension(dX, dY), drawColor1, scale));
            else if(ev.getButton() == MouseEvent.BUTTON3)
                coords.add(new Pair(new Dimension(dX, dY), drawColor2, scale));       
            repaint();
        }      
    };   
    public MouseMotionListener mouseDrag = new MouseMotionListener(){
        
        @Override
        public void mouseMoved(MouseEvent e) {                  
        }
    
        @Override
        public void mouseDragged(MouseEvent e) {
            dX = e.getX();
            dY = e.getY();
            int b1 = MouseEvent.BUTTON1_DOWN_MASK;
            int b2 = MouseEvent.BUTTON3_DOWN_MASK;
            if ((e.getModifiersEx() & (b1 | b2)) == b1) {
                coords.add(new Pair(new Dimension(dX, dY), drawColor1, scale));           
            }                     
            else{
                coords.add(new Pair(new Dimension(dX, dY), drawColor2, scale));                
            }   
            repaint();                
        }
    };          
}