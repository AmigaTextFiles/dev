/*
 * image.c  V3.1
 *
 * ToolManager Objects Image class
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
#define PROPCHUNKS 1
static const ULONG PropChunkTable[2 * PROPCHUNKS] = {
 ID_TMIM, ID_FILE
};
static ULONG           IconLockCount      = 0;
static struct Library *IconBase           = NULL;
static ULONG           DataTypesLockCount = 0;
static struct Library *DataTypesBase      = NULL;
static ULONG           RemapEnabled       = TRUE;
static ULONG           RemapPrecision     = PRECISION_IMAGE;

/* Local data structures */
struct TMCacheData {
 struct MinNode  tmcd_Node;
 Object         *tmcd_DTObject;
 struct Screen  *tmcd_Screen;
 ULONG           tmcd_References;
};

struct TMBitMapData {
 struct TMImageData  tmbmd_Data;
 struct TMCacheData *tmbmd_CacheEntry;
};

#define IMAGE_TYPE_BITMAP 0 /* For TMImageData.tmid_Type */
#define IMAGE_TYPE_ICON   1

/* Image class instance data */
struct ImageClassData {
 ULONG           icd_Flags;
 char           *icd_File;
 struct MinList  icd_Cache;
};
#define TYPED_INST_DATA(cl, o) ((struct ImageClassData *) INST_DATA((cl), (o)))

/* Flags for strings allocated in IFF parsing */
#define IFFF_FILE       0x80000000  /* icd_File */

/* Internal state flags */
#define IMAGEF_DELETING 0x00000001  /* Object is in delete state */

#ifdef _DCC
/* VarArgs stub for DoDTMethodA */
ULONG DoDTMethod(Object *obj, struct Window *w, struct Requester *req,
                 ULONG MethodID, ...)
{
 return(DoDTMethodA(obj, w, req, (Msg) &MethodID));
}

/* VarArgs stub for GetDTAttrsA */
ULONG GetDTAttrs(Object *obj, Tag tag1, ...)
{
 return(GetDTAttrsA(obj, (struct Tagitem *) &tag1));
}

/* VarArgs stub for NewDTObjectA */
static Object *NewDTObject(APTR name, Tag tag1, ...)
{
 return(NewDTObjectA(name, (struct TagItem *) &tag1));
}

/* VarArgs stub for SetDTAttrsA */
ULONG SetDTAttrs(Object *obj, struct Window *w, struct Requester *req,
                 Tag tag1, ...)
{
 return(SetDTAttrsA(obj, w, req, (struct Tagitem *) &tag1));
}
#endif

/* Open datatypes.library */
static BOOL LockDataTypesLibrary(void)
{
 BOOL rc;

 /* Library already opened or can we open it? */
 if (rc = (DataTypesBase != NULL) ||
          (DataTypesBase = OpenLibrary("datatypes.library", 39)))

  /* Increment lock counter */
  DataTypesLockCount++;

 return(rc);
}

/* Close datatypes.library */
static void ReleaseDataTypesLibrary(void)
{
 /* Decrement lock counter */
 if (--DataTypesLockCount == 0) {

  /* Lock count is zero, close library */
  CloseLibrary(DataTypesBase);

  /* Reset library base pointer */
  DataTypesBase = NULL;
 }
}

/* Open a picture.datatype object */
static Object *NewImageDTObject(const char *name, struct Screen *s)
{
 return(NewDTObject(name, DTA_SourceType, DTST_FILE,
                          DTA_GroupID,    GID_PICTURE,
                          PDTA_DestMode,  MODE_V43,
                          PDTA_Remap,     RemapEnabled,
                          OBP_Precision,  RemapPrecision,
                          PDTA_Screen,    s,
                          TAG_DONE));
}

/* Get an entry from the cache. If it doesn't exist create a new one and */
/* Try <file> and <file>.info as file name for the DataTypes object      */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION GetCacheEntry
static struct TMCacheEntry *GetCacheEntry(const char *name, struct Screen *s,
                                          struct MinList *l)
{
 struct TMCacheData *rc = (struct TMCacheData *) GetHead(l);;

 IMAGECLASS_LOG(LOG3(Arguments, "Name %s (0x%08lx) Screen 0x%08lx", name,
                     name, s))

