/*
 *	File:					List.c
 *	Description:	A set of functions for manipulating Exec lists.
 *
 *	(C) 1993,1994,1995 Ketil Hunn
 *
 */

#ifndef LIST_C
#define	LIST_C

/*** PRIVATE INCLUDES ****************************************************************/
#include "System.h"
#include "System_Prefs.h"
#include "List.h"
#include "Dirs.h"

/*** FUNCTIONS ***********************************************************************/
__asm BYTE IsNil(register __a0 struct List *list)
{
	if(list==NULL)
		return 1;
	return (BYTE)(IsListEmpty(list));
}

struct List *InitList(void)
{
	struct List *list;

#ifdef MYDEBUG_H
	DebugOut("ListInit");
#endif

	if(list=AllocVec(sizeof(struct List), MEMF_CLEAR|MEMF_PUBLIC))
		NewList(list);
	else
		FailAlert(MSG_OUTOFMEMORY);
	return list;
}

__stackext void RemoveNode(struct Node *node)
{
	register struct EventNode *eventnode=(struct EventNode *)node;

#ifdef MYDEBUG_H
	DebugOut("RemoveNode");
#endif

	if(node)
	{
		if(node->ln_Name)
			free(node->ln_Name);

		switch(node->ln_Type)
		{
			case REC_DIR:
				FreeList(eventnode->children);
				break;
			case REC_EVENT:
				FreeList(eventnode->datelist);
				FreeList(eventnode->textlist);
				if(eventnode->screen)
					free(eventnode->screen);
				if(eventnode->dir)
					free(eventnode->dir);
				break;
		}
		if(node->ln_Pred && node->ln_Succ)
			Remove(node);
		FreeVec(node);
	}
}

void ClearList(struct List *list)
{
#ifdef MYDEBUG_H
	DebugOut("ClearList");
#endif

	while(!IsNil(list))
		RemoveNode(list->lh_Head);
}

void FreeList(struct List *list)
{
#ifdef MYDEBUG_H
	DebugOut("FreeList");
#endif

	ClearList(list);
	FreeVec(list);
}

struct EventNode *AddEventNode(struct List *list, struct Node *prevnode, UBYTE *name)
{
	struct EventNode *node;
#ifdef MYDEBUG_H
	DebugOut("AddEvent");
#endif

	if(node=AllocVec(sizeof(struct EventNode), MEMF_CLEAR|MEMF_PUBLIC))
	{
		node->nn_Node.ln_Name=strdup(name);
		node->nn_Node.ln_Type=REC_EVENT;
		if(node->textlist=InitList())
			if(node->datelist=InitList())
			{
				if(prevnode==NULL)
					AddTail(list, node);
				else
					Insert(list, node, prevnode);
			}
	}
	else
		FailAlert(MSG_OUTOFMEMORY);
	return node;
}

struct EventNode *AddDirNode(struct List *list, struct Node *prevnode, UBYTE *name)
{
	struct EventNode *node;

#ifdef MYDEBUG_H
	DebugOut("AddDir");
#endif

	if(node=AllocVec(sizeof(struct EventNode), MEMF_CLEAR|MEMF_PUBLIC))
	{
		node->nn_Node.ln_Name=strdup(name);
		node->nn_Node.ln_Type=REC_DIR;
		if(node->children=InitList())
		{
			if(prevnode==NULL)
				AddTail(list, node);
			else
				Insert(list, node, prevnode);
		}
	}
	else
		FailAlert(MSG_OUTOFMEMORY);
	return node;
}

struct Node *AddNode(struct List *list, struct Node *prevnode, UBYTE *name)
{
	struct Node *node;

#ifdef MYDEBUG_H
	DebugOut("AddNode");
#endif

	if(node=AllocVec(sizeof(struct Node), MEMF_CLEAR|MEMF_PUBLIC))
	{
		node->ln_Name=strdup(name);
		node->ln_Type=REC_TEXT;
		if(prevnode==NULL)
			AddTail(list, node);
		else
			Insert(list, node, prevnode);
	}
	else
		FailAlert(MSG_OUTOFMEMORY);
	return node;
}

struct DateNode *AddDateNode(struct List *list, struct Node *prevnode, UBYTE *name)
{
	struct DateNode *node;

#ifdef MYDEBUG_H
	DebugOut("AddDate");
#endif

	if(node=AllocVec(sizeof(struct DateNode), MEMF_CLEAR|MEMF_PUBLIC))
	{
		node->nn_Node.ln_Name=strdup(name);
		node->nn_Node.ln_Type=REC_DATE;
		node->hour=node->minutes=NONE;
		if(prevnode==NULL)
			AddTail(list, node);
		else
			Insert(list, node, prevnode);
	}
	else
		FailAlert(MSG_OUTOFMEMORY);
	return node;
}

void RenameText(UBYTE **old, UBYTE *new)
{
	if(old)
		free(*old);

	if(strlen(new))
		*old=strdup(new);
	else
		*old=NULL;
}

__asm struct Node *GetHead(register __a0 struct List *list)
{
	return (IsNil(list) ? NULL : list->lh_Head);
}

__asm struct Node *GetTail(register __a0 struct List *list)
{
	return (IsNil(list) ? NULL : list->lh_TailPred);
}

