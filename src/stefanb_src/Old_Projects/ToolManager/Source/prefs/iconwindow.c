/*
 * iconwindow.c  V2.1
 *
 * icon edit window handling
 *
 * (c) 1990-1993 Stefan Becker
 */

#include "ToolManagerConf.h"

/* Icon node */
struct IconNode {
                 struct Node  in_Node;
                 ULONG        in_Flags;
                 char        *in_Exec;
                 char        *in_Image;
                 char        *in_Sound;
                 LONG         in_XPos;
                 LONG         in_YPos;
                };

/* Window data */
static struct Gadget *gl;             /* Gadget list */
static struct Window *w;              /* Window */
static struct MsgPort *wp;            /* Window user port */
static UWORD ww,wh;                   /* Window size */
static struct IconNode *CurrentNode;
static ULONG CurrentGadgetNum;
static BOOL ReqOpen;
static struct Requester DummyReq;
#define WINDOW_IDCMP (IDCMP_CLOSEWINDOW|IDCMP_REFRESHWINDOW|BUTTONIDCMP|\
                      CHECKBOXIDCMP|STRINGIDCMP|TEXTIDCMP|IDCMP_VANILLAKEY)

/* Gadget data */
#define GAD_NAME_STR   0 /* Gadgets with labels */
#define GAD_EXEC_BUT   1
#define GAD_IMAGE_BUT  2
#define GAD_SOUND_BUT  3
#define GAD_XPOS_INT   4
#define GAD_YPOS_INT   5

#define GAD_EXEC_TXT   6
#define GAD_IMAGE_TXT  7
#define GAD_SOUND_TXT  8

#define GAD_POSITION   9 /* Cycle gadget */

#define GAD_SHOWNAME  10 /* Checkbox gadget */

#define GAD_OK        11
#define GAD_CANCEL    12
#define GADGETS       13
static struct GadgetData gdata[GADGETS];

/* Gadget tags */
static struct TagItem nametags[]={GTST_String,   NULL,
                                  GTST_MaxChars, SGBUFLEN,
                                  TAG_DONE};

static struct TagItem exectags[]={GTTX_Text,   NULL,
                                  GTTX_Border, TRUE,
                                  TAG_DONE};

static struct TagItem imagetags[]={GTTX_Text,   NULL,
                                   GTTX_Border, TRUE,
                                   TAG_DONE};

static struct TagItem soundtags[]={GTTX_Text,   NULL,
                                   GTTX_Border, TRUE,
                                   TAG_DONE};

static char *cyclelabels[3]={NULL, NULL, NULL};
static struct TagItem cycletags[]={GTCY_Labels, (ULONG) cyclelabels,
                                   GTCY_Active, 0,
                                   TAG_DONE};

static struct TagItem xpostags[]={GTIN_Number,   0,
                                  GTIN_MaxChars, 10,
                                  TAG_DONE};

static struct TagItem ypostags[]={GTIN_Number,   0,
                                  GTIN_MaxChars, 10,
                                  TAG_DONE};

static struct TagItem showntags[]={GTCB_Checked, FALSE,
                                   GTCB_Scaled,  TRUE,
                                   TAG_DONE};

/* Gadget vanilla key data */
#define KEY_NAME   0
#define KEY_EXEC   1
#define KEY_IMAGE  2
#define KEY_SOUND  3
#define KEY_XPOS   4
#define KEY_YPOS   5
#define KEY_SHOW   6
#define KEY_OK     7
#define KEY_CANCEL 8
static char KeyArray[KEY_CANCEL+1];

