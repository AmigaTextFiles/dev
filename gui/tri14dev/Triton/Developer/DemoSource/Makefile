#
#  Triton - The object oriented GUI creation system for the Amiga
#  Written by Stefan Zeiger in 1993-1995
#
#  (c) 1993-1995 by Stefan Zeiger
#  You are hereby allowed to use this source or parts of it for
#  creating programs for AmigaOS which use the Triton GUI creation
#  system. All other rights reserved.
#
#  Makefile - Makefile for gcc
#


CC	= gcc

CFLAGS	= -O2

LFLAGS	= -ltriton -lauto

all:	Demo EnvPrint trLogo ToolManager1 ToolManager2 ToolManager3 ProgInd

Demo: Demo.c
	$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

EnvPrint: EnvPrint.c
	$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

trLogo: trLogo.c
	$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

ToolManager1: ToolManager1.c
	$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

ToolManager2: ToolManager2.c
	$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

ToolManager3: ToolManager3.c
	$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

ProgInd: ProgInd.c
	$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)
