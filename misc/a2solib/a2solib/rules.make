# Choose clib2 or newlib here
CLIB = clib2

ifeq ($(shell uname), AmigaOS)
CROSS   =
RM 		= delete
CP		= copy
MKDIR	= makedir
MV		= rename
LINSTDIR= SDK:local/$(CLIB)/
BINSTDIR= SDK:local/c/
else
CROSS	= ppc-amigaos-
RM		= rm
CP		= cp
MKDIR	= mkdir
MV		= mv
LINSTDIR= /usr/local/amiga/ppc-amigaos/SDK/local/$(CLIB)/
BINSTDIR= /usr/local/amiga/bin/
endif

CFLAGS = -mcrt=$(CLIB)
LDFLAGS = -mcrt=$(CLIB)

ifeq ($(shell uname), CYGWIN_NT-5.1)
EXE=.exe
else
EXE=
endif

CC 		= $(CROSS)gcc
CXX 	= $(CROSS)c++
AR 		= $(CROSS)ar
CCNAT	= gcc
