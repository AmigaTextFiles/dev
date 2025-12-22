#ifndef _INCLUDE_PRAGMA_RAMDRIVE_LIB_H
#define _INCLUDE_PRAGMA_RAMDRIVE_LIB_H

/*
**  $VER: ramdrive_lib.h 10.1 (19.7.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_RAMDRIVE_PROTOS_H
#include <clib/ramdrive_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(RamdriveDevice, 0x2a, KillRAD0())
#pragma amicall(RamdriveDevice, 0x30, KillRAD(d0))

#ifdef __cplusplus
}
#endif

#endif
