/*
 * mainwindow.c  V2.1
 *
 * main window handling
 *
 * (c) 1990-1993 Stefan Becker
 */

#include "ToolManagerConf.h"

/* Edit windows function tables */
OpenWindowFuncPtr OpenEditWindowFunctions[TMOBJTYPES]={
                                                       OpenExecEditWindow,
                                                       OpenImageEditWindow,
                                                       OpenSoundEditWindow,
                                                       OpenMenuEditWindow,
                                                       OpenIconEditWindow,
                                                       OpenDockEditWindow,
                                                       OpenAccessEditWindow
                                                        };

CopyNodeFuncPtr CopyNodeFunctions[TMOBJTYPES]={
                                               CopyExecNode,
                                               CopyImageNode,
                                               CopySoundNode,
                                               CopyMenuNode,
                                               CopyIconNode,
                                               CopyDockNode,
                                               CopyAccessNode
                                              };

/* Window data */
static struct Gadget *gl;             /* Gadget list */
static struct Menu *mn;               /* Menu list */
static struct Window *w;              /* Window */
static void *aw;                      /* AppWindow pointer */
static UWORD ww,wh;                   /* Window size */
                                      /* Current list in ListView gadget */
static struct List *CurrentList=&ObjectLists[TMOBJTYPE_EXEC];
static struct Node *CurrentNode=NULL; /* Current selected node */
static struct Node *OldNode;          /* Current edited node */
static ULONG CurrentListNumber=0;     /* Number of the current list */
static LONG CurrentTop=0;             /* Top node ordinal number */
static LONG CurrentOrd=-1;            /* Current node ordinal number */
static ULONG CurrentSeconds=0;
static ULONG CurrentMicros=0;
static OpenWindowFuncPtr OpenEditWindow=OpenExecEditWindow;
static CopyNodeFuncPtr   CopyNode=CopyExecNode;
static FreeNodeFuncPtr   FreeNode=FreeExecNode;
static struct EasyStruct es={sizeof(struct EasyStruct),0,NULL,NULL,NULL};
static char *deftooltypes[]={"USE",NULL};
static struct Requester DummyReq;
#define WINDOW_IDCMP (IDCMP_CLOSEWINDOW|IDCMP_REFRESHWINDOW|BUTTONIDCMP|\
                      LISTVIEWIDCMP|CYCLEIDCMP|IDCMP_MENUPICK|IDCMP_VANILLAKEY)

/* Gadget data */
#define GAD_TYPE    0
#define GAD_LIST    1
#define GAD_TOP     2
#define GAD_UP      3
#define GAD_DOWN    4
#define GAD_BOTTOM  5
#define GAD_SORT    6
#define GAD_NEW     7
#define GAD_EDIT    8
#define GAD_COPY    9
#define GAD_REMOVE 10
#define GAD_SAVE   11
#define GAD_USE    12
#define GAD_TEST   13
#define GAD_CANCEL 14
#define GADGETS    15
static struct GadgetData gdata[GADGETS];

/* Gadget tags */
static char *cyclelabels[TMOBJTYPES+1];
static struct TagItem cycletags[]={GTCY_Labels, (ULONG) cyclelabels,
                                   GTCY_Active, TMOBJTYPE_EXEC,
                                   TAG_DONE};

static struct TagItem lvtags[]={GTLV_Labels,
                                 (ULONG) &ObjectLists[TMOBJTYPE_EXEC],
                                GTLV_ShowSelected, NULL,
                                TAG_DONE};

/* Menu data */
#define MENU_PROJECT  0
#define MENU_OPEN     1
#define MENU_APPEND   2
#define MENU_SAVEAS   3
#define MENU_ABOUT    5
#define MENU_QUIT     7
#define MENU_EDIT     8
#define MENU_LSAVED   9
#define MENU_RESTORE 10
#define MENU_SETTING 11
#define MENU_CRICONS 12
static struct NewMenu mdata[]={
                               {NM_TITLE,NULL,NULL,0,~0,NULL},
                                {NM_ITEM,NULL,NULL,0,~0,(APTR) MENU_OPEN},
                                {NM_ITEM,NULL,NULL,0,~0,(APTR) MENU_APPEND},
                                {NM_ITEM,NULL,NULL,0,~0,(APTR) MENU_SAVEAS},
                                {NM_ITEM,NM_BARLABEL,NULL,0,~0,NULL},
                                {NM_ITEM,NULL,NULL,0,~0,(APTR) MENU_ABOUT},
                                {NM_ITEM,NM_BARLABEL,NULL,0,~0,NULL},
                                {NM_ITEM,NULL,NULL,0,~0,(APTR) MENU_QUIT},
                               {NM_TITLE,NULL,NULL,0,~0,NULL},
                                {NM_ITEM,NULL,NULL,0,~0,(APTR) MENU_LSAVED},
                                {NM_ITEM,NULL,NULL,0,~0,(APTR) MENU_RESTORE},
                               {NM_TITLE,NULL,NULL,0,~0,NULL},
                                {NM_ITEM,NULL,NULL,0,~1,(APTR) MENU_CRICONS},
                               {NM_END}
                              };

