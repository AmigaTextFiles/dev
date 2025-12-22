#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "error.h"

void fatal_error(char *error, ...)
{
   va_list argptr;

   va_start (argptr,error);
   printf("Error: ");
   vprintf (error,argptr);
   va_end (argptr);
   printf("\n");
   exit (1);
}

void error_printf(char *error, ...)
{
   va_list argptr;

   va_start (argptr,error);
   printf("Error: ");
   vprintf (error,argptr);
   va_end (argptr);
   printf("\n");
}

FILE *infostream=0L;
void closeinfo(void);

void info_printf(char *error, ...)
{
/*	va_list argptr;

	if(!infostream)
	{
		infostream=fopen("CON:////LoadElfWOS Output","w");
		atexit(closeinfo);
	}

	va_start (argptr,error);
	vfprintf (infostream,error,argptr);
	va_end (argptr);*/
}

void closeinfo(void)
{
	if(infostream)
		fclose(infostream);
}
