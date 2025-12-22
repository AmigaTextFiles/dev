/*
 * listtree.c  V3.1
 *
 * ListTree class
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
static const char *TextNewObject;

/* ListTree class instance data */
struct ListTreeClassData {
 struct MUI_CustomClass *ltcd_Class;
 ULONG                   ltcd_IsGroup;
};
#define TYPED_INST_DATA(cl, o) ((struct ListTreeClassData *) INST_DATA((cl), (o)))
#define TREENODE(n)            ((struct MUIS_Listtree_TreeNode *) (n))

/* Destruct function  */
#define DEBUGFUNCTION ListTreeClassDestruct
__geta4 static void ListTreeClassDestruct(__a1 Object *obj)
{
 LISTTREE_LOG(LOG1(Object, "0x%08lx", obj))

 MUI_DisposeObject(obj);
}

/* Display function  */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ListTreeClassDisplay
__geta4 static void ListTreeClassDisplay(
                                        __a1 struct MUIS_Listtree_TreeNode *tn,
                                        __a2 char **array)
{
#if DEBUG_VERY_NOISY
 /* This just generates too much debug output... */
 LISTTREE_LOG(LOG1(Object, "0x%08lx", tn->tn_User))
#endif

 /* Get name of object */
 GetAttr(TMA_Name, tn->tn_User, (ULONG *) array);
}

/* Compare function  */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ListTreeClassSortH
__geta4 static LONG ListTreeClassSortH(__a1 struct MUIS_Listtree_TreeNode *tn1,
                                       __a2 struct MUIS_Listtree_TreeNode *tn2)
{
 const char *s1, *s2;

 /* This just generates too much debug output... */
 LISTTREE_LOG(LOG2(Entry, "Obj1 0x%08lx Obj2 0x%08lx", tn1->tn_User,
                   tn2->tn_User))

 /* Get name of objects */
 GetAttr(TMA_Name, tn1->tn_User, (ULONG *) &s1);
 GetAttr(TMA_Name, tn2->tn_User, (ULONG *) &s2);

 /* Return result of string comparison */
 return(strcmp(s2, s1));
}

/* Hooks */
static const struct Hook DestructHook = {
 {NULL, NULL}, (void *) ListTreeClassDestruct, NULL, NULL
};
static const struct Hook DisplayHook = {
 {NULL, NULL}, (void *) ListTreeClassDisplay, NULL, NULL
};
static const struct Hook SortHook = {
 {NULL, NULL}, (void *) ListTreeClassSortH, NULL, NULL
};

/* ListTree class method: OM_NEW */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ListTreeClassNew
static ULONG ListTreeClassNew(Class *cl, Object *obj, struct opSet *ops)
{
 LISTTREE_LOG((LOG1(Tags, "0x%08lx", ops->ops_AttrList),
               PrintTagList(ops->ops_AttrList)))

 if (obj = (Object *) DoSuperNew(cl, obj,
                                InputListFrame,
                                MUIA_Listtree_DuplicateNodeName, FALSE,
                                MUIA_Listtree_DestructHook,      &DestructHook,
                                MUIA_Listtree_DisplayHook,       &DisplayHook,
                                MUIA_Listtree_SortHook,          &SortHook,
                                TAG_MORE, ops->ops_AttrList)) {

  /* Initialize instance data */
  TYPED_INST_DATA(cl, obj)->ltcd_Class = (struct MUI_CustomClass *)
                                GetTagData(TMA_Class, NULL, ops->ops_AttrList);

  /* Double click on node names does not open it */
  SetAttrs(obj, MUIA_Listtree_DoubleClick, MUIV_Listtree_DoubleClick_Off,
                TAG_DONE);

  /* Double click on node names/leaves starts editing */
  DoMethod(obj, MUIM_Notify, MUIA_Listtree_DoubleClick, MUIV_EveryTime,
            obj, 2, TMM_Selected, MUIV_TriggerValue);
 }

 LISTTREE_LOG(LOG1(Result, "0x%08lx", obj))

 /* Return pointer to created object */
 return((ULONG) obj);
}

