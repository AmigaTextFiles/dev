/*
 * imagewindow.c  V2.1
 *
 * image edit window handling
 *
 * (c) 1990-1993 Stefan Becker
 */

#include "ToolManagerConf.h"

/* Image node */
struct ImageNode {
                  struct Node  in_Node;
                  char        *in_File;
                 };

/* Window data */
static struct Gadget *gl;             /* Gadget list */
static struct Window *w;              /* Window */
static void *aw;                      /* AppWindow pointer */
static UWORD ww,wh;                   /* Window size */
static struct ImageNode *CurrentNode;
static char *DirName=NULL;
static struct Requester DummyReq;

/* Gadget data */
#define GAD_NAME_STR 0
#define GAD_FILE_BUT 1
#define GAD_FILE_TXT 2
#define GAD_FILE_STR 3
#define GAD_OK       4
#define GAD_CANCEL   5
#define GADGETS      6
static struct GadgetData gdata[GADGETS];

/* Gadget tags */
static struct TagItem nametags[]={GTST_String,   NULL,
                                  GTST_MaxChars, SGBUFLEN,
                                  TAG_DONE};

static struct TagItem filetags[]={GTST_String,   NULL,
                                  GTST_MaxChars, SGBUFLEN,
                                  TAG_DONE};

/* Gadget vanilla key data */
#define KEY_NAME   0
#define KEY_FILE   1
#define KEY_OK     2
#define KEY_CANCEL 3
static char KeyArray[KEY_CANCEL+1];

/* Init image edit window */
void InitImageEditWindow(UWORD left, UWORD fheight)
{
 ULONG tmp,tmp2,maxw1,maxw2;
 ULONG strheight=fheight+2;
 struct GadgetData *gd;

 /* Init strings */
 gdata[GAD_OK].name    =AppStrings[MSG_WINDOW_OK_GAD];
 gdata[GAD_CANCEL].name=AppStrings[MSG_WINDOW_CANCEL_GAD];

 /* Calculate maximum label width for string gadgets */
 maxw1=TextLength(&TmpRastPort,AppStrings[MSG_WINDOW_NAME_GAD],
                  strlen(AppStrings[MSG_WINDOW_NAME_GAD]));
 tmp=TextLength(&TmpRastPort,AppStrings[MSG_IMAGEWIN_FILE_GAD],
                strlen(AppStrings[MSG_IMAGEWIN_FILE_GAD]))+REQBUTTONWIDTH;
 if (tmp > maxw1) maxw1=tmp;
 maxw1+=INTERWIDTH;

 /* Calculate minimal string gadgets width */
 ww=TextLength(&TmpRastPort,
               AppStrings[MSG_IMAGEWIN_NEWNAME],
               strlen(AppStrings[MSG_IMAGEWIN_NEWNAME])
              ) + maxw1 + 3*INTERWIDTH;

 /* Calculate button gadgets width */
 gd=&gdata[GAD_OK];
 maxw2=TextLength(&TmpRastPort,gd->name,strlen(gd->name));
 gd++;
 if ((tmp=TextLength(&TmpRastPort,gd->name,strlen(gd->name))) > maxw2)
  maxw2=tmp;
 maxw2+=2*INTERWIDTH;
 if ((tmp=2*(maxw2+INTERWIDTH)) > ww) ww=tmp;

 /* window height */
 wh=3*fheight+4*INTERHEIGHT+4;

 /* Init gadgets */
 gd=gdata;
 tmp=WindowTop+INTERHEIGHT;
 tmp2=ww-maxw1-INTERWIDTH;
 maxw1+=left;

 /* Name string gadget */
 gd->name=AppStrings[MSG_WINDOW_NAME_GAD];
 gd->type=STRING_KIND;
 gd->flags=PLACETEXT_LEFT;
 gd->tags=nametags;
 gd->left=maxw1;
 gd->top=tmp;
 gd->width=tmp2;
 gd->height=strheight;
 tmp+=strheight+INTERHEIGHT;

 /* File name button gadget */
 gd++;
 gd->type=GENERIC_KIND;
 gd->flags=0;
 gd->left=maxw1-REQBUTTONWIDTH;
 gd->top=tmp;
 gd->width=REQBUTTONWIDTH;
 gd->height=strheight;

 /* File name text gadget */
 gd++;
 gd->name=AppStrings[MSG_IMAGEWIN_FILE_GAD];
 gd->type=TEXT_KIND;
 gd->flags=PLACETEXT_LEFT;
 gd->left=maxw1-REQBUTTONWIDTH;
 gd->top=tmp+strheight/2;
 gd->width=0;
 gd->height=0;

 /* File name string gadget */
 gd++;
 gd->type=STRING_KIND;
 gd->tags=filetags;
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
 KeyArray[KEY_FILE]  =FindVanillaKey(gdata[GAD_FILE_TXT].name);
 KeyArray[KEY_OK]    =FindVanillaKey(gdata[GAD_OK].name);
 KeyArray[KEY_CANCEL]=FindVanillaKey(gdata[GAD_CANCEL].name);

 /* Init dummy requester structure */
 InitRequester(&DummyReq);
}