/* Init icon edit window */
void InitIconEditWindow(UWORD left, UWORD fheight)
{
 ULONG labwidth,gadwidth,cycwidth,cbwidth,butwidth;
 ULONG strheight=fheight+2;
 ULONG i,tmp,yadd;
 struct GadgetData *gd;

 /* Init strings */
 gdata[GAD_NAME_STR].name  =AppStrings[MSG_WINDOW_NAME_GAD];
 gdata[GAD_EXEC_BUT].name  =AppStrings[MSG_WINDOW_EXEC_GAD];
 gdata[GAD_IMAGE_BUT].name =AppStrings[MSG_WINDOW_IMAGE_GAD];
 gdata[GAD_SOUND_BUT].name =AppStrings[MSG_WINDOW_SOUND_GAD];
 gdata[GAD_XPOS_INT].name  =AppStrings[MSG_WINDOW_LEFTEDGE_GAD];
 gdata[GAD_YPOS_INT].name  =AppStrings[MSG_WINDOW_TOPEDGE_GAD];
 cyclelabels[0]            =AppStrings[MSG_WINDOW_POSITION_OPEN_LABEL];
 cyclelabels[1]            =AppStrings[MSG_WINDOW_POSITION_CLOSE_LABEL];
 gdata[GAD_SHOWNAME].name  =AppStrings[MSG_ICONWIN_SHOWNAME_GAD];
 gdata[GAD_OK].name        =AppStrings[MSG_WINDOW_OK_GAD];
 gdata[GAD_CANCEL].name    =AppStrings[MSG_WINDOW_CANCEL_GAD];

 /* Calculate maximum label width for string gadgets */
 labwidth=0;
 gd=&gdata[GAD_NAME_STR];
 for (i=GAD_NAME_STR; i<=GAD_YPOS_INT; i++, gd++)
  if ((tmp=TextLength(&TmpRastPort,gd->name,strlen(gd->name))) > labwidth)
   labwidth=tmp;
 labwidth+=2*INTERWIDTH;

 /* Calculate minimum string gadget width */
 gadwidth=TextLength(&TmpRastPort,AppStrings[MSG_ICONWIN_NEWNAME],
                     strlen(AppStrings[MSG_ICONWIN_NEWNAME]))+2*INTERWIDTH;

 /* Calculate minimum window width */
 ww=labwidth+gadwidth+2*INTERWIDTH;

 /* Calculate maximum cyclegadget width */
 {
  char **s;

  cycwidth=0;
  s=cyclelabels;
  for (i=0; i<=1; i++, s++)
   if ((tmp=TextLength(&TmpRastPort,*s,strlen(*s))) > cycwidth)
    cycwidth=tmp;
  cycwidth+=5*INTERWIDTH;
 }
 if ((tmp=cycwidth+INTERWIDTH) > ww) ww=tmp;

 /* Calculate checkbox label width */
 gd=&gdata[GAD_SHOWNAME];
 cbwidth=TextLength(&TmpRastPort,gd->name,strlen(gd->name))+INTERWIDTH
         +CHECKBOX_WIDTH;
 if ((tmp=cbwidth+INTERWIDTH) > ww) ww=tmp;

 /* Calculate button gadgets width */
 gd=&gdata[GAD_OK];
 butwidth=TextLength(&TmpRastPort,gd->name,strlen(gd->name));
 gd++;
 if ((tmp=TextLength(&TmpRastPort,gd->name,strlen(gd->name))) > butwidth)
  butwidth=tmp;
 butwidth+=2*INTERWIDTH;
 if ((tmp=2*(butwidth+INTERWIDTH)) > ww) ww=tmp;

 /* window height */
 wh=9*fheight+9*INTERHEIGHT+12;
 if (!OSV39) wh+=INTERHEIGHT;

 /* Init gadgets */
 gd=gdata;
 tmp=WindowTop+INTERHEIGHT;
 gadwidth=ww-labwidth-2*INTERWIDTH; /* String gadget width */
 i=labwidth;
 labwidth+=left+INTERWIDTH;
 yadd=strheight+INTERHEIGHT;

 /* Name string gadget */
 gd->type=STRING_KIND;
 gd->flags=PLACETEXT_LEFT;
 gd->tags=nametags;
 gd->left=labwidth;
 gd->top=tmp;
 gd->width=gadwidth;
 gd->height=strheight;
 tmp+=yadd;

 /* Exec object button gadget */
 gd++;
 gd->type=BUTTON_KIND;
 gd->flags=PLACETEXT_IN;
 gd->left=left;
 gd->top=tmp;
 gd->width=i;
 gd->height=strheight;
 tmp+=yadd;

 /* Image object button gadget */
 gd++;
 gd->type=BUTTON_KIND;
 gd->flags=PLACETEXT_IN;
 gd->left=left;
 gd->top=tmp;
 gd->width=i;
 gd->height=strheight;
 tmp+=yadd;

 /* Sound object button gadget */
 gd++;
 gd->name=AppStrings[MSG_WINDOW_SOUND_GAD];
 gd->type=BUTTON_KIND;
 gd->flags=PLACETEXT_IN;
 gd->left=left;
 gd->top=tmp;
 gd->width=i;
 gd->height=strheight;
 tmp+=yadd+fheight+INTERHEIGHT;

 /* Leftedge integer gadget */
 gd++;
 gd->type=INTEGER_KIND;
 gd->flags=PLACETEXT_LEFT;
 gd->tags=xpostags;
 gd->left=labwidth;
 gd->top=tmp;
 gd->width=gadwidth;
 gd->height=strheight;
 tmp+=yadd;

 /* TopEdge integer gadget */
 gd++;
 gd->type=INTEGER_KIND;
 gd->flags=PLACETEXT_LEFT;
 gd->tags=ypostags;
 gd->left=labwidth;
 gd->top=tmp;
 gd->width=gadwidth;
 gd->height=strheight;

 /* Exec object text gadget */
 tmp=WindowTop+yadd+INTERHEIGHT;
 gd++;
 gd->type=TEXT_KIND;
 gd->tags=exectags;
 gd->left=labwidth;
 gd->top=tmp;
 gd->width=gadwidth;
 gd->height=strheight;
 tmp+=yadd;

 /* Image object text gadget */
 gd++;
 gd->type=TEXT_KIND;
 gd->tags=imagetags;
 gd->left=labwidth;
 gd->top=tmp;
 gd->width=gadwidth;
 gd->height=strheight;
 tmp+=yadd;

 /* Sound object text gadget */
 gd++;
 gd->type=TEXT_KIND;
 gd->tags=soundtags;
 gd->left=labwidth;
 gd->top=tmp;
 gd->width=gadwidth;
 gd->height=strheight;
 tmp+=yadd;

 /* Position cycle gadget */
 gd++;
 gd->type=CYCLE_KIND;
 gd->flags=PLACETEXT_IN;
 gd->tags=cycletags;
 gd->left=left;
 gd->top=tmp;
 gd->width=ww-INTERWIDTH;
 gd->height=fheight;

 /* Showname checkbox gadget */
 tmp=WindowTop+7*fheight+8*INTERHEIGHT+12;
 gd++;
 gd->type=CHECKBOX_KIND;
 gd->flags=PLACETEXT_RIGHT;
 gd->tags=showntags;
 gd->left=(ww-cbwidth-INTERWIDTH)/2+left;
 gd->top=tmp;
 gd->width=CHECKBOX_WIDTH;
 gd->height=fheight-INTERHEIGHT;
 tmp+=fheight;
 if (!OSV39) tmp+=INTERHEIGHT;

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
 KeyArray[KEY_EXEC]  =FindVanillaKey(gdata[GAD_EXEC_BUT].name);
 KeyArray[KEY_IMAGE] =FindVanillaKey(gdata[GAD_IMAGE_BUT].name);
 KeyArray[KEY_SOUND] =FindVanillaKey(gdata[GAD_SOUND_BUT].name);
 KeyArray[KEY_XPOS]  =FindVanillaKey(gdata[GAD_XPOS_INT].name);
 KeyArray[KEY_YPOS]  =FindVanillaKey(gdata[GAD_YPOS_INT].name);
 KeyArray[KEY_SHOW]  =FindVanillaKey(gdata[GAD_SHOWNAME].name);
 KeyArray[KEY_OK]    =FindVanillaKey(gdata[GAD_OK].name);
 KeyArray[KEY_CANCEL]=FindVanillaKey(gdata[GAD_CANCEL].name);

 /* Init dummy requester structure */
 InitRequester(&DummyReq);
}

