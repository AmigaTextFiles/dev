/*
 * execwindow.c  V2.1
 *
 * exec edit window handling
 *
 * (c) 1990-1993 Stefan Becker
 */

#include "ToolManagerConf.h"

/* Exec node */
struct ExecNode {
                 struct Node  en_Node;
                 ULONG        en_Flags;
                 UWORD        en_ExecType;
                 WORD         en_Priority;
                 LONG         en_Delay;
                 ULONG        en_Stack;
                 char        *en_Command;
                 char        *en_CurrentDir;
                 char        *en_HotKey;
                 char        *en_Output;
                 char        *en_Path;
                 char        *en_PubScreen;
                };

/* Window data */
static struct Gadget *gl;             /* Gadget list */
static struct Window *w;              /* Window */
static void *aw;                      /* AppWindow pointer */
static UWORD ww,wh;                   /* Window size */
static struct ExecNode *CurrentNode;
static ULONG CurrentGadgetNum;
static BOOL ReqOpen;
static struct Requester DummyReq;
#define WINDOW_IDCMP (IDCMP_CLOSEWINDOW|IDCMP_REFRESHWINDOW|BUTTONIDCMP|\
                      CHECKBOXIDCMP|CYCLEIDCMP|INTEGERIDCMP|STRINGIDCMP|\
                      IDCMP_VANILLAKEY)

/* Gadget data */
#define GAD_NAME_STR      0 /* Gadgets with labels (left side) */
#define GAD_EXECTYPE      1
#define GAD_COMMAND_BUT   2
#define GAD_COMMAND_TXT   3
#define GAD_COMMAND_STR   4
#define GAD_HOTKEY_STR    5
#define GAD_STACK_INT     6
#define GAD_PRIORITY_INT  7
#define GAD_DELAY_INT     8

#define GAD_CURDIR_BUT    9 /* Gadgets with labels (right side) */
#define GAD_PATH_BUT     10
#define GAD_OUTPUT_BUT   11
#define GAD_PSCREEN_BUT  12
#define GAD_CURDIR_TXT   13
#define GAD_PATH_TXT     14
#define GAD_OUTPUT_TXT   15
#define GAD_PSCREEN_TXT  16

#define GAD_ARGS         17 /* Checkbox gadgets (right side) */
#define GAD_TOFRONT      18

#define GAD_CURDIR_STR   19
#define GAD_PATH_STR     20
#define GAD_OUTPUT_STR   21
#define GAD_PSCREEN_STR  22

#define GAD_OK           23 /* Button gadgets */
#define GAD_CANCEL       24
#define GADGETS          25
static struct GadgetData gdata[GADGETS];

/* Gadget tags */
static struct TagItem nametags[]={GTST_String,   NULL,
                                  GTST_MaxChars, SGBUFLEN,
                                  TAG_DONE};

static char *cyclelabels[]={"CLI", "WB", "ARexx", "Dock", "Hot Key", "Network",
                            NULL};
static struct TagItem cycletags[]={GTCY_Labels, (ULONG) cyclelabels,
                                   GTCY_Active, 0,
                                   TAG_DONE};

static struct TagItem commtags[]={GTST_String,   NULL,
                                  GTST_MaxChars, SGBUFLEN,
                                  TAG_DONE};

static struct TagItem curdtags[]={GTST_String,   NULL,
                                  GTST_MaxChars, SGBUFLEN,
                                  TAG_DONE};

static struct TagItem hotktags[]={GTST_String,   NULL,
                                  GTST_MaxChars, SGBUFLEN,
                                  TAG_DONE};

static struct TagItem outptags[]={GTST_String,   NULL,
                                  GTST_MaxChars, SGBUFLEN,
                                  TAG_DONE};

static struct TagItem pathtags[]={GTST_String,   NULL,
                                  GTST_MaxChars, SGBUFLEN,
                                  TAG_DONE};

static struct TagItem pbsctags[]={GTST_String,   NULL,
                                  GTST_MaxChars, SGBUFLEN,
                                  TAG_DONE};

static struct TagItem stacktags[]={GTIN_Number,   0,
                                   GTIN_MaxChars, 10,
                                   TAG_DONE};

static struct TagItem priotags[]={GTIN_Number,   0,
                                  GTIN_MaxChars, 10,
                                  TAG_DONE};

static struct TagItem delaytags[]={GTIN_Number,   0,
                                   GTIN_MaxChars, 10,
                                   TAG_DONE};

static struct TagItem argstags[]={GTCB_Checked, FALSE,
                                  GTCB_Scaled,  TRUE,
                                  TAG_DONE};

static struct TagItem tofronttags[]={GTCB_Checked, FALSE,
                                     GTCB_Scaled,  TRUE,
                                     TAG_DONE};

/* Gadget vanilla key data */
#define KEY_NAME     0
#define KEY_TYPE     1
#define KEY_COMMAND  2
#define KEY_HOTKEY   3
#define KEY_STACK    4
#define KEY_PRIO     5
#define KEY_DELAY    6
#define KEY_CURDIR   7
#define KEY_PATH     8
#define KEY_OUTPUT   9
#define KEY_PSCREEN 10
#define KEY_ARGS    11
#define KEY_FRONT   12
#define KEY_OK      13
#define KEY_CANCEL  14
static char KeyArray[KEY_CANCEL+1];

