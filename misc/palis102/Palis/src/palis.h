/*
	·C·O·D·E·X· ·D·E·S·I·G·N· ·S·O·F·T·W·A·R·E·
	presents

	Palis

	FILE:	PALIS.h
	TASK:	include for programms that want to read some
			data from PALIS
	NOTE:	TabLen=3

	 You may don't like ViewPALIS (included in the archive)
	or want to know some special information about patches tracked
	by PALIS.
	 Here's the description of how these information are tracked
	and how to access them.

	(c)1995 by Hans Bühler, codex@stern.mathematik.hu-berlin.de
	Attention ! This is the actual e-mail address !
	h0348kil... is obsolete !
*/

#include	<exec/exec.h>

// ---------------------------
// PALIS patches tracking
// ---------------------------

/***************************************************
 * All information about patches tracked by PALIS	*
 * might be received using "struct plBase" (see		*
 * below)														*
 * If you want to access PALIS plBase (see below)	*
 * do the following:											*
 ***************************************************
 *
 *	FIRST: WAIT UNTIL PLBASE IS READY FOR YOU
 *	-----------------------------------------
 *
 *	struct plBase *ObtainPalisBase(void)
 *	{
 *		struct plBase	*plBase;
 *
 *		if(plBase = (struct plBase *)FindSemaphore(PALIS_SEMAPHORE_NAME))
 *			ObtainSemaphoreShared(&plBase->Sem);
 *
 *		return plBase;
 *	};
 *
 *	SECOND: FIND BASE AND CHECK WHETHER YOU MAY ACCESS IT
 *	-----------------------------------------------------
 *	
 *	struct plBase *AttemptPalisBase(void)
 *	{
 *		struct plBase	*plBase;
 *
 *		if(plBase = (struct plBase *)FindSemaphore(PALIS_SEMAPHORE_NAME))
 *			if(!AttemptSemaphoreShared(&plBase->Sem))
 *				plBase	=	0;
 *
 *		return plBase;
 *	};
 *
 *	THIRD: RELEASE BASE IF YOU FINISHED WORK
 *	----------------------------------------
 *	
 *	void ReleasePLBase(struct plBase *plBase)
 *	{
 *		if(plBase)
 *			ReleaseSemaphore(&plBase->Sem);
 *	}
 *
 ***************************************************
 * Please remember these points:							*
 * 1) ALL DATA ARE READ-ONLY !!!!!!!!!!!!!!!!		*
 * 2) Please release plBase as soon as possible		*
 *		since PALIS will block all other programms	*
 *		trying to patch _any_ library !!					*
 ***************************************************/

#define	PALIS_SEMAPHORE_NAME		"PALIS_patch_list"		// don't use FindSemaphore(PL...); it could be removed between
																			// Find..() and Obtain..() !!!!!
#define	PALIS_VERSION				0x100							// check this...
#define	PALIS_NAME					"PALIS V1.02"				// if you want to refer to PALIS' name ;^)

/***************************************************************************
 * these structs are the basic structures used to track each SetFunction()	*
 * call !!!																						*
 * they may not behave strange but note that semaphore locking is used for	*
 * the whole heap using plBase->Sem !!!!!!!!!										*
 ***************************************************************************/

struct plPatch				/* patches an einem offset */
	{
		struct MinNode		Node;							// tracking...
		char					*ProcName;					// _copy_ of processname or CLI command name
																// might be an error message if you ran out of
																// memory while allocating mem for name...
		APTR					plOffset;					// struct plOffset *

		UWORD					_Cookie_;					// set to ASS-JMP, address of this entry is send to SetFunction()
		APTR					PatchFunc,					// newly set function
								OldFunc;						// address of func having been replaced (mostly last &plPatch->_Cookie_..)
																// 0 => patch isn't active anymore
																// (part of list because other patches will jump here)
	};
#define	PL_ACTIVE(PAT)	((PAT)->OldFunc)			// use this to detect whether a patch has been removed..

struct plOffset			/* offsets in einer lib, die gepatched wurden */
	{
		struct MinNode		Node;							// tracking...
		WORD					Offset;						// offset which has been patched
		APTR					plLib;						// struct plLib *

		APTR					OriginalFunc;				// original function...

		struct MinList		PatchList;					// list of patches (struct plPatch *)
		UWORD					PatchCnt;					// counter
	};

struct plLib				/* libraries, die gepatched wurden */
	{
		struct MinNode		Node;							// tracking... (ln_Name points to lib...)
		struct Library		*Lib;							// ID: OpenLib() ... close if cnt == 0 !

		struct MinList		OffList;						// list of offsets patched (struct plOffset *)
		UWORD					OffCnt;						// counter
	};

struct plBase				/* basic struct mit sigSemaphore */
	{
		struct SignalSemaphore	Sem;					// avoid Forbid()/Permit() use !!!
																// use FindSemaphore() to find this Base somewhere... ;^)
		UWORD							Version;				// Version of PALIS (PALIS_VERSION)

		struct MinList				LibList;				// list of libs having been patched (struct plLib *)
		UWORD							LibCnt;				// counter

		LONG							PatchCnt;			// just a counter... total number of patches
																// this is reliable...

		BOOL							LowMemErr;			// if TRUE, a memory allocation error
																// has been detected during any new patch.
																// => no more PALIS work !!!!!
	};
