# Makefile


#
# define some compilers and flags
#
AS=phxass
AFLAGS=NOEXE I=include:

LINK=slink
LFLAGS1=AsmStartup/Astartup.o
LFLAGS2=lib lib:amiga.lib AmigavisionsLib/amigavisions.lib sc sd nd

DELETE=Delete


#
# object files
#
OBJ=Main.o TestPar.o Load_SFile.o Reloc_SFile.o


#
# executeable files
#
EXE=Reloc


#
# main part of Makefile
#
$(EXE): $(OBJ)
	make -C AsmStartup
	make -C AmigavisionsLib
	$(LINK) from $(LFLAGS1) $(OBJ) to $(EXE) $(LFLAGS2)
	$(DELETE) $(OBJ)

Main.o: Main.a
	$(AS) $(AFLAGS) Main.a

TestPar.o: TestPar.a
	$(AS) $(AFLAGS) TestPar.a

Load_SFile.o: Load_SFile.a
	$(AS) $(AFLAGS) Load_SFile.a

Reloc_SFile.o: Reloc_SFile.a
	$(AS) $(AFLAGS) Reloc_SFile.a
