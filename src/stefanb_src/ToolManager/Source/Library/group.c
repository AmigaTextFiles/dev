/*
 * group.c  V3.1
 *
 * ToolManager group gadget class
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

/* Group class instance data */
struct GroupClassData {
 struct MinList  gcd_Gadgets;
 ULONG           gcd_MaxWidth;
 ULONG           gcd_MaxHeight;
 Object         *gcd_Active;
 UWORD           gcd_ActiveX;
 UWORD           gcd_ActiveY;
};
#define TYPED_INST_DATA(cl, o) ((struct GroupClassData *) INST_DATA((cl), (o)))
#define GADGET(g)              ((struct Gadget *) (g))

/* Group class method: GM_HITTEST */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION GroupClassHitTest
static ULONG GroupClassHitTest(Class *cl, Object *obj, struct gpHitTest *gpht)
{
 struct GroupClassData *gcd  = TYPED_INST_DATA(cl, obj);
 Object                *obj1 = (Object *) gcd->gcd_Gadgets.mlh_Head;
 UWORD                  x    = gpht->gpht_Mouse.X + GADGET(obj)->LeftEdge;
 UWORD                  y    = gpht->gpht_Mouse.Y + GADGET(obj)->TopEdge;
 struct Gadget         *g;

 GROUPCLASS_LOG(LOG2(Mouse, "X %ld Y %ld", x, y))

 /* Scan object list */
 while (g = GADGET(NextObject(&obj1))) {

  /* Calculate new coordinates relative to gadget */
  gpht->gpht_Mouse.X = x - g->LeftEdge;
  gpht->gpht_Mouse.Y = y - g->TopEdge;

  /* Send message to gadget */
  if (DoMethodA((Object *) g, (Msg) gpht) == GMR_GADGETHIT) break;
 }

 GROUPCLASS_LOG(LOG1(Gadget, "0x%08lx", g))

 /* Save active gadget */
 gcd->gcd_Active = (Object *) g;

 /* Active gadget found? */
 return(g ? GMR_GADGETHIT : 0);
}

