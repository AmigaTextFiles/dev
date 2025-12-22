/*
 * dock.c  V3.1
 *
 * ToolManager Objects Dock class
 *
 * Copyright (C) 1990-98 Stefan Becker
 *
 * This source code is for educational purposes only. You may study it
 * and copy ideas or algorithms from it for your own projects. It is
 * not allowed to use any of the source codes (in full or in parts)
 * in other programs. Especially it is not allowed to create variants
 * of ToolManager or ToolManager-like programs from this source code.
 *
 */

#include "toolmanager.h"

/* Menu IDs */
#define MENU_CLOSE 0
#define MENU_PREFS 1
#define MENU_QUIT  2

/* Local data */
#define PROPCHUNKS 3
static const ULONG PropChunkTable[2 * PROPCHUNKS] = {
 ID_TMDO, ID_FONT,
 ID_TMDO, ID_HKEY,
 ID_TMDO, ID_PSCR
};
static const struct TagItem TagsToFlags[] = {
 TMOP_Activated, DATA_DOCKF_ACTIVATED,
 TMOP_Centered,  DATA_DOCKF_CENTERED,
 TMOP_FrontMost, DATA_DOCKF_FRONTMOST,
 TMOP_Menu,      DATA_DOCKF_MENU,
 TMOP_PopUp,     DATA_DOCKF_POPUP,
 TMOP_Text,      DATA_DOCKF_TEXT,
 TMOP_Backdrop,  DATA_DOCKF_BACKDROP,
 TMOP_Sticky,    DATA_DOCKF_STICKY,
 TMOP_Images,    DATA_DOCKF_IMAGES,
 TMOP_Border,    DATA_DOCKF_BORDER,
 TAG_DONE
};
static const struct TagItem CreateMenusTags[] = {
 GTMN_FullMenu, TRUE,
 TAG_DONE
};
static const struct TagItem LayoutMenusTags[] = {
 GTMN_NewLookMenus, TRUE,
 TAG_DONE
};
static struct NewMenu DockMenu[]              = {
 {NM_TITLE, NULL, NULL, 0, ~0, NULL},
  {NM_ITEM, NULL, NULL, 0, ~0, (APTR) MENU_CLOSE},
  {NM_ITEM, NULL, NULL, 0, ~0, (APTR) MENU_PREFS},
  {NM_ITEM, NULL, NULL, 0, ~0, (APTR) MENU_QUIT},
 {NM_END}
};
static ULONG           GadToolsLockCount      = 0;
static struct Library *GadToolsBase           = NULL;

struct DockEntry {
 struct MinNode        de_Node;
 struct DockEntryChunk de_Data;
};

/* Dock class instance data */
struct DockClassData {
 ULONG            dcd_Flags;
 ULONG            dcd_LeftEdge;
 ULONG            dcd_TopEdge;
 ULONG            dcd_Columns;
 struct TextAttr  dcd_TextAttr;
 char            *dcd_PubScreen;
 CxObj           *dcd_HotKey;
 struct MinList   dcd_Entries;   /* entries: struct DockEntry */
 Object          *dcd_Gadget;
 struct TextFont *dcd_Font;
 struct Window   *dcd_Window;
 APTR             dcd_VisualInfo;
 struct Menu     *dcd_Menu;
 void            *dcd_AppWindow;
 ULONG            dcd_Seconds;
 ULONG            dcd_Micros;
};
#define TYPED_INST_DATA(cl, o) ((struct DockClassData *) INST_DATA((cl), (o)))

/* Flags for strings allocated in IFF parsing */
#define IFFF_FONTNAME    0x80000000 /* dcd_TextAttr.ta_Name */
#define IFFF_PUBSCREEN   0x40000000 /* dcd_PubScreen        */

/* Internal state flags */
#define DOCKF_DEFERCLOSE 0x20000000 /* Defer close while dock is active    */
#define DOCKF_REOPEN     0x10000000 /* Open dock when screen is open again */

/* Open gadtools.library */
static BOOL LockGadTools(void)
{
 BOOL rc;

 /* GadTools already opened or can we open it? */
 if (rc = (GadToolsBase != NULL) ||
          (GadToolsBase = OpenLibrary("gadtools.library", 39)))

  /* Increment lock counter */
  GadToolsLockCount++;

 return(rc);
}

/* Close gadtools.library */
static void ReleaseGadTools(void)
{
 /* Decrement lock counter */
 if (--GadToolsLockCount == 0) {

  /* Lock count is zero, close library */
  CloseLibrary(GadToolsBase);

  /* Reset library base pointer */
  GadToolsBase = NULL;
 }
}

/* Free dock menu */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION FreeDockMenu
static void FreeDockMenu(struct DockClassData *dcd)
{
 DOCKCLASS_LOG(LOG0(Freeing menu))

 FreeMenus(dcd->dcd_Menu);
 FreeVisualInfo(dcd->dcd_VisualInfo);
 ReleaseGadTools();
}

