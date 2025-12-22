CFLAGS	= -DHAVE_CONFIG_H -DAMIGA \
          -I. -I../ -I../lib $(TARGFLAGS)
DIR	= obj_$(EXT)

OBJS	= $(DIR)/diff.o $(DIR)/diff3.o $(DIR)/analyze.o \
          $(DIR)/cmpbuf.o $(DIR)/dir.o $(DIR)/io.o $(DIR)/util.o \
          $(DIR)/context.o $(DIR)/ed.o $(DIR)/ifdef.o \
          $(DIR)/normal.o $(DIR)/side.o $(DIR)/version.o


all: $(TARGET)

$(TARGET): $(OBJS)
	$(RM) $(TARGET)
	$(AR) $(TARGET) $(OBJS)

obj_$(EXT)/%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	-delete force quiet $(TARGET) $(OBJS)
