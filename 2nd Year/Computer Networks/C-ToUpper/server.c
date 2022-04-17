#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netdb.h>
#include <netinet/in.h>

char* host = "127.0.0.1";
char* port = "20000";

void CheckError(int result, char* message);
char *ManageMessage(char * message);

int main(int argc, char const *argv[])
{
    
    int s, err;
    struct addrinfo hints, *res;
    struct sockaddr_storage their_addr;
    socklen_t addr_size;
    
    memset(&hints, 0, sizeof (hints));
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;
    // hints.ai_flags = AI_PASSIVE;

    //get addr info
    err = getaddrinfo(host, port, &hints, &res);
    CheckError(err, "Failed in getaddrinfo");

    //create a socket
    s = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
    CheckError(s, "Failed to create a socket");

    //bind socket
    err = bind(s, res->ai_addr, res->ai_addrlen);
    CheckError(err, "Failed to bind");

    //listen
    err = listen(s, 1);
    CheckError(err, "Failed to listen");

    addr_size = sizeof their_addr;
    int new_socket = accept(s, (struct sockaddr *)&their_addr, &addr_size);

    while (1)
    {
        char buffer[1024];
        memset(&buffer, 0, sizeof(buffer));
        int s_len = recv(new_socket, buffer, sizeof(buffer), 0);
        // CheckError(s_len, "");
        if (s_len == 0)
            break;
        printf("Got data from client: \n%s\n", buffer);
        
        //to upper
        for(int i = 0; i < strlen(buffer); i++)
        {
            buffer[i] = toupper(buffer[i]);
        }

        err = send(new_socket, buffer, strlen(buffer), 0);
        printf("%d\n", err);
    }
    

    close(s);
    return 0;
}

void CheckError(int result, char* message)
{
    if (result < 0) {
        fprintf(stderr, "Error: %s. Error code %d\n", message, result);
        exit(1);    
    }
    return;
}

char *ManageMessage(char message[])
{
    for (int i = 0; i < strlen(message); i++)
    {
        message[i]= toupper(message[i]);
    }
    return message;
}