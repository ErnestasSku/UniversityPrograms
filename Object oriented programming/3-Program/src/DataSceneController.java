import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.ResourceBundle;

import javax.imageio.ImageIO;
import javax.swing.Action;

import com.itextpdf.kernel.geom.PageSize;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import People.Person;
import People.PersonTableData;
import People.PersonTree;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.collections.transformation.FilteredList;
import javafx.embed.swing.SwingFXUtils;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.Scene;
import javafx.scene.SnapshotParameters;
import javafx.scene.control.Button;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.RadioButton;
import javafx.scene.control.Tab;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.TextField;
import javafx.scene.control.ToggleGroup;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.image.Image;
import javafx.scene.image.WritableImage;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.Pane;
import javafx.stage.FileChooser;
import javafx.stage.Stage;

public class DataSceneController {

    @FXML
    private ResourceBundle resources;

    @FXML
    private URL location;

    @FXML
    private Tab data;

    @FXML
    private AnchorPane dataTableAnchorPane;
    
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
    private Button addNewPerson;

    @FXML
    private Tab treePreview;

    @FXML
    private AnchorPane treePreviewPane;

    @FXML
    private Button viewList;

    @FXML
    private Button Button;

    @FXML
    private Tab filter;

    @FXML
    private ChoiceBox<String> filterList;

    @FXML
    private Button filterButton;


    TextField nameField = new TextField("Vardas");
    TextField lastNameField = new TextField("Pavardė");
    TextField birthPlaceField = new TextField("Gimimo vieta");
    TextField idNumberField = new TextField("ID numeris");
    TextField bithYearField = new TextField("Gimimo metai");
    Stage newPersonStage = new Stage();
    @FXML
    void addNewPerson(MouseEvent event) {
        
        for(PersonTree i : App.peopleTree)
        {
            System.out.println(i.getName() + " " + i.Level);
        }

        
        Pane newPersonPane = new Pane();
        newPersonPane.prefWidth(600);
        newPersonPane.prefHeight(400);

        
        Button submitButton = new Button("Pridėti");
        nameField.setLayoutX(50); nameField.setLayoutY(50);
        lastNameField.setLayoutX(50); lastNameField.setLayoutY(100);
        birthPlaceField.setLayoutX(50); birthPlaceField.setLayoutY(150);
        idNumberField.setLayoutX(50); idNumberField.setLayoutY(200);
        bithYearField.setLayoutX(50); bithYearField.setLayoutY(250);
        submitButton.setLayoutX(50); submitButton.setLayoutY(300);
        setSubmitButton(submitButton);


        newPersonPane.getChildren().addAll(nameField, lastNameField, birthPlaceField, idNumberField, bithYearField, submitButton);
        
        Scene newPersonScene = new Scene(newPersonPane);
        newPersonStage.setScene(newPersonScene);
        newPersonStage.show();
        newPersonStage.setTitle("Naujas žmogus");
    }

    public void setSubmitButton(Button button) {
        Button = button;
        
        Button.setOnAction(event -> {
            // TODO: should add type checking / data validation
            String name = nameField.getText();
            String lastName = lastNameField.getText();
            String birthPlace = birthPlaceField.getText();
            int id = Integer.parseInt(idNumberField.getText());
            int birthYear = Integer.parseInt(bithYearField.getText());

            PersonTableData temp1 = new PersonTableData(name, lastName, birthPlace, id, birthYear);
            App.people.add(temp1);
            tabelData.getItems().add(temp1);
            
            PersonTree temp2 = new PersonTree(name, lastName, birthPlace, id, birthYear, 150, 360);
            App.peopleTree.add(temp2);
            treePane.getChildren().add(temp2.mainBody);
            newPersonStage.close();
        });
        
    }

    WritableImage treeViewImage = null;
    WritableImage dataTableImage = null;

