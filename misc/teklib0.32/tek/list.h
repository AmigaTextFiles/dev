
#ifndef _TEK_LIST_H
#define	_TEK_LIST_H 1

/*
**	list.h
**
**	lists and nodes
*/

#include <tek/type.h>


typedef struct
{
	TAPTR succ;
	TAPTR pred;
}	TNODE;


typedef struct
{
	TNODE *head;
	TNODE *tail;
	TNODE *tailpred;
}	TLIST;



/* 
**	list support macros.
*/

#define TInitList(list)		(list)->tailpred=(TNODE *)list;(list)->tail=TNULL;(list)->head=(TNODE *)&((list)->tail);
#define	TFirstNode(list)	((list)->head->succ ? (list)->head : TNULL)
#define TLastNode(list)		((list)->tailpred->pred ? (list)->tailpred : TNULL)
#define TListEmpty(list)	(!((list)->head->succ))



TBEGIN_C_API


extern TVOID TAddHead(TLIST *list, TNODE *node)						__ELATE_QCALL__(("qcall lib/tek/list/addhead"));
extern TVOID TAddTail(TLIST *list, TNODE *node)						__ELATE_QCALL__(("qcall lib/tek/list/addtail"));
extern TVOID TRemove(TNODE *node)									__ELATE_QCALL__(("qcall lib/tek/list/remove"));
extern TVOID TInsert(TLIST *list, TNODE *node, TNODE *listnode)		__ELATE_QCALL__(("qcall lib/tek/list/insert"));
extern TNODE *TRemHead(TLIST *list)									__ELATE_QCALL__(("qcall lib/tek/list/remhead"));
extern TNODE *TRemTail(TLIST *list)									__ELATE_QCALL__(("qcall lib/tek/list/remtail"));
extern TNODE *TSeekNode(TNODE *node, TINT numsteps)					__ELATE_QCALL__(("qcall lib/tek/list/seeknode"));


TEND_C_API


#endif
