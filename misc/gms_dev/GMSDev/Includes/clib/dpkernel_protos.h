#ifndef  CLIB_DPKERNEL_PROTOS_H
#define  CLIB_DPKERNEL_PROTOS_H

/*
**  $VER: dpkernel_protos.h
**
**  C prototypes.
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
*/

#ifndef  DPKERNEL_H
#include <dpkernel/dpkernel.h>
#endif

#ifndef MODULES_DPKBASE_H
#include <modules/dpkbase.h>
#endif

#ifndef _USE_DPKBASE

void yyx0000(void);
void TagInitTags(APTR,APTR);
void empty01(void);
void empty02(void);
void empty03(void);

ECODE  Activate(APTR Object);
APTR   AddResource(APTR Object, WORD Type, APTR Pointer);
struct Event * AddSysEvent(APTR TagList);
struct Event * AddSysEventTags(ULONG tag1Type, ...);
struct SysObject * AddSysObject(WORD ClassID, WORD ObjectID, BYTE *Name, APTR TagList);
struct SysObject * AddSysObjectTags(WORD ClassID, WORD ObjectID, BYTE *Name, ULONG tag1Type, ...);
struct SysObject * AddSysObjectTagList(WORD ClassID, WORD ObjectID, BYTE *Name, struct TagItem *);
APTR   AllocMemBlock(LONG Size, LONG MemType);
LONG   AllocObjectID(void);
void   Armageddon(LONG Key);
ECODE  AttemptExclusive(APTR Object, WORD Ticks);
void   AutoStop(void);
LONG   Awaken(struct DPKTask *);
LONG   CallEventList(LONG ID, APTR Arg1, LONG Arg2);
ECODE  CheckAction(APTR Object, LONG ActionTag);
struct DPKTask * CheckExclusive(APTR Object);
LONG   CheckInit(APTR Object);
LONG   CheckLock(APTR Object);
void   CleanSystem(LONG Flags);
LONG   Clear(APTR Object);
APTR   CloneMemBlock(APTR MemBlock, LONG Flags);
void   CloseDPK(void);
LONG   Copy(APTR Source, APTR Destination);
LONG   CopyStructure(APTR Source, APTR Destination);
LONG   Deactivate(APTR Object);
void   DebugOff(void);
void   DebugOn(void);
LONG   Detach(APTR Object1, APTR Object2);
void   DPKForbid(void);
void   DPKPermit(void);
void   DPrintF(BYTE *Header, const BYTE *, ...);
ECODE  Draw(APTR Object);
ECODE  ErrCode(LONG ErrorCode);
ECODE  Exclusive(APTR Object);
LONG   FastRandom(LONG Range);
struct DPKTask *   FindDPKTask(void);
struct Field *     FindField(APTR Object, LONG FieldID, BYTE *FieldName);
struct Reference * FindReference(LONG ClassID, struct Reference *Reference);
struct SysObject * FindSysName(BYTE *Name, struct SysObject *);
struct SysObject * FindSysObject(WORD ID, struct SysObject *);
LONG   FingerOfDeath(struct DPKTask *);
LONG   Flush(APTR Object);
LONG   Free(APTR Object);
void   FreeExclusive(APTR Object);
LONG   FreeMemBlock(APTR MemBlock);
void   FreeResource(APTR Object, APTR Pointer);
APTR   Get(LONG ID);
APTR   GetByName(BYTE *Name);
APTR   GetContainer(APTR Object);
LONG   GetField(APTR Object, LONG FieldID);
LONG   GetFieldName(APTR Object, BYTE *Name);
LONG   GetMemSize(APTR MemBlock);
LONG   GetMemType(APTR MemBlock);
BYTE * GetExtension(APTR Object);
BYTE * GetFileType(APTR Object);
struct ItemList * GetTypeList(WORD ClassID);
void   Hide(APTR Object);
LONG   Idle(APTR Object);
APTR   Init(APTR Object, APTR Container);
APTR   InitTags(APTR Container, ULONG tag1Type, ...);
APTR   InitTagList(struct TagItem *, APTR Container);
void   InitDestruct(void *DestructCode, APTR DestructStack);
APTR   Load(APTR Source, WORD ID);
APTR   LoadPrefs(struct DPKTask *, BYTE *Name);
LONG   Lock(APTR Object);
LONG   MoveToBack(APTR Object);
LONG   MoveToFront(APTR Object);
struct Module * OpenModule(LONG ID, BYTE *Name);
ECODE  Query(APTR Object);
LONG   Read(APTR Object, APTR Buffer, LONG Length);
APTR   Realloc(APTR Memory, LONG NewSize);
void   RemapKernel(APTR Functions);
void   RemSysEvent(struct Event *);
void   RemSysObject(struct SysObject *);
ECODE  Rename(APTR Object, BYTE *Name);
LONG   Reset(APTR Object);
ECODE  SaveToFile(APTR Object, struct FileName *, BYTE *FileType);
struct DPKTask * SearchForTask(BYTE *Name, struct DPKTask *);
LONG   Seek(APTR Object, LONG Offset, WORD Position);
void   SelfDestruct(void);
APTR   SetContext(APTR Object);
ECODE  SetField(APTR Object, LONG FieldID, LONG Data);
ECODE  SetFieldName(APTR Object, BYTE *Name, LONG Data);
ECODE  Show(APTR Object);
LONG   SlowRandom(LONG Range);
void   StepBack(void);
LONG   Stream(APTR SrcObject, APTR DestObject, LONG Length);
void   OldSwitch(void);
LONG   TagInit(APTR Structure, APTR TagList);
LONG   TotalMem(struct DPKTask *, LONG Flags);
LONG   Unhook(APTR Object, APTR Chain);
void   Unlock(APTR Object);
void   WaitTime(WORD MicroSeconds);
LONG   Write(APTR Object, APTR Buffer, LONG Length);

