CDEFS   = -DHAVE_CONFIG_H
CC      = ppc-morphos-gcc-4 -noixemul
INCLUDE = -I. -I./include
CFLAGS  = -mcpu=750 -mtune=7450 -O2 $(INCLUDE) -Wall $(CDEFS)
AR	= ar
RANLIB	= ranlib

ECHE = echo -e
BOLD = \033[1m
NRML = \033[22m

COMPILING = @$(ECHE) "compiling $(BOLD)$@$(NRML)..."
LINKING = @$(ECHE) "linking $(BOLD)$@$(NRML)..."
STRIPPING = @$(ECHE) "stripping $(BOLD)$@$(NRML)..."
ARCHIVING = @$(ECHE) "archiving $(BOLD)$@$(NRML)..."

TARGET  = libmikmod.a

SOURCES = \
	drivers/drv_aiff.c \
	drivers/drv_ahi.c \
	drivers/drv_nos.c \
	drivers/drv_raw.c \
	drivers/drv_stdout.c \
	drivers/drv_wav.c \
	loaders/*.c \
	mmio/*.c \
	playercode/*.c

OBJS = $(shell echo $(SOURCES) | sed -e 's,\.c,\.o,g')
SOBJS = $(shell echo $(SOURCES) | sed -e 's,\.c,\.so,g')

all: lib/$(TARGET) lib/libb32/$(TARGET)

.c.o:
	$(COMPILING)
	@$(CC) $(CFLAGS) -c $< -o $@

%.so: %.c
	$(COMPILING)
	@$(CC) $(CFLAGS) -mresident32 -c $< -o $@

lib/$(TARGET): $(OBJS)
	@mkdir -p lib/libb32
	$(LINKING)
	@-rm -f $@
	@$(AR) cru $@ $(OBJS)
	@$(RANLIB) $@

lib/libb32/$(TARGET): $(SOBJS)
	@mkdir -p lib/libb32
	$(LINKING)
	@-rm -f $@
	@$(AR) cru $@ $(SOBJS)
	@$(RANLIB) $@

clean:
	rm -f $(TARGET) $(OBJS) $(SOBJS)

dep:
	echo >Makefile.dep
	$(CC) -MM $(CFLAGS) $(SOURCES) >>Makefile.dep

-include Makefile.dep
