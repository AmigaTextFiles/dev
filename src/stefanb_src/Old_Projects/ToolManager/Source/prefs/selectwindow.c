/*
 * selectwindow.c  V2.1
 *
 * AppMessage select window handling
 *
 * (c) 1990-1993 Stefan Becker
 */

#include "ToolManagerConf.h"

/* Window data */
static struct Gadget *gl;          /* Gadget list */
static struct Window *w;           /* Window */
static struct MsgPort *wp;         /* Window user port */
static UWORD ww,wh;                /* Window size */
static struct WBArg *CurrentWBArg;
static ULONG SelectAction=0;
static ULONG OldSelAction=0;

/* Action codes */
#define SELACT_EXEC     0
#define SELACT_IMAGE    1
#define SELACT_MENU     2
#define SELACT_ICON     3
#define SELACT_MENUICON 4
#define SELACTIONS      5

/* Gadget data */
#define GAD_NAME_STR 0
#define GAD_OBJ_TXT  1
#define GAD_OBJECT   2
#define GAD_OK       3
#define GAD_CANCEL   4
#define GADGETS      5
static struct GadgetData gdata[GADGETS];

/* Gadget tags */
static struct TagItem nametags[]={GTST_String,   NULL,
                                  GTST_MaxChars, SGBUFLEN,
                                  TAG_DONE};

static char *mxlabels[SELACTIONS+1]={NULL, NULL, NULL, NULL, NULL, NULL};
static struct TagItem mxtags[]={GTMX_Labels, (ULONG) mxlabels,
                                GTMX_Active, 0,
                                GTMX_Scaled, TRUE,
                                TAG_DONE};

/* Gadget vanilla key data */
#define KEY_NAME   0
#define KEY_OBJECT 1
#define KEY_OK     2
#define KEY_CANCEL 3
static char KeyArray[KEY_CANCEL+1];