/* ListTree class method: OM_GET */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ListTreeClassGet
static ULONG ListTreeClassGet(Class *cl, Object *obj, struct opGet *opg)
{
 ULONG rc = FALSE;

 LISTTREE_LOG(LOG2(Attribute, "0x%08lx (%s)", opg->opg_AttrID,
                   GetTagName(opg->opg_AttrID)))

 /* Which attribute is requested? */
 switch(opg->opg_AttrID) {
  case TMA_Active: {
    struct MUIS_Listtree_TreeNode *tn;

    /* Get active entry */
    GetAttr(MUIA_Listtree_Active, obj, (ULONG *) &tn);

    /* Is active entry an object? */
    if ((tn->tn_Flags & TNF_LIST) == 0) {

     /* Return pointer to embedded object */
     *opg->opg_Storage = (ULONG) tn->tn_User;

     /* Return TRUE to indicate that the attribute is implemented */
     rc = TRUE;
    }
   }
   break;

  default:
   rc = DoSuperMethodA(cl, obj, (Msg) opg);
   break;
 }

 LISTTREE_LOG(LOG2(Result, "%ld value 0x%08lx", rc, *opg->opg_Storage))

 return(rc);
}

/* ListTree class method: MUIM_DragQuery */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ListTreeClassDragQuery
static ULONG ListTreeClassDragQuery(Class *cl, Object *obj,
                                    struct MUIP_DragQuery *mpdq)
{
 ULONG rc = MUIV_DragQuery_Refuse;

#if DEBUG_VERY_NOISY
 /* This just generates too much debug output... */
 LISTTREE_LOG(LOG2(Arguments, "Object 0x%08lx Source 0x%08lx", obj, mpdq->obj))
#endif

 /* Is source our list? */
 if (mpdq->obj == obj) {
  struct MUIS_Listtree_TreeNode *active;

  /* Get active entry */
  GetAttr(MUIA_Listtree_Active, obj, (ULONG *) &active);

  /* Dragging a group or an object? */
  TYPED_INST_DATA(cl, obj)->ltcd_IsGroup = (active->tn_Flags & TNF_LIST) != 0;

  /* Call SuperClass */
  rc = DoSuperMethodA(cl, obj, (Msg) mpdq);
 }

 return(rc);
}

/* ListTree class method: MUIM_DragReport */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ListTreeClassDragReport
static ULONG ListTreeClassDragReport(Class *cl, Object *obj,
                                     struct MUIP_DragReport *mpdr)
{
 struct MUIS_Listtree_TestPos_Result tpr;
 ULONG                               rc  = MUIV_DragReport_Continue;

#if DEBUG_VERY_NOISY
 /* This just generates too much debug output... */
 LISTTREE_LOG(LOG0(Entry))
#endif

#if 1
 /* This works, but the ListTree doesn't scroll... */
 /* Test position */
 if (DoMethod(obj, MUIM_Listtree_TestPos, mpdr->x, mpdr->y, &tpr)) {

  /* Update required? */
  if (mpdr->update) {
   BOOL IsGroup   = TYPED_INST_DATA(cl, obj)->ltcd_IsGroup;
   BOOL GroupDrop;

   /* Yes, is current destination end of tree or above/below a group? */
   GroupDrop = (TREENODE(tpr.tpr_TreeNode) == NULL) ||
               ((TREENODE(tpr.tpr_TreeNode)->tn_Flags & TNF_LIST) &&
                ((tpr.tpr_Flags == MUIV_Listtree_TestPos_Result_Flags_Above) ||
                 (tpr.tpr_Flags == MUIV_Listtree_TestPos_Result_Flags_Below)));

   /* Dragging a group and group drop or object and no group drop? */
   if ((IsGroup && GroupDrop) || ((IsGroup == FALSE) && (GroupDrop == FALSE)))

    /* Yes, call SuperClass */
    rc = DoSuperMethodA(cl, obj, (Msg) mpdr);

  /* No, just refresh */
  } else rc = MUIV_DragReport_Refresh;
 }

#else
 /* This officially documented way doesn't work */
 static LONG  old_entry = 0;
 static ULONG old_flags = 0;

 /* Test position */
 DoMethod(obj, MUIM_Listtree_TestPos, mpdr->x, mpdr->y, &tpr);

