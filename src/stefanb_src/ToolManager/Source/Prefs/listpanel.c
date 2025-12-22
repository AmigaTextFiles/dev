/*
 * listpanel.c  V3.1
 *
 * ListPanel class
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
static const char *TextNewGroup;
static const char *HelpNewGroup;
static const char *TextNewObject;
static const char *HelpNewObject;
static const char *TextSort;
static const char *HelpSort;

/* ListPanel class instance data */
struct ListPanelClassData {
 Object *lpcd_List;
};
#define TYPED_INST_DATA(cl, o) ((struct ListPanelClassData *) INST_DATA((cl), (o)))

/* ListPanel class method: OM_NEW */
#define DEBUGFUNCTION ListPanelClassNew
static ULONG ListPanelClassNew(Class *cl, Object *obj, struct opSet *ops)
{
 Object *Listview;
 Object *NewGroupButton;
 Object *NewObjectButton;
 Object *DeleteButton;
 Object *SortButton;
 Object *List;

 LISTPANEL_LOG((LOG1(Tags, "0x%08lx", ops->ops_AttrList),
                PrintTagList(ops->ops_AttrList)))

 if (obj = (Object *) DoSuperNew(cl, obj,
      MUIA_Group_Horiz, FALSE,
      Child, Listview = ListviewObject,
       MUIA_Listview_DragType, MUIV_Listview_DragType_Immediate,
       MUIA_Listview_List,     List = NewObjectA(ListTreeClass->mcc_Class,
                                                 NULL, ops->ops_AttrList),
       MUIA_CycleChain,        TRUE,
      End,
      Child, HGroup,
       MUIA_Group_SameWidth, TRUE,
       Child, NewGroupButton  = MakeButton(TextNewGroup,     HelpNewGroup),
       Child, NewObjectButton = MakeButton(TextNewObject,    HelpNewObject),
       Child, DeleteButton    = MakeButton(TextGlobalDelete, HelpGlobalDelete),
       Child, SortButton      = MakeButton(TextSort,         HelpSort),
      End,
      TAG_MORE, ops->ops_AttrList)) {
  struct ListPanelClassData *lpcd = TYPED_INST_DATA(cl, obj);

  /* Initialize instance data */
  lpcd->lpcd_List = List;

  /* Add methods to buttons */
  DoMethod(NewGroupButton,  MUIM_Notify, MUIA_Pressed, FALSE,
           List, 1, TMM_NewGroup);
  DoMethod(NewObjectButton, MUIM_Notify, MUIA_Pressed, FALSE,
           List, 1, TMM_NewObject);
  DoMethod(DeleteButton,    MUIM_Notify, MUIA_Pressed, FALSE,
           List, 4, MUIM_Listtree_Remove, MUIV_Listtree_Remove_ListNode_Root,
                    MUIV_Listtree_Remove_TreeNode_Active, 0);
  DoMethod(SortButton,      MUIM_Notify, MUIA_Pressed, FALSE,
           List, 1, TMM_Sort);
 }

 LISTPANEL_LOG(LOG1(Result, "0x%08lx", obj))

 /* Return pointer to created object */
 return((ULONG) obj);
}

/* ListPanel class method: TMM_WBArg */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ListPanelClassWBArg
static ULONG ListPanelClassWBArg(Class *cl, Object *obj,
                                 struct TMP_WBArg *tmpwa)
{
 Object                        *list = TYPED_INST_DATA(cl, obj)->lpcd_List;
 struct MUIS_Listtree_TreeNode *tn;
 Object                        *rc   = NULL;

 /* Create new object */
 if (tn = (struct MUIS_Listtree_TreeNode *) DoMethod(list, TMM_NewObject)) {

  LISTPANEL_LOG(LOG1(TreeNode, "0x%08lx", tn))

  /* Forward method to new object */
  if (DoMethodA(tn->tn_User, (Msg) tmpwa)) {

   /* Method succeeded, redraw list */
   DoMethod(list, MUIM_List_Redraw, MUIV_List_Redraw_All);

   /* Set return code */
   rc = tn->tn_User;

  } else {

   LISTPANEL_LOG(LOG0(Object could not use the WBArg))

   /* Method failed, remove object again */
   DoMethod(list, MUIM_Listtree_Remove, MUIV_Listtree_Remove_ListNode_Root, tn,
            0);
  }
 }

 LISTPANEL_LOG(LOG1(Result, "0x%08lx", rc))

 /* Return pointer to new object */
 return((ULONG) rc);
}

/* ListPanel class method dispatcher */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ListPanelClassDispatcher
__geta4 static ULONG ListPanelClassDispatcher(__a0 Class *cl, __a2 Object *obj,
                                              __a1 Msg msg)
{
 ULONG rc;

 LISTPANEL_LOG(LOG3(Arguments, "Class 0x%08lx Object 0x%08lx Msg 0x%08lx",
                    cl, obj, msg))

 switch(msg->MethodID) {
  /* BOOPSI methods */
  case OM_NEW:
   rc = ListPanelClassNew(cl, obj, (struct opSet *) msg);
   break;

  /* Forward some MUI Listtree methods to embedded list object   */
  /* NOTE: We can't rely on the forward mechanism of the group   */
  /*       superclass because we need the return code for these! */
  case MUIM_Listtree_Insert:
  case MUIM_Listtree_Remove:
  case MUIM_Listtree_GetEntry:
  case MUIM_Listtree_FindName:
   rc = DoMethodA(TYPED_INST_DATA(cl, obj)->lpcd_List, msg);
   break;

  /* TM methods */
  case TMM_WBArg:
   rc = ListPanelClassWBArg(cl, obj, (struct TMP_WBArg *) msg);
   break;

  /* Unknown method -> delegate to SuperClass */
  default:
   rc = DoSuperMethodA(cl, obj, msg);
   break;
 }

 return(rc);
}

/* Create ListPanel class */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CreateListPanelClass
struct MUI_CustomClass *CreateListPanelClass(void)
{
 struct MUI_CustomClass *rc;

 /* Create class */
 if (rc = MUI_CreateCustomClass(NULL, MUIC_Group, NULL,
                                sizeof(struct ListPanelClassData),
                                ListPanelClassDispatcher)) {

  /* Localize strings */
  TextNewGroup  = TranslateString(LOCALE_TEXT_LISTPANEL_NEW_GROUP_STR,
                                  LOCALE_TEXT_LISTPANEL_NEW_GROUP);
  HelpNewGroup  = TranslateString(LOCALE_HELP_LISTPANEL_NEW_GROUP_STR,
                                  LOCALE_HELP_LISTPANEL_NEW_GROUP);
  TextNewObject = TranslateString(LOCALE_TEXT_LISTPANEL_NEW_OBJECT_STR,
                                  LOCALE_TEXT_LISTPANEL_NEW_OBJECT);
  HelpNewObject = TranslateString(LOCALE_HELP_LISTPANEL_NEW_OBJECT_STR,
                                  LOCALE_HELP_LISTPANEL_NEW_OBJECT);
  TextSort      = TranslateString(LOCALE_TEXT_LISTPANEL_SORT_STR,
                                  LOCALE_TEXT_LISTPANEL_SORT);
  HelpSort      = TranslateString(LOCALE_HELP_LISTPANEL_SORT_STR,
                                  LOCALE_HELP_LISTPANEL_SORT);
 }

 LISTPANEL_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}