/* Free icon node */
void FreeIconNode(struct Node *node)
{
 struct IconNode *in=(struct IconNode *) node;
 char *s;

 if (s=in->in_Node.ln_Name) free(s);
 if (s=in->in_Exec) free(s);
 if (s=in->in_Image) free(s);
 if (s=in->in_Sound) free(s);

 /* Free node */
 FreeMem(in,sizeof(struct IconNode));
}

/* Copy image node */
struct Node *CopyIconNode(struct Node *node)
{
 struct IconNode *in,*orignode=(struct IconNode *) node;

 /* Alloc memory for icon node */
 if (in=AllocMem(sizeof(struct IconNode),MEMF_PUBLIC|MEMF_CLEAR)) {

  /* Got an old node? */
  if (orignode) {
   /* Yes, copy it */
   if ((!orignode->in_Node.ln_Name || (in->in_Node.ln_Name=
                                        strdup(orignode->in_Node.ln_Name))) &&
       (!orignode->in_Exec || (in->in_Exec=strdup(orignode->in_Exec))) &&
       (!orignode->in_Image || (in->in_Image=strdup(orignode->in_Image))) &&
       (!orignode->in_Sound || (in->in_Sound=strdup(orignode->in_Sound)))) {
    /* Copy flags & numbers */
    in->in_Flags=orignode->in_Flags;
    in->in_XPos=orignode->in_XPos;
    in->in_YPos=orignode->in_YPos;
    return(in);
   }
  } else
   /* No, set defaults */
   if (in->in_Node.ln_Name=strdup(AppStrings[MSG_ICONWIN_NEWNAME])) {
    /* Set flags */
    in->in_Flags=ICPOF_SHOWNAME;

    /* Return pointer to new node */
    return(in);
   }

  FreeIconNode((struct Node *) in);
 }
 /* Call failed */
 return(NULL);
}

