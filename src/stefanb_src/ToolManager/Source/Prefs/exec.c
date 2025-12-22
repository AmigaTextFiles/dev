/*
 * exec.c  V3.1
 *
 * TM Exec object class
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
#define PROPCHUNKS 8
static const ULONG PropChunkTable[2 * PROPCHUNKS] = {
 ID_TMEX, ID_CDIR,
 ID_TMEX, ID_CMND,
 ID_TMEX, ID_DATA,
 ID_TMEX, ID_HKEY,
 ID_TMEX, ID_NAME,
 ID_TMEX, ID_OUTP,
 ID_TMEX, ID_PATH,
 ID_TMEX, ID_PSCR
};
static const char *TextTitle;
static const char *HelpCommand;
static const char *HelpHotKey;
static const char *TextExecType;
static const char *HelpExecType;
static const char *TextExecTypes[TMET_Network - TMET_CLI + 2];
static const char *TextStack;
static const char *HelpStack;
static const char *TextPriority;
static const char *HelpPriority;
static const char *HelpDirectory;
static const char *TextPath;
static const char *HelpPath;
static const char *TextOutput;
static const char *HelpOutput;
static const char *HelpPublicScreen;
static const char *TextArguments;
static const char *HelpArguments;
static const char *TextToFront;
static const char *HelpToFront;

/* For which exec type is which data valid? */
#define VALIDF_POPBUTTON 0x01
#define VALIDF_STACK     0x02
#define VALIDF_PRIORITY  0x04
#define VALIDF_ARGUMENTS 0x08
#define VALIDF_DIRECTORY 0x10
#define VALIDF_PATH      0x20
#define VALIDF_OUTPUT    0x40
static const ULONG NotValidMasks[TMET_Network - TMET_CLI + 1] = {
 /* CLI */     ~(VALIDF_POPBUTTON | VALIDF_STACK     | VALIDF_PRIORITY |
                 VALIDF_ARGUMENTS | VALIDF_DIRECTORY | VALIDF_PATH     |
                 VALIDF_OUTPUT),
 /* WB */      ~(VALIDF_POPBUTTON | VALIDF_STACK     | VALIDF_PRIORITY |
                 VALIDF_ARGUMENTS | VALIDF_DIRECTORY | 0               |
                 0),
 /* ARexx */   ~(VALIDF_POPBUTTON | 0                | 0               |
                 VALIDF_ARGUMENTS | VALIDF_DIRECTORY | 0               |
                 0),
 /* Dock */    ~(0                | 0                | 0               |
                 0                | 0                | 0               |
                 0),
 /* HotKey */  ~(0                | 0                | 0               |
                 0                | 0                | 0               |
                 0),
 /* Network */ ~(0                | 0                | 0               |
                 0                | 0                | 0               |
                 0)
};

/* Exec class instance data */
struct ExecClassData {
 ULONG       ecd_Flags;
 ULONG       ecd_ExecType;
 ULONG       ecd_Stack;
 LONG        ecd_Priority;
 const char *ecd_Command;
 const char *ecd_HotKey;
 const char *ecd_Directory;
 const char *ecd_Path;
 const char *ecd_Output;
 const char *ecd_PubScreen;
 Object     *ecd_Active;
 Object     *ecd_TypeCycle;
 Object     *ecd_CmdString;
 Object     *ecd_HotKeyString;
 Object     *ecd_StackInteger;
 Object     *ecd_PriorityNumeric;
 Object     *ecd_DirString;
 Object     *ecd_PathString;
 Object     *ecd_OutputString;
 Object     *ecd_PubScreenString;
 Object     *ecd_Arguments;
 Object     *ecd_ToFront;
};
#define TYPED_INST_DATA(cl, o) ((struct ExecClassData *) INST_DATA((cl), (o)))

