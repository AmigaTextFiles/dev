#ifndef __exec_h_
#define __exec_h_
#include <exec/devices.h>
#include <exec/semaphores.h>
#include <exec/io.h>
#include <exec/memory.h>
#include <dos/dos.h>
struct ExecBase;
  void  _AddDevice (struct ExecBase * , struct Device *device );
#define  AddDevice(b1) _AddDevice (SysBase ,b1)
  void  _RemDevice (struct ExecBase * , struct Device *device );
#define  RemDevice(b1) _RemDevice (SysBase ,b1)
  BYTE  _OpenDevice (struct ExecBase * , STRPTR devName , ULONG unitNumber , struct IORequest *iORequest , ULONG flags );
#define  OpenDevice(b1,b2,b3,b4) _OpenDevice (SysBase ,b1,b2,b3,b4)
  void  _CloseDevice (struct ExecBase * , struct IORequest *iORequest );
#define  CloseDevice(b1) _CloseDevice (SysBase ,b1)
  void  _SendIO (struct ExecBase * , struct IORequest *iORequest );
#define  SendIO(b1) _SendIO (SysBase ,b1)
  struct IORequest *  _CheckIO (struct ExecBase * , struct IORequest *iORequest );
#define  CheckIO(b1) _CheckIO (SysBase ,b1)
  BYTE  _WaitIO (struct ExecBase * , struct IORequest *iORequest );
#define  WaitIO(b1) _WaitIO (SysBase ,b1)
  void  _AbortIO (struct ExecBase * , struct IORequest *iORequest );
#define  AbortIO(b1) _AbortIO (SysBase ,b1)
  BYTE  _DoIO (struct ExecBase * , struct IORequest *iORequest );
#define  DoIO(b1) _DoIO (SysBase ,b1)
  struct IORequest *  _CreateIORequest (struct ExecBase * , struct MsgPort *ioReplyPort , ULONG size );
#define  CreateIORequest(b1,b2) _CreateIORequest (SysBase ,b1,b2)
  void  _DeleteIORequest (struct ExecBase * , struct IORequest *ioReq );
#define  DeleteIORequest(b1) _DeleteIORequest (SysBase ,b1)
  struct Library *  _EXEC_Open (struct ExecBase * , ULONG version );
#define  EXEC_Open(b1) _EXEC_Open (SysBase ,b1)
  BPTR  _EXEC_Close (struct ExecBase * );
#define  EXEC_Close() _EXEC_Close (SysBase )
  BPTR  _EXEC_Expunge (struct ExecBase * );
#define  EXEC_Expunge() _EXEC_Expunge (SysBase )
  ULONG  _EXEC_Null (struct ExecBase * );
#define  EXEC_Null() _EXEC_Null (SysBase )
  struct Interrupt *  _SetIntVector (struct ExecBase * , ULONG intNumber , struct Interrupt *interrupt );
#define  SetIntVector(b1,b2) _SetIntVector (SysBase ,b1,b2)
  void  _AddIntServer (struct ExecBase * , long intnum , struct Interrupt *inter );
#define  AddIntServer(b1,b2) _AddIntServer (SysBase ,b1,b2)
  void  _RemIntServer (struct ExecBase * , ULONG intNum , struct Interrupt *interrupt );
#define  RemIntServer(b1,b2) _RemIntServer (SysBase ,b1,b2)
  void  _Cause (struct ExecBase * , struct Interrupt *interrupt );
#define  Cause(b1) _Cause (SysBase ,b1)
  ULONG  _ObtainQuickVector (struct ExecBase * , APTR interruptCode );
#define  ObtainQuickVector(b1) _ObtainQuickVector (SysBase ,b1)
  void  _Disable (struct ExecBase * );
#define  Disable() _Disable (SysBase )
  void  _Enable (struct ExecBase * );
#define  Enable() _Enable (SysBase )
  void  _Private_1 (struct ExecBase * );
#define  Private_1() _Private_1 (SysBase )
    APTR  _Private_2 (struct ExecBase * , APTR newstack );
#define  Private_2(b1) _Private_2 (SysBase ,b1)
    APTR  _Private_3 (struct ExecBase * , APTR oldstack , APTR function , APTR data );
#define  Private_3(b1,b2,b3) _Private_3 (SysBase ,b1,b2,b3)
    void  _Private_4 (struct ExecBase * , ULONG intnum );
#define  Private_4(b1) _Private_4 (SysBase ,b1)
    void  _CacheClearU (struct ExecBase * );
#define  CacheClearU() _CacheClearU (SysBase )
  void  _CacheClearE (struct ExecBase * , APTR address , ULONG length , ULONG flags );
