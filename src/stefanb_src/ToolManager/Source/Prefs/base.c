/*
 * base.c  V3.1
 *
 * Base class for TM objects
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
static const char *TextName;
static const char *HelpName;

/* Base class instance data */
struct BaseClassData {
 struct MinList  bcd_AttachList;
 char           *bcd_Name;
 ULONG           bcd_ID;
 ULONG           bcd_Type;
 Object         *bcd_List;
 Object         *bcd_Root;
 Object         *bcd_Active;
 Object         *bcd_String;
 Object         *bcd_Child;
 Object         *bcd_Buttons;
};
#define TYPED_INST_DATA(cl, o) ((struct BaseClassData *) INST_DATA((cl), (o)))

/* Base class method: OM_NEW */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION BaseClassNew
static ULONG BaseClassNew(Class *cl, Object *obj, struct opSet *ops)
{
 Object     *rc   = NULL;
 const char *name;

 BASE_LOG((LOG1(Tags, "0x%08lx", ops->ops_AttrList),
           PrintTagList(ops->ops_AttrList)))

 /* Duplicate name */
 if (name = DuplicateString((const char *)
                             GetTagData(TMA_Name, NULL, ops->ops_AttrList))) {
  Object *Root;

  BASE_LOG(LOG2(Name, "%s (0x%08lx)", name, name))

  /* Create object */
  if (rc = (Object *) DoSuperNew(cl, obj,
                                   MUIA_Window_AppWindow, TRUE,
                                   WindowContents,        Root = VGroup,
                                   End,
                                   TAG_MORE,              ops->ops_AttrList)) {
   struct BaseClassData *bcd = TYPED_INST_DATA(cl, rc);

   BASE_LOG(LOG1(Root, "0x%08lx", Root))

   /* Initialize attach list */
   NewList((struct List *) &bcd->bcd_AttachList);

   /* Initialize instance data */
   bcd->bcd_Name    = name;
   bcd->bcd_ID      = 0;
   bcd->bcd_Type    = GetTagData(TMA_Type, 0, ops->ops_AttrList);
   bcd->bcd_List    = (Object *) GetTagData(TMA_List, NULL, ops->ops_AttrList);
   bcd->bcd_Root    = Root;
   bcd->bcd_Active  = NULL;

   /* Window action */
   DoMethod(rc, MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
            bcd->bcd_List, 3, TMM_Update, rc, TMV_Finish_Cancel);

   /* AppWindow action */
   DoMethod(rc, MUIM_Notify, MUIA_AppMessage, MUIV_EveryTime,
            rc, 3, MUIM_CallHook, &AppMessageHook, MUIV_TriggerValue);

  } else

   /* Couldn't create object, free name */
   FreeVector(name);
 }

 BASE_LOG(LOG1(Result, "0x%08lx", rc))

 /* Return pointer to created object */
 return((ULONG) rc);
}

/* Base class method: OM_DISPOSE */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION BaseClassDispose
static ULONG BaseClassDispose(Class *cl, Object *obj, Msg msg)
{
 struct BaseClassData *bcd = TYPED_INST_DATA(cl, obj);

 BASE_LOG(LOG1(Disposing, "0x%08lx", obj))

 /* Close edit window first */
 DoMethod(obj, TMM_Finish, TMV_Finish_Cancel);

 /* Notify all attached objects */
 {
  struct AttachData *ad;

  /* For each attached object */
  while (ad = (struct AttachData *)
               RemHead((struct List *) &bcd->bcd_AttachList)) {

   BASE_LOG(LOG1(Notify, "0x%08lx", ad->ad_AttachedTo))

   /* Clear object pointer -> object is going to be disposed */
   ad->ad_Object = NULL;

   /* Send notification */
   DoMethod(ad->ad_AttachedTo, TMM_Notify, ad);

   /* Free attach data */
   FreeMemory(ad, sizeof(struct AttachData));
  }
 }

 /* Free name */
 FreeVector(bcd->bcd_Name);

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, msg));
}

