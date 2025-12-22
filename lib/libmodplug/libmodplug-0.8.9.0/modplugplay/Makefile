CC := ppc-amigaos-gcc

CFLAGS  := -mcrt=clib2 -O2 -g -Wall -Werror
LDFLAGS := -athread=single -mcrt=clib2 -static
LIBS    := -lmodplug -lstdc++ -lm

modplugplay: modplugplay.o loadfile.o ahi.o
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

.PHONY: clean
clean:
	rm -f modplugplay *.o

