package sample;

import javafx.application.Application;
import javafx.beans.property.SimpleStringProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.chart.LineChart;
import javafx.scene.chart.NumberAxis;
import javafx.scene.chart.XYChart;
import javafx.scene.control.*;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.*;
import javafx.scene.paint.Color;
import javafx.scene.text.Text;
import javafx.stage.Stage;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;


public class Main extends Application {


    /////Input
    private TextField desiredLoanInput;
    private TextField loanTermYearsInput;
    private TextField loanTermMonthsInput;
    private RadioButton annuity;
    private RadioButton linear;
    private ToggleGroup graphGroup;
    private TextField loanPercentInput;

    private Button calculate;

    private Scene inputScene;
    /////Output
    final ObservableList<TableData> tableData = FXCollections.observableArrayList();
    private final TableView<TableData> table = new TableView<>();
    private Scene outputScene;

    public void Main(String[] args) {


        PrepeareFirstScene();
//        launch(args);

    }

    @Override
    public void start(Stage primaryStage) throws Exception {
        PrepeareFirstScene();

        primaryStage.setTitle("Paskolų skaičiuoklė");
        primaryStage.setResizable(false);
        primaryStage.setScene(inputScene);
        primaryStage.show();

        calculate.setOnAction(event -> {
            RadioButton checked = (RadioButton) graphGroup.getSelectedToggle();

            if(validData()) {

                if (checked.getText().equals("Anuiteto")) {
                    double sum = Double.parseDouble(desiredLoanInput.getText());
                    int years = Integer.parseInt(loanTermYearsInput.getText());
                    int months = Integer.parseInt((loanTermMonthsInput.getText()));
                    double percentage = Double.parseDouble(loanPercentInput.getText());
                    Anuity data = new Anuity(sum, years, months, percentage);
                    data.calculate();
                    prepareOutputScene(data, "Anuiteto");
                    primaryStage.setScene(outputScene);
                } else if (checked.getText().equals("Linijinis")) {
                    double sum = Double.parseDouble(desiredLoanInput.getText());
                    int years = Integer.parseInt(loanTermYearsInput.getText());
                    int months = Integer.parseInt((loanTermMonthsInput.getText()));
                    double percentage = Double.parseDouble(loanPercentInput.getText());
                    Linear data = new Linear(sum, years, months, percentage);
                    data.calculate();
                    prepareOutputScene(data, "Linijinis");
                    primaryStage.setScene(outputScene);
                }
            }
        });
    }
    private Boolean validData()
    {
//        TextField desiredLoanInput;
//        TextField loanTermYearsInput;
//        TextField loanTermMonthsInput;
//        TextField loanPercentInput;

        if(desiredLoanInput.getText().equals("")){printError("Paskolos suma įvesta neteisingai"); return false;}
        if(loanTermMonthsInput.getText().equals("")){printError("Paskolos terminas įvestas neteisingai"); return false;}
        if(loanTermYearsInput.getText().equals("")){printError("Paskolos terminas įvestas neteisingai"); return false;}
        if(graphGroup.getSelectedToggle() == null){printError("Paskolos grafikas įvestas neteisingai"); return false;}
        if(loanPercentInput.getText().equals("")){printError("Paskolos procentas įvestas neteisingai"); return false;}

        //Check if the input is correct
        try{
            double temp = Double.parseDouble(desiredLoanInput.getText());
            if(temp <= 0){printError("Paskolos suma įvesta neteisingai"); return false;}
        } catch (NumberFormatException exception){
            printError("Paskolos suma įvesta neteisingai");
            return false;
        }

        try{
            int temp1 = Integer.parseInt(loanTermYearsInput.getText());
            int temp2 = Integer.parseInt(loanTermMonthsInput.getText());
            if( (temp1 == 0 && temp2 == 0) || temp1 < 0 || temp2 < 0 ){printError("Neteisingai įvestas paskolos terminas"); return false;}
        }catch ( NumberFormatException exception)
        {
            printError("Neteisingai įvestas paskolos terminas");
            return false;
        }

        try{
            double temp = Double.parseDouble(loanPercentInput.getText());
            if(temp <= 0) {printError("Neteisingai įvestas paskolos procentas"); return false;}
        } catch (NumberFormatException exception)
        {
            printError("Neteisingai įvestas paskolos procentas");
            return false;
        }

        return true;
    }
    private void printError(String message)
    {
        Alert alert = new Alert(Alert.AlertType.ERROR);
        alert.setTitle("Klaida");
        alert.setHeaderText("Įvesties klaida");
        alert.setContentText(message);
        alert.showAndWait();
    }

