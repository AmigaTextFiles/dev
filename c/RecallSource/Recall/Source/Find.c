/*
 *	File:					Find.c
 *	Description:	Finds/replace an event names
 *
 *	(C) 1994,1995 Ketil Hunn
 *
 */

#ifndef	FIND_C
#define	FIND_C

/*** INCLUDES ************************************************************************/
#include "System.h"
#include "System_Prefs.h"
#include "Find.h"
#include "Dirs.h"

/*** DEFINES *************************************************************************/
#define	CANCELREPLACE	0
#define	NEXT					1
#define	REPLACE				2
#define	REPLACEALL		3

/*** GLOBALS *************************************************************************/
BYTE	jumptoevent=FALSE;

/*** FUNCTIONS ***********************************************************************/
__stackext __asm void JumpToEvent(register __a0 struct List				*list,
																	register __a1 struct EventNode	*findevent)
{
	register struct Node *node, *findnode=(struct Node *)findevent;

#ifdef MYDEBUG_H
	DebugOut("JumpToEvent");
#endif

	for(every_node)
		if(!jumptoevent)
			if(findnode==node)
			{
				jumptoevent=TRUE;
				activeevent=
					(UWORD)egSetGadgetAttrs(eventlistview,		mainTask.window, NULL,
																GTLV_Labels,				eventlist=list,
																GTLV_SelectedNode,	eventnode=(struct EventNode *)node,
																TAG_DONE);
				GetFirstText();
				GetFirstDate();
				UpdateAllTasks();
				break;
			}
			else if(node->ln_Type==REC_DIR)
			{
				PushDir(list, (struct EventNode *)node);
				JumpToEvent(((struct EventNode *)node)->children, findevent);
				if(jumptoevent==FALSE)
					PopDir();
			}
}

__asm UBYTE *Upper(register __a0 UBYTE *string)
{
	register UBYTE	*c=string;

	while(*c!='\0')
		*c++=ToUpper(*string++);

	return string;
}

__asm char *matchname(register __a0 char *string,
											register __a1 char *substring)
{
	char *found=NULL;
#ifdef MYDEBUG_H
	DebugOut("matchname");
#endif

	if(string!=NULL & substring!=NULL)
	{
		char string1[MAXCHARS], string2[MAXCHARS];

		strcpy(string1, string);
		strcpy(string2, substring);

		if(finder.ignorecase)
		{
			Upper(string1);
			Upper(string2);
		}

		if(finder.onlywholewords)
			found=(strcmp(string1, string2)==0 ? string : NULL);
		else if(found=strstr(string1, string2))
			found=string+(found-string1);
	}
	return found;
}

__asm UBYTE *replace(	register __a0 struct Node *node,
											register __a1 char *p)
{
#ifdef MYDEBUG_H
	DebugOut("replace");
#endif

	if(strlen(node->ln_Name)-strlen(finder.findstring)+strlen(finder.replacestring)<MAXCHARS)
	{
		UBYTE name[MAXCHARS], newname[MAXCHARS], *c;

		strcpy(name, node->ln_Name);
		c=name+(p-node->ln_Name);
		*c='\0';
		sprintf(newname, "%s%s%s", name, finder.replacestring, p+strlen(finder.findstring));

		RenameNode(node, newname);
		++env.changes;
	}
	else
		FailRequest(mainTask.window, MSG_BUFFERTOOLARGE, (APTR)MAXCHARS, NULL);

	return node->ln_Name;
}

__asm struct FindNode *AddFindNode(	register __a0 struct List *list,
																		register __a1 struct Node *link)
{
	struct FindNode *findnode;

	if(findnode=AllocVec(sizeof(struct FindNode), MEMF_CLEAR))
	{
		findnode->nn_Node.ln_Type=REC_TEXT;
		findnode->link=link;
		AddTail(list, findnode);
	}
	else
		FailAlert(MSG_OUTOFMEMORY);
	return findnode;
}

__stackext __asm void buildReplaceList(	register __a0 struct List *eventlist,
																				register __a1 struct List *list,
																				register __a3 struct Node *node)
{
	if(node==NULL)
		node=eventlist->lh_Head;

	while(node!=NULL)
	{
		if(matchname(node->ln_Name, finder.findstring))
			AddFindNode(list, node);
		if(node->ln_Type==REC_DIR)
			buildReplaceList(((struct EventNode *)node)->children, list, NULL);
		node=node->ln_Succ;
	}
}

