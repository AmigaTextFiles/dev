/*
 * WBStart-Handler.c   V1.4
 *
 * Handler code
 *
 * (c) 1991-93 Stefan Becker
 *
 */

/* Handler includes */
#include "WBStart.h"

/* System includes */
#include <dos/dostags.h>
#include <exec/memory.h>
#include <workbench/icon.h>
#include <workbench/workbench.h>

/* Prototypes */
#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <clib/icon_protos.h>
void _waitwbmsg(void);

/* Pragmas */
#include <pragmas/dos_pragmas.h>
#include <pragmas/exec_pragmas.h>
#include <pragmas/icon_pragmas.h>

/* ANSI C includes */
#include <stdlib.h>
#include <string.h>

/* Defines */
#define MINSTACKSIZE 4096

/* Structure for path lists */
struct PathList {
                 BPTR NextPath; /* Pointer to next PathList */
                 BPTR PathLock; /* Lock on directory */
                };

/* Library bases */
extern struct Library *SysBase, *DOSBase, *IconBase;

/* Global data */
static struct PathList *LoadPath=NULL; /* Path for loading programs */
static struct MsgPort *HandlerPort;    /* Handler message port */
static ULONG wbactive=0;               /* Number of active WB processes */

/* Version string */
static const char Version[]="$VER: WBStart-Handler 1.4 ("
                             __COMMODORE_DATE__ ")";

/* Duplicate a string */
static char *StrDup(char *old)
{
 char *new;

 /* Allocate memory and copy string */
 if (new=AllocVec(strlen(old)+1,MEMF_PUBLIC))
  strcpy(new,old);
 return(new);
}

/* Try to load a program, return pointer to segment and lock to home dir */
static BPTR LoadSegPath(char *name, BPTR curdir, BPTR *homedir)
{
 BPTR segment;
 struct PathList *pl;

 /* Load from current directory */
 if (segment=NewLoadSeg(name,NULL))
  /* Copy lock */
  if (*homedir=DupLock(curdir))
   return(segment);
  else
   return(NULL); /* Error */

 /* Load from path */
 pl=LoadPath;
 while (pl) {
  /* Set new directory */
  CurrentDir(pl->PathLock);

  /* Try to load program */
  if (segment=NewLoadSeg(name,NULL)) {
   /* Return to old directory */
   CurrentDir(curdir);

   /* Copy lock */
   if (*homedir=DupLock(pl->PathLock))
    return(segment);
   else
    return(NULL); /* Error */
  }

  /* Next path entry */
  pl=BADDR(pl->NextPath);
 }

 /* Load from "C:" */
 {
  BPTR lock;

  /* Get directory lock */
  if (lock=Lock("C:",ACCESS_READ)) {
   CurrentDir(lock);

   /* Try to load program */
   if (segment=NewLoadSeg(name,NULL)) {
    /* Return to old directory */
    CurrentDir(curdir);

    /* Set lock */
    *homedir=lock;
    return(segment);
   }

   /* Free lock */
   UnLock(lock);
  }
 }

 /* Return to old directory */
 CurrentDir(curdir);

 /* Load failed */
 return(NULL);
}

