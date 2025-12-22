
OBJS	= quittm.o alloctm.o freetm.o createtm.o deletetm.o changetm.o lvotm.o tmlib.o
ASM	= asm
#ASM	= BAsm

.asm.o:
	$(ASM) $*.asm

.c.o:
	sc $*.c STRMERGE UNSCHAR NOSTKCHK OPTIMIZE

tm.lib: $(OBJS)
	oml tm.lib r $(OBJS)
#	Copy tm.lib TO LIB: CLONE
