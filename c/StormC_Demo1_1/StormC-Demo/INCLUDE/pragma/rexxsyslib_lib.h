#ifndef _INCLUDE_PRAGMA_REXXSYSLIB_LIB_H
#define _INCLUDE_PRAGMA_REXXSYSLIB_LIB_H

/*
**  $VER: rexxsyslib_lib.h 10.1 (19.7.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_REXXSYSLIB_PROTOS_H
#include <clib/rexxsyslib_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(RexxSysBase, 0x7e, CreateArgstring(a0,d0))
#pragma amicall(RexxSysBase, 0x84, DeleteArgstring(a0))
#pragma amicall(RexxSysBase, 0x8a, LengthArgstring(a0))
#pragma amicall(RexxSysBase, 0x90, CreateRexxMsg(a0,a1,d0))
#pragma amicall(RexxSysBase, 0x96, DeleteRexxMsg(a0))
#pragma amicall(RexxSysBase, 0x9c, ClearRexxMsg(a0,d0))
#pragma amicall(RexxSysBase, 0xa2, FillRexxMsg(a0,d0,d1))
#pragma amicall(RexxSysBase, 0xa8, IsRexxMsg(a0))
#pragma amicall(RexxSysBase, 0x1c2, LockRexxBase(d0))
#pragma amicall(RexxSysBase, 0x1c8, UnlockRexxBase(d0))

#ifdef __cplusplus
}
#endif

#endif
