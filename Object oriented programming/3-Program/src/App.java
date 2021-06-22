/**
 * @author: Ernestas Škudzinskas
 * 
 */

import java.io.Console;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Iterator;

import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.FormulaEvaluator;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import People.PersonTableData;
import People.PersonTree;
import javafx.application.*;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.Parent;
import javafx.scene.layout.Pane;
import javafx.stage.Stage;
import javafx.scene.shape.*;

public class App extends Application{
    public static void main(String[] args) throws Exception {
        launch(args);
    }
    
    private static Stage guiStage;
    
    public static Stage getStage() {
        return guiStage;
    }

    public static ArrayList<PersonTableData> people = new ArrayList<PersonTableData>();
    public static ArrayList<PersonTree> peopleTree = new ArrayList<PersonTree>();
    public static ArrayList<Connection> connections = new ArrayList<Connection>();

    @Override
    public void start(Stage primaryStage) throws Exception {
        
        FXMLLoader fxmlLoader = new FXMLLoader(getClass().getResource("MainScene.fxml"));
        Parent root = (Parent) fxmlLoader.load();
        MainSceneController mainSceneController = fxmlLoader.getController();
    
        Scene scene = new Scene(root);
        
        guiStage = primaryStage;
        primaryStage.setScene(scene);
        primaryStage.show();

    }

    public static void readFromFile(String fileName) /*throws Exception*/
    {
        // System.out.println("Bravo six we got it " + fileName);
        
        try {
            File file = new File(fileName);
            FileInputStream fis = new FileInputStream(file);

            XSSFWorkbook wb = new XSSFWorkbook(fis);

            XSSFSheet sheet = wb.getSheetAt(0);

            Iterator<Row> itr = sheet.iterator();
        int count = 0;
        while (itr.hasNext())                 
        {  
            Row row = itr.next();  
            Iterator<Cell> cellIterator = row.cellIterator();   //iterating over each column  
            String name, lastName, birthPlace;
            int idNum, birthYear;
            
            Cell cell = cellIterator.next();
            name = cell.getStringCellValue();
            cell = cellIterator.next();
            lastName = cell.getStringCellValue();
            cell = cellIterator.next();
            idNum = (int) cell.getNumericCellValue();
            cell = cellIterator.next();
            birthYear = (int) cell.getNumericCellValue();
            cell = cellIterator.next();
            birthPlace = cell.getStringCellValue();

            System.out.print(String.format("%s %s %d %d %s\n", name, lastName, idNum, birthYear, birthPlace));
            PersonTableData temp1 = new PersonTableData(name, lastName, birthPlace, idNum, birthYear);
            PersonTree temp2 = new PersonTree(name, lastName, birthPlace, idNum, birthYear, 100 * count, 100 * count);
            count++;
            people.add(temp1);
            peopleTree.add(temp2);
        } 
        
        fis.close();

        
    } catch (Exception e)
    {
        e.printStackTrace();
    }
    }

}
