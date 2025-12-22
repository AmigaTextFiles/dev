NAME   = throw

CC     = /usr/bin/gcc
CFLAGS = -noixemul -O3 -Wall

CHMOD  = /usr/bin/chmod

%.o: %.c
	$(CC) -c $< $(CFLAGS)
	$(CHMOD) -x $@

$(NAME): main.o
	$(CC) $^ -o $@ -lamiga -lauto $(CFLAGS)

main.o:  main.c macro.h

