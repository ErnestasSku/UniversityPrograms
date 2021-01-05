/*
   Ernestas Škudzinskas 2016049
    3.4 užduotis

    Trukmė, patį uždavinį išsprendžiau per 40+ min, bet
    šiek tiek užtrukau kol vizualiai sutvarkiau keletą vietų, (ištryniau 
    savo debug printf'us)
    Taip pat buvo iškilusios keletą mažų bugų
    Visas uždavinys buvo baigtas per 1h ~15 min

*/
#include <stdio.h>
#include <stdlib.h>

char *ReadFile(int *size, char *inputname);
void ConnectWords(char *CharArray, int *CurrentPos, char c, char LastSymbol);
void PrintFile(char *CharArray, int size, char *outputName);

int main()
{
    int size = 0;
    char *Array;
    char inputName[100];
    char outputName[100];
    printf("Enter the file name ");
    scanf("%s", inputName);
    printf("Enter the output name ");
    scanf("%s", outputName);

    Array = ReadFile(&size, inputName);
    
    if (Array == NULL)
        return 0;

    PrintFile(Array, size, outputName);

    return 0;
}

char *ReadFile(int *ammount, char *inputName)
{
    FILE *fp;
    fp = fopen(inputName, "r");
    if (fp == NULL)
    {
        printf("Couldn't open the file");
        return NULL;
    }
    
    fseek(fp, 0, SEEK_END);
    int FileSize = ftell(fp) - 1;
    int CurrentPos = 0;
    fseek(fp, 0, SEEK_SET);
    char c = 0, LastSymbol, CurrentSymbol;
    char *CharArray = malloc(FileSize * sizeof(char));
    

    do{
        
        CurrentSymbol = c;
        c = fgetc(fp);
        if (c == ' ' && c != 0)
        {
            LastSymbol = CurrentSymbol;
            //LastWordPos = CurrentPos;
        }
            

        if(CharArray[CurrentPos - 1] == ' ' && CurrentPos != 0)
        {
            ConnectWords(CharArray, &CurrentPos, c, LastSymbol);
        }
        
        CharArray[CurrentPos] = c;

        CurrentPos++;

    }while (c != EOF);

    *(ammount) = CurrentPos;
    fclose(fp);
    return CharArray;
    free(CharArray);
}

void ConnectWords(char *CharArray, int *CurrentPos, char c, char LastSymbol)
{
    if (c == LastSymbol)
    {
        CharArray[*(CurrentPos) - 1] = c;
        *(CurrentPos) = *(CurrentPos) - 1;
    }
}

void PrintFile(char *charArray, int size, char *outputName)
{
    FILE *fp;

    fp = fopen(outputName, "w");

    if (fp == NULL)
    {
        printf("There was an error while creating output file");
        return;
    }

    for (int i = 0; i < size - 1; i++)
    {
        fputc(charArray[i], fp);
    }

    fclose(fp);

}