/* Start program as a WB process */
static BOOL StartProgram(struct WBStartMsg *msg)
{
 struct WBStartup *wbs;

 /* Allocate memory for WBStartup */
 if (wbs=AllocVec(sizeof(struct WBStartup)+
                  sizeof(struct WBArg)*(msg->wbsm_NumArgs+2),
                  MEMF_PUBLIC|MEMF_CLEAR)) {
  BPTR olddir,homedir;
  char *toolname=msg->wbsm_Name;
  char *projectname=NULL;
  ULONG stacksize=msg->wbsm_Stack;

  /* Go to tools current directory */
  olddir=CurrentDir(msg->wbsm_DirLock);

  /* Check for project icon */
  {
   struct DiskObject *dobj;

   /* Get program icon */
   if ((dobj=GetDiskObject(toolname)) &&
       (dobj->do_Type==WBPROJECT)) {
    /* It's a project icon, get the name & icon of the default tool */
    projectname=toolname;
    if (toolname=StrDup(dobj->do_DefaultTool)) {
     /* Free old icon */
     FreeDiskObject(dobj);

     /* Get new icon */
     dobj=GetDiskObject(toolname);
    }
   }

   /* No error and tool icon? */
   if (toolname && dobj && (dobj->do_Type==WBTOOL)) {
    /* Get stack size from tool icon */
    if (dobj->do_StackSize>stacksize) stacksize=dobj->do_StackSize;

    /* Get tool window description (Maybe obsolete???) */
    if (dobj->do_ToolWindow) wbs->sm_ToolWindow=StrDup(dobj->do_ToolWindow);
   }

   /* Free Disk object */
   if (dobj) FreeDiskObject(dobj);
  }

  /* No error and can we load the program? */
  if (toolname &&
      (wbs->sm_Segment=LoadSegPath(toolname,msg->wbsm_DirLock,&homedir))) {
   /* Program loaded */
   struct WBArg *wbas;
   struct WBArg *wbad;

   /* Build WBStartup message */
   /* wbs->sm_Message.mn_Node.ln_Type=NT_MESSAGE; PutMsg() does this for us! */
   wbs->sm_Message.mn_ReplyPort=HandlerPort;
   wbs->sm_Message.mn_Length=sizeof(struct WBStartup);
   wbs->sm_NumArgs=msg->wbsm_NumArgs+1;
   wbs->sm_ArgList=(struct WBArg *)(wbs+1); /* WBArgs follow after WBStartup */

   /* Initialize WBArg list pointers */
   wbas=msg->wbsm_ArgList; /* Source */
   wbad=wbs->sm_ArgList;   /* Destination */

   /* The first argument is the tool itself. a) Copy lock */
   if (wbad->wa_Lock=DupLock(homedir)) {
    int i;

    /* b) Copy name */
    wbs->sm_NumArgs=1;
    if (wbad->wa_Name=(BYTE *) StrDup(toolname)) {
     /* If it is a project, then use project as second argument */
     if (!projectname ||
          (wbs->sm_NumArgs=2, wbad++,
           (wbad->wa_Lock=DupLock(msg->wbsm_DirLock)) &&
           (wbad->wa_Name=(BYTE *) StrDup(projectname)))) {
      BOOL noerror=TRUE;

      /* Next destination argument */
      wbad++;

      /* Copy WBArgs from message */
      for (i=msg->wbsm_NumArgs; i; i--,wbas++) {
       char *argname=wbas->wa_Name;

       /* Copy lock (skip arguments with invalid locks) */
       if ((wbad->wa_Lock=DupLock(wbas->wa_Lock)) ||

           /* NULL lock, check if argument name is a device name */
           (argname && (argname[strlen(argname)-1]==':'))) {
        /* Increment argument count */
        wbs->sm_NumArgs++;

        /* Check & copy name */
        if (!(argname && (wbad->wa_Name=(BYTE *) StrDup(argname)))) {
         /* ERROR --> leave loop */
         noerror=FALSE;
         break;
        }

        /* Next destination WBArg */
        wbad++;
       }
      }

      /* No error? */
      if (noerror) {
       /* Make sure that the stack size is valid */
       if (stacksize<MINSTACKSIZE) stacksize=MINSTACKSIZE;
       stacksize=(stacksize+3)&(~3); /* Stack size must be a multiple of 4! */

       /* Create process */
       Forbid(); /* We want to manipulate the process first! */
       if (wbs->sm_Process=CreateProc(wbs->sm_ArgList->wa_Name,msg->wbsm_Prio,
                                      wbs->sm_Segment,stacksize)) {
        /* Set PROGDIR: *** ATTENTION: Don't try this at home, kids :-) *** */
        {
         struct Process *pr=(struct Process *) wbs->sm_Process->mp_SigTask;

         pr->pr_HomeDir=homedir;
         pr->pr_WindowPtr=NULL;
         pr->pr_ConsoleTask=NULL;
        }
        Permit(); /* Ready to rock'n'roll :-) */

        /* Send WBStartup message to new process */
        PutMsg(wbs->sm_Process,(struct Message *) wbs);

        /* Free tool name */
        if (projectname) FreeVec(toolname);

        /* Go back to old directory */
        CurrentDir(olddir);

        /* Program successfully started! */
        wbactive++;
        return(TRUE);
       } else
        /* Couldn't create process */
        Permit();
      }
     }
    }

    /* Free WBArgs */
    for (i=wbs->sm_NumArgs; i; i--, wbas++) {
     /* Free lock */
     UnLock(wbas->wa_Lock);

     /* Free name */
     if (wbas->wa_Name) FreeVec(wbas->wa_Name);
    }
   }

   /* Free lock */
   UnLock(homedir);

   /* Unload segment */
   UnLoadSeg(wbs->sm_Segment);
  }

  /* Free tool window description */
  if (wbs->sm_ToolWindow) FreeVec(wbs->sm_ToolWindow);

  /* Free tool name */
  if (projectname && toolname) FreeVec(toolname);

  /* Go back to old directory */
  CurrentDir(olddir);
  FreeVec(wbs);
 }

 /* Call failed */
 return(FALSE);
}

/* Copy a path list */
static BOOL CopyPathList(struct PathList **pla, struct PathList **plc,
                         struct PathList *oldpl)
{
 struct PathList *pl1=oldpl,*pl2=*plc,*pl3=NULL;

