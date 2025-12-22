/*
 * iconobj.c  V2.1
 *
 * TMObject, Type: Icon
 *
 * (c) 1990-1993 Stefan Becker
 */

#include "ToolManagerLib.h"

/* extended TMObject structure for TMOBJTYPE_ICON objects */
struct TMObjectIcon {
                     struct TMObject     io_Object;
                     ULONG               io_Flags;
                     ULONG               io_LeftEdge;
                     ULONG               io_TopEdge;
                     struct TMLink      *io_ExecLink;
                     struct TMLinkImage *io_ImageLink;
                     struct TMLink      *io_SoundLink;
                     struct TMLink       io_Link;
                     struct DiskObject  *io_DiskObj;
                     void               *io_AppIcon;
                    };

/* io_Flags */
#define IO_ShowName (1L<<0)

/* Tag to Flag mapping table for PackBoolTags */
static struct TagItem flagmap[]={TMOP_ShowName, IO_ShowName,
                                 TAG_DONE};

/* Create an AppIcon */
static void CreateAppIcon(struct TMObjectIcon *tmobj, char *name)
{
 /* Add AppIcon to Workbench if image is supplied */
 if (tmobj->io_ImageLink && tmobj->io_ImageLink->tmli_Normal) {
  struct DiskObject *dobj;

  if (dobj=AllocMem(sizeof(struct DiskObject),MEMF_PUBLIC|MEMF_CLEAR)) {
   /* Init DiskObject structure */
   dobj->do_Version=WB_DISKVERSION;
   dobj->do_Gadget.Width=tmobj->io_ImageLink->tmli_Width;
   dobj->do_Gadget.Height=tmobj->io_ImageLink->tmli_Height;
   dobj->do_Gadget.GadgetRender=tmobj->io_ImageLink->tmli_Normal;
   if (dobj->do_Gadget.SelectRender=tmobj->io_ImageLink->tmli_Selected)
    dobj->do_Gadget.Flags=GFLG_GADGHIMAGE|GFLG_GADGIMAGE;
   else
    dobj->do_Gadget.Flags=GFLG_GADGHCOMP|GFLG_GADGIMAGE;
   dobj->do_Gadget.Activation=GACT_RELVERIFY|GACT_IMMEDIATE;
   dobj->do_Gadget.GadgetType=GTYP_BOOLGADGET;
   dobj->do_Gadget.UserData=(APTR) WB_DISKREVISION;
   dobj->do_CurrentX=tmobj->io_LeftEdge;
   dobj->do_CurrentY=tmobj->io_TopEdge;

   DEBUG_PRINTF("Normal 0x%08lx",dobj->do_Gadget.GadgetRender);
   DEBUG_PRINTF(" Selected 0x%08lx",dobj->do_Gadget.SelectRender);
   DEBUG_PRINTF(" Width %4ld",dobj->do_Gadget.Width);
   DEBUG_PRINTF(" Height %4ld",dobj->do_Gadget.Height);
   DEBUG_PRINTF(" X %4ld",dobj->do_CurrentX);
   DEBUG_PRINTF(" Y %4ld\n",dobj->do_CurrentY);

   /* ARGGGGGH "SoftError:0 Too many redos (5)" hits again :-( */
   if (tmobj->io_AppIcon=AddAppIconA((ULONG) &tmobj->io_Link,NULL,
                            (tmobj->io_Flags & IO_ShowName) ?
                            name : DefaultNoName, AppMsgPort,NULL,dobj,NULL))
    tmobj->io_DiskObj=dobj;
   else
    FreeMem(dobj,sizeof(struct DiskObject));
  }
 }
}

