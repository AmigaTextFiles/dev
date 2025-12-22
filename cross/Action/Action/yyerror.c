#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>

/* #define MAIN	*/

void yyerror(char *fmt,...)
{
	va_list arglist;

	va_start(arglist,fmt);
	vfprintf(stderr,fmt,arglist);
	va_end(arglist);
}

