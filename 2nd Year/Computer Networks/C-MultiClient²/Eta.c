#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <errno.h>
#include <signal.h>

#include "util.h"

#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <netdb.h>
#include <netinet/in.h>

typedef struct sockaddr_in SA_IN;
typedef struct sockaddr SA;

#define BUFSIZE 1024
#define SERVER_BACKLOG 20
#define DEBUG

void * handle_connection(int, fd_set *);
void check(int exp, const char *msg);
char *CombineMessage(char *name, char *message);
int accept_new_connection(int server_socket);
int setup_server(const char *ip, const char *port, int backlog);

Node head = NULL;
fd_set current_sockets;
fd_set sock_read, sock_write;
int server_socket;
int communicator_socket = -1;


int main(int argc, char const *argv[])
{
    if (argc != 4) {
        fprintf(stderr, "usage: server ip port1 port2\n");
        exit(1);
    }

    server_socket = setup_server(argv[1], argv[2], SERVER_BACKLOG);
    // int server_socket = setup_server(argv[1], argv[2], SERVER_BACKLOG);

    // fd_set current_sockets;
    // fd_set sock_read, sock_write;
    FD_ZERO(&current_sockets);
    FD_SET(server_socket, &current_sockets);

    while (1) {

        if (communicator_socket < 0)
        {
            //TODO: attempt to connect to the server
            communicator_socket = connect_to_communicator(argv[1], argv[3]);
            if (communicator_socket > 0)
            {
                FD_SET(communicator_socket, &current_sockets);
                printf("communcator conn: %d\n\n", communicator_socket);
            }
        }
        sock_read = current_sockets;
        sock_write = current_sockets;


        // select (size, read, write, error, timout)
        if (select(FD_SETSIZE, &sock_read, &sock_write, NULL, NULL) < 0) {
            perror("slsect error");
            exit(1);
        }

        // printf("%p %p", &sock_read, &sock_write);

        for (int i = 0; i < FD_SETSIZE; i++)
        {
            if (FD_ISSET(i, &sock_read)) {
                if (i == server_socket) {
                    int client_socket = accept_new_connection(server_socket);
                    FD_SET(client_socket, &current_sockets);
                }
                else if (i == communicator_socket)
                {
                    // printf("Communicator: sent a message\n");
                    char combuff[BUFSIZE];
                    memset(&combuff, 0, sizeof(combuff));
                    int s_len = recv(i, combuff, sizeof(combuff), 0);
                    
                    if (s_len == 0)
                    {
                        close(i);
                        FD_CLR(i, &current_sockets);
                        communicator_socket = -1;
                    }
                    else {
                        // printf("Got message from communicator: %s\n", combuff);
                        char *receiver_name = getName(combuff);
                        int receiver_id = FindByName(head, receiver_name);

                        send(receiver_id, combuff, sizeof(combuff), 0);

                    }

                    FD_CLR(i, &sock_read);
                    FD_CLR(i, &sock_write);
                } 
                else 
                {

                    handle_connection(i, &current_sockets);
                    FD_CLR(i, &sock_read);
                    FD_CLR(i, &sock_write);
                }
            }
        }
    }

    return 0;
}

int setup_server(const char *ip, const char *port, int backlog)
{
    int server_socket, err;
    int yes = 1;
    struct addrinfo hints, *res, *p;
    socklen_t addr_size;
    
    memset(&hints, 0, sizeof hints);
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;

    err = getaddrinfo(ip, port, &hints, &res);
    check(err, "Failed in getaddrinfo");

    for(p = res; p != NULL; p = p->ai_next) {
        if ((server_socket = socket(p->ai_family, p->ai_socktype, p->ai_protocol)) == -1)
        {
            perror("server: socket");
            continue;
        }

        if (setsockopt(server_socket, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(int)) == -1) {
            perror("setsockopt");
            exit(1);
        }

        if (bind(server_socket, p->ai_addr, p->ai_addrlen) == -1) {
            close(server_socket);
            perror("server: bind");
            continue;
        }
        int err = listen(server_socket, SERVER_BACKLOG);
        check(err, "Failed in listen");

        break;
    }

    freeaddrinfo(res);

    if (p == NULL) {
        fprintf(stderr, "failure in setup_server");
        exit(1);
    }
    return server_socket;
}

