#ifndef _INCLUDE_PRAGMA_EXEC_LIB_H
#define _INCLUDE_PRAGMA_EXEC_LIB_H

#ifndef CLIB_EXEC_PROTOS_H
#include <clib/exec_protos.h>
#endif

#if defined(AZTEC_C) || defined(__MAXON__) || defined(__STORM__)
#pragma amicall(SysBase,0x01e,Supervisor(a5))
#pragma amicall(SysBase,0x048,InitCode(d0,d1))
#pragma amicall(SysBase,0x04e,InitStruct(a1,a2,d0))
#pragma amicall(SysBase,0x054,MakeLibrary(a0,a1,a2,d0,d1))
#pragma amicall(SysBase,0x05a,MakeFunctions(a0,a1,a2))
#pragma amicall(SysBase,0x060,FindResident(a1))
#pragma amicall(SysBase,0x066,InitResident(a1,d1))
#pragma amicall(SysBase,0x06c,Alert(d7))
#pragma amicall(SysBase,0x072,Debug(d0))
#pragma amicall(SysBase,0x078,Disable())
#pragma amicall(SysBase,0x07e,Enable())
#pragma amicall(SysBase,0x084,Forbid())
#pragma amicall(SysBase,0x08a,Permit())
#pragma amicall(SysBase,0x090,SetSR(d0,d1))
#pragma amicall(SysBase,0x096,SuperState())
#pragma amicall(SysBase,0x09c,UserState(d0))
#pragma amicall(SysBase,0x0a2,SetIntVector(d0,a1))
#pragma amicall(SysBase,0x0a8,AddIntServer(d0,a1))
#pragma amicall(SysBase,0x0ae,RemIntServer(d0,a1))
#pragma amicall(SysBase,0x0b4,Cause(a1))
#pragma amicall(SysBase,0x0ba,Allocate(a0,d0))
#pragma amicall(SysBase,0x0c0,Deallocate(a0,a1,d0))
#pragma amicall(SysBase,0x0c6,AllocMem(d0,d1))
#pragma amicall(SysBase,0x0cc,AllocAbs(d0,a1))
#pragma amicall(SysBase,0x0d2,FreeMem(a1,d0))
#pragma amicall(SysBase,0x0d8,AvailMem(d1))
#pragma amicall(SysBase,0x0de,AllocEntry(a0))
#pragma amicall(SysBase,0x0e4,FreeEntry(a0))
#pragma amicall(SysBase,0x0ea,Insert(a0,a1,a2))
#pragma amicall(SysBase,0x0f0,AddHead(a0,a1))
#pragma amicall(SysBase,0x0f6,AddTail(a0,a1))
#pragma amicall(SysBase,0x0fc,Remove(a1))
#pragma amicall(SysBase,0x102,RemHead(a0))
#pragma amicall(SysBase,0x108,RemTail(a0))
#pragma amicall(SysBase,0x10e,Enqueue(a0,a1))
#pragma amicall(SysBase,0x114,FindName(a0,a1))
#pragma amicall(SysBase,0x11a,AddTask(a1,a2,a3))
#pragma amicall(SysBase,0x120,RemTask(a1))
#pragma amicall(SysBase,0x126,FindTask(a1))
#pragma amicall(SysBase,0x12c,SetTaskPri(a1,d0))
#pragma amicall(SysBase,0x132,SetSignal(d0,d1))
#pragma amicall(SysBase,0x138,SetExcept(d0,d1))
#pragma amicall(SysBase,0x13e,Wait(d0))
#pragma amicall(SysBase,0x144,Signal(a1,d0))
#pragma amicall(SysBase,0x14a,AllocSignal(d0))
#pragma amicall(SysBase,0x150,FreeSignal(d0))
#pragma amicall(SysBase,0x156,AllocTrap(d0))
#pragma amicall(SysBase,0x15c,FreeTrap(d0))
#pragma amicall(SysBase,0x162,AddPort(a1))
#pragma amicall(SysBase,0x168,RemPort(a1))
#pragma amicall(SysBase,0x16e,PutMsg(a0,a1))
#pragma amicall(SysBase,0x174,GetMsg(a0))
#pragma amicall(SysBase,0x17a,ReplyMsg(a1))
#pragma amicall(SysBase,0x180,WaitPort(a0))
#pragma amicall(SysBase,0x186,FindPort(a1))
#pragma amicall(SysBase,0x18c,AddLibrary(a1))
#pragma amicall(SysBase,0x192,RemLibrary(a1))
#pragma amicall(SysBase,0x198,OldOpenLibrary(a1))
#pragma amicall(SysBase,0x19e,CloseLibrary(a1))
#pragma amicall(SysBase,0x1a4,SetFunction(a1,a0,d0))
#pragma amicall(SysBase,0x1aa,SumLibrary(a1))
#pragma amicall(SysBase,0x1b0,AddDevice(a1))
#pragma amicall(SysBase,0x1b6,RemDevice(a1))
#pragma amicall(SysBase,0x1bc,OpenDevice(a0,d0,a1,d1))
#pragma amicall(SysBase,0x1c2,CloseDevice(a1))
#pragma amicall(SysBase,0x1c8,DoIO(a1))
#pragma amicall(SysBase,0x1ce,SendIO(a1))
#pragma amicall(SysBase,0x1d4,CheckIO(a1))
#pragma amicall(SysBase,0x1da,WaitIO(a1))
#pragma amicall(SysBase,0x1e0,AbortIO(a1))
#pragma amicall(SysBase,0x1e6,AddResource(a1))
#pragma amicall(SysBase,0x1ec,RemResource(a1))
#pragma amicall(SysBase,0x1f2,OpenResource(a1))
#pragma amicall(SysBase,0x20a,RawDoFmt(a0,a1,a2,a3))
#pragma amicall(SysBase,0x210,GetCC())
#pragma amicall(SysBase,0x216,TypeOfMem(a1))
#pragma amicall(SysBase,0x21c,Procure(a0,a1))
#pragma amicall(SysBase,0x222,Vacate(a0,a1))
#pragma amicall(SysBase,0x228,OpenLibrary(a1,d0))
#pragma amicall(SysBase,0x22e,InitSemaphore(a0))
#pragma amicall(SysBase,0x234,ObtainSemaphore(a0))
#pragma amicall(SysBase,0x23a,ReleaseSemaphore(a0))
#pragma amicall(SysBase,0x240,AttemptSemaphore(a0))
#pragma amicall(SysBase,0x246,ObtainSemaphoreList(a0))
#pragma amicall(SysBase,0x24c,ReleaseSemaphoreList(a0))
#pragma amicall(SysBase,0x252,FindSemaphore(a1))
#pragma amicall(SysBase,0x258,AddSemaphore(a1))
#pragma amicall(SysBase,0x25e,RemSemaphore(a1))
#pragma amicall(SysBase,0x264,SumKickData())
#pragma amicall(SysBase,0x26a,AddMemList(d0,d1,d2,a0,a1))
#pragma amicall(SysBase,0x270,CopyMem(a0,a1,d0))
#pragma amicall(SysBase,0x276,CopyMemQuick(a0,a1,d0))
#pragma amicall(SysBase,0x27c,CacheClearU())
#pragma amicall(SysBase,0x282,CacheClearE(a0,d0,d1))
#pragma amicall(SysBase,0x288,CacheControl(d0,d1))
#pragma amicall(SysBase,0x28e,CreateIORequest(a0,d0))
#pragma amicall(SysBase,0x294,DeleteIORequest(a0))
#pragma amicall(SysBase,0x29a,CreateMsgPort())
#pragma amicall(SysBase,0x2a0,DeleteMsgPort(a0))
#pragma amicall(SysBase,0x2a6,ObtainSemaphoreShared(a0))
#pragma amicall(SysBase,0x2ac,AllocVec(d0,d1))
#pragma amicall(SysBase,0x2b2,FreeVec(a1))
#pragma amicall(SysBase,0x2b8,CreatePool(d0,d1,d2))
#pragma amicall(SysBase,0x2be,DeletePool(a0))
#pragma amicall(SysBase,0x2c4,AllocPooled(a0,d0))
#pragma amicall(SysBase,0x2ca,FreePooled(a0,a1,d0))
#pragma amicall(SysBase,0x2d0,AttemptSemaphoreShared(a0))
#pragma amicall(SysBase,0x2d6,ColdReboot())
#pragma amicall(SysBase,0x2dc,StackSwap(a0))
#pragma amicall(SysBase,0x2fa,CachePreDMA(a0,a1,d0))
#pragma amicall(SysBase,0x300,CachePostDMA(a0,a1,d0))
#pragma amicall(SysBase,0x306,AddMemHandler(a1))
#pragma amicall(SysBase,0x30c,RemMemHandler(a1))
#pragma amicall(SysBase,0x312,ObtainQuickVector(a0))
#pragma amicall(SysBase,0x33c,NewMinList(a0))
#pragma amicall(SysBase,0x354,AVL_AddNode(a0,a1,a2))
#pragma amicall(SysBase,0x35a,AVL_RemNodeByAddress(a0,a1))
#pragma amicall(SysBase,0x360,AVL_RemNodeByKey(a0,a1,a2))
#pragma amicall(SysBase,0x366,AVL_FindNode(a0,a1,a2))
#pragma amicall(SysBase,0x36c,AVL_FindPrevNodeByAddress(a0))
#pragma amicall(SysBase,0x372,AVL_FindPrevNodeByKey(a0,a1,a2))
#pragma amicall(SysBase,0x378,AVL_FindNextNodeByAddress(a0))
#pragma amicall(SysBase,0x37e,AVL_FindNextNodeByKey(a0,a1,a2))
#pragma amicall(SysBase,0x384,AVL_FindFirstNode(a0))
#pragma amicall(SysBase,0x38a,AVL_FindLastNode(a0))
#endif
#if defined(_DCC) || defined(__SASC)
#pragma  libcall SysBase Supervisor             01e d01
#pragma  libcall SysBase InitCode               048 1002
#pragma  libcall SysBase InitStruct             04e 0a903
#pragma  libcall SysBase MakeLibrary            054 10a9805
#pragma  libcall SysBase MakeFunctions          05a a9803
#pragma  libcall SysBase FindResident           060 901
#pragma  libcall SysBase InitResident           066 1902
#pragma  libcall SysBase Alert                  06c 701
#pragma  libcall SysBase Debug                  072 001
#pragma  libcall SysBase Disable                078 00
#pragma  libcall SysBase Enable                 07e 00
#pragma  libcall SysBase Forbid                 084 00
#pragma  libcall SysBase Permit                 08a 00
#pragma  libcall SysBase SetSR                  090 1002
#pragma  libcall SysBase SuperState             096 00
#pragma  libcall SysBase UserState              09c 001
#pragma  libcall SysBase SetIntVector           0a2 9002
#pragma  libcall SysBase AddIntServer           0a8 9002
#pragma  libcall SysBase RemIntServer           0ae 9002
#pragma  libcall SysBase Cause                  0b4 901
#pragma  libcall SysBase Allocate               0ba 0802
#pragma  libcall SysBase Deallocate             0c0 09803
#pragma  libcall SysBase AllocMem               0c6 1002
#pragma  libcall SysBase AllocAbs               0cc 9002
#pragma  libcall SysBase FreeMem                0d2 0902
#pragma  libcall SysBase AvailMem               0d8 101
#pragma  libcall SysBase AllocEntry             0de 801
#pragma  libcall SysBase FreeEntry              0e4 801
#pragma  libcall SysBase Insert                 0ea a9803
#pragma  libcall SysBase AddHead                0f0 9802
#pragma  libcall SysBase AddTail                0f6 9802
#pragma  libcall SysBase Remove                 0fc 901
#pragma  libcall SysBase RemHead                102 801
#pragma  libcall SysBase RemTail                108 801
#pragma  libcall SysBase Enqueue                10e 9802
#pragma  libcall SysBase FindName               114 9802
#pragma  libcall SysBase AddTask                11a ba903
#pragma  libcall SysBase RemTask                120 901
#pragma  libcall SysBase FindTask               126 901
#pragma  libcall SysBase SetTaskPri             12c 0902
#pragma  libcall SysBase SetSignal              132 1002
#pragma  libcall SysBase SetExcept              138 1002
#pragma  libcall SysBase Wait                   13e 001
#pragma  libcall SysBase Signal                 144 0902
#pragma  libcall SysBase AllocSignal            14a 001
#pragma  libcall SysBase FreeSignal             150 001
#pragma  libcall SysBase AllocTrap              156 001
#pragma  libcall SysBase FreeTrap               15c 001
#pragma  libcall SysBase AddPort                162 901
#pragma  libcall SysBase RemPort                168 901
#pragma  libcall SysBase PutMsg                 16e 9802
#pragma  libcall SysBase GetMsg                 174 801
#pragma  libcall SysBase ReplyMsg               17a 901
#pragma  libcall SysBase WaitPort               180 801
#pragma  libcall SysBase FindPort               186 901
#pragma  libcall SysBase AddLibrary             18c 901
#pragma  libcall SysBase RemLibrary             192 901
#pragma  libcall SysBase OldOpenLibrary         198 901
#pragma  libcall SysBase CloseLibrary           19e 901
#pragma  libcall SysBase SetFunction            1a4 08903
#pragma  libcall SysBase SumLibrary             1aa 901
#pragma  libcall SysBase AddDevice              1b0 901
#pragma  libcall SysBase RemDevice              1b6 901
#pragma  libcall SysBase OpenDevice             1bc 190804
#pragma  libcall SysBase CloseDevice            1c2 901
#pragma  libcall SysBase DoIO                   1c8 901
#pragma  libcall SysBase SendIO                 1ce 901
#pragma  libcall SysBase CheckIO                1d4 901
#pragma  libcall SysBase WaitIO                 1da 901
#pragma  libcall SysBase AbortIO                1e0 901
#pragma  libcall SysBase AddResource            1e6 901
#pragma  libcall SysBase RemResource            1ec 901
#pragma  libcall SysBase OpenResource           1f2 901
#pragma  libcall SysBase RawDoFmt               20a ba9804
#pragma  libcall SysBase GetCC                  210 00
#pragma  libcall SysBase TypeOfMem              216 901
#pragma  libcall SysBase Procure                21c 9802
#pragma  libcall SysBase Vacate                 222 9802
#pragma  libcall SysBase OpenLibrary            228 0902
#pragma  libcall SysBase InitSemaphore          22e 801
#pragma  libcall SysBase ObtainSemaphore        234 801
#pragma  libcall SysBase ReleaseSemaphore       23a 801
#pragma  libcall SysBase AttemptSemaphore       240 801
#pragma  libcall SysBase ObtainSemaphoreList    246 801
#pragma  libcall SysBase ReleaseSemaphoreList   24c 801
#pragma  libcall SysBase FindSemaphore          252 901
#pragma  libcall SysBase AddSemaphore           258 901
#pragma  libcall SysBase RemSemaphore           25e 901
#pragma  libcall SysBase SumKickData            264 00
#pragma  libcall SysBase AddMemList             26a 9821005
#pragma  libcall SysBase CopyMem                270 09803
#pragma  libcall SysBase CopyMemQuick           276 09803
#pragma  libcall SysBase CacheClearU            27c 00
#pragma  libcall SysBase CacheClearE            282 10803
#pragma  libcall SysBase CacheControl           288 1002
#pragma  libcall SysBase CreateIORequest        28e 0802
#pragma  libcall SysBase DeleteIORequest        294 801
#pragma  libcall SysBase CreateMsgPort          29a 00
#pragma  libcall SysBase DeleteMsgPort          2a0 801
#pragma  libcall SysBase ObtainSemaphoreShared  2a6 801
#pragma  libcall SysBase AllocVec               2ac 1002
#pragma  libcall SysBase FreeVec                2b2 901
#pragma  libcall SysBase CreatePool             2b8 21003
#pragma  libcall SysBase DeletePool             2be 801
#pragma  libcall SysBase AllocPooled            2c4 0802
#pragma  libcall SysBase FreePooled             2ca 09803
#pragma  libcall SysBase AttemptSemaphoreShared 2d0 801
#pragma  libcall SysBase ColdReboot             2d6 00
#pragma  libcall SysBase StackSwap              2dc 801
#pragma  libcall SysBase CachePreDMA            2fa 09803
#pragma  libcall SysBase CachePostDMA           300 09803
#pragma  libcall SysBase AddMemHandler          306 901
#pragma  libcall SysBase RemMemHandler          30c 901
#pragma  libcall SysBase ObtainQuickVector      312 801
#pragma  libcall SysBase NewMinList             33c 801
#pragma  libcall SysBase AVL_AddNode            354 a9803
#pragma  libcall SysBase AVL_RemNodeByAddress   35a 9802
#pragma  libcall SysBase AVL_RemNodeByKey       360 a9803
#pragma  libcall SysBase AVL_FindNode           366 a9803
#pragma  libcall SysBase AVL_FindPrevNodeByAddress 36c 801
#pragma  libcall SysBase AVL_FindPrevNodeByKey  372 a9803
#pragma  libcall SysBase AVL_FindNextNodeByAddress 378 801
#pragma  libcall SysBase AVL_FindNextNodeByKey  37e a9803
#pragma  libcall SysBase AVL_FindFirstNode      384 801
#pragma  libcall SysBase AVL_FindLastNode       38a 801
#endif

#endif	/*  _INCLUDE_PRAGMA_EXEC_LIB_H  */
