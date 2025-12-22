/*
 *	File:					SleepPointer.h
 *	Description:	Puts up a sleep pointer and blocks the input in a window
 *
 *	(C) 1994, Ketil Hunn
 *
 */

#ifndef MR_SLEEPPOINTER_H
#define MR_SLEEPPOINTER_H

#include <intuition/intuitionbase.h>
#include <clib/intuition_protos.h>

extern struct IntuitionBase *IntuitionBase;

UWORD __chip mr_waitPointer[] = {
	0x0000,	0x0000,
	0x0400, 0x07C0,
	0x0000, 0x07C0,
	0x0100, 0x0380,
	0x0000, 0x07E0,
	0x07C0, 0x1FF8,
	0x1FF0, 0x3FEC,
	0x3FF8, 0x7FDE,
	0x3FF8, 0x7FBE,
	0x7FFC, 0xFF7F,
	0x7EFC, 0xFFFF,
	0x7FFC, 0xFFFF,
	0x3FF8, 0x7FFE,
	0x3FF8, 0x7FFE,
	0x1FF0, 0x3FFC,
	0x07C0, 0x1FF8,
	0x0000, 0x07E0,
	0x0000, 0x0000
};

__asm __saveds APTR mrLockWindow(register __a0 struct Window *window)
{
#ifdef MYDEBUG_H
	DebugOut("LockWindow");
#endif

	if(window)
	{
		struct Requester	*null_request;

		null_request=AllocVec(sizeof(struct Requester), 0);
		InitRequester(null_request);
		Request(null_request, window);

		if(IntuitionBase->LibNode.lib_Version>=39)
		{
			SetWindowPointer( window,
												WA_BusyPointer, TRUE,
												WA_PointerDelay,TRUE,
												TAG_END);
		}
		else
			SetPointer(window, mr_waitPointer, 16, 16, -6, 0);

		return null_request;
	}
	return NULL;
}

__asm __saveds void mrUnlockWindow(	register __a0 struct Window *window,
																		register __a1 APTR lock)
{
#ifdef MYDEBUG_H
	DebugOut("UnlockWindow");
#endif
	if(window)
	{
		EndRequest(lock, window);
		FreeVec(lock);

		if(IntuitionBase->LibNode.lib_Version>=39)
			SetWindowPointer(window, TAG_END);
		else
			ClearPointer(window);
	}
}

#endif
