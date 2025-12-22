#ifndef _INCLUDE_PRAGMA_DPKERNEL_LIB_H
#define _INCLUDE_PRAGMA_DPKERNEL_LIB_H

#ifndef CLIB_DPKERNEL_PROTOS_H
#include <clib/dpkernel_protos.h>
#endif

#if defined(AZTEC_C) || defined(__MAXON__) || defined(__STORM__)
#pragma amicall(DPKBase,0x01E,Deactivate(a0))
#pragma amicall(DPKBase,0x024,Query(a0))
#pragma amicall(DPKBase,0x02A,CheckExclusive(a0))
#pragma amicall(DPKBase,0x030,CloseDPK())
#pragma amicall(DPKBase,0x036,TagInit(a0,a1))
#pragma amicall(DPKBase,0x03C,FindDPKTask())
#pragma amicall(DPKBase,0x042,DPKForbid())
#pragma amicall(DPKBase,0x048,DPKPermit())
#pragma amicall(DPKBase,0x04E,SearchForTask(a0,a1))
#pragma amicall(DPKBase,0x054,OpenModule(d0,a0))
#pragma amicall(DPKBase,0x05A,Init(a0,a1))
#pragma amicall(DPKBase,0x060,Draw(a0))
#pragma amicall(DPKBase,0x066,GetMemType(a0))
#pragma amicall(DPKBase,0x06C,GetMemSize(a0))
#pragma amicall(DPKBase,0x072,FindField(a0,d0,a1))
#pragma amicall(DPKBase,0x078,Unhook(a0,a1))
#pragma amicall(DPKBase,0x07E,CallEventList(d0,a0,d1))
#pragma amicall(DPKBase,0x084,MoveToFront(a0))
#pragma amicall(DPKBase,0x08A,GetField(a0,d0))
#pragma amicall(DPKBase,0x090,WaitTime(d0))
#pragma amicall(DPKBase,0x096,FastRandom(d1))
#pragma amicall(DPKBase,0x09C,SlowRandom(d1))
#pragma amicall(DPKBase,0x0A2,CheckLock(a0))
#pragma amicall(DPKBase,0x0A8,Seek(a0,d0,d1))
#pragma amicall(DPKBase,0x0AE,Lock(a0))
#pragma amicall(DPKBase,0x0B4,Unlock(a0))
#pragma amicall(DPKBase,0x0BA,AddSysEvent(a0))
#pragma amicall(DPKBase,0x0C0,RemSysEvent(a0))
#pragma amicall(DPKBase,0x0C6,AllocMemBlock(d0,d1))
#pragma amicall(DPKBase,0x0CC,FreeMemBlock(d0))
#pragma amicall(DPKBase,0x0D2,CleanSystem(d0))
#pragma amicall(DPKBase,0x0D8,empty01())
#pragma amicall(DPKBase,0x0DE,Detach(a0,a1))
#pragma amicall(DPKBase,0x0E4,Read(a0,a1,d0))
#pragma amicall(DPKBase,0x0EA,Write(a0,a1,d0))
#pragma amicall(DPKBase,0x0F0,Activate(a0))
#pragma amicall(DPKBase,0x0F6,Clear(a0))
#pragma amicall(DPKBase,0x0FC,SaveToFile(a0,a1,a2))
#pragma amicall(DPKBase,0x102,Reset(a0))
#pragma amicall(DPKBase,0x108,Flush(a0))
#pragma tagcall(DPKBase,0x10E,DPrintF(a4,a5))
#pragma amicall(DPKBase,0x114,Show(a0))
#pragma amicall(DPKBase,0x11A,Load(a0,d0))
#pragma amicall(DPKBase,0x120,FindSysObject(d0,a0))
#pragma amicall(DPKBase,0x126,Hide(a0))
#pragma amicall(DPKBase,0x12C,InitDestruct(a0,a1))
#pragma amicall(DPKBase,0x132,SelfDestruct())
#pragma amicall(DPKBase,0x138,Armageddon(d0))
#pragma amicall(DPKBase,0x13E,FingerOfDeath(d0))
#pragma amicall(DPKBase,0x144,TotalMem(a0,d0))
#pragma amicall(DPKBase,0x14A,Get(d0))
#pragma amicall(DPKBase,0x150,Free(a0))
#pragma amicall(DPKBase,0x156,AddSysObject(d0,d1,a1,a0))
#pragma amicall(DPKBase,0x15C,RemSysObject(d0))
#pragma amicall(DPKBase,0x162,Awaken(a0))
#pragma amicall(DPKBase,0x168,CopyStructure(a0,a1))
#pragma amicall(DPKBase,0x16E,AutoStop())
#pragma amicall(DPKBase,0x174,MoveToBack(a0))
#pragma amicall(DPKBase,0x17A,Exclusive(a0))
#pragma amicall(DPKBase,0x180,ErrCode(d0))
#pragma amicall(DPKBase,0x186,StepBack())
#pragma amicall(DPKBase,0x18C,GetExtension(a0))
#pragma amicall(DPKBase,0x192,GetFileType(a0))
#pragma amicall(DPKBase,0x198,GetTypeList(d0))
#pragma amicall(DPKBase,0x19E,Copy(a0,a1))
#pragma amicall(DPKBase,0x1A4,AttemptExclusive(a0,d0))
#pragma amicall(DPKBase,0x1AA,FreeExclusive(a0))
#pragma amicall(DPKBase,0x1B0,CheckInit(a0))
#pragma amicall(DPKBase,0x1B6,LoadPrefs(a0,a1))
#pragma amicall(DPKBase,0x1BC,CheckAction(a0,a1))
#pragma amicall(DPKBase,0x1C2,Rename(a0,a1))
#pragma amicall(DPKBase,0x1C8,Realloc(a0,d0))
#pragma amicall(DPKBase,0x1CE,AllocObjectID())
#pragma amicall(DPKBase,0x1D4,FindReference(d0,a0))
#pragma amicall(DPKBase,0x1DA,FindSysName(a0,a1))
#pragma amicall(DPKBase,0x1E0,GetByName(a0))
#pragma amicall(DPKBase,0x1E6,GetFieldName(a0,a1))
#pragma amicall(DPKBase,0x1EC,CloneMemBlock(a0,d0))
#pragma amicall(DPKBase,0x1F2,SetField(a0,d0,d1))
#pragma amicall(DPKBase,0x1F8,SetFieldName(a0,a1,d0))
#pragma amicall(DPKBase,0x1FE,DebugOff())
#pragma amicall(DPKBase,0x204,DebugOn())
#pragma amicall(DPKBase,0x20A,GetContainer(a0))
#pragma amicall(DPKBase,0x210,AddResource(a0,d0,a1))
#pragma amicall(DPKBase,0x216,FreeResource(a0,a1))
#pragma amicall(DPKBase,0x21C,Idle(a0))
#pragma amicall(DPKBase,0x222,empty02())
#pragma amicall(DPKBase,0x228,empty03())
#pragma amicall(DPKBase,0x22E,SetContext(a0))
#endif
#if defined(_DCC) || defined(__SASC)
#pragma libcall DPKBase Deactivate           01E 801
#pragma libcall DPKBase Query                024 801
#pragma libcall DPKBase CheckExclusive       02A 801
#pragma libcall DPKBase CloseDPK             030 00
#pragma libcall DPKBase TagInit              036 9802
#pragma libcall DPKBase FindDPKTask          03C 00
#pragma libcall DPKBase DPKForbid            042 00
#pragma libcall DPKBase DPKPermit            048 00
#pragma libcall DPKBase SearchForTask        04E 9802
#pragma libcall DPKBase OpenModule           054 8002
#pragma libcall DPKBase Init                 05A 9802
#pragma libcall DPKBase Draw                 060 801
#pragma libcall DPKBase GetMemType           066 801
#pragma libcall DPKBase GetMemSize           06C 801
#pragma libcall DPKBase FindField            072 90803
#pragma libcall DPKBase Unhook               078 9802
#pragma libcall DPKBase CallEventList        07E 18003
#pragma libcall DPKBase MoveToFront          084 801
#pragma libcall DPKBase GetField             08A 0802
#pragma libcall DPKBase WaitTime             090 001
#pragma libcall DPKBase FastRandom           096 101
#pragma libcall DPKBase SlowRandom           09C 101
#pragma libcall DPKBase CheckLock            0A2 801
#pragma libcall DPKBase Seek                 0A8 10803
#pragma libcall DPKBase Lock                 0AE 801
#pragma libcall DPKBase Unlock               0B4 801
#pragma libcall DPKBase AddSysEvent          0BA 801
#pragma libcall DPKBase RemSysEvent          0C0 801
#pragma libcall DPKBase AllocMemBlock        0C6 1002
#pragma libcall DPKBase FreeMemBlock         0CC 001
#pragma libcall DPKBase CleanSystem          0D2 001
#pragma libcall DPKBase empty01              0D8 00
#pragma libcall DPKBase Detach               0DE 9802
#pragma libcall DPKBase Read                 0E4 09803
#pragma libcall DPKBase Write                0EA 09803
#pragma libcall DPKBase Activate             0F0 801
#pragma libcall DPKBase Clear                0F6 801
#pragma libcall DPKBase SaveToFile           0FC A9803
#pragma libcall DPKBase Reset                102 801
#pragma libcall DPKBase Flush                108 801
#pragma tagcall DPKBase DPrintF              10E DC02
#pragma libcall DPKBase Show                 114 801
#pragma libcall DPKBase Load                 11A 0802
#pragma libcall DPKBase FindSysObject        120 8002
#pragma libcall DPKBase Hide                 126 801
#pragma libcall DPKBase InitDestruct         12C 9802
#pragma libcall DPKBase SelfDestruct         132 00
#pragma libcall DPKBase Armageddon           138 001
#pragma libcall DPKBase FingerOfDeath        13E 001
#pragma libcall DPKBase TotalMem             144 0802
#pragma libcall DPKBase Get                  14A 001
#pragma libcall DPKBase Free                 150 801
#pragma libcall DPKBase AddSysObject         156 891004
#pragma libcall DPKBase RemSysObject         15C 001
#pragma libcall DPKBase Awaken               162 801
#pragma libcall DPKBase CopyStructure        168 9802
#pragma libcall DPKBase AutoStop             16E 00
#pragma libcall DPKBase MoveToBack           174 801
#pragma libcall DPKBase Exclusive            17A 801
#pragma libcall DPKBase ErrCode              180 001
#pragma libcall DPKBase StepBack             186 00
#pragma libcall DPKBase GetExtension         18C 801
#pragma libcall DPKBase GetFileType          192 801
#pragma libcall DPKBase GetTypeList          198 001
#pragma libcall DPKBase Copy                 19E 9802
#pragma libcall DPKBase AttemptExclusive     1A4 0802
#pragma libcall DPKBase FreeExclusive        1AA 801
#pragma libcall DPKBase CheckInit            1B0 801
#pragma libcall DPKBase LoadPrefs            1B6 9802
#pragma libcall DPKBase CheckAction          1BC 9802
#pragma libcall DPKBase Rename               1C2 9802
#pragma libcall DPKBase Realloc              1C8 0802
#pragma libcall DPKBase AllocObjectID        1CE 00
#pragma libcall DPKBase FindReference        1D4 8002
#pragma libcall DPKBase FindSysName          1DA 9802
#pragma libcall DPKBase GetByName            1E0 801
#pragma libcall DPKBase GetFieldName         1E6 9802
#pragma libcall DPKBase CloneMemBlock        1EC 0802
#pragma libcall DPKBase SetField             1F2 10803
#pragma libcall DPKBase SetFieldName         1F8 09803
#pragma libcall DPKBase DebugOff             1FE 00
#pragma libcall DPKBase DebugOn              204 00
#pragma libcall DPKBase GetContainer         20A 801
#pragma libcall DPKBase AddResource          210 90803
#pragma libcall DPKBase FreeResource         216 9802
#pragma libcall DPKBase Idle                 21C 801
#pragma libcall DPKBase empty02              222 00
#pragma libcall DPKBase empty03              228 00
#pragma libcall DPKBase SetContext           22E 801
#endif
#ifdef __STORM__
#pragma tagcall(DPKBase,0x036,TagInitTags(a0,a1))
#pragma tagcall(DPKBase,0x0BA,AddSysEventTags(a0))
#pragma tagcall(DPKBase,0x156,AddSysObjectTags(d0,d1,a1,a0))
#endif
#ifdef __SASC_60
#pragma tagcall DPKBase TagInitTags          036 9802
#pragma tagcall DPKBase AddSysEventTags      0BA 801
#pragma tagcall DPKBase AddSysObjectTags     156 891004
#endif

#endif	/*  _INCLUDE_PRAGMA_DPKERNEL_LIB_H  */