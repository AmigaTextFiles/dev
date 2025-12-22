/*
 * docklistwindow.c  V2.1
 *
 * dock list edit window handling
 *
 * (c) 1990-1993 Stefan Becker
 */

#include "ToolManagerConf.h"

/* Window data */
static struct Gadget *gl;             /* Gadget list */
static struct Window *w;              /* Window */
static struct MsgPort *wp;            /* Window user port */
static UWORD ww,wh;                   /* Window size */
static struct List *ToolsList;
static struct ToolNode *CurrentTool;
static LONG CurrentTop;               /* Top tool ordinal number */
static LONG CurrentOrd;               /* Current tool ordinal number */
static ULONG CurrentGadgetNum;
static BOOL ReqOpen;
static struct Requester DummyReq;
#define WINDOW_IDCMP (IDCMP_CLOSEWINDOW|IDCMP_REFRESHWINDOW|BUTTONIDCMP|\
                      LISTVIEWIDCMP|TEXTIDCMP|IDCMP_VANILLAKEY)

/* Gadget data */
#define GAD_TOOLS       0
#define GAD_NEW         1
#define GAD_REMOVE      2
#define GAD_TOP         3
#define GAD_UP          4
#define GAD_DOWN        5
#define GAD_BOTTOM      6
#define GAD_EXEC_BUT    7
#define GAD_EXEC_TXT    8
#define GAD_IMAGE_BUT   9
#define GAD_IMAGE_TXT  10
#define GAD_SOUND_BUT  11
#define GAD_SOUND_TXT  12
#define GAD_OK         13
#define GAD_CANCEL     14
#define GADGETS        15
static struct GadgetData gdata[GADGETS];

