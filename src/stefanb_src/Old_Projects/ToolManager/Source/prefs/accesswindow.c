/*
 * accesswindow.c  V2.1
 *
 * access edit window handling
 *
 * (c) 1990-1993 Stefan Becker
 */

#include "ToolManagerConf.h"

/* Library for host requester */
struct Library *EnvoyBase;

struct AccessNode {
                   struct Node an_Node;
                   struct List an_Entries;
                  };

/* Window data */
static struct Gadget *gl;             /* Gadget list */
static struct Window *w;              /* Window */
static struct MsgPort *wp;            /* Window user port */
static UWORD ww,wh;                   /* Window size */
static struct AccessNode *CurrentNode;
static struct Node *CurrentEntry;
static LONG CurrentTop;               /* Top tool ordinal number */
static LONG CurrentOrd;               /* Current tool ordinal number */
static BOOL ReqOpen;
static struct Requester DummyReq;
#define WINDOW_IDCMP (IDCMP_CLOSEWINDOW|IDCMP_REFRESHWINDOW|BUTTONIDCMP|\
                      LISTVIEWIDCMP|IDCMP_VANILLAKEY)

/* Gadget data */
#define GAD_NAME_BUT 0
#define GAD_NAME_TXT 1
#define GAD_NAME_STR 2
#define GAD_ENTRIES  3
#define GAD_ADD      4
#define GAD_REMOVE   5
#define GAD_OK       6
#define GAD_CANCEL   7
#define GADGETS      8
static struct GadgetData gdata[GADGETS];

/* Gadget tags */
static struct TagItem nametags[]={GTST_String,   NULL,
                                  GTST_MaxChars, SGBUFLEN,
                                  TAG_DONE};

static struct TagItem lvtags[]={GTLV_Labels,       NULL,
                                GTLV_ShowSelected, NULL,
                                TAG_DONE};

/* Gadget vanilla key data */
#define KEY_NAME   0
#define KEY_ADD    1
#define KEY_OK     2
#define KEY_CANCEL 3
static char KeyArray[KEY_CANCEL+1];

/* Init access edit window */
void InitAccessEditWindow(UWORD left, UWORD fheight)
{
 ULONG i,tmp,maxw1,maxw2;
 ULONG strheight=fheight+2;
 struct GadgetData *gd;

 /* Init strings */
 gdata[GAD_NAME_TXT].name=AppStrings[MSG_WINDOW_NAME_GAD];
 gdata[GAD_ENTRIES].name =AppStrings[MSG_ACCESSWIN_ENTRIES_GAD];
 gdata[GAD_ADD].name     =AppStrings[MSG_ACCESSWIN_ADD_GAD];
 gdata[GAD_REMOVE].name  =AppStrings[MSG_WINDOW_REMOVE_GAD];
 gdata[GAD_OK].name      =AppStrings[MSG_WINDOW_OK_GAD];
 gdata[GAD_CANCEL].name  =AppStrings[MSG_WINDOW_CANCEL_GAD];

 /* Calculate maximum label width for name string gadget */
 maxw1=TextLength(&TmpRastPort,AppStrings[MSG_WINDOW_NAME_GAD],
                  strlen(AppStrings[MSG_WINDOW_NAME_GAD]));
 maxw1+=INTERWIDTH+REQBUTTONWIDTH;

 /* Calculate minimal string gadget width */
 ww=TextLength(&TmpRastPort,AppStrings[MSG_ACCESSWIN_NEWNAME],
               strlen(AppStrings[MSG_ACCESSWIN_NEWNAME]))+
    maxw1+3*INTERWIDTH;

 /* Calculate width for listview gadget */
 if ((tmp=ListViewColumns*ScreenFont->tf_XSize) > ww) ww=tmp;

 /* Calculate button gadgets width */
 gd=&gdata[GAD_ADD];
 maxw2=0;
 for (i=GAD_ADD; i<=GAD_CANCEL; i++, gd++)
  if ((tmp=TextLength(&TmpRastPort,gd->name,strlen(gd->name))) > maxw2)
   maxw2=tmp;
 maxw2+=2*INTERWIDTH;
 if ((tmp=2*(maxw2+INTERWIDTH)) > ww) ww=tmp;

 /* window height */
 wh=(ListViewRows+3)*fheight+5*INTERHEIGHT+2;

 /* Init gadgets */
 gd=gdata;
 maxw1+=left;
 tmp=WindowTop+INTERHEIGHT;

 /* Name button gadget */
 gd->type=GENERIC_KIND;
 gd->flags=0;
 gd->left=maxw1-REQBUTTONWIDTH;
 gd->top=tmp;
 gd->width=REQBUTTONWIDTH;
 gd->height=strheight;

 /* Name text gadget */
 gd++;
 gd->type=TEXT_KIND;
 gd->flags=PLACETEXT_LEFT;
 gd->left=maxw1-REQBUTTONWIDTH;
 gd->top=tmp+strheight/2;
 gd->width=0;
 gd->height=0;

 /* Name string gadget */
 gd++;
 gd->type=STRING_KIND;
 gd->flags=PLACETEXT_LEFT;
 gd->tags=nametags;
 gd->left=maxw1;
 gd->top=tmp;
 gd->width=ww-maxw1-INTERWIDTH+left;
 gd->height=strheight;
 tmp+=strheight+fheight+INTERHEIGHT;

 /* Exec objects list gadget */
 gd++;
 gd->type=LISTVIEW_KIND;
 gd->flags=PLACETEXT_ABOVE;
 gd->tags=lvtags;
 gd->left=left;
 gd->top=tmp;
 gd->width=ww-INTERWIDTH;
 gd->height=(ListViewRows-1)*fheight;
 tmp+=(ListViewRows-1)*fheight+INTERHEIGHT;

 /* Add button gadget */
 maxw1=ww-maxw2-INTERWIDTH+left;
 gd++;
 gd->type=BUTTON_KIND;
 gd->flags=PLACETEXT_IN;
 gd->left=left;
 gd->top=tmp;
 gd->width=maxw2;
 gd->height=fheight;

 /* Remove button gadget */
 gd++;
 gd->type=BUTTON_KIND;
 gd->flags=PLACETEXT_IN;
 gd->tags=DisabledTags;
 gd->left=maxw1;
 gd->top=tmp;
 gd->width=maxw2;
 gd->height=fheight;
 tmp+=fheight+INTERHEIGHT;

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
 gd->left=maxw1;
 gd->top=tmp;
 gd->width=maxw2;
 gd->height=fheight;

 /* Init vanilla key array */
 KeyArray[KEY_NAME]  =FindVanillaKey(gdata[GAD_NAME_TXT].name);
 KeyArray[KEY_ADD]   =FindVanillaKey(gdata[GAD_ADD].name);
 KeyArray[KEY_OK]    =FindVanillaKey(gdata[GAD_OK].name);
 KeyArray[KEY_CANCEL]=FindVanillaKey(gdata[GAD_CANCEL].name);

 /* Init dummy requester structure */
 InitRequester(&DummyReq);
}

