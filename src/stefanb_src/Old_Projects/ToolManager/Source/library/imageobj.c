/*
 * imageobj.c  V2.1
 *
 * TMObject, Type: Image
 *
 * (c) 1990-1993 Stefan Becker
 */

#include "ToolManagerLib.h"

/* extended TMTimerReq structure */
struct TMTimerReqImage {
                        struct TMTimerReq   tmtri_TimerReq;
                        struct Image        tmtri_Image;
                        struct TMImageNode *tmtri_NextImage;
                       };

/* extended TMObject structure for TMOBJTYPE_Image objects */
struct TMObjectImage {
                      struct TMObject     io_Object;
                      ULONG               io_Flags;
                      char               *io_File;
                      struct TMImageData *io_Data;
                      UWORD               io_XSize;
                      UWORD               io_YSize;
                      struct Image       *io_Normal;
                      struct Image       *io_Selected;
                     };

/* io_Flags */
#define IO_FreeData (1L<<0)
#define IO_DiskObj  (1L<<1)

/* Data */
static ULONG IconCount=0;
struct Library *IconBase=NULL;

/* Try to open icon.library */
static BOOL GetIconLibrary(void)
{
 /* Library already open or can we open it? */
 if (IconBase || (IconBase=OpenLibrary("icon.library",37)))
  {
   /* Increment Icon counter */
   IconCount++;

   /* All OK */
   return(TRUE);
  }

 /* Call failed */
 return(FALSE);
}

/* Try to close icon.library */
static void FreeIconLibrary(void)
{
 /* Decrement Icon counter and close icon.library if zero */
 if (--IconCount==0) {
  CloseLibrary(IconBase);
  IconBase=NULL;
 }
}

/* Create an Image object */
struct TMObject *CreateTMObjectImage(struct TMHandle *handle, char *name,
                                     struct TagItem *tags)
{
 struct TMObjectImage *tmobj;

 /* allocate memory for object */
 if (tmobj=(struct TMObjectImage *)
            AllocateTMObject(sizeof(struct TMObjectImage))) {
  struct TagItem *ti,*tstate;

  /* Scan tag list */
  tstate=tags;
  while (ti=NextTagItem(&tstate)) {

   DEBUG_PRINTF("Got Tag (0x%08lx)\n",ti->ti_Tag);

   switch (ti->ti_Tag) {
    case TMOP_File: tmobj->io_File=(char *) ti->ti_Data;
                    break;
    case TMOP_Data: tmobj->io_Data=(struct TMImageData *) ti->ti_Data;
                    break;
   }
  }

  /* Sanity check */
  if (!tmobj->io_File && !tmobj->io_Data) tmobj->io_File=DefaultNoName;

  /* File name supplied? */
  if (tmobj->io_File) {
   /* Yes. Read image data from it */
   BPTR fl;

   /* Ignore user supplied data */
   tmobj->io_Data=NULL;

   /* Try to open as IFF file first */
   if (fl=Lock(tmobj->io_File,ACCESS_READ)) {
    /* Got it. */
    UnLock(fl);

    /* Read IFF file */
    if (tmobj->io_Data=ReadIFFData(tmobj->io_File)) {
     /* Got an IFF ILBM/ANIM */
     struct Image *img=&tmobj->io_Data->tmid_Normal;

     tmobj->io_XSize=img->Width;
     tmobj->io_YSize=img->Height+1;
     tmobj->io_Normal=img;

     /* Get selected image */
     img=&tmobj->io_Data->tmid_Selected;
     if (img->ImageData)
      tmobj->io_Selected=img;
    }
   }

   /* Got IFF data? No --> Open icon file */
   if (!(tmobj->io_Data) && GetIconLibrary())
    if (tmobj->io_Data=(struct TMImageData *) GetDiskObject(tmobj->io_File)) {
     /* Got an icon */
     struct Image *img=((struct DiskObject *) tmobj->io_Data)
                        ->do_Gadget.GadgetRender;

     tmobj->io_Flags|=IO_DiskObj;
     tmobj->io_XSize=img->Width;
     tmobj->io_YSize=img->Height+1;
     tmobj->io_Normal=img;
     tmobj->io_Selected=((struct DiskObject *) tmobj->io_Data)
                         ->do_Gadget.SelectRender;
    }
    else
     FreeIconLibrary();

   /* All OK? */
   if (tmobj->io_Data) {
    tmobj->io_Flags|=IO_FreeData; /* Set free resources flag */
    return(tmobj);
   }
  }
  else {
   /* No. User supplied image data directly */
   struct Image *img=&tmobj->io_Data->tmid_Normal;

   tmobj->io_XSize=img->Width;
   tmobj->io_YSize=img->Height+1;
   tmobj->io_Normal=img;

   /* Get selected image */
   img=&tmobj->io_Data->tmid_Selected;
   if (img->ImageData)
    tmobj->io_Selected=img;

   /* All OK */
   return(tmobj);
  }
  FreeMem(tmobj,sizeof(struct TMObjectImage));
 }

