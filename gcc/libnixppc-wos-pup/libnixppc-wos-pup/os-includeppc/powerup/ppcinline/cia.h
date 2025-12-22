/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_CIA_H
#define _PPCINLINE_CIA_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#define AbleICR(resource, mask) \
	LP2UB(0x12, WORD, AbleICR, struct Library *, resource, a6, LONG, mask, d0, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define AddICRVector(resource, iCRBit, interrupt) \
	LP3UB(0x6, struct Interrupt *, AddICRVector, struct Library *, resource, a6, LONG, iCRBit, d0, struct Interrupt *, interrupt, a1, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define RemICRVector(resource, iCRBit, interrupt) \
	LP3NRUB(0xc, RemICRVector, struct Library *, resource, a6, LONG, iCRBit, d0, struct Interrupt *, interrupt, a1, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SetICR(resource, mask) \
	LP2UB(0x18, WORD, SetICR, struct Library *, resource, a6, LONG, mask, d0, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_CIA_H */