    Button saveAsPdfButton = new Button("Išsaugoti kaip pdf");
    public void setSaveAsPdfButton(Button saveAsPdfButton) {
        this.saveAsPdfButton = saveAsPdfButton;
        
        saveAsPdfButton.setOnAction(event -> {
            System.out.println("Printing time");

            FileChooser fileChooser = new FileChooser();

            fileChooser.getExtensionFilters().add(new FileChooser.ExtensionFilter("png files (*.png)","*.png"));

            // File file1 = fileChooser.showSaveDialog(null);
            // File file2 = fileChooser.showSaveDialog(null);

            File file1 = new File("treeImg.png");
            File file2 = new File("dataImg.png");

            // if (file1 != null) {
            try {
                // WritableImage writableImage = new WritableImage((int)getWidth() + 20,(int)getHeight() + 20);
                ImageIO.write(SwingFXUtils.fromFXImage(treeViewImage, null), "png", file1);
            } catch (IOException ex ) {ex.printStackTrace();}
            // }

            // if (file2 != null) {
            try {
                // WritableImage writableImage = new WritableImage((int)getWidth() + 20,(int)getHeight() + 20);
                ImageIO.write(SwingFXUtils.fromFXImage(dataTableImage, null), "png", file2);
            } catch (IOException ex ) {ex.printStackTrace();}
            // }

        
        });
    }

    @FXML
    Button checkForChoicesButton;

    @FXML
    void checkForChoices(ActionEvent event) {

        System.out.println("x");
        // filterList = new ChoiceBox<String>();
        HashSet<String> uniqueNames = new HashSet<String>();
        
        for(PersonTree i: App.peopleTree) {
            uniqueNames.add(i.getName());
        }
        
        ArrayList<String> names = new ArrayList<String>(uniqueNames);
        filterList.getItems().setAll(names);

        // filterList.setItems(FXCollections.observableArrayList("First", "Second", "Third"));
        // System.out.print(filterList.getItems());
        // for(PersonTree i: App.peopleTree) {
            // filterList.setItems(FXCollections.observableArrayList(i.()));
        // }
    }

    @FXML
    void filterPeople(ActionEvent event) {
        System.out.print(filterList.getSelectionModel().getSelectedItem());
        
        Stage filteredStage = new Stage();
        Pane filteredPane = new Pane();
        filteredPane.setPrefSize(600, 600);

        ArrayList<PersonTree> searchingPersonId = new ArrayList<PersonTree>();
        ArrayList<PersonTree> queue = new ArrayList<PersonTree>();

        for(PersonTree i: App.peopleTree) {
            if(i.getName() == filterList.getSelectionModel().getSelectedItem()){
                searchingPersonId.add(i);
                queue.add(i);
            }
        }

        int layer = 1, peopleCounter = searchingPersonId.size();
        
        while(searchingPersonId.size() > 0) {
            int tempXPlaceHolder = 1;
            int stepX = 600 / (searchingPersonId.size() + 1) + 60;
            int spaceY = layer * 60;
            ArrayList<PersonTree> tempQueue = new ArrayList<PersonTree>(); 
            for (PersonTree j: searchingPersonId) {
                PersonTree temp = new PersonTree(j.getName(), j.getLastName(), j.getBirthPlace(), j.getIdentificationNumber(), j.getBirthYear(), 0 , 0);
                temp.mainBody.setLayoutX(stepX * (tempXPlaceHolder++));
                temp.mainBody.setLayoutY(spaceY);
                System.out.println( " " + spaceY);
                filteredPane.getChildren().add(temp.mainBody);
                for(PersonTree i: j.children)
                    tempQueue.add(i);
            }
            searchingPersonId = tempQueue;

            layer++;
        }

        // filteredPane.getChildren().addAll
        Scene filterScene = new Scene(filteredPane);
        filteredStage.setScene(filterScene);
        filteredStage.show();

    }

    @FXML
    void createTree(ActionEvent event) {
        
        saveAsPdfButton.setLayoutX(300);
        saveAsPdfButton.setLayoutY(500);
        setSaveAsPdfButton(saveAsPdfButton);
        Stage outputStage = new Stage();
        Pane mainPane = new Pane();
        mainPane.setPrefSize(600, 600);

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
        int stepX = (int) (600 / (currentGen.size() + 1));
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
           
           mainPane.getChildren().addAll(temp.line);
           temp.updatePosition();
       }
        updateConnections();