/* Init exec edit window */
void InitExecEditWindow(UWORD left, UWORD fheight)
{
 ULONG llabwidth,lgadwidth,rlabwidth,rgadwidth;
 ULONG cbwidth,butwidth,minstringwidth;
 ULONG strheight=fheight+2;
 ULONG i,tmp,yadd;
 struct GadgetData *gd;

 /* Init strings */
 gdata[GAD_NAME_STR].name     =AppStrings[MSG_WINDOW_NAME_GAD];
 gdata[GAD_EXECTYPE].name     =AppStrings[MSG_EXECWIN_EXECTYPE_GAD];
 gdata[GAD_COMMAND_BUT].name  ="";
 gdata[GAD_COMMAND_TXT].name  =AppStrings[MSG_WINDOW_COMMAND_GAD];
 gdata[GAD_COMMAND_STR].name  ="";
 gdata[GAD_HOTKEY_STR].name   =AppStrings[MSG_WINDOW_HOTKEY_GAD];
 gdata[GAD_STACK_INT].name    =AppStrings[MSG_EXECWIN_STACK_GAD];
 gdata[GAD_PRIORITY_INT].name =AppStrings[MSG_EXECWIN_PRIORITY_GAD];
 gdata[GAD_DELAY_INT].name    =AppStrings[MSG_EXECWIN_DELAY_GAD];
 gdata[GAD_CURDIR_TXT].name   =AppStrings[MSG_EXECWIN_CURRENTDIR_GAD];
 gdata[GAD_PATH_TXT].name     =AppStrings[MSG_EXECWIN_PATH_GAD];
 gdata[GAD_OUTPUT_TXT].name   =AppStrings[MSG_EXECWIN_OUTPUT_GAD];
 gdata[GAD_PSCREEN_TXT].name  =AppStrings[MSG_WINDOW_PUBSCREEN_GAD];
 gdata[GAD_ARGS].name         =AppStrings[MSG_EXECWIN_ARGUMENTS_GAD];
 gdata[GAD_TOFRONT].name      =AppStrings[MSG_EXECWIN_TOFRONT_GAD];
 gdata[GAD_OK].name           =AppStrings[MSG_WINDOW_OK_GAD];
 gdata[GAD_CANCEL].name       =AppStrings[MSG_WINDOW_CANCEL_GAD];

 /* Calculate maximum label width (left side) */
 llabwidth=0;
 gd=&gdata[GAD_NAME_STR];
 for (i=GAD_NAME_STR; i<=GAD_DELAY_INT; i++, gd++)
  if ((tmp=TextLength(&TmpRastPort,gd->name,strlen(gd->name))) > llabwidth)
   llabwidth=tmp;
 llabwidth+=INTERWIDTH;

 /* Calculate maximum gadget width (left side) */
 minstringwidth=TextLength(&TmpRastPort,AppStrings[MSG_EXECWIN_NEWNAME],
                           strlen(AppStrings[MSG_EXECWIN_NEWNAME]))
                +2*INTERWIDTH;
 lgadwidth=minstringwidth;

 /* Calculate maximum label width (right side) */
 rlabwidth=0;
 gd=&gdata[GAD_CURDIR_TXT];
 for (i=GAD_CURDIR_TXT; i<=GAD_PSCREEN_TXT; i++, gd++)
  if ((tmp=TextLength(&TmpRastPort,gd->name,strlen(gd->name))) > rlabwidth)
   rlabwidth=tmp;
 rlabwidth+=INTERWIDTH;

 /* Calculate maximum gadget width (right side) */
 rgadwidth=minstringwidth;

 /* Calculate maximum checkbox gadget width */
 cbwidth=0;
 gd=&gdata[GAD_ARGS];
 for (i=GAD_ARGS; i<=GAD_TOFRONT; i++, gd++)
  if ((tmp=TextLength(&TmpRastPort,gd->name,strlen(gd->name))) > cbwidth)
   cbwidth=tmp;
 cbwidth+=CHECKBOX_WIDTH+INTERWIDTH;
 if ((rlabwidth+rgadwidth+INTERWIDTH) < cbwidth)
  rgadwidth=cbwidth-rlabwidth-INTERWIDTH;

 /* Calculate minimum window width */
 ww=llabwidth+lgadwidth+rlabwidth+rgadwidth+4*INTERWIDTH;

 /* Calculate button gadgets width */
 gd=&gdata[GAD_OK];
 butwidth=TextLength(&TmpRastPort,gd->name,strlen(gd->name));
 gd++;
 if ((tmp=TextLength(&TmpRastPort,gd->name,strlen(gd->name))) > butwidth)
  butwidth=tmp;
 butwidth+=2*INTERWIDTH;
 if ((tmp=2*(butwidth+INTERWIDTH)) > ww) ww=tmp;

 /* window height */
 wh=8*fheight+9*INTERHEIGHT+14;

 /* Init gadgets */
 gd=gdata;
 yadd=strheight+INTERHEIGHT;
 tmp=(ww-llabwidth-lgadwidth-rlabwidth-rgadwidth-4*INTERWIDTH)/2;
 lgadwidth+=tmp; /* String gadget width (left) */
 rgadwidth+=tmp; /* String gadget width (right) */
 llabwidth+=left;
 tmp=WindowTop+INTERHEIGHT;

 /* (left side) Name string gadget */
 gd->type=STRING_KIND;
 gd->flags=PLACETEXT_LEFT;
 gd->tags=nametags;
 gd->left=llabwidth;
 gd->top=tmp;
 gd->width=lgadwidth;
 gd->height=strheight;
 tmp+=yadd;

 /* cycle gadget */
 gd++;
 gd->type=CYCLE_KIND;
 gd->flags=PLACETEXT_LEFT;
 gd->tags=cycletags;
 gd->left=llabwidth;
 gd->top=tmp;
 gd->width=lgadwidth;
 gd->height=strheight;
 tmp+=yadd;

 /* Command button gadget */
 gd++;
 gd->name=NULL;
 gd->type=GENERIC_KIND;
 gd->flags=0;
 gd->left=llabwidth;
 gd->top=tmp;
 gd->width=REQBUTTONWIDTH;
 gd->height=strheight;

 /* Command text gadget */
 gd++;
 gd->type=TEXT_KIND;
 gd->flags=PLACETEXT_LEFT;
 gd->left=llabwidth;
 gd->top=tmp+strheight/2;
 gd->width=0;
 gd->height=0;

 /* Command string gadget */
 gd++;
 gd->name=NULL;
 gd->type=STRING_KIND;
 gd->tags=commtags;
 gd->left=llabwidth+REQBUTTONWIDTH;
 gd->top=tmp;
 gd->width=lgadwidth-REQBUTTONWIDTH;
 gd->height=strheight;
 tmp+=yadd;

 /* HotKey string gadget */
 gd++;
 gd->type=STRING_KIND;
 gd->flags=PLACETEXT_LEFT;
 gd->tags=hotktags;
 gd->left=llabwidth;
 gd->top=tmp;
 gd->width=lgadwidth;
 gd->height=strheight;
 tmp+=yadd;

 /* Stack integer gadget */
 gd++;
 gd->type=INTEGER_KIND;
 gd->flags=PLACETEXT_LEFT;
 gd->tags=stacktags;
 gd->left=llabwidth;
 gd->top=tmp;
 gd->width=lgadwidth;
 gd->height=strheight;
 tmp+=yadd;

 /* Priority integer gadget */
 gd++;
 gd->type=INTEGER_KIND;
 gd->flags=PLACETEXT_LEFT;
 gd->tags=priotags;
 gd->left=llabwidth;
 gd->top=tmp;
 gd->width=lgadwidth;
 gd->height=strheight;
 tmp+=yadd;

 /* Delay integer gadget */
 gd++;
 gd->type=INTEGER_KIND;
 gd->flags=PLACETEXT_LEFT;
 gd->tags=delaytags;
 gd->left=llabwidth;
 gd->top=tmp;
 gd->width=lgadwidth;
 gd->height=strheight;

 /* (right side) Button gadgets */
 llabwidth=ww-INTERWIDTH-REQBUTTONWIDTH-rgadwidth+left;
 tmp=WindowTop+INTERHEIGHT;
 gd++;
 for (i=GAD_CURDIR_BUT; i<=GAD_PSCREEN_BUT; i++, gd++) {
  gd->type=GENERIC_KIND;
  gd->flags=0;
  gd->left=llabwidth;
  gd->top=tmp;
  gd->width=REQBUTTONWIDTH;
  gd->height=strheight;
  tmp+=yadd;
 }

 /* (right side) dummy text gadgets */
 tmp=WindowTop+strheight/2+INTERHEIGHT;
 for (i=GAD_CURDIR_TXT; i<=GAD_PSCREEN_TXT; i++, gd++) {
  gd->type=TEXT_KIND;
  gd->flags=PLACETEXT_LEFT;
  gd->left=llabwidth;
  gd->top=tmp;
  gd->width=0;
  gd->height=0;
  tmp+=yadd;
 }

 /* Arguments checkbox gadget */
 lgadwidth=rgadwidth+rlabwidth+INTERWIDTH-cbwidth;
 rlabwidth=llabwidth-rlabwidth+lgadwidth/2;
 gd->type=CHECKBOX_KIND;
 gd->flags=PLACETEXT_RIGHT;
 gd->tags=argstags;
 gd->left=rlabwidth;
 gd->top=++tmp;
 gd->width=CHECKBOX_WIDTH;
 gd->height=fheight-INTERHEIGHT;
 tmp+=yadd;

 /* ToFront checkbox gadget */
 gd++;
 gd->type=CHECKBOX_KIND;
 gd->flags=PLACETEXT_RIGHT;
 gd->tags=tofronttags;
 gd->left=rlabwidth;
 gd->top=tmp;
 gd->width=CHECKBOX_WIDTH;
 gd->height=fheight-INTERHEIGHT;

 /* Current Directory string gadget */
 tmp=WindowTop+INTERHEIGHT;
 llabwidth+=REQBUTTONWIDTH;
 gd++;
 gd->type=STRING_KIND;
 gd->flags=PLACETEXT_LEFT;
 gd->tags=curdtags;
 gd->left=llabwidth;
 gd->top=tmp;
 gd->width=rgadwidth;
 gd->height=strheight;
 tmp+=yadd;

 /* Path string gadget */
 gd++;
 gd->type=STRING_KIND;
 gd->flags=PLACETEXT_LEFT;
 gd->tags=pathtags;
 gd->left=llabwidth;
 gd->top=tmp;
 gd->width=rgadwidth;
 gd->height=strheight;
 tmp+=yadd;

 /* Output string gadget */
 gd++;
 gd->type=STRING_KIND;
 gd->flags=PLACETEXT_LEFT;
 gd->tags=outptags;
 gd->left=llabwidth;
 gd->top=tmp;
 gd->width=rgadwidth;
 gd->height=strheight;
 tmp+=yadd;

 /* Public Screen string gadget */
 gd++;
 gd->type=STRING_KIND;
 gd->flags=PLACETEXT_LEFT;
 gd->tags=pbsctags;
 gd->left=llabwidth;
 gd->top=tmp;
 gd->width=rgadwidth;
 gd->height=strheight;

 /* OK button gadget */
 tmp=WindowTop+7*strheight+8*INTERHEIGHT;
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
 KeyArray[KEY_NAME]   =FindVanillaKey(gdata[GAD_NAME_STR].name);
 KeyArray[KEY_TYPE]   =FindVanillaKey(gdata[GAD_EXECTYPE].name);
 KeyArray[KEY_COMMAND]=FindVanillaKey(gdata[GAD_COMMAND_TXT].name);
 KeyArray[KEY_HOTKEY] =FindVanillaKey(gdata[GAD_HOTKEY_STR].name);
 KeyArray[KEY_STACK]  =FindVanillaKey(gdata[GAD_STACK_INT].name);
 KeyArray[KEY_PRIO]   =FindVanillaKey(gdata[GAD_PRIORITY_INT].name);
 KeyArray[KEY_DELAY]  =FindVanillaKey(gdata[GAD_DELAY_INT].name);
 KeyArray[KEY_CURDIR] =FindVanillaKey(gdata[GAD_CURDIR_TXT].name);
 KeyArray[KEY_PATH]   =FindVanillaKey(gdata[GAD_PATH_TXT].name);
 KeyArray[KEY_OUTPUT] =FindVanillaKey(gdata[GAD_OUTPUT_TXT].name);
 KeyArray[KEY_PSCREEN]=FindVanillaKey(gdata[GAD_PSCREEN_TXT].name);
 KeyArray[KEY_ARGS]   =FindVanillaKey(gdata[GAD_ARGS].name);
 KeyArray[KEY_FRONT]  =FindVanillaKey(gdata[GAD_TOFRONT].name);
 KeyArray[KEY_OK]     =FindVanillaKey(gdata[GAD_OK].name);
 KeyArray[KEY_CANCEL] =FindVanillaKey(gdata[GAD_CANCEL].name);

 /* Init dummy requester structure */
 InitRequester(&DummyReq);
}

