CC = gcc

#Output failas yra t.out, o ne t.exe, nes naudoju Linux'us
OUTPUT = t.out
HEADERS = functions.h list.h
FILES = functions.c list.c

mainmake: main.c $(HEADERS) $(FILES)
	$(CC) main.c $(FILES) -o  $(OUTPUT) -I.

debug: debug.c $(HEADERS) $(FILES)
	$(CC) debug.c $(FILES) -o $(OUTPUT) -I.