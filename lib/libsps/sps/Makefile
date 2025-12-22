CC=$(CROSS)gcc
CXX=$(CROSS)gcc
LD=$(CROSS)gcc
AR=$(CROSS)ar
RANLIB=$(CROSS)ranlib
RM=rm -rf

INC=-Iinclude
LIB=
CFLAGS=-Wall -mcrt=newlib
DBG=-ggdb -O0

.SUFFIXES: .cpp

LIBRARY=lib/libsps++.a

SRC=sps_exception.cpp \
    sps_timer.cpp \
    sps_thread.cpp \
    sps_hook.cpp \
    sps_message.cpp
	
OBJ=$(SRC:.cpp=.o)

all: lib test

lib: $(LIBRARY)

test: examples/test

doc: doxygen

# maybe someone can fix my dependecies
$(LIBRARY): $(OBJ)
	$(AR) crv $@ obj/sps_exception.o obj/sps_timer.o obj/sps_thread.o obj/sps_hook.o obj/sps_message.o
	$(RANLIB) $(LIBRARY)
	@echo Done compiling $(LIBRARY).

.cpp.o:
	$(CC) $(CFLAGS) $(DBG) $(INC) -c $< -o obj/$@

#clean us up
clean:
	$(RM) $(LIBRARY) obj/*.o examples/*.o examples/test

#install into SDK
install: $(LIBRARY)
	@cp -v $(LIBRARY) /sdk/local/newlib/lib
	@mkdir -p /sdk/local/common/include/sps
	@cp -v -f -r *.h /sdk/local/common/include/sps

#example
examples/test: examples/test.cpp $(LIBRARY)
	$(CC) $(CFLAGS) $(DBG) $(INC) examples/test.cpp -o examples/test -Llib -lsps++ -lauto -lstdc++
	@cp -p examples/test examples/test.debug
	@strip examples/test

doxygen:
	@doxygen

# distribution
dist:
