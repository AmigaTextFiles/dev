/*
 * main.c  V2.1
 *
 * configuration program main entry point
 *
 * (c) 1990-1993 Stefan Becker
 */

#include "ToolManagerConf.h"

static const char Version[]="\0$VER: ToolManager " TMVERSION "." TMREVISION
                            " (" __COMMODORE_DATE__ ")\r\n";
static const char PrefsPortName[]="ToolManager_Prefs";

/* Misc. data */
struct Library *IFFParseBase=NULL;
static struct MsgPort *PrefsPort=NULL;
static char *FromFileName;
static char *PubScreenName;
static char Template[]="FROM,EDIT/S,USE/S,SAVE/S,PUBSCREEN/K,DEFAULTFONT/S";
static struct {
               char *from;
               long  edit;
               long  use;
               long  save;
               char *pubsc;
               long  deffont;
              } cmdlineparams={PrefsFileName,TRUE,FALSE,FALSE,NULL,FALSE};
static UWORD MainWinX=10;
static UWORD MainWinY=10;
static BOOL DefaultFont;
static char WBName[]="Workbench";
static char YesString[]="Y|Yes";

/* Open resources */
static BOOL OpenResources(void)
{
 if (!(IFFParseBase=OpenLibrary("iffparse.library",37))) return(FALSE);
 if (!(PrefsPort=CreateMsgPort())) return(FALSE);
 PrefsPort->mp_Node.ln_Pri=-127;
 PrefsPort->mp_Node.ln_Name=PrefsPortName;
 AddPort(PrefsPort);

 /* Try to open workbench.library */
 WorkbenchBase=OpenLibrary("workbench.library",37);

 if (!(AppMsgPort=CreateMsgPort())) return(FALSE);
 GetLocale();

 /* All OK */
 return(TRUE);
}

/* Close Resources */
static void CloseResources(void)
{
 FreeLocale();
 if (AppMsgPort) {
  struct Message *msg;
  while (msg=GetMsg(AppMsgPort)) ReplyMsg(msg);
  DeleteMsgPort(AppMsgPort);
 }
 if (WorkbenchBase) CloseLibrary(WorkbenchBase);
 if (PrefsPort) {
  RemPort(PrefsPort);
  DeleteMsgPort(PrefsPort);
 }
 if (IFFParseBase) CloseLibrary(IFFParseBase);
}

/* Free all preferences objects */
void FreeAllObjects(void)
{
 int i;

 for (i=0; i<TMOBJTYPES; i++) {
  struct List *list=&ObjectLists[i];
  FreeNodeFuncPtr freefunc=FreeNodeFunctions[i];
  struct Node *node;

  /* Scan list and free nodes */
  while (node=RemHead(list)) (*freefunc)(node);
 }
}

/* Copy a file */
BOOL CopyFile(char *source, char *dest)
{
 char *copybuf;
 BOOL rc=FALSE;

 /* Allocate copy buffer */
 if (copybuf=malloc(2048)) {
  BPTR infh;

  /* Open source file */
  if (infh=Open(source,MODE_OLDFILE)) {
   BPTR outfh;

   /* Open destination file */
   if (outfh=Open(dest,MODE_NEWFILE)) {
    LONG n;

    /* Copy file */
    while ((n=Read(infh,copybuf,2048))>0) Write(outfh,copybuf,n);

    /* No error? */
    if (n==0) rc=TRUE;

    Close(outfh);
   }
   Close(infh);
  }
  free(copybuf);
 }
 return(rc);
}