/* Init select window */
void InitSelectWindow(UWORD left, UWORD fheight)
{
 ULONG labwidth,mxwidth,butwidth;
 ULONG strheight=fheight+2;
 ULONG i,tmp;
 struct GadgetData *gd;

 /* Init strings */
 gdata[GAD_NAME_STR].name=AppStrings[MSG_WINDOW_NAME_GAD];
 gdata[GAD_OBJ_TXT].name =AppStrings[MSG_SELECTWIN_OBJECT_GAD];
 mxlabels[0]             =AppStrings[MSG_MAINWIN_TYPE_EXEC_CYCLE_LABEL];
 mxlabels[1]             =AppStrings[MSG_MAINWIN_TYPE_IMAGE_CYCLE_LABEL];
 mxlabels[2]             =AppStrings[MSG_SELECTWIN_MENU_MX_LABEL];
 mxlabels[3]             =AppStrings[MSG_SELECTWIN_ICON_MX_LABEL];
 mxlabels[4]             =AppStrings[MSG_SELECTWIN_MENUICON_MX_LABEL];
 gdata[GAD_OK].name      =AppStrings[MSG_WINDOW_OK_GAD];
 gdata[GAD_CANCEL].name  =AppStrings[MSG_WINDOW_CANCEL_GAD];

 /* Calculate maximum label width for name gadget */
 labwidth=TextLength(&TmpRastPort,AppStrings[MSG_WINDOW_NAME_GAD],
                     strlen(AppStrings[MSG_WINDOW_NAME_GAD]))+INTERWIDTH;

 /* Calculate minimum window width */
 ww=labwidth+TextLength(&TmpRastPort,AppStrings[MSG_EXECWIN_NEWNAME],
                        strlen(AppStrings[MSG_EXECWIN_NEWNAME]))
    +4*INTERWIDTH;

 /* Calculate maximum MX gadget width */
 {
  char **s;

  mxwidth=0;
  s=mxlabels;
  for (i=0; i<=4; i++, s++)
   if ((tmp=TextLength(&TmpRastPort,*s,strlen(*s))) > mxwidth)
    mxwidth=tmp;
  mxwidth+=CHECKBOX_WIDTH;
 }
 if (mxwidth > ww) ww=mxwidth+INTERWIDTH;

 /* Calculate button gadgets width */
 gd=&gdata[GAD_OK];
 butwidth=TextLength(&TmpRastPort,gd->name,strlen(gd->name));
 gd++;
 if ((tmp=TextLength(&TmpRastPort,gd->name,strlen(gd->name))) > butwidth)
  butwidth=tmp;
 butwidth+=2*INTERWIDTH;
 if ((tmp=2*(butwidth+INTERWIDTH)) > ww) ww=tmp;

 /* window height */
 wh=8*fheight+5*INTERHEIGHT-8;

 /* Init gadgets */
 gd=gdata;
 tmp=WindowTop+INTERHEIGHT;

 /* Name string gadget */
 gd->type=STRING_KIND;
 gd->flags=PLACETEXT_LEFT;
 gd->tags=nametags;
 gd->left=labwidth+left;
 gd->top=tmp;
 gd->width=ww-labwidth-INTERWIDTH;
 gd->height=strheight;
 tmp+=strheight+INTERHEIGHT;

 /* Object text gadget */
 gd++;
 gd->type=TEXT_KIND;
 gd->flags=PLACETEXT_IN;
 gd->left=left;
 gd->top=tmp;
 gd->width=ww-INTERWIDTH;
 gd->height=fheight;
 tmp+=fheight+INTERHEIGHT;

 /* Object MX gadget */
 gd++;
 gd->type=MX_KIND;
 gd->flags=PLACETEXT_RIGHT;
 gd->tags=mxtags;
 gd->left=left+(ww-mxwidth-INTERWIDTH)/2;
 gd->top=tmp;
 gd->width=MX_WIDTH;
 gd->height=fheight-INTERHEIGHT;
 tmp+=5*fheight-10+INTERHEIGHT;

 /* OK button gadget */
 gd++;
 gd->type=BUTTON_KIND;
 gd->flags=PLACETEXT_IN;
 gd->left=left;
 gd->top=tmp;
 gd->width=butwidth;
 gd->height=fheight;

 /* Cancel button gadget */
 gd++;
 gd->type=BUTTON_KIND;
 gd->flags=PLACETEXT_IN;
 gd->left=ww-butwidth-INTERWIDTH+left;
 gd->top=tmp;
 gd->width=butwidth;
 gd->height=fheight;

 /* Init vanilla key array */
 KeyArray[KEY_NAME]  =FindVanillaKey(gdata[GAD_NAME_STR].name);
 KeyArray[KEY_OBJECT]=FindVanillaKey(gdata[GAD_OBJ_TXT].name);
 KeyArray[KEY_OK]    =FindVanillaKey(gdata[GAD_OK].name);
 KeyArray[KEY_CANCEL]=FindVanillaKey(gdata[GAD_CANCEL].name);
}

/* Free WBArg */
static void FreeWBArg(struct WBArg *wa)
{
 if (wa->wa_Name) free(wa->wa_Name);
 if (wa->wa_Lock) UnLock(wa->wa_Lock);

 FreeMem(wa,sizeof(struct WBArg));
}

/* Copy WBArg */
static struct WBArg *CopyWBArg(struct WBArg *oldwa)
{
 struct WBArg *newwa;

 /* Allocate memory for new WBArg */
 if (newwa=AllocMem(sizeof(struct WBArg),MEMF_PUBLIC|MEMF_CLEAR)) {

  /* Copy WBArg */
  if ((newwa->wa_Lock=DupLock(oldwa->wa_Lock)) &&
      (newwa->wa_Name=(BYTE *) strdup(oldwa->wa_Name)))
   /* Return pointer to new */
   return(newwa);

  FreeWBArg(newwa);
 }
 /* Call failed */
 return(NULL);
}