/* Group class method: GM_RENDER */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION GroupClassRender
static ULONG GroupClassRender(Class *cl, Object *obj, Msg msg)
{
 Object *obj1 = (Object *) TYPED_INST_DATA(cl, obj)->gcd_Gadgets.mlh_Head;
 Object *obj2;

 GROUPCLASS_LOG(LOG0(Rendering))

 /* Scan object list and forward message to objects */
 while (obj2 = NextObject(&obj1)) DoMethodA(obj2, msg);

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* Send a translated gpInput method to gadget */
static ULONG DoTranslatedMethod(struct GroupClassData *gcd, Object *obj,
                                struct gpInput *gpi)
{
 /* Correct coordinates */
 gpi->gpi_Mouse.X -= gcd->gcd_ActiveX;
 gpi->gpi_Mouse.Y -= gcd->gcd_ActiveY;

 /* Forward method to active gadget */
 return(DoMethodA(obj, (Msg) gpi));
}

/* Group class method: GM_GOACTIVE */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION GroupClassGoActive
static ULONG GroupClassGoActive(Class *cl, Object *obj, struct gpInput *gpi)
{
 struct GroupClassData *gcd = TYPED_INST_DATA(cl, obj);
 struct Gadget         *g   = GADGET(gcd->gcd_Active);
 ULONG                  rc  = GMR_REUSE;

 GROUPCLASS_LOG(LOG0(Go Active))

 /* Active gadget valid? */
 if (g) {

  /* Save active gadgets offsets (Gadget coord. are relative to window!) */
  gcd->gcd_ActiveX = g->LeftEdge - GADGET(obj)->LeftEdge;
  gcd->gcd_ActiveY = g->TopEdge  - GADGET(obj)->TopEdge;

  /* Forward method to active gadget */
  rc = DoTranslatedMethod(gcd, (Object *) g, gpi);
 }

 GROUPCLASS_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}

/* Group class method: GM_HANDLEINPUT */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION GroupClassHandleInput
static ULONG GroupClassHandleInput(Class *cl, Object *obj,
                                   struct gpInput *gpi)
{
 struct GroupClassData *gcd = TYPED_INST_DATA(cl, obj);
 ULONG                  rc  = GMR_REUSE;

 GROUPCLASS_LOG(LOG0(Handle Input))

 /* Active gadget valid? */
 if (gcd->gcd_Active)

  /* Forward method to active gadget */
  if ((rc = DoTranslatedMethod(gcd, gcd->gcd_Active, gpi)) & GMR_VERIFY) {

   GROUPCLASS_LOG(LOG1(Gadget released, "%ld",
                       GADGET(gcd->gcd_Active)->GadgetID))

   /* Copy the gadget ID to the termination field */
   *gpi->gpi_Termination = GADGET(gcd->gcd_Active)->GadgetID;
  }

 return(rc);
}

/* Group class method: GM_GOINACTIVE */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION GroupClassGoInactive
static ULONG GroupClassGoInactive(Class *cl, Object *obj, Msg msg)
{
 struct GroupClassData *gcd = TYPED_INST_DATA(cl, obj);

 GROUPCLASS_LOG(LOG0(Go Inactive))

 /* Active gadget valid? */
 if (gcd->gcd_Active) {

  /* Forward method to active gadget */
  DoMethodA(gcd->gcd_Active, msg);

  /* Clear active gadget*/
  gcd->gcd_Active = NULL;
 }

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* Group class method: OM_NEW */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION GroupClassNew
static ULONG GroupClassNew(Class *cl, Object *obj, struct opSet *ops)
{
 GROUPCLASS_LOG((LOG1(Tags, "0x%08lx", ops->ops_AttrList),
                PrintTagList(ops->ops_AttrList)))

 /* Call SuperClass */
 if (obj = (Object *) DoSuperMethodA(cl, obj, (Msg) ops)) {
  struct GroupClassData *gcd = TYPED_INST_DATA(cl, obj);

  /* Initalize instance data */
  gcd->gcd_MaxWidth  = 0;
  gcd->gcd_MaxHeight = 0;
  gcd->gcd_Active    = NULL;

  /* Initialize gadget list */
  NewList((struct List *) &gcd->gcd_Gadgets);
 }

 return((ULONG) obj);
}

/* Group class method: OM_DISPOSE */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION GroupClassDispose
static ULONG GroupClassDispose(Class *cl, Object *obj, Msg msg)
{
 Object *obj1 = (Object *) TYPED_INST_DATA(cl, obj)->gcd_Gadgets.mlh_Head;
 Object *obj2;

 GROUPCLASS_LOG(LOG0(Disposing))

 /* Scan object list and delete objects */
 while (obj2 = NextObject(&obj1)) {

  /* Remove object */
  DoMethod(obj2, OM_REMOVE);

  /* Dispose object */
  DisposeObject(obj2);
 }

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, msg));
}

/* Group class method: OM_SET */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION GroupClassSet
static ULONG GroupClassSet(Class *cl, Object *obj, struct opSet *ops)
{
 struct TagItem *tstate = ops->ops_AttrList;
 struct TagItem *ti;

 GROUPCLASS_LOG((LOG1(Tags, "0x%08lx", ops->ops_AttrList),
                 PrintTagList(ops->ops_AttrList)))

 /* Scan tag list */
 while (ti = NextTagItem(&tstate))

  /* Which attribute shall be set? */
  switch (ti->ti_Tag) {
   case GA_Left: {
     Object        *obj1  = (Object *)
                             TYPED_INST_DATA(cl, obj)->gcd_Gadgets.mlh_Head;
     struct Gadget *g;
     ULONG          delta = ti->ti_Data - GADGET(obj)->LeftEdge;

     /* Scan object list */
     while (g = GADGET(NextObject(&obj1)))

      /* Set new X coordinate */
      SetGadgetAttrs(g, ops->ops_GInfo->gi_Window,
                        ops->ops_GInfo->gi_Requester,
                        GA_Left, g->LeftEdge + delta,
                        TAG_DONE);

     /* Set new X coordinate */
     GADGET(obj)->LeftEdge = ti->ti_Data;
    }
    break;

   case GA_Top: {
     Object        *obj1  = (Object *)
                             TYPED_INST_DATA(cl, obj)->gcd_Gadgets.mlh_Head;
     struct Gadget *g;
     ULONG          delta = ti->ti_Data - GADGET(obj)->TopEdge;

     /* Scan object list */
     while (g = GADGET(NextObject(&obj1)))

      /* Set new X coordinate */
      SetGadgetAttrs(g, ops->ops_GInfo->gi_Window,
                        ops->ops_GInfo->gi_Requester,
                        GA_Top, g->TopEdge + delta,
                        TAG_DONE);

     /* Set new X coordinate */
     GADGET(obj)->TopEdge = ti->ti_Data;
    }
    break;
  }

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, (Msg) ops));
}

