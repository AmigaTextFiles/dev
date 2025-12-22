#ifndef _INCLUDE_PRAGMA_AMIGAGUIDE_LIB_H
#define _INCLUDE_PRAGMA_AMIGAGUIDE_LIB_H

/*
**  $VER: amigaguide_lib.h 10.2 (29.12.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_AMIGAGUIDE_PROTOS_H
#include <clib/amigaguide_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(AmigaGuideBase, 0x24, LockAmigaGuideBase(a0))
#pragma amicall(AmigaGuideBase, 0x2a, UnlockAmigaGuideBase(d0))
#pragma amicall(AmigaGuideBase, 0x36, OpenAmigaGuideA(a0,a1))
#pragma tagcall(AmigaGuideBase, 0x36, OpenAmigaGuide(a0, a1))	// New
#pragma amicall(AmigaGuideBase, 0x3c, OpenAmigaGuideAsyncA(a0,d0))
#pragma tagcall(AmigaGuideBase, 0x3c, OpenAmigaGuideAsync(a0,d0)) // New
#pragma amicall(AmigaGuideBase, 0x42, CloseAmigaGuide(a0))
#pragma amicall(AmigaGuideBase, 0x48, AmigaGuideSignal(a0))
#pragma amicall(AmigaGuideBase, 0x4e, GetAmigaGuideMsg(a0))
#pragma amicall(AmigaGuideBase, 0x54, ReplyAmigaGuideMsg(a0))
#pragma amicall(AmigaGuideBase, 0x5a, SetAmigaGuideContextA(a0,d0,d1))
#pragma tagcall(AmigaGuideBase, 0x5a, SetAmigaGuideContext(a0,d0,d1)) // New
#pragma amicall(AmigaGuideBase, 0x60, SendAmigaGuideContextA(a0,d0))
#pragma tagcall(AmigaGuideBase, 0x60, SendAmigaGuideContext(a0,d0)) // New
#pragma amicall(AmigaGuideBase, 0x66, SendAmigaGuideCmdA(a0,d0,d1))
#pragma tagcall(AmigaGuideBase, 0x66, SendAmigaGuideCmd(a0,d0,d1)) // New
#pragma amicall(AmigaGuideBase, 0x6c, SetAmigaGuideAttrsA(a0,a1))
#pragma tagcall(AmigaGuideBase, 0x6c, SetAmigaGuideAttrs(a0,a1)) // New
#pragma amicall(AmigaGuideBase, 0x72, GetAmigaGuideAttr(d0,a0,a1))
#pragma amicall(AmigaGuideBase, 0x7e, LoadXRef(a0,a1))
#pragma amicall(AmigaGuideBase, 0x84, ExpungeXRef())
#pragma amicall(AmigaGuideBase, 0x8a, AddAmigaGuideHostA(a0,d0,a1))
#pragma tagcall(AmigaGuideBase, 0x8a, AddAmigaGuideHost(a0,d0,a1)) // New
#pragma amicall(AmigaGuideBase, 0x90, RemoveAmigaGuideHostA(a0,a1))
#pragma tagcall(AmigaGuideBase, 0x90, RemoveAmigaGuideHost(a0,a1)) // New
#pragma amicall(AmigaGuideBase, 0xd2, GetAmigaGuideString(d0))

#ifdef __cplusplus
}
#endif

#endif
