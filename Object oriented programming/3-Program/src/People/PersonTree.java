package People;


import java.util.ArrayList;

import javafx.event.EventHandler;
import javafx.scene.Group;
import javafx.scene.input.MouseEvent;
import javafx.scene.paint.Paint;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Text;

public class PersonTree extends Person implements Node{
    
    public ArrayList<PersonTree> parents;
    public ArrayList<PersonTree> children;
    public PersonTree marriage = null;
    public int Level = 0;

    public boolean clicked = false;
    public Group mainBody;
    Rectangle outsideBody;
    Text textBody;

    public PersonTree(String name, String lastName, String birthPlace, int identificationNumber, int birthYear, int xPos, int yPos)
    {
        super(name, lastName, birthPlace, identificationNumber, birthYear);

        outsideBody = new Rectangle(120, 35);
        outsideBody.setX(0); outsideBody.setY(0);
        outsideBody.setFill(Paint.valueOf("Green"));
        textBody = new Text(name + " " + lastName);
        textBody.setFill(Paint.valueOf("Black"));
        textBody.setX(30); textBody.setY(17);
        mainBody = new Group();
        mainBody.getChildren().addAll(outsideBody, textBody);
        mainBody.setLayoutX(xPos);
        mainBody.setLayoutX(yPos);
        mainBody.addEventFilter(MouseEvent.MOUSE_CLICKED, eventHandler);
        parents = new ArrayList<PersonTree>();
        children = new ArrayList<PersonTree>();
        Level = 0;

    }


    public int[] getPos() {
        int[] temp = new int[2];
        temp[0] = (int)mainBody.getLayoutX();
        temp[1] = (int)mainBody.getLayoutY();
        return temp;
    }
    
    EventHandler<MouseEvent> eventHandler = new EventHandler<MouseEvent>(){
        @Override
        public void handle(MouseEvent e) {
            // System.out.println("Pressed on node" + name);
            clicked = true;
        }
    };

   

    public void mouseClickTreeItem(MouseEvent event){
        System.out.println("Clicked on node " + this.name);
    }

    public String getName() {return name;}
    public void setName(String name) {this.name = name;}

    public String getLastName() {return lastName;}
    public void setLastName(String lastName) {this.lastName = lastName;}
    
    public String getBirthPlace() {return birthPlace;}
    public void setBirthPlace(String birthPlace) {this.birthPlace = birthPlace;}

    public Integer getIdentificationNumber() {return identificationNumber;}
    public void setIdentificationNumber(Integer identificationNumber) {this.identificationNumber = identificationNumber;}

    public Integer getBirthYear() {return birthYear;}
    public void setBirthYear(Integer birthYear) {this.birthYear = birthYear;}
}
