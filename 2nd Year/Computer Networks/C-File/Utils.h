#ifndef Utils_h
#define Utils_h

int setup_server(const char*, const char*, int);
void check(int, const char*);
int recvtimeout(int, char*, int, int);
// int recvtimeout(int, unsigned char*, int, int);
void tcp_send(int, unsigned char*, unsigned char*, int);


#endif