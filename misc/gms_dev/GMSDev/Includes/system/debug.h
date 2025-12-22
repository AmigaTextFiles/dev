#ifndef SYSTEM_DEBUG_H
#define SYSTEM_DEBUG_H 1

/*
**  $VER: debug.h
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
*/

#ifndef DPKERNEL_H
#include <dpkernel/dpkernel.h>
#endif

struct DebugMsg {
  LIBPTR void (*Unhook)(mreg(__a0) APTR Object, mreg(__a1) APTR Chain);
  LIBPTR void (*Detach)(mreg(__a0) APTR Child, mreg(__a1) APTR Parent);
  LIBPTR void (*Reset)(mreg(__a0) APTR Object);
  LIBPTR void (*DPKOpened)(void);
  LIBPTR void (*DPKClosed)(void);
  LIBPTR void (*AddSysEvent)(mreg(__a0) LONG *Tags);
  LIBPTR void (*AddInputHandler)(void);
  LIBPTR void (*AllocAudio)(void);
  LIBPTR void (*AllocBlitter)(void);
  LIBPTR void (*AllocBlitMem)(mreg(__d0)  LONG Size, mreg(__d1) LONG Flags, mreg(__d2) APTR Address);
  LIBPTR void (*AllocMemBlock)(mreg(__d0) LONG Size, mreg(__d1) LONG Flags, mreg(__d2) APTR Address);
  LIBPTR void (*AllocSoundMem)(mreg(__d0) LONG Size, mreg(__d1) LONG Flags, mreg(__d2) APTR Address);
  LIBPTR void (*AllocVideoMem)(mreg(__d0) LONG Size, mreg(__d1) LONG Flags, mreg(__d2) APTR Address);
  LIBPTR void (*Awaken)(mreg(__a0) struct DPKTask *);
  LIBPTR void (*BlankOff)(void);
  LIBPTR void (*BlankOn)(void);
  LIBPTR void (*CopyStructure)(mreg(__a0) APTR Source, mreg(__a1) APTR Dest);
  LIBPTR void (*CreateMasks)(mreg(__a0) struct Bob *);
  LIBPTR void (*Show)(mreg(__a0) APTR Object);
  LIBPTR void (*RemSysEvent)(mreg(__a0) struct Event *Event);
  LIBPTR void (*FingerOfDeath)(mreg(__a0) struct DPKTask *);
  LIBPTR void (*Free)(mreg(__a0) APTR Object);
  LIBPTR void (*FreeAudio)(void);
  LIBPTR void (*FreeBlitter)(void);
  LIBPTR void (*FreeMemBlock)(mreg(__a0) APTR MemBlock);
  LIBPTR void (*Get)(mreg(__d0) LONG ID);
  LIBPTR void (*GetFileObject)(mreg(__a0) APTR Object, mreg(__a1) BYTE *Name);
  LIBPTR void (*GetFileObjectList)(mreg(__a0) APTR Object, mreg(__a1) APTR List);
  LIBPTR void (*Hide)(mreg(__a0) APTR Object);
  LIBPTR void (*Init)(mreg(__a0) APTR Object, mreg(__a1) APTR Container);
  LIBPTR void (*InitDestruct)(mreg(__a0) APTR Code, mreg(__a1) APTR Stack);
  LIBPTR void (*Load)(mreg(__a0) APTR Source, mreg(__d0) LONG ObjectID);
  LIBPTR void (*MoveToBack)(mreg(__a0) APTR Object);
  LIBPTR void (*MoveToFront)(mreg(__a0) APTR Object);
  LIBPTR void (*OpenFile)(mreg(__a0) APTR Source, mreg(__d0) LONG Flags);
  LIBPTR void (*RemInputHandler)(void);
  LIBPTR void (*ReturnDisplay)(void);
  LIBPTR void (*SetBobFrames)(mreg(__a0) struct Bob *);
  LIBPTR void (*SelfDestruct)(void);
  LIBPTR void (*Switch)(void);
  LIBPTR void (*TakeDisplay)(mreg(__a0) struct GScreen *);
  LIBPTR void (*Flush)(mreg(__a0) APTR Object);
  LIBPTR void (*SaveToFile)(mreg(__a0) APTR Object, mreg(__a1) APTR FileName, mreg(__a2) BYTE *FileType);
  LIBPTR void (*CallEventList)(mreg(__d0) WORD ID, mreg(__a0) APTR Arg1, mreg(__d1) LONG Arg2);
  LIBPTR void (*Read)(mreg(__a0) struct Head *Object, mreg(__a1) APTR Buffer, mreg(__d0) LONG Length);
  LIBPTR void (*Write)(mreg(__a0) struct Head *Object, mreg(__a1) APTR Buffer, mreg(__d0) LONG Length);
};

#endif  /* SYSTEM_DEBUG_H */

