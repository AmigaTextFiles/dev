/* ------------------------------------------------------------------
    LABEL.C -- symbol table module for the A6 cross assembler
     This is free software, please see the file
     "COPYING" for copyright and licence details
   ------------------------------------------------------------------ */

#include <stdlib.h>
#include <stdio.h>

#include "asmfile.h"
#include "conf.h"
#include "error.h"
#include "label.h"
#include "global.h"
#include "outf.h"
#include "ustring.h"

/*-----------------------------------------------------------------*/
/* Global variables */

int labelsused=0;

/*@null@*/struct label* head=0;

struct label* lbl_index[128];

/*-----------------------------------------------------------------*/
/* Locale stack and other such things */
#define MAXLOCALENEST (32)
unsigned int localestack[MAXLOCALENEST];
unsigned int localestacksize=0;

unsigned int currentlocale=0;
unsigned int nextlocale=1;

/*-----------------------------------------------------------------*/
/* lbl_init -- setup for pass 1 */
void lbl_init(void)
{
	int i;

	for(i=32;i<127;i++) {
		lbl_index[i]=(void *)0;
	}
}

/*-----------------------------------------------------------------*/
/* lbl_reset -- reset for pass 2 */
void lbl_reset(void)
{
	int i;

	nextlocale=1; currentlocale=localestacksize=0;

	for(i=0;i<32;i++) {
		localestack[i]=0;
	}
}

/*-----------------------------------------------------------------*/
/* lbl_getptr -- used by lbl_define and others */
/*@null@*/struct label *lbl_getptr(char *lbl,unsigned int scope)
{
	struct label* temp; char c;

	temp=head;

	/* Check for global scope */
	if(*lbl=='!') {
		lbl++;
		scope=0;
	}

	c=*lbl;

	/* Check the index */
	if((temp=lbl_index[(int)c])==0)
		return(0);

	/* Find the label */
	while((temp!=0) && *(temp->name)==c) {
		#ifdef DEBUG
		printf("lbl_getptr: %p %s %u %u\n",temp,temp->name,temp->locale,temp->value);
		#endif

		if(((temp->locale == scope) || (temp->locale == 0)) && (strcmp(lbl,temp->name)==0)) {
			return(temp);
		}
		temp=temp->next;
	}

	return(0);
}

/*-----------------------------------------------------------------*/
/* lbl_define */
int lbl_define(char *z,unsigned int val,unsigned int lbltype)
{
	/*@null@*/struct label *temp;
	struct label *newlbl;
	struct label *prev;
	int i,j;
	unsigned int requiredlocale=currentlocale;

	/* Do we want the global version */
	if(z[0]=='!') {
		requiredlocale=0;
		z++;
		temp=lbl_getptr(z,0);
	} else {
		temp=lbl_getptr(z,currentlocale);
	}

	/* Check for PC re-assignment */
	if(z[0]=='*') {
		if(outf_getpc()==0)	/* Never assigned, just do it */
			outf_setpc(val);
		else {		/* Check re-assigned at same place */
			if(outf_getpc()>val)
				error("current pc counter (*) exceeds new!",ERR_PASS2);
			else
				while(outf_getpc()<val)
					outf_wbyte(0xea);
		}

		return 0;
	}

	/* Is it a variable that's already defined? */
	if((temp!=0) && (lbltype==LBL_VARIABLE)) {
		if(temp->line==0) {
			temp->value=val;
			return(0);
		} else {
			errors("label `%s' is not a variable",z,ERR_PASS1);
			return(-1);
		}
	}

	/* Not a variable redefinition -- define it */
	if(g_pass>0) {
		/* Pass 2 - do some checking */
		if(temp==0)
			if(z[1]=='\0' && (z[0]=='a' || z[0]=='A')) {
				error("'A' is a reserved label",0);
				return(-1);
			} else
				/* FATAL ERROR if not defined */
				errors("label `%s' unknown (internal error)",z,ERR_FATAL);

		/* Test for double-define (variable?) */
		if(temp->line != af_line() || temp->filename != af_name()) {
			/* double-definition is reported in pass 1 */
			return(0);
		}

		/* Otherwise, check synchronisation */
		if(lbltype==LBL_SYNCPC) {
		        #ifdef DEBUG
		        printf("checking sync: label=%u, *=%u\n",temp->value,outf_getpc());
			#endif

			/* Check we're at the same place as pass 1 */
			if(outf_getpc()>temp->value)
				error("object code overflow",ERR_FATAL);

			while(outf_getpc()<temp->value)
				outf_wbyte(0xea); /* NOP */
		}

		/* That should cover it... */
		return(0);
	} else {
		/* Pass 1 - define this thing */
		if((temp!=0) && temp->locale!=requiredlocale) temp=0;

		/* Already defined? */
		if(temp!=0) {
			errors("label `%s' defined twice",z,0);
			return(-1);
		}

		/* Check it isn't "a" */
		if(z[1]=='\0' && (z[0]=='a' || z[0]=='A')) return(-1);

		newlbl=malloc(sizeof(struct label));

		if(newlbl==0) {
			fprintf(stderr,"out of memory -- a6 terminated (lbl_define)\n");
			exit(EXIT_FAILURE);
		}

		newlbl->name=newstring(z);
		newlbl->value=val;
		newlbl->locale=requiredlocale;
		newlbl->filename=af_name();

		/* Check whether to put the line number in */
		if(lbltype==LBL_VARIABLE)
			newlbl->line=0;
		else
			newlbl->line=af_line();

		/* Find insert point */
		if(head) {
			temp=head; prev=0; i=1;

			while(temp!=0 && i!=0) {
				j=strcmp(temp->name,z);

				/* Next name is > requested, insert here */
				if(j>0) i=0;

				/* Same name, this is older scope, insert before temp */
				if(j==0 && (temp->locale < currentlocale)) i=0;

				/* Otherwise, onward */
				if(j<0) {
					prev=temp;
					temp=temp->next;
				}
			/* This loop terminates at end of labels */
			}

			/* If no previous label, this is head of list */
			if(prev)
				prev->next=newlbl;
			else
				head=newlbl;
			newlbl->next=temp;

			/* Print some debug info */
			#ifdef DEBUG
				printf("***label defined***\n");
				if(prev)
					printf("previous label: %s (%u %u)\n",prev->name,prev->locale,prev->value);
				else
					printf("inserted at head of list\n");
				printf("new label: %s (%u %u)\n",newlbl->name,newlbl->locale,newlbl->value);
				if(temp)
					printf("next label: %s (%u %u)\n",temp->name,temp->locale,temp->value);
				else
					printf("inserted at tail of list\n");
				printf("***end of label definition***\n\n");
			#endif
		} else {	/* Special case -- first label */
			head=newlbl;
			head->next=0;
                        #ifdef DEBUG
			printf("***label defined***\n");
			printf("new label: %s (%u %u)\n",newlbl->name,newlbl->locale,newlbl->value);
			printf("only label\n***end of label definition***\n\n");
			#endif
		}

		/* Insert into the index */
		if(lbl_index[(int)*z]) {
			if(newlbl->next == lbl_index[(int)*z])
				lbl_index[(int)*z]=newlbl;
		} else
			lbl_index[(int)*z]=newlbl;

		/* Defined okay -- return 0 */
		return(0);
	}
}

