/*
 * Revision control info:
 *
 */

static const char rcsid[] =
	"$Id: list.c 1.2 1995/10/23 21:54:32 JöG Exp JöG $";

/*
 *
 * Jörgen Grahn
 * Wetterlinsgatan 13E
 * S-521 34 Falköping
 * Sverige
 *
 */

/* 
 * list.c
 * 
 * Jörgen Grahn 1992-11-28, 1993-05-07, 1994-04-03
 *
 * Optimized 1994-05-03.
 * Fixed not to clash with the definitions in
 * AmigaDOS' exec/types.h 1994-11-30
 * 
 * Manages doubly-linked lists in a clear
 * and nice way.
 * 
 * In this context, 'head' is the first node
 * in the list, and 'tail' is the last node in the list.
 * 
 * To make insert/delete operations simple, a List
 * always has one dummy first node, and one dummy
 * last node. The dummy head node has a NULL
 * 'prev' pointer, and the dummy tail node has a NULL
 * 'next' pointer.
 * In the AmigaOS executive kernel, the two dummy
 * nodes share one NULL pointer, thus saving four bytes.
 *
 * In the prototypes for the functions below, 'Node *'
 * has been replaced with 'APTR' (typedef'ed to 'void *').
 * This is to avoid type warnings, since you normally don't
 * pass a 'Node *', but a pointer to a structure that _starts_
 * with a Node, and contains useful data at the end.
 *
 */

/*
 * $Log: list.c $
 * Revision 1.2  1995/10/23  21:54:32  JöG
 * made the RCS id a string
 *
 * Revision 1.1  1995/10/18  14:43:02  JöG
 * Initial revision
 *
 * Revision 1.2  1995/05/08  22:54:54  JöG
 * removed dependency on my "types.h" file
 *
 * Revision 1.1  1995/04/24  16:30:42  JöG
 * Initial revision
 *
 *
 */

#ifdef _AMIGA
#include <exec/types.h>
#else
#in clude "types.h"		/* Fool braindead Makefile generators */
#endif

#include "list.h"

/*
 * Given an uninitialized List structure, listcreate()
 * makes it a valid empty list.
 */
void listcreate(List * l)
{
	l->dummyheadnext = (Node *)&(l->dummynull);
	l->dummynull = NULL;
	l->dummytailprev = (Node *)&(l->dummyheadnext);
}

/*
 * Inserts a node in the list after another
 * given non-dummy node.
 *
 */
void listinsert(APTR prev, APTR element)
{
	Node * next;

	next = ((Node *)prev)->next;

	((Node *)element)->next = next;
	((Node *)element)->prev = prev;

	((Node *)prev)->next = element;
	next->prev = element;
}

/*
 * Removes the valid node from its list.
 *
 */
void listremove(APTR element)
{
	Node	* next,
		* prev;

	next = ((Node *)element)->next;
	prev = ((Node *)element)->prev;

	prev->next = next;
	next->prev = prev;
}

/*
 * Adds a node as the first element
 * in the given list.
 *
 */
void listaddhead(List * list, APTR element)
{
	listinsert(&(list->dummyheadnext), element);
}

/*
 * Adds a node as the last element
 * in the given list.
 *
 */
void listaddtail(List * list, APTR element)
{
	listinsert(list->dummytailprev, element);
}

/*
 * Removes the first node
 * in the given list, if non-empty.
 *
 */
void listremovehead(List * list)
{
	if(!listisempty(list))
		listremove(list->dummyheadnext);
}

/*
 * Removes the last node
 * in the given list, if non-empty.
 *
 */
void listremovetail(List * list)
{
	if(!listisempty(list))
		listremove(list->dummytailprev);
}

/*
 * Returns non-zero if given list is
 * empty, zero otherwise.
 *
 */
BOOL listisempty(List * list)
{
	return(BOOL)(list->dummyheadnext->next==NULL);
}

/*
 * Returns non-zero if given node is
 * the first one in a list, zero otherwise.
 *
 */
BOOL listishead(APTR node)
{
	return(BOOL)(((Node *)node)->prev->prev==NULL);
}

/*
 * Returns non-zero if given node is
 * the last one in a list, zero otherwise.
 *
 */
BOOL lististail(APTR node)
{
	return(BOOL)(((Node *)node)->next->next==NULL);
}

/*
 * Returns the first node of a list, or
 * NULL if it is empty.
 *
 */
APTR listhead(List * list)
{
	if(list->dummyheadnext->next == NULL)
		return(NULL);
	return(list->dummyheadnext);
}

/*
 * Returns the last node of a list, or
 * NULL if it is empty.
 *
 */
APTR listtail(List * list)
{
	if(list->dummyheadnext->next == NULL)
		return(NULL);
	return(list->dummytailprev);
}

/*
 * Returns the element following the one given,
 * or NULL if it was the tail.
 * A NULL argument returns NULL.
 *
 */
APTR listnext(APTR node)
{
	if(node==NULL || ((Node *)node)->next->next == NULL)
		return(NULL);
	return(((Node *)node)->next);
}

/*
 * Returns the element preceding the one given,
 * or NULL if it was the head.
 * A NULL argument returns NULL.
 *
 */
APTR listprev(APTR node)
{
	if(node==NULL || ((Node *)node)->prev->prev == NULL)
		return(NULL);
	return(((Node *)node)->prev);
}

/*
 * Returns lenght of list.
 *
 */
LONG listlen(List * list)
{
	LONG	  i;
	Node	* n;

	i = 0;
	n = listhead(list);

	while(n!=NULL)
	{
		i++;
		n = listnext(n);
	}
	return(i);
}
