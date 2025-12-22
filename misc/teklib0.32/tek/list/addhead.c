
#include "tek/list.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	void TAddHead(TLIST *list, TNODE *node)
**
**	add node at head of list
*/

TVOID TAddHead(TLIST *list, TNODE *node)
{
	TNODE *temp = list->head;
	list->head = node;
	node->succ = temp;
	node->pred = (TNODE *) &list->head;
	temp->pred = node;
}
