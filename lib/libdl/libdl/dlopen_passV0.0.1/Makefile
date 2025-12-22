# Version
VERSION = 0.0.1

# Compiler flags
CFLAGS = -Wall -W -O2

all: plugin dlopen

plugin: plugin.c
	 gcc $(CFLAGS) -c -fPIC plugin.c
	 gcc $(CFLAGS) -o plugin.so -shared plugin.o

dlopen: dlopen.c
	 gcc $(CFLAGS) -o dlopen dlopen.c -ldl -lauto -use-dynld

cos: cos.c
	gcc $(CFLAGS) -o cos cos.c -ldl -use-dynld -lauto

clean:	
	rm plugin.so dlopen cos
