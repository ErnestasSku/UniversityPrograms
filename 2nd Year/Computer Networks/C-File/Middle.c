#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <errno.h>
#include <signal.h>

#include "Utils.h"

#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <netdb.h>
#include <netinet/in.h>

typedef struct sockaddr_in SA_IN;

#define BUFFSIZE 1024
#define SERVER_BACKLOG 10

#define DEBUG

void send_file(int sender, int output);
int connect_to_server(const char *host, const char *port);

int main(int argc, char const *argv[])
{
    if (argc != 4) {
        fprintf(stderr, "usage: middle IP PORT1 PORT2\n");
    }

    const char *ip = argv[1], *port1 = argv[2], *port2 = argv[3];
    int input = -1, output = -1;

    while (1) {
        
        if(input == -1)
            input = setup_server(ip, port1, SERVER_BACKLOG);
        if(output == -1)
            output = connect_to_server(ip, port2);

        printf("Client status: %s. Server Status: %s\n", 
                            (input != -1) ? "OK" : "off",
                            (output != -1) ? "OK" : "off");
        
        if(input != -1 &&  output != -1)
            break;

        sleep(5);
    }

    struct sockaddr_storage their_addr;
    socklen_t addr_size = sizeof their_addr;

    int sender = accept(input, (struct sockaddr *)&their_addr , &addr_size);

    //Send "Ack" message to client to start the file sending process
    int err;
    do {
        err = send(sender, "send", strlen("send"), 0);

    } while (err < 0);

    
    send_file(sender, output);


    return 0;
}

int connect_to_server(const char *host, const char *port)
{
    struct addrinfo hints, *res, *p;
    memset(&hints, 0, sizeof(hints));
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;

    int code = getaddrinfo(host, port, &hints, &res);

    for(p = res; p != NULL; p = p->ai_next)
    {
        int sock= socket(p->ai_family, p->ai_socktype, p->ai_protocol);
        if (sock == -1)
            continue;

        code = connect(sock, res->ai_addr, res->ai_addrlen);
        if (code < 0) {
            close(sock);
            continue;
        } else 
            return sock;
    }
    return -1;
}

void send_file(int sender, int output)
{
    // receive data from client
    // send data to server with timeout
    // get ACK | timeout
    // if ack send ack to server and repeat
    unsigned char buffer[1024];
    unsigned char response[1024];
    while(1)
    {
        memset(&buffer, 0, 1024 * sizeof(unsigned char));
        memset(&response, 0, 1024 * sizeof(unsigned char));

        int s_len = recv(sender, buffer, 1024 * sizeof(unsigned char), 0);
        if (s_len == 0)
            return;
        
        // printf("received: %d\n %s\n", s_len, buffer);
        // int code = send(output, buffer, sizeof(buffer), 0);
        tcp_send(output, buffer, response, s_len);
        send(sender, "ack", strlen("ack"), 0);
    }
}