__asm void ReplaceEvent(register __a0 struct List *elist,
												register __a1 struct Node *node)
{
	struct List *list;
	register ULONG count=0, replaced=0;
	struct EventNode *initialevent=eventnode;

	if(list=InitList())
	{
		buildReplaceList(elist, list, node);
		count=Count(list);

		while(finder.done==FALSE & IsNil(list)==FALSE)
		{
			struct FindNode *findnode=(struct FindNode *)list->lh_Head;
			char *substring;
			ULONG command, pos;

			if(finder.replaceall==FALSE)
			{
				ClearList(dirlist);
				jumptoevent=FALSE;
				JumpToEvent(rootlist, (struct EventNode *)findnode->link);
			}

			substring=matchname(findnode->link->ln_Name, finder.findstring);
			pos=substring-findnode->link->ln_Name;
			while(finder.done==FALSE & substring!=NULL)
			{
				if(finder.replaceall==FALSE)
					command=egRequest(mainTask.window,
												NAME " " VERS,
												GetString(&li, MSG_REPLACEWITH),
												GetString(&li, MSG_REPLACEEVENTGADGETS),
												finder.findstring,
												finder.replacestring);
				else
					command=REPLACEALL;

				switch(command)
				{
					case CANCELREPLACE:
						finder.done=TRUE;
						break;
					case NEXT:
						break;
					case REPLACE:
						DetachList(eventlistview, mainTask.window);
						replace(findnode->link, substring);
						AttachList(eventlistview, mainTask.window, eventlist);
						++replaced;
						break;
					case REPLACEALL:
						replace(findnode->link, substring);
						finder.replaceall=TRUE;
						++replaced;
						break;
				}
				substring=matchname(findnode->link->ln_Name+pos+strlen(finder.replacestring),
														finder.findstring);
				pos=substring-findnode->link->ln_Name;
				if(finder.replaceall==FALSE)
					egSetGadgetAttrs(eventstring, mainTask.window, NULL,
														GTST_String,	strcpy(eventname, findnode->link->ln_Name),
														TAG_DONE);
			}
			RemoveNode(list->lh_Head);
		}
		FreeList(list);
		AttachList(eventlistview, mainTask.window, eventlist);
		if(replaced>0 & finder.replaceall==TRUE)
			egRequest(mainTask.window,
								NAME,
								GetString(&li, MSG_REPLACEDNOCCURRENCESOF),
								GetString(&li, MSG_OK),
								(APTR)replaced,
								(APTR)finder.findstring,
								(APTR)finder.replacestring);
	}

	if(count==0)
	{
		egRequest(mainTask.window,
							NAME,
							GetString(&li, MSG_NOTFOUND),
							GetString(&li, MSG_OK),
							(APTR)finder.findstring);
//		ClearList(dirlist);
		JumpToEvent(rootlist, initialevent);
	}
}

__stackext __asm BYTE FindEvent(register __a0 struct List *list,
																register __a1 struct Node *node,
																register __d0 ULONG				level)
{
	register BYTE found=FALSE;
	register struct Node *skipnode=node;

#ifdef MYDEBUG_H
	DebugOut("FindEvent");
#endif

	if(*finder.findstring=='\0')
		return FALSE;
	else if(node==NULL)
		node=list->lh_Head;

	for( ; node->ln_Succ ; node=node->ln_Succ)
	{
		if(!finder.done)
		{
			if(node!=skipnode)
				if(matchname(node->ln_Name, finder.findstring))
				{
					activeevent=(UWORD)egSetGadgetAttrs(eventlistview, mainTask.window, NULL,
																	GTLV_Labels,				eventlist=list,
																	GTLV_SelectedNode,	eventnode=(struct EventNode *)node,
																	TAG_DONE);
					GetFirstText();
					GetFirstDate();
					UpdateAllTasks();
					finder.done=found=TRUE;
					AttachList(eventlistview, mainTask.window, eventlist);
					break;
				}
			if(node->ln_Type==REC_DIR & found==FALSE)
			{
				PushDir(list, (struct EventNode *)node);
				FindEvent(((struct EventNode *)node)->children, NULL, level+1);
				if(finder.done==FALSE)
					PopDir();
			}
		}
		else
			break;
	}

	if(finder.done==FALSE & level==0)
		egRequest(mainTask.window,
									NAME " " VERS,
									GetString(&li, (finder.onlywholewords ? MSG_NOTFOUNDASENTIREWORD :MSG_NOTFOUND)),
									GetString(&li, MSG_OK),
									finder.findstring);
	else if(found==TRUE & level==0)
		UpdateMainTask();

	if(level==0)
		AttachList(eventlistview, mainTask.window, eventlist);

	return found;
}

#endif
