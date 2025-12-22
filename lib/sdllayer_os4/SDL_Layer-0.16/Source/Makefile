sdlconfig=$(shell which sdl-config)
gcc=$(shell which gcc)
ar=$(shell which ar)

ifeq (sqlconfig,"")
$(error "I need sdl-config to compile")
endif

ifeq (gcc,"")
$(error "I need gcc to compile")
endif

ifeq (ar,"")
$(error "I need ar to compile")
endif

cflags=-Wall $$($(sdlconfig) --cflags) -g -pg -O4
libs=$$($(sdlconfig) --libs)


all:
	$(gcc) $(cflags) -c *.c
	$(ar) rcs libSDL_layer.a *.o

demos:	all
	\cd demos && $(MAKE)


clean:
	\rm -Rf *.o *.a

.PHONY: demos