/* Activate name string gadget */
static void ActivateNameGadget(void)
{
 ActivateGadget(gdata[GAD_NAME_STR].gadget,w,NULL);
}

/* Open select window */
BOOL OpenSelectWindow(struct WBArg *wa, struct Window *parent)
{
 /* Copy WBArg */
 if (CurrentWBArg=CopyWBArg(wa)) {
  /* Set tags */
  nametags[0].ti_Data=(ULONG) CurrentWBArg->wa_Name;
  mxtags[1].ti_Data=SelectAction;

  /* Create gadgets */
  if (gl=CreateGadgetList(gdata,GADGETS)) {
   /* Open window */
   if (w=OpenWindowTags(NULL,WA_Left,        parent->LeftEdge,
                             WA_Top,         parent->TopEdge+WindowTop,
                             WA_InnerWidth,  ww,
                             WA_InnerHeight, wh,
                             WA_AutoAdjust,  TRUE,
                             WA_Title,       AppStrings[MSG_SELECTWIN_TITLE],
                             WA_PubScreen,   PublicScreen,
                             WA_Flags,       WFLG_CLOSEGADGET|WFLG_DRAGBAR|
                                             WFLG_DEPTHGADGET|WFLG_RMBTRAP|
                                             WFLG_ACTIVATE,
                             TAG_DONE)) {
    /* Add gadgets to window */
    AddGList(w,gl,(UWORD) -1,(UWORD) -1,NULL);
    RefreshGList(gl,w,NULL,(UWORD) -1);
    GT_RefreshWindow(w,NULL);

    /* Activate name string gadget */
    ActivateNameGadget();

    /* Set local variables */
    w->UserPort=IDCMPPort;
    w->UserData=(BYTE *) HandleSelectWindowIDCMP;
    ModifyIDCMP(w,IDCMP_CLOSEWINDOW|IDCMP_REFRESHWINDOW|BUTTONIDCMP|
                  STRINGIDCMP|MXIDCMP|IDCMP_VANILLAKEY);
    CurrentWindow=w;
    OldSelAction=SelectAction;

    /* All OK. */
    return(TRUE);
   }
   FreeGadgets(gl);
  }
  FreeWBArg(CurrentWBArg);
 }
 /* Call failed */
 return(FALSE);
}

/* Close select window */
static void CloseSelectWindow(void)
{
 /* Free resources */
 RemoveGList(w,gl,(UWORD) -1);
 CloseWindowSafely(w);
 FreeGadgets(gl);
}

