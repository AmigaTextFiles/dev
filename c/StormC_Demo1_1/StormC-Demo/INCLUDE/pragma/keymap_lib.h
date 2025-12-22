#ifndef _INCLUDE_PRAGMA_KEYMAP_LIB_H
#define _INCLUDE_PRAGMA_KEYMAP_LIB_H

/*
**  $VER: keymap_lib.h 10.1 (19.7.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_KEYMAP_PROTOS_H
#include <clib/keymap_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(KeymapBase, 0x1e, SetKeyMapDefault(a0))
#pragma amicall(KeymapBase, 0x24, AskKeyMapDefault())
#pragma amicall(KeymapBase, 0x2a, MapRawKey(a0,a1,d1,a2))
#pragma amicall(KeymapBase, 0x30, MapANSI(a0,d0,a1,d1,a2))

#ifdef __cplusplus
}
#endif

#endif
