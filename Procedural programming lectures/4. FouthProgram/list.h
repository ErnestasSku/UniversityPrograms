#ifndef LinkedList_h
#define LinkedList_h

struct List
{
    struct List *next;
    int data;
};

typedef struct List *Node;

Node CreateNode();
Node FindNode();
Node AddNode();
Node PrintList();
Node FreeList();

#endif