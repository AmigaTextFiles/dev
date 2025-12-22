/*
 * icon.c  V3.1
 *
 * ToolManager Objects Icon class
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
static const struct TagItem TagsToFlags[] = {
 TMOP_ShowName, DATA_ICONF_SHOWNAME,
 TAG_DONE
};

/* Icon class instance data */
struct IconClassData {
 ULONG                icd_Flags;
 ULONG                icd_LeftEdge;
 ULONG                icd_TopEdge;
 void                *icd_AppObject;
 struct TMMemberData *icd_ExecObject;
 Object              *icd_ImageObject;
 struct TMImageData  *icd_Image;
 struct TMMemberData *icd_SoundObject;
};
#define TYPED_INST_DATA(cl, o) ((struct IconClassData *) INST_DATA((cl), (o)))

/* Create icon */
#define DEBUGFUNCTION CreateIcon
static BOOL CreateIcon(Object *obj, struct IconClassData *icd)
{
 BOOL rc = FALSE;

 /* Get image data */
 if (icd->icd_Image = (struct TMImageData *)
                       DoMethod(icd->icd_ImageObject, TMM_GetImage, obj,
                                NULL)) {
  struct DiskObject *diskobj = icd->icd_Image->tmid_ImageData;

  ICONCLASS_LOG(LOG1(Image Data, "0x%08lx", icd->icd_Image))

  /* Set icon position */
  diskobj->do_CurrentX = icd->icd_LeftEdge;
  diskobj->do_CurrentY = icd->icd_TopEdge;

  /* Create icon */
  if (icd->icd_AppObject =
       CreateAppIcon(obj, diskobj, icd->icd_Flags & DATA_ICONF_SHOWNAME)) {

   ICONCLASS_LOG(LOG1(AppObject, "0x%08lx", icd->icd_AppObject))

   /* All OK */
   rc = TRUE;
  }
 }

 ICONCLASS_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Remove icon */
static void RemoveIcon(Object *obj, struct IconClassData *icd)
{
 /* Remove icon */
 if (icd->icd_AppObject) {
  DeleteAppIcon(icd->icd_AppObject, obj);
  icd->icd_AppObject = NULL;
 }

 /* Image object attached? Release it */
 if (icd->icd_Image) {
  DoMethod(icd->icd_Image->tmid_MemberData.tmmd_Object,
           TMM_Detach, icd->icd_Image);
  icd->icd_Image = NULL;
 }
}

/* Icon class method: OM_NEW */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION IconClassNew
static ULONG IconClassNew(Class *cl, Object *obj, struct opSet *ops)
{
 ICONCLASS_LOG((LOG1(Tags, "0x%08lx", ops->ops_AttrList),
                PrintTagList(ops->ops_AttrList)))

 /* Call SuperClass */
 if (obj = (Object *) DoSuperMethodA(cl, obj, (Msg) ops)) {
  struct IconClassData *icd = TYPED_INST_DATA(cl, obj);

  /* Initialize instance data */
  icd->icd_Flags       = 0;
  icd->icd_AppObject   = NULL;
  icd->icd_ExecObject  = NULL;
  icd->icd_ImageObject = NULL;
  icd->icd_Image       = NULL;
  icd->icd_SoundObject = NULL;
 }

 return((ULONG) obj);
}

/* Icon class method: OM_DISPOSE */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION IconClassDispose
static ULONG IconClassDispose(Class *cl, Object *obj, Msg msg)
{
 struct IconClassData *icd = TYPED_INST_DATA(cl, obj);

 ICONCLASS_LOG(LOG0(Disposing))

 /* Sound object attached? Release it */
 if (icd->icd_SoundObject) DoMethod(icd->icd_SoundObject->tmmd_Object,
                                    TMM_Detach, icd->icd_SoundObject);

 /* Remove icon */
 RemoveIcon(obj, icd);

 /* Exec object attached? Release it */
 if (icd->icd_ExecObject) DoMethod(icd->icd_ExecObject->tmmd_Object,
                                   TMM_Detach, icd->icd_ExecObject);

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, msg));
}

