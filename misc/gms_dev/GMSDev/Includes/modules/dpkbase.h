#ifndef MODULES_DPKBASE_H
#define MODULES_DPKBASE_H

/*
**  $VER: dpkbase.h V1.0
**
**  Definition of the DPKBase structure for making calls to the kernel.
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
*/

#ifndef DPKERNEL_H
#include <dpkernel/dpkernel.h>
#endif

/*****************************************************************************
** DPKBase structure.
*/

typedef struct DPKBase {
  LIBPTR ECODE  (*Activate)(mreg(__a0) APTR Object);
  LIBPTR struct Event * (*AddSysEvent)(mreg(__a0) APTR TagList);
  LIBPTR struct SysObject * (*AddSysObject)(mreg(__d0) WORD ClassID, mreg(__d1) WORD ObjectID, mreg(__a1) BYTE *Name, mreg(__a0) APTR TagList);
  LIBPTR LONG   (*AddTrack)(mreg(__d0) LONG Resource, mreg(__d3) LONG Data, mreg(__a0) APTR Routine);
  LIBPTR APTR   (*AllocMemBlock)(mreg(__d0) LONG Size, mreg(__d1) LONG MemType);
  LIBPTR void   (*Armageddon)(mreg(__d0) LONG Key);
  LIBPTR ECODE  (*AttemptExclusive)(mreg(__a0) APTR Object, mreg(__d0) WORD Ticks);
  LIBPTR void   (*AutoStop)(void);
  LIBPTR LONG   (*Awaken)(mreg(__a0) struct DPKTask *);
  LIBPTR LONG   (*CallEventList)(mreg(__d0) LONG ID, mreg(__a0) APTR Arg1, mreg(__d1) LONG Arg2);
  LIBPTR ECODE  (*CheckAction)(mreg(__a0) APTR Object, mreg(__a1) LONG ActionTag);
  LIBPTR struct DPKTask * (*CheckExclusive)(mreg(__a0) APTR Object);
  LIBPTR LONG   (*CheckInit)(mreg(__a0) APTR Object);
  LIBPTR LONG   (*CheckLock)(mreg(__a0) APTR Object);
  LIBPTR LONG   (*Clear)(mreg(__a0) APTR Object);
  LIBPTR void   (*CloseDPK)(void);
  LIBPTR LONG   (*Copy)(mreg(__a0) APTR Source, mreg(__a1) APTR Destination);
  LIBPTR LONG   (*CopyStructure)(mreg(__a0) APTR Source, mreg(__a1) APTR Destination);
  LIBPTR LONG   (*Deactivate)(mreg(__a0) APTR Object);
  LIBPTR void   (*DeleteTrack)(mreg(__d1) LONG Key);
  LIBPTR LONG   (*Detach)(mreg(__a0) APTR Object1, mreg(__a1) APTR Object2);
  LIBPTR void   (*DPKForbid)(void);
  LIBPTR void   (*DPKPermit)(void);
  LIBPTR void   (*DPrintF)(mreg(__a4) BYTE *Header, mreg(__a5) const BYTE *, ...);
  LIBPTR ECODE  (*Draw)(mreg(__a0) APTR Object);
  LIBPTR ECODE  (*ErrCode)(mreg(__d0) LONG ErrorCode);
  LIBPTR ECODE  (*Exclusive)(mreg(__a0) APTR Object);
  LIBPTR LONG   (*FastRandom)(mreg(__d1) LONG Range);
  LIBPTR struct DPKTask *   (*FindDPKTask)(void);
  LIBPTR struct SysObject * (*FindSysObject)(mreg(__d0) WORD ID, mreg(__a0) struct SysObject *);
  LIBPTR LONG   (*FingerOfDeath)(mreg(__a0) struct DPKTask *);
  LIBPTR LONG   (*Flush)(mreg(__a0) APTR Object);
  LIBPTR void   (*Free)(mreg(__a0) APTR Object);
  LIBPTR void   (*FreeExclusive)(mreg(__a0) APTR Object);
  LIBPTR void   (*FreeMemBlock)(mreg(__d0) APTR MemBlock);
  LIBPTR APTR   (*Get)(mreg(__d0) LONG ID);
  LIBPTR LONG   (*GetMemSize)(mreg(__a0) APTR MemBlock);
  LIBPTR LONG   (*GetMemType)(mreg(__a0) APTR MemBlock);
  LIBPTR BYTE * (*GetExtension)(mreg(__a0) APTR Object);
  LIBPTR BYTE * (*GetFileType)(mreg(__a0) APTR Object);
  LIBPTR struct ItemList * (*GetTypeList)(mreg(__d0) WORD ClassID);
  LIBPTR void   (*Hide)(mreg(__a0) APTR Object);
  LIBPTR APTR   (*Init)(mreg(__a0) APTR Object, mreg(__a1) APTR Container);
  LIBPTR void   (*InitDestruct)(mreg(__a0) void *DestructCode, mreg(__a1) APTR DestructStack);
  LIBPTR APTR   (*Load)(mreg(__a0) APTR Source, mreg(__d0) WORD ID);
  LIBPTR APTR   (*LoadPrefs)(mreg(__a0) struct DPKTask *, mreg(__a1) BYTE *Name);
  LIBPTR LONG   (*Lock)(mreg(__a0) APTR Object);
  LIBPTR LONG   (*MoveToBack)(mreg(__a0) APTR Object);
  LIBPTR LONG   (*MoveToFront)(mreg(__a0) APTR Object);
  LIBPTR struct Module * (*OpenModule)(mreg(__d0) LONG ID, mreg(__a0) BYTE *Name);
  LIBPTR ECODE  (*Query)(mreg(__a0) APTR Object);
  LIBPTR LONG   (*Read)(mreg(__a0) APTR Object, mreg(__a1) APTR Buffer, mreg(__d0) LONG Length);
  LIBPTR APTR   (*Realloc)(mreg(__a0) APTR Memory, mreg(__d0) LONG NewSize);
  LIBPTR void   (*RemapKernel)(mreg(__a0) APTR Functions);
  LIBPTR void   (*RemSysEvent)(mreg(__a0) struct Event *);
  LIBPTR void   (*RemSysObject)(mreg(__a0) struct SysObject *);
  LIBPTR ECODE  (*Rename)(mreg(__a0) APTR Object, mreg(__a1) BYTE *Name);
  LIBPTR LONG   (*Reset)(mreg(__a0) APTR Object);
  LIBPTR ECODE  (*SaveToFile)(mreg(__a0) APTR Object, mreg(__a1) struct FileName *, mreg(__a2) BYTE *FileType);
  LIBPTR struct DPKTask * (*SearchForTask)(mreg(__a0) BYTE *Name, mreg(__a1) struct DPKTask *);
  LIBPTR LONG   (*Seek)(mreg(__a0) APTR Object, mreg(__d0) LONG Offset, mreg(__d1) WORD Position);
  LIBPTR void   (*SelfDestruct)(void);
  LIBPTR ECODE  (*Show)(mreg(__a0) APTR Object);
  LIBPTR LONG   (*SlowRandom)(mreg(__d1) LONG Range);
  LIBPTR void   (*StepBack)(void);
  LIBPTR LONG   (*Stream)(mreg(__a0) APTR SrcObject, mreg(__a1) APTR DestObject, mreg(__d0) LONG Length);
  LIBPTR void   (*OldSwitch)(void);
  LIBPTR LONG   (*TagInit)(mreg(__a0) APTR Structure, mreg(__a1) APTR TagList);
  LIBPTR LONG   (*TotalMem)(mreg(__a0) struct DPKTask *, mreg(__d0) LONG Flags);
  LIBPTR LONG   (*Unhook)(mreg(__a0) APTR Object, mreg(__a1) APTR Chain);
  LIBPTR void   (*Unlock)(mreg(__a0) APTR Object);
  LIBPTR void   (*WaitTime)(mreg(__d0) WORD MicroSeconds);
  LIBPTR LONG   (*Write)(mreg(__a0) APTR Object, mreg(__a1) APTR Buffer, mreg(__d0) LONG Length);
  LIBPTR LONG   (*AllocObjectID)(void);
  LIBPTR struct Reference * (*FindReference)(mreg(__d0) LONG ClassID, mreg(__a0) struct Reference *);
  LIBPTR struct SysObject * (*FindSysObjectName)(mreg(__a0) BYTE *Name);
  LIBPTR APTR   (*GetByName)(mreg(__a0) BYTE *Name);
  LIBPTR LONG   (*SetDebug)(mreg(__d0) APTR DPrintF, mreg(__d1) APTR DebugMsg);
} OBJ_DPKBASE;

#endif /* MODULES_DPKBASE_H */