 /* Scan cache list */
 while (rc) {

  /* Is the screen of the cache entry the same as the specified one? */
  if (rc->tmcd_Screen == s) {

   /* Yes, increment reference count */
   rc->tmcd_References++;

   /* Leave loop */
   break;
  }

  /* Next entry */
  rc = (struct TMCacheData *) GetSucc((struct MinNode *) rc);
 }

 /* Object not found in cache and can we lock the datatypes.library? */
 if ((rc == NULL) && LockDataTypesLibrary()) {
  struct TMCacheData *tmcd;

  IMAGECLASS_LOG(LOG0(Creating new cache entry))

  /* Yes, allocate memory for new cache entry */
  if (tmcd = GetMemory(sizeof(struct TMCacheData))) {

   IMAGECLASS_LOG(LOG1(New cache entry, "0x%08lx", tmcd))

   /* Open DataTypes object, Try with original file name first */
   if ((tmcd->tmcd_DTObject = NewImageDTObject(name, s)) == NULL) {
    ULONG  len = strlen(name);
    char  *buf;

    IMAGECLASS_LOG(LOG0(Object not loaded trying to load icon))

    /* Allocate memory for string */
    if (buf = GetVector(len + sizeof(".info"))) {

     /* Copy string */
     CopyMem(name, buf, len);

     /* Append ".info" */
     CopyMem(".info", buf + len, sizeof(".info"));

     IMAGECLASS_LOG(LOG2(New name, "%s (0x%08lx)", buf, buf))

     /* Try again with new name */
     tmcd->tmcd_DTObject = NewImageDTObject(buf, s);

     /* Free buffer */
     FreeVector(buf);
    }
   }

   IMAGECLASS_LOG(LOG1(DTObject, "0x%08lx", tmcd->tmcd_DTObject))

   /* Datatypes object created? */
   if (tmcd->tmcd_DTObject) {

    /* Yes, set object attributes */
    SetDTAttrs(tmcd->tmcd_DTObject, NULL, NULL, PDTA_UseFriendBitMap, TRUE,
                                                TAG_DONE);

    /* Draw picture into destination bitmap */
    if (DoDTMethod(tmcd->tmcd_DTObject, NULL, NULL,
                   DTM_PROCLAYOUT, NULL, TRUE)) {

     /* Image remapped, initialize rest of cache entry */
     tmcd->tmcd_Screen     = s;
     tmcd->tmcd_References = 1;

     /* Add entry to cache */
     AddTail((struct List *) l, (struct Node *) tmcd);

     /* Set return value */
     rc = tmcd;
    }
   }

   /* Error? Free cache entry */
   if (rc == NULL) FreeMemory(tmcd, sizeof(struct TMCacheData));
  }

  /* Error? Release datatypes.library again */
  if (rc == NULL) ReleaseDataTypesLibrary();
 }

 IMAGECLASS_LOG(LOG1(Result, "0x%08lx", rc))

 /* Return pointer to cache entry */
 return(rc);
}

/* Remove one entry from cache list */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION RemoveCacheEntry
static void RemoveCacheEntry(struct TMCacheData *tmcd)
{
 IMAGECLASS_LOG(LOG1(Removing, "0x%08lx", tmcd))

 /* Remove entry from list */
 Remove((struct Node *) tmcd);

 /* Free DataTypes object */
 DisposeDTObject(tmcd->tmcd_DTObject);

 /* Release datatypes.library */
 ReleaseDataTypesLibrary();

 /* Free memory for cache entry */
 FreeMemory(tmcd, sizeof(struct TMCacheData));
}

/* Open icon.library */
static BOOL LockIconLibrary(void)
{
 BOOL rc;

 /* Library already opened or can we open it? */
 if (rc = (IconBase != NULL) ||
          (IconBase = OpenLibrary("icon.library", 39)))

  /* Increment lock counter */
  IconLockCount++;

 return(rc);
}

/* Close icon.library */
static void ReleaseIconLibrary(void)
{
 /* Decrement lock counter */
 if (--IconLockCount == 0) {

  /* Lock count is zero, close library */
  CloseLibrary(IconBase);

  /* Reset library base pointer */
  IconBase = NULL;
 }
}

