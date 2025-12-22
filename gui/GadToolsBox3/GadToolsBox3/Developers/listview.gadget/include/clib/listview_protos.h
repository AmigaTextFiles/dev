#ifndef  CLIB_LISTVIEW_PROTOS_H
#define  CLIB_LISTVIEW_PROTOS_H

/*
**	$VER: listview_protos.h 1.0 (20.6.96)
**
**	C prototypes. For use with 32 bit integers only.
**
**	(C) Copyright 1997 Tomasz Muszynski
*/

#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif

Class *GetListViewClass(void);
void Tree_AddHead(struct LVList *,struct LVNode *);
void Tree_AddSubHead(struct LVList *,struct LVNode *,struct LVNode *);
void Tree_AddSubTail(struct LVList *,struct LVNode *,struct LVNode *);
void Tree_AddTail(struct LVList *,struct LVNode *);
void Tree_Insert(struct LVList *,struct LVNode *,struct LVNode *);
void Tree_NewList(struct LVList *);
struct LVNode *Tree_NextNode(struct LVNode *);
struct LVNode *Tree_NextSubNode(struct LVNode *);
struct LVNode *Tree_RemHead(struct LVList *);
void Tree_Remove(struct LVNode *);
struct LVNode *Tree_RemSubHead(struct LVNode *);
struct LVNode *Tree_RemSubTail(struct LVNode *);
struct LVNode *Tree_RemTail(struct LVList *);

#endif	 /* CLIB_LISTVIEW_PROTOS_H */
