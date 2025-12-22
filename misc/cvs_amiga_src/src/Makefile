CFLAGS	= -DHAVE_CONFIG_H -DAMIGA -no-trigraphs \
          -I../ -I../lib -I../diff -I../zlib -I../amiga $(TARGFLAGS)
DIR	= obj_$(EXT)

OBJS1	= $(DIR)/add.o $(DIR)/admin.o $(DIR)/annotate.o $(DIR)/buffer.o \
          $(DIR)/checkin.o $(DIR)/checkout.o $(DIR)/classify.o \
          $(DIR)/client.o $(DIR)/commit.o $(DIR)/create_adm.o $(DIR)/cvsrc.o \
          $(DIR)/diff.o $(DIR)/edit.o $(DIR)/entries.o $(DIR)/error.o \
          $(DIR)/expand_path.o $(DIR)/fileattr.o $(DIR)/filesubr.o \
          $(DIR)/find_names.o $(DIR)/hardlink.o $(DIR)/hash.o \
          $(DIR)/history.o $(DIR)/ignore.o $(DIR)/import.o $(DIR)/lock.o

OBJS2   = $(DIR)/log.o $(DIR)/login.o $(DIR)/logmsg.o $(DIR)/main.o \
          $(DIR)/mkmodules.o $(DIR)/modules.o $(DIR)/myndbm.o \
          $(DIR)/no_diff.o $(DIR)/parseinfo.o $(DIR)/patch.o $(DIR)/rcs.o \
          $(DIR)/rcscmds.o $(DIR)/recurse.o $(DIR)/release.o $(DIR)/remove.o \
          $(DIR)/repos.o $(DIR)/root.o $(DIR)/run.o $(DIR)/scramble.o \
          $(DIR)/server.o $(DIR)/stack.o $(DIR)/status.o $(DIR)/subr.o \
          $(DIR)/tag.o $(DIR)/update.o $(DIR)/version.o $(DIR)/vers_ts.o \
          $(DIR)/watch.o $(DIR)/wrapper.o $(DIR)/zlib.o


all: $(TARGET)

$(TARGET): $(OBJS1) $(OBJS2)
	$(RM) $(TARGET)
	$(AR) $(TARGET) $(DIR)/#?.o

obj_$(EXT)/%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	-delete force quiet $(TARGET) $(DIR)/#?.o
