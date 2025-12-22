/*
 * appmsgs.c  V3.1
 *
 * ToolManager WB application messages handling routines
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
static ULONG           WBLockCount     = 0;
static struct Library *WorkbenchBase   = NULL;
static struct MsgPort *AppMessagesPort;

/* Activate WB application messages */
#define DEBUGFUNCTION StartAppMessages
LONG StartAppMessages(void)
{
 LONG rc = -1;

 APPMSGS_LOG(LOG0(Entry))

 /* Allocate message port */
 if (AppMessagesPort = CreateMsgPort()) rc = AppMessagesPort->mp_SigBit;

 APPMSGS_LOG(LOG2(Result, "Port 0x%08lx Signal %ld", AppMessagesPort, rc))

 return(rc);
}

/* Stop WB application messages */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION StopAppMessages
void StopAppMessages(void)
{
 APPMSGS_LOG(LOG1(Port, "0x%08lx", AppMessagesPort))

 SafeDeleteMsgPort(AppMessagesPort);
}

/* Handle WB application messages */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION HandleAppMessages
void HandleAppMessages(void)
{
 struct AppMessage *msg;

 APPMSGS_LOG(LOG0(Entry))

 /* Empty message queue */
 while (msg = (struct AppMessage *) GetMsg(AppMessagesPort)) {

  APPMSGS_LOG(LOG2(Activating, "Object 0x%08lx Args 0x%08lx", msg->am_ID, msg))

  /* Activate object */
  DoMethod((Object *) msg->am_ID, TMM_Activate, msg);

  /* Reply message */
  ReplyMsg((struct Message *) msg);
 }
}

/* Open workbench.library */
static BOOL LockWorkbench(void)
{
 BOOL rc;

 /* Workbench already opened or can we open it? */
 if (rc = (WorkbenchBase != NULL) ||
          (WorkbenchBase = OpenLibrary("workbench.library", 39)))

  /* Increment lock counter */
  WBLockCount++;

 return(rc);
}

/* Close workbench.library */
static void ReleaseWorkbench(void)
{
 /* Decrement lock counter */
 if (--WBLockCount == 0) {

  /* Lock count is zero, close library */
  CloseLibrary(WorkbenchBase);

  /* Reset library base pointer */
  WorkbenchBase = NULL;
 }
}

/* Remove all associated messages from the message port */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION RemoveAppMessages
static void RemoveAppMessages(Object *obj)
{
 struct AppMessage *msg;

 APPMSGS_LOG(LOG1(Object, "0x%08lx", obj))

 /* Disable multi-tasking */
 Forbid();

 /* Scan message port list */
 msg = (struct AppMessage *) GetHead((struct MinList *) &AppMessagesPort
                                       ->mp_MsgList);
 while (msg) {
  struct AppMessage *nextmsg = (struct AppMessage *)
                                GetSucc((struct MinNode *) msg);

  /* Does the message point to this object? */
  if ((Object *) msg->am_ID == obj) {

   /* Remove it from list */
   Remove((struct Node *) msg);

   /* Reply it */
   ReplyMsg((struct Message *) msg);
  }

  /* Next message */
  msg = nextmsg;
 }

 /* Enable multi-tasking */
 Permit();

 /* Release Workbench */
 ReleaseWorkbench();
}

/* Create WB menu item */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CreateAppMenuItem
void *CreateAppMenuItem(Object *obj)
{
 void *rc = NULL;

 APPMSGS_LOG(LOG1(Arguments, "Object 0x%08lx", obj))

 /* Lock Workbench */
 if (LockWorkbench()) {
  char *name;

  APPMSGS_LOG(LOG0(WB locked))

  /* Get name from object */
  GetAttr(TMA_ObjectName, obj, (ULONG *) &name);

  APPMSGS_LOG(LOG2(Name, "'%s' (0x%08lx)", name, name))

  /* Create menu item */
  if ((rc = AddAppMenuItemA((ULONG) obj, 0, name, AppMessagesPort, NULL))
       == NULL)

   /* Error, release workbench */
   ReleaseWorkbench();
 }

 APPMSGS_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}

/* Delete WB menu item */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DeleteAppMenuItem
void DeleteAppMenuItem(void *appobj, Object *obj)
{
 APPMSGS_LOG(LOG2(Arguments, "AppObj 0x%08lx Object 0x%08lx", appobj, obj))

 /* Remove menu item */
 RemoveAppMenuItem(appobj);

 /* Remove messages and release Workbench */
 RemoveAppMessages(obj);
}

/* Create WB icon */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CreateAppIcon
void *CreateAppIcon(Object *obj, struct DiskObject *dobj, BOOL showname)
{
 void *rc = NULL;

 APPMSGS_LOG(LOG2(Arguments, "Object 0x%08lx DiskObject 0x%08lx", obj, dobj))

 /* Lock Workbench */
 if (LockWorkbench()) {
  char *name = "";

  APPMSGS_LOG(LOG0(WB locked))

  /* Show name? */
  if (showname)

   /* Yes, get name from object */
   GetAttr(TMA_ObjectName, obj, (ULONG *) &name);

  APPMSGS_LOG(LOG2(Name, "'%s' (0x%08lx)", name, name))

  /* Create icon */
  if ((rc = AddAppIconA((ULONG) obj, 0, name, AppMessagesPort, NULL, dobj,
                        NULL)) == NULL)

   /* Error, release workbench */
   ReleaseWorkbench();
 }

 APPMSGS_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}

/* Delete WB icon */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DeleteAppIcon
void DeleteAppIcon(void *appobj, Object *obj)
{
 APPMSGS_LOG(LOG2(Arguments, "AppObj 0x%08lx Object 0x%08lx", appobj, obj))

 /* Remove icon */
 RemoveAppIcon(appobj);

 /* Remove messages and release Workbench */
 RemoveAppMessages(obj);
}

/* Create WB application window */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CreateAppWindow
void *CreateAppWindow(Object *obj, struct Window *w)
{
 void *rc = NULL;

 APPMSGS_LOG(LOG2(Arguments, "Object 0x%08lx Window 0x%08lx", obj, w))

 /* Lock Workbench */
 if (LockWorkbench()) {

  APPMSGS_LOG(LOG0(WB locked))

  /* Create window */
  if ((rc = AddAppWindowA((ULONG) obj, 0, w, AppMessagesPort, NULL)) == NULL)

   /* Error, release workbench */
   ReleaseWorkbench();
 }

 APPMSGS_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}

/* Delete WB application window */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DeleteAppWindow
void DeleteAppWindow(void *appobj, Object *obj)
{
 APPMSGS_LOG(LOG2(Arguments, "AppObj 0x%08lx Object 0x%08lx", appobj, obj))

 /* Remove window */
 RemoveAppWindow(appobj);

 /* Remove messages and release Workbench */
 RemoveAppMessages(obj);
}