/* Create dock menu */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CreateDockMenu
static BOOL CreateDockMenu(struct DockClassData *dcd, struct Screen *s)
{
 BOOL rc = FALSE;

 DOCKCLASS_LOG(LOG0(Entry))

 /* Lock GadTools */
 if (LockGadTools()) {

  DOCKCLASS_LOG(LOG0(GadTools locked))

  /* Get visual info */
  if (dcd->dcd_VisualInfo = GetVisualInfoA(s, NULL)) {

   DOCKCLASS_LOG(LOG1(VisualInfo, "0x%08lx", dcd->dcd_VisualInfo))

   /* Create menus */
   if (dcd->dcd_Menu = CreateMenusA(DockMenu, CreateMenusTags)) {

    DOCKCLASS_LOG(LOG1(Menu, "0x%08lx", dcd->dcd_Menu))

    /* Layout menu */
    if (LayoutMenusA(dcd->dcd_Menu, dcd->dcd_VisualInfo, LayoutMenusTags)) {

     DOCKCLASS_LOG(LOG0(Menus OK))

     /* All OK */
     rc = TRUE;

    } else

     /* Couldn't layout menus */
     FreeMenus(dcd->dcd_Menu);
   }

   /* Error? Free visual info */
   if (rc == FALSE) FreeVisualInfo(dcd->dcd_VisualInfo);
  }

  /* Error? Unlock GadTools*/
  if (rc == FALSE) ReleaseGadTools();
 }

 DOCKCLASS_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Close dock window */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CloseDockWindow
static void CloseDockWindow(Object *obj, struct DockClassData *dcd)
{
 DOCKCLASS_LOG(LOG0(Entry))

 /* Window open? */
 if (dcd->dcd_Window) {

  DOCKCLASS_LOG(LOG0(Closing window))

  /* AppWindow? */
  if (dcd->dcd_AppWindow) DeleteAppWindow(dcd->dcd_AppWindow, obj);

  /* Menu attached? */
  if (dcd->dcd_Menu) {

   /* Remove menu strip from window */
   ClearMenuStrip(dcd->dcd_Window);

   /* Free menu */
   FreeDockMenu(dcd);
  }

  /* Remove dock gadget */
  RemoveGList(dcd->dcd_Window, (struct Gadget *) dcd->dcd_Gadget, 1);

  /* Sticky bit set? */
  if ((dcd->dcd_Flags & DATA_DOCKF_STICKY) == 0) {

   /* No, store new window position */
   dcd->dcd_LeftEdge = dcd->dcd_Window->LeftEdge;
   dcd->dcd_TopEdge  = dcd->dcd_Window->TopEdge;
  }

  /* Close window */
  SafeCloseWindow(dcd->dcd_Window);
  dcd->dcd_Window = NULL;

  /* Delete dock gadget */
  DisposeObject(dcd->dcd_Gadget);

  /* Free font */
  if (dcd->dcd_Font) CloseFont(dcd->dcd_Font);
 }
}

/* Create dock gadget */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CreateDock
static Object *CreateDock(struct TMHandle *tmh, struct DockClassData *dcd,
                          struct Screen *s, ULONG x, ULONG y)
{
 Object *g = NULL;

 DOCKCLASS_LOG(LOG2(Arguments, "X %ld Y %ld", x, y))

 /* Clear font pointer */
 dcd->dcd_Font = NULL;

 /* Font specified? */
 if (dcd->dcd_TextAttr.ta_Name) {
  struct Library *DiskfontBase;

  DOCKCLASS_LOG(LOG0(Load Font))

  /* Open diskfont.library */
  if (DiskfontBase = OpenLibrary("diskfont.library", 39)) {

   DOCKCLASS_LOG(LOG1(DiskfontBase, "0x%08lx", DiskfontBase))

   /* Open disk based font */
   dcd->dcd_Font = OpenDiskFont(&dcd->dcd_TextAttr);

   CloseLibrary(DiskfontBase);
  }

 } else

  /* No, get screen default font */
  dcd->dcd_Font = OpenFont(s->Font);

 /* Font opened? */
 if (dcd->dcd_Font) {

  DOCKCLASS_LOG(LOG1(Font, "0x%08lx", dcd->dcd_Font))

  /* Create group object */
  if (g = NewObject(ToolManagerGroupClass, NULL, GA_Left,      x,
                                                 GA_Top,       y,
                                                 GA_RelVerify, TRUE,
                                                 TAG_DONE)) {
   struct DockEntry *de     = (struct DockEntry *) GetHead(&dcd->dcd_Entries);
   BOOL              images = (dcd->dcd_Flags & DATA_DOCKF_IMAGES) != 0;
   BOOL              text   = (dcd->dcd_Flags & DATA_DOCKF_TEXT)   != 0;

   DOCKCLASS_LOG(LOG1(Group, "0x%08lx", g))

   /* Scan entries list */
   while (de) {
    Object *b;

    /* Create button gadget */
    if (b = NewObject(ToolManagerButtonClass, NULL,
                       TMA_TMHandle, tmh,
                       TMA_Entry,    &de->de_Data,
                       TMA_Screen,   s,
                       TMA_Font,     dcd->dcd_Font,
                       TMA_Images,   images,
                       TMA_Text,     text,
                       TAG_DONE)) {

     DOCKCLASS_LOG(LOG1(Button, "0x%08lx", b))

     /* Add button to group */
     DoMethod(g, OM_ADDMEMBER, b);
    }

    /* Next entry */
    de = (struct DockEntry *) GetSucc((struct MinNode *) de);
   }

   /* Layout group */
   if (DoMethod(g, TMM_Layout, dcd->dcd_Columns) == 0) {

    /* Layout failed, dispose group */
    DisposeObject(g);

    /* Return failure code */
    g = NULL;

   } else {

    /* Initialize rest of data */
    dcd->dcd_Seconds = 0;
    dcd->dcd_Micros  = 0;
   }
  }

  /* Free font if error */
  if (g == NULL) CloseFont(dcd->dcd_Font);
 }

 return(g);
}

/* Open dock window */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION OpenDockWindow
static void OpenDockWindow(Object *obj, struct DockClassData *dcd, BOOL beep)
{
 struct Screen *s;
 BOOL           error = TRUE;

 /* Open on frontmost public screen? */
 if (dcd->dcd_Flags & DATA_DOCKF_FRONTMOST) {
  ULONG lock;

  /* Avoid race conditions */
  Forbid();

  /* Lock IntuitionBase */
  lock = LockIBase(0);

  /* Get active screen */
  if (s = ((struct IntuitionBase *) IntuitionBase)->ActiveScreen) {
   ULONG type = s->Flags & SCREENTYPE;

   DOCKCLASS_LOG(LOG3(ActiveScreen, "0x%08lx Flags 0x%08lx Type 0x%08lx",
                      s, s->Flags, type))

   /* Found a public screen? */
   if ((type != WBENCHSCREEN) && (type != PUBLICSCREEN))

    /* No! Clear pointer again */
    s = NULL;
  }

  /* Unlock IntuitionBase */
  UnlockIBase(lock);

  /* Lock public screen */
  if (s) {
   struct List *slist;

   /* Get a pointer to the public screen list */
   if (slist = LockPubScreenList()) {
    struct PubScreenNode *snode = (struct PubScreenNode *)
                                   GetHead((struct MinList *) slist);
    UBYTE                 buf[MAXPUBSCREENNAME + 1];

    DOCKCLASS_LOG(LOG1(PubScreenList, "0x%08lx", slist))

    /* Scan public scren list */
    while (snode) {

     DOCKCLASS_LOG(LOG1(Next PubScreen, "%s", snode->psn_Node.ln_Name))

     /* Does this node point to our screen? */
     if (snode->psn_Screen == s) {

      /* Yes. Copy screen name and leave loop */
      strcpy(buf, snode->psn_Node.ln_Name);
      break;
     }

     /* get a pointer to next node */
     snode = (struct PubScreenNode *) GetSucc((struct MinNode *) snode);
    }

    /* Release public screen list */
    UnlockPubScreenList();

    DOCKCLASS_LOG(LOG1(PubScreenNode, "0x%08lx", snode))

    /* Public screen node valid? */
    if (snode)

     /* Yes, lock public screen */
     s = LockPubScreen(buf);

    else

     /* No, clear screen pointer */
     s = NULL;

   } else

    /* No public screens??? */
    s = NULL;
  }

  /* OK, we have a screen now */
  Permit();

 } else

  /* No, just lock public screen */
  s = LockPubScreen(dcd->dcd_PubScreen);

 /* Public screen valid? */
 if (s) {
  struct TMHandle *tmh;
  ULONG            gx;
  ULONG            gy;
  BOOL             border = (dcd->dcd_Flags & DATA_DOCKF_BORDER) != 0;

  DOCKCLASS_LOG(LOG1(Screen, "0x%08lx", s))

  /* Get correct gadget offsets */
  if (border) {

   /* Correct for window borders */
   gx = s->WBorLeft + 1;
   gy = s->WBorTop  + s->Font->ta_YSize + 2;

  } else {

   /* No border, no offset */
   gx = 0;
   gy = 0;
  }

  /* Get TMHandle */
  GetAttr(TMA_TMHandle, obj, (ULONG *) &tmh);

  /* Create dock gadget */
  if (dcd->dcd_Gadget = CreateDock(tmh, dcd, s, gx, gy)) {
   char  *name;
   ULONG  wx;
   ULONG  wy;

   /* Get name */
   GetAttr(TMA_ObjectName, obj, (ULONG *) &name);

   /* Centered window? */
   if (dcd->dcd_Flags & DATA_DOCKF_CENTERED) {

    /* Centering: X = MouseX - width/2 - LeftBorder */
    wx = s->MouseX - ((struct Gadget *) dcd->dcd_Gadget)->Width  / 2 - gx;
    wy = s->MouseY - ((struct Gadget *) dcd->dcd_Gadget)->Height / 2 - gy;

   /* Not centered */
   } else {
    wx = dcd->dcd_LeftEdge;
    wy = dcd->dcd_TopEdge;
   }

   /* Clear menu pointer */
   dcd->dcd_Menu = NULL;

   /* Menu flag not set? Otherwise create menus */
   if (((dcd->dcd_Flags & DATA_DOCKF_MENU) == 0) || CreateDockMenu(dcd, s)) {

    DOCKCLASS_LOG(LOG1(Menu, "0x%08lx", dcd->dcd_Menu))

    /* Open window */
    if (dcd->dcd_Window = OpenWindowTags(NULL,
         WA_Left,         wx,
         WA_Top,          wy,
         WA_InnerWidth,
                ((struct Gadget *) dcd->dcd_Gadget)->Width  + (border ? 2 : 0),
         WA_InnerHeight,
                ((struct Gadget *) dcd->dcd_Gadget)->Height + (border ? 2 : 0),
         WA_Title,        border ? name : NULL,
         WA_Borderless,   !border,
         WA_CloseGadget,  border,
         WA_DragBar,      border,
         WA_DepthGadget,  border,
         WA_PubScreen,    s,
         WA_AutoAdjust,   TRUE,
         WA_NewLookMenus, TRUE,
         WA_IDCMP,        0,
         TAG_DONE)) {

     DOCKCLASS_LOG(LOG1(Window, "0x%08lx", dcd->dcd_Window))

     /* Backdrop flag set? */
     if (dcd->dcd_Flags & DATA_DOCKF_BACKDROP) WindowToBack(dcd->dcd_Window);

     /* Attach and activate IDCMP */
     if (AttachIDCMP(obj, dcd->dcd_Window, IDCMP_GADGETUP | IDCMP_MENUPICK |
                                           IDCMP_CLOSEWINDOW |
                                           IDCMP_VANILLAKEY)) {

      DOCKCLASS_LOG(LOG0(Window active))

      /* Add gadget */
      AddGList(dcd->dcd_Window, (struct Gadget *) dcd->dcd_Gadget, (UWORD) -1,
               1, NULL);
      RefreshGList((struct Gadget *) dcd->dcd_Gadget, dcd->dcd_Window, NULL,
                   1);

      /* Add menu */
      if (dcd->dcd_Menu) SetMenuStrip(dcd->dcd_Window, dcd->dcd_Menu);

      /* Clear AppWindow pointer */
      dcd->dcd_AppWindow = NULL;

      /* On Workbench screen? */
      if ((s->Flags & SCREENTYPE) == WBENCHSCREEN)

       /* Yes, activate AppWindow */
       dcd->dcd_AppWindow = CreateAppWindow(obj, dcd->dcd_Window);

      DOCKCLASS_LOG(LOG1(AppWindow, "0x%08lx", dcd->dcd_AppWindow))

      /* Dock window has been opened */
      error = FALSE;

      DOCKCLASS_LOG(LOG0(Gadget attached))
     }

     /* Close window if error */
     if (error) {
      SafeCloseWindow(dcd->dcd_Window);
      dcd->dcd_Window = NULL;
     }
    }

    /* Free dock menu if error */
    if (dcd->dcd_Menu && error) FreeDockMenu(dcd);
   }

   /* Dispose dock gadget if error */
   if (error) DisposeObject(dcd->dcd_Gadget);
  }

  /* Unlock screen */
  UnlockPubScreen(NULL, s);
 }

 /* Error? */
 if (error)

  /* beep allowed? */
  if (beep)

   /* Flash screens! */
   DisplayBeep(NULL);

  else

   /* No, but mark dock window for re-opening when screen is available */
   dcd->dcd_Flags |= DOCKF_REOPEN;
}

/* Dock class method: OM_NEW */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DockClassNew
static ULONG DockClassNew(Class *cl, Object *obj, struct opSet *ops)
{
 DOCKCLASS_LOG((LOG1(Tags, "0x%08lx", ops->ops_AttrList),
                PrintTagList(ops->ops_AttrList)))

 /* Call SuperClass */
 if (obj = (Object *) DoSuperMethodA(cl, obj, (Msg) ops)) {
  struct DockClassData *dcd = TYPED_INST_DATA(cl, obj);

  /* Initialize instance data */
  dcd->dcd_Flags            = 0;
  dcd->dcd_LeftEdge         = 0;
  dcd->dcd_TopEdge          = 0;
  dcd->dcd_Columns          = 0;
  dcd->dcd_TextAttr.ta_Name = NULL;
  dcd->dcd_PubScreen        = NULL;
  dcd->dcd_HotKey           = NULL;
  dcd->dcd_Window           = NULL;

  /* Initialize dock entries list */
  NewList((struct List *) &dcd->dcd_Entries);

  /* We need screen notifications */
  LockScreenNotify();
 }

 return((ULONG) obj);
}

/* Dock class method: OM_DISPOSE */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DockClassDispose
static ULONG DockClassDispose(Class *cl, Object *obj, Msg msg)
{
 struct DockClassData *dcd = TYPED_INST_DATA(cl, obj);

 DOCKCLASS_LOG(LOG0(Disposing))

 /* We don't need screen notifications anymore */
 ReleaseScreenNotify();

 /* Close dock */
 CloseDockWindow(obj, dcd);

 /* Free dock entries */
 {
  struct DockEntry *de;

  /* Remove entry from head of list */
  while (de = (struct DockEntry *) RemHead((struct List *) &dcd->dcd_Entries))

   /* Free entry */
   FreeMemory(de, sizeof(struct DockEntry));
 }

 /* Hotkey allocated? */
 if (dcd->dcd_HotKey) SafeDeleteCxObjAll(dcd->dcd_HotKey, obj);

 /* Free IFF data */
 if (dcd->dcd_Flags & IFFF_PUBSCREEN) FreeVector(dcd->dcd_PubScreen);
 if (dcd->dcd_Flags & IFFF_FONTNAME)  FreeVector(dcd->dcd_TextAttr.ta_Name);

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, msg));
}

