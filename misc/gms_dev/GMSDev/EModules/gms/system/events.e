/*
**  $VER: events.e
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
**
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'gms/dpkernel/dpkernel','gms/system/register','gms/system/tasks'

/*****************************************************************************
** The Event Node.
*/

CONST TAGS_EVENT = $FFFB0000 OR ID_EVENT

OBJECT event
  head[1]  :ARRAY OF head
  next     :PTR TO event
  prev     :PTR TO event
  args     :PTR TO LONG
  priority :INT
  type     :INT
  flags    :LONG
  routine  :LONG
  task     :LONG
ENDOBJECT

/* Event Structure Tags */

CONST EVA_Args     = TAPTR OR 20,
      EVA_Priority = TWORD OR 24,
      EVA_Type     = TWORD OR 26,
      EVA_Flags    = TLONG OR 28,
      EVA_Routine  = TAPTR OR 32

/*****************************************************************************
** Event->Flags
*/

#define EVF_GLOBAL $00000001  /* Always call if event occurs (default) */
#define EVF_TASK   $00000002  /* Only call if I am the active task */

/*****************************************************************************
** Return flags that can be returned by Event->Routine(), these are acted
** on by CallEventList()
*/

#define EVR_BREAK $00000001  /* Do not execute any more events */
#define EVR_FAIL  $00000002  /* Return immediately (failure) */

/*****************************************************************************
** Available event types.
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

