/*
    Ernestas Škudzinskas 2016049
    4.2 užduotis

    Trukmė: tikslaus laiko nežinau, bet tikrai neviršijau savo numatytos prognzės
    Linked listą implementavau pakankamai greitai, nes jau turiu patirties su juo, tai jis užtruko apie
    ~25 minutes, neipaisant tvarkos, nes tai pasilikau pabaigai kai daug maž viskas buvo išspręsta

    bugai: turėjau keletą bugų su pointeriais, bet juos išsprendžiau per 10-20 minučių.
    Vienas iš sudėtingesnių bugų buvo implementuoti kad sąrašas susitvarkytų, bet nusipiešus veikimo principą ant popieriaus
    jį greitai pašalinau. Užtrukau apie 20-25 minutes.


*/
#include <stdio.h>
#include "list.h"
#include "functions.h"

int main(int argc, char *argv[])
{
    Node head = NULL;

    printf("Press 1 to create a list from a file\nPress 2 add data\nPress 3 to print the list\nPress 4 to exit the program\n");
    while(1)
    {  
        printf("\nEnter which you want to take ");
        int action = GetInt();
        if(action == 1)
        {
            FILE *fp = NULL;
            char fileName[100];
            printf("Enter the name of the file ");
            scanf("%s", fileName);
            fp = fopen(fileName, "r");

            if(fp == NULL)
            {
                printf("There was an error opening a file ");
            }else{
                head = ReadFile(fp, head);
                fclose(fp);
            }
            
            

        }else if(action == 2)
        {

            int data;
            printf("Enter data: ");
            data = GetInt();
            head = AddNode(head, data);

        }else if(action == 3)
        {

            if(head != NULL)
                PrintList(head);
            else
                printf("There is no list yet");

        }else if(action == 4)
        {
            head = FreeList(head);
            return 0;
        }
        else
            printf("There is no such command");
        

    }

    return 0;
}