/* Free exec node */
void FreeExecNode(struct Node *node)
{
 struct ExecNode *en=(struct ExecNode *) node;
 char *s;

 if (s=en->en_Node.ln_Name) free(s);
 if (s=en->en_Command) free(s);
 if (s=en->en_CurrentDir) free(s);
 if (s=en->en_Output) free(s);
 if (s=en->en_Path) free(s);
 if (s=en->en_HotKey) free(s);
 if (s=en->en_PubScreen) free(s);

 /* Free node */
 FreeMem(en,sizeof(struct ExecNode));
}

/* Copy exec node */
struct Node *CopyExecNode(struct Node *node)
{
 struct ExecNode *en,*orignode=(struct ExecNode *) node;

 /* Alloc memory for exec node */
 if (en=AllocMem(sizeof(struct ExecNode),MEMF_PUBLIC|MEMF_CLEAR)) {

  /* Got an old node? */
  if (orignode) {
   /* Yes, copy it */
   if ((!orignode->en_Node.ln_Name || (en->en_Node.ln_Name=
                                        strdup(orignode->en_Node.ln_Name))) &&
       (!orignode->en_Command || (en->en_Command=
                                   strdup(orignode->en_Command))) &&
       (!orignode->en_CurrentDir || (en->en_CurrentDir=
                                      strdup(orignode->en_CurrentDir))) &&
       (!orignode->en_Output || (en->en_Output=strdup(orignode->en_Output))) &&
       (!orignode->en_Path || (en->en_Path=strdup(orignode->en_Path))) &&
       (!orignode->en_HotKey || (en->en_HotKey=strdup(orignode->en_HotKey))) &&
       (!orignode->en_PubScreen || (en->en_PubScreen=
                                     strdup(orignode->en_PubScreen)))) {
    /* Copy flags & numbers */
    en->en_ExecType=orignode->en_ExecType;
    en->en_Flags=orignode->en_Flags;
    en->en_Stack=orignode->en_Stack;
    en->en_Priority=orignode->en_Priority;
    en->en_Delay=orignode->en_Delay;

    /* Return pointer to new node */
    return(en);
   }
  } else {
   /* No, set defaults */
   if (en->en_Node.ln_Name=strdup(AppStrings[MSG_EXECWIN_NEWNAME])) {
    en->en_Flags=EXPOF_ARGS;
    en->en_Stack=4096;

    /* Return pointer to new node */
    return(en);
   }
  }

  FreeExecNode((struct Node *) en);
 }
 /* Call failed */
 return(NULL);
}

