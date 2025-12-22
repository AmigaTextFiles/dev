/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_RAMDRIVE_H
#define _PPCINLINE_RAMDRIVE_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef RAMDRIVE_BASE_NAME
#define RAMDRIVE_BASE_NAME RamdriveDevice
#endif /* !RAMDRIVE_BASE_NAME */

#define KillRAD(unit) \
	LP1(0x30, STRPTR, KillRAD, ULONG, unit, d0, \
	, RAMDRIVE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define KillRAD0() \
	LP0(0x2a, STRPTR, KillRAD0, \
	, RAMDRIVE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_RAMDRIVE_H */
