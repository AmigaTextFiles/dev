/*
 * clipwindow.c  V3.1
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
static const char *TextTitle;
static const char *HelpList;

/* ClipWindow class instance data */
struct ClipWindowClassData {
 ULONG cwcd_Dummy;
};
#define TYPED_INST_DATA(cl, o) ((struct ClipWindowClassData *) INST_DATA((cl), (o)))

/* ClipWindow class method: OM_NEW */
#define DEBUGFUNCTION ClipWindowClassNew
static ULONG ClipWindowClassNew(Class *cl, Object *obj, struct opSet *ops)
{
 Object *ListView;
 Object *List;
 Object *Delete;

 CLIPWINDOW_LOG((LOG1(Tags, "0x%08lx", ops->ops_AttrList),
                 PrintTagList(ops->ops_AttrList)))

 /* Create object */
 if (obj = (Object *) DoSuperNew(cl, obj,
        MUIA_Window_Title,    TextTitle,
        MUIA_Window_ID,       MAKE_ID('C','L','I','P'),
        MUIA_Window_Activate, FALSE,
        WindowContents,       VGroup,
         Child, VGroup,
          MUIA_Background,  MUII_GroupBack,
          MUIA_Frame,       MUIV_Frame_Group,
          MUIA_ShortHelp,   HelpList,
          Child, ListView = ListviewObject,
           MUIA_Listview_DragType, MUIV_Listview_DragType_Immediate,
           MUIA_Listview_List, List = NewObject(ClipListClass->mcc_Class, NULL,
            MUIA_Frame, MUIV_Frame_InputList,
           End,
           MUIA_CycleChain,        TRUE,
          End,
          Child, Delete = MakeButton(TextGlobalDelete, HelpGlobalDelete),
         End,
        End,
        MUIA_HelpNode,        "ClipWindow",
        TAG_MORE,             ops->ops_AttrList)) {

  /* Close window action */
  DoMethod(obj,      MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
           MUIV_Notify_Application, 4, MUIM_Application_PushMethod,
           obj, 2, TMM_Finish, TMV_Finish_Cancel);

  /* Double-Click action */
  DoMethod(ListView, MUIM_Notify, MUIA_Listview_DoubleClick, TRUE,
           List, 1, TMM_DoubleClicked);

  /* Button actions */
  DoMethod(Delete,   MUIM_Notify, MUIA_Pressed, FALSE,
           List, 2, MUIM_List_Remove, MUIV_List_Remove_Active);
 }

 CLIPWINDOW_LOG(LOG1(Result, "0x%08lx", obj))

 /* Return pointer to created object */
 return((ULONG) obj);
}

/* ClipWindow class method: TMM_Finish */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ClipWindowClassFinish
static ULONG ClipWindowClassFinish(Class *cl, Object *obj,
                                   struct TMP_Finish *tmpf)
{
 CLIPWINDOW_LOG(LOG0(Entry))

 /* Close window */
 SetAttrs(obj, MUIA_Window_Open, FALSE, TAG_DONE);

 /* Remove window from application */
 DoMethod(_app(obj), OM_REMMEMBER, obj);

 /* Dispose object */
 MUI_DisposeObject(obj);

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* ClipWindow class method dispatcher */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ClipWindowClassDispatcher
__geta4 static ULONG ClipWindowClassDispatcher(__a0 Class *cl,
                                               __a2 Object *obj,
                                               __a1 Msg msg)
{
 ULONG rc;

 CLIPWINDOW_LOG(LOG3(Arguments, "Class 0x%08lx Object 0x%08lx Msg 0x%08lx",
                     cl, obj, msg))

 switch(msg->MethodID) {
  /* BOOPSI methods */
  case OM_NEW:
   rc = ClipWindowClassNew(cl, obj, (struct opSet *) msg);
   break;

  /* TM methods */
  case TMM_Finish:
   rc = ClipWindowClassFinish(cl, obj, (struct TMP_Finish *) msg);
   break;

  /* Unknown method -> delegate to SuperClass */
  default:
   rc = DoSuperMethodA(cl, obj, msg);
   break;
 }

 return(rc);
}

/* Create ClipWindow class */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CreateClipWindowClass
struct MUI_CustomClass *CreateClipWindowClass(void)
{
 struct MUI_CustomClass *rc;

 /* Create class */
 if (rc = MUI_CreateCustomClass(NULL, MUIC_Window, NULL,
                                sizeof(struct ClipWindowClassData),
                                ClipWindowClassDispatcher)) {

  /* Localize strings */
  TextTitle = TranslateString(LOCALE_TEXT_CLIPWINDOW_TITLE_STR,
                              LOCALE_TEXT_CLIPWINDOW_TITLE);
  HelpList  = TranslateString(LOCALE_HELP_CLIPWINDOW_LIST_STR,
                              LOCALE_HELP_CLIPWINDOW_LIST);
 }

 CLIPWINDOW_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}
