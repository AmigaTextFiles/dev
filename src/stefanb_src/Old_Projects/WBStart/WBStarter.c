/*
 * WBStarter.c   V1.4
 *
 * Start WB programs via WBStart-Handler
 *
 * (c) 1991-93 Stefan Becker
 *
 */

/* Handler includes */
#include "WBStart.h"

/* System includes */
#include <dos/dostags.h>
#include <workbench/startup.h>

/* Prototypes */
#include <clib/dos_protos.h>
#include <clib/exec_protos.h>

/* Pragmas */
#include <pragmas/dos_pragmas.h>
#include <pragmas/exec_pragmas.h>

/* ANSI C includes */
#include <stdlib.h>
#include <stdio.h>

/* Library bases */
extern struct Library *SysBase, *DOSBase;

/* Version string */
static const char Version[]="$VER: WBStarter 1.4 (" __COMMODORE_DATE__ ")";

int main(int argc, char *argv[])
{
 BPTR fl;
 struct WBStartMsg msg;
 struct MsgPort *mp,*hp;

 /* Check OS version */
 if (SysBase->lib_Version<37) return(20);

 if (!(mp=CreateMsgPort())) {
  puts("No message port!\n");
  exit(20);
 }

 fl=CurrentDir(NULL);
 msg.wbsm_Msg.mn_Node.ln_Pri=0;
 msg.wbsm_Msg.mn_ReplyPort=mp;
 msg.wbsm_DirLock=fl;
 msg.wbsm_Stack=4096;
 msg.wbsm_Prio=0;
 msg.wbsm_NumArgs=0;
 msg.wbsm_ArgList=NULL;

 while (--argc) {
  msg.wbsm_Name=*++argv;

  /* Try to send a message to the WBStart-Handler */
  Forbid();
  hp=FindPort(WBS_PORTNAME);
  if (hp) PutMsg(hp,(struct Message *) &msg);
  Permit();

  /* No WBStart-Handler, try to start it! */
  if (!hp) {
   BPTR ifh=Open("NIL:",MODE_NEWFILE);
   BPTR ofh=Open("NIL:",MODE_OLDFILE);

   /* Start handler */
   if (SystemTags(WBS_LOADNAME,SYS_Input,ifh,
                               SYS_Output,ofh,
                               SYS_Asynch,TRUE,
                               SYS_UserShell,TRUE,
                               NP_ConsoleTask,NULL,
                               NP_WindowPtr,NULL,
                               TAG_DONE)!=-1) {
    int i;

    /* Handler started, try to send message (Retry up to 5 seconds) */
    for (i=0; i<10; i++) {
     /* Try to send message */
     Forbid();
     hp=FindPort(WBS_PORTNAME);
     if (hp) PutMsg(hp,(struct Message *) &msg);
     Permit();

     /* Message sent? Yes, leave loop */
     if (hp) break;

     /* No, wait 1/2 second */
     Delay(25);
    }
   } else {
    /* Handler not started, close file handles */
    Close(ifh);
    Close(ofh);
   }
  }

  /* Could we send the message? */
  if (hp) {
   /* Get reply message */
   WaitPort(mp);
   GetMsg(mp);
  } else {
   /* Oops. ERROR! */
   puts("Can't find 'WBStart-Handler'!");
   break;
  }
 }

 /* Free resources */
 CurrentDir(fl);
 DeleteMsgPort(mp);

 /* All OK! */
 return(0);
}
