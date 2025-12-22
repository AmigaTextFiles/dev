/******************************************************************************

	The Integer Tree

	We want to store things whos comparison key is an integer value.

	add, remove, find	: LOG (n)

	sequentiall access	: RANDOM

******************************************************************************/

#include <stdio.h>

#include "inttree.h"

intTree::intTree ()
{
	cnt = 0;
	root = NULL;
	FoundSlot = NULL;
}

intNode::~intNode ()
{
	if (less) delete less;
	if (more) delete more;
}

intNode *intTree::intFind (unsigned int q)
{
	Query = q;

	intNode *n;

	if (!(n = root)) {
		FoundSlot = &root;
		return NULL;
	}

	FoundSlot = NULL;

	for (int bt = 1; bt; bt *= 2) {
		if (n->Key == q) return n;
		if (q & bt)
			if (n->less) n = n->less;
			else {
				FoundSlot = &n->less;
				return NULL;
			}
		else
			if (n->more) n = n->more;
			else {
				FoundSlot = &n->more;
				return NULL;
			}
	}

	fprintf (stderr, "intTree FUBAR. Segmentation Fault. sorry\n");
	return NULL;
}

intNode::intNode (intTree *i)
{
	if (i->FoundSlot) addself (i);

	less = more = NULL;
}

void intNode::addself (intTree *i)
{
	*i->FoundSlot = this;
	++i->cnt;
	i->FoundSlot = NULL;
	Key = i->Query;
}

void intNode::intRemove (intTree *i)
{
	int isroot, bt = 0;
	intNode *n = i->root;

	if (!(isroot = n == this))
		for (bt = 1; bt; bt *= 2)
			if (Key & bt)	// avoid braces like hell
				if (n->less != this) n = n->less;
				else break;
			else		// yes but why?
				if (n->more != this) n = n->more;
				else break;

	if (!less && !more)
		if (isroot) i->root = NULL;
		else
			if (Key & bt) n->less = NULL;
			else n->more = NULL;
	else {
		intNode *r = this, *rp = NULL;
		while (r->more || r->less) {
			rp = r;
			r = (r->more) ? r->more : r->less;
		}
		if (isroot) i->root = r;
		else
			if (Key & bt) n->less = r;
			else n->more = r;
		if (rp->more == r) rp->more = NULL;
		else rp->less = NULL;
		r->more = more;
		r->less = less;
	}
}
