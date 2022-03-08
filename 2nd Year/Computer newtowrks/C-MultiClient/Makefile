CLIENT = client.c
SERVER = server.c

HEADERS = util.h
FILES = util.c


OUTPUTFORMAT = out


IP ?= 127.0.0.1
PORT ?= 20000

client: $(CLIENT) $(HEADERS)
	gcc $(CLIENT) $(FILES) -o client.$(OUTPUTFORMAT)

runClient: client
	./client.$(OUTPUTFORMAT) $(IP) $(PORT)

server: $(SERVER) $(HEADERS)
	gcc $(SERVER) $(FILES) -o server.$(OUTPUTFORMAT)

runServer: server
	./server.$(OUTPUTFORMAT) $(IP) $(PORT)

rs: runServer

rc: runClient