 /* Entry dragged over a new entry or flags changed? */
 if ((tpr.tpr_ListEntry != old_entry) || (tpr.tpr_Flags != old_flags)) {

  /* Update required? */
  if (mpdr->update) {
   BOOL IsGroup   = TYPED_INST_DATA(cl, obj)->ltcd_IsGroup;
   BOOL GroupDrop;

   /* Store new values */
   old_entry = tpr.tpr_ListEntry;
   old_flags = tpr.tpr_Flags;

   /* Yes, is current destination end of tree or above/below a group? */
   GroupDrop = (TREENODE(tpr.tpr_TreeNode) == NULL) ||
               ((TREENODE(tpr.tpr_TreeNode)->tn_Flags & TNF_LIST) &&
                ((tpr.tpr_Flags == MUIV_Listtree_TestPos_Result_Flags_Above) ||
                 (tpr.tpr_Flags == MUIV_Listtree_TestPos_Result_Flags_Below)));

   /* Dragging a group and group drop or object and no group drop? */
   if ((IsGroup && GroupDrop) || ((IsGroup == FALSE) && (GroupDrop == FALSE)))

    /* Yes, show drop mark */
    DoMethod(obj, MUIM_Listtree_SetDropMark, old_entry, tpr.tpr_ListFlags);

   else

    /* No, don't show drop mark */
    DoMethod(obj, MUIM_Listtree_SetDropMark, old_entry, MUIV_Listtree_SetDropMark_Values_None);

   /* Call SuperClass */
   rc = DoSuperMethodA(cl, obj, (Msg) mpdr);

  } else

   /* No update required, just refresh */
   rc = MUIV_DragReport_Refresh;

 } else

  /* No, just forward message to SuperClass */
  rc = DoSuperMethodA(cl, obj, (Msg) mpdr);
#endif

 return(rc);
}

/* ListTree class method: TMM_NewGroup */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ListTreeClassNewGroup
static ULONG ListTreeClassNewGroup(Class *cl, Object *obj)
{
 struct MUIS_Listtree_TreeNode *rc    = NULL;
 Object                        *group;

 LISTTREE_LOG(LOG0(Entry))

 /* Create new group object */
 if (group = NewObject(GroupClass->mcc_Class, NULL, TMA_Name, TextNewGroup,
                                                    TMA_List, obj,
                                                    TAG_DONE)) {
  struct MUIS_Listtree_TreeNode *active;

  LISTTREE_LOG(LOG1(Group, "0%08lx", group))

  /* Get active entry */
  GetAttr(MUIA_Listtree_Active, obj, (ULONG *) &active);

  /* Active entry valid? */
  if (active) {

   /* Is entry an object (= leaf)? */
   if ((active->tn_Flags & TNF_LIST) == 0)

    /* Yes, get parent node */
    active = TREENODE(DoMethod(obj, MUIM_Listtree_GetEntry, active,
                               MUIV_Listtree_GetEntry_Position_Parent, 0));

  } else

   /* No, just add new group at the end of the list */
   active = TREENODE(MUIV_Listtree_Insert_PrevNode_Tail);

  /* Insert group into tree */
  if (rc = TREENODE(DoMethod(obj, MUIM_Listtree_Insert, TextNewGroup, group,
                             MUIV_Listtree_Insert_ListNode_Root, active,
                             TNF_LIST | TNF_OPEN))) {

   LISTTREE_LOG(LOG1(Group inserted, "0x%08lx", rc))

   /* Make it the active one */
   SetAttrs(obj, MUIA_Listtree_Active, rc, TAG_DONE);

   /* Let the user edit the group name */
   DoMethod(group, TMM_Edit, NULL);

  } else

   /* Couldn't insert group, delete it */
   MUI_DisposeObject(group);
 }

 LISTTREE_LOG(LOG1(Result, "0x%08lx", rc))

 /* Return pointer to TreeNode */
 return((ULONG) rc);
}

