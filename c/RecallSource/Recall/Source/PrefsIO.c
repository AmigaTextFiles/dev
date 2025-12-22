/*
 *	File:					PrefsIO.c
 *	Description:	
 *
 *	(C) 1995, Ketil Hunn
 *
 */

#ifndef PREFSIO_C
#define PREFSIO_C

/*** INCLUDES ************************************************************************/
#include "System.h"
#include "System_Prefs.h"
#include "PrefsIO.h"
#include "ProjectIO.h"
#include "Asl.h"
#include "myinclude:Exists.h"
#include "Dirs.h"

/*** FUNCTIONS ***********************************************************************/

void SetEventWhenStrings(struct EventNode *eventnode)
{
	register struct List *list=eventnode->datelist;
	register struct Node *node;

	if(!IsNil(list))
		for(every_node)
			SetWhenString((struct DateNode *)node, FALSE);
}

__stackext __asm void SetWhenStrings(register __a0 struct List *list)
{
	register struct Node *node;

	if(!IsNil(list))
		for(every_node)
			if(node->ln_Type==REC_DIR && ((struct EventNode *)node)->children)
				SetWhenStrings(((struct EventNode *)node)->children);
			else
				SetEventWhenStrings((struct EventNode *)node);
}

LONG ReadProject(struct List *list, UBYTE *file, BYTE force)
{
	LONG	error=IFFERR_EOF;
#ifdef MYDEBUG_H
	DebugOut("ReadProject");
#endif

	egLockAllTasks(eg);
	DetachList(eventlistview, mainTask.window);
	DetachList(textlistview, textTask.window);
	ClearList(list);
	ClearList(dirlist);
	error=ReadIFF(eventlist=list, file);
	SetWhenStrings(list);
	GetFirstEvent();
	GetFirstText();
	GetFirstDate();
	UpdateAllTasks();
	UpdateMainMenu();
	egUnlockAllTasks(eg);
	env.changes=0;
	return error;
}

LONG OpenProject(struct List *list, UBYTE *file, BYTE force)
{
	LONG	error=IFFERR_EOF;

#ifdef MYDEBUG_H
	DebugOut("OpenProject");
#endif

	egLockAllTasks(eg);
	if(ConfirmActions(MSG_OPEN, force))
		if(FileRequest(	mainTask.window,
										MSG_OPENPROJECT,
										file,
										NULL,
										NULL,
										MSG_OPEN))
		{
			ReadProject(list, file, FALSE);
			SetWhenStrings(list);
		}
	egUnlockAllTasks(eg);
	return error;
}

LONG AppendProject(struct List *list, UBYTE *file)
{
	LONG	error=IFFERR_EOF;

#ifdef MYDEBUG_H
	DebugOut("AppendProject");
#endif

	egLockAllTasks(eg);
	if(FileRequest(mainTask.window,
									MSG_INCLUDEPROJECT,
									file,
									NULL,
									NULL,
									MSG_INCLUDE))
	{
		error=ReadIFF(list, file);
		SetWhenStrings(list);
		UpdateMainTask();
		++env.changes;
	}
	egUnlockAllTasks(eg);
	return error;
}

LONG SaveProject(struct List *list, UBYTE *file)
{
	LONG error;

#ifdef MYDEBUG_H
	DebugOut("SaveProject");
#endif

	egLockAllTasks(eg);
	if(OverwriteFile(file))
		error=WriteIFF(list, file);
	egUnlockAllTasks(eg);
	env.changes=0;

	return error;
}

LONG SaveProjectAs(struct List *list, UBYTE *file)
{
	LONG error;

#ifdef MYDEBUG_H
	DebugOut("SaveProjectAs");
#endif

	egLockAllTasks(eg);
	if(FileRequest(	mainTask.window,
									MSG_SAVEPROJECT,
									file,
									FRF_DOSAVEMODE,
									NULL,
									MSG_SAVE))
		if(OverwriteFile(file))
			error=WriteIFF(list, file);
	egUnlockAllTasks(eg);
	return error;
}

LONG LastSaved(struct List *list, UBYTE *file, BYTE force)
{
	LONG error;

#ifdef MYDEBUG_H
	DebugOut("LastSaved");
#endif

	egLockAllTasks(eg);
	if(ConfirmActions(MSG_RESTORE, force))
	{
		ClearList(list);
		ClearList(dirlist);
		error=ReadIFF(list, file);
		UpdateMainTask();
		env.changes=0;
/*
		if(record)
			AddARexxMacroCommand(	macro,
														ER_Command,		"OPEN '%s'",
														ER_Argument,	file,
														TAG_DONE);
*/
	}
	egUnlockAllTasks(eg);
//	SetAllPointers();
	return error;
}

BYTE OverwriteFile(UBYTE *file)
{
	register BYTE overwrite=TRUE;

	if(env.acknowledge && Exists(file))
		overwrite=egRequest(mainTask.window,
												NAME,
												egGetString(MSG_OVERWRITE),
												egGetString(MSG_OKCANCEL),
												(APTR)file,
												NULL);
	return overwrite;
}

#endif
