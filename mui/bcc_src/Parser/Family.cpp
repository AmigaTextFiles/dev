#include <stdio.h>
#include "Family.h"

Family::Family()
{
	Succ = NULL;
	Head = (struct Family*)&Tail;
	Tail = NULL;
	TailPred = (struct Family*)&Head;
}

void Family::Remove( void )
{
	if( Succ ) {
		Succ->Pred = Pred;
		Pred->Succ = Succ;
		Succ = NULL;
	}
}

void Family::Swap( Family *f )
{
	Family *p1, *p2;

	if( Succ == f ) {

		f->Remove();
		Pred->AddAfter( f );

	} else 
	if( Pred == f ) {

		f->Remove();
		AddAfter( f );

	} else {

		p1 = Pred;
		p2 = f->Pred;

		Remove();
		f->Remove();

		p1->AddAfter( f );
		p2->AddAfter( this );

	}
/*
	Pred->Succ = f;
	Succ->Pred = f;

	f->Succ->Pred = this;
	f->Pred->Succ = this;

	b = Pred;
	Pred = f->Pred;
	f->Pred = b;

	b = Succ;
	Succ = f->Succ;
	f->Succ = b;
*/

}

short Family::Count( void )
{
	short n = 0;

	FScan( Family, f, this ) n++;

	return n;

}

Family::~Family()
{
	Remove();
	KillChildren();
}

void Family::KillChildren( void )
{
	if( !isEmpty() ) {
		Family *item, *nitem;
		for( item = Head; item->Succ; ) {
			nitem = item->Succ;
			delete item;
			item = nitem;
		}
	}
}

int Family::isEmpty( void )
{
	return( TailPred == (Family*)&Head );
}

void Family::AddTail( struct Family *child )
{
	child->Succ = (struct Family*)&Tail;
	child->Pred = TailPred;
	TailPred->Succ = child;
	TailPred = child;
}

void Family::AddHead( struct Family *child )
{
	child->Succ = Head;
	child->Pred = (struct Family*)&Head;
	Head->Pred = child;
	Head = child;
}

void Family::AddAfter( Family *child )
{
	child->Succ = Succ;
	child->Pred = this;
	Succ->Pred = child;
	Succ = child;
}

Family *Family::Last( void )
{
		return TailPred;
}

Family *Family::Parent( void )
{
	if( !Succ ) return 0;

	Family *s;
	for( s = this; s->Succ; s = s->Succ );

	return (Family*)(((Family**)s)-3);

}

void Family::Disconnect( void )
{
	Succ = Pred = Head = Tail = TailPred = 0;
}

void Family::Adopt( Family *f )
{
	Family *s, *n;

	for( s = f->Head; s->Succ; s = n ) {
		n = s->Succ;
		s->Remove();
		AddTail( s );
	}
}
