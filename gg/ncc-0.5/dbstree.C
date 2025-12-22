/******************************************************************************
	dbstree.C 

	Dynamic Binary Search Tree used throughout the entire project.

	A dbsNode applied as a parent class to a specific class will provide
	transparent storage in a dbstree. As a result no duplicates may be
	stored and locating stored data is performed in less than 32 steps.

	Check dbstree.tex for technical information on this tree.

*****************************************************************************/

#include <stdio.h>
#include <assert.h>
#include "dbstree.h"

dbsTree::dbsTree ()
{
	nnodes = 0;
	root = NULL;
	FoundSlot = NULL;
}

/*
 * Balancing a binary tree. This happens whenever the height reaches 32.
 */
void dbsTree::tree_to_array (dbsNode *n)
{
	if (n->less) tree_to_array (n->less);
	*FoundSlot++ = n;
	if (n->more) tree_to_array (n->more);
}
void dbsTree::dbsBalance ()		// O(n)
{
	dbsNode **npp;
	unsigned long long i, j, k, D, Y, k2, k3;

	if (!root) return;

	npp = FoundSlot = (dbsNode**) alloca (sizeof (dbsNode*) * nnodes);
	tree_to_array (root);

	root = npp [nnodes / 2];
	for (D = nnodes + 1, i = 4; i <= D; i *= 2)
		for (j = 2; j < i; j += 4)
		{
			k3 = nnodes * j / i;
			npp [k3]->less = npp [nnodes * (j - 1) / i],
			npp [k3]->more = npp [nnodes * (j + 1) / i];
		}
	k = nnodes + 1 - (Y = i / 2);
	if (k == 0)
	{
		for (i /=2, j = 1; j < i; j += 2)
			k3 = nnodes * j / i,
			npp [k3]->less = npp [k3]->more = NULL;
		return;
	}

	for (j = 2; j < i; j += 4)
	{
		k3 = nnodes * j / i;
		D = (k2 = (j - 1) * nnodes / i) * Y % nnodes;
		if (D >= k || D == 0)
			npp [k3]->less = NULL;
		else
		{
			npp [k3]->less = npp [k2];
			npp [k2]->less = npp [k2]->more = NULL;
		}
		D = (k2 = (j + 1) * nnodes / i) * Y % nnodes;
		if (D >= k || D == 0)
			npp [k3]->more = NULL;
		else
		{
			npp [k3]->more = npp [k2];
			npp [k2]->less = npp [k2]->more = NULL;
		}
	}

	dbsNode *np;
	for (np = root; np->less; np = np->less);

	np->less = npp [0];
	npp [0]->less = npp [0]->more = NULL;
}

void dbsNode::addself (dbsTree *t)
{
	*t->FoundSlot = this;
	++t->nnodes;

	if (t->FoundDepth >= DBS_MAGIC)
		t->dbsBalance ();
	t->FoundSlot = NULL;	// Bug traper
}

dbsNode::dbsNode (dbsTree *t)
{
	less = more = NULL;

	if (t->FoundSlot) addself (t);
}

dbsNode::~dbsNode ()
{ }

/*
 */
void dbsTree::dbsRemove (dbsNode *t)		// O(log n)
{
	dbsNode *np, *nl, *nr, *nlp, *nrp;
	int isroot;
	unsigned int i, j;

	isroot = (np = t->myParent (this)) == NULL;

	--nnodes;

	if (!(t->less && t->more))
	{
		if (isroot)
			root = (t->less) ? t->less : t->more;
		else
			if (np->less == t)
				np->less = (t->less) ? t->less : t->more;
			else
				np->more = (t->less) ? t->less : t->more;
		return;
	}

	for (i = 0, nlp = NULL, nl = t->less; nl->more; i++)
		nlp = nl, nl = nl->more;
	for (j = 0, nrp = NULL, nr = t->more; nr->less; j++)
		nrp = nr, nr = nr->less;

	if (i >= j)		// the smallest from bigger ones
	{
		if (isroot) root = nl;
		else
			if (np->less == t) np->less = nl;
			else np->more = nl;
		if (nlp)
		{
			nlp->more = nl->less;
			nl->less = t->less;
		}
		nl->more = t->more;
	}
	else	// Mirror situation
	{
		if (isroot) root = nr;
		else
			if (np->less == t) np->less = nr;
			else np->more = nr;
		if (nrp)
		{
			nrp->less = nr->more;
			nr->more = t->more;
		}
		nr->less = t->less;
	}
}

