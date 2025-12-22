/*
 * menuwindow.c  V2.1
 *
 * menu edit window handling
 *
 * (c) 1990-1993 Stefan Becker
 */

#include "ToolManagerConf.h"

/* Menu node */
struct MenuNode {
                  struct Node  mn_Node;
                  char        *mn_Exec;
                  char        *mn_Sound;
                 };

/* Window data */
static struct Gadget *gl;             /* Gadget list */
static struct Window *w;              /* Window */
static struct MsgPort *wp;            /* Window user port */
static UWORD ww,wh;                   /* Window size */
static struct MenuNode *CurrentNode;
static ULONG CurrentGadgetNum;
static BOOL ReqOpen;
static struct Requester DummyReq;
#define WINDOW_IDCMP (IDCMP_CLOSEWINDOW|IDCMP_REFRESHWINDOW|BUTTONIDCMP|\
                      STRINGIDCMP|TEXTIDCMP|IDCMP_VANILLAKEY)

/* Gadget data */
#define GAD_NAME_STR  0
#define GAD_EXEC_BUT  1
#define GAD_EXEC_TXT  2
#define GAD_SOUND_BUT 3
#define GAD_SOUND_TXT 4
#define GAD_OK        5
#define GAD_CANCEL    6
#define GADGETS       7
static struct GadgetData gdata[GADGETS];

/* Gadget tags */
static struct TagItem nametags[]={GTST_String,   NULL,
                                  GTST_MaxChars, SGBUFLEN,
                                  TAG_DONE};

static struct TagItem exectags[]={GTTX_Text,   NULL,
                                  GTTX_Border, TRUE,
                                  TAG_DONE};

static struct TagItem soundtags[]={GTTX_Text,   NULL,
                                   GTTX_Border, TRUE,
                                   TAG_DONE};

/* Gadget vanilla key data */
#define KEY_NAME   0
#define KEY_EXEC   1
#define KEY_SOUND  2
#define KEY_OK     3
#define KEY_CANCEL 4
static char KeyArray[KEY_CANCEL+1];

