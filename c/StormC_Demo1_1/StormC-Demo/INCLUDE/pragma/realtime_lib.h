// New in V40
#ifndef _INCLUDE_PRAGMA_REALTIME_LIB_H
#define _INCLUDE_PRAGMA_REALTIME_LIB_H

/*
**  $VER: realtime_lib.h 10.2 (29.12.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_REALTIME_PROTOS_H
#include <clib/realtime_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(RealTimeBase, 0x1e, LockRealTime(d0))
#pragma amicall(RealTimeBase, 0x24, UnlockRealTime(a0))
#pragma amicall(RealTimeBase, 0x2a, CreatePlayerA(a0))
#pragma tagcall(RealTimeBase, 0x2a, CreatePlayer(a0)) // New
#pragma amicall(RealTimeBase, 0x30, DeletePlayer(a0))
#pragma amicall(RealTimeBase, 0x36, SetPlayerAttrsA(a0,a1))
#pragma tagcall(RealTimeBase, 0x36, SetPlayerAttrs(a0,a1)) // New
#pragma amicall(RealTimeBase, 0x3c, SetConductorState(a0,d0,d1))
#pragma amicall(RealTimeBase, 0x42, ExternalSync(a0,d0,d1))
#pragma amicall(RealTimeBase, 0x48, NextConductor(a0))
#pragma amicall(RealTimeBase, 0x4e, FindConductor(a0))
#pragma amicall(RealTimeBase, 0x54, GetPlayerAttrsA(a0,a1))
#pragma tagcall(RealTimeBase, 0x54, GetPlayerAttrs(a0,a1)) // New

#ifdef __cplusplus
}
#endif

#endif