dbsNode *dbsNode::myParent (dbsTree *t)		// O(log n)
{
	dbsNode *np;

	if ((np = t->root) == this)
		return NULL;

	while (np)
		if (compare (np) < 0)
			if (np->less == this) break;
			else np = np->less;
		else
			if (np->more == this) break;
			else np = np->more;

	assert (np);

	return np;
}

dbsNode *dbsTree::dbsFind ()		// O (log n)
{
	dbsNode *d;
	int i;

	dflag = FoundDepth = 0;

	if (!(d = root)) {
		FoundSlot = &root;
		return NULL;
	}

	++FoundDepth;

	for (;; ++FoundDepth) {
		if ((i = d->compare ()) == 0) {
			FoundSlot = NULL;
			return d;
		}
		if (i < 0)
			if (d->more) d = d->more;
			else {
				FoundSlot = &d->more;
				return NULL;
			}
		else
			if (d->less) d = d->less;
			else {
				FoundSlot = &d->less;
				return NULL;
			}
	}
}

/*
 * Moving in the tree.
 *  If we want for every node of the tree: foreach ()	O(n)
 *  To copy the tree - preorder: copytree ()		O(n)
 *  Safe to node deletion (but no dbsRemove, just
 *	root=NULL, cnt=0) - postorder: deltree ()	O(n) 
 *  To a specific index: operator [i]			O(n)  ...(n/16)
 *     But for every node with operator[] total is ... n^2  CAREFUL!
 *  Inorder next/prev dbsNext, dbsPrev:			O(log n)
 *  For a scroller area Use dbsNext, dbsPrev and keep a sample node
 *  if the tree is modified, reget the sample node from operator [].
 *
 */

void dbsTree::walk_tree (dbsNode *n, void (*foo)(dbsNode*))
{
	foo (n);
	if (n->less) walk_tree (n->less, foo);
	if (n->more) walk_tree (n->more, foo);
}
void dbsTree::walk_tree_io (dbsNode *n, void (*foo)(dbsNode*))
{
	if (n->less) walk_tree_io (n->less, foo);
	foo (n);
	if (n->more) walk_tree_io (n->more, foo);
}
void dbsTree::walk_tree_d (dbsNode *n, void (*foo)(dbsNode*))
{
	if (n->less) walk_tree_d (n->less, foo);
	if (n->more) walk_tree_d (n->more, foo);
	foo (n);
}


void dbsTree::copytree (void (*f)(dbsNode*))
{
	if (root) walk_tree (root, f);
}

void dbsTree::foreach (void (*f)(dbsNode*))
{
	if (root) walk_tree_io (root, f);
}

void dbsTree::deltree (void (*f)(dbsNode*))
{
	if (root) walk_tree_d (root, f);
}
/*
 * Indexed by inorder access
 */

//***************************************************************
// A tree of case sensitive strings -- char *Name
//***************************************************************

char *dbsNodeStr::Query;

int dbsNodeStr::compare (dbsNode *n)
{
	return strcmp (Name, ((dbsNodeStr*) n)->Name);
}

int dbsNodeStr::compare ()
{
	return strcmp (Name, Query);
}

dbsNodeStr::dbsNodeStr (dbsTree *t) : dbsNode (t)
{
	Name = StrDup (Query);
}

dbsNodeStr::~dbsNodeStr ()
{ }