/* Base class method: OM_SET */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION BaseClassSet
static ULONG BaseClassSet(Class *cl, Object *obj, struct opSet *ops)
{
 struct TagItem *tstate = ops->ops_AttrList;
 struct TagItem *ti;

 BASE_LOG((LOG1(Tags, "0x%08lx", ops->ops_AttrList),
                PrintTagList(ops->ops_AttrList)))

 /* Scan tag list */
 while (ti = NextTagItem(&tstate))

  /* Which attribute shall be set? */
  switch (ti->ti_Tag) {
   case TMA_ID:
    TYPED_INST_DATA(cl, obj)->bcd_ID = ti->ti_Data;
    break;

   case TMA_Name: {
     char *newname;

     BASE_LOG(LOG2(Name, "%s (0x%08lx)", ti->ti_Data, ti->ti_Data))
     /* Duplicate new name */
     if (newname = DuplicateString((const char *) ti->ti_Data)) {
      struct BaseClassData *bcd = TYPED_INST_DATA(cl, obj);
      struct AttachData    *ad  = (struct AttachData *)
                                   GetHead(&bcd->bcd_AttachList);

      BASE_LOG(LOG2(New Name, "%s (0x%08lx)", newname, newname))

      /* Free old name */
      FreeVector(bcd->bcd_Name);

      /* Set new name */
      bcd->bcd_Name = newname;

      /* Notify all attached objects */
      while (ad) {

       BASE_LOG(LOG1(Notify, "0x%08lx", ad->ad_AttachedTo))

       /* Send notification */
       DoMethod(ad->ad_AttachedTo, TMM_Notify, ad);

       /* Next object */
       ad = (struct AttachData *) GetSucc((struct MinNode *) ad);
      }
     }
    }
    break;
  }

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, (Msg) ops));
}

/* Base class method: OM_GET */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION BaseClassGet
static ULONG BaseClassGet(Class *cl, Object *obj, struct opGet *opg)
{
 ULONG rc;

 BASE_LOG(LOG2(Attribute, "0x%08lx (%s)", opg->opg_AttrID,
               GetTagName(opg->opg_AttrID)))

 /* Which attribute is requested? */
 switch(opg->opg_AttrID) {
  case TMA_Name:
   *opg->opg_Storage = (ULONG) TYPED_INST_DATA(cl, obj)->bcd_Name;

   /* Return TRUE to indicate that the attribute is implemented */
   rc = TRUE;
   break;

  case TMA_ID:
   *opg->opg_Storage = TYPED_INST_DATA(cl, obj)->bcd_ID;

   /* Return TRUE to indicate that the attribute is implemented */
   rc = TRUE;
   break;

  case TMA_Type:
   *opg->opg_Storage = TYPED_INST_DATA(cl, obj)->bcd_Type;

   /* Return TRUE to indicate that the attribute is implemented */
   rc = TRUE;
   break;

  default:
   rc = DoSuperMethodA(cl, obj, (Msg) opg);
   break;
 }

 BASE_LOG(LOG2(Result, "%ld value 0x%08lx", rc, *opg->opg_Storage))

 return(rc);
}

