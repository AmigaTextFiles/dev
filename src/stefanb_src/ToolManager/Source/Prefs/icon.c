/*
 * icon.c  V3.1
 *
 * TM Icon object class
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
 ID_TMIC, ID_DATA,
 ID_TMIC, ID_NAME,
};
static const char *TextTitle;
static const char *HelpExecObject;
static const char *HelpImageObject;
static const char *HelpSoundObject;
static const char *HelpPosition;
static const char *TextShowName;
static const char *HelpShowName;

/* Icon class instance data */
struct IconClassData {
 ULONG              icd_Flags;
 ULONG              icd_LeftEdge;
 ULONG              icd_TopEdge;
 struct AttachData *icd_ExecObject;
 struct AttachData *icd_ImageObject;
 struct AttachData *icd_SoundObject;
 Object            *icd_Active;
 Object            *icd_ExecDrop;
 Object            *icd_ImageDrop;
 Object            *icd_SoundDrop;
 Object            *icd_Position;
 Object            *icd_ShowName;
};
#define TYPED_INST_DATA(cl, o) ((struct IconClassData *) INST_DATA((cl), (o)))

/* Icon class method: OM_NEW */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION IconClassNew
static ULONG IconClassNew(Class *cl, Object *obj, struct opSet *ops)
{
 ICON_LOG((LOG1(Tags, "0x%08lx", ops->ops_AttrList),
           PrintTagList(ops->ops_AttrList)))

 /* Create object */
 if (obj = (Object *) DoSuperNew(cl, obj,
                                       MUIA_Window_Title, TextTitle,
                                       MUIA_HelpNode,     "IconWindow",
                                       TMA_Type,          TMOBJTYPE_ICON,
                                       TAG_MORE,          ops->ops_AttrList)) {
  struct IconClassData *icd = TYPED_INST_DATA(cl, obj);

  /* Initialize instance data */
  icd->icd_Flags       = DATA_ICONF_SHOWNAME;
  icd->icd_LeftEdge    = 0;
  icd->icd_TopEdge     = 0;
  icd->icd_ExecObject  = NULL;
  icd->icd_ImageObject = NULL;
  icd->icd_SoundObject = NULL;
  icd->icd_Active      = NULL;
 }

 ICON_LOG(LOG1(Result, "0x%08lx", obj))

 /* Return pointer to created object */
 return((ULONG) obj);
}

/* Icon class method: OM_DISPOSE */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION IconClassDispose
static ULONG IconClassDispose(Class *cl, Object *obj, Msg msg)
{
 struct IconClassData *icd = TYPED_INST_DATA(cl, obj);

 ICON_LOG(LOG1(Disposing, "0x%08lx", obj))

 /* Detach objects */
 if (icd->icd_ExecObject)  DoMethod(icd->icd_ExecObject->ad_Object,
                                    TMM_Detach, icd->icd_ExecObject);
 if (icd->icd_ImageObject) DoMethod(icd->icd_ImageObject->ad_Object,
                                    TMM_Detach, icd->icd_ImageObject);
 if (icd->icd_SoundObject) DoMethod(icd->icd_SoundObject->ad_Object,
                                    TMM_Detach, icd->icd_SoundObject);

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, msg));
}

/* Icon class method: TMM_Finish */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION IconClassFinish
static ULONG IconClassFinish(Class *cl, Object *obj, struct TMP_Finish *tmpf)
{
 struct IconClassData *icd = TYPED_INST_DATA(cl, obj);

 ICON_LOG(LOG1(Type, "%ld", tmpf->tmpf_Type))

 /* MUI objects allocated? */
 if (icd->icd_Active) {

  /* Use or Cancel? */
  if (tmpf->tmpf_Type == TMV_Finish_Use) {

   /* Get new attach data */
   icd->icd_ExecObject  = GetAttachData(icd->icd_ExecDrop,  obj,
                                        icd->icd_ExecObject);
   icd->icd_ImageObject = GetAttachData(icd->icd_ImageDrop, obj,
                                        icd->icd_ImageObject);
   icd->icd_SoundObject = GetAttachData(icd->icd_SoundDrop, obj,
                                        icd->icd_SoundObject);

   /* Get new position values */
   GetAttr(MUIA_Popposition_XPos, icd->icd_Position,  &icd->icd_LeftEdge);
   GetAttr(MUIA_Popposition_YPos, icd->icd_Position,  &icd->icd_TopEdge);

   /* Get new flag status */
   icd->icd_Flags = GetCheckmarkState(icd->icd_ShowName, DATA_ICONF_SHOWNAME);
  }

  /* Reset pointer to file name area */
  icd->icd_Active = NULL;
 }

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, (Msg) tmpf));
}