#define  CacheClearE(b1,b2,b3) _CacheClearE (SysBase ,b1,b2,b3)
  APTR  _CachePreDMA (struct ExecBase * , APTR address , LONG *length , ULONG flags );
#define  CachePreDMA(b1,b2,b3) _CachePreDMA (SysBase ,b1,b2,b3)
  void  _CachePostDMA (struct ExecBase * , APTR address , LONG *length , ULONG flags );
#define  CachePostDMA(b1,b2,b3) _CachePostDMA (SysBase ,b1,b2,b3)
  void  _AddLibrary (struct ExecBase * , struct Library *lib );
#define  AddLibrary(b1) _AddLibrary (SysBase ,b1)
  void  _RemLibrary (struct ExecBase * , struct Library *lib );
#define  RemLibrary(b1) _RemLibrary (SysBase ,b1)
  ULONG  _MakeFunctions (struct ExecBase * , APTR bp , APTR array , APTR base );
#define  MakeFunctions(b1,b2,b3) _MakeFunctions (SysBase ,b1,b2,b3)
  void  _InitStruct (struct ExecBase * , APTR is , APTR mem , ULONG size );
#define  InitStruct(b1,b2,b3) _InitStruct (SysBase ,b1,b2,b3)
  struct Library *  _MakeLibrary (struct ExecBase * , APTR jmptabl , APTR is , ULONG (*initpc)() , ULONG size , ULONG seglist );
#define  MakeLibrary(b1,b2,b3,b4,b5) _MakeLibrary (SysBase ,b1,b2,b3,b4,b5)
  struct Library *  _OldOpenLibrary (struct ExecBase * , APTR libName );
#define  OldOpenLibrary(b1) _OldOpenLibrary (SysBase ,b1)
  void  _CloseLibrary (struct ExecBase * , struct Library *library );
#define  CloseLibrary(b1) _CloseLibrary (SysBase ,b1)
  APTR  _SetFunction (struct ExecBase * , struct Library *library , LONG funcOffset , APTR funcEntry );
#define  SetFunction(b1,b2,b3) _SetFunction (SysBase ,b1,b2,b3)
  void  _SumLibrary (struct ExecBase * , struct Library *library );
#define  SumLibrary(b1) _SumLibrary (SysBase ,b1)
  struct Library *  _OpenLibrary (struct ExecBase * , STRPTR libName , ULONG version );
#define  OpenLibrary(b1,b2) _OpenLibrary (SysBase ,b1,b2)
  void  _Insert (struct ExecBase * , struct List *list , struct Node *node , struct Node *prev );
#define  Insert(b1,b2,b3) _Insert (SysBase ,b1,b2,b3)
  void  _Remove (struct ExecBase * , struct Node *node );
#define  Remove(b1) _Remove (SysBase ,b1)
  void  _AddHead (struct ExecBase * , struct List *list , struct Node *node );
#define  AddHead(b1,b2) _AddHead (SysBase ,b1,b2)
  struct Node *  _RemHead (struct ExecBase * , struct List *list );
#define  RemHead(b1) _RemHead (SysBase ,b1)
  void  _AddTail (struct ExecBase * , struct List *list , struct Node *node );
#define  AddTail(b1,b2) _AddTail (SysBase ,b1,b2)
  struct Node *  _RemTail (struct ExecBase * , struct List *list );
#define  RemTail(b1) _RemTail (SysBase ,b1)
  void  _Enqueue (struct ExecBase * , struct List *list , struct Node *node );
#define  Enqueue(b1,b2) _Enqueue (SysBase ,b1,b2)
  struct Node *  _FindName (struct ExecBase * , struct List *list , STRPTR name );
#define  FindName(b1,b2) _FindName (SysBase ,b1,b2)
  VOID  _StackSwap (struct ExecBase * , struct StackSwapStruct *newStack );
#define  StackSwap(b1) _StackSwap (SysBase ,b1)
  void *  _Allocate (struct ExecBase * , struct MemHeader *mh , ULONG size );
#define  Allocate(b1,b2) _Allocate (SysBase ,b1,b2)
  void  _Deallocate (struct ExecBase * , struct MemHeader *mh , APTR mem , ULONG size );
#define  Deallocate(b1,b2,b3) _Deallocate (SysBase ,b1,b2,b3)
  void *  _AllocMem (struct ExecBase * , ULONG size , ULONG attrib );
#define  AllocMem(b1,b2) _AllocMem (SysBase ,b1,b2)
  void  _FreeMem (struct ExecBase * , void *mem , ULONG size );
#define  FreeMem(b1,b2) _FreeMem (SysBase ,b1,b2)
  void *  _AllocAbs (struct ExecBase * , ULONG size , void *mem );
