#ifndef _INCLUDE_PRAGMA_BULLET_LIB_H
#define _INCLUDE_PRAGMA_BULLET_LIB_H

/*
**  $VER: bullet_lib.h 10.2 (29.12.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_BULLET_PROTOS_H
#include <clib/bullet_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(BulletBase, 0x1e, OpenEngine())
#pragma amicall(BulletBase, 0x24, CloseEngine(a0))
#pragma amicall(BulletBase, 0x2a, SetInfoA(a0,a1))
#pragma tagcall(BulletBase, 0x2a, SetInfo(a0,a1)) // New
#pragma amicall(BulletBase, 0x30, ObtainInfoA(a0,a1))
#pragma tagcall(BulletBase, 0x30, ObtainInfo(a0,a1)) // New
#pragma amicall(BulletBase, 0x36, ReleaseInfoA(a0,a1))
#pragma tagcall(BulletBase, 0x36, ReleaseInfo(a0,a1)) // New

#ifdef __cplusplus
}
#endif

#endif