/* Gadget vanilla key data */
#define KEY_TYPE   0
#define KEY_SORT   1
#define KEY_NEW    2
#define KEY_EDIT   3
#define KEY_COPY   4
#define KEY_SAVE   5
#define KEY_USE    6
#define KEY_TEST   7
#define KEY_CANCEL 8
static char KeyArray[KEY_CANCEL+1];

/* Init main window */
void InitMainWindow(UWORD left, UWORD fheight)
{
 ULONG i,tmp,maxw1,maxw2,maxw3;
 struct GadgetData *gd;

 /* Init strings */
 gdata[GAD_TYPE].name  =AppStrings[MSG_MAINWIN_TYPE_GAD];
 gdata[GAD_LIST].name  =AppStrings[MSG_MAINWIN_LIST_GAD];
 gdata[GAD_TOP].name   =AppStrings[MSG_WINDOW_TOP_GAD];
 gdata[GAD_UP].name    =AppStrings[MSG_WINDOW_UP_GAD];
 gdata[GAD_DOWN].name  =AppStrings[MSG_WINDOW_DOWN_GAD];
 gdata[GAD_BOTTOM].name=AppStrings[MSG_WINDOW_BOTTOM_GAD];
 gdata[GAD_SORT].name  =AppStrings[MSG_MAINWIN_SORT_GAD];
 gdata[GAD_NEW].name   =AppStrings[MSG_MAINWIN_NEW_GAD];
 gdata[GAD_EDIT].name  =AppStrings[MSG_MAINWIN_EDIT_GAD];
 gdata[GAD_COPY].name  =AppStrings[MSG_MAINWIN_COPY_GAD];
 gdata[GAD_REMOVE].name=AppStrings[MSG_WINDOW_REMOVE_GAD];
 gdata[GAD_SAVE].name  =AppStrings[MSG_MAINWIN_SAVE_GAD];
 gdata[GAD_USE].name   =AppStrings[MSG_MAINWIN_USE_GAD];
 gdata[GAD_TEST].name  =AppStrings[MSG_MAINWIN_TEST_GAD];
 gdata[GAD_CANCEL].name=AppStrings[MSG_WINDOW_CANCEL_GAD];
 cyclelabels[TMOBJTYPE_EXEC]  =AppStrings[MSG_MAINWIN_TYPE_EXEC_CYCLE_LABEL];
 cyclelabels[TMOBJTYPE_IMAGE] =AppStrings[MSG_MAINWIN_TYPE_IMAGE_CYCLE_LABEL];
 cyclelabels[TMOBJTYPE_SOUND] =AppStrings[MSG_MAINWIN_TYPE_SOUND_CYCLE_LABEL];
 cyclelabels[TMOBJTYPE_MENU]  =AppStrings[MSG_MAINWIN_TYPE_MENU_CYCLE_LABEL];
 cyclelabels[TMOBJTYPE_ICON]  =AppStrings[MSG_MAINWIN_TYPE_ICON_CYCLE_LABEL];
 cyclelabels[TMOBJTYPE_DOCK]  =AppStrings[MSG_MAINWIN_TYPE_DOCK_CYCLE_LABEL];
 cyclelabels[TMOBJTYPE_ACCESS]=AppStrings[MSG_MAINWIN_TYPE_ACCESS_CYCLE_LABEL];
 cyclelabels[TMOBJTYPES]      =NULL;

 mdata[MENU_PROJECT].nm_Label  =AppStrings[MSG_MAINWIN_PROJECT_MENU_LABEL];
 mdata[MENU_OPEN].nm_Label     =AppStrings[MSG_MAINWIN_OPEN_MENU_LABEL];
 mdata[MENU_OPEN].nm_CommKey   =AppStrings[MSG_MAINWIN_OPEN_MENU_SHORTCUT];
 mdata[MENU_APPEND].nm_Label   =AppStrings[MSG_MAINWIN_APPEND_MENU_LABEL];
 mdata[MENU_SAVEAS].nm_Label   =AppStrings[MSG_MAINWIN_SAVEAS_MENU_LABEL];
 mdata[MENU_SAVEAS].nm_CommKey =AppStrings[MSG_MAINWIN_SAVEAS_MENU_SHORTCUT];
 mdata[MENU_ABOUT].nm_Label    =AppStrings[MSG_MAINWIN_ABOUT_MENU_LABEL];
 mdata[MENU_QUIT].nm_Label     =AppStrings[MSG_MAINWIN_QUIT_MENU_LABEL];
 mdata[MENU_QUIT].nm_CommKey   =AppStrings[MSG_MAINWIN_QUIT_MENU_SHORTCUT];
 mdata[MENU_EDIT].nm_Label     =AppStrings[MSG_MAINWIN_EDIT_MENU_LABEL];
 mdata[MENU_LSAVED].nm_Label   =AppStrings[MSG_MAINWIN_LASTSAVED_MENU_LABEL];
 mdata[MENU_LSAVED].nm_CommKey =AppStrings[MSG_MAINWIN_LASTSAVED_MENU_SHORTCUT];
 mdata[MENU_RESTORE].nm_Label  =AppStrings[MSG_MAINWIN_RESTORE_MENU_LABEL];
 mdata[MENU_RESTORE].nm_CommKey=AppStrings[MSG_MAINWIN_RESTORE_MENU_SHORTCUT];
 mdata[MENU_SETTING].nm_Label  =AppStrings[MSG_MAINWIN_SETTINGS_MENU_LABEL];
 mdata[MENU_CRICONS].nm_Label  =AppStrings[MSG_MAINWIN_CREATEICONS_MENU_LABEL];
 mdata[MENU_CRICONS].nm_CommKey=
                             AppStrings[MSG_MAINWIN_CREATEICONS_MENU_SHORTCUT];
 mdata[MENU_CRICONS].nm_Flags=CHECKIT|MENUTOGGLE| (CreateIcons ? CHECKED : 0);

 /* Calculate maximum width for cycle gadget */
 {
  char **s;
  maxw1=0;
  for (s=cyclelabels; *s; s++)
   if ((tmp=TextLength(&TmpRastPort,*s,strlen(*s))) > maxw1)
    maxw1=tmp;
  maxw1+=4*INTERWIDTH;
 }

 /* Calculate size for type gadget text */
 gd=gdata;
 gd->left=TextLength(&TmpRastPort,gd->name,strlen(gd->name))+INTERWIDTH;
 ww=gd->left+maxw1+2*INTERWIDTH;

 /* Calculate width for listview gadget */
 gd++;
 gd->width=2*TextLength(&TmpRastPort,gd->name,strlen(gd->name));
 if ((tmp=ListViewColumns*ScreenFont->tf_XSize) > gd->width) gd->width=tmp;

 /* Calculate maximum width for move gadgets */
 maxw2=0;
 for (gd++, i=GAD_TOP; i<=GAD_SORT; i++, gd++)
  if ((tmp=TextLength(&TmpRastPort,gd->name,strlen(gd->name))) > maxw2)
   maxw2=tmp;
 maxw2+=2*INTERWIDTH;
 if ((tmp=gdata[GAD_LIST].width+maxw2+2*INTERWIDTH) > ww) ww=tmp;

 /* Calculate maximum width for manipulation gadgets */
 maxw3=0;
 for (; i<=GAD_CANCEL; i++, gd++)
  if ((tmp=TextLength(&TmpRastPort,gd->name,strlen(gd->name))) > maxw3)
   maxw3=tmp;
 maxw3+=2*INTERWIDTH;
 if ((tmp=4*maxw3+4*INTERWIDTH) > ww) ww=tmp;

 /* Calculate window sizes */
 wh=(ListViewRows+3)*fheight+7*INTERHEIGHT;

 /* Type gadget */
 gd=&gdata[GAD_TYPE];
 maxw1=ww-gd->left-INTERWIDTH;
 gd->type=CYCLE_KIND;
 gd->flags=PLACETEXT_LEFT;
 gd->tags=cycletags;
 gd->left+=left;
 gd->top=WindowTop+INTERHEIGHT;
 gd->width=maxw1;
 gd->height=fheight;

 /* Object list gadget */
 gd++;
 gd->type=LISTVIEW_KIND;
 gd->flags=PLACETEXT_ABOVE;
 gd->tags=lvtags;
 gd->left=left;
 gd->top=WindowTop+2*fheight+3*INTERHEIGHT;
 gd->width=ww-2*INTERWIDTH-maxw2;
 gd->height=(ListViewRows-1)*fheight;

 /* Move gadgets */
 maxw1=ww-maxw2-INTERWIDTH+left;
 tmp=gd->top;
 gd++;
 for (i=GAD_TOP; i<=GAD_SORT; i++, gd++, tmp+=fheight+INTERHEIGHT) {
  gd->type=BUTTON_KIND;
  gd->flags=PLACETEXT_IN;
  gd->tags=DisabledTags;
  gd->left=maxw1;
  gd->top=tmp;
  gd->width=maxw2;
  gd->height=fheight;
 }
 gdata[GAD_SORT].tags=NULL;

 /* Manipulation gadgets */
 maxw1=left;
 maxw2=(ww-INTERWIDTH-maxw3)/3;
 tmp=WindowTop+(ListViewRows+1)*fheight+4*INTERHEIGHT;
 for (i=GAD_NEW; i<=GAD_REMOVE; i++, gd++, maxw1+=maxw2) {
  gd->type=BUTTON_KIND;
  gd->flags=PLACETEXT_IN;
  gd->tags=DisabledTags;
  gd->left=maxw1;
  gd->top=tmp;
  gd->width=maxw3;
  gd->height=fheight;
 }
 gdata[GAD_NEW].tags=NULL;
 gdata[GAD_REMOVE].left=ww-maxw3-INTERWIDTH+left;

 /* Configuration gadgets */
 maxw1=left;
 tmp+=fheight+2*INTERHEIGHT;
 for (; i<=GAD_CANCEL; i++, gd++, maxw1+=maxw2) {
  gd->type=BUTTON_KIND;
  gd->flags=PLACETEXT_IN;
  gd->left=maxw1;
  gd->top=tmp;
  gd->width=maxw3;
  gd->height=fheight;
 }
 gdata[GAD_CANCEL].left=ww-maxw3-INTERWIDTH+left;

 /* Init vanilla key array */
 KeyArray[KEY_TYPE]  =FindVanillaKey(gdata[GAD_TYPE].name);
 KeyArray[KEY_SORT]  =FindVanillaKey(gdata[GAD_SORT].name);
 KeyArray[KEY_NEW]   =FindVanillaKey(gdata[GAD_NEW].name);
 KeyArray[KEY_EDIT]  =FindVanillaKey(gdata[GAD_EDIT].name);
 KeyArray[KEY_COPY]  =FindVanillaKey(gdata[GAD_COPY].name);
 KeyArray[KEY_SAVE]  =FindVanillaKey(gdata[GAD_SAVE].name);
 KeyArray[KEY_USE]   =FindVanillaKey(gdata[GAD_USE].name);
 KeyArray[KEY_TEST]  =FindVanillaKey(gdata[GAD_TEST].name);
 KeyArray[KEY_CANCEL]=FindVanillaKey(gdata[GAD_CANCEL].name);

 /* Init dummy requester structure */
 InitRequester(&DummyReq);
}

