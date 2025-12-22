/*
 * dock.c  V3.1
 *
 * TM Dock object class
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

/* Local data */
#define PROPCHUNKS 5
static const ULONG PropChunkTable[2 * PROPCHUNKS] = {
 ID_TMDO, ID_DATA,
 ID_TMDO, ID_FONT,
 ID_TMDO, ID_HKEY,
 ID_TMDO, ID_NAME,
 ID_TMDO, ID_PSCR
};
static const char *TextTitle;
static const char *HelpHotKey;
static const char *HelpPublicScreen;
static const char *HelpPosition;
static const char *TextColumns;
static const char *HelpColumns;
static const char *TextFont;
static const char *HelpFont;
static const char *TextActivated;
static const char *HelpActivated;
static const char *TextBackdrop;
static const char *HelpBackdrop;
static const char *TextBorder;
static const char *HelpBorder;
static const char *TextCentered;
static const char *HelpCentered;
static const char *TextFrontmost;
static const char *HelpFrontmost;
static const char *TextImages;
static const char *HelpImages;
static const char *TextMenu;
static const char *HelpMenu;
static const char *TextPopup;
static const char *HelpPopup;
static const char *TextSticky;
static const char *HelpSticky;
static const char *TextText;
static const char *HelpText;
static const char *TextEntries;
static const char *HelpEntries;
static const char *TextSelectFont;

/* Dock class instance data */
struct DockClassData {
 ULONG           dcd_Flags;
 ULONG           dcd_LeftEdge;
 ULONG           dcd_TopEdge;
 ULONG           dcd_Columns;
 const char     *dcd_HotKey;
 const char     *dcd_Font;
 const char     *dcd_PubScreen;
 struct MinList  dcd_Entries;
 Object         *dcd_Active;
 Object         *dcd_HotKeyString;
 Object         *dcd_Position;
 Object         *dcd_ColsNumeric;
 Object         *dcd_PubScreenString;
 Object         *dcd_FontString;
 Object         *dcd_ListView;
 Object         *dcd_EntryList;
 Object         *dcd_Activated;
 Object         *dcd_Backdrop;
 Object         *dcd_Border;
 Object         *dcd_Centered;
 Object         *dcd_Frontmost;
 Object         *dcd_Images;
 Object         *dcd_Menu;
 Object         *dcd_Popup;
 Object         *dcd_Sticky;
 Object         *dcd_Text;
};
#define TYPED_INST_DATA(cl, o) ((struct DockClassData *) INST_DATA((cl), (o)))

/* Dock class method: OM_NEW */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DockClassNew
static ULONG DockClassNew(Class *cl, Object *obj, struct opSet *ops)
{
 DOCK_LOG((LOG1(Tags, "0x%08lx", ops->ops_AttrList),
           PrintTagList(ops->ops_AttrList)))

 /* Create object */
 if (obj = (Object *) DoSuperNew(cl, obj,
                                       MUIA_Window_Title, TextTitle,
                                       MUIA_HelpNode,     "DockWindow",
                                       TMA_Type,          TMOBJTYPE_DOCK,
                                       TAG_MORE,          ops->ops_AttrList)) {
  struct DockClassData *dcd = TYPED_INST_DATA(cl, obj);

  /* Initalize entries list */
  NewList((struct List *) &dcd->dcd_Entries);

  /* Initialize instance data */
  dcd->dcd_Flags       = DATA_DOCKF_ACTIVATED | DATA_DOCKF_IMAGES;
  dcd->dcd_LeftEdge    = 0;
  dcd->dcd_TopEdge     = 0;
  dcd->dcd_Columns     = 1;
  dcd->dcd_HotKey      = NULL;
  dcd->dcd_Font        = NULL;
  dcd->dcd_PubScreen   = NULL;
  dcd->dcd_Active      = NULL;
 }

 DOCK_LOG(LOG1(Result, "0x%08lx", obj))

 /* Return pointer to created object */
 return((ULONG) obj);
}

