/* $VER: lists.h 39.0 (15.10.1991) */
OPT NATIVE, INLINE
MODULE 'target/exec/nodes'
MODULE 'target/exec/types'
{#include <exec/lists.h>}
NATIVE {EXEC_LISTS_H} CONST

/*
 *  Full featured list header.
 */
NATIVE {List} OBJECT lh
   {lh_Head}	head	:PTR TO ln
   {lh_Tail}	tail	:PTR TO ln
   {lh_TailPred}	tailpred	:PTR TO ln
   {lh_Type}	type	:UBYTE
   {lh_pad}	pad	:UBYTE
ENDOBJECT	/* word aligned */

/*
 * Minimal List Header - no type checking
 */
NATIVE {MinList} OBJECT mlh
   {mlh_Head}	head	:PTR TO mln
   {mlh_Tail}	tail	:PTR TO mln
   {mlh_TailPred}	tailpred	:PTR TO mln
ENDOBJECT	/* longword aligned */


/*
 *	Check for the presence of any nodes on the given list.	These
 *	macros are even safe to use on lists that are modified by other
 *	tasks.	However; if something is simultaneously changing the
 *	list, the result of the test is unpredictable.
 *
 *	Unless you first arbitrated for ownership of the list, you can't
 *	_depend_ on the contents of the list.  Nodes might have been added
 *	or removed during or after the macro executes.
 *
 *		if( IsListEmpty(list) )		printf("List is empty\n");
 */
NATIVE {IsListEmpty} PROC
PROC IsListEmpty(list:PTR TO lh) IS NATIVE {-IsListEmpty(} list {)} ENDNATIVE !!BOOL

->IsMsgPortEmpty() moved to 'exec/ports' where it makes more sense
NATIVE {IsMsgPortEmpty} PROC