/* Open main window */
ULONG OpenMainWindow(UWORD wx, UWORD wy)
{
 /* Create gadgets */
 if (gl=CreateGadgetList(gdata,GADGETS)) {
  /* Create menus */
  if (mn=CreateMenus(mdata,GTMN_FullMenu, TRUE,
                           TAG_DONE)) {
   /* Layout menus */
   if (LayoutMenus(mn,ScreenVI,GTMN_NewLookMenus, TRUE,
                               TAG_DONE))
    /* Open window */
    if (w=OpenWindowTags(NULL,WA_Left,         wx,
                              WA_Top,          wy,
                              WA_InnerWidth,   ww,
                              WA_InnerHeight,  wh,
                              WA_AutoAdjust,   TRUE,
                              WA_Title,        AppStrings[MSG_MAINWIN_TITLE],
                              WA_PubScreen,    PublicScreen,
                              WA_Flags,        WFLG_CLOSEGADGET|WFLG_DRAGBAR|
                                               WFLG_DEPTHGADGET|WFLG_ACTIVATE,
                              WA_IDCMP,        WINDOW_IDCMP,
                              WA_NewLookMenus, TRUE,
                              TAG_DONE)) {
     /* Set menu strip */
     if (SetMenuStrip(w,mn)) {
      /* Release public screen */
      UnlockPubScreen(NULL,PublicScreen);

      /* Add as AppWindow */
      aw=NULL;
      if (WorkbenchBase && WBScreen)
       /* This call fails if the Workbench is NOT running! */
       aw=AddAppWindowA(0,0,w,AppMsgPort,NULL);

      /* Add gadgets to window */
      AddGList(w,gl,(UWORD) -1,(UWORD) -1,NULL);
      RefreshGList(gl,w,NULL,(UWORD) -1);
      GT_RefreshWindow(w,NULL);

      /* Set local variables */
      IDCMPPort=w->UserPort;
      w->UserData=(BYTE *) HandleMainWindowIDCMP;
      CurrentWindow=w;
      if (aw) HandleAppMsg=HandleMainWindowAppMsg;

      /* All OK. (Return IDCMP signal mask) */
      return(1L << IDCMPPort->mp_SigBit);
     }
     CloseWindow(w);
   }
   FreeMenus(mn);
  }
  FreeGadgets(gl);
 }
 /* Call failed */
 return(0);
}

