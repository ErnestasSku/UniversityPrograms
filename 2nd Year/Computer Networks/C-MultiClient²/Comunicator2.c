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

int setup_server(const char *ip, const char *port, int backlog);


int main(int argc, char const *argv[])
{   
    struct sockaddr_storage their_addr;
    socklen_t addr_size;

    int hash_server, eta_server;
     if (argc != 4)
    {
        fprintf(stderr, "usage: communicator ip port1 port 2\n");
        exit(1);
    }
    eta_server = setup_server(argv[1], argv[2], 10);
    hash_server = setup_server(argv[1], argv[3], 10);
    
    addr_size = sizeof their_addr;
    int eta_socket = accept(eta_server, (struct sockaddr *)&their_addr, &addr_size);
    int hash_socket = accept(hash_server, (struct sockaddr *)&their_addr, &addr_size); 

    while(1)
    {   
        char *buffer[1024];
        
        memset(buffer, 0, sizeof(buffer));
        int e_len = recvtimeout(eta_socket, buffer, sizeof(buffer), 1);

        if (e_len > 0) {
            printf("Received: %s\n", buffer);
            send(hash_socket, buffer, sizeof(buffer), 0);
        }

        memset(buffer, 0, sizeof(buffer));
        int h_len = recvtimeout(hash_socket, buffer, sizeof(buffer), 1);

        if (h_len > 0) {
            printf("Received: %s\n", buffer);
            send(eta_socket, buffer, sizeof(buffer), 0);
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
        int err = listen(server_socket, 10);
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

void check(int exp, const char *msg)
{
    if (exp < 0) {
        fprintf(stderr, "Error: %s. Error code %d\n", msg, exp);
        exit(1);    
    }
    return;
}
