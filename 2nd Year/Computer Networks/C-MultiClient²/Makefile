CC = gcc
OUTPUTFORMAT = out

ETASERVER = Eta.c
HASHSERVER = Hash.c
COMMUNICATOR = Comunicator2.c

HEADERS = util.h
HFILES = util.c

IP ?= 127.0.0.1

PORT1 = 20000
PORT2 = 20010
PORT3 = 20020
PORT4 = 20030


# Eta server
etaServer: $(ETASERVER) $(HEADERS)
	$(CC) $(ETASERVER) $(HFILES) -o etaServer.$(OUTPUTFORMAT)

runEtaServer: etaServer
	./etaServer.$(OUTPUTFORMAT) $(IP) $(PORT1) $(PORT3)

eta: runEtaServer

# Hash server
hashServer: $(HASHSERVER) $(HEADERS)
	$(CC) $(HASHSERVER) $(HFILES) -o hashServer.$(OUTPUTFORMAT)

runHashServer: hashServer
	./hashServer.$(OUTPUTFORMAT) $(IP) $(PORT2) $(PORT4)

hash: runHashServer


comunicator: $(COMMUNICATOR) $(HEADERS)
	$(CC) $(COMMUNICATOR) $(HFILES) -o communicator.$(OUTPUTFORMAT)

runCommuncator: comunicator
	./communicator.$(OUTPUTFORMAT) $(IP) $(PORT3) $(PORT4)

com: runCommuncator