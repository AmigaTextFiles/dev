/*
 * menuobj.c  V2.1
 *
 * TMObject, Type: Menu
 *
 * (c) 1990-1993 Stefan Becker
 */

#include "ToolManagerLib.h"

/* extended TMObject structure for TMOBJTYPE_MENU objects */
struct TMObjectMenu {
                     struct TMObject  mo_Object;
                     struct TMLink   *mo_ExecLink;
                     struct TMLink   *mo_SoundLink;
                     struct TMLink    mo_Link;
                     void            *mo_AppMenu;
                    };

/* Create a Menu object */
struct TMObject *CreateTMObjectMenu(struct TMHandle *handle, char *name,
                                    struct TagItem *tags)
{
 /* Open Workbench */
 if (GetWorkbench()) {
  struct TMObjectMenu *tmobj;

  /* allocate memory for object */
  if (tmobj=(struct TMObjectMenu *)
             AllocateTMObject(sizeof(struct TMObjectMenu))) {
   struct TagItem *ti,*tstate;

   /* Scan tag list */
   tstate=tags;
   while (ti=NextTagItem(&tstate)) {

    DEBUG_PRINTF("Got Tag (0x%08lx)\n",ti->ti_Tag);

    switch (ti->ti_Tag) {
     case TMOP_Exec:  if (ti->ti_Data) {
                       if (tmobj->mo_ExecLink) /* Already got a link? */
                        /* Yep. Remove it! */
                        RemLinkTMObject(tmobj->mo_ExecLink);

                       /* Create new link to exec object */
                       tmobj->mo_ExecLink=AddLinkTMObject(handle,
                                                          (char *) ti->ti_Data,
                                                          TMOBJTYPE_EXEC,
                                                          (struct TMObject *)
                                                           tmobj);
                      }
                      break;
     case TMOP_Sound: if (ti->ti_Data) {
                       if (tmobj->mo_SoundLink) /* Already got a link? */
                       RemLinkTMObject(tmobj->mo_SoundLink); /* Remove it! */

                      /* Create new link to exec object */
                      tmobj->mo_SoundLink=AddLinkTMObject(handle,
                                                          (char *) ti->ti_Data,
                                                          TMOBJTYPE_SOUND,
                                                          (struct TMObject *)
                                                           tmobj);
                      }
                      break;
    }
   }

   /* Add menu entry */
   if (tmobj->mo_AppMenu=AddAppMenuItemA((ULONG) &tmobj->mo_Link,NULL,name,
                                         AppMsgPort,NULL)) {
    /* Initialize rest of structure */
    tmobj->mo_Link.tml_Linked=(struct TMObject *) tmobj;

    /* All OK */
    return(tmobj);
   }
   else {
    /* Remove links */
    if (tmobj->mo_ExecLink) RemLinkTMObject(tmobj->mo_ExecLink);
    if (tmobj->mo_SoundLink) RemLinkTMObject(tmobj->mo_SoundLink);
   }
   FreeMem(tmobj,sizeof(struct TMObjectMenu));
  }
  FreeWorkbench();
 }
 /* call failed */
 return(NULL);
}

/* Delete a Menu object */
BOOL DeleteTMObjectMenu(struct TMObjectMenu *tmobj)
{
 DEBUG_PRINTF("Delete/Menu (0x%08lx)\n",tmobj);

 /* Free resources */
 SafeRemoveAppMenuItem(tmobj->mo_AppMenu,&tmobj->mo_Link);
 FreeWorkbench();

 /* Remove links */
 if (tmobj->mo_ExecLink) RemLinkTMObject(tmobj->mo_ExecLink);
 if (tmobj->mo_SoundLink) RemLinkTMObject(tmobj->mo_SoundLink);

 /* Remove object from list */
 Remove((struct Node *) tmobj);

 /* Free object */
 FreeMem(tmobj,sizeof(struct TMObjectMenu));

 /* All OK. */
 return(TRUE);
}

/* Change a Menu object */
struct TMObject *ChangeTMObjectMenu(struct TMHandle *handle,
                                    struct TMObjectMenu *tmobj,
                                    struct TagItem *tags)
{
 struct TagItem *ti,*tstate;

 /* Scan tag list */
 tstate=tags;
 while (ti=NextTagItem(&tstate)) {

  DEBUG_PRINTF("Got Tag (0x%08lx)\n",ti->ti_Tag);

  switch (ti->ti_Tag) {
   case TMOP_Exec:  if (tmobj->mo_ExecLink) { /* Already got a link? */
                     /* Yep. Remove it! */
                     RemLinkTMObject(tmobj->mo_ExecLink);
                     tmobj->mo_ExecLink=NULL;
                    }

                    if (ti->ti_Data) {
                     /* Create new link to exec object */
                     tmobj->mo_ExecLink=AddLinkTMObject(handle,
                                                        (char *) ti->ti_Data,
                                                        TMOBJTYPE_EXEC,
                                                        (struct TMObject *)
                                                         tmobj);
                    }
                    break;
   case TMOP_Sound: if (tmobj->mo_SoundLink) { /* Already got a link? */
                     /* Yep. Remove it! */
                     RemLinkTMObject(tmobj->mo_SoundLink);
                     tmobj->mo_SoundLink=NULL;
                    }

                    if (ti->ti_Data) {
                     /* Create new link to exec object */
                     tmobj->mo_SoundLink=AddLinkTMObject(handle,
                                                         (char *) ti->ti_Data,
                                                         TMOBJTYPE_SOUND,
                                                         (struct TMObject *)
                                                          tmobj);
                    }
                    break;
  }
 }

 /* All OK. */
 return(TRUE);
}

/* Update link structures */
void DeleteLinkTMObjectMenu(struct TMLink *tml)
{
 struct TMObjectMenu *tmobj=(struct TMObjectMenu *) tml->tml_LinkedTo;

 /* Clear link */
 if (tml==tmobj->mo_ExecLink)
  tmobj->mo_ExecLink=NULL;
 else if (tml==tmobj->mo_SoundLink)
  tmobj->mo_SoundLink=NULL;
}

/* Activate a Menu object */
void ActivateTMObjectMenu(struct TMLink *tml, struct AppMessage *msg)
{
 struct TMObjectMenu *tmobj=(struct TMObjectMenu *) tml->tml_Linked;

 /* Activate Sound object */
 if (tmobj->mo_SoundLink) CallActivateTMObject(tmobj->mo_SoundLink,NULL);

 /* Activate Exec object */
 if (tmobj->mo_ExecLink) CallActivateTMObject(tmobj->mo_ExecLink,msg);
}
