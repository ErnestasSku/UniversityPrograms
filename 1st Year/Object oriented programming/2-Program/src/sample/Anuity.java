package sample;

public class Anuity extends Data {

    Anuity(double sum, int years, int months, double percentage)
    {
        super(sum, years, months, percentage);
    }

    public void calculate()
    {
        int n = years * 12 + months;
        double montlyPercent = percentage / 12 / 100;
        double K = (montlyPercent * Math.pow((1 + montlyPercent), n) )
                / ( Math.pow( (1 + montlyPercent), n ) - 1 );


        double monthlyPayment = sum * K;

        remainder[0] = sum;
        payment[0] = monthlyPayment;
        increase[0] = sum * montlyPercent;
        round(0);
        for(int i = 1; i <= n; i++)
        {
            remainder[i] = remainder[i - 1] - monthlyPayment + increase[i - 1];
            payment[i] = monthlyPayment;
            increase[i] = remainder[i] * montlyPercent;

            round(i);

        }

    }

}