/* Group class method: OM_ADDMEMBER */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION GroupClassAddMember
static ULONG GroupClassAddMember(Class *cl, Object *obj, struct opMember *opm)
{
 struct GroupClassData *gcd = TYPED_INST_DATA(cl, obj);
 struct Gadget         *g   = GADGET(opm->opam_Object);

 /* Check gadget size and correct limits */
 if (g->Width  > gcd->gcd_MaxWidth)  gcd->gcd_MaxWidth  = g->Width;
 if (g->Height > gcd->gcd_MaxHeight) gcd->gcd_MaxHeight = g->Height;

 /* Let the object handle the adding */
 return(DoMethod((Object *) g, OM_ADDTAIL, &gcd->gcd_Gadgets));
}

/* Group class method: TMM_Layout */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION GroupClassLayout
static ULONG GroupClassLayout(Class *cl, Object *obj, struct TMP_Layout *tmpl)
{
 ULONG entries = 0;

 GROUPCLASS_LOG(LOG1(Columns, "%ld", tmpl->tmpl_Columns))

 /* Sanity check! */
 if (tmpl->tmpl_Columns != 0) {
  struct GroupClassData *gcd   = TYPED_INST_DATA(cl, obj);
  Object                *obj1  = (Object *) gcd->gcd_Gadgets.mlh_Head;
  struct Gadget         *g;
  ULONG                  x     = GADGET(obj)->LeftEdge;
  ULONG                  y     = GADGET(obj)->TopEdge;
  ULONG                  cols  = 0;

  GROUPCLASS_LOG(LOG2(Box, "Width %ld Height %ld", gcd->gcd_MaxWidth,
                      gcd->gcd_MaxHeight))

  /* Scan object list */
  while (g = GADGET(NextObject(&obj1))) {

   /* Increment counter */
   entries++;

   /* Set X & Y and ID for the gadget */
   SetGadgetAttrs(g, NULL, NULL, GA_Left,   x,
                                 GA_Top,    y,
                                 GA_Width,  gcd->gcd_MaxWidth,
                                 GA_Height, gcd->gcd_MaxHeight,
                                 GA_ID,     entries,
                                 TAG_DONE);

   /* Correct counters */
   if (++cols >= tmpl->tmpl_Columns) {

    /* Column full, reset X & column counter and increment Y & row counter */
    x     = GADGET(obj)->LeftEdge;
    y    += gcd->gcd_MaxHeight;
    cols  = 0;

   } else

    /* Column not yet full, just increment X */
    x += gcd->gcd_MaxWidth;
  }

  /* Calculate new gadget hit box */
  GADGET(obj)->Width  = gcd->gcd_MaxWidth  * tmpl->tmpl_Columns;
  GADGET(obj)->Height = gcd->gcd_MaxHeight *
                     ((entries + tmpl->tmpl_Columns - 1) / tmpl->tmpl_Columns);
 }

 GROUPCLASS_LOG(LOG3(Result, "Entries %ld Width %ld Height %ld", entries,
                     GADGET(obj)->Width, GADGET(obj)->Height))

 /* Return FALSE if no objects are in the group */
 return(entries != 0);
}

/* Group class method: TMM_GadgetUp */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION GroupClassGadgetUp
static ULONG GroupClassGadgetUp(Class *cl, Object *obj,
                                struct TMP_GadgetUp *tmpgu)
{
 Object        *obj1 = (Object *)
                        TYPED_INST_DATA(cl, obj)->gcd_Gadgets.mlh_Head;
 struct Gadget *g;

 GROUPCLASS_LOG(LOG1(GadgetID, "%ld", tmpgu->tmpgu_GadgetID))

