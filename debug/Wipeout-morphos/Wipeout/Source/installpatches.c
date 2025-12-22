/*
 * $Id: installpatches.c,v 1.11 2009/02/23 01:24:09 piru Exp $
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


#define	NORMALPATCHES	1
#define	POOLPATCHES		1
#define	ALIGNPATCHES	0
#define	USE_REVERSE_CCR	1

/******************************************************************************/

#undef global
#define global

/* declare the vector stubs */
#include "installpatches.h"

/******************************************************************************/

#define	GETSTACKFRAME												\
	ULONG pc[TRACKEDCALLERSTACKSIZE];								\
    ScanStackHistory((ULONG*) __builtin_frame_address(0),pc);				\


#define LVOAllocMem				-198
#define LVOFreeMem				-210
#define LVOAllocVec				-684
#define LVOFreeVec				-690
#define LVOCreatePool			-696
#define LVODeletePool			-702
#define LVOAllocPooled			-708
#define LVOFreePooled			-714

// Following functions are new and use M68k ABI
#define LVOFlushPool			-882
#define LVOAllocVecPooled		-894
#define LVOFreeVecPooled		-900

// Following functions are new and use SysV ABI
#define LVOAllocMemAligned		-936
#define LVOAllocVecAligned		-942
#define LVOAllocPooledAligned	-984

/******************************************************************************/

void	ScanStackHistory(ULONG			*Stack,
                         ULONG			pc[TRACKEDCALLERSTACKSIZE])
{
ULONG	*CurrentStack;
ULONG	*StackPtr;
int		i;


  i		=	0;
  CurrentStack	=	Stack;


  memset(pc,0,sizeof(pc));

  while (TypeOfMem(CurrentStack))
  {
    StackPtr	=(ULONG*) CurrentStack[0];	/* Get previous stackframe */
    if (TypeOfMem(StackPtr))
    {
      if (TypeOfMem((APTR) StackPtr[1]) ||
          ((StackPtr[1] >= ModuleStart) && (StackPtr[1] < ModuleStart+ModuleSize)) ||
          ((StackPtr[1] >= EmulationStart) && (StackPtr[1] < EmulationStart+EmulationSize)))
      {
        /* Legal LR */

		pc[i]	=	StackPtr[1];
        i++;
        if (i >= TRACKEDCALLERSTACKSIZE)
        {
          break;
        }
      }
      CurrentStack=StackPtr;
    }
    else
    {
      break;
    }
  }
}

/******************************************************************************/


/* Pushing all 68k registers into stack is quite pointless on PPC but when debugging
 * 68k programs it might be useful. Either way PPC programs pass parameters via
 * 68k registers and dumping A0/A1/D0/D1 is needed. -itix
 */

STATIC VOID Push(void)
{
	ULONG *stack, *regs, i;

	REG_A7	-= 15 * sizeof(ULONG);
	regs		 = &MyEmulHandle->Dn[0];
	stack		 = (ULONG *)REG_A7;

	for (i = 0; i < 15; i++)
	{
		*stack++ = *regs++;
	}

	Forbid();
}

STATIC VOID Pull(void)
{
	REG_A7	+= 15 * sizeof(ULONG);
	Permit();
}

void FixCCR(APTR rc)
{
#if USE_REVERSE_CCR

	/* Return reverse ccr flags - try to trip buggy apps - Piru */

	if (rc)
	{
		/* Simulate 0 return: clear N, V, C, set Z */
		REG_SR = (REG_SR & ~11) | 4;
	}
	else
	{
		/* Simulate -1 return: clear Z, V, C, set N */
		REG_SR = (REG_SR & ~7) | 8;
	}

#else
	
	if (rc)
	{
		/* nonzero: clear N, Z, V, C, set N if negative */
		REG_SR = (REG_SR & ~15) | (((LONG) rc < 0) ? 8 : 0);
	}
	else
	{
		/* zero: clear N, V, C, set Z */
		REG_SR = (REG_SR & ~11) | 4;
	}

#endif
}

STATIC APTR NewAllocMemAlignedFrontEndPPC(APTR SysBase, ULONG size, ULONG attr, ULONG align, ULONG offset)
{
	// SysV ABI call, no 68k calls possible
	APTR rc;
	GETSTACKFRAME
	Forbid();
	rc = NewAllocMemAligned(size, attr, align, offset, pc);
	Permit();
	return rc;
}

STATIC APTR NewAllocMemFrontEndPPC(void)
{
	ULONG size = REG_D0;
	ULONG attr = REG_D1;
	APTR rc;
	GETSTACKFRAME
	Push();
	rc = NewAllocMem(size, attr, (ULONG *)REG_A7, pc);
	Pull();

	FixCCR(rc);

	return rc;
}

STATIC VOID NewFreeMemFrontEndPPC(void)
{
	ULONG size = REG_D0;
	APTR block = (APTR)REG_A1;
	GETSTACKFRAME
	Push();
	NewFreeMem(block, size, (ULONG *)REG_A7, pc);
	Pull();
}