/* Icon class method: TMM_Notify */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION IconClassNotify
static ULONG IconClassNotify(Class *cl, Object *obj, struct TMP_Notify *tmpn)
{
 ICON_LOG(LOG1(Type, "0x%08lx", tmpn->tmpn_Data->ad_Object))

 /* Object deleted? */
 if (tmpn->tmpn_Data->ad_Object == NULL) {
  struct IconClassData *icd = TYPED_INST_DATA(cl, obj);

  /* Exec, Image or Sound object? */
  if      (icd->icd_ExecObject  == tmpn->tmpn_Data)
   icd->icd_ExecObject  = NULL;
  else if (icd->icd_ImageObject == tmpn->tmpn_Data)
   icd->icd_ImageObject = NULL;
  else
   icd->icd_SoundObject = NULL;
 }

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* Icon class method: TMM_Edit */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION IconClassEdit
static ULONG IconClassEdit(Class *cl, Object *obj, struct TMP_Edit *tmpe)
{
 struct IconClassData *icd = TYPED_INST_DATA(cl, obj);

 /* MUI objects allocated? */
 if (icd->icd_Active) {

  ICON_LOG(LOG0(Object already active))

  /* Yes, forward method to SuperClass */
  DoSuperMethodA(cl, obj, (Msg) tmpe);

 /* No, create object edit area */
 } else if (icd->icd_Active =
    VGroup,
     Child, ColGroup(2),
      Child, Label1(TextGlobalExecObject),
      Child, icd->icd_ExecDrop  = NewObject(DropAreaClass->mcc_Class, NULL,
                                          TMA_Type,       TMOBJTYPE_EXEC,
                                          TMA_Attach,     icd->icd_ExecObject,
                                          MUIA_ShortHelp, HelpExecObject,
                                          TAG_DONE),
      Child, Label1(TextGlobalImageObject),
      Child, icd->icd_ImageDrop = NewObject(DropAreaClass->mcc_Class, NULL,
                                          TMA_Type,       TMOBJTYPE_IMAGE,
                                          TMA_Attach,     icd->icd_ImageObject,
                                          MUIA_ShortHelp, HelpImageObject,
                                          TAG_DONE),
      Child, Label1(TextGlobalSoundObject),
      Child, icd->icd_SoundDrop = NewObject(DropAreaClass->mcc_Class, NULL,
                                          TMA_Type,       TMOBJTYPE_SOUND,
                                          TMA_Attach,     icd->icd_SoundObject,
                                          MUIA_ShortHelp, HelpSoundObject,
                                          TAG_DONE),
      Child, Label2(TextGlobalPosition),
      Child, icd->icd_Position  = TMPopPosition(icd->icd_LeftEdge,
                                                icd->icd_TopEdge,
                                                HelpPosition),
      End,
     End,
     Child, HGroup,
      Child, HSpace(0),
      Child, Label1(TextShowName),
      Child, icd->icd_ShowName =
       MakeCheckmark(icd->icd_Flags & DATA_ICONF_SHOWNAME, HelpShowName),
      Child, HSpace(0),
     End,
    End) {

  ICON_LOG(LOG1(Icon Area, "0x%08lx", icd->icd_Active))

  /* Forward method to SuperClass */
  if (DoSuperMethod(cl, obj, TMM_Edit, icd->icd_Active)) {
   struct Screen *screen;

   /* SuperClass succeeded, get screen */
   GetAttr(MUIA_Window_Screen, obj, (ULONG *) &screen);

   /* Set new Y offset for position gadget */
   SetAttrs(icd->icd_Position,
                             MUIA_Popposition_YOffset, - screen->BarHeight - 1,
                             TAG_DONE);

  } else {

   /* SuperClass failed, delete file area again */
   MUI_DisposeObject(icd->icd_Active);
   icd->icd_Active = NULL;
  }
 }

 ICON_LOG(LOG1(Result, "0x%08lx", icd->icd_Active))

 /* Return pointer to file area object to indicate success */
 return((ULONG) icd->icd_Active);
}

/* Icon class method: TMM_ParseIFF */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION IconClassParseIFF
static ULONG IconClassParseIFF(Class *cl, Object *obj,
                               struct TMP_ParseIFF *tmppi)
{
 BOOL rc = FALSE;

 ICON_LOG(LOG1(Handle, "0x%08lx", tmppi->tmppi_IFFHandle))

 /* Initialize IFF parser */
 if ((PropChunks(tmppi->tmppi_IFFHandle, PropChunkTable, PROPCHUNKS) == 0) &&
     (StopOnExit(tmppi->tmppi_IFFHandle, ID_TMIC, ID_FORM) == 0) &&
     (ParseIFF(tmppi->tmppi_IFFHandle, IFFPARSE_SCAN) == IFFERR_EOC)) {
  struct StoredProperty *spname;

  ICON_LOG(LOG0(FORM TMIC chunk parsed OK))

  /* Check for mandatory NAME property */
  if (spname = FindProp(tmppi->tmppi_IFFHandle, ID_TMIC, ID_NAME)) {
   struct StoredProperty *spdata;

   ICON_LOG(LOG2(Name, "%s (0x%08lx)", spname->sp_Data, spname->sp_Data))

   /* Check for mandatory DATA property */
   if (spdata = FindProp(tmppi->tmppi_IFFHandle, ID_TMIC, ID_DATA)) {
    struct IconClassData *icd = TYPED_INST_DATA(cl, obj);
    struct IconDATAChunk *idc = spdata->sp_Data;

    ICON_LOG(LOG4(Data1, "ID 0x%08lx Exec 0x%08lx Image 0x%08lx Sound 0x%08lx",
                  idc->idc_Standard.sdc_ID, idc->idc_ExecObject,
                  idc->idc_ImageObject, idc->idc_SoundObject))
    ICON_LOG(LOG3(Data2, "Flags 0x%08lx Left %ld Top %ld",
                  idc->idc_Standard.sdc_Flags, idc->idc_LeftEdge,
                  idc->idc_TopEdge))

    /* Set new name and ID */
    SetAttrs(obj, TMA_Name, spname->sp_Data,
                  TMA_ID,   idc->idc_Standard.sdc_ID,
                  TAG_DONE);

    /* Copy values from data chunk */
    icd->icd_Flags    = idc->idc_Standard.sdc_Flags & DATA_ICONF_MASK;
    icd->icd_LeftEdge = idc->idc_LeftEdge;
    icd->icd_TopEdge  = idc->idc_TopEdge;

    icd->icd_ExecObject  = AttachObject(tmppi->tmppi_Lists[TMOBJTYPE_EXEC],
                                        obj, idc->idc_ExecObject);
    icd->icd_ImageObject = AttachObject(tmppi->tmppi_Lists[TMOBJTYPE_IMAGE],
                                        obj, idc->idc_ImageObject);
    icd->icd_SoundObject = AttachObject(tmppi->tmppi_Lists[TMOBJTYPE_SOUND],
                                        obj, idc->idc_SoundObject);

    /* All OK */
    rc = TRUE;
   }
  }
 }

 ICON_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Icon class method: TMM_WriteIFF */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION IconClassWriteIFF
static ULONG IconClassWriteIFF(Class *cl, Object *obj,
                               struct TMP_WriteIFF *tmpwi)
{
 struct IconClassData *icd  = TYPED_INST_DATA(cl, obj);
 struct IconDATAChunk  idc;
 BOOL                  rc;

 ICON_LOG(LOG1(IFFHandle, "0x%08lx", tmpwi->tmpwi_IFFHandle))

 /* Initialize DATA chunk (use object addresses as IDs) */
 idc.idc_Standard.sdc_ID    = (ULONG) obj;
 idc.idc_Standard.sdc_Flags = icd->icd_Flags;
 idc.idc_LeftEdge           = icd->icd_LeftEdge;
 idc.idc_TopEdge            = icd->icd_TopEdge;
 idc.idc_ExecObject         = (ULONG) (icd->icd_ExecObject  ?
                                        icd->icd_ExecObject->ad_Object  :
                                        NULL);
 idc.idc_ImageObject        = (ULONG) (icd->icd_ImageObject ?
                                        icd->icd_ImageObject->ad_Object :
                                        NULL);
 idc.idc_SoundObject        = (ULONG) (icd->icd_SoundObject ?
                                        icd->icd_SoundObject->ad_Object :
                                        NULL);

 /* a) Forward message to SuperClass first */
 /* b) Push DATA chunk                     */
 rc = DoSuperMethodA(cl, obj, (Msg) tmpwi) &&
      WriteProperty(tmpwi->tmpwi_IFFHandle, ID_DATA, &idc,
                    sizeof(struct IconDATAChunk));

 ICON_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Icon class method: TMM_WBArg */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION IconClassWBArg
static ULONG IconClassWBArg(Class *cl, Object *obj, struct TMP_WBArg *tmpwa)
{
 ULONG rc;

 ICON_LOG(LOG1(WBArg, "0x%08lx", tmpwa->tmpwa_Argument))

 /* First forward method to SuperClass */
 if (rc = DoSuperMethodA(cl, obj, (Msg) tmpwa)) {
  Object *exec;

  ICON_LOG(LOG0(Creating objects))

  /* Create exec object from WBArg */
  if (exec = (Object *) DoMethodA(tmpwa->tmpwa_Lists[TMOBJTYPE_EXEC],
                                  (Msg) tmpwa)) {
   Object *image;

   ICON_LOG(LOG1(Exec, "0x%08lx", exec))

   /* Create image object from WBArg */
   if (image = (Object *) DoMethodA(tmpwa->tmpwa_Lists[TMOBJTYPE_IMAGE],
                                    (Msg) tmpwa)) {
    struct IconClassData *icd = TYPED_INST_DATA(cl, obj);

    ICON_LOG(LOG1(Image, "0x%08lx", image))

    /* Attach new objects */
    SetAttrs(icd->icd_ExecDrop,  TMA_Object, exec,  TAG_DONE);
    SetAttrs(icd->icd_ImageDrop, TMA_Object, image, TAG_DONE);
   }
  }
 }

 ICON_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}

/* Icon class method dispatcher */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION IconClassDispatcher
__geta4 static ULONG IconClassDispatcher(__a0 Class *cl, __a2 Object *obj,
                                         __a1 Msg msg)
{
 ULONG rc;

 ICON_LOG(LOG3(Arguments, "Class 0x%08lx Object 0x%08lx Msg 0x%08lx",
               cl, obj, msg))

 switch(msg->MethodID) {
  /* BOOPSI methods */
  case OM_NEW:
   rc = IconClassNew(cl, obj, (struct opSet *) msg);
   break;

  case OM_DISPOSE:
   rc = IconClassDispose(cl, obj, msg);
   break;

  /* TM methods */
  case TMM_Finish:
   rc = IconClassFinish(cl, obj, (struct TMP_Finish *) msg);
   break;

  case TMM_Notify:
   rc = IconClassNotify(cl, obj, (struct TMP_Notify *) msg);
   break;

  case TMM_Edit:
   rc = IconClassEdit(cl, obj, (struct TMP_Edit *) msg);
   break;

  case TMM_ParseIFF:
   rc = IconClassParseIFF(cl, obj, (struct TMP_ParseIFF *) msg);
   break;

  case TMM_WriteIFF:
   rc = IconClassWriteIFF(cl, obj, (struct TMP_WriteIFF *) msg);
   break;

  case TMM_WBArg:
   rc = IconClassWBArg(cl, obj, (struct TMP_WBArg *) msg);
   break;

  /* Unknown method -> delegate to SuperClass */
  default:
   rc = DoSuperMethodA(cl, obj, msg);
   break;
 }

 return(rc);
}

/* Create Icon class */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CreateIconClass
struct MUI_CustomClass *CreateIconClass(void)
{
 struct MUI_CustomClass *rc;

 /* Create class */
 if (rc = MUI_CreateCustomClass(NULL, NULL, BaseClass,
                                sizeof(struct IconClassData),
                                IconClassDispatcher)) {

  /* Localize strings */
  TextTitle       = TranslateString(LOCALE_TEXT_ICON_TITLE_STR,
                                    LOCALE_TEXT_ICON_TITLE);
  HelpExecObject  = TranslateString(LOCALE_HELP_ICON_EXEC_OBJECT_STR,
                                    LOCALE_HELP_ICON_EXEC_OBJECT);
  HelpImageObject = TranslateString(LOCALE_HELP_ICON_IMAGE_OBJECT_STR,
                                    LOCALE_HELP_ICON_IMAGE_OBJECT);
  HelpSoundObject = TranslateString(LOCALE_HELP_ICON_SOUND_OBJECT_STR,
                                    LOCALE_HELP_ICON_SOUND_OBJECT);
  HelpPosition    = TranslateString(LOCALE_HELP_ICON_POSITION_STR,
                                    LOCALE_HELP_ICON_POSITION);
  TextShowName    = TranslateString(LOCALE_TEXT_ICON_SHOW_NAME_STR,
                                    LOCALE_TEXT_ICON_SHOW_NAME);
  HelpShowName    = TranslateString(LOCALE_HELP_ICON_SHOW_NAME_STR,
                                    LOCALE_HELP_ICON_SHOW_NAME);
 }

 ICON_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}
