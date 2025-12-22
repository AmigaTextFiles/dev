/*
 * safety.c  V2.1
 *
 * safe delete functions
 *
 * (c) 1990-1993 Stefan Becker
 */

#include "ToolManagerLib.h"

/* Delete a CxObject and remove all associated messages from the BrokerPort */
void SafeDeleteCxObjAll(struct CxObj *cxobj, struct TMLink *tml)
{
 CxMsg *msg;

 /* Delete object */
 DeleteCxObjAll(cxobj);

 /* Scan message port list */
 Forbid();
 msg=GetHead(&BrokerPort->mp_MsgList);
 while (msg)
  /* Does the message point to this object? */
  if ((struct TMLink *) CxMsgID(msg)==tml) {
   /* Yes */
   CxMsg *nextmsg=GetSucc(msg);

   /* Remove it from list */
   Remove((struct Node *) msg);

   /* Reply it */
   ReplyMsg((struct Message *) msg);

   /* Get pointer to next message */
   msg=nextmsg;
  }
   /* No. Get pointer to next message */
  else msg=GetSucc(msg);
 Permit();
}

/* Remove all associated messages from the AppMsgPort */
static void RemoveAppMsgs(struct TMLink *tml)
{
 struct AppMessage *msg;

 /* Scan message port */
 Forbid();
 msg=GetHead(&AppMsgPort->mp_MsgList);
 while (msg)
  /* Does the message point to this object? */
  if ((struct TMLink *) msg->am_ID==tml) {
   /* Yes */
   struct AppMessage *nextmsg=GetSucc(msg);

   /* Remove it from list */
   Remove((struct Node *) msg);

   /* Reply it */
   ReplyMsg((struct Message *) msg);

   /* Get pointer to next message */
   msg=nextmsg;
  }
   /* No. Get pointer to next message */
  else msg=GetSucc(msg);
 Permit();
}

/* Delete an AppMenu and remove all associated messages from the AppMsgPort */
void SafeRemoveAppMenuItem(void *appmenu, struct TMLink *tml)
{
 /* Remove AppMenu */
 RemoveAppMenuItem(appmenu);

 /* Remove messages */
 RemoveAppMsgs(tml);
}

/* Delete an AppIcon and remove all associated messages from the AppMsgPort */
void SafeRemoveAppIcon(void *appicon, struct TMLink *tml)
{
 /* Remove AppIcon */
 RemoveAppIcon(appicon);

 /* Remove messages */
 RemoveAppMsgs(tml);
}

/* Delete an AppWindow and remove all associated messages from the AppMsgPort */
void SafeRemoveAppWindow(void *appwin, struct TMLink *tml)
{
 /* Remove AppIcon */
 RemoveAppWindow(appwin);

 /* Remove messages */
 RemoveAppMsgs(tml);
}
