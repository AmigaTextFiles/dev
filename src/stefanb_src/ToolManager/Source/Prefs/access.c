/*
 * access.c  V3.1
 *
 * TM Access object class
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
static const char *TextTitle;

/* Access class instance data */
struct AccessClassData {
 ULONG acd_Dummy;
};
#define TYPED_INST_DATA(cl, o) ((struct AccessClassData *) INST_DATA((cl), (o)))

/* Access class method: OM_NEW */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION AccessClassNew
static ULONG AccessClassNew(Class *cl, Object *obj, struct opSet *ops)
{
 ACCESS_LOG((LOG1(Tags, "0x%08lx", ops->ops_AttrList),
             PrintTagList(ops->ops_AttrList)))

#if 0
 /* Create object */
 if (obj = (Object *) DoSuperNew(cl, obj,
                                       MUIA_Window_Title, TextTitle,
                                       MUIA_HelpNode,     "AccessWindow",
                                       TMA_Type,          TMOBJTYPE_ACCESS,
                                       TAG_MORE,          ops->ops_AttrList)) {
  struct AccessClassData *acd = TYPED_INST_DATA(cl, obj);
 }
#else
 obj = NULL; /* Don't try to create an object */
#endif

 ACCESS_LOG(LOG1(Result, "0x%08lx", obj))

 /* Return pointer to created object */
 return((ULONG) obj);
}

/* Access class method: OM_DISPOSE */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION AccessClassDispose
static ULONG AccessClassDispose(Class *cl, Object *obj, Msg msg)
{
 ACCESS_LOG(LOG1(Disposing, "0x%08lx", obj))

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, msg));
}

/* Access class method dispatcher */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION AccessClassDispatcher
__geta4 static ULONG AccessClassDispatcher(__a0 Class *cl, __a2 Object *obj,
                                           __a1 Msg msg)
{
 ULONG rc;

 ACCESS_LOG(LOG3(Arguments, "Class 0x%08lx Object 0x%08lx Msg 0x%08lx",
                 cl, obj, msg))

 switch(msg->MethodID) {
  /* BOOPSI methods */
  case OM_NEW:
   rc = AccessClassNew(cl, obj, (struct opSet *) msg);
   break;

  case OM_DISPOSE:
   rc = AccessClassDispose(cl, obj, msg);
   break;

  /* TM methods */

  /* Unknown method -> delegate to SuperClass */
  default:
   rc = DoSuperMethodA(cl, obj, msg);
   break;
 }

 return(rc);
}

/* Create Access class */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CreateAccessClass
struct MUI_CustomClass *CreateAccessClass(void)
{
 struct MUI_CustomClass *rc;

 /* Create class */
 if (rc = MUI_CreateCustomClass(NULL, NULL, BaseClass,
                                sizeof(struct AccessClassData),
                                AccessClassDispatcher)) {

  /* Localize strings */
  TextTitle = TranslateString(LOCALE_TEXT_ACCESS_TITLE_STR,
                              LOCALE_TEXT_ACCESS_TITLE);
 }

 ACCESS_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}
