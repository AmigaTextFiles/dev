#ifndef SYSTEM_GLOBALBASE_H
#define SYSTEM_GLOBALBASE_H

/*
**  $VER: globalbase.h
**
**  Definition of the dpkernel's global variables structure.
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved
*/

#ifndef DPKERNEL_H
#include <dpkernel/dpkernel.h>
#endif

#ifndef EXEC_LIBRARIES_H
  #ifdef MACHINE_AMIGA
    #include <exec/libraries.h>
  #else
    struct Node {
      struct  Node *ln_Succ;  /* Pointer to next (successor) */
      struct  Node *ln_Pred;  /* Pointer to previous (predecessor) */
      UBYTE   ln_Type;
      BYTE    ln_Pri;         /* Priority, for sorting */
      char    *ln_Name;       /* ID string, null terminated */
    };  /* Note: word aligned */

    struct Library {
      struct  Node lib_Node;
      UBYTE   lib_Flags;
      UBYTE   lib_pad;
      UWORD   lib_NegSize;   /* number of bytes before library */
      UWORD   lib_PosSize;   /* number of bytes after library */
      UWORD   lib_Version;   /* major */
      UWORD   lib_Revision;  /* minor */
      APTR    lib_IdString;  /* ASCII identification */
      ULONG   lib_Sum;       /* the checksum itself */
      UWORD   lib_OpenCnt;   /* number of current opens */
    };                       /* Warning: size is not a longword multiple! */
  #endif
#endif

/*****************************************************************************
** All fields in this structure are private.  This file is included in the
** developers archive for module writers and debugging purposes only.
*/

struct GVBase {
  struct Library LibNode;
  WORD   ScreenFlip;                /* Private */
  APTR   SegList;                   /* Private */
  LIBPTR ULONG (*DPrintF)(mreg(__a4) BYTE *Header, mreg(__a5) LONG *array);
  WORD   ded3;                      /* Private */
  WORD   OwnBlitter;                /* 0 = FALSE, 1 = TRUE */
  WORD   VBLPosition;               /* Private */
  BYTE   Switch;                    /* Private */
  BYTE   Destruct;                  /* Private */
  LONG   RandomSeed;                /* Random seed */
  WORD   BlitterUsed;               /* 0 = Free, 1 = Grabbed */
  WORD   BlitterPriority;           /* 0 = NoPriority, 1 = Priority */
  struct GScreen *CurrentScreen;    /* Currently displayed screen */
  LONG   Ticks;                     /* Vertical blank ticks counter */
  WORD   HSync;                     /* Private */
  struct SysObject *SysObjects;     /* System object list (master) */
  BYTE   DebugActive;               /* Set if debugger is currently active */
  BYTE   ScrBlanked;                /* Set if screen is currently blanked */
  WORD   Version;                   /* The version of this kernel */
  WORD   Revision;                  /* The revision of this kernel */
  struct SScreen   *ScreenList;     /* List of shown screens, starting from back. */
  struct SysObject *ChildObjects;   /* System object list (hidden & children) */
  struct DPKTask   *SystemTask;     /* System task */
  struct Reference *ReferenceList;  /* List of object references */
  struct Module    *ScreensModule;  /* Pointer to module */
  struct Module    *BlitterModule;  /* Pointer to module */
  struct Module    *FileModule;     /* Pointer to module */
  struct Module    *KeyModule;      /* Pointer to module */
  APTR   ScreensBase;               /* */
  APTR   BlitterBase;               /* */
  APTR   FileBase;                  /* */
  APTR   KeyBase;                   /* */
  struct Module   *SoundModule;     /* Pointer to module */
  APTR   SoundBase;                 /* */
  struct ModEntry *ModList;         /* List of modules */
  struct Event    **EventArray;     /* Event array */
  LONG   FlipSignal;                /* Signal mask */
  struct DPKTask  *UserFocus;       /* Task that currently has the user focus. */
  struct DebugMsg *Debug;           /* Debug routines */
  struct DPKTask  **TaskList;       /* Pointer to an array of all our tasks */
  struct Module   *ConfigModule;    /* Pointer to module */
};

struct SScreen {
  struct SScreen *Next;
  struct GScreen *Screen;
};

#endif /* SYSTEM_GLOBALBASE_H */
