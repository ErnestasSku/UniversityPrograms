PY = python3
CC = clang

COMPILE_FLAGS = -I/usr/include/python3.8 -I/usr/include/python3.8  -Wno-unused-result -Wsign-compare -g -fdebug-prefix-map=/build/python3.8-AEtGER/python3.8-3.8.10=. -specs=/usr/share/dpkg/no-pie-compile.specs -fstack-protector -Wformat -Werror=format-security  -DNDEBUG -g -fwrapv -O3 -Wall

LINK_FLAGS = -L/usr/lib/python3.8/config-3.8-x86_64-linux-gnu -L/usr/lib -lpython3.8 -lcrypt -lpthread -ldl  -lutil -lm -lm 

py: 
	sudo $(PY) setup.py install
	$(PY) 4.py

compile:
	$(CC) -c main.c $(COMPILE_FLAGS)
	
link: compile
	$(CC) main.o $(LINK_FLAGS)

run: link
	./a.out

clean: 
	rm *.o 
	rm *.out
