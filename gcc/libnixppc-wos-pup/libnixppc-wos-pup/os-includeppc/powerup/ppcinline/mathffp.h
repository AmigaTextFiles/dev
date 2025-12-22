/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_MATHFFP_H
#define _PPCINLINE_MATHFFP_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef MATHFFP_BASE_NAME
#define MATHFFP_BASE_NAME MathBase
#endif /* !MATHFFP_BASE_NAME */

#define SPAbs(parm) \
	LP1(0x36, FLOAT, SPAbs, FLOAT, parm, d0, \
	, MATHFFP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SPAdd(leftParm, rightParm) \
	LP2(0x42, FLOAT, SPAdd, FLOAT, leftParm, d1, FLOAT, rightParm, d0, \
	, MATHFFP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SPCeil(parm) \
	LP1(0x60, FLOAT, SPCeil, FLOAT, parm, d0, \
	, MATHFFP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SPCmp(leftParm, rightParm) \
	LP2(0x2a, LONG, SPCmp, FLOAT, leftParm, d1, FLOAT, rightParm, d0, \
	, MATHFFP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SPDiv(leftParm, rightParm) \
	LP2(0x54, FLOAT, SPDiv, FLOAT, leftParm, d1, FLOAT, rightParm, d0, \
	, MATHFFP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SPFix(parm) \
	LP1(0x1e, LONG, SPFix, FLOAT, parm, d0, \
	, MATHFFP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SPFloor(parm) \
	LP1(0x5a, FLOAT, SPFloor, FLOAT, parm, d0, \
	, MATHFFP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SPFlt(integer) \
	LP1(0x24, FLOAT, SPFlt, LONG, integer, d0, \
	, MATHFFP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SPMul(leftParm, rightParm) \
	LP2(0x4e, FLOAT, SPMul, FLOAT, leftParm, d1, FLOAT, rightParm, d0, \
	, MATHFFP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SPNeg(parm) \
	LP1(0x3c, FLOAT, SPNeg, FLOAT, parm, d0, \
	, MATHFFP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SPSub(leftParm, rightParm) \
	LP2(0x48, FLOAT, SPSub, FLOAT, leftParm, d1, FLOAT, rightParm, d0, \
	, MATHFFP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SPTst(parm) \
	LP1(0x30, LONG, SPTst, FLOAT, parm, d1, \
	, MATHFFP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_MATHFFP_H */