/* Free Access node */
void FreeAccessNode(struct Node *node)
{
 struct AccessNode *an=(struct AccessNode *) node;
 char *s;

 if (s=an->an_Node.ln_Name) free(s);

 /* Free entries */
 {
  struct Node *aen1,*aen2=GetHead(&an->an_Entries);

  /* Scan list */
  while (aen1=aen2) {
   /* Get next node */
   aen2=GetSucc(aen1);

   /* Remove node */
   Remove(aen1);

   /* Free node */
   if (s=aen1->ln_Name) free(s);
   FreeMem(aen1,sizeof(struct Node));
  }
 }
 /* Free Node */
 FreeMem(an,sizeof(struct AccessNode));
}

/* Copy entries list */
static BOOL CopyEntriesList(struct List *src, struct List *dest)
{
 struct Node *orignode=GetHead(src);
 BOOL rc=TRUE;

 /* Scan source list */
 while (rc && orignode) {
  struct Node *newnode;

  /* Alloc memory for new node */
  if (newnode=AllocMem(sizeof(struct Node),MEMF_CLEAR|MEMF_PUBLIC)) {
   /* Append new node */
   AddTail(dest,newnode);

   /* Copy name */
   if (orignode->ln_Name && !(newnode->ln_Name=strdup(orignode->ln_Name)))
    rc=FALSE;
  } else
   /* Error */
   rc=FALSE;

  /* Get pointer to next node */
  orignode=GetSucc(orignode);
 }
 return(rc);
}

/* Copy Access node */
struct Node *CopyAccessNode(struct Node *node)
{
 struct AccessNode *an,*orignode=(struct AccessNode *) node;

 /* Alloc memory for Access node */
 if (an=AllocMem(sizeof(struct AccessNode),MEMF_PUBLIC|MEMF_CLEAR)) {
  NewList(&an->an_Entries);

  /* Got an old node? */
  if (orignode) {
   /* Yes, copy it */
   if ((!orignode->an_Node.ln_Name || (an->an_Node.ln_Name=
                                        strdup(orignode->an_Node.ln_Name))) &&
       CopyEntriesList(&orignode->an_Entries,&an->an_Entries))
   return(an);
  } else
   /* No, set defaults */
   if (an->an_Node.ln_Name=strdup(AppStrings[MSG_ACCESSWIN_NEWNAME]))
    /* Return pointer to new node */
    return(an);

  FreeAccessNode((struct Node *) an);
 }
 /* Call failed */
 return(NULL);
}

