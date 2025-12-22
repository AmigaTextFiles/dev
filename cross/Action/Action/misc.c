/*******************************************************
** Misc routines for the ACTION! compiler
** Created by Jim Patchell
** March 2010
*****************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symtab.h"
#include "misc.h"

CLIST* newCLIST(int v)
{
	CLIST *pCL = malloc(sizeof(CLIST));
	pCL->next = 0;
	pCL->v = v;
	return pCL;
}

CLIST* CLISTchain(CLIST *cl1, CLIST *cl2)
{
	//-------------------------
	// add a new element to the
	// end of a constant list 
	// ------------------------
	CLIST *pCL = cl1;

	while(pCL->next)
		pCL = pCL->next;
	pCL->next = cl2;
	return cl1;
}

int CLISTsize(CLIST *pCL)
{
	int retval = 0;
	while(pCL)
	{
		++retval;
		pCL = pCL->next;
	}
	return retval;
}

void ClistToDataBlock(DATABLOCK *pD, CLIST *pCL)
{
	int size = 0;
	CLIST *pC = pCL;
	int i;

	while(pC)	//count the number of elements
	{
		++size;
		pC = pC->next;
	}
	pD->size = size;
	pD->data = malloc(size);
	//copy data to new structure
	for(i=0,pC = pCL;i<size;++i,pC=pC->next)
		pD->data[i] = pC->v;
}

char *NewString(char *s)
{
	char *pS = malloc(strlen(s)+1);
	strcpy(pS,s);
	return pS;
}

symbol *AddSymbolToSymTab(int flag, symbol *pSym)
{
	symbol *pS = findsym( Symbol_tab, pSym->name );
	if((pS == NULL) && flag)	//not there, then add it
	{
//		printf("Add to symbol %s Table...\n",pSym->name );
		addsym( Symbol_tab, pSym  );
	}
	else if (flag)
		printf("*ERROR* Symbol %s already in table\n",pSym->name);
	return pSym;
}

void RemoveLocalsFromSymtab(HASH_TAB *pTab)
{
	//**********************************************
	// Global variables have a scoping level of 0
	// Local variables have a scoping level of 1
	// So, find alll of the variables that have a
	// scoping level of 1 and remove them from the
	// symbol table.
	//
	// paramter:
	//	pTab.....pointer to symbol table to check
	//*********************************************

	symbol *pSym;
	BUCKET *pB;
	int i;

	for(i=0;i < pTab->size;++i)
	{
		pB = pTab->table[i];
		while(pB)
		{
			pSym = (symbol *)(pB+1);
			if(pSym->level == 1)
			{
				//-----------------------------
				// remove symbol from table
				//-----------------------------
				pTab->numsyms--;
				if(  *(pB->prev) = pB->next  )
					pB->next->prev = pB->prev ;
				pB = pTab->table[i];
			}
			else
			{
				pB = pB->next;
			}
		}
	}
}

void MarkSymbolsAsLocal(symbol *s)
{
	while(s)
	{
		s->level = 1;
		s = s->next;
	}
}