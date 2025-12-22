#ifndef CLIB_IOBLIX_DEV_PROTOS_H
#define CLIB_IOBLIX_DEV_PROTOS_H

/*
**      $VER: ioblix_dev_protos.h 37.3 (7.4.99)
**
**      C prototypes. For use with 32 bit integers only.
**
**      (C) Copyright 1998 Thore Böckelmann
**      All Rights Reserved.
**
** (TAB SIZE: 8)
*/

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef EXEC_IO_H
#include <exec/io.h>
#endif

#ifndef RESOURCES_IOBLIX_H
#include <resources/ioblix.h>
#endif

struct IOBlixChipNode *GetChipInfo ( struct IORequest *ioreq );
struct ECPProbeInformation *AllocECPInfo( struct IORequest *ioreq );
void *FreeECPInfo( struct ECPProbeInformation *epi );

#endif /* CLIB_IOBLIX_PROTOS_H */
