import java.net.URL;
import java.util.ResourceBundle;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Button;
import javafx.scene.control.RadioButton;
import javafx.scene.control.ToggleGroup;

public class ConnectionSceneController {

    @FXML
    private ResourceBundle resources;

    @FXML
    private URL location;

    @FXML
    private RadioButton ParentButton;

    @FXML
    private ToggleGroup ConnectionType;

    @FXML
    private RadioButton marriageButton;

    @FXML
    private RadioButton childButton;

    @FXML
    private Button okButton;

    @FXML
    void finalizeConnection(ActionEvent event) {
        // System.out.println(DataSceneController.selectedTreeItem.getName() + " " + DataSceneController.connected.getName());
    }

    @FXML
    void initialize() {
        assert ParentButton != null : "fx:id=\"ParentButton\" was not injected: check your FXML file 'Untitled'.";
        assert ConnectionType != null : "fx:id=\"ConnectionType\" was not injected: check your FXML file 'Untitled'.";
        assert marriageButton != null : "fx:id=\"marriageButton\" was not injected: check your FXML file 'Untitled'.";
        assert childButton != null : "fx:id=\"childButton\" was not injected: check your FXML file 'Untitled'.";
        assert okButton != null : "fx:id=\"okButton\" was not injected: check your FXML file 'Untitled'.";

    }
}
