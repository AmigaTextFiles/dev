#ifndef _INLINE_RAMDRIVE_H
#define _INLINE_RAMDRIVE_H

#ifndef CLIB_RAMDRIVE_PROTOS_H
#define CLIB_RAMDRIVE_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef RAMDRIVE_BASE_NAME
#define RAMDRIVE_BASE_NAME RamdriveDevice
#endif

#define KillRAD0() \
	LP0(0x2a, STRPTR, KillRAD0, \
	, RAMDRIVE_BASE_NAME)

#define KillRAD(unit) \
	LP1(0x30, STRPTR, KillRAD, ULONG, unit, d0, \
	, RAMDRIVE_BASE_NAME)

#endif /*  _INLINE_RAMDRIVE_H  */