/* Create exec node from WBArg */
struct Node *CreateExecNode(char *name, struct WBArg *wa)
{
 struct ExecNode *en;

 /* Alloc memory for exec node */
 if (en=AllocMem(sizeof(struct ExecNode),MEMF_PUBLIC|MEMF_CLEAR)) {
  char *dirbuf;

  /* Init node */
  if ((en->en_Node.ln_Name=strdup(name)) &&
      (en->en_Command=strdup(wa->wa_Name)) &&
      (dirbuf=malloc(4096))) {

   /* Create & copy directory name */
   if (NameFromLock(wa->wa_Lock,dirbuf,4096) &&
       (en->en_CurrentDir=strdup(dirbuf))) {
    /* Set defaults */
    en->en_ExecType=TMET_WB;
    en->en_Flags=EXPOF_ARGS;
    en->en_Stack=4096;

    /* All OK. */
    free(dirbuf);
    return(en);
   }
   free(dirbuf);
  }
  FreeExecNode((struct Node *) en);
 }
 /* Call failed */
 return(NULL);
}

/* Activate a gadget */
static void MyActivateGadget(ULONG num)
{
 ActivateGadget(gdata[num].gadget,w,NULL);
}

/* Open exec edit window */
BOOL OpenExecEditWindow(struct Node *node, struct Window *parent)
{
 /* Copy node */
 if (CurrentNode=(struct ExecNode *) CopyExecNode(node)) {
  /* Set tags */
  nametags[0].ti_Data=(ULONG) CurrentNode->en_Node.ln_Name;
  cycletags[1].ti_Data=CurrentNode->en_ExecType;
  commtags[0].ti_Data=(ULONG) CurrentNode->en_Command;
  curdtags[0].ti_Data=(ULONG) CurrentNode->en_CurrentDir;
  hotktags[0].ti_Data=(ULONG) CurrentNode->en_HotKey;
  outptags[0].ti_Data=(ULONG) CurrentNode->en_Output;
  pathtags[0].ti_Data=(ULONG) CurrentNode->en_Path;
  pbsctags[0].ti_Data=(ULONG) CurrentNode->en_PubScreen;
  stacktags[0].ti_Data=CurrentNode->en_Stack;
  priotags[0].ti_Data=CurrentNode->en_Priority;
  delaytags[0].ti_Data=CurrentNode->en_Delay;
  argstags[0].ti_Data=(CurrentNode->en_Flags & EXPOF_ARGS)!=0;
  tofronttags[0].ti_Data=(CurrentNode->en_Flags & EXPOF_TOFRONT)!=0;

  /* Create gadgets */
  if (gl=CreateGadgetList(gdata,GADGETS)) {
   /* Open window */
   if (w=OpenWindowTags(NULL,WA_Left,        parent->LeftEdge,
                             WA_Top,         parent->TopEdge+WindowTop,
                             WA_InnerWidth,  ww,
                             WA_InnerHeight, wh,
                             WA_AutoAdjust,  TRUE,
                             WA_Title,       AppStrings[MSG_EXECWIN_TITLE],
                             WA_PubScreen,   PublicScreen,
                             WA_Flags,       WFLG_CLOSEGADGET|WFLG_DRAGBAR|
                                             WFLG_DEPTHGADGET|WFLG_RMBTRAP|
                                             WFLG_ACTIVATE,
                             TAG_DONE)) {
    /* Add as AppWindow */
    aw=NULL;
    if (WorkbenchBase && WBScreen)
     /* This call fails if the Workbench is NOT running! */
     aw=AddAppWindowA(0,0,w,AppMsgPort,NULL);

    /* Init requester button gadgets */
    InitReqButtonGadget(gdata[GAD_COMMAND_BUT].gadget);
    InitReqButtonGadget(gdata[GAD_CURDIR_BUT].gadget);
    InitReqButtonGadget(gdata[GAD_PATH_BUT].gadget);
    InitReqButtonGadget(gdata[GAD_OUTPUT_BUT].gadget);
    InitReqButtonGadget(gdata[GAD_PSCREEN_BUT].gadget);

    /* Add gadgets to window */
    AddGList(w,gl,(UWORD) -1,(UWORD) -1,NULL);
    RefreshGList(gl,w,NULL,(UWORD) -1);
    GT_RefreshWindow(w,NULL);

    /* Activate first gadget */
    MyActivateGadget(GAD_NAME_STR);

    /* Set local variables */
    w->UserPort=IDCMPPort;
    w->UserData=(BYTE *) HandleExecEditWindowIDCMP;
    ModifyIDCMP(w,WINDOW_IDCMP);
    CurrentWindow=w;
    if (aw) HandleAppMsg=HandleExecEditWindowAppMsg;
    ReqOpen=FALSE;

    /* Set up file requester parameters */
    FileReqParms.frp_Window=w;
    FileReqParms.frp_OKText=AppStrings[MSG_FILEREQ_OK_GAD];
    FileReqParms.frp_Flags1=FRF_DOPATTERNS;

    /* All OK. */
    return(TRUE);
   }
   FreeGadgets(gl);
  }
  FreeExecNode((struct Node *) CurrentNode);
 }
 /* Call failed */
 return(FALSE);
}

