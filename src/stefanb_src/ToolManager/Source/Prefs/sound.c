/*
 * sound.c  V3.1
 *
 * TM Sound object class
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
#define PROPCHUNKS 4
static const ULONG PropChunkTable[2 * PROPCHUNKS] = {
 ID_TMSO, ID_CMND,
 ID_TMSO, ID_DATA,
 ID_TMSO, ID_NAME,
 ID_TMSO, ID_PORT,
};
static const char *TextTitle;
static const char *HelpCommand;
static const char *TextARexxPort;
static const char *HelpARexxPort;

/* Sound class instance data */
struct SoundClassData {
 const char *scd_Command;
 const char *scd_ARexxPort;
 Object     *scd_Active;
 Object     *scd_CmdString;
 Object     *scd_PopPort;
};
#define TYPED_INST_DATA(cl, o) ((struct SoundClassData *) INST_DATA((cl), (o)))

/* Sound class method: OM_NEW */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION SoundClassNew
static ULONG SoundClassNew(Class *cl, Object *obj, struct opSet *ops)
{
 SOUND_LOG((LOG1(Tags, "0x%08lx", ops->ops_AttrList),
            PrintTagList(ops->ops_AttrList)))

 /* Create object */
 if (obj = (Object *) DoSuperNew(cl, obj,
                                       MUIA_Window_Title, TextTitle,
                                       MUIA_HelpNode,     "SoundWindow",
                                       TMA_Type,          TMOBJTYPE_SOUND,
                                       TAG_MORE,          ops->ops_AttrList)) {
  struct SoundClassData *scd = TYPED_INST_DATA(cl, obj);

  /* Initialize instance data */
  scd->scd_Command   = NULL;
  scd->scd_ARexxPort = NULL;
  scd->scd_Active    = NULL;
 }

 SOUND_LOG(LOG1(Result, "0x%08lx", obj))

 /* Return pointer to created object */
 return((ULONG) obj);
}

/* Sound class method: OM_DISPOSE */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION SoundClassDispose
static ULONG SoundClassDispose(Class *cl, Object *obj, Msg msg)
{
 struct SoundClassData *scd = TYPED_INST_DATA(cl, obj);

 SOUND_LOG(LOG1(Disposing, "0x%08lx", obj))

 /* Free instance data */
 if (scd->scd_Command)   FreeVector(scd->scd_Command);
 if (scd->scd_ARexxPort) FreeVector(scd->scd_ARexxPort);

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, msg));
}

/* Sound class method: TMM_Finish */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION SoundClassFinish
static ULONG SoundClassFinish(Class *cl, Object *obj, struct TMP_Finish *tmpf)
{
 struct SoundClassData *scd = TYPED_INST_DATA(cl, obj);

 SOUND_LOG(LOG1(Type, "%ld", tmpf->tmpf_Type))

 /* MUI objects allocated? */
 if (scd->scd_Active) {

  /* Use or Cancel? */
  if (tmpf->tmpf_Type == TMV_Finish_Use) {

   /* Get new string contents */
   scd->scd_Command   = GetStringContents(scd->scd_CmdString,
                                          scd->scd_Command);
   scd->scd_ARexxPort = GetStringContents(scd->scd_PopPort,
                                          scd->scd_ARexxPort);
  }

  /* Reset pointer to file name area */
  scd->scd_Active = NULL;
 }

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, (Msg) tmpf));
}

/* Sound class method: TMM_Edit */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION SoundClassEdit
static ULONG SoundClassEdit(Class *cl, Object *obj, struct TMP_Edit *tmpe)
{
 struct SoundClassData *scd = TYPED_INST_DATA(cl, obj);

 /* MUI objects allocated? */
 if (scd->scd_Active) {

  SOUND_LOG(LOG0(Object already active))

  /* Yes, forward method to SuperClass */
  DoSuperMethodA(cl, obj, (Msg) tmpe);

 /* No, create object edit area */
 } else if (scd->scd_Active =
    ColGroup(2),
     Child, Label2(TextGlobalCommand),
     Child, scd->scd_CmdString  = TMString(scd->scd_Command, LENGTH_FILENAME,
                                           HelpCommand),
     Child, Label2(TextARexxPort),
     Child, scd->scd_PopPort    = PopportObject,
      MUIA_Popstring_String,  TMString(scd->scd_ARexxPort, LENGTH_STRING,
                                       NULL),
      MUIA_Popport_ARexxOnly, TRUE,
      MUIA_ShortHelp,         HelpARexxPort,
     End,
    End) {

  SOUND_LOG(LOG1(Sound Area, "0x%08lx", scd->scd_Active))

  /* Forward method to SuperClass */
  if (DoSuperMethod(cl, obj, TMM_Edit, scd->scd_Active) == NULL) {

   /* SuperClass failed, delete file area again */
   MUI_DisposeObject(scd->scd_Active);
   scd->scd_Active = NULL;
  }
 }

 SOUND_LOG(LOG1(Result, "0x%08lx", scd->scd_Active))

 /* Return pointer to file area object to indicate success */
 return((ULONG) scd->scd_Active);
}

/* Sound class method: TMM_ParseIFF */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION SoundClassParseIFF
static ULONG SoundClassParseIFF(Class *cl, Object *obj,
                                struct TMP_ParseIFF *tmppi)
{
 BOOL rc = FALSE;

 SOUND_LOG(LOG1(Handle, "0x%08lx", tmppi->tmppi_IFFHandle))

