/*
 * global.c  V3.1
 *
 * ToolManager global settings
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
#define PROPCHUNKS 3
static const ULONG PropChunksTable[2 * PROPCHUNKS] = {
 ID_TMGP, ID_DATA,
 ID_TMGP, ID_CDIR,
 ID_TMGP, ID_CMND
};
static const char *TextTitle;
static const char *HelpDirectory;
static const char *TextPreferences;
static const char *HelpPreferences;
static const char *TextNetwork;
static const char *HelpNetwork;
static const char *TextRemap;
static const char *HelpRemap;
static const char *TextRemapPrecision;
static const char *HelpRemapPrecision;
static const char *TextPrecisionTypes[DATA_GLOBAL_PRECISION_MAX + 1];
static Object     *Window          = NULL;
static char       *GlobalDirectory = NULL;
static char       *GlobalCommand   = NULL;
static ULONG       GlobalFlags     = DATA_GLOBALF_REMAPENABLE;
static ULONG       GlobalPrecision = DATA_GLOBAL_PRECISION_DEFAULT;

/* Global class instance data */
struct GlobalClassData {
 Object *gcd_Directory;
 Object *gcd_Command;
 Object *gcd_Network;
 Object *gcd_Remap;
 Object *gcd_Precision;
};
#define TYPED_INST_DATA(cl, o) ((struct GlobalClassData *) INST_DATA((cl), (o)))

