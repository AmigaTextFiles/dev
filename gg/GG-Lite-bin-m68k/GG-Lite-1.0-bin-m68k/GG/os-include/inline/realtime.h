#ifndef _INLINE_REALTIME_H
#define _INLINE_REALTIME_H

#ifndef CLIB_REALTIME_PROTOS_H
#define CLIB_REALTIME_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef  LIBRARIES_REALTIME_H
#include <libraries/realtime.h>
#endif
#ifndef  UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

#ifndef REALTIME_BASE_NAME
#define REALTIME_BASE_NAME RealTimeBase
#endif

#define LockRealTime(lockType) \
	LP1(0x1e, APTR, LockRealTime, ULONG, lockType, d0, \
	, REALTIME_BASE_NAME)

#define UnlockRealTime(lock) \
	LP1NR(0x24, UnlockRealTime, APTR, lock, a0, \
	, REALTIME_BASE_NAME)

#define CreatePlayerA(tagList) \
	LP1(0x2a, struct Player *, CreatePlayerA, const struct TagItem *, tagList, a0, \
	, REALTIME_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define CreatePlayer(tags...) \
	({ULONG _tags[] = {tags}; CreatePlayerA((const struct TagItem *) _tags);})
#endif

#define DeletePlayer(player) \
	LP1NR(0x30, DeletePlayer, struct Player *, player, a0, \
	, REALTIME_BASE_NAME)

#define SetPlayerAttrsA(player, tagList) \
	LP2(0x36, BOOL, SetPlayerAttrsA, struct Player *, player, a0, const struct TagItem *, tagList, a1, \
	, REALTIME_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetPlayerAttrs(player, tags...) \
	({ULONG _tags[] = {tags}; SetPlayerAttrsA((player), (const struct TagItem *) _tags);})
#endif

#define SetConductorState(player, state, time) \
	LP3(0x3c, LONG, SetConductorState, struct Player *, player, a0, ULONG, state, d0, LONG, time, d1, \
	, REALTIME_BASE_NAME)

#define ExternalSync(player, minTime, maxTime) \
	LP3(0x42, BOOL, ExternalSync, struct Player *, player, a0, LONG, minTime, d0, LONG, maxTime, d1, \
	, REALTIME_BASE_NAME)

#define NextConductor(previousConductor) \
	LP1(0x48, struct Conductor *, NextConductor, const struct Conductor *, previousConductor, a0, \
	, REALTIME_BASE_NAME)

#define FindConductor(name) \
	LP1(0x4e, struct Conductor *, FindConductor, CONST_STRPTR, name, a0, \
	, REALTIME_BASE_NAME)

#define GetPlayerAttrsA(player, tagList) \
	LP2(0x54, ULONG, GetPlayerAttrsA, const struct Player *, player, a0, const struct TagItem *, tagList, a1, \
	, REALTIME_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define GetPlayerAttrs(player, tags...) \
	({ULONG _tags[] = {tags}; GetPlayerAttrsA((player), (const struct TagItem *) _tags);})
#endif

#endif /*  _INLINE_REALTIME_H  */
