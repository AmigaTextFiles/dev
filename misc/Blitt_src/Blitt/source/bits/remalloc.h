#ifndef	REM_ALLOC_H
#define	REM_ALLOC_H
#ifndef	COMPILER_H
#include	<iff/compiler.h>
#endif
#ifdef	FDwAT
extern	UBYTE	*RemAlloc(LONG,	LONG);
extern	UBYTE	*ChipAlloc(LONG);
extern	UBYTE	*ChipNoClearAlloc(LONG);
extern	UBYTE	*ExtAlloc(LONG);
extern	UBYTE	*ExtNoClearAlloc(LONG);
extern	UBYTE	*RemFree(UBYTE	*);
#else
extern	UBYTE	*RemAlloc();
extern	UBYTE	*ChipAlloc();
extern	UBYTE	*ExtAlloc();
extern	UBYTE	*RemFree();
#endif
#endif	REM_ALLOC_H
