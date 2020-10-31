/*
    Ernestas Škudzinskas
    
    This program will run if the input is between -1000 and 1000
    as soon as you enter the bigger or smaller number than mentioned
    the program will finish it's job and will tell yoi if there are 3 zeroes in a row


*/


#include <stdio.h>
#include <stdbool.h>

int Input();

int main() {

    int Number, Zeros = 0;
    bool Found = 0;
    printf("Enter numbers\n");
    do {
        Number = Input();
        if (Number == 0 && !Found) {
            Zeros++;
            if (Zeros == 3) {
                Found = 1;
            }
        }else{
            Zeros = 0;
        }

    } while(Number >= -1000 && Number <= 1000);

    if (Found) {
        printf("There are 3 zeros in a row\n");
    }else{
        printf("There aren't 3 zeros in a row\n");
    }

    return 0;
}

int Input()
{
    int Number, c;
    bool Correct, Negative = 0;
    do {
        Correct = 1;
        Number = 0;
        c = getchar();
        if (c == '-') {
            c = getchar();
            Negative = 1;
        }

        if (!(c > 47 && c < 58) )
            Correct = 0;

        for (; c != 10; c = getchar()) {

            if (!(c > 47 && c < 58) )
                Correct = 0;
            else
                Number = Number*10 + c - 48;

        }


    if (!Correct)
        printf("Wrong input\n");

    } while(!Correct);

    if (Negative)
        Number *= -1;

    return Number;
}
