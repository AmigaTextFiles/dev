#ifndef _INCLUDE_PRAGMA_MATHIEEESINGTRANS_LIB_H
#define _INCLUDE_PRAGMA_MATHIEEESINGTRANS_LIB_H

/*
**  $VER: mathieeesingtrans_lib.h 10.1 (19.7.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_MATHIEEESINGTRANS_PROTOS_H
#include <clib/mathieeesingtrans_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(MathIeeeSingTransBase, 0x1e, IEEESPAtan(d0))
#pragma amicall(MathIeeeSingTransBase, 0x24, IEEESPSin(d0))
#pragma amicall(MathIeeeSingTransBase, 0x2a, IEEESPCos(d0))
#pragma amicall(MathIeeeSingTransBase, 0x30, IEEESPTan(d0))
#pragma amicall(MathIeeeSingTransBase, 0x36, IEEESPSincos(a0,d0))
#pragma amicall(MathIeeeSingTransBase, 0x3c, IEEESPSinh(d0))
#pragma amicall(MathIeeeSingTransBase, 0x42, IEEESPCosh(d0))
#pragma amicall(MathIeeeSingTransBase, 0x48, IEEESPTanh(d0))
#pragma amicall(MathIeeeSingTransBase, 0x4e, IEEESPExp(d0))
#pragma amicall(MathIeeeSingTransBase, 0x54, IEEESPLog(d0))
#pragma amicall(MathIeeeSingTransBase, 0x5a, IEEESPPow(d1,d0))
#pragma amicall(MathIeeeSingTransBase, 0x60, IEEESPSqrt(d0))
#pragma amicall(MathIeeeSingTransBase, 0x66, IEEESPTieee(d0))
#pragma amicall(MathIeeeSingTransBase, 0x6c, IEEESPFieee(d0))
#pragma amicall(MathIeeeSingTransBase, 0x72, IEEESPAsin(d0))
#pragma amicall(MathIeeeSingTransBase, 0x78, IEEESPAcos(d0))
#pragma amicall(MathIeeeSingTransBase, 0x7e, IEEESPLog10(d0))

#ifdef __cplusplus
}
#endif

#endif