/* Create icon node from string */
struct Node *CreateIconNode(char *name)
{
 struct IconNode *in;

 /* Alloc memory for icon node */
 if (in=AllocMem(sizeof(struct IconNode),MEMF_PUBLIC|MEMF_CLEAR)) {

  /* Init node */
  if ((in->in_Node.ln_Name=strdup(name)) &&
      (in->in_Exec=strdup(name)) &&
      (in->in_Image=strdup(name))) {
   /* Set flags */
   in->in_Flags=ICPOF_SHOWNAME;

   /* All OK. */
   return(in);
  }

  FreeIconNode((struct Node *) in);
 }
 /* Call failed */
 return(NULL);
}

/* Activate gadget and save pointer to it */
static void MyActivateGadget(ULONG num)
{
 ActivateGadget(gdata[num].gadget,w,NULL);
}

/* Open icon edit window */
BOOL OpenIconEditWindow(struct Node *node, struct Window *parent)
{
 /* Copy node */
 if (CurrentNode=(struct IconNode *) CopyIconNode(node)) {
  /* Set tags */
  nametags[0].ti_Data=(ULONG) CurrentNode->in_Node.ln_Name;
  exectags[0].ti_Data=(ULONG) CurrentNode->in_Exec;
  imagetags[0].ti_Data=(ULONG) CurrentNode->in_Image;
  soundtags[0].ti_Data=(ULONG) CurrentNode->in_Sound;
  xpostags[0].ti_Data=CurrentNode->in_XPos;
  ypostags[0].ti_Data=CurrentNode->in_YPos;
  showntags[0].ti_Data=(CurrentNode->in_Flags & ICPOF_SHOWNAME)!=0;

  /* Create gadgets */
  if (gl=CreateGadgetList(gdata,GADGETS)) {
   /* Open window */
   if (w=OpenWindowTags(NULL,WA_Left,        parent->LeftEdge,
                             WA_Top,         parent->TopEdge+WindowTop,
                             WA_InnerWidth,  ww,
                             WA_InnerHeight, wh,
                             WA_AutoAdjust,  TRUE,
                             WA_Title,       AppStrings[MSG_ICONWIN_TITLE],
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
    MyActivateGadget(GAD_NAME_STR);

    /* Set local variables */
    w->UserPort=IDCMPPort;
    w->UserData=(BYTE *) HandleIconEditWindowIDCMP;
    ModifyIDCMP(w,WINDOW_IDCMP);
    CurrentWindow=w;
    ReqOpen=FALSE;

    /* All OK. */
    return(TRUE);
   }
   FreeGadgets(gl);
  }
  FreeIconNode((struct Node *) CurrentNode);
 }
 /* Call failed */
 return(FALSE);
}

/* Close icon edit window */
static void CloseIconEditWindow(void)
{
 /* Free resources */
 if (MoveWindowPtr) CloseMoveWindow();
 RemoveGList(w,gl,(UWORD) -1);
 CloseWindowSafely(w);
 FreeGadgets(gl);
}

/* If move window open, move it to new position */
static void MoveMoveWindow(void)
{
 /* Move window open? */
 if (MoveWindowPtr) {
  ULONG x,y;

  /* Read current position */
  x=((struct StringInfo *) gdata[GAD_XPOS_INT].gadget->SpecialInfo)->LongInt;
  y=((struct StringInfo *) gdata[GAD_YPOS_INT].gadget->SpecialInfo)->LongInt;

  /* Move move window */
  MoveWindow(MoveWindowPtr,x-MoveWindowPtr->LeftEdge+WBXOffset,
                           y-MoveWindowPtr->TopEdge+WBYOffset);
 }
}

/* Exec, Image & Sound button gadget function */
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
   UpdateWindow=UpdateIconEditWindow;
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
 if (s=CurrentNode->in_Node.ln_Name) free(s);

 /* Duplicate new string */
 if ((CurrentNode->in_Node.ln_Name=
       DuplicateBuffer(gdata[GAD_NAME_STR].gadget)) != (char *) -1) {
  /* Copy integer gadget values */
  CurrentNode->in_XPos=
   ((struct StringInfo *) gdata[GAD_XPOS_INT].gadget->SpecialInfo)->LongInt;
  CurrentNode->in_YPos=
   ((struct StringInfo *) gdata[GAD_YPOS_INT].gadget->SpecialInfo)->LongInt;

  rc=(struct Node *) CurrentNode;
 } else {
  /* Couldn't copy strings */
  rc=(struct Node *) -1;
  FreeIconNode((struct Node *) CurrentNode);
 }
 return(rc);
}

