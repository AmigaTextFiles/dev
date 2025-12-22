#ifndef _INCLUDE_PRAGMA_POTGO_LIB_H
#define _INCLUDE_PRAGMA_POTGO_LIB_H

/*
**  $VER: potgo_lib.h 10.1 (19.7.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_POTGO_PROTOS_H
#include <clib/potgo_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(PotgoBase, 0x6, AllocPotBits(d0))
#pragma amicall(PotgoBase, 0xc, FreePotBits(d0))
#pragma amicall(PotgoBase, 0x12, WritePotgo(d0,d1))

#ifdef __cplusplus
}
#endif

#endif