/* Exec class method: OM_NEW */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ExecClassNew
static ULONG ExecClassNew(Class *cl, Object *obj, struct opSet *ops)
{
 EXEC_LOG((LOG1(Tags, "0x%08lx", ops->ops_AttrList),
           PrintTagList(ops->ops_AttrList)))

 /* Create object */
 if (obj = (Object *) DoSuperNew(cl, obj,
                                       MUIA_Window_Title, TextTitle,
                                       MUIA_HelpNode,     "ExecWindow",
                                       TMA_Type,          TMOBJTYPE_EXEC,
                                       TAG_MORE,          ops->ops_AttrList)) {
  struct ExecClassData *ecd = TYPED_INST_DATA(cl, obj);

  /* Initialize instance data */
  ecd->ecd_Flags     = DATA_EXECF_ARGUMENTS;
  ecd->ecd_ExecType  = TMET_CLI;
  ecd->ecd_Stack     = 4096;
  ecd->ecd_Priority  = 0;
  ecd->ecd_Command   = NULL;
  ecd->ecd_HotKey    = NULL;
  ecd->ecd_Directory = NULL;
  ecd->ecd_Path      = NULL;
  ecd->ecd_Output    = NULL;
  ecd->ecd_PubScreen = NULL;
  ecd->ecd_Active    = NULL;
 }

 EXEC_LOG(LOG1(Result, "0x%08lx", obj))

 /* Return pointer to created object */
 return((ULONG) obj);
}

/* Exec class method: OM_DISPOSE */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ExecClassDispose
static ULONG ExecClassDispose(Class *cl, Object *obj, Msg msg)
{
 struct ExecClassData *ecd = TYPED_INST_DATA(cl, obj);

 EXEC_LOG(LOG1(Disposing, "0x%08lx", obj))

 /* Free instance data */
 if (ecd->ecd_Command)   FreeVector(ecd->ecd_Command);
 if (ecd->ecd_HotKey)    FreeVector(ecd->ecd_HotKey);
 if (ecd->ecd_Directory) FreeVector(ecd->ecd_Directory);
 if (ecd->ecd_Path)      FreeVector(ecd->ecd_Path);
 if (ecd->ecd_Output)    FreeVector(ecd->ecd_Output);
 if (ecd->ecd_PubScreen) FreeVector(ecd->ecd_PubScreen);

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, msg));
}

/* Exec class method: TMM_Finish */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ExecClassFinish
static ULONG ExecClassFinish(Class *cl, Object *obj, struct TMP_Finish *tmpf)
{
 struct ExecClassData *ecd = TYPED_INST_DATA(cl, obj);

 EXEC_LOG(LOG1(Type, "%ld", tmpf->tmpf_Type))

 /* MUI objects allocated? */
 if (ecd->ecd_Active) {

  /* Use or Cancel? */
  if (tmpf->tmpf_Type == TMV_Finish_Use) {

   /* Get new exec type */
   GetAttr(MUIA_Cycle_Active, ecd->ecd_TypeCycle, &ecd->ecd_ExecType);

   /* Get new string contents */
   ecd->ecd_Command   = GetStringContents(ecd->ecd_CmdString,
                                          ecd->ecd_Command);
   ecd->ecd_HotKey    = GetStringContents(ecd->ecd_HotKeyString,
                                          ecd->ecd_HotKey);
   ecd->ecd_Directory = GetStringContents(ecd->ecd_DirString,
                                          ecd->ecd_Directory);
   ecd->ecd_Path      = GetStringContents(ecd->ecd_PathString,
                                          ecd->ecd_Path);
   ecd->ecd_Output    = GetStringContents(ecd->ecd_OutputString,
                                          ecd->ecd_Output);
   ecd->ecd_PubScreen = GetStringContents(ecd->ecd_PubScreenString,
                                          ecd->ecd_PubScreen);

   /* Get new numeric values */
   GetAttr(MUIA_String_Integer, ecd->ecd_StackInteger,    &ecd->ecd_Stack);
   GetAttr(MUIA_Numeric_Value,  ecd->ecd_PriorityNumeric, &ecd->ecd_Priority);

   /* Get new flag states */
   ecd->ecd_Flags = GetCheckmarkState(ecd->ecd_Arguments,
                                      DATA_EXECF_ARGUMENTS) |
                    GetCheckmarkState(ecd->ecd_ToFront,
                                      DATA_EXECF_TOFRONT);
  }

  /* Reset pointer to file name area */
  ecd->ecd_Active = NULL;
 }

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, (Msg) tmpf));
}

