/*
 * base.c  V3.1
 *
 * ToolManager Objects base class
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

/* Base class instance data */
struct BaseClassData {
 struct TMHandle *bcd_Handle;
 ULONG            bcd_Flags;
 const char      *bcd_Name;
 ULONG            bcd_ID;
 struct MinList   bcd_MemberList;
};
#define TYPED_INST_DATA(cl, o) ((struct BaseClassData *) INST_DATA((cl), (o)))

/* Flags for strings allocated in IFF parsing */
#define IFFF_NAME 0x1  /* Object name */

/* Send TMM_Notify method to attached objects */
#define DEBUGFUNCTION NotifyAttached
static void NotifyAttached(struct BaseClassData *bcd)
{
 struct TMMemberData *tmmd1;
 struct TMMemberData *tmmd2 = (struct TMMemberData *)
                               GetTail(&bcd->bcd_MemberList);

 /* Notify attached objects that this object has changed               */
 /* NOTE: We have to scan the list backwards, because the notification */
 /*       might result in calls to the TMM_Attach/Detach methods which */
 /*       makes the current node invalid!                              */
 while (tmmd1 = tmmd2) {

  BASECLASS_LOG(LOG2(Notify, "Member 0x%08lx Data 0x%08lx",
                     tmmd1->tmmd_Member, tmmd1))

  /* Previous attached object */
  tmmd2 = (struct TMMemberData *) GetPred((struct MinNode *) tmmd1);

  /* Send notification */
  DoMethod(tmmd1->tmmd_Member, TMM_Notify, tmmd1);
 }
}

/* Base class method: OM_NEW */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION BaseClassNew
static ULONG BaseClassNew(Class *cl, Object *obj, struct opSet *ops)
{
 BASECLASS_LOG((LOG1(Tags, "0x%08lx", ops->ops_AttrList),
                PrintTagList(ops->ops_AttrList)))

 /* Call SuperClass */
 if (obj = (Object *) DoSuperMethodA(cl, obj, (Msg) ops)) {
  struct BaseClassData *bcd = TYPED_INST_DATA(cl, obj);

  /* Initialize instance data */
  bcd->bcd_Handle = (struct TMHandle *) GetTagData(TMA_TMHandle, NULL,
                                                    ops->ops_AttrList);
  bcd->bcd_Flags  = 0;
  bcd->bcd_Name   = "";
  bcd->bcd_ID     = ++bcd->bcd_Handle->tmh_IDCounter;

  /* Initialize member list */
  NewList((struct List *) &bcd->bcd_MemberList);

  /* Add new object to TM handle */
  DoSuperMethod(cl, obj, OM_ADDTAIL, &bcd->bcd_Handle
                 ->tmh_ObjectLists[GetTagData(TMA_ObjectType, 0,
                                               ops->ops_AttrList)]);
 }

 return((ULONG) obj);
}

/* Base class method: OM_DISPOSE */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION BaseClassDispose
static ULONG BaseClassDispose(Class *cl, Object *obj, Msg msg)
{
 struct BaseClassData *bcd = TYPED_INST_DATA(cl, obj);

 BASECLASS_LOG(LOG0(Disposing))

 /* Notify all linked objects that this object will be disposed */
 {
  struct TMMemberData *tmmd;

  /* Scan member list */
  while (tmmd = (struct TMMemberData *) GetHead(&bcd->bcd_MemberList)) {

   BASECLASS_LOG(LOG2(Releasing, "Member 0x%08lx Data 0x%08lx",
                      tmmd->tmmd_Member, tmmd))

   /* Cancel membership (TMM_Detach will be send) */
   DoMethod(tmmd->tmmd_Member, TMM_Release, tmmd);
  }
 }

 /* Remove object from TM Handle */
 DoSuperMethod(cl, obj, OM_REMOVE);

 /* Free name */
 if (bcd->bcd_Flags & IFFF_NAME) FreeVector(bcd->bcd_Name);

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, msg));
}