/* Close exec edit window */
static void CloseExecEditWindow(void)
{
 /* Free resources */
 RemoveGList(w,gl,(UWORD) -1);
 if (aw) {
  HandleAppMsg=HandleMainWindowAppMsg;
  RemoveAppWindow(aw);
 }
 CloseWindowSafely(w);
 FreeGadgets(gl);
}

/* Handle application messages */
void HandleExecEditWindowAppMsg(struct AppMessage *msg)
{
 struct WBArg *wa;

 DEBUG_PRINTF("AppMsg 0x%08lx\n",msg);

 /* Get first argument */
 if (wa=msg->am_ArgList) {
  BPTR olddir;
  struct DiskObject *dobj;

  DEBUG_PRINTF("Argument 0x%08lx\n",wa);

  /* Go to new current dir */
  olddir=CurrentDir(wa->wa_Lock);

  /* Get icon */
  if (dobj=GetDiskObjectNew(wa->wa_Name)) {
   char *command=NULL;

   /* Get program name */
   switch (dobj->do_Type) {
    case WBTOOL:
    case WBPROJECT: command=(char *) wa->wa_Name;
                    break;
    default:        DisplayBeep(NULL);
                    break;
   }

   /* Command string valid? */
   if (command) {
    char *dirbuf;

    /* Allocate memory for directory buffer */
    if (dirbuf=malloc(4096)) {
     /* Get current dir name */
     if (NameFromLock(wa->wa_Lock,dirbuf,4096)) {
      /* Set new gadget values */
      CurrentNode->en_ExecType=TMET_WB;
      GT_SetGadgetAttrs(gdata[GAD_EXECTYPE].gadget,w,NULL,
                        GTCY_Active,TMET_WB,TAG_DONE);
      GT_SetGadgetAttrs(gdata[GAD_NAME_STR].gadget,w,NULL,
                        GTST_String,wa->wa_Name,TAG_DONE);
      GT_SetGadgetAttrs(gdata[GAD_COMMAND_STR].gadget,w,NULL,
                        GTST_String,command,TAG_DONE);
      GT_SetGadgetAttrs(gdata[GAD_CURDIR_STR].gadget,w,NULL,
                        GTST_String,dirbuf,TAG_DONE);

      /* Tool? */
      if (dobj->do_Type==WBTOOL)
       /* Yes, set stack */
       GT_SetGadgetAttrs(gdata[GAD_STACK_INT].gadget,w,NULL,
                         GTIN_Number,dobj->do_StackSize,TAG_DONE);
     }
     free(dirbuf);
    }
   }

   /* Free icon */
   FreeDiskObject(dobj);
  } else
   DisplayBeep(NULL);
  CurrentDir(olddir);
 }
}

