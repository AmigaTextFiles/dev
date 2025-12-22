/*
** Copyright (C) 1999, 2000, Lorenzo Bettini <lorenzo.bettini@penteres.it>
**  
** This program is free software; you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation; either version 2 of the License, or
** (at your option) any later version.
**  
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**  
** You should have received a copy of the GNU General Public License
** along with this program; if not, write to the Free Software
** Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
**  
*/

// list.h

/*
  Class List ( first element is dummy )
*/

#include <iostream.h>
#include <stdlib.h>

#ifndef LIST
#define LIST

template <class TYPE>
struct ListNode
{
  TYPE elem ;
  ListNode<TYPE> *next ;

  ListNode() : next( 0 ) {}
  ListNode( TYPE e, ListNode<TYPE> *n ) : elem( e ), next( n ) {}

  ListNode<TYPE> * Next() { return next ; }
  TYPE & Elem() { return elem ; } 
} ;


template <class TYPE>
class List
{
	ListNode<TYPE> *first ;
	ListNode<TYPE> *last ;

	void Clear() ;

public:
	unsigned length ;

	List() ;
	List( const List<TYPE> & l ) ;
	~List() ;

	ListNode<TYPE> * First() { return first->next ; }
	void AddToBack( TYPE el ) ; // aggiunge in coda
	void AddToFront( TYPE el ) ; // aggiunge in testa
	void Add( TYPE el ) { AddToBack( el ) ; }
	void OwnsNothing() ; // notifica alla lista che ha perso gli elementi
	int Empty() { return first == last ; } // la lista è vuota?
	void Flush() ; // svuota la lista, ma senza distruggerla
	TYPE ExtractFromFront() ; // estrae dalla testa
        void Append( List<TYPE> & l ) ; // Append senza copia
        void Append( List<TYPE> *l ) ; // idem
	void AppendDeep( List<TYPE> l ) ; // Append con copia
	unsigned Length() { return length ; }
	void Copy( List<TYPE> & source ) ; // copia di un'altra lista
	void Detach( ListNode<TYPE> * l ) ; // rimozione di un elemento
	void Check( ListNode<TYPE> * l ) ; // L'allocazione è riuscita?
	// int HasMember( const TYPE &i ) ;
	// void print() ; // stampa gli elementi della lista

} ;


template <class TYPE>
List<TYPE>::List()
{
	first = new ListNode<TYPE> ;
	Check( first ) ;
	last = first ;
	length = 0 ;
}

template <class TYPE>
List<TYPE>::List( const List<TYPE> & l )
{
	ListNode<TYPE> * tmp ;

	first = new ListNode<TYPE> ;
	Check( first ) ;
	last = first ;
	length = 0 ;

	tmp = l.first->next ;

	while( tmp )
	{
		AddToBack( tmp->elem ) ;
		tmp = tmp->next ;
	}
}

template <class TYPE>
void List<TYPE>::Copy( List<TYPE> & source )
{
	ListNode<TYPE> * tmp ;

	tmp = source.First() ;

	while( tmp )
	{
		AddToBack( tmp->elem ) ;
		tmp = tmp->next ;
	}
}

template <class TYPE>
void List<TYPE>::Clear()
{
	ListNode<TYPE> *l1 ;
	ListNode<TYPE> *l2 ;

	l1 = first ;
	while ( l1 )
	{
		l2 = l1->next ;
		delete l1 ;
		l1 = l2 ;
	}
}

template <class TYPE>
void List<TYPE>::Flush()
{
	ListNode<TYPE> *l1 ;
	ListNode<TYPE> *l2 ;

	l1 = first->next ;
	// la lista viene solo svuotata e non distrutta, quindi si deve
	// lasciare intatto il primo elemento fittizio

	while ( l1 )
	{
		l2 = l1->next ;
		delete l1 ;
		l1 = l2 ;
	}
	OwnsNothing() ;
}

template <class TYPE>
List<TYPE>::~List()
{
	Clear() ;
}

template <class TYPE>
void List<TYPE>::AddToBack( TYPE el )
{
	ListNode<TYPE> *tmp ;
	tmp = new ListNode<TYPE>( el, 0 ) ;
	Check( tmp ) ;
	last->next = tmp ;
	last = last->next ;
	length++ ;
}

template <class TYPE>
void List<TYPE>::AddToFront( TYPE el )
{
	ListNode<TYPE> *tmp ;
	tmp = new ListNode<TYPE>( el, 0 ) ;
	Check( tmp ) ;
	if( ! tmp )
	{
		cout << "Allocazione fallita!" << endl ;
		abort() ;
	}
	tmp->next = first->next ;
	if ( first == last ) last = tmp ;
	first->next = tmp ;
	length++ ;
}

template <class TYPE>
TYPE List<TYPE>::ExtractFromFront()
{
	TYPE RetValue ;
	ListNode<TYPE> * tmp ;

	RetValue = first->next->elem ;
	tmp = first->next->next ;
	delete first->next ;
	first->next = tmp ;
	length-- ;
	if ( ! tmp ) last = first ;     // la coda è vuota
	return RetValue ;
}

template<class TYPE>
void List<TYPE>::Append( List<TYPE> * l )
{
  if ( l )
    Append( *l ) ;
}
template <class TYPE>
void List<TYPE>::Append( List<TYPE> & l )
{
        if( ! l.Empty() )
	  {
                last->next = l.first->next ;
                last = l.last ;
                length += l.Length() ;
	  }
}

template <class TYPE>
void List<TYPE>::AppendDeep( List<TYPE> l )
{
  if (!Empty()) {
    last->next=l.first;  last=l.last; 
    length+=l.length;
    l.first=l.last=NULL; // to avoid destruction of elements
  } else {
    first=l.first;  last=l.last; 
    length=l.length;
    l.first=l.last=NULL;
  }
}

// comunica alla lista che non possiede piu' i suoi elementi :
// qualcun'altro se ne e' impossessato
template <class TYPE>
void List<TYPE>::OwnsNothing()
{
	last = first ;
	first->next = 0 ;
	length = 0 ;
}

// l è il puntatore al nodo precedente a quello che si vuole deallocare :
// in pratica si vuole deallocare il nodo puntato da l->next
template <class TYPE>
void List<TYPE>::Detach( ListNode<TYPE> * l )
{
	ListNode<TYPE> * tmp ;

	if( l->next == last )
		last = l ;

	tmp = l->next->next ;
	delete l->next ;
	l->next = tmp ;
	length-- ;
}

// controlla che l'allocazione nello heap abbia avuto successo
template <class TYPE>
void List<TYPE>::Check( ListNode<TYPE> * l )
{
	if( ! l )
	{
		cout << "List non ha potuto allocare un nodo : " << endl ;
		cout << "MEMORIA ESAURITA !" << endl ;
		abort() ;
	}
}


#endif
