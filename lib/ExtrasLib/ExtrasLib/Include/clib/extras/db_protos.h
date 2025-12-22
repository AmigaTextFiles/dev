#ifndef CLIB_EXTRAS_DB_PROTOS_H
#define CLIB_EXTRAS_DB_PROTOS_H

#ifndef DOS_DOS_H
#include <dos/dos.h>
#endif

#ifndef CLIB_EXTRAS_NNSTRING_PROTOS_H
#include <clib/extras/nnstring_protos.h>
#endif

#ifndef EXTRAS_NNSTRING_H
#include <extras/nnstring.h>
#endif

/* DB uses NNStrings */
STRPTR  db_GetNNData(STRPTR NNStr, STRPTR Name, STRPTR DefVal);
BOOL    db_GetEntryData(BPTR File, STRPTR EntryName, STRPTR Name, ... );
STRPTR  db_EntryToNN(BPTR File, STRPTR EntryName);
LONG    db_NextEntry(BPTR File, STRPTR EntryName, STRPTR Buffer, ULONG BufferSize);

#endif /* CLIB_EXTRAS_DB_PROTOS_H */
