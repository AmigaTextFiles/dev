#
CFLAGS = -O -DUNIX -DANSICRT $(DEBUG)
CC = gcc

OBJ = .o

#MVSCFLAGS = -O2 -DOPENEDITION -DANSICRT $(DEBUG)
#MVSCC = gcc-uss
MVSCFLAGS = -O2 -DOS390 $(DEBUG)
MVSCC = gcc-mvsle
MVSCOPTS = -S

SRCS =	focal.c parser.c screen.c 
OBJS =	focal$(OBJ) parser$(OBJ) screen$(OBJ) 
SSRC =	focal.s parser.s screen.s
HDRS =  parser.h errors.h ptables.h stables.h psemant.h scanner.h

.c.s :
	$(MVSCC) $(MVSCFLAGS) $(MVSCOPTS) $<
	@mv $@ t.t
	@detab 9 16 +8 t.t >$@
	@rm t.t

all : 
	@if [ "`uname -s`" = "Linux" ] ; then \
		echo "Making Linux on a `uname -m`" ;\
		make linux ;\
	elif [ "`uname -s`" = "AIX" ] ; then \
		echo "Making AIX" ;\
		make aix ;\
	elif [ "`uname -s`" = "SunOS" ] ; then \
		echo "Making Solaris" ;\
		make solaris ;\
	elif [ "`uname -s`" = "OS/390" ] ; then \
		echo "Making OS/390 USS" ;\
		make uss ;\
	else \
		echo "OS type `uname -s` is unknown" ;\
		echo "You must enter an OS type. OS types are:" ;\
		echo "   linux | nt | uss | openvms | os2 | riscos | solaris | sunos" ;\
		echo " " ;\
		echo "For IBM OS/390 you have the choices:" ;\
		echo "   dignusdcc | dignusgcc | mvs" ;\
		echo " " ;\
	fi

nt :
	@nmake /nologo /f Makefile.nt $(PARM)

uss :
	@make focal$(EXE) \
		"CFLAGS = -O -DOPENEDITION -DSYSVDIR -DSTRERROR -DANSICRT \
			$(DEBUG)" \
		"CC = cc" \
		$(PARM)

openvms vaxvms :
	make /file=Makefile.vms $(PARM)

os2 :
	@nmake /nologo /f Makefile.os2 $(PARM)

linux :
	@make focal$(EXE) \
		"CFLAGS = -O2 -DSYSVDIR -DSTRERROR -DANSICRT $(DEBUG)" \
		$(PARM)

solaris :
	@make focal$(EXE) \
		"CFLAGS = -O -DSYSVDIR -DSTRERROR -DANSICRT $(DEBUG)" \
		$(PARM)

sunos :
	@make focal$(EXE) \
		"CFLAGS = -O -DBSDDIR -DANSICRT $(DEBUG)" \
		$(PARM)

riscos :
	@make focal$(EXE) \
		"CFLAGS = -O -DBSDDIR -DANSICRT $(DEBUG)" \
		$(PARM)

focal : $(OBJS)
	$(CC) -o $@ $(CFLAGS) $(OBJS) -lm

mvs : $(SSRC)

dignusdcc :
	@make focal.po \
		"LIBS = -lmvs" \
		"CFLAGS = -DDIGNUS -DOS390 -I/usr/local/dignus/include $(DEBUG)" \
		"CC = dcc"

dignusgcc :
	@make focal.po \
		"LIBS = -lmvs" \
		"CFLAGS = -S -DOS390 $(DEBUG)" \
		"CC = gcc-mvsdignus"

clean :
	rm -f $(OBJS) $(SSRC) core focal
	rm -f *.obj *.asm *.po *.lst

depend : $(SRCS)
	mkdep $(SRCS) > makedep
	@echo '/^# DO NOT DELETE THIS LINE/+1,$$d' >eddep
	@echo '$$r makedep' >>eddep
	@echo 'w' >>eddep
	@cp Makefile Makefile.bak
	@ex - Makefile < eddep
	-@rm eddep makedep

lint : $(SRCS)
	lint $(SRCS)

tags : $(SRCS)
	ctags $(SRCS)

focalc.tok focalc.err focalc.ptb focalc.sem : focalc.bnf
	chat focalc

perrors.h : focalc.err
	cp focalc.err perrors.h

ptables.h : focalc.ptb
	cp focalc.ptb ptables.h

psemant.h : focalc.sem
	cp focalc.sem psemant.h

ptokens.h : focalc.tok
	cp focalc.tok ptokens.h

focal.s : focal.c parser.h errors.h perrors.h
parser.s : parser.c parser.h errors.h ptables.h stables.h psemant.h scanner.h
screen.s : screen.c

focal.asm : focal.c parser.h errors.h perrors.h
	$(CC) $(CFLAGS) -o $@ $<
parser.asm : parser.c parser.h errors.h ptables.h stables.h psemant.h scanner.h
	$(CC) $(CFLAGS) -o $@ $<
screen.asm : screen.c
	$(CC) $(CFLAGS) -o $@ $<

focal.obj : focal.asm
	dasm -xa -xr -xrld -L /usr/local/dignus/maclib -macext . -o $@ $<
parser.obj : parser.asm
	dasm -xa -xr -xrld -L /usr/local/dignus/maclib -macext . -o $@ $<
screen.obj : screen.asm
	dasm -xa -xr -xrld -L /usr/local/dignus/maclib -macext . -o $@ $<

focal.po : focal.obj parser.obj screen.obj
	plink -px -o $@ focal.obj parser.obj screen.obj -L/usr/local/dignus/lib -lc $(LIBS)

# DO NOT DELETE THIS LINE
focal$(OBJ) : focal.c parser.h errors.h perrors.h
parser$(OBJ) : parser.c parser.h errors.h ptables.h stables.h psemant.h scanner.h
screen$(OBJ) : screen.c
