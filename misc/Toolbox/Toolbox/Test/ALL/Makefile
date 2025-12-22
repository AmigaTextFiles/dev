TOOLBOX = toolbox:
TOOL = $(TOOLBOX)bin
REUSE = $(TOOLBOX)lib
INCLUDE = $(REUSE)/include
OP = -I$(INCLUDE)
CC = gcc $(OP)

all: parser

# Parser
##############################################################
parser:	Parser.o ParserDrv.o Errors.o Scanner.o Source.o Tree.o
	$(CC) -o parser Parser.o ParserDrv.o Scanner.o Errors.o Source.o Tree.o -L$(INCLUDE) -lreuse

Parser.c: Scanner.c PL5.lalr.c Tree.c
	$(TOOL)/lalr -c -d -e -p -b -v PL5.lalr.c

Parser.o Errors.o ParserDrv.o: $*.c
	$(CC) -c $*.c

# Abstract Syntax Tree
##############################################################
Tree.c: PL5.astag.c
	$(TOOL)/ast -mwdiRck PL5.astag.c

Tree.o: $*.c
	$(CC) -c $*.c


# Attribute Evaluation
##############################################################
#Eval.c:	PL5.astag.c
#	$(TOOL)/ag -DIc$(AGX) PL5.astag.c



# Scanner
##############################################################
scanner:	Scanner.o Source.o ScannerDrv.o
	$(CC) -o scanner Scanner.o Source.o ScannerDrv.o -L$(INCLUDE) -lreuse

Scanner.c:	PL5.rex.c
	$(TOOL)/rex -csd PL5.rex.c

Scanner.o Source.o ScannerDrv.o: $*.c
	$(CC) -c $*.c

clean:
	-rm s#? pa#? y#? _#? e#? #?.info t#?
