/*
 * entries.c  V3.1
 *
 * TM dock entries handling routines
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

/* Read dock entries from configuration file */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ReadDockEntries
void ReadDockEntries(struct IFFHandle *iffh, struct MinList *list,
                     Object *obj, Object **lists)
{
 struct CollectionItem *ci;

 /* Any entries found? */
 if (ci = FindCollection(iffh, ID_TMDO, ID_ENTR)) {
  struct DockEntry *de;

  ENTRIES_LOG(LOG1(Collection, "0x%08lx", ci))

  /* Scan collection item list */
  while (ci) {

   ENTRIES_LOG(LOG1(Next, "0x%08lx", ci))

   /* Allocate memory for next entry */
   if (de = GetMemory(sizeof(struct DockEntry))) {
    struct DockEntryChunk *dec = (struct DockEntryChunk *) ci->ci_Data;

    /* Attach objects */
    de->de_Exec  = AttachObject(lists[TMOBJTYPE_EXEC],  obj,
                                dec->dec_ExecObject);
    de->de_Image = AttachObject(lists[TMOBJTYPE_IMAGE], obj,
                                dec->dec_ImageObject);
    de->de_Sound = AttachObject(lists[TMOBJTYPE_SOUND], obj,
                                dec->dec_SoundObject);

    /* Insert entry at the head of the list */
    AddHead((struct List *) list, (struct Node *) de);

   } else

    /* No memory, leave loop */
    break;

   /* Next collection item */
   ci = ci->ci_Next;
  }
 }
}

/* Write dock entries to configuration file */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION WriteDockEntries
BOOL WriteDockEntries(struct IFFHandle *iffh, struct MinList *list)
{
 struct DockEntry      *de  = (struct DockEntry *) GetHead(list);
 BOOL                   rc  = TRUE;
 struct DockEntryChunk  dec;

 /* For each entry in the list */
 while (de) {

  /* Use object addresses as IDs */
  dec.dec_ExecObject  = (ULONG) (de->de_Exec  ? de->de_Exec->ad_Object  :
                                 NULL);
  dec.dec_ImageObject = (ULONG) (de->de_Image ? de->de_Image->ad_Object :
                                 NULL);
  dec.dec_SoundObject = (ULONG) (de->de_Sound ? de->de_Sound->ad_Object :
                                 NULL);

  /* Write entry */
  if ((rc = WriteProperty(iffh, ID_ENTR, &dec, sizeof(struct DockEntryChunk)))
       == FALSE)

   /* Error, leave loop */
   break;

  /* Next entry */
  de = (struct DockEntry *) GetSucc((struct MinNode *) de);
 }

 ENTRIES_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Free one dock entry */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION FreeDockEntry
void FreeDockEntry(struct DockEntry *de)
{
 ENTRIES_LOG(LOG1(Entry, "0x%08lx", de))

 /* Detach objects */
 if (de->de_Exec)  DoMethod(de->de_Exec->ad_Object,  TMM_Detach, de->de_Exec);
 if (de->de_Image) DoMethod(de->de_Image->ad_Object, TMM_Detach, de->de_Image);
 if (de->de_Sound) DoMethod(de->de_Sound->ad_Object, TMM_Detach, de->de_Sound);

 /* Free entry */
 FreeMemory(de, sizeof(struct DockEntry));
}

/* Free a list of dock entries */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION FreeDockEntries
void FreeDockEntries(struct MinList *list)
{
 struct DockEntry *de;

 /* For each entry in the list */
 while (de = (struct DockEntry *) RemTail((struct List *) list)) {

  ENTRIES_LOG(LOG1(Next entry, "0x%08lx", de))

  /* Free entry */
  FreeDockEntry(de);
 }

 ENTRIES_LOG(LOG0(Exit))
}

/* Copy one dock entries */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CopyDockEntry
struct DockEntry *CopyDockEntry(struct DockEntry *de, Object *obj)
{
 struct DockEntry *rc;

 ENTRIES_LOG(LOG1(Entry, "0x%08lx", de))

 /* Allocate memory for new entry */
 if (rc = GetMemory(sizeof(struct DockEntry))) {

  ENTRIES_LOG(LOG1(New entry, "0x%08lx", rc))

  /* Initialize entry */
  rc->de_Exec  = NULL;
  rc->de_Image = NULL;
  rc->de_Sound = NULL;

  /* Attach objects */
  if (((de->de_Exec  != NULL) &&
       ((rc->de_Exec  = (struct AttachData *)
                         DoMethod(de->de_Exec->ad_Object,   TMM_Attach, obj))
         == NULL)) ||
      ((de->de_Image != NULL) &&
       ((rc->de_Image = (struct AttachData *)
                         DoMethod(de->de_Image->ad_Object,  TMM_Attach, obj))
         == NULL)) ||
      ((de->de_Sound != NULL) &&
       ((rc->de_Sound = (struct AttachData *)
                         DoMethod(de->de_Sound->ad_Object,  TMM_Attach, obj))
         == NULL))) {

   /* Could not attach objects */
   ENTRIES_LOG(LOG0(Could not duplicate entry))

   /* Delete new entry */
   FreeDockEntry(rc);

   /* Clear pointer */
   rc = NULL;
  }
 }

 ENTRIES_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}

/* Clear one attached object from a list of dock entries */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION RemoveDockEntryAttach
BOOL RemoveDockEntryAttach(struct DockEntry *de, struct AttachData *ad)
{
 BOOL rc = TRUE;

 ENTRIES_LOG(LOG2(Arguments, "Entry 0x%08lx Attach 0x%08lx", de, ad))

 /* Object found? Yes, clear pointer and leave loop */
 if      (ad == de->de_Exec)  de->de_Exec  = NULL;
 else if (ad == de->de_Image) de->de_Image = NULL;
 else if (ad == de->de_Sound) de->de_Sound = NULL;
 else                         rc           = FALSE;

 ENTRIES_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}
