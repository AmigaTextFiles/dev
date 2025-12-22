###########################################################################
#
# Makefile created by Matthew D. Campbell
# email: matt@campbellhome.dhs.org
#
###########################################################################

all: libSDLSprite.a

SDL_CFLAGS :=  $(shell sdl-config --cflags)
SDL_LDFLAGS :=  $(shell sdl-config --libs)

SRC=SDLSprite.cpp SDLSpriteList.cpp
OBJS=SDLSprite.o SDLSpriteList.o
HDRS=SDLSprite.h SDLSpriteList.o

CFLAGS=$(SDL_CFLAGS)
LDFLAGS=$(SDL_LDFLAGS)

AR=i386-aros-ar
CXX=i386-aros-g++

.cpp.o:
	$(CXX) -c $^ $(CFLAGS)

libSDLSprite.a: $(OBJS) $(SRC) $(HDRS)
	$(AR) -r libSDLSprite.a $(OBJS)
