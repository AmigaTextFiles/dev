# arp.lib makefile

CFLAGS=+b +x3,5

.c.oi:
	cc $(CFLAGS) +ipre:intuition -o $@ $*.c

.fd.lib:
	bind -rAztec $*

ARP_LIB=\
scdir.o dospkt.o fmalloc.o crt0.o _main.oi wbparse.o cliparse.o clitemp.o clihelp.o \
exit.o _exit.o vars.o

A_LIB=sprintf.o fprintf.o printf.o tracker.o toupper.o arp_lib.lib

all: clib:arp.lib clib:a.lib clib:gads.o clib:arpdetach.o

clib:arp.lib: $(ARP_LIB) $(A_LIB)
	lb $@ $(ARP_LIB) $(A_LIB)

clib:a.lib: $(A_LIB)
	lb $@ $(A_LIB)

# special compilation

clib:gads.o: gads.c
	cc $(CFLAGS) -o$@ gads.c

clib:arpdetach.o: _main.c
	cc $(CFLAGS) -DDETACH +ipre:intuition -o$@ _main.c

