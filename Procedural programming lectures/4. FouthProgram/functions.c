#include <stdio.h>
#include "functions.h"

int GetInt()
{
    short int correct = 0;
    int data;

    do{
        correct = 1;

        if(!scanf("%d", &data))
        {
            scanf("%*[^\n]");
            correct = 0;
            printf("Wrong input ");
        }
    }while(!correct);

    return data;
}

Node ReadFile(FILE *fp, Node head)
{
    int data;
    while(fscanf(fp, "%d", &data) == 1)
    {
        head = AddNode(head, data);
    }

    return head;

}