/*
 * mem.h -- this file contains macros to take over AllocMem() and
 *	FreeMem();
 * (c)1988 Jojo Wesener
 * NOTE: do not include this file in mem.c
 */

#ifdef MEMTRACE

#define AllocMem(amt,type)	alloctrack(amt,type,__FILE__,__FUNC__,__LINE__)
#define FreeMem(addr,amt)	freetrack(addr,amt,__FILE__,__FUNC__,__LINE__)

extern char * alloctrack();

#endif MEMTRACE
