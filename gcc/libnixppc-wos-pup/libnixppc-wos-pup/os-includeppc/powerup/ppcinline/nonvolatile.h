/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_NONVOLATILE_H
#define _PPCINLINE_NONVOLATILE_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef NONVOLATILE_BASE_NAME
#define NONVOLATILE_BASE_NAME NVBase
#endif /* !NONVOLATILE_BASE_NAME */

#define DeleteNV(appName, itemName, killRequesters) \
	LP3(0x30, BOOL, DeleteNV, CONST_STRPTR, appName, a0, CONST_STRPTR, itemName, a1, LONG, killRequesters, d1, \
	, NONVOLATILE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define FreeNVData(data) \
	LP1NR(0x24, FreeNVData, APTR, data, a0, \
	, NONVOLATILE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define GetCopyNV(appName, itemName, killRequesters) \
	LP3(0x1e, APTR, GetCopyNV, CONST_STRPTR, appName, a0, CONST_STRPTR, itemName, a1, LONG, killRequesters, d1, \
	, NONVOLATILE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define GetNVInfo(killRequesters) \
	LP1(0x36, struct NVInfo *, GetNVInfo, LONG, killRequesters, d1, \
	, NONVOLATILE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define GetNVList(appName, killRequesters) \
	LP2(0x3c, struct MinList *, GetNVList, CONST_STRPTR, appName, a0, LONG, killRequesters, d1, \
	, NONVOLATILE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SetNVProtection(appName, itemName, mask, killRequesters) \
	LP4(0x42, BOOL, SetNVProtection, CONST_STRPTR, appName, a0, CONST_STRPTR, itemName, a1, LONG, mask, d2, LONG, killRequesters, d1, \
	, NONVOLATILE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define StoreNV(appName, itemName, data, length, killRequesters) \
	LP5(0x2a, UWORD, StoreNV, CONST_STRPTR, appName, a0, CONST_STRPTR, itemName, a1, CONST APTR, data, a2, ULONG, length, d0, LONG, killRequesters, d1, \
	, NONVOLATILE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_NONVOLATILE_H */
