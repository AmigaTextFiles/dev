/*************************************************************************
 *
 * ea/deea
 *
 * Copyright ©1995 Lee Kindness and Evan Tuer
 * cs2lk@scms.rgu.ac.uk
 *
 * machine.h
 *  Allows use of system specific functions => smaller code or just to use
 *  ANSI functions.
 */

#ifndef _MACHINE_H_
#define _MACHINE_H_

/* Remove to compile on a WB 1.3 Amiga */
#ifdef _AMIGA
#define AMIGA
#endif

#ifdef MSDOS
#define BRKCHARS ":\\"
#else
#define BRKCHARS "/:"
#endif

#ifdef AMIGA
/* Lets be Amiga specific */

#include <exec/types.h>
#include <exec/memory.h>
#include <dos/dos.h>

#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <pragmas/exec_sysbase_pragmas.h>
#include <pragmas/dos_pragmas.h>

extern struct ExecBase *SysBase;
extern struct DosLibrary *DOSBase;

#define mprintf Printf
#define mfprintf FPrintf
typedef BPTR FILEt;
#define FILEOPEN_READ MODE_OLDFILE 
#define FILEOPEN_WRITE MODE_NEWFILE
#define mfopen(F,M) Open(F,M)
#define mfgetc(F) FGetC(F)
#define mfgets(B,S,F) FGets(F,B,S-1)
#define mfputc(C,F) FPutC(F,C)
#define mfclose(F) Close(F)
#define mmalloc(S) AllocVec(S,0)
#define mfree(P) FreeVec(P)
void msprintf(char *buffer, char *format, ...);

#else /* AMIGA */
/* Use ANSI functions */

#include <stdio.h>
#include <stdlib.h>

#define mprintf printf
#define mfprintf fprintf
typedef FILE *FILEt;
#define FILEOPEN_READ "r"
#define FILEOPEN_WRITE "w"
#define mfopen(F,M) fopen(F,M)
#define mfgetc(F) fgetc(F)
#define mfgets(B,S,F) fgets(B,S,F)
#define mfputc(C,F) fputc(C,F) 
#define mfclose(F) fclose(F)
#define mmalloc(S) malloc(S)
#define mfree(P) free(P)
#define msprintf sprintf

#endif /* AMIGA */


#ifdef __TURBOC__

#pragma warn -pia

#endif /* __TURBOC__ */


struct Args
{
	char          *arg_Filename;
	char          *arg_Dest;
	unsigned long  arg_Size;
#ifdef AMIGA
	struct RDArgs *arg_RAHandle;
#endif /* AMIGA */
};

int InitSystem( void );
void FreeSystem( void );


#ifdef _EA_H_

struct Args *GeteaArgs(int argc, char **argv);
void FreeeaArgs(struct Args *args);

#endif /* _EA_H_ */


#ifdef _DEEA_H_

struct Args *GetdeeaArgs(int argc, char **argv);
void FreedeeaArgs(struct Args *args);

#endif /* _DEEA_H_ */


#endif /* _MACHINE_H_ */