#else /*** Definition for inline library calls ***/

#define Activate Activate(Object)  (DPKBase->Activate(Object))
#define AddSysEvent(TagList)       (DPKBase->AddSysEvent(TagList))
#define AddSysObject(Cl,Ob,Nm,Tag) (DPKBase->AddSysObject(Cl,Ob,Nm,Tag))
#define AllocMemBlock(Size,MType)  (DPKBase->AllocMemBlock(Size,MType))
#define AllocObjectID()            (DPKBase->AllocObjectID())
#define Armageddon(Key)            (DPKBase->Armageddon(Key))
#define AttemptExclusive(Obj,Tick) (DPKBase->AttemptExclusive(Object,Tick))
#define AutoStop()                 (DPKBase->AutoStop())
#define Awaken(Task)               (DPKBase->Awaken(Task))
#define CallEventList(ID,A1,A2)    (DPKBase->CallEventList(ID,A1,A2))
#define CheckAction(Obj,Action)    (DPKBase->CheckAction(Obj,Action))
#define CheckExclusive(Object)     (DPKBase->CheckExclusive(Object))
#define CheckInit(Obj)             (DPKBase->CheckInit(Obj))
#define CheckLock(Obj)             (DPKBase->CheckLock(Obj))
#define CleanSystem(Flags)         (DPKBase->CleanSystem(Flags))
#define Clear(Obj)                 (DPKBase->Clear(Object))
#define CloneMemBlock(Mem,Flags)   (DPKBase->CloneMemBlock(Mem,Flags))
#define CloseDPK()                 (DPKBase->CloseDPK())
#define Copy(Src,Dest)             (DPKBase->Copy(Src,Dest))
#define CopyStructure(Src,Dest)    (DPKBase->CopyStructure(Source, Destination))
#define Deactivate(Obj)            (DPKBase->Deactivate(Obj))
#define DebugOff()                 (DPKBase->DebugOff())
#define DebugOn()                  (DPKBase->DebugOn())
#define Detach(Obj1,Obj2)          (DPKBase->Detach(Obj1, Obj2))
#define DPKForbid()                (DPKBase->DPKForbid())
#define DPKPermit()                (DPKBase->DPKPermit())
#define Draw(Object)               (DPKBase->Draw(Object))
#define ErrCode(ErrorCode)         (DPKBase->ErrCode(ErrorCode))
#define Exclusive(Object)          (DPKBase->Exclusive(Object))
#define FastRandom(Range)          (DPKBase->FastRandom(Range))
#define FindDPKTask()              (DPKBase->FindDPKTask())
#define FindField(Obj,ID,Name)     (DPKBase->FindField(Obj,ID,Name))
#define FindReference(Class,Rf)    (DPKBase->FindReference(Class,Rf))
#define FindSysName(Name,Sys)      (DPKBase->FindSysName(Name,Sys))
#define FindSysObject(ID,Sys)      (DPKBase->FindSysObject(ID,Sys))
#define FingerOfDeath(Task)        (DPKBase->FingerOfDeath(Task))
#define Flush(Object)              (DPKBase->Flush(Object))
#define Free(Object)               (DPKBase->Free(Object))
#define FreeExclusive(Object)      (DPKBase->FreeExclusive(Object))
#define FreeMemBlock(MemBlock)     (DPKBase->FreeMemBlock(MemBlock))
#define Get(ID)                    (DPKBase->Get(ID))
#define GetByName(Name)            (DPKBase->GetByName(Name))
#define GetField(Obj,ID)           (DPKBase->GetField(Obj,ID))
#define GetFieldName(Obj,Name)     (DPKBase->GetFieldName(Obj,Name))
#define GetMemSize(MemBlock)       (DPKBase->GetMemSize(MemBlock))
#define GetMemType(MemBlock)       (DPKBase->GetMemType(MemBlock))
#define GetExtension(Object)       (DPKBase->GetExtension(Object))
#define GetFileType(Object)        (DPKBase->GetFileType(Object))
#define GetTypeList(ClassID)       (DPKBase->GetTypeList(ClassID))
#define Hide(Object)               (DPKBase->Hide(Object))
#define Init(Object,Container)     (DPKBase->Init(Object, Container))
#define InitTagList(Object,Con)    (DPKBase->Init(Object,Con))
#define InitDestruct(Code,Stck)    (DPKBase->InitDestruct(Code,Stck))
#define Load(Source,ID)            (DPKBase->Load(Source, ID))
#define LoadPrefs(Task, Name)      (DPKBase->LoadPrefs(Task, Name))
#define Lock(Object)               (DPKBase->Lock(Object))
#define MoveToBack(Object)         (DPKBase->MoveToBack(Object))
#define MoveToFront(Object)        (DPKBase->MoveToFront(Object))
#define OpenModule(ID, Name)       (DPKBase->OpenModule(ID,Name))
#define Query(Object)              (DPKBase->Query(Object))
#define Read(Object,Buffer,Len)    (DPKBase->Read(Object,Buffer,Len))
#define Realloc(Memory,NewSize)    (DPKBase->Realloc(Memory,NewSize))
#define RemapKernel(Functions)     (DPKBase->RemapKernel(Functions))
#define RemSysEvent(Event)         (DPKBase->RemSysEvent(Event))
#define RemSysObject(SysObject)    (DPKBase->RemSysObject(SysObject))
#define Rename(Object,Name)        (DPKBase->Rename(Object, Name))
#define Reset(Object)              (DPKBase->Reset(Object))
#define SaveToFile(Obj,Nm,Type)    (DPKBase->SaveToFile(Obj,Nm,Type))
#define SearchForTask(Nm,Task)     (DPKBase->SearchForTask(Nm, Task))
#define Seek(Object,Offset,Pos)    (DPKBase->Seek(Object, Offset, Pos))
#define SelfDestruct()             (DPKBase->SelfDestruct())
#define SetContext(Object)         (DPKBase->SetContext(Object))
#define SetField(Obj,Field,Data)   (DPKBase->SetField(Obj,Field,Data))
#define SetFieldName(Obj,Nm,Data)  (DPKBase->SetFieldName(Obj,Nm,Data))
#define Show(Object)               (DPKBase->Show(Object))
#define SlowRandom(Range)          (DPKBase->SlowRandom(Range))
#define StepBack()                 (DPKBase->StepBack())
#define Stream(Src,Dest,Length)    (DPKBase->Stream(Src,Dest,Length))
#define OldSwitch()                (DPKBase->OldSwitch())
#define TagInit(Structure,Tags)    (DPKBase->TagInit(Structure, Tags))
#define TotalMem(Task,Flags)       (DPKBase->TotalMem(Task, Flags))
#define Unhook(Object,Chain)       (DPKBase->Unhook(Object, Chain))
#define Unlock(Object)             (DPKBase->Unlock(Object))
#define WaitTime(Micro)            (DPKBase->WaitTime(Micro))
#define Write(Object,Buffer,Ln)    (DPKBase->Write(Object,Buffer,Ln))

/*** Non-inline calls (necessary for tags) ***/

APTR InitTags(APTR Container, ULONG tag1Type, ...) {
  return(DPKBase->Init(Container, &tag1Type));
}
void DPrintF(BYTE *Header, ULONG String, ...) {
  DPKBase->DPrintF(Header, (BYTE *)&String);
}
struct SysObject * AddSysObjectTags(WORD ClassID, WORD ObjectID, BYTE *Name, ULONG tag1Type, ...) {
  return(DPKBase->AddSysObject(ClassID, ObjectID, Name, &tag1Type));
}
struct Event * AddSysEventTags(ULONG tag1Type, ...) {
  return(DPKBase->AddSysEvent(&tag1Type));
}
#endif

#endif /* CLIB_DPKERNEL_PROTOS_H */
