import java.io.IOException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.ResourceBundle;

import People.Person;
import People.PersonTree;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.RadioButton;
import javafx.scene.control.Tab;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.ToggleGroup;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.Pane;
import javafx.stage.Stage;

public class DataSceneController2 {

    @FXML
    private ResourceBundle resources;

    @FXML
    private URL location;

    @FXML
    private Tab data;

    @FXML
    private TableView<Person> tabelData;

    @FXML
    private TableColumn<Person, String> tableName;

    @FXML
    private TableColumn<Person, String> tabelLastName;

    @FXML
    private TableColumn<Person, Integer> tableId;

    @FXML
    private TableColumn<Person, Integer> tabelBirthYear;

    @FXML
    private TableColumn<Person, String> tableCity;

    @FXML
    private Tab tree;

    @FXML
    private AnchorPane treePane;

    @FXML
    private Button saveAsPDF;

    @FXML
    private Button addNewPerson;

    @FXML
    private Button createTreeViewButton;

    @FXML
    private Tab treePreview;

    @FXML
    private AnchorPane treePreviewPane;

    @FXML
    private Button viewList;

    @FXML
    private Tab filter;

    @FXML
    void addNewPerson(MouseEvent event) {
        
        for(PersonTree i : App.peopleTree)
        {
            System.out.println(i.getName() + " " + i.Level);
        }
    }

    // @FXML
    // void createPdf(ActionEvent event) {

    // }

    // @FXML
    // void createTree(ActionEvent event) {

    // }

    @FXML
    void createTreeView(ActionEvent event) {

    
        Stage outputStage = new Stage();
        Pane mainPane = new Pane();
        mainPane.setPrefSize(800, 800);

       HashSet<Integer> generations = new HashSet<Integer>();
       int minGen = 0;
       for(PersonTree i : App.peopleTree) {
           generations.add(i.Level);
           minGen = Math.min(minGen, i.Level);
       }

    //    ArrayList<PersonTree>[] generationPeople = new ArrayList<PersonTree>[generations.size()]();
       
       ArrayList<ArrayList<PersonTree>> generationPeople = new ArrayList<ArrayList<PersonTree>>();
       ArrayList<PersonTree> allPeople = new ArrayList<PersonTree>();

       for(int i = 0; i < generations.size(); i++)
       {
           generationPeople.add(new ArrayList());
       }

       List<Integer> sortedGenLevels = new ArrayList<Integer>(generations);
       Collections.sort(sortedGenLevels);

       int layer = 1;
       for(Integer i: sortedGenLevels) {
          ArrayList<PersonTree> currentGen = new ArrayList<PersonTree>();
          for(PersonTree j: App.peopleTree) {
              if(j.Level == i) {
                
                PersonTree temp = new PersonTree(j.getName(), j.getLastName(), j.getBirthPlace(), j.getIdentificationNumber(), j.getBirthYear(), 0 , 0);
    
                currentGen.add(temp);
                allPeople.add(temp);
              }
          }

          // Add people to the tab
        //   int stepX = (int) (App.getStage().getWidth() / currentGen.size() + 60);
        int stepX = (int) (800 / currentGen.size() + 60);
        int spaceY = layer * 60;
        int counter = 1;
        for (PersonTree j: currentGen) {
            // this.treePreviewPane.getChildren().addAll(j.mainBody);
            mainPane.getChildren().add(j.mainBody);
            j.mainBody.setLayoutX(counter * stepX);
            j.mainBody.setLayoutY(spaceY);
            counter++;
            System.out.println(j.mainBody);
        }
          layer++;
       }

       for(Connection i: App.connections)
       {
           int id1 = i.personOne.getIdentificationNumber();
           int id2 = i.personTwo.getIdentificationNumber();

           PersonTree one = null, two = null;

           for (PersonTree j: allPeople) {
               if (id2 == j.getIdentificationNumber())
                    two = j;
                if (id1 == j.getIdentificationNumber())
                    one = j;
           }
           Connection temp = null;
           if(one != null && two != null)
           {
                temp = new Connection(one, two, i.connectionType);
           }
           
           mainPane.getChildren().addAll(i.line);
           i.updatePosition();
       }
        updateConnections();

        Scene mainScene = new Scene(mainPane);
        outputStage.setScene(mainScene);
        outputStage.show();
        outputStage.setTitle("Medis");
    }

