/*
 * cliplist.c  V3.1
 *
 * Class for TM objects clipboard window
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
static const char *TextColumnName;
static const char *TextColumnType;

/* ClipList class instance data */
struct ClipListClassData {
 struct Hook clcd_Construct;
};
#define TYPED_INST_DATA(cl, o) ((struct ClipListClassData *) INST_DATA((cl), (o)))

/* ClipList class construct function */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ClipListClassConstruct
__geta4 static ULONG ClipListClassConstruct(__a0 struct Hook *h,
                                            __a1 Object *obj)
{
 /* Attach to object */
 return((ULONG) DoMethod(obj, TMM_Attach, h->h_Data));
}

/* ClipList class destruct function */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ClipListClassDestruct
__geta4 static void ClipListClassDestruct(__a1 struct AttachData *ad)
{
 /* Detach from object if not a notify event */
 if (ad->ad_Object) DoMethod(ad->ad_Object, TMM_Detach, ad);
}

/* ClipList class display function */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ClipListClassDisplay
__geta4 static void ClipListClassDisplay(__a1 struct AttachData *ad,
                                         __a2 const char **array)
{
 /* Entry valid? */
 if (ad) {
  ULONG type;

  /* Yes, get object name */
  GetAttr(TMA_Name, ad->ad_Object,  (ULONG *) array++);

  /* Get object type */
  GetAttr(TMA_Type, ad->ad_Object,  &type);

  /* Set second column text according to object type */
  switch (type) {
   case TMOBJTYPE_EXEC:  *array = TextGlobalExecObject;  break;
   case TMOBJTYPE_IMAGE: *array = TextGlobalImageObject; break;
   case TMOBJTYPE_SOUND: *array = TextGlobalSoundObject; break;
  }

 } else {

  /* No, create title column */
  *array++ = TextColumnName;
  *array   = TextColumnType;
 }
}

/* Hooks */
static const struct Hook DestructHook = {
 {NULL, NULL}, (void *) ClipListClassDestruct, NULL, NULL
};
static const struct Hook DisplayHook = {
 {NULL, NULL}, (void *) ClipListClassDisplay, NULL, NULL
};

/* ClipList class method: OM_NEW */
#define DEBUGFUNCTION ClipListClassNew
static ULONG ClipListClassNew(Class *cl, Object *obj, struct opSet *ops)
{
 CLIPLIST_LOG((LOG1(Tags, "0x%08lx", ops->ops_AttrList),
               PrintTagList(ops->ops_AttrList)))

 /* Create object */
 if (obj = (Object *) DoSuperNew(cl, obj,
                                 MUIA_List_DestructHook,  &DestructHook,
                                 MUIA_List_DisplayHook,   &DisplayHook,
                                 MUIA_List_Format,        "BAR,",
                                 MUIA_List_ShowDropMarks, FALSE,
                                 MUIA_List_Title,         TRUE,
                                 TAG_MORE,               ops->ops_AttrList)) {
  struct ClipListClassData *clcd = TYPED_INST_DATA(cl, obj);

  /* Initialize construct hook */
  clcd->clcd_Construct.h_Entry = (void *) ClipListClassConstruct;
  clcd->clcd_Construct.h_Data  = obj;

  /* Set construct hook */
  SetAttrs(obj, MUIA_List_ConstructHook, &clcd->clcd_Construct, TAG_DONE);
 }

 CLIPLIST_LOG(LOG1(Result, "0x%08lx", obj))

 /* Return pointer to created object */
 return((ULONG) obj);
}

/* ClipList class method: OM_GET */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ClipListClassGet
static ULONG ClipListClassGet(Class *cl, Object *obj, struct opGet *opg)
{
 ULONG rc;

 CLIPLIST_LOG(LOG2(Attribute, "0x%08lx (%s)", opg->opg_AttrID,
                   GetTagName(opg->opg_AttrID)))

 /* Which attribute is requested? */
 switch(opg->opg_AttrID) {
  case TMA_Active: {
    struct AttachData *ad;

    /* Get active entry */
    DoMethod(obj, MUIM_List_GetEntry, MUIV_List_GetEntry_Active,
             (ULONG *) &ad);

    /* If active entry is valid return pointer to attached object */
    *opg->opg_Storage = (ULONG) (ad ? ad->ad_Object : NULL);

    /* Return TRUE to indicate that the attribute is implemented */
    rc = TRUE;
   }
   break;

  default:
   rc = DoSuperMethodA(cl, obj, (Msg) opg);
   break;
 }

 CLIPLIST_LOG(LOG2(Result, "%ld value 0x%08lx", rc, *opg->opg_Storage))

 return(rc);
}

/* ClipList class method: MUIM_DragQuery */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ClipListClassDragQuery
static ULONG ClipListClassDragQuery(Class *cl, Object *obj,
                                    struct MUIP_DragQuery *mpdq)
{
 ULONG rc = MUIV_DragQuery_Refuse;

#if DEBUG_VERY_NOISY
 /* This just generates too much debug output... */
 CLIPLIST_LOG(LOG2(Arguments, "Object 0x%08lx Source 0x%08lx", obj,
                   mpdq->obj))
#endif