/* Image class method: OM_NEW */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ImageClassNew
static ULONG ImageClassNew(Class *cl, Object *obj, struct opSet *ops)
{
 IMAGECLASS_LOG((LOG1(Tags, "0x%08lx", ops->ops_AttrList),
                 PrintTagList(ops->ops_AttrList)))

 /* Call SuperClass */
 if (obj = (Object *) DoSuperMethodA(cl, obj, (Msg) ops)) {
  struct ImageClassData *icd = TYPED_INST_DATA(cl, obj);

  /* Initialize instance data */
  icd->icd_Flags = 0;
  icd->icd_File  = NULL;

  /* Initialize bitmap cache list */
  NewList((struct List *) &icd->icd_Cache);
 }

 return((ULONG) obj);
}

/* Image class method: OM_DISPOSE */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ImageClassDispose
static ULONG ImageClassDispose(Class *cl, Object *obj, Msg msg)
{
 struct ImageClassData *icd = TYPED_INST_DATA(cl, obj);

 IMAGECLASS_LOG(LOG0(Disposing))

 /* Purge cache to clear unreferenced objects first */
 DoMethod(obj, TMM_PurgeCache);

 /* We are in delete state now */
 icd->icd_Flags |= IMAGEF_DELETING;

 /* Free IFF data */
 if (icd->icd_Flags & IFFF_FILE) FreeVector(icd->icd_File);

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, msg));
}

/* Image class method: TMM_Detach */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ImageClassDetach
static ULONG ImageClassDetach(Class *cl, Object *obj, struct TMP_Detach *tmpd)
{
 IMAGECLASS_LOG(LOG2(Arguments, "Data 0x%08lx Member 0x%08lx",
                     tmpd->tmpd_MemberData,
                     tmpd->tmpd_MemberData->tmmd_Member))

 /* Icon or BitMap? */
 if (((struct TMImageData *) tmpd->tmpd_MemberData)->tmid_Type
      == IMAGE_TYPE_BITMAP) {
  struct TMCacheData *tmcd = ((struct TMBitMapData *)
                              tmpd->tmpd_MemberData)->tmbmd_CacheEntry;

  /* Cache entry valid? */
  if (tmcd) {

   IMAGECLASS_LOG(LOG1(Decrement reference, "0%08lx", tmcd))

   /* Decrement reference count for cache entry */
   tmcd->tmcd_References--;
  }

 } else {

  IMAGECLASS_LOG(LOG0(Releasing Icon))

  /* Free Icon */
  FreeDiskObject(((struct TMImageData *) tmpd->tmpd_MemberData)
                  ->tmid_ImageData);
  ReleaseIconLibrary();
 }

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, (Msg) tmpd));
}

/* Image class method: TMM_ParseIFF */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ImageClassParseIFF
static ULONG ImageClassParseIFF(Class *cl, Object *obj,
                                struct TMP_ParseIFF *tmppi)
{
 BOOL rc = FALSE;

 IMAGECLASS_LOG(LOG1(Handle, "0x%08lx", tmppi->tmppi_IFFHandle))

 /* Initialize IFF parser and forward method to SuperClass */
 if ((PropChunks(tmppi->tmppi_IFFHandle, PropChunkTable, PROPCHUNKS) == 0) &&
     DoSuperMethodA(cl, obj, (Msg) tmppi)) {
  char *file;

  IMAGECLASS_LOG(LOG0(FORM TMIM chunk parsed OK))

  /* Check for mandatory FILE property */
  if (file = DuplicateProperty(tmppi->tmppi_IFFHandle, ID_TMIM, ID_FILE)) {
   struct ImageClassData *icd = TYPED_INST_DATA(cl, obj);

   IMAGECLASS_LOG(LOG2(File, "%s (0x%08lx)", file, file))

   /* Set instance data */
   icd->icd_Flags = IFFF_FILE;
   icd->icd_File  = file;

   /* Configuration data parsed */
   rc = TRUE;
  }
 }

 IMAGECLASS_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Image class method: TMM_ParseTags */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ImageClassParseTags
static ULONG ImageClassParseTags(Class *cl, Object *obj,
                                 struct TMP_ParseTags *tmppt)
{
 struct ImageClassData *icd    = TYPED_INST_DATA(cl, obj);
 struct TagItem        *tstate = tmppt->tmppt_Tags;
 struct TagItem        *ti;
 BOOL                   rc     = FALSE;

 IMAGECLASS_LOG((LOG1(Tags, "0x%08lx", tmppt->tmppt_Tags),
                PrintTagList(tmppt->tmppt_Tags)))

 /* Scan tag list */
 while (ti = NextTagItem(&tstate))

