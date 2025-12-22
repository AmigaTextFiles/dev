#ifndef _INCLUDE_PRAGMA_BATTMEM_LIB_H
#define _INCLUDE_PRAGMA_BATTMEM_LIB_H

/*
**  $VER: battmem_lib.h 10.1 (19.7.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_BATTMEM_PROTOS_H
#include <clib/battmem_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(BattMemBase, 0x6, ObtainBattSemaphore())
#pragma amicall(BattMemBase, 0xc, ReleaseBattSemaphore())
#pragma amicall(BattMemBase, 0x12, ReadBattMem(a0,d0,d1))
#pragma amicall(BattMemBase, 0x18, WriteBattMem(a0,d0,d1))

#ifdef __cplusplus
}
#endif

#endif
