/*
 * entry.c  V3.1
 *
 * ToolManager dock entry image class
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

/* Entry class instance data */
struct EntryClassData {
 struct TMImageData *ecd_ImageObject;
 const char         *ecd_Text;
 struct TextFont    *ecd_Font;
 UWORD               ecd_ImageX;
 UWORD               ecd_ImageY;
 UWORD               ecd_TextLength;
 UWORD               ecd_TextWidth;
 UWORD               ecd_TextX;
 UWORD               ecd_TextY;

};
#define TYPED_INST_DATA(cl, o) ((struct EntryClassData *) INST_DATA((cl), (o)))
#define IMAGE(i)               ((struct Image *) (i))

/* Entry class method: OM_NEW */
#define DEBUGFUNCTION EntryClassNew
static ULONG EntryClassNew(Class *cl, Object *obj, struct opSet *ops)
{
 ENTRYCLASS_LOG((LOG1(Tags, "0x%08lx", ops->ops_AttrList),
                 PrintTagList(ops->ops_AttrList)))

 /* Call SuperClass */
 if (obj = (Object *) DoSuperMethodA(cl, obj, (Msg) ops)) {
  struct EntryClassData *ecd    = TYPED_INST_DATA(cl, obj);
  UWORD                  width  = 0;
  UWORD                  height = 0;
  BOOL                   error  = FALSE;

  /* Initialize instance data */
  ecd->ecd_ImageObject = NULL;
  ecd->ecd_Text        = NULL;

  /* Display image? */
  {
   Object *image;

   /* Image object specified? */
   if (image = (Object *) GetTagData(TMA_Image, NULL, ops->ops_AttrList)) {

    ENTRYCLASS_LOG(LOG1(Image, "0x%08lx", image))

    /* Attach image object */
    if ((ecd->ecd_ImageObject =
         (struct TMImageData *) DoMethod(image, TMM_GetImage, obj,
                           GetTagData(TMA_Screen, NULL, ops->ops_AttrList)))) {

     ENTRYCLASS_LOG(LOG1(ImageData, "0x%08lx", ecd->ecd_ImageObject))

     /* Get image dimensions (NOTE: Frame size is hardcoded into this!) */
     width  = ecd->ecd_ImageObject->tmid_Width  + 4;
     height = ecd->ecd_ImageObject->tmid_Height + 2;
    } else

     /* Couldn't get image -> error */
     error = TRUE;
   }
  }

  /* Display text? */
  if (error == FALSE) {

   /* Text specified? */
   if (ecd->ecd_Text = (const char *)
                        GetTagData(TMA_String, NULL, ops->ops_AttrList)) {
    struct RastPort tmprp;

    ENTRYCLASS_LOG(LOG2(Text, "'%s' (0x%08lx)", ecd->ecd_Text, ecd->ecd_Text))

    /* Yes, we need the font then */
    ecd->ecd_Font = (struct TextFont *)
                     GetTagData(TMA_Font, NULL, ops->ops_AttrList);

    ENTRYCLASS_LOG(LOG1(Font, "0x%08lx", ecd->ecd_Font))

    /* Initialize RastPort */
    InitRastPort(&tmprp);
    SetFont(&tmprp, ecd->ecd_Font);

    /* Calculate string length and text width */
    ecd->ecd_TextLength = strlen(ecd->ecd_Text);
    ecd->ecd_TextWidth  = TextLength(&tmprp, ecd->ecd_Text,
                                     ecd->ecd_TextLength);

    /* Set text dimensions */
    if (width < (ecd->ecd_TextWidth + INTERWIDTH))
     width = ecd->ecd_TextWidth + INTERWIDTH;
    height += ecd->ecd_Font->tf_YSize + INTERHEIGHT;
   }
  }

  /* Check image dimensions */
  if ((error == FALSE) && ((width == 0) || (height == 0)))

   /* Not a valid image */
   error = TRUE;

  else {

   ENTRYCLASS_LOG(LOG2(Dimensions, "Width %ld Height %ld", width, height))

   /* Set Image dimensions */
   IMAGE(obj)->Width  = width;
   IMAGE(obj)->Height = height;
  }

  /* Everything OK? */
  if (error) {

   /* No, dispose object */
   CoerceMethod(cl, obj, OM_DISPOSE);

   /* Clear object pointer */
   obj = NULL;
  }
 }

 ENTRYCLASS_LOG(LOG1(Result, "0x%08lx", obj))

 return((ULONG) obj);
}

