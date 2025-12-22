#ifndef EXTRDARGS_H
#define EXTRDARGS_H
/*
** $PROJECT: CLI/Workbench ReadArgs()
**
** $VER: extrdargs.h 1.2 (08.01.95)
**
** by
**
** Stefan Ruppert , Windthorststraße 5 , 65439 Flörsheim , GERMANY
**
** (C) Copyright 1994,1995
** All Rights Reserved !
**
** $HISTORY:
**
** 08.01.95 : 001.002 : changed to ExtReadArgs()
** 04.09.94 : 001.001 : bumped to version 1
** 04.09.94 : 000.001 : initial
*/

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef DOS_RDARGS_H
#include <dos/rdargs.h>
#endif

#ifndef DOS_DOS_H
#include <dos/dos.h>
#endif

struct ExtRDArgs
{
   STRPTR erda_Template;            /* readargs template */
   LONG *erda_Parameter;            /* pointer to the parameter array */
   LONG erda_FileParameter;         /* which parameter should contain the files passed
                                     * with the WBStartup message or -1 for none
                                     */
   STRPTR erda_Window;              /* window description to open, if this is started
                                     * from workbench or NULL for no window !
                                     * If in the ToolTypes exists a WINDOW variable
                                     * this is used, instead of the default here !
                                     */
   struct RDArgs *erda_RDArgs;      /* use this RDArgs structure instead of allocating
                                     * a new, so you can provide extended help !
                                     */
   ULONG erda_Flags;                /* some flags see below */
   struct RDArgs *erda_FreeArgs;    /* pointer to the RDArgs structure returned from
                                     * the ReadArgs() call !
                                     */
   STRPTR erda_Buffer;              /* pointer to a buffer to use for the WB startup or
                                     * NULL, so the ExtReadArgs() will allocated !
                                     */
   ULONG erda_BufferSize;           /* buffersize of the buffer, or if buffer == NULL
                                     * the size, which should be used to allocate the
                                     * buffer !
                                     */
   STRPTR erda_ActualPtr;           /* actual pointer in the erda_Buffer */
   STRPTR erda_EndPtr;              /* pointer to the end of the erda_Buffer */

   BPTR erda_WindowFH;              /* window filehandle MUST BE NULL */
   BPTR erda_OldOutput;             /* old output filehandle MUST BE NULL */
   BPTR erda_OldInput;              /* old input filehandle MUST BE NULL */

   struct WBArg *erda_WBArg;        /* wbargs for erda_FileParameter */
   LONG erda_NumArgs;               /* number of wbargs */
};

#define ERDA_MIN_BUFFER_SIZE        1024

#define ERDAF_WORKBENCH    (1<<0)   /* indicate, that the program is started from the
                                     * Workbench !
                                     */
#define ERDAF_ALLOCRDARGS  (1<<1)   /* args->erda_RDArgs is allocated through
                                     * AllocDosObject()
                                     */
#define ERDAF_ALLOCBUFFER  (1<<2)   /* args->erda_Buffer is allocated from FinalReadArgs() */

#define ERDAF_ALLOCWINDOW  (1<<3)   /* args->erda_Window if allocated from FinalReadArgs() */

/* ------------------------------ prototypes ------------------------------ */

LONG ExtReadArgs(LONG ac,STRPTR *av,struct ExtRDArgs *args);
void ExtFreeArgs(struct ExtRDArgs *args);

#endif /* !EXTRDARGS_H */

