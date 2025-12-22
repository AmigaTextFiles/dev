
#include "tek/list.h"

/*
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	void TRemove(TNODE *node)
**
**	unlink node from list
**
*/

TVOID TRemove(TNODE *node)
{
	TNODE *temp = node->succ;
	node = node->pred;
	node->succ = temp;
	temp->pred = node;
}
