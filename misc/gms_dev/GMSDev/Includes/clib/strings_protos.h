#ifndef  CLIB_STRINGS_PROTOS_H
#define  CLIB_STRINGS_PROTOS_H

/*
**   $VER: strings_protos.h V1.0
**
**   C prototypes.
**
**   (C) Copyright 1998 DreamWorld Productions.
**       All Rights Reserved.
*/

#ifndef  DPKERNEL_H
#include <dpkernel/dpkernel.h>
#endif

APTR   IntToStr(LONG Integer, BYTE *);
void   StrCapitalize( BYTE *);
BYTE * StrClone(BYTE *, LONG MemFlags);
LONG   StrCompare(BYTE *, BYTE *, LONG Length, WORD CaseSensitive);
void   StrCopy(BYTE *, BYTE *Dest, LONG Length);
LONG   StrLength(BYTE *);
void   StrLower(BYTE *);
APTR   StrMerge(BYTE *, BYTE *, BYTE *Dest);
LONG   StrSearch(BYTE *Search, BYTE *);
void   StrUpper(BYTE *);
LONG   StrToInt(BYTE *);

#endif /* CLIB_STRINGS_PROTOS_H */

