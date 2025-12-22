/*
 * soundwindow.c  V2.1
 *
 * sound edit window handling
 *
 * (c) 1990-1993 Stefan Becker
 */

#include "ToolManagerConf.h"

/* Sound node */
struct SoundNode {
                  struct Node  sn_Node;
                  char        *sn_Command;
                  char        *sn_Port;
                 };

/* Window data */
static struct Gadget *gl;             /* Gadget list */
static struct Window *w;              /* Window */
static struct MsgPort *wp;            /* Window user port */
static UWORD ww,wh;                   /* Window size */
static struct SoundNode *CurrentNode;

/* Gadget data */
#define GAD_NAME_STR  0
#define GAD_COMM_STR  1
#define GAD_AREXX_STR 2
#define GAD_OK        3
#define GAD_CANCEL    4
#define GADGETS       5
static struct GadgetData gdata[GADGETS];

/* Gadget tags */
static struct TagItem nametags[]={GTST_String,   NULL,
                                  GTST_MaxChars, SGBUFLEN,
                                  TAG_DONE};

static struct TagItem commtags[]={GTST_String,   NULL,
                                  GTST_MaxChars, SGBUFLEN,
                                  TAG_DONE};

static struct TagItem arexxtags[]={GTST_String,   NULL,
                                   GTST_MaxChars, SGBUFLEN,
                                   TAG_DONE};

/* Gadget vanilla key data */
#define KEY_NAME   0
#define KEY_COMM   1
#define KEY_AREXX  2
#define KEY_OK     3
#define KEY_CANCEL 4
static char KeyArray[KEY_CANCEL+1];

/* Init sound edit window */
void InitSoundEditWindow(UWORD left, UWORD fheight)
{
 ULONG tmp,tmp2,maxw1,maxw2;
 ULONG strheight=fheight+2;
 struct GadgetData *gd;

 /* Init strings */
 gdata[GAD_NAME_STR].name =AppStrings[MSG_WINDOW_NAME_GAD];
 gdata[GAD_COMM_STR].name =AppStrings[MSG_WINDOW_COMMAND_GAD];
 gdata[GAD_AREXX_STR].name=AppStrings[MSG_SOUNDWIN_AREXX_GAD];
 gdata[GAD_OK].name       =AppStrings[MSG_WINDOW_OK_GAD];
 gdata[GAD_CANCEL].name   =AppStrings[MSG_WINDOW_CANCEL_GAD];

 /* Calculate maximum label width for string gadgets */
 gd=gdata;
 maxw1=0;
 for (tmp=GAD_NAME_STR; tmp<=GAD_AREXX_STR; tmp++, gd++)
  if ((tmp2=TextLength(&TmpRastPort,gd->name,strlen(gd->name))) > maxw1)
   maxw1=tmp2;
 maxw1+=INTERWIDTH;

 /* Calculate minimal string gadgets width */
 ww=TextLength(&TmpRastPort,AppStrings[MSG_SOUNDWIN_NEWNAME],
               strlen(AppStrings[MSG_SOUNDWIN_NEWNAME]))+
    maxw1+3*INTERWIDTH;

 /* Calculate button gadgets width */
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
 maxw1+=left;

 /* Name string gadget */
 gd->type=STRING_KIND;
 gd->flags=PLACETEXT_LEFT;
 gd->tags=nametags;
 gd->left=maxw1;
 gd->top=tmp;
 gd->width=tmp2;
 gd->height=strheight;
 tmp+=strheight+INTERHEIGHT;

 /* File name string gadget */
 gd++;
 gd->type=STRING_KIND;
 gd->flags=PLACETEXT_LEFT;
 gd->tags=commtags;
 gd->left=maxw1;
 gd->top=tmp;
 gd->width=tmp2;
 gd->height=strheight;
 tmp+=strheight+INTERHEIGHT;

 /* ARexx port gadget */
 gd++;
 gd->type=STRING_KIND;
 gd->flags=PLACETEXT_LEFT;
 gd->tags=arexxtags;
 gd->left=maxw1;
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
 KeyArray[KEY_COMM]  =FindVanillaKey(gdata[GAD_COMM_STR].name);
 KeyArray[KEY_AREXX] =FindVanillaKey(gdata[GAD_AREXX_STR].name);
 KeyArray[KEY_OK]    =FindVanillaKey(gdata[GAD_OK].name);
 KeyArray[KEY_CANCEL]=FindVanillaKey(gdata[GAD_CANCEL].name);
}

/* Free sound node */
void FreeSoundNode(struct Node *node)
{
 struct SoundNode *sn=(struct SoundNode *) node;
 char *s;

 if (s=sn->sn_Node.ln_Name) free(s);
 if (s=sn->sn_Command) free(s);
 if (s=sn->sn_Port) free(s);

 /* Free node */
 FreeMem(sn,sizeof(struct SoundNode));
}

