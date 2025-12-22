/*
 * button.c  V3.1
 *
 * ToolManager button gadget class
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

/* Button class instance data */
struct ButtonClassData {
 struct TMMemberData *bcd_ExecObject;
 struct TMMemberData *bcd_SoundObject;
};
#define TYPED_INST_DATA(cl, o) ((struct ButtonClassData *) INST_DATA((cl), (o)))
#define GADGET(g)              ((struct Gadget *) (g))

/* Button class method: OM_NEW */
#define DEBUGFUNCTION ButtonClassNew
static ULONG ButtonClassNew(Class *cl, Object *obj, struct opSet *ops)
{
 BUTTONCLASS_LOG((LOG1(Tags, "0x%08lx", ops->ops_AttrList),
                 PrintTagList(ops->ops_AttrList)))

 /* Call SuperClass */
 if (obj = (Object *) DoSuperMethodA(cl, obj, (Msg) ops)) {
  struct ButtonClassData *bcd   = TYPED_INST_DATA(cl, obj);
  struct TMHandle        *tmh;
  struct DockEntryChunk  *dec   = NULL;
  const char             *text  = NULL;
  Object                 *image = NULL;
  Object                 *label;
  BOOL                    error = FALSE;

  /* Initialize instance data */
  bcd->bcd_ExecObject  = NULL;
  bcd->bcd_SoundObject = NULL;

  /* Get TMHandle */
  tmh = (struct TMHandle *) GetTagData(TMA_TMHandle, NULL, ops->ops_AttrList);

  /* Get dock entry data */
  dec = (struct DockEntryChunk *) GetTagData(TMA_Entry, NULL,
                                             ops->ops_AttrList);

  /* Attach objects */
  if (dec) {
   Object *o;

   /* Find Exec object */
   if ((dec->dec_ExecObject != 0) &&
       (o = FindTypedIDTMObject(tmh, dec->dec_ExecObject, TMOBJTYPE_EXEC)))

    /* Attach object */
    bcd->bcd_ExecObject = (struct TMMemberData *) DoMethod(o, TMM_Attach, obj,
                                                           TMV_Attach_Normal);

   /* Find Sound object */
   if ((dec->dec_SoundObject != 0) &&
       (o = FindTypedIDTMObject(tmh, dec->dec_SoundObject, TMOBJTYPE_SOUND)))

    /* Attach object */
    bcd->bcd_SoundObject = (struct TMMemberData *) DoMethod(o, TMM_Attach,
                                                            obj,
                                                            TMV_Attach_Normal);
  }

  /* Display image? */
  if (GetTagData(TMA_Images, FALSE, ops->ops_AttrList)) {

   BUTTONCLASS_LOG(LOG0(Display Images))

   /* Find image object */
   if ((dec->dec_ImageObject == 0) ||
       ((image = FindTypedIDTMObject(tmh, dec->dec_ImageObject,
                                     TMOBJTYPE_IMAGE)) == NULL))

    /* No image found -> error */
    error = TRUE;
  }

  /* Display text? */
  if ((error == FALSE) && GetTagData(TMA_Text, FALSE, ops->ops_AttrList)) {

   BUTTONCLASS_LOG(LOG0(Display Text))

   /* Exec object valid? */
   if (bcd->bcd_ExecObject) {

    /* Get name of exec object */
    GetAttr(TMA_ObjectName, bcd->bcd_ExecObject->tmmd_Object, (ULONG *) &text);

   } else

    /* No text available -> error */
    error = TRUE;
  }

  BUTTONCLASS_LOG(LOG3(Attached, "Exec 0x%08lx Image 0x%08lx Sound 0x%08lx",
                       bcd->bcd_ExecObject, image, bcd->bcd_SoundObject))

  /* No error? */
  if (error == FALSE) {

   /* Create label image */
   if (label = NewObject(ToolManagerEntryClass, NULL,
                          TMA_String, text,
                          TMA_Font,
                           GetTagData(TMA_Font,   NULL, ops->ops_AttrList),
                          TMA_Image,  image,
                          TMA_Screen,
                           GetTagData(TMA_Screen, NULL, ops->ops_AttrList),
                          TAG_DONE)) {
    Object *frame;

    BUTTONCLASS_LOG(LOG1(Label, "0x%08lx", label))

    /* Create frame image */
    if (frame = NewObject(NULL, FRAMEICLASS, IA_FrameType, FRAME_BUTTON,
                                             TAG_DONE)) {

     BUTTONCLASS_LOG(LOG1(Frame, "0x%08lx", frame))

     /* Set gadget images */
     SetAttrs(obj, GA_LabelImage, label,
                   GA_Image,      frame,
                   TAG_DONE);

     /* Set gadget size */
     SetAttrs(obj, GA_Width,  ((struct Image *) label)->Width,
                   GA_Height, ((struct Image *) label)->Height,
                   TAG_DONE);
    } else {

     /* Couldn't create frame image, dispose label image */
     DisposeObject(label);
     error = TRUE;
    }

   } else

    /* Couldn't create label image */
    error = TRUE;
  }

  /* Everything OK? */
  if (error) {

   /* No, dispose object */
   CoerceMethod(cl, obj, OM_DISPOSE);

   /* Clear object pointer */
   obj = NULL;
  }
 }

 BUTTONCLASS_LOG(LOG1(Result, "0x%08lx", obj))

 return((ULONG) obj);
}

