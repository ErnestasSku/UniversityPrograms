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

int main(int argc, char const *argv[])
{
    if (argc != 4) {
        fprintf(stderr, "usage: final IP PORT outputfile\n");
    }
    const char *ip = argv[1], *port = argv[2];
    const char *file = argv[3];
    
    int server_socket = setup_server(ip, port, SERVER_BACKLOG);

    struct sockaddr_storage their_addr;
    socklen_t addr_size = sizeof their_addr;

    int sender = accept(server_socket, (struct sockaddr *)&their_addr , &addr_size);

    const char *ack_message = "ACK";
    FILE *fp = fopen(file, "w");
    while(1) {
        unsigned char buffer[BUFFSIZE];
        memset(&buffer, 0, sizeof(buffer));
        int s_len = recv(sender, buffer, sizeof(buffer), 0);

        if (s_len == 0)
            break;
        
        // printf("%s\n", buffer);
        // fprintf(fp, "%s", buffer);
        // printf("%s\n\n", buffer);
        fwrite(buffer, sizeof(unsigned char), 1023, fp);
        send(sender, ack_message, strlen(ack_message), 0);
    }

    fclose(fp);
    return 0;
}

