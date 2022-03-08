#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "util.h"

Node CreateNode()
{
    Node temp;
    temp = (Node)malloc(sizeof(struct NamesList));
    temp->next = NULL;
    return temp;
}

Node FindNode(Node p, int id)
{
    if (p->sockId == id)
        return p;
    else if (p->next == NULL)
        return NULL;
    else
        FindNode(p->next, id);
}

Node AddNode(Node head, int id, char name[])
{
    Node temp, p;
    temp = CreateNode();
    temp->sockId = id;
    strcpy(temp->name, name);

    if(head == NULL)
        head = temp;
    else {
        for (p = head; p->next != NULL; p=p->next)
        {}
        p->next = temp;
    }
    return head;
}

int CheckName(Node head, char name[])
{
    // printf("Called check name\n");
    if(head == NULL)
        return 0;

    // printf("Head is not null\n");
    Node p;
    for (p = head; p != NULL; p=p->next)
    {
        #ifdef DEBUG
            printf("name: %s", p->name);
        #endif

        if(strcmp(p->name, name) == 0)
            return 1;
    }
    return 0;
}

Node FreeList(Node head, int sockId)
{
    if (head->sockId == sockId)
        {
            free(head);
            return NULL;
        }
    else {
        Node p, t;
        p = head->next;
        t = head;
        for ( ; p != NULL; p = p->next)
        {
            if (p->sockId == sockId)
            {
                t = p->name;
                free(p);
                return head;
            }
            t = p;
        }
    }
    return head;
}