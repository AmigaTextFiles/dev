/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_MISC_H
#define _PPCINLINE_MISC_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef MISC_BASE_NAME
#define MISC_BASE_NAME MiscBase
#endif /* !MISC_BASE_NAME */

#define AllocMiscResource(unitNum, name) \
	LP2(0x6, UBYTE *, AllocMiscResource, ULONG, unitNum, d0, CONST_STRPTR, name, a1, \
	, MISC_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define FreeMiscResource(unitNum) \
	LP1NR(0xc, FreeMiscResource, ULONG, unitNum, d0, \
	, MISC_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_MISC_H */