 /* Initialize IFF parser */
 if ((PropChunks(tmppi->tmppi_IFFHandle, PropChunkTable, PROPCHUNKS) == 0) &&
     (StopOnExit(tmppi->tmppi_IFFHandle, ID_TMSO, ID_FORM) == 0) &&
     (ParseIFF(tmppi->tmppi_IFFHandle, IFFPARSE_SCAN) == IFFERR_EOC)) {
  struct StoredProperty *spname;

  SOUND_LOG(LOG0(FORM TMEX chunk parsed OK))

  /* Check for mandatory NAME property */
  if (spname = FindProp(tmppi->tmppi_IFFHandle, ID_TMSO, ID_NAME)) {
   struct StoredProperty *spdata;

   SOUND_LOG(LOG2(Name, "%s (0x%08lx)", spname->sp_Data, spname->sp_Data))

   /* Check for mandatory DATA property */
   if (spdata = FindProp(tmppi->tmppi_IFFHandle, ID_TMSO, ID_DATA)) {
    struct SoundClassData    *scd = TYPED_INST_DATA(cl, obj);
    struct StandardDATAChunk *sdc = spdata->sp_Data;

    SOUND_LOG(LOG1(Data, "ID 0x%08lx", sdc->sdc_ID))

    /* Set new name and ID */
    SetAttrs(obj, TMA_Name, spname->sp_Data,
                  TMA_ID,   sdc->sdc_ID,
                  TAG_DONE);

    /* Get command */
    scd->scd_Command   = ReadStringProperty(tmppi->tmppi_IFFHandle, ID_TMSO,
                                            ID_CMND);
    scd->scd_ARexxPort = ReadStringProperty(tmppi->tmppi_IFFHandle, ID_TMSO,
                                            ID_PORT);

    /* All OK */
    rc = TRUE;
   }
  }
 }

 SOUND_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Sound class method: TMM_WriteIFF */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION SoundClassWriteIFF
static ULONG SoundClassWriteIFF(Class *cl, Object *obj,
                                struct TMP_WriteIFF *tmpwi)
{
 struct SoundClassData    *scd = TYPED_INST_DATA(cl, obj);
 struct StandardDATAChunk  sdc;
 BOOL                      rc;

 SOUND_LOG(LOG1(IFFHandle, "0x%08lx", tmpwi->tmpwi_IFFHandle))

 /* Initialize DATA chunk */
 sdc.sdc_ID    = (ULONG) obj; /* Use objects address as ID */
 sdc.sdc_Flags = 0;

 /* a) Forward message to SuperClass first */
 /* b) Push DATA chunk                     */
 /* c) Push CMND chunk                     */
 /* d) Push PORT chunk                     */
 rc = DoSuperMethodA(cl, obj, (Msg) tmpwi)                 &&
      WriteProperty(tmpwi->tmpwi_IFFHandle, ID_DATA, &sdc,
                    sizeof(struct StandardDATAChunk))      &&
      WriteStringProperty(tmpwi->tmpwi_IFFHandle, ID_CMND,
                          scd->scd_Command)                &&
      WriteStringProperty(tmpwi->tmpwi_IFFHandle, ID_PORT,
                          scd->scd_ARexxPort);

 SOUND_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Sound class method dispatcher */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION SoundClassDispatcher
__geta4 static ULONG SoundClassDispatcher(__a0 Class *cl, __a2 Object *obj,
                                          __a1 Msg msg)
{
 ULONG rc;

 SOUND_LOG(LOG3(Arguments, "Class 0x%08lx Object 0x%08lx Msg 0x%08lx",
                cl, obj, msg))

 switch(msg->MethodID) {
  /* BOOPSI methods */
  case OM_NEW:
   rc = SoundClassNew(cl, obj, (struct opSet *) msg);
   break;

  case OM_DISPOSE:
   rc = SoundClassDispose(cl, obj, msg);
   break;

  /* TM methods */
  case TMM_Finish:
   rc = SoundClassFinish(cl, obj, (struct TMP_Finish *) msg);
   break;

  case TMM_Edit:
   rc = SoundClassEdit(cl, obj, (struct TMP_Edit *) msg);
   break;

  case TMM_ParseIFF:
   rc = SoundClassParseIFF(cl, obj, (struct TMP_ParseIFF *) msg);
   break;

  case TMM_WriteIFF:
   rc = SoundClassWriteIFF(cl, obj, (struct TMP_WriteIFF *) msg);
   break;

  /* Unknown method -> delegate to SuperClass */
  default:
   rc = DoSuperMethodA(cl, obj, msg);
   break;
 }

 return(rc);
}

/* Create Sound class */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CreateSoundClass
struct MUI_CustomClass *CreateSoundClass(void)
{
 struct MUI_CustomClass *rc;

 /* Create class */
 if (rc = MUI_CreateCustomClass(NULL, NULL, BaseClass,
                                sizeof(struct SoundClassData),
                                SoundClassDispatcher)) {

  /* Localize strings */
  TextTitle     = TranslateString(LOCALE_TEXT_SOUND_TITLE_STR,
                                  LOCALE_TEXT_SOUND_TITLE);
  HelpCommand   = TranslateString(LOCALE_HELP_SOUND_COMMAND_STR,
                                  LOCALE_HELP_SOUND_COMMAND);
  TextARexxPort = TranslateString(LOCALE_TEXT_SOUND_AREXX_PORT_STR,
                                  LOCALE_TEXT_SOUND_AREXX_PORT);
  HelpARexxPort = TranslateString(LOCALE_HELP_SOUND_AREXX_PORT_STR,
                                  LOCALE_HELP_SOUND_AREXX_PORT);
 }

 SOUND_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}