/* Exec class method: TMM_Edit */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ExecClassEdit
static ULONG ExecClassEdit(Class *cl, Object *obj, struct TMP_Edit *tmpe)
{
 struct ExecClassData *ecd = TYPED_INST_DATA(cl, obj);

 /* MUI objects allocated? */
 if (ecd->ecd_Active) {

  EXEC_LOG(LOG0(Object already active))

  /* Yes, forward method to SuperClass */
  DoSuperMethodA(cl, obj, (Msg) tmpe);

 /* No, create object edit area */
 } else if (ecd->ecd_Active =
    VGroup,
     Child, ColGroup(2),
      Child, Label2(TextExecType),
      Child, ecd->ecd_TypeCycle    = CycleObject,
       MUIA_Cycle_Entries, TextExecTypes,
       MUIA_Cycle_Active,  ecd->ecd_ExecType,
       MUIA_CycleChain,    TRUE,
       MUIA_ShortHelp,     HelpExecType,
      End,
      Child, Label2(TextGlobalCommand),
      Child, ecd->ecd_CmdString    = TMPopFile(TextGlobalSelectCmd,
                                               ecd->ecd_Command,
                                               LENGTH_FILENAME, HelpCommand),
      End,
      Child, Label2(TextGlobalHotKey),
      Child, ecd->ecd_HotKeyString = TMPopHotKey(ecd->ecd_HotKey, HelpHotKey),
      End,
      Child, Label2(TextStack),
      Child, ecd->ecd_StackInteger = TMInteger(ecd->ecd_Stack, HelpStack),
     End,
     Child, HGroup,
      Child, Label1(TextPriority),
      Child, ecd->ecd_PriorityNumeric = NumericbuttonObject,
       MUIA_Numeric_Min,   -128,
       MUIA_Numeric_Max,   127,
       MUIA_Numeric_Value, ecd->ecd_Priority,
       MUIA_CycleChain,    TRUE,
       MUIA_ShortHelp,     HelpPriority,
      End,
      Child, HSpace(0),
      Child, Label1(TextArguments),
      Child, ecd->ecd_Arguments =
       MakeCheckmark(ecd->ecd_Flags & DATA_EXECF_ARGUMENTS, HelpArguments),
      Child, HSpace(0),
      Child, Label1(TextToFront),
      Child, ecd->ecd_ToFront   =
       MakeCheckmark(ecd->ecd_Flags & DATA_EXECF_TOFRONT, HelpToFront),
     End,
     Child, ColGroup(2),
      Child, Label2(TextGlobalDirectory),
      Child, ecd->ecd_DirString       = TMPopFile(TextGlobalSelectDir,
                                                  ecd->ecd_Directory,
                                                  LENGTH_FILENAME,
                                                  HelpDirectory),
       ASLFR_DrawersOnly, TRUE,
      End,
      Child, Label2(TextPath),
      Child, ecd->ecd_PathString      = TMString(ecd->ecd_Path,
                                                 LENGTH_PATH, HelpPath),
      Child, Label2(TextOutput),
      Child, ecd->ecd_OutputString    = TMPopFile(TextGlobalSelectFile,
                                                  ecd->ecd_Output,
                                                  LENGTH_FILENAME, HelpOutput),
      End,
      Child, Label2(TextGlobalPublicScreen),
      Child, ecd->ecd_PubScreenString = TMPopScreen(ecd->ecd_PubScreen,
                                                    HelpPublicScreen),
      End,
     End,
    End) {

  EXEC_LOG(LOG1(Exec Area, "0x%08lx", ecd->ecd_Active))

  /* Gadget actions */
  DoMethod(ecd->ecd_TypeCycle, MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime,
           obj, 1, TMM_Change);
  DoMethod(ecd->ecd_ToFront,   MUIM_Notify, MUIA_Selected,     MUIV_EveryTime,
           obj, 1, TMM_Change);

  /* Set initial disable states */
  DoMethod(obj, TMM_Change);

  /* Forward method to SuperClass */
  if (DoSuperMethod(cl, obj, TMM_Edit, ecd->ecd_Active) == NULL) {

   /* SuperClass failed, delete file area again */
   MUI_DisposeObject(ecd->ecd_Active);
   ecd->ecd_Active = NULL;
  }
 }

 EXEC_LOG(LOG1(Result, "0x%08lx", ecd->ecd_Active))

 /* Return pointer to file area object to indicate success */
 return((ULONG) ecd->ecd_Active);
}

