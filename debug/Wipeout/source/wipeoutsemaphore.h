/*
 * $Id: wipeoutsemaphore.h 1.7 1998/04/14 09:28:17 olsen Exp olsen $
 *
 * :ts=4
 *
 * Wipeout -- Traces and munges memory and detects memory trashing
 *
 * Written by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
 * Public Domain
 */

#ifndef _WIPEOUTSEMAPHORE_H
#define _WIPEOUTSEMAPHORE_H 1

/****************************************************************************/

#include <utility/tagitem.h>

/****************************************************************************/

#define WIPEOUTSEMAPHORENAME		"« Wipeout »"
#define WIPEOUTSEMAPHOREVERSION		2
#define WIPEOUTSEMAPHOREREVISION	1

/****************************************************************************/

typedef LONG (* ASM WipeoutControlFunc)(REG(a0) struct TagItem *tags);

/****************************************************************************/

struct WipeoutSemaphore
{
	struct SignalSemaphore	ws_SignalSemaphore;	/* regular semaphore */
	WORD					ws_Version;			/* semaphore version number */
	WORD					ws_Revision;		/* semaphore revision number */

	WipeoutControlFunc		ws_ControlFunc;

	UBYTE					ws_SemaphoreName[(sizeof(WIPEOUTSEMAPHORENAME)+3) & ~3];

	struct Task *			ws_WipeoutTask;		/* semaphore creator */
	ULONG					ws_WakeupMask;		/* mask to wake creator with */

	struct Task *			ws_Client;			/* client interfacing to creator */
	LONG					ws_Command;			/* command to perform by creator */
	APTR					ws_Parameter;		/* parameter for command */
	LONG					ws_Error;			/* creator result code */

	BOOL *					ws_IsActive;		/* all options */
	BOOL *					ws_ShowFail;
	BOOL *					ws_CheckConsistency;
	BOOL *					ws_WaitAfterHit;
	BOOL *					ws_NameTag;
	BOOL *					ws_NoReuse;
	BOOL *					ws_ARegCheck;
	BOOL *					ws_DRegCheck;
	BOOL *					ws_StackCheck;
	LONG *					ws_StackLines;
	LONG *					ws_CheckDelay;
};

/****************************************************************************/

/* the commands the Wipeout semaphore owner knows */
enum
{
	WIPEOUTCMD_UpdateFilterList,
	WIPEOUTCMD_NewCheckDelay,
	WIPEOUTCMD_Remunge,
	WIPEOUTCMD_Mark,
	WIPEOUTCMD_Unmark,
	WIPEOUTCMD_ShowUnmarked,
};

/****************************************************************************/

#define WOT_BASE (TAG_USER+20010602)

#define WOT_Address	(WOT_BASE+1)
#define WOT_SetPC	(WOT_BASE+2)

/****************************************************************************/

#endif /* _WIPEOUTSEMAPHORE_H */
