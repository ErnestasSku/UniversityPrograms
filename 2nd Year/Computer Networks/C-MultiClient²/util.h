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
int FindByName(Node head, char name[]);
Node AddNode();
Node PrintList();
Node FreeList();
int CheckName();
int beginsWith(char msg[], char p);
char *getName(char msg[]);

int recvtimeout();

#endif