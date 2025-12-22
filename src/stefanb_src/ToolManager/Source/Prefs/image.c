/*
 * image.c  V3.1
 *
 * TM Image object class
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
static const ULONG PropChunkTable[2 * PROPCHUNKS] = {
 ID_TMIM, ID_DATA,
 ID_TMIM, ID_FILE,
 ID_TMIM, ID_NAME,
};
static const char *TextTitle;
static const char *TextFile;
static const char *HelpFile;

/* Image class instance data */
struct ImageClassData {
 const char *icd_File;
 Object     *icd_Active;
 Object     *icd_PopFile;
};
#define TYPED_INST_DATA(cl, o) ((struct ImageClassData *) INST_DATA((cl), (o)))

/* Image class method: OM_NEW */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ImageClassNew
static ULONG ImageClassNew(Class *cl, Object *obj, struct opSet *ops)
{
 IMAGE_LOG((LOG1(Tags, "0x%08lx", ops->ops_AttrList),
            PrintTagList(ops->ops_AttrList)))

 /* Create object */
 if (obj = (Object *) DoSuperNew(cl, obj,
                                       MUIA_Window_Title, TextTitle,
                                       MUIA_HelpNode,     "ImageWindow",
                                       TMA_Type,          TMOBJTYPE_IMAGE,
                                       TAG_MORE,          ops->ops_AttrList)) {
  struct ImageClassData *icd = TYPED_INST_DATA(cl, obj);

  /* Initialize instance data */
  icd->icd_File   = NULL;
  icd->icd_Active = NULL;
 }

 IMAGE_LOG(LOG1(Result, "0x%08lx", obj))

 /* Return pointer to created object */
 return((ULONG) obj);
}

/* Image class method: OM_DISPOSE */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ImageClassDispose
static ULONG ImageClassDispose(Class *cl, Object *obj, Msg msg)
{
 struct ImageClassData *icd = TYPED_INST_DATA(cl, obj);

 IMAGE_LOG(LOG1(Disposing, "0x%08lx", obj))

 /* Free instance data */
 if (icd->icd_File) FreeVector(icd->icd_File);

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, msg));
}

/* Image class method: TMM_Finish */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ImageClassFinish
static ULONG ImageClassFinish(Class *cl, Object *obj, struct TMP_Finish *tmpf)
{
 struct ImageClassData *icd = TYPED_INST_DATA(cl, obj);

 IMAGE_LOG(LOG1(Type, "%ld", tmpf->tmpf_Type))

 /* MUI objects allocated? */
 if (icd->icd_Active) {

  /* Use or Cancel? */
  if (tmpf->tmpf_Type == TMV_Finish_Use) {

   /* Get new file name */
   icd->icd_File = GetStringContents(icd->icd_PopFile, icd->icd_File);
  }

  /* Reset pointer to file name area */
  icd->icd_Active = NULL;
 }

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, (Msg) tmpf));
}

/* Image class method: TMM_Edit */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ImageClassEdit
static ULONG ImageClassEdit(Class *cl, Object *obj, struct TMP_Edit *tmpe)
{
 struct ImageClassData *icd = TYPED_INST_DATA(cl, obj);

 /* MUI objects allocated? */
 if (icd->icd_Active) {

  IMAGE_LOG(LOG0(Object already active))

  /* Yes, forward method to SuperClass */
  DoSuperMethodA(cl, obj, (Msg) tmpe);

 /* No, create object edit area */
 } else if (icd->icd_Active =
    HGroup,
     Child, Label2(TextFile),
     Child, icd->icd_PopFile = TMPopFile(TextGlobalSelectFile, icd->icd_File,
                                         LENGTH_FILENAME, HelpFile),
     End,
    End) {

  IMAGE_LOG(LOG1(File Area, "0x%08lx", icd->icd_Active))

  /* Forward method to SuperClass */
  if (DoSuperMethod(cl, obj, TMM_Edit, icd->icd_Active) == NULL) {

   /* SuperClass failed, delete file area again */
   MUI_DisposeObject(icd->icd_Active);
   icd->icd_Active = NULL;
  }
 }

 IMAGE_LOG(LOG1(Result, "0x%08lx", icd->icd_Active))

 /* Return pointer to file area object to indicate success */
 return((ULONG) icd->icd_Active);
}

/* Image class method: TMM_ParseIFF */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ImageClassParseIFF
static ULONG ImageClassParseIFF(Class *cl, Object *obj,
                                struct TMP_ParseIFF *tmppi)
{
 BOOL rc = FALSE;

 IMAGE_LOG(LOG1(Handle, "0x%08lx", tmppi->tmppi_IFFHandle))

 /* Initialize IFF parser */
 if ((PropChunks(tmppi->tmppi_IFFHandle, PropChunkTable, PROPCHUNKS) == 0) &&
     (StopOnExit(tmppi->tmppi_IFFHandle, ID_TMIM, ID_FORM) == 0) &&
     (ParseIFF(tmppi->tmppi_IFFHandle, IFFPARSE_SCAN) == IFFERR_EOC)) {
  struct StoredProperty *spname;

  IMAGE_LOG(LOG0(FORM TMEX chunk parsed OK))

  /* Check for mandatory NAME property */
  if (spname = FindProp(tmppi->tmppi_IFFHandle, ID_TMIM, ID_NAME)) {
   struct StoredProperty *spdata;

   IMAGE_LOG(LOG2(Name, "%s (0x%08lx)", spname->sp_Data, spname->sp_Data))

   /* Check for mandatory DATA property */
   if (spdata = FindProp(tmppi->tmppi_IFFHandle, ID_TMIM, ID_DATA)) {
    struct ImageClassData    *icd = TYPED_INST_DATA(cl, obj);
    struct StandardDATAChunk *sdc = spdata->sp_Data;

    IMAGE_LOG(LOG1(Data, "ID 0x%08lx", sdc->sdc_ID))

    /* Set new name and ID */
    SetAttrs(obj, TMA_Name, spname->sp_Data,
                  TMA_ID,   sdc->sdc_ID,
                  TAG_DONE);

    /* Get file name */
    icd->icd_File = ReadStringProperty(tmppi->tmppi_IFFHandle, ID_TMIM,
                                       ID_FILE);

    /* All OK */
    rc = TRUE;
   }
  }
 }

