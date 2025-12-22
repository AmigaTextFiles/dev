/*
 * group.c  V3.1
 *
 * Class for TM config groups
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

/* Group class instance data */
struct GroupClassData {
 ULONG gcd_Dummy;
};
#define TYPED_INST_DATA(cl, o) ((struct GroupClassData *) INST_DATA((cl), (o)))

/* Group class method: OM_NEW */
#define DEBUGFUNCTION GroupClassNew
static ULONG GroupClassNew(Class *cl, Object *obj, struct opSet *ops)
{
 GROUP_LOG((LOG1(Tags, "0x%08lx", ops->ops_AttrList),
            PrintTagList(ops->ops_AttrList)))

 /* Create object */
 if (obj = (Object *) DoSuperNew(cl, obj,
                                       MUIA_Window_Title, TextTitle,
                                       MUIA_HelpNode,     "GroupWindow",
                                       TMA_Type,          TMOBJTYPE_GROUP,
                                       TAG_MORE,          ops->ops_AttrList)) {
 }

 GROUP_LOG(LOG1(Result, "0x%08lx", obj))

 /* Return pointer to created object */
 return((ULONG) obj);
}

/* Group class method dispatcher */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION GroupClassDispatcher
__geta4 static ULONG GroupClassDispatcher(__a0 Class *cl, __a2 Object *obj,
                                          __a1 Msg msg)
{
 ULONG rc;

 GROUP_LOG(LOG3(Arguments, "Class 0x%08lx Object 0x%08lx Msg 0x%08lx",
                cl, obj, msg))

 switch(msg->MethodID) {
  /* BOOPSI methods */
  case OM_NEW:
   rc = GroupClassNew(cl, obj, (struct opSet *) msg);
   break;

  /* TM methods */

  /* Unknown method -> delegate to SuperClass */
  default:
   rc = DoSuperMethodA(cl, obj, msg);
   break;
 }

 return(rc);
}

/* Create Group class */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CreateGroupClass
struct MUI_CustomClass *CreateGroupClass(void)
{
 struct MUI_CustomClass *rc;

 /* Create class */
 if (rc = MUI_CreateCustomClass(NULL, NULL, BaseClass,
                                sizeof(struct GroupClassData),
                                GroupClassDispatcher)) {

  /* Localize strings */
  TextTitle = TranslateString(LOCALE_TEXT_GROUP_TITLE_STR,
                              LOCALE_TEXT_GROUP_TITLE);
 }

 GROUP_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}
