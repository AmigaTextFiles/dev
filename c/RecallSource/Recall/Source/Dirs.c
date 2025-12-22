/*
 *	File:					Dirs.c
 *	Description:	Lets Recall handle directories.
 *
 *	(C) 1994,1995 Ketil Hunn
 *
 */

#ifndef DIRS_C
#define	DIRS_C

/*** PRIVATE INCLUDES ****************************************************************/
#include "System.h"
#include "System_Prefs.h"
#include "Dirs.h"
#include "myDoubleClick.h"

/*** GLOBALS *************************************************************************/
struct List *dirlist;

/*** FUNCTIONS ***********************************************************************/
void PushDir(struct List *list, struct EventNode *eventnode)
{
	struct DirNode *dirnode;

#ifdef MYDEBUG_H
	DebugOut("PushDir");
#endif

	if(dirnode=AllocVec(sizeof(struct DirNode), MEMF_CLEAR|MEMF_PUBLIC))
	{
		dirnode->dir=list;
		dirnode->nn_Node.ln_Type=REC_TEXT;
		AddHead(dirlist, (struct Node *)dirnode);
		dirnode->eventnode=eventnode;
	}
	else
		FailAlert(MSG_OUTOFMEMORY);
}

struct List *PopDir(void)
{
	struct DirNode	*dirnode=(struct DirNode *)dirlist->lh_Head;
	struct List *l=dirnode->dir;

#ifdef MYDEBUG_H
	DebugOut("PopDir");
#endif

	eventnode=dirnode->eventnode;
	RemHead(dirlist);
	FreeVec(dirnode);
	return l;
}

void ShowChildren(struct EventNode *node)
{
#ifdef MYDEBUG_H
	DebugOut("ShowChildren");
#endif
	if(node->nn_Node.ln_Type==REC_DIR)
	{
		PushDir(eventlist, node);
		eventlist=node->children;
 		GetFirstEvent();
		GetFirstText();
		GetFirstDate();
		UpdateAllTasks();
		ClearDoubleClick();
	}
}

void ShowParent(void)
{
#ifdef MYDEBUG_H
	DebugOut("ShowParent");
#endif

	if(!IsNil(dirlist))
	{
		activeevent=
						(UWORD)egSetGadgetAttrs(eventlistview, mainTask.window, NULL,
																	GTLV_Labels,				eventlist=PopDir(),
																	GTLV_SelectedNode,	eventnode,
																	TAG_DONE);
		GetFirstText();
		GetFirstDate();
		UpdateAllTasks();
	}
}

void ShowRoot(void)
{
	struct DirNode	*dirnode=(struct DirNode *)dirlist->lh_TailPred;
#ifdef MYDEBUG_H
	DebugOut("ShowRoot");
#endif

	if(!IsNil(dirlist))
	{
//		eventnode=dirnode->eventnode;
		activeevent=
						(UWORD)egSetGadgetAttrs(eventlistview, mainTask.window, NULL,
																	GTLV_Labels,				eventlist=rootlist,
																	GTLV_SelectedNode,	eventnode=dirnode->eventnode,
																	TAG_DONE);
		ResetDataTasks();
		ClearList(dirlist);
		UpdateAllTasks();
	}
}

#endif
