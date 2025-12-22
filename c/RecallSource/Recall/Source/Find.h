/*
 *	File:					Find.h
 *	Description:	Finds/replace an event names
 *
 *	(C) 1994,1995 Ketil Hunn
 *
 */

#ifndef	FIND_H
#define	FIND_H

/*** GLOBALS *************************************************************************/
struct FindNode
{
	struct Node	nn_Node;
	struct Node	*link;
};

/*** PROTOTYPES **********************************************************************/
__stackext __asm void JumpToEvent(register __a0 struct List				*list,
																	register __a1 struct EventNode	*findevent);
__asm UBYTE *Upper(register __a0 UBYTE *string);
__asm char *matchname(register __a0 char *string,
											register __a1 char *substring);
__asm UBYTE *replace(	register __a0 struct Node *node,
											register __a1 char *p);
__asm struct FindNode *AddFindNode(	register __a0 struct List *list,
																		register __a1 struct Node *link);
__stackext __asm void buildReplaceList(	register __a0 struct List *eventlist,
																				register __a1 struct List *list,
																				register __a3 struct Node *node);
__asm void ReplaceEvent(register __a0 struct List *elist,
												register __a1 struct Node *node);
__stackext __asm BYTE FindEvent(register __a0 struct List *list,
																register __a1 struct Node *node,
																register __d0 ULONG				level);
#endif