/* Activate name string gadget */
static void ActivateNameGadget(void)
{
 ActivateGadget(gdata[GAD_NAME_STR].gadget,w,NULL);
}

/* Open access edit window */
BOOL OpenAccessEditWindow(struct Node *node, struct Window *parent)
{
 /* Copy node */
 if (CurrentNode=(struct AccessNode *) CopyAccessNode(node)) {
  /* Set tags */
  nametags[0].ti_Data=(ULONG) CurrentNode->an_Node.ln_Name;
  lvtags[0].ti_Data=(ULONG) &CurrentNode->an_Entries;

  /* Create gadgets */
  if (gl=CreateGadgetList(gdata,GADGETS)) {
   /* Open window */
   if (w=OpenWindowTags(NULL,WA_Left,        parent->LeftEdge,
                             WA_Top,         parent->TopEdge+WindowTop,
                             WA_InnerWidth,  ww,
                             WA_InnerHeight, wh,
                             WA_AutoAdjust,  TRUE,
                             WA_Title,       AppStrings[MSG_ACCESSWIN_TITLE],
                             WA_PubScreen,   PublicScreen,
                             WA_Flags,       WFLG_CLOSEGADGET|WFLG_DRAGBAR|
                                             WFLG_DEPTHGADGET|WFLG_RMBTRAP|
                                             WFLG_ACTIVATE,
                             TAG_DONE)) {
    /* Init requester button gadgets */
    InitReqButtonGadget(gdata[GAD_NAME_BUT].gadget);

    /* Add gadgets to window */
    AddGList(w,gl,(UWORD) -1,(UWORD) -1,NULL);
    RefreshGList(gl,w,NULL,(UWORD) -1);
    GT_RefreshWindow(w,NULL);

    /* Activate name string gadget */
    ActivateNameGadget();

    /* Set local variables */
    w->UserPort=IDCMPPort;
    w->UserData=(BYTE *) HandleAccessEditWindowIDCMP;
    ModifyIDCMP(w,WINDOW_IDCMP);
    CurrentWindow=w;
    ReqOpen=FALSE;
    CurrentEntry=NULL;
    CurrentTop=0;
    CurrentOrd=-1;

    /* All OK. */
    return(TRUE);
   }
   FreeGadgets(gl);
  }
  FreeAccessNode((struct Node *) CurrentNode);
 }
 /* Call failed */
 return(FALSE);
}

/* Close access edit window */
static void CloseAccessEditWindow(void)
{
 /* Free resources */
 RemoveGList(w,gl,(UWORD) -1);
 CloseWindowSafely(w);
 FreeGadgets(gl);
}

/* Detach list */
static void DetachEntryList(void)
{
 GT_SetGadgetAttrs(gdata[GAD_ENTRIES].gadget,w,NULL,GTLV_Labels,-1,
                                                    TAG_DONE);
}

/* Attach list */
static void AttachEntryList(void)
{
 GT_SetGadgetAttrs(gdata[GAD_ENTRIES].gadget,w,NULL,GTLV_Labels,
                                                     &CurrentNode->an_Entries,
                                                    GTLV_Top,      CurrentTop,
                                                    GTLV_Selected, CurrentOrd,
                                                    TAG_DONE);
}

/* Name gadget function */
static void NameGadgetFunc(void)
{
 /* Open library */
 if (EnvoyBase=OpenLibrary("envoy.library",37)) {
  char *buffer;

  /* Allocate memory for the host name buffer */
  if (buffer=AllocMem(SGBUFLEN,MEMF_PUBLIC)) {

   /* Open requester */
   if (HostRequest(HREQ_Buffer,   buffer,
                   HREQ_BuffSize, SGBUFLEN,
                   HREQ_Title,    AppStrings[MSG_HOSTREQ_TITLE],
                   TAG_DONE))
    /* User selected a name, put name into name string gadget */
    GT_SetGadgetAttrs(gdata[GAD_NAME_STR].gadget,w,NULL,GTST_String,buffer,
                                                        TAG_DONE);

   /* Free memory */
   FreeMem(buffer,SGBUFLEN);
  }

  /* Close library */
  CloseLibrary(EnvoyBase);
 }
}

