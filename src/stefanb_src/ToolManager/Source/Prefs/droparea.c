/*
 * droparea.c  V3.1
 *
 * Class to drop TM objects on
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

/* DropArea class instance data */
struct DropAreaClassData {
 ULONG              dacd_Type;
 struct AttachData *dacd_Data;
};
#define TYPED_INST_DATA(cl, o) ((struct DropAreaClassData *) INST_DATA((cl), (o)))

/* DropArea class method: OM_NEW */
#define DEBUGFUNCTION DropAreaClassNew
static ULONG DropAreaClassNew(Class *cl, Object *obj, struct opSet *ops)
{
 DROPAREA_LOG((LOG1(Tags, "0x%08lx", ops->ops_AttrList),
                    PrintTagList(ops->ops_AttrList)))

 /* Create object */
 if (obj = (Object *) DoSuperNew(cl, obj,
                                    MUIA_Text_SetMin, TRUE,
                                    MUIA_Background,  MUII_TextBack,
                                    MUIA_Dropable,    TRUE,
                                    MUIA_InputMode,   MUIV_InputMode_RelVerify,
                                    TextFrame,
                                    TAG_MORE,         ops->ops_AttrList)) {
  struct DropAreaClassData *dacd = TYPED_INST_DATA(cl, obj);
  struct AttachData        *old  = (struct AttachData *)
                                    GetTagData(TMA_Attach, NULL,
                                               ops->ops_AttrList);

  /* Initialize instance data */
  dacd->dacd_Type = GetTagData(TMA_Type, 0, ops->ops_AttrList);
  dacd->dacd_Data = NULL;

  /* Old attach data valid? */
  if (old) {

   DROPAREA_LOG(LOG1(Attaching, "0x%08lx", old->ad_Object))

   /* Yes, attach to object */
   if (dacd->dacd_Data = (struct AttachData *)
                          DoMethod(old->ad_Object, TMM_Attach, obj)) {

    DROPAREA_LOG(LOG0(Attached to object))

    /* Set initial text contents */
    DoMethod(obj, TMM_Notify, dacd->dacd_Data);

    /* "Button" action */
    DoMethod(obj, MUIM_Notify, MUIA_Pressed, FALSE,
             obj, 1, TMM_DoubleClicked);

   } else {

    DROPAREA_LOG(LOG0(Could not attach object))

    /* Delete object again */
    CoerceMethod(cl, obj, OM_DISPOSE);

    /* Reset object pointer */
    obj = NULL;
   }
  }
 }

 DROPAREA_LOG(LOG1(Result, "0x%08lx", obj))

 /* Return pointer to created object */
 return((ULONG) obj);
}

/* DropArea class method: OM_DISPOSE */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DropAreaClassDispose
static ULONG DropAreaClassDispose(Class *cl, Object *obj, Msg msg)
{
 struct DropAreaClassData *dacd = TYPED_INST_DATA(cl, obj);

 DROPAREA_LOG(LOG1(Disposing, "0x%08lx", obj))

 /* Detach object */
 if (dacd->dacd_Data) DoMethod(dacd->dacd_Data->ad_Object, TMM_Detach,
                               dacd->dacd_Data);

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, msg));
}

/* Base class method: OM_SET */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DropAreaClassSet
static ULONG DropAreaClassSet(Class *cl, Object *obj, struct opSet *ops)
{
 struct TagItem *tstate = ops->ops_AttrList;
 struct TagItem *ti;

 DROPAREA_LOG((LOG1(Tags, "0x%08lx", ops->ops_AttrList),
               PrintTagList(ops->ops_AttrList)))

 /* Scan tag list */
 while (ti = NextTagItem(&tstate))

  /* Which attribute shall be set? */
  switch (ti->ti_Tag) {
   case TMA_Object: {
     struct AttachData *new;

     /* Attach to new object */
     if (new = (struct AttachData *) DoMethod((Object *) ti->ti_Data,
                                              TMM_Attach, obj)) {
      struct DropAreaClassData *dacd = TYPED_INST_DATA(cl, obj);

      DROPAREA_LOG(LOG1(Attach, "0x%08lx", new))

      /* Detach old object */
      if (dacd->dacd_Data) DoMethod(dacd->dacd_Data->ad_Object, TMM_Detach,
                                    dacd->dacd_Data);

      /* Set new object */
      dacd->dacd_Data = new;

      /* Update contents */
      DoMethod(obj, TMM_Notify, new);
     }
    }
    break;
  }

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, (Msg) ops));
}

/* DropArea class method: OM_GET */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DropAreaClassGet
static ULONG DropAreaClassGet(Class *cl, Object *obj, struct opGet *opg)
{
 ULONG rc;

 DROPAREA_LOG(LOG2(Attribute, "0x%08lx (%s)", opg->opg_AttrID,
                   GetTagName(opg->opg_AttrID)))

 /* Which attribute is requested? */
 switch(opg->opg_AttrID) {
  case TMA_Attach:
   *opg->opg_Storage = (ULONG) TYPED_INST_DATA(cl, obj)->dacd_Data;

   /* Return TRUE to indicate that the attribute is implemented */
   rc = TRUE;
   break;

  default:
   rc = DoSuperMethodA(cl, obj, (Msg) opg);
   break;
 }

 DROPAREA_LOG(LOG2(Result, "%ld value 0x%08lx", rc, *opg->opg_Storage))

 return(rc);
}

