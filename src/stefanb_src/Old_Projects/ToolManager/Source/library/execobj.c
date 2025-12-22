/*
 * execobj.c  V2.1.01
 *
 * TMObject, Type: Exec
 *
 * (c) 1990-1996 Stefan Becker
 */

#include "ToolManagerLib.h"

/* extended TMObject structure for TMOBJTYPE_Exec objects */
struct TMObjectExec {
                     struct TMObject    eo_Object;
                     UWORD              eo_Type;
                     UWORD              eo_Flags;
                     char              *eo_Command;
                     char              *eo_CurrentDir;
                     LONG               eo_Delay;
                     char              *eo_HotKey;
                     char              *eo_Output;
                     char              *eo_Path;
                     LONG               eo_Priority;
                     char              *eo_PubScreen;
                     LONG               eo_Stack;
                     CxObj             *eo_CxObj;
                     struct TMHandle   *eo_Handle;
                     void              *eo_LinkData;
                     struct TMLink      eo_Link;
                     struct TMTimerReq  eo_TimerReq;
                    };

/* eo_Flags */
#define EO_Arguments (1L<<0)
#define EO_ToFront   (1L<<1)

/* Tag to Flag mapping table for PackBoolTags */
static struct TagItem flagmap[]={TMOP_Arguments, EO_Arguments,
                                 TMOP_ToFront,   EO_ToFront,
                                 TAG_DONE};

/* Structure for path list */
struct PathList {
                 BPTR NextPath; /* Pointer to next PathList */
                 BPTR PathLock; /* Lock on directory */
                };

/* Global data */
struct Library *WBStartBase;

/* Create an Exec object */
struct TMObject *CreateTMObjectExec(struct TMHandle *handle, char *name,
                                    struct TagItem *tags)
{
 struct TMObjectExec *tmobj;

 /* allocate memory for object */
 if (tmobj=(struct TMObjectExec *)
            AllocateTMObject(sizeof(struct TMObjectExec))) {
  struct TagItem *ti,*tstate;
  BOOL noerror=TRUE;

  /* Set object defaults */
  tmobj->eo_Type=TMET_CLI;
  tmobj->eo_Command=DefaultNoName;
  tmobj->eo_CurrentDir=DefaultDirName;
  tmobj->eo_Output=DefaultOutput;
  tmobj->eo_Stack=4096;
  tmobj->eo_Handle=handle;

  /* Scan tag list */
  tstate=tags;
  while (noerror && (ti=NextTagItem(&tstate))) {

   DEBUG_PRINTF("Got Tag (0x%08lx)\n",ti->ti_Tag);

   switch (ti->ti_Tag) {
    case TMOP_Command:    {
                           char *s=(char *) ti->ti_Data;
                           if (s) tmobj->eo_Command=s;
                          }
                          break;
    case TMOP_CurrentDir: {
                           char *s=(char *) ti->ti_Data;
                           if (s) tmobj->eo_CurrentDir=s;
                          }
                          break;
    case TMOP_Delay:      tmobj->eo_Delay=ti->ti_Data;
                          break;
    case TMOP_ExecType:   {
                           UWORD type=ti->ti_Data;

                           /* Sanity check */
                           if ((type <= TMET_Network) || (type == TMET_Hook))
                            tmobj->eo_Type=type;
                           else
                            noerror=FALSE;
                          }
                          break;
    case TMOP_HotKey:     tmobj->eo_HotKey=(char *) ti->ti_Data;
                          break;
    case TMOP_Output:     {
                           char *s=(char *) ti->ti_Data;
                           if (s) tmobj->eo_Output=s;
                          }
                          break;
    case TMOP_Path:       tmobj->eo_Path=(char *) ti->ti_Data;
                          break;
    case TMOP_Priority:   tmobj->eo_Priority=ti->ti_Data;
                          break;
    case TMOP_PubScreen:  tmobj->eo_PubScreen=(char *) ti->ti_Data;
                          break;
    case TMOP_Stack:      tmobj->eo_Stack=ti->ti_Data;
                          break;
   }
  }

  /* No errors? */
  if (noerror) {
   BOOL hotkey=tmobj->eo_HotKey!=NULL;

   /* HotKey set? Create Commodities object from HotKey description */
   if  (hotkey && (tmobj->eo_CxObj=HotKey(tmobj->eo_HotKey,BrokerPort,
                                          (ULONG) &tmobj->eo_Link))) {

    DEBUG_PRINTF("Created CxObj (0x%08lx)\n",tmobj->eo_CxObj);

    /* Attach object to broker */
    AttachCxObj(Broker,tmobj->eo_CxObj);
   }

   /* No HotKey or no HotKey error? */
   if (!hotkey || (tmobj->eo_CxObj && !CxObjError(Broker))) {
    /* No. Set flags */
    tmobj->eo_Flags=PackBoolTags(EO_Arguments,tags,flagmap);

    /* Initialize rest of structure */
    tmobj->eo_Link.tml_Linked=(struct TMObject *) tmobj;
    tmobj->eo_Link.tml_Active=FALSE;
    tmobj->eo_TimerReq.tmtr_Request=*deftimereq;
    tmobj->eo_TimerReq.tmtr_Link=&tmobj->eo_Link;

    /* All OK */
    return(tmobj);
   }

   /* Free resources */
   if (tmobj->eo_CxObj) SafeDeleteCxObjAll(tmobj->eo_CxObj,&tmobj->eo_Link);
  }
  FreeMem(tmobj,sizeof(struct TMObjectExec));
 }