int accept_new_connection(int server_socket) {
    // printf("DEBUG: called accept new\n");
    int addr_size = sizeof(SA_IN);
    int client_socket;
    SA_IN client_addr;
    client_socket = accept(server_socket, 
                            (SA*)&client_addr,
                            (socklen_t*)&addr_size);
    // printf("\nSock: %d\n\n", client_socket);
    check(client_socket, "Failed in accepting new connection");

    char *msg = "Write your name ";
    char buffer[120];
    while (1)
    {
        memset(&buffer, 0, sizeof(buffer));
        send(client_socket, msg, strlen(msg), 0);
        recv(client_socket, buffer, sizeof(buffer), 0);
        // Todo: validate uniqueness
        buffer[(strlen(buffer) - 2)] = '\0';
        if (CheckName(head, buffer) == 0)
            {
                send(client_socket, "vardas ok\n", strlen("vardas ok\n"), 0);
                break;
            }
        else 
            send(client_socket, "uzimtas\n", strlen("uzimtas\n"), 0);
    }
    printf("Got name: %s\n", buffer);
    // buffer[(strlen(buffer) - 2)] = '\0';
    head = AddNode(head, client_socket, buffer);
    return client_socket;
}


void * handle_connection(int client_socket, fd_set *master)
{
    char buffer[BUFSIZE];
    memset(&buffer, 0, sizeof(buffer));

    int s_len = recv(client_socket, buffer, sizeof(buffer), 0);
    if (s_len == 0)
    {
        head = FreeList(head, client_socket);
        close(client_socket);
        FD_CLR(client_socket, master);
        return;
    }
    if (strcmp("\r\n", buffer) == 0)
        return;

    char *sender = FindNode(head, client_socket)->name;

    if (beginsWith(buffer, '#'))
        {
            char newmsg[1200] = "";
            memset(&newmsg, 0, sizeof(newmsg));
            strcat(newmsg, sender);
            // strcat(newmsg, "@");
            strcat(newmsg, buffer);
            sendToCommunicator(newmsg, client_socket);
            return;
        }
    // printf("Sender: %s\n", sender);
    
    char newmsg[1200] = "";
    memset(&newmsg, 0, sizeof(newmsg));
    strcat(newmsg, sender);
    strcat(newmsg, ": ");
    strcat(newmsg, buffer);
    int messageSize = strlen(sender) + strlen(": ") + strlen(buffer);
    printf("New msg: %s\n", newmsg);

    for (int i = 0; i < FD_SETSIZE; i++)
        {
            if (FD_ISSET(i, &sock_write)) {
                if (i == server_socket) {
                    continue;
                }
                else if(i == communicator_socket)
                {
                    continue;
                } 
                else 
                {
                    int err = send(i, newmsg, messageSize, 0);
                }
            }
        }

}

int connect_to_communicator(const char *ip, const char *port)
{
    struct addrinfo hints, *res, *p;
    memset(&hints, 0, sizeof hints);
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;

    int code = getaddrinfo(ip, port, &hints, &res);

    for (p = res; p != NULL; p = p->ai_next)
    {
        int sock = socket(p->ai_family, p->ai_socktype, p->ai_protocol);
        if (sock == -1)
            continue;
        
        int code = connect(sock, res->ai_addr, res->ai_addrlen);

        if (code < 0)
        {
            close(sock);
            continue;
        }
        else 
            return sock;
    }
    return -1;
}


void sendToCommunicator(char msg[], int sender)
{
    if (communicator_socket != -1)
    {
        int err = send(communicator_socket, msg, 1024 * sizeof(char), 0);
        // printf("Attempting to send to comm: %s = %d\n", msg, err);

        if (err < 0)
        {
            printf("Failed to send to other server\n");
            send(sender, "failed to send to other server\n", strlen("failed to send to other server\n"), 0);
        }
    }
}


void check(int exp, const char *msg)
{
    if (exp < 0) {
        fprintf(stderr, "Error: %s. Error code %d\n", msg, exp);
        exit(1);    
    }
    return;
}

char *CombineMessage(char *name, char *message)
{   
    printf("\n\nSender: %s\nMessage: %s\n", name, message);
    char *new = "";
    int len = 0;

    for (int i = 0; i < strlen(name) - 1; i++)
    {   
        printf("%c", name[i]);
        new[len++] = name[i];
    }
    new[len++] = ':';
    new[len++] = ' ';

    for (int i = 0; i < strlen(message) - 1; i++)
    {
        printf("%c", message[i]);
        new[len++] = message[i];
    }
    new[len++] = '\0';
    printf("End: %s\n", new);
    return new;
}