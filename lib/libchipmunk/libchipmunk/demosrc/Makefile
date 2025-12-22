CC = gcc -mcrt=newlib
RM = delete

CFLAGS = -O3 -std=gnu99 -DMINIGL -Dtimeval=TimeVal

LIBS = -lGLUT -lGL -lchipmunk -lm

TARGET = Demo

OBJS = main.o Demo1.o Demo2.o Demo3.o \
	Demo4.o Demo5.o Demo6.o Demo7.o

$(TARGET): $(OBJS)
	$(CC) -o $@ $^ $(LIBS)

clean:
	$(RM) $(TARGET) $(OBJS)