/* Command gadget function */
static void CommandGadgetFunc(void)
{
 char *file;
 struct Gadget *g=gdata[GAD_COMMAND_STR].gadget;

 /* Dock exec type? */
 if (CurrentNode->en_ExecType==TMET_Dock) {
  /* Yes. Open list requester */
  if (!ReqOpen && OpenListRequester(LISTREQ_DOCK,w)) {
   /* Disable window */
   DisableWindow(w,&DummyReq);

   /* Save gadget number */
   CurrentGadgetNum=GAD_COMMAND_STR;

   /* Set update function */
   UpdateWindow=UpdateExecEditWindow;
   ReqOpen=TRUE;
  }
 } else {
  /* No. Set file requester parameters */
  FileReqParms.frp_Title=AppStrings[MSG_FILEREQ_TITLE_FILE];
  FileReqParms.frp_Flags2=FRF_REJECTICONS;
  FileReqParms.frp_OldFile=((struct StringInfo *) g->SpecialInfo)->Buffer;

  /* Open file requester */
  if (file=OpenFileRequester(&DummyReq)) {
   /* Set new file string */
   GT_SetGadgetAttrs(g,w,NULL,GTST_String,file, TAG_DONE);
   free(file);
  }
 }

 /* Activate command string gadget */
 ActivateGadget(g,w,NULL);
}

/* Current directory gadget function */
static void CurDirGadgetFunc(void)
{
 char *file;
 struct Gadget *g=gdata[GAD_CURDIR_STR].gadget;

 /* Set file requester parameters */
 FileReqParms.frp_Title=AppStrings[MSG_FILEREQ_TITLE_DRAWER];
 FileReqParms.frp_Flags2=FRF_DRAWERSONLY|FRF_REJECTICONS;
 FileReqParms.frp_OldFile=((struct StringInfo *) g->SpecialInfo)->Buffer;

 /* Open file requester */
 if (file=OpenFileRequester(&DummyReq)) {
  /* Set new file string */
  GT_SetGadgetAttrs(g,w,NULL,GTST_String,file,TAG_DONE);
  free(file);
 }

 /* Activate current directory string gadget */
 ActivateGadget(g,w,NULL);
}

/* Path gadget function */
static void PathGadgetFunc(void)
{
 char *file;
 struct Gadget *g=gdata[GAD_PATH_STR].gadget;

 /* Set file requester parameters */
 FileReqParms.frp_Title=AppStrings[MSG_FILEREQ_TITLE_DRAWER];
 FileReqParms.frp_Flags2=FRF_DRAWERSONLY|FRF_REJECTICONS;
 FileReqParms.frp_OldFile="";

 /* Open file requester */
 if (file=OpenFileRequester(&DummyReq)) {
  char *oldpath,*path;
  ULONG len;

  oldpath=((struct StringInfo *) g->SpecialInfo)->Buffer;
  len=strlen(oldpath);

  /* Alloc memory for new path string */
  if (path=malloc(len+strlen(file)+2)) {
   /* Build new path string. Got old path? */
   if (len) {
    /* Yes. Append new path */
    strcpy(path,oldpath);
    path[len]=';';
    strcpy(path+len+1,file);
   } else
    /* No. Copy new path */
    strcpy(path,file);

   /* Set new path string */
   GT_SetGadgetAttrs(g,w,NULL,GTST_String,path,TAG_DONE);
   free(path);
  }
  free(file);
 }

 /* Activate path string gadget */
 ActivateGadget(g,w,NULL);
}

/* Output gadget function */
static void OutputGadgetFunc(void)
{
 char *file;
 struct Gadget *g=gdata[GAD_OUTPUT_STR].gadget;

 /* Set file requester parameters */
 FileReqParms.frp_Title=AppStrings[MSG_FILEREQ_TITLE_FILE];
 FileReqParms.frp_Flags2=FRF_REJECTICONS;
 FileReqParms.frp_OldFile=((struct StringInfo *) g->SpecialInfo)->Buffer;

 /* Open file requester */
 if (file=OpenFileRequester(&DummyReq)) {
  /* Set new file string */
  GT_SetGadgetAttrs(g,w,NULL,GTST_String,file,TAG_DONE);
  free(file);
 }

 /* Activate output string gadget */
 ActivateGadget(g,w,NULL);
}

/* Public screen gadget function */
static void PubScreenGadgetFunc(void)
{
 /* Open list requester */
 if (!ReqOpen && OpenListRequester(LISTREQ_PUBSC,w)) {
  /* Disable window */
  DisableWindow(w,&DummyReq);

  /* Save gadget number */
  CurrentGadgetNum=GAD_PSCREEN_STR;

  /* Set update function */
  UpdateWindow=UpdateExecEditWindow;
  ReqOpen=TRUE;
 }
}

/* OK gadget function */
static struct Node *OKGadgetFunc(void)
{
 struct Node *rc;

 char *s;

 /* Free old strings */
 if (s=CurrentNode->en_Node.ln_Name) free(s);
 CurrentNode->en_Node.ln_Name=NULL;
 if (s=CurrentNode->en_Command) free(s);
 CurrentNode->en_Command=NULL;
 if (s=CurrentNode->en_CurrentDir) free(s);
 CurrentNode->en_CurrentDir=NULL;
 if (s=CurrentNode->en_Output) free(s);
 CurrentNode->en_Output=NULL;
 if (s=CurrentNode->en_Path) free(s);
 CurrentNode->en_Path=NULL;
 if (s=CurrentNode->en_HotKey) free(s);
 CurrentNode->en_HotKey=NULL;
 if (s=CurrentNode->en_PubScreen) free(s);
 CurrentNode->en_PubScreen=NULL;

