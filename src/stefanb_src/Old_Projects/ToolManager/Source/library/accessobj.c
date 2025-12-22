/*
 * accessobj.c  V2.1
 *
 * TMObject, Type: Access
 *
 * (c) 1990-1993 Stefan Becker
 */

#include "ToolManagerLib.h"

/* Node for one Exec object */
struct AccessEntry {
                    struct AccessEntry *ae_Next;
                    char               *ae_ExecName;
                    struct TMLink      *ae_ExecLink;
                   };

/* extended TMObject structure for TMOBJTYPE_MENU objects */
struct TMObjectAccess {
                       struct TMObject     ac_Object;
                       struct AccessEntry *ac_Entries;
                      };

/* Create an Access object */
struct TMObject *CreateTMObjectAccess(struct TMHandle *handle, char *name,
                                      struct TagItem *tags)
{
 /* Network installed? */
 if (LocalEntity) {
  struct TMObjectAccess *tmobj;

  /* allocate memory for object */
  if (tmobj=(struct TMObjectAccess *)
             AllocateTMObject(sizeof(struct TMObjectAccess))) {
   struct TagItem *ti,*tstate;
   struct AccessEntry *ae=NULL;

   /* Scan tag list */
   tstate=tags;
   while (ti=NextTagItem(&tstate)) {

    DEBUG_PRINTF("Got Tag (0x%08lx)\n",ti->ti_Tag);

    switch (ti->ti_Tag) {
     case TMOP_Exec: if (ti->ti_Data) {
                      struct AccessEntry *newae;

                      /* Alloc AccessEntry structure */
                      if (newae=AllocMem(sizeof(struct AccessEntry),
                                         MEMF_CLEAR)) {
                       /* Set name */
                       newae->ae_ExecName=(char *) ti->ti_Data;

                       /* Add link to Exec object */
                       newae->ae_ExecLink=AddLinkTMObject(handle,
                                                          (char *) ti->ti_Data,
                                                          TMOBJTYPE_EXEC,
                                                          (struct TMObject *)
                                                           tmobj);

                       DEBUG_PRINTF("ExecLink: 0x%08lx\n",newae->ae_ExecLink);

                       /* Add node to list. Head of list? */
                       if (ae) {
                        /* No. Add to tail */
                        ae->ae_Next=newae;
                        ae=newae;
                       } else {
                        /* Yes. Init list anchor */
                        tmobj->ac_Entries=newae;
                        ae=newae;
                       }
                      }
                     }
                     break;
    }
   }

   /* All OK */
   return(tmobj);
  }
 }
 /* call failed */
 return(NULL);
}

/* Delete an Access object */
BOOL DeleteTMObjectAccess(struct TMObjectAccess *tmobj)
{
 struct AccessEntry *ae,*nextae=tmobj->ac_Entries;

 DEBUG_PRINTF("Delete/Access (0x%08lx)\n",tmobj);

 /* Remove entries */
 while (ae=nextae) {
  /* Get pointer to next entry */
  nextae=ae->ae_Next;

  /* Remove link */
  if (ae->ae_ExecLink) RemLinkTMObject(ae->ae_ExecLink);

  /* Free entry */
  FreeMem(ae,sizeof(struct AccessEntry));
 }

 /* Remove object from list */
 Remove((struct Node *) tmobj);

 /* Free object */
 FreeMem(tmobj,sizeof(struct TMObjectAccess));

 /* All OK. */
 return(TRUE);
}

/* Change an Access object */
struct TMObject *ChangeTMObjectAccess(struct TMHandle *handle,
                                      struct TMObjectAccess *tmobj,
                                      struct TagItem *tags)
{
 struct TagItem *ti,*tstate;
 struct AccessEntry *ae=tmobj->ac_Entries;

 /* Search last AccessEntry */
 if (ae)
  while (ae->ae_Next) ae=ae->ae_Next;

 /* Scan tag list */
 tstate=tags;
 while (ti=NextTagItem(&tstate)) {

  DEBUG_PRINTF("Got Tag (0x%08lx)\n",ti->ti_Tag);

  switch (ti->ti_Tag) {
   case TMOP_Exec: if (ti->ti_Data) {
                    struct AccessEntry *newae;

                    /* Alloc AccessEntry structure */
                    if (newae=AllocMem(sizeof(struct AccessEntry),
                                       MEMF_CLEAR)) {
                     /* Set name */
                     newae->ae_ExecName=(char *) ti->ti_Data;

                     /* Add link to Exec object */
                     newae->ae_ExecLink=AddLinkTMObject(handle,
                                                        (char *) ti->ti_Data,
                                                        TMOBJTYPE_EXEC,
                                                        (struct TMObject *)
                                                         tmobj);

                     /* Add node to list. Head of list? */
                     if (ae) {
                      /* No. Add to tail */
                      ae->ae_Next=newae;
                      ae=newae;
                     } else {
                      /* Yes. Init list anchor */
                      tmobj->ac_Entries=newae;
                      ae=newae;
                     }
                    }
                   }
                   break;
  }
 }

 /* All OK. */
 return(TRUE);
}

/* Allocate & Initialize a TMLink structure */
struct TMLink *AllocLinkTMObjectAccess(struct TMObjectAccess *tmobj)
{
 struct TMLink *tml;

 /* Allocate memory for link structure */
 if (tml=AllocMem(sizeof(struct TMLink),MEMF_CLEAR|MEMF_PUBLIC))
  /* Initialize link structure */
  tml->tml_Size=sizeof(struct TMLink);

 return(tml);
}

/* Update link structures */
void DeleteLinkTMObjectAccess(struct TMLink *tml)
{
 struct TMObjectAccess *tmobj=(struct TMObjectAccess *) tml->tml_LinkedTo;
 struct AccessEntry *ae=tmobj->ac_Entries;

 /* Scan tool list */
 while (ae) {
  /* Link to Exec object? */
  if (tml==ae->ae_ExecLink) {
   ae->ae_ExecLink=NULL;
   break;
  }

  /* Get pointer to next tool */
  ae=ae->ae_Next;
 }
}

/* Activate an Access object */
void ActivateTMObjectAccess(struct TMLink *tml, char *execname)
{
 struct TMObjectAccess *tmobj=(struct TMObjectAccess *) tml->tml_Linked;
 struct AccessEntry *ae;

 DEBUG_PRINTF("Activate/Access '%s'\n",execname);

 /* Access check disabled? */
 if (ae=tmobj->ac_Entries)

  /* No, search Exec object in access list */
  while (ae) {
   /* Exec object found? */
   if (!strcmp(execname,ae->ae_ExecName)) {
    /* Yes! If link is valid, activate object */
    if (ae->ae_ExecLink) CallActivateTMObject(ae->ae_ExecLink,NULL);

    /* Leave loop */
    break;
   }

   /* Get pointer to next node */
   ae=ae->ae_Next;
  }
 else {
  /* Yes, free access granted */
  struct TMLink *tmle;

  DEBUG_PRINTF("Free access!\n");

  /* Search Exec object (only global Exec objects can be activated!) */
  if (tmle=AddLinkTMObject(PrivateTMHandle,execname,TMOBJTYPE_EXEC,NULL)) {

   DEBUG_PRINTF("Link: 0x%08lx\n",tmle);

   /* Activate Exec object */
   CallActivateTMObject(tmle,NULL);

   /* Remove link */
   RemLinkTMObject(tmle);
  }
 }
}
