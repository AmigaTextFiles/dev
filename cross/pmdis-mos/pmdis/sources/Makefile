#
# (c) 2001 Jouni 'Mr.Spiv' Korhonen / Dead Coders Society
#
#

.PHONY: clean all dep dist
.SUFFIXES:
.SUFFIXES: .c .o .h
.DEFAULT:
	make all
#

SRCS = pmhelper.c	pmstatics.c	\
       pm_3f.c		pm_40_7f.c \
       pm_80_9f.c	pm_a0_df.c \
       pm_ce_cf.c	pm_e0_ff.c \
       pm_fixed.c				\
       main.c		pm_disasm.c	\
       disasm.c

HDRS = pmd.h disasm.h

OBJS = pmhelper.o                  pmstatics.o	\
       pm_3f.o		pm_40_7f.o \
       pm_80_9f.o	pm_a0_df.o \
       pm_ce_cf.o	pm_e0_ff.o \
       pm_fixed.o				\
       main.o				pm_disasm.o	\
       disasm.o

#

PROG = pmdis

#
# If you want to (of course you want to :) compile all source
# for Amiga using Amiga specific stuff then just uncomment the
# OS and CPU defines..
#

CC = gcc
RM = rm -f
CP = cp
OS = #AMIGA
CPU = #68020
DEPEND = .dep
WILD = *
FOO = PMDis - a disassembler for Pokemon-Mini is ready

LOCAL_CFLAGS = -O -fomit-frame-pointer
LOCAL_LDFLAGS =

#
#
#

ifeq ($(OS),AMIGA)
	LOCAL_CFLAGS += -noixemul
	RM = delete
	WILD = "\#?"

ifeq ($CPU),68020)
	LOCAL_CFLAGS += -mc68020
endif
endif

#
# rules

all: $(DEPEND) $(PROG)
	@echo $(FOO)

-include $(DEPEND)

$(DEPEND): Makefile
	$(CC) -MM $(SRCS) > $(DEPEND)
	@echo "Dependencies done"

%.o: %.c
	$(CC) $(LOCAL_CFLAGS) -c $< -o $@

$(PROG): $(OBJS)
	$(CC) -o $(PROG) $(OBJS) $(LOCAL_LDFLAGS) $(LOCAL_LIBDIR) $(LOCAL_LIBS)


clean:
	-$(RM) $(WILD).o
	-$(RM) $(WILD)~
	-$(RM) $(PROG).tgz
	-$(RM) $(DEPEND)
	-$(RM) $(PROG)

dist:
	tar zcvf $(PROG).tgz *.c *.h Makefile readme.txt




