# Makefile per cross-compiler per z80
# realizzato per lo gnu c

cflag =-O2
objects = c_z80.o c_z1.o c_z2.o c_z3.o c_zf.o

# target
c_z80 : $(objects)
   gcc $(cflag) -o c_z80 $(objects)

# modules 
c_z80.o : c_z80.c
   gcc $(cflag) -c c_z80.c
   
c_z1.o : c_z1.c c_z80.h
   gcc $(cflag) -c c_z1.c

c_z2.o : c_z2.c c_z80.h
   gcc $(cflag) -c c_z2.c

c_z3.o : c_z3.c c_z80.h
   gcc $(cflag) -c c_z3.c

c_zf.o : c_zf.c c_z80.h
   gcc $(cflag) -c c_zf.c


