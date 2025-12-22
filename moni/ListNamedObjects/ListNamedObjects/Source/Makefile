# File: Makefile

MAKEFILE = Makefile
CC = gcc -msmall-code -O2 -ansi
ASSEMBLER = as
LINKER = ld -e _Main -s
AMIGA_LIB = GG:lib/libamiga.a

COMMAND = ListNamedObjects


$(COMMAND): %: %.c startup.o $(MAKEFILE)
	$(CC) -c "$@.c"
	$(LINKER) "startup.o" "$@.o" "$(AMIGA_LIB)" -o "$@"

startup.o: startup.s $(MAKEFILE)
	$(ASSEMBLER) "startup.s" -o $@

install: $(COMMAND)
	Copy "$(COMMAND)" "C:" CLONE

clean:
	Delete "$(COMMAND)" "#?.o"