    void PrepeareFirstScene() {
        //Paskolos suma
        Text desiredLoan = new Text("Pageidaujama paskolos suma: ");
        desiredLoanInput = new TextField();
        desiredLoanInput.setAlignment(Pos.CENTER_RIGHT);
        desiredLoanInput.setPrefSize(100, 20);
        Text euroSign = new Text("€");

        //Paskolos terminas
        Text loanTermYears = new Text("Paskolos terminas. Metai: ");
        Text loanTermMonths = new Text("Mėnesiai: ");
        loanTermYearsInput = new TextField();
        loanTermMonthsInput = new TextField();
        loanTermMonthsInput.setPrefSize(40, 20);
        loanTermYearsInput.setPrefSize(40, 20);
        loanTermMonthsInput.setAlignment(Pos.CENTER_RIGHT);
        loanTermYearsInput.setAlignment(Pos.CENTER_RIGHT);


        //Paskolos grafikas
        Text loanType = new Text("Paskolos gražinimo grafikas: ");
        annuity = new RadioButton("Anuiteto");
        linear = new RadioButton("Linijinis");
        graphGroup = new ToggleGroup();
        annuity.setToggleGroup(graphGroup);
        linear.setToggleGroup(graphGroup);


        //Paskolos procentai
        Text loanPercent = new Text("Metinės palūkanos: ");
        loanPercentInput = new TextField();
        loanPercentInput.setAlignment(Pos.CENTER_RIGHT);
        loanPercentInput.setPrefSize(40, 20);
        Text percentSign = new Text("%");

        //Button
        calculate = new Button("Skaičiuoti");

        HBox hBox[] = new HBox[5];
        hBox[0] = new HBox(desiredLoan, desiredLoanInput, euroSign);
        hBox[1] = new HBox(loanTermYears, loanTermYearsInput, loanTermMonths, loanTermMonthsInput);
        hBox[2] = new HBox(loanType, annuity, linear);
        hBox[3] = new HBox(loanPercent, loanPercentInput, percentSign);


        VBox vBox = new VBox();
        vBox.setPadding(new Insets(50, 0, 0, 20));
        vBox.setSpacing(3);
        for (int i = 0; i < 4; i++) {
            hBox[i].setPadding(new Insets(10, 0, 0, 0));
            hBox[i].setSpacing(5);
            vBox.getChildren().add(hBox[i]);
        }

        calculate.setLayoutX(400);
        calculate.setLayoutY(400);
        vBox.getChildren().add(calculate);
        //Pane
        Pane inputPane = new Pane();
        inputPane.getChildren().addAll(vBox);
        inputScene = new Scene(inputPane, 450, 300);
    }

    void prepareOutputScene(Data data, String type) {
        Label typeS = new Label(type);


        Pane left = new Pane(typeS);
        left.setPrefSize(300, 300);

        //Tableview
        table.setEditable(true);

        TableColumn month = new TableColumn("Mėnuo");
        TableColumn leftToPay = new TableColumn("Liko nesumokėta");
        TableColumn paid = new TableColumn("Reikia sumokėti");
        TableColumn increase = new TableColumn("Palūkanos");

        month.setCellValueFactory(
                new PropertyValueFactory<TableData, String>("month"));
        leftToPay.setCellValueFactory(
                new PropertyValueFactory<TableData, String>("leftUnpaid"));
        paid.setCellValueFactory(
                new PropertyValueFactory<TableData, String>("needToPay"));
        increase.setCellValueFactory(
                new PropertyValueFactory<TableData, String>("increase"));


        for (int i = 0; i < (data.years * 12 + data.months); i++) {
            TableData temp = new TableData(String.valueOf(i + 1), String.valueOf(data.remainder[i]), String.valueOf(data.payment[i]), String.valueOf(data.increase[i]));
//            temp.setIncrease("popo");
//            tableData.addAll(  FXCollections.observableArrayList(
//                    new TableData( Integer.toString(i + 1), String.valueOf(data.remainder[i]), String.valueOf(data.payment[i]), String.valueOf(data.increase[i]))
//            ) );
            tableData.addAll(FXCollections.observableArrayList(temp));
        }

        table.getColumns().addAll(month, leftToPay, paid, increase);
        table.setItems(tableData);


        left.getChildren().add(table);
//        left.setPadding(new Insets(10, 10, 10, 10));


        Pane right = new Pane();

        NumberAxis xAxis = new NumberAxis();
        NumberAxis yAxis = new NumberAxis();
        xAxis.setLabel("Mėnuo");

        LineChart<Number, Number> lineCHart = new LineChart<>(xAxis, yAxis);
        lineCHart.setTitle("Paskolos likutis");
        XYChart.Series series = new XYChart.Series();
        for (int i = 0; i < data.years * 12 + data.months; i++) {
            series.getData().add(new XYChart.Data(i + 1, data.remainder[i]));
        }
        lineCHart.getData().add(series);
        right.getChildren().add(lineCHart);
        right.setPrefSize(300, 300);


        HBox outputPane = new HBox(left, right);
        outputPane.setSpacing(20);

        outputScene = new Scene(outputPane, 800, 400);

        writeToFile(data);

    }

    public void writeToFile(Data data) {

//        System.out.print("Bravo six" + (data.years * 12 + data.months) );
        try {
            FileWriter newFile = new FileWriter("Output.txt");

            for (int i = 0; i < data.years * 12 + data.months; i++) {
                newFile.write("Mėnuo: " + (i + 1) + " Liko sumokėti: " + data.remainder[i] + " Reikia sumokėti: " + data.payment[i] + " Ikainis: " + data.increase[i] + "\r\n");
            }
            newFile.close();
        } catch (IOException e) {
            System.out.println("An error occured");
            e.printStackTrace();
        }
    }
}