#define  AllocAbs(b1,b2) _AllocAbs (SysBase ,b1,b2)
  void *  _AllocVec (struct ExecBase * , ULONG size , ULONG attrib );
#define  AllocVec(b1,b2) _AllocVec (SysBase ,b1,b2)
  void  _FreeVec (struct ExecBase * , void *mem );
#define  FreeVec(b1) _FreeVec (SysBase ,b1)
  struct MemList *  _AllocEntry (struct ExecBase * , struct MemList *ml );
#define  AllocEntry(b1) _AllocEntry (SysBase ,b1)
  void  _FreeEntry (struct ExecBase * , struct MemList *ml );
#define  FreeEntry(b1) _FreeEntry (SysBase ,b1)
  void  _AddMemList (struct ExecBase * , ULONG size , ULONG attributes , LONG pri , APTR base , STRPTR name );
#define  AddMemList(b1,b2,b3,b4,b5) _AddMemList (SysBase ,b1,b2,b3,b4,b5)
  ULONG  _TypeOfMem (struct ExecBase * , void *mem );
#define  TypeOfMem(b1) _TypeOfMem (SysBase ,b1)
  void  _CopyMem (struct ExecBase * , APTR source , APTR dest , unsigned long size );
#define  CopyMem(b1,b2,b3) _CopyMem (SysBase ,b1,b2,b3)
  void  _CopyMemQuick (struct ExecBase * , ULONG *source , ULONG *dest , ULONG size );
#define  CopyMemQuick(b1,b2,b3) _CopyMemQuick (SysBase ,b1,b2,b3)
  ULONG  _AvailMem (struct ExecBase * , ULONG attributes );
#define  AvailMem(b1) _AvailMem (SysBase ,b1)
  void *  _CreatePool (struct ExecBase * , ULONG memFlags , ULONG puddleSize , ULONG treshSize );
#define  CreatePool(b1,b2,b3) _CreatePool (SysBase ,b1,b2,b3)
  void  _DeletePool (struct ExecBase * , void *poolHeader );
#define  DeletePool(b1) _DeletePool (SysBase ,b1)
  void *  _AllocPooled (struct ExecBase * , void *poolHeader , ULONG memSize );
#define  AllocPooled(b1,b2) _AllocPooled (SysBase ,b1,b2)
  void  _FreePooled (struct ExecBase * , void *poolHeader , void *memory , ULONG memSize );
#define  FreePooled(b1,b2,b3) _FreePooled (SysBase ,b1,b2,b3)
  void  _AddMemHandler (struct ExecBase * , struct Interrupt *memHandler );
#define  AddMemHandler(b1) _AddMemHandler (SysBase ,b1)
  void  _RemMemHandler (struct ExecBase * , struct Interrupt *memHandler );
#define  RemMemHandler(b1) _RemMemHandler (SysBase ,b1)
  struct Message *  _GetMsg (struct ExecBase * , struct MsgPort *port );
#define  GetMsg(b1) _GetMsg (SysBase ,b1)
  void  _PutMsg (struct ExecBase * , struct MsgPort *port , struct Message *msg );
#define  PutMsg(b1,b2) _PutMsg (SysBase ,b1,b2)
  void  _ReplyMsg (struct ExecBase * , struct Message *msg );
#define  ReplyMsg(b1) _ReplyMsg (SysBase ,b1)
  struct Message *  _WaitPort (struct ExecBase * , struct MsgPort *port );
#define  WaitPort(b1) _WaitPort (SysBase ,b1)
  struct MsgPort *  _CreateMsgPort (struct ExecBase * );
#define  CreateMsgPort() _CreateMsgPort (SysBase )
  void  _DeleteMsgPort (struct ExecBase * , struct MsgPort *port );
#define  DeleteMsgPort(b1) _DeleteMsgPort (SysBase ,b1)
  struct MsgPort *  _FindPort (struct ExecBase * , STRPTR name );
#define  FindPort(b1) _FindPort (SysBase ,b1)
  void  _AddPort (struct ExecBase * , struct MsgPort *port );
#define  AddPort(b1) _AddPort (SysBase ,b1)
  void  _RemPort (struct ExecBase * , struct MsgPort *port );
#define  RemPort(b1) _RemPort (SysBase ,b1)
  void  _Alert (struct ExecBase * , ULONG alertnum );
#define  Alert(b1) _Alert (SysBase ,b1)
  void  _Debug (struct ExecBase * , ULONG flags );
#define  Debug(b1) _Debug (SysBase ,b1)
  APTR  _RawDoFmt (struct ExecBase * , STRPTR FormatString , APTR DataStream , void (*PutChProc)() , APTR PutChData );
