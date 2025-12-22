
OPT = -newlib -O2 -ggdb -D__USE_BASETYPE__ -D__USE_INLINE__ -I. -I./include
LIB = -lSDL_image -lSDL -lSDL_ttf -lfreetype -Llib -lablit -lablit_utils \
      -lpng -ljpeg -lpthread -lz -lm -lauto
SHELL = /SDK/local/c/sh


SRC = ablit_demo.c
OBJ = $(SRC:.c=.o)
APP = ../bin/ablit_demo

.SUFFIXES: .c.cpp

all: $(APP)

$(APP): $(OBJ)
	gcc -o $@ $< $(OPT) $(LIB)
	@echo 'Done. The demo can be found in $(APP)'

.c.o:
	gcc $(OPT) -c $<

clean: 
	-rm *.o $(APP)

rebuild: clean $(APP)

