package sample;

public class Data {
    double sum;
    int years, months;
    double percentage;

    double remainder[], payment[], increase[];

    Data(double sum, int years, int months, double percentage)
    {
        this.sum = sum;
        this.years = years;
        this.months = months;
        this.percentage = percentage;
        remainder = new double[this.years * 12 + this.months + 1];
        payment = new double[this.years * 12 + this.months + 1];
        increase = new double[this.years * 12 + this.months + 1];


    }
    Data()
    {

    };

    public void round(int i)
    {
        remainder[i] = Math.round(remainder[i] * 100.0) / 100.0;
        payment[i] = Math.round(payment[i] * 100.0) / 100.0;
        increase[i] = Math.round(increase[i] * 100.0) / 100.0;

    };
}
