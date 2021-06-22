#include <stdio.h>
#include <stdlib.h>
#include "list.h"

Node CreateNode()
{
    Node temp;
    temp = (Node)malloc(sizeof(struct List));
    temp->next = NULL;
    return temp;

}

Node FindNode(Node p, Node prev, int value)
{   
    if(p->data > value)
        return prev;
    else if(p->next == NULL)
        return p;
    else
    {
        //p = p->next;
        FindNode(p->next, p, value);
    }
}

Node AddNode(Node head, int value)
{
    Node temp, p;
    temp = CreateNode();
    temp->data = value;

    if(head == NULL)
    {
        head = temp;
    }else if(head->data > value)
    {
        
        temp->next = head;
        head = temp;

    }else
    {
        p = head;
        p = FindNode(head, p, value);
        
        if(p->next == NULL)
            p->next = temp;
        else
        {
            temp->next = p->next;
            p->next = temp;
            
        }
    }
    return head;
}

Node PrintList(Node p)
{   
    printf("%d ", p->data);
    if(p->next != NULL)
    {
        p = p->next;
        PrintList(p);
    }
}

Node FreeList(Node p)
{
    if(p->next != NULL)
    {
        FreeList(p->next);
    }
    free(p);
    return NULL;
}
