/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_DISK_H
#define _PPCINLINE_DISK_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef DISK_BASE_NAME
#define DISK_BASE_NAME DiskBase
#endif /* !DISK_BASE_NAME */

#define AllocUnit(unitNum) \
	LP1(0x6, BOOL, AllocUnit, LONG, unitNum, d0, \
	, DISK_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define FreeUnit(unitNum) \
	LP1NR(0xc, FreeUnit, LONG, unitNum, d0, \
	, DISK_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define GetUnit(unitPointer) \
	LP1(0x12, struct DiskResourceUnit *, GetUnit, struct DiskResourceUnit *, unitPointer, a1, \
	, DISK_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define GetUnitID(unitNum) \
	LP1(0x1e, LONG, GetUnitID, LONG, unitNum, d0, \
	, DISK_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define GiveUnit() \
	LP0NR(0x18, GiveUnit, \
	, DISK_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ReadUnitID(unitNum) \
	LP1(0x24, LONG, ReadUnitID, LONG, unitNum, d0, \
	, DISK_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_DISK_H */
