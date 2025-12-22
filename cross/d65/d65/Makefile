TARGET = d65
OBJECTS = scan.o vector.o dump.o table.o label.o main.o

# choose the compiler and flags

#CC = cc
#CFLAGS = -O
#CFLAGS = -O2

CC = gcc
#CFLAGS = -Wall -Wmissing-prototypes -pedantic -O6
CFLAGS = -Wall -Wmissing-prototypes -ggdb

all: $(TARGET)

$(TARGET) : $(OBJECTS)
	$(CC) $(LDFLAGS) -o $@ $(OBJECTS)

scan.o : structures.h proto.h options.h opcodes.h
vector.o : structures.h proto.h options.h
dump.o : structures.h proto.h options.h opcodes.h
table.o : structures.h proto.h
label.o : structures.h proto.h
main.o : structures.h proto.h options.h opcodes.h

clean:
	rm -f $(OBJECTS)