/* Dock class method: TMM_ParseIFF */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DockClassParseIFF
static ULONG DockClassParseIFF(Class *cl, Object *obj,
                               struct TMP_ParseIFF *tmppi)
{
 BOOL rc = FALSE;

 DOCKCLASS_LOG(LOG1(Handle, "0x%08lx", tmppi->tmppi_IFFHandle))

 /* Initialize IFF parser and forward method to SuperClass */
 if ((PropChunks(tmppi->tmppi_IFFHandle, PropChunkTable, PROPCHUNKS) == 0) &&
     (CollectionChunk(tmppi->tmppi_IFFHandle, ID_TMDO, ID_ENTR) == 0) &&
     DoSuperMethodA(cl, obj, (Msg) tmppi)) {
  struct StoredProperty *sp;

  DOCKCLASS_LOG(LOG0(FORM TMDO chunk parsed OK))

  /* Check for mandatory DATA property */
  if (sp = FindProp(tmppi->tmppi_IFFHandle, ID_TMDO, ID_DATA)) {
   struct DockClassData *dcd = TYPED_INST_DATA(cl, obj);
   struct DockDATAChunk *ddc = sp->sp_Data;

   DOCKCLASS_LOG(LOG4(Data1,
                      "Flags 0x%08lx X %ld Y %ld Cols %ld",
                      ddc->ddc_Standard.sdc_Flags, ddc->ddc_LeftEdge,
                      ddc->ddc_TopEdge, ddc->ddc_Columns))
   DOCKCLASS_LOG(LOG3(Data2,
                      "Font YSize %ld Style 0x%02lx Flags 0x%02lx",
                      ddc->ddc_FontYSize, ddc->ddc_FontStyle,
                      ddc->ddc_FontFlags))

   /* Initialize class data */
   dcd->dcd_Flags             = ddc->ddc_Standard.sdc_Flags & DATA_DOCKF_MASK;
   dcd->dcd_LeftEdge          = ddc->ddc_LeftEdge;
   dcd->dcd_TopEdge           = ddc->ddc_TopEdge;
   dcd->dcd_Columns           = ddc->ddc_Columns;
   dcd->dcd_TextAttr.ta_YSize = ddc->ddc_FontYSize;
   dcd->dcd_TextAttr.ta_Style = ddc->ddc_FontStyle;
   dcd->dcd_TextAttr.ta_Flags = ddc->ddc_FontFlags;

   /* Duplicate strings and set flags */
   if (dcd->dcd_TextAttr.ta_Name = DuplicateProperty(tmppi->tmppi_IFFHandle,
                                                     ID_TMDO, ID_FONT))
    dcd->dcd_Flags |= IFFF_FONTNAME;
   if (dcd->dcd_PubScreen        = DuplicateProperty(tmppi->tmppi_IFFHandle,
                                                     ID_TMDO, ID_PSCR))
    dcd->dcd_Flags |= IFFF_PUBSCREEN;

   /* HotKey specified? */
   if (sp = FindProp(tmppi->tmppi_IFFHandle, ID_TMDO, ID_HKEY))

    /* Yes, reate Hotkey */
    dcd->dcd_HotKey = CreateHotKey(sp->sp_Data, obj);

   /* Build dock entries list */
   {
    struct CollectionItem *ci;

    /* Any entries found? */
    if (ci = FindCollection(tmppi->tmppi_IFFHandle, ID_TMDO, ID_ENTR)) {
     struct DockEntry *de;

     DOCKCLASS_LOG(LOG1(Collection, "0x%08lx", ci))

     /* Scan collection item list */
     while (ci) {

      DOCKCLASS_LOG(LOG1(Next, "0x%08lx", ci))

      /* Allocate memory for next entry */
      if (de = GetMemory(sizeof(struct DockEntry))) {

       /* Copy data */
       de->de_Data = *((struct DockEntryChunk *) ci->ci_Data);

       /* Insert entry at the head of the list */
       AddHead((struct List *) &dcd->dcd_Entries, (struct Node *) de);

      } else

       /* No memory, leave loop */
       break;

      /* Next collection item */
      ci = ci->ci_Next;
     }
    }
   }

   /* Dock active? */
   if (dcd->dcd_Flags & DATA_DOCKF_ACTIVATED) OpenDockWindow(obj, dcd, FALSE);

   /* Configuration data parsed */
   rc = TRUE;
  }
 }