/* Icon class method: TMM_Release */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION IconClassRelease
static ULONG IconClassRelease(Class *cl, Object *obj, struct TMP_Detach *tmpd)
{
 struct IconClassData *icd = TYPED_INST_DATA(cl, obj);

 ICONCLASS_LOG(LOG2(Arguments, "Data 0x%08lx Member 0x%08lx",
                    tmpd->tmpd_MemberData, tmpd->tmpd_MemberData->tmmd_Member))

 /* Exec or Sound object deleted? */
 if (icd->icd_ExecObject == tmpd->tmpd_MemberData)
  icd->icd_ExecObject = NULL;
 else if (icd->icd_SoundObject == tmpd->tmpd_MemberData)
  icd->icd_SoundObject = NULL;
 else {

  /* Remove icon first */
  DeleteAppIcon(icd->icd_AppObject, obj);

  /* Reset pointers */
  icd->icd_AppObject   = NULL;
  icd->icd_ImageObject = NULL;
  icd->icd_Image       = NULL;
 }

 /* Detach object */
 DoMethod(tmpd->tmpd_MemberData->tmmd_Object, TMM_Detach,
          tmpd->tmpd_MemberData);

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* Icon class method: TMM_ParseIFF */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION IconClassParseIFF
static ULONG IconClassParseIFF(Class *cl, Object *obj,
                               struct TMP_ParseIFF *tmppi)
{
 BOOL rc = FALSE;

 /* Forward method to SuperClass */
 if (DoSuperMethodA(cl, obj, (Msg) tmppi)) {
  struct StoredProperty *sp;

  ICONCLASS_LOG(LOG0(FORM TMIC chunk parsed OK))

  /* Check for mandatory DATA property */
  if (sp = FindProp(tmppi->tmppi_IFFHandle, ID_TMIC, ID_DATA)) {
   struct IconClassData *icd      = TYPED_INST_DATA(cl, obj);
   struct IconDATAChunk *idc      = sp->sp_Data;
   struct TMHandle      *tmh;

   ICONCLASS_LOG(LOG4(Data1,
                      "Flags 0x%08lx Exec 0x%08lx Image 0x%08lx Sound 0x%08lx",
                      idc->idc_Standard.sdc_Flags, idc->idc_ExecObject,
                      idc->idc_ImageObject, idc->idc_SoundObject))
   ICONCLASS_LOG(LOG2(Data2, "Left %ld Top %ld",
                      idc->idc_LeftEdge, idc->idc_TopEdge))

   /* Initialize class data */
   icd->icd_Flags    = idc->idc_Standard.sdc_Flags & DATA_ICONF_MASK;
   icd->icd_LeftEdge = idc->idc_LeftEdge;
   icd->icd_TopEdge  = idc->idc_TopEdge;

   /* Get TMHandle */
   GetAttr(TMA_TMHandle, obj, (ULONG *) &tmh);

   /* Find Image object */
   if (icd->icd_ImageObject = FindTypedIDTMObject(tmh, idc->idc_ImageObject,
                                                  TMOBJTYPE_IMAGE)) {

    ICONCLASS_LOG(LOG1(Image Object, "0x%08lx", icd->icd_ImageObject))

    /* Create icon */
    if (CreateIcon(obj, icd)) {

     /* Attach Exec object */
     if (idc->idc_ExecObject) {
      Object *execobj;

      /* Find exec object */
      if (execobj = FindTypedIDTMObject(tmh, idc->idc_ExecObject,
                                        TMOBJTYPE_EXEC)) {

       ICONCLASS_LOG(LOG1(Exec, "0x%08lx", execobj))

       /* Attach to exec object */
       icd->icd_ExecObject = (struct TMMemberData *)
        DoMethod(execobj, TMM_Attach, obj, TMV_Attach_Normal);

       ICONCLASS_LOG(LOG1(Exec Data, "0x%08lx", icd->icd_ExecObject))
      }
     }

     /* Attach sound object */
     if (idc->idc_SoundObject) {
      Object *soundobj;

      /* Find sound object */
      if (soundobj = FindTypedIDTMObject(tmh, idc->idc_SoundObject,
                                         TMOBJTYPE_SOUND)) {

       ICONCLASS_LOG(LOG1(Sound, "0x%08lx", soundobj))

       /* Attach to sound object */
       icd->icd_SoundObject = (struct TMMemberData *)
        DoMethod(soundobj, TMM_Attach, obj, TMV_Attach_Normal);

       ICONCLASS_LOG(LOG1(Sound Data, "0x%08lx", icd->icd_SoundObject))
      }
     }

     /* Configuration data parsed */
     rc = TRUE;
    }
   }
  }
 }

 ICONCLASS_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Icon class method: TMM_ParseTags */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION IconClassParseTags
static ULONG IconClassParseTags(Class *cl, Object *obj,
                                struct TMP_ParseTags *tmppt)
{
 struct IconClassData *icd    = TYPED_INST_DATA(cl, obj);
 struct TagItem       *tstate = tmppt->tmppt_Tags;
 struct TagItem       *ti;
 struct TMHandle      *tmh;
 BOOL                  rc     = FALSE;

 ICONCLASS_LOG((LOG1(Tags, "0x%08lx", tmppt->tmppt_Tags),
                PrintTagList(tmppt->tmppt_Tags)))

 /* Get TMHandle */
 GetAttr(TMA_TMHandle, obj, (ULONG *) &tmh);

 /* Scan tag list */
 while (ti = NextTagItem(&tstate))

  /* Which tag? */
  switch (ti->ti_Tag) {
   case TMOP_Exec: {
     Object *newobj;

     /* Release old object first */
     if (icd->icd_ExecObject) DoMethod(icd->icd_ExecObject->tmmd_Object,
                                       TMM_Detach, icd->icd_ExecObject);

     /* Object name valid and does the object exist? */
     if (ti->ti_Data &&
         (newobj = FindTypedNamedTMObject(tmh, (char *) ti->ti_Data,
                                          TMOBJTYPE_EXEC))) {

       ICONCLASS_LOG(LOG1(Exec, "0x%08lx", newobj))

       /* Yes, attach new object */
       icd->icd_ExecObject = (struct TMMemberData *)
                              DoMethod(newobj, TMM_Attach, obj,
                                       TMV_Attach_Normal);

      } else

       /* No, clear pointer */
       icd->icd_ExecObject = NULL;

     ICONCLASS_LOG(LOG1(Exec Attach, "0x%08lx", icd->icd_ExecObject))
    }
    break;

   case TMOP_Sound: {
     Object *newobj;

     /* Release old object first */
     if (icd->icd_SoundObject) DoMethod(icd->icd_SoundObject->tmmd_Object,
                                        TMM_Detach, icd->icd_SoundObject);

     /* Object name valid and does the object exist? */
     if (ti->ti_Data &&
         (newobj = FindTypedNamedTMObject(tmh, (char *) ti->ti_Data,
                                          TMOBJTYPE_SOUND))) {

       ICONCLASS_LOG(LOG1(Sound, "0x%08lx", newobj))

       /* Yes, attach new object */
       icd->icd_SoundObject = (struct TMMemberData *)
                               DoMethod(newobj, TMM_Attach, obj,
                                        TMV_Attach_Normal);

      } else

       /* No, clear pointer */
       icd->icd_SoundObject = NULL;

     ICONCLASS_LOG(LOG1(Sound Attach, "0x%08lx", icd->icd_SoundObject))
    }
    break;

   case TMOP_Image:
    /* Remove old icon first */
    RemoveIcon(obj, icd);

    /* Object name valid? */
    if (ti->ti_Data)

     /* Yes, get new object */
     icd->icd_ImageObject = FindTypedNamedTMObject(tmh, (char *) ti->ti_Data,
                                                   TMOBJTYPE_IMAGE);

    else

     /* No, clear pointer */
     icd->icd_ImageObject = NULL;

    break;

   case TMOP_ShowName:
    /* Remove old icon first */
    RemoveIcon(obj, icd);
    break;

   case TMOP_LeftEdge:
    /* Remove old icon first */
    RemoveIcon(obj, icd);

    icd->icd_LeftEdge = ti->ti_Data;
    break;

   case TMOP_TopEdge:
    /* Remove old icon first */
    RemoveIcon(obj, icd);

    icd->icd_TopEdge = ti->ti_Data;
    break;
  }

 /* Set Flags */
 icd->icd_Flags = PackBoolTags(icd->icd_Flags, tmppt->tmppt_Tags, TagsToFlags);

 /* Icon not created yet and image object valid? */
 if ((icd->icd_AppObject == NULL) && icd->icd_ImageObject)

  /* Yes, create icon */
  rc = CreateIcon(obj, icd);

 ICONCLASS_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Icon class method: TMM_Activate */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION IconClassActivate
static ULONG IconClassActivate(Class *cl, Object *obj,
                               struct TMP_Activate *tmpa)
{
 struct IconClassData *icd = TYPED_INST_DATA(cl, obj);

 ICONCLASS_LOG(LOG1(Data, "0x%08lx", tmpa->tmpa_Data))

 /* Activate sound object */
 if (icd->icd_SoundObject) DoMethod(icd->icd_SoundObject->tmmd_Object,
                                    TMM_Activate, NULL);

 /* Activate Exec object */
 if (icd->icd_ExecObject) DoMethod(icd->icd_ExecObject->tmmd_Object,
                                   TMM_Activate, tmpa->tmpa_Data);

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* Icon class method: TMM_Notify */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION IconClassNotify
static ULONG IconClassNotify(Class *cl, Object *obj,
                             struct TMP_Detach *tmpd)
{
 struct IconClassData *icd = TYPED_INST_DATA(cl, obj);

 ICONCLASS_LOG(LOG2(Arguments, "Data 0x%08lx Member 0x%08lx",
                    tmpd->tmpd_MemberData, tmpd->tmpd_MemberData->tmmd_Member))

 /* Image has changed, remove old icon */
 RemoveIcon(obj, icd);

 /* Create new icon */
 CreateIcon(obj, icd);

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* Icon class dispatcher */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION IconClassDispatcher
static __geta4 ULONG IconClassDispatcher(__A0 Class *cl, __A2 Object *obj,
                                         __A1 Msg msg)
{
 ULONG rc;

 ICONCLASS_LOG(LOG3(Arguments, "Class 0x%08lx Object 0x%08lx Msg 0x%08lx",
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
  case TMM_Release:
   rc = IconClassRelease(cl, obj, (struct TMP_Detach *) msg);
   break;

  case TMM_ParseIFF:
   rc = IconClassParseIFF(cl, obj, (struct TMP_ParseIFF *) msg);
   break;

  case TMM_ParseTags:
   rc = IconClassParseTags(cl, obj, (struct TMP_ParseTags *) msg);
   break;

  case TMM_Activate:
   rc = IconClassActivate(cl, obj, (struct TMP_Activate *) msg);
   break;

  case TMM_Notify:
   rc = IconClassNotify(cl, obj, (struct TMP_Detach *) msg);
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
Class *CreateIconClass(Class *superclass)
{
 Class *cl;

 ICONCLASS_LOG(LOG1(SuperClass, "0x%08lx", superclass))

 /* Create class */
 if (cl = MakeClass(NULL, NULL, superclass, sizeof(struct IconClassData), 0))

  /* Set dispatcher */
  cl->cl_Dispatcher.h_Entry = (ULONG (*)()) IconClassDispatcher;

 ICONCLASS_LOG(LOG1(Class, "0x%08lx", cl))

 /* Return pointer to class */
 return(cl);
}
