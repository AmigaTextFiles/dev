CFLAGS = -n +L

OBJ = mrdatereq.o mrdates.o mrgadgets.o rxdatereq.o minrexx.o
REXXOBJ = rexxglue.o rexxvars.o

# Note: REXXOBJ files are expected to be in the library search path.

rxdatereq: $(OBJ)
	ln -w -g -o rxdatereq $(OBJ) $(REXXOBJ) -la32 -lc32

MRDateReq.pw.uue: MRDateReq.pw
	uuencode >MRDateReq.pw.uue MRDateReq.pw MRDateReq.pw

rxdatereq.uue: rxdatereq
	uuencode >rxdatereq.uue rxdatereq rxdatereq

shar: MRDateReq.pw.uue rxdatereq.uue
	makekit -n SHAR ReadMe *.c *.h *.uue MakeFile test listsince
