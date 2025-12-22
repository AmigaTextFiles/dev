CC := ppc-amigaos-gcc
AR := ppc-amigaos-ar
RM := rm -f
CP := cp -p --remove-destination

CFLAGS := -O2 -Wall -Iinclude
LDFLAGS := 
LIBS := -lauto

OBJS := closehandle.o datestamptofiletime.o dostow32error.o createdirectory.o \
	createfile.o deletefile.o filetimetodatestamp.o filetimetolocalfiletime.o \
	filetimetosystemtime.o findfirstfile.o getfilesize.o getfilesizeex.o \
	getfiletime.o getlasterror.o readfile.o removedirectory.o setendoffile.o \
	setfilepointer.o setfiletime.o writefile.o

TESTS := tests/mkfile tests/listfiles

all: libwin32.a tests

libwin32.a: $(OBJS)
	$(AR) -crv $@ $^

$(OBJS): w32private.h include/w32api/windows.h

tests: $(TESTS)

tests/mkfile: tests/mkfile.o libwin32.a
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

tests/listfiles: tests/listfiles.o libwin32.a
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

clean:
	$(RM) libwin32.a *.o $(TESTS) tests/*.o

dist: libwin32.a
	$(CP) libwin32.a ../release/SDK/local/newlib/lib/
	$(CP) -r include/* ../release/SDK/local/newlib/include/
