#ifndef  CLIB_EMULATION_PROTOS_H
#define  CLIB_EMULATION_PROTOS_H

/*
**   $VER: emulation_protos.h V1.0
**
**   C prototypes.
**
**   (C) Copyright 1996-1998 DreamWorld Productions.
**       All Rights Reserved.
*/

#ifndef  DPKERNEL_H
#include <dpkernel/dpkernel.h>
#endif

LONG emuRemapFunctions(struct DPKBase *);
LONG emuInitRefresh(struct GScreen *);
void emuFreeRefresh(struct GScreen *);
void emuRefreshScreen(struct GScreen *);

#endif /* CLIB_EMULATION_PROTOS_H */
