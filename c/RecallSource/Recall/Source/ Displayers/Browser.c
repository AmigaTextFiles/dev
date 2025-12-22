/*
 *	File:					Browser.c
 *	Description:	Lets the user browse through the list of events
 *
 *	(C) 1994, Ketil Hunn
 *
 */

#ifndef BROWSER_C
#define BROWSER_C

#include <exec/types.h>
#include <exec/ports.h>
#include <dos/dos.h>
#include <exec/lists.h>
#include <exec/memory.h>

#include <clib/exec_protos.h>
#include <clib/alib_protos.h>
//#include <clib/alib_stdio_protos.h>
#include <clib/dos_protos.h>

#include <intuition/intuitionbase.h>

#include <string.h>

#include "morereq:/include/MoreReq.h"
#include "morereq:/proto/MoreReq_protos.h"
#include "morereq:MoreReq_pragmas.h"

#include "Modules.h"
#include "ProjectStructures.h"

#include <stdio.h>

struct Library *MoreReqBase;
struct MsgPort	*ioport;
struct RecallMsg	*msg;

#include "myinclude:mylist.h"

#include "Browser_rev.h"

struct Screen *screen=NULL;
struct EventNode *eventnode;

struct BrowseNode
{
	struct Node nn_Node;
	struct EventNode	*eventnode;
};

struct Node *AddLevel(struct List *list, struct EventNode *eventnode, ULONG level)
{
	struct BrowseNode *node;

	if(node=(struct BrowseNode *)AllocVec(sizeof(struct BrowseNode), MEMF_CLEAR))
	{
		UBYTE tmpname[512], *c;
		register ULONG i;

		c=tmpname;
		for(i=0; i<level; i++)
			*c++=' ';
		*c='\0';
		strcat(tmpname, eventnode->nn_Node.ln_Name);
		node->nn_Node.ln_Name=strdup(tmpname);
		node->eventnode=eventnode;

		AddTail(list, node);
	}
	return node;
}

__stackext void LevelOneList(struct List *levelonelist, struct List *list, ULONG level)
{
	struct Node	*node;

	if(list!=NULL)
		for(every_node)
			switch(node->ln_Type)
			{
				case REC_DIR:
					AddLevel(levelonelist, (struct EventNode *)node, level);
					LevelOneList(levelonelist, ((struct EventNode *)node)->children, level+1);
					break;
				case REC_EVENT:
					AddLevel(levelonelist, (struct EventNode *)node, level);
					break;
			}
}

void Browse(struct List *eventlist)
{
	struct List *list;
	struct ListviewRequester	*req;

	if(req=mrAllocRequest(MR_ListviewRequest,
												TAG_DONE))
	{
		if(list=InitList())
		{
			register ULONG active=0, found=FALSE;
			register struct Node *node;

			LevelOneList(list, eventlist, 0);

			for(every_node)
				if(eventnode==((struct BrowseNode *)node)->eventnode)
				{
					found=TRUE;
					break;
				}
				else
					++active;
			if(found==FALSE)
				active=0;

			if(mrRequest(req,
										MR_SizeGadget,				TRUE,
										MR_CloseGadget,				TRUE,
										MR_TitleText,					"Browser " VERS,
										MR_Gadgets,						"_Jump to|_Close",
										MRLV_Labels,					list,
										MR_InitialPercentH,		25,
										MR_InitialPercentV,		50,
										MR_InitialCentreH,		TRUE,
										MR_InitialCentreV,		TRUE,
										MRLV_Selected,				0,
										MR_Screen,						screen,
										MR_PrivateIDCMP,			TRUE,
										MR_TextAttr,					screen->Font,
										MRLV_Selected,				active,
										TAG_DONE))
			{
				struct BrowseNode *browsenode=(struct BrowseNode *)req->selectednode;
				struct EventNode *eventnode=browsenode->eventnode;

				SendMessage(ioport, msg,
										REC_JumpToEvent,	eventnode,
										TAG_DONE);
			}
			FreeList(list);
		}
		mrFreeRequest(req);
	}
}

void main(char *AIDS_KILLS)
{
	struct MsgPort	*port;
	static char *version=VERSTAG;

	if(MoreReqBase=OpenLibrary("morereq.library", 1L))
	{
		Forbid();
		ioport=FindPort(RECALL_PORT);
		Permit();

		if(ioport)
		{
			if(port=CreateMsgPort())
			{
				if(msg=AllocMessage(port, DISPLAYER_TYPE))
				{
					struct List *list=NULL;
					struct SignalSemaphore *semaphore;

					SendMessage(ioport, msg,
											REC_GetEventList, &list,
											REC_GetScreen,		&screen,
											REC_GetEvent,			&eventnode,
											TAG_DONE);
					Forbid();
					if(semaphore=FindSemaphore(EVENTSEMAPHORE))
						if(AttemptSemaphore(semaphore)==NULL)
							semaphore=NULL;
					Permit();

					if(semaphore)
					{
						if(list!=NULL & screen!=NULL)
							Browse(list);
						ReleaseSemaphore(semaphore);
					}

					FreeVec(msg);
				}
				DeleteMsgPort(port);
			}
		}
		CloseLibrary(MoreReqBase);
	}
}

#endif
