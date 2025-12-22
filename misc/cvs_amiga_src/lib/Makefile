CFLAGS	= -DHAVE_CONFIG_H -DAMIGA \
          -I. -I../ -I../src -I../amiga $(TARGFLAGS)
DIR	= obj_$(EXT)

OBJS	= $(DIR)/argmatch.o $(DIR)/getline.o $(DIR)/getopt.o \
          $(DIR)/getopt1.o $(DIR)/md5.o $(DIR)/regex.o $(DIR)/savecwd.o \
          $(DIR)/stripslash.o $(DIR)/xgetwd.o $(DIR)/yesno.o \
          $(DIR)/sighandle.o $(DIR)/getdate.o $(DIR)/fnmatch.o \
          $(DIR)/fncase.o


all: $(TARGET)

$(TARGET): $(OBJS)
	$(RM) $(TARGET)
	$(AR) $(TARGET) $(OBJS)

obj_$(EXT)/%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	-delete force quiet $(TARGET) $(OBJS)
