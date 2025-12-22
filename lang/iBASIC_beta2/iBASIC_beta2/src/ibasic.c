/*
**  ibasic.c - a very basic BASIC interpreter
**  Original Author: JERRY WILLIAMS JR
**
**  ported to Amiga by Micha B. 05/2023
*/
#include <stdio.h>
#include "ibasic.h"

char *vers="\0$VER: iBASIC 1.0 (07.05.2023)";

PRINTS_()
{
puts((char*)*sp++); STEP;
}

/* ------------------------------------------------------------------------ */

kwdhook_(char *msg)
{
if (!strcmp(msg,"PRINTS"))
expr(), emit(PRINTS_);
else	return 0;
return 1;
}

/* ------------------------------------------------------------------------ */

main(int argc, char **argv) 
{
FILE *sf=stdin;
initbasic(0);
kwdhook=kwdhook_;

printf("%s", White);
puts("\f================================================");
puts("= iBASIC v1.0 - a very basic BASIC interpreter =");
puts("= based on \"basic.c\" for UNIX by               =");
puts("= JERRY WILLIAMS JR.                           =");
puts("=                                              =");
puts("= ported and ehanced for Amiga by Micha B.     =");
puts("================================================\n");
printf("%s", Black);
printf("%s", Reset);

if (strlen(argv[1]) == 0) 
{

	printf("%s", Bold);
	puts("TEMPLATE: iBASIC <source>");
	printf("%s", Italic);
	puts("No BASIC source was loaded!\n");
	printf("%s", Bold);
	puts("Type 'HELP' for help");
	puts("Type 'BYE' for exit\n");
	printf("%s", Reset);
}
else 
{

	printf("%s", Bold);
	puts("Type 'HELP' for help");
	puts("Type 'BYE' for exit\n");
	printf("%s", Reset);
}

if (argv[1])
    if (sf=fopen(argv[1],"r"))
        compile++;
else 
{
	printf("CANNOT OPEN: %s\n", argv[1]);
	printf("\n%s", Reset);
	return 255;
}

printf("\n%s", Reset);

return interp(sf);
}


