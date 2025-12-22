/*
 * arexx.c  V3.1
 *
 * ToolManager library ARexx handling routines
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

/* Send an ARexx command */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION SendARexxCommand
BOOL SendARexxCommand(const char *command, ULONG len)
{
 struct Library *RexxSysBase;
 BOOL            rc          = FALSE;

 AREXX_LOG(LOG2(Arguments, "Cmd '%s' (%ld)", command, len))

 /* Open ARexx system library */
 if (RexxSysBase = OpenLibrary(RXSNAME, 0)) {
  struct MsgPort *mp;

  AREXX_LOG(LOG1(RexxSysBase, "0x%08lx", RexxSysBase))

  /* Allocate message port */
  if (mp = CreateMsgPort()) {
   struct RexxMsg *rxmsg;

   AREXX_LOG(LOG1(Reply port, "0x%08lx", mp))

   /* Allocate ARexx message */
   if (rxmsg = CreateRexxMsg(mp, NULL, NULL)) {

    AREXX_LOG(LOG1(ARexx Msg, "0x%08lx", rxmsg))

    /* Create ARexx argument */
    if (rxmsg->rm_Args[0] = CreateArgstring(command, len)) {
     struct MsgPort *ap;

     AREXX_LOG(LOG0(Argument created))

     /* Initialize ARexx message */
     rxmsg->rm_Action = RXCOMM | RXFF_NOIO;

     /* Find port and send message */
     Forbid();
     if (ap = FindPort("AREXX")) PutMsg(ap, (struct Message *) rxmsg);
     Permit();

     /* Success? */
     if (ap) {

      AREXX_LOG(LOG1(AREXX port, "0x%08lx", ap))

      /* Yes, wait on reply and remove it */
      WaitPort(mp);
      GetMsg(mp);

      /* Check return code */
      rc = (rxmsg->rm_Result1 == RC_OK);
     }

     ClearRexxMsg(rxmsg, 1);
    }

    DeleteRexxMsg(rxmsg);
   }

   DeleteMsgPort(mp);
  }

  CloseLibrary(RexxSysBase);
 }

 AREXX_LOG(LOG1(result, "%ld", rc))

 return(rc);
}

/* Start an ARexx program */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION StartARexxProgram
BOOL StartARexxProgram(const char *cmd, const char *cdir,
                       struct AppMessage *msg)
{
 BPTR newcd;
 BOOL rc    = FALSE;

 AREXX_LOG(LOG3(Arguments, "Cmd '%s' Dir '%s' Msg 0x%08lx", cmd, cdir, msg))

 /* Lock current directory */
 if (newcd = Lock(cdir, SHARED_LOCK)) {
  char  *cmdline;
  ULONG  length;

  AREXX_LOG(LOG1(NewCD, "0x%08lx", newcd))

  /* Build command line */
  if (cmdline = BuildCommandLine(cmd, msg, newcd, &length)) {
   BPTR oldcd;

   AREXX_LOG(LOG3(cmdline, "'%s' (0x%08lx, %ld)", cmdline, cmdline, length))

   /* Go to program's current directory */
   oldcd = CurrentDir(newcd);

   /* Send ARexx command */
   rc = SendARexxCommand(cmdline, length);

   /* Go back to old current directory */
   CurrentDir(oldcd);

   /* Free command line */
   FreeVector(cmdline);
  }

  UnLock(newcd);
 }

 AREXX_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}
