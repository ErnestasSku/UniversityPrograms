#ifndef utils_h
#define utils_h

struct NamesList
{
    char name[120];
    int sockId;

    struct NamesList *next;
};

typedef struct NamesList *Node;

Node CreateNode();
Node FindNode();
Node AddNode();
Node PrintList();
Node FreeList();
int CheckName();

#endif