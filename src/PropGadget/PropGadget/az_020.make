: A man should be ashamed to die unless he has won at least one battle
: for humanity.                                           Horace Mann
:
:           Jerry J. Trantow
:           1560 A East Irving Place
:           Milwaukee, Wi 53202-1460
:
:  This is a Aztec Make file for the PropGadget Example
:  This version will only run with an 020, (881 doesn't matter)
:  Special Thanks to Brad Fowles whose LUCAS project make this possible
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
COMPILE:PropGadget_A020 : ex.o mult020.o div020.o add.o 
  ln +cdb -o COMPILE:PropGadget_A020 ex.o add.o mult020.o div020.o c.lib

ex.o : ex.c struct.inc clean2.inc prop.inc
  cc -Dmachine=MC68020 ex.c
add.o     : add.asm
  as   add.asm
mult020.o : mult020.asm
  as   mult020.asm
div020.o   : div020.asm
  as   div020.asm
