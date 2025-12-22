/*
 * $Id: pubwipeoutsemaphore.h,v 1.1 2005/12/21 19:48:23 itix Exp $
 *
 * :ts=4
 *
 * Wipeout -- Traces and munges memory and detects memory trashing
 *
 * Written by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
 * Public Domain
 */

#ifndef _PUBWIPEOUTSEMAPHORE_H
#define _PUBWIPEOUTSEMAPHORE_H 1

/****************************************************************************/

#include <utility/tagitem.h>

/****************************************************************************/

#define PUBWIPEOUTSEMAPHORENAME		"« Wipeout »"
#define PUBWIPEOUTSEMAPHOREVERSION	2
#define PUBWIPEOUTSEMAPHOREREVISION	1

/****************************************************************************/

typedef LONG (* WipeoutControlFunc)(void);

/****************************************************************************/

#pragma pack(2)
struct WipeoutSemaphore
{
	struct SignalSemaphore	ws_SignalSemaphore;	/* regular semaphore */
	WORD							ws_Version;				/* semaphore version number */
	WORD							ws_Revision;			/* semaphore revision number */

	WipeoutControlFunc		ws_ControlFunc;		/* uses M68k ABI */
};
#pragma pack()

/****************************************************************************/

#define WOT_BASE	(TAG_USER+20010602)

#define WOT_Address	(WOT_BASE+1)
#define WOT_SetPC	(WOT_BASE+2)

/****************************************************************************/

#endif /* _PUBWIPEOUTSEMAPHORE_H */
