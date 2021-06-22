package People;

import javafx.beans.property.SimpleStringProperty;

public class PersonTableData extends Person{

    SimpleStringProperty tableName = new SimpleStringProperty();

    public PersonTableData(String name, String lastName, String birthPlace, int identificationNumber, int birthYear) {
        super(name, lastName, birthPlace, identificationNumber, birthYear);
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