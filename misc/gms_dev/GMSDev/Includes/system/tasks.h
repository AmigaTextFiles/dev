#ifndef SYSTEM_TASKS_H
#define SYSTEM_TASKS_H TRUE

/*
**  $VER: tasks.h
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
*/

#ifndef DPKERNEL_H
#include <dpkernel/dpkernel.h>
#endif

/****************************************************************************
** Task object.
*/

#define VER_TASK  2
#define TAGS_TASK ((ID_SPCTAGS<<16)|ID_TASK)

struct  DPKTask {
  struct Head Head;                  /* 000 [R-] Standard header */
  APTR   UserData;                   /* 012 [RW] Pointer to user data, no restrictions */
  BYTE   *Name;                      /* 016 [RI] Name of the task, if specified */
  struct MasterPrefs  *MasterPrefs;  /* 020 [--] Library preferences */
  struct ScreenPrefs  *ScreenPrefs;  /* 024 [--] Screen preferences */
  struct SoundPrefs   *SoundPrefs;   /* 028 [--] Sound preferences */
  struct BlitterPrefs *BlitterPrefs; /* 032 [--] Blitter preferences */
  APTR   emptyResourceChain001;      /* 036 [--] */
  LONG   ReqStatus;                  /* 040 [--] Private, used internally */
  LONG   BlitKey;                    /* 044 [--] Resource key */
  LONG   AudioKey;                   /* 048 [--] Resource key */
  APTR   ExecNode;                   /* 052 [--] Task's exec node */
  APTR   DestructStack;              /* 056 [--] Stack to use for DestructCode */
  APTR   DestructCode;               /* 060 [--] Pointer to self destruct code routine */
  BYTE   AlertState;                 /* 064 [--] Private */
  BYTE   Switched;                   /* 065 [--] Set if task is in Switch() */
  WORD   DebugStep;                  /* 066 [--] Debug tree stepping position */
  BYTE   AwakeSig;                   /* 068 [--] Signal for waking this task */
  BYTE   Pad;                        /* 069 [--] Reserved */
  WORD   DPKTable;                   /* 070 [-I] Type of jump table from DPK */
  LONG   emptyTotalData002;          /* 072 [--] */
  LONG   emptyTotalVideo003;         /* 076 [--] */
  LONG   emptyTotalSound004;         /* 080 [--] */
  LONG   emptyTotalBlit005;          /* 084 [--] */
  APTR   Code;                       /* 088 [-I] Start of program */
  BYTE   *Preferences;               /* 092 [--] Preferences directory */
  LONG   DPKBase;                    /* 096 [R-] DPKBase */
  BYTE   *Author;                    /* 100 [RI] Who wrote the program */
  BYTE   *Date;                      /* 104 [RI] Date of compilation */
  BYTE   *Copyright;                 /* 108 [RI] Copyright details */
  BYTE   *Short;                     /* 112 [RI] Short description of program */
  WORD   MinDPKVersion;              /* 116 [R-] Minimum required DPKernel version */
  WORD   MinDPKRevision;             /* 118 [R-] Minimum required DPKernel revision */
  struct GVBase *GVBase;             /* 120 [R-] GVBase */
  BYTE   *Args;                      /* 124 [RI] Pointer to argument string */
  APTR   Source;                     /* 128 [RI] Where to load the task from */
  BYTE   *prvName;                   /* 132 [--] Memory location of name memory */
  WORD   DebugState;                 /* 136 [RW] Debug On/Off */
  struct Head *prvContext;           /* 138 [--] Pointer to object in current context */
};

#define TSK_Name      (TAPTR|16)
#define TSK_DPKTable  (TWORD|70)
#define TSK_Code      (TAPTR|88)
#define TSK_Author    (TAPTR|100)
#define TSK_Date      (TAPTR|104)
#define TSK_Copyright (TAPTR|108)
#define TSK_Short     (TAPTR|112)
#define TSK_Args      (TAPTR|124)
#define TSK_Source    (TAPTR|128)

#define CS_OCS 0
#define CS_ECS 1
#define CS_AGA 2

#endif /* SYSTEM_TASKS_H */
