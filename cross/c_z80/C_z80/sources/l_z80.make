# makefile per linker per cross-compiler per z80 
# realizzato per lo gnu-c

cflag = -O2
objects = l_z80.o l_z1.o

# target
l_z80 : $(objects)
   gcc $(cflag) -o l_z80 $(objects)

# modules 
l_z80.o : l_z80.c
   gcc $(cflag) -c l_z80.c
   
l_z1.o : l_z1.c l_z80.h
   gcc $(cflag) -c l_z1.c

