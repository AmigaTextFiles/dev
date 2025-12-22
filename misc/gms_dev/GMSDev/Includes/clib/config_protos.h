#ifndef  CLIB_CONFIG_PROTOS_H
#define  CLIB_CONFIG_PROTOS_H

/*
**   $VER: config_protos.h V1.0
**
**   C prototypes.
**
**   (C) Copyright 1998 DreamWorld Productions.
**       All Rights Reserved.
*/

#ifndef  DPKERNEL_H
#include <dpkernel/dpkernel.h>
#endif

BYTE * ReadConfig(struct Config *, BYTE *Section, BYTE *Item);
LONG   ReadConfigInt(struct Config *, BYTE *Section, BYTE *Item);

#endif /* CLIB_CONFIG_PROTOS_H */

