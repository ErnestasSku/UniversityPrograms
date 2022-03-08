#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netdb.h>
#include <netinet/in.h>

char* host = "127.0.0.1";
char* port = "20000";

void CheckError(int result, char* message);

int main(int argc, char const *argv[])
{
    int s, err;
    struct addrinfo hints, *res;

    memset(&hints, 0, sizeof (hints));
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;
    
    err = getaddrinfo(host, port, &hints, &res);
    CheckError(err, "Failed in getaddrinfo");

    s = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
    CheckError(s, "Failed in socket");

    err = connect(s, res->ai_addr, res->ai_addrlen);
    CheckError(err, "Failed in connect");


    size_t buffsize = 1024;
    char *buffer = (char*)malloc(buffsize * sizeof(char));
    printf("Enter a message -->\n");
    getline(&buffer, &buffsize, stdin);
    printf("\ninput text: %s", buffer);
    send(s, buffer, strlen(buffer), 0);

    err = read(s, buffer, 1024);
    printf("Recieved:\n%s\n", buffer);
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