/* ListTree class method: TMM_NewObject */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ListTreeClassNewObject
static ULONG ListTreeClassNewObject(Class *cl, Object *obj)
{
 struct MUIS_Listtree_TreeNode *rc     = NULL;
 Object                        *newobj;

 LISTTREE_LOG(LOG0(Entry))

 /* Create new object */ /* TEMPORARY! */
 if (newobj = NewObject(TYPED_INST_DATA(cl, obj)->ltcd_Class->mcc_Class, NULL,
                        TMA_Name, TextNewObject,
                        TMA_List, obj,
                        TAG_DONE)) {
  struct MUIS_Listtree_TreeNode *active = TREENODE(
                                           MUIV_Listtree_Insert_PrevNode_Tail);
  struct MUIS_Listtree_TreeNode *list;

  LISTTREE_LOG(LOG1(Object, "0%08lx", newobj))

  /* Get active entry */
  GetAttr(MUIA_Listtree_Active, obj, (ULONG *) &list);

  /* Active entry valid? */
  if (list) {

   /* Yes, is entry an object (= leaf)? */
   if ((list->tn_Flags & TNF_LIST) == 0) {

    /* Yes, append new object after active node */
    active = list;

    /* Get parent node */
    list = TREENODE(DoMethod(obj, MUIM_Listtree_GetEntry, list,
                             MUIV_Listtree_GetEntry_Position_Parent, 0));
   }
  } else

   /* No, get last entry */
   if ((list = TREENODE(DoMethod(obj, MUIM_Listtree_GetEntry,
                                 MUIV_Listtree_GetEntry_ListNode_Root,
                                 MUIV_Listtree_GetEntry_Position_Tail, 0)))
        == NULL)

    /* No groups! Create one */
    list = TREENODE(DoMethod(obj, TMM_NewGroup));

  LISTTREE_LOG(LOG1(List, "0%08lx", list))

  /* Insert group into tree */
  if (list && (rc = TREENODE(DoMethod(obj, MUIM_Listtree_Insert, TextNewObject,
                                       newobj, list, active, 0)))) {

   LISTTREE_LOG(LOG1(Object inserted, "0x%08lx", rc))

   /* Open group */
   DoMethod(obj, MUIM_Listtree_Open, MUIV_Listtree_Open_ListNode_Root, list,
            0);

   /* Make it the active one */
   SetAttrs(obj, MUIA_Listtree_Active, rc, TAG_DONE);

   /* Let the user edit the object */
   DoMethod(newobj, TMM_Edit, NULL);

  } else

   /* Couldn't insert object, delete it */
   MUI_DisposeObject(newobj);
 }

 LISTTREE_LOG(LOG1(Result, "0x%08lx", rc))

 /* Return pointer to TreeNode */
 return((ULONG) rc);
}

/* ListTree class method: TMM_Sort */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ListTreeClassSort
static ULONG ListTreeClassSort(Class *cl, Object *obj)
{
 struct MUIS_Listtree_TreeNode *tn;

 LISTTREE_LOG(LOG0(Entry))

 /* Get active node */
 GetAttr(MUIA_Listtree_Active, obj, (ULONG *) &tn);

 /* Active node found? */
 if (tn)

  /* List node? */
  if (tn->tn_Flags & TNF_LIST) {

   /* Yes, list closed? Sort root */
   if ((tn->tn_Flags & TNF_OPEN) == 0) tn = MUIV_Listtree_Sort_ListNode_Root;

  } else

   /* No, leaf node. Get parent node */
   tn = TREENODE(DoMethod(obj, MUIM_Listtree_GetEntry, tn,
                          MUIV_Listtree_GetEntry_Position_Parent, 0));

 else

  /* No, sort root list */
  tn = MUIV_Listtree_Sort_ListNode_Root;

 /* Call sort method */
 DoMethod(obj, MUIM_Listtree_Sort, tn, 0);

 return(0);
}

/* ListTree class method: TMM_Update */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ListTreeClassUpdate
static ULONG ListTreeClassUpdate(Class *cl, Object *obj,
                                 struct TMP_Update *tmpu)
{
 LISTTREE_LOG(LOG2(Entry, "Object 0x%08lx Type %ld", tmpu->tmpu_Entry,
                   tmpu->tmpu_Type))

 /* Tell entry to finish */
 DoMethod(tmpu->tmpu_Entry, TMM_Finish, tmpu->tmpu_Type);

