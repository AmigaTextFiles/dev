// New in V40
#ifndef _INCLUDE_PRAGMA_NONVOLATILE_LIB_H
#define _INCLUDE_PRAGMA_NONVOLATILE_LIB_H

/*
**  $VER: nonvolatile_lib.h 10.1 (19.7.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_NONVOLATILE_PROTOS_H
#include <clib/nonvolatile_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(NVBase, 0x1e, GetCopyNV(a0,a1,d1))
#pragma amicall(NVBase, 0x24, FreeNVData(a0))
#pragma amicall(NVBase, 0x2a, StoreNV(a0,a1,a2,d0,d1))
#pragma amicall(NVBase, 0x30, DeleteNV(a0,a1,d1))
#pragma amicall(NVBase, 0x36, GetNVInfo(d1))
#pragma amicall(NVBase, 0x3c, GetNVList(a0,d1))
#pragma amicall(NVBase, 0x42, SetNVProtection(a0,a1,d2,d1))

#ifdef __cplusplus
}
#endif

#endif