/* Handle icon edit window IDCMP events */
void *HandleIconEditWindowIDCMP(struct IntuiMessage *msg)
{
 struct Node *NewNode=NULL;

 /* Which IDCMP class? */
 switch (msg->Class) {
  case IDCMP_CLOSEWINDOW:   NewNode=(struct Node *) -1;
                            FreeIconNode((struct Node *) CurrentNode);
                            break;
  case IDCMP_REFRESHWINDOW: GT_BeginRefresh(w);
                            GT_EndRefresh(w,TRUE);
                            break;
  case IDCMP_GADGETUP:
   switch (((struct Gadget *) msg->IAddress)->GadgetID) {
    case GAD_EXEC_BUT:  TextButtonGadgetFunc(GAD_EXEC_TXT,LISTREQ_EXEC);
                        break;
    case GAD_IMAGE_BUT: TextButtonGadgetFunc(GAD_IMAGE_TXT,LISTREQ_IMAGE);
                        break;
    case GAD_SOUND_BUT: TextButtonGadgetFunc(GAD_SOUND_TXT,LISTREQ_SOUND);
                        break;
    case GAD_XPOS_INT:  MoveMoveWindow();
                        break;
    case GAD_YPOS_INT:  MoveMoveWindow();
                        break;
    case GAD_POSITION:  /* Move window open? */
                        if (MoveWindowPtr)
                         /* Yes. Close move window */
                         CloseMoveWindow();
                        else {
                         /* No. Open it! */
                         MoveWindowOffX=WBXOffset;
                         MoveWindowOffY=WBYOffset;

                         /* Open move window */
                         OpenMoveWindow(w,gdata[GAD_XPOS_INT].gadget,
                                          gdata[GAD_YPOS_INT].gadget);
                        }
                        break;
    case GAD_SHOWNAME:  /* Toggle flag */
                        CurrentNode->in_Flags^=ICPOF_SHOWNAME;
                        break;
    case GAD_OK:        NewNode=OKGadgetFunc();
                        break;
    case GAD_CANCEL:    NewNode=(struct Node *) -1;
                        FreeIconNode((struct Node *) CurrentNode);
                        break;
   }
   break;
  case IDCMP_VANILLAKEY:
   switch (MatchVanillaKey(msg->Code,KeyArray)) {
    case KEY_NAME:   MyActivateGadget(GAD_NAME_STR);
                     break;
    case KEY_EXEC:   TextButtonGadgetFunc(GAD_EXEC_TXT,LISTREQ_EXEC);
                     break;
    case KEY_IMAGE:  TextButtonGadgetFunc(GAD_IMAGE_TXT,LISTREQ_IMAGE);
                     break;
    case KEY_SOUND:  TextButtonGadgetFunc(GAD_SOUND_TXT,LISTREQ_SOUND);
                     break;
    case KEY_XPOS:   MyActivateGadget(GAD_XPOS_INT);
                     break;
    case KEY_YPOS:   MyActivateGadget(GAD_YPOS_INT);
                     break;
    case KEY_SHOW:   /* Toggle flag */
                     CurrentNode->in_Flags^=ICPOF_SHOWNAME;

                     /* Set check box gadget */
                     GT_SetGadgetAttrs(gdata[GAD_SHOWNAME].gadget,w,NULL,
                      GTCB_Checked, (CurrentNode->in_Flags & ICPOF_SHOWNAME),
                      TAG_DONE);

                     break;
    case KEY_OK:     NewNode=OKGadgetFunc();
                     break;
    case KEY_CANCEL: NewNode=(struct Node *) -1;
                     FreeIconNode((struct Node *) CurrentNode);
                     break;
   }
   break;
 }

 /* Close window? */
 if (NewNode) {
  /* Yes. But first reply message!!! */
  GT_ReplyIMsg(msg);
  CloseIconEditWindow();
 }

 return(NewNode);
}

