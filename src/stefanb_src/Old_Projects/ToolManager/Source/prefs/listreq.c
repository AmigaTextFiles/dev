/*
 * listreq.c  V2.1
 *
 * list requester handling
 *
 * (c) 1990-1993 Stefan Becker
 */

#include "ToolManagerConf.h"

/* Window data */
static struct Gadget *gl;             /* Gadget list */
static struct Window *w;              /* Window */
static struct MsgPort *wp;            /* Window user port */
static UWORD ww,wh;                   /* Window size */
static struct List *CurrentList;
static struct Node *CurrentNode;
static ULONG OldSeconds,OldMicros;

/* Gadget data */
#define GAD_LIST   0
#define GAD_OK     1
#define GAD_CANCEL 2
#define GADGETS    3
static struct GadgetData gdata[GADGETS];

/* Gadget tags */
static struct TagItem lvtags[]={GTLV_Labels,       NULL,
                                GTLV_ShowSelected, NULL,
                                TAG_DONE};

/* Gadget vanilla key data */
#define KEY_OK     0
#define KEY_CANCEL 1
static char KeyArray[KEY_CANCEL+1];

/* Init list requester */
void InitListRequester(UWORD left, UWORD fheight)
{
 ULONG tmp,maxw1,maxw2;
 struct GadgetData *gd;

 /* Init strings */
 gdata[GAD_OK].name    =AppStrings[MSG_WINDOW_OK_GAD];
 gdata[GAD_CANCEL].name=AppStrings[MSG_WINDOW_CANCEL_GAD];

 /* Calculate maximum width for list gadget */
 maxw1=ListViewColumns*ScreenFont->tf_XSize;
 ww=maxw1+INTERWIDTH;

 /* Calculate maximum width for button gadgets */
 gd=&gdata[GAD_OK];
 maxw2=TextLength(&TmpRastPort,gd->name,strlen(gd->name));
 gd++;
 if ((tmp=TextLength(&TmpRastPort,gd->name,strlen(gd->name))) > maxw2)
  maxw2=tmp;
 maxw2+=2*INTERWIDTH;
 if ((tmp=2*(maxw2+INTERWIDTH)) > ww) ww=tmp;

 /* window height */
 wh=(ListViewRows+3)*fheight+3*INTERHEIGHT;

 /* ListView gadget */
 gd=gdata;
 tmp=ww-INTERWIDTH;
 gd->type=LISTVIEW_KIND;
 gd->tags=lvtags;
 gd->left=left;
 gd->top=WindowTop+INTERHEIGHT;
 gd->width=tmp;
 gd->height=(ListViewRows+2)*fheight;

 /* OK gadget */
 tmp=WindowTop+(ListViewRows+2)*fheight+2*INTERHEIGHT;
 gd++;
 gd->type=BUTTON_KIND;
 gd->flags=PLACETEXT_IN;
 gd->tags=NULL;
 gd->left=left;
 gd->top=tmp;
 gd->width=maxw2;
 gd->height=fheight;

 /* Cancel Gadget */
 gd++;
 gd->type=BUTTON_KIND;
 gd->flags=PLACETEXT_IN;
 gd->tags=NULL;
 gd->left=ww-maxw2-INTERWIDTH+left;
 gd->top=tmp;
 gd->width=maxw2;
 gd->height=fheight;

 /* Init vanilla key array */
 KeyArray[KEY_OK]    =FindVanillaKey(gdata[GAD_OK].name);
 KeyArray[KEY_CANCEL]=FindVanillaKey(gdata[GAD_CANCEL].name);
}

