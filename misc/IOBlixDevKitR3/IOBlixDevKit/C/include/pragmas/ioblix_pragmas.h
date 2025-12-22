#ifndef _INCLUDE_PRAGMA_IOBLIX_LIB_H
#define _INCLUDE_PRAGMA_IOBLIX_LIB_H

#ifndef CLIB_IOBLIX_PROTOS_H
#include <clib/ioblix_protos.h>
#endif

#if defined(AZTEC_C) || defined(__MAXON__) || defined(__STORM__)
#pragma amicall(IOBlixBase,0x006,ObtainChip(d0,d1,a0,a1))
#pragma amicall(IOBlixBase,0x00C,ReleaseChip(a0))
#pragma amicall(IOBlixBase,0x012,FindChip(d0,d1))
#pragma amicall(IOBlixBase,0x018,AllocChipList())
#pragma amicall(IOBlixBase,0x01E,FreeChipList(a0))
#pragma amicall(IOBlixBase,0x024,AddIRQHook(a0))
#pragma amicall(IOBlixBase,0x02A,RemIRQHook(a0))
#pragma amicall(IOBlixBase,0x030,ObtainChipShared(d0,d1,a0,a1))
#pragma amicall(IOBlixBase,0x036,ReleaseChipShared(a0,a1))
#endif
#if defined(_DCC) || defined(__SASC)
#pragma  libcall IOBlixBase ObtainChip           006 981004
#pragma  libcall IOBlixBase ReleaseChip          00C 801
#pragma  libcall IOBlixBase FindChip             012 1002
#pragma  libcall IOBlixBase AllocChipList        018 00
#pragma  libcall IOBlixBase FreeChipList         01E 801
#pragma  libcall IOBlixBase AddIRQHook           024 801
#pragma  libcall IOBlixBase RemIRQHook           02A 801
#pragma  libcall IOBlixBase ObtainChipShared     030 981004
#pragma  libcall IOBlixBase ReleaseChipShared    036 9802
#endif

#endif	/*  _INCLUDE_PRAGMA_IOBLIX_LIB_H  */