 /* call failed */
 return(NULL);
}

/* Delete an Exec object */
BOOL DeleteTMObjectExec(struct TMObjectExec *tmobj)
{
 DEBUG_PRINTF("Delete/Exec (0x%08lx)\n",tmobj);

 /* timer request active? */
 if (tmobj->eo_Link.tml_Active) {
  struct IORequest *tr=(struct IORequest *) &tmobj->eo_TimerReq;

  /* If timer request still active, abort it */
  if (!CheckIO(tr)) AbortIO(tr);

  /* Remove timer request */
  WaitIO(tr);
  tmobj->eo_Link.tml_Active=FALSE;
 }

 /* Free internal data */
 if (tmobj->eo_LinkData)
  switch(tmobj->eo_Type) {
   case TMET_HotKey: FreeMem(tmobj->eo_LinkData,sizeof(struct InputEvent));
                     break;
   case TMET_Dock:   RemLinkTMObject(tmobj->eo_LinkData);
                     break;
  }

 /* Remove links */
 DeleteAllLinksTMObject((struct TMObject *) tmobj);

 /* Free resources */
 if (tmobj->eo_CxObj) SafeDeleteCxObjAll(tmobj->eo_CxObj,&tmobj->eo_Link);

 /* Remove object from list */
 Remove((struct Node *) tmobj);

 /* Free object */
 FreeMem(tmobj,sizeof(struct TMObjectExec));

 /* All OK. */
 return(TRUE);
}

/* Change an Exec object */
struct TMObject *ChangeTMObjectExec(struct TMHandle *handle,
                                    struct TMObjectExec *tmobj,
                                    struct TagItem *tags)
{
 struct TagItem *ti,*tstate;

 /* Scan tag list */
 tstate=tags;
 while (ti=NextTagItem(&tstate)) {

  DEBUG_PRINTF("Got Tag (0x%08lx)\n",ti->ti_Tag);

  switch (ti->ti_Tag) {
   case TMOP_Command:    {
                          char *s=(char *) ti->ti_Data;
                          if (s) tmobj->eo_Command=s;
                         }
                         break;
   case TMOP_CurrentDir: {
                          char *s=(char *) ti->ti_Data;
                          if (s) tmobj->eo_CurrentDir=s;
                         }
                         break;
   case TMOP_Delay:      tmobj->eo_Delay=ti->ti_Data;
                         break;
   case TMOP_ExecType:   {
                          UWORD type=ti->ti_Data;

                          /* Sanity check */
                          if ((type <= TMET_Network) || (type == TMET_Hook))
                           tmobj->eo_Type=type;
                         }
                         break;
   case TMOP_HotKey:     if (tmobj->eo_CxObj) {
                          SafeDeleteCxObjAll(tmobj->eo_CxObj,&tmobj->eo_Link);
                          tmobj->eo_CxObj=NULL;
                         }

                         tmobj->eo_HotKey=(char *) ti->ti_Data;
                         break;
   case TMOP_Output:     {
                          char *s=(char *) ti->ti_Data;
                          if (s) tmobj->eo_Output=s;
                         }
                         break;
   case TMOP_Path:       tmobj->eo_Path=(char *) ti->ti_Data;
                         break;
   case TMOP_Priority:   tmobj->eo_Priority=ti->ti_Data;
                         break;
   case TMOP_PubScreen:  tmobj->eo_PubScreen=(char *) ti->ti_Data;
                         break;
   case TMOP_Stack:      tmobj->eo_Stack=ti->ti_Data;
                         break;
  }
 }

