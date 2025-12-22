/*
 * $Id: segtracker.c,v 1.3 2009/02/23 01:24:09 piru Exp $
 *
 * :ts=4
 *
 * Wipeout -- Traces and munges memory and detects memory trashing
 *
 * Written by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
 * Public Domain
 */

#ifndef _GLOBAL_H
#include "global.h"
#endif	/* _GLOBAL_H */

/******************************************************************************/

#ifndef __MORPHOS__
typedef char (* ASM SegTrack(REG(a0) ULONG		Address,
                             REG(a1) ULONG *	SegNum,
                             REG(a2) ULONG *	Offset));
#endif

#pragma pack(2)
struct SegSem
{
	struct SignalSemaphore	seg_Semaphore;
	APTR							seg_Find;
};
#pragma pack()

/******************************************************************************/

BOOL
FindAddress(
	ULONG	address,
	LONG	nameLen,
	STRPTR	nameBuffer,
	ULONG *	segmentPtr,
	ULONG *	offsetPtr)
{
	STRPTR name;
	BOOL found = FALSE;

	if (address == 0)
	{
		return FALSE;
	}

	Forbid();

	/* map the address to a name and a hunk/offset index */
	REG_A0	= address;
	REG_A1	= (ULONG)segmentPtr;
	REG_A2	= (ULONG)offsetPtr;
	name		= (STRPTR)MyEmulHandle->EmulCallDirect68k(SegTracker->seg_Find);
	if(name != NULL)
	{
		StrcpyN(nameLen,nameBuffer,name);

		found = TRUE;
	}

	Permit();

	if (!found)
	{
		if ((address >= ModuleStart) && (address < ModuleStart+ModuleSize))
		{
			StrcpyN(nameLen,nameBuffer,"Module");
			*segmentPtr=0;
			*offsetPtr=address - ModuleStart;
			found = TRUE;
		}
		else
		if ((address >= EmulationStart) && (address < EmulationStart+EmulationSize))
		{
			StrcpyN(nameLen,nameBuffer,"Emulation");
			*segmentPtr=0;
			*offsetPtr=address - EmulationStart;
			found = TRUE;
		}
	}

	return(found);
}