 DOCKCLASS_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Dock class method: TMM_ParseTags */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DockClassParseTags
static ULONG DockClassParseTags(Class *cl, Object *obj,
                                struct TMP_ParseTags *tmppt)
{
 struct DockClassData *dcd    = TYPED_INST_DATA(cl, obj);
 struct TagItem       *tstate = tmppt->tmppt_Tags;
 struct TagItem       *ti;
 struct TMHandle      *tmh;
 BOOL                  rc     = TRUE;

 DOCKCLASS_LOG((LOG1(Tags, "0x%08lx", tmppt->tmppt_Tags),
                PrintTagList(tmppt->tmppt_Tags)))

 /* Remove old dock first */
 CloseDockWindow(obj, dcd);

 /* Get TMHandle */
 GetAttr(TMA_TMHandle, obj, (ULONG *) &tmh);

 /* Scan tag list */
 while (rc && (ti = NextTagItem(&tstate)))

  /* Which tag? */
  switch (ti->ti_Tag) {
   case TMOP_HotKey:
    /* Free old hotkey */
    if (dcd->dcd_HotKey) SafeDeleteCxObjAll(dcd->dcd_HotKey, obj);

    /* String valid? */
    if (ti->ti_Data)

     /* Yes, create new hotkey */
     rc = (dcd->dcd_HotKey = CreateHotKey((char *) ti->ti_Data, obj)) != NULL;

    else

     /* Hotkey cleared */
     dcd->dcd_HotKey = NULL;

    break;

   case TMOP_PubScreen:
    dcd->dcd_PubScreen = (char *) ti->ti_Data;
    break;

   case TMOP_LeftEdge:
    dcd->dcd_LeftEdge = ti->ti_Data;
    break;

   case TMOP_TopEdge:
    dcd->dcd_TopEdge = ti->ti_Data;
    break;

   case TMOP_Columns:
    dcd->dcd_Columns = ti->ti_Data;
    break;

   case TMOP_Font:
    dcd->dcd_TextAttr = *((struct TextAttr *) ti->ti_Data);
    break;

   case TMOP_Tool:
    /* Tool valid? */
    if (ti->ti_Data) {
     struct DockEntry *de;

     /* Yes, get memory for dock entry */
     if (de = GetMemory(sizeof(struct DockEntry))) {
      char   **names  = (char **) ti->ti_Data;
      Object  *newobj;

      /* Get Exec object */
      if (names[0] && (newobj = FindTypedNamedTMObject(tmh, names[0],
                                                       TMOBJTYPE_EXEC)))

       /* Get object ID */
       GetAttr(TMA_ObjectID, newobj, &de->de_Data.dec_ExecObject);

      /* Get Image object */
      if (names[1] && (newobj = FindTypedNamedTMObject(tmh, names[1],
                                                       TMOBJTYPE_IMAGE)))

       /* Get object ID */
       GetAttr(TMA_ObjectID, newobj, &de->de_Data.dec_ImageObject);

      /* Get Exec object */
      if (names[2] && (newobj = FindTypedNamedTMObject(tmh, names[2],
                                                       TMOBJTYPE_SOUND)))

       /* Get object ID */
       GetAttr(TMA_ObjectID, newobj, &de->de_Data.dec_SoundObject);

      /* Insert entry at the head of the list */
      AddHead((struct List *) &dcd->dcd_Entries, (struct Node *) de);

     } else

      /* Error */
      rc = FALSE;
    }
    break;
  }

