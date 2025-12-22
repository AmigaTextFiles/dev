/*
** ObjectiveAmiga: NeXTSTEP NXStream implementation for AmigaOS
** See GNU:lib/libobjam/ReadMe for details
*/


#include <stdarg.h>

#include <libraries/objc.h>


typedef struct __NXStream
{
} NXStream;


/* File and port streams */
NXStream *NXOpenFile(int fd, int mode);
NXStream *NXOpenPort(port_t port, int mode);

/* Memory streams */
NXStream *NXOpenMemory(const char *address, int size, int mode);
NXStream *NXMapFile(const char *pathName, int mode);
int NXSaveToFile(NXStream *stream, const char *name);
void NXGetMemoryBuffer(NXStream *stream, char **streambuf, int *len, int *maxlen);
void NXCloseMemory(NXStream *stream, int option);

/* Close a stream */
void NXClose(NXStream *stream);

/* Flush a stream */
int NXFlush(NXStream *stream);

/* Read/write unformatted data */
int NXRead(NXStream *stream, void *buf, int count);
int NXWrite(NXStream *stream, const void *buf, int count);

/* Read/write formatted data */
int NXPutc(NXStream *stream, char c);
int NXGetc(NXStream *stream);
void NXUngetc(NXStream *stream);
int NXScanf(NXStream *stream, const char *format,...);
void NXPrintf(NXStream *stream, const char *format,...);
int NXVScanf(NXStream *stream, const char *format, va_list argList);
void NXVPrintf(NXStream *stream, const char *format, va_list argList);

/* Register a formatting procedure */
typedef void NXPrintProc(NXStream *stream, void *item, void *procData);
void NXRegisterPrintfProc(char formatChar, NXPrintProc *proc, void *procData);

/* Set or report current position */
void NXSeek(NXStream *stream, long offset, int ptrName);
long NXTell(NXStream *stream);
BOOL NXAtEOS(NXStream *stream);

/* Support a user-defined stream */
NXStream *NXStreamCreateFromZone(int mode, int createBuf, NXZone *zone);
NXStream *NXStreamCreate(int mode, int createBuf);
void NXStreamDestroy(NXStream *stream);
int NXDefaultRead(NXStream *stream, void *buf, int count);
int NXDefaultWrite(NXStream *stream, const void *buf, int count);
int NXFill(NXStream *stream);
void NXChangeBuffer(NXStream *stream);