  /* File tag and valid data? */
  if ((ti->ti_Tag == TMOP_File) && ti->ti_Data) {

   /* Set new file */
   icd->icd_File = (char *) ti->ti_Data;

   /* All OK */
   rc = TRUE;
  }

 /* All OK? */
 if (rc) {

  /* Yes, forward method to SuperClass */
  rc = DoSuperMethodA(cl, obj, (Msg) tmppt);

  /* Purge cache after all attached objects have been notified */
  DoMethod(obj, TMM_PurgeCache);
 }

 IMAGECLASS_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Image class method: TMM_GetImage */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ImageClassGetImage
static ULONG ImageClassGetImage(Class *cl, Object *obj,
                                struct TMP_GetImage *tmpgi)
{
 ULONG rc = 0;

 IMAGECLASS_LOG(LOG2(Arguments, "Object 0x%08lx Screen 0x%08lx",
                     tmpgi->tmpgi_Object, tmpgi->tmpgi_Screen))

 /* Icon or BitMap? */
 if (tmpgi->tmpgi_Screen == NULL) {
  struct TMImageData *tmid;

  /* Load icon. Call SuperClass to allocate TMImageData */
  if (tmid = (struct TMImageData *) DoSuperMethod(cl, obj, TMM_Attach,
                                     tmpgi->tmpgi_Object,
                                     sizeof(struct TMImageData))) {

   IMAGECLASS_LOG(LOG1(TMImageData, "0x%08lx", tmid))

   /* Open icon.library */
   if (LockIconLibrary()) {

    IMAGECLASS_LOG(LOG0(Icon Library opened))

    /* Read icon */
    if (tmid->tmid_ImageData =
         GetDiskObject(TYPED_INST_DATA(cl, obj)->icd_File)) {

     IMAGECLASS_LOG(LOG1(DiskObject, "0x%08lx", tmid->tmid_ImageData))

     /* Initialize data structure */
     tmid->tmid_Type   = IMAGE_TYPE_ICON;
     tmid->tmid_Width  = ((struct DiskObject *) tmid->tmid_ImageData)
                          ->do_Gadget.Width;
     tmid->tmid_Height = ((struct DiskObject *) tmid->tmid_ImageData)
                          ->do_Gadget.Height;

     /* All OK */
     rc = (ULONG) tmid;

    } else
     ReleaseIconLibrary();
   }

   /* If we couldn't get the icon, detach the object again */
   if (rc == 0) DoSuperMethod(cl, obj, TMM_Detach, tmid);
  }

 } else {
  struct TMBitMapData *tmbmd;

  /* Load BitMap. Call SuperClass to allocate TMImageData */
  if (tmbmd = (struct TMBitMapData *) DoSuperMethod(cl, obj, TMM_Attach,
                                       tmpgi->tmpgi_Object,
                                       sizeof(struct TMBitMapData))) {
   struct ImageClassData *icd = TYPED_INST_DATA(cl, obj);

   IMAGECLASS_LOG(LOG1(TMBitMapData, "0x%08lx", tmbmd))

   /* Initialize data structure type */
   tmbmd->tmbmd_Data.tmid_Type = IMAGE_TYPE_BITMAP;

   /* Create datatypes object */
   if (tmbmd->tmbmd_CacheEntry = GetCacheEntry(icd->icd_File,
                                               tmpgi->tmpgi_Screen,
                                               &icd->icd_Cache)) {
    struct BitMapHeader *bmh;

    /* Get bitmap information */
    if (GetDTAttrs(tmbmd->tmbmd_CacheEntry->tmcd_DTObject,
                         PDTA_DestBitMap,   &tmbmd->tmbmd_Data.tmid_ImageData,
                         PDTA_BitMapHeader, &bmh,
                         TAG_DONE)) {

     IMAGECLASS_LOG(LOG3(BitMap, "0x%08lx (%ld x %ld)",
                         tmbmd->tmbmd_Data.tmid_ImageData,
                         bmh->bmh_Width, bmh->bmh_Height))

     /* Initialize data structure */
     tmbmd->tmbmd_Data.tmid_Width  = bmh->bmh_Width;
     tmbmd->tmbmd_Data.tmid_Height = bmh->bmh_Height;

     /* All OK */
     rc = (ULONG) tmbmd;
    }
   }

   /* If we couldn't get the object, detach the object again */
   if (rc == 0) DoMethod(obj, TMM_Detach, tmbmd);
  }
 }