 /* Set flags */
 if (rc) dcd->dcd_Flags = PackBoolTags(dcd->dcd_Flags, tmppt->tmppt_Tags,
                                       TagsToFlags);

 /* Open dock? */
 if (rc && (dcd->dcd_Window == NULL) &&
     (dcd->dcd_Flags & DATA_DOCKF_ACTIVATED))

  /* Yes */
  OpenDockWindow(obj, dcd, FALSE);

 DOCKCLASS_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Activate one dock entry */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ActivateDockEntry
static BOOL ActivateDockEntry(struct DockClassData *dcd, ULONG id, ULONG data)
{
 BOOL rc;

 DOCKCLASS_LOG(LOG0(Entry))

 /* We are active now, please don't close the window */
 dcd->dcd_Flags |= DOCKF_DEFERCLOSE;

 /* Send message do object */
 DoMethod(dcd->dcd_Gadget, id, data);

 /* Popup dock or defered close flag cleared? */
 if ((dcd->dcd_Flags & DATA_DOCKF_POPUP) ||
     ((dcd->dcd_Flags & DOCKF_DEFERCLOSE) == 0))

  /* Close dock window */
  rc = TRUE;

 else {

  /* Reset defered close flag */
  dcd->dcd_Flags &= ~DOCKF_DEFERCLOSE;

  /* Window should NOT be closed */
  rc = FALSE;
 }

 DOCKCLASS_LOG(LOG1(Result, "%ld", rc))

 /* Return TRUE if the window should be closed */
 return(rc);
}


/* Exec class method: TMM_Activate */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DockClassActivate
static ULONG DockClassActivate(Class *cl, Object *obj,
                               struct TMP_Activate *tmpa)
{
 struct DockClassData *dcd = TYPED_INST_DATA(cl, obj);