/* Close main window */
void CloseMainWindow(void)
{
 /* Free resources */
 RemoveGList(w,gl,(UWORD) -1);
 if (aw) {
  HandleAppMsg=NULL;
  RemoveAppWindow(aw);
 }
 ClearMenuStrip(w);
 CloseWindow(w);
 FreeMenus(mn);
 FreeGadgets(gl);
}

/* Detach list */
static void DetachObjectList(void)
{
 GT_SetGadgetAttrs(gdata[GAD_LIST].gadget,w,NULL,GTLV_Labels,-1,
                                                 TAG_DONE);
}

/* Attach list */
static void AttachObjectList(void)
{
 GT_SetGadgetAttrs(gdata[GAD_LIST].gadget,w,NULL,GTLV_Labels,   CurrentList,
                                                 GTLV_Top,      CurrentTop,
                                                 GTLV_Selected, CurrentOrd,
                                                 TAG_DONE);
}

/* Disable object gadgets */
static void DisableObjectGadgets(BOOL disable)
{
 DisableGadget(gdata[GAD_TOP].gadget,w,disable);
 DisableGadget(gdata[GAD_UP].gadget,w,disable);
 DisableGadget(gdata[GAD_DOWN].gadget,w,disable);
 DisableGadget(gdata[GAD_BOTTOM].gadget,w,disable);
 DisableGadget(gdata[GAD_EDIT].gadget,w,disable);
 DisableGadget(gdata[GAD_COPY].gadget,w,disable);
 DisableGadget(gdata[GAD_REMOVE].gadget,w,disable);
}

/* Handle application messages */
void HandleMainWindowAppMsg(struct AppMessage *msg)
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

   /* Open selection window */
   switch (dobj->do_Type) {
    case WBTOOL:
    case WBPROJECT: if (!UpdateWindow)
                     if (OpenSelectWindow(wa,w)) {
                      /* Disable window */
                      DisableWindow(w,&DummyReq);

                      /* Detach object list */
                      DetachObjectList();

                      /* Deactivate object gadgets */
                      DisableObjectGadgets(TRUE);

                      /* Set update function */
                      UpdateWindow=UpdateAppMainWindow;
                     } else
                      DisplayBeep(NULL);
                    break;
    default:        DisplayBeep(NULL);
                    break;
   }

   /* Free icon */
   FreeDiskObject(dobj);
  } else
   DisplayBeep(NULL);

  CurrentDir(olddir);
 }
}

