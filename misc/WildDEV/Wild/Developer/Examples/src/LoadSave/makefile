AS = genam 
ASFLAGS = WITH PyperWorks:Programs/Devpac/GenAmNoDebug.opts FROM 

CC  = gcc:bin/gcca
CFLAGS = -w

lnk = vlink -o

objects = entry.o startup.o LoadSave.o

out = ////Demos/Misc/LoadSave/LoadSave

$(out) : $(objects)
	$(lnk) $(out) $(objects) 
	
entry.o : entry.s
startup.o : startup.c
LoadSave.o : LoadSave.c