 DOCKCLASS_LOG(LOG1(Data, "0x%08lx", tmpa->tmpa_Data))

 /* Data valid? */
 if (tmpa->tmpa_Data) {

  /* Activate dock entry */
  if (ActivateDockEntry(dcd, TMM_AppEvent, (ULONG) tmpa->tmpa_Data))

   /* Please close window */
   CloseDockWindow(obj, dcd);

 /* No data, user pressed hotkey. Dock window open? */
 } else if (dcd->dcd_Window)

  /* Close defered? */
  if (dcd->dcd_Flags & DOCKF_DEFERCLOSE)

   /* Yes, reset flag */
   dcd->dcd_Flags &= ~DOCKF_DEFERCLOSE;

  else

   /* No, close window */
   CloseDockWindow(obj, dcd);

 /* Dock window is not open, open it */
 else OpenDockWindow(obj, dcd, TRUE);

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* Dock class method: TMM_IDCMPEvent */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DockClassIDCMPEvent
static ULONG DockClassIDCMPEvent(Class *cl, Object *obj,
                                 struct TMP_IDCMPEvent *tmpie)
{
 struct DockClassData *dcd   = TYPED_INST_DATA(cl, obj);
 BOOL                  close = FALSE;

 /* Which event? */
 switch (tmpie->tmpie_Message->Class) {

  case IDCMP_GADGETUP: {
    struct IntuiMessage *msg = tmpie->tmpie_Message;

    /* Check double click time */
    if (DoubleClick(dcd->dcd_Seconds, dcd->dcd_Micros,
                    msg->Seconds,     msg->Micros) == FALSE)

     /* Not a double click -> Activate dock entry */
     close = ActivateDockEntry(dcd, TMM_GadgetUp, msg->Code);

    /* Save time */
    dcd->dcd_Seconds = msg->Seconds;
    dcd->dcd_Micros  = msg->Micros;
   }
   break;

  case IDCMP_MENUPICK: {
    USHORT menunum = tmpie->tmpie_Message->Code;

    /* Scan all menu events */
    while (menunum != MENUNULL) {
     struct MenuItem *menuitem = ItemAddress(dcd->dcd_Menu, menunum);

     DOCKCLASS_LOG(LOG2(Menu event, "Num 0x%04lx Item 0x%08lx", menunum,
                        menuitem))

     /* Which menu selected? */
     switch (GTMENUITEM_USERDATA(menuitem)) {
      case MENU_CLOSE: close = TRUE;       break;
      case MENU_PREFS: StartPreferences(); break;
      case MENU_QUIT:  KillToolManager();  break;
     }

     /* Get next menu event */
     menunum = menuitem->NextSelect;
    }
   }
   break;

  case IDCMP_CLOSEWINDOW:
   close = TRUE;
   break;

  case IDCMP_VANILLAKEY:
   /* Which key was pressed? */
   switch (tmpie->tmpie_Message->Code) {
    case 0x03: /* CTRL-C */
    case 0x1B: /* ESC    */
     close = TRUE;
     break;
   }
   break;
 }

