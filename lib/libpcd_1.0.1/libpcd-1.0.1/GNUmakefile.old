
DESTDIR	:=
prefix	:= /usr/local

incdir	:= $(DESTDIR)$(prefix)/include
libdir	:= $(DESTDIR)$(prefix)/lib

CC	:= gcc
WARN	:= -Wall -Wmissing-prototypes -Wstrict-prototypes -Wpointer-arith
CFLAGS	?= -g -O2
CFLAGS	+= $(WARN)

MAJOR	:= 2
MINOR	:= 2.0.1
SONAME	:= libpcd.so.$(MAJOR)
TARGETS	:= libpcd.a libpcd.so.$(MINOR)

SRCS	:= file.c yuv2rgb.c huff.c inter.c
STATIC	:= $(subst .c,.o,$(SRCS))
SHARED	:= $(subst .c,.pic.o,$(SRCS))
depfile	 = $(subst .o,.dep,$@)

all build: $(TARGETS) 

%.o: %.c
	$(CC) $(CFLAGS) -Wp,-MD,$(depfile) -c -o $@ $<

%.pic.o: %.c
	$(CC) $(CFLAGS) -Wp,-MD,$(depfile) -fPIC -c -o $@ $<

libpcd.a: $(STATIC)
	rm -f $@
	ar rc $@ $(STATIC)
	ranlib $@

libpcd.so.$(MINOR): $(SHARED)
	rm -f $@
	$(CC) $(CFLAGS) -shared -Wl,-soname,$(SONAME) -o $@ $(SHARED)

install:
	install -d $(libdir)
	install -d $(incdir)
	install -m644 libpcd.a $(libdir)
	install -m755 libpcd.so.$(MINOR) $(libdir)
	ln -s libpcd.so.$(MINOR) $(libdir)/libpcd.so.$(MAJOR)
	ln -s libpcd.so.$(MINOR) $(libdir)/libpcd.so
	install -m644 pcd.h $(incdir)

clean:
	-rm -f *~ *.bak *.dep $(STATIC) $(SHARED)

realclean distclean: clean
	-rm -f libpcd.a libpcd.so.$(MAJOR) libpcd.so.$(MINOR)

# auto dependencies
-include *.dep

# debian stuff
dsc source: distclean
	dpkg-buildpackage -S -us -uc -rfakeroot

debs pbuild: dsc
	sudo /usr/sbin/pbuilder build ../libpcd_*.dsc

