/**************************************************************************
 Copyright (C) 2000 Stelios Xanthakis
**************************************************************************/

#include <stdlib.h>

#include "dLIST.h"

//---------------------------------------------------------------------------

//:::::::::::::::::::::::::::::::::::::::::::::::::::::: dlist

dlist::dlist ()
{
	Start = End = NULL;
	cnt = 0;
}

void dlist::addtostart (dlistNode *n)
{
	if (!(n->next = Start)) End = n;
	else Start->prev = n;
	n->prev = NULL;
	Start = n;
	++cnt;
}

void dlist::addtoend (dlistNode *n)
{
	if (!(n->prev = End)) Start = n;
	else End->next = n;
	n->next = NULL;
	End = n;
	++cnt;
}

void dlist::addafter (dlistNode *a, dlistNode *n)
{
	n->prev = a;
	n->next = a->next;
	if (a->next) a->next->prev = n;
	else End = n;
	a->next = n;
	++cnt;
}

void dlist::dremove (dlistNode *n)
{
	if (n->next) n->next->prev = n->prev;
	else End = n->prev;
	if (n->prev) n->prev->next = n->next;
	else Start = n->next;
	--cnt;
}

void dlist::swap (dlistNode *a, dlistNode *b)
{
	dlistNode *t = a->prev;

	if (t == b) {
		dremove (b);
		addafter (a, b);
	} else {
		dremove (a);
		addafter (b, a);
		dremove (b);
		if (t) addafter (t, b);
		else addtostart (b);
	}
}

dlist::~dlist ()
{ }

//::::::::::::::::::::::::::::::::::::::::::::::::::::: dlistNode?Auto

dlistNodeAuto::dlistNodeAuto (dlist *m, bool e)
{
	if (e) m->addtoend ((dlistNode*)this);
	else m->addtostart ((dlistNode*)this);
}

void dlistNodeAuto::leave (dlist *m)
{
	m->dremove ((dlistNode*)this);
}

dlistNodeAuto::~dlistNodeAuto ()
{ }

/****************************************************************************

  - If we wish a class to automatically join a list we make it ancestor

	static dlist AManager;

	class A : dlistNodeAuto {
		A () : dlistNodeAuto (&AManager)	{ ... }
		~A()		{ leave (&AManager); }
	};

  - If we want a list of things with a temporary, non-global manager

	class A {
		dlistAuto<char*> Manager;
	};

	Manager.add (char*);
	Manager.rmv (char*);

-----------
dlistNode		: Never used directly
dlist			: A list manager, containing { Start, End }
			  Declare a such for a list.
dlistNodeAuto		: joins by contructor
dlistAuto<class X>	: An automatic templated manager.
*****************************************************************************/