 /* Reply message */
 ReplyMsg((struct Message *) tmpie->tmpie_Message);

 /* Close window? */
 if (close) CloseDockWindow(obj, dcd);

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* Dock class method: TMM_ScreenOpen */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DockClassScreenOpen
static ULONG DockClassScreenOpen(Class *cl, Object *obj,
                                 struct TMP_ScreenOpen *tmpso)
{
 struct DockClassData *dcd = TYPED_INST_DATA(cl, obj);

 /* Dock window marked for re-opening? */
 if ((dcd->dcd_Flags & DOCKF_REOPEN) &&

 /* Public screen name specified for this dock? */
     (dcd->dcd_PubScreen != NULL) &&

 /* Does public screen name match? */
     (stricmp(dcd->dcd_PubScreen, tmpso->tmpso_Name) == 0)) {

  /* Yes, open dock window */
  OpenDockWindow(obj, dcd, TRUE);

  /* Clear re-open flag */
  dcd->dcd_Flags &= ~DOCKF_REOPEN;
 }

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* Dock class method: TMM_ScreenClose */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DockClassScreenClose
static ULONG DockClassScreenClose(Class *cl, Object *obj,
                                  struct TMP_ScreenClose *tmpsc)
{
 struct DockClassData *dcd = TYPED_INST_DATA(cl, obj);