/* Base class method: OM_SET */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION BaseClassSet
static ULONG BaseClassSet(Class *cl, Object *obj, struct opSet *ops)
{
 struct TagItem *tstate = ops->ops_AttrList;
 struct TagItem *ti;

 BASECLASS_LOG((LOG1(Tags, "0x%08lx", ops->ops_AttrList),
                PrintTagList(ops->ops_AttrList)))

 /* Scan tag list */
 while (ti = NextTagItem(&tstate))

  /* Set name? */
  if (ti->ti_Tag == TMA_ObjectName) {
   struct BaseClassData *bcd = TYPED_INST_DATA(cl, obj);

   /* Set new name */
   bcd->bcd_Name = (const char *) ti->ti_Data;

   /* Notify attached objects */
   NotifyAttached(bcd);
  }

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, (Msg) ops));
}

/* Base class method: OM_GET */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION BaseClassGet
static ULONG BaseClassGet(Class *cl, Object *obj, struct opGet *opg)
{
 BASECLASS_LOG(LOG2(Attribute, "0x%08lx (%s)", opg->opg_AttrID,
                    GetTagName(opg->opg_AttrID)))

 /* Which attribute is requested? */
 switch(opg->opg_AttrID) {
  case TMA_TMHandle:
   *opg->opg_Storage = (ULONG) TYPED_INST_DATA(cl, obj)->bcd_Handle;
   break;

  case TMA_ObjectName:
   *opg->opg_Storage = (ULONG) TYPED_INST_DATA(cl, obj)->bcd_Name;
   break;

  case TMA_ObjectID:
   *opg->opg_Storage = TYPED_INST_DATA(cl, obj)->bcd_ID;
   break;

  default:
   DoSuperMethodA(cl, obj, (Msg) opg);
   break;
 }

 BASECLASS_LOG(LOG1(Result, "0x%08lx", *opg->opg_Storage))

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* Base class method: TMM_Attach */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION BaseClassAttach
static ULONG BaseClassAttach(Class *cl, Object *obj, struct TMP_Attach *tmpa)
{
 struct TMMemberData *tmmd;

 BASECLASS_LOG(LOG2(Member, "0x%08lx (%ld)", tmpa->tmpa_Object,
                    tmpa->tmpa_Size))

 /* Allocate member data */
 if (tmmd = GetVector(tmpa->tmpa_Size)) {

  /* Initialize member data */
  tmmd->tmmd_Object = obj;
  tmmd->tmmd_Member = tmpa->tmpa_Object;

  /* Add member to list */
  AddTail((struct List *) &TYPED_INST_DATA(cl, obj)->bcd_MemberList,
          (struct Node *) tmmd);
 }

 BASECLASS_LOG(LOG1(Result, "0x%08lx", tmmd))

 /* Return pointer to member data */
 return((ULONG) tmmd);
}

/* Base class method: TMM_Detach */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION BaseClassDetach
static ULONG BaseClassDetach(Class *cl, Object *obj, struct TMP_Detach *tmpd)
{
 BASECLASS_LOG(LOG2(Arguments, "Data 0x%08lx Member 0x%08lx",
                    tmpd->tmpd_MemberData, tmpd->tmpd_MemberData->tmmd_Member))

 /* Remove member from list */
 Remove((struct Node *) tmpd->tmpd_MemberData);

 /* Free member data */
 FreeVector(tmpd->tmpd_MemberData);

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* Base class method: TMM_ParseIFF */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION BaseClassParseIFF
static ULONG BaseClassParseIFF(Class *cl, Object *obj,
                               struct TMP_ParseIFF *tmppi)
{
 struct ContextNode *cn;
 BOOL                rc = FALSE;

 BASECLASS_LOG(LOG1(Handle, "0x%08lx", tmppi->tmppi_IFFHandle))

 /* Get current chunk */
 if (cn = CurrentChunk(tmppi->tmppi_IFFHandle)) {

  BASECLASS_LOG(LOG3(Chunk, "ID 0x%08lx Type 0x%08lx Size %ld", cn->cn_ID,
                     cn->cn_Type, cn->cn_Size))

  /* Initialize IFF parser */
  if ((PropChunk(tmppi->tmppi_IFFHandle, cn->cn_Type, ID_NAME) == 0) &&
      (PropChunk(tmppi->tmppi_IFFHandle, cn->cn_Type, ID_DATA) == 0) &&
      (StopOnExit(tmppi->tmppi_IFFHandle, cn->cn_Type, ID_FORM) == 0) &&
      (ParseIFF(tmppi->tmppi_IFFHandle, IFFPARSE_SCAN) == IFFERR_EOC)) {
   char *name;

   BASECLASS_LOG(LOG0(FORM parsed OK))

   /* Check for mandatory NAME property */
   if (name = DuplicateProperty(tmppi->tmppi_IFFHandle, cn->cn_Type,
                                ID_NAME)) {
    struct StoredProperty *sp;

    BASECLASS_LOG(LOG2(Name, "%s (0x%08lx)", name, name))

    /* Check for mandatory DATA property */
    if (sp = FindProp(tmppi->tmppi_IFFHandle, cn->cn_Type, ID_DATA)) {
     struct BaseClassData     *bcd = TYPED_INST_DATA(cl, obj);
     struct StandardDATAChunk *sdc = sp->sp_Data;

     BASECLASS_LOG(LOG1(ID, "0x%08lx", sdc->sdc_ID))

     /* Set instance data */
     bcd->bcd_Flags = IFFF_NAME;
     bcd->bcd_Name  = name;
     bcd->bcd_ID    = sdc->sdc_ID;

     /* Configuration data parsed */
     rc = TRUE;

    } else

     /* Mandatory DATA chunk missing */
     FreeVector(name);
   }
  }
 }

 BASECLASS_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Base class method: TMM_ParseTags */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION BaseClassParseTags
static ULONG BaseClassParseTags(Class *cl, Object *obj)
{
 BASECLASS_LOG(LOG0(Object changed))

 /* Notify attached objects */
 NotifyAttached(TYPED_INST_DATA(cl, obj));

 /* Return success */
 return(TRUE);
}

/* Base class dispatcher */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION BaseClassDispatcher
static __geta4 ULONG BaseClassDispatcher(__A0 Class *cl, __A2 Object *obj,
                                         __A1 Msg msg)
{
 ULONG rc;

 BASECLASS_LOG(LOG3(Arguments, "Class 0x%08lx Object 0x%08lx Msg 0x%08lx",
                    cl, obj, msg))

 switch(msg->MethodID) {
  /* BOOPSI methods */
  case OM_NEW:
   rc = BaseClassNew(cl, obj, (struct opSet *) msg);
   break;

  case OM_DISPOSE:
   rc = BaseClassDispose(cl, obj, msg);
   break;

  case OM_SET:
   rc = BaseClassSet(cl, obj, (struct opSet *) msg);
   break;

  case OM_GET:
   rc = BaseClassGet(cl, obj, (struct opGet *) msg);
   break;

  /* TM methods */
  case TMM_Attach:
   rc = BaseClassAttach(cl, obj, (struct TMP_Attach *) msg);
   break;

  case TMM_Detach:
   rc = BaseClassDetach(cl, obj, (struct TMP_Detach *) msg);
   break;

  case TMM_ParseIFF:
   rc = BaseClassParseIFF(cl, obj, (struct TMP_ParseIFF *) msg);
   break;

  case TMM_ParseTags:
   rc = BaseClassParseTags(cl, obj);
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
#define DEBUGFUNCTION CreateBaseClass
const Class *CreateBaseClass(void)
{
 Class *cl;

 /* Create class */
 if (cl = MakeClass(NULL, ROOTCLASS, NULL, sizeof(struct BaseClassData), 0))

  /* Set dispatcher */
  cl->cl_Dispatcher.h_Entry = (ULONG (*)()) BaseClassDispatcher;

 BASECLASS_LOG(LOG1(Class, "0x%08lx", cl))

 /* Return pointer to class */
 return(cl);
}
