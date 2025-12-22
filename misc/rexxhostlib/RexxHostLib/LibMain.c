/*
**	rexxhost.library - ARexx host management support library
**
**	Copyright © 1990-1992 by Olaf `Olsen' Barthel
**		All Rights Reserved
*/

#include "rexxhost.h"

	/* The structure expected by the library loader (auto-init). */

struct InitTable
{
	ULONG	 it_DataSize;	/* Data size to allocate. */
	APTR	*it_FuncTable;	/* Pointer to function table. */
	APTR	 it_DataInit;	/* Pointer to data initializers (remember InitStruct?). */
	APTR	 it_InitFunc;	/* The real library init function. */
};

	/* Protos for this module. */

struct RexxHostBase * __saveds __asm	LibInit(register __d0 struct RexxHostBase *RexxHostBase,register __a0 BPTR SegList);
struct RexxHostBase * __saveds __asm	LibOpen(register __a6 struct RexxHostBase *RexxHostBase);
BPTR __saveds __asm			LibClose(register __a6 struct RexxHostBase *RexxHostBase);
BPTR __saveds __asm			LibExpunge(register __a6 struct RexxHostBase *RexxHostBase);

	/* Pointer to library segment list. */

BPTR			 LibSegList;

	/* ASCII library ID. */

UBYTE __aligned LibName[]	= "rexxhost.library";
UBYTE __aligned LibID[]		= VSTRING;

	/* File version string. */

STATIC UBYTE VersionTag[]	= VERSTAG;

	/* Global library base IDs. */

struct RxsLib		*RexxSysBase;
struct ExecBase		*SysBase;

	/* The list of library functions. */

APTR __aligned LibFuncTab[] =
{
	LibOpen,		/* Standard library routines. */
	LibClose,
	LibExpunge,
	NULL,

	CreateRexxHost,		/* Now for the real stuff. */
	DeleteRexxHost,
	SendRexxCommand,
	FreeRexxCommand,
	ReplyRexxCommand,
	GetRexxCommand,
	GetRexxArg,
	GetRexxResult1,
	GetRexxResult2,
	GetToken,
	GetStringValue,
	BuildValueString,
	RexxStrCmp,
	GetRexxMsg,
	SendRexxMsg,
	GetRexxString,
	GetRexxClip,

	(APTR)-1		/* End marker. */
};

	/* The romtag needs this. */

struct InitTable LibInitTab =
{
	sizeof(struct RexxHostBase),	/* Lib base. */
	LibFuncTab,			/* Function table. */
	NULL,				/* No data init table (we'll do autoinit). */
	LibInit				/* Lib init routine. */
};

	/* LibInit(RexxHostBase,SegList):
	 *
	 *	Does the main library initialization, expects
	 *	all arguments in registers.
	 */

struct RexxHostBase * __saveds __asm
LibInit(register __d0 struct RexxHostBase *RexxHostBase,register __a0 BPTR SegList)
{
	SysBase = *(struct ExecBase **)4;

		/* Remember segment list. */

	LibSegList = SegList;

		/* Fill in the library node head. */

	RexxHostBase -> LibNode . lib_Node . ln_Type	= NT_LIBRARY;
	RexxHostBase -> LibNode . lib_Node . ln_Name	= LibName;

		/* Set the remaining flags. */

	RexxHostBase -> LibNode . lib_Flags		= LIBF_SUMUSED | LIBF_CHANGED;
	RexxHostBase -> LibNode . lib_Version		= VERSION;
	RexxHostBase -> LibNode . lib_Revision		= REVISION;
	RexxHostBase -> LibNode . lib_IdString		= (APTR)LibID;

		/* Return the result (surprise!). */

	return(RexxHostBase);
}

	/* LibOpen():
	 *
	 *	Library open routine.
	 */

struct RexxHostBase * __saveds __asm
LibOpen(register __a6 struct RexxHostBase *RexxHostBase)
{
	if(!RexxHostBase -> LibNode . lib_OpenCnt)
	{
		if(!(RexxHostBase -> RexxSysBase = RexxSysBase = (struct RxsLib *)OpenLibrary(RXSNAME,0)))
			return(NULL);
	}

		/* Increment open count and prevent delayed
		 * expunges.
		 */

	RexxHostBase -> LibNode . lib_OpenCnt++;
	RexxHostBase -> LibNode . lib_Flags &= ~LIBF_DELEXP;

		/* Return base pointer. */

	return(RexxHostBase);
}

	/* LibClose():
	 *
	 *	Closes the library.
	 */

BPTR __saveds __asm
LibClose(register __a6 struct RexxHostBase *RexxHostBase)
{
	BPTR SegList = ZERO;

		/* Is the library user count ok? */

	if(RexxHostBase -> LibNode . lib_OpenCnt)
	{
			/* Decrement user count. */

		RexxHostBase -> LibNode . lib_OpenCnt--;

			/* Try the expunge. */

		SegList = LibExpunge(RexxHostBase);
	}
	else
	{
		/* One close request after the lib has already
		 * shut down? We'll call Mr. Guru.
		 */

		Alert(AT_Recovery | AG_CloseLib,RexxHostBase);
	}

		/* Return the segment list, ramlib will know
		 * what to do with it.
		 */

	return(SegList);
}

	/* LibExpunge(RexxHostBase):
	 *
	 *	Expunge library, careful: this can be called by
	 *	ramlib without the rest of the library knowing
	 *	about it.
	 */

BPTR __saveds __asm
LibExpunge(register __a6 struct RexxHostBase *RexxHostBase)
{
	BPTR SegList = ZERO;

		/* Is the user count zero, the delayed expunge flag
		 * set and do we have a valid segment list?
		 */

	if(!RexxHostBase -> LibNode . lib_OpenCnt && (RexxHostBase -> LibNode . lib_Flags & LIBF_DELEXP) && LibSegList)
	{
			/* Remember segment list. */

		SegList = LibSegList;

			/* Set real segment list to zero which will
			 * hopefully keep us from getting expunged
			 * twice.
			 */

		LibSegList = ZERO;

			/* Remove library from lib list. */

		Remove(&RexxHostBase -> LibNode . lib_Node);

			/* Close the libraries. */

		if(RexxSysBase)
			CloseLibrary(RexxSysBase);

			/* Free library/jump table memory. */

		FreeMem((BYTE *)((ULONG)RexxHostBase - RexxHostBase -> LibNode . lib_NegSize),RexxHostBase -> LibNode . lib_NegSize + RexxHostBase -> LibNode . lib_PosSize);
	}
	else
	{
		/* In any other case we'll set the delayed
		 * expunge flag (so next expunge call will
		 * hopefully wipe us from the lib list).
		 */

		RexxHostBase -> LibNode . lib_Flags |= LIBF_DELEXP;
	}

		/* Return segment list pointer. */

	return(SegList);
}
