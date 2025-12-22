#ifndef _INCLUDE_PRAGMA_ASL_LIB_H
#define _INCLUDE_PRAGMA_ASL_LIB_H

/*
**  $VER: asl_lib.h 10.2 (29.12.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_ASL_PROTOS_H
#include <clib/asl_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(AslBase, 0x1e, AllocFileRequest())
#pragma amicall(AslBase, 0x24, FreeFileRequest(a0))
#pragma amicall(AslBase, 0x2a, RequestFile(a0))
#pragma amicall(AslBase, 0x30, AllocAslRequest(d0,a0))
#pragma tagcall(AslBase, 0x30, AllocAslRequestTags(d0,a0)) // New
#pragma amicall(AslBase, 0x36, FreeAslRequest(a0))
#pragma amicall(AslBase, 0x3c, AslRequest(a0,a1))
#pragma tagcall(AslBase, 0x3c, AslRequestTags(a0,a1)) // New

#ifdef __cplusplus
}
#endif

#endif
