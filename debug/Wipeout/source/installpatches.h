/*
 * $Id: installpatches.h 1.4 1998/04/12 17:29:18 olsen Exp olsen $
 *
 * :ts=4
 *
 * Wipeout -- Traces and munges memory and detects memory trashing
 *
 * Written by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
 * Public Domain
 */

#ifndef _INSTALLPATCHES_H
#define _INSTALLPATCHES_H 1

/****************************************************************************/

#ifndef global
#define global extern
#endif	/* global */

/****************************************************************************/

/* this defines the function pointers the original memory allocation routines
 * will respond to after we have patched them.
 */

global APTR (* ASM OldAllocMem)(REG(d0) ULONG				byteSize,
                                REG(d1) ULONG				attributes,
                                REG(a6) struct ExecBase *	sysBase);

global VOID (* ASM OldFreeMem)(REG(a1)	APTR				memoryBlock,
                               REG(d0) ULONG				byteSize,
                               REG(a6) struct ExecBase *	sysBase);

global APTR (* ASM OldAllocVec)(REG(d0) ULONG				byteSize,
                                REG(d1) ULONG				attributes,
                                REG(a6) struct ExecBase *	sysBase);

global VOID (* ASM OldFreeVec)(REG(a1)	APTR				memoryBlock,
                               REG(a6) struct ExecBase *	sysBase);

global APTR (* ASM OldCreatePool)(REG(d0) ULONG				memFlags,
                                  REG(d1) ULONG				puddleSize,
                                  REG(d2) ULONG				threshSize,
                                  REG(a6) struct ExecBase *	sysBase);

global VOID (* ASM OldDeletePool)(REG(a0) APTR				poolHeader,
                                  REG(a6) struct ExecBase *	sysBase);

global APTR (* ASM OldAllocPooled)(REG(a0) APTR					poolHeader,
                                   REG(d0) ULONG				memSize,
                                   REG(a6) struct ExecBase *	sysBase);

global VOID (* ASM OldFreePooled)(REG(a0) APTR				poolHeader,
                                  REG(a1) APTR				memoryBlock,
                                  REG(d0) ULONG				memSize,
                                  REG(a6) struct ExecBase *	sysBase);

/****************************************************************************/

#endif /* _INSTALLPATCHES_H */
