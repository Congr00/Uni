import game.*;

import javax.swing.SwingUtilities;
import javax.swing.UIManager;

public class Tester{
    public static void main(String[] args) {
        System.setProperty("sun.java2d.opengl", "true");        
        //Schedule a job for the event dispatch thread:
        //creating and showing this application's GUI.
        SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                //Turn off metal's use of bold fonts
	        UIManager.put("swing.boldMetal", Boolean.FALSE);
            new MainFrame(20,20,10);
            }
        });
    }
}