/* Copy sound node */
struct Node *CopySoundNode(struct Node *node)
{
 struct SoundNode *sn,*orignode=(struct SoundNode *) node;

 /* Alloc memory for sound node */
 if (sn=AllocMem(sizeof(struct SoundNode),MEMF_CLEAR)) {

  /* Got an old node? */
  if (orignode) {
   /* Yes, copy it */
   if ((!orignode->sn_Node.ln_Name || (sn->sn_Node.ln_Name=
                                        strdup(orignode->sn_Node.ln_Name))) &&
       (!orignode->sn_Command || (sn->sn_Command=
                                   strdup(orignode->sn_Command))) &&
       (!orignode->sn_Port || (sn->sn_Port=strdup(orignode->sn_Port))))
    return(sn);
  } else
   /* No, set defaults */
   if (sn->sn_Node.ln_Name=strdup(AppStrings[MSG_SOUNDWIN_NEWNAME]))
    /* Return pointer to new node */
    return(sn);

  FreeSoundNode((struct Node *) sn);
 }
 /* Call failed */
 return(NULL);
}

/* Activate gadget and save pointer to it */
static void MyActivateGadget(ULONG num)
{
 ActivateGadget(gdata[num].gadget,w,NULL);
}

/* Open sound edit window */
BOOL OpenSoundEditWindow(struct Node *node, struct Window *parent)
{
 /* Copy node */
 if (CurrentNode=(struct SoundNode *) CopySoundNode(node)) {
  /* Set tags */
  nametags[0].ti_Data=(ULONG) CurrentNode->sn_Node.ln_Name;
  commtags[0].ti_Data=(ULONG) CurrentNode->sn_Command;
  arexxtags[0].ti_Data=(ULONG) CurrentNode->sn_Port;

  /* Create gadgets */
  if (gl=CreateGadgetList(gdata,GADGETS)) {
   /* Open window */
   if (w=OpenWindowTags(NULL,WA_Left,        parent->LeftEdge,
                             WA_Top,         parent->TopEdge+WindowTop,
                             WA_InnerWidth,  ww,
                             WA_InnerHeight, wh,
                             WA_AutoAdjust,  TRUE,
                             WA_Title,       AppStrings[MSG_SOUNDWIN_TITLE],
                             WA_PubScreen,   PublicScreen,
                             WA_Flags,       WFLG_CLOSEGADGET|WFLG_DRAGBAR|
                                             WFLG_DEPTHGADGET|WFLG_RMBTRAP|
                                             WFLG_ACTIVATE,
                             TAG_DONE)) {
    /* Add gadgets to window */
    AddGList(w,gl,(UWORD) -1,(UWORD) -1,NULL);
    RefreshGList(gl,w,NULL,(UWORD) -1);
    GT_RefreshWindow(w,NULL);

    /* Activate first gadget */
    MyActivateGadget(GAD_NAME_STR);

    /* Set local variables */
    w->UserPort=IDCMPPort;
    w->UserData=(BYTE *) HandleSoundEditWindowIDCMP;
    ModifyIDCMP(w,IDCMP_CLOSEWINDOW|IDCMP_REFRESHWINDOW|BUTTONIDCMP|
                  STRINGIDCMP|IDCMP_VANILLAKEY);
    CurrentWindow=w;

    /* Set up file requester parameters */
    FileReqParms.frp_Window=w;
    FileReqParms.frp_Title=AppStrings[MSG_FILEREQ_TITLE_FILE];
    FileReqParms.frp_OKText=AppStrings[MSG_FILEREQ_OK_GAD];
    FileReqParms.frp_Flags1=FRF_DOPATTERNS;
    FileReqParms.frp_Flags2=0;

    /* All OK. */
    return(TRUE);
   }
   FreeGadgets(gl);
  }
  FreeSoundNode((struct Node *) CurrentNode);
 }
 /* Call failed */
 return(FALSE);
}

/* Close sound edit window */
static void CloseSoundEditWindow(void)
{
 /* Free resources */
 RemoveGList(w,gl,(UWORD) -1);
 CloseWindowSafely(w);
 FreeGadgets(gl);
}

/* OK gadget function */
static struct Node *OKGadgetFunc(void)
{
 struct Node *rc;
 char *s;

 /* Free old strings */
 if (s=CurrentNode->sn_Node.ln_Name) free(s);
 CurrentNode->sn_Node.ln_Name=NULL;
 if (s=CurrentNode->sn_Command) free(s);
 CurrentNode->sn_Command=NULL;
 if (s=CurrentNode->sn_Port) free(s);
 CurrentNode->sn_Port=NULL;

