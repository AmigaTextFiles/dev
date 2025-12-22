/*
 *	File:					DateList.c
 *	Description:	Makes the computing of dates a lot faster
 *
 *	(C) 1994,1995, Ketil Hunn
 *
 */

#ifndef	DATELIST_C
#define	DATELIST_C

/*** PRIVATE INCLUDES ****************************************************************/
#include "System.h"
#include "System_Recall.h"
#include "DateList.h"
#include "list.h"
#include "AdjustYear.h"
#include "MakeDate.h"
#include "MakeTime.h"
#include "CheckDateTime.h"
#include "myinclude:myAlert.h"
#include "myinclude:myEasyRequest.h"
#include "myinclude:Execute.h"
#include "ErrorFuncs.h"
#include "TASK_Attrib.h"
#include "Hotkey.h"
#include "CalcField.h"

#include <clib/timer_protos.h>

/*** GLOBALS *************************************************************************/
LONG	datenow, olddatenow, timenow;

/*** FUNCTIONS ***********************************************************************/
struct QuickNode *AddQuickNode(	struct List				*list,
																struct EventNode	*eventnode,
																struct DateNode		*datenode)
{
	struct QuickNode *quicknode;

#ifdef MYDEBUG_H
	DebugOut("AddQuickNode");
#endif
	if(quicknode=AllocVec(sizeof(struct QuickNode), MEMF_CLEAR))
	{
		if(datenode)
		{
			quicknode->date				=MakeDate(datenode);
			quicknode->time				=MakeTime(datenode);
		}
		quicknode->eventnode	=eventnode;
		quicknode->datenode		=datenode;
		quicknode->nn_Node.ln_Type=REC_QUICK;
		AddTail(list, (struct Node *)quicknode);
	}
	else
		FailAlert(MSG_OUTOFMEMORY);
	return quicknode;
}

void CreateQuickList(struct List *quicklist, struct List *list)
{
	struct Node *node;

#ifdef MYDEBUG_H
	DebugOut("CreateQuickList");
#endif
	for(every_node)
	{
		struct EventNode *eventnode=(struct EventNode *)node;

		if(node->ln_Type==REC_DIR)
			CreateQuickList(quicklist, eventnode->children);
		else
		{
			struct List *list=eventnode->datelist;
			struct Node	*node;

			if(IsNil(list))
				AddQuickNode(quicklist, eventnode, NULL);
			else
				for(every_node)
					AddQuickNode(quicklist, eventnode, (struct DateNode *)node);
		}
	}
}

BYTE MarkDisplay(struct List *list, BYTE startup)
{
	struct Node				*node;
	struct EventNode	*eventnode;
	struct QuickNode	*quicknode;
	BYTE 							show=FALSE;

#ifdef MYDEBUG_H
	DebugOut("MarkDisplay");
#endif

	for(every_node)
	{
		quicknode=(struct QuickNode *)node;
		eventnode=quicknode->eventnode;

		if((eventnode->show!=NEVER & eventnode->datestamp!=datenow))
			if((eventnode->show==STARTUP & startup==TRUE) | eventnode->show!=STARTUP)
			{
				if(eventnode->datestamp==POSTPONE_STAMP)
					show=quicknode->eventnode->display=1;
				else
					show|=quicknode->eventnode->display|=CheckNodeDateTime(quicknode);
			}
	}
	return show;
}

void ExecuteNode(struct EventNode *eventnode)
{
	register struct Node	*node;
	register BYTE					multitask=ISBITSET(eventnode->flags, MULTITASK);

	for(node=eventnode->textlist->lh_Head; node->ln_Succ; node=node->ln_Succ)
	{
		switch(eventnode->type)
		{
			case CLI_TYPE:
				StartCLIProgram(node->ln_Name,
												eventnode->dir,
												eventnode->stack,
												eventnode->priority,
												multitask);
				break;
			case WB_TYPE:
				WBStartApp(node->ln_Name, eventnode->dir, multitask);
				break;
			case AREXX_TYPE:
				StartArexxProgram(node->ln_Name, eventnode->dir);
				break;
		}
	}
}

