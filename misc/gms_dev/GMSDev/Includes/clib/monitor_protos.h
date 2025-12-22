#ifndef  CLIB_MONITOR_PROTOS_H
#define  CLIB_MONITOR_PROTOS_H

/*
**   $VER: monitor_protos.h V1.0
**
**   C prototypes.
**
**   (C) Copyright 1996-1998 DreamWorld Productions.
**       All Rights Reserved.
*/

#ifndef  SYSTEM_TYPES_H
#include <system/types.h>
#endif

void monRemapFunctions(struct DPKBase *);
APTR monSetHardware(struct GScreen *, UWORD *Insert);
LONG monTakeDisplay(struct GScreen *);
struct GScreen * monReturnDisplay(void);
void monRemakeScreen(struct GScreen *);

#endif /* CLIB_MONITOR_PROTOS_H */

