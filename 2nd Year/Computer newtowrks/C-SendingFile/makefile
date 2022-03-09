CC = gcc
OUTPUTFORMAT = out

CLIENT = Client.c
MIDDLE = Middle.c
FINAL = Final.c

IP ?= 127.0.0.1
PORT1 ?= 20000
PORT2 ?= 20010

# INPUTFILE ?= A.txt
# OUTPUTFILE ?= B.txt
INPUTFILE ?= A.png
OUTPUTFILE ?= B.png

HEADERS = Utils.h
HFILES = Utils.c



# Initial client
client: $(CLIENT) $(HEADERS)
	$(CC) $(CLIENT) $(HFILES) -o client.$(OUTPUTFORMAT)

runClient: client
	./client.$(OUTPUTFORMAT) $(IP) $(PORT1) $(INPUTFILE)

cl: runClient

# First middle servre
middle: $(MIDDLE) $(HEADERS)
	$(CC) $(MIDDLE) $(HFILES) -o middle.$(OUTPUTFORMAT)

runMiddle: middle
	./middle.$(OUTPUTFORMAT) $(IP) $(PORT1) $(PORT2)

mid: runMiddle

# Receiving server
final: $(FINAL) $(HEADERS)
	$(CC) $(FINAL) $(HFILES) -o final.$(OUTPUTFORMAT)

runFinal: final
	./final.$(OUTPUTFORMAT) $(IP) $(PORT2) $(OUTPUTFILE)

fin: runFinal