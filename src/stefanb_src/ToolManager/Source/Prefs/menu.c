/*
 * menu.c  V3.1
 *
 * TM Menu object class
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
#define PROPCHUNKS 2
static const ULONG PropChunkTable[2 * PROPCHUNKS] = {
 ID_TMMO, ID_DATA,
 ID_TMMO, ID_NAME,
};
static const char *TextTitle;
static const char *HelpExecObject;
static const char *HelpSoundObject;


/* Menu class instance data */
struct MenuClassData {
 struct AttachData *mcd_ExecObject;
 struct AttachData *mcd_SoundObject;
 Object            *mcd_Active;
 Object            *mcd_ExecDrop;
 Object            *mcd_SoundDrop;
};
#define TYPED_INST_DATA(cl, o) ((struct MenuClassData *) INST_DATA((cl), (o)))

/* Menu class method: OM_NEW */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION MenuClassNew
static ULONG MenuClassNew(Class *cl, Object *obj, struct opSet *ops)
{
 MENU_LOG((LOG1(Tags, "0x%08lx", ops->ops_AttrList),
           PrintTagList(ops->ops_AttrList)))

 /* Create object */
 if (obj = (Object *) DoSuperNew(cl, obj,
                                       MUIA_Window_Title, TextTitle,
                                       MUIA_HelpNode,     "MenuWindow",
                                       TMA_Type,          TMOBJTYPE_MENU,
                                       TAG_MORE,          ops->ops_AttrList)) {
  struct MenuClassData *mcd = TYPED_INST_DATA(cl, obj);

  /* Initialize instance data */
  mcd->mcd_ExecObject  = NULL;
  mcd->mcd_SoundObject = NULL;
  mcd->mcd_Active      = NULL;
 }

 MENU_LOG(LOG1(Result, "0x%08lx", obj))

 /* Return pointer to created object */
 return((ULONG) obj);
}

/* Menu class method: OM_DISPOSE */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION MenuClassDispose
static ULONG MenuClassDispose(Class *cl, Object *obj, Msg msg)
{
 struct MenuClassData *mcd = TYPED_INST_DATA(cl, obj);

 MENU_LOG(LOG1(Disposing, "0x%08lx", obj))

 /* Detach objects */
 if (mcd->mcd_ExecObject)  DoMethod(mcd->mcd_ExecObject->ad_Object,
                                    TMM_Detach, mcd->mcd_ExecObject);
 if (mcd->mcd_SoundObject) DoMethod(mcd->mcd_SoundObject->ad_Object,
                                    TMM_Detach, mcd->mcd_SoundObject);

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, msg));
}

/* Menu class method: TMM_Finish */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION MenuClassFinish
static ULONG MenuClassFinish(Class *cl, Object *obj, struct TMP_Finish *tmpf)
{
 struct MenuClassData *mcd = TYPED_INST_DATA(cl, obj);

 MENU_LOG(LOG1(Type, "%ld", tmpf->tmpf_Type))

 /* MUI objects allocated? */
 if (mcd->mcd_Active) {

  /* Use or Cancel? */
  if (tmpf->tmpf_Type == TMV_Finish_Use) {

   /* Get new attach data */
   mcd->mcd_ExecObject  = GetAttachData(mcd->mcd_ExecDrop,  obj,
                                        mcd->mcd_ExecObject);
   mcd->mcd_SoundObject = GetAttachData(mcd->mcd_SoundDrop, obj,
                                        mcd->mcd_SoundObject);
  }

  /* Reset pointer to file name area */
  mcd->mcd_Active = NULL;
 }

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, (Msg) tmpf));
}