 /* HotKey set? Create Commodities object from HotKey description */
 if  (tmobj->eo_HotKey && !tmobj->eo_CxObj &&
      (tmobj->eo_CxObj=HotKey(tmobj->eo_HotKey,BrokerPort,
                              (ULONG) &tmobj->eo_Link))) {

  DEBUG_PRINTF("Created CxObj (0x%08lx)\n",tmobj->eo_CxObj);

  /* Attach object to broker */
  AttachCxObj(Broker,tmobj->eo_CxObj);

  /* Commodities error? */
  if (CxObjError(Broker)) {
   SafeDeleteCxObjAll(tmobj->eo_CxObj,&tmobj->eo_Link);
   tmobj->eo_CxObj=NULL;
  }
 }

 /* Set flags */
 tmobj->eo_Flags=PackBoolTags(tmobj->eo_Flags,tags,flagmap);

 /* All OK */
 return(TRUE);
}

/* Allocate & Initialize a TMLink structure */
struct TMLink *AllocLinkTMObjectExec(struct TMObjectExec *tmobj)
{
 struct TMLink *tml;

 /* Allocate memory for link structure */
 if (tml=AllocMem(sizeof(struct TMLink),MEMF_CLEAR|MEMF_PUBLIC))
  /* Initialize link structure */
  tml->tml_Size=sizeof(struct TMLink);

 return(tml);
}

/* Clear link to Dock object */
void DeleteLinkTMObjectExec(struct TMLink *tml)
{
 struct TMObjectExec *tmobj=(struct TMObjectExec *) tml->tml_LinkedTo;

 tmobj->eo_LinkData=NULL;
}

