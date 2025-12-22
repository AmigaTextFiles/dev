/*
 * commands.c  V3.1
 *
 * ToolManager IPC command handling routines
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
static struct MsgPort *IPCPort;

/* Start IPC */
#define DEBUGFUNCTION StartIPC
LONG StartIPC(void)
{
 LONG rc = -1;

 COMMANDS_LOG(LOG0(Entry))

 /* Allocate message port */
 if (IPCPort = CreateMsgPort()) rc = IPCPort->mp_SigBit;

 COMMANDS_LOG(LOG2(Result, "Port 0x%08lx Signal %ld", IPCPort, rc))

 return(rc);
}

/* Stop IPC */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION StopIPC
void StopIPC(void)
{
 COMMANDS_LOG(LOG1(Port, "0x%08lx", IPCPort))

 SafeDeleteMsgPort(IPCPort);
}

/* Get IPC Port */
struct MsgPort *GetIPCPort(void)
{
 return(IPCPort);
}

/* Handle one IPC command */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION HandleIPC
void HandleIPC(void)
{
 struct TMHandle *tmh;

 COMMANDS_LOG(LOG0(Entry))

 /* Empty IPC port message queue */
 while (tmh = (struct TMHandle *) GetMsg(IPCPort)) {

  COMMANDS_LOG(LOG1(Command, "%ld", tmh->tmh_Message.tmm_Command))

  /* What command did we receive? */
  switch (tmh->tmh_Message.tmm_Command) {
   case TMIPC_AllocTMHandle:
    tmh->tmh_Message.tmm_Command = InitToolManagerHandle(tmh);
    break;

   case TMIPC_FreeTMHandle:
    DeleteToolManagerHandle(tmh);
    tmh->tmh_Message.tmm_Command = TRUE;
    break;

   case TMIPC_CreateTMObject: {
     Object *obj;

     COMMANDS_LOG(LOG2(Create, "Name '%s' Type %ld",
                       tmh->tmh_Message.tmm_Object, tmh->tmh_Message.tmm_Type))

     /* Set error return code */
     tmh->tmh_Message.tmm_Command = FALSE;

     /* Create new object */
     if (obj = CreateToolManagerObject(tmh, tmh->tmh_Message.tmm_Type)) {

      COMMANDS_LOG((LOG2(Created, "Object 0x%08lx Tags 0x%08lx",
                         obj, tmh->tmh_Message.tmm_Tags),
                    PrintTagList(tmh->tmh_Message.tmm_Tags)))

      /* Set object name */
      SetAttrs(obj, TMA_ObjectName, tmh->tmh_Message.tmm_Object, TAG_DONE);

      /* Set Object name and initialize object with tag list */
      if (DoMethod(obj, TMM_ParseTags, tmh->tmh_Message.tmm_Tags))

       /* Object created */
       tmh->tmh_Message.tmm_Command = TRUE;

      else

       /* Error in tag list */
       DisposeObject(obj);
     }
    }
    break;

   case TMIPC_DeleteTMObject: {
     struct Object *obj;

     COMMANDS_LOG(LOG1(Delete, "'%s'", tmh->tmh_Message.tmm_Object))

     /* Set error return code */
     tmh->tmh_Message.tmm_Command = FALSE;

     /* Search object */
     if (obj = FindNamedTMObject(tmh, tmh->tmh_Message.tmm_Object)) {

      COMMANDS_LOG(LOG1(Deleting, "0x%08lx", tmh->tmh_Message.tmm_Object))

      /* Dispose object */
      DisposeObject(obj);
      tmh->tmh_Message.tmm_Command = TRUE;
     }
    }
    break;

   case TMIPC_ChangeTMObject: {
     struct Object *obj;

     COMMANDS_LOG(LOG1(Change, "'%s'", tmh->tmh_Message.tmm_Object))

     /* Set error return code */
     tmh->tmh_Message.tmm_Command = FALSE;

     /* Search object */
     if (obj = FindNamedTMObject(tmh, tmh->tmh_Message.tmm_Object)) {

      COMMANDS_LOG((LOG2(Changing, "Object 0x%08lx Tags 0x%08lx",
                         tmh->tmh_Message.tmm_Object,
                         tmh->tmh_Message.tmm_Tags),
                    PrintTagList(tmh->tmh_Message.tmm_Tags)))

      /* Change object */
      tmh->tmh_Message.tmm_Command = DoMethod(obj, TMM_ParseTags,
                                              tmh->tmh_Message.tmm_Tags);
     }
    }
    break;
  }

  COMMANDS_LOG(LOG1(Command reply, "%ld", tmh->tmh_Message.tmm_Command))

  /* Reply message */
  ReplyMsg((struct Message *) tmh);
 }
}