        mainPane.getChildren().addAll(saveAsPdfButton);
        Scene mainScene = new Scene(mainPane);
        outputStage.setScene(mainScene);
        outputStage.show();
        outputStage.setTitle("Medis");
        treeViewImage = mainPane.snapshot(new SnapshotParameters(), null);
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
                second.Level = first.Level + 1;
            } else if(checked.getText().equals("Tėvai")) {
                first.parents.add(second);
                second.children.add(first);
                Connection newConnectionLine = (new Connection(first, second, "Tėvai"));
                App.connections.add(newConnectionLine);
                treePane.getChildren().add(newConnectionLine.line);
                second.Level = first.Level - 1;
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
    Button saveToExButton;

    @FXML
    void SaveToExcell(ActionEvent event) {
        XSSFWorkbook workbook = new XSSFWorkbook();

        XSSFSheet spreadsheet = workbook.createSheet(" Ryšiai ");

        Object[][] bookData = new Object[100][100];

        int rowCounter = 0, colCounter = 0;
        for(PersonTree i: App.peopleTree) {
            colCounter = 0;
            bookData[rowCounter][colCounter++] = i.getName();
            bookData[rowCounter][colCounter++] = i.getLastName();
            bookData[rowCounter][colCounter++] = i.getBirthPlace();
            bookData[rowCounter][colCounter++] = i.getIdentificationNumber();
            bookData[rowCounter][colCounter++] = i.getBirthYear();

            if(i.marriage != null)
            {
                String temp = "Sutuoktinis " + i.marriage.getName() + " " + i.marriage.getLastName(); 
                bookData[rowCounter][colCounter++] = temp;
            }
            
            for(PersonTree j: i.parents) {
                String temp = "Tėvai " + j.getName() + " " + j.getLastName(); 
                bookData[rowCounter][colCounter++] = temp;
            }

            for(PersonTree j: i.children) {
                String temp = "Vaikai " + j.getName() + " " + j.getLastName(); 
                bookData[rowCounter][colCounter++] = temp;
            }
            
            rowCounter++;
        }

        rowCounter = 0; colCounter = 0;

        for (Object[] aBook : bookData) {
            Row row = spreadsheet.createRow(rowCounter++);

            colCounter = 0;

            for (Object field : aBook) {
                Cell cell = row.createCell(colCounter++);
                if (field instanceof String ){
                    cell.setCellValue((String) field);
                } else if(field instanceof Integer) {
                    cell.setCellValue((Integer) field);
                }
            }
        }

        try {
            FileOutputStream outputStream = new FileOutputStream("JavaConnections.xlsx"); 
            workbook.write(outputStream);
        } catch (Exception e) {
            
        }

    }

    @FXML
    void initialize() {
        assert data != null : "fx:id=\"data\" was not injected: check your FXML file 'NewDataScene.fxml'.";
        assert tabelData != null : "fx:id=\"tabelData\" was not injected: check your FXML file 'NewDataScene.fxml'.";
        assert tableName != null : "fx:id=\"tableName\" was not injected: check your FXML file 'NewDataScene.fxml'.";
        assert tabelLastName != null : "fx:id=\"tabelLastName\" was not injected: check your FXML file 'NewDataScene.fxml'.";
        assert tableId != null : "fx:id=\"tableId\" was not injected: check your FXML file 'NewDataScene.fxml'.";
        assert tabelBirthYear != null : "fx:id=\"tabelBirthYear\" was not injected: check your FXML file 'NewDataScene.fxml'.";
        assert tableCity != null : "fx:id=\"tableCity\" was not injected: check your FXML file 'NewDataScene.fxml'.";
        assert tree != null : "fx:id=\"tree\" was not injected: check your FXML file 'NewDataScene.fxml'.";
        assert treePane != null : "fx:id=\"treePane\" was not injected: check your FXML file 'NewDataScene.fxml'.";
        assert addNewPerson != null : "fx:id=\"addNewPerson\" was not injected: check your FXML file 'NewDataScene.fxml'.";
        assert treePreview != null : "fx:id=\"treePreview\" was not injected: check your FXML file 'NewDataScene.fxml'.";
        assert treePreviewPane != null : "fx:id=\"treePreviewPane\" was not injected: check your FXML file 'NewDataScene.fxml'.";
        assert viewList != null : "fx:id=\"viewList\" was not injected: check your FXML file 'NewDataScene.fxml'.";
        assert Button != null : "fx:id=\"Button\" was not injected: check your FXML file 'NewDataScene.fxml'.";
        assert filter != null : "fx:id=\"filter\" was not injected: check your FXML file 'NewDataScene.fxml'.";
        assert filterList != null : "fx:id=\"filterList\" was not injected: check your FXML file 'NewDataScene.fxml'.";
        assert filterButton != null : "fx:id=\"filterButton\" was not injected: check your FXML file 'NewDataScene.fxml'.";

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
