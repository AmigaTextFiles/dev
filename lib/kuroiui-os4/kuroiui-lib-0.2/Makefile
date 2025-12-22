LIBRARY = libkuroiui.a

LFLAGS = -mcrt=newlib -lSDL_gfx -lSDL_net -lSDL_image -ltiff -lpng -ljpeg -lz -lSDL_mixer -lsmpeg -lm -lvorbisfile -lvorbis -logg -lstdc++ -lSDL_ttf -lfreetype -lz -lsdlmain -lsdl -lauto -lpthread -lm -lunix

CC = g++ -mcrt=newlib
AR = ar
CCFLAGS = -Wall -ggdb3 -ansi -pedantic
COMPILE = $(CC) $(CCFLAGS) -c
ARCHIVE = $(AR) rcs

SRCS := $(wildcard *.cpp)
OBJS := $(patsubst %.cpp,objs/%.o,$(SRCS))

all: $(LIBRARY)

$(LIBRARY): $(OBJS)
	@echo -n "Archiving $(LIBRARY) ... "
	@$(ARCHIVE) $(LIBRARY) $(OBJS)
	@echo "done!"

objs/%.o: %.cpp
	@echo -n "Compiling $< ... "
	@$(COMPILE) -o $@ $<
	@echo "done!"

clean:
	@echo -n "Cleaning up ... "
	@-rm $(OBJS) $(LIBRARY) *~
	@echo "done!"