/*-----------------------------------------------------------------*/
/* lbl_getval doesn't call error because it's used internally */
long lbl_getval(char *lbl)
{
	struct label *temp;

	/* Check for pc counter */
	if(lbl[0]=='*' && lbl[1]=='\0') return((long)outf_getpc());

	/* Get the pointer */
	temp=lbl_getptr(lbl,currentlocale);

	/* Return the value */
	if(temp) {
		return((long)temp->value);
	} else {
		return(-1);
	}
}

/*-----------------------------------------------------------------*/
/* Enter locale */
int lbl_enterlocal(void)
{
	if(localestacksize==MAXLOCALENEST)
		error("too many local nestings",ERR_FATAL);

	if(nextlocale==32000)
		error("maximum number of localities reached (32,000!!!)\n",ERR_FATAL);

	localestack[localestacksize++]=currentlocale;
	currentlocale=nextlocale++;
	return(0);
}

/*-----------------------------------------------------------------*/
/* Exit current locale */
long lbl_exitlocal(void)
{
	if(localestacksize==0) return(-1);	/* Still global... */

	return((long)(currentlocale=localestack[--localestacksize]));
}

/*-----------------------------------------------------------------*/
/* Return number of current locale */
unsigned int lbl_getlocale(void)
{
	return(currentlocale);
}

/*-----------------------------------------------------------------*/
/* Dump symbol table */
void lbl_dumpsym(void)
{
	struct label *temp;
	unsigned int count;
	char labelname[65];


	printf("Symbols defined:\n\n" \
		"Label                            Value Line  File\n" \
		"-----                            ----- ----  ----\n");

	currentlocale=0;

	while(currentlocale<nextlocale) {

	count=0;
	temp=head;

		while(temp) {
			if(temp->locale==currentlocale) {
				if(count++==0)
					printf("\n***Locale %u\n",currentlocale);

				sprintf(labelname,"%s                               ",temp->name);
				labelname[32]='\0';

				printf("*%s* %5s ",labelname,tohex(temp->value));

				if(temp->line==0)
					printf("---- %s\n",temp->filename);
				else
					printf("%4u %s\n",temp->line,temp->filename);
			}
			temp=temp->next;
		}

	if(count>0)
		printf(" (%u symbols)\n",count);

	currentlocale++;
	}

}

/*-----------------------------------------------------------------*/
/* Destroy all labels */
void lbl_destroy(void)
{
	struct label *temp;

	while(head) {
		temp=head->next;
		free(head->name);
		free(head);
		head=temp;
	}
}
