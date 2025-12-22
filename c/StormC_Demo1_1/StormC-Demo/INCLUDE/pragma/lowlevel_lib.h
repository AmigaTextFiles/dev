// Neu in V40
#ifndef _INCLUDE_PRAGMA_LOWLEVEL_LIB_H
#define _INCLUDE_PRAGMA_LOWLEVEL_LIB_H

/*
**  $VER: lowlevel_lib.h 10.2 (29.12.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_LOWLEVEL_PROTOS_H
#include <clib/lowlevel_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(LowLevelBase, 0x1e, ReadJoyPort(d0))
#pragma amicall(LowLevelBase, 0x24, GetLanguageSelection())
#pragma amicall(LowLevelBase, 0x30, GetKey())
#pragma amicall(LowLevelBase, 0x36, QueryKeys(a0,d1))
#pragma amicall(LowLevelBase, 0x3c, AddKBInt(a0,a1))
#pragma amicall(LowLevelBase, 0x42, RemKBInt(a1))
#pragma amicall(LowLevelBase, 0x48, SystemControlA(a1))
#pragma tagcall(LowLevelBase, 0x48, SystemControl(a1))  // New
#pragma amicall(LowLevelBase, 0x4e, AddTimerInt(a0,a1))
#pragma amicall(LowLevelBase, 0x54, RemTimerInt(a1))
#pragma amicall(LowLevelBase, 0x5a, StopTimerInt(a1))
#pragma amicall(LowLevelBase, 0x60, StartTimerInt(a1,d0,d1))
#pragma amicall(LowLevelBase, 0x66, ElapsedTime(a0))
#pragma amicall(LowLevelBase, 0x6c, AddVBlankInt(a0,a1))
#pragma amicall(LowLevelBase, 0x72, RemVBlankInt(a1))
#pragma amicall(LowLevelBase, 0x84, SetJoyPortAttrsA(d0,a1))
#pragma tagcall(LowLevelBase, 0x84, SetJoyPortAttrs(d0,a1)) // New

#ifdef __cplusplus
}
#endif

#endif
