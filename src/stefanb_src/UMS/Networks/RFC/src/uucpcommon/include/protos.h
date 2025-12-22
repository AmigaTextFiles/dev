
/*
 *  AMIGA prototypes used by UUCP programs.  This is where compiler
 *  dependancies go.
 */

#ifndef _PROTOS_H
#define _PROTOS_H

#ifdef _DCC

#ifndef CLIB_EXEC_PROTOS_H
extern void *AllocMem();
extern void *GetMsg();
extern void *CreatePort();
extern void *OpenWindow();
extern void *OpenLibrary();

extern void *RemHead();
extern void *RemTail();

extern void *FindPort();
extern void *SetFunction();
#endif

#else
#ifdef MCH_AMIGA
#define __saveds
#include <functions.h>	       /* Manx */
#else
#include <proto/all.h>	       /* Lattice */
#endif
#endif

#endif	/*  _PROTO_H */
