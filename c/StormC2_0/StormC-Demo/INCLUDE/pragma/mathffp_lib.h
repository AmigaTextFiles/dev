#ifndef _INCLUDE_PRAGMA_MATHFFP_LIB_H
#define _INCLUDE_PRAGMA_MATHFFP_LIB_H

/*
**  $VER: mathffp_lib.h 10.1 (19.7.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_MATHFFP_PROTOS_H
#include <clib/mathffp_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(MathBase, 0x1e, SPFix(d0))
#pragma amicall(MathBase, 0x24, SPFlt(d0))
#pragma amicall(MathBase, 0x2a, SPCmp(d1,d0))
#pragma amicall(MathBase, 0x30, SPTst(d1))
#pragma amicall(MathBase, 0x36, SPAbs(d0))
#pragma amicall(MathBase, 0x3c, SPNeg(d0))
#pragma amicall(MathBase, 0x42, SPAdd(d1,d0))
#pragma amicall(MathBase, 0x48, SPSub(d1,d0))
#pragma amicall(MathBase, 0x4e, SPMul(d1,d0))
#pragma amicall(MathBase, 0x54, SPDiv(d1,d0))
#pragma amicall(MathBase, 0x5a, SPFloor(d0))
#pragma amicall(MathBase, 0x60, SPCeil(d0))

#ifdef __cplusplus
}
#endif

#endif
