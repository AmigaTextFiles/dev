#ifndef _INCLUDE_PRAGMA_UTILITY_LIB_H
#define _INCLUDE_PRAGMA_UTILITY_LIB_H

#ifndef CLIB_UTILITY_PROTOS_H
#include <clib/utility_protos.h>
#endif

#if defined(AZTEC_C) || defined(__MAXON__) || defined(__STORM__)
#pragma amicall(UtilityBase,0x01e,FindTagItem(d0,a0))
#pragma amicall(UtilityBase,0x024,GetTagData(d0,d1,a0))
#pragma amicall(UtilityBase,0x02a,PackBoolTags(d0,a0,a1))
#pragma amicall(UtilityBase,0x030,NextTagItem(a0))
#pragma amicall(UtilityBase,0x036,FilterTagChanges(a0,a1,d0))
#pragma amicall(UtilityBase,0x03c,MapTags(a0,a1,d0))
#pragma amicall(UtilityBase,0x042,AllocateTagItems(d0))
#pragma amicall(UtilityBase,0x048,CloneTagItems(a0))
#pragma amicall(UtilityBase,0x04e,FreeTagItems(a0))
#pragma amicall(UtilityBase,0x054,RefreshTagItemClones(a0,a1))
#pragma amicall(UtilityBase,0x05a,TagInArray(d0,a0))
#pragma amicall(UtilityBase,0x060,FilterTagItems(a0,a1,d0))
#pragma amicall(UtilityBase,0x066,CallHookPkt(a0,a2,a1))
#pragma amicall(UtilityBase,0x078,Amiga2Date(d0,a0))
#pragma amicall(UtilityBase,0x07e,Date2Amiga(a0))
#pragma amicall(UtilityBase,0x084,CheckDate(a0))
#pragma amicall(UtilityBase,0x08a,SMult32(d0,d1))
#pragma amicall(UtilityBase,0x090,UMult32(d0,d1))
#pragma amicall(UtilityBase,0x096,SDivMod32(d0,d1))
#pragma amicall(UtilityBase,0x09c,UDivMod32(d0,d1))
#pragma amicall(UtilityBase,0x0a2,Stricmp(a0,a1))
#pragma amicall(UtilityBase,0x0a8,Strnicmp(a0,a1,d0))
#pragma amicall(UtilityBase,0x0ae,ToUpper(d0))
#pragma amicall(UtilityBase,0x0b4,ToLower(d0))
#pragma amicall(UtilityBase,0x0ba,ApplyTagChanges(a0,a1))
#pragma amicall(UtilityBase,0x0c6,SMult64(d0,d1))
#pragma amicall(UtilityBase,0x0cc,UMult64(d0,d1))
#pragma amicall(UtilityBase,0x0d2,PackStructureTags(a0,a1,a2))
#pragma amicall(UtilityBase,0x0d8,UnpackStructureTags(a0,a1,a2))
#pragma amicall(UtilityBase,0x0de,AddNamedObject(a0,a1))
#pragma amicall(UtilityBase,0x0e4,AllocNamedObjectA(a0,a1))
#pragma amicall(UtilityBase,0x0ea,AttemptRemNamedObject(a0))
#pragma amicall(UtilityBase,0x0f0,FindNamedObject(a0,a1,a2))
#pragma amicall(UtilityBase,0x0f6,FreeNamedObject(a0))
#pragma amicall(UtilityBase,0x0fc,NamedObjectName(a0))
#pragma amicall(UtilityBase,0x102,ReleaseNamedObject(a0))
#pragma amicall(UtilityBase,0x108,RemNamedObject(a0,a1))
#pragma amicall(UtilityBase,0x10e,GetUniqueID())
#endif
#if defined(_DCC) || defined(__SASC)
#pragma  libcall UtilityBase FindTagItem            01e 8002
#pragma  libcall UtilityBase GetTagData             024 81003
#pragma  libcall UtilityBase PackBoolTags           02a 98003
#pragma  libcall UtilityBase NextTagItem            030 801
#pragma  libcall UtilityBase FilterTagChanges       036 09803
#pragma  libcall UtilityBase MapTags                03c 09803
#pragma  libcall UtilityBase AllocateTagItems       042 001
#pragma  libcall UtilityBase CloneTagItems          048 801
#pragma  libcall UtilityBase FreeTagItems           04e 801
#pragma  libcall UtilityBase RefreshTagItemClones   054 9802
#pragma  libcall UtilityBase TagInArray             05a 8002
#pragma  libcall UtilityBase FilterTagItems         060 09803
#pragma  libcall UtilityBase CallHookPkt            066 9a803
#pragma  libcall UtilityBase Amiga2Date             078 8002
#pragma  libcall UtilityBase Date2Amiga             07e 801
#pragma  libcall UtilityBase CheckDate              084 801
#pragma  libcall UtilityBase SMult32                08a 1002
#pragma  libcall UtilityBase UMult32                090 1002
#pragma  libcall UtilityBase SDivMod32              096 1002
#pragma  libcall UtilityBase UDivMod32              09c 1002
#pragma  libcall UtilityBase Stricmp                0a2 9802
#pragma  libcall UtilityBase Strnicmp               0a8 09803
#pragma  libcall UtilityBase ToUpper                0ae 001
#pragma  libcall UtilityBase ToLower                0b4 001
#pragma  libcall UtilityBase ApplyTagChanges        0ba 9802
#pragma  libcall UtilityBase SMult64                0c6 1002
#pragma  libcall UtilityBase UMult64                0cc 1002
#pragma  libcall UtilityBase PackStructureTags      0d2 a9803
#pragma  libcall UtilityBase UnpackStructureTags    0d8 a9803
#pragma  libcall UtilityBase AddNamedObject         0de 9802
#pragma  libcall UtilityBase AllocNamedObjectA      0e4 9802
#pragma  libcall UtilityBase AttemptRemNamedObject  0ea 801
#pragma  libcall UtilityBase FindNamedObject        0f0 a9803
#pragma  libcall UtilityBase FreeNamedObject        0f6 801
#pragma  libcall UtilityBase NamedObjectName        0fc 801
#pragma  libcall UtilityBase ReleaseNamedObject     102 801
#pragma  libcall UtilityBase RemNamedObject         108 9802
#pragma  libcall UtilityBase GetUniqueID            10e 00
#endif
#ifdef __STORM__
#pragma tagcall(UtilityBase,0x0e4,AllocNamedObject(a0,a1))
#endif
#ifdef __SASC_60
#pragma  tagcall UtilityBase AllocNamedObject       0e4 9802
#endif

#endif	/*  _INCLUDE_PRAGMA_UTILITY_LIB_H  */