#define  RawDoFmt(b1,b2,b3,b4) _RawDoFmt (SysBase ,b1,b2,b3,b4)
  void  _ColdReboot (struct ExecBase * );
#define  ColdReboot() _ColdReboot (SysBase )
  void  _Private_1 (struct ExecBase * );
#define  Private_1() _Private_1 (SysBase )
  APTR  _Private_2 (struct ExecBase * , APTR newstack );
#define  Private_2(b1) _Private_2 (SysBase ,b1)
  APTR  _Private_3 (struct ExecBase * , APTR oldstack , APTR function , APTR data );
#define  Private_3(b1,b2,b3) _Private_3 (SysBase ,b1,b2,b3)
  void  _Private_4 (struct ExecBase * , ULONG intnum );
#define  Private_4(b1) _Private_4 (SysBase ,b1)
  void  _Private_5 (struct ExecBase * , ULONG intNumber , APTR function , APTR data );
#define  Private_5(b1,b2,b3) _Private_5 (SysBase ,b1,b2,b3)
  void  _Private_7 (struct ExecBase * );
#define  Private_7() _Private_7 (SysBase )
  void  _Private_8 (struct ExecBase * );
#define  Private_8() _Private_8 (SysBase )
  ULONG  _CacheControl (struct ExecBase * , ULONG bits , ULONG mask );
#define  CacheControl(b1,b2) _CacheControl (SysBase ,b1,b2)
  ULONG  _Supervisor (struct ExecBase * , void *userFunc );
#define  Supervisor(b1) _Supervisor (SysBase ,b1)
  APTR  _SuperState (struct ExecBase * );
#define  SuperState() _SuperState (SysBase )
  void  _UserState (struct ExecBase * , APTR sysStack );
#define  UserState(b1) _UserState (SysBase ,b1)
  LONG  _AllocTrap (struct ExecBase * , LONG trapNum );
#define  AllocTrap(b1) _AllocTrap (SysBase ,b1)
  void  _FreeTrap (struct ExecBase * , ULONG trapNum );
#define  FreeTrap(b1) _FreeTrap (SysBase ,b1)
  ULONG  _SetSR (struct ExecBase * , ULONG newSR , ULONG mask );
#define  SetSR(b1,b2) _SetSR (SysBase ,b1,b2)
  void  _GetCC (struct ExecBase * );
#define  GetCC() _GetCC (SysBase )
  void  _Private_6 (struct ExecBase * );
#define  Private_6() _Private_6 (SysBase )
  void  _Private_9 (struct ExecBase * );
#define  Private_9() _Private_9 (SysBase )
  void  _Private_10 (struct ExecBase * );
#define  Private_10() _Private_10 (SysBase )
  void  _Private_11 (struct ExecBase * );
#define  Private_11() _Private_11 (SysBase )
  void  _Private_12 (struct ExecBase * );
#define  Private_12() _Private_12 (SysBase )
  void  _Private_13 (struct ExecBase * );
#define  Private_13() _Private_13 (SysBase )
  void  _Private_14 (struct ExecBase * );
#define  Private_14() _Private_14 (SysBase )
  void  _Private_15 (struct ExecBase * );
#define  Private_15() _Private_15 (SysBase )
  void  _InitCode (struct ExecBase * , ULONG startClass , ULONG version );
#define  InitCode(b1,b2) _InitCode (SysBase ,b1,b2)
  struct Resident *  _FindResident (struct ExecBase * , STRPTR name );
#define  FindResident(b1) _FindResident (SysBase ,b1)
  APTR  _InitResident (struct ExecBase * , struct Resident *resident , ULONG segList );
#define  InitResident(b1,b2) _InitResident (SysBase ,b1,b2)
  ULONG  _SumKickData (struct ExecBase * );
#define  SumKickData() _SumKickData (SysBase )
  void  _AddResource (struct ExecBase * , APTR resource );
#define  AddResource(b1) _AddResource (SysBase ,b1)
  void  _RemResource (struct ExecBase * , APTR resource );
#define  RemResource(b1) _RemResource (SysBase ,b1)
  APTR  _OpenResource (struct ExecBase * , STRPTR resName );
#define  OpenResource(b1) _OpenResource (SysBase ,b1)
  VOID  _InitSemaphore (struct ExecBase * , struct SignalSemaphore *sem );
#define  InitSemaphore(b1) _InitSemaphore (SysBase ,b1)
  VOID  _ObtainSemaphore (struct ExecBase * , struct SignalSemaphore *sem );
