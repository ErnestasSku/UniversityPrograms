CLIENT = client.c
SERVER = server.c




client: $(CLIENT)
	gcc $(CLIENT) -o client.out

runClient: client
	./client.out

server: $(SERVER)
	gcc $(SERVER) -o server.out

runServer: server
	./server.out


argument ?= Default

action: 
	echo "argument is $(argument)"