/* Copy a path list */
BOOL CopyPathList(struct PathList **pla, struct PathList **plc,
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
void FreePathList(struct PathList *pla)
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

/* Build a path list from a string */
static BOOL BuildPathList(struct PathList **pla, struct PathList **plc, char *s)
{
 struct FileInfoBlock *fib;
 char *cp1,*cp2=s;
 struct PathList *pl1=*plc,*pl2=NULL;

 /* Get memory for FIB */
 if (!(fib=AllocVec(sizeof(struct FileInfoBlock),MEMF_PUBLIC|MEMF_CLEAR)))
  return(FALSE);

 /* For every path part */
 while (cp1=cp2) {
  /* Search next path part */
  if (cp2=strchr(cp1,',')) *cp2='\0'; /* Add string end character */

  /* Get memory for path list entry */
  if (!(pl2 ||
       (pl2=AllocVec(sizeof(struct PathList),MEMF_PUBLIC|MEMF_CLEAR)))) {
   FreeVec(fib);
   return(FALSE); /* No more memory */
  }

  /* Get lock */
  if (pl2->PathLock=Lock(cp1,SHARED_LOCK))
   /* Is it a directory? */
   if (Examine(pl2->PathLock,fib) && (fib->fib_DirEntryType>0)) {
    /* Yes, it is a directory, append it to the list. Head of list? */
    if (*pla)
     pl1->NextPath=MKBADDR(pl2); /* No, append it to list */
    else
     *pla=pl2;                   /* Yes, set list anchor */

    /* Save pointer */
    pl1=pl2;

    /* Invalidate pointer, next time a new PathList will be allocated */
    pl2=NULL;
   }
   else UnLock(pl2->PathLock); /* No, it is a file */

  /* Restore string and move to next character */
  if (cp2) *cp2++=',';
 }

 *plc=pl1;              /* Save end of list */
 if (pl2) FreeVec(pl2); /* Last Lock() failed, free memory */
 FreeVec(fib);

 /* All OK. */
 return(TRUE);
}

#define NAMELEN    256  /* Buffer length for a file name */
#define CMDLINELEN 4096 /* Buffer length for command line */

/* Build a CLI or ARexx command line (supports [] argument substitution) */
static ULONG BuildCommandLine(char *buf, char *command, BPTR curdir,
                              struct AppMessage *msg)
{
 ULONG cmdlen;      /* Command line length */
 char *lp=command;  /* Pointer to current cmdline pos. */
 char *contp=NULL;  /* Pointer AFTER [] place holder */

 /* Search for [] parameter place holder */
 while (lp=strchr(lp,'['))
  /* Place holder found? */
  if (*(lp+1) == ']')
   /* Yes, leave loop */
   break;
  else
   /* No, skip to next one */
   lp++;

 /* Copy command name to command line */
 if (lp) {
  /* [] parameter place holder found, copy first part of command */
  cmdlen=lp-command;
  strncpy(buf,command,cmdlen);
  buf[cmdlen]='\0';
  contp=lp+2;
 }
 else {
  strcpy(buf,command); /* No [] parameter place holder */
  cmdlen=strlen(buf);
 }
 lp=buf+cmdlen;

 /* Check for arguments */
 if (msg) {
  char *dir; /* Buffer for file names */

  /* Get memory for file names */
  if (dir=AllocMem(NAMELEN,MEMF_PUBLIC)) {
   struct WBArg *wa=msg->am_ArgList;  /* Pointer to WBArgs */
   int i;                             /* Counter for WBArgs */

   for (i=msg->am_NumArgs; i; i--,wa++) {
    char *name,*space;
    ULONG namelen;

    /* Skip args which don't support locks! */
    if (!wa->wa_Lock) continue;

    /* Append a space for each parameter */
    if (cmdlen>CMDLINELEN-2) break;
    *lp++=' ';
    cmdlen++;

    /* Build parameter from Lock & name */
    DEBUG_PRINTF("wa_Name: 0x%08lx\n",wa->wa_Name);
    DEBUG_PRINTF("wa_Name: '%s'\n",wa->wa_Name);
    if (*(wa->wa_Name)!='\0')
     /* File name --> build complete path name */
     if (SameLock(curdir,wa->wa_Lock)==LOCK_SAME)
      /* File in current directory -> "<file>" */
      name=(char *) wa->wa_Name;
     else {
      /* File in other directory -> "<path><seperator><file>" */
      if (!NameFromLock(wa->wa_Lock,dir,NAMELEN)) continue;
      if (!AddPart(dir,wa->wa_Name,NAMELEN)) continue;
      name=dir;
     }
    else {
     /* No file name --> Drawer */
     if (!NameFromLock(wa->wa_Lock,dir,NAMELEN)) continue;
     name=dir;
    }
    namelen=strlen(name);

    /* Handle special case: Space in a filename */
    if (space=strchr(name,' ')) namelen+=2;

    /* Does parameter fit into commandline? */
    if (cmdlen+namelen>CMDLINELEN-2) break;

    if (space) *lp++='"';   /* Quote file name (beginning) */
    strcpy(lp,name);        /* Append parameter */
    lp+=namelen;            /* Correct pointer */
    if (space) {
     lp--;                  /* Correct pointer */
     *(lp-1)='"';           /* Quote file name (end) */
    }
    cmdlen+=namelen;        /* New command line length */

    DEBUG_PRINTF("Parameter: '%s'\n",buf);
   }
   FreeMem(dir,NAMELEN);
  }
 }

 /* Check for [] parameter place holder, Find closing bracket */
 if (contp && (cmdlen+strlen(contp)<CMDLINELEN-1)) {
  strcpy(lp,contp); /* Copy second part of command */
  lp=lp+strlen(lp); /* Move to end of string */
 }
 else
  *lp='\0';       /* Set string terminator */

 /* Return command line length */
 return(lp-buf);
}

/* Start CLI program */
static BOOL StartCLIProgram(struct TMObjectExec *tmobj, struct AppMessage *msg)
{
 char *cmd;     /* Buffer for command line */
 BOOL rc=FALSE;

 /* Get memory for command line */
 if (cmd=AllocMem(CMDLINELEN,MEMF_PUBLIC)) {
  BPTR newcd; /* Lock for program's current directory */

  if (newcd=Lock(tmobj->eo_CurrentDir,SHARED_LOCK)) {
   BPTR ofh; /* AmigaDOS file handle (output) */

   /* Build command line */
   BuildCommandLine(cmd,tmobj->eo_Command,newcd,msg);

   /* Open output file */
   if (ofh=Open(tmobj->eo_Output,MODE_NEWFILE)) {
    BPTR ifh; /* AmigaDOS file handle (input) */
    struct MsgPort *newct=NULL;          /* New ConsoleTask pointer */

    /* Is the output file an interactive file? */
    if (IsInteractive(ofh)) {
     struct MsgPort *oldct;  /* Old ConsoleTask pointer */

     /* Yes. We need the same file as input file for CTRL-C/D/E/F redirection */
     /* Set our ConsoleTask to the new output file, so that we can re-open it */
     newct=((struct FileHandle *) BADDR(ofh))->fh_Type;
     oldct=SetConsoleTask(newct);

     /* Open the new input file (Now ifh points to the same file as ofh) */
     ifh=Open("CONSOLE:",MODE_OLDFILE);

     /* Change back to old ConsoleTask */
     SetConsoleTask(oldct);
    }
    /* Non-interactive output, open dummy input file */
    else ifh=Open(DefaultOutput,MODE_OLDFILE);

    if (ifh) {
     struct PathList *pla=NULL,*plc=NULL;

     /* Build path list, local path first, then global path*/
     if (BuildPathList(&pla,&plc,tmobj->eo_Path) &&
         CopyPathList(&pla,&plc,GlobalPath)) {
      BPTR oldcd; /* pointer to old current directory */

      /* Go to program's current directory */
      oldcd=CurrentDir(newcd);

      /* Start program */
      if (SystemTags(cmd,SYS_Output,     ofh,
                         SYS_Input,      ifh,
                         SYS_Asynch,     TRUE, /* Run program asynchron */
                         SYS_UserShell,  TRUE, /* Use user specified shell */
                         NP_StackSize,   tmobj->eo_Stack,
                         NP_Priority,    tmobj->eo_Priority,
                         NP_Path,        MKBADDR(pla),
                         NP_ConsoleTask, newct,
                         TAG_DONE)!=-1)
       rc=TRUE; /* Program started! */

      /* Go back to old current directory */
      CurrentDir(oldcd);
     }
     if (!rc) FreePathList(pla); /* Free path list if program wasn't started */
     if (!rc) Close(ifh); /* Close input file if program wasn't started */
    }
    if (!rc) Close(ofh); /* Close output file if program wasn't started */
   }
   UnLock(newcd);
  }
  FreeMem(cmd,CMDLINELEN);
 }
 return(rc);
}

/* Start WB program */
static BOOL StartWBProgram(struct TMObjectExec *tmobj, struct AppMessage *msg)
{
 BOOL rc                     = FALSE;

 /* Open wbstart.library */
 if (WBStartBase = OpenLibrary(WBSTART_NAME, WBSTART_VERSION)) {

  /* Start WB program */
  rc = WBStartTags(WBStart_Name,          tmobj->eo_Command,
                   WBStart_DirectoryName, tmobj->eo_CurrentDir,
                   WBStart_Stack,         tmobj->eo_Stack,
                   WBStart_Priority,      tmobj->eo_Priority,
                   WBStart_ArgumentCount, msg ? msg->am_NumArgs : 0,
                   WBStart_ArgumentList,  msg ? msg->am_ArgList : 0,
                   TAG_DONE)
        == RETURN_OK;

  /* Close library */
  CloseLibrary(WBStartBase);
 }

 return(rc);
}

/* Start ARexx program */
static BOOL StartARexxProgram(struct TMObjectExec *tmobj,
                              struct AppMessage *msg)
{
 char *cmd;     /* Buffer for command line */
 BOOL rc=FALSE;

 /* Get memory for command line */
 if (cmd=AllocMem(CMDLINELEN,MEMF_PUBLIC)) {
  BPTR newcd; /* Lock for program's current directory */

  if (newcd=Lock(tmobj->eo_CurrentDir,SHARED_LOCK)) {
   ULONG cmdlen; /* Command line length */
   BPTR oldcd;   /* Lock for old current directory */

   /* Build command line */
   cmdlen=BuildCommandLine(cmd,tmobj->eo_Command,newcd,msg);

   /* Go to program's current directory */
   oldcd=CurrentDir(newcd);

   /* Send ARexx command */
   rc=SendARexxCommand(cmd,cmdlen);

   /* Go back to old current directory */
   CurrentDir(oldcd);
   UnLock(newcd);
  }
  FreeMem(cmd,CMDLINELEN);
 }
 return(rc);
}

/* Start Network program */
static BOOL StartNetworkProgram(struct TMObjectExec *tmobj)
{
 BOOL rc=FALSE;

 /* Network installed? */
 if (LocalEntity) {
  char *cmd=tmobj->eo_Command;
  char *hostname;

  /* Search '@' seperator */
  if (hostname=strchr(cmd,'@')) {
   /* Host name found */
   ULONG cmdlen=hostname-cmd+1;
   struct Entity *RemoteEntity;

   /* Increment pointer */
   hostname++;

   DEBUG_PRINTF("Host name: '%s'\n",hostname);

   /* Find entity "ToolManager" on remote machine */
   if (RemoteEntity=FindEntity(hostname,ToolManagerName,LocalEntity,NULL)) {
    struct Transaction *trans;

    DEBUG_PRINTF("Remote entity: 0x%08lx\n",RemoteEntity);

    /* Allocate transaction */
    if (trans=AllocTransaction(TRN_AllocReqBuffer, cmdlen,
                               TAG_DONE)) {
     char *buffer=trans->trans_RequestData;

     DEBUG_PRINTF("Transaction: 0x%08lx\n",trans);

     /* Init transaction */
     strncpy(buffer,cmd,cmdlen-1);
     buffer[cmdlen-1]='\0';
     trans->trans_ReqDataActual=cmdlen;
     trans->trans_Timeout=10; /* 10 secs timeout for remote machine */

     DEBUG_PRINTF("Remote command: '%s'\n",buffer);

     /* Do transaction */
     DoTransaction(RemoteEntity,LocalEntity,trans);
     rc=(trans->trans_Error == ENVOYERR_NOERROR);

     DEBUG_PRINTF("Network error: %ld\n",trans->trans_Error);

     /* Free transaction */
     FreeTransaction(trans);
    }

    /* Release remote entity */
    LoseEntity(RemoteEntity);
   }
  }
 }
 return(rc);
}

/* Input desctription structure for ParseIX() */
static struct InputXpression ParseBuffer={IX_VERSION};

void kprintf(char *, ...);

/* Create an input event from a Commodities description string */
static struct InputEvent *CreateInputEvent(struct TMObjectExec *tmobj)
{
 struct InputEvent *ie;

 /* Allocate memory for input event */
 if (ie=AllocMem(sizeof(struct InputEvent),MEMF_CLEAR|MEMF_PUBLIC)) {

  /* Parse description string */
  if (!ParseIX(tmobj->eo_Command,&ParseBuffer)) {

   /* Description OK, initialize input event */
   ie->ie_Class    =ParseBuffer.ix_Class;
   ie->ie_Code     =ParseBuffer.ix_Code;
   ie->ie_Qualifier=ParseBuffer.ix_Qualifier;

   /* All OK */
   return(ie);
  }

  /* Error in description string, free input event */
  FreeMem(ie,sizeof(struct InputEvent));
 }
 return(NULL);
}

/* Start program */
static void StartProgram(struct TMObjectExec *tmobj, struct AppMessage *msg)
{
 struct AppMessage *args=(tmobj->eo_Flags & EO_Arguments) ? msg : NULL;
 BOOL rc=FALSE;

 /* Check for command */
 if (!tmobj->eo_Command) return; /* Nothing to do */

 /* Check for ToFront flag */
 if (tmobj->eo_Flags & EO_ToFront) {
  /* Move screen to front */
  struct Screen *s=LockPubScreen(tmobj->eo_PubScreen);

  if (s) {
   ScreenToFront(s);
   UnlockPubScreen(NULL,s);
  }
 }

 /* Check for program type */
 switch (tmobj->eo_Type) {
  case TMET_CLI:     rc=StartCLIProgram(tmobj,args);
                     break;
  case TMET_WB:      rc=StartWBProgram(tmobj,args);
                     break;
  case TMET_ARexx:   rc=StartARexxProgram(tmobj,args);
                     break;
  case TMET_Dock:    /* Dock already linked or can we create a link? */
                     if (tmobj->eo_LinkData ||
                         (tmobj->eo_LinkData=AddLinkTMObject(tmobj->eo_Handle,
                                                             tmobj->eo_Command,
                                                             TMOBJTYPE_DOCK,
                                                 (struct TMObject *) tmobj))) {
                      /* Yes, activate it */
                      CallActivateTMObject(tmobj->eo_LinkData,NULL);
                      rc=TRUE;
                     }
                     break;
  case TMET_HotKey:  /* Input event already created or can we create it? */
                     if (tmobj->eo_LinkData ||
                         (tmobj->eo_LinkData=CreateInputEvent(tmobj))) {
                      /* Yes */
                      struct InputEvent *ie=tmobj->eo_LinkData;

                      /* Set time stamp */
                      CurrentTime(&ie->ie_TimeStamp.tv_secs,
                                  &ie->ie_TimeStamp.tv_micro);

                      /* Enqueue event */
                      AddIEvents(tmobj->eo_LinkData);
                      rc=TRUE;
                     }
                     break;
  case TMET_Network: rc=StartNetworkProgram(tmobj); /* No args possible */
                     break;
  case TMET_Hook:    {
                      struct Hook *hook=(struct Hook *) tmobj->eo_Command;
                      HookFuncPtr Entry = (HookFuncPtr) hook->h_Entry;

                      /* Call hook function. Calling conventions:          */
                      /* A0 (hook)   : pointer to hook structure           */
                      /* A1 (message): pointer to AppMessage (may be NULL) */
                      /* A2 (object) : value of hook->h_Data               */
                      /* Return Code : BOOL, FALSE for failure             */
                      rc=Entry(hook,args,hook->h_Data);
                     }
                     break;
 }

 /* Error? */
 if (!rc) DisplayBeep(NULL);
}

/* Send timer request */
static void SendTimerRequest(struct TMObjectExec *tmobj)
{
 struct timerequest *tr=(struct timerequest *) &tmobj->eo_TimerReq;

 /* Initialize timer request */
 tr->tr_node.io_Command=TR_ADDREQUEST;
 tr->tr_time.tv_secs=labs(tmobj->eo_Delay);
 tr->tr_time.tv_micro=0;

 /* Send timer request */
 SendIO((struct IORequest *) tr);
 tmobj->eo_Link.tml_Active=(void *) TRUE;
}

/* Activate an Exec object */
void ActivateTMObjectExec(struct TMLink *tml, struct AppMessage *msg)
{
 struct TMObjectExec *tmobj=(struct TMObjectExec *) tml->tml_Linked;

 DEBUG_PRINTF("Activate/Exec (0x%08lx)\n",msg);

 /* Is timer active? */
 if (tmobj->eo_Link.tml_Active) {
  /* Yes. a) got timer event, b) user wants to stop last request */
  struct IORequest *tr=(struct IORequest *) &tmobj->eo_TimerReq;

  /* Check timer request */
  if (CheckIO(tr)) {
   /* a) Timer event finished, remove it. */
   WaitIO(tr);
   tmobj->eo_Link.tml_Active=FALSE;

   /* Start program, no arguments */
   StartProgram(tmobj,NULL);

   /* repeat event? */
   if (tmobj->eo_Delay<0) SendTimerRequest(tmobj);
  }
  else {
   /* b) user wants to stop last request, abort it */
   AbortIO(tr);
   WaitIO(tr);
   tmobj->eo_Link.tml_Active=FALSE;
  }
 }
 /* Timer not active, start program or time request */
 else if (tmobj->eo_Delay!=0) SendTimerRequest(tmobj);

 /* Start program */
 else StartProgram(tmobj,msg);
}