/* Add gadget function */
static void AddGadgetFunc(void)
{
 if (!ReqOpen) {
  /* Open list requester */
  if (OpenListRequester(TMOBJTYPE_EXEC,w)) {
   /* Disable window */
   DisableWindow(w,&DummyReq);

   /* Detach entry list */
   DetachEntryList();

   /* Set update function */
   UpdateWindow=UpdateAccessEditWindow;
   ReqOpen=TRUE;
  }
 }
}

static struct Node *OKGadgetFunc(void)
{
 struct Node *rc;
 char *s;

 /* Free old string */
 if (s=CurrentNode->an_Node.ln_Name) free(s);
 CurrentNode->an_Node.ln_Name=NULL;

 /* Duplicate new string */
 if ((s=CurrentNode->an_Node.ln_Name=
       DuplicateBuffer(gdata[GAD_NAME_STR].gadget)) != (char *) -1) {
  ULONG len=strlen(s)-1;

  /* Strip trailing ':' */
  if ((len>=0) && (s[len]==':')) s[len]='\0';

  rc=(struct Node *) CurrentNode;
 } else {
  /* Couldn't copy string */
  rc=(struct Node *) -1;
  FreeAccessNode((struct Node *) CurrentNode);
 }
 return(rc);
}

/* Handle access edit window IDCMP events */
void *HandleAccessEditWindowIDCMP(struct IntuiMessage *msg)
{
 struct Node *NewNode=NULL;

 /* Which IDCMP class? */
 switch (msg->Class) {
  case IDCMP_CLOSEWINDOW:   NewNode=(struct Node *) -1;
                            FreeAccessNode((struct Node *) CurrentNode);
                            break;
  case IDCMP_REFRESHWINDOW: GT_BeginRefresh(w);
                            GT_EndRefresh(w,TRUE);
                            break;
  case IDCMP_GADGETUP:
   switch (((struct Gadget *) msg->IAddress)->GadgetID) {
    case GAD_NAME_BUT: NameGadgetFunc();
                       break;
    case GAD_ENTRIES:  {
                        ULONG i;

                        /* Find node */
                        CurrentTop=(msg->Code>ListViewRows-4) ?
                         msg->Code-ListViewRows+4 : 0;
                        CurrentOrd=msg->Code;
                        CurrentEntry=GetHead(&CurrentNode->an_Entries);
                        for (i=0; i<CurrentOrd; i++)
                         CurrentEntry=GetSucc(CurrentEntry);

                        /* Activate remove gadget */
                        DisableGadget(gdata[GAD_REMOVE].gadget,w,FALSE);
                       }
                       break;
    case GAD_ADD:      AddGadgetFunc();
                       break;
    case GAD_REMOVE:   if (CurrentEntry) {
                        char *s;

                        /* Detach entry list */
                        DetachEntryList();

                        /* Disable remove gadget */
                        DisableGadget(gdata[GAD_REMOVE].gadget,w,TRUE);

                        /* Remove node */
                        Remove(CurrentEntry);

                        /* Free node */
                        if (s=CurrentEntry->ln_Name) free(s);
                        FreeMem(CurrentEntry,sizeof(struct Node));

                        /* Reset pointers */
                        CurrentEntry=NULL;
                        if (CurrentTop) CurrentTop--;
                        CurrentOrd=-1;

                        /* Attach entry list */
                        AttachEntryList();
                       }
                       break;
    case GAD_OK:       NewNode=OKGadgetFunc();
                       break;
    case GAD_CANCEL:   NewNode=(struct Node *) -1;
                       FreeAccessNode((struct Node *) CurrentNode);
                       break;
   }
   break;
  case IDCMP_VANILLAKEY:
   switch (MatchVanillaKey(msg->Code,KeyArray)) {
    case KEY_NAME:   NameGadgetFunc();
                     break;
    case KEY_ADD:    AddGadgetFunc();
                     break;
    case KEY_OK:     NewNode=OKGadgetFunc();
                     break;
    case KEY_CANCEL: NewNode=(struct Node *) -1;
                     FreeAccessNode((struct Node *) CurrentNode);
                     break;
   }
   break;
 }

 /* Close window? */
 if (NewNode) {
  /* Yes. But first reply message!!! */
  GT_ReplyIMsg(msg);
  CloseAccessEditWindow();
 }

 return(NewNode);
}

