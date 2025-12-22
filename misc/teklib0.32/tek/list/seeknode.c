
#include "tek/list.h"

/*
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TNODE *TSeekNode(TNODE *node, TINT steps)
**
**	starting at the given node, seek in the list by
**	a given number of steps, and return the node
**	reached, or TNULL if seeked past end or before start
**
*/

TNODE *TSeekNode(TNODE *node, TINT steps)
{
	TNODE *nextnode;

	if (steps > 0)
	{
		while ((nextnode = node->succ))
		{
			if (steps-- == 0)
			{
				return node;
			}

			node = nextnode;
		}

		return TNULL;
	}
	else if (steps < 0)
	{
		while ((nextnode = node->pred))
		{
			if (steps++ == 0)
			{
				return node;
			}

			node = nextnode;
		}
		return TNULL;
	}
	
	return node;
}
