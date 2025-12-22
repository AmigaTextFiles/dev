all: RawIO2Parallel RawIOEcho

# The order of the files given to the compiler is important as this order
# will be kept in the resulting executable.
# The file containing the startup function must be first as AmigaOS simply
# starts executing from the start of the first hunk. Then to make it as
# efficient as possible to load this as a resident, the Resident structure
# is placed next, followed by the actual code for the patch and then ending
# it with an empty function used to point/skip to the end in Resident
# structure.
RawIO2Parallel: Startup.c Resident.c ResidentInit.c RawIO2Parallel.c Parallel.asm ResidentEnd.c ResidentInit.h RawIO2Parallel.h Parallel.h ResidentEnd.h NDK3.2 Makefile
	vc +allaos68k -D__NOLIBBASE__ -nostdlib -c99 -O1 -sc -lamiga -lddebug -o $@ Startup.c Resident.c ResidentInit.c RawIO2Parallel.c Parallel.asm ResidentEnd.c

RawIOEcho: RawIOEcho.c MinimalDebug.c MinimalDebug.h NDK3.2 Makefile
	vc +allaos68k -D__NOLIBBASE__ -nostdlib -c99 -O1 -sc -o $@ $< MinimalDebug.c

NDK3.2: NDK3.2.lha
	lha x -w=$@ $<
	touch $@

NDK3.2.lha:
	wget aminet.net/dev/misc/$@ -O $@

clean:
	$(RM) RawIO2Parallel RawIOEcho