/* Display write error requester */
static void ConfigWriteError(char *s)
{
 es.es_TextFormat=AppStrings[MSG_MAINWIN_WRITE_ERROR];
 es.es_GadgetFormat=AppStrings[MSG_FILEREQ_CANCEL_GAD];

 EasyRequest(w,&es,NULL,s);
}

/* Open or append config file */
static void LoadConfigFile(BOOL delobjs)
{
 char *file;

 FileReqParms.frp_Window=w;
 FileReqParms.frp_Title=AppStrings[MSG_FILEREQ_TITLE_FILE];
 FileReqParms.frp_OKText=AppStrings[MSG_FILEREQ_OK_GAD];
 FileReqParms.frp_Flags1=FRF_DOPATTERNS;
 FileReqParms.frp_Flags2=FRF_REJECTICONS;
 FileReqParms.frp_OldFile=PrefsFileName;

 /* Get file name */
 if (file=OpenFileRequester(&DummyReq)) {
  /* Detach object list */
  DetachObjectList();

  /* Deactivate object gadgets */
  DisableObjectGadgets(TRUE);

  /* Free all preferences objects */
  if (delobjs) FreeAllObjects();

  /* Set wait pointer */
  DisableWindow(w,&DummyReq);

  /* Read new config file */
  if (!ReadConfigFile(file)) DisplayBeep(NULL);

  /* Remove wait pointer */
  EnableWindow(w,&DummyReq,WINDOW_IDCMP);

  /* Set new pointers */
  CurrentList=&ObjectLists[CurrentListNumber];
  CurrentNode=NULL;
  CurrentTop=0;
  CurrentOrd=-1;

  /* Free file name */
  free(file);

  /* Attach object list */
  AttachObjectList();
 }
}

/* Type gadget function */
static void TypeGadgetFunc(ULONG num)
{
 /* Set new Exec list in ListView gadget, detach list */
 DetachObjectList();

 /* Set new pointers */
 CurrentList=&ObjectLists[num];
 CurrentListNumber=num;
 CurrentNode=NULL;
 CurrentTop=0;
 CurrentOrd=-1;

 /* Set new function pointers */
 OpenEditWindow=OpenEditWindowFunctions[num];
 CopyNode=CopyNodeFunctions[num];
 FreeNode=FreeNodeFunctions[num];

 /* Disable object gadgets, attach list */
 DisableObjectGadgets(TRUE);
 AttachObjectList();
}

/* Sort gadget function */
static void SortGadgetFunc(void)
{
 BOOL notfinished=TRUE;

 /* Detach object list */
 DetachObjectList();

 /* Sort list (quick & dirty bubble sort) */
 while (notfinished) {
  struct Node *first;

  /* Reset not finished flag */
  notfinished=FALSE;

  /* Get first node */
  if (first=GetHead(CurrentList)) {
   struct Node *second;

   /* One bubble sort round */
   while (second=GetSucc(first))
    /* Compare */
    if (stricmp(first->ln_Name,second->ln_Name)>0) {
     /* Swap */
     Remove(first);
     Insert(CurrentList,first,second);
     notfinished=TRUE;
    } else
     /* Next */
     first=second;
  }
 }

 /* Reset pointers */
 CurrentNode=NULL;
 CurrentOrd=-1;
 CurrentTop=0;

 /* Deactivate object gadgets */
 DisableObjectGadgets(TRUE);

 /* Attach object list */
 AttachObjectList();
}

/* New & Edit gadget function */
static void EditGadgetFunc(struct Node *editnode)
{
 if (!UpdateWindow) {
  /* Save old node */
  OldNode=editnode;

  /* Open edit window */
  if ((*OpenEditWindow)(editnode,w)) {
   /* Disable window */
   DisableWindow(w,&DummyReq);

   /* Set update function */
   UpdateWindow=UpdateMainWindow;
  } else
   DisplayBeep(NULL);
 }
}

/* Copy gadget function */
static void CopyGadgetFunc(void)
{
 if (CurrentNode) {
  struct Node *newnode;

  /* Detach object list */
  DetachObjectList();

  /* Copy node */
  if (newnode=(*CopyNode)(CurrentNode)) {
   /* Insert new node */
   Insert(CurrentList,newnode,CurrentNode);

   /* Reset pointers */
   CurrentNode=newnode;
   CurrentOrd++;
   CurrentTop=(CurrentOrd>ListViewRows-4) ? CurrentOrd-ListViewRows+4 : 0;
  }

  /* Attach object list */
  AttachObjectList();
 }
}

/* Save gadget function */
static void *SaveGadgetFunc(void)
{
 void *rc=NULL;

 /* Set wait pointer */
 DisableWindow(w,&DummyReq);

 /* Save config file */
 if (WriteConfigFile(SavePrefsFileName))
  if (CopyFile(SavePrefsFileName,PrefsFileName))
   rc=(void *) 1;
  else
   ConfigWriteError(PrefsFileName);
 else
  ConfigWriteError(SavePrefsFileName);

 /* Remove wait pointer */
 EnableWindow(w,&DummyReq,WINDOW_IDCMP);
 return(rc);
}

