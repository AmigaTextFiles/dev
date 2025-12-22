CFLAGS	= -DHAVE_CONFIG_H -DAMIGA -I. -I../ -I../src -I../lib -Issh $(TARGFLAGS)
DIR	= obj_$(EXT)

OBJS	= $(DIR)/amiga.o $(DIR)/filesubr.o


all: $(TARGET)

$(TARGET): $(OBJS)
	$(RM) $(TARGET)
	$(AR) $(TARGET) $(OBJS)

obj_$(EXT)/%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	-delete force quiet $(TARGET) $(OBJS)
