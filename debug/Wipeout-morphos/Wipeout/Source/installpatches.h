/*
 * $Id: installpatches.h,v 1.2 2006/02/02 17:45:35 laire Exp $
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

global APTR (*OldAllocMemAligned)(APTR SysBase, ULONG size, ULONG attr, ULONG align, ULONG offset);
global APTR OldAllocMem;
global APTR OldFreeMem;
global APTR (*OldAllocVecAligned)(APTR SysBase, ULONG size, ULONG attr, ULONG align, ULONG offset);
global APTR OldAllocVec;
global APTR OldFreeVec;
global APTR OldCreatePool;
global APTR OldDeletePool;
global APTR OldFlushPool;
global APTR (*OldAllocPooledAligned)(APTR SysBase, APTR pool, ULONG size, ULONG align, ULONG offset);
global APTR OldAllocPooled;
global APTR OldFreePooled;
global APTR OldAllocVecPooled;
global APTR OldFreeVecPooled;

/****************************************************************************/

#endif /* _INSTALLPATCHES_H */