/* Base class method: TMM_Finish */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION BaseClassFinish
static ULONG BaseClassFinish(Class *cl, Object *obj, struct TMP_Finish *tmpf)
{
 struct BaseClassData *bcd = TYPED_INST_DATA(cl, obj);

 BASE_LOG(LOG1(Type, "%ld", tmpf->tmpf_Type))

 /* MUI objects allocated? */
 if (bcd->bcd_Active) {

  BASE_LOG(LOG0(Closing Window))

  /* Yes, close window */
  set(obj, MUIA_Window_Open, FALSE);

  /* Use or Cancel? */
  if (tmpf->tmpf_Type == TMV_Finish_Use) {
   char *name;

   /* Get new name */
   GetAttr(MUIA_String_Contents, bcd->bcd_String, (ULONG *) &name);

   /* Set new name */
   SetAttrs(obj, TMA_Name, name, TAG_DONE);
  }

  /* Remove object from application */
  DoMethod(_app(obj),     OM_REMMEMBER, obj);

  /* Remove objects from root group */
  DoMethod(bcd->bcd_Root, OM_REMMEMBER, bcd->bcd_Buttons);
  if (bcd->bcd_Child) DoMethod(bcd->bcd_Root, OM_REMMEMBER, bcd->bcd_Child);
  DoMethod(bcd->bcd_Root, OM_REMMEMBER, bcd->bcd_Active);

  /* Delete objects */
  MUI_DisposeObject(bcd->bcd_Buttons);
  MUI_DisposeObject(bcd->bcd_Active);
  if (bcd->bcd_Child) MUI_DisposeObject(bcd->bcd_Child);

  /* Reset active flag */
  bcd->bcd_Active = NULL;
 }

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* Base class method: TMM_Attach */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION BaseClassAttach
static ULONG BaseClassAttach(Class *cl, Object *obj, struct TMP_Attach *tmpa)
{
 struct AttachData *rc;

 BASE_LOG(LOG1(Object, "0x%08lx", tmpa->tmpa_Object))

 /* Allocate memory for attach data */
 if (rc = GetMemory(sizeof(struct AttachData))) {

  BASE_LOG(LOG1(Attach Data, "0x%08lx", rc))

  /* Initialize attach data */
  rc->ad_Object     = obj;
  rc->ad_AttachedTo = tmpa->tmpa_Object;

  /* Append attach data to list */
  AddTail((struct List *) &TYPED_INST_DATA(cl, obj)->bcd_AttachList,
          (struct Node *) rc);
 }

 BASE_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}

/* Base class method: TMM_Detach */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION BaseClassDetach
static ULONG BaseClassDetach(Class *cl, Object *obj, struct TMP_Detach *tmpd)
{
 BASE_LOG(LOG1(Data, "0x%08lx", tmpd->tmpd_Data))

 /* Remove attach data from list */
 Remove((struct Node *) tmpd->tmpd_Data);

 /* Free attach data */
 FreeMemory(tmpd->tmpd_Data, sizeof(struct AttachData));

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* Base class method: TMM_Edit */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION BaseClassEdit
static ULONG BaseClassEdit(Class *cl, Object *obj, struct TMP_Edit *tmpe)
{
 struct BaseClassData *bcd  = TYPED_INST_DATA(cl, obj);

 BASE_LOG(LOG1(Arguments, "Group 0x%08lx", tmpe->tmpe_Group))

 /* Already editing? */
 if (bcd->bcd_Active) {

  /* Yes, move window to front */
  DoMethod(obj, MUIM_Window_ToFront);

  /* Activate window */
  set(obj, MUIA_Window_Activate, TRUE);

 /* No, create Name area */
 } else if (bcd->bcd_Active = HGroup,
                               Child, Label2(TextName),
                               Child, bcd->bcd_String =
                                TMString(bcd->bcd_Name, LENGTH_STRING,
                                         HelpName),
                              End) {
  Object *UseButton;
  Object *CancelButton;

  BASE_LOG(LOG1(Name Area, "0x%08lx", bcd->bcd_Active))

  /* Create ButtonArea */
  if (bcd->bcd_Buttons = HGroup,
                          Child, UseButton    = MakeButton(TextGlobalUse,
                                                           HelpGlobalUse),
                          Child, HSpace(0),
                          Child, CancelButton = MakeButton(TextGlobalCancel,
                                                           HelpGlobalCancel),
                         End) {

   BASE_LOG(LOG1(Button Area, "0x%08lx", bcd->bcd_Buttons))

   /* Add objects to root group */
   DoMethod(bcd->bcd_Root, OM_ADDMEMBER, bcd->bcd_Active);
   if (bcd->bcd_Child = tmpe->tmpe_Group)
    DoMethod(bcd->bcd_Root, OM_ADDMEMBER, bcd->bcd_Child);
   DoMethod(bcd->bcd_Root, OM_ADDMEMBER, bcd->bcd_Buttons);

   /* Button actions                                           */
   /* NOTE: The Method has to be pushed because button objects */
   /*       are disposed during the execution of the method!   */
   DoMethod(UseButton,    MUIM_Notify, MUIA_Pressed, FALSE,
            MUIV_Notify_Application, 6, MUIM_Application_PushMethod,
            bcd->bcd_List, 3, TMM_Update, obj, TMV_Finish_Use);
   DoMethod(CancelButton, MUIM_Notify, MUIA_Pressed, FALSE,
            MUIV_Notify_Application, 6, MUIM_Application_PushMethod,
            bcd->bcd_List, 3, TMM_Update, obj, TMV_Finish_Cancel);

   /* String action (only if no child objects) */
   if (bcd->bcd_Child == NULL)
    DoMethod(bcd->bcd_String, MUIM_Notify,
             MUIA_String_Acknowledge, MUIV_EveryTime,
             MUIV_Notify_Application, 6, MUIM_Application_PushMethod,
             bcd->bcd_List, 3, TMM_Update, obj, TMV_Finish_Use);

   /* Add object to application */
   DoMethod(_app(bcd->bcd_List), OM_ADDMEMBER, obj);

   /* Position window and activate name string gadget */
   SetAttrs(obj, MUIA_Window_LeftEdge,     MUIV_Window_LeftEdge_Moused,
                 MUIA_Window_TopEdge,      MUIV_Window_TopEdge_Moused,
                 MUIA_Window_ActiveObject, bcd->bcd_String,
                 TAG_DONE);

   /* Open window */
   SetAttrs(obj, MUIA_Window_Open, TRUE, TAG_DONE);

  } else {
   /* Can't create button area, delete name area again */
   MUI_DisposeObject(bcd->bcd_Active);
   bcd->bcd_Active = NULL;
  }
 }

 BASE_LOG(LOG1(Result, "0x%08lx", bcd->bcd_Active))

 /* Return pointer to name area object to indicate success */
 return((ULONG) bcd->bcd_Active);
}

/* Base class method: TMM_WriteIFF */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION BaseClassWriteIFF
static ULONG BaseClassWriteIFF(Class *cl, Object *obj,
                               struct TMP_WriteIFF *tmpwi)
{
 BOOL rc;

 BASE_LOG(LOG1(Arguments, "IFFHandle 0x%08lx", tmpwi->tmpwi_IFFHandle))

 rc = WriteStringProperty(tmpwi->tmpwi_IFFHandle, ID_NAME,
                          TYPED_INST_DATA(cl, obj)->bcd_Name);

 BASE_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Base class method: TMM_WBArg */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION BaseClassWBArg
static ULONG BaseClassWBArg(Class *cl, Object *obj, struct TMP_WBArg *tmpwa)
{
 struct BaseClassData *bcd  = TYPED_INST_DATA(cl, obj);
 char                 *name = tmpwa->tmpwa_Argument->wa_Name;
 ULONG                 rc   = 0;

 BASE_LOG(LOG2(Name, "%s (0x%08lx)", name, name))

 /* Edit active and icon name valid? */
 if (bcd->bcd_Active && name && (*name != '\0')) {

  BASE_LOG(LOG0(Edit active))

  /* Yes, set name string */
  SetAttrs(bcd->bcd_String, MUIA_String_Contents, name, TAG_DONE);

  /* Set object name */
  SetAttrs(obj, TMA_Name, name, TAG_DONE);

  /* Return pointer to ourself */
  rc = (ULONG) obj;
 }

 BASE_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}

/* Base class method dispatcher */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION BaseClassDispatcher
__geta4 static ULONG BaseClassDispatcher(__a0 Class *cl, __a2 Object *obj,
                                         __a1 Msg msg)
{
 ULONG rc;

 BASE_LOG(LOG3(Arguments, "Class 0x%08lx Object 0x%08lx Msg 0x%08lx",
               cl, obj, msg))

 switch(msg->MethodID) {
  /* BOOPSI methods */
  case OM_NEW:
   rc = BaseClassNew(cl, obj, (struct opSet *) msg);
   break;

  case OM_DISPOSE:
   rc = BaseClassDispose(cl, obj, msg);
   break;

  case OM_SET:
   rc = BaseClassSet(cl, obj, (struct opSet *) msg);
   break;

  case OM_GET:
   rc = BaseClassGet(cl, obj, (struct opGet *) msg);
   break;

  /* TM methods */
  case TMM_Finish:
   rc = BaseClassFinish(cl, obj, (struct TMP_Finish *) msg);
   break;

  case TMM_Attach:
   rc = BaseClassAttach(cl, obj, (struct TMP_Attach *) msg);
   break;

  case TMM_Detach:
   rc = BaseClassDetach(cl, obj, (struct TMP_Detach *) msg);
   break;

  case TMM_Edit:
   rc = BaseClassEdit(cl, obj, (struct TMP_Edit *) msg);
   break;

  case TMM_WriteIFF:
   rc = BaseClassWriteIFF(cl, obj, (struct TMP_WriteIFF *) msg);
   break;

  case TMM_WBArg:
   rc = BaseClassWBArg(cl, obj, (struct TMP_WBArg *) msg);
   break;

  /* Unknown method -> delegate to SuperClass */
  default:
   rc = DoSuperMethodA(cl, obj, msg);
   break;
 }

 return(rc);
}

/* Create Base class */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CreateBaseClass
struct MUI_CustomClass *CreateBaseClass(void)
{
 struct MUI_CustomClass *rc;

 /* Create class */
 if (rc = MUI_CreateCustomClass(NULL, MUIC_Window, NULL,
                                sizeof(struct BaseClassData),
                                BaseClassDispatcher)) {

  /* Localize strings */
  TextName   = TranslateString(LOCALE_TEXT_BASE_NAME_STR,
                               LOCALE_TEXT_BASE_NAME);
  HelpName   = TranslateString(LOCALE_HELP_BASE_NAME_STR,
                               LOCALE_HELP_BASE_NAME);
 }

 BASE_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}
