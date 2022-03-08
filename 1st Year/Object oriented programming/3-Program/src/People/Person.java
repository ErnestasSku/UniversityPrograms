package People;
public abstract class Person{
    String name, lastName, birthPlace;
    int identificationNumber, birthYear;

    Person(String name, String lastName, String birthPlace, int identificationNumber, int birthYear)
    {
        this.name = name;
        this.lastName = lastName;
        this.birthPlace = birthPlace;
        this.identificationNumber = identificationNumber;
        this.birthYear = birthYear;
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
