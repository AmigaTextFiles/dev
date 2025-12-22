/* ------------------------------------------------------------------
    ASSEMBLE.C -- main assembly section for A6
     This is free software, please see the file
     "COPYING" for copyright and licence details
   ------------------------------------------------------------------ */

/* Main assembly/macro stuff */

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "asmfile.h"
#include "error.h"
#include "label.h"
#include "global.h"
#include "outf.h"
#include "psop.h"
#include "pspop.h"
#include "psexpr.h"
#include "ustring.h"

/* parseline -- parses a line.  Returns 0 when all lines done. */
int parseline(void)
{
	char *line;
	char *label; char *opcode; char *expr;

	#ifdef DEBUG
	printf("parseline entered\n");
	fflush(stdout);
	#endif

	line=af_getline();

	/*---------------------------------------------------------*/
	/* Check for EOF */
	if(line==0)
		if(af_close)
			return(0);
		else
			return(1);

	/*---------------------------------------------------------*/
	/* Find comment and remove it */
	label=strchr(line,';');
	if(label)
		*label='\0';

	/*---------------------------------------------------------*/
	/* Check for label, first of all */
	if((isalpha(*line)) || (*line=='_') || (*line=='!') || (*line=='*')) {
		label=line;

		/* Find end of label */
		opcode=line+1;

		while(isalnum(*opcode) || (*opcode=='_') || (*opcode=='.') || (*opcode=='$'))
			opcode++;

		expr=opcode;

		while(isspace(*opcode))
			opcode++;

		/* Syncpc definition? */
		if(*opcode=='\0') {
			lbl_define((char *)rtrim(label),outf_getpc(),LBL_SYNCPC);
			return(1);
		}

		/* Variable definition? */
		if(*opcode==':' && opcode[1]=='=') {
			expr[0]='\0';
			lbl_define((char *)rtrim(label),(unsigned int)parseexpr((char *)opcode+2),LBL_VARIABLE);
			return(1);
		}

		/* Label definition? */
		if(*opcode=='=') {
			expr[0]='\0';
			lbl_define(label,(unsigned int)parseexpr((char *)opcode+1),LBL_NONE);
			return(1);
		}

		/* Okay, this is a syncpc definition */
		expr[0]='\0';

	} else {
		/* What do we do if there's no label to define? */
		label=0;

		opcode=line;

		while(isspace(*opcode))
			opcode++;
	}

	/*---------------------------------------------------------*/
	/* Opcode now points to the beginning of the second field
	   so we need to find the first space after it. */

	/* Return okay if nothing left to do */
	if(*opcode=='\0')
		return(1);

	/* PC redefinition? */
	if(*opcode=='*' && opcode[1]=='=') {
		lbl_define("*",(unsigned int)parseexpr((char *)opcode+2),LBL_NONE);
		return(1);
	}

	expr=opcode;

	while(*expr!='\0' && !isspace(*expr))
		expr++;

	/* label[end]=Zero byte and advance expr to next non-space */
	*expr++='\0';

	while(isspace(*expr))
		expr++;

	/* Define the label as a syncpc if necessary */
	if(label)
		lbl_define((char *)rtrim(label),outf_getpc(),LBL_SYNCPC);

	/* do we have an expression? */
	if((*expr)=='\0')
		expr="";

	if(opcode[0]=='.')
		parsepop((char *)opcode+1,expr);
	else
		parseopcode(opcode,expr);

	return 1;
}
