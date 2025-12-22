#ifndef _INCLUDE_PRAGMA_CIA_LIB_H
#define _INCLUDE_PRAGMA_CIA_LIB_H

/*
**  $VER: cia_lib.h 10.1 (19.7.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_CIA_PROTOS_H
#include <clib/cia_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(CiaBase, 0x6, AddICRVector(a6,d0,a1))
#pragma amicall(CiaBase, 0xc, RemICRVector(a6,d0,a1))
#pragma amicall(CiaBase, 0x12, AbleICR(a6,d0))
#pragma amicall(CiaBase, 0x18, SetICR(a6,d0))

#ifdef __cplusplus
}
#endif

#endif
