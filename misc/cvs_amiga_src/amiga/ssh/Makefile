CFLAGS	= -DHAVE_CONFIG_H -DAMIGA -I. -I../ $(TARGFLAGS)
DIR	= obj_$(EXT)

OBJS	= $(DIR)/blowfish.o $(DIR)/crc.o $(DIR)/des.o $(DIR)/md5.o \
          $(DIR)/rsa.o $(DIR)/ssh_protocol.o


all: $(TARGET)

$(TARGET): $(OBJS)
	$(RM) $(TARGET)
	$(AR) $(TARGET) $(OBJS)

obj_$(EXT)/%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	-delete force quiet $(TARGET) $(OBJS)