/* Update Icon edit window */
void UpdateIconEditWindow(void *data)
{
 /* Got data? */
 if (data != LREQRET_CANCEL) {
  char *new;

  /* Selected something? */
  new=(data == LREQRET_NOSELECT) ? NULL : ((struct Node *) data)->ln_Name;

  /* Duplicate name */
  if (!new || (new=strdup(new))) {
   char *old;

   /* Which object? */
   switch (CurrentGadgetNum) {
    case GAD_EXEC_TXT:  /* Set new Exec name */
                        old=CurrentNode->in_Exec;
                        CurrentNode->in_Exec=new;
                        break;
    case GAD_IMAGE_TXT: /* Set new Image name */
                        old=CurrentNode->in_Image;
                        CurrentNode->in_Image=new;
                        break;
    case GAD_SOUND_TXT: /* Set new Sound name */
                        old=CurrentNode->in_Sound;
                        CurrentNode->in_Sound=new;
                        break;
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

/* Read TMIC IFF chunk into Icon node */
struct Node *ReadIconNode(UBYTE *buf)
{
 struct IconNode *in;

 /* Allocate memory for node */
 if (in=AllocMem(sizeof(struct IconNode),MEMF_PUBLIC|MEMF_CLEAR)) {
  struct IconPrefsObject *ipo=(struct IconPrefsObject *) buf;
  ULONG sbits=ipo->ipo_StringBits;
  UBYTE *ptr=(UBYTE *) &ipo[1];

  if ((!(sbits & ICPO_NAME) || (in->in_Node.ln_Name=GetConfigStr(&ptr))) &&
      (!(sbits & ICPO_EXEC) || (in->in_Exec=GetConfigStr(&ptr))) &&
      (!(sbits & ICPO_IMAGE) || (in->in_Image=GetConfigStr(&ptr))) &&
      (!(sbits & ICPO_SOUND) || (in->in_Sound=GetConfigStr(&ptr)))) {
   /* Copy flags & values */
   in->in_Flags=ipo->ipo_Flags;
   in->in_XPos=ipo->ipo_XPos;
   in->in_YPos=ipo->ipo_YPos;

   /* All OK. */
   return(in);
  }

  /* Call failed */
  FreeIconNode((struct Node *) in);
 }
 return(NULL);
}

/* Write Icon node to TMIC IFF chunk */
BOOL WriteIconNode(struct IFFHandle *iff, UBYTE *buf, struct Node *node)
{
 struct IconNode *in=(struct IconNode *) node;
 struct IconPrefsObject *ipo=(struct IconPrefsObject *) buf;
 ULONG sbits=0;
 UBYTE *ptr=(UBYTE *) &ipo[1];

 /* Copy strings */
 if (PutConfigStr(in->in_Node.ln_Name,&ptr)) sbits|=ICPO_NAME;
 if (PutConfigStr(in->in_Exec,&ptr)) sbits|=ICPO_EXEC;
 if (PutConfigStr(in->in_Image,&ptr)) sbits|=ICPO_IMAGE;
 if (PutConfigStr(in->in_Sound,&ptr)) sbits|=ICPO_SOUND;

 /* set string bits */
 ipo->ipo_StringBits=sbits;

 /* Copy flags & values */
 ipo->ipo_Flags=in->in_Flags;
 ipo->ipo_XPos=in->in_XPos;
 ipo->ipo_YPos=in->in_YPos;

 /* calculate length */
 sbits=ptr-buf;

 DEBUG_PRINTF("chunk size %ld\n",sbits);

 /* Open chunk */
 if (PushChunk(iff,0,ID_TMIC,sbits)) return(FALSE);

 /* Write chunk */
 if (WriteChunkBytes(iff,buf,sbits)!=sbits) return(FALSE);

 /* Close chunk */
 if (PopChunk(iff)) return(FALSE);

 /* All OK. */
 return(TRUE);
}