 /* Redraw list */
 DoMethod(obj, MUIM_List_Redraw, MUIV_List_Redraw_All);

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* ListTree class method dispatcher */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ListTreeClassDispatcher
__geta4 static ULONG ListTreeClassDispatcher(__a0 Class *cl, __a2 Object *obj,
                                             __a1 Msg msg)
{
 ULONG rc;

#if DEBUG_VERY_NOISY
 /* This just generates too much debug output... */
 LISTTREE_LOG(LOG3(Arguments, "Class 0x%08lx Object 0x%08lx Msg 0x%08lx",
                   cl, obj, msg))
#endif

 switch(msg->MethodID) {
  /* BOOPSI methods */
  case OM_NEW:
   rc = ListTreeClassNew(cl, obj, (struct opSet *) msg);
   break;

  case OM_GET:
   rc = ListTreeClassGet(cl, obj, (struct opGet *) msg);
   break;

  /* MUI methods */
  case MUIM_DragQuery:
   rc = ListTreeClassDragQuery(cl, obj, (struct MUIP_DragQuery *) msg);
   break;

  case MUIM_DragReport:
   rc = ListTreeClassDragReport(cl, obj, (struct MUIP_DragReport *) msg);
   break;

  /* TM methods */
  case TMM_NewGroup:
   rc = ListTreeClassNewGroup(cl, obj);
   break;

  case TMM_NewObject:
   rc = ListTreeClassNewObject(cl, obj);
   break;

  case TMM_Sort:
   rc = ListTreeClassSort(cl, obj);
   break;

  case TMM_Selected:
   /* Translate it to the TMM_Edit method for the attached object */
   rc = DoMethod(((struct TMP_Selected *) msg)->tmps_Entry->tn_User,
                 TMM_Edit, NULL);
   break;

  case TMM_Update:
   rc = ListTreeClassUpdate(cl, obj, (struct TMP_Update *) msg);
   break;

  /* Unknown method -> delegate to SuperClass */
  default:
   rc = DoSuperMethodA(cl, obj, msg);
   break;
 }

 return(rc);
}

/* Create ListTree class */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CreateListTreeClass
struct MUI_CustomClass *CreateListTreeClass(void)
{
 struct MUI_CustomClass *rc;

 /* Create class */
 if (rc = MUI_CreateCustomClass(NULL, MUIC_Listtree, NULL,
                                sizeof(struct ListTreeClassData),
                                ListTreeClassDispatcher)) {

  /* Localize strings */
  TextNewGroup  = TranslateString(LOCALE_TEXT_LISTTREE_NEW_GROUP_STR,
                                  LOCALE_TEXT_LISTTREE_NEW_GROUP);
  TextNewObject = TranslateString(LOCALE_TEXT_LISTTREE_NEW_OBJECT_STR,
                                  LOCALE_TEXT_LISTTREE_NEW_OBJECT);
 }

 LISTTREE_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}

/* Search object with specified ID in list and attach to it */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION AttachObject
struct AttachData *AttachObject(Object *list, Object *obj, ULONG id)
{
 struct MUIS_Listtree_TreeNode *group;
 struct AttachData             *rc    = NULL;

 /* Get first group in list */
 if (group = TREENODE(DoMethod(list, MUIM_Listtree_GetEntry,
                               MUIV_Listtree_GetEntry_ListNode_Root,
                               MUIV_Listtree_GetEntry_Position_Head,
                               0))) {
  ULONG objid;

  /* For each group in the list */
  do {
   struct MUIS_Listtree_TreeNode *tn  = group;
   struct MUIS_Listtree_TreeNode *pos =
                                TREENODE(MUIV_Listtree_GetEntry_Position_Head);

   LISTTREE_LOG(LOG1(Next group, "0x%08lx", group))

   /* For each object in group */
   while (tn = TREENODE(DoMethod(list, MUIM_Listtree_GetEntry, tn, pos, 0))) {

    CONFIG_LOG(LOG1(Next object, "0x%08lx", tn->tn_User))

    /* Get object ID */
    GetAttr(TMA_ID, tn->tn_User, &objid);

    /* Object found? */
    if (objid == id) {

     /* Yes, attach object */
     rc = (struct AttachData *) DoMethod(tn->tn_User, TMM_Attach, obj);

     /* Leave loop */
     break;
    }

    /* Search for next object on the same level */
    pos = TREENODE(MUIV_Listtree_GetEntry_Position_Next);
   }

  /* Get next group */
  } while ((rc == NULL) &&
           (group = TREENODE(DoMethod(list, MUIM_Listtree_GetEntry,
                                      group,
                                      MUIV_Listtree_GetEntry_Position_Next,
                                      0))));
 }

 LISTTREE_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}
