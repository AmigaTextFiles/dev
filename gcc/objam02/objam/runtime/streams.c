/*
** ObjectiveAmiga: NeXTSTEP NXStream implementation for AmigaOS
** See GNU:lib/libobjam/ReadMe for details
*/


#include <exec/lists.h>
#include <proto/exec.h>
#include <clib/alib_protos.h>
#include <stddef.h>

#include <libraries/objc.h>
#include <clib/objc_protos.h>

#include "streams.h"

#include "misc.h" /* For the ANSI function emulations */
#include "zone.h" /* For quick access to the default zone */


/*
** File and port streams
*/

NXStream *NXOpenFile(int fd, int mode) /* Open an open()ed file */
{
}

NXStream *NXOpenPort(port_t port, int mode) /* Open a mach port */
{
}


/*
** Memory streams
*/

NXStream *NXOpenMemory(const char *address, int size, int mode) /* Open a memory block */
/* 'NULL, 0, NX_WRITEONLY' indicates dynamic memory management */
{
}

NXStream *NXMapFile(const char *pathName, int mode) /* Open a file on disk via a memory stream */
{
}

int NXSaveToFile(NXStream *stream, const char *name) /* Save stream contents to file */
/* Return value of -1 indicates error */
{
}

void NXGetMemoryBuffer(NXStream *stream, char **streambuf, int *len, int *maxlen)
/* Return memory buffer dimensions */
{
}

void NXCloseMemory(NXStream *stream, int option) /* Close a memory stream */
/* NX_TRUNCATEBUFFER: free unused memory pages */
/* NX_SAVEBUFFER: don't free */
/* Internal buffers are never freed. Use NXGetMemoryBuffer() and deallocate with vm_deallocate() */
{
}


/*
** Close a stream
*/

void NXClose(NXStream *stream) /* Flush and close any kind of stream */
{
}


/*
** Flush a stream
*/

int NXFlush(NXStream *stream) /* Flush a stream */
/* Returns number of characters written */
{
}


/*
** Read/write unformatted data
*/

int NXRead(NXStream *stream, void *buf, int count) /* Read raw data */
{
}

int NXWrite(NXStream *stream, const void *buf, int count) /* Write raw data */
{
}


/*
** Read/write formatted data
*/

int NXPutc(NXStream *stream, char c) /* Write a character */
/* Returns the character written */
{
}

int NXGetc(NXStream *stream) /* Read a character */
/* Returns the character read */
{
}

void NXUngetc(NXStream *stream) /* Puts back the last *one* character */
{
}

int NXScanf(NXStream *stream, const char *format,...)
/* Returns number of characters read for failure, EOF for success */
{
}

void NXPrintf(NXStream *stream, const char *format,...)
{
}

int NXVScanf(NXStream *stream, const char *format, va_list argList)
/* Returns number of characters read for failure, EOF for success */
{
}

void NXVPrintf(NXStream *stream, const char *format, va_list argList)
{
}


/*
** Register a formatting procedure
*/

void NXRegisterPrintfProc(char formatChar, NXPrintProc *proc, void *procData)
{
}


/*
** Set or report current position
*/

void NXSeek(NXStream *stream, long offset, int ptrName)
{
}

long NXTell(NXStream *stream)
{
}

BOOL NXAtEOS(NXStream *stream)
{
}


/*
** Support a user-defined stream
*/

NXStream *NXStreamCreateFromZone(int mode, int createBuf, NXZone *zone)
{
}

NXStream *NXStreamCreate(int mode, int createBuf)
{
}

void NXStreamDestroy(NXStream *stream)
{
}

int NXDefaultRead(NXStream *stream, void *buf, int count)
{
}

int NXDefaultWrite(NXStream *stream, const void *buf, int count)
{
}

int NXFill(NXStream *stream)
{
}

void NXChangeBuffer(NXStream *stream)
{
}
