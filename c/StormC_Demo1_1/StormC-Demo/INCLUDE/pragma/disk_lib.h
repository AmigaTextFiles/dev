#ifndef _INCLUDE_PRAGMA_DISK_LIB_H
#define _INCLUDE_PRAGMA_DISK_LIB_H

/*
**  $VER: disk_lib.h 10.1 (19.7.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_DISK_PROTOS_H
#include <clib/disk_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(DiskBase, 0x6, AllocUnit(d0))
#pragma amicall(DiskBase, 0xc, FreeUnit(d0))
#pragma amicall(DiskBase, 0x12, GetUnit(a1))
#pragma amicall(DiskBase, 0x18, GiveUnit())
#pragma amicall(DiskBase, 0x1e, GetUnitID(d0))
#pragma amicall(DiskBase, 0x24, ReadUnitID(d0))

#ifdef __cplusplus
}
#endif

#endif
