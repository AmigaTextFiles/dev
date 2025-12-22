CC = g++
LD = g++
CFLAGS = -Wall `sdl-config --cflags` 
LDFLAGS = `sdl-config --libs` -lSDL_image
RM   = /bin/rm -f
OBJS = scrolling.o 
PROG = scrolling
VERS = 0.1.0

.PHONY: clean distclean
all: $(PROG)
$(PROG): $(OBJS)
	$(LD) $(LDFLAGS) -s -o $(PROG) $(OBJS)
scrolling.o: scrolling.cpp
	$(CC) $(CFLAGS) -O2 -c scrolling.cpp 
clean:
	$(RM) *~ $(OBJS) $(PROG)
.PHONY: clean
