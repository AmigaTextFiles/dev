
CC = vc68k
CCFLAGS =

OBJECTSa = entry.o startup.o ppctimagemapping.o
OBJECTSb = entry.o startup.o ppctimagemapping_useppc.o

LD = vlink -sc -sd -lStubs -o 

OUTa = ////demos/ppct/ppctimagemapping/PPCTImageMapping
OUTb = ////demos/ppct/ppctimagemapping/PPCTImageMapping_UsePPC

$(OUTa) : $(OBJECTSa) $(OBJECTSb) $(OUTb)
	$(LD) $(OUTa) $(OBJECTSa)

$(OUTb) : $(OBJECTSb)
	$(LD) $(OUTb) $(OBJECTSb)
	

