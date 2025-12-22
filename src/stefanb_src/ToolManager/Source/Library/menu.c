/*
 * menu.c  V3.1
 *
 * ToolManager Objects Menu class
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

/* Menu class instance data */
struct MenuClassData {
 ULONG                mcd_Flags;
 void                *mcd_AppObject;
 struct TMMemberData *mcd_ExecObject;
 struct TMMemberData *mcd_SoundObject;
};
#define TYPED_INST_DATA(cl, o) ((struct MenuClassData *) INST_DATA((cl), (o)))

/* Menu class method: OM_NEW */
#define DEBUGFUNCTION MenuClassNew
static ULONG MenuClassNew(Class *cl, Object *obj, struct opSet *ops)
{
 MENUCLASS_LOG((LOG1(Tags, "0x%08lx", ops->ops_AttrList),
                PrintTagList(ops->ops_AttrList)))

 /* Call SuperClass */
 if (obj = (Object *) DoSuperMethodA(cl, obj, (Msg) ops)) {
  struct MenuClassData *mcd = TYPED_INST_DATA(cl, obj);

  /* Initialize instance data */
  mcd->mcd_Flags       = 0;
  mcd->mcd_AppObject   = NULL;
  mcd->mcd_ExecObject  = NULL;
  mcd->mcd_SoundObject = NULL;
 }

 return((ULONG) obj);
}

/* Menu class method: OM_DISPOSE */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION MenuClassDispose
static ULONG MenuClassDispose(Class *cl, Object *obj, Msg msg)
{
 struct MenuClassData *mcd = TYPED_INST_DATA(cl, obj);

 MENUCLASS_LOG(LOG0(Disposing))

 /* Sound object attached? Release it */
 if (mcd->mcd_SoundObject) DoMethod(mcd->mcd_SoundObject->tmmd_Object,
                                    TMM_Detach, mcd->mcd_SoundObject);

 /* Exec object attached? Release it */
 if (mcd->mcd_ExecObject) DoMethod(mcd->mcd_ExecObject->tmmd_Object,
                                   TMM_Detach, mcd->mcd_ExecObject);

 /* Remove menu item */
 if (mcd->mcd_AppObject) DeleteAppMenuItem(mcd->mcd_AppObject, obj);

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, msg));
}

