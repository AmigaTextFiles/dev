pascal source/$_passed.p $_passed.s
peep $_passed.s $_passed.asm
a68k $_passed.asm object/$_passed.o
del $_passed.asm
del $_passed.s
