/* ------------------------------------------------------------------
    ERROR.C -- error reporting module for the A6 cross assembler
     This is free software, please see the file
     "COPYING" for copyright and licence details
   ------------------------------------------------------------------ */

#include <stdio.h>
#include <stdlib.h>

#include "asmfile.h"
#include "error.h"
#include "global.h"

/* Cope with non-ANSI stdlib.h */
#ifndef EXIT_FAILURE
#define EXIT_FAILURE (int)g_errorcount+1
#endif

void errors(char *txt,char *s,int fatal)
{
	char *t=malloc((strlen(s)+strlen(txt)+1)*sizeof(char));

	if(t) {
		sprintf(t,txt,s);
		error(t,fatal);
		free(t);
	} else {
		fprintf(stderr,"out of memory -- a6 stopped.\n");
		exit(EXIT_FAILURE);
	}
}

void error(char *txt,int fatal)
{
	char *w="error";

	if(fatal>0) {
		switch(fatal) {
			case ERR_PASS1:
				if(g_pass>0) return;
				break;
			case ERR_PASS2:
				if(g_pass==0) return;
				break;
			case ERR_WARNING:
			        if(g_pass>0) return;
				w="warning";
				break;
			case ERR_FATAL:
				w="fatal";
				break;
		}
	}

	if(fatal!=ERR_WARNING)
		g_errorcount++;

	af_printforerror();

	printf("%s %u: %s: %s\n",af_name(),af_line(),w,txt);

	if(fatal==ERR_FATAL) {
		printf("assembly stopped: fatal error\n");
		exit(EXIT_FAILURE);
	}
}