/* Menu class method: TMM_Release */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION MenuClassRelease
static ULONG MenuClassRelease(Class *cl, Object *obj, struct TMP_Detach *tmpd)
{
 struct MenuClassData *mcd = TYPED_INST_DATA(cl, obj);

 MENUCLASS_LOG(LOG2(Arguments, "Data 0x%08lx Member 0x%08lx",
                    tmpd->tmpd_MemberData, tmpd->tmpd_MemberData->tmmd_Member))

 /* Exec or Sound object deleted? */
 if (mcd->mcd_ExecObject == tmpd->tmpd_MemberData)
  mcd->mcd_ExecObject = NULL;
 else
  mcd->mcd_SoundObject = NULL;

 /* Detach object */
 DoMethod(tmpd->tmpd_MemberData->tmmd_Object, TMM_Detach,
          tmpd->tmpd_MemberData);

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* Menu class method: TMM_ParseIFF */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION MenuClassParseIFF
static ULONG MenuClassParseIFF(Class *cl, Object *obj,
                               struct TMP_ParseIFF *tmppi)
{
 BOOL rc = FALSE;

 MENUCLASS_LOG(LOG1(Handle, "0x%08lx", tmppi->tmppi_IFFHandle))

 /* Forward method to SuperClass */
 if (DoSuperMethodA(cl, obj, (Msg) tmppi)) {
  struct StoredProperty *sp;

  MENUCLASS_LOG(LOG0(FORM TMMO chunk parsed OK))

  /* Check for mandatory DATA property */
  if (sp = FindProp(tmppi->tmppi_IFFHandle, ID_TMMO, ID_DATA)) {
   struct MenuClassData *mcd = TYPED_INST_DATA(cl, obj);
   struct MenuDATAChunk *mdc = sp->sp_Data;

   MENUCLASS_LOG(LOG2(Data, "Exec 0x%08lx Sound 0x%08lx", mdc->mdc_ExecObject,
                      mdc->mdc_SoundObject))

   /* Create menu item */
   if (mcd->mcd_AppObject = CreateAppMenuItem(obj)) {
    struct TMHandle *tmh;

    MENUCLASS_LOG(LOG1(AppObject, "0x%08lx", mcd->mcd_AppObject))

    /* Get TMHandle */
    GetAttr(TMA_TMHandle, obj, (ULONG *) &tmh);

    /* Attach Exec object */
    if (mdc->mdc_ExecObject) {
     Object *execobj;

     /* Find exec object */
     if (execobj = FindTypedIDTMObject(tmh, mdc->mdc_ExecObject,
                                       TMOBJTYPE_EXEC)) {

      MENUCLASS_LOG(LOG1(Exec, "0x%08lx", execobj))

      /* Attach to exec object */
      mcd->mcd_ExecObject = (struct TMMemberData *)
       DoMethod(execobj, TMM_Attach, obj, TMV_Attach_Normal);

      MENUCLASS_LOG(LOG1(Exec Data, "0x%08lx", mcd->mcd_ExecObject))
     }
    }

    /* Attach sound object */
    if (mdc->mdc_SoundObject) {
     Object *soundobj;

     /* Find sound object */
     if (soundobj = FindTypedIDTMObject(tmh, mdc->mdc_SoundObject,
                                        TMOBJTYPE_SOUND)) {

      MENUCLASS_LOG(LOG1(Sound, "0x%08lx", soundobj))

      /* Attach to sound object */
      mcd->mcd_SoundObject = (struct TMMemberData *)
       DoMethod(soundobj, TMM_Attach, obj, TMV_Attach_Normal);

      MENUCLASS_LOG(LOG1(Sound Data, "0x%08lx", mcd->mcd_SoundObject))
     }
    }

    /* Configuration data parsed */
    rc = TRUE;
   }
  }
 }

 MENUCLASS_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Menu class method: TMM_ParseTags */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION MenuClassParseTags
static ULONG MenuClassParseTags(Class *cl, Object *obj,
                                struct TMP_ParseTags *tmppt)
{
 struct MenuClassData *mcd = TYPED_INST_DATA(cl, obj);
 BOOL                  rc  = FALSE;

 MENUCLASS_LOG((LOG1(Tags, "0x%08lx", tmppt->tmppt_Tags),
                PrintTagList(tmppt->tmppt_Tags)))

 /* Create menu item if not already created */
 if (mcd->mcd_AppObject ||
     (mcd->mcd_AppObject = CreateAppMenuItem(obj))) {
  struct TagItem  *tstate = tmppt->tmppt_Tags;
  struct TagItem  *ti;
  struct TMHandle *tmh;

  MENUCLASS_LOG(LOG1(AppObject, "0x%08lx", mcd->mcd_AppObject))

  /* Reset error code */
  rc = TRUE;

  /* Get TMHandle */
  GetAttr(TMA_TMHandle, obj, (ULONG *) &tmh);

  /* Scan tag list */
  while (ti = NextTagItem(&tstate))

   /* Which tag? */
   switch (ti->ti_Tag) {
    case TMOP_Exec: {
      Object *newobj;

      /* Release old object first */
      if (mcd->mcd_ExecObject) DoMethod(mcd->mcd_ExecObject->tmmd_Object,
                                        TMM_Detach, mcd->mcd_ExecObject);

      /* Object name valid and does the object exist? */
      if (ti->ti_Data &&
          (newobj = FindTypedNamedTMObject(tmh, (char *) ti->ti_Data,
                                           TMOBJTYPE_EXEC))) {

        MENUCLASS_LOG(LOG1(Exec, "0x%08lx", newobj))

        /* Yes, attach new object */
        mcd->mcd_ExecObject = (struct TMMemberData *)
                               DoMethod(newobj, TMM_Attach, obj,
                                        TMV_Attach_Normal);

       } else

        /* No, clear pointer */
        mcd->mcd_ExecObject = NULL;

      MENUCLASS_LOG(LOG1(Exec Attach, "0x%08lx", mcd->mcd_ExecObject))
     }
     break;

    case TMOP_Sound: {
      Object *newobj;

      /* Release old object first */
      if (mcd->mcd_SoundObject) DoMethod(mcd->mcd_SoundObject->tmmd_Object,
                                         TMM_Detach, mcd->mcd_SoundObject);

      /* Object name valid and does the object exist? */
      if (ti->ti_Data &&
          (newobj = FindTypedNamedTMObject(tmh, (char *) ti->ti_Data,
                                           TMOBJTYPE_SOUND))) {

        MENUCLASS_LOG(LOG1(Sound, "0x%08lx", newobj))

        /* Yes, attach new object */
        mcd->mcd_SoundObject = (struct TMMemberData *)
                                DoMethod(newobj, TMM_Attach, obj,
                                         TMV_Attach_Normal);

       } else

        /* No, clear pointer */
        mcd->mcd_SoundObject = NULL;

      MENUCLASS_LOG(LOG1(Sound Attach, "0x%08lx", mcd->mcd_SoundObject))
     }
     break;
   }
 }

 MENUCLASS_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Menu class method: TMM_Activate */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION MenuClassActivate
static ULONG MenuClassActivate(Class *cl, Object *obj,
                               struct TMP_Activate *tmpa)
{
 struct MenuClassData *mcd = TYPED_INST_DATA(cl, obj);

 MENUCLASS_LOG(LOG1(Data, "0x%08lx", tmpa->tmpa_Data))

 /* Activate sound object */
 if (mcd->mcd_SoundObject) DoMethod(mcd->mcd_SoundObject->tmmd_Object,
                                    TMM_Activate, NULL);

 /* Activate Exec object */
 if (mcd->mcd_ExecObject) DoMethod(mcd->mcd_ExecObject->tmmd_Object,
                                   TMM_Activate, tmpa->tmpa_Data);

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* Menu class dispatcher */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION MenuClassDispatcher
static __geta4 ULONG MenuClassDispatcher(__A0 Class *cl, __A2 Object *obj,
                                         __A1 Msg msg)
{
 ULONG rc;

 MENUCLASS_LOG(LOG3(Arguments, "Class 0x%08lx Object 0x%08lx Msg 0x%08lx",
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
  case TMM_Release:
   rc = MenuClassRelease(cl, obj, (struct TMP_Detach *) msg);
   break;

  case TMM_ParseIFF:
   rc = MenuClassParseIFF(cl, obj, (struct TMP_ParseIFF *) msg);
   break;

  case TMM_ParseTags:
   rc = MenuClassParseTags(cl, obj, (struct TMP_ParseTags *) msg);
   break;

  case TMM_Activate:
   rc = MenuClassActivate(cl, obj, (struct TMP_Activate *) msg);
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
Class *CreateMenuClass(Class *superclass)
{
 Class *cl;

 MENUCLASS_LOG(LOG1(SuperClass, "0x%08lx", superclass))

 /* Create class */
 if (cl = MakeClass(NULL, NULL, superclass, sizeof(struct MenuClassData), 0))

  /* Set dispatcher */
  cl->cl_Dispatcher.h_Entry = (ULONG (*)()) MenuClassDispatcher;

 MENUCLASS_LOG(LOG1(Class, "0x%08lx", cl))

 /* Return pointer to class */
 return(cl);
}
