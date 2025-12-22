
#include "tek/list.h"

/*
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TNODE *TRemTail(TLIST *list)
**
**	unlink node from tail of list
**
*/

TNODE *TRemTail(TLIST *list)
{
	TNODE *temp, *node;

	temp = list->tailpred;
	node = temp->pred;
	if (node)
	{
		list->tailpred = node;
		node->succ = (TNODE *) &list->tail;
		return temp;
	}
	return node;
}
