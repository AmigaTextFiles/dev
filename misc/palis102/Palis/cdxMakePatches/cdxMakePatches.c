/*
	·C·O·D·E·X· ·D·E·S·I·G·N· ·S·O·F·T·W·A·R·E·
	presents:

	 cdxMakePatches.c

	How to savely install / remove several patches.

	- Supports _all_ patch managers.
	- Supports dummy code if none is found.
	- Supports use of semaphores in order to avoid that another
	  task runs your code.

	(c)by Hans Bühler
*/

#include	"cdxMakePatches.h"

// ------------------------------------
// defines (internal)
// ------------------------------------

#define	JMP_CODE				0x4ef9

#define	STATUS_OK			0
#define	STATUS_FORCE		1
#define	STATUS_ERROR		2

// ------------------------------------
// datatypes (internal)
// ------------------------------------

struct ForceCode
	{
		UWORD						Jmp;			// jmp code (0x4ef9)
		APTR						Adr;			// address to jump (==NewFunc)
	};

struct cdxPatch
	{
		struct cdxPatch			*Next,*Prev;

		struct Library				*Lib;
		WORD							Offset;
		APTR							NewFunc,OldFunc;

		APTR							Dummy;

		struct ForceCode			*ForceCode;
		struct SignalSemaphore	*Sem;
	};

// ------------------------------------
// vars
// ------------------------------------

// ------------------------------------
// funx
// ------------------------------------

/*********************************************
 * this func installs some functions to libs *
 * returns ptr to old function or NULL			*
 * REMEMBER TO INITIALIZE THE HEADPTR BY ZERO*
 * BEFORE INSTALLING THE FIRST PTR !!			*
 *********************************************/

APTR __asm cdxPutFunction(register __a0 APTR *headPtr,
                          register __d0 UWORD Flags,
                          register __a1 APTR lib,
                          register __d1 WORD offset,
                          register __a2 APTR newFunc)
{
	struct cdxPatch	*patch;

	if(!headPtr)
		return 0;

	if(!( patch = AllocVec(sizeof(struct cdxPatch), MEMF_PUBLIC|MEMF_CLEAR) ))
		return 0;

	patch->Lib		=	lib;
	patch->Offset	=	offset;
	patch->NewFunc	=	newFunc;

	if(Flags & CDXFUNCF_ADDSEM)
	{
		if(!( patch->Sem = AllocVec(sizeof(struct SignalSemaphore), MEMF_PUBLIC|MEMF_CLEAR) ))
		{
			FreeVec(patch);
			return 0;
		}

		InitSemaphore(patch->Sem);
	}

	// -- check additional flags --

	if(Flags & CDXFUNCF_ADDCODE)
	{
		if(!( patch->ForceCode = AllocVec(sizeof(struct ForceCode), MEMF_PUBLIC) ))
		{
			if(patch->Sem)
				FreeVec(patch->Sem);
			FreeVec(patch);
			return 0;
		}

		patch->ForceCode->Jmp	=	JMP_CODE;
		patch->ForceCode->Adr	=	patch->NewFunc;
		newFunc						=	patch->ForceCode;
	}

	// -- set new function --

	patch->OldFunc	=	SetFunction(lib,offset,newFunc);

	if(patch->Next = *headPtr)
		patch->Next->Prev	=	patch;
	*headPtr	=	patch;

	return patch->OldFunc;
}

/*********************************************
 * this func tries to remove these functions	*
 * and will savely keep all installed if it	*
 * wasn't possible to remove _ALL_				*
 * returns FALSE if de-installation failed.	*
 * Save to be called after failure from		*
 * cdxPutLibFunction()								*
 *********************************************/

BOOL __asm cdxRemAllFunctions(register __a0 APTR *headPtr,
                              register __d0 BOOL force)
{
	struct cdxPatch	*patch,*next;
	UBYTE					status;
	BOOL					ok;

	Forbid();

	CacheClearU();

	status	=	STATUS_OK;

	for(patch = *headPtr; patch; patch = patch->Next)
	{
		patch->Dummy	=	SetFunction(patch->Lib,patch->Offset,patch->OldFunc);

		if(patch->ForceCode)
		{
			if(patch->Dummy != patch->ForceCode)
				status	=	force ? STATUS_FORCE : STATUS_ERROR;	// this is difficult but okay at all
		}
		else
			if(patch->Dummy != patch->NewFunc)
				status	=	STATUS_ERROR;

		if(status == STATUS_ERROR)
			break;							// note: patch != 0 !!!!
	}

	// -- check whether there had been problems --

	if(status == STATUS_ERROR)
	{
		for(; patch; patch = patch->Prev)
			SetFunction(patch->Lib,patch->Offset,patch->Dummy);	// back to life

		ok	=	FALSE;						// ;-O

		Permit();
	}
	else
	{
		// first, restore FORCEed patches

		if(status == STATUS_FORCE)		// all patches had been checked !
			for(patch = *headPtr; patch; patch = patch->Next)
			{
				if(patch->ForceCode && (patch->Dummy != patch->ForceCode))
				{
					patch->ForceCode->Adr	=	patch->OldFunc;
					patch->ForceCode			=	0;
					SetFunction(patch->Lib,patch->Offset,patch->Dummy);
				}
			}

		// free unused memory

		Permit();

		next	=	*headPtr;

		while(patch = next)
		{
			next	=	patch->Next;

			if(patch->Sem)
			{
				ObtainSemaphore(patch->Sem);		// exclusive access
				ReleaseSemaphore(patch->Sem);
				FreeVec(patch->Sem);
			}

			if(patch->ForceCode)
				FreeVec(patch->ForceCode);
			FreeVec(patch);
		}

		*headPtr	=	0;

		ok	=	TRUE;
	}

	return ok;
}

// ------------------------------------
// help stuff
// ------------------------------------

/************************************************************
 * This function returns the SignalSemaphore allocated for	*
 * "newFunc" or if newFunc is NULL of the last function.		*
 * Note that NULL will be returned if the specified func		*
 * doesn't had ADDFUNCF_ADDSEM flag set !							*
 ************************************************************/

struct SignalSemaphore *__asm cdxGetPatchSem(register __a0 APTR *headPtr,
														  register __a1 APTR newFunc)
{
	struct cdxPatch	*patch;

	if(!( patch = *headPtr ))
		return 0;
	if(!newFunc)
		return patch->Sem;

	for(; patch; patch = patch->Next)
		if(patch->NewFunc == newFunc)
			return patch->Sem;

	return 0;
}

