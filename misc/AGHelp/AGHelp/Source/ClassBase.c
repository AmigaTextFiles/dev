/* $VER: ClassBase.c 1.0 (17.1.97)
 *
 * Generic (Class) Library Base
 *
 * This code is based on the example shared library from DICE 3.0,
 * with inspiration from the AIFF datatype (by Olaf Barthel).
 *
 * This code doesn't use any form of startup code.
 * This is not something the novice C-programmer should attempt to do.
 * You need to know what you are doing. :)
 */

#define __USE_SYSBASE
#include <dos/dos.h>
#include <exec/libraries.h>
#include <exec/resident.h>
#include <exec/semaphores.h>
#include <intuition/classes.h>
#include <proto/exec.h>
#include "macros.h"

#include "classbase.h"


/* This should be defined in some system include, IMHO.. ;) */

struct InitTable
{
	ULONG	it_LibrarySize;
	APTR	*it_FunctionTable;
	UBYTE	*it_InitStruct;
	APTR	it_LibraryInit;
}; /* struct InitTable */


/*---------------------------------------------------------------------------*/


/* Library functions */
LIBFUNC struct ClassBase	*LibInit( D0 struct ClassBase *, A0 BPTR, A6 struct ExecBase * );
LIBFUNC struct ClassBase	*LibOpen( A6 struct ClassBase * );
LIBFUNC BPTR			LibClose( A6 struct ClassBase * );
LIBFUNC BPTR			LibExpunge( A6 struct ClassBase * );
LIBFUNC Class			*GetClassBase( A6 struct ClassBase * );

/* Functions in Class.c */
BOOL	LibrarySetup( struct ClassBase * );
VOID	LibraryCleanup( struct ClassBase * );


/* In case the user tries to run us, simply exit immediately.
 * This code is also used for the reserved library function,
 * that all libraries currently must have.
 *
 * Note that this function *must* be placed before any const
 * data, or else the "exit if run" effect is lost (you are
 * more likely to get a "crash if run" effect ;).
 */
LONG
LibReserved( VOID )
{
	return( 0 );
} /* LibReserved */


/* The functions the library should have. Unfortunately, we can't
 * use the more compact format, using 16-bit relative entries,
 * due to the compiler.
 */

static const APTR
FuncTable[] =
{
	LibOpen,	/* Standard library functions */
	LibClose,
	LibExpunge,
	LibReserved,

	GetClassBase,	/* Our functions start here */
	( APTR ) -1	/* Terminate the table */
}; /* FuncTable */


/* Table describing the library. We need this, since we use the
 * autoinit feature. This means we don't need to call MakeLibrary()
 * etc. in LibInit().
 */
static const struct InitTable
InitTable =
{
	sizeof( struct ClassBase ),	/* Size of our library base, excluding jump table */
	FuncTable,			/* The functions we have */
	NULL,				/* InitStruct data. We init stuff ourselves instead */
	LibInit				/* The library init function */
}; /* InitTable */


/* And finaly the resident structure, used by InitResident(),
 * in order to initialize everything for us.
 */
static const struct Resident
RomTag =
{
	RTC_MATCHWORD,		/* rt_MatchWord */
	&RomTag,		/* rt_MatchTag */
	LibExpunge,		/* rt_EndSkip */
	RTF_AUTOINIT,		/* rt_Flags */
	CB_VERSION,		/* rt_Version */
	NT_LIBRARY,		/* rt_Type */
	0,			/* rt_Pri */
	CB_NAME,		/* rt_Name */
	CB_ID,			/* rt_IDString */
	&InitTable		/* rt_Init */
}; /* RomTag */


/*---------------------------------------------------------------------------*/


/* This function is called when the library is loaded and the library base
 * have been allocated. We are in a Forbid() section here, so don't do
 * anything time-consuming, Wait(), or similar.
 *
 * To make sure we won't break Forbid(), we don't allocate any resources
 * below.
 *
 * If all ok, return the library base. If anything went wrong, deallocate
 * the library structure and return NULL (this can't happen with the below
 * code).
 */
LIBFUNC struct ClassBase *
LibInit( D0 struct ClassBase *classBase, A0 BPTR seglist, A6 struct ExecBase *execbase )
{
	SysBase = execbase;

	classBase->cb_Library.cl_Lib.lib_Node.ln_Type	= NT_LIBRARY;
	classBase->cb_Library.cl_Lib.lib_Node.ln_Pri	= 0;
	classBase->cb_Library.cl_Lib.lib_Node.ln_Name	= CB_NAME;

	/* Request that checksum should be calculated */
	classBase->cb_Library.cl_Lib.lib_Flags		= LIBF_CHANGED | LIBF_SUMUSED;
	classBase->cb_Library.cl_Lib.lib_Version	= CB_VERSION;
	classBase->cb_Library.cl_Lib.lib_Revision	= CB_REVISION;
	classBase->cb_Library.cl_Lib.lib_IdString	= ( APTR ) CB_ID;
	classBase->cb_SegList				= seglist;
	InitSemaphore( &classBase->cb_Semaphore );

	return( classBase );
} /* LibInit */