 IMAGECLASS_LOG(LOG1(Result, "0x%08lx", rc))

 /* Return pointer to image data */
 return(rc);
}

/* Image class method: TMM_PurgeCache */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ImageClassPurgeCache
static ULONG ImageClassPurgeCache(Class *cl, Object *obj)
{
 struct TMCacheData *tmcd = (struct TMCacheData *)
                             GetHead(&TYPED_INST_DATA(cl, obj)->icd_Cache);

 IMAGECLASS_LOG(LOG0(Clearing cache))

 /* Scan cache list */
 while (tmcd) {
  struct TMCacheData *next = (struct TMCacheData *)
                              GetSucc((struct MinNode *) tmcd);

  /* Cache entry unreferenced? Remove entry from cache */
  if (tmcd->tmcd_References == 0) RemoveCacheEntry(tmcd);

  /* Next entry */
  tmcd = next;
 }

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* Image class method: TMM_ScreenClose */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ImageClassScreenClose
static ULONG ImageClassScreenClose(Class *cl, Object *obj,
                                   struct TMP_ScreenClose *tmpsc)
{
 struct TMCacheData *tmcd = (struct TMCacheData *)
                             GetHead(&TYPED_INST_DATA(cl, obj)->icd_Cache);

 IMAGECLASS_LOG(LOG1(Arguments, "Screen 0x%08lx", tmpsc->tmpsc_Screen))

 /* Scan cache list */
 while (tmcd) {
  struct TMCacheData *next = (struct TMCacheData *)
                              GetSucc((struct MinNode *) tmcd);

  /* Cache entry uses the screen? Remove entry from cache */
  if (tmcd->tmcd_Screen == tmpsc->tmpsc_Screen) RemoveCacheEntry(tmcd);

  /* Next entry */
  tmcd = next;
 }

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* Image class dispatcher */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ImageClassDispatcher
static __geta4 ULONG ImageClassDispatcher(__A0 Class *cl, __A2 Object *obj,
                                          __A1 Msg msg)
{
 ULONG rc;

 IMAGECLASS_LOG(LOG3(Arguments, "Class 0x%08lx Object 0x%08lx Msg 0x%08lx",
                     cl, obj, msg))

 switch(msg->MethodID) {
  /* BOOPSI methods */
  case OM_NEW:
   rc = ImageClassNew(cl, obj, (struct opSet *) msg);
   break;

  case OM_DISPOSE:
   rc = ImageClassDispose(cl, obj, msg);
   break;

  /* TM methods */
  case TMM_Detach:
   rc = ImageClassDetach(cl, obj, (struct TMP_Detach *) msg);
   break;

  case TMM_ParseIFF:
   rc = ImageClassParseIFF(cl, obj, (struct TMP_ParseIFF *) msg);
   break;

  case TMM_ParseTags:
   rc = ImageClassParseTags(cl, obj, (struct TMP_ParseTags *) msg);
   break;

  case TMM_GetImage:
   rc = ImageClassGetImage(cl, obj, (struct TMP_GetImage *) msg);
   break;

  case TMM_PurgeCache:
   rc = ImageClassPurgeCache(cl, obj);
   break;

  case TMM_ScreenClose:
   rc = ImageClassScreenClose(cl, obj, (struct TMP_ScreenClose *) msg);
   break;

  /* Unknown method -> delegate to SuperClass */
  default:
   rc = DoSuperMethodA(cl, obj, msg);
   break;
 }

 return(rc);
}

/* Create Image class */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CreateImageClass
Class *CreateImageClass(Class *superclass)
{
 Class *cl;

 IMAGECLASS_LOG(LOG1(SuperClass, "0x%08lx", superclass))

 /* Create class */
 if (cl = MakeClass(NULL, NULL, superclass, sizeof(struct ImageClassData), 0))

  /* Set dispatcher */
  cl->cl_Dispatcher.h_Entry = (ULONG (*)()) ImageClassDispatcher;

 IMAGECLASS_LOG(LOG1(Class, "0x%08lx", cl))

 /* Return pointer to class */
 return(cl);
}

/* Enable/Disable remapping */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION EnableRemap
void EnableRemap(BOOL enable, ULONG precision)
{
 IMAGECLASS_LOG(LOG2(Data, "Enable %ld, Precision %ld", enable, precision))

 RemapEnabled   = enable;
 RemapPrecision = precision;
}
