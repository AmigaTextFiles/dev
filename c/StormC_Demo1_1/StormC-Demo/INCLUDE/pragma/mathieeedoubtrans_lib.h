#ifndef _INCLUDE_PRAGMA_MATHIEEEDOUBTRANS_LIB_H
#define _INCLUDE_PRAGMA_MATHIEEEDOUBTRANS_LIB_H

/*
**  $VER: mathieeesoubtrans_lib.h 10.1 (19.7.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_MATHIEEEDOUBTRANS_PROTOS_H
#include <clib/mathieeedoubtrans_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(MathIeeeDoubTransBase, 0x1e, IEEEDPAtan(d0,d1))
#pragma amicall(MathIeeeDoubTransBase, 0x24, IEEEDPSin(d0,d1))
#pragma amicall(MathIeeeDoubTransBase, 0x2a, IEEEDPCos(d0,d1))
#pragma amicall(MathIeeeDoubTransBase, 0x30, IEEEDPTan(d0,d1))
#pragma amicall(MathIeeeDoubTransBase, 0x36, IEEEDPSincos(a0,d0,d1))
#pragma amicall(MathIeeeDoubTransBase, 0x3c, IEEEDPSinh(d0,d1))
#pragma amicall(MathIeeeDoubTransBase, 0x42, IEEEDPCosh(d0,d1))
#pragma amicall(MathIeeeDoubTransBase, 0x48, IEEEDPTanh(d0,d1))
#pragma amicall(MathIeeeDoubTransBase, 0x4e, IEEEDPExp(d0,d1))
#pragma amicall(MathIeeeDoubTransBase, 0x54, IEEEDPLog(d0,d1))
#pragma amicall(MathIeeeDoubTransBase, 0x5a, IEEEDPPow(d2,d3,d0,d1))
#pragma amicall(MathIeeeDoubTransBase, 0x60, IEEEDPSqrt(d0,d1))
#pragma amicall(MathIeeeDoubTransBase, 0x66, IEEEDPTieee(d0,d1))
#pragma amicall(MathIeeeDoubTransBase, 0x6c, IEEEDPFieee(d0))
#pragma amicall(MathIeeeDoubTransBase, 0x72, IEEEDPAsin(d0,d1))
#pragma amicall(MathIeeeDoubTransBase, 0x78, IEEEDPAcos(d0,d1))
#pragma amicall(MathIeeeDoubTransBase, 0x7e, IEEEDPLog10(d0,d1))

#ifdef __cplusplus
}
#endif

#endif
