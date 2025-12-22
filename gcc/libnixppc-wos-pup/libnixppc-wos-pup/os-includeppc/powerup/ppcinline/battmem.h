/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_BATTMEM_H
#define _PPCINLINE_BATTMEM_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef BATTMEM_BASE_NAME
#define BATTMEM_BASE_NAME BattMemBase
#endif /* !BATTMEM_BASE_NAME */

#define ObtainBattSemaphore() \
	LP0NR(0x6, ObtainBattSemaphore, \
	, BATTMEM_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ReadBattMem(buffer, offset, length) \
	LP3(0x12, ULONG, ReadBattMem, APTR, buffer, a0, ULONG, offset, d0, ULONG, length, d1, \
	, BATTMEM_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ReleaseBattSemaphore() \
	LP0NR(0xc, ReleaseBattSemaphore, \
	, BATTMEM_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define WriteBattMem(buffer, offset, length) \
	LP3(0x18, ULONG, WriteBattMem, CONST APTR, buffer, a0, ULONG, offset, d0, ULONG, length, d1, \
	, BATTMEM_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_BATTMEM_H */