/* Init menu edit window */
void InitMenuEditWindow(UWORD left, UWORD fheight)
{
 ULONG tmp,tmp2,maxw1,maxw2;
 ULONG strheight=fheight+2;
 struct GadgetData *gd;

 /* Init strings */
 gdata[GAD_OK].name       =AppStrings[MSG_WINDOW_OK_GAD];
 gdata[GAD_CANCEL].name   =AppStrings[MSG_WINDOW_CANCEL_GAD];

 /* Calculate maximum label width for string gadgets */
 maxw1=TextLength(&TmpRastPort,AppStrings[MSG_WINDOW_NAME_GAD],
                  strlen(AppStrings[MSG_WINDOW_NAME_GAD]));
 tmp=TextLength(&TmpRastPort,AppStrings[MSG_WINDOW_EXEC_GAD],
                strlen(AppStrings[MSG_WINDOW_EXEC_GAD]))+2*INTERWIDTH;
 if (tmp > maxw1) maxw1=tmp;
 tmp=TextLength(&TmpRastPort,AppStrings[MSG_WINDOW_SOUND_GAD],
                strlen(AppStrings[MSG_WINDOW_SOUND_GAD]))+2*INTERWIDTH;
 if (tmp > maxw1) maxw1=tmp;
 maxw1+=INTERWIDTH;

 /* Calculate minimal string gadget width */
 ww=TextLength(&TmpRastPort,AppStrings[MSG_MENUWIN_NEWNAME],
               strlen(AppStrings[MSG_MENUWIN_NEWNAME]))+
    maxw1+3*INTERWIDTH;

 /* Calculate button gadgets width */
 gd=&gdata[GAD_OK];
 maxw2=TextLength(&TmpRastPort,gd->name,strlen(gd->name));
 gd++;
 if ((tmp=TextLength(&TmpRastPort,gd->name,strlen(gd->name))) > maxw2)
  maxw2=tmp;
 maxw2+=2*INTERWIDTH;
 if ((tmp=2*(maxw2+INTERWIDTH)) > ww) ww=tmp;

 /* window height */
 wh=4*fheight+5*INTERHEIGHT+6;

 /* Init gadgets */
 gd=gdata;
 tmp=WindowTop+INTERHEIGHT;
 tmp2=ww-maxw1-INTERWIDTH;

 /* Name string gadget */
 gd->name=AppStrings[MSG_WINDOW_NAME_GAD];
 gd->type=STRING_KIND;
 gd->flags=PLACETEXT_LEFT;
 gd->tags=nametags;
 gd->left=maxw1+left;
 gd->top=tmp;
 gd->width=tmp2;
 gd->height=strheight;
 tmp+=strheight+INTERHEIGHT;

 /* Exec object button gadget */
 gd++;
 gd->name=AppStrings[MSG_WINDOW_EXEC_GAD];
 gd->type=BUTTON_KIND;
 gd->flags=PLACETEXT_IN;
 gd->left=left;
 gd->top=tmp;
 gd->width=maxw1-INTERWIDTH;
 gd->height=strheight;

 /* Exec object text gadget */
 gd++;
 gd->type=TEXT_KIND;
 gd->tags=exectags;
 gd->left=maxw1+left;
 gd->top=tmp;
 gd->width=tmp2;
 gd->height=strheight;
 tmp+=strheight+INTERHEIGHT;

 /* Sound object button gadget */
 gd++;
 gd->name=AppStrings[MSG_WINDOW_SOUND_GAD];
 gd->type=BUTTON_KIND;
 gd->flags=PLACETEXT_IN;
 gd->left=left;
 gd->top=tmp;
 gd->width=maxw1-INTERWIDTH;
 gd->height=strheight;

 /* Sound object text gadget */
 gd++;
 gd->type=TEXT_KIND;
 gd->tags=soundtags;
 gd->left=maxw1+left;
 gd->top=tmp;
 gd->width=tmp2;
 gd->height=strheight;
 tmp+=strheight+INTERHEIGHT;

 /* OK button gadget */
 gd++;
 gd->type=BUTTON_KIND;
 gd->flags=PLACETEXT_IN;
 gd->left=left;
 gd->top=tmp;
 gd->width=maxw2;
 gd->height=fheight;

 /* Cancel button gadget */
 gd++;
 gd->type=BUTTON_KIND;
 gd->flags=PLACETEXT_IN;
 gd->left=ww-maxw2-INTERWIDTH+left;
 gd->top=tmp;
 gd->width=maxw2;
 gd->height=fheight;

 /* Init vanilla key array */
 KeyArray[KEY_NAME]  =FindVanillaKey(gdata[GAD_NAME_STR].name);
 KeyArray[KEY_EXEC]  =FindVanillaKey(gdata[GAD_EXEC_BUT].name);
 KeyArray[KEY_SOUND] =FindVanillaKey(gdata[GAD_SOUND_BUT].name);
 KeyArray[KEY_OK]    =FindVanillaKey(gdata[GAD_OK].name);
 KeyArray[KEY_CANCEL]=FindVanillaKey(gdata[GAD_CANCEL].name);

 /* Init dummy requester structure */
 InitRequester(&DummyReq);
}

/* Free menu node */
void FreeMenuNode(struct Node *node)
{
 struct MenuNode *mn=(struct MenuNode *) node;
 char *s;

 if (s=mn->mn_Node.ln_Name) free(s);
 if (s=mn->mn_Exec) free(s);
 if (s=mn->mn_Sound) free(s);

 /* Free node */
 FreeMem(mn,sizeof(struct MenuNode));
}

/* Copy menu node */
struct Node *CopyMenuNode(struct Node *node)
{
 struct MenuNode *mn,*orignode=(struct MenuNode *) node;

 /* Alloc memory for menu node */
 if (mn=AllocMem(sizeof(struct MenuNode),MEMF_PUBLIC|MEMF_CLEAR)) {

  /* Got an old node? */
  if (orignode) {
   /* Yes, copy it */
   if ((!orignode->mn_Node.ln_Name || (mn->mn_Node.ln_Name=
                                        strdup(orignode->mn_Node.ln_Name))) &&
       (!orignode->mn_Exec || (mn->mn_Exec=strdup(orignode->mn_Exec))) &&
       (!orignode->mn_Sound || (mn->mn_Sound=strdup(orignode->mn_Sound))))
    return(mn);
  } else
   /* No, set defaults */
   if (mn->mn_Node.ln_Name=strdup(AppStrings[MSG_MENUWIN_NEWNAME]))
    /* Return pointer to new node */
    return(mn);

  FreeMenuNode((struct Node *) mn);
 }
 /* Call failed */
 return(NULL);
}

/* Create menu node from string */
struct Node *CreateMenuNode(char *name)
{
 struct MenuNode *mn;