/* DropArea class method: MUIM_DragQuery */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DropAreaClassDragQuery
static ULONG DropAreaClassDragQuery(Class *cl, Object *obj,
                                    struct MUIP_DragQuery *mpdq)
{
 Object *src;
 ULONG   type = TMOBJTYPES;

#if DEBUG_VERY_NOISY
 /* This just generates too much debug output... */
 DROPAREA_LOG(LOG1(Arguments, "Source 0x%08lx", mpdq->obj))
#endif

 /* Ask source object for active tree node */
 if (GetAttr(TMA_Active, mpdq->obj, (ULONG *) &src))

  /* Get object type */
  GetAttr(TMA_Type, src, &type);

 /* Is the type allowed? */
 return((TYPED_INST_DATA(cl, obj)->dacd_Type == type) ?
         MUIV_DragQuery_Accept : MUIV_DragQuery_Refuse);
}

/* DropArea class method: MUIM_DragDrop */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DropAreaClassDragDrop
static ULONG DropAreaClassDragDrop(Class *cl, Object *obj,
                                   struct MUIP_DragDrop *mpdd)
{
 Object            *src;
 struct AttachData *ad;

#if DEBUG_VERY_NOISY
 /* This just generates too much debug output... */
 DROPAREA_LOG(LOG1(Arguments, "Source 0x%08lx", mpdd->obj))
#endif

 /* Ask source object for active tree node */
 GetAttr(TMA_Active, mpdd->obj, (ULONG *) &src);

 /* Attach to object */
 if (ad = (struct AttachData *) DoMethod(src, TMM_Attach, obj)) {
  struct DropAreaClassData *dacd = TYPED_INST_DATA(cl, obj);

  /* Detach old object */
  if (dacd->dacd_Data) DoMethod(dacd->dacd_Data->ad_Object, TMM_Detach,
                                dacd->dacd_Data);

  /* Set new object */
  dacd->dacd_Data = ad;

  /* Update contents */
  DoMethod(obj, TMM_Notify, ad);
 }

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* DropArea class method: TMM_Notify */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DropAreaClassNotify
static ULONG DropAreaClassNotify(Class *cl, Object *obj,
                                 struct TMP_Notify *tmpn)
{
 const char *name;

 DROPAREA_LOG(LOG1(Object, "0x%08lx", tmpn->tmpn_Data->ad_Object))

 /* Object valid? */
 if (tmpn->tmpn_Data->ad_Object) {

  /* Yes, get new object name */
  GetAttr(TMA_Name, tmpn->tmpn_Data->ad_Object, (ULONG *) &name);

  DROPAREA_LOG(LOG2(New Name, "%s (0x%08lx)", name, name))

 } else {
  struct DropAreaClassData *dacd = TYPED_INST_DATA(cl, obj);

  DROPAREA_LOG(LOG0(Object has been deleted))

  /* Reset data pointer */
  dacd->dacd_Data = NULL;

  /* No name */
  name = NULL;
 }

 /* Set new text contents */
 SetAttrs(obj, MUIA_Text_Contents, name, TAG_DONE);

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* DropArea class method: TMM_DoubleClicked */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DropAreaClassDoubleClicked
static ULONG DropAreaClassDoubleClicked(Class *cl, Object *obj)
{
 struct AttachData *ad;

 DROPAREA_LOG(LOG0(Entry))

 /* Object attached? */
 if (ad = TYPED_INST_DATA(cl, obj)->dacd_Data) {

  DROPAREA_LOG(LOG1(Attach, "0x%08lx", ad))

  /* Yes, all Edit method on the object */
  DoMethod(ad->ad_Object, TMM_Edit, NULL);
 }

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* DropArea class method dispatcher */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DropAreaClassDispatcher
__geta4 static ULONG DropAreaClassDispatcher(__a0 Class *cl, __a2 Object *obj,
                                             __a1 Msg msg)
{
 ULONG rc;

 DROPAREA_LOG(LOG3(Arguments, "Class 0x%08lx Object 0x%08lx Msg 0x%08lx",
                cl, obj, msg))

 switch(msg->MethodID) {
  /* BOOPSI methods */
  case OM_NEW:
   rc = DropAreaClassNew(cl, obj, (struct opSet *) msg);
   break;

  case OM_DISPOSE:
   rc = DropAreaClassDispose(cl, obj, msg);
   break;

  case OM_SET:
   rc = DropAreaClassSet(cl, obj, (struct opSet *) msg);
   break;

  case OM_GET:
   rc = DropAreaClassGet(cl, obj, (struct opGet *) msg);
   break;

  /* MUI methods */
  case MUIM_DragQuery:
   rc = DropAreaClassDragQuery(cl, obj, (struct MUIP_DragQuery *) msg);
   break;

  case MUIM_DragDrop:
   rc = DropAreaClassDragDrop(cl, obj, (struct MUIP_DragDrop *) msg);
   break;

  /* TM methods */
  case TMM_Notify:
   rc = DropAreaClassNotify(cl, obj, (struct TMP_Notify *) msg);
   break;

  case TMM_DoubleClicked:
   rc = DropAreaClassDoubleClicked(cl, obj);
   break;

  /* Unknown method -> delegate to SuperClass */
  default:
   rc = DoSuperMethodA(cl, obj, msg);
   break;
 }

 return(rc);
}

/* Create DropArea class */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CreateDropAreaClass
struct MUI_CustomClass *CreateDropAreaClass(void)
{
 struct MUI_CustomClass *rc;

 /* Create class */
 if (rc = MUI_CreateCustomClass(NULL, MUIC_Text, NULL,
                                sizeof(struct DropAreaClassData),
                                DropAreaClassDispatcher)) {

  /* NOTHING TO DO */
 }

 DROPAREA_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}
