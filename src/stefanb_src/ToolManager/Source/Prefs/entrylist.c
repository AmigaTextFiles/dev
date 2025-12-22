/*
 * entrylist.c  V3.1
 *
 * Class for TM dock entries list
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
static const char *TextColumnExec;
static const char *TextColumnImage;
static const char *TextColumnSound;

/* EntryList class instance data */
struct EntryListClassData {
 struct Hook elcd_Construct;
};
#define TYPED_INST_DATA(cl, o) ((struct EntryListClassData *) INST_DATA((cl), (o)))

/* EntryList class construct function */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION EntryListClassConstruct
__geta4 static ULONG EntryListClassConstruct(__a0 struct Hook *h,
                                             __a1 struct DockEntry *de)
{
 /* Duplicate dock entry */
 return((ULONG) CopyDockEntry(de, (Object *) h->h_Data));
}

/* EntryList class destruct function */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION EntryListClassDestruct
__geta4 static void EntryListClassDestruct(__a1 struct DockEntry *de)
{
 /* Free dock entry */
 FreeDockEntry(de);
}

/* EntryList class display function */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION EntryListClassDisplay
__geta4 static void EntryListClassDisplay(__a1 struct DockEntry *de,
                                          __a2 const char **array)
{
 /* Entry valid? */
 if (de) {

  /* Yes, get object names. Get Exec object name */
  if (de->de_Exec)
   GetAttr(TMA_Name, de->de_Exec->ad_Object,  (ULONG *) array++);
  else
   *array++ = TextGlobalEmpty;

  /* Get Image object name */
  if (de->de_Image)
   GetAttr(TMA_Name, de->de_Image->ad_Object, (ULONG *) array++);
  else
   *array++ = TextGlobalEmpty;

  /* Get Sound object name */
  if (de->de_Sound)
   GetAttr(TMA_Name, de->de_Sound->ad_Object, (ULONG *) array);
  else
   *array = TextGlobalEmpty;

 } else {

  /* No, create title column */
  *array++ = TextColumnExec;
  *array++ = TextColumnImage;
  *array   = TextColumnSound;
 }
}

/* Hooks */
static const struct Hook DestructHook = {
 {NULL, NULL}, (void *) EntryListClassDestruct, NULL, NULL
};
static const struct Hook DisplayHook = {
 {NULL, NULL}, (void *) EntryListClassDisplay, NULL, NULL
};

/* EntryList class method: OM_NEW */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION EntryListClassNew
static ULONG EntryListClassNew(Class *cl, Object *obj, struct opSet *ops)
{
 ENTRYLIST_LOG((LOG1(Tags, "0x%08lx", ops->ops_AttrList),
                PrintTagList(ops->ops_AttrList)))

 /* Create object */
 if (obj = (Object *) DoSuperNew(cl, obj,
                                 MUIA_List_DestructHook, &DestructHook,
                                 MUIA_List_DisplayHook,  &DisplayHook,
                                 MUIA_List_Format,       "BAR,BAR,",
                                 MUIA_List_DragSortable, TRUE,
                                 MUIA_List_Title,        TRUE,
                                 TAG_MORE,               ops->ops_AttrList)) {
  struct EntryListClassData *elcd = TYPED_INST_DATA(cl, obj);
  struct DockEntry          *de   = (struct DockEntry *)
                                     GetHead((struct MinList *)
                                              GetTagData(TMA_Entries, NULL,
                                                         ops->ops_AttrList));

  /* Initialize construct hook */
  elcd->elcd_Construct.h_Entry = (void *) EntryListClassConstruct;
  elcd->elcd_Construct.h_Data  = obj;

  /* Set construct hook */
  SetAttrs(obj, MUIA_List_ConstructHook, &elcd->elcd_Construct, TAG_DONE);

  /* For each dock entry */
  while (de) {

   /* Insert entry */
   DoMethod(obj, MUIM_List_InsertSingle, de, MUIV_List_Insert_Bottom);

   /* Next entry */
   de = (struct DockEntry *) GetSucc((struct MinNode *) de);
  }
 }

 ENTRYLIST_LOG(LOG1(Result, "0x%08lx", obj))

 /* Return pointer to created object */
 return((ULONG) obj);
}

/* EntryList class method: MUIM_DragQuery */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION EntryListClassDragQuery
static ULONG EntryListClassDragQuery(Class *cl, Object *obj,
                                     struct MUIP_DragQuery *mpdq)
{
 ULONG rc = MUIV_DragQuery_Accept;

#if DEBUG_VERY_NOISY
 /* This just generates too much debug output... */
 ENTRYLIST_LOG(LOG2(Arguments, "Object 0x%08lx Source 0x%08lx", obj,
                    mpdq->obj))
#endif

