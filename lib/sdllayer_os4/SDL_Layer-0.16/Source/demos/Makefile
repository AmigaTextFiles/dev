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

cflags=-Wall $$($(sdlconfig) --cflags) -I../ -g -pg -O4
libs=$$($(sdlconfig) --libs) -lSDL_gfx -lSDL_net -lSDL_image -ltiff -lpng -ljpeg -lz -lSDL_mixer -lsmpeg -lvorbisfile -lvorbis -logg -lstdc++ -lSDL_ttf -lfreetype -lz -lsdlmain -lsdl -lauto -lpthread -lm



all:
	$(gcc) $(cflags) scroll.c ../libSDL_layer.a $(libs) -o scroll
	$(gcc) $(cflags) snow.c ../libSDL_layer.a $(libs) -o snow

clean:
	\rm -Rf *.o scroll snow