STATIC APTR NewAllocVecAlignedFrontEndPPC(APTR SysBase, ULONG size, ULONG attr, ULONG align, ULONG offset)
{
	// SysV ABI call, no 68k calls possible
	APTR rc;
	GETSTACKFRAME
	Forbid();
	rc = NewAllocVecAligned(size, attr, align, offset, pc);
	Permit();
	return rc;
}

STATIC APTR NewAllocVecFrontEndPPC(void)
{
	ULONG size = REG_D0;
	ULONG attr = REG_D1;
	APTR rc;
	GETSTACKFRAME
	Push();
	rc = NewAllocVec(size, attr, (ULONG *)REG_A7, pc);
	Pull();

	FixCCR(rc);

	return rc;
}

STATIC VOID NewFreeVecFrontEndPPC(void)
{
	APTR block = (APTR)REG_A1;
	GETSTACKFRAME
	Push();
	NewFreeVec(block, (ULONG *)REG_A7, pc);
	Pull();
}

STATIC APTR NewCreatePoolFrontEndPPC(void)
{
	ULONG flags = REG_D0;
	ULONG psize = REG_D1;
	ULONG tsize = REG_D2;
	APTR rc;
	GETSTACKFRAME
	Push();
	rc = NewCreatePool(flags, psize, tsize, (ULONG *)REG_A7, pc);
	Pull();
	return rc;
}

STATIC VOID NewDeletePoolFrontEndPPC(void)
{
	APTR pool = (APTR)REG_A0;
	GETSTACKFRAME
	Push();
	NewDeletePool(pool, (ULONG *)REG_A7, pc);
	Pull();
}

STATIC VOID NewFlushPoolFrontEndPPC(void)
{
	APTR pool = (APTR)REG_A0;
	GETSTACKFRAME
	Push();
	NewFlushPool(pool, (ULONG *)REG_A7, pc);
	Pull();
}

STATIC APTR NewAllocPooledAlignedFrontEndPPC(APTR SysBase, APTR pool, ULONG size, ULONG align, ULONG offset)
{
	// SysV ABI call, no 68k calls possible
	APTR rc;
	GETSTACKFRAME
	Forbid();
	rc = NewAllocPooledAligned(pool, size, align, offset, pc);
	Permit();
	return rc;
}

STATIC APTR NewAllocPooledFrontEndPPC(void)
{
	ULONG size = REG_D0;
	APTR pool = (APTR)REG_A0;
	APTR rc;
	GETSTACKFRAME
	Push();
	rc = NewAllocPooled(pool, size, (ULONG *)REG_A7, pc);
	Pull();
	return rc;
}

STATIC VOID NewFreePooledFrontEndPPC(void)
{
	ULONG size = REG_D0;
	APTR pool = (APTR)REG_A0;
	APTR block = (APTR)REG_A1;
	GETSTACKFRAME
	Push();
	NewFreePooled(pool, block, size, (ULONG *)REG_A7, pc);
	Pull();
}

STATIC APTR NewAllocVecPooledFrontEndPPC(void)
{
	ULONG size = REG_D0;
	APTR pool = (APTR)REG_A0;
	APTR rc;
	GETSTACKFRAME
	Push();
	rc = NewAllocVecPooled(pool, size, (ULONG *)REG_A7, pc);
	Pull();
	return rc;
}

STATIC VOID NewFreeVecPooledFrontEndPPC(void)
{
	APTR pool = (APTR)REG_A0;
	APTR block = (APTR)REG_A1;
	GETSTACKFRAME
	Push();
	NewFreeVecPooled(pool, block, (ULONG *)REG_A7, pc);
	Pull();
}

STATIC CONST struct EmulLibEntry NewAllocMemFrontEnd			= { TRAP_LIBSR, 0, (void (*)())&NewAllocMemFrontEndPPC		};
STATIC CONST struct EmulLibEntry NewFreeMemFrontEnd			= { TRAP_LIBNR, 0, (void (*)())&NewFreeMemFrontEndPPC			};
STATIC CONST struct EmulLibEntry NewAllocVecFrontEnd			= { TRAP_LIBSR, 0, (void (*)())&NewAllocVecFrontEndPPC		};
STATIC CONST struct EmulLibEntry NewFreeVecFrontEnd			= { TRAP_LIBNR, 0, (void (*)())&NewFreeVecFrontEndPPC			};
STATIC CONST struct EmulLibEntry NewCreatePoolFrontEnd		= { TRAP_LIB  , 0, (void (*)())&NewCreatePoolFrontEndPPC		};
STATIC CONST struct EmulLibEntry NewDeletePoolFrontEnd		= { TRAP_LIBNR, 0, (void (*)())&NewDeletePoolFrontEndPPC		};
STATIC CONST struct EmulLibEntry NewFlushPoolFrontEnd			= { TRAP_LIBNR, 0, (void (*)())&NewFlushPoolFrontEndPPC		};
STATIC CONST struct EmulLibEntry NewAllocPooledFrontEnd		= { TRAP_LIB  , 0, (void (*)())&NewAllocPooledFrontEndPPC	};
STATIC CONST struct EmulLibEntry NewFreePooledFrontEnd		= { TRAP_LIBNR, 0, (void (*)())&NewFreePooledFrontEndPPC		};
STATIC CONST struct EmulLibEntry NewAllocVecPooledFrontEnd	= { TRAP_LIB  , 0, (void (*)())&NewAllocVecPooledFrontEndPPC};
STATIC CONST struct EmulLibEntry NewFreeVecPooledFrontEnd	= { TRAP_LIBNR, 0, (void (*)())&NewFreeVecPooledFrontEndPPC	};