BYTE CheckProject(struct List *list, BYTE startup)
{
	BYTE update=FALSE;

#ifdef MYDEBUG_H
	DebugOut("CheckProject");
#endif

	datenow=MakeDate(NULL);
	timenow=MakeTime(NULL);

	if(datenow!=olddatenow)
	{
		ClearList(list);
		CreateQuickList(list, eventlist);
		olddatenow=datenow;
	}

	if(MarkDisplay(list, startup))
	{
		char *text;

		if(text=AllocVec(buffersize, MEMF_CLEAR))
		{
			struct Node				*node;
			LONG							retvalue;
			UBYTE							buttons[MAXCHARS];

			for(every_node)
			{
				struct QuickNode	*quicknode=(struct QuickNode *)node;
				struct EventNode	*eventnode=quicknode->eventnode;
				BYTE	centre		=ISBITSET(eventnode->flags, CENTRE),
							confirm		=ISBITSET(eventnode->flags, CONFIRM),
							postpone	=ISBITSET(eventnode->flags, POSTPONE),
							group			=ISBITSET(eventnode->flags, GROUP);
				retvalue=1;

				if(quicknode->eventnode->display==TRUE)
				{
					if(group)
						CatGroupEventsTexts(node, eventnode->type, text);
					else
						CatSingleEventTexts(quicknode, text);
			
					if(strlen(text))
					{
						if(ISBITSET(eventnode->flags, FLASH))
							DisplayBeep(NULL);

						if(eventnode->type==REQUESTER_TYPE)
							strcpy(buttons, GetString(&li, MSG_OK));
						else
							strcpy(buttons, GetString(&li, MSG_YES));

						if(postpone)
							strcat(buttons, GetString(&li, MSG_POSTPONE));

						if(confirm)
							if(eventnode->type==REQUESTER_TYPE)
								strcat(buttons, GetString(&li, MSG_CANCEL));
							else
								strcat(buttons, GetString(&li, MSG_NO));

						switch(eventnode->type)
						{
							case HOTKEY_TYPE:
								if(confirm)
									retvalue=ShowRequest(	eventnode->screen,
																				GetString(&li, MSG_GENERATEINPUT),
																				buttons,
																				centre,
																				text);
								if(retvalue==1)
									SendHotkey(text);
								break;
							case REQUESTER_TYPE:
									retvalue=ShowRequest(eventnode->screen, text, buttons, centre, NULL);
								break;
							case REDALERT_TYPE:
							case YELLOWALERT_TYPE:
								if(confirm)
									strcat(text, GetString(&li, MSG_ALERTCONFIRM));
								retvalue=myAlert((eventnode->type==REDALERT_TYPE ? DEADEND_ALERT:RECOVERY_ALERT),text, eventnode->timeout);
								break;
							case CLI_TYPE:
							case WB_TYPE:
							case AREXX_TYPE:
								if(confirm)
										retvalue=ShowRequest(	eventnode->screen,
																					(eventnode->type==AREXX_TYPE ?
																							GetString(&li, MSG_SENDAREXXCOMMAND) :
																							GetString(&li, MSG_EXECUTEEVENT)),
																					buttons,
																					centre,
																					text);
								if(retvalue==1)
									if(group)
									{
										struct Node	*enode;

										ExecuteNode(eventnode);
										for(enode=node; enode->ln_Succ; enode=enode->ln_Succ)
										{
											struct EventNode	*tmpnode=(struct EventNode *)enode;
											if(	tmpnode->type==eventnode->type &
													tmpnode->datestamp==GROUP_STAMP)
											{
												if(ISBITSET(tmpnode->flags, FLASH))
													DisplayBeep(NULL);
												ExecuteNode(tmpnode);
											}
										}
									}
									else
										ExecuteNode(eventnode);
								break;
						}
					}
					quicknode->eventnode->display=TRUE;
				}
				if(eventnode->datestamp==GROUP_STAMP | quicknode->eventnode->display==TRUE)
				{
					quicknode->eventnode->display=FALSE;
					switch(retvalue)
					{
						case 1:
							if(eventnode->show==DAILY)
							{
								eventnode->datestamp=datenow;
								update=TRUE;
							}
							break;
						case 2:
							eventnode->datestamp=POSTPONE_STAMP;
							update=TRUE;
							break;
						case 0:
							if(confirm)
							{
								eventnode->datestamp=datenow;
								update=TRUE;
							}
							break;
					}
				}
				*text='\0';
			}
			FreeVec(text);
		}
		else
			FailAlert(MSG_OUTOFMEMORY);
	}
	return update;
}