 IMAGE_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Image class method: TMM_WriteIFF */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ImageClassWriteIFF
static ULONG ImageClassWriteIFF(Class *cl, Object *obj,
                                struct TMP_WriteIFF *tmpwi)
{
 struct StandardDATAChunk sdc;
 BOOL                     rc;

 IMAGE_LOG(LOG1(IFFHandle, "0x%08lx", tmpwi->tmpwi_IFFHandle))

 /* Initialize DATA chunk */
 sdc.sdc_ID    = (ULONG) obj; /* Use objects address as ID */
 sdc.sdc_Flags = 0;

 /* a) Forward message to SuperClass first */
 /* b) Push DATA chunk                     */
 /* c) Push FILE chunk                     */
 rc = DoSuperMethodA(cl, obj, (Msg) tmpwi)                    &&
      WriteProperty(tmpwi->tmpwi_IFFHandle, ID_DATA, &sdc,
                    sizeof(struct StandardDATAChunk))         &&
      WriteStringProperty(tmpwi->tmpwi_IFFHandle, ID_FILE,
                          TYPED_INST_DATA(cl, obj)->icd_File);

 IMAGE_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Image class method: TMM_WBArg */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ImageClassWBArg
static ULONG ImageClassWBArg(Class *cl, Object *obj, struct TMP_WBArg *tmpwa)
{
 ULONG rc;

 IMAGE_LOG(LOG1(WBArg, "0x%08lx", tmpwa->tmpwa_Argument))

 /* First forward method to SuperClass */
 if (rc = DoSuperMethodA(cl, obj, (Msg) tmpwa)) {
  struct WBArg          *wa   = tmpwa->tmpwa_Argument;
  char                  *file;

  IMAGE_LOG(LOG0(Set gadget contents))

  /* Allocate memory for buffer */
  if (file = GetMemory(LENGTH_FILENAME)) {

   IMAGE_LOG(LOG1(Buffer, "0x%08lx", file))

   /* Create file name from lock and name */
   if (NameFromLock(wa->wa_Lock, file, LENGTH_FILENAME) &&
       AddPart(file, wa->wa_Name, LENGTH_FILENAME)) {

    IMAGE_LOG(LOG1(File name, "%s", file))

    /* Set directory gadget contents */
    SetAttrs(TYPED_INST_DATA(cl, obj)->icd_PopFile, MUIA_String_Contents, file,
                                                    TAG_DONE);
   }

   /* Free buffer */
   FreeMemory(file, LENGTH_FILENAME);
  }
 }

 IMAGE_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}

/* Image class method dispatcher */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ImageClassDispatcher
__geta4 static ULONG ImageClassDispatcher(__a0 Class *cl, __a2 Object *obj,
                                          __a1 Msg msg)
{
 ULONG rc;

 IMAGE_LOG(LOG3(Arguments, "Class 0x%08lx Object 0x%08lx Msg 0x%08lx",
                cl, obj, msg))

 switch(msg->MethodID) {
  /* BOOPSI methods */
  case OM_NEW:
   rc = ImageClassNew(cl, obj, (struct opSet *) msg);
   break;

  case OM_DISPOSE:
   rc = ImageClassDispose(cl, obj, msg);
   break;

  /* TM methods */
  case TMM_Finish:
   rc = ImageClassFinish(cl, obj, (struct TMP_Finish *) msg);
   break;

  case TMM_Edit:
   rc = ImageClassEdit(cl, obj, (struct TMP_Edit *) msg);
   break;

  case TMM_ParseIFF:
   rc = ImageClassParseIFF(cl, obj, (struct TMP_ParseIFF *) msg);
   break;

  case TMM_WriteIFF:
   rc = ImageClassWriteIFF(cl, obj, (struct TMP_WriteIFF *) msg);
   break;

  case TMM_WBArg:
   rc = ImageClassWBArg(cl, obj, (struct TMP_WBArg *) msg);
   break;

  /* Unknown method -> delegate to SuperClass */
  default:
   rc = DoSuperMethodA(cl, obj, msg);
   break;
 }

 return(rc);
}

/* Create Image class */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CreateImageClass
struct MUI_CustomClass *CreateImageClass(void)
{
 struct MUI_CustomClass *rc;

 /* Create class */
 if (rc = MUI_CreateCustomClass(NULL, NULL, BaseClass,
                                sizeof(struct ImageClassData),
                                ImageClassDispatcher)) {

  /* Localize strings */
  TextTitle = TranslateString(LOCALE_TEXT_IMAGE_TITLE_STR,
                              LOCALE_TEXT_IMAGE_TITLE);
  TextFile  = TranslateString(LOCALE_TEXT_IMAGE_FILE_STR,
                              LOCALE_TEXT_IMAGE_FILE);
  HelpFile  = TranslateString(LOCALE_HELP_IMAGE_FILE_STR,
                              LOCALE_HELP_IMAGE_FILE);
 }

 IMAGE_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}
