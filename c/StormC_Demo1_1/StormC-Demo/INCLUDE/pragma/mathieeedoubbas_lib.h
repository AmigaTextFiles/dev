#ifndef _INCLUDE_PRAGMA_MATHIEEEDOUBBAS_LIB_H
#define _INCLUDE_PRAGMA_MATHIEEEDOUBBAS_LIB_H

/*
**  $VER: mathieeedoubbas_lib.h 10.1 (19.7.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_MATHIEEEDOUBBAS_PROTOS_H
#include <clib/mathieeedoubbas_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(MathIeeeDoubBasBase, 0x1e, IEEEDPFix(d0,d1))
#pragma amicall(MathIeeeDoubBasBase, 0x24, IEEEDPFlt(d0))
#pragma amicall(MathIeeeDoubBasBase, 0x2a, IEEEDPCmp(d0,d1,d2,d3))
#pragma amicall(MathIeeeDoubBasBase, 0x30, IEEEDPTst(d0,d1))
#pragma amicall(MathIeeeDoubBasBase, 0x36, IEEEDPAbs(d0,d1))
#pragma amicall(MathIeeeDoubBasBase, 0x3c, IEEEDPNeg(d0,d1))
#pragma amicall(MathIeeeDoubBasBase, 0x42, IEEEDPAdd(d0,d1,d2,d3))
#pragma amicall(MathIeeeDoubBasBase, 0x48, IEEEDPSub(d0,d1,d2,d3))
#pragma amicall(MathIeeeDoubBasBase, 0x4e, IEEEDPMul(d0,d1,d2,d3))
#pragma amicall(MathIeeeDoubBasBase, 0x54, IEEEDPDiv(d0,d1,d2,d3))
#pragma amicall(MathIeeeDoubBasBase, 0x5a, IEEEDPFloor(d0,d1))
#pragma amicall(MathIeeeDoubBasBase, 0x60, IEEEDPCeil(d0,d1))

#ifdef __cplusplus
}
#endif

#endif