char *CatSingleEventTexts(struct QuickNode *quicknode, char *text)
{
#ifdef MYDEBUG_H
	DebugOut("CatSingleEventTexts");
#endif

	if(quicknode->eventnode->display==TRUE)
	{
		UBYTE line[MAXCHARS];
		struct List *list=quicknode->eventnode->textlist;
		struct Node *node;

		quicknode->eventnode->display=FALSE;
		if(ISBITSET(quicknode->eventnode->flags, GROUP))
			quicknode->eventnode->datestamp=GROUP_STAMP;
		for(every_node)
		{
			UBYTE newtext[300]="\0";
			strcpy(line, node->ln_Name);
			strcat(text, ParseFields(quicknode, newtext, line));
			if(node!=list->lh_TailPred)
				strcat(text, "\n");
		}
		return text;
	}
	return NULL;
}

char *CatGroupEventsTexts(struct Node *innode, short type, char *text)
{
	struct QuickNode	*quicknode;
	struct EventNode	*eventnode;
	struct Node				*node;
	char   						*tmp;
	BYTE   						newline=FALSE;

#ifdef MYDEBUG_H
	DebugOut("CatGroupEventsTexts");
#endif

	if(tmp=AllocVec(buffersize, MEMF_CLEAR))
	{
		for(node=innode; node->ln_Succ; node=node->ln_Succ)
		{
			quicknode=(struct QuickNode *)node;
			eventnode=quicknode->eventnode;
			if(	eventnode->type==type & eventnode->display==1 & 
					ISBITSET(eventnode->flags, GROUP)>0)
			{
				if(!newline)
					newline=TRUE;
				else
					strcat(text, "\n");
				*tmp='\0';
				strcat(text, CatSingleEventTexts(quicknode, tmp));
			}
		}
		FreeVec(tmp);
	}
	else
		FailAlert(MSG_OUTOFMEMORY);
	return text;
}

LONG ShowRequest(	UBYTE *screenname,
									UBYTE *text,
									UBYTE *buttons,
									BYTE	centre,
									UBYTE *params)
{
	struct Window *window;
	LONG val;

#ifdef MYDEBUG_H
	DebugOut("ShowRequest");
#endif

	if(window=OpenWindowTags(	NULL,
														WA_Width,							1,
														WA_Height,						1,
														WA_PubScreenName,			screenname,
														WA_PubScreenFallBack,	TRUE,
														TAG_DONE))
	{
		if(usereqtools==TRUE & ReqToolsBase!=NULL)
		{
			struct Process *myproc;
			APTR oldwinptr;
			LONG tags[5];

			tags[0]=RTEZ_ReqTitle;
			tags[1]=(ULONG)(title);
			tags[2]=RT_ReqPos;
			tags[4]=TAG_DONE;

			myproc=(struct Process *)FindTask(NULL);
			oldwinptr=myproc->pr_WindowPtr;
			myproc->pr_WindowPtr=window;

			if(centre)
			{
				tags[3]=REQPOS_CENTERSCR;
				val=rtEZRequest(text, buttons, NULL, (struct TagItem *)tags, params);
			}
			else
			{
				tags[3]=REQPOS_POINTER;
				val=rtEZRequest(text, buttons, NULL, (struct TagItem *)tags, params);
			}
			myproc->pr_WindowPtr=oldwinptr;
		}
		else
			val=myEasyRequest(window, title, text, buttons, params);

		CloseWindow(window);
	}

	return val;
}

void SendTimeIO(struct timerequest *timerIO, ULONG secs, ULONG micros)
{
#ifdef MYDEBUG_H
	DebugOut("SendTimeIO");
#endif
	timerIO->tr_node.io_Command	=TR_ADDREQUEST;
	timerIO->tr_time.tv_secs		=secs;
	timerIO->tr_time.tv_micro		=micros;
	SendIO((struct IORequest *)timerIO);
}

/*
void SynchronizeTimer(void)
{
	struct timeval		tv;
	struct ClockData	clockdata;

	GetSysTime(&tv);
	Amiga2Date(tv.tv_secs, &clockdata);
	Delay((60-clockdata.sec)*50);
}
*/

#endif