/* Create an Icon object */
struct TMObject *CreateTMObjectIcon(struct TMHandle *handle, char *name,
                                    struct TagItem *tags)
{
 /* Open Workbench */
 if (GetWorkbench()) {
  struct TMObjectIcon *tmobj;

  /* allocate memory for object */
  if (tmobj=(struct TMObjectIcon *)
             AllocateTMObject(sizeof(struct TMObjectIcon))) {
   struct TagItem *ti,*tstate;

   /* Scan tag list */
   tstate=tags;
   while (ti=NextTagItem(&tstate)) {

    DEBUG_PRINTF("Got Tag (0x%08lx)\n",ti->ti_Tag);

    switch (ti->ti_Tag) {
     case TMOP_Exec:    if (ti->ti_Data) {
                         if (tmobj->io_ExecLink) /* Already got a link? */
                          /* Yes, remove it! */
                          RemLinkTMObject(tmobj->io_ExecLink);

                         /* Create new link to exec object */
                         tmobj->io_ExecLink=AddLinkTMObject(handle,
                                                            (char *)
                                                             ti->ti_Data,
                                                            TMOBJTYPE_EXEC,
                                                            (struct TMObject *)
                                                             tmobj);
                        }
                        break;
     case TMOP_Image:   if (ti->ti_Data) {
                         if (tmobj->io_ImageLink) /* Already got a link? */
                          /* Yes, remove it! */
                          RemLinkTMObject((struct TMLink *)
                                          tmobj->io_ImageLink);

                         /* Create new link to exec object */
                         tmobj->io_ImageLink=(struct TMLinkImage *)
                                  AddLinkTMObject(handle, (char *) ti->ti_Data,
                                                  TMOBJTYPE_IMAGE,
                                                  (struct TMObject *) tmobj);
                        }
                        break;
     case TMOP_LeftEdge:tmobj->io_LeftEdge=ti->ti_Data;
                        break;
     case TMOP_Sound:   if (ti->ti_Data) {
                         if (tmobj->io_SoundLink) /* Already got a link? */
                          RemLinkTMObject(tmobj->io_SoundLink); /* Remove it! */

                         /* Create new link to exec object */
                         tmobj->io_SoundLink=AddLinkTMObject(handle,
                                                             (char *)
                                                              ti->ti_Data,
                                                             TMOBJTYPE_SOUND,
                                                             (struct TMObject *)
                                                              tmobj);
                        }
                        break;
     case TMOP_TopEdge: tmobj->io_TopEdge=ti->ti_Data;
                        break;
    }
   }

   /* Set flags */
   tmobj->io_Flags=PackBoolTags(IO_ShowName,tags,flagmap);

   /* Create AppIcon */
   CreateAppIcon(tmobj,name);

   /* Initialize rest of structure */
   tmobj->io_Link.tml_Linked=(struct TMObject *) tmobj;

   /* All OK */
   return(tmobj);
  }
  FreeWorkbench();
 }
 /* call failed */
 return(NULL);
}

/* Delete an Icon object */
BOOL DeleteTMObjectIcon(struct TMObjectIcon *tmobj)
{
 DEBUG_PRINTF("Delete/Icon (0x%08lx)\n",tmobj);

 /* Free resources */
 if (tmobj->io_AppIcon) {
  SafeRemoveAppIcon(tmobj->io_AppIcon,&tmobj->io_Link);
  FreeMem(tmobj->io_DiskObj,sizeof(struct DiskObject));
 }
 FreeWorkbench();

 /* Remove links */
 if (tmobj->io_ExecLink) RemLinkTMObject(tmobj->io_ExecLink);
 if (tmobj->io_ImageLink)
  RemLinkTMObject((struct TMLink *) tmobj->io_ImageLink);
 if (tmobj->io_SoundLink) RemLinkTMObject(tmobj->io_SoundLink);

 /* Remove object from list */
 Remove((struct Node *) tmobj);

 /* Free object */
 FreeMem(tmobj,sizeof(struct TMObjectIcon));

 /* All OK. */
 return(TRUE);
}

/* Change an Icon object */
struct TMObject *ChangeTMObjectIcon(struct TMHandle *handle,
                                    struct TMObjectIcon *tmobj,
                                    struct TagItem *tags)
{
 struct TagItem *ti,*tstate;
 struct TMLinkImage *oldimage=NULL;
 void *oldicon=NULL;