 /* Is source our list? */
 if (mpdq->obj != obj) {
  Object *active;
  ULONG   type   = TMOBJTYPES;

  /* No, get active entry */
  if (GetAttr(TMA_Active, mpdq->obj, (ULONG *) &active))

   /* Get type of object */
   GetAttr(TMA_Type, active, &type);

  /* Check type, only Exec, Image and Sound objects are accepted */
  if (type <= TMOBJTYPE_SOUND) rc = MUIV_DragQuery_Accept;
 }

 return(rc);
}

/* ClipList class method: MUIM_DragDrop */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ClipListClassDragDrop
static ULONG ClipListClassDragDrop(Class *cl, Object *obj,
                                   struct MUIP_DragDrop *mpdd)
{
 Object *active;

 /* Get active entry */
 GetAttr(TMA_Active, mpdd->obj, (ULONG *) &active);

 CLIPLIST_LOG(LOG1(Object, "0x%08lx", active))

 /* Insert object */
 DoMethod(obj, MUIM_List_InsertSingle, active, MUIV_List_Insert_Bottom);

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* ClipList class method: TMM_Notify */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ClipListClassNotify
static ULONG ClipListClassNotify(Class *cl, Object *obj,
                                 struct TMP_Notify *tmpn)
{
 int                i  = -1;
 struct AttachData *ad;

 CLIPLIST_LOG(LOG2(Arguments, "Attach 0x%08lx Object 0x%08lx",
                   tmpn->tmpn_Data, tmpn->tmpn_Data->ad_Object))

 /* For each entry in list */
 do {

  /* Get next entry */
  DoMethod(obj, MUIM_List_GetEntry, ++i, &ad);

  CLIPLIST_LOG(LOG1(Next entry, "0x%08lx", ad))

  /* AttachData found? */
  if (ad == tmpn->tmpn_Data) {
   ULONG method;

   /* Object deleted? Yes, remove entry, otherwise redraw it */
   method = (tmpn->tmpn_Data->ad_Object == NULL) ? MUIM_List_Remove :
                                                   MUIM_List_Redraw;

   CLIPLIST_LOG(LOG1(Method, "0x%08lx", method))

   /* Call method */
   DoMethod(obj, method, i);

   /* Leave loop */
   break;
  }

 } while (ad);

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* ClipList class method: TMM_DoubleClicked */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ClipListClassDoubleClicked
static ULONG ClipListClassDoubleClicked(Class *cl, Object *obj)
{
 struct AttachData *ad;

 CLIPLIST_LOG(LOG0(Entry))

 /* Get active entry */
 DoMethod(obj, MUIM_List_GetEntry, MUIV_List_GetEntry_Active, &ad);

 /* Call Edit method on the object */
 DoMethod(ad->ad_Object, TMM_Edit, NULL);

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* ClipList class method dispatcher */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ClipListClassDispatcher
__geta4 static ULONG ClipListClassDispatcher(__a0 Class *cl, __a2 Object *obj,
                                             __a1 Msg msg)
{
 ULONG rc;

 CLIPLIST_LOG(LOG3(Arguments, "Class 0x%08lx Object 0x%08lx Msg 0x%08lx",
                   cl, obj, msg))

 switch(msg->MethodID) {
  /* BOOPSI methods */
  case OM_NEW:
   rc = ClipListClassNew(cl, obj, (struct opSet *) msg);
   break;

  case OM_GET:
   rc = ClipListClassGet(cl, obj, (struct opGet *) msg);
   break;

  /* MUI methods */
  case MUIM_DragQuery:
   rc = ClipListClassDragQuery(cl, obj, (struct MUIP_DragQuery *) msg);
   break;

  case MUIM_DragDrop:
   rc = ClipListClassDragDrop(cl, obj, (struct MUIP_DragDrop *) msg);
   break;

  /* TM methods */
  case TMM_Notify:
   rc = ClipListClassNotify(cl, obj, (struct TMP_Notify *) msg);
   break;

  case TMM_DoubleClicked:
   rc = ClipListClassDoubleClicked(cl, obj);
   break;

  /* Unknown method -> delegate to SuperClass */
  default:
   rc = DoSuperMethodA(cl, obj, msg);
   break;
 }

 return(rc);
}

/* Create ClipList class */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CreateClipListClass
struct MUI_CustomClass *CreateClipListClass(void)
{
 struct MUI_CustomClass *rc;

 /* Create class */
 if (rc = MUI_CreateCustomClass(NULL, MUIC_List, NULL,
                                sizeof(struct ClipListClassData),
                                ClipListClassDispatcher)) {

  /* Localize strings */
  TextColumnName = TranslateString(LOCALE_TEXT_CLIPLIST_COLUMN_NAME_STR,
                                   LOCALE_TEXT_CLIPLIST_COLUMN_NAME);
  TextColumnType = TranslateString(LOCALE_TEXT_CLIPLIST_COLUMN_TYPE_STR,
                                   LOCALE_TEXT_CLIPLIST_COLUMN_TYPE);
 }

 CLIPLIST_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}
