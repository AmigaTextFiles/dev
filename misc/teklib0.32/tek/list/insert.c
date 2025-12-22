
#include "tek/list.h"

/*
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	void TInsert(TLIST *list, TNODE *node, TNODE *prednode)
**
**	insert node after given node
**
*/

void TInsert(TLIST *list, TNODE *node, TNODE *prednode)
{
	TNODE *temp;

	if (prednode)
	{
		temp = prednode->succ;
		if (temp)
		{
			node->succ = temp;
			node->pred = prednode;
			temp->pred = node;
			prednode->succ = node;
		}
		else
		{
			node->succ = prednode;
			temp = prednode->pred;
			node->pred = temp;
			prednode->pred = node;
			temp->succ = node;
		}
	}
	else
	{
		temp = list->head;
		list->head = node;
		node->succ = temp;
		node->pred = (TNODE *) &list->head;
		temp->pred = node;
	}
}
