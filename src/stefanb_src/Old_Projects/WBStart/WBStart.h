/*
 * WBStart.h   V1.4
 *
 * WBStart-Handler data structure definition
 *
 * (c) 1991-93 by Stefan Becker
 *
 */

#include <dos/dos.h>
#include <exec/ports.h>
#include <workbench/startup.h>

/* Structure to send to the WBStart-Handler message port                   */
/* - wbsm_Name should be relative to wbsm_DirLock                          */
/* - wbsm_Stack is used as return field (TRUE == program has been started) */
struct WBStartMsg {
                   struct Message  wbsm_Msg;
                   char           *wbsm_Name;    /* Name of the program */
                   BPTR            wbsm_DirLock; /* Directory lock */
                   ULONG           wbsm_Stack;   /* Stack size */
                   LONG            wbsm_Prio;    /* Process priority */
                   ULONG           wbsm_NumArgs; /* # of Args in ArgList */
                   struct WBArg   *wbsm_ArgList; /* Pointer to Arguments */
                  };

/* Name of the handler message port */
#define WBS_PORTNAME "WBStart-Handler Port"

/* Default name for the WBStart-Handler binary */
#define WBS_LOADNAME "L:WBStart-Handler"