 /* Alloc memory for menu node */
 if (mn=AllocMem(sizeof(struct MenuNode),MEMF_PUBLIC|MEMF_CLEAR)) {

  /* Init node */
  if ((mn->mn_Node.ln_Name=strdup(name)) &&
      (mn->mn_Exec=strdup(name)))
   /* All OK. */
   return(mn);

  FreeMenuNode((struct Node *) mn);
 }
 /* Call failed */
 return(NULL);
}

/* Activate name string gadget */
static void ActivateNameGadget(void)
{
 ActivateGadget(gdata[GAD_NAME_STR].gadget,w,NULL);
}

/* Open menu edit window */
BOOL OpenMenuEditWindow(struct Node *node, struct Window *parent)
{
 /* Copy node */
 if (CurrentNode=(struct MenuNode *) CopyMenuNode(node)) {
  /* Set tags */
  nametags[0].ti_Data=(ULONG) CurrentNode->mn_Node.ln_Name;
  exectags[0].ti_Data=(ULONG) CurrentNode->mn_Exec;
  soundtags[0].ti_Data=(ULONG) CurrentNode->mn_Sound;

  /* Create gadgets */
  if (gl=CreateGadgetList(gdata,GADGETS)) {
   /* Open window */
   if (w=OpenWindowTags(NULL,WA_Left,        parent->LeftEdge,
                             WA_Top,         parent->TopEdge+WindowTop,
                             WA_InnerWidth,  ww,
                             WA_InnerHeight, wh,
                             WA_AutoAdjust,  TRUE,
                             WA_Title,       AppStrings[MSG_MENUWIN_TITLE],
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
    w->UserData=(BYTE *) HandleMenuEditWindowIDCMP;
    ModifyIDCMP(w,WINDOW_IDCMP);
    CurrentWindow=w;
    ReqOpen=FALSE;

    /* All OK. */
    return(TRUE);
   }
   FreeGadgets(gl);
  }
  FreeMenuNode((struct Node *) CurrentNode);
 }
 /* Call failed */
 return(FALSE);
}

/* Close menu edit window */
static void CloseMenuEditWindow(void)
{
 /* Free resources */
 RemoveGList(w,gl,(UWORD) -1);
 CloseWindowSafely(w);
 FreeGadgets(gl);
}

/* Exec & Sound gadget function */
static void TextButtonGadgetFunc(ULONG gadnum, ULONG listnum)
{
 if (!ReqOpen) {
  /* Save gadget number */
  CurrentGadgetNum=gadnum;

  /* Open list requester */
  if (OpenListRequester(listnum,w)) {
   /* Disable window */
   DisableWindow(w,&DummyReq);

   /* Set update function */
   UpdateWindow=UpdateMenuEditWindow;
   ReqOpen=TRUE;
  }
 }
}

/* OK gadget function */
static struct Node *OKGadgetFunc(void)
{
 struct Node *rc;
 char *s;

 /* Free old string */
 if (s=CurrentNode->mn_Node.ln_Name) free(s);

 /* Duplicate new string */
 if ((CurrentNode->mn_Node.ln_Name=
       DuplicateBuffer(gdata[GAD_NAME_STR].gadget)) != (char *) -1)
  rc=(struct Node *) CurrentNode;
 else {
  /* Couldn't copy strings */
  rc=(struct Node *) -1;
  FreeMenuNode((struct Node *) CurrentNode);
 }
 return(rc);
}

/* Handle menu edit window IDCMP events */
void *HandleMenuEditWindowIDCMP(struct IntuiMessage *msg)
{
 struct Node *NewNode=NULL;

 /* Which IDCMP class? */
 switch (msg->Class) {
  case IDCMP_CLOSEWINDOW:   NewNode=(struct Node *) -1;
                            FreeMenuNode((struct Node *) CurrentNode);
                            break;
  case IDCMP_REFRESHWINDOW: GT_BeginRefresh(w);
                            GT_EndRefresh(w,TRUE);
                            break;
  case IDCMP_GADGETUP:
   switch (((struct Gadget *) msg->IAddress)->GadgetID) {
    case GAD_EXEC_BUT:  TextButtonGadgetFunc(GAD_EXEC_TXT,LISTREQ_EXEC);
                        break;
    case GAD_SOUND_BUT: TextButtonGadgetFunc(GAD_SOUND_TXT,LISTREQ_SOUND);
                        break;
    case GAD_OK:        NewNode=OKGadgetFunc();
                        break;
    case GAD_CANCEL:    NewNode=(struct Node *) -1;
                        FreeMenuNode((struct Node *) CurrentNode);
                        break;
   }
   break;
  case IDCMP_VANILLAKEY:
   switch (MatchVanillaKey(msg->Code,KeyArray)) {
    case KEY_NAME:   ActivateNameGadget();
                     break;
    case KEY_EXEC:   TextButtonGadgetFunc(GAD_EXEC_TXT,LISTREQ_EXEC);
                     break;
    case KEY_SOUND:  TextButtonGadgetFunc(GAD_SOUND_TXT,LISTREQ_SOUND);
                     break;
    case KEY_OK:     NewNode=OKGadgetFunc();
                     break;
    case KEY_CANCEL: NewNode=(struct Node *) -1;
                     FreeMenuNode((struct Node *) CurrentNode);
                     break;
   }
   break;
 }

 /* Close window? */
 if (NewNode) {
  /* Yes. But first reply message!!! */
  GT_ReplyIMsg(msg);
  CloseMenuEditWindow();
 }

 return(NewNode);
}

/* Update Menu edit window */
void UpdateMenuEditWindow(void *data)
{
 /* Got data? */
 if (data != LREQRET_CANCEL) {
  char *new;

  /* Selected something? */
  new=(data == LREQRET_NOSELECT) ? NULL : ((struct Node *) data)->ln_Name;

  /* Duplicate name */
  if (!new || (new=strdup(new))) {
   char *old;

   /* Exec object? */
   if (CurrentGadgetNum==GAD_EXEC_TXT) {
    /* Yes. Set new Exec name */
    old=CurrentNode->mn_Exec;
    CurrentNode->mn_Exec=new;
   } else {
    /* No. Set new Sound name */
    old=CurrentNode->mn_Sound;
    CurrentNode->mn_Sound=new;
   }

   /* Free old string */
   if (old) free(old);

   /* Set new text */
   GT_SetGadgetAttrs(gdata[CurrentGadgetNum].gadget,w,NULL,GTTX_Text,new,
                                                           TAG_DONE);
  }
 }

 /* Enable window */
 EnableWindow(w,&DummyReq,WINDOW_IDCMP);

 /* Restore update function pointer */
 UpdateWindow=UpdateMainWindow;
 CurrentWindow=w;
 ReqOpen=FALSE;
}

/* Read TMMO IFF chunk into Menu node */
struct Node *ReadMenuNode(UBYTE *buf)
{
 struct MenuNode *mn;

 /* Allocate memory for node */
 if (mn=AllocMem(sizeof(struct MenuNode),MEMF_PUBLIC|MEMF_CLEAR)) {
  struct MenuPrefsObject *mpo=(struct MenuPrefsObject *) buf;
  ULONG sbits=mpo->mpo_StringBits;
  UBYTE *ptr=(UBYTE *) &mpo[1];

  if ((!(sbits & MOPO_NAME) || (mn->mn_Node.ln_Name=GetConfigStr(&ptr))) &&
      (!(sbits & MOPO_EXEC) || (mn->mn_Exec=GetConfigStr(&ptr))) &&
      (!(sbits & MOPO_SOUND) || (mn->mn_Sound=GetConfigStr(&ptr))))
   /* All OK. */
   return(mn);

  /* Call failed */
  FreeMenuNode((struct Node *) mn);
 }
 return(NULL);
}

/* Write Menu node to TMMO IFF chunk */
BOOL WriteMenuNode(struct IFFHandle *iff, UBYTE *buf, struct Node *node)
{
 struct MenuNode *mn=(struct MenuNode *) node;
 struct MenuPrefsObject *mpo=(struct MenuPrefsObject *) buf;
 ULONG sbits=0;
 UBYTE *ptr=(UBYTE *) &mpo[1];

 /* Copy strings */
 if (PutConfigStr(mn->mn_Node.ln_Name,&ptr)) sbits|=MOPO_NAME;
 if (PutConfigStr(mn->mn_Exec,&ptr)) sbits|=MOPO_EXEC;
 if (PutConfigStr(mn->mn_Sound,&ptr)) sbits|=MOPO_SOUND;

 /* set string bits */
 mpo->mpo_StringBits=sbits;

 /* calculate length */
 sbits=ptr-buf;

 DEBUG_PRINTF("chunk size %ld\n",sbits);

 /* Open chunk */
 if (PushChunk(iff,0,ID_TMMO,sbits)) return(FALSE);

 /* Write chunk */
 if (WriteChunkBytes(iff,buf,sbits)!=sbits) return(FALSE);

 /* Close chunk */
 if (PopChunk(iff)) return(FALSE);

 /* All OK. */
 return(TRUE);
}