/* Use gadget function */
static void *UseGadgetFunc(void)
{
 void *rc=NULL;

 /* Set wait pointer */
 DisableWindow(w,&DummyReq);

 /* Save config file */
 if (WriteConfigFile(PrefsFileName))
  rc=(void *) 1;
 else
  ConfigWriteError(PrefsFileName);

 /* Remove wait pointer */
 EnableWindow(w,&DummyReq,WINDOW_IDCMP);
 return(rc);
}

/* Test gadget function */
static void TestGadgetFunc(void)
{
 /* Set wait pointer */
 DisableWindow(w,&DummyReq);

 /* Save config file */
 if (!WriteConfigFile(PrefsFileName))
  ConfigWriteError(PrefsFileName);

 /* Remove wait pointer */
 EnableWindow(w,&DummyReq,WINDOW_IDCMP);
}

/* Handle main window IDCMP events */
void *HandleMainWindowIDCMP(struct IntuiMessage *msg)
{
 void *closewindow=NULL;

 /* Which IDCMP class? */
 switch (msg->Class) {
  case IDCMP_CLOSEWINDOW:   if (!UpdateWindow) closewindow=(void *) 1;
                            break;
  case IDCMP_REFRESHWINDOW: GT_BeginRefresh(w);
                            GT_EndRefresh(w,TRUE);
                            break;
  case IDCMP_GADGETUP:
   switch (((struct Gadget *) msg->IAddress)->GadgetID) {
    case GAD_TYPE:   TypeGadgetFunc(msg->Code);
                     break;
    case GAD_LIST:   {
                      ULONG i;
                      LONG OldOrd;

                      /* Find node */
                      OldOrd=CurrentOrd;
                      CurrentOrd=msg->Code;
                      CurrentTop=(CurrentOrd>ListViewRows-4) ?
                                  CurrentOrd-ListViewRows+4 : 0;
                      CurrentNode=GetHead(CurrentList);
                      for (i=0; i<CurrentOrd; i++)
                       CurrentNode=GetSucc(CurrentNode);

                      /* Double click? */
                      if (DoubleClick(CurrentSeconds,CurrentMicros,
                                      msg->Seconds,msg->Micros) &&
                          (CurrentOrd == OldOrd) && !UpdateWindow &&
                          CurrentNode) {
                       /* Save pointer to node */
                       OldNode=CurrentNode;

                       /* Open edit window */
                       if ((*OpenEditWindow)(CurrentNode,w)) {
                        /* Disable window */
                        DisableWindow(w,&DummyReq);

                        /* Set update function */
                        UpdateWindow=UpdateMainWindow;
                       } else
                        DisplayBeep(NULL);
                      }

                      /* Activate object gadgets */
                      DisableObjectGadgets(FALSE);

                      /* Save current time */
                      CurrentSeconds=msg->Seconds;
                      CurrentMicros=msg->Micros;
                     }
                     break;
    case GAD_TOP:    if (CurrentNode) {
                      /* Detach object list */
                      DetachObjectList();

                      /* Move node to top of list */
                      Remove(CurrentNode);
                      AddHead(CurrentList,CurrentNode);
                      CurrentTop=0;
                      CurrentOrd=0;

                      /* Attach object list */
                      AttachObjectList();
                     }
                     break;
    case GAD_UP:     {
                      struct Node *pred;

                      /* Node valid and has a predecessor? */
                      if (CurrentNode && (pred=GetPred(CurrentNode))) {
                       /* Detach object list */
                       DetachObjectList();

                       /* Move node one position up */
                       pred=GetPred(pred);
                       Remove(CurrentNode);
                       Insert(CurrentList,CurrentNode,pred);
                       --CurrentOrd;
                       CurrentTop=(CurrentOrd>ListViewRows-4) ?
                                   CurrentOrd-ListViewRows+4 : 0;

                       /* Attach object list */
                       AttachObjectList();
                      }
                     }
                     break;
    case GAD_DOWN:   {
                      struct Node *succ;

                      /* Node valid and has a successor? */
                      if (CurrentNode && (succ=GetSucc(CurrentNode))) {
                       /* Detach object list */
                       DetachObjectList();

                       /* Move node one position down */
                       Remove(CurrentNode);
                       Insert(CurrentList,CurrentNode,succ);
                       ++CurrentOrd;
                       CurrentTop=(CurrentOrd>ListViewRows-4) ?
                                   CurrentOrd-ListViewRows+4 : 0;

                       /* Attach object list */
                       AttachObjectList();
                      }
                     }
                     break;
    case GAD_BOTTOM: if (CurrentNode) {
                      ULONG i;
                      struct Node *tmpnode;

                      /* Detach object list */
                      DetachObjectList();

                      /* Move tool to bottom of list */
                      Remove(CurrentNode);
                      AddTail(CurrentList,CurrentNode);

                      /* Search ordinal number */
                      tmpnode=GetHead(CurrentList);
                      for (i=0; tmpnode; i++) tmpnode=GetSucc(tmpnode);
                      CurrentOrd=--i;
                      CurrentTop=(i>ListViewRows-4) ? i-ListViewRows+4 : 0;

                      /* Attach object list */
                      AttachObjectList();
                     }
                     break;
    case GAD_SORT:   SortGadgetFunc();
                     break;
    case GAD_NEW:    EditGadgetFunc(NULL);
                     break;
    case GAD_EDIT:   EditGadgetFunc(CurrentNode);
                     break;
    case GAD_COPY:   CopyGadgetFunc();
                     break;
    case GAD_REMOVE: /* Remove current node */
                     if (CurrentNode) {
                      /* Detach object list */
                      DetachObjectList();

                      /* Deactivate object gadgets */
                      DisableObjectGadgets(TRUE);

                      /* Remove node from list */
                      Remove(CurrentNode);

                      /* Free node */
                      (*FreeNode)(CurrentNode);

                      /* Reset pointers */
                      CurrentNode=NULL;
                      CurrentTop=(CurrentOrd>ListViewRows-4) ?
                                  CurrentOrd-ListViewRows+4 : 0;
                      CurrentOrd=-1;

                      /* Attach object list */
                      AttachObjectList();
                     }
                     break;
    case GAD_SAVE:   closewindow=SaveGadgetFunc();
                     break;
    case GAD_USE:    closewindow=UseGadgetFunc();
                     break;
    case GAD_TEST:   TestGadgetFunc();
                     break;
    case GAD_CANCEL: if (!UpdateWindow) closewindow=(void *) 1;
                     break;
   }
   break;
  case IDCMP_VANILLAKEY:
   switch (MatchVanillaKey(msg->Code,KeyArray)) {
    case KEY_TYPE:   {
                      /* Get next cycle gadget code */
                      ULONG type;

                      /* Forward or backward cycle? */
                      if (islower(msg->Code))
                       type=(CurrentListNumber+1) % TMOBJTYPES;
                      else
                       type=(CurrentListNumber>0) ? CurrentListNumber-1 :
                                                    TMOBJTYPE_ACCESS;

                      /* Set cycle gadget */
                      GT_SetGadgetAttrs(gdata[GAD_TYPE].gadget,w,NULL,
                                        GTCY_Active, type,
                                        TAG_DONE);

                      /* Update data */
                      TypeGadgetFunc(type);
                     }
                     break;
    case KEY_SORT:   SortGadgetFunc();
                     break;
    case KEY_NEW:    EditGadgetFunc(NULL);
                     break;
    case KEY_EDIT:   if (CurrentNode) EditGadgetFunc(CurrentNode);
                     break;
    case KEY_COPY:   CopyGadgetFunc();
                     break;
    case KEY_SAVE:   closewindow=SaveGadgetFunc();
                     break;
    case KEY_USE:    closewindow=UseGadgetFunc();
                     break;
    case KEY_TEST:   TestGadgetFunc();
                     break;
    case KEY_CANCEL: if (!UpdateWindow) closewindow=(void *) 1;
                     break;
   }
   break;
  case IDCMP_MENUPICK: {
    USHORT menunum=msg->Code;

    /* Scan all menu events */
    while (menunum!=MENUNULL) {
     struct MenuItem *menuitem=ItemAddress(mn,menunum);

     /* Which menu selected? */
     switch(GTMENUITEM_USERDATA(menuitem)) {
      case MENU_OPEN:    LoadConfigFile(TRUE);
                         break;
      case MENU_APPEND:  LoadConfigFile(FALSE);
                         break;
      case MENU_SAVEAS:  {
                          char *file;

                          FileReqParms.frp_Window=w;
                          FileReqParms.frp_Title=
                             AppStrings[MSG_FILEREQ_TITLE_FILE];
                          FileReqParms.frp_OKText=
                             AppStrings[MSG_FILEREQ_SAVE_GAD];
                          FileReqParms.frp_Flags1=FRF_DOSAVEMODE;
                          FileReqParms.frp_Flags2=FRF_REJECTICONS;
                          FileReqParms.frp_OldFile=SavePrefsFileName;

                          /* Get file name */
                          if (file=OpenFileRequester(&DummyReq)) {
                           /* Set wait pointer */
                           DisableWindow(w,&DummyReq);

                           /* Read new config file */
                           if (WriteConfigFile(file)) {
                            /* Create icon for file? */
                            if (CreateIcons) {
                             struct DiskObject *dobj;

                             /* Get project icon */
                             if (dobj=
                                  GetDiskObjectNew(file)) {
                              char *deftool=dobj->do_DefaultTool;
                              char **tooltypes=dobj->do_ToolTypes;
                              UBYTE type=dobj->do_Type;

                              /* Set new values */
                              dobj->do_DefaultTool=ProgramName;
                              dobj->do_ToolTypes=deftooltypes;
                              dobj->do_Type=WBPROJECT;

                              /* Write icon */
                              PutDiskObject(file,dobj);

                              /* Set old values */
                              dobj->do_DefaultTool=deftool;
                              dobj->do_ToolTypes=tooltypes;
                              dobj->do_Type=type;

                              /* Free icon */
                              FreeDiskObject(dobj);
                             }
                            }
                           } else
                            /* error occurred */
                            ConfigWriteError(file);

                           /* Remove wait pointer */
                           EnableWindow(w,&DummyReq,WINDOW_IDCMP);

                           /* Free file name */
                           free(file);
                          }
                         }
                         break;
      case MENU_ABOUT:   es.es_TextFormat="ToolManager " TMVERSION "."
                                          TMREVISION " (" __COMMODORE_DATE__
                                          ")\nFreely distributable\n"
                                          "© " TMCRYEAR "  Stefan Becker";
                         es.es_GadgetFormat=AppStrings[MSG_FILEREQ_CANCEL_GAD];

                         /* Disable window */
                         DisableWindow(w,&DummyReq);

                         /* Display requester */
                         EasyRequest(w,&es,NULL,NULL);

                         /* Enable window */
                         EnableWindow(w,&DummyReq,WINDOW_IDCMP);
                         break;
      case MENU_QUIT:    if (!UpdateWindow) closewindow=(void *) 1;
                         break;
      case MENU_LSAVED:  {
                          /* Detach object list */
                          DetachObjectList();

                          /* Deactivate object gadgets */
                          DisableObjectGadgets(TRUE);

                          /* Free all preferences objects */
                          FreeAllObjects();

                          /* Set wait pointer */
                          DisableWindow(w,&DummyReq);

                          /* Read new config file */
                          if (!ReadConfigFile(SavePrefsFileName))
                           DisplayBeep(NULL);

                          /* Remove wait pointer */
                          EnableWindow(w,&DummyReq,WINDOW_IDCMP);

                          /* Set new pointers */
                          CurrentList=&ObjectLists[CurrentListNumber];
                          CurrentNode=NULL;
                          CurrentTop=0;
                          CurrentOrd=-1;

                          /* Attach object list */
                          AttachObjectList();
                         }
                         break;
      case MENU_RESTORE: {
                          /* Detach object list */
                          DetachObjectList();

                          /* Deactivate object gadgets */
                          DisableObjectGadgets(TRUE);

                          /* Free all preferences objects */
                          FreeAllObjects();

                          /* Set wait pointer */
                          DisableWindow(w,&DummyReq);

                          /* Read new config file */
                          if (!ReadConfigFile(PrefsFileName)) DisplayBeep(NULL);

                          /* Remove wait pointer */
                          EnableWindow(w,&DummyReq,WINDOW_IDCMP);

                          /* Set new pointers */
                          CurrentList=&ObjectLists[CurrentListNumber];
                          CurrentNode=NULL;
                          CurrentTop=0;
                          CurrentOrd=-1;

                          /* Attach object list */
                          AttachObjectList();
                         }
                         break;
      case MENU_CRICONS: CreateIcons=(menuitem->Flags & CHECKED) != 0;
                         break;
     }

     /* Get next menu event number */
     menunum=menuitem->NextSelect;
    }
   }
   break;
 }

 /* Close Window? */
 if (closewindow) GT_ReplyIMsg(msg);

 return(closewindow);
}

