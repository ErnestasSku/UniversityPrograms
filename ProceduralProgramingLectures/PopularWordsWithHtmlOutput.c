/*
 *  Ernestas Skudzinskas
 *
 *  This program counts the words in an input file, and outputs the result 
 *  as a html file. The 5 most common words are highlighted in a different colour
 *
 */
#include<stdio.h>
#include<ctype.h>
#include<string.h>

struct pair{
	char string[100];
	int count;
}P[100];

void checkWord(int *size, char *word);
void sort(int size);
void PrintResults(int size);

int main()
{
    printf("The input is recieved from \"input.txt\", and the results are created in \"inxex.html\". The input and output needs to be in the same folder as this C file\n");

    int uniqueCount = 0;
	
    FILE *fp;
    fp = fopen("input.txt", "r");

	//printf("Įveskite simbolių seką ");	
	
	int exitCondition = 0;
	while(exitCondition < 3)
	{
        char c, word[100];
        int i = 0;
        do {
            //c = getchar();
            c = fgetc(fp);
            word[i] = c;
            i++;
        }while (c != 10 && c != 32 && c != EOF);
        

        if (word[0] == '\n')
            exitCondition++;
        else
        {
            word[i-1] = '\0';
            checkWord(&uniqueCount, word);
            exitCondition = 0;
        }
        
	}
    fclose(fp);

    sort(uniqueCount);
    /*for (int i = 0; i < uniqueCount; i++) {
        printf("Word - %s, Count = %d\n", P[i].string, P[i].count);
    }*/
    
    PrintResults(uniqueCount);
    
	return 0;
}

void checkWord(int *size, char *word)
{ 
    
    int temp = 0;
    while ( word[temp] )
    {
        word[temp] = tolower(word[temp]);
        temp++;
    }

    for (int i = 0; i < *size; i++)
    {
        if ( strcmp(word, P[i].string) == 0)
        {
            P[i].count++;
            return;
        }
    }
    
    strcpy(P[*size].string, word);
    P[*size].count = 1;
    *size = *size + 1;

}

void sort(int size)
{
    struct pair Temp;
    
    for (int i = 0; i < size - 1; i++)
    {
        for (int j = i + 1; j < size; j++)
        {
            if (P[i].count < P[j].count){
                Temp = P[i];
                P[i] = P[j];
                P[j] = Temp;
            }
        }
        
    }
    
}

void PrintResults(int size)
{
    FILE *fp;
    fp = fopen("index.html", "w");
    
    fprintf(fp, "<!DOCTYPE hyml>\n<html lang=\"en\">");
    fprintf(fp, "\t<head>\n\t\t<meta charset=\"utf-8\">\n\t\t<title>Results</title>\n<style> body{background-image: linear-gradient(to right,PaleGreen, Aquamarine);}</style>\n\t</head>");
    fprintf(fp, "\t<body>\n\t\t<div>\n\t\t\t<h1>Results</h1><ul style=\"width:300px; float:left;\">");
    
    int mostPopular = 5;
    int i = 0;
    while (mostPopular && i < size) {
        fprintf(fp, "<li style=\"color:OrangeRed;\">Word = %s, Count = %d</li>\n", P[i].string, P[i].count);
        
        i++;
        if (P[i - 1].count != P[i].count)
            --mostPopular;

    }

    for (; i < size; i++)
    {
        fprintf(fp, "<li>Word = %s, Count = %d</li>\n", P[i].string, P[i].count);
    }
    fprintf(fp, "</ul><img src=\"https://cdn.mos.cms.futurecdn.net/M7fDTpDnJcZ4dt3myngzxi.jpg\" style=\"width:720px; height:471px;float:right;\"");
    fprintf(fp, "</div></body></html>");
	fclose(fp);
}