/* Menu class method: TMM_Notify */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION MenuClassNotify
static ULONG MenuClassNotify(Class *cl, Object *obj, struct TMP_Notify *tmpn)
{
 MENU_LOG(LOG1(Type, "0x%08lx", tmpn->tmpn_Data->ad_Object))

 /* Object deleted? */
 if (tmpn->tmpn_Data->ad_Object == NULL) {
  struct MenuClassData *mcd = TYPED_INST_DATA(cl, obj);

  /* Exec or Sound object? */
  if (mcd->mcd_ExecObject == tmpn->tmpn_Data)
   mcd->mcd_ExecObject  = NULL;
  else
   mcd->mcd_SoundObject = NULL;
 }

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* Menu class method: TMM_Edit */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION MenuClassEdit
static ULONG MenuClassEdit(Class *cl, Object *obj, struct TMP_Edit *tmpe)
{
 struct MenuClassData *mcd = TYPED_INST_DATA(cl, obj);

 /* MUI objects allocated? */
 if (mcd->mcd_Active) {

  MENU_LOG(LOG0(Object already active))

  /* Yes, forward method to SuperClass */
  DoSuperMethodA(cl, obj, (Msg) tmpe);

 /* No, create object edit area */
 } else if (mcd->mcd_Active =
    ColGroup(2),
     Child, Label1(TextGlobalExecObject),
     Child, mcd->mcd_ExecDrop  = NewObject(DropAreaClass->mcc_Class, NULL,
                                          TMA_Type,       TMOBJTYPE_EXEC,
                                          TMA_Attach,     mcd->mcd_ExecObject,
                                          MUIA_ShortHelp, HelpExecObject,
                                          TAG_DONE),
     Child, Label1(TextGlobalSoundObject),
     Child, mcd->mcd_SoundDrop = NewObject(DropAreaClass->mcc_Class, NULL,
                                          TMA_Type,       TMOBJTYPE_SOUND,
                                          TMA_Attach,     mcd->mcd_SoundObject,
                                          MUIA_ShortHelp, HelpSoundObject,
                                          TAG_DONE),
    End) {

  MENU_LOG(LOG1(Menu Area, "0x%08lx", mcd->mcd_Active))

  /* Forward method to SuperClass */
  if (DoSuperMethod(cl, obj, TMM_Edit, mcd->mcd_Active) == NULL) {

   /* SuperClass failed, delete file area again */
   MUI_DisposeObject(mcd->mcd_Active);
   mcd->mcd_Active = NULL;
  }
 }

 MENU_LOG(LOG1(Result, "0x%08lx", mcd->mcd_Active))

 /* Return pointer to file area object to indicate success */
 return((ULONG) mcd->mcd_Active);
}

/* Menu class method: TMM_ParseIFF */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION MenuClassParseIFF
static ULONG MenuClassParseIFF(Class *cl, Object *obj,
                               struct TMP_ParseIFF *tmppi)
{
 BOOL rc = FALSE;

 MENU_LOG(LOG1(Handle, "0x%08lx", tmppi->tmppi_IFFHandle))

 /* Initialize IFF parser */
 if ((PropChunks(tmppi->tmppi_IFFHandle, PropChunkTable, PROPCHUNKS) == 0) &&
     (StopOnExit(tmppi->tmppi_IFFHandle, ID_TMMO, ID_FORM) == 0) &&
     (ParseIFF(tmppi->tmppi_IFFHandle, IFFPARSE_SCAN) == IFFERR_EOC)) {
  struct StoredProperty *spname;

  MENU_LOG(LOG0(FORM TMMO chunk parsed OK))

  /* Check for mandatory NAME property */
  if (spname = FindProp(tmppi->tmppi_IFFHandle, ID_TMMO, ID_NAME)) {
   struct StoredProperty *spdata;

   MENU_LOG(LOG2(Name, "%s (0x%08lx)", spname->sp_Data, spname->sp_Data))

   /* Check for mandatory DATA property */
   if (spdata = FindProp(tmppi->tmppi_IFFHandle, ID_TMMO, ID_DATA)) {
    struct MenuClassData *mcd = TYPED_INST_DATA(cl, obj);
    struct MenuDATAChunk *mdc = spdata->sp_Data;

    MENU_LOG(LOG3(Data, "ID 0x%08lx Menu 0x%08lx Sound 0x%08lx",
                  mdc->mdc_Standard.sdc_ID, mdc->mdc_ExecObject,
                  mdc->mdc_SoundObject))

    /* Set new name and ID */
    SetAttrs(obj, TMA_Name, spname->sp_Data,
                  TMA_ID,   mdc->mdc_Standard.sdc_ID,
                  TAG_DONE);

    /* Attach objects */
    mcd->mcd_ExecObject  = AttachObject(tmppi->tmppi_Lists[TMOBJTYPE_EXEC],
                                        obj, mdc->mdc_ExecObject);
    mcd->mcd_SoundObject = AttachObject(tmppi->tmppi_Lists[TMOBJTYPE_SOUND],
                                        obj, mdc->mdc_SoundObject);

    /* All OK */
    rc = TRUE;
   }
  }
 }

 MENU_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Menu class method: TMM_WriteIFF */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION MenuClassWriteIFF
static ULONG MenuClassWriteIFF(Class *cl, Object *obj,
                               struct TMP_WriteIFF *tmpwi)
{
 struct MenuClassData *mcd  = TYPED_INST_DATA(cl, obj);
 struct MenuDATAChunk  mdc;
 BOOL                  rc;

 MENU_LOG(LOG1(IFFHandle, "0x%08lx", tmpwi->tmpwi_IFFHandle))

 /* Initialize DATA chunk (use object addresses as IDs) */
 mdc.mdc_Standard.sdc_ID    = (ULONG) obj;
 mdc.mdc_Standard.sdc_Flags = 0;
 mdc.mdc_ExecObject         = (ULONG) (mcd->mcd_ExecObject  ?
                                        mcd->mcd_ExecObject->ad_Object  :
                                        NULL);
 mdc.mdc_SoundObject        = (ULONG) (mcd->mcd_SoundObject ?
                                        mcd->mcd_SoundObject->ad_Object :
                                        NULL);

 /* a) Forward message to SuperClass first */
 /* b) Push DATA chunk                     */
 rc = DoSuperMethodA(cl, obj, (Msg) tmpwi) &&
      WriteProperty(tmpwi->tmpwi_IFFHandle, ID_DATA, &mdc,
                    sizeof(struct MenuDATAChunk));

 MENU_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Menu class method: TMM_WBArg */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION MenuClassWBArg
static ULONG MenuClassWBArg(Class *cl, Object *obj, struct TMP_WBArg *tmpwa)
{
 ULONG rc;

 MENU_LOG(LOG1(WBArg, "0x%08lx", tmpwa->tmpwa_Argument))

 /* First forward method to SuperClass */
 if (rc = DoSuperMethodA(cl, obj, (Msg) tmpwa)) {
  Object *exec;

  MENU_LOG(LOG0(Creating objects))

  /* Create exec object from WBArg */
  if (exec = (Object *) DoMethodA(tmpwa->tmpwa_Lists[TMOBJTYPE_EXEC],
                                  (Msg) tmpwa)) {

   MENU_LOG(LOG1(Exec, "0x%08lx", exec))

   /* Attach new exec object */
   SetAttrs(TYPED_INST_DATA(cl, obj)->mcd_ExecDrop, TMA_Object, exec,
                                                    TAG_DONE);
  }
 }

 MENU_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}

/* Menu class method dispatcher */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION MenuClassDispatcher
__geta4 static ULONG MenuClassDispatcher(__a0 Class *cl, __a2 Object *obj,
                                         __a1 Msg msg)
{
 ULONG rc;

 MENU_LOG(LOG3(Arguments, "Class 0x%08lx Object 0x%08lx Msg 0x%08lx",
               cl, obj, msg))

 switch(msg->MethodID) {
  /* BOOPSI methods */
  case OM_NEW:
   rc = MenuClassNew(cl, obj, (struct opSet *) msg);
   break;

  case OM_DISPOSE:
   rc = MenuClassDispose(cl, obj, msg);
   break;

  /* TM methods */
  case TMM_Finish:
   rc = MenuClassFinish(cl, obj, (struct TMP_Finish *) msg);
   break;

  case TMM_Notify:
   rc = MenuClassNotify(cl, obj, (struct TMP_Notify *) msg);
   break;

  case TMM_Edit:
   rc = MenuClassEdit(cl, obj, (struct TMP_Edit *) msg);
   break;

  case TMM_ParseIFF:
   rc = MenuClassParseIFF(cl, obj, (struct TMP_ParseIFF *) msg);
   break;

  case TMM_WriteIFF:
   rc = MenuClassWriteIFF(cl, obj, (struct TMP_WriteIFF *) msg);
   break;

  case TMM_WBArg:
   rc = MenuClassWBArg(cl, obj, (struct TMP_WBArg *) msg);
   break;

  /* Unknown method -> delegate to SuperClass */
  default:
   rc = DoSuperMethodA(cl, obj, msg);
   break;
 }

 return(rc);
}

/* Create Menu class */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CreateMenuClass
struct MUI_CustomClass *CreateMenuClass(void)
{
 struct MUI_CustomClass *rc;

 /* Create class */
 if (rc = MUI_CreateCustomClass(NULL, NULL, BaseClass,
                                sizeof(struct MenuClassData),
                                MenuClassDispatcher)) {

  /* Localize strings */
  TextTitle       = TranslateString(LOCALE_TEXT_MENU_TITLE_STR,
                                    LOCALE_TEXT_MENU_TITLE);
  HelpExecObject  = TranslateString(LOCALE_HELP_MENU_EXEC_OBJECT_STR,
                                    LOCALE_HELP_MENU_EXEC_OBJECT);
  HelpSoundObject = TranslateString(LOCALE_HELP_MENU_SOUND_OBJECT_STR,
                                    LOCALE_HELP_MENU_SOUND_OBJECT);
 }

 MENU_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}
