/*
 * popasl.c  V3.1
 *
 * PopASL class
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
static struct SignalSemaphore CounterSemaphore;
static ULONG                  RequesterCounter;

/* Update counter */
static void UpdateCounter(LONG delta)
{
 /* Requester open, lock semaphore */
 ObtainSemaphore(&CounterSemaphore);

 /* Increment counter */
 RequesterCounter += delta;

 /* Release semaphore */
 ReleaseSemaphore(&CounterSemaphore);
}

/* PopASL class instance data */
struct PopASLClassData {
 Object *pacd_Button;
};
#define TYPED_INST_DATA(cl, o) ((struct PopASLClassData *) INST_DATA((cl), (o)))

/* PopASL class method: OM_NEW */
#define DEBUGFUNCTION PopASLClassNew
static ULONG PopASLClassNew(Class *cl, Object *obj, struct opSet *ops)
{
 POPASL_LOG((LOG1(Tags, "0x%08lx", ops->ops_AttrList),
                  PrintTagList(ops->ops_AttrList)))

 if (obj = (Object *) DoSuperNew(cl, obj, TAG_MORE, ops->ops_AttrList)) {
  struct PopASLClassData *pacd = TYPED_INST_DATA(cl, obj);

  /* Get pointer to button */
  GetAttr(MUIA_Popstring_Button, obj, (ULONG *) &pacd->pacd_Button);
 }

 POPASL_LOG(LOG1(Result, "0x%08lx", obj))

 /* Return pointer to created object */
 return((ULONG) obj);
}

/* PopASL class method: OM_DISPOSE */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION PopASLClassDispose
static ULONG PopASLClassDispose(Class *cl, Object *obj, Msg msg)
{
 ULONG active;

 POPASL_LOG(LOG1(Disposing, "0x%08lx", obj))

 /* Check requester status */
 GetAttr(MUIA_Popasl_Active, obj, &active);

 /* Requester opened? */
 if (active) {

  POPASL_LOG(LOG0(Requester still open))

  /* Decrement counter */
  UpdateCounter(-1);
 }

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, msg));
}

/* PopASL class method: OM_SET */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION PopASLClassSet
static ULONG PopASLClassSet(Class *cl, Object *obj, struct opSet *ops)
{
 struct TagItem *tstate = ops->ops_AttrList;
 struct TagItem *ti;

 POPASL_LOG((LOG1(Tags, "0x%08lx", ops->ops_AttrList),
                  PrintTagList(ops->ops_AttrList)))

 /* Scan tag list */
 while (ti = NextTagItem(&tstate))

  /* Which attribute shall be set? */
  switch (ti->ti_Tag) {
   case TMA_ButtonDisabled:
    SetDisabledState(TYPED_INST_DATA(cl, obj)->pacd_Button, ti->ti_Data);
    break;
  }

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, (Msg) ops));
}

/* PopASL class method: MUIM_Popstring_Open */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION PopASLClassOpen
static ULONG PopASLClassOpen(Class *cl, Object *obj, Msg msg)
{
 ULONG active;

 POPASL_LOG(LOG0(Entry))

 /* Call SuperClass */
 DoSuperMethodA(cl, obj, msg);

 /* Check requester status */
 GetAttr(MUIA_Popasl_Active, obj, &active);

 /* Requester opened? */
 if (active) {

  POPASL_LOG(LOG0(Requester open))

  /* Set window to sleep */
  SetAttrs(_win(obj), MUIA_Window_Sleep, TRUE, TAG_DONE);

  /* Increment counter */
  UpdateCounter(1);
 }

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* PopASL class method: MUIM_Popstring_Close */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION PopASLClassClose
static ULONG PopASLClassClose(Class *cl, Object *obj, Msg msg)
{
 POPASL_LOG(LOG0(Entry))

 /* Set window to active */
 SetAttrs(_win(obj), MUIA_Window_Sleep, FALSE, TAG_DONE);

 /* Decrement counter */
 UpdateCounter(-1);

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, msg));
}

/* PopASL class method dispatcher */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION PopASLClassDispatcher
__geta4 static ULONG PopASLClassDispatcher(__a0 Class *cl, __a2 Object *obj,
                                           __a1 Msg msg)
{
 ULONG rc;

 POPASL_LOG(LOG3(Arguments, "Class 0x%08lx Object 0x%08lx Msg 0x%08lx",
                    cl, obj, msg))

 switch(msg->MethodID) {
  /* BOOPSI methods */
  case OM_NEW:
   rc = PopASLClassNew(cl, obj, (struct opSet *) msg);
   break;

  case OM_DISPOSE:
   rc = PopASLClassDispose(cl, obj, msg);
   break;

  case OM_SET:
   rc = PopASLClassSet(cl, obj, (struct opSet *) msg);
   break;

  /* MUI methods */
  case MUIM_Popstring_Open:
   rc = PopASLClassOpen(cl, obj, msg);
   break;

  case MUIM_Popstring_Close:
   rc = PopASLClassClose(cl, obj, msg);
   break;

  /* Unknown method -> delegate to SuperClass */
  default:
   rc = DoSuperMethodA(cl, obj, msg);
   break;
 }

 return(rc);
}

/* Create PopASL class */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CreatePopASLClass
struct MUI_CustomClass *CreatePopASLClass(void)
{
 struct MUI_CustomClass *rc;

 /* Create class */
 if (rc = MUI_CreateCustomClass(NULL, MUIC_Popasl, NULL,
                                sizeof(struct PopASLClassData),
                                PopASLClassDispatcher)) {

  /* Initialize requester counter semaphore */
  InitSemaphore(&CounterSemaphore);

  /* Initialize requester counter */
  RequesterCounter = 0;
 }

 POPASL_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}

/* Show error requester and return FALSE if an ASL requester is still  open */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CheckRequesters
BOOL CheckRequesters(Object *win)
{
 BOOL rc;

 /* Still requesters open? */
 if ((rc = (RequesterCounter == 0)) == FALSE)

  /* Show error requester */
  MUI_RequestA(_app(win), win, 0,
               TextGlobalTitle, TextGlobalCancel,
               TranslateString(LOCALE_TEXT_POPASL_CLOSE_DELAYED_STR,
                               LOCALE_TEXT_POPASL_CLOSE_DELAYED),
               NULL);

 POPASL_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}
