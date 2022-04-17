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


int setup_server(const char *ip, const char *port, int backlog);
int accept_new_connection(int server_socket);
void handle_connection(int client_socket, fd_set *eta, fd_set *hash, int option);
void check(int exp, const char *msg);



fd_set eta_sockets, hash_sockets;
fd_set hash_sock_read, hash_sock_write;
fd_set eta_sock_read, eta_sock_write;
int eta_server, hash_server;

int main(int argc, char const *argv[])
{
    if (argc != 4)
    {
        fprintf(stderr, "usage: communicator ip port1 port2\n");
        exit(1);
    }
    // fprintf(stdout, "1\n");    
    eta_server = setup_server(argv[1], argv[2], SERVER_BACKLOG);
    hash_server = setup_server(argv[1], argv[3], SERVER_BACKLOG);

    // fprintf(stdout, "2\n");    

    FD_ZERO(&eta_sockets);
    FD_ZERO(&hash_sockets);
    FD_SET(eta_server, &eta_sockets);
    FD_SET(hash_server, &hash_sockets);

    // printf("2.5\n");
    // printf("About to enter while loop\n");

    struct timeval tv;
    tv.tv_sec = 1;
    tv.tv_usec = 0;

    while(1)
    {
        // fprintf(stdout,"3");
        // printf("3");
        if (select(FD_SETSIZE, &hash_sock_read, &hash_sock_write, NULL, &tv) < 0) {
            perror("slsect error");
            exit(1);
        }
        if (select(FD_SETSIZE, &eta_sock_read, &eta_sock_write, NULL, &tv) < 0) {
            perror("slsect error");
            exit(1);
        }

        for (int i = 0; i < FD_SETSIZE; i++)
        {
            if (FD_ISSET(i, &eta_sock_read)) {
                if (i == eta_server) {
                    //TODO: accept connection
                    int client_socket = accept_new_connection(eta_server);
                    FD_SET(client_socket, &eta_sockets);
                    fprintf(stdout, "Added eta server\n");
                } else {
                    // TODO: handle connection
                    handle_connection(i, &eta_sockets, &hash_sockets, 0);
                    FD_CLR(i, &eta_sock_read);
                    FD_CLR(i, &eta_sock_write);
                }
            }

            if (FD_ISSET(i, &hash_sock_read)) {
                if (i == hash_server) {
                    //TODO: accept connection
                    int client_socket = accept_new_connection(hash_server);
                    FD_SET(client_socket, &hash_sockets);
                    fprintf(stdout, "Added hash server\n");
                } else {
                    // TODO: handle connection
                    handle_connection(i, &eta_sockets, &hash_sockets, 1);
                    FD_CLR(i, &eta_sock_read);
                    FD_CLR(i, &eta_sock_write);
                }
            }
        }
        // sleep(5);
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

int accept_new_connection(int server_socket)
{
    int addr_size = sizeof(SA_IN);
    int client_socket;
    SA_IN client_addr;
    client_socket = accept(server_socket, 
                            (SA*)&client_addr,
                            (socklen_t*)&addr_size);
    check(client_socket, "Failed in accepting new connection");
    fprintf(stdout, "Accepted connection\n");
    return client_socket;
}

/**
 * @brief 
 * 
 * @param client_socket 
 * @param eta 
 * @param hash 
 * @param option - 0 Eta server, 1 - Hash server 
 */
void handle_connection(int client_socket, fd_set *eta, fd_set *hash, int option)
{
    char buffer[BUFSIZE];
    memset(&buffer, 0, sizeof(buffer));

    int s_len = recv(client_socket, buffer, sizeof(buffer), 0);
    fprintf(stdout, "Received: %s\n", buffer);
    if (s_len == 0)
    {
        close(client_socket);

        if(!option)
            FD_CLR(client_socket, eta);
        else
            FD_CLR(client_socket, hash);
        return;
    }

     for (int i = 0; i < FD_SETSIZE; i++)
        {
            if(!option)
            {
                if (FD_ISSET(i, &eta_sock_write))
                {
                    if (i == eta_server)
                        continue;
                    else 
                    {
                        int err = send(i, buffer, s_len, 0);
                    }
                }
            } 
            else 
            {
                if (FD_ISSET(i, &hash_sock_write))
                {
                    if (i == hash_server)
                        continue;
                    else 
                    {
                        int err = send(i, buffer, s_len, 0);
                    }
                }
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