 /* Duplicate new strings */
 if (((CurrentNode->en_Node.ln_Name=
        DuplicateBuffer(gdata[GAD_NAME_STR].gadget)) != (char *) -1) &&
     ((CurrentNode->en_Command=
        DuplicateBuffer(gdata[GAD_COMMAND_STR].gadget)) != (char *) -1) &&
     ((CurrentNode->en_CurrentDir=
        DuplicateBuffer(gdata[GAD_CURDIR_STR].gadget)) != (char *) -1) &&
     ((CurrentNode->en_Output=
        DuplicateBuffer(gdata[GAD_OUTPUT_STR].gadget)) != (char *) -1) &&
     ((CurrentNode->en_Path=
        DuplicateBuffer(gdata[GAD_PATH_STR].gadget)) != (char *) -1) &&
     ((CurrentNode->en_HotKey=
        DuplicateBuffer(gdata[GAD_HOTKEY_STR].gadget)) != (char *) -1) &&
     ((CurrentNode->en_PubScreen=
        DuplicateBuffer(gdata[GAD_PSCREEN_STR].gadget)) != (char *) -1)) {
  /* Copy integer gadget values */
  CurrentNode->en_Stack=
   ((struct StringInfo *) gdata[GAD_STACK_INT].gadget->SpecialInfo)->LongInt;
  CurrentNode->en_Priority=
   ((struct StringInfo *) gdata[GAD_PRIORITY_INT].gadget->SpecialInfo)
    ->LongInt;
  CurrentNode->en_Delay=
   ((struct StringInfo *) gdata[GAD_DELAY_INT].gadget->SpecialInfo)->LongInt;

  rc=(struct Node *) CurrentNode;
 } else {
  /* Couldn't copy strings */
  rc=(struct Node *) -1;
  FreeExecNode((struct Node *) CurrentNode);
 }
 return(rc);
}

/* Handle exec edit window IDCMP events */
void *HandleExecEditWindowIDCMP(struct IntuiMessage *msg)
{
 struct Node *NewNode=NULL;

 /* Which IDCMP class? */
 switch (msg->Class) {
  case IDCMP_CLOSEWINDOW:   NewNode=(struct Node *) -1;
                            FreeExecNode((struct Node *) CurrentNode);
                            break;
  case IDCMP_REFRESHWINDOW: GT_BeginRefresh(w);
                            GT_EndRefresh(w,TRUE);
                            break;
  case IDCMP_GADGETUP:
   switch (((struct Gadget *) msg->IAddress) ->GadgetID) {
    case GAD_EXECTYPE:    /* Save type */
                          CurrentNode->en_ExecType=msg->Code;
                          break;
    case GAD_COMMAND_BUT: CommandGadgetFunc();
                          break;
    case GAD_CURDIR_BUT:  CurDirGadgetFunc();
                          break;
    case GAD_PATH_BUT:    PathGadgetFunc();
                          break;
    case GAD_OUTPUT_BUT:  OutputGadgetFunc();
                          break;
    case GAD_PSCREEN_BUT: PubScreenGadgetFunc();
                          break;
    case GAD_ARGS:        /* Toggle flag */
                          CurrentNode->en_Flags^=EXPOF_ARGS;
                          break;
    case GAD_TOFRONT:     /* Toggle flag */
                          CurrentNode->en_Flags^=EXPOF_TOFRONT;
                          break;
    case GAD_OK:          NewNode=OKGadgetFunc();
                          break;
    case GAD_CANCEL:      NewNode=(struct Node *) -1;
                          FreeExecNode((struct Node *) CurrentNode);
                          break;
   }
   break;
  case IDCMP_VANILLAKEY:
   switch (MatchVanillaKey(msg->Code,KeyArray)) {
    case KEY_NAME:    MyActivateGadget(GAD_NAME_STR);
                      break;
    case KEY_TYPE:    {
                       /* Get next cycle gadget code */
                       ULONG oldtype=CurrentNode->en_ExecType;
                       ULONG newtype;

                       /* Forward or backward cycle */
                       if (islower(msg->Code))
                        newtype=(oldtype+1) % (TMET_Network+1);
                       else
                        newtype=(oldtype>0) ? oldtype-1 : TMET_Network;

                       /* Set cycle gadget */
                       GT_SetGadgetAttrs(gdata[GAD_EXECTYPE].gadget,w,NULL,
                                         GTCY_Active, newtype,
                                         TAG_DONE);

                       /* Save type */
                       CurrentNode->en_ExecType=newtype;
                      }
                      break;
    case KEY_COMMAND: CommandGadgetFunc();
                      break;
    case KEY_HOTKEY:  MyActivateGadget(GAD_HOTKEY_STR);
                      break;
    case KEY_STACK:   MyActivateGadget(GAD_STACK_INT);
                      break;
    case KEY_PRIO:    MyActivateGadget(GAD_PRIORITY_INT);
                      break;
    case KEY_DELAY:   MyActivateGadget(GAD_DELAY_INT);
                      break;
    case KEY_CURDIR:  CurDirGadgetFunc();
                      break;
    case KEY_PATH:    PathGadgetFunc();
                      break;
    case KEY_OUTPUT:  OutputGadgetFunc();
                      break;
    case KEY_PSCREEN: PubScreenGadgetFunc();
                      break;
    case KEY_ARGS:    /* Toggle flag */
                      CurrentNode->en_Flags^=EXPOF_ARGS;

                      /* Set check box gadget */
                      GT_SetGadgetAttrs(gdata[GAD_ARGS].gadget,w,NULL,
                       GTCB_Checked, (CurrentNode->en_Flags & EXPOF_ARGS),
                       TAG_DONE);

                      break;
    case KEY_FRONT:   /* Toggle flag */
                      CurrentNode->en_Flags^=EXPOF_TOFRONT;

                      /* Set check box gadget */
                      GT_SetGadgetAttrs(gdata[GAD_TOFRONT].gadget,w,NULL,
                       GTCB_Checked, (CurrentNode->en_Flags & EXPOF_TOFRONT),
                       TAG_DONE);

                      break;
    case KEY_OK:      NewNode=OKGadgetFunc();
                      break;
    case KEY_CANCEL:  NewNode=(struct Node *) -1;
                      FreeExecNode((struct Node *) CurrentNode);
                      break;
   }
   break;
 }

 /* Close window? */
 if (NewNode) {
  /* Yes. But first reply message!!! */
  GT_ReplyIMsg(msg);
  CloseExecEditWindow();
 }

 return(NewNode);
}

