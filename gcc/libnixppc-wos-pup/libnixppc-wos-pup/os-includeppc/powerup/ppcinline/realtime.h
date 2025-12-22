/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_REALTIME_H
#define _PPCINLINE_REALTIME_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef REALTIME_BASE_NAME
#define REALTIME_BASE_NAME RealTimeBase
#endif /* !REALTIME_BASE_NAME */

#define CreatePlayerA(tagList) \
	LP1(0x2a, struct Player *, CreatePlayerA, CONST struct TagItem *, tagList, a0, \
	, REALTIME_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define DeletePlayer(player) \
	LP1NR(0x30, DeletePlayer, struct Player *, player, a0, \
	, REALTIME_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ExternalSync(player, minTime, maxTime) \
	LP3(0x42, BOOL, ExternalSync, struct Player *, player, a0, LONG, minTime, d0, LONG, maxTime, d1, \
	, REALTIME_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define FindConductor(name) \
	LP1(0x4e, struct Conductor *, FindConductor, CONST_STRPTR, name, a0, \
	, REALTIME_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define GetPlayerAttrsA(player, tagList) \
	LP2(0x54, ULONG, GetPlayerAttrsA, CONST struct Player *, player, a0, CONST struct TagItem *, tagList, a1, \
	, REALTIME_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define LockRealTime(lockType) \
	LP1(0x1e, APTR, LockRealTime, ULONG, lockType, d0, \
	, REALTIME_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define NextConductor(previousConductor) \
	LP1(0x48, struct Conductor *, NextConductor, CONST struct Conductor *, previousConductor, a0, \
	, REALTIME_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SetConductorState(player, state, time) \
	LP3(0x3c, LONG, SetConductorState, struct Player *, player, a0, ULONG, state, d0, LONG, time, d1, \
	, REALTIME_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SetPlayerAttrsA(player, tagList) \
	LP2(0x36, BOOL, SetPlayerAttrsA, struct Player *, player, a0, CONST struct TagItem *, tagList, a1, \
	, REALTIME_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define UnlockRealTime(lock) \
	LP1NR(0x24, UnlockRealTime, APTR, lock, a0, \
	, REALTIME_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_REALTIME_H */
