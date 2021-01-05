#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <limits.h>
#include <assert.h>
#include "list.h"
#include "functions.h"


Node AddRandomElements(Node head, int low, int high, int count);

int main(int argc, char *argv[])
{
    srand((unsigned) time(0));
    Node head = NULL;
    
    head = AddNode(head, 5);
    head = AddNode(head, 2);
    head = AddNode(head, 8);

    assert(head->data == 2);
    assert(head->next->data == 5);
    assert(head->next->next->data == 8);

    head = AddNode(head, 1);
    assert(head->data == 1);
    assert(head->next->data == 2);
    
    head = FreeList(head);
    assert(head == NULL);

    //Sukuria sarašą iš random elementų, ir patikrina ar jis eina didėjimo tvarka

    FILE *fp = fopen("data.txt", "r");
    assert(fp != NULL);
    fp = fopen("b.txt", "r");
    assert(fp == NULL);

    head = AddRandomElements(head, 0, 30, 10);
    Node temp = head;
    for(int i = 0; i < 9; i++)
    {

        assert(temp->data <= temp->next->data);
        temp = temp->next;
    }


    return 0;
}

Node AddRandomElements(Node head, int low, int high, int count)
{
    for (int i = 0; i < count; ++i)
    {
        int number = (rand() % (high - low + 1) + low); 
        head = AddNode(head, number);
    }

    return head;
}
