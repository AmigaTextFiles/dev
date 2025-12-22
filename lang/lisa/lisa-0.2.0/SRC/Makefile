# Makefile for project lisa
SRCDIR=.
CFLAGS=-O2 -pedantic -Wall
CC=gcc
LINKER=gcc
OBJS=\
	eval.o \
	lexer.o \
	parser.o \
	phpdbdriver.o \
	xml.o \
	main.o \

LIBS=

lisac:	$(OBJS) Makefile
	$(LINKER) -o $(SRCDIR)/lisac $(OBJS) $(LIBS)

# Build EVAL.C
EVAL_C=\
	$(SRCDIR)/eval.h\
	$(SRCDIR)/main.h\

eval.o: $(EVAL_C) $(SRCDIR)/eval.c
	$(CC) -c $(CFLAGS) $(SRCDIR)/eval.c

# Build LEXER.C
LEXER_C=\
	$(SRCDIR)/lexer.h\
	$(SRCDIR)/main.h\

lexer.o: $(LEXER_C) $(SRCDIR)/lexer.c
	$(CC) -c $(CFLAGS) $(SRCDIR)/lexer.c

# Build PARSER.C
PARSER_C=\
	$(SRCDIR)/parser.h\
	$(SRCDIR)/main.h\

parser.o: $(PARSER_C) $(SRCDIR)/parser.c
	$(CC) -c $(CFLAGS) $(SRCDIR)/parser.c

# Build PHPDBDRIVER.C
PHPDBDRIVER_C=\
	$(SRCDIR)/phpdbdriver.h\
	$(SRCDIR)/main.h\

phpdbdriver.o: $(PHPDBDRIVER_C) $(SRCDIR)/phpdbdriver.c
	$(CC) -c $(CFLAGS) $(SRCDIR)/phpdbdriver.c

# Build XML.C
XML_C=\
	$(SRCDIR)/xml.h\
	$(SRCDIR)/main.h\

xml.o: $(PHPDBDRIVER_C) $(SRCDIR)/xml.c
	$(CC) -c $(CFLAGS) $(SRCDIR)/xml.c

# Build LISA.C
LISA_C=\
	$(SRCDIR)/main.h\

main.o: $(LISA_C) $(SRCDIR)/main.c
	$(CC) -c $(CFLAGS) $(SRCDIR)/main.c

link:
	$(LINKER) -o $(SRCDIR)/lisac $(OBJS) $(LIBS)