 /* Is window open and does the screen match? */
 if (dcd->dcd_Window && (dcd->dcd_Window->WScreen == tmpsc->tmpsc_Screen)) {

  /* Yes, close dock window */
  CloseDockWindow(obj, dcd);

  /* Mark dock window for re-opening when screen is available again */
  dcd->dcd_Flags |= DOCKF_REOPEN;
 }

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* Dock class dispatcher */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DockClassDispatcher
static __geta4 ULONG DockClassDispatcher(__A0 Class *cl, __A2 Object *obj,
                                         __A1 Msg msg)
{
 ULONG rc;

 DOCKCLASS_LOG(LOG3(Arguments, "Class 0x%08lx Object 0x%08lx Msg 0x%08lx",
                    cl, obj, msg))

 switch(msg->MethodID) {
  /* BOOPSI methods */
  case OM_NEW:
   rc = DockClassNew(cl, obj, (struct opSet *) msg);
   break;

  case OM_DISPOSE:
   rc = DockClassDispose(cl, obj, msg);
   break;

  /* TM methods */
  case TMM_ParseIFF:
   rc = DockClassParseIFF(cl, obj, (struct TMP_ParseIFF *) msg);
   break;

  case TMM_ParseTags:
   rc = DockClassParseTags(cl, obj, (struct TMP_ParseTags *) msg);
   break;

  case TMM_Activate:
   rc = DockClassActivate(cl, obj, (struct TMP_Activate *) msg);
   break;

  case TMM_IDCMPEvent:
   rc = DockClassIDCMPEvent(cl, obj, (struct TMP_IDCMPEvent *) msg);
   break;

  case TMM_ScreenOpen:
   rc = DockClassScreenOpen(cl, obj, (struct TMP_ScreenOpen *) msg);
   break;

  case TMM_ScreenClose:
   rc = DockClassScreenClose(cl, obj, (struct TMP_ScreenClose *) msg);
   break;

  /* Unknown method -> delegate to SuperClass */
  default:
   rc = DoSuperMethodA(cl, obj, msg);
   break;
 }

 return(rc);
}

/* Create Dock class */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CreateDockClass
Class *CreateDockClass(Class *superclass)
{
 Class *cl;

 DOCKCLASS_LOG(LOG1(SuperClass, "0x%08lx", superclass))

 /* Create class */
 if (cl = MakeClass(NULL, NULL, superclass, sizeof(struct DockClassData), 0)) {

  /* Set dispatcher */
  cl->cl_Dispatcher.h_Entry = (ULONG (*)()) DockClassDispatcher;

  /* Localize strings */
  DockMenu[0].nm_Label   = TranslateString(
                                   LOCALE_LIBRARY_DOCK_MENU_TITLE_STR,
                                   LOCALE_LIBRARY_DOCK_MENU_TITLE);
  DockMenu[1].nm_Label   = TranslateString(
                                   LOCALE_LIBRARY_DOCK_MENU_CLOSE_ITEM_STR,
                                   LOCALE_LIBRARY_DOCK_MENU_CLOSE_ITEM);
  DockMenu[1].nm_CommKey = TranslateString(
                                   LOCALE_LIBRARY_DOCK_MENU_CLOSE_SHORTCUT_STR,
                                   LOCALE_LIBRARY_DOCK_MENU_CLOSE_SHORTCUT);
  DockMenu[2].nm_Label   = TranslateString(
                                   LOCALE_LIBRARY_DOCK_MENU_PREFS_ITEM_STR,
                                   LOCALE_LIBRARY_DOCK_MENU_PREFS_ITEM);
  DockMenu[2].nm_CommKey = TranslateString(
                                   LOCALE_LIBRARY_DOCK_MENU_PREFS_SHORTCUT_STR,
                                   LOCALE_LIBRARY_DOCK_MENU_PREFS_SHORTCUT);
  DockMenu[3].nm_Label   = TranslateString(
                                   LOCALE_LIBRARY_DOCK_MENU_QUIT_ITEM_STR,
                                   LOCALE_LIBRARY_DOCK_MENU_QUIT_ITEM);
  DockMenu[3].nm_CommKey = TranslateString(
                                   LOCALE_LIBRARY_DOCK_MENU_QUIT_SHORTCUT_STR,
                                   LOCALE_LIBRARY_DOCK_MENU_QUIT_SHORTCUT);
 }

 DOCKCLASS_LOG(LOG1(Class, "0x%08lx", cl))

 /* Return pointer to class */
 return(cl);
}