 /* Duplicate new strings */
 if (((CurrentNode->sn_Node.ln_Name=
        DuplicateBuffer(gdata[GAD_NAME_STR].gadget)) != (char *) -1) &&
     ((CurrentNode->sn_Command=
        DuplicateBuffer(gdata[GAD_COMM_STR].gadget)) != (char *) -1) &&
     ((CurrentNode->sn_Port=
        DuplicateBuffer(gdata[GAD_AREXX_STR].gadget)) != (char *) -1))
  rc=(struct Node *) CurrentNode;
 else {
  /* Couldn't copy strings */
  rc=(struct Node *) -1;
  FreeSoundNode((struct Node *) CurrentNode);
 }
 return(rc);
}

/* Handle sound edit window IDCMP events */
void *HandleSoundEditWindowIDCMP(struct IntuiMessage *msg)
{
 struct Node *NewNode=NULL;

 /* Which IDCMP class? */
 switch (msg->Class) {
  case IDCMP_CLOSEWINDOW:   NewNode=(struct Node *) -1;
                            FreeSoundNode((struct Node *) CurrentNode);
                            break;
  case IDCMP_REFRESHWINDOW: GT_BeginRefresh(w);
                            GT_EndRefresh(w,TRUE);
                            break;
  case IDCMP_GADGETUP:
   switch (((struct Gadget *) msg->IAddress)->GadgetID) {
    case GAD_OK:     NewNode=OKGadgetFunc();
                     break;
    case GAD_CANCEL: NewNode=(struct Node *) -1;
                     FreeSoundNode((struct Node *) CurrentNode);
                     break;
   }
   break;
  case IDCMP_VANILLAKEY:
   switch (MatchVanillaKey(msg->Code,KeyArray)) {
    case KEY_NAME:   MyActivateGadget(GAD_NAME_STR);
                     break;
    case KEY_COMM:   MyActivateGadget(GAD_COMM_STR);
                     break;
    case KEY_AREXX:  MyActivateGadget(GAD_AREXX_STR);
                     break;
    case KEY_OK:     NewNode=OKGadgetFunc();
                     break;
    case KEY_CANCEL: NewNode=(struct Node *) -1;
                     FreeSoundNode((struct Node *) CurrentNode);
                     break;
   }
   break;
 }

 /* Close window? */
 if (NewNode) {
  /* Yes. But first reply message!!! */
  GT_ReplyIMsg(msg);
  CloseSoundEditWindow();
 }

 return(NewNode);
}

/* Read TMSO IFF chunk into Sound node */
struct Node *ReadSoundNode(UBYTE *buf)
{
 struct SoundNode *sn;

 /* Allocate memory for node */
 if (sn=AllocMem(sizeof(struct SoundNode),MEMF_PUBLIC|MEMF_CLEAR)) {
  struct SoundPrefsObject *spo=(struct SoundPrefsObject *) buf;
  ULONG sbits=spo->spo_StringBits;
  UBYTE *ptr=(UBYTE *) &spo[1];

  if ((!(sbits & SOPO_NAME) || (sn->sn_Node.ln_Name=GetConfigStr(&ptr))) &&
      (!(sbits & SOPO_COMMAND) || (sn->sn_Command=GetConfigStr(&ptr))) &&
      (!(sbits & SOPO_PORT) || (sn->sn_Port=GetConfigStr(&ptr))))
   /* All OK. */
   return(sn);

  /* Call failed */
  FreeSoundNode((struct Node *) sn);
 }
 return(NULL);
}

/* Write Sound node to TMSO IFF chunk */
BOOL WriteSoundNode(struct IFFHandle *iff, UBYTE *buf, struct Node *node)
{
 struct SoundNode *sn=(struct SoundNode *) node;
 struct SoundPrefsObject *spo=(struct SoundPrefsObject *) buf;
 ULONG sbits=0;
 UBYTE *ptr=(UBYTE *) &spo[1];

 /* Copy strings */
 if (PutConfigStr(sn->sn_Node.ln_Name,&ptr)) sbits|=SOPO_NAME;
 if (PutConfigStr(sn->sn_Command,&ptr)) sbits|=SOPO_COMMAND;
 if (PutConfigStr(sn->sn_Port,&ptr)) sbits|=SOPO_PORT;

 /* set string bits */
 spo->spo_StringBits=sbits;

 /* calculate length */
 sbits=ptr-buf;

 DEBUG_PRINTF("chunk size %ld\n",sbits);

 /* Open chunk */
 if (PushChunk(iff,0,ID_TMSO,sbits)) return(FALSE);

 /* Write chunk */
 if (WriteChunkBytes(iff,buf,sbits)!=sbits) return(FALSE);

 /* Close chunk */
 if (PopChunk(iff)) return(FALSE);

 /* All OK. */
 return(TRUE);
}