/* Update dock edit window */
void UpdateAccessEditWindow(void *data)
{
 /* Got data? */
 if (data != LREQRET_CANCEL) {
  char *new;

  /* Selected something? */
  if (new=(data == LREQRET_NOSELECT) ? NULL : ((struct Node *) data)
       ->ln_Name) {
   /* Yes, create new node */
   struct Node *aen;

   /* Create dummy tool */
   if (aen=AllocMem(sizeof(struct Node),MEMF_PUBLIC|MEMF_CLEAR))

    /* Copy name string */
    if (aen->ln_Name=strdup(new)) {

     /* Insert after selected node? */
     if (CurrentEntry) {
      /* Yes */
      Insert(&CurrentNode->an_Entries,aen,CurrentEntry);
      CurrentOrd++;
      CurrentTop=(CurrentOrd>ListViewRows-4) ? CurrentOrd-ListViewRows+4 : 0;
     } else {
      /* No */
      struct Node *tmpnode;
      ULONG i;

      /* Add node to the end of list */
      AddTail(&CurrentNode->an_Entries,aen);

      /* Search ordinal number */
      tmpnode=GetHead(&CurrentNode->an_Entries);
      for (i=0; tmpnode; i++) tmpnode=GetSucc(tmpnode);
      CurrentOrd=--i;
      CurrentTop=(i>ListViewRows-4) ? i-ListViewRows+4 : 0;
     }
     CurrentEntry=aen;

     /* Activate remove gadget */
     DisableGadget(gdata[GAD_REMOVE].gadget,w,FALSE);
    } else
     /* Error */
     FreeMem(aen,sizeof(struct Node));
  }
 }

 /* Attach entry list */
 AttachEntryList();

 /* Enable window */
 EnableWindow(w,&DummyReq,WINDOW_IDCMP);

 /* Restore update function pointer */
 UpdateWindow=UpdateMainWindow;
 CurrentWindow=w;
 ReqOpen=FALSE;
}

/* Read TMAC IFF chunk into Access node */
struct Node *ReadAccessNode(UBYTE *buf)
{
 struct AccessNode *an;

 /* Allocate memory for node */
 if (an=AllocMem(sizeof(struct AccessNode),MEMF_PUBLIC|MEMF_CLEAR)) {
  struct AccessPrefsObject *apo=(struct AccessPrefsObject *) buf;
  ULONG sbits=apo->apo_StringBits;
  UBYTE *ptr=(UBYTE *) &apo[1];

  if (!(sbits & DOPO_NAME) || (an->an_Node.ln_Name=GetConfigStr(&ptr))) {
   LONG entries=0;
   UBYTE enflags;

   /* Init list */
   NewList(&an->an_Entries);

   /* Get tools */
   while ((enflags=*ptr++) & AOPOE_CONTINUE) {
    struct Node *aen;

    if (aen=AllocMem(sizeof(struct Node),MEMF_PUBLIC|MEMF_CLEAR)) {
     /* Add tool to list */
     AddTail(&an->an_Entries,aen);

     if (!(enflags & AOPOE_EXEC) || (aen->ln_Name=GetConfigStr(&ptr)))
      /* All OK. */
      entries++;
     else {
      /* Error */
      entries=-1;
      break;
     }
    } else {
     /* No memory. */
     entries=-1;
     break;
    }
   }

   /* Error? All OK. */
   if (entries!=-1) return(an);
  }

  /* Call failed */
  FreeAccessNode((struct Node *) an);
 }
 return(NULL);
}

/* Write Access node to TMAC IFF chunk */
BOOL WriteAccessNode(struct IFFHandle *iff, UBYTE *buf, struct Node *node)
{
 struct AccessNode *an=(struct AccessNode *) node;
 struct AccessPrefsObject *apo=(struct AccessPrefsObject *) buf;
 ULONG sbits=0;
 UBYTE *ptr=(UBYTE *) &apo[1];

 /* Copy strings */
 if (PutConfigStr(an->an_Node.ln_Name,&ptr)) sbits|=AOPO_NAME;

 /* set string bits */
 apo->apo_StringBits=sbits;

 /* Write entry list */
 {
  struct Node *aen=GetHead(&an->an_Entries);

  while (aen) {
   UBYTE *flptr=ptr++;
   UBYTE aefl=AOPOE_CONTINUE;

   if (PutConfigStr(aen->ln_Name,&ptr)) aefl|=AOPOE_EXEC;

   /* Put flags */
   *flptr=aefl;

   /* Get next node */
   aen=GetSucc(aen);
  }
 }

 /* Append terminator */
 *ptr++=0;

 /* calculate length */
 sbits=ptr-buf;

 DEBUG_PRINTF("chunk size %ld\n",sbits);

 /* Open chunk */
 if (PushChunk(iff,0,ID_TMAC,sbits)) return(FALSE);

 /* Write chunk */
 if (WriteChunkBytes(iff,buf,sbits)!=sbits) return(FALSE);

 /* Close chunk */
 if (PopChunk(iff)) return(FALSE);

 /* All OK. */
 return(TRUE);
}
