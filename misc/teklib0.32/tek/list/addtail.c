
#include "tek/list.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	void TAddHead(TLIST *list, TNODE *node)
**
**	add node at tail of list
**
*/

void TAddTail(TLIST *list, TNODE *node)
{
	TNODE *temp = list->tailpred;
	list->tailpred = node;
	node->succ = (TNODE *) &list->tail;
	node->pred = temp;
	temp->succ = node;
}