/* Entry class method: OM_DISPOSE */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION EntryClassDispose
static ULONG EntryClassDispose(Class *cl, Object *obj, Msg msg)
{
 struct EntryClassData *ecd = TYPED_INST_DATA(cl, obj);

 ENTRYCLASS_LOG(LOG0(Disposing))

 /* Image object attached? Release it */
 if (ecd->ecd_ImageObject)
  DoMethod(ecd->ecd_ImageObject->tmid_MemberData.tmmd_Object, TMM_Detach,
           ecd->ecd_ImageObject);

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, msg));
}

/* Entry class method: OM_SET */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION EntryClassSet
static ULONG EntryClassSet(Class *cl, Object *obj, struct opSet *ops)
{
 struct TagItem *tstate = ops->ops_AttrList;
 struct TagItem *ti;

 ENTRYCLASS_LOG((LOG1(Tags, "0x%08lx", ops->ops_AttrList),
                 PrintTagList(ops->ops_AttrList)))

 /* Scan tag list */
 while (ti = NextTagItem(&tstate))

  /* Which attribute shall be set? */
  switch (ti->ti_Tag) {
   case IA_Width: {
     struct EntryClassData *ecd = TYPED_INST_DATA(cl, obj);

     /* Center image */
     if (ecd->ecd_ImageObject)
      ecd->ecd_ImageX = (ti->ti_Data - ecd->ecd_ImageObject->tmid_Width) / 2;

     /* Center text */
     ecd->ecd_TextX = (ti->ti_Data - ecd->ecd_TextWidth) / 2;
    }
    break;

   case IA_Height: {
     struct EntryClassData *ecd = TYPED_INST_DATA(cl, obj);

     /* Calculate new Y position */
     if (ecd->ecd_Text) {

      /* Center text */
      ecd->ecd_TextY = ti->ti_Data - ecd->ecd_Font->tf_YSize +
                        ecd->ecd_Font->tf_Baseline - INTERHEIGHT / 2;

      /* Center image */
      if (ecd->ecd_ImageObject)
       ecd->ecd_ImageY = (ti->ti_Data - ecd->ecd_ImageObject->tmid_Height
                          - ecd->ecd_Font->tf_YSize - INTERHEIGHT) / 2;

     } else

      /* Center image */
      ecd->ecd_ImageY = (ti->ti_Data - ecd->ecd_ImageObject->tmid_Height)
                         / 2;
    }
    break;
  }

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, (Msg) ops));
}