 while (pl1) {
  /* Get memory for path list entry */
  if (!(pl3 || (pl3=AllocVec(sizeof(struct PathList),MEMF_PUBLIC|MEMF_CLEAR))))
   return(FALSE); /* No more memory... */

  /* Copy path entry */
  if (pl3->PathLock=DupLock(pl1->PathLock)) {
   /* Copy successful, append new entry to list. Head of list? */
   if (*pla)
    pl2->NextPath=MKBADDR(pl3); /* No, append it to list */
   else
    *pla=pl3;                   /* Yes, set list anchor */

   /* Save pointer */
   pl2=pl3;

   /* Invalidate pointer, next time a new PathList will be allocated */
   pl3=NULL;
  }

  /* Get next path list entry */
  pl1=BADDR(pl1->NextPath);
 }

 /* Free memory */
 if (pl3) FreeVec(pl3);

 /* All OK */
 *plc=pl2; /* Save pointer to new end of list */
 return(TRUE);
}

/* Free a path list */
static void FreePathList(struct PathList *pla)
{
 /* Check for NULL */
 if (pla) {
  struct PathList *pl1=pla,*pl2;

  /* Scan list */
  do {
   /* Get pointer to next entry */
   pl2=BADDR(pl1->NextPath);

   /* Free entry */
   UnLock(pl1->PathLock);
   FreeVec(pl1);
  } while (pl1=pl2);
 }
}

__stkargs void _main(int arglen, char *argptr)
{
 struct PathList *oldpath;
 struct PathList *newpath=NULL;
 struct CommandLineInterface *mycli;

 /* Check OS version */
 if (SysBase->lib_Version<37) return;

 /* CLI Process? */
 if (mycli=Cli()) {
  /* Yes, try to copy path from Workbench process */
  struct Process *wbproc=(struct Process *) FindTask("Workbench");

  /* Get pointer to our old path */
  oldpath=(struct PathList *) BADDR(mycli->cli_CommandDir);
  LoadPath=oldpath;

  /* Task found? Make sure it IS a process */
  if (wbproc && (wbproc->pr_Task.tc_Node.ln_Type==NT_PROCESS)) {
   /* It is a process */
   struct CommandLineInterface *wbcli=BADDR(wbproc->pr_CLI);

   /* Make sure it IS a CLI process */
   if (wbcli) {
    struct PathList *dummy;

    /* Build new path: a) our old path, b) WB path */
    if (CopyPathList(&newpath,&dummy,oldpath) &&
        CopyPathList(&newpath,&dummy,
                     (struct PathList *) BADDR(wbcli->cli_CommandDir))) {
     /* Path successfully copied, install it in our process */
     mycli->cli_CommandDir=MKBADDR(newpath);
     LoadPath=newpath;
    } else {
     /* Error, free path list */
     FreePathList(newpath);
     return;
    }
   }
  }
 }

 /* Create message port */
 if (HandlerPort=CreateMsgPort()) {
  ULONG wsig,psig;
  BOOL notend=TRUE;

  /* Make port public */
  HandlerPort->mp_Node.ln_Pri=0;
  HandlerPort->mp_Node.ln_Name=WBS_PORTNAME;
  AddPort(HandlerPort);

  /* Init signal masks */
  psig=1L<<HandlerPort->mp_SigBit;
  wsig=psig|SIGBREAKF_CTRL_C;

  /* Main event loop */
  while (notend) {
   ULONG gotsigs;

   /* Wait on event */
   gotsigs=Wait(wsig);

   /* Got a message at our port? */
   if (gotsigs&psig) {
    struct WBStartMsg *msg;

    /* Process all messages */
    while (msg=(struct WBStartMsg *) GetMsg(HandlerPort))
     /* Replied message? */
     if (msg->wbsm_Msg.mn_Node.ln_Type==NT_REPLYMSG) {
      /* This is the death message from a tool we started some time ago */
      struct WBStartup *wbs=(struct WBStartup *) msg;
      struct WBArg *wa=wbs->sm_ArgList;
      int i=wbs->sm_NumArgs;

      while (i--) {
       UnLock(wa->wa_Lock);      /* Free WB argument */
       if (wa->wa_Name) FreeVec(wa->wa_Name);
       wa++;
      }

      if (wbs->sm_ToolWindow)     /* Free tool window specification */
       FreeVec(wbs->sm_ToolWindow);

      UnLoadSeg(wbs->sm_Segment); /* Unload code */
      FreeVec(wbs);               /* Free WBStartup */
      wbactive--;                 /* One tool closed down */
     } else {
      /* We got a new message. Handle and reply it. */
      msg->wbsm_Stack=StartProgram(msg);
      ReplyMsg((struct Message *) msg);
     }
   }

   /* Received a CTRL-C? */
   if ((gotsigs&SIGBREAKF_CTRL_C) && !wbactive) notend=FALSE;
  }

  /* Exit handler */
  RemPort(HandlerPort);
  DeleteMsgPort(HandlerPort);
 }

 /* Free path list */
 if (newpath) {
  /* Reinstall old path first */
  mycli->cli_CommandDir=MKBADDR(oldpath);
  FreePathList(newpath);
 }

 /* Handler finished */
 return;

 /* NOT REACHED */
 _waitwbmsg();    /* Force linking of WB startup code */
}
