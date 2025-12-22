#ifndef _INCLUDE_PRAGMA_ICON_LIB_H
#define _INCLUDE_PRAGMA_ICON_LIB_H

/*
**  $VER: icon_lib.h 10.1 (19.7.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_ICON_PROTOS_H
#include <clib/icon_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(IconBase, 0x36, FreeFreeList(a0))
#pragma amicall(IconBase, 0x48, AddFreeList(a0,a1,a2))
#pragma amicall(IconBase, 0x4e, GetDiskObject(a0))
#pragma amicall(IconBase, 0x54, PutDiskObject(a0,a1))
#pragma amicall(IconBase, 0x5a, FreeDiskObject(a0))
#pragma amicall(IconBase, 0x60, FindToolType(a0,a1))
#pragma amicall(IconBase, 0x66, MatchToolValue(a0,a1))
#pragma amicall(IconBase, 0x6c, BumpRevision(a0,a1))
#pragma amicall(IconBase, 0x78, GetDefDiskObject(d0))
#pragma amicall(IconBase, 0x7e, PutDefDiskObject(a0))
#pragma amicall(IconBase, 0x84, GetDiskObjectNew(a0))
#pragma amicall(IconBase, 0x8a, DeleteDiskObject(a0))

#ifdef __cplusplus
}
#endif

#endif
