/*
 * $Id: data.h 1.3 1998/04/18 15:44:53 olsen Exp olsen $
 *
 * :ts=4
 *
 * Blowup -- Catches and displays task errors
 *
 * Written by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
 * Public Domain
 */

#ifndef _GLOBAL_H
#include "global.h"
#endif	/* _GLOBAL_H */

/******************************************************************************/

#ifndef global
#define global extern
#endif	/* global */

/******************************************************************************/

extern struct ExecBase *	SysBase;
extern struct Library *		DOSBase;

/******************************************************************************/

global struct Library * IntuitionBase;

/******************************************************************************/

global struct Device * TimerBase;	/* required for GetSysTime() */

/******************************************************************************/

#if !defined(__SASC) || defined(_M68020)
global struct Library *	UtilityBase;
#else
extern struct Library *	UtilityBase;
#endif

/******************************************************************************/

global BOOL ARegCheck;		/* run all address registers through SegTracker? */
global BOOL DRegCheck;		/* run all data registers through SegTracker? */
global BOOL StackCheck;		/* run stack contents through SegTracker? */
global LONG StackLines;		/* number of stack lines to show on each hit. */

/******************************************************************************/

global UBYTE ProgramName[60];	/* program name: Blowup */

/******************************************************************************/

global struct SignalSemaphore BusySemaphore; /* held while a requester is being shown */

/******************************************************************************/
