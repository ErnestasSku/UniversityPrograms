/*
    Ernestas Škudzinskas
    This program checks whether the entered number array has 
    3 zeroes in a row or not.

*/


#include <stdio.h>
#include <stdbool.h>

int Input();

int main(int argc, char const *argv[]) {

    int Number, Zeros = 0;
    bool Found = 0;
    printf("Iveskite skaiciu seka\n");
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
        printf("Sekoje yra trys nuliai\n");
    }else{
        printf("Sekoje nera triju nuliu\n");
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
        printf("Neteisinga ivestis\n");

    } while(!Correct);

    if (Negative)
        Number *= -1;

    return Number;
}
