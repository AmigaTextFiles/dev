CFLAGS	= -DHAVE_CONFIG_H -DAMIGA \
          -I. -I../ -I../lib -I../src $(TARGFLAGS)
DIR	= obj_$(EXT)

OBJS	= $(DIR)/adler32.o $(DIR)/compress.o $(DIR)/crc32.o \
          $(DIR)/gzio.o $(DIR)/uncompr.o $(DIR)/deflate.o $(DIR)/trees.o \
          $(DIR)/zutil.o $(DIR)/inflate.o $(DIR)/infblock.o \
          $(DIR)/inftrees.o $(DIR)/infcodes.o $(DIR)/infutil.o \
          $(DIR)/inffast.o


all: $(TARGET)

$(TARGET): $(OBJS)
	$(RM) $(TARGET)
	$(AR) $(TARGET) $(OBJS)

obj_$(EXT)/%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	-delete force quiet $(TARGET) $(OBJS)