/* Gadget tags */
static struct TagItem lvtags[]={GTLV_Labels, NULL,
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

/* Gadget vanilla key data */
#define KEY_NEW    0
#define KEY_EXEC   1
#define KEY_IMAGE  2
#define KEY_SOUND  3
#define KEY_OK     4
#define KEY_CANCEL 5
static char KeyArray[KEY_CANCEL+1];

/* Init dock list edit window */
void InitDockListEditWindow(UWORD left, UWORD fheight)
{
 ULONG i,tmp,tmp2,tmp3,maxw1,maxw2,maxw3;
 ULONG strheight=fheight+2;
 struct GadgetData *gd;

 /* Init strings */
 gdata[GAD_TOOLS].name  =AppStrings[MSG_DOCKLISTWIN_TOOLS_GAD];
 gdata[GAD_NEW].name    =AppStrings[MSG_DOCKLISTWIN_NEW_GAD];
 gdata[GAD_REMOVE].name =AppStrings[MSG_WINDOW_REMOVE_GAD];
 gdata[GAD_TOP].name    =AppStrings[MSG_WINDOW_TOP_GAD];
 gdata[GAD_UP].name     =AppStrings[MSG_WINDOW_UP_GAD];
 gdata[GAD_DOWN].name   =AppStrings[MSG_WINDOW_DOWN_GAD];
 gdata[GAD_BOTTOM].name =AppStrings[MSG_WINDOW_BOTTOM_GAD];
 gdata[GAD_OK].name     =AppStrings[MSG_WINDOW_OK_GAD];
 gdata[GAD_CANCEL].name =AppStrings[MSG_WINDOW_CANCEL_GAD];

 /* Calculate width for listview gadget */
 gd=gdata;
 ww=2*TextLength(&TmpRastPort,gd->name,strlen(gd->name));
 if ((tmp=ListViewColumns*ScreenFont->tf_XSize) > ww) ww=tmp;

 /* Calculate maximum width for tools gadgets */
 maxw1=0;
 for (gd++, i=GAD_NEW; i<=GAD_BOTTOM; i++, gd++)
  if ((tmp=TextLength(&TmpRastPort,gd->name,strlen(gd->name))) > maxw1)
   maxw1=tmp;
 maxw1+=2*INTERWIDTH;
 ww+=2*maxw1+3*INTERWIDTH;

 /* Calculate maximum label width for text gadgets */
 {
  char **s;

  maxw2=0;
  s=&AppStrings[MSG_WINDOW_EXEC_GAD];
  for (i=MSG_WINDOW_EXEC_GAD; i<=MSG_WINDOW_SOUND_GAD; i++, s++)
   if ((tmp=TextLength(&TmpRastPort,*s,strlen(*s))) > maxw2) maxw2=tmp;
  maxw2+=2*INTERWIDTH;
 }

 /* Calculate minimal width for text gadgets */
 tmp=TextLength(&TmpRastPort,AppStrings[MSG_LISTREQ_TITLE_EXEC],
               strlen(AppStrings[MSG_LISTREQ_TITLE_EXEC]))+3*INTERWIDTH;
 if ((tmp+=maxw2) > ww) ww=tmp;

 /* Calculate button gadgets width */
 gd=&gdata[GAD_OK];
 maxw3=TextLength(&TmpRastPort,gd->name,strlen(gd->name));
 gd++;
 if ((tmp=TextLength(&TmpRastPort,gd->name,strlen(gd->name)))
     > maxw3)
  maxw3=tmp;
 maxw3+=2*INTERWIDTH;
 if ((tmp=2*(maxw3+INTERWIDTH)) > ww) ww=tmp;

 /* window height */
 wh=(ListViewRows+3)*fheight+6*INTERHEIGHT+6;

 /* Init gadgets */
 gd=gdata;
 tmp=WindowTop+fheight+INTERHEIGHT;

 /* Tools list gadget */
 gd->type=LISTVIEW_KIND;
 gd->flags=PLACETEXT_ABOVE;
 gd->tags=lvtags;
 gd->left=left+maxw1+INTERWIDTH;
 gd->top=tmp;
 gd->width=ww-3*INTERWIDTH-2*maxw1;
 gd->height=(ListViewRows-2)*fheight;

 /* New gadget */
 gd++;
 tmp2=tmp+((ListViewRows-4)*fheight-INTERHEIGHT)/2;
 gd->type=BUTTON_KIND;
 gd->flags=PLACETEXT_IN;
 gd->left=left;
 gd->top=tmp2;
 gd->width=maxw1;
 gd->height=fheight;

 /* Remove gadget */
 gd++;
 gd->type=BUTTON_KIND;
 gd->flags=PLACETEXT_IN;
 gd->tags=DisabledTags;
 gd->left=left;
 gd->top=tmp2+fheight+INTERHEIGHT;
 gd->width=maxw1;
 gd->height=fheight;

 /* Move gadgets */
 gd++;
 tmp2=tmp+((ListViewRows-6)*fheight-3*INTERHEIGHT)/2;
 tmp3=ww-maxw1-INTERWIDTH+left;
 for (i=GAD_TOP; i<=GAD_BOTTOM; i++, gd++, tmp2+=fheight+INTERHEIGHT) {
  gd->type=BUTTON_KIND;
  gd->flags=PLACETEXT_IN;
  gd->tags=DisabledTags;
  gd->left=tmp3;
  gd->top=tmp2;
  gd->width=maxw1;
  gd->height=fheight;
 }
 tmp+=(ListViewRows-2)*fheight+INTERHEIGHT;

 /* Exec object button gadget */
 i=strheight+INTERHEIGHT;
 tmp2=ww-maxw2-2*INTERWIDTH;
 maxw1=maxw2+left+INTERWIDTH;
 gd->name=AppStrings[MSG_WINDOW_EXEC_GAD];
 gd->type=BUTTON_KIND;
 gd->flags=PLACETEXT_IN;
 gd->tags=DisabledTags;
 gd->left=left;
 gd->top=tmp;
 gd->width=maxw2;
 gd->height=strheight;

 /* Exec object text gadget */
 gd++;
 gd->type=TEXT_KIND;
 gd->tags=exectags;
 gd->left=maxw1;
 gd->top=tmp;
 gd->width=tmp2;
 gd->height=strheight;
 tmp+=i;

 /* Image object button gadget */
 gd++;
 gd->name=AppStrings[MSG_WINDOW_IMAGE_GAD];
 gd->type=BUTTON_KIND;
 gd->flags=PLACETEXT_IN;
 gd->tags=DisabledTags;
 gd->left=left;
 gd->top=tmp;
 gd->width=maxw2;
 gd->height=strheight;

 /* Image object text gadget */
 gd++;
 gd->type=TEXT_KIND;
 gd->tags=imagetags;
 gd->left=maxw1;
 gd->top=tmp;
 gd->width=tmp2;
 gd->height=strheight;
 tmp+=i;

 /* Sound object button gadget */
 gd++;
 gd->name=AppStrings[MSG_WINDOW_SOUND_GAD];
 gd->type=BUTTON_KIND;
 gd->flags=PLACETEXT_IN;
 gd->tags=DisabledTags;
 gd->left=left;
 gd->top=tmp;
 gd->width=maxw2;
 gd->height=strheight;

 /* Sound object text gadget */
 gd++;
 gd->type=TEXT_KIND;
 gd->tags=soundtags;
 gd->left=maxw1;
 gd->top=tmp;
 gd->width=tmp2;
 gd->height=strheight;
 tmp+=i;

 /* OK button gadget */
 gd++;
 gd->type=BUTTON_KIND;
 gd->flags=PLACETEXT_IN;
 gd->left=left;
 gd->top=tmp;
 gd->width=maxw3;
 gd->height=fheight;

 /* Cancel button gadget */
 gd++;
 gd->type=BUTTON_KIND;
 gd->flags=PLACETEXT_IN;
 gd->left=ww-maxw3-INTERWIDTH+left;
 gd->top=tmp;
 gd->width=maxw3;
 gd->height=fheight;

 /* Init vanilla key array */
 KeyArray[KEY_NEW]   =FindVanillaKey(gdata[GAD_NEW].name);
 KeyArray[KEY_EXEC]  =FindVanillaKey(gdata[GAD_EXEC_BUT].name);
 KeyArray[KEY_IMAGE] =FindVanillaKey(gdata[GAD_IMAGE_BUT].name);
 KeyArray[KEY_SOUND] =FindVanillaKey(gdata[GAD_SOUND_BUT].name);
 KeyArray[KEY_OK]    =FindVanillaKey(gdata[GAD_OK].name);
 KeyArray[KEY_CANCEL]=FindVanillaKey(gdata[GAD_CANCEL].name);

 /* Init dummy requester structure */
 InitRequester(&DummyReq);
}

/* Free tool list */
void FreeToolsList(struct List *toollist)
{
 struct ToolNode *tn1,*tn2=GetHead(toollist);

 /* Free tool nodes */
 while (tn1=tn2) {
  char *s;

  /* Get next node */
  tn2=GetSucc(tn1);

  /* Remove node */
  Remove((struct Node *) tn1);

  /* Free node */
  if (s=tn1->tn_Node.ln_Name) free(s);
  if (s=tn1->tn_Image) free(s);
  if (s=tn1->tn_Sound) free(s);
  FreeMem(tn1,sizeof(struct ToolNode));
 }
 free(toollist);
}

/* Copy tools list */
struct List *CopyToolsList(struct List *srclist)
{
 struct List *destlist;

