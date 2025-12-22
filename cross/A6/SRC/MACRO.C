/* MACRO.C */

#include <stdio.h>

#include "error.h"
#include "ustring.h"

FILE *tempfile;

struct macro {
	char *name;
	int length;
	int tempfilepos;
	struct macro *next;
};

struct macro *head=0;

int inmacro=0;

/* Do the macro and conditional assembly stuff in here */

/* Define macro - pass stuff through to macro temp file until stated */
void mac_define(char *name,char *expr)
{
	struct macro mactmp;
	int i=1;

	mactmp->name=newstring(name);

	if(tempfile==0) {
		tempfile=fopen(tmpnam(),"r+b");
		if(tempfile==0)
			error("can't open temp file for macro cache",ERR_FATAL);
	}

	fseek(tempfile,0,SEEK_EOF);
	mactmp->tempfilepos=ftell(tempfile);

	
}

/* Expand macro */
void mac_expand(char *name,char *expr)
{
}

/* Get next macro line */
void mac_getline()
{
	if(!inmacro)
		return(0);

	
}

/* Conditional assembly */
void mac_cond(int cond_type,char *expr)
{
}
