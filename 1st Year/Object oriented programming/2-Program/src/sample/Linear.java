package sample;

public class Linear extends Data {

    Linear(double sum, int years, int months, double percentage)
    {

        super(sum, years, months, percentage);
    }

    public void calculate()
    {
        int n = years * 12 + months;
        double base = sum / n;
        double monthlyPercent = percentage / 100 / 12;
//        double baseInterest = sum * monthlyPercent;

        remainder[0] = sum;
        increase[0] = remainder[0] * monthlyPercent;
        payment[0] = base + increase[0];
        round(0);
        for(int i = 1; i < n; i++)
        {
            remainder[i] = remainder[i - 1] - payment[i-1] + increase[i - 1];
            increase[i] = remainder[i] * monthlyPercent;
            payment[i] = base + increase[i];
            round(i);;
        }
    }


}
