package grafika;

import javax.swing.JToolBar;
import javax.swing.JButton;
import javax.swing.ImageIcon;

import javax.swing.JFrame;
import javax.swing.JTextArea;
import javax.swing.JScrollPane;
import javax.swing.JPanel;
import javax.swing.SwingUtilities;
import javax.swing.UIManager;
import javax.swing.JColorChooser;

import java.net.URL;

import java.awt.BorderLayout;
import java.awt.Canvas;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.image.BufferedImage;
import java.io.FileOutputStream;
import java.io.IOException;
import java.awt.event.*;
import java.awt.Color;
import javax.swing.*;
import javax.swing.filechooser.*;

import jdk.internal.org.objectweb.asm.commons.SerialVersionUIDAdder;

import javax.imageio.*;
import java.awt.Image;
import java.awt.Scrollbar;
import javax.swing.JScrollBar;

public class ToolBar extends JPanel implements ActionListener {
    private static final long serialVersionUID = 1024;

    private CanvasFace canvas;
    private JScrollPane scroller;

    static final private String LEFT = "left";
    static final private String UP = "up";
    static final private String RIGHT = "right";
    static final private String DOWN = "down";
    static final private String MAG_PLUS = "mag-plus";
    static final private String MAG_MINUS = "mag-minus";
    static final private String COLOR_PICK = "color-picker";
    static final private String FILE_PICK = "file-picker";
    static final private String SAVE_IMAGE = "save-image";

    private static final Color VIOLET = new Color(131, 66, 244);
    private static final Color LIGHT_GREEN = new Color(175, 244, 65);
    private static final Color LIGHT_BLUE = new Color(69, 71, 70);

    private Color pickedColor_1 = Color.WHITE, pickedColor_2 = Color.BLACK;

    private static final Color[][] basicColors = {{Color.BLACK, Color.BLUE, Color.CYAN, Color.DARK_GRAY, 
        Color.GRAY, Color.GREEN, Color.LIGHT_GRAY, Color.MAGENTA}, 
                                                 {Color.ORANGE, Color.PINK, Color.RED, Color.WHITE,
        Color.YELLOW, VIOLET, LIGHT_GREEN, LIGHT_BLUE}};


    public ToolBar() {
        super(new BorderLayout());
        JToolBar toolBar = new JToolBar("Tool Bar");
        addButtons(toolBar);
        setPreferredSize(new Dimension(430, 50));
        add(toolBar, BorderLayout.PAGE_START);
    }

    class ColorCanvas extends Canvas{
        private static final long serialVersionUID = 1024;
        private int type;
        public ColorCanvas(int x, int y, int type){
            setSize(x, y);
            this.type = type;      
            this.addMouseListener(mouseList);       
        }
        public void paint(Graphics g){
            super.paint(g);
            if(type == 0){
                setBackground(pickedColor_1);
                canvas.setDrawColor1(pickedColor_1);
            }
            else{
                setBackground(pickedColor_2);   
                canvas.setDrawColor2(pickedColor_2);                
            }             
        }
        private MouseListener mouseList = new MouseAdapter()
        {
            @Override
            public void mouseClicked(MouseEvent ev){switchColors();}
        };          
    }
    ColorCanvas col1, col2;
    
    class PickerCanvas extends Canvas{
        private static final long serialVersionUID = 1024;        
        public PickerCanvas(int x, int y){
            setSize(x, y);
            this.addMouseListener(mouseList);
        }
        public void paint(Graphics g){
            super.paint(g);         
            for(int i = 0; i < 8; i++){
                g.setColor(basicColors[0][i]);
                g.fillRect(i*this.getWidth()/8, 0, this.getWidth()/8, this.getHeight()/2);
                g.setColor(basicColors[1][i]);
                g.fillRect(i*this.getWidth()/8, this.getHeight()/2, this.getWidth()/8, this.getHeight()/2);
            }
        }
        private MouseListener mouseList = new MouseAdapter()
        {
            @Override
            public void mouseClicked(MouseEvent ev)
            {
                int flattenX = 7 - ((getWidth() - ev.getX() - 1) / (getWidth()/8) );
                int flattenY = 1 - ((getHeight() - ev.getY() - 1) / (getHeight()/2) );             
                if(ev.getButton() == MouseEvent.BUTTON1){
                    pickedColor_1 = basicColors[flattenY][flattenX];
                    col1.repaint();                
                }
                else{
                    pickedColor_2 = basicColors[flattenY][flattenX];
                    col2.repaint();                                  
                }
            }
        };        
    }