/* Open is given the library pointer. Either return the library pointer or
 * NULL. Clear the delayed-expunge flag. Exec has Forbid() for us during
 * the call.
 *
 * Since we might open disk resources in LibrarySetup(), protect everything
 * by obtaining the private library semaphore.
 */
LIBFUNC struct ClassBase *
LibOpen( A6 struct ClassBase *classBase )
{
	struct SignalSemaphore	*sem;

	/* Prevent any delayed expunge */
	classBase->cb_Library.cl_Lib.lib_Flags &= ~LIBF_DELEXP;
	++classBase->cb_Library.cl_Lib.lib_OpenCnt;

	ObtainSemaphore( sem = &classBase->cb_Semaphore );

	if( classBase->cb_Library.cl_Lib.lib_OpenCnt == 1 )
	{
		/* First open. Set up resources */
		if( !LibrarySetup( classBase ) )
		{
			/* Couldn't get resources */
			--classBase->cb_Library.cl_Lib.lib_OpenCnt;
			classBase = NULL;
		} /* if */
	} /* if */

	ReleaseSemaphore( sem );

	return( classBase );
} /* LibOpen */


/* Close is given the library pointer. Be sure not to decrement the open
 * count if already zero. If the open count is or becomes zero AND there
 * is a LIBF_DELEXP, we expunge the library and return the seglist.
 * Otherwise we return NULL. Exec has Forbid() for us during the call.
 *
 * Note that this routine never sets LIBF_DELEXP on its own.
 *
 */
LIBFUNC BPTR
LibClose( A6 struct ClassBase *classBase )
{
	BPTR	segment = NULL;

	if( classBase->cb_Library.cl_Lib.lib_OpenCnt )
	{
		/* Last close? */
		if( classBase->cb_Library.cl_Lib.lib_OpenCnt == 1 )
		{
			/* Cleanup any allocated resources */
			ObtainSemaphore( &classBase->cb_Semaphore );
			LibraryCleanup( classBase );
			ReleaseSemaphore( &classBase->cb_Semaphore );

			/* Make sure library hasn't been opened while we obtained
			 * the semaphore. Though it is likely that the DELEXP flag
			 * is cleared then, there is a very remote possibility
			 * that it is set by the Expunge function. Hence this
			 * extra open check, to plug even that tiny hole. ;)
			 */
			if( !--classBase->cb_Library.cl_Lib.lib_OpenCnt &&
				( classBase->cb_Library.cl_Lib.lib_Flags & LIBF_DELEXP ) )
			{
				segment = LibExpunge( classBase );
			} /* if */
		}
		else
		{
			--classBase->cb_Library.cl_Lib.lib_OpenCnt;
		} /* if */
	} /* if */

	return( segment );
} /* LibClose */


/* We expunge the library and return the Seglist ONLY if the open count is
 * zero. If the open count is not zero we set the delayed-expunge flag and
 * return NULL.
 *
 * Exec has Forbid() for us during the call. NOTE ALSO that Expunge might
 * be called from the memory allocator and thus we CANNOT DO A Wait() or
 * otherwise take a long time to complete (straight from RKM).
 *
 * RemLibrary() calls our expunge routine and would therefore freeze if we
 * called it ourselves. LibExpunge() must remove the library itself as
 * shown below.
 */
LIBFUNC BPTR
LibExpunge( A6 struct ClassBase *classBase )
{
	BPTR	segment = NULL;

	if( classBase->cb_Library.cl_Lib.lib_OpenCnt )
	{
		classBase->cb_Library.cl_Lib.lib_Flags |= LIBF_DELEXP;
	}
	else
	{
		segment = classBase->cb_SegList;
		Remove( &classBase->cb_Library.cl_Lib.lib_Node );
		FreeMem( ( UBYTE * ) classBase - classBase->cb_Library.cl_Lib.lib_NegSize,
			( ULONG ) ( classBase->cb_Library.cl_Lib.lib_NegSize
				+ classBase->cb_Library.cl_Lib.lib_PosSize ) );
	} /* if */

	return( segment );
} /* LibExpunge */
