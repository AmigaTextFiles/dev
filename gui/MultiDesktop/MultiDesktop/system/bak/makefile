sys: syslib.o system.o
 ln -o sys syslib.o system.o +q -lcl32
 copy sys LIBS:multisystem.library

syslib.o: syslib.asm
 as syslib.asm -C -D -N

system.o: system.asm
 phxass system.asm -mf