/* Update Exec edit window */
void UpdateExecEditWindow(void *data)
{
 /* Got data? */
 if (data != LREQRET_CANCEL) {
  struct Gadget *g=gdata[CurrentGadgetNum].gadget;
  char *new;

  /* Selected something? */
  new=(data == LREQRET_NOSELECT) ? NULL : ((struct Node *) data)->ln_Name;

  /* Set new public screen name */
  GT_SetGadgetAttrs(g,w,NULL,GTST_String,new,
                             TAG_DONE);

  /* Activate string gadget */
  ActivateGadget(g,w,NULL);
 }

 /* Enable window */
 EnableWindow(w,&DummyReq,WINDOW_IDCMP);

 /* Restore update function pointer */
 UpdateWindow=UpdateMainWindow;
 CurrentWindow=w;
 ReqOpen=FALSE;
}

/* Read TMEX IFF chunk into Exec node */
struct Node *ReadExecNode(UBYTE *buf)
{
 struct ExecNode *en;

 /* Allocate memory for node */
 if (en=AllocMem(sizeof(struct ExecNode),MEMF_PUBLIC|MEMF_CLEAR)) {
  struct ExecPrefsObject *epo=(struct ExecPrefsObject *) buf;
  ULONG sbits=epo->epo_StringBits;
  UBYTE *ptr=(UBYTE *) &epo[1];

  if ((!(sbits & EXPO_NAME) || (en->en_Node.ln_Name=GetConfigStr(&ptr))) &&
      (!(sbits & EXPO_COMMAND) || (en->en_Command=GetConfigStr(&ptr))) &&
      (!(sbits & EXPO_CURDIR) || (en->en_CurrentDir=GetConfigStr(&ptr))) &&
      (!(sbits & EXPO_HOTKEY) || (en->en_HotKey=GetConfigStr(&ptr))) &&
      (!(sbits & EXPO_OUTPUT) || (en->en_Output=GetConfigStr(&ptr))) &&
      (!(sbits & EXPO_PATH) || (en->en_Path=GetConfigStr(&ptr))) &&
      (!(sbits & EXPO_PSCREEN) || (en->en_PubScreen=GetConfigStr(&ptr)))) {
   /* Copy flags & values */
   en->en_Flags=epo->epo_Flags;
   en->en_ExecType=epo->epo_ExecType;
   en->en_Priority=epo->epo_Priority;
   en->en_Delay=epo->epo_Delay;
   en->en_Stack=epo->epo_Stack;

   /* All OK. */
   return(en);
  }

  /* Call failed */
  FreeExecNode((struct Node *) en);
 }
 return(NULL);
}

/* Write Exec node to TMEX IFF chunk */
BOOL WriteExecNode(struct IFFHandle *iff, UBYTE *buf, struct Node *node)
{
 struct ExecNode *en=(struct ExecNode *) node;
 struct ExecPrefsObject *epo=(struct ExecPrefsObject *) buf;
 ULONG sbits=0;
 UBYTE *ptr=(UBYTE *) &epo[1];

 /* Copy strings */
 if (PutConfigStr(en->en_Node.ln_Name,&ptr)) sbits|=EXPO_NAME;
 if (PutConfigStr(en->en_Command,&ptr)) sbits|=EXPO_COMMAND;
 if (PutConfigStr(en->en_CurrentDir,&ptr)) sbits|=EXPO_CURDIR;
 if (PutConfigStr(en->en_HotKey,&ptr)) sbits|=EXPO_HOTKEY;
 if (PutConfigStr(en->en_Output,&ptr)) sbits|=EXPO_OUTPUT;
 if (PutConfigStr(en->en_Path,&ptr)) sbits|=EXPO_PATH;
 if (PutConfigStr(en->en_PubScreen,&ptr)) sbits|=EXPO_PSCREEN;

 /* set string bits */
 epo->epo_StringBits=sbits;

 /* Copy flags & values */
 epo->epo_Flags=en->en_Flags;
 epo->epo_ExecType=en->en_ExecType;
 epo->epo_Priority=en->en_Priority;
 epo->epo_Delay=en->en_Delay;
 epo->epo_Stack=en->en_Stack;

 /* calculate length */
 sbits=ptr-buf;

 DEBUG_PRINTF("chunk size %ld\n",sbits);

 /* Open chunk */
 if (PushChunk(iff,0,ID_TMEX,sbits)) return(FALSE);

 /* Write chunk */
 if (WriteChunkBytes(iff,buf,sbits)!=sbits) return(FALSE);

 /* Close chunk */
 if (PopChunk(iff)) return(FALSE);

 /* All OK. */
 return(TRUE);
}