/* Free image node */
void FreeImageNode(struct Node *node)
{
 struct ImageNode *in=(struct ImageNode *) node;
 char *s;

 if (s=in->in_Node.ln_Name) free(s);
 if (s=in->in_File) free(s);

 /* Free node */
 FreeMem(in,sizeof(struct ImageNode));
}

/* Copy image node */
struct Node *CopyImageNode(struct Node *node)
{
 struct ImageNode *in,*orignode=(struct ImageNode *) node;

 /* Alloc memory for image node */
 if (in=AllocMem(sizeof(struct ImageNode),MEMF_PUBLIC|MEMF_CLEAR)) {

  /* Got an old node? */
  if (orignode) {
   /* Yes, copy it */
   if ((!orignode->in_Node.ln_Name || (in->in_Node.ln_Name=
                                  strdup(orignode->in_Node.ln_Name))) &&
       (!orignode->in_File || (in->in_File=strdup(orignode->in_File))))
    return(in);
  } else
   /* No, set defaults */
   if ((in->in_Node.ln_Name=strdup(AppStrings[MSG_IMAGEWIN_NEWNAME])) &&
       (!DirName || (in->in_File=strdup(DirName))))
    /* Return pointer to new node */
    return(in);

  FreeImageNode((struct Node *) in);
 }
 /* Call failed */
 return(NULL);
}

/* Create image node from WBArg */
struct Node *CreateImageNode(char *name, struct WBArg *wa)
{
 struct ImageNode *in;

 /* Alloc memory for image node */
 if (in=AllocMem(sizeof(struct ImageNode),MEMF_PUBLIC|MEMF_CLEAR)) {
  char *filebuf;

  /* Init node */
  if ((in->in_Node.ln_Name=strdup(name)) &&
      (filebuf=malloc(4096))) {

   /* Create & copy icon file name */
   if (NameFromLock(wa->wa_Lock,filebuf,4096) &&
       AddPart(filebuf,wa->wa_Name,4096) &&
       (in->in_File=strdup(filebuf))) {
    /* All OK. */
    free(filebuf);
    return(in);
   }
   free(filebuf);
  }
  FreeImageNode((struct Node *) in);
 }
 /* Call failed */
 return(NULL);
}

/* Activate gadget and save pointer to it */
static void MyActivateGadget(ULONG num)
{
 ActivateGadget(gdata[num].gadget,w,NULL);
}

