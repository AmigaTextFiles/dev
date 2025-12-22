static const char CfgLunix [] = 
"\n"/* ld65 Linker-configuration for LUnix, Next Generation. */
"MEMORY {\n"
"ZP:	start = $80, size = $40;\n"        /* userzp buffer */
"RAM: start = %S, size = $7600;\n"
"}\n"
"SEGMENTS {\n"
"ZEROPAGE: load = ZP,  type = zp,  define = yes;\n" /* Pseudo-registers */
"STARTUP:  load = RAM, type = wp;\n"	/* First initiation code */
"LOWCODE:  load = RAM, type = rw;\n"	/* Legacy from other platforms */
"CODE:     load = RAM, type = ro;\n"	/* Program */
"RODATA:   load = RAM, type = ro;\n"	/* Literals, constants */
"DATA:     load = RAM, type = rw;\n"	/* Initiated variables */
"BSS:      load = RAM, type = bss, define = yes;\n" /* Un-initiated variables */
"}\n"
"FEATURES {\n"
"CONDES: segment = RODATA,\n"
"type = constructor,\n"
"label = __CONSTRUCTOR_TABLE__,\n"
"count = __CONSTRUCTOR_COUNT__;\n"
"CONDES: segment = RODATA,\n"
"type = destructor,\n"
"label = __DESTRUCTOR_TABLE__,\n"
"count = __DESTRUCTOR_COUNT__;\n"
"}\n"
"FILES {\n"
"%O: format = o65;\n"
"}\n"
"FORMATS {\n"
"o65: os = lunix, type = small,\n"
"export = main,\n"	       	/* Program entry-point */
"\n"/* import = LIB6502,	# Shared-library entry-points */
"import = LUNIXKERNEL;\n"	/* Kernel entry-points */
"}\n"
"SYMBOLS {\n"
"__HEAPSIZE__  = $2000;\n"      /* 8k heap [temporary, until LUnix malloc() exists] */
"__STACKSIZE__ = $0400;\n"      /* 1k stack (do typical LUnix apps. need 2k?) */
"}\n"
;