/* Update main window (after the select window has closed) */
void UpdateAppMainWindow(void *data)
{
 /* Lists changed? */
 if (data!=(void *) -1) {

  /* Clear pointers */
  CurrentNode=NULL;
  CurrentTop=0;
  CurrentOrd=-1;
 }

 /* Activate Gadgets */
 DisableObjectGadgets(CurrentNode==NULL);

 /* Attach object list */
 AttachObjectList();

 /* Enable window */
 EnableWindow(w,&DummyReq,WINDOW_IDCMP);

 /* Restore update function pointer */
 UpdateWindow=NULL;
 CurrentWindow=w;
}


/* Update main window (after an edit window has closed) */
void UpdateMainWindow(void *data)
{
 /* Detach object list */
 DetachObjectList();

 DEBUG_PRINTF("OldNode: 0x%08lx ",OldNode);
 DEBUG_PRINTF("NewNode: 0x%08lx\n",data);

 /* Node changed? */
 if (data!=(void *) -1) {
  struct Node *NewNode=data;

  /* Make sure that ln_Name is valid */
  if (!NewNode->ln_Name) NewNode->ln_Name=strdup("");

  /* Yes. New or Edit? */
  if (OldNode) {
   /* Edit. Insert new node */
   Insert(CurrentList,NewNode,OldNode);

   /* Remove old node */
   Remove(OldNode);

   /* Free old node */
   (*FreeNode)(OldNode);

   /* Set pointer */
   CurrentNode=NewNode;
  } else {
   /* New. Insert after selected node? */
   if (CurrentNode) {
    /* Yes */
    Insert(CurrentList,NewNode,CurrentNode);
    CurrentOrd++;
    CurrentTop=(CurrentOrd>ListViewRows-4) ? CurrentOrd-ListViewRows+4 : 0;
   } else {
    /* No */
    struct Node *tmpnode;
    ULONG i;

    /* Add node to the end of list */
    AddTail(CurrentList,NewNode);

    /* Search ordinal number */
    tmpnode=GetHead(CurrentList);
    for (i=0; tmpnode; i++) tmpnode=GetSucc(tmpnode);
    CurrentOrd=--i;
    CurrentTop=(i>ListViewRows-4) ? i-ListViewRows+4 : 0;
   }
   CurrentNode=NewNode;
  }
 }

 /* Activate Gadgets */
 DisableObjectGadgets(CurrentNode==NULL);

 /* Attach object list */
 AttachObjectList();

 /* Enable window */
 EnableWindow(w,&DummyReq,WINDOW_IDCMP);

 /* Restore update function pointer */
 UpdateWindow=NULL;
 CurrentWindow=w;
}
