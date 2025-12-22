#ifndef _INLINE_LOWLEVEL_H
#define _INLINE_LOWLEVEL_H

#ifndef CLIB_LOWLEVEL_PROTOS_H
#define CLIB_LOWLEVEL_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef  EXEC_INTERRUPTS_H
#include <exec/interrupts.h>
#endif
#ifndef  UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif
#ifndef  DEVICES_TIMER_H
#include <devices/timer.h>
#endif
#ifndef  LIBRARIES_LOWLEVEL_H
#include <libraries/lowlevel.h>
#endif

#ifndef LOWLEVEL_BASE_NAME
#define LOWLEVEL_BASE_NAME LowLevelBase
#endif

#define ReadJoyPort(port) \
	LP1(0x1e, ULONG, ReadJoyPort, ULONG, port, d0, \
	, LOWLEVEL_BASE_NAME)

#define GetLanguageSelection() \
	LP0(0x24, UBYTE, GetLanguageSelection, \
	, LOWLEVEL_BASE_NAME)

#define GetKey() \
	LP0(0x30, ULONG, GetKey, \
	, LOWLEVEL_BASE_NAME)

#define QueryKeys(queryArray, arraySize) \
	LP2NR(0x36, QueryKeys, struct KeyQuery *, queryArray, a0, ULONG, arraySize, d1, \
	, LOWLEVEL_BASE_NAME)

#define AddKBInt(intRoutine, intData) \
	LP2(0x3c, APTR, AddKBInt, const APTR, intRoutine, a0, const APTR, intData, a1, \
	, LOWLEVEL_BASE_NAME)

#define RemKBInt(intHandle) \
	LP1NR(0x42, RemKBInt, APTR, intHandle, a1, \
	, LOWLEVEL_BASE_NAME)

#define SystemControlA(tagList) \
	LP1(0x48, ULONG, SystemControlA, const struct TagItem *, tagList, a1, \
	, LOWLEVEL_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SystemControl(tags...) \
	({ULONG _tags[] = {tags}; SystemControlA((const struct TagItem *) _tags);})
#endif

#define AddTimerInt(intRoutine, intData) \
	LP2(0x4e, APTR, AddTimerInt, const APTR, intRoutine, a0, const APTR, intData, a1, \
	, LOWLEVEL_BASE_NAME)

#define RemTimerInt(intHandle) \
	LP1NR(0x54, RemTimerInt, APTR, intHandle, a1, \
	, LOWLEVEL_BASE_NAME)

#define StopTimerInt(intHandle) \
	LP1NR(0x5a, StopTimerInt, APTR, intHandle, a1, \
	, LOWLEVEL_BASE_NAME)

#define StartTimerInt(intHandle, timeInterval, continuous) \
	LP3NR(0x60, StartTimerInt, APTR, intHandle, a1, ULONG, timeInterval, d0, LONG, continuous, d1, \
	, LOWLEVEL_BASE_NAME)

#define ElapsedTime(context) \
	LP1(0x66, ULONG, ElapsedTime, struct EClockVal *, context, a0, \
	, LOWLEVEL_BASE_NAME)

#define AddVBlankInt(intRoutine, intData) \
	LP2(0x6c, APTR, AddVBlankInt, const APTR, intRoutine, a0, const APTR, intData, a1, \
	, LOWLEVEL_BASE_NAME)

#define RemVBlankInt(intHandle) \
	LP1NR(0x72, RemVBlankInt, APTR, intHandle, a1, \
	, LOWLEVEL_BASE_NAME)

#define SetJoyPortAttrsA(portNumber, tagList) \
	LP2(0x84, BOOL, SetJoyPortAttrsA, ULONG, portNumber, d0, const struct TagItem *, tagList, a1, \
	, LOWLEVEL_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetJoyPortAttrs(portNumber, tags...) \
	({ULONG _tags[] = {tags}; SetJoyPortAttrsA((portNumber), (const struct TagItem *) _tags);})
#endif

#endif /*  _INLINE_LOWLEVEL_H  */
