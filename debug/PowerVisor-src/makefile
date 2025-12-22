#
# Assembler flags and linker flags for PowerVisor and related utilities
# make pv (is default)
# make pv13
# make powervisor.library
# make mstruct
# make mstruct13
#
af =
lf = NODEBUG
cf =
#
# The real make stuff
#
OBJS = pv_detach.o pv_main.o pv_general.o pv_memory.o pv_list.o pv_eval.o pv_debug.o pv_file.o pv_mmu.o pv_screen.o pv_arexx.o mondis.o myminrexx.o pv_revision.o pv_68030.o
OBJS13 = pv_detach.o13 pv_main.o13 pv_general.o13 pv_memory.o13 pv_list.o13 pv_eval.o13 pv_debug.o13 pv_file.o13 pv_mmu.o13 pv_screen.o13 pv_arexx.o13 mondis.o myminrexx.o pv_revision.o13 pv_68030.o

.asm.o:
	macro68 $*.asm -O $*.o $(af)

.asm.o13:
	macro68 $*.asm -O $*.o13 $(af)

#.s.o:
#	asm -iINCLUDEASM: -m2 $*.s

.c.o:
	sc $(cf) $*.c

pv: $(OBJS)
	slink from $(OBJS) to pv lib lib:amiga.lib lib:debug.lib $(lf)

pv13: $(OBJS13)
	slink from $(OBJS13) to pv13 lib lib:amiga.lib lib:debug.lib $(lf)

powervisor.library: pvLib.o
	slink from pvLib.o to powervisor.library $(lf)

#MStruct: MStruct.o ArgR.o
#	slink ArgR.o+MStruct.o to MStruct lib lib:sc.lib $(lf)
MStruct: MStruct.c
	sc $(cf) link MStruct
#ArgR.o: Arg.asm
#	asm -iINCLUDEASM: -dCLI -dRESIDENT -oArgR.o Arg.asm

MStruct13: MStruct13.o ArgR13.o
	slink ArgR13.o+MStruct13.o to MStruct13 lib lib:sc.lib $(lf)
MStruct13.o: MStruct13.c
	sc $(cf) MStruct13
ArgR13.o: Arg13.asm
	asm -iINCLUDEASM: -dCLI -dRESIDENT -oArgR13.o Arg13.asm