/* Open list requester */
BOOL OpenListRequester(ULONG type, struct Window *oldwindow)
{
 char *title;

 /* Set title & list */
 switch (type) {
  case LISTREQ_EXEC:  title=AppStrings[MSG_LISTREQ_TITLE_EXEC];
                      CurrentList=&ObjectLists[TMOBJTYPE_EXEC];
                      break;
  case LISTREQ_IMAGE: title=AppStrings[MSG_LISTREQ_TITLE_IMAGE];
                      CurrentList=&ObjectLists[TMOBJTYPE_IMAGE];
                      break;
  case LISTREQ_SOUND: title=AppStrings[MSG_LISTREQ_TITLE_SOUND];
                      CurrentList=&ObjectLists[TMOBJTYPE_SOUND];
                      break;
  case LISTREQ_DOCK:  title=AppStrings[MSG_LISTREQ_TITLE_DOCK];
                      CurrentList=&ObjectLists[TMOBJTYPE_DOCK];
                      break;
  case LISTREQ_PUBSC: title=AppStrings[MSG_LISTREQ_TITLE_PUBSCREEN];
                      CurrentList=&PubScreenList;
                      break;
 }

 /* Set tags */
 lvtags[0].ti_Data=(ULONG) CurrentList;

 /* Create gadgets */
 if (gl=CreateGadgetList(gdata,GADGETS)) {
  /* Open window */
  if (w=OpenWindowTags(NULL,WA_Left,        oldwindow->LeftEdge,
                            WA_Top,         oldwindow->TopEdge+WindowTop,
                            WA_InnerWidth,  ww,
                            WA_InnerHeight, wh,
                            WA_AutoAdjust,  TRUE,
                            WA_Title,       title,
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
   w->UserData=(BYTE *) HandleListRequesterIDCMP;
   ModifyIDCMP(w,IDCMP_CLOSEWINDOW|IDCMP_REFRESHWINDOW|BUTTONIDCMP|
                 LISTVIEWIDCMP|IDCMP_VANILLAKEY);
   CurrentWindow=w;
   CurrentNode=NULL;
   OldSeconds=0;
   OldMicros=0;

   /* All OK. (Return window UserPort signal mask) */
   return(TRUE);
  }

  FreeGadgets(gl);
 }
 /* Call failed */
 return(FALSE);
}

/* Close list requester */
void CloseListRequester(void)
{
 /* Free resources */
 RemoveGList(w,gl,(UWORD) -1);
 CloseWindowSafely(w);
 FreeGadgets(gl);
}

/* Handle list requester IDCMP events */
void *HandleListRequesterIDCMP(struct IntuiMessage *msg)
{
 struct Node *NewNode;

 /* Which IDCMP Class? */
 switch (msg->Class) {
  case IDCMP_CLOSEWINDOW:   NewNode=LREQRET_CANCEL;
                            break;
  case IDCMP_REFRESHWINDOW: GT_BeginRefresh(w);
                            GT_EndRefresh(w,TRUE);
                            break;
  case IDCMP_GADGETUP:
   switch (((struct Gadget *) msg->IAddress)->GadgetID) {
    case GAD_LIST:   {
                      ULONG code=msg->Code;

                      /* Search node */
                      CurrentNode=GetHead(CurrentList);
                      while (code--) CurrentNode=GetSucc(CurrentNode);

                      /* Double-click? */
                      if (DoubleClick(OldSeconds,OldMicros,
                                      msg->Seconds,msg->Micros))
                       /* Yes. Quit requester */
                       if (CurrentNode)
                        NewNode=CurrentNode;
                       else
                        NewNode=LREQRET_NOSELECT;

                      /* Save current time */
                      OldSeconds=msg->Seconds;
                      OldMicros=msg->Micros;
                     }
                     break;
    case GAD_OK:     if (CurrentNode)
                      NewNode=CurrentNode;
                     else
                      NewNode=LREQRET_NOSELECT;
                     break;
    case GAD_CANCEL: NewNode=LREQRET_CANCEL;
                     break;
   }
   break;
  case IDCMP_VANILLAKEY:
   switch (MatchVanillaKey(msg->Code,KeyArray)) {
    case KEY_OK:     if (CurrentNode)
                      NewNode=CurrentNode;
                     else
                      NewNode=LREQRET_NOSELECT;
                     break;
    case KEY_CANCEL: NewNode=LREQRET_CANCEL;
                     break;
   }
   break;
 }

 /* Close window? */
 if (NewNode) {
  /* Yes. But first reply message!!! */
  GT_ReplyIMsg(msg);
  CloseListRequester();
 }

 return(NewNode);
}
