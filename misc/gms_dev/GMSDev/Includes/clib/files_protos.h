#ifndef  CLIB_FILES_PROTOS_H
#define  CLIB_FILES_PROTOS_H

/*
**   $VER: files_protos.h V1.0
**
**   C prototypes.
**
**   (C) Copyright 1996-1998 DreamWorld Productions.
**       All Rights Reserved.
*/

#ifndef  DPKERNEL_H
#include <dpkernel/dpkernel.h>
#endif

BYTE * GetFComment(APTR Object);
struct Time * GetFDate(APTR Object);
LONG GetFPermissions(APTR Object);
LONG GetFSize(APTR Object);
LONG SetFComment(APTR Object, BYTE *Comment);
LONG SetFDate(APTR Object, struct Time *);
struct File * OpenFile(APTR Source, LONG Flags);

#endif /* CLIB_FILES_PROTOS_H */