    private void addButtons(JToolBar toolBar) {
        JButton button = null;

        //first button
        button = makeNavigationButton("left-arrow", LEFT, "Move canvas to the left", "Previous");
        toolBar.add(button);

        //second button
        button = makeNavigationButton("right-arrow", RIGHT, "Move canvas to the right", "Right");
        toolBar.add(button);

        //third button
        button = makeNavigationButton("up-arrow", UP, "Move canvas upwords", "Up");
        toolBar.add(button);

        button = makeNavigationButton("down-arrow", DOWN, "Move canvas downwords", "Down");
        toolBar.add(button);  
        toolBar.addSeparator();

        button = makeNavigationButton("mag-plus", MAG_PLUS, "Zoom into canvas", "ZoomIn");
        toolBar.add(button);    

        button = makeNavigationButton("mag-minus", MAG_MINUS, "Zoom out of canvas", "ZoomOut");
        toolBar.add(button);   
        toolBar.addSeparator();
        // canvas dual paint picker
        col1 = new ColorCanvas(10, 10, 0);
        col2 = new ColorCanvas(10, 10, 1);

        toolBar.add(col1);
        toolBar.add(col2);
        toolBar.addSeparator();
        // 16x2 color picker
        toolBar.add(new PickerCanvas(10*16, 20*2));
        toolBar.addSeparator();

        button = makeNavigationButton("color-picker", COLOR_PICK, "pick custom color", "ColorPicker");
        toolBar.add(button);
        toolBar.addSeparator();

        button = makeNavigationButton("image-picker", FILE_PICK, "pick custom file", "FilerPicker");
        toolBar.add(button); 
        toolBar.addSeparator();
        
        button = makeNavigationButton("save", SAVE_IMAGE, "save image", "ImageSaver");
        toolBar.add(button);         

    }

    private JButton makeNavigationButton(String imageName, String actionCommand, String toolTipText, String altText) {
        //Look for the image.
        String imgLocation = "images/"
                             + imageName
                             + ".png";
        URL imageURL = ToolBar.class.getResource(imgLocation);
       
        //Create and initialize the button.
        JButton button = new JButton();
        button.setActionCommand(actionCommand);
        button.setToolTipText(toolTipText);
        button.addActionListener(this);

        if (imageURL != null) {                      //image found
            button.setIcon(new ImageIcon(imageURL, altText));
        } else {                                     //no image found
            button.setText(altText);
            System.err.println("Resource not found: "+ imgLocation);
        }
        return button;
    }

    public void actionPerformed(ActionEvent e) {
        String cmd = e.getActionCommand();
        if(COLOR_PICK.equals(cmd)){
            pickedColor_1 = JColorChooser.showDialog(null, "Pick color", pickedColor_1);
            col1.repaint();
        }
        else if(MAG_PLUS.equals(cmd)){
            canvas.rescale(2.0);
        }
        else if(MAG_MINUS.equals(cmd)){
            canvas.rescale(0.5);
        }
        else if(FILE_PICK.equals(cmd)){
            filePicker();
        }
        else if(SAVE_IMAGE.equals(cmd)){
            saveFile();
        }
        else if(LEFT.equals(cmd)){
            JScrollBar bar = scroller.getHorizontalScrollBar();
            bar.setValue(bar.getMinimum());
        }
        else if(RIGHT.equals(cmd)){
            JScrollBar bar = scroller.getHorizontalScrollBar();
            bar.setValue(bar.getMaximum());
        }
        else if(UP.equals(cmd)){
            JScrollBar bar = scroller.getVerticalScrollBar();
            bar.setValue(bar.getMinimum());
        }
        else if(DOWN.equals(cmd)){
            JScrollBar bar = scroller.getVerticalScrollBar();
            bar.setValue(bar.getMaximum());
        }
    }
    private void filePicker(){
        JFileChooser chooser = new JFileChooser();
        FileNameExtensionFilter filter = new FileNameExtensionFilter(
            "JPG & PNG Images", "jpg", "png");
        chooser.setFileFilter(filter);
        int returnVal = chooser.showOpenDialog(this);
        if(returnVal == JFileChooser.APPROVE_OPTION) {
          try{canvas.setBackgroundImg(ImageIO.read(chooser.getSelectedFile()));}
          catch(IOException ex){System.out.println("Error while loading image!");};
        }   
    }
    private void saveFile(){
        JFileChooser chooser = new JFileChooser();
        FileFilter filter = new FileNameExtensionFilter("png", "jgp");
        chooser.setFileFilter(filter); 
        filter = new FileNameExtensionFilter("jpg", "png");
        chooser.setFileFilter(filter);

        int returnVal = chooser.showSaveDialog(this);
        if(returnVal == JFileChooser.APPROVE_OPTION){
            BufferedImage canvImg = canvas.exportImage();
            FileOutputStream out;
            try{out = new FileOutputStream(chooser.getSelectedFile() + "." + chooser.getFileFilter().getDescription());}
            catch(Exception ex){System.out.println("File not found while saving!"); return;}
            try{ImageIO.write(canvImg, chooser.getFileFilter().getDescription(), out);}
            catch(IOException ex){System.out.println("Error while saving image!");}
        }        
    }
    public void switchColors(){
        Color c = pickedColor_1;
        pickedColor_1 = pickedColor_2;
        pickedColor_2 = c;
        col1.repaint();
        col2.repaint();
    }
    public Color getColor1(){return pickedColor_1;}
    public Color getColor2(){return pickedColor_2;}
    public void setCanv(CanvasFace c){this.canvas = c;}
    public void setScroll(JScrollPane s){this.scroller = s;}    
}