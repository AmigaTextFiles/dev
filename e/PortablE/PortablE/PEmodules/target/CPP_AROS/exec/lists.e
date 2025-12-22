/* Structures and macros for exec lists. */
OPT NATIVE
MODULE 'target/exec/nodes'
MODULE 'target/exec/types'
{#include <exec/lists.h>}
NATIVE {EXEC_LISTS_H} CONST

/**************************************
	       Structures
**************************************/
/* Normal list */
NATIVE {List} OBJECT lh
    {lh_Head}	head	:PTR TO ln
	{lh_Tail}	tail	:PTR TO ln
	{lh_TailPred}	tailpred	:PTR TO ln
    {lh_Type}	type	:UBYTE
    {l_pad}	pad	:UBYTE
ENDOBJECT

/* Minimal list */
NATIVE {MinList} OBJECT mlh
    {mlh_Head}	head	:PTR TO mln
	{mlh_Tail}	tail	:PTR TO mln
	{mlh_TailPred}	tailpred	:PTR TO mln
ENDOBJECT


/**************************************
	       Makros
**************************************/
NATIVE {IsListEmpty} PROC	->IsListEmpty(l) ( (((struct List *)l)->lh_TailPred) == (struct Node *)(l) )

NATIVE {IsMsgPortEmpty} PROC	->IsMsgPortEmpty(mp) ( (((struct MsgPort *)(mp))->mp_MsgList.lh_TailPred) == (struct Node *)(&(((struct MsgPort *)(mp))->mp_MsgList)) )

NATIVE {NEWLIST} CONST	->NEWLIST(_l)

NATIVE {ADDHEAD} CONST	->ADDHEAD(_l,_n)

NATIVE {ADDTAIL} CONST	->ADDTAIL(_l,_n)

NATIVE {REMOVE} CONST	->REMOVE(_n)

NATIVE {GetHead} PROC	->GetHead(_l)

NATIVE {GetTail} PROC	->GetTail(_l)

NATIVE {GetSucc} PROC	->GetSucc(_n)

NATIVE {GetPred} PROC	->GetPred(_n)

NATIVE {REMHEAD} CONST	->REMHEAD(_l)

NATIVE {REMTAIL} CONST	->REMTAIL(_l)

NATIVE {ForeachNode} PROC	->ForeachNode(list, node)

NATIVE {ForeachNodeSafe} PROC	->ForeachNodeSafe(list, current, next)

NATIVE {ListLength} PROC	->ListLength(list,count
