import People.PersonTree;
import javafx.scene.paint.Paint;
import javafx.scene.shape.Line;

public class Connection implements Cloneable{
    
    PersonTree personOne, personTwo;
    String connectionType;

    Line line;

    Connection(PersonTree first, PersonTree second, String connection)
    {
        personOne = first;
        personTwo = second;
        connectionType = connection;
        line = new Line();
        line.toBack();
        line.setStartX(first.mainBody.getLayoutX() + 60);
        line.setStartY(first.mainBody.getLayoutY() + 17);
        line.setEndX(second.mainBody.getLayoutX() + 60);
        line.setEndY(second.mainBody.getLayoutY() + 17);

        if(connection.equals("Sutuoktiniai"))
            line.setStroke(Paint.valueOf("Red"));
        else if(connection.equals("Vaikai"))
            line.setStroke(Paint.valueOf("Green"));
        else if(connection.equals("Tėvai"))
            line.setStroke(Paint.valueOf("Green"));
    }

    public Object clone() throws CloneNotSupportedException
    {
        return super.clone();
    }

    void updatePosition()
    {
        line.toBack();
        line.setStartX(personOne.mainBody.getLayoutX() + 60);
        line.setStartY(personOne.mainBody.getLayoutY() + 17);
        line.setEndX(personTwo.mainBody.getLayoutX() + 60);
        line.setEndY(personTwo.mainBody.getLayoutY() + 17);
    }

}