/* Dock class method: OM_DISPOSE */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DockClassDispose
static ULONG DockClassDispose(Class *cl, Object *obj, Msg msg)
{
 struct DockClassData *dcd = TYPED_INST_DATA(cl, obj);

 DOCK_LOG(LOG1(Disposing, "0x%08lx", obj))

 /* Free dock entries */
 FreeDockEntries(&dcd->dcd_Entries);

 /* Free strings */
 if (dcd->dcd_HotKey)    FreeVector(dcd->dcd_HotKey);
 if (dcd->dcd_Font)      FreeVector(dcd->dcd_Font);
 if (dcd->dcd_PubScreen) FreeVector(dcd->dcd_PubScreen);

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, msg));
}

/* Dock class method: TMM_Finish */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DockClassFinish
static ULONG DockClassFinish(Class *cl, Object *obj, struct TMP_Finish *tmpf)
{
 struct DockClassData *dcd = TYPED_INST_DATA(cl, obj);

 DOCK_LOG(LOG1(Type, "%ld", tmpf->tmpf_Type))

 /* MUI objects allocated? */
 if (dcd->dcd_Active) {

  /* Use or Cancel? */
  if (tmpf->tmpf_Type == TMV_Finish_Use) {
   int               i  = 0;
   struct DockEntry *de;

   /* Free old entries */
   FreeDockEntries(&dcd->dcd_Entries);

   /* For each entry in list */
   do {
    struct DockEntry *new;

    /* Get next entry */
    DoMethod(dcd->dcd_EntryList, MUIM_List_GetEntry, i++, &de);

    DOCK_LOG(LOG1(Next entry, "0x%08lx", de))

    /* End of list reached? */
    if (de) {

     /* No, copy entry. Leave loop if error */
     if ((new = CopyDockEntry(de, obj)) == NULL) break;

     /* Append new entry to list */
     AddTail((struct List *) &dcd->dcd_Entries, (struct Node *) new);
    }
   } while (de);

   /* Get new string contents */
   dcd->dcd_HotKey    = GetStringContents(dcd->dcd_HotKeyString,
                                          dcd->dcd_HotKey);
   dcd->dcd_Font      = GetStringContents(dcd->dcd_FontString,
                                          dcd->dcd_Font);
   dcd->dcd_PubScreen = GetStringContents(dcd->dcd_PubScreenString,
                                          dcd->dcd_PubScreen);

   /* Get new position values */
   GetAttr(MUIA_Popposition_XPos, dcd->dcd_Position,  &dcd->dcd_LeftEdge);
   GetAttr(MUIA_Popposition_YPos, dcd->dcd_Position,  &dcd->dcd_TopEdge);

   /* Get new columns count */
   GetAttr(MUIA_Numeric_Value, dcd->dcd_ColsNumeric, &dcd->dcd_Columns);

   /* Get new flag status */
   dcd->dcd_Flags = GetCheckmarkState(dcd->dcd_Activated,
                                      DATA_DOCKF_ACTIVATED) |
                    GetCheckmarkState(dcd->dcd_Backdrop,
                                      DATA_DOCKF_BACKDROP)  |
                    GetCheckmarkState(dcd->dcd_Border,
                                      DATA_DOCKF_BORDER)    |
                    GetCheckmarkState(dcd->dcd_Centered,
                                      DATA_DOCKF_CENTERED)  |
                    GetCheckmarkState(dcd->dcd_Frontmost,
                                      DATA_DOCKF_FRONTMOST) |
                    GetCheckmarkState(dcd->dcd_Images,
                                      DATA_DOCKF_IMAGES)    |
                    GetCheckmarkState(dcd->dcd_Menu,
                                      DATA_DOCKF_MENU)      |
                    GetCheckmarkState(dcd->dcd_Popup,
                                      DATA_DOCKF_POPUP)     |
                    GetCheckmarkState(dcd->dcd_Sticky,
                                      DATA_DOCKF_STICKY)    |
                    GetCheckmarkState(dcd->dcd_Text,
                                      DATA_DOCKF_TEXT);
  }

  /* Reset pointer to file name area */
  dcd->dcd_Active = NULL;
 }

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, (Msg) tmpf));
}