/* OK gadget function */
static void *OKGadgetFunc(void)
{
 char *name;

 /* Get object name */
 name=((struct StringInfo *) gdata[GAD_NAME_STR].gadget->SpecialInfo)->Buffer;

 switch(SelectAction) {
  case SELACT_EXEC: {
    struct Node *en;

    /* Create exec node */
    if (en=CreateExecNode(name,CurrentWBArg)) {
     /* Add node */
     AddHead(&ObjectLists[TMOBJTYPE_EXEC],en);
     return((void *) 1);
    }
   }
   break;
  case SELACT_IMAGE: {
    struct Node *in;

    /* Create exec node */
    if (in=CreateImageNode(name,CurrentWBArg)) {
     /* Add node */
     AddHead(&ObjectLists[TMOBJTYPE_IMAGE],in);
     return((void *) 1);
    }
   }
   break;
  case SELACT_MENU:     {
    struct Node *en;

    /* Create exec node */
    if (en=CreateExecNode(name,CurrentWBArg)) {
     struct Node *mn;

     /* Create menu node */
     if (mn=CreateMenuNode(name)) {

      /* Add nodes */
      AddHead(&ObjectLists[TMOBJTYPE_EXEC],en);
      AddHead(&ObjectLists[TMOBJTYPE_MENU],mn);
      return((void *) 1);
     }
     FreeExecNode(en);
    }
   }
   break;
  case SELACT_ICON: {
    struct Node *en;

    /* Create exec node */
    if (en=CreateExecNode(name,CurrentWBArg)) {
     struct Node *in;

     /* Create image node */
     if (in=CreateImageNode(name,CurrentWBArg)) {
      struct Node *icn;

      /* Create icon node */
      if (icn=CreateIconNode(name)) {

       /* Add nodes */
       AddHead(&ObjectLists[TMOBJTYPE_EXEC],en);
       AddHead(&ObjectLists[TMOBJTYPE_IMAGE],in);
       AddHead(&ObjectLists[TMOBJTYPE_ICON],icn);
       return((void *) 1);
      }
      FreeImageNode(in);
     }
     FreeExecNode(en);
    }
   }
   break;
  case SELACT_MENUICON: {
    struct Node *en;

    /* Create exec node */
    if (en=CreateExecNode(name,CurrentWBArg)) {
     struct Node *in;

     /* Create image node */
     if (in=CreateImageNode(name,CurrentWBArg)) {
      struct Node *mn;

      /* Create menu node */
      if (mn=CreateMenuNode(name)) {
       struct Node *icn;

       /* Create icon node */
       if (icn=CreateIconNode(name)) {

        /* Add nodes */
        AddHead(&ObjectLists[TMOBJTYPE_EXEC],en);
        AddHead(&ObjectLists[TMOBJTYPE_IMAGE],in);
        AddHead(&ObjectLists[TMOBJTYPE_MENU],mn);
        AddHead(&ObjectLists[TMOBJTYPE_ICON],icn);
        return((void *) 1);
       }
       FreeMenuNode(mn);
      }
      FreeImageNode(in);
     }
     FreeExecNode(en);
    }
   }
   break;
 }
 return((void *) -1);
}

/* Handle select window IDCMP events */
void *HandleSelectWindowIDCMP(struct IntuiMessage *msg)
{
 void *rc=NULL;

 /* Which IDCMP class? */
 switch (msg->Class) {
  case IDCMP_CLOSEWINDOW:   rc=(void *) -1;
                            SelectAction=OldSelAction;
                            break;
  case IDCMP_REFRESHWINDOW: GT_BeginRefresh(w);
                            GT_EndRefresh(w,TRUE);
                            break;
  case IDCMP_GADGETUP:
   switch (((struct Gadget *) msg->IAddress)->GadgetID) {
    case GAD_OK:     rc=OKGadgetFunc();
                     break;
    case GAD_CANCEL: rc=(void *) -1;
                     SelectAction=OldSelAction;
                     break;
   }
   break;
  case IDCMP_GADGETDOWN:
   if (((struct Gadget *) msg->IAddress)->GadgetID==GAD_OBJECT)
    SelectAction=msg->Code;
   break;
  case IDCMP_VANILLAKEY:
   switch (MatchVanillaKey(msg->Code,KeyArray)) {
    case KEY_NAME:   ActivateNameGadget();
                     break;
    case KEY_OBJECT: /* Forward or backward cycle? */
                     if (islower(msg->Code))
                      SelectAction=(SelectAction+1) % SELACTIONS;
                     else
                      SelectAction=(SelectAction>0) ? SelectAction-1 :
                                                      SELACTIONS-1;

                     /* Set cycle gadget */
                     GT_SetGadgetAttrs(gdata[GAD_OBJECT].gadget,w,NULL,
                                       GTMX_Active, SelectAction,
                                       TAG_DONE);

                     break;
    case KEY_OK:     rc=OKGadgetFunc();
                     break;
    case KEY_CANCEL: rc=(void *) -1;
                     SelectAction=OldSelAction;
                     break;
   }
   break;
 }

 /* Close window? */
 if (rc) {
  /* Yes. But first reply message!!! */
  GT_ReplyIMsg(msg);
  FreeWBArg(CurrentWBArg);
  CloseSelectWindow();
 }

 return(rc);
}
