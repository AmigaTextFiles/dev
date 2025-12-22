
CC = dcc:abin/dcc
CCOPTS = -3.0 
CFLAGS = -// 

SCCOBJS = callfunc.o codegen.o const.o data.o decl.o error.o expr.o \
float.o io.o lex.o main.o misc.o plunge.o preproc.o primary.o stmt.o sym.o \
while.o 

SCCHDRS = ccdefs.h callfunc.h codegen.h const.h data.h decl.h define.h \
error.h expr.h float.h io.h lex.h lvalue.h main.h misc.h plunge.h \
preproc.h primary.h stmt.h sym.h while.h



all: scc dumbarse



scc: ${SCCOBJS} 
        ${CC} -o scc ${CFLAGS} ${CCOPTS} ${SCCOBJS}

# You probably won't need this!

dumbarse: 
	${CC} -o scc -3.0 ${SCCOBJS}


# Dependencies for SCCOBJS..

callfunc.o: callfunc.c ${SCCHDRS}
codegen.o:  codegen.c ${SCCHDRS}
const.o:    const.c ${SCCHDRS}
data.o:     data.c ${SCCHDRS}
decl.o:     decl.c ${SCCHDRS}
error.o:    error.c ${SCCHDRS}
expr.o:     expr.c ${SCCHDRS}
float.o:    float.c ${SCCHDRS}
io.o:       io.c ${SCCHDRS}
lex.o:      lex.c ${SCCHDRS}
main.o:     main.c ${SCCHDRS}
misc.o:     misc.c ${SCCHDRS}
plunge.o:   plunge.c ${SCCHDRS}
preproc.o:  preproc.c ${SCCHDRS}
primary.o:  primary.c ${SCCHDRS}
stmt.o:     stmt.c ${SCCHDRS}
sym.o:      sym.c ${SCCHDRS}
while.o:    while.c ${SCCHDRS}