#define  ObtainSemaphore(b1) _ObtainSemaphore (SysBase ,b1)
  ULONG  _AttemptSemaphore (struct ExecBase * , struct SignalSemaphore *sem );
#define  AttemptSemaphore(b1) _AttemptSemaphore (SysBase ,b1)
  VOID  _ObtainSemaphoreShared (struct ExecBase * , struct SignalSemaphore *sem );
#define  ObtainSemaphoreShared(b1) _ObtainSemaphoreShared (SysBase ,b1)
  ULONG  _AttemptSemaphoreShared (struct ExecBase * , struct SignalSemaphore *sem );
#define  AttemptSemaphoreShared(b1) _AttemptSemaphoreShared (SysBase ,b1)
  VOID  _ReleaseSemaphore (struct ExecBase * , struct SignalSemaphore *sem );
#define  ReleaseSemaphore(b1) _ReleaseSemaphore (SysBase ,b1)
  VOID  _Procure (struct ExecBase * , struct SignalSemaphore *sem , struct SemaphoreMessage *sm );
#define  Procure(b1,b2) _Procure (SysBase ,b1,b2)
  VOID  _Vacate (struct ExecBase * , struct SignalSemaphore *sem , struct SemaphoreMessage *sm );
#define  Vacate(b1,b2) _Vacate (SysBase ,b1,b2)
  VOID  _ObtainSemaphoreList (struct ExecBase * , struct List *sl );
#define  ObtainSemaphoreList(b1) _ObtainSemaphoreList (SysBase ,b1)
  VOID  _ReleaseSemaphoreList (struct ExecBase * , struct List *sl );
#define  ReleaseSemaphoreList(b1) _ReleaseSemaphoreList (SysBase ,b1)
  VOID  _AddSemaphore (struct ExecBase * , struct SignalSemaphore *sem );
#define  AddSemaphore(b1) _AddSemaphore (SysBase ,b1)
  VOID  _RemSemaphore (struct ExecBase * , struct SignalSemaphore *sem );
#define  RemSemaphore(b1) _RemSemaphore (SysBase ,b1)
  struct SignalSemaphore *  _FindSemaphore (struct ExecBase * , STRPTR name );
#define  FindSemaphore(b1) _FindSemaphore (SysBase ,b1)
  BYTE  _AllocSignal (struct ExecBase * , long signum );
#define  AllocSignal(b1) _AllocSignal (SysBase ,b1)
  void  _FreeSignal (struct ExecBase * , long signum );
#define  FreeSignal(b1) _FreeSignal (SysBase ,b1)
  ULONG  _SetSignal (struct ExecBase * , ULONG new , ULONG mask );
#define  SetSignal(b1,b2) _SetSignal (SysBase ,b1,b2)
  ULONG  _SetExcept (struct ExecBase * , ULONG newSignals , ULONG signalMask );
#define  SetExcept(b1,b2) _SetExcept (SysBase ,b1,b2)
  void  _Signal (struct ExecBase * , struct Task *task , ULONG sigs );
#define  Signal(b1,b2) _Signal (SysBase ,b1,b2)
  ULONG  _Wait (struct ExecBase * , ULONG sigs );
#define  Wait(b1) _Wait (SysBase ,b1)
  void  _Forbid (struct ExecBase * );
#define  Forbid() _Forbid (SysBase )
  void  _Permit (struct ExecBase * );
#define  Permit() _Permit (SysBase )
  APTR  _AddTask (struct ExecBase * , struct Task *task , APTR initialPC , APTR finalPC );
#define  AddTask(b1,b2,b3) _AddTask (SysBase ,b1,b2,b3)
  void  _RemTask (struct ExecBase * , struct Task *task );
#define  RemTask(b1) _RemTask (SysBase ,b1)
  BYTE  _SetTaskPri (struct ExecBase * , struct Task *task , long pri );
#define  SetTaskPri(b1,b2) _SetTaskPri (SysBase ,b1,b2)
  struct Task *  _FindTask (struct ExecBase * , STRPTR name );
#define  FindTask(b1) _FindTask (SysBase ,b1)
  void  _ChildFree (struct ExecBase * , APTR tid );
#define  ChildFree(b1) _ChildFree (SysBase ,b1)
  void  _ChildOrphan (struct ExecBase * , APTR tid );
#define  ChildOrphan(b1) _ChildOrphan (SysBase ,b1)
  void  _ChildStatus (struct ExecBase * , APTR tid );
#define  ChildStatus(b1) _ChildStatus (SysBase ,b1)
  void  _ChildWait (struct ExecBase * , APTR tid );
#define  ChildWait(b1) _ChildWait (SysBase ,b1)
 #endif