/* Button class method: OM_DISPOSE */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ButtonClassDispose
static ULONG ButtonClassDispose(Class *cl, Object *obj, Msg msg)
{
 struct ButtonClassData *bcd = TYPED_INST_DATA(cl, obj);

 BUTTONCLASS_LOG(LOG0(Disposing))

 /* Dispose frame object */
 if (GADGET(obj)->GadgetRender)
  DisposeObject(GADGET(obj)->GadgetRender);

 /* Dispose label object */
 if (GADGET(obj)->GadgetText)
  DisposeObject(GADGET(obj)->GadgetText);

 /* Sound object attached? Release it */
 if (bcd->bcd_SoundObject) DoMethod(bcd->bcd_SoundObject->tmmd_Object,
                                    TMM_Detach, bcd->bcd_SoundObject);

 /* Exec object attached? Release it */
 if (bcd->bcd_ExecObject) DoMethod(bcd->bcd_ExecObject->tmmd_Object,
                                   TMM_Detach, bcd->bcd_ExecObject);

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, msg));
}

/* Button class method: OM_SET */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ButtonClassSet
static ULONG ButtonClassSet(Class *cl, Object *obj, struct opSet *ops)
{
 struct TagItem *tstate = ops->ops_AttrList;
 struct TagItem *ti;

 BUTTONCLASS_LOG((LOG1(Tags, "0x%08lx", ops->ops_AttrList),
                  PrintTagList(ops->ops_AttrList)))

 /* Scan tag list */
 while (ti = NextTagItem(&tstate))

  /* Which attribute shall be set? */
  switch (ti->ti_Tag) {
   case GA_Width:
    /* Forward new width to Label image object */
    SetAttrs(GADGET(obj)->GadgetText, IA_Width, ti->ti_Data);
    break;

   case GA_Height:
    /* Forward new height to Label image object */
    SetAttrs(GADGET(obj)->GadgetText, IA_Height, ti->ti_Data);
    break;
  }

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, (Msg) ops));
}

/* Button class method: TMM_Release */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ButtonClassRelease
static ULONG ButtonClassRelease(Class *cl, Object *obj,
                                struct TMP_Detach *tmpd)
{
 struct ButtonClassData *bcd = TYPED_INST_DATA(cl, obj);

 BUTTONCLASS_LOG(LOG2(Arguments, "Data 0x%08lx Object 0x%08lx",
                      tmpd->tmpd_MemberData,
                      tmpd->tmpd_MemberData->tmmd_Object))

 /* Exec or Sound object deleted? */
 if (bcd->bcd_ExecObject == tmpd->tmpd_MemberData) {

  /* Tell image that the text is no longer valid */
  DoMethod((Object *) GADGET(obj)->GadgetText, TMM_Release, NULL);

  bcd->bcd_ExecObject = NULL;
 } else
  bcd->bcd_SoundObject = NULL;

 /* Detach object */
 DoMethod(tmpd->tmpd_MemberData->tmmd_Object, TMM_Detach,
          tmpd->tmpd_MemberData);

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* Button class method: TMM_Activate */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ButtonClassActivate
static ULONG ButtonClassActivate(Class *cl, Object *obj,
                                 struct TMP_Activate *tmpa)
{
 struct ButtonClassData *bcd = TYPED_INST_DATA(cl, obj);

 ICONCLASS_LOG(LOG1(Data, "0x%08lx", tmpa->tmpa_Data))

 /* Activate sound object */
 if (bcd->bcd_SoundObject) DoMethod(bcd->bcd_SoundObject->tmmd_Object,
                                    TMM_Activate, NULL);

 /* Activate Exec object */
 if (bcd->bcd_ExecObject) DoMethod(bcd->bcd_ExecObject->tmmd_Object,
                                   TMM_Activate, tmpa->tmpa_Data);

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* Button class dispatcher */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ButtonClassDispatcher
static __geta4 ULONG ButtonClassDispatcher(__A0 Class *cl, __A2 Object *obj,
                                           __A1 Msg msg)
{
 ULONG rc;

 BUTTONCLASS_LOG(LOG3(Arguments, "Class 0x%08lx Object 0x%08lx Msg 0x%08lx",
                      cl, obj, msg))

 switch(msg->MethodID) {
  /* BOOPSI methods */
  case OM_NEW:
   rc = ButtonClassNew(cl, obj, (struct opSet *) msg);
   break;

  case OM_DISPOSE:
   rc = ButtonClassDispose(cl, obj, msg);
   break;

  case OM_SET:
   rc = ButtonClassSet(cl, obj, (struct opSet *) msg);
   break;

  /* TM methods */
  case TMM_Release:
   rc = ButtonClassRelease(cl, obj, (struct TMP_Detach *) msg);
   break;

  case TMM_Activate:
   rc = ButtonClassActivate(cl, obj, (struct TMP_Activate *) msg);
   break;

  /* Unknown method -> delegate to SuperClass */
  default:
   rc = DoSuperMethodA(cl, obj, msg);
   break;
 }

 return(rc);
}

/* Create base class */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CreateButtonClass
const Class *CreateButtonClass(void)
{
 Class *cl;

 /* Create class */
 if (cl = MakeClass(NULL, FRBUTTONCLASS, NULL, sizeof(struct ButtonClassData),
                    0))

  /* Set dispatcher */
  cl->cl_Dispatcher.h_Entry = (ULONG (*)()) ButtonClassDispatcher;

 BUTTONCLASS_LOG(LOG1(Class, "0x%08lx", cl))

 /* Return pointer to class */
 return(cl);
}
