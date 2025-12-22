
colors : colors.o
	blink lib:c.o colors.o //src/ez.lib LIB lib:lc.lib lib:amiga.lib

colors.o : colors.c
	lc colors.c