/* Open image edit window */
BOOL OpenImageEditWindow(struct Node *node, struct Window *parent)
{
 /* Copy node */
 if (CurrentNode=(struct ImageNode *) CopyImageNode(node)) {
  /* Set tags */
  nametags[0].ti_Data=(ULONG) CurrentNode->in_Node.ln_Name;
  filetags[0].ti_Data=(ULONG) CurrentNode->in_File;

  /* Create gadgets */
  if (gl=CreateGadgetList(gdata,GADGETS)) {
   /* Open window */
   if (w=OpenWindowTags(NULL,WA_Left,        parent->LeftEdge,
                             WA_Top,         parent->TopEdge+WindowTop,
                             WA_InnerWidth,  ww,
                             WA_InnerHeight, wh,
                             WA_AutoAdjust,  TRUE,
                             WA_Title,       AppStrings[MSG_IMAGEWIN_TITLE],
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
    InitReqButtonGadget(gdata[GAD_FILE_BUT].gadget);

    /* Add gadgets to window */
    AddGList(w,gl,(UWORD) -1,(UWORD) -1,NULL);
    RefreshGList(gl,w,NULL,(UWORD) -1);
    GT_RefreshWindow(w,NULL);

    /* Activate first gadget */
    MyActivateGadget(GAD_NAME_STR);

    /* Set local variables */
    w->UserPort=IDCMPPort;
    w->UserData=(BYTE *) HandleImageEditWindowIDCMP;
    ModifyIDCMP(w,IDCMP_CLOSEWINDOW|IDCMP_REFRESHWINDOW|BUTTONIDCMP|
                  STRINGIDCMP|IDCMP_VANILLAKEY);
    CurrentWindow=w;
    if (aw) HandleAppMsg=HandleImageEditWindowAppMsg;

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
  FreeImageNode((struct Node *) CurrentNode);
 }
 /* Call failed */
 return(FALSE);
}

/* Close image edit window */
static void CloseImageEditWindow(void)
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
void HandleImageEditWindowAppMsg(struct AppMessage *msg)
{
 struct WBArg *wa;

 /* Get first argument */
 if (wa=msg->am_ArgList) {
  char *filebuf;

  /* Allocate memory for name buffer */
  if (filebuf=malloc(4096)) {
   /* Build full file name */
   if (NameFromLock(wa->wa_Lock,filebuf,4096) &&
       AddPart(filebuf,wa->wa_Name,4096)) {
    /* Set new gadget values */
    GT_SetGadgetAttrs(gdata[GAD_NAME_STR].gadget,w,NULL,
                      GTST_String,wa->wa_Name,TAG_DONE);
    GT_SetGadgetAttrs(gdata[GAD_FILE_STR].gadget,w,NULL,
                      GTST_String,filebuf,TAG_DONE);
   }
   free(filebuf);
  }
 }
}

/* File gadget function */
static void FileGadgetFunc(void)
{
 char *file;
 struct Gadget *g=gdata[GAD_FILE_STR].gadget;

 /* Set file requester parameters */
 FileReqParms.frp_OldFile=((struct StringInfo *) g->SpecialInfo)->Buffer;

 /* Open file requester */
 if (file=OpenFileRequester(&DummyReq)) {
  char *path;

  /* Set new file string */
  GT_SetGadgetAttrs(g,w,NULL,GTST_String,file,TAG_DONE);

  /* Get new path */
  path=FilePart(file);
  if (path!=file) {
   /* Free old path */
   if (DirName) free(DirName);

   /* Set new path */
   DirName=file;
   *path='\0';
  }

  /* Activate string gadget */
  MyActivateGadget(GAD_FILE_STR);
 }
}

/* OK gadget function */
static struct Node *OKGadgetFunc(void)
{
 struct Node *rc;
 char *s;

 /* Free old strings */
 if (s=CurrentNode->in_Node.ln_Name) free(s);
 CurrentNode->in_Node.ln_Name=NULL;
 if (s=CurrentNode->in_File) free(s);
 CurrentNode->in_File=NULL;

 /* Duplicate new strings */
 if (((CurrentNode->in_Node.ln_Name=
        DuplicateBuffer(gdata[GAD_NAME_STR].gadget)) != (char *) -1) &&
     ((CurrentNode->in_File=
        DuplicateBuffer(gdata[GAD_FILE_STR].gadget)) != (char *) -1)) {
  char *s=CurrentNode->in_File;
  ULONG len=strlen(s);

  /* Strip trailing ".info" */
  if ((len>=5) && !stricmp(s+len-5,".info")) s[len-5]='\0';
  rc=(struct Node *) CurrentNode;
 } else {
  /* Couldn't copy strings */
  rc=(struct Node *) -1;
  FreeImageNode((struct Node *) CurrentNode);
 }
 return(rc);
}

/* Handle image edit window IDCMP events */
void *HandleImageEditWindowIDCMP(struct IntuiMessage *msg)
{
 struct Node *NewNode=NULL;

 /* Which IDCMP class? */
 switch (msg->Class) {
  case IDCMP_CLOSEWINDOW:   NewNode=(struct Node *) -1;
                            FreeImageNode((struct Node *) CurrentNode);
                            break;
  case IDCMP_REFRESHWINDOW: GT_BeginRefresh(w);
                            GT_EndRefresh(w,TRUE);
                            break;
  case IDCMP_GADGETUP:
   switch (((struct Gadget *) msg->IAddress)->GadgetID) {
    case GAD_FILE_BUT: FileGadgetFunc();
                       break;
    case GAD_OK:       NewNode=OKGadgetFunc();
                       break;
    case GAD_CANCEL:   NewNode=(struct Node *) -1;
                       FreeImageNode((struct Node *) CurrentNode);
                       break;
   }
   break;
  case IDCMP_VANILLAKEY:
   switch (MatchVanillaKey(msg->Code,KeyArray)) {
    case KEY_NAME:   MyActivateGadget(GAD_NAME_STR);
                     break;
    case KEY_FILE:   FileGadgetFunc();
                     break;
    case KEY_OK:     NewNode=OKGadgetFunc();
                     break;
    case KEY_CANCEL: NewNode=(struct Node *) -1;
                     FreeImageNode((struct Node *) CurrentNode);
                     break;
   }
   break;
 }

 /* Close window? */
 if (NewNode) {
  /* Yes. But first reply message!!! */
  GT_ReplyIMsg(msg);
  CloseImageEditWindow();
 }

 return(NewNode);
}

/* Read TMIM IFF chunk into Image node */
struct Node *ReadImageNode(UBYTE *buf)
{
 struct ImageNode *in;

 /* Allocate memory for node */
 if (in=AllocMem(sizeof(struct ImageNode),MEMF_PUBLIC|MEMF_CLEAR)) {
  struct ImagePrefsObject *ipo=(struct ImagePrefsObject *) buf;
  ULONG sbits=ipo->ipo_StringBits;
  UBYTE *ptr=(UBYTE *) &ipo[1];

  if ((!(sbits & IMPO_NAME) || (in->in_Node.ln_Name=GetConfigStr(&ptr))) &&
      (!(sbits & IMPO_FILE) || (in->in_File=GetConfigStr(&ptr))))
   /* All OK. */
   return(in);

  /* Call failed */
  FreeImageNode((struct Node *) in);
 }
 return(NULL);
}

/* Write Image node to TMIM IFF chunk */
BOOL WriteImageNode(struct IFFHandle *iff, UBYTE *buf, struct Node *node)
{
 struct ImageNode *in=(struct ImageNode *) node;
 struct ImagePrefsObject *ipo=(struct ImagePrefsObject *) buf;
 ULONG sbits=0;
 UBYTE *ptr=(UBYTE *) &ipo[1];

 /* Copy strings */
 if (PutConfigStr(in->in_Node.ln_Name,&ptr)) sbits|=IMPO_NAME;
 if (PutConfigStr(in->in_File,&ptr)) sbits|=IMPO_FILE;

 /* set string bits */
 ipo->ipo_StringBits=sbits;

 /* calculate length */
 sbits=ptr-buf;

 DEBUG_PRINTF("chunk size %ld\n",sbits);

 /* Open chunk */
 if (PushChunk(iff,0,ID_TMIM,sbits)) return(FALSE);

 /* Write chunk */
 if (WriteChunkBytes(iff,buf,sbits)!=sbits) return(FALSE);

 /* Close chunk */
 if (PopChunk(iff)) return(FALSE);

 /* All OK. */
 return(TRUE);
}
