#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symtab.h"
#include "abstract.h"
#include "misc.h"

//----------------------------------------------
// newABSTRACT
//
//	creates a new ABSTRACT object
//
//----------------------------------------------

ABSTRACT *newABSTRACT(void)
{
	ABSTRACT *pA = malloc(sizeof(ABSTRACT));
	pA->etype = NULL;
	pA->type = NULL;
	return pA;
}

//----------------------------------------------
// discardABSTRACT
//
//	free memory allocated for an ABSTRACT object
//
//	parameter:
//	pA........pointer to ABSTRACT object to free
//----------------------------------------------

void discardABSTRACT(ABSTRACT *pA)
{
	free(pA);
}

//---------------------------------------------
// AbstractAddDeclarator
//
//	And a link object to the end of an ABSTRACT
// object chain
//
// parameter:
//	d......pointer to the link object to add to a chain
//
//---------------------------------------------

void AbstractAddDeclarator(ABSTRACT *pA,struct link *d)
{
	link *end;

	if(d == NULL)
	{
		fprintf(stderr,"ERROR: NULL Link pointer\n");
		exit(1);
	}
	if(pA == NULL)
	{
		fprintf(stderr,"ERROR:Null abstract pointer\n");
		exit(1);
	}
	//first, find end of declarator chain, if there is one
	end = d;
	while(end->next != NULL)
		end=end->next;
	if(pA->type == NULL)
	{
		pA->type = d;
		pA->etype = end;
	}
	else
	{
		end->next = pA->type;
		pA->type = d;
	}
	fprintf(stderr,"***Exit Add Declarator***\n");
}

ABSTRACT *AbstractBuildDeclarator(ABSTRACT *pA,int dectype, int nele, struct symbol *s)
{
	/*	this function is similar to add_declarator except it is copyright (c)
	** 1994 by Jim Patchell.  This is used to build a declarator chain.
	** in the C grammar I am using, we may not know what the symbol is
	** that the declartor productions are working on
	*/
	link *n;

	if(pA->type != NULL)
	{
		if(dectype == SYMTAB_FUNCTION && IS_ARRAY(pA->etype) )
		{
			yyerror("Array of functions is illegal, assuming function pointer\n");
			AbstractBuildDeclarator(pA,SYMTAB_POINTER,0,NULL);
		}
	}
	n = new_link();		/*	the default class is DECLARATOR	*/
	n->SYMTAB_DCL_TYPE = dectype;
	n->SYMTAB_NUM_ELE = nele;
	n->SYMTAB_ARGS = s;
	if(pA->type == NULL)	/*	create a new link list	*/
	{
		pA->type = n;
		pA->etype = n;
	}
	else
	{
		pA->etype->next = n;
		pA->etype = n;
	}
	return pA;
}

