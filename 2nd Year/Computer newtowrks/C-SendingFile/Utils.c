#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <errno.h>
#include <signal.h>

#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <netdb.h>
#include <netinet/in.h>

#include "Utils.h"

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
        int err = listen(server_socket, backlog);
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

void check(int exp, const char *msg)
{
    if (exp < 0) {
        fprintf(stderr, "Error: %s. Error code %d\n", msg, exp);
        exit(1);    
    }
    return;
}



void tcp_send(int socket, unsigned char *buffer, unsigned char *response, int size)
{
    int snd;
    int rcv;
    do 
    {
        snd = send(socket, buffer, size * sizeof(unsigned char), 0);
        
        rcv = recvtimeout(socket, response, 1024 * sizeof(unsigned char), 1);
    } while (snd < 0 && rcv < 0);
}