/* Entry class method: IM_DRAW */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION EntryClassDraw
static ULONG EntryClassDraw(Class *cl, Object *obj, struct impDraw *id)
{
 struct EntryClassData *ecd = TYPED_INST_DATA(cl, obj);

 ENTRYCLASS_LOG(LOG0(Drawing))

 ENTRYCLASS_LOG(LOG2(Coord, "X %ld Y %ld", id->imp_Offset.X, id->imp_Offset.Y))

 /* Image valid? */
 if (ecd->ecd_ImageObject) {
  BltBitMapRastPort(ecd->ecd_ImageObject->tmid_ImageData, 0, 0, id->imp_RPort,
                    ecd->ecd_ImageX + id->imp_Offset.X,
                    ecd->ecd_ImageY + id->imp_Offset.Y,
                    ecd->ecd_ImageObject->tmid_Width,
                    ecd->ecd_ImageObject->tmid_Height, (ABC | ABNC));
 }

 /* Text valid? */
 if (ecd->ecd_Text) {

  /* Initialize RastPort */
  SetFont(id->imp_RPort, ecd->ecd_Font);
  SetABPenDrMd(id->imp_RPort,
               id->imp_State == IDS_NORMAL ?
                id->imp_DrInfo->dri_Pens[TEXTPEN] :
                id->imp_DrInfo->dri_Pens[FILLTEXTPEN],
               0, JAM1);

  /* Draw text */
  Move(id->imp_RPort, ecd->ecd_TextX + id->imp_Offset.X,
                      ecd->ecd_TextY + id->imp_Offset.Y);
  Text(id->imp_RPort, ecd->ecd_Text, ecd->ecd_TextLength);
 }

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* Entry class method: TMM_Release */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION EntryClassRelease
static ULONG EntryClassRelease(Class *cl, Object *obj, struct TMP_Detach *tmpd)
{
 struct EntryClassData *ecd = TYPED_INST_DATA(cl, obj);

 ENTRYCLASS_LOG(LOG2(Arguments, "Data 0x%08lx Object 0x%08lx",
                     tmpd->tmpd_MemberData,
                     tmpd->tmpd_MemberData->tmmd_Object))

 /* Image or Exec object released? */
 if (tmpd->tmpd_MemberData) {

  /* Detach image object */
  DoMethod(ecd->ecd_ImageObject->tmid_MemberData.tmmd_Object, TMM_Detach,
           ecd->ecd_ImageObject);
  ecd->ecd_ImageObject = NULL;

 } else

  /* Text has become invalid */
  ecd->ecd_Text = NULL;

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* Entry class method: TMM_Notify */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION EntryClassNotify
static ULONG EntryClassNotify(Class *cl, Object *obj,
                              struct TMP_Detach *tmpd)
{
 ENTRYCLASS_LOG(LOG2(Arguments, "Data 0x%08lx Member 0x%08lx",
                     tmpd->tmpd_MemberData,
                     tmpd->tmpd_MemberData->tmmd_Member))

 /* Detach image object */
 DoMethod(tmpd->tmpd_MemberData->tmmd_Object, TMM_Detach,
          tmpd->tmpd_MemberData);

 /* Clear image pointer */
 TYPED_INST_DATA(cl, obj)->ecd_ImageObject = NULL;

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* Entry class dispatcher */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION EntryClassDispatcher
static __geta4 ULONG EntryClassDispatcher(__A0 Class *cl, __A2 Object *obj,
                                          __A1 Msg msg)
{
 ULONG rc;

 ENTRYCLASS_LOG(LOG3(Arguments, "Class 0x%08lx Object 0x%08lx Msg 0x%08lx",
                      cl, obj, msg))

 switch(msg->MethodID) {
  /* BOOPSI methods */
  case OM_NEW:
   rc = EntryClassNew(cl, obj, (struct opSet *) msg);
   break;

  case OM_DISPOSE:
   rc = EntryClassDispose(cl, obj, msg);
   break;

  case OM_SET:
   rc = EntryClassSet(cl, obj, (struct opSet *) msg);
   break;

  /* BOOPSI image methods */
  case IM_DRAW:
   rc = EntryClassDraw(cl, obj, (struct impDraw *) msg);
   break;

  /* TM methods */
  case TMM_Release:
   rc = EntryClassRelease(cl, obj, (struct TMP_Detach *) msg);
   break;

  case TMM_Notify:
   rc = EntryClassNotify(cl, obj, (struct TMP_Detach *) msg);
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
#define DEBUGFUNCTION CreateEntryClass
const Class *CreateEntryClass(void)
{
 Class *cl;

 /* Create class */
 if (cl = MakeClass(NULL, IMAGECLASS, NULL, sizeof(struct EntryClassData),
                    0))

  /* Set dispatcher */
  cl->cl_Dispatcher.h_Entry = (ULONG (*)()) EntryClassDispatcher;

 ENTRYCLASS_LOG(LOG1(Class, "0x%08lx", cl))

 /* Return pointer to class */
 return(cl);
}
