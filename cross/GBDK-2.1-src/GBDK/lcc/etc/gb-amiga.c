/* DOS */

#ifndef LCCDIR
#define LCCDIR "GBDK:"
#endif

#include <string.h>

char *suffixes[] = { ".c", ".i", ".s;.asm", ".o;.obj", ".gb", 0 };
char inputs[256] = "";
char *cpp[] = { LCCDIR "bin/cpp",
	"-DINT_8_BITS", "-D__STDC__=1", "-DZ80",
#ifdef GAMEBOY
	"-DGB", "-DGAMEBOY",
#endif
	"$1", "$2", "$3", 0 };
char *include[] = { "-I" LCCDIR "include", 0 };
char *com[] = { LCCDIR "bin/rcc",
#ifdef GAMEBOY
	"-target=gbz80/int8",
#else
	"-target=z80/int8",
#endif
	"-optimize", "$1", "$2", "$3", 0 };
char *as[] = { LCCDIR "bin/asGB", "-o", "$1", "$3", "$2", 0 };
char *ld[] = { LCCDIR "bin/linkGB", "-n", "--",
#ifdef GAMEBOY
	"-z",
#else
	"-i",
#endif
	"$1", "-k" LCCDIR "lib",
#ifdef GAMEBOY
	"-lgb.lib",
#else
	"-lz80.lib",
#endif
	"$3", LCCDIR "lib/crt0.o", "$2", 0 };

extern char *concat(char *, char *);

int option(char *arg) {
	if(strncmp(arg, "-lccdir=", 8) == 0) {
		int lastchar;
		char *path;
		lastchar = strlen(arg) - 1;
		if((arg[lastchar] == ':') ||
		   (arg[lastchar] == '/'))
			path = &arg[8];
		else
			path = concat(&arg[8], "/");

		cpp[0] = concat(path, "bin/cpp");
		include[0] = concat("-I", concat(path, "include"));
		com[0] = concat(path, "bin/rcc");
		as[0] = concat(path, "bin/asGB");
		ld[0] = concat(path, "bin/linkGB");
		ld[5] = concat("-k", concat(path, "lib"));
		ld[8] = concat(path, "lib/crt0.o");
	} else if(strcmp(arg, "-int8") == 0) {
		cpp[1] = "-DINT_8_BITS";
#ifdef GAMEBOY
		com[1] = "-target=gbz80/int8";
#else
		com[1] = "-target=z80/int8";
#endif
	} else if(strcmp(arg, "-int16") == 0) {
		cpp[1] = "-DINT_16_BITS";
#ifdef GAMEBOY
		com[1] = "-target=gbz80/int16";
#else
		com[1] = "-target=z80/int16";
#endif
	} else
		return 0;
	return 1;
}