 /* Scan tag list */
 tstate=tags;
 while (ti=NextTagItem(&tstate)) {

  DEBUG_PRINTF("Got Tag (0x%08lx)\n",ti->ti_Tag);

  switch (ti->ti_Tag) {
   case TMOP_Exec:     if (tmobj->io_ExecLink) { /* Already got a link? */
                        /* Yes, remove it! */
                        RemLinkTMObject(tmobj->io_ExecLink);
                        tmobj->io_ExecLink=NULL;
                       }

                       if (ti->ti_Data) {
                        /* Create new link to exec object */
                        tmobj->io_ExecLink=AddLinkTMObject(handle,
                                                           (char *) ti->ti_Data,
                                                           TMOBJTYPE_EXEC,
                                                           (struct TMObject *)
                                                            tmobj);
                       }
                       break;
   case TMOP_Image:    oldimage=tmobj->io_ImageLink;
                       oldicon=tmobj->io_AppIcon;

                       if (ti->ti_Data) {
                        /* Create new link to exec object */
                        tmobj->io_ImageLink=(struct TMLinkImage *)
                                  AddLinkTMObject(handle, (char *) ti->ti_Data,
                                                  TMOBJTYPE_IMAGE,
                                                  (struct TMObject *) tmobj);
                       }
                       break;
   case TMOP_LeftEdge: tmobj->io_LeftEdge=ti->ti_Data;
                       oldicon=tmobj->io_AppIcon;
                       break;
   case TMOP_Sound:    if (tmobj->io_SoundLink) { /* Already got a link? */
                        /* Yes, remove it! */
                        RemLinkTMObject(tmobj->io_SoundLink);
                        tmobj->io_SoundLink=NULL;
                       }

                       if (ti->ti_Data) {
                        /* Create new link to exec object */
                        tmobj->io_SoundLink=AddLinkTMObject(handle,
                                                            (char *)
                                                             ti->ti_Data,
                                                            TMOBJTYPE_SOUND,
                                                            (struct TMObject *)
                                                             tmobj);
                       }
                       break;
   case TMOP_TopEdge:  tmobj->io_TopEdge=ti->ti_Data;
                       oldicon=tmobj->io_AppIcon;
                       break;
  }
 }

 /* Set new flags */
 {
  ULONG oldflags=tmobj->io_Flags;

  /* Flags changed? */
  if ((tmobj->io_Flags=PackBoolTags(oldflags,tags,flagmap)) != oldflags)
   /* Yes. Create new icon */
   oldicon=tmobj->io_AppIcon;
 }

 /* Create new icon? */
 if (oldicon) {
  /* Yes! Remove old one */
  SafeRemoveAppIcon(tmobj->io_AppIcon,&tmobj->io_Link);
  tmobj->io_AppIcon=NULL;
  FreeMem(tmobj->io_DiskObj,sizeof(struct DiskObject));
  tmobj->io_DiskObj=NULL;

  /* Remove old image link? */
  if (oldimage) RemLinkTMObject((struct TMLink *) oldimage);

  /* Create AppIcon */
  CreateAppIcon(tmobj,tmobj->io_Object.tmo_Name);
 }

 /* All OK */
 return(TRUE);
}

/* Update link structures */
void DeleteLinkTMObjectIcon(struct TMLink *tml)
{
 struct TMObjectIcon *tmobj=(struct TMObjectIcon *) tml->tml_LinkedTo;

 /* Clear link */
 if (tml==tmobj->io_ExecLink)
  tmobj->io_ExecLink=NULL;
 else if (tml==(struct TMLink *) tmobj->io_ImageLink) {
  if (tmobj->io_AppIcon) {
   SafeRemoveAppIcon(tmobj->io_AppIcon,&tmobj->io_Link);
   tmobj->io_AppIcon=NULL;
  }
  if (tmobj->io_DiskObj) {
   FreeMem(tmobj->io_DiskObj,sizeof(struct DiskObject));
   tmobj->io_DiskObj=NULL;
  }
  tmobj->io_ImageLink=NULL;
 }
 else if (tml==tmobj->io_SoundLink)
  tmobj->io_SoundLink=NULL;
}

/* Activate an Icon object */
void ActivateTMObjectIcon(struct TMLink *tml, struct AppMessage *msg)
{
 struct TMObjectIcon *tmobj=(struct TMObjectIcon *) tml->tml_Linked;

 /* Activate Sound object */
 if (tmobj->io_SoundLink) CallActivateTMObject(tmobj->io_SoundLink,NULL);

 /* Activate Exec object */
 if (tmobj->io_ExecLink) CallActivateTMObject(tmobj->io_ExecLink,msg);
}

