#ifndef SYSTEM_EVENTS_H
#define SYSTEM_EVENTS_H TRUE

/*
**  $VER: events.h
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
**
*/

#ifndef DPKERNEL_H
#include <dpkernel/dpkernel.h>
#endif

/*****************************************************************************
** Event object.
*/

#define VER_EVENT  1
#define TAGS_EVENT ((ID_SPCTAGS<<16)|ID_EVENT)

struct Event {
  struct Head Head;         /* [00] [--] Standard header */
  struct Event *Next;       /* [12] [--] Next event node */
  struct Event *Prev;       /* [16] [--] Previous event node */
  LONG   *Args;             /* [20] [RI] Event arguments */
  WORD   Priority;          /* [24] [RI] Sets position in the event chain */
  WORD   Type;              /* [26] [RI] Event number */
  LONG   Flags;             /* [28] [RI] Special flags */
  LIBPTR LONG (*Routine)(mreg(__a0) APTR, mreg(__d0) LONG);
  struct DPKTask *Task;     /* [36] [--] Used for EVF_TASK */
};

/*** Event Structure Tags ***/

#define EVA_Args     (TAPTR|20)
#define EVA_Priority (TWORD|24)
#define EVA_Type     (TWORD|26)
#define EVA_Flags    (TLONG|28)
#define EVA_Routine  (TAPTR|32)

/*****************************************************************************
** Event->Flags
*/

#define EVF_GLOBAL 0x00000001  /* Always call if event occurs (default) */
#define EVF_TASK   0x00000002  /* Only call if I am the active task */

/*****************************************************************************
** Return flags that can be returned by Event->Routine(), these are acted
** on by CallEventList()
*/

#define EVR_BREAK 0x00000001  /* Do not execute any more events */
#define EVR_FAIL  0x00000002  /* Return immediately (failure) */

/*****************************************************************************
** Available Event->Types.
*/

#define EVT_OnNewTask        1 /* A new task is appearing */
#define EVT_OnRemTask        2 /* An existing task is being removed */
#define EVT_ScreenToFront    3 /* Receives: <Screen> */
#define EVT_ScreenToBack     4 /* Receives: <Screen> */
#define EVT_ScreenDisplayed  5 /* Receives: <Screen> */
#define EVT_ScreenHidden     6 /* Receives: <Screen> */
#define EVT_DiskInsert       7 /* Disk inserted by user */
#define EVT_DiskRemove       8 /* Disk removed by user */
#define EVT_SelfDestruct     9 /* Receives: <Task> */
#define EVT_LowMemory       10 /* Args: <PercentageLeft> */
#define EVT_SystemDisable   11 /* Switching between operating systems */
#define EVT_SystemEnable    12 /* Switching between operating systems */
#define EVT_UserFocus       13 /* When the user focuses on a new task */

#define EVT_END          200  /* Maximum amount of events for this version */

#endif /* SYSTEM_EVENTS_H */
