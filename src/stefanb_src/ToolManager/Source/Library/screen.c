/*
 * screen.c  V3.1
 *
 * ToolManager ScreenNotify handling routines
 *
 * Copyright (C) 1990-98 Stefan Becker
 *
 * This source code is for educational purposes only. You may study it
 * and copy ideas or algorithms from it for your own projects. It is
 * not allowed to use any of the source codes (in full or in parts)
 * in other programs. Especially it is not allowed to create variants
 * of ToolManager or ToolManager-like programs from this source code.
 *
 */

#include "toolmanager.h"

/* Local data */
static const char      WorkbenchName[]       = "Workbench";
static struct MsgPort *ScreenNotifyPort      = NULL;
static ULONG           ScreenNotifyLockCount = 0;
static struct Library *ScreenNotifyBase      = NULL;
static APTR            CloseScreenHandle;
static APTR            PubScreenHandle;
static APTR            WorkbenchHandle;

/* Start ScreenNotify */
#define DEBUGFUNCTION StartScreenNotify
LONG StartScreenNotify(void)
{
 LONG rc = -1;

 SCREEN_LOG(LOG0(Entry))

 /* Allocate message port */
 if (ScreenNotifyPort = CreateMsgPort()) rc = ScreenNotifyPort->mp_SigBit;

 SCREEN_LOG(LOG2(Result, "Port 0x%08lx Signal %ld", ScreenNotifyPort, rc))

 return(rc);
}

/* Stop ScreenNotify */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION StopScreenNotify
void StopScreenNotify(void)
{
 SCREEN_LOG(LOG1(Port, "0x%08lx", ScreenNotifyPort))

 DeleteMsgPort(ScreenNotifyPort);
}

/* Lock ScreenNotify */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION LockScreenNotify
void LockScreenNotify(void)
{
 /* ScreenNotify already opened? */
 if (ScreenNotifyBase != NULL)

  /* Yes, increment lock count */
  ScreenNotifyLockCount++;

 /* No, open it */
 else if (ScreenNotifyBase = OpenLibrary("screennotify.library", 0)) {

  /* Add clients */
  CloseScreenHandle = AddCloseScreenClient(NULL, ScreenNotifyPort, 0);
  PubScreenHandle   = AddPubScreenClient(ScreenNotifyPort, 0);
  WorkbenchHandle   = AddWorkbenchClient(ScreenNotifyPort, 0);

  /* Set lock count to 1 */
  ScreenNotifyLockCount = 1;
 }
}

/* Release ScreenNotify */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ReleaseScreenNotify
void ReleaseScreenNotify(void)
{
 /* ScreenNotify already opened and lock count reaches zero? */
 if ((ScreenNotifyBase != NULL) && (--ScreenNotifyLockCount == 0)) {

  /* Remove clients */
  if (CloseScreenHandle)
   while (RemCloseScreenClient(CloseScreenHandle) == FALSE) Delay(10);
  if (PubScreenHandle)
   while (RemPubScreenClient(PubScreenHandle) == FALSE)     Delay(10);
  if (WorkbenchHandle)
   while (RemWorkbenchClient(WorkbenchHandle) == FALSE)     Delay(10);

  /* Close library */
  CloseLibrary(ScreenNotifyBase);

  /* Reset library base pointer */
  ScreenNotifyBase = NULL;
 }
}

/* Forward screen event to dock objects */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ScreenEvent
static void ScreenEvent(ULONG type, ULONG MethodID, void *data)
{
 struct MinNode *n = GetHead(GetHandleList());

 SCREEN_LOG(LOG3(Arguments, "Type %ld Method 0x%08lx 0x%08lx",
                 type, MethodID, data))

 /* Traverse handle list */
 while (n) {
  Object *obj1 = (Object *) TMHANDLE(n)->tmh_ObjectLists[type].mlh_Head;
  Object *obj2;

  SCREEN_LOG(LOG1(Handle, "0x%08lx", n))

  /* Scan 'type' object list */
  while (obj2 = NextObject(&obj1)) {

   SCREEN_LOG(LOG1(Object, "0x%08lx", obj2))

   /* Send screen open/close method to object */
   DoMethod(obj2, MethodID, data);
  }

  /* Get next entry in handle list */
  n = GetSucc(n);
 }
}

/* Handle ScreenNotify event */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION HandleScreenNotify
void HandleScreenNotify(void)
{
 struct ScreenNotifyMessage *snm;

 SCREEN_LOG(LOG0(Entry))

 /* Retrieve message from port */
 while (snm = (struct ScreenNotifyMessage *) GetMsg(ScreenNotifyPort)) {

  /* Which event? */
  switch (snm->snm_Type) {
   case SCREENNOTIFY_TYPE_CLOSESCREEN:
    /* Close docks first */
    ScreenEvent(TMOBJTYPE_DOCK, TMM_ScreenClose, snm->snm_Value);

    /* Then remove entries from image cache */
    ScreenEvent(TMOBJTYPE_IMAGE, TMM_ScreenClose, snm->snm_Value);
    break;

   case SCREENNOTIFY_TYPE_PUBLICSCREEN:
    ScreenEvent(TMOBJTYPE_DOCK, TMM_ScreenOpen,
                ((struct PubScreenNode *) snm->snm_Value)->psn_Node.ln_Name);
    break;

   case SCREENNOTIFY_TYPE_PRIVATESCREEN:
    ScreenEvent(TMOBJTYPE_DOCK, TMM_ScreenClose,
                ((struct PubScreenNode *) snm->snm_Value)->psn_Screen);
    break;

   case SCREENNOTIFY_TYPE_WORKBENCH:
    /* Close or open event? */
    switch (snm->snm_Value) {
     case FALSE: {            /* Close event */
       struct Screen *s;

       /* Lock Workbench screen */
       if (s = LockPubScreen(WorkbenchName)) {
        /* Close docks */
        ScreenEvent(TMOBJTYPE_DOCK, TMM_ScreenClose, s);

        /* Remove entries from image cache */
        ScreenEvent(TMOBJTYPE_IMAGE, TMM_ScreenClose, s);

        /* Unlock Workbench screen */
        UnlockPubScreen(NULL, s);
       }
      }
      break;

     case TRUE:               /* Open event */
      ScreenEvent(TMOBJTYPE_DOCK, TMM_ScreenOpen, WorkbenchName);
      break;
    }
    break;
  }

  /* Reply message */
  ReplyMsg((struct Message *) snm);
 }
}
