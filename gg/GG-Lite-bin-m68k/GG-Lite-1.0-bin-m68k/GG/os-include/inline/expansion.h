#ifndef _INLINE_EXPANSION_H
#define _INLINE_EXPANSION_H

#ifndef CLIB_EXPANSION_PROTOS_H
#define CLIB_EXPANSION_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef  LIBRARIES_CONFIGVARS_H
#include <libraries/configvars.h>
#endif
#ifndef  DOS_FILEHANDLER_H
#include <dos/filehandler.h>
#endif

#ifndef EXPANSION_BASE_NAME
#define EXPANSION_BASE_NAME ExpansionBase
#endif

#define AddConfigDev(configDev) \
	LP1NR(0x1e, AddConfigDev, struct ConfigDev *, configDev, a0, \
	, EXPANSION_BASE_NAME)

#define AddBootNode(bootPri, flags, deviceNode, configDev) \
	LP4(0x24, BOOL, AddBootNode, LONG, bootPri, d0, ULONG, flags, d1, struct DeviceNode *, deviceNode, a0, struct ConfigDev *, configDev, a1, \
	, EXPANSION_BASE_NAME)

#define AllocBoardMem(slotSpec) \
	LP1NR(0x2a, AllocBoardMem, ULONG, slotSpec, d0, \
	, EXPANSION_BASE_NAME)

#define AllocConfigDev() \
	LP0(0x30, struct ConfigDev *, AllocConfigDev, \
	, EXPANSION_BASE_NAME)

#define AllocExpansionMem(numSlots, slotAlign) \
	LP2(0x36, APTR, AllocExpansionMem, ULONG, numSlots, d0, ULONG, slotAlign, d1, \
	, EXPANSION_BASE_NAME)

#define ConfigBoard(board, configDev) \
	LP2NR(0x3c, ConfigBoard, APTR, board, a0, struct ConfigDev *, configDev, a1, \
	, EXPANSION_BASE_NAME)

#define ConfigChain(baseAddr) \
	LP1NR(0x42, ConfigChain, APTR, baseAddr, a0, \
	, EXPANSION_BASE_NAME)

#define FindConfigDev(oldConfigDev, manufacturer, product) \
	LP3(0x48, struct ConfigDev *, FindConfigDev, const struct ConfigDev *, oldConfigDev, a0, LONG, manufacturer, d0, LONG, product, d1, \
	, EXPANSION_BASE_NAME)

#define FreeBoardMem(startSlot, slotSpec) \
	LP2NR(0x4e, FreeBoardMem, ULONG, startSlot, d0, ULONG, slotSpec, d1, \
	, EXPANSION_BASE_NAME)

#define FreeConfigDev(configDev) \
	LP1NR(0x54, FreeConfigDev, struct ConfigDev *, configDev, a0, \
	, EXPANSION_BASE_NAME)

#define FreeExpansionMem(startSlot, numSlots) \
	LP2NR(0x5a, FreeExpansionMem, ULONG, startSlot, d0, ULONG, numSlots, d1, \
	, EXPANSION_BASE_NAME)

#define ReadExpansionByte(board, offset) \
	LP2(0x60, UBYTE, ReadExpansionByte, const APTR, board, a0, ULONG, offset, d0, \
	, EXPANSION_BASE_NAME)

#define ReadExpansionRom(board, configDev) \
	LP2NR(0x66, ReadExpansionRom, const APTR, board, a0, struct ConfigDev *, configDev, a1, \
	, EXPANSION_BASE_NAME)

#define RemConfigDev(configDev) \
	LP1NR(0x6c, RemConfigDev, struct ConfigDev *, configDev, a0, \
	, EXPANSION_BASE_NAME)

#define WriteExpansionByte(board, offset, byte) \
	LP3NR(0x72, WriteExpansionByte, APTR, board, a0, ULONG, offset, d0, ULONG, byte, d1, \
	, EXPANSION_BASE_NAME)

#define ObtainConfigBinding() \
	LP0NR(0x78, ObtainConfigBinding, \
	, EXPANSION_BASE_NAME)

#define ReleaseConfigBinding() \
	LP0NR(0x7e, ReleaseConfigBinding, \
	, EXPANSION_BASE_NAME)

#define SetCurrentBinding(currentBinding, bindingSize) \
	LP2NR(0x84, SetCurrentBinding, struct CurrentBinding *, currentBinding, a0, ULONG, bindingSize, d0, \
	, EXPANSION_BASE_NAME)

#define GetCurrentBinding(currentBinding, bindingSize) \
	LP2(0x8a, ULONG, GetCurrentBinding, const struct CurrentBinding *, currentBinding, a0, ULONG, bindingSize, d0, \
	, EXPANSION_BASE_NAME)

#define MakeDosNode(parmPacket) \
	LP1(0x90, struct DeviceNode *, MakeDosNode, const APTR, parmPacket, a0, \
	, EXPANSION_BASE_NAME)

#define AddDosNode(bootPri, flags, deviceNode) \
	LP3(0x96, BOOL, AddDosNode, LONG, bootPri, d0, ULONG, flags, d1, struct DeviceNode *, deviceNode, a0, \
	, EXPANSION_BASE_NAME)

#endif /*  _INLINE_EXPANSION_H  */
