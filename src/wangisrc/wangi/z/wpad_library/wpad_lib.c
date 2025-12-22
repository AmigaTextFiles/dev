/***************************************************************************
 * wpad_lib.c
 *
 * wpad.library, Copyright ©1995 Lee Kindness.
 *
 * 
 */

#include "wpad_global.h"

struct WPadBase
{
	struct Library LibNode;
	struct ExecBase *SysBase;
	struct SignalSemaphore LockSemaphore;
	BPTR LibSegment;
};

#define SysBase WPadBase->SysBase
#define LockSemaphore WPadBase->LockSemaphore
#define LibSegment WPadBase->LibSegment

STATIC struct Library * __asm __saveds LibInit(register __a0 BPTR Segment,register __d0 struct WPadBase *WPadBase,register __a6 struct ExecBase *ExecBase);
STATIC struct Library * __asm __saveds LibOpen(register __a6 struct WPadBase *WPadBase);
STATIC BPTR __asm __saveds LibExpunge(register __a6 struct WPadBase *WPadBase);
STATIC BPTR __asm __saveds LibClose(register __a6 struct WPadBase *WPadBase);
STATIC LONG __asm __saveds LibNull(register __a6 struct WPadBase *WPadBase);

STATIC APTR LibVectors[] =
{
	LibOpen,
	LibClose,
	LibExpunge,
	LibNull,
	
	WP_OpenPadA,
	WP_ClosePadA,
	WP_SetPadAttrsA,
	WP_GetPadAttrsA,
	WP_PadCount,

	(APTR)-1
};

extern UBYTE __far LibName[],
                   LibID[];

extern LONG __far LibVersion,
                  LibRevision;

struct { ULONG DataSize; APTR Table; APTR Data; struct WPadBase * (*Init)(); } __aligned LibInitTab =
{
	sizeof(struct WPadBase),
	LibVectors,
	NULL,
	LibInit
};

STATIC struct WPadBase * __asm __saveds
LibInit(register __a0 BPTR Segment,register __d0 struct WPadBase *WPadBase,register __a6 struct ExecBase *ExecBase)
{
	WPadBase->LibNode.lib_Node.ln_Type = NT_LIBRARY;
	WPadBase->LibNode.lib_Node.ln_Name = LibName;
	WPadBase->LibNode.lib_Flags = LIBF_CHANGED | LIBF_SUMUSED;
	WPadBase->LibNode.lib_Version = LibVersion;
	WPadBase->LibNode.lib_Revision = LibRevision;
	WPadBase->LibNode.lib_IdString = (APTR)LibID;

	LibSegment = Segment;
	SysBase = ExecBase;

	InitSemaphore(&LockSemaphore);
	InitSemaphore(&EntrySem);

	if(SysBase->LibNode.lib_Version < 37)
		return(NULL);
	else
		return(WPadBase);
}

STATIC struct Library * __asm __saveds
LibOpen(register __a6 struct WPadBase *WPadBase)
{
	WPadBase->LibNode.lib_Flags &= ~LIBF_DELEXP;

	WPadBase->LibNode.lib_OpenCnt++;

	if(WPadBase->LibNode.lib_OpenCnt == 1)
	{
		ObtainSemaphore(&LockSemaphore);

		if(WPP_Init())
			ReleaseSemaphore(&LockSemaphore);
		else
		{
			WPP_Exit();

			ReleaseSemaphore(&LockSemaphore);

			WPadBase->LibNode.lib_OpenCnt--;

			return(NULL);
		}
	}

	return(WPadBase);
}

STATIC BPTR __asm __saveds
LibExpunge(register __a6 struct WPadBase *WPadBase)
{
	if(!WPadBase->LibNode.lib_OpenCnt && LibSegment)
	{
		BPTR TempSegment = LibSegment;

		Remove((struct Node *)WPadBase);

		FreeMem((BYTE *)WPadBase - WPadBase->LibNode.lib_NegSize,WPadBase->LibNode.lib_NegSize + WPadBase->LibNode.lib_PosSize);

		return(TempSegment);
	}
	else
	{
		WPadBase->LibNode.lib_Flags |= LIBF_DELEXP;

		return(NULL);
	}
}

STATIC BPTR __asm __saveds
LibClose(register __a6 struct WPadBase *WPadBase)
{
	if(WPadBase->LibNode.lib_OpenCnt > 0)
		WPadBase->LibNode.lib_OpenCnt--;

	if(!WPadBase->LibNode.lib_OpenCnt)
	{
		ObtainSemaphore(&LockSemaphore);
		ObtainSemaphore(&EntrySem);

		WPP_Exit();

		ReleaseSemaphore(&EntrySem);
		ReleaseSemaphore(&LockSemaphore);

		if(WPadBase->LibNode.lib_Flags & LIBF_DELEXP)
			return(LibExpunge(WPadBase));
	}

	return(NULL);
}

STATIC LONG __asm __saveds
LibNull(register __a6 struct WPadBase *WPadBase)
{
	return(NULL);
}
