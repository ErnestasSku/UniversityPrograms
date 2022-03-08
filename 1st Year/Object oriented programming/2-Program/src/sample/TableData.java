package sample;

import javafx.beans.property.SimpleStringProperty;

public class TableData {
    SimpleStringProperty month;
    SimpleStringProperty leftUnpaid;
    SimpleStringProperty needToPay;
    SimpleStringProperty increase;

    TableData(String month, String leftUnpaid, String needToPay, String increase)
    {
        this.month = new SimpleStringProperty(month);
        this.leftUnpaid = new SimpleStringProperty(leftUnpaid);
        this.needToPay = new SimpleStringProperty(needToPay);
        this.increase = new SimpleStringProperty(increase);
    }

    public String getMonth() {return month.get();}
    public void setMonth(String month) {this.month.set(month);}

    public String getLeftUnpaid() {return leftUnpaid.get();}
    public  void setLeftUnpaid(String leftUnpaid) {this.leftUnpaid.set(leftUnpaid);}

    public String getNeedToPay() {return needToPay.get();}
    public  void setNeedToPay(String needToPay) {this.needToPay.set(needToPay);}

    public String getIncrease() {return increase.get();}
    public  void setIncrease(String increase) {this.increase.set(increase);}
}
