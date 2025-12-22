/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_CARDRES_H
#define _PPCINLINE_CARDRES_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef CARDRES_BASE_NAME
#define CARDRES_BASE_NAME CardResource
#endif /* !CARDRES_BASE_NAME */

#define BeginCardAccess(handle) \
	LP1(0x18, BOOL, BeginCardAccess, struct CardHandle *, handle, a1, \
	, CARDRES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define CardAccessSpeed(handle, nanoseconds) \
	LP2(0x36, ULONG, CardAccessSpeed, struct CardHandle *, handle, a1, ULONG, nanoseconds, d0, \
	, CARDRES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define CardChangeCount() \
	LP0(0x60, ULONG, CardChangeCount, \
	, CARDRES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define CardForceChange() \
	LP0(0x5a, BOOL, CardForceChange, \
	, CARDRES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define CardInterface() \
	LP0(0x66, ULONG, CardInterface, \
	, CARDRES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define CardMiscControl(handle, control_bits) \
	LP2(0x30, UBYTE, CardMiscControl, struct CardHandle *, handle, a1, ULONG, control_bits, d1, \
	, CARDRES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define CardProgramVoltage(handle, voltage) \
	LP2(0x3c, LONG, CardProgramVoltage, struct CardHandle *, handle, a1, ULONG, voltage, d0, \
	, CARDRES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define CardResetCard(handle) \
	LP1(0x42, BOOL, CardResetCard, struct CardHandle *, handle, a1, \
	, CARDRES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define CardResetRemove(handle, flag) \
	LP2(0x2a, BOOL, CardResetRemove, struct CardHandle *, handle, a1, ULONG, flag, d0, \
	, CARDRES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define CopyTuple(handle, buffer, tuplecode, size) \
	LP4(0x48, BOOL, CopyTuple, CONST struct CardHandle *, handle, a1, UBYTE *, buffer, a0, ULONG, tuplecode, d1, ULONG, size, d0, \
	, CARDRES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define DeviceTuple(tuple_data, storage) \
	LP2(0x4e, ULONG, DeviceTuple, CONST UBYTE *, tuple_data, a0, struct DeviceTData *, storage, a1, \
	, CARDRES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define EndCardAccess(handle) \
	LP1(0x1e, BOOL, EndCardAccess, struct CardHandle *, handle, a1, \
	, CARDRES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define GetCardMap() \
	LP0(0x12, struct CardMemoryMap *, GetCardMap, \
	, CARDRES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define IfAmigaXIP(handle) \
	LP1(0x54, struct Resident *, IfAmigaXIP, CONST struct CardHandle *, handle, a2, \
	, CARDRES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define OwnCard(handle) \
	LP1(0x6, struct CardHandle *, OwnCard, struct CardHandle *, handle, a1, \
	, CARDRES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ReadCardStatus() \
	LP0(0x24, UBYTE, ReadCardStatus, \
	, CARDRES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ReleaseCard(handle, flags) \
	LP2NR(0xc, ReleaseCard, struct CardHandle *, handle, a1, ULONG, flags, d0, \
	, CARDRES_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_CARDRES_H */