 /* Is source our list? */
 if (mpdq->obj != obj) {
  Object *active;
  ULONG   type   = TMOBJTYPES;

  /* No, get active entry */
  if (GetAttr(TMA_Active, mpdq->obj, (ULONG *) &active))

   /* Get type of object */
   GetAttr(TMA_Type, active, &type);

  /* Check type, only Exec, Image and Sound objects are accepted */
  if (type > TMOBJTYPE_SOUND) rc = MUIV_DragQuery_Refuse;
 }

 return(rc);
}

/* EntryList class method: MUIM_DragDrop */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION EntryListClassDragDrop
static ULONG EntryListClassDragDrop(Class *cl, Object *obj,
                                    struct MUIP_DragDrop *mpdd)
{
 /* Is source our list? */
 if (obj == mpdd->obj)

  /* Yes, call SuperClass */
  DoSuperMethodA(cl, obj, (Msg) mpdd);

 else {
  Object           *active;
  ULONG             type;
  ULONG             entry;
  struct DockEntry *de;

  /* No, get active entry */
  GetAttr(TMA_Active, mpdd->obj, (ULONG *) &active);

  ENTRYLIST_LOG(LOG1(Object, "0x%08lx", active))

  /* Get type of object */
  GetAttr(TMA_Type, active, &type);

  ENTRYLIST_LOG(LOG1(Type, "%ld", type))

  /* Get drop mark */
  GetAttr(MUIA_List_DropMark, obj, &entry);

  ENTRYLIST_LOG(LOG1(Drop Mark, "%ld", entry))

  /* Get entry corresponding to drop mark */
  DoMethod(obj, MUIM_List_GetEntry, entry, &de);

  /* Entry valid? */
  if (de) {

   ENTRYLIST_LOG(LOG1(Dock Entry, "0x%08lx", de))

   /* Which type? */
   switch (type) {
    case TMOBJTYPE_EXEC:
     /* Detach old Exec object */
     if (de->de_Exec) DoMethod(de->de_Exec->ad_Object, TMM_Detach,
                               de->de_Exec);

     /* Attach new Exec object */
     de->de_Exec = (struct AttachData *) DoMethod(active, TMM_Attach, obj);
     break;

    case TMOBJTYPE_IMAGE:
     /* Detach old Image object */
     if (de->de_Image) DoMethod(de->de_Image->ad_Object, TMM_Detach,
                                de->de_Image);

     /* Attach new Image object */
     de->de_Image = (struct AttachData *) DoMethod(active, TMM_Attach, obj);
     break;

    case TMOBJTYPE_SOUND:
     /* Detach old Sound object */
     if (de->de_Sound) DoMethod(de->de_Sound->ad_Object, TMM_Detach,
                                de->de_Sound);

     /* Attach new Sound object */
     de->de_Sound = (struct AttachData *) DoMethod(active, TMM_Attach, obj);
     break;
   }

   /* Redraw entry */
   DoMethod(obj, MUIM_List_Redraw, entry);

  } else {
   struct DockEntry  de;
   struct AttachData ad;

   /* Initialize dummy entry */
   de.de_Exec  = NULL;
   de.de_Image = NULL;
   de.de_Sound = NULL;

   /* Initialize dummy attach data */
   ad.ad_Object = active;

   /* Set dummy attach data to correct type */
   switch (type) {
    case TMOBJTYPE_EXEC:  de.de_Exec  = &ad; break;
    case TMOBJTYPE_IMAGE: de.de_Image = &ad; break;
    case TMOBJTYPE_SOUND: de.de_Sound = &ad; break;
   }

   /* Insert "dummy" entry (it will be duplicated!) */
   DoMethod(obj, MUIM_List_InsertSingle, &de, MUIV_List_Insert_Bottom);

   ENTRYLIST_LOG(LOG0(Creating new entry))
  }
 }

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* EntryList class method: TMM_Notify */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION EntryListClassNotify
static ULONG EntryListClassNotify(Class *cl, Object *obj,
                                  struct TMP_Notify *tmpn)
{
 ENTRYLIST_LOG(LOG1(Type, "0x%08lx", tmpn->tmpn_Data->ad_Object))

 /* Object deleted? */
 if (tmpn->tmpn_Data->ad_Object == NULL) {
  int               i  = 0;
  struct DockEntry *de;

  /* For each entry in list */
  do {

   /* Get next entry */
   DoMethod(obj, MUIM_List_GetEntry, i++, &de);

   ENTRYLIST_LOG(LOG1(Next entry, "0x%08lx", de))

   /* Try to remove attached object. Leave loop if object found */
   if (de && RemoveDockEntryAttach(de, tmpn->tmpn_Data)) break;

  } while (de);
 }

 /* Redraw list */
 DoMethod(obj, MUIM_List_Redraw, MUIV_List_Redraw_All);

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* EntryList class method: TMM_WBArg */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION EntryListClassWBArg
static ULONG EntryListClassWBArg(Class *cl, Object *obj,
                                 struct TMP_WBArg *tmpwa)
{
 Object *exec;
 ULONG  rc    = 0;

 ENTRYLIST_LOG(LOG1(WBArg, "0x%08lx", tmpwa->tmpwa_Argument))

