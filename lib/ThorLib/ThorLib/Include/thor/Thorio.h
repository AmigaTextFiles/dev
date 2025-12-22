/*************************************************************************
 ** THOR.lib                                                            **
 ** Version 1.00  6th December 1995     © 1995 THOR-Software inc        **
 **                                                                     **
 **---------------------------------------------------------------------**
 **                                                                     **
 ** Thor-IO routines Version 1.05                                       **
 **     updated Oct 19 1997                                             **
 **                                                                     **
 ** © 1991,1993,1995,1997 THOR - Software                               **
 *************************************************************************/

#ifndef THORIO_H
#define THORIO_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef DOS_DOS_H
#include <dos/dos.h>
#endif

/* main structure */
typedef  struct {
        BPTR fh_DOSHandle;              /* BPTR to DOS file structure */
        void *fh_Buffer;                /* buffer itself */
        UWORD fh_BufferLength;          /* its length */
        UWORD fh_BufferContents;        /* # of valid bytes */
        UWORD fh_BufferPos;             /* position of fileptr in buffer */
        UWORD fh_DOSOffset;             /* offset of buffer in total file */
        UBYTE fh_Mode;                  /* open mode, see below */
        UBYTE fh_Flags;                 /* additional flags, internal */
        char fh_RecordSep1;             /* record seperator, as LF or NUL */
        char fh_RecordSep2;             /* a second one... */
        ULONG fh_FilePointer;           /* absolute position in file */
}FileHandle;

/* definition of flags: READ ONLY */
#define FHFLG_CHANGED (1<<0)            /* buffer has been changed and must be written to disk */
#define FHFLG_INTERACTIVE (1<<1)        /* belongs to interactive file (should check for non-filing system files as well...) */

/* definition of mode-flags: READ ONLY in structure, used for open */
#define FHMOD_APPEND (1<<0)             /* append to end of file */
#define FHMOD_READ (1<<2)               /* open for reading */
#define FHMOD_WRITE (1<<3)              /* open for writing */
#define FHMOD_RECORD (1<<6)             /* record-oriented IO */
#define FHMOD_NONUL (1<<7)              /* don't write NULs on record IO */
/* this short version of ThorIO does not supply
        directory IO,CIS,COS,CER opening... */

/* file IO functions */

/* open file, given mode and buffersize */
extern FileHandle __regargs *FOpen(register char *name,register UBYTE mode,register UWORD buffersize);

/* close file */
extern BOOL __regargs FClose(register FileHandle *fh);

/* flush buffer */
extern  LONG __regargs FFlush(register FileHandle *fh);

/* read bytes */
extern  LONG __regargs FRead(register FileHandle *fh,register void *buffer,register ULONG len);

/* write bytes */
extern  LONG __regargs FWrite(register FileHandle *fh,register void *buffer,register ULONG len);

/* seek in file, mode like in A-Dos */
extern  LONG __regargs FSeek(register FileHandle *fh,register LONG offset,register LONG mode);

/* the next is implemented as a macro */
#define FTell(file) ((file)->fh_FilePointer)

#endif

