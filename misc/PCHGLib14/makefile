# Generates pchg.lib and pchgr.lib

OBJ=PCHGLib.o HuffComp.o SetUserCopList.o ParsePCHG.o SHAM2PCHG.o FastDecomp.o BuildFreqTable.o
OBJR=PCHGLibr.o HuffCompr.o SetUserCopListr.o ParsePCHGr.o SHAM2PCHGr.o FastDecomp.o BuildFreqTable.o

all: pchgr.lib pchg.lib

pchg.lib: $(OBJ)
     oml pchg.lib R $(OBJ)

pchgr.lib: $(OBJR)
     oml pchgr.lib R $(OBJR)

PCHGLibr.o: PCHGLib.c
     sc PARMS=REG NOSTKCHK OPTIMIZE STREQ UNSCHAR STRMERGE OBJNAME=PCHGLibr.o $*

PCHGLib.o: PCHGLib.c
     sc NOSTKCHK OPTIMIZE STREQ UNSCHAR STRMERGE OBJNAME=PCHGLib.o $*

HuffCompr.o: HuffComp.c
     sc PARMS=REG NOSTKCHK OPTIMIZE STREQ UNSCHAR STRMERGE OBJNAME=HuffCompr.o $*

HuffCompr.o:
     sc NOSTKCHK OPTIMIZE STREQ UNSCHAR STRMERGE OBJNAME=HuffComp.o $*

SetUserCopListr.o: SetUserCopList.c
     sc  PARMS=REG NOSTKCHK OPTIMIZE STREQ UNSCHAR STRMERGE OBJNAME=SetUserCopListr.o $*

SetUserCopList.o: SetUserCopList.c
     sc  NOSTKCHK OPTIMIZE STREQ UNSCHAR STRMERGE OBJNAME=SetUserCopList.o $*

ParsePCHGr.o: ParsePCHG.c
     sc PARMS=REG NOSTKCHK OPTIMIZE STREQ UNSCHAR STRMERGE OBJNAME=ParsePCHGr.o $*

ParsePCHG.o: ParsePCHG.c
     sc NOSTKCHK OPTIMIZE STREQ UNSCHAR STRMERGE OBJNAME=ParsePCHG.o $*

SHAM2PCHGr.o: SHAM2PCHG.c
     sc  PARMS=REG NOSTKCHK OPTIMIZE STREQ UNSCHAR STRMERGE OBJNAME=SHAM2PCHGr.o $*

SHAM2PCHG.o: SHAM2PCHG.c
     sc  NOSTKCHK OPTIMIZE STREQ UNSCHAR STRMERGE OBJNAME=SHAM2PCHG.o $*

FastDecomp.o: FastDecomp.a
     asm -u $*

BuildFreqTable.o: BuildFreqTable.a
     asm -u $*

Autodoc:
     autodoc >PCHGLib.doc -I -C -s PCHGLib.c HuffComp.c SetUserCopList.c ParsePCHG.c SHAM2PCHG.c FastDecomp.a BuildFreqTable.a

docs:
     tex PCHG.texinfo
     tex PCHG.texinfo
     dvips -t a4 PCHG
     makeinfo --amiga --fill-column 77 PCHG.texinfo
     makeinfo --amiga --no-headers --fill-column 77 --output PCHG.doc PCHG.texinfo

archive:
		-delete PCHGLib1?.lha
		lha a PCHGLib14\
			Makefile\
			BuildFreqTable.a\
			FastDecomp.a\
			HuffComp.c\
			ParsePCHG.c\
			PCHGLib.c\
			pchglib.doc\
			pchgr.lib\
			SetUserCopList.c\
			SHAM2PCHG.c\
			cp:Mostra2V15.lha\
			cp:MakeVPort_Patch374.lha\
			SG:PCHG/LightHouse.mp\
			SG:PCHG/Lake.mp\
			PCHG.guide\
			pchg.lib\
			ToPCHG\
			ToPCHG.c\
			PCHG.dvi\
			PCHG.ps\
			PCHG.texinfo\
			README
		lha -x a PCHGLib14\
			include/clib/pchglib_protos.h\
			include/iff/PCHG.h\