 /* call failed */
 return(NULL);
}

/* Delete an Image object */
BOOL DeleteTMObjectImage(struct TMObjectImage *tmobj)
{
 DEBUG_PRINTF("Delete/Image (0x%08lx)\n",tmobj);

 /* Remove links */
 DeleteAllLinksTMObject((struct TMObject *) tmobj);

 /* Remove object from list */
 Remove((struct Node *) tmobj);

 /* Free resources? */
 if (tmobj->io_Flags&IO_FreeData)
  /* Yes, Icon file? */
  if (tmobj->io_Flags&IO_DiskObj) {
   /* Yes, release data */
   FreeDiskObject((struct DiskObject *) tmobj->io_Data);
   FreeIconLibrary();
  }
  else
   /* No, IFF data -> release it */
   FreeIFFData(tmobj->io_Data);

 /* Free object */
 FreeMem(tmobj,sizeof(struct TMObjectImage));

 /* All OK. */
 return(TRUE);
}

/* Allocate & Initialize a TMLinkImage structure */
struct TMLink *AllocLinkTMObjectImage(struct TMObjectImage *tmobj)
{
 struct TMLinkImage *tml;

 /* Allocate memory for link structure */
 if (tml=AllocMem(sizeof(struct TMLinkImage),MEMF_CLEAR|MEMF_PUBLIC)) {
  /* Initialize link structure */
  tml->tmli_Link.tml_Size=sizeof(struct TMLinkImage);
  tml->tmli_Width=tmobj->io_XSize;
  tml->tmli_Height=tmobj->io_YSize;
  tml->tmli_Normal=tmobj->io_Normal;
  tml->tmli_Selected=tmobj->io_Selected;
 }

 return(tml);
}

/* Send timer request */
static void SendTimerRequest(struct TMTimerReqImage *tmtri, BOOL last)
{
 struct timerequest *tr=&tmtri->tmtri_TimerReq.tmtr_Request;

 /* Initialize timer request */
 tr->tr_node.io_Command=TR_ADDREQUEST;
 tr->tr_time.tv_secs=last ? 1 : 0;
 tr->tr_time.tv_micro=last ? 0 : 33333;

 /* Send timer request */
 SendIO((struct IORequest *) tr);
}

/* Abort timer request */
static void AbortTimerRequest(struct TMTimerReqImage *tmtri)
{
 /* I/O request still active? */
 if (!CheckIO((struct IORequest *) tmtri))
  /* Yes. Abort it */
  AbortIO((struct IORequest *) tmtri);

 /* Remove request from port */
 WaitIO((struct IORequest *) tmtri);
}

