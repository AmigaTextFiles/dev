:  There is a time in the affairs of men, which taken at the flood 
:  leads on to fame and fortune.                        Julius Caesar (Act IV)
:
:           Jerry J. Trantow
:           1560 A East Irving Place
:           Milwaukee, Wi 53202-1460
:
:  This is a Aztec Make file for the PropGadget Example
:
:  assign COMPILE: to where the executable file should go
:
: example.c   contains the main program
: struct.inc  contains the gadget and IntuiText Structures
: clean2.inc  contains the routines to close everything and exit
: prop.inc    conþains the functions which manipulate the proportional Gadgetry
: div020.asm  is my Quad division routine (assembly)
: mutl020.asm is my Quad Multiplication routnine (assembly)
:  

COMPILE:PropGadget_A000 : ex.o mult.o div.o add.o Aztec.make 
  ln +cdb -o COMPILE:PropGadget_A000 ex.o add.o mult.o div.o c.lib

ex.o : ex.c struct.inc clean2.inc prop.inc
  cc  ex.c
add.o     : add.asm
  as   add.asm
mult.o : mult.asm
  as   mult.asm
div.o   : div.asm
  as   div.asm