 /* Scan object list */
 while (g = GADGET(NextObject(&obj1))) {

  GROUPCLASS_LOG(LOG1(Gadget, "0x%08lx", g))

  /* Gadget found? */
  if (g->GadgetID == tmpgu->tmpgu_GadgetID) {

   GROUPCLASS_LOG(LOG0(Activating gadget))

   /* Send activate message to gadget */
   DoMethod((Object *) g, TMM_Activate, NULL);

   /* Leave loop */
   break;
  }
 }

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* Group class method: TMM_AppEvent */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION GroupClassAppEvent
static ULONG GroupClassAppEvent(Class *cl, Object *obj,
                                struct TMP_AppEvent *tmpae)
{
 struct GroupClassData *gcd  = TYPED_INST_DATA(cl, obj);
 Object                *obj1 = (Object *) gcd->gcd_Gadgets.mlh_Head;
 WORD                   x    = tmpae->tmpae_Message->am_MouseX;
 WORD                   y    = tmpae->tmpae_Message->am_MouseY;
 struct Gadget         *g;
 struct gpHitTest       gpht = { GM_HITTEST, NULL };

 GROUPCLASS_LOG(LOG2(Mouse, "X %ld Y %ld", x, y))

 /* Scan object list */
 while (g = GADGET(NextObject(&obj1))) {

  /* Calculate coordinates relative to the gadget */
  gpht.gpht_Mouse.X = x - g->LeftEdge;
  gpht.gpht_Mouse.Y = y - g->TopEdge;

  GROUPCLASS_LOG(LOG3(Gadget, "0x%08lx Relative X %ld Y %ld", g,
                      gpht.gpht_Mouse.X, gpht.gpht_Mouse.Y))

  /* Send HITTEST message to gadget */
  if (DoMethodA((Object *) g, (Msg) &gpht) == GMR_GADGETHIT)

   /* Gadget has been found */
   break;
 }

 GROUPCLASS_LOG(LOG1(Gadget, "0x%08lx", g))

 /* Send activate message to object */
 if (g) DoMethod((Object *) g, TMM_Activate, tmpae->tmpae_Message);

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* Group class dispatcher */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION GroupClassDispatcher
static __geta4 ULONG GroupClassDispatcher(__A0 Class *cl, __A2 Object *obj,
                                          __A1 Msg msg)
{
 ULONG rc;

 GROUPCLASS_LOG(LOG3(Arguments, "Class 0x%08lx Object 0x%08lx Msg 0x%08lx",
                     cl, obj, msg))

 switch(msg->MethodID) {
  /* BOOPSI gadget methods */
  case GM_HITTEST:
   rc = GroupClassHitTest(cl, obj, (struct gpHitTest *) msg);
   break;

  case GM_RENDER:
   rc = GroupClassRender(cl, obj, msg);
   break;

  case GM_GOACTIVE:
   rc = GroupClassGoActive(cl, obj, (struct gpInput *) msg);
   break;

  case GM_HANDLEINPUT:
   rc = GroupClassHandleInput(cl, obj, (struct gpInput *) msg);
   break;

  case GM_GOINACTIVE:
   rc = GroupClassGoInactive(cl, obj, msg);
   break;

  /* BOOPSI methods */
  case OM_NEW:
   rc = GroupClassNew(cl, obj, (struct opSet *) msg);
   break;

  case OM_DISPOSE:
   rc = GroupClassDispose(cl, obj, msg);
   break;

  case OM_SET:
   rc = GroupClassSet(cl, obj, (struct opSet *) msg);
   break;

  case OM_ADDMEMBER:
   rc = GroupClassAddMember(cl, obj, (struct opMember *) msg);
   break;

  /* TM methods */
  case TMM_Layout:
   rc = GroupClassLayout(cl, obj, (struct TMP_Layout *) msg);
   break;

  case TMM_GadgetUp:
   rc = GroupClassGadgetUp(cl, obj, (struct TMP_GadgetUp *) msg);
   break;

  case TMM_AppEvent:
   rc = GroupClassAppEvent(cl, obj, (struct TMP_AppEvent *) msg);
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
#define DEBUGFUNCTION CreateGroupClass
const Class *CreateGroupClass(void)
{
 Class *cl;

 /* Create class */
 if (cl = MakeClass(NULL, GADGETCLASS, NULL, sizeof(struct GroupClassData), 0))

  /* Set dispatcher */
  cl->cl_Dispatcher.h_Entry = (ULONG (*)()) GroupClassDispatcher;

 GROUPCLASS_LOG(LOG1(Class, "0x%08lx", cl))

 /* Return pointer to class */
 return(cl);
}
