LC = lc:lc
ASM = lc:asm
FLAGS = -iINCLUDE: -b0 -d0 -v
ASMFLAGS = -iINCLUDE:
LINK = lc:blink
LIB = lib:amiga.lib+lib:lc.lib
OBJ = printertag.o+init.o+data.o+dospecial.o+render.o+transfer.o
TARGET = Xerox_4020

.c.o:
   @$(LC) $(FLAGS) $*

$(TARGET): printertag.o init.o data.o dospecial.o render.o transfer.o
   @$(LINK) <WITH <
   FROM $(OBJ)
   TO $(TARGET)
   LIBRARY $(LIB)
   NODEBUG SC SD VERBOSE MAP $(TARGET).map H
   <

init.o: init.asm
   @$(ASM) $(ASMFLAGS) init.asm

printertag.o: printertag.asm xerox_4020_rev.i
   @$(ASM) $(ASMFLAGS) printertag.asm

transfer.o: transfer.c

dospecial.o: dospecial.c

data.o: data.c

render.o: render.c

install:
   @copy $(TARGET) to devs:printers