/* Dock class method: TMM_Notify */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DockClassNotify
static ULONG DockClassNotify(Class *cl, Object *obj, struct TMP_Notify *tmpn)
{
 DOCK_LOG(LOG1(Type, "0x%08lx", tmpn->tmpn_Data->ad_Object))

 /* Object deleted? */
 if (tmpn->tmpn_Data->ad_Object == NULL) {
  struct DockEntry *de = (struct DockEntry *)
                          GetHead(&TYPED_INST_DATA(cl, obj)->dcd_Entries);

  /* For each entry in the list */
  while (de) {

   ENTRIES_LOG(LOG1(Next entry, "0x%08lx", de))

   /* Try to remove attached object. Leave loop if object found */
   if (RemoveDockEntryAttach(de, tmpn->tmpn_Data)) break;

   de = (struct DockEntry *) GetSucc((struct MinNode *) de);
  }
 }

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* Dock class method: TMM_Edit */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DockClassEdit
static ULONG DockClassEdit(Class *cl, Object *obj, struct TMP_Edit *tmpe)
{
 struct DockClassData *dcd = TYPED_INST_DATA(cl, obj);
 Object               *delete;

 /* MUI objects allocated? */
 if (dcd->dcd_Active) {

  DOCK_LOG(LOG0(Object already active))

  /* Yes, forward method to SuperClass */
  DoSuperMethodA(cl, obj, (Msg) tmpe);

 /* No, create object edit area */
 } else if (dcd->dcd_Active =
    VGroup,
     Child, ColGroup(2),
      Child, Label2(TextGlobalHotKey),
      Child, dcd->dcd_HotKeyString    = TMPopHotKey(dcd->dcd_HotKey,
                                                    HelpHotKey),
      End,
      Child, Label2(TextGlobalPublicScreen),
      Child, dcd->dcd_PubScreenString = TMPopScreen(dcd->dcd_PubScreen,
                                                    HelpPublicScreen),
      End,
      Child, Label2(TextFont),
      Child, dcd->dcd_FontString      = NewObject(PopASLClass->mcc_Class, NULL,
       MUIA_Popasl_Type,      ASL_FontRequest,
       MUIA_Popstring_String, TMString(dcd->dcd_Font, LENGTH_STRING, NULL),
       MUIA_Popstring_Button, PopButton(MUII_PopUp),
       MUIA_ShortHelp,        HelpFont,
       ASLFR_TitleText,       TextSelectFont,
      End,
     End,
     Child, HGroup,
      Child, Label1(TextColumns),
      Child, dcd->dcd_ColsNumeric = NumericbuttonObject,
       MUIA_Numeric_Min,   1,
       MUIA_Numeric_Max,   20,
       MUIA_Numeric_Value, dcd->dcd_Columns,
       MUIA_CycleChain,    TRUE,
       MUIA_ShortHelp,     HelpColumns,
      End,
      Child, Label2(TextGlobalPosition),
      Child, dcd->dcd_Position    = TMPopPosition(dcd->dcd_LeftEdge,
                                                  dcd->dcd_TopEdge,
                                                  HelpPosition),
      End,
     End,
     Child, VGroup,
      MUIA_Background, MUII_GroupBack,
      MUIA_Frame,      MUIV_Frame_Group,
      MUIA_FrameTitle, TextEntries,
      MUIA_ShortHelp,  HelpEntries,
      Child, dcd->dcd_ListView = ListviewObject,
       MUIA_Listview_DragType, MUIV_Listview_DragType_Immediate,
       MUIA_Listview_List,     dcd->dcd_EntryList =
        NewObject(EntryListClass->mcc_Class, NULL,
        TMA_Entries,     &dcd->dcd_Entries,
        MUIA_Frame,      MUIV_Frame_InputList,
       End,
       MUIA_CycleChain,        TRUE,
      End,
      Child, delete = MakeButton(TextGlobalDelete, HelpGlobalDelete),
     End,
     Child, ColGroup(11),
      Child, Label1(TextActivated),
      Child, dcd->dcd_Activated =
       MakeCheckmark(dcd->dcd_Flags & DATA_DOCKF_ACTIVATED, HelpActivated),
      Child, HSpace(0),
      Child, Label1(TextBackdrop),
      Child, dcd->dcd_Backdrop =
       MakeCheckmark(dcd->dcd_Flags & DATA_DOCKF_BACKDROP, HelpBackdrop),
      Child, HSpace(0),
      Child, Label1(TextBorder),
      Child, dcd->dcd_Border =
       MakeCheckmark(dcd->dcd_Flags & DATA_DOCKF_BORDER, HelpBorder),
      Child, HSpace(0),
      Child, Label1(TextMenu),
      Child, dcd->dcd_Menu =
       MakeCheckmark(dcd->dcd_Flags & DATA_DOCKF_MENU, HelpMenu),
      Child, Label1(TextFrontmost),
      Child, dcd->dcd_Frontmost =
       MakeCheckmark(dcd->dcd_Flags & DATA_DOCKF_FRONTMOST, HelpFrontmost),
      Child, HSpace(0),
      Child, Label1(TextPopup),
      Child, dcd->dcd_Popup =
       MakeCheckmark(dcd->dcd_Flags & DATA_DOCKF_POPUP, HelpPopup),
      Child, HSpace(0),
      Child, Label1(TextCentered),
      Child, dcd->dcd_Centered =
       MakeCheckmark(dcd->dcd_Flags & DATA_DOCKF_CENTERED, HelpCentered),
      Child, HSpace(0),
      Child, Label1(TextSticky),
      Child, dcd->dcd_Sticky =
       MakeCheckmark(dcd->dcd_Flags & DATA_DOCKF_STICKY, HelpSticky),
      Child, HSpace(0),
      Child, HSpace(0),
      Child, HSpace(0),
      Child, Label1(TextImages),
      Child, dcd->dcd_Images =
       MakeCheckmark(dcd->dcd_Flags & DATA_DOCKF_IMAGES, HelpImages),
      Child, HSpace(0),
      Child, Label1(TextText),
      Child, dcd->dcd_Text =
       MakeCheckmark(dcd->dcd_Flags & DATA_DOCKF_TEXT, HelpText),
     End,
    End) {

  DOCK_LOG(LOG1(Dock Area, "0x%08lx", dcd->dcd_Active))

  /* Gadget actions */
  DoMethod(delete,             MUIM_Notify, MUIA_Pressed,  FALSE,
           dcd->dcd_EntryList, 2, MUIM_List_Remove, MUIV_List_Remove_Active);
  DoMethod(dcd->dcd_Centered,  MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
           obj,                1, TMM_Change);
  DoMethod(dcd->dcd_Frontmost, MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
           obj,                1, TMM_Change);
  DoMethod(dcd->dcd_Text,      MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
           obj,                1, TMM_Change);

  /* List actions */
  DoMethod(dcd->dcd_ListView,  MUIM_Notify, MUIA_Listview_DoubleClick, TRUE,
           obj,                1, TMM_DoubleClicked, 0);

  /* Set initial disable states */
  DoMethod(obj, TMM_Change);

  /* Forward method to SuperClass */
  if (DoSuperMethod(cl, obj, TMM_Edit, dcd->dcd_Active)
      == NULL) {

   /* SuperClass failed, delete file area again */
   MUI_DisposeObject(dcd->dcd_Active);
   dcd->dcd_Active = NULL;
  }
 }

 DOCK_LOG(LOG1(Result, "0x%08lx", dcd->dcd_Active))

 /* Return pointer to file area object to indicate success */
 return((ULONG) dcd->dcd_Active);
}

/* Dock class method: TMM_Change */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DockClassChange
static ULONG DockClassChange(Class *cl, Object *obj)
{
 struct DockClassData *dcd = TYPED_INST_DATA(cl, obj);

 DOCK_LOG(LOG0(Entry))

 /* Public screen gadget is disabled when "Frontmost" is selected */
 SetDisabledState(dcd->dcd_PubScreenString,
                  GetCheckmarkState(dcd->dcd_Frontmost, TRUE));

 /* Font gadget is disabled when "Text" is not selected */
 SetDisabledState(dcd->dcd_FontString,
                  !GetCheckmarkState(dcd->dcd_Text, TRUE));

 /* Position icons disabled when "Centered" is selected */
 SetDisabledState(dcd->dcd_Position,
                  GetCheckmarkState(dcd->dcd_Centered, TRUE));

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* Dock class method: TMM_ParseIFF */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DockClassParseIFF
static ULONG DockClassParseIFF(Class *cl, Object *obj,
                               struct TMP_ParseIFF *tmppi)
{
 BOOL rc = FALSE;

 DOCK_LOG(LOG1(Handle, "0x%08lx", tmppi->tmppi_IFFHandle))

 /* Initialize IFF parser */
 if ((PropChunks(tmppi->tmppi_IFFHandle, PropChunkTable, PROPCHUNKS) == 0) &&
     (CollectionChunk(tmppi->tmppi_IFFHandle, ID_TMDO, ID_ENTR) == 0) &&
     (StopOnExit(tmppi->tmppi_IFFHandle, ID_TMDO, ID_FORM) == 0) &&
     (ParseIFF(tmppi->tmppi_IFFHandle, IFFPARSE_SCAN) == IFFERR_EOC)) {
  struct StoredProperty *spname;

  DOCK_LOG(LOG0(FORM TMDO chunk parsed OK))

  /* Check for mandatory NAME property */
  if (spname = FindProp(tmppi->tmppi_IFFHandle, ID_TMDO, ID_NAME)) {
   struct StoredProperty *spdata;

   DOCK_LOG(LOG2(Name, "%s (0x%08lx)", spname->sp_Data, spname->sp_Data))

   /* Check for mandatory DATA property */
   if (spdata = FindProp(tmppi->tmppi_IFFHandle, ID_TMDO, ID_DATA)) {
    struct DockClassData *dcd = TYPED_INST_DATA(cl, obj);
    struct DockDATAChunk *ddc = spdata->sp_Data;

    DOCK_LOG(LOG5(Data1, "ID 0x%08lx Flags 0x%08lx X %ld Y %ld Cols %ld",
                  ddc->ddc_Standard.sdc_ID, ddc->ddc_Standard.sdc_Flags,
                  ddc->ddc_LeftEdge, ddc->ddc_TopEdge, ddc->ddc_Columns))
    DOCK_LOG(LOG3(Data2, "Font YSize %ld Style 0x%02lx Flags 0x%02lx",
                  ddc->ddc_FontYSize, ddc->ddc_FontStyle, ddc->ddc_FontFlags))

    /* Set new name and ID */
    SetAttrs(obj, TMA_Name, spname->sp_Data,
                  TMA_ID,   ddc->ddc_Standard.sdc_ID,
                  TAG_DONE);

    /* Copy values from data chunk */
    dcd->dcd_Flags    = ddc->ddc_Standard.sdc_Flags & DATA_DOCKF_MASK;
    dcd->dcd_LeftEdge = ddc->ddc_LeftEdge;
    dcd->dcd_TopEdge  = ddc->ddc_TopEdge;
    dcd->dcd_Columns  = ddc->ddc_Columns;

    /* Sanity check */
    if (dcd->dcd_Columns == 0) dcd->dcd_Columns = 1;

    /* Get string values */
    dcd->dcd_HotKey    = ReadStringProperty(tmppi->tmppi_IFFHandle, ID_TMDO,
                                            ID_HKEY);
    dcd->dcd_PubScreen = ReadStringProperty(tmppi->tmppi_IFFHandle, ID_TMDO,
                                            ID_PSCR);

    /* Retrieve font name */
    if (spdata = FindProp(tmppi->tmppi_IFFHandle, ID_TMDO, ID_FONT)) {
     LONG len = strlen(spdata->sp_Data) - 5;

     DOCK_LOG(LOG2(Font, "%s (0x%08lx)", spdata->sp_Data, spdata->sp_Data))

     /* Allocate memory for string: name - ".font" + '/' + 5 digits + '\0' */
     if ((len > 0) && (dcd->dcd_Font = GetVector(len + 7))) {
      char  *cp     = dcd->dcd_Font;
      ULONG  height = ddc->ddc_FontYSize;
      ULONG  div    = 10000;
      BOOL   in     = FALSE;

      /* Copy name, but strip the trailing ".font" */
      strncpy(cp, spdata->sp_Data, len);
      cp += len;

      /* Add separator */
      *cp++ = '/';

      /* Sanity check */
      if (height == 0) height = 1;

      /* Convert number */
      while (div > 0) {
       char digit = (height / div) + '0';

       /* Suppress leading zeros */
       if (in || (digit != '0')) {

        /* Copy digit */
        *cp++ = digit;

        /* In number */
        in = TRUE;
       }

       /* Next digit */
       height %= div;
       div    /= 10;
      }

      /* Add string terminator */
      *cp = '\0';

      DOCK_LOG(LOG2(Font String, "%s (0x%08lx)", dcd->dcd_Font, dcd->dcd_Font))
     }
    }

    /* Read dock entries */
    ReadDockEntries(tmppi->tmppi_IFFHandle, &dcd->dcd_Entries, obj,
                    tmppi->tmppi_Lists);

    /* All OK */
    rc = TRUE;
   }
  }
 }

 DOCK_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Dock class method: TMM_WriteIFF */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DockClassWriteIFF
static ULONG DockClassWriteIFF(Class *cl, Object *obj,
                               struct TMP_WriteIFF *tmpwi)
{
 struct DockClassData *dcd  = TYPED_INST_DATA(cl, obj);
 struct DockDATAChunk  ddc;
 char                 *font = NULL;
 BOOL                  rc;

 DOCK_LOG(LOG1(IFFHandle, "0x%08lx", tmpwi->tmpwi_IFFHandle))

 /* Initialize DATA chunk (use object addresses as IDs) */
 ddc.ddc_Standard.sdc_ID    = (ULONG) obj;
 ddc.ddc_Standard.sdc_Flags = dcd->dcd_Flags;
 ddc.ddc_LeftEdge           = dcd->dcd_LeftEdge;
 ddc.ddc_TopEdge            = dcd->dcd_TopEdge;
 ddc.ddc_Columns            = dcd->dcd_Columns;
 ddc.ddc_FontYSize          = 0;
 ddc.ddc_FontStyle          = 0;
 ddc.ddc_FontFlags          = 0;

 /* Analyze font string */
 if (dcd->dcd_Font) {
  char *cp;

  /* Search separator and extract font height */
  if ((cp = strchr(dcd->dcd_Font, '/')) &&
      (ddc.ddc_FontYSize = strtol(cp + 1, NULL, 10))) {
   ULONG len = cp - dcd->dcd_Font;

   /* Allocate string for font name */
   if (font = GetVector(len + sizeof(".font"))) {

    /* Copy font name */
    strncpy(font, dcd->dcd_Font, len);

    /* Append ".font" */
    strcpy(font + len, ".font");

    DOCK_LOG(LOG2(Font name, "%s (0x%08lx)", font, font))
   }
  }
 }

 /* a) Forward message to SuperClass first */
 /* b) Push DATA chunk                     */
 /* c) Push HKEY chunk                     */
 /* d) Push FONT chunk                     */
 /* e) Push PSCR chunk                     */
 /* f) Push ENTR chunks                    */
 rc = DoSuperMethodA(cl, obj, (Msg) tmpwi) &&
      WriteProperty(tmpwi->tmpwi_IFFHandle, ID_DATA, &ddc,
                    sizeof(struct DockDATAChunk))                           &&
      WriteStringProperty(tmpwi->tmpwi_IFFHandle, ID_HKEY, dcd->dcd_HotKey) &&
      WriteStringProperty(tmpwi->tmpwi_IFFHandle, ID_FONT, font)            &&
      ((dcd->dcd_Flags & DATA_DOCKF_FRONTMOST) ||
       WriteStringProperty(tmpwi->tmpwi_IFFHandle, ID_PSCR,
                           dcd->dcd_PubScreen))                             &&
       WriteDockEntries(tmpwi->tmpwi_IFFHandle, &dcd->dcd_Entries);

 /* Free font string */
 if (font) FreeVector(font);

 DOCK_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Dock class method: TMM_WBArg */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DockClassWBArg
static ULONG DockClassWBArg(Class *cl, Object *obj, struct TMP_WBArg *tmpwa)
{
 struct DockClassData *dcd  = TYPED_INST_DATA(cl, obj);
 char                 *name = tmpwa->tmpwa_Argument->wa_Name;
 ULONG                 rc   = 0;

 DOCK_LOG(LOG2(Name, "%s (0x%08lx)", name, name))

 /* Edit active and icon name valid? */
 if (dcd->dcd_Active && name && (*name != '\0')) {

  DOCK_LOG(LOG0(Edit active))

  /* Yes, forward message to EntryList */
  rc = DoMethodA(dcd->dcd_EntryList, (Msg) tmpwa);
 }

 DOCK_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}

/* Dock class method: TMM_DoubleClicked */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DockClassDoubleClicked
static ULONG DockClassDoubleClicked(Class *cl, Object *obj)
{
 struct DockClassData *dcd    = TYPED_INST_DATA(cl, obj);
 ULONG                 column;

 DOCK_LOG(LOG0(Entry))

 /* Get column from list view */
 GetAttr(MUIA_Listview_ClickColumn, dcd->dcd_ListView, &column);

 DOCK_LOG(LOG1(Column, "%ld", column))

 /* Call column method on entry list */
 DoMethod(dcd->dcd_EntryList, TMM_Column, column);

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* Dock class method dispatcher */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DockClassDispatcher
__geta4 static ULONG DockClassDispatcher(__a0 Class *cl, __a2 Object *obj,
                                         __a1 Msg msg)
{
 ULONG rc;

 DOCK_LOG(LOG3(Arguments, "Class 0x%08lx Object 0x%08lx Msg 0x%08lx",
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
  case TMM_Finish:
   rc = DockClassFinish(cl, obj, (struct TMP_Finish *) msg);
   break;

  case TMM_Notify:
   rc = DockClassNotify(cl, obj, (struct TMP_Notify *) msg);
   break;

  case TMM_Edit:
   rc = DockClassEdit(cl, obj, (struct TMP_Edit *) msg);
   break;

  case TMM_Change:
   rc = DockClassChange(cl, obj);
   break;

  case TMM_ParseIFF:
   rc = DockClassParseIFF(cl, obj, (struct TMP_ParseIFF *) msg);
   break;

  case TMM_WriteIFF:
   rc = DockClassWriteIFF(cl, obj, (struct TMP_WriteIFF *) msg);
   break;

  case TMM_WBArg:
   rc = DockClassWBArg(cl, obj, (struct TMP_WBArg *) msg);
   break;

  case TMM_DoubleClicked:
   rc = DockClassDoubleClicked(cl, obj);
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
struct MUI_CustomClass *CreateDockClass(void)
{
 struct MUI_CustomClass *rc;

 /* Create class */
 if (rc = MUI_CreateCustomClass(NULL, NULL, BaseClass,
                                sizeof(struct DockClassData),
                                DockClassDispatcher)) {

  /* Localize strings */
  TextTitle        = TranslateString(LOCALE_TEXT_DOCK_TITLE_STR,
                                     LOCALE_TEXT_DOCK_TITLE);
  HelpHotKey       = TranslateString(LOCALE_HELP_DOCK_HOTKEY_STR,
                                     LOCALE_HELP_DOCK_HOTKEY);
  HelpPublicScreen = TranslateString(LOCALE_HELP_DOCK_PUBLIC_SCREEN_STR,
                                     LOCALE_HELP_DOCK_PUBLIC_SCREEN);
  HelpPosition     = TranslateString(LOCALE_HELP_DOCK_POSITION_STR,
                                     LOCALE_HELP_DOCK_POSITION);
  TextFont         = TranslateString(LOCALE_TEXT_DOCK_FONT_STR,
                                     LOCALE_TEXT_DOCK_FONT);
  HelpFont         = TranslateString(LOCALE_HELP_DOCK_FONT_STR,
                                     LOCALE_HELP_DOCK_FONT);
  TextColumns      = TranslateString(LOCALE_TEXT_DOCK_COLUMNS_STR,
                                     LOCALE_TEXT_DOCK_COLUMNS);
  HelpColumns      = TranslateString(LOCALE_HELP_DOCK_COLUMNS_STR,
                                     LOCALE_HELP_DOCK_COLUMNS);
  TextActivated    = TranslateString(LOCALE_TEXT_DOCK_ACTIVATED_STR,
                                     LOCALE_TEXT_DOCK_ACTIVATED);
  HelpActivated    = TranslateString(LOCALE_HELP_DOCK_ACTIVATED_STR,
                                     LOCALE_HELP_DOCK_ACTIVATED);
  TextBackdrop     = TranslateString(LOCALE_TEXT_DOCK_BACKDROP_STR,
                                     LOCALE_TEXT_DOCK_BACKDROP);
  HelpBackdrop     = TranslateString(LOCALE_HELP_DOCK_BACKDROP_STR,
                                     LOCALE_HELP_DOCK_BACKDROP);
  TextBorder       = TranslateString(LOCALE_TEXT_DOCK_BORDER_STR,
                                     LOCALE_TEXT_DOCK_BORDER);
  HelpBorder       = TranslateString(LOCALE_HELP_DOCK_BORDER_STR,
                                     LOCALE_HELP_DOCK_BORDER);
  TextCentered     = TranslateString(LOCALE_TEXT_DOCK_CENTERED_STR,
                                     LOCALE_TEXT_DOCK_CENTERED);
  HelpCentered     = TranslateString(LOCALE_HELP_DOCK_CENTERED_STR,
                                     LOCALE_HELP_DOCK_CENTERED);
  TextFrontmost    = TranslateString(LOCALE_TEXT_DOCK_FRONTMOST_STR,
                                     LOCALE_TEXT_DOCK_FRONTMOST);
  HelpFrontmost    = TranslateString(LOCALE_HELP_DOCK_FRONTMOST_STR,
                                     LOCALE_HELP_DOCK_FRONTMOST);
  TextImages       = TranslateString(LOCALE_TEXT_DOCK_IMAGES_STR,
                                     LOCALE_TEXT_DOCK_IMAGES);
  HelpImages       = TranslateString(LOCALE_HELP_DOCK_IMAGES_STR,
                                     LOCALE_HELP_DOCK_IMAGES);
  TextMenu         = TranslateString(LOCALE_TEXT_DOCK_MENU_STR,
                                     LOCALE_TEXT_DOCK_MENU);
  HelpMenu         = TranslateString(LOCALE_HELP_DOCK_MENU_STR,
                                     LOCALE_HELP_DOCK_MENU);
  TextPopup        = TranslateString(LOCALE_TEXT_DOCK_POPUP_STR,
                                     LOCALE_TEXT_DOCK_POPUP);
  HelpPopup        = TranslateString(LOCALE_HELP_DOCK_POPUP_STR,
                                     LOCALE_HELP_DOCK_POPUP);
  TextSticky       = TranslateString(LOCALE_TEXT_DOCK_STICKY_STR,
                                     LOCALE_TEXT_DOCK_STICKY);
  HelpSticky       = TranslateString(LOCALE_HELP_DOCK_STICKY_STR,
                                     LOCALE_HELP_DOCK_STICKY);
  TextText         = TranslateString(LOCALE_TEXT_DOCK_TEXT_STR,
                                     LOCALE_TEXT_DOCK_TEXT);
  HelpText         = TranslateString(LOCALE_HELP_DOCK_TEXT_STR,
                                     LOCALE_HELP_DOCK_TEXT);
  TextEntries      = TranslateString(LOCALE_TEXT_DOCK_ENTRIES_STR,
                                     LOCALE_TEXT_DOCK_ENTRIES);
  HelpEntries      = TranslateString(LOCALE_HELP_DOCK_ENTRIES_STR,
                                     LOCALE_HELP_DOCK_ENTRIES);
  TextSelectFont   = TranslateString(LOCALE_TEXT_DOCK_SELECT_FONT_STR,
                                     LOCALE_TEXT_DOCK_SELECT_FONT);
 }

 DOCK_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}
