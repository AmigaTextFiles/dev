/*
 *	File:					HandleModules.c
 *	Description:	Handles import, export, operator and displayer modules
 *
 *	(C) 1994,1995 Ketil Hunn
 *
 */

#ifndef HANDLEMODULES_C
#define HANDLEMODULES_C

/*** INCLUDES ************************************************************************/
#include "System.h"
#include "System_Prefs.h"
#include "RecallModules.h"
#include "myinclude:Execute.h"
#include "Dirs.h"
#include "Asl.h"

/*** GLOBALS *************************************************************************/
UBYTE moduleio[MAXCHARS];

extern BYTE keyok;

/*** FUNCTIONS ***********************************************************************/
BYTE LaunchModule(ULONG base)
{
	UBYTE module[MAXCHARS], doit=FALSE;

#ifdef MYDEBUG_H
	DebugOut("LaunchModule");
#endif

	strcpy(moduleio, project);
	if(base<SAVERBASE)
		sprintf(module, "%s/" LOADERSDIR "/%s", startdir, (egGetNode(loaders, base-LOADERBASE))->ln_Name);
	else if(base<OPERATORBASE)
		sprintf(module, "%s/" SAVERSDIR "/%s", startdir, (egGetNode(savers, base-SAVERBASE))->ln_Name);
	else if(base<DISPLAYERBASE)
		sprintf(module, "%s/" OPERATORSDIR "/%s", startdir, (egGetNode(operators, base-OPERATORBASE))->ln_Name);
	else
		sprintf(module, "%s/" DISPLAYERSDIR "/%s", startdir, (egGetNode(displayers, base-DISPLAYERBASE))->ln_Name);

	if(base<OPERATORBASE)
	{
		register BYTE import=(base<SAVERBASE);

		if(FileRequest(	mainTask.window,
										(import ? MSG_IMPORT : MSG_EXPORT),
										moduleio,
										(import ? 0: FRF_DOSAVEMODE), NULL,
										MSG_OK))
		{
			if(base<SAVERBASE)
				NewProject(FALSE);
			doit=TRUE;
		}
	}
	else
		doit=TRUE;

	if(doit)
		if(0>WBStartApp(module, NULL, TRUE))
			FailRequest(mainTask.window, MSG_NOTFOUND, (APTR)module, NULL);

	return TRUE;
}

void HandleModule(void)
{
	struct RecallMsg *msg;

#ifdef MYDEBUG_H
	DebugOut("HandleModule");
#endif

	while(msg=(struct RecallMsg *)GetMsg(ioport))
	{
		struct TagItem	*tstate;
		struct TagItem	*tag;
		ULONG						*p;

		tstate=msg->taglist;
		while(tag=NextTagItem(&tstate))
		{
			p=(ULONG *)tag->ti_Data;

			switch(tag->ti_Tag)
			{
				case REC_InitMessage:
					msg->version	=VERSION;
					msg->revision	=REVISION;
//					msg->flags	 |=(env.parsedirs ? PARSEDIRS:0);
					msg->name			=moduleio;
					break;
				case REC_GetScreen:
					*p=(ULONG)mainTask.screen;
					break;
				case REC_GetEventList:
//					*p=(ULONG)(env.affectall ? rootlist:eventlist);
					break;
				case REC_GetTextList:
					*p=(ULONG)(eventnode ? eventnode->textlist:NULL);
					break;
				case REC_GetDateList:
					*p=(ULONG)(eventnode ? eventnode->datelist:NULL);
					break;
				case REC_GetEvent:
					*p=(ULONG)eventnode;
					break;
				case REC_GetText:
					*p=(ULONG)textnode;
					break;
				case REC_GetDate:
					*p=(ULONG)datenode;
					break;
				case REC_JumpToEvent:
					ClearList(dirlist);
//					jumptoevent=FALSE;
//					JumpToEvent(rootlist, (struct EventNode *)tag->ti_Data);
					break;
				case REC_SleepWindows:
					if(tag->ti_Data)
					{
						egLockAllTasks(eg);
						DetachList(eventlistview, mainTask.window);
						if(textTask.status==STATUS_OPEN)
							DetachList(textlistview, textTask.window);
					}
					else
					{
						egUnlockAllTasks(eg);
						AttachList(eventlistview, mainTask.window, eventlist);
						if(textTask.status==STATUS_OPEN)
							AttachList(textlistview, textTask.window, textlist);
					}
					break;
				case REC_ClearList:
					ClearList((struct List *)tag->ti_Data);
					break;
				case REC_UpdateData:
					eventnode=NULL;
//					ResetAllWindows();
					UpdateAllTasks();
					UpdateMainMenu();
					env.changes=0;
					break;
				case REC_PutRootList:
					eventlist=(struct List *)tag->ti_Data;
					break;
				case REC_PutEventList:
					eventlist=(struct List *)tag->ti_Data;
					break;
				case REC_PutTextList:
					if(eventnode)
						eventnode->textlist=(struct List *)tag->ti_Data;
					break;
				case REC_PutDateList:
					if(eventnode)
						eventnode->datelist=(struct List *)tag->ti_Data;
					break;
				case REC_GetRootList:
					*p=(ULONG)rootlist;
					break;
				case REC_AddEvent:
					*p=(ULONG)AddEventNode(msg->list, NULL, msg->name);
					break;
				case REC_AddDate:
					*p=(ULONG)AddDateNode(msg->list, NULL, msg->name);
					break;
				case REC_AddText:
					*p=(ULONG)AddNode(msg->list, NULL, msg->name);
					break;
				case REC_SetWhenString:
					SetWhenString((struct DateNode *)tag->ti_Data, FALSE);
					break;
				case REC_KeyOK:
					*p=(ULONG)keyok;
					break;
			}
		}
		ReplyMsg((struct Message *)msg);
	}
}

#endif
