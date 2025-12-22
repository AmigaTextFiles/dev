gcc -o 6502asm 6502asm.c
6502asm -F rom -A -0xffff -O bootloader.img bootloader.asm