/******************************************************************************/

STATIC CONST struct
{
	WORD  lvo;
	APTR *oldfuncptr;
}
oldfuncs[] =
{
#define MKP(n) {LVO ## n, (APTR *) &Old ## n}
	MKP(AllocMem),
	MKP(FreeMem),

	MKP(AllocVec),
	MKP(FreeVec),

	MKP(AllocMemAligned),
	MKP(AllocVecAligned),

	MKP(CreatePool),
	MKP(DeletePool),

	MKP(AllocPooled),
	MKP(FreePooled),
	MKP(AllocVecPooled),
	MKP(FreeVecPooled),
	MKP(AllocPooledAligned),
};
const int NUMOLDFUNCS = sizeof(oldfuncs) / sizeof(oldfuncs[0]);

STATIC CONST struct
{
	UWORD type;
	WORD  lvo;
	APTR  newfunc;
	APTR *oldfuncptr;
}
patches[] =
{
#undef MKP
#define MKP(t,n,e) {MACHINE_ ## t, LVO ## n, (APTR) &New ## n ## FrontEnd ## e, (APTR *) &Old ## n}
#if NORMALPATCHES
	MKP(M68k, AllocMem, ),
	MKP(M68k, FreeMem, ),

	MKP(M68k, AllocVec, ),
	MKP(M68k, FreeVec, ),
#endif

#if ALIGNPATCHES
	MKP(PPC,  AllocMemAligned, PPC),
	MKP(PPC,  AllocVecAligned, PPC),
#endif

#if POOLPATCHES
	MKP(M68k, CreatePool, ),
	MKP(M68k, DeletePool, ),
	MKP(M68k, FlushPool, ),

	MKP(M68k, AllocPooled, ),
	MKP(M68k, FreePooled, ),
	MKP(M68k, AllocVecPooled, ),
	MKP(M68k, FreeVecPooled, ),
#if 1//ALIGNPATCHES
	MKP(PPC,  AllocPooledAligned, PPC),
#endif
#endif
};
const int NUMPATCHES = sizeof(patches) / sizeof(patches[0]);

/******************************************************************************/

VOID
InstallPatches(VOID)
{
	/* SysV ABI functions are not patchable via SetFunction() so we must use
	 * NewSetFuction() instead.
	 */

	CONST struct TagItem tags[] = { { SETFUNCTAG_TYPE, SETFUNCTYPE_SYSTEMV }, { TAG_DONE, 0 } };
	int i;
	#pragma pack(2)
	struct { UWORD opcode; APTR func; } *lvo;
	#pragma pack()

	/* SegTracker is always loaded */
	SegTracker = (struct SegSem *)FindSemaphore("SegTracker");

	Forbid();

	/*
	 * Get all old function pointers. Even if something is disabled in
	 * 'patches' array, some of the Old ptrs might still be used.
	 */
	for (i = 0; i < NUMOLDFUNCS; i++)
	{
		lvo = (APTR) (((UBYTE *) SysBase) + oldfuncs[i].lvo);
		*(oldfuncs[i].oldfuncptr) = lvo->func;
	}

	/*
	 * Redirect all these memory allocation routines to our monitoring code
	 */
	for (i = 0; i < NUMPATCHES; i++)
	{
		#if 0 /* done above now */
		/* The new function must be callable before [New]SetFunction returns! */
		lvo = (APTR) (((UBYTE *) SysBase) + patches[i].lvo);
		*(patches[i].oldfuncptr) = lvo->func;
		#endif

		switch (patches[i].type)
		{
			case MACHINE_M68k:
				*(patches[i].oldfuncptr) = SetFunction(&SysBase->LibNode, patches[i].lvo, (ULONG (*)(void)) patches[i].newfunc);
				break;

			case MACHINE_PPC:
				*(patches[i].oldfuncptr) = NewSetFunction(&SysBase->LibNode, patches[i].newfunc, patches[i].lvo, (struct TagItem *) tags);
				break;
		}
	}

	Permit();
}
