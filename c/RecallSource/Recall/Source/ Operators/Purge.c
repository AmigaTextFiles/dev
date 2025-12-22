/*
 *	File:					Purge.c
 *	Description:	Purges all outdated events
 *
 *	(C) 1994,1995, Ketil Hunn
 *
 */

#ifndef	PURGE_H
#define	PURGE_H

#include <exec/types.h>
#include <exec/ports.h>
#include <exec/lists.h>
#include <exec/memory.h>
#include <utility/utility.h>

#include <clib/exec_protos.h>
#include <clib/alib_protos.h>
#include <clib/alib_stdio_protos.h>
#include <clib/utility_protos.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <clib/macros.h>

struct Library	*UtilityBase, *EasyGadgetsBase, *TimerBase;

struct List *list=NULL;
struct Screen *screen;
struct MsgPort	*port, *ioport;
struct RecallMsg	*recmsg;
struct timerequest		*timerIO;
struct MsgPort				*timerport;
ULONG								datenow, removed=0;
BYTE parsedirs=0;

#include "Version.h"
#include "Modules.h"
#include "ProjectStructures.h"
#include "AdjustYear.h"
#include "MakeDate.h"
#include "MakeTime.h"

#include "Purge_rev.h"
char version[]=VERSTAG;
#include "myinclude:mylist.h"

#include <clib/easygadgets_protos.h>
#include <libraries/easygadgets.h>
#include "EG:Macros.h"
struct EasyGadgets	*eg;

BYTE checkPurge(struct EventNode *eventnode)
{
	register struct List *list=eventnode->datelist;
	register struct Node *node;
	register BYTE mxpurge=FALSE;

	if(!IsNil(list))
		for(every_node)
		{
			register struct DateNode *datenode=(struct DateNode *)node;
			register ULONG eventdate=MakeDate(datenode);

			if(datenode->day & datenode->month & datenode->year)
				switch(datenode->whendate)
				{
					case EXACT:
					case BEFORE:
						if(datenow>eventdate & datenode->year>0)
							mxpurge|=TRUE;
						break;
					case AFTER:
						if(datenode->dateperiod>0 & datenow>eventdate+86400*datenode->dateperiod)
							mxpurge|=TRUE;
						break;
				}
			else
				mxpurge=FALSE;
		}
	return mxpurge;
}

void Purge(struct List *purgelist)
{
	register struct Node	*node=purgelist->lh_Head;

	while(node!=NULL & node!=list->lh_TailPred->ln_Succ)
	{
		register struct EventNode *eventnode=(struct EventNode *)node;
		register struct Node *nextnode=node->ln_Succ;

		if(node->ln_Type==REC_DIR)
		{
			if(parsedirs)
				Purge(eventnode->children);
		}
		else if(checkPurge(eventnode))
		{
			RemoveNode(node);
			++removed;
		}

		node=nextnode;
	}
}

void __main(char *BE_NICE)
{
	struct Message	*msg;

	if(UtilityBase=OpenLibrary("utility.library", 37L))
	{
		if(EasyGadgetsBase=OpenLibrary("easygadgets.library", 1L))
		{
			if(timerport=CreateMsgPort())
			{
				if(timerIO=(struct timerequest *)CreateExtIO(timerport, sizeof(struct timerequest)))
				{
					if(0==(OpenDevice(TIMERNAME, UNIT_VBLANK, (struct IORequest *)timerIO, 0L)))
					{
						TimerBase=(struct Library *)timerIO->tr_node.io_Device;

						Forbid();
						ioport=FindPort(RECALL_PORT);
						Permit();

						if(ioport)
						{
							if(port=CreateMsgPort())
							{
								if(recmsg=AllocMessage(port, OPERATOR_TYPE))
								{
									struct SignalSemaphore *semaphore;

									SendMessage(ioport, recmsg,
															REC_InitMessage,	TRUE,
															REC_GetEventList,	&list,
															REC_GetScreen,		&screen,
															TAG_DONE);
									parsedirs=(recmsg->flags & PARSEDIRS);

									Forbid();
									if(semaphore=FindSemaphore(EVENTSEMAPHORE))
										if(AttemptSemaphore(semaphore)==NULL)
											semaphore=NULL;
									Permit();

									datenow=MakeDate(NULL);
									if(semaphore)
									{
										if(list && screen)
											Purge(list);
										ReleaseSemaphore(semaphore);
									}

									SendMessage(ioport, recmsg,
															REC_UpdateData,		TRUE,
															TAG_DONE);

									egRequest(screen->FirstWindow,
														NAME " " VERS,
														"Purged %ld events from project.",
														"OK",
														(APTR)removed);
									FreeVec(recmsg);
								}
								DeleteMsgPort(port);
							}
							CloseDevice((struct IORequest *)timerIO);
						}
						DeleteExtIO((struct IORequest *)timerIO);
					}
					while(msg=GetMsg(timerport))
						ReplyMsg(msg);
					DeleteMsgPort(timerport);
				}
			}
			CloseLibrary(EasyGadgetsBase);
		}
		CloseLibrary(UtilityBase);
	}
}

#endif
