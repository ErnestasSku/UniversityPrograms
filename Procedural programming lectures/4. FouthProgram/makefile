CC = gcc

#This program initially was written using linux, therefore the output file is
# .out and not .exe
OUTPUT = t.out
HEADERS = functions.h list.h
FILES = functions.c list.c

mainmake: main.c $(HEADERS) $(FILES)
	$(CC) main.c $(FILES) -o  $(OUTPUT) -I.

debug: debug.c $(HEADERS) $(FILES)
	$(CC) debug.c $(FILES) -o $(OUTPUT) -I.