#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "Utils.h"

#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netdb.h>
#include <netinet/in.h>

int createSocket(struct addrinfo *res);
void send_file(int socket, const char *filename);

#define BUFFSIZE 1024

// #define DEBUG

int main(int argc, char const *argv[])
{
    if (argc != 4)
    {
        fprintf(stderr, "usage: client ip port file");
        exit(1);
    }

    const char *host = argv[1], *port = argv[2];
    const char *file = argv[3];

    int socket, code;
    struct addrinfo hints, *res;

    while (1)
    {
        memset(&hints, 0, sizeof(hints));
        hints.ai_family = AF_UNSPEC;
        hints.ai_socktype = SOCK_STREAM;

        // Try to connect to a first server.
        printf("Connecting...\n");

        code = getaddrinfo(host, port, &hints, &res);
        socket = createSocket(res);

        if (socket == -1)
        {
            printf("Did not succeed in connection\n");
        }
        else
        {
            printf("Connected\n");
            break;
        }

        sleep(5);
    }

    char buff[BUFFSIZE];
    memset(&buff, 0, BUFFSIZE * sizeof(char));
    code = recv(socket, buff, sizeof buff, 0);

    if (code > 0)
    {
        send_file(socket, file);
    }

    send(socket, 0, 0, 0);
   
    printf("close socket\n");
    close(socket);

    return 0;
}

int createSocket(struct addrinfo *res)
{
    struct addrinfo *p;
    for (p = res; p != NULL; p = p->ai_next)
    {
        int code;
        int sock = socket(p->ai_family, p->ai_socktype, p->ai_protocol);
        if (sock == -1)
            continue;

        code = connect(sock, res->ai_addr, res->ai_addrlen);
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

void send_file(int socket, const char *filename)
{
    int count;
    FILE *fp;

    fp = fopen(filename, "r");
    if (fp == NULL)
    {
        perror("Error while opening a file\n");
        exit(0);
    }

    int code;
    unsigned char buffer[BUFFSIZE];
    unsigned char response[BUFFSIZE];
    
    while (1)
    {
        count = 0;
        memset(&buffer, 0, BUFFSIZE * sizeof(unsigned char));
        memset(&response, 0, BUFFSIZE * sizeof(unsigned char));

        int c = 0;
        unsigned char ch = 0;

        //Old method.
        // for (int i = 0; i < 1023; i++)
        // {
        //     c = fgetc(fp);
        //     printf("%d ", c);
        //     if (c == EOF)
        //         break;
        //     ch = c;
        //     buffer[count++] = ch;
        // }
        c = fread(buffer, sizeof(char), 1023, fp);

        if (c == 0)
            break;

        tcp_send(socket, buffer, response, c);
    }

    fclose(fp);
}

