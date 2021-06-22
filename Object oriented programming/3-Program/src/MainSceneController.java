import java.io.IOException;
import java.net.URL;
import java.util.ResourceBundle;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.TextField;
import javafx.scene.layout.AnchorPane;

public class MainSceneController {

    @FXML
    private ResourceBundle resources;

    @FXML
    private URL location;

    @FXML
    private AnchorPane loadButton;

    @FXML
    private TextField fileInputField;

    @FXML
    private Button fileInputButton;

    
    @FXML
    void openFile(ActionEvent event) throws Exception {
        // System.out.print("Ye pressed meh " + fileInputField.getText() + "\n");
        App.readFromFile(fileInputField.getText());
        
        FXMLLoader fxmlLoader = new FXMLLoader(getClass().getResource("NewDataScene.fxml"));
        Parent root = (Parent) fxmlLoader.load();
   
        DataSceneController dataSceneController = fxmlLoader.getController();
        
       
        Scene scene = new Scene(root);
        App.getStage().setScene(scene);
        
    }

    @FXML
    void initialize() {
        assert loadButton != null : "fx:id=\"loadButton\" was not injected: check your FXML file 'Untitled'.";
        assert fileInputField != null : "fx:id=\"fileInputField\" was not injected: check your FXML file 'Untitled'.";
        assert fileInputButton != null : "fx:id=\"fileInputButton\" was not injected: check your FXML file 'Untitled'.";

    }
}

