
#include "tek/list.h"

/*
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TNODE *TRemHead(TLIST *list)
**
**	unlink node from head of list
**
*/

TNODE *TRemHead(TLIST *list)
{
	TNODE *temp, *node;
	
	temp = list->head;
	node = temp->succ;
	if (node)
	{
		list->head = node;
		node->pred = (TNODE *) &list->head;
		return temp;
	}
	
	return node;
}
