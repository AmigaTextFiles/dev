#ifndef _INLINE_NONVOLATILE_H
#define _INLINE_NONVOLATILE_H

#ifndef CLIB_NONVOLATILE_PROTOS_H
#define CLIB_NONVOLATILE_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef  EXEC_LISTS_H
#include <exec/lists.h>
#endif
#ifndef  LIBRARIES_NONVOLATILE_H
#include <libraries/nonvolatile.h>
#endif

#ifndef NONVOLATILE_BASE_NAME
#define NONVOLATILE_BASE_NAME NVBase
#endif

#define GetCopyNV(appName, itemName, killRequesters) \
	LP3(0x1e, APTR, GetCopyNV, CONST_STRPTR, appName, a0, CONST_STRPTR, itemName, a1, LONG, killRequesters, d1, \
	, NONVOLATILE_BASE_NAME)

#define FreeNVData(data) \
	LP1NR(0x24, FreeNVData, APTR, data, a0, \
	, NONVOLATILE_BASE_NAME)

#define StoreNV(appName, itemName, data, length, killRequesters) \
	LP5(0x2a, UWORD, StoreNV, CONST_STRPTR, appName, a0, CONST_STRPTR, itemName, a1, const APTR, data, a2, ULONG, length, d0, LONG, killRequesters, d1, \
	, NONVOLATILE_BASE_NAME)

#define DeleteNV(appName, itemName, killRequesters) \
	LP3(0x30, BOOL, DeleteNV, CONST_STRPTR, appName, a0, CONST_STRPTR, itemName, a1, LONG, killRequesters, d1, \
	, NONVOLATILE_BASE_NAME)

#define GetNVInfo(killRequesters) \
	LP1(0x36, struct NVInfo *, GetNVInfo, LONG, killRequesters, d1, \
	, NONVOLATILE_BASE_NAME)

#define GetNVList(appName, killRequesters) \
	LP2(0x3c, struct MinList *, GetNVList, CONST_STRPTR, appName, a0, LONG, killRequesters, d1, \
	, NONVOLATILE_BASE_NAME)

#define SetNVProtection(appName, itemName, mask, killRequesters) \
	LP4(0x42, BOOL, SetNVProtection, CONST_STRPTR, appName, a0, CONST_STRPTR, itemName, a1, LONG, mask, d2, LONG, killRequesters, d1, \
	, NONVOLATILE_BASE_NAME)

#endif /*  _INLINE_NONVOLATILE_H  */
