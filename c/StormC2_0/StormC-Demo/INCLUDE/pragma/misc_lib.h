#ifndef _INCLUDE_PRAGMA_MISC_LIB_H
#define _INCLUDE_PRAGMA_MISC_LIB_H

/*
**  $VER: misc_lib.h 10.1 (19.7.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_MISC_PROTOS_H
#include <clib/misc_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(MiscBase, 0x6, AllocMiscResource(d0,a1))
#pragma amicall(MiscBase, 0xc, FreeMiscResource(d0))

#ifdef __cplusplus
}
#endif

#endif
