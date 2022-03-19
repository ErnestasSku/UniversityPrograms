#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "util.h"

#include <ctype.h>

#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <netdb.h>
#include <netinet/in.h>

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
    if(head == NULL)
        return 0;

    Node p;
    for (p = head; p != NULL; p=p->next)
    {
        if(strcmp(p->name, name) == 0)
            return 1;
    }
    return 0;
}

int FindByName(Node head, char name[])
{
    if(head == NULL)
        return -1;
    
    Node p;
    for (p = head; p != NULL; p=p->next)
    {
        if(strcmp(p->name, name) == 0)
            return p->sockId;
    }
    return -1;
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
                t = p->next;
                free(p);
                return head;
            }
            t = p;
        }
    }
    return head;
}

int beginsWith(char msg[], char p)
{
    if (msg[0] == p)
        return 1;
    else 
        return 0;
}

char* getName(char msg[])
{
    int add = 0;
    char *name = calloc(120, sizeof(char));
    int len = 0;
    memset(name, 0, sizeof(name));
    
    for(int i = 0; i < strlen(msg); i++)
    {
        if (msg[i] == '#' || msg[i] == '@')
            {
                add = 1;
                continue;
            }
        else if (msg[i] == ' ' || msg[i] == '\0')
            {
                add = 0;
                return name;
            }
        else if(add)
            {
                *(name + len) = msg[i];
                len++;
            }

    }
    return name;
}

int recvtimeout(int s, char *buf, int len, int timeout)
{
    fd_set fds;
    int n;
    struct timeval tv;

    FD_ZERO(&fds);
    FD_SET(s, &fds);

    tv.tv_sec = timeout;
    tv.tv_usec = 0;

    n = select(s+1, &fds, NULL, NULL, &tv);
    if (n == 0) return -2; // TIMEOUT
    if (n == -1) return -1; // error
    FD_CLR(s, &fds);
    return recv(s, buf, len, 0);
}