 /* Allocate new list */
 if (destlist=malloc(sizeof(struct List))) {
  /* Init new list */
  NewList(destlist);

  /* Valid source list? */
  if (srclist) {
   struct ToolNode *origtool=GetHead(srclist);

   /* Scan tools list */
   while (origtool) {
    struct ToolNode *newtool;

    if ((newtool=AllocMem(sizeof(struct ToolNode),MEMF_PUBLIC|MEMF_CLEAR)) &&
        (!origtool->tn_Node.ln_Name || (newtool->tn_Node.ln_Name=
                                         strdup(origtool->tn_Node.ln_Name))) &&
        (!origtool->tn_Image || (newtool->tn_Image=
                                  strdup(origtool->tn_Image))) &&
        (!origtool->tn_Sound || (newtool->tn_Sound=
                                  strdup(origtool->tn_Sound))))
     AddTail(destlist,(struct Node *) newtool);
    else {
     char *s;

     /* Error, free new node */
     if (s=newtool->tn_Node.ln_Name) free(s);
     if (s=newtool->tn_Image) free(s);
     if (s=newtool->tn_Sound) free(s);
     FreeMem(newtool,sizeof(struct ToolNode));
     FreeToolsList(destlist);
     return(NULL);
    }

    /* Get next node */
    origtool=GetSucc(origtool);
   }
  }
 }
 return(destlist);
}

/* Open dock list edit window */
BOOL OpenDockListEditWindow(struct List *oldlist, struct Window *parent)
{
 /* Copy node */
 if (ToolsList=CopyToolsList(oldlist)) {
  /* Set tags */
  lvtags[0].ti_Data=(ULONG) ToolsList;

  /* Create gadgets */
  if (gl=CreateGadgetList(gdata,GADGETS)) {
   /* Open window */
   if (w=OpenWindowTags(NULL,WA_Left,        parent->LeftEdge,
                             WA_Top,         parent->TopEdge+WindowTop,
                             WA_InnerWidth,  ww,
                             WA_InnerHeight, wh,
                             WA_AutoAdjust,  TRUE,
                             WA_Title,       AppStrings[MSG_DOCKLISTWIN_TITLE],
                             WA_PubScreen,   PublicScreen,
                             WA_Flags,       WFLG_CLOSEGADGET|WFLG_DRAGBAR|
                                             WFLG_DEPTHGADGET|WFLG_RMBTRAP|
                                             WFLG_ACTIVATE,
                             TAG_DONE)) {
    /* Add gadgets to window */
    AddGList(w,gl,(UWORD) -1,(UWORD) -1,NULL);
    RefreshGList(gl,w,NULL,(UWORD) -1);
    GT_RefreshWindow(w,NULL);

    /* Set local variables */
    w->UserPort=IDCMPPort;
    w->UserData=(BYTE *) HandleDockListEditWindowIDCMP;
    ModifyIDCMP(w,WINDOW_IDCMP);
    CurrentWindow=w;
    ReqOpen=FALSE;
    CurrentTool=NULL;
    CurrentTop=0;
    CurrentOrd=-1;

    /* All OK. */
    return(TRUE);
   }
   FreeGadgets(gl);
  }
  FreeToolsList(ToolsList);
 }
 /* Call failed */
 return(FALSE);
}

/* Close dock edit window */
static void CloseDockListEditWindow(void)
{
 /* Free resources */
 RemoveGList(w,gl,(UWORD) -1);
 CloseWindowSafely(w);
 FreeGadgets(gl);
}

/* Detach list */
static void DetachToolList(void)
{
 GT_SetGadgetAttrs(gdata[GAD_TOOLS].gadget,w,NULL,GTLV_Labels,-1,
                                                  TAG_DONE);
}

/* Attach list */
static void AttachToolList(void)
{
 GT_SetGadgetAttrs(gdata[GAD_TOOLS].gadget,w,NULL,GTLV_Labels,   ToolsList,
                                                  GTLV_Top,      CurrentTop,
                                                  GTLV_Selected, CurrentOrd,
                                                  TAG_DONE);
}

/* Disable tool gadgets */
static void DisableToolGadgets(BOOL disable)
{
 DisableGadget(gdata[GAD_REMOVE].gadget,w,disable);
 DisableGadget(gdata[GAD_TOP].gadget,w,disable);
 DisableGadget(gdata[GAD_UP].gadget,w,disable);
 DisableGadget(gdata[GAD_DOWN].gadget,w,disable);
 DisableGadget(gdata[GAD_BOTTOM].gadget,w,disable);
 DisableGadget(gdata[GAD_EXEC_BUT].gadget,w,disable);
 DisableGadget(gdata[GAD_IMAGE_BUT].gadget,w,disable);
 DisableGadget(gdata[GAD_SOUND_BUT].gadget,w,disable);
}

/* Set text gadget */
static void SetTextGadget(ULONG num, char *text)
{
 GT_SetGadgetAttrs(gdata[num].gadget,w,NULL,GTTX_Text, text,
                                            TAG_DONE);
}

/* New gadget function */
static void NewGadgetFunc(void)
{
 struct ToolNode *tn;

 /* Create dummy tool */
 if (tn=AllocMem(sizeof(struct ToolNode),MEMF_PUBLIC|MEMF_CLEAR))
  if (tn->tn_Node.ln_Name=strdup(AppStrings[MSG_LISTREQ_TITLE_EXEC])) {
   /* Detach tool list */
   DetachToolList();

   /* Insert new node */
   if (CurrentTool) {
    /* Insert after current Tool */
    Insert(ToolsList, (struct Node *) tn, (struct Node *) CurrentTool);
    CurrentTop++;
    CurrentOrd++;
   } else {
    /* Append to list */
    struct Node *tmpnode;
    ULONG i;

    /* Add node to the end of list */
    AddTail(ToolsList,(struct Node *) tn);

    /* Search ordinal number */
    tmpnode=GetHead(ToolsList);
    for (i=0; tmpnode; i++) tmpnode=GetSucc(tmpnode);
    CurrentOrd=--i;
    CurrentTop=(i>ListViewRows-5) ? i-ListViewRows+5 : 0;

    /* Enable tool gadgets */
    DisableToolGadgets(FALSE);
   }
   CurrentTool=tn;

   /* Set text gadgets */
   SetTextGadget(GAD_EXEC_TXT,tn->tn_Node.ln_Name);
   SetTextGadget(GAD_IMAGE_TXT,NULL);
   SetTextGadget(GAD_SOUND_TXT,NULL);

   /* Attach tool list */
   AttachToolList();
  } else
   /* Error */
   FreeMem(tn,sizeof(struct ToolNode));
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
   UpdateWindow=UpdateDockListEditWindow;
   ReqOpen=TRUE;
  }
 }
}

/* Handle dock list edit window IDCMP events */
void *HandleDockListEditWindowIDCMP(struct IntuiMessage *msg)
{
 struct List *NewList=NULL;

 /* Which IDCMP class? */
 switch (msg->Class) {
  case IDCMP_CLOSEWINDOW:   NewList=(struct List *) -1;
                            FreeToolsList(ToolsList);
                            break;
  case IDCMP_REFRESHWINDOW: GT_BeginRefresh(w);
                            GT_EndRefresh(w,TRUE);
                            break;
  case IDCMP_GADGETUP:
   switch (((struct Gadget *) msg->IAddress)->GadgetID) {
    case GAD_TOOLS:     {
                         ULONG i;

                         /* Find node */
                         CurrentTop=(msg->Code>ListViewRows-5) ?
                          msg->Code-ListViewRows+5 : 0;
                         CurrentOrd=msg->Code;
                         CurrentTool=GetHead(ToolsList);
                         for (i=0; i<CurrentOrd; i++)
                          CurrentTool=GetSucc(CurrentTool);

                         /* Set text gadgets */
                         SetTextGadget(GAD_EXEC_TXT,
                                       CurrentTool->tn_Node.ln_Name);
                         SetTextGadget(GAD_IMAGE_TXT,CurrentTool->tn_Image);
                         SetTextGadget(GAD_SOUND_TXT,CurrentTool->tn_Sound);

                         /* Activate object gadgets */
                         DisableToolGadgets(FALSE);
                        }
                        break;
    case GAD_NEW:       NewGadgetFunc();
                        break;
    case GAD_REMOVE:    if (CurrentTool) {
                         char *s;

                         /* Detach tool list */
                         DetachToolList();

                         /* Disable tool gadgets */
                         DisableToolGadgets(TRUE);

                         /* Set text gadgets */
                         SetTextGadget(GAD_EXEC_TXT,NULL);
                         SetTextGadget(GAD_IMAGE_TXT,NULL);
                         SetTextGadget(GAD_SOUND_TXT,NULL);

                         /* Remove Node */
                         Remove((struct Node *) CurrentTool);

                         /* Free Node */
                         if (s=CurrentTool->tn_Node.ln_Name) free(s);
                         if (s=CurrentTool->tn_Image) free(s);
                         if (s=CurrentTool->tn_Sound) free(s);
                         FreeMem(CurrentTool,sizeof(struct ToolNode));

                         /* Reset pointers */
                         CurrentTool=NULL;
                         if (CurrentTop) CurrentTop--;
                         CurrentOrd=-1;

                         /* Attach tool list */
                         AttachToolList();
                        }
                        break;
    case GAD_TOP:       if (CurrentTool) {
                         /* Detach tool list */
                         DetachToolList();

                         /* Move node to top of list */
                         Remove((struct Node *) CurrentTool);
                         AddHead(ToolsList,(struct Node *) CurrentTool);
                         CurrentTop=0;
                         CurrentOrd=0;

                         /* Attach tool list */
                         AttachToolList();
                        }
                        break;
    case GAD_UP:        {
                         struct Node *pred;

                         /* Node valid and has a predecessor? */
                         if (CurrentTool && (pred=GetPred(CurrentTool))) {
                          /* Detach tool list */
                          DetachToolList();

                          /* Move node one position up */
                          pred=GetPred(pred);
                          Remove((struct Node *) CurrentTool);
                          Insert(ToolsList,(struct Node *) CurrentTool,pred);
                          --CurrentOrd;
                          CurrentTop=(CurrentOrd>ListViewRows-5) ?
                           CurrentOrd-ListViewRows+5 : 0;

                          /* Attach tool list */
                          AttachToolList();
                         }
                        }
                        break;
    case GAD_DOWN:      {
                         struct Node *succ;

                         /* Node valid and has a successor? */
                         if (CurrentTool && (succ=GetSucc(CurrentTool))) {
                          /* Detach tool list */
                          DetachToolList();

                          /* Move node one position down */
                          Remove((struct Node *) CurrentTool);
                          Insert(ToolsList,(struct Node *) CurrentTool,succ);
                          ++CurrentOrd;
                          CurrentTop=(CurrentOrd>ListViewRows-5) ?
                           CurrentOrd-ListViewRows+5 : 0;

                          /* Attach tool list */
                          AttachToolList();
                         }
                        }
                        break;
    case GAD_BOTTOM:    if (CurrentTool) {
                         ULONG i;
                         struct Node *tmpnode;

                         /* Detach tool list */
                         DetachToolList();

                         /* Move tool to bottom of list */
                         Remove((struct Node *) CurrentTool);
                         AddTail(ToolsList,(struct Node *) CurrentTool);

                         /* Search ordinal number */
                         tmpnode=GetHead(ToolsList);
                         for (i=0; tmpnode; i++) tmpnode=GetSucc(tmpnode);
                         CurrentOrd=--i;
                         CurrentTop=(i>ListViewRows-5) ? i-ListViewRows+5 : 0;

                         /* Attach tool list */
                         AttachToolList();
                        }
                        break;
    case GAD_EXEC_BUT:  TextButtonGadgetFunc(GAD_EXEC_TXT,LISTREQ_EXEC);
                        break;
    case GAD_IMAGE_BUT: TextButtonGadgetFunc(GAD_IMAGE_TXT,LISTREQ_IMAGE);
                        break;
    case GAD_SOUND_BUT: TextButtonGadgetFunc(GAD_SOUND_TXT,LISTREQ_SOUND);
                        break;
    case GAD_OK:        NewList=ToolsList;
                        break;
    case GAD_CANCEL:    NewList=(struct List *) -1;
                        FreeToolsList(ToolsList);
                        break;
   }
   break;
  case IDCMP_VANILLAKEY:
   switch (MatchVanillaKey(msg->Code,KeyArray)) {
    case KEY_NEW:    NewGadgetFunc();
                     break;
    case KEY_EXEC:   TextButtonGadgetFunc(GAD_EXEC_TXT,LISTREQ_EXEC);
                     break;
    case KEY_IMAGE:  TextButtonGadgetFunc(GAD_IMAGE_TXT,LISTREQ_IMAGE);
                     break;
    case KEY_SOUND:  TextButtonGadgetFunc(GAD_SOUND_TXT,LISTREQ_SOUND);
                     break;
    case KEY_OK:     NewList=ToolsList;
                     break;
    case KEY_CANCEL: NewList=(struct List *) -1;
                     FreeToolsList(ToolsList);
                     break;
   }
   break;
 }

 /* Close window? */
 if (NewList) {
  /* Yes. But first reply message!!! */
  GT_ReplyIMsg(msg);
  CloseDockListEditWindow();
 }

 return(NewList);
}

