CC = g++ -mcrt=clib2
AR = ar
RM = delete

CFLAGS = -O3

TARGET = libchipmunk.a

OBJS = cpVect.o cpSpaceHash.o cpSpace.o cpShape.o \
	cpPolyShape.o cpJoint.o cpHashSet.o cpCollision.o \
	cpBody.o cpBB.o cpArray.o cpArbiter.o chipmunk.o

$(TARGET): $(OBJS)
	$(AR) -crv $@ $^

clean:
	$(RM) $(OBJS) $(TARGET)
