/*
	·C·O·D·E·X· ·D·E·S·I·G·N· ·S·O·F·T·W·A·R·E·
	presents

	TestPatch.library

	this program will check whether library patching is observed by
	a PatchManager like SaferPatches or PALIS.
	returns appropiate codes to the caller.

	FILE:	ChkLib.c
	TASK:	SAS/C library

	(c)1995 by Hans Bühler, codex@stern.mathematik.hu-berlin.de
*/

#include	"/chk.h"
#include	<stdio.h>

// ---------------------------
// defines
// ---------------------------

// ---------------------------
// datatypes
// ---------------------------

// ---------------------------
// proto
// ---------------------------

extern int	__asm __UserLibInit(register __a6 struct Library *LibBase);
extern void	__asm __UserLibCleanup(register __a6 struct Library *LibBase);
extern void __asm __interrupt LIB_DummyFunc(void);

// ---------------------------
// vars
// ---------------------------

struct IntuitionBase	*IntuitionBase	=	0;
struct ExecBase		*SysBase			=	0;

// ---------------------------
// funx1
// ---------------------------

/*
	OpenLibrary()
	-------------
*/

int __asm __UserLibInit(register __a6 struct Library *LibBase)
{
	SysBase			=	*((struct ExecBase **)4);
	IntuitionBase	=	(struct IntuitionBase *)OldOpenLibrary("intuition.library");

	return 0;
}

/*
	CloseLibrary()
	--------------
*/

void __asm __UserLibCleanup(register __a6 struct Library *LibBase)
{
	if(IntuitionBase)
		CloseLibrary((struct Library *)IntuitionBase);
}

// ---------------------------
// funx2
// ---------------------------

void __asm __interrupt LIB_DummyFunc(void)
{
	DisplayBeep(0);
}


