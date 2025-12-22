#ifndef _INCLUDE_PRAGMA_CONSOLE_LIB_H
#define _INCLUDE_PRAGMA_CONSOLE_LIB_H

/*
**  $VER: console_lib.h 10.1 (19.7.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_CONSOLE_PROTOS_H
#include <clib/console_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(ConsoleDevice, 0x2a, CDInputHandler(a0,a1))
#pragma amicall(ConsoleDevice, 0x30, RawKeyConvert(a0,a1,d1,a2))

#ifdef __cplusplus
}
#endif

#endif
