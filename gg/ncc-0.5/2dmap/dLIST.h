/*******************************************************************************
	Ultimate double list library
*******************************************************************************/

#ifndef dLIST_INCLUDED

#define dLIST_INCLUDED

class dlistNode
{
   public:
	dlistNode *prev, *next;
};

class dlist
{
   public:
	dlist ();
	dlistNode *Start, *End;
	void addtostart (dlistNode*);
	void addtoend (dlistNode*);
	void addafter (dlistNode*, dlistNode*);
	void dremove (dlistNode*);
	void swap (dlistNode*, dlistNode*);
	dlistNode *Next (dlistNode*) const;
	dlistNode *Prev (dlistNode*) const;
	int cnt;
	~dlist ();
};

inline dlistNode *dlist::Next (dlistNode *d) const
{
	return d->next;
}

inline dlistNode *dlist::Prev (dlistNode *d) const
{
	return d->prev;
}

class dlistNodeAuto : public dlistNode
{
   protected:
	void leave (dlist*);
   public:
	dlistNodeAuto (dlist*, bool = true);
	~dlistNodeAuto ();
};

//------------------------ templates --------------------------

template<class X>
class dlistAuto : public dlist
{
   public:
	dlistAuto ();
	void add (X x, bool = true);
	dlistNode *find (X x);
	int tipe;
	void rmv (X x);
	void addafter (dlistNode*, X x);
	void dremove (dlistNode*);
	X XFor (dlistNode*);
	~dlistAuto ();
};

template<class X>
class dlistNodeX : public dlistNode {
   public:
	dlistNodeX (X ix)	{ x = ix; }
	X x;
};

//:::::::::::::::::::::::::::::::::::::::::::::::::::::: dlistAuto<X>

template<class X>
dlistAuto<X>::dlistAuto () : dlist ()
{ }

template<class X>
void dlistAuto<X>::add (X x, bool toe)
{
	dlistNode *n = (dlistNode*) new dlistNodeX<X> (x);

	if (toe) addtoend (n);
	else addtostart (n);
}

template<class X>
dlistNode *dlistAuto<X>::find (X x)
{
	dlistNodeX<X> *d;

	if (tipe)
	for (d = (dlistNodeX<X>*) End; d; d = (dlistNodeX<X>*) Prev (d)) {
		if (d->x == x) break; }
	else
	for (d = (dlistNodeX<X>*) Start; d; d = (dlistNodeX<X>*) Next (d)) {
		if (d->x == x) break; }

	return (dlistNode*)d;
}

template<class X>
void dlistAuto<X>::addafter (dlistNode *d, X x)
{
	dlistNode *n = (dlistNode*) new dlistNodeX<X> (x);
	dlist::addafter (d, n);
}

template<class X>
void dlistAuto<X>::dremove (dlistNode *d)
{
	dlist::dremove (d);
	delete d;
}

template<class X>
void dlistAuto<X>::rmv (X x)
{
	dlistNode *d = find (x);

	if (d)
		dremove (d);
}

template<class X>
X dlistAuto<X>::XFor (dlistNode *n)
{
	return ((dlistNodeX<X>*)n)->x;
}

template<class X>
dlistAuto<X>::~dlistAuto ()
{
	dlistNode *d;
	tipe = 0;
	while ((d = Start)) dremove (d);
}
#endif