__asm struct Node *GetSucc(	register __a0 struct List *list,
														register __a1 struct Node *node)
{
	return (node==NULL | node==list->lh_TailPred ? NULL : node->ln_Succ);
}

__asm struct Node *GetPred(register __a0 struct Node *node)
{
	return (node==NULL ? NULL:node->ln_Pred);
}

/* Counts items in current directory */
ULONG Count(struct List *list)
{
	register struct Node	*node;
	register ULONG				i=0;

#ifdef MYDEBUG_H
	DebugOut("Count");
#endif

	for(every_node)
		++i;
	return i;
}

/* Counts items in whole directory-structure */
__stackext ULONG CountAll(struct List *list)
{
	register struct Node	*node;
	register ULONG				i=0;

#ifdef MYDEBUG_H
	DebugOut("CountAll");
#endif

	for(every_node)
	{
		if(node->ln_Type==REC_DIR)
			i+=CountAll(((struct EventNode *)node)->children);
		else
			++i;
	}
	return i;
}

void RenameNode(struct Node *node, UBYTE *name)
{
#ifdef MYDEBUG_H
	DebugOut("RenameNode");
#endif

	free(node->ln_Name);
	node->ln_Name=strdup(name);
}

void CopyNode(struct List *list, struct Node **buffer, struct Node *node)
{
#ifdef MYDEBUG_H
	DebugOut("CopyNode");
#endif

	if(*buffer!=NULL)
		RemoveNode(*buffer);

	*buffer=DuplicateNode(node);
	(*buffer)->ln_Pred=NULL;
	(*buffer)->ln_Succ=NULL;

}

struct Node *CutNode(struct List *list, struct Node **buffer, struct Node *node)
{
	struct Node *activatenext=NULL;
#ifdef MYDEBUG_H
	DebugOut("CutEvent");
#endif

	if(*buffer!=NULL)
		RemoveNode(*buffer);

	if(node==NULL)
		;
	if(node->ln_Succ!=NULL & node!=list->lh_TailPred)
		activatenext=node->ln_Succ;
	else if(node->ln_Pred!=NULL & node!=list->lh_Head)
		activatenext=node->ln_Pred;

	*buffer=node;
	Remove(node);
	node->ln_Pred=node->ln_Succ=NULL;

	return activatenext;
}

struct Node *PasteNode(struct List *list, struct Node *buffer, struct Node *before)
{
	struct Node *newnode;
#ifdef MYDEBUG_H
	DebugOut("PasteNode");
#endif

	newnode=DuplicateNode(buffer);
	if(before==NULL)
		AddTail(list, newnode);
	else
		Insert(list, newnode, before->ln_Pred);

	return newnode;
}

__stackext struct Node *DuplicateNode(struct Node *node)
{
	struct Node				*newnode;
	struct EventNode	*eventnode;
#ifdef MYDEBUG_H
	DebugOut("DuplicateNode");
#endif

	switch(node->ln_Type)
	{
		case REC_DIR:
			if(eventnode=AllocVec(sizeof(struct EventNode), MEMF_CLEAR|MEMF_PUBLIC))
			{
				struct EventNode *enode=(struct EventNode *)node;

				CopyMem(node, eventnode, sizeof(struct EventNode));
				eventnode->nn_Node.ln_Name=strdup(node->ln_Name);
				eventnode->children=DuplicateList(enode->children);
			}
			else
				FailAlert(MSG_OUTOFMEMORY);
			newnode=(struct Node *)eventnode;
			break;

		case REC_EVENT:
			if(eventnode=AllocVec(sizeof(struct EventNode), MEMF_CLEAR|MEMF_PUBLIC))
			{
				struct EventNode *enode=(struct EventNode *)node;

				CopyMem(node, eventnode, sizeof(struct EventNode));
				eventnode->nn_Node.ln_Name=strdup(node->ln_Name);
				eventnode->datelist=DuplicateList(enode->datelist);
				eventnode->textlist=DuplicateList(enode->textlist);
			}
			else
				FailAlert(MSG_OUTOFMEMORY);
			newnode=(struct Node *)eventnode;
			break;

		case REC_DATE:
			if(newnode=AllocVec(sizeof(struct DateNode), MEMF_CLEAR|MEMF_PUBLIC))
			{
				CopyMem(node, newnode, sizeof(struct DateNode));
				newnode->ln_Name=strdup(node->ln_Name);
			}
			else
				FailAlert(MSG_OUTOFMEMORY);
			break;

		case REC_TEXT:
			if(newnode=AllocVec(sizeof(struct Node), MEMF_CLEAR|MEMF_PUBLIC))
			{
				CopyMem(node, newnode, sizeof(struct Node));
				newnode->ln_Name=strdup(node->ln_Name);
			}
			else
				FailAlert(MSG_OUTOFMEMORY);
			break;
	}
	return newnode;
}

__stackext struct List *DuplicateList(struct List *list)
{
	struct List *newlist;
	register struct Node *node;

#ifdef MYDEBUG_H
	DebugOut("DuplicateList");
#endif

	if(newlist=InitList())
		for(every_node)
			AddTail(newlist, DuplicateNode(node));

	return newlist;
}
#endif
