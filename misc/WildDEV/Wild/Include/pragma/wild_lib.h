#ifndef _INCLUDE_PRAGMA_WILD_LIB_H
#define _INCLUDE_PRAGMA_WILD_LIB_H

#ifndef CLIB_WILD_PROTOS_H
#include <clib/wild_protos.h>
#endif

#if defined(AZTEC_C) || defined(__MAXON__) || defined(__STORM__)
#pragma amicall(WildBase,0x01E,AddWildApp(a0,a1))
#pragma amicall(WildBase,0x024,RemWildApp(a0))
#pragma amicall(WildBase,0x02A,LoadModule(a0,a1))
#pragma amicall(WildBase,0x030,KillModule(a1))
#pragma amicall(WildBase,0x036,SetWildAppTags(a0,a1))
#pragma amicall(WildBase,0x03C,GetWildAppTags(a0,a1))
#pragma amicall(WildBase,0x042,AddWildThread(a0,a1))
#pragma amicall(WildBase,0x048,RemWildThread(a0))
#pragma amicall(WildBase,0x04E,AllocVecPooled(d0,a0))
#pragma amicall(WildBase,0x054,FreeVecPooled(a1))
#pragma amicall(WildBase,0x05A,RealyzeFrame(a0))
#pragma amicall(WildBase,0x060,InitFrame(a0))
#pragma amicall(WildBase,0x066,DisplayFrame(a0))
#pragma amicall(WildBase,0x06C,LoadTable(d0,a0))
#pragma amicall(WildBase,0x072,KillTable(a1))
#pragma amicall(WildBase,0x078,LoadFile(d0,d1,a0))
#pragma amicall(WildBase,0x07E,LoadExtension(a1,d0))
#pragma amicall(WildBase,0x084,KillExtension(a1))
#pragma amicall(WildBase,0x08A,FindWildApp(a0))
#pragma amicall(WildBase,0x090,BuildWildObject(a0))
#pragma amicall(WildBase,0x096,FreeWildObject(a0))
#pragma amicall(WildBase,0x09C,LoadWildObject(a0,a1))
#pragma amicall(WildBase,0x0A2,GetWildObjectChild(a0,d0,d1))
#pragma amicall(WildBase,0x0A8,SaveWildObject(a0,a1))
#pragma amicall(WildBase,0x0AE,DoAction(a0,a1))
#pragma amicall(WildBase,0x0B4,WildAnimate(a0,a1))
#pragma amicall(WildBase,0x0BA,AbortAction(a0))
#endif
#if defined(_DCC) || defined(__SASC)
#pragma  libcall WildBase AddWildApp           01E 9802
#pragma  libcall WildBase RemWildApp           024 801
#pragma  libcall WildBase LoadModule           02A 9802
#pragma  libcall WildBase KillModule           030 901
#pragma  libcall WildBase SetWildAppTags       036 9802
#pragma  libcall WildBase GetWildAppTags       03C 9802
#pragma  libcall WildBase AddWildThread        042 9802
#pragma  libcall WildBase RemWildThread        048 801
#pragma  libcall WildBase AllocVecPooled       04E 8002
#pragma  libcall WildBase FreeVecPooled        054 901
#pragma  libcall WildBase RealyzeFrame         05A 801
#pragma  libcall WildBase InitFrame            060 801
#pragma  libcall WildBase DisplayFrame         066 801
#pragma  libcall WildBase LoadTable            06C 8002
#pragma  libcall WildBase KillTable            072 901
#pragma  libcall WildBase LoadFile             078 81003
#pragma  libcall WildBase LoadExtension        07E 0902
#pragma  libcall WildBase KillExtension        084 901
#pragma  libcall WildBase FindWildApp          08A 801
#pragma  libcall WildBase BuildWildObject      090 801
#pragma  libcall WildBase FreeWildObject       096 801
#pragma  libcall WildBase LoadWildObject       09C 9802
#pragma  libcall WildBase GetWildObjectChild   0A2 10803
#pragma  libcall WildBase SaveWildObject       0A8 9802
#pragma  libcall WildBase DoAction             0AE 9802
#pragma  libcall WildBase WildAnimate          0B4 9802
#pragma  libcall WildBase AbortAction          0BA 801
#endif
#ifdef __STORM__
#pragma tagcall(WildBase,0x01E,AddWildAppTags(a0,a1))
#pragma tagcall(WildBase,0x036,SetWildAppTagsTags(a0,a1))
#pragma tagcall(WildBase,0x03C,GetWildAppTagsTags(a0,a1))
#pragma tagcall(WildBase,0x042,AddWildThreadTags(a0,a1))
#pragma tagcall(WildBase,0x08A,FindWildAppTags(a0))
#pragma tagcall(WildBase,0x090,BuildWildObjectTags(a0))
#pragma tagcall(WildBase,0x09C,LoadWildObjectTags(a0,a1))
#pragma tagcall(WildBase,0x0A8,SaveWildObjectTags(a0,a1))
#pragma tagcall(WildBase,0x0AE,DoActionTags(a0,a1))
#pragma tagcall(WildBase,0x0B4,WildAnimateTags(a0,a1))
#endif
#ifdef __SASC_60
#pragma  tagcall WildBase AddWildAppTags       01E 9802
#pragma  tagcall WildBase SetWildAppTagsTags   036 9802
#pragma  tagcall WildBase GetWildAppTagsTags   03C 9802
#pragma  tagcall WildBase AddWildThreadTags    042 9802
#pragma  tagcall WildBase FindWildAppTags      08A 801
#pragma  tagcall WildBase BuildWildObjectTags  090 801
#pragma  tagcall WildBase LoadWildObjectTags   09C 9802
#pragma  tagcall WildBase SaveWildObjectTags   0A8 9802
#pragma  tagcall WildBase DoActionTags         0AE 9802
#pragma  tagcall WildBase WildAnimateTags      0B4 9802
#endif

#endif	/*  _INCLUDE_PRAGMA_WILD_LIB_H  */
