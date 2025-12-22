#ifndef _INCLUDE_PRAGMA_MATHIEEESINGBAS_LIB_H
#define _INCLUDE_PRAGMA_MATHIEEESINGBAS_LIB_H

/*
**  $VER: mathieeesingbas_lib.h 10.1 (19.7.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_MATHIEEESINGBAS_PROTOS_H
#include <clib/mathieeesingbas_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(MathIeeeSingBasBase, 0x1e, IEEESPFix(d0))
#pragma amicall(MathIeeeSingBasBase, 0x24, IEEESPFlt(d0))
#pragma amicall(MathIeeeSingBasBase, 0x2a, IEEESPCmp(d0,d1))
#pragma amicall(MathIeeeSingBasBase, 0x30, IEEESPTst(d0))
#pragma amicall(MathIeeeSingBasBase, 0x36, IEEESPAbs(d0))
#pragma amicall(MathIeeeSingBasBase, 0x3c, IEEESPNeg(d0))
#pragma amicall(MathIeeeSingBasBase, 0x42, IEEESPAdd(d0,d1))
#pragma amicall(MathIeeeSingBasBase, 0x48, IEEESPSub(d0,d1))
#pragma amicall(MathIeeeSingBasBase, 0x4e, IEEESPMul(d0,d1))
#pragma amicall(MathIeeeSingBasBase, 0x54, IEEESPDiv(d0,d1))
#pragma amicall(MathIeeeSingBasBase, 0x5a, IEEESPFloor(d0))
#pragma amicall(MathIeeeSingBasBase, 0x60, IEEESPCeil(d0))

#ifdef __cplusplus
}
#endif

#endif
