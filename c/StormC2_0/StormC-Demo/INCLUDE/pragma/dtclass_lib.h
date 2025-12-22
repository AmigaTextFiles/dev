#ifndef _INCLUDE_PRAGMA_DTCLASS_LIB_H
#define _INCLUDE_PRAGMA_DTCLASS_LIB_H

/*
**  $VER: dtclass_lib.h 10.1 (19.7.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_DTCLASS_PROTOS_H
#include <clib/dtclass_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(DTClassBase, 0x1e, ObtainEngine())

#ifdef __cplusplus
}
#endif

#endif
