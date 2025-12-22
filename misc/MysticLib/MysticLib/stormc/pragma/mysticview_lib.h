#ifndef _INCLUDE_PRAGMA_MYSTICVIEW_LIB_H
#define _INCLUDE_PRAGMA_MYSTICVIEW_LIB_H

#ifndef CLIB_MYSTICVIEW_PROTOS_H
#include <clib/mysticview_protos.h>
#endif

#pragma amicall(MysticBase,0x01E,MV_CreateA(a0,a1,a2))
#pragma amicall(MysticBase,0x024,MV_Delete(a0))
#pragma amicall(MysticBase,0x02A,MV_SetAttrsA(a0,a1))
#pragma amicall(MysticBase,0x030,MV_DrawOn(a0))
#pragma amicall(MysticBase,0x036,MV_DrawOff(a0))
#pragma amicall(MysticBase,0x03C,MV_Refresh(a0))
#pragma amicall(MysticBase,0x042,MV_GetAttrsA(a0,a1))
#pragma amicall(MysticBase,0x048,MV_SetViewStart(a0,d0,d1))
#pragma amicall(MysticBase,0x04E,MV_SetViewRelative(a0,d0,d1))
#pragma tagcall(MysticBase,0x01E,MV_Create(a0,a1,a2))
#pragma tagcall(MysticBase,0x02A,MV_SetAttrs(a0,a1))
#pragma tagcall(MysticBase,0x042,MV_GetAttrs(a0,a1))

#endif	/*  _INCLUDE_PRAGMA_MYSTICVIEW_LIB_H  */
