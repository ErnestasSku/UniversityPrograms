/*
    Ernestas Škudzinskas

    This program asks for n ammount of numbers and prints the results
    in 3 intervals 

 */

#include<stdio.h>
#include<stdbool.h>
#include<limits.h>

int Input();
int Min(int firstNumber, int secondNumber);
int Max(int firstNumber, int secondNumber);
void Sort(int numberList[], int size);
void PrintInterval(int *i, int size, int numberList[], int limit);

int main()
{
    printf("Enter the size of the array ");
    
    int n;
    n = Input();
    int numberList[n];
    int minNumber = INT_MAX, maxNumber = INT_MIN;
    for(int i = 0; i < n; i++)
    {
        numberList[i] = Input();
        minNumber = Min(minNumber, numberList[i]);
        maxNumber = Max(maxNumber, numberList[i]);
    }
    
    Sort(numberList, n);
    
    
    int i = 0;
    PrintInterval(&i, n, numberList, (minNumber + (maxNumber - minNumber)/3) );
    PrintInterval(&i, n, numberList, (minNumber + (maxNumber - minNumber)*2/3) - 1);
    PrintInterval(&i, n, numberList, maxNumber);

    return 0;
}


void PrintInterval(int *i, int size, int numberList[], int limit)
{
    printf("\n");
    for(; *i < size; *i = *i + 1)
    {
        if(numberList[*i] > limit)
            break;
        printf("%d ", numberList[*i]);
    }
}


int Input()
{
    int number;
    bool correct;

    do {
       correct = 1;
        
       if(!scanf("%d", &number))
        {
            scanf("%*[^\n]");
            correct = 0;
            printf("Wrong input\n");
        }

    } while (!correct);

    return number;
}

void Sort(int numberList[], int size)
{
   for (int i = 0; i < size - 1; i++) {
        for (int j = i + 1; j < size; j++){
            if(numberList[i] > numberList[j])
            {
                int c = numberList[i];
                numberList[i] = numberList[j];
                numberList[j] = c;
            }
        }
   } 
}


int Min(int firstNumber, int secondNumber)
{
    if (firstNumber < secondNumber)
        return firstNumber;
    else
        return secondNumber;
}
int Max(int firstNumber, int secondNumber)
{

    if (firstNumber > secondNumber)
        return firstNumber;
    else
        return secondNumber;
}