/* Activate an Image object */
void ActivateTMObjectImage(struct TMLinkImage *tmli, void *start)
{
 struct TMObjectImage *tmobj=(struct TMObjectImage *)
                              tmli->tmli_Link.tml_Linked;
 UWORD x=tmli->tmli_LeftEdge;
 UWORD y=tmli->tmli_TopEdge;

 DEBUG_PRINTF("Activate/Image (%ld)\n",start);

 /* Start animation? */
 switch ((ULONG) start) {
  case NULL:         {
                      struct TMTimerReqImage *tmtri=tmli->tmli_Link.tml_Active;
                      struct TMImageNode *tmin=tmtri->tmtri_NextImage;

                      /* Remove timer request */
                      WaitIO((struct IORequest *) tmtri);

                      /* Draw next picture? */
                      if (tmin) {
                       /* Yes. Draw next picture */
                       struct Image *img=&tmtri->tmtri_Image;

                       /* Set image pointer */
                       img->ImageData=tmin->tmin_Data;

                       /* Draw picture */
                       DrawImage(tmli->tmli_RastPort,img,x,y);

                       /* Set next picture */
                       tmtri->tmtri_NextImage=tmin->tmin_Next;

                       /* Activate timer */
                       SendTimerRequest(tmtri,tmtri->tmtri_NextImage==NULL);
                      } else {
                       /* No. Draw normal picture */
                       DrawImage(tmli->tmli_RastPort,tmli->tmli_Normal,x,y);

                       /* Free timer request */
                       FreeMem(tmtri,sizeof(struct TMTimerReqImage));
                       tmli->tmli_Link.tml_Active=NULL;
                      }
                     }
                     break;
  case IOC_DEACTIVE: {
                      struct TMTimerReqImage *tmtri=tmli->tmli_Link.tml_Active;

                      /* Anim active? */
                      if (tmtri) {
                       /* Yes. Stop it! Abort timer request */
                       AbortTimerRequest(tmtri);

                       /* Free timer request */
                       FreeMem(tmtri,sizeof(struct TMTimerReqImage));
                       tmli->tmli_Link.tml_Active=NULL;
                      }

                      /* Draw inactive image */
                      DrawImage(tmli->tmli_RastPort,tmli->tmli_Normal,x,y);
                     }
                     break;
  case IOC_ACTIVE:   {
                      struct TMTimerReqImage *tmtri=tmli->tmli_Link.tml_Active;
                      struct RastPort *rp=tmli->tmli_RastPort;

                      /* Anim active? */
                      if (tmtri) {
                       /* Yes. Stop it! Abort timer request */
                       AbortTimerRequest(tmtri);

                       /* Draw inactive state */
                       DrawImage(rp,tmli->tmli_Normal,x,y);

                       /* Free timer request */
                       FreeMem(tmtri,sizeof(struct TMTimerReqImage));
                       tmli->tmli_Link.tml_Active=NULL;
                      }

                      /* Draw selected state. Got a selected image? */
                      if (tmobj->io_Selected)
                       /* Yes, draw it */
                       DrawImage(rp,tmobj->io_Selected,x,y);
                      else {
                       /* No, invert image */
                       SetDrMd(rp,COMPLEMENT);
                       SetAPen(rp,0xff);
                       RectFill(rp,x,y,x+tmobj->io_XSize-1,y+tmobj->io_YSize-2);
                      }
                     }
                     break;
  case IOC_FULLANIM: {
                      struct TMTimerReqImage *tmtri=tmli->tmli_Link.tml_Active;
                      struct RastPort *rp=tmli->tmli_RastPort;

                      /* Anim active? */
                      if (tmtri) {
                       /* Yes. Stop it! Abort timer request */
                       AbortTimerRequest(tmtri);

                       /* Draw inactive state */
                       DrawImage(rp,tmli->tmli_Normal,x,y);

                       /* Free timer request */
                       FreeMem(tmtri,sizeof(struct TMTimerReqImage));
                       tmli->tmli_Link.tml_Active=NULL;
                      }

                      /* Start animation after 1st image. Get memory. */
                      if (tmtri=AllocMem(sizeof(struct TMTimerReqImage),
                                         MEMF_PUBLIC)) {
                       /* Got it */
                       struct Image *img=tmobj->io_Selected;

                       /* Init timer request */
                       tmtri->tmtri_TimerReq.tmtr_Request=*deftimereq;
                       tmtri->tmtri_Image=*(tmli->tmli_Normal);
                       tmtri->tmtri_TimerReq.tmtr_Link=(struct TMLink *) tmli;

                       /* No icon file and more than one picture? */
                       if (!(tmobj->io_Flags & IO_DiskObj) && img)
                        /* Yes. Set anim starting image */
                        tmtri->tmtri_NextImage=tmobj->io_Data->tmid_Data->
                                                tmin_Next->tmin_Next;
                       else
                        /* Only one picture animation */
                        tmtri->tmtri_NextImage=NULL;

                       /* Got a second picture? */
                       if (img)
                        /* Yes, draw it */
                        DrawImage(rp,img,x,y);
                       else {
                        /* No, invert image */
                        SetDrMd(rp,COMPLEMENT);
                        SetAPen(rp,0xff);
                        RectFill(rp,x,y,x+tmobj->io_XSize-1,
                                 y+tmobj->io_YSize-2);
                       }

                       /* Send timer request */
                       SendTimerRequest(tmtri,FALSE);

                       /* Set active flag */
                       tmli->tmli_Link.tml_Active=tmtri;
                      }
                     }
                     break;
  case IOC_CONTANIM: {
                      struct TMTimerReqImage *tmtri=tmli->tmli_Link.tml_Active;

                      /* Anim active? */
                      if (tmtri) {
                       /* Yes. Stop it! Abort timer request */
                       AbortTimerRequest(tmtri);

                       /* Free timer request */
                       FreeMem(tmtri,sizeof(struct TMTimerReqImage));
                       tmli->tmli_Link.tml_Active=NULL;
                      }

                      /* Start animation after 2nd image */
                      /* Icon file or only one picture? */
                      if ((tmobj->io_Flags & IO_DiskObj) ||
                          !tmobj->io_Selected)
                       /* Yes. Draw normal state */
                       DrawImage(tmli->tmli_RastPort,tmli->tmli_Normal,x,y);
                      else {
                       struct TMImageNode *tmin=tmobj->io_Data->tmid_Data->
                                                 tmin_Next->tmin_Next;

                       /* Got more than 2 images and can we allocate memory */
                       /* for timer request? */
                       if (tmin && (tmtri=AllocMem(
                                           sizeof(struct TMTimerReqImage),
                                           MEMF_PUBLIC))) {
                        /* Yes, start anim. Init timer request */
                        tmtri->tmtri_TimerReq.tmtr_Request=*deftimereq;
                        tmtri->tmtri_Image=*(tmli->tmli_Normal);
                        tmtri->tmtri_TimerReq.tmtr_Link=(struct TMLink *) tmli;
                        tmtri->tmtri_NextImage=tmin;

                        /* Send timer request */
                        SendTimerRequest(tmtri,FALSE);

                        /* Set active flag */
                        tmli->tmli_Link.tml_Active=tmtri;
                       } else
                        /* No. Draw normal state */
                        DrawImage(tmli->tmli_RastPort,tmli->tmli_Normal,x,y);
                      }
                     }
                     break;
 }
}
