/*************************************************************************
 *
 * Chunker/DeChunk
 *
 * Copyright ©1995 Lee Kindness
 * cs2lk@scms.rgu.ac.uk
 *
 * machine.h
 *  Allows use of system specific functions => smaller code or just to use
 *  ANSI functions.
 *
 * A number of different versions can be built:
 *  Generic       - Uses ANSI IO and memory functions
 *                  optionally AMIGA_1_3 defined (if _AMIGA is defined)
 *  Amiga         - Uses Amiga 2.0 IO and memory functions
 *                  _AMIGA and NO_ASYNCIO defined
 *  Amiga/Asyncio - Uses Amiga 2.0 memory allocation functions and AsyncIO
 *                  _AMIGA defined
 */

#ifndef _MACHINE_H_
#define _MACHINE_H_

/* If building an Amiga version then we want to use the Asyncio package.
 * This requires aminet://dev/c/asyncio.lha
 * You can compile without it by defining NO_ASYNCIO when compiling
 */
#ifndef NO_ASYNCIO
#define USE_ASYNCIO
#endif


/* Will we use Amiga 2.0+ IO and memory allocation functions?
 */
 
#ifndef AMIGA_1_3
#ifdef _AMIGA
#define BUILD_AMIGA
#endif
#endif

#ifdef BUILD_AMIGA
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

#ifdef USE_ASYNCIO

#include <libraries/asyncio.h>
#include <clib/asyncio_protos.h>

typedef AsyncFile *FILEt;
#define FILEOPEN_READ MODE_READ 
#define FILEOPEN_WRITE MODE_WRITE
#define OS_fopen(F,M) OpenAsync(F,M,8192)
#define OS_fgetc(F) ReadCharAsync(F)
#define OS_fputc(C,F) WriteCharAsync(F,C)
#define OS_fclose(F) CloseAsync(F)

#else /* !USE_ASYNCIO */

typedef BPTR FILEt;
#define FILEOPEN_READ MODE_OLDFILE 
#define FILEOPEN_WRITE MODE_NEWFILE
#define OS_fopen(F,M) Open(F,M)
#define OS_fgetc(F) FGetC(F)
#define OS_fputc(C,F) FPutC(F,C)
#define OS_fclose(F) Close(F)

#endif

#define OS_malloc(S) AllocVec(S, 0)
#define OS_free(P) FreeVec(P)
#define OS_printf Printf
void OS_sprintf(char *buffer, char *format, ...);

#else /* !BUILD_AMIGA */
/* Use ANSI functions */

#include <stdio.h>
#include <stdlib.h>

#define OS_printf printf
typedef FILE *FILEt;
#define FILEOPEN_READ "rb"
#define FILEOPEN_WRITE "wb"
#define OS_fopen(F,M) fopen(F,M)
#define OS_fgetc(F) fgetc(F)
#define OS_fputc(C,F) fputc(C,F) 
#define OS_fclose(F) fclose(F)
#define OS_malloc(S) malloc(S)
#define OS_free(P) free(P)
#define OS_sprintf sprintf

#endif /* BUILD_AMIGA */


#ifdef __TURBOC__

#pragma warn -pia

#endif /* __TURBOC__ */


struct Args
{
	char          *arg_Filename;
	char          *arg_Basename;
	unsigned long  arg_Size;
#ifdef BUILD_AMIGA
	struct RDArgs *arg_RAHandle;
#endif /* BUILD_AMIGA */
};

int InitSystem( void );
void FreeSystem( void );


#ifdef __CHUNKER_H__

struct Args *GetChunkerArgs(int argc, char **argv);
void FreeChunkerArgs(struct Args *args);

#endif /* __CHUNKER_H__ */


#ifdef __DECHUNK_H__

struct Args *GetDeChunkArgs(int argc, char **argv);
void FreeDeChunkArgs(struct Args *args);

#endif /* __DECHUNK_H__ */


#endif /* _MACHINE_H_ */