    public static boolean selected = false;
    public static PersonTree selectedTreeItem = null;
    public static PersonTree connected;
    @FXML
    void mouseClickPane(MouseEvent event) {
        int mouseX = (int) event.getX();
        int mouseY = (int) event.getY();
        // System.out.println(mouseX + " " + mouseY);
        

        if(!selected)
        {
            for(PersonTree i: App.peopleTree)
            {
                if(i.clicked)
                {
                    selected = true;
                    selectedTreeItem = i;
                } 
            
            }
        } else {
            boolean newConnection = false;
            connected = null;
            for(PersonTree i: App.peopleTree) 
            {
                if(i.clicked){
                    newConnection  = true;
                    connected = i;
                }
            }

            if(newConnection) {
                try {
                    if(selectedTreeItem.getIdentificationNumber() != connected.getIdentificationNumber())
                        createNewConnection(selectedTreeItem, connected);
                } catch (IOException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
                selected = false;
                selectedTreeItem = null;
            }else {
                selectedTreeItem.mainBody.setLayoutX(mouseX);
                selectedTreeItem.mainBody.setLayoutY(mouseY);
                selectedTreeItem = null;
                selected = false;
            }
        }

        updateConnections();

        for(PersonTree i : App.peopleTree){
            if(i.clicked)
                i.clicked = false;

        }
    }

    public void updateConnections()
    {
        for(Connection i : App.connections)
        {
            // this.treePane.getChildren().addAll(i.line);
            i.updatePosition();
            i.line.toBack();
        }
    }

    public void createNewConnection(PersonTree first, PersonTree second) throws IOException
    {
        System.out.println("new Connection" + first.getName() + " " + second.getName());
        Stage connectionWindow = new Stage();
        
        Pane mainPane = new Pane();
        mainPane.setPrefSize(200, 200);

        RadioButton marriageButton = new RadioButton("Sutuoktiniai");
        marriageButton.setLayoutX(49.0); marriageButton.setLayoutY(59.0); 
        RadioButton perentButton = new RadioButton("Tėvai");
        perentButton.setLayoutX(49.0); perentButton.setLayoutY(83.0); 
        RadioButton childButton = new RadioButton("Vaikai");
        childButton.setLayoutX(49.0); childButton.setLayoutY(107.0);  

        ToggleGroup connectionType  = new ToggleGroup();

        marriageButton.setToggleGroup(connectionType);
        perentButton.setToggleGroup(connectionType);
        childButton.setToggleGroup(connectionType);
        

        Button okButton = new Button("Sukurti ryšį");
        okButton.setLayoutX(60.0); okButton.setLayoutY(149.0);

        okButton.setOnAction(event -> {
            RadioButton checked = (RadioButton) connectionType.getSelectedToggle();

            if(checked.getText().equals("Sutuoktiniai")) {
                if(first.marriage == null && second.marriage == null)
                {
                    first.marriage = second;
                    second.marriage = first;
                    Connection newConnectionLine = (new Connection(first, second, "Sutuoktiniai"));
                    App.connections.add(newConnectionLine);
                    treePane.getChildren().add(newConnectionLine.line);
                }
            }
            else if(checked.getText().equals("Vaikai")) {
                first.children.add(second);
                second.parents.add(first);
                Connection newConnectionLine = (new Connection(first, second, "Vaikai"));
                App.connections.add(newConnectionLine);
                treePane.getChildren().add(newConnectionLine.line);
                first.Level = second.Level + 1;
            } else if(checked.getText().equals("Tėvai")) {
                first.parents.add(second);
                second.children.add(first);
                Connection newConnectionLine = (new Connection(first, second, "Tėvai"));
                App.connections.add(newConnectionLine);
                treePane.getChildren().add(newConnectionLine.line);
                second.Level = first.Level + 1;
            }

            // System.out.print("Pressed");
            connectionWindow.close();
        });
        

        mainPane.getChildren().addAll(marriageButton, perentButton, childButton, okButton);
         
        Scene mainScene = new Scene(mainPane);
        connectionWindow.setScene(mainScene);
        connectionWindow.show();
        connectionWindow.setTitle("Nustatykite ryšį tarp " + first.getName() + " ir " + second.getName());
        
    }
    
    @FXML
    void initialize() {
        assert data != null : "fx:id=\"data\" was not injected: check your FXML file 'DataScene.fxml'.";
        assert tabelData != null : "fx:id=\"tabelData\" was not injected: check your FXML file 'DataScene.fxml'.";
        assert tableName != null : "fx:id=\"tableName\" was not injected: check your FXML file 'DataScene.fxml'.";
        assert tabelLastName != null : "fx:id=\"tabelLastName\" was not injected: check your FXML file 'DataScene.fxml'.";
        assert tableId != null : "fx:id=\"tableId\" was not injected: check your FXML file 'DataScene.fxml'.";
        assert tabelBirthYear != null : "fx:id=\"tabelBirthYear\" was not injected: check your FXML file 'DataScene.fxml'.";
        assert tableCity != null : "fx:id=\"tableCity\" was not injected: check your FXML file 'DataScene.fxml'.";
        assert tree != null : "fx:id=\"tree\" was not injected: check your FXML file 'DataScene.fxml'.";
        assert treePane != null : "fx:id=\"treePane\" was not injected: check your FXML file 'DataScene.fxml'.";
        assert saveAsPDF != null : "fx:id=\"saveAsPDF\" was not injected: check your FXML file 'DataScene.fxml'.";
        assert addNewPerson != null : "fx:id=\"addNewPerson\" was not injected: check your FXML file 'DataScene.fxml'.";
        assert createTreeViewButton != null : "fx:id=\"createTreeViewButton\" was not injected: check your FXML file 'DataScene.fxml'.";
        assert treePreview != null : "fx:id=\"treePreview\" was not injected: check your FXML file 'DataScene.fxml'.";
        assert treePreviewPane != null : "fx:id=\"treePreviewPane\" was not injected: check your FXML file 'DataScene.fxml'.";
        assert viewList != null : "fx:id=\"viewList\" was not injected: check your FXML file 'DataScene.fxml'.";
        assert filter != null : "fx:id=\"filter\" was not injected: check your FXML file 'DataScene.fxml'.";

        tableName.setCellValueFactory(new PropertyValueFactory<Person, String>("name"));
        tabelLastName.setCellValueFactory(new PropertyValueFactory<Person, String>("lastName"));
        tableId.setCellValueFactory(new PropertyValueFactory<Person, Integer>("identificationNumber"));
        tabelBirthYear.setCellValueFactory(new PropertyValueFactory<Person, Integer>("birthYear"));
        tableCity.setCellValueFactory(new PropertyValueFactory<Person, String>("birthPlace"));

        
        ObservableList<Person> tempTableData = FXCollections.observableArrayList();
        for (Person i : App.people)
        {
            Person temp1 = i;
            tempTableData.addAll(FXCollections.observableArrayList(temp1));
            // temp.add(i);
        }
        
        // tabelData.getColumns().addAll(tableName, tabelLastName, tableId, tabelBirthYear, tableCity);
        tabelData.setItems(tempTableData);
        
        for (PersonTree i : App.peopleTree)
        {
            this.treePane.getChildren().addAll(i.mainBody);
        }

    }
}