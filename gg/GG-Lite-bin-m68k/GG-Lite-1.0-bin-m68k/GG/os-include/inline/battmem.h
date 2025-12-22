#ifndef _INLINE_BATTMEM_H
#define _INLINE_BATTMEM_H

#ifndef CLIB_BATTMEM_PROTOS_H
#define CLIB_BATTMEM_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef BATTMEM_BASE_NAME
#define BATTMEM_BASE_NAME BattMemBase
#endif

#define ObtainBattSemaphore() \
	LP0NR(0x6, ObtainBattSemaphore, \
	, BATTMEM_BASE_NAME)

#define ReleaseBattSemaphore() \
	LP0NR(0xc, ReleaseBattSemaphore, \
	, BATTMEM_BASE_NAME)

#define ReadBattMem(buffer, offset, length) \
	LP3(0x12, ULONG, ReadBattMem, APTR, buffer, a0, ULONG, offset, d0, ULONG, length, d1, \
	, BATTMEM_BASE_NAME)

#define WriteBattMem(buffer, offset, length) \
	LP3(0x18, ULONG, WriteBattMem, const APTR, buffer, a0, ULONG, offset, d0, ULONG, length, d1, \
	, BATTMEM_BASE_NAME)

#endif /*  _INLINE_BATTMEM_H  */
