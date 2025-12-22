#ifndef _INCLUDE_PRAGMA_MATHTRANS_LIB_H
#define _INCLUDE_PRAGMA_MATHTRANS_LIB_H

/*
**  $VER: mathtrans_lib.h 10.1 (19.7.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_MATHTRANS_PROTOS_H
#include <clib/mathtrans_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(MathTransBase, 0x1e, SPAtan(d0))
#pragma amicall(MathTransBase, 0x24, SPSin(d0))
#pragma amicall(MathTransBase, 0x2a, SPCos(d0))
#pragma amicall(MathTransBase, 0x30, SPTan(d0))
#pragma amicall(MathTransBase, 0x36, SPSincos(d1,d0))
#pragma amicall(MathTransBase, 0x3c, SPSinh(d0))
#pragma amicall(MathTransBase, 0x42, SPCosh(d0))
#pragma amicall(MathTransBase, 0x48, SPTanh(d0))
#pragma amicall(MathTransBase, 0x4e, SPExp(d0))
#pragma amicall(MathTransBase, 0x54, SPLog(d0))
#pragma amicall(MathTransBase, 0x5a, SPPow(d1,d0))
#pragma amicall(MathTransBase, 0x60, SPSqrt(d0))
#pragma amicall(MathTransBase, 0x66, SPTieee(d0))
#pragma amicall(MathTransBase, 0x6c, SPFieee(d0))
#pragma amicall(MathTransBase, 0x72, SPAsin(d0))
#pragma amicall(MathTransBase, 0x78, SPAcos(d0))
#pragma amicall(MathTransBase, 0x7e, SPLog10(d0))

#ifdef __cplusplus
}
#endif

#endif
