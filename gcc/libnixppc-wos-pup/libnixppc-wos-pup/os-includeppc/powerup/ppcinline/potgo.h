/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_POTGO_H
#define _PPCINLINE_POTGO_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef POTGO_BASE_NAME
#define POTGO_BASE_NAME PotgoBase
#endif /* !POTGO_BASE_NAME */

#define AllocPotBits(bits) \
	LP1(0x6, UWORD, AllocPotBits, ULONG, bits, d0, \
	, POTGO_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define FreePotBits(bits) \
	LP1NR(0xc, FreePotBits, ULONG, bits, d0, \
	, POTGO_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define WritePotgo(word, mask) \
	LP2NR(0x12, WritePotgo, ULONG, word, d0, ULONG, mask, d1, \
	, POTGO_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_POTGO_H */
