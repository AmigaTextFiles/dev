/* $VER: lists.h 39.0 (15.10.1991) */
OPT NATIVE, INLINE
MODULE 'target/exec/nodes'
MODULE 'target/exec/types'
{MODULE 'exec/lists'}

/*
 *  Full featured list header.
 */
NATIVE {lh} OBJECT lh
   {head}	head	:PTR TO ln
   {tail}	tail	:PTR TO ln
   {tailpred}	tailpred	:PTR TO ln
   {type}	type	:UBYTE
   {pad}	pad	:UBYTE
ENDOBJECT	/* word aligned */

/*
 * Minimal List Header - no type checking
 */
NATIVE {mlh} OBJECT mlh
   {head}	head	:PTR TO mln
   {tail}	tail	:PTR TO mln
   {tailpred}	tailpred	:PTR TO mln
ENDOBJECT	/* longword aligned */


NATIVE {IsListEmpty} PROC
PROC IsListEmpty(list:PTR TO lh) IS NATIVE {IsListEmpty(} list {)} ENDNATIVE !!BOOL

->IsMsgPortEmpty() moved to 'exec/ports' where it makes more sense
NATIVE {IsMsgPortEmpty} PROC