/* Exec class method: TMM_Change */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ExecClassChange
static ULONG ExecClassChange(Class *cl, Object *obj)
{
 struct ExecClassData *ecd = TYPED_INST_DATA(cl, obj);

 EXEC_LOG(LOG0(Entry))

 /* Check exec type */
 {
  ULONG mask;
  ULONG state;

  /* Get state of type cycle gadget */
  GetAttr(MUIA_Cycle_Active, ecd->ecd_TypeCycle, &state);

  /* Get valid mask for exec type */
  mask = NotValidMasks[state];

  /* Set disabled states according to mask */
  SetAttrs(ecd->ecd_CmdString, TMA_ButtonDisabled, mask & VALIDF_POPBUTTON,
                               TAG_DONE);
  SetDisabledState(ecd->ecd_StackInteger,    mask & VALIDF_STACK);
  SetDisabledState(ecd->ecd_PriorityNumeric, mask & VALIDF_PRIORITY);
  SetDisabledState(ecd->ecd_Arguments,       mask & VALIDF_ARGUMENTS);
  SetDisabledState(ecd->ecd_DirString,       mask & VALIDF_DIRECTORY);
  SetDisabledState(ecd->ecd_PathString,      mask & VALIDF_PATH);
  SetDisabledState(ecd->ecd_OutputString,    mask & VALIDF_OUTPUT);
 }

 /* Public screen gadget is enabled when "To Front" is selected */
 SetDisabledState(ecd->ecd_PubScreenString,
                  !GetCheckmarkState(ecd->ecd_ToFront, TRUE));

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* Exec class method: TMM_ParseIFF */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ExecClassParseIFF
static ULONG ExecClassParseIFF(Class *cl, Object *obj,
                               struct TMP_ParseIFF *tmppi)
{
 BOOL rc = FALSE;

 EXEC_LOG(LOG1(Handle, "0x%08lx", tmppi->tmppi_IFFHandle))

 /* Initialize IFF parser */
 if ((PropChunks(tmppi->tmppi_IFFHandle, PropChunkTable, PROPCHUNKS) == 0) &&
     (StopOnExit(tmppi->tmppi_IFFHandle, ID_TMEX, ID_FORM) == 0) &&
     (ParseIFF(tmppi->tmppi_IFFHandle, IFFPARSE_SCAN) == IFFERR_EOC)) {
  struct StoredProperty *spname;

  EXEC_LOG(LOG0(FORM TMEX chunk parsed OK))

  /* Check for mandatory NAME property */
  if (spname = FindProp(tmppi->tmppi_IFFHandle, ID_TMEX, ID_NAME)) {
   struct StoredProperty *spdata;

   EXEC_LOG(LOG2(Name, "%s (0x%08lx)", spname->sp_Data, spname->sp_Data))

   /* Check for mandatory DATA property */
   if (spdata = FindProp(tmppi->tmppi_IFFHandle, ID_TMEX, ID_DATA)) {
    struct ExecClassData *ecd = TYPED_INST_DATA(cl, obj);
    struct ExecDATAChunk *edc = spdata->sp_Data;

    EXEC_LOG(LOG5(Data, "ID 0x%08lx Flags 0x%08lx Type %ld Prio %ld Stack %ld",
                        edc->edc_Standard.sdc_ID, edc->edc_Standard.sdc_Flags,
                        edc->edc_ExecType, edc->edc_Priority, edc->edc_Stack))

    /* Set new name and ID */
    SetAttrs(obj, TMA_Name, spname->sp_Data,
                  TMA_ID,   edc->edc_Standard.sdc_ID,
                  TAG_DONE);

    /* Copy values from data chunk */
    ecd->ecd_Flags    = edc->edc_Standard.sdc_Flags & DATA_EXECF_MASK;
    ecd->ecd_ExecType = edc->edc_ExecType;
    ecd->ecd_Stack    = edc->edc_Stack;
    ecd->ecd_Priority = edc->edc_Priority;

    /* Sanity checks */
    if (ecd->ecd_ExecType > TMET_Network) ecd->ecd_ExecType = TMET_Network;
    if (ecd->ecd_Priority < -128)         ecd->ecd_Priority = -128;
    if (ecd->ecd_Priority >  127)         ecd->ecd_Priority =  127;
    if (ecd->ecd_Stack    == 0)           ecd->ecd_Stack    = 4096;

    /* Get string values */
    ecd->ecd_Command   = ReadStringProperty(tmppi->tmppi_IFFHandle, ID_TMEX,
                                            ID_CMND);
    ecd->ecd_HotKey    = ReadStringProperty(tmppi->tmppi_IFFHandle, ID_TMEX,
                                            ID_HKEY);
    ecd->ecd_Directory = ReadStringProperty(tmppi->tmppi_IFFHandle, ID_TMEX,
                                            ID_CDIR);
    ecd->ecd_Path      = ReadStringProperty(tmppi->tmppi_IFFHandle, ID_TMEX,
                                            ID_PATH);
    ecd->ecd_Output    = ReadStringProperty(tmppi->tmppi_IFFHandle, ID_TMEX,
                                            ID_OUTP);
    ecd->ecd_PubScreen = ReadStringProperty(tmppi->tmppi_IFFHandle, ID_TMEX,
                                            ID_PSCR);

    /* All OK */
    rc = TRUE;
   }
  }
 }

 EXEC_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Exec class method: TMM_WriteIFF */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ExecClassWriteIFF
static ULONG ExecClassWriteIFF(Class *cl, Object *obj,
                               struct TMP_WriteIFF *tmpwi)
{
 struct ExecClassData *ecd  = TYPED_INST_DATA(cl, obj);
 struct ExecDATAChunk  edc;
 ULONG                 mask = NotValidMasks[ecd->ecd_ExecType];
 BOOL                  rc;

 EXEC_LOG(LOG1(IFFHandle, "0x%08lx", tmpwi->tmpwi_IFFHandle))

 /* Initialize DATA chunk */
 edc.edc_Standard.sdc_ID    = (ULONG) obj;      /* Use objects address as ID */
 edc.edc_Standard.sdc_Flags = ecd->ecd_Flags;
 edc.edc_ExecType           = ecd->ecd_ExecType;
 edc.edc_Stack              = ecd->ecd_Stack;
 edc.edc_Priority           = ecd->ecd_Priority;

 /* Check validity of argument flag */
 if (mask & VALIDF_ARGUMENTS)
  edc.edc_Standard.sdc_Flags &= ~(DATA_EXECF_ARGUMENTS);

 /* a) Forward message to SuperClass first */
 /* b) Push DATA chunk                     */
 /* c) Push FILE chunk                     */
 rc = DoSuperMethodA(cl, obj, (Msg) tmpwi)                                   &&
      WriteProperty(tmpwi->tmpwi_IFFHandle, ID_DATA, &edc,
                    sizeof(struct ExecDATAChunk))                            &&
      WriteStringProperty(tmpwi->tmpwi_IFFHandle, ID_CMND, ecd->ecd_Command) &&
      WriteStringProperty(tmpwi->tmpwi_IFFHandle, ID_HKEY, ecd->ecd_HotKey)  &&
      ((mask & VALIDF_DIRECTORY) ||
       WriteStringProperty(tmpwi->tmpwi_IFFHandle, ID_CDIR,
                           ecd->ecd_Directory))                              &&
      ((mask & VALIDF_PATH) ||
       WriteStringProperty(tmpwi->tmpwi_IFFHandle, ID_PATH,
                           ecd->ecd_Path))                                   &&
      ((mask & VALIDF_OUTPUT) ||
       WriteStringProperty(tmpwi->tmpwi_IFFHandle, ID_OUTP,
                           ecd->ecd_Output))                                 &&
      (((ecd->ecd_Flags & DATA_EXECF_TOFRONT) == 0) ||
       WriteStringProperty(tmpwi->tmpwi_IFFHandle, ID_PSCR,
                           ecd->ecd_PubScreen));

 EXEC_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Exec class method: TMM_WBArg */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ExecClassWBArg
static ULONG ExecClassWBArg(Class *cl, Object *obj, struct TMP_WBArg *tmpwa)
{
 ULONG rc;

 EXEC_LOG(LOG1(WBArg, "0x%08lx", tmpwa->tmpwa_Argument))

 /* First forward method to SuperClass */
 if (rc = DoSuperMethodA(cl, obj, (Msg) tmpwa)) {
  struct ExecClassData *ecd = TYPED_INST_DATA(cl, obj);
  struct WBArg         *wa  = tmpwa->tmpwa_Argument;

  EXEC_LOG(LOG0(Set gadget contents))

  /* Yes, set gadget contents */
  SetAttrs(ecd->ecd_TypeCycle, MUIA_Cycle_Active,    TMET_WB,     TAG_DONE);
  SetAttrs(ecd->ecd_CmdString, MUIA_String_Contents, wa->wa_Name, TAG_DONE);

  /* Get stack size from icon */
  {
   struct DiskObject *dobj;
   BPTR               oldcd;

   /* Go to icon directory */
   oldcd = CurrentDir(wa->wa_Lock);

   /* Load icon */
   if (dobj = GetDiskObject(wa->wa_Name)) {

    EXEC_LOG(LOG1(DiskObject, "0x%08lx", dobj))

    /* Tool icon? */
    if (dobj->do_Type == WBTOOL) {

     EXEC_LOG(LOG1(Stack size, "%ld", dobj->do_StackSize))

     /* Yes, get stack size from icon */
     SetAttrs(ecd->ecd_StackInteger, MUIA_String_Integer, dobj->do_StackSize,
                                     TAG_DONE);
    }

    /* Free icon */
    FreeDiskObject(dobj);
   }

   /* Go back to old directory */
   CurrentDir(oldcd);
  }

  /* Get current directory name */
  {
   char *dir;

   /* Allocate memory for buffer */
   if (dir = GetMemory(LENGTH_FILENAME)) {

    EXEC_LOG(LOG1(Buffer, "0x%08lx", dir))

    /* Create name from lock */
    if (NameFromLock(wa->wa_Lock, dir, LENGTH_FILENAME)) {

     EXEC_LOG(LOG1(Directory, "%s", dir))

     /* Set directory gadget contents */
     SetAttrs(ecd->ecd_DirString, MUIA_String_Contents, dir, TAG_DONE);
    }

    /* Free buffer */
    FreeMemory(dir, LENGTH_FILENAME);
   }
  }
 }

 EXEC_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}

/* Exec class method dispatcher */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ExecClassDispatcher
__geta4 static ULONG ExecClassDispatcher(__a0 Class *cl, __a2 Object *obj,
                                         __a1 Msg msg)
{
 ULONG rc;

 EXEC_LOG(LOG3(Arguments, "Class 0x%08lx Object 0x%08lx Msg 0x%08lx",
               cl, obj, msg))

 switch(msg->MethodID) {
  /* BOOPSI methods */
  case OM_NEW:
   rc = ExecClassNew(cl, obj, (struct opSet *) msg);
   break;

  case OM_DISPOSE:
   rc = ExecClassDispose(cl, obj, msg);
   break;

  /* TM methods */
  case TMM_Finish:
   rc = ExecClassFinish(cl, obj, (struct TMP_Finish *) msg);
   break;

  case TMM_Edit:
   rc = ExecClassEdit(cl, obj, (struct TMP_Edit *) msg);
   break;

  case TMM_Change:
   rc = ExecClassChange(cl, obj);
   break;

  case TMM_ParseIFF:
   rc = ExecClassParseIFF(cl, obj, (struct TMP_ParseIFF *) msg);
   break;

  case TMM_WriteIFF:
   rc = ExecClassWriteIFF(cl, obj, (struct TMP_WriteIFF *) msg);
   break;

  case TMM_WBArg:
   rc = ExecClassWBArg(cl, obj, (struct TMP_WBArg *) msg);
   break;

  /* Unknown method -> delegate to SuperClass */
  default:
   rc = DoSuperMethodA(cl, obj, msg);
   break;
 }

 return(rc);
}

/* Create Exec class */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CreateExecClass
struct MUI_CustomClass *CreateExecClass(void)
{
 struct MUI_CustomClass *rc;

 /* Create class */
 if (rc = MUI_CreateCustomClass(NULL, NULL, BaseClass,
                                sizeof(struct ExecClassData),
                                ExecClassDispatcher)) {

  /* Localize strings */
  TextTitle                       = TranslateString(
                                        LOCALE_TEXT_EXEC_TITLE_STR,
                                        LOCALE_TEXT_EXEC_TITLE);
  HelpCommand                     = TranslateString(
                                        LOCALE_HELP_EXEC_COMMAND_STR,
                                        LOCALE_HELP_EXEC_COMMAND);
  TextExecType                    = TranslateString(
                                        LOCALE_TEXT_EXEC_TYPE_STR,
                                        LOCALE_TEXT_EXEC_TYPE);
  HelpExecType                    = TranslateString(
                                        LOCALE_HELP_EXEC_TYPE_STR,
                                        LOCALE_HELP_EXEC_TYPE);
  TextExecTypes[TMET_CLI]         = TranslateString(
                                        LOCALE_TEXT_EXEC_TYPE_SHELL_STR,
                                        LOCALE_TEXT_EXEC_TYPE_SHELL);
  TextExecTypes[TMET_WB]          = TranslateString(
                                        LOCALE_TEXT_EXEC_TYPE_WORKBENCH_STR,
                                        LOCALE_TEXT_EXEC_TYPE_WORKBENCH);
  TextExecTypes[TMET_ARexx]       = TranslateString(
                                        LOCALE_TEXT_EXEC_TYPE_AREXX_STR,
                                        LOCALE_TEXT_EXEC_TYPE_AREXX);
  TextExecTypes[TMET_Dock]        = TextGlobalDock;
  TextExecTypes[TMET_HotKey]      = TextGlobalHotKey;
  TextExecTypes[TMET_Network]     = TranslateString(
                                        LOCALE_TEXT_EXEC_TYPE_NETWORK_STR,
                                        LOCALE_TEXT_EXEC_TYPE_NETWORK);
  TextExecTypes[TMET_Network + 1] = NULL;
  HelpHotKey                      = TranslateString(
                                        LOCALE_HELP_EXEC_HOTKEY_STR,
                                        LOCALE_HELP_EXEC_HOTKEY);
  TextStack                       = TranslateString(
                                        LOCALE_TEXT_EXEC_STACK_STR,
                                        LOCALE_TEXT_EXEC_STACK);
  HelpStack                       = TranslateString(
                                        LOCALE_HELP_EXEC_STACK_STR,
                                        LOCALE_HELP_EXEC_STACK);
  TextPriority                    = TranslateString(
                                        LOCALE_TEXT_EXEC_PRIORITY_STR,
                                        LOCALE_TEXT_EXEC_PRIORITY);
  HelpPriority                    = TranslateString(
                                        LOCALE_HELP_EXEC_PRIORITY_STR,
                                        LOCALE_HELP_EXEC_PRIORITY);
  HelpDirectory                   = TranslateString(
                                        LOCALE_HELP_EXEC_DIRECTORY_STR,
                                        LOCALE_HELP_EXEC_DIRECTORY);
  TextPath                        = TranslateString(
                                        LOCALE_TEXT_EXEC_PATH_STR,
                                        LOCALE_TEXT_EXEC_PATH);
  HelpPath                        = TranslateString(
                                        LOCALE_HELP_EXEC_PATH_STR,
                                        LOCALE_HELP_EXEC_PATH);
  TextOutput                      = TranslateString(
                                        LOCALE_TEXT_EXEC_OUTPUT_FILE_STR,
                                        LOCALE_TEXT_EXEC_OUTPUT_FILE);
  HelpOutput                      = TranslateString(
                                        LOCALE_HELP_EXEC_OUTPUT_FILE_STR,
                                        LOCALE_HELP_EXEC_OUTPUT_FILE);
  HelpPublicScreen                = TranslateString(
                                        LOCALE_HELP_EXEC_PUBLIC_SCREEN_STR,
                                        LOCALE_HELP_EXEC_PUBLIC_SCREEN);
  TextArguments                   = TranslateString(
                                        LOCALE_TEXT_EXEC_ARGUMENTS_STR,
                                        LOCALE_TEXT_EXEC_ARGUMENTS);
  HelpArguments                   = TranslateString(
                                        LOCALE_HELP_EXEC_ARGUMENTS_STR,
                                        LOCALE_HELP_EXEC_ARGUMENTS);
  TextToFront                     = TranslateString(
                                        LOCALE_TEXT_EXEC_TO_FRONT_STR,
                                        LOCALE_TEXT_EXEC_TO_FRONT);
  HelpToFront                     = TranslateString(
                                        LOCALE_HELP_EXEC_TO_FRONT_STR,
                                        LOCALE_HELP_EXEC_TO_FRONT);
 }

 EXEC_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}