 /* Create exec object from WBArg */
 if (exec = (Object *) DoMethodA(tmpwa->tmpwa_Lists[TMOBJTYPE_EXEC],
                                 (Msg) tmpwa)) {
  Object *image;

  ENTRYLIST_LOG(LOG1(Exec, "0x%08lx", exec))

  /* Create image object from WBArg */
  if (image = (Object *) DoMethodA(tmpwa->tmpwa_Lists[TMOBJTYPE_IMAGE],
                                   (Msg) tmpwa)) {
   struct DockEntry  de;
   struct AttachData ead;
   struct AttachData iad;

   ENTRYLIST_LOG(LOG1(Image, "0x%08lx", image))

   /* Initialize dummy entry */
   de.de_Exec  = &ead;
   de.de_Image = &iad;
   de.de_Sound = NULL;

   /* Initialize dummy attach data */
   ead.ad_Object = exec;
   iad.ad_Object = image;

   /* Insert "dummy" entry (it will be duplicated!) */
   DoMethod(obj, MUIM_List_InsertSingle, &de, MUIV_List_Insert_Bottom);

   /* Return 1 to indicate success */
   rc = 1;
  }
 }

 ENTRYLIST_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}

/* EntryList class method: TMM_Column */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION EntryListClassColumn
static ULONG EntryListClassColumn(Class *cl, Object *obj,
                                  struct TMP_Column *tmpc)
{
 struct DockEntry  *de;
 struct AttachData *ad = NULL;

 ENTRYLIST_LOG(LOG1(Column, "%ld", tmpc->tmpc_Column))

 /* Get active entry from list*/
 DoMethod(obj, MUIM_List_GetEntry, MUIV_List_GetEntry_Active, &de);

 ENTRYLIST_LOG(LOG1(Entry, "0x%08lx", de))

 /* Select object to edit */
 switch (tmpc->tmpc_Column) {
  case 0: ad = de->de_Exec;  break;
  case 1: ad = de->de_Image; break;
  case 2: ad = de->de_Sound; break;
 }

 ENTRYLIST_LOG(LOG1(Attach data, "0x%08lx", ad))

 /* Call edit method on the object */
 if (ad) DoMethod(ad->ad_Object, TMM_Edit, NULL);

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* EntryList class method dispatcher */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION EntryListClassDispatcher
__geta4 static ULONG EntryListClassDispatcher(__a0 Class *cl, __a2 Object *obj,
                                              __a1 Msg msg)
{
 ULONG rc;

#if DEBUG_VERY_NOISY
 /* This just generates too much debug output... */
 ENTRYLIST_LOG(LOG3(Arguments, "Class 0x%08lx Object 0x%08lx Msg 0x%08lx",
                    cl, obj, msg))
#endif

 switch(msg->MethodID) {
  /* BOOPSI methods */
  case OM_NEW:
   rc = EntryListClassNew(cl, obj, (struct opSet *) msg);
   break;

  /* MUI methods */
  case MUIM_DragQuery:
   rc = EntryListClassDragQuery(cl, obj, (struct MUIP_DragQuery *) msg);
   break;

  case MUIM_DragDrop:
   rc = EntryListClassDragDrop(cl, obj, (struct MUIP_DragDrop *) msg);
   break;

  /* TM methods */
  case TMM_Notify:
   rc = EntryListClassNotify(cl, obj, (struct TMP_Notify *) msg);
   break;

  case TMM_WBArg:
   rc = EntryListClassWBArg(cl, obj, (struct TMP_WBArg *) msg);
   break;

  case TMM_Column:
   rc = EntryListClassColumn(cl, obj, (struct TMP_Column *) msg);
   break;

  /* Unknown method -> delegate to SuperClass */
  default:
   rc = DoSuperMethodA(cl, obj, msg);
   break;
 }

 return(rc);
}

/* Create EntryList class */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CreateEntryListClass
struct MUI_CustomClass *CreateEntryListClass(void)
{
 struct MUI_CustomClass *rc;

 /* Create class */
 if (rc = MUI_CreateCustomClass(NULL, MUIC_List, NULL,
                                sizeof(struct EntryListClassData),
                                EntryListClassDispatcher)) {

  /* Localize strings */
  TextColumnExec  = TranslateString(LOCALE_TEXT_ENTRYLIST_COLUMN_EXEC_STR,
                                    LOCALE_TEXT_ENTRYLIST_COLUMN_EXEC);
  TextColumnImage = TranslateString(LOCALE_TEXT_ENTRYLIST_COLUMN_IMAGE_STR,
                                    LOCALE_TEXT_ENTRYLIST_COLUMN_IMAGE);
  TextColumnSound = TranslateString(LOCALE_TEXT_ENTRYLIST_COLUMN_SOUND_STR,
                                    LOCALE_TEXT_ENTRYLIST_COLUMN_SOUND);
 }

 ENTRYLIST_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}