/* Update dock edit window */
void UpdateDockListEditWindow(void *data)
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
    case GAD_EXEC_TXT:  /* Detach tool list */
                        DetachToolList();

                        /* Set new Exec name */
                        old=CurrentTool->tn_Node.ln_Name;

                        /* Set VALID name! */
                        if (new || (new=strdup(
                                         AppStrings[MSG_LISTREQ_TITLE_EXEC])))
                         CurrentTool->tn_Node.ln_Name=new;
                        else
                         /* Could not set valid name */
                         old=NULL;

                        /* Attach tool list */
                        AttachToolList();
                        break;
    case GAD_IMAGE_TXT: /* Set new Image name */
                        old=CurrentTool->tn_Image;
                        CurrentTool->tn_Image=new;
                        break;
    case GAD_SOUND_TXT: /* Set new Sound name */
                        old=CurrentTool->tn_Sound;
                        CurrentTool->tn_Sound=new;
                        break;
   }

   /* Free old string */
   if (old) free(old);

   /* Set new text */
   SetTextGadget(CurrentGadgetNum,new);
  }
 }

 /* Enable window */
 EnableWindow(w,&DummyReq,WINDOW_IDCMP);

 /* Restore update function pointer */
 UpdateWindow=UpdateDockEditWindow;
 CurrentWindow=w;
 ReqOpen=FALSE;
}