/* Main program */
static int mainprogram(struct WBArg *wa)
{
 /* Another ToolManager Preferences program already running? */
 Forbid();
 if (PrefsPort=FindPort(PrefsPortName)) {
  /* Yes, signal other task... */
  Signal(PrefsPort->mp_SigTask,1L << PrefsPort->mp_SigBit);
  Permit();

  /* ...and exit! */
  return(0);
 }
 Permit();

 /* Open resources */
 if (OpenResources()) {
  /* Check OS version */
  if (SysBase->lib_Version>=39)
   OSV39=TRUE;

  /* Set defaults */
  FromFileName=PrefsFileName;
  PubScreenName=NULL;
  ProgramName=NULL;
  DefaultFont=FALSE;

  /* WB or CLI startup? */
  if (wa) {
   /* WB Startup */
   struct DiskObject *dobj;

   /* Get icon */
   if (dobj=GetDiskObjectNew(wa->wa_Name)) {
    char *s,**tt=dobj->do_ToolTypes;

    /* USE? */
    if (FindToolType(tt,"USE")) {
     /* Copy From file to preferences file */
     CopyFile(wa->wa_Name,PrefsFileName);

     /* ...and exit */
     FreeDiskObject(dobj);
     CloseResources();
     return(0);
    }

    /* SAVE? */
    if (FindToolType(tt,"SAVE")) {
     /* Copy From file to preferences file */
     CopyFile(wa->wa_Name,SavePrefsFileName);

     /* ...and exit */
     FreeDiskObject(dobj);
     CloseResources();
     return(0);
    }

    /* PUBSCREEN */
    if (s=FindToolType(tt,"PUBSCREEN")) PubScreenName=strdup(s);

    /* DEFAULTFONT */
    if (s=FindToolType(tt,"DEFAULTFONT"))
     DefaultFont=MatchToolValue(YesString,s);

    /* CREATEICONS */
    if (s=FindToolType(tt,"CREATEICONS"))
     CreateIcons=MatchToolValue(YesString,s);

    /* XPOS */
    if (s=FindToolType(tt,"XPOS"))
     MainWinX=strtol(s,NULL,10);

    /* YPOS */
    if (s=FindToolType(tt,"YPOS"))
     MainWinY=strtol(s,NULL,10);

    /* LISTCOLUMNS */
    if (s=FindToolType(tt,"MINLISTCOLUMNS"))
     if ((ListViewColumns=strtol(s,NULL,10))<20)
      ListViewColumns=20;

    /* LISTROWS */
    if (s=FindToolType(tt,"MINLISTROWS"))
     if ((ListViewRows=strtol(s,NULL,10))<8)
      ListViewRows=8;

    /* Get program & prefs file name. Icon type? */
    switch (dobj->do_Type) {
     case WBTOOL:    if (ProgramName=malloc(256)) {
                      *ProgramName='\0';
                      if (NameFromLock(wa->wa_Lock,ProgramName,256))
                       AddPart(ProgramName,wa->wa_Name,256);
                     }
                     break;
     case WBPROJECT: ProgramName=strdup(dobj->do_DefaultTool);
                     if (!(FromFileName=strdup(wa->wa_Name)))
                      FromFileName=PrefsFileName;
                     break;
    }

    /* Free DiskObject */
    FreeDiskObject(dobj);
   }
  } else {
   /* CLI Startup */
   struct RDArgs *rda;

   /* Parse command line */
   rda=ReadArgs(Template,(LONG *) &cmdlineparams,NULL);

   /* Get values */
   if (cmdlineparams.from) FromFileName=strdup(cmdlineparams.from);
   if (!FromFileName) FromFileName=PrefsFileName;
   if (cmdlineparams.pubsc) PubScreenName=strdup(cmdlineparams.pubsc);
   if (cmdlineparams.deffont) DefaultFont=TRUE;

   /* Free ReadArgs parameters */
   if (rda) FreeArgs(rda);

   /* USE? */
   if (cmdlineparams.use) {
    /* Copy From file to preferences file */
    CopyFile(FromFileName,PrefsFileName);

    /* ...and exit */
    CloseResources();
    return(0);
   }

   /* SAVE? */
   if (cmdlineparams.save) {
    /* Copy From file to save preferences file */
    CopyFile(FromFileName,SavePrefsFileName);

    /* ...and exit */
    CloseResources();
    return(0);
   }

   /* Get program name */
   if (ProgramName=malloc(256)) {
    *ProgramName='\0';
    GetProgramName(ProgramName,256);
   }
  }

  /* Init object lists */
  {
   int i;

   for (i=0; i<TMOBJTYPES; i++) NewList(&ObjectLists[i]);
  }

  /* Read public screen list */
  NewList(&PubScreenList);
  {
   struct List *pubsclist;

   if (pubsclist=LockPubScreenList()) {
    struct PubScreenNode *pubscnode=GetHead(pubsclist);

    /* Scan list */
    while (pubscnode) {
     struct Node *mynode;

     /* Copy entry */
     if (mynode=malloc(sizeof(struct Node)))
      if (mynode->ln_Name=strdup(pubscnode->psn_Node.ln_Name))
       /* Node allocated, add it to list */
       AddTail(&PubScreenList,mynode);
      else
       /* no memory, free node */
       free(mynode);

     /* get a pointer to next node */
     pubscnode=GetSucc(pubscnode);
    }

    /* Release public screen list */
    UnlockPubScreenList();
   }
  }

  /* Try to get the Workbench window offsets */
  if (PublicScreen=LockPubScreen(WBName)) {
   struct Window *w=PublicScreen->FirstWindow;

   /* Scan Workbench screen window list */
   while (w) {
    struct MsgPort *mp=w->UserPort;

    /* Workbench window? (Lots of safety checks) */
    if ((w->Flags & WFLG_WBENCHWINDOW) && mp &&
        ((mp->mp_Flags & PF_ACTION) == PA_SIGNAL)) {
     struct Task *t=mp->mp_SigTask;

     /* More safety checks */
     if (t && t->tc_Node.ln_Name && !strcmp(t->tc_Node.ln_Name,WBName))
      /* Window title valid? */
      if (w->Title) {
       /* Window has title, compare it to string "Workbench" */
       if (!strcmp(w->Title,WBName)) break;
      } else
       /* Window has no title, check for Workbench backdrop window */
       if ((w->Flags & (WFLG_BACKDROP|WFLG_BORDERLESS)) ==
            (WFLG_BACKDROP|WFLG_BORDERLESS))
        break;
    }

    /* next window */
    w=w->NextWindow;
   }

   /* Window found? */
   if (w)
    /* Yes. Read offsets. Backdrop window? */
    if (w->Flags & WFLG_BACKDROP) {
     /* Yes. Just read window coordinates */
     WBXOffset=w->LeftEdge;
     WBYOffset=w->TopEdge;
    } else {
     /* No */
     WBXOffset=w->LeftEdge+w->BorderLeft;
     WBYOffset=w->TopEdge+w->BorderTop;
    }

   UnlockPubScreen(NULL,PublicScreen);
  }

  /* Read Configuration */
  if (ReadConfigFile(FromFileName)) {
   /* Lock default public screen */
   if (PublicScreen=LockPubScreen(PubScreenName)) {
    WBScreen=(PublicScreen->Flags & SCREENTYPE) == WBENCHSCREEN;

    /* Get visual info */
    if (ScreenVI=GetVisualInfo(PublicScreen,TAG_DONE)) {
     /* Which font should be used? */
     if (DefaultFont) {
      struct TextFont *tf=GfxBase->DefaultFont;

      /* Read system default font values */
      ScreenTextAttr.ta_Name=tf->tf_Message.mn_Node.ln_Name;
      ScreenTextAttr.ta_YSize=tf->tf_YSize;
      ScreenTextAttr.ta_Style=tf->tf_Style;
      ScreenTextAttr.ta_Flags=tf->tf_Flags;
     }
     else
      /* Copy public screen TextAttr */
      ScreenTextAttr=*(PublicScreen->Font);

     /* Limit font size. Fonts must be higher than 7 pixels! */
     if (ScreenTextAttr.ta_YSize<8) ScreenTextAttr.ta_YSize=8;

     /* Open screen font */
     if (ScreenFont=OpenDiskFont(&ScreenTextAttr)) {

      /* Calculate requester button image */
      if (CalcReqButtonImage()) {
       ULONG IDCMPSignalMask;

       /* Init global TmpRastPort */
       InitRastPort(&TmpRastPort);
       SetFont(&TmpRastPort,ScreenFont);

       /* Init windows */
       {
        UWORD left=PublicScreen->WBorLeft+INTERWIDTH/2;
        UWORD fheight=ScreenFont->tf_YSize+INTERHEIGHT;

        WindowTop=PublicScreen->WBorTop+PublicScreen->Font->ta_YSize+1;

        InitMainWindow(left,fheight);
        InitExecEditWindow(left,fheight);
        InitImageEditWindow(left,fheight);
        InitSoundEditWindow(left,fheight);
        InitMenuEditWindow(left,fheight);
        InitIconEditWindow(left,fheight);
        InitDockEditWindow(left,fheight);
        InitAccessEditWindow(left,fheight);
        InitSelectWindow(left,fheight);
        InitMoveWindow(left,fheight);
        InitDockListEditWindow(left,fheight);
        InitListRequester(left,fheight);
       }

       /* Init global NewGadget structure */
       NewGadget.ng_TextAttr=&ScreenTextAttr;
       NewGadget.ng_VisualInfo=ScreenVI;
       NewGadget.ng_UserData=NULL;

       /* Open main window */
       if (IDCMPSignalMask=OpenMainWindow(MainWinX,MainWinY)) {
        ULONG PrefsPortSignalMask,AppMsgPortSignalMask,SignalMask;
        BPTR oldcd;
        BOOL notend=TRUE;

        /* Init signal masks */
        PrefsPortSignalMask=1L << PrefsPort->mp_SigBit;
        AppMsgPortSignalMask=1L << AppMsgPort->mp_SigBit;
        SignalMask=IDCMPSignalMask | PrefsPortSignalMask |
                    AppMsgPortSignalMask;

        /* Go to boot directory */
        oldcd=CurrentDir(NULL);

        /* Main event loop */
        while (notend) {
         ULONG GotSigs;

/*         DEBUG_PRINTF("CONF: Waiting for messages...\n"); */

         /* Wait for messages */
         GotSigs=Wait(SignalMask);

         /* IDCMP Event? */
         if (GotSigs & IDCMPSignalMask) {
          struct IntuiMessage *msg;

          /* Scan IDCMP port */
          while (msg=GT_GetIMsg(IDCMPPort)) {
           void *data;
           HandleIDCMPFuncPtr func=(HandleIDCMPFuncPtr)
                                    msg->IDCMPWindow->UserData;

           /* Handle IDCMP Message. Window closed? */
           if (data=(*func)(msg))
            /* Yes. Main window closed? */
            if (UpdateWindow)
             /* No, call update function */
             (*UpdateWindow)(data);
            else
             /* Yes, quit program */
             notend=FALSE;
           else
            /* No, reply message */
            GT_ReplyIMsg(msg);
          }
         }

         /* Prefs port signal? */
         if (GotSigs & PrefsPortSignalMask)
          /* Yes. Move current window to front */
          WindowToFront(CurrentWindow);

         /* Application message arrived? */
         if (GotSigs & AppMsgPortSignalMask) {
          struct AppMessage *msg;

          /* Scan AppMsg port */
          while (msg=(struct AppMessage *) GetMsg(AppMsgPort)) {
           /* Application message handling function valid? */
           if (HandleAppMsg)
            /* Yes, handle message */
            (*HandleAppMsg)(msg);

           /* Reply message */
           ReplyMsg((struct Message *) msg);
          }
         }
        }

        /* Go back to old directory */
        CurrentDir(oldcd);

        /* Close Main Window */
        CloseMainWindow();

        /* End of program. Clear public screen pointer */
        PublicScreen=NULL;
       }
       FreeReqButtonImage();
      }
      CloseFont(ScreenFont);
     }
     FreeVisualInfo(ScreenVI);
    }
    if (PublicScreen) UnlockPubScreen(NULL,PublicScreen);
   }
  }

  /* Free public screen list */
  {
   struct Node *n1,*n2=GetHead(&PubScreenList);

   while (n1=n2) {
    /* Get next node */
    n2=GetSucc(n1);

    /* Free node */
    free(n1->ln_Name);
    free(n1);
   }
  }

  /* Free all object nodes */
  FreeAllObjects();
 }

 /* Closing down... */
 CloseResources();
 return(0);
}

/* CLI entry point */
int main(int argc, char *argv[])
{
 return(mainprogram(NULL));
}

/* WB entry point */
int wbmain(struct WBStartup *wbs)
{
 struct WBArg *wa;
 BPTR dirlock;
 int rc;

 /* Get last WBArg */
 wa=&wbs->sm_ArgList[wbs->sm_NumArgs-1];

 /* Go to icon directory */
 dirlock=CurrentDir(wa->wa_Lock);

 /* Do it :-) */
 rc=mainprogram(wa);

 /* Go back... */
 CurrentDir(dirlock);
 return(rc);
}