/* Read global configuration data */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ParseGlobalIFF
BOOL ParseGlobalIFF(struct IFFHandle *iffh)
{
 BOOL rc = FALSE;

 if ((PropChunks(iffh, PropChunksTable, PROPCHUNKS) == 0) &&
     (StopOnExit(iffh, ID_TMGP, ID_FORM) == 0)  &&
     (ParseIFF(iffh, IFFPARSE_SCAN) == IFFERR_EOC)) {
  struct StoredProperty *sp;

  GLOBAL_LOG(LOG0(FORM TMGP chunk parsed OK))

  /* Get DATA chunk */
  if (sp = FindProp(iffh, ID_TMGP, ID_DATA)) {
   struct GlobalDATAChunk *gdc = (struct GlobalDATAChunk *) sp->sp_Data;

   GLOBAL_LOG(LOG2(Data, "Flags 0x%08lx Precision %ld", gdc->gdc_Flags,
                   gdc->gdc_Precision))

   /* Copy data */
   GlobalFlags     = gdc->gdc_Flags & DATA_GLOBALF_MASK;
   GlobalPrecision = gdc->gdc_Precision;

   /* Sanity Check */
   if (GlobalPrecision >= DATA_GLOBAL_PRECISION_MAX)
    GlobalPrecision = DATA_GLOBAL_PRECISION_DEFAULT;
  }

  /* Get string values */
  GlobalDirectory = ReadStringProperty(iffh, ID_TMGP, ID_CDIR);
  GlobalCommand   = ReadStringProperty(iffh, ID_TMGP, ID_CMND);

  /* Chunk OK */
  rc = TRUE;
 }

 GLOBAL_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Write global configuration data */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION WriteGlobalIFF
BOOL WriteGlobalIFF(struct IFFHandle *iffh)
{
 struct GlobalDATAChunk gdc;

 /* Initialize DATA chunk */
 gdc.gdc_Flags     = GlobalFlags;
 gdc.gdc_Precision = GlobalPrecision;

 BOOL rc = (PushChunk(iffh, ID_TMGP, ID_FORM, IFFSIZE_UNKNOWN) == 0) &&
           WriteProperty(iffh, ID_DATA, &gdc,
                         sizeof(struct GlobalDATAChunk))             &&
           WriteStringProperty(iffh, ID_CDIR, GlobalDirectory)       &&
           WriteStringProperty(iffh, ID_CMND, GlobalCommand)         &&
           (PopChunk(iffh) == 0);

 GLOBAL_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Free global data */
void FreeGlobalData(void)
{
 /* Free strings */
 if (GlobalDirectory) FreeVector(GlobalDirectory);
 if (GlobalCommand)   FreeVector(GlobalCommand);
}

/* Global class method: OM_NEW */
#define DEBUGFUNCTION GlobalClassNew
static ULONG GlobalClassNew(Class *cl, Object *obj, struct opSet *ops)
{
 Object *Directory;
 Object *Command;
 Object *Network;
 Object *Remap;
 Object *Precision;
 Object *Use;
 Object *Cancel;

 GLOBAL_LOG((LOG1(Tags, "0x%08lx", ops->ops_AttrList),
             PrintTagList(ops->ops_AttrList)))

 /* Create object */
 if (obj = (Object *) DoSuperNew(cl, obj,
          MUIA_Window_Title, TextTitle,
          MUIA_Window_ID,    MAKE_ID('G','L','O','B'),
          WindowContents,    VGroup,
           Child, ColGroup(2),
            Child, Label2(TextGlobalDirectory),
            Child, Directory = TMPopFile(TextGlobalSelectDir, GlobalDirectory,
                                         LENGTH_FILENAME, HelpDirectory),
             ASLFR_DrawersOnly, TRUE,
            End,
            Child, Label2(TextPreferences),
            Child, Command   = TMPopFile(TextGlobalSelectCmd, GlobalCommand,
                                         LENGTH_FILENAME, HelpPreferences),
            End,
           End,
           Child, ColGroup(2),
            Child, Label1(TextNetwork),
            Child, Network =
             MakeCheckmark(GlobalFlags & DATA_GLOBALF_NETWORKENABLE,
                           HelpNetwork),
            Child, Label1(TextRemap),
            Child, Remap =
             MakeCheckmark(GlobalFlags & DATA_GLOBALF_REMAPENABLE,
                           HelpRemap),
            Child, Label2(TextRemapPrecision),
            Child, Precision = CycleObject,
             MUIA_Cycle_Entries, TextPrecisionTypes,
             MUIA_Cycle_Active,  GlobalPrecision,
             MUIA_CycleChain,    TRUE,
             MUIA_ShortHelp,     HelpRemapPrecision,
            End,
           End,
           Child, HGroup,
            Child, Use    = MakeButton(TextGlobalUse,    HelpGlobalUse),
            Child, HSpace(0),
            Child, Cancel = MakeButton(TextGlobalCancel, HelpGlobalCancel),
           End,
          End,
          MUIA_HelpNode,     "GlobalWindow",
          TAG_MORE,          ops->ops_AttrList)) {
  struct GlobalClassData *gcd = TYPED_INST_DATA(cl, obj);

  /* Initialize instance data */
  gcd->gcd_Directory = Directory;
  gcd->gcd_Command   = Command;
  gcd->gcd_Network   = Network;
  gcd->gcd_Remap     = Remap;
  gcd->gcd_Precision = Precision;

  /* Close window action */
  DoMethod(obj,    MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
           MUIV_Notify_Application, 4, MUIM_Application_PushMethod,
           obj, 2, TMM_Finish, TMV_Finish_Cancel);

  /* Gadget actions */
  DoMethod(gcd->gcd_Remap, MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
           obj, 1, TMM_Change);

  /* Button actions */
  DoMethod(Use,    MUIM_Notify, MUIA_Pressed, FALSE,
           MUIV_Notify_Application, 5, MUIM_Application_PushMethod,
           obj, 2, TMM_Finish, TMV_Finish_Use);
  DoMethod(Cancel, MUIM_Notify, MUIA_Pressed, FALSE,
           MUIV_Notify_Application, 5, MUIM_Application_PushMethod,
           obj, 2, TMM_Finish, TMV_Finish_Cancel);

  /* Set initial disable states */
  DoMethod(obj, TMM_Change);
 }

 GLOBAL_LOG(LOG1(Result, "0x%08lx", obj))

 /* Return pointer to created object */
 return((ULONG) obj);
}

/* Global class method: TMM_Finish */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION GlobalClassFinish
static ULONG GlobalClassFinish(Class *cl, Object *obj,
                                   struct TMP_Finish *tmpf)
{
 /* Close window */
 SetAttrs(obj, MUIA_Window_Open, FALSE, TAG_DONE);

 /* Use new global settings? */
 if (tmpf->tmpf_Type == TMV_Finish_Use) {
  struct GlobalClassData *gcd = TYPED_INST_DATA(cl, obj);

  /* Get new string contents */
  GlobalDirectory = GetStringContents(gcd->gcd_Directory, GlobalDirectory);
  GlobalCommand   = GetStringContents(gcd->gcd_Command, GlobalCommand);

  /* Get new flag states */
  GlobalFlags = GetCheckmarkState(gcd->gcd_Network,
                                  DATA_GLOBALF_NETWORKENABLE) |
                GetCheckmarkState(gcd->gcd_Remap,
                                  DATA_GLOBALF_REMAPENABLE);

  /* Get new precision type */
  GetAttr(MUIA_Cycle_Active, gcd->gcd_Precision, &GlobalPrecision);
 }

 /* Remove window from application */
 DoMethod(_app(obj), OM_REMMEMBER, obj);

 /* Dispose object */
 MUI_DisposeObject(obj);

 /* Clear global window pointer */
 Window = NULL;

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* Global class method: TMM_Change */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION GlobalClassChange
static ULONG GlobalClassChange(Class *cl, Object *obj)
{
 struct GlobalClassData *gcd = TYPED_INST_DATA(cl, obj);

 GLOBAL_LOG(LOG0(Entry))

 /* Precision cycle gadget is disabled if remap is disabled */
 SetDisabledState(gcd->gcd_Precision,
                  !GetCheckmarkState(gcd->gcd_Remap, TRUE));

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* Global class method dispatcher */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION GlobalClassDispatcher
__geta4 static ULONG GlobalClassDispatcher(__a0 Class *cl, __a2 Object *obj,
                                           __a1 Msg msg)
{
 ULONG rc;

 GLOBAL_LOG(LOG3(Arguments, "Class 0x%08lx Object 0x%08lx Msg 0x%08lx",
                 cl, obj, msg))

 switch(msg->MethodID) {
  /* BOOPSI methods */
  case OM_NEW:
   rc = GlobalClassNew(cl, obj, (struct opSet *) msg);
   break;

  /* TM methods */
  case TMM_Finish:
   rc = GlobalClassFinish(cl, obj, (struct TMP_Finish *) msg);
   break;

  case TMM_Change:
   rc = GlobalClassChange(cl, obj);
   break;

  /* Unknown method -> delegate to SuperClass */
  default:
   rc = DoSuperMethodA(cl, obj, msg);
   break;
 }

 return(rc);
}

/* Create Global class */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CreateGlobalClass
struct MUI_CustomClass *CreateGlobalClass(void)
{
 struct MUI_CustomClass *rc;

 /* Create class */
 if (rc = MUI_CreateCustomClass(NULL, MUIC_Window, NULL,
                                sizeof(struct GlobalClassData),
                                GlobalClassDispatcher)) {

  /* Localize strings */
  TextTitle             = TranslateString(
                                       LOCALE_TEXT_GLOBAL_WINDOW_TITLE_STR,
                                       LOCALE_TEXT_GLOBAL_WINDOW_TITLE);
  HelpDirectory         = TranslateString(
                                       LOCALE_HELP_GLOBAL_DIRECTORY_STR,
                                       LOCALE_HELP_GLOBAL_DIRECTORY);
  TextPreferences       = TranslateString(
                                       LOCALE_TEXT_GLOBAL_PREFERENCES_STR,
                                       LOCALE_TEXT_GLOBAL_PREFERENCES);
  HelpPreferences       = TranslateString(
                                       LOCALE_HELP_GLOBAL_PREFERENCES_STR,
                                       LOCALE_HELP_GLOBAL_PREFERENCES);
  TextNetwork           = TranslateString(
                                       LOCALE_TEXT_GLOBAL_NETWORK_STR,
                                       LOCALE_TEXT_GLOBAL_NETWORK);
  HelpNetwork           = TranslateString(
                                       LOCALE_HELP_GLOBAL_NETWORK_STR,
                                       LOCALE_HELP_GLOBAL_NETWORK);
  TextRemap             = TranslateString(
                                       LOCALE_TEXT_GLOBAL_REMAP_STR,
                                       LOCALE_TEXT_GLOBAL_REMAP);
  HelpRemap             = TranslateString(
                                       LOCALE_HELP_GLOBAL_REMAP_STR,
                                       LOCALE_HELP_GLOBAL_REMAP);
  TextRemapPrecision    = TranslateString(
                                       LOCALE_TEXT_GLOBAL_REMAP_PRECISION_STR,
                                       LOCALE_TEXT_GLOBAL_REMAP_PRECISION);
  HelpRemapPrecision    = TranslateString(
                                       LOCALE_HELP_GLOBAL_REMAP_PRECISION_STR,
                                       LOCALE_HELP_GLOBAL_REMAP_PRECISION);
  TextPrecisionTypes[0] = TranslateString(
                                       LOCALE_TEXT_GLOBAL_PRECISION_EXACT_STR,
                                       LOCALE_TEXT_GLOBAL_PRECISION_EXACT);
  TextPrecisionTypes[1] = TranslateString(
                                       LOCALE_TEXT_GLOBAL_PRECISION_IMAGES_STR,
                                       LOCALE_TEXT_GLOBAL_PRECISION_IMAGES);
  TextPrecisionTypes[2] = TranslateString(
                                       LOCALE_TEXT_GLOBAL_PRECISION_ICONS_STR,
                                       LOCALE_TEXT_GLOBAL_PRECISION_ICONS);
  TextPrecisionTypes[3] = TranslateString(
                                       LOCALE_TEXT_GLOBAL_PRECISION_GUI_STR,
                                       LOCALE_TEXT_GLOBAL_PRECISION_GUI);
  TextPrecisionTypes[4] = NULL;

 }

 GLOBAL_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}

/* Open global window */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION OpenGlobalWindow
void OpenGlobalWindow(Object *app)
{
 /* Window already open? */
 if (Window) {

  GLOBAL_LOG(LOG0(Move window to front))

  /* Yes, send method to window */
  DoMethod(Window, MUIM_Window_ToFront);

 } else {

  /* No, create global window */
  if (Window = NewObject(GlobalClass->mcc_Class, NULL, NULL)) {
   ULONG opened;

   GLOBAL_LOG(LOG1(Global window, "0x%08lx", Window))

   /* Add window to application */
   DoMethod(app, OM_ADDMEMBER, Window);

   /* Open main window */
   SetAttrs(Window, MUIA_Window_Open, TRUE, TAG_DONE);

   /* Get window open status */
   GetAttr(MUIA_Window_Open, Window, &opened);

   /* Window open? */
   if (opened == FALSE) {

    GLOBAL_LOG(LOG0(Could not open global window))

    /* No, remove window from application */
    DoMethod(app, OM_REMMEMBER, Window);

    /* Dispose window */
    MUI_DisposeObject(Window);

    /* Clear pointer */
    Window = NULL;
   }
  }
 }
}
