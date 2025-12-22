/*
 * dockobj.c  V2.1.01
 *
 * TMObject, Type: Dock
 *
 * (c) 1990-1995 Stefan Becker
 */

#include "ToolManagerLib.h"

/* node for one tool */
struct DockTool {
                 struct DockTool    *dt_Next;
                 char               *dt_ExecName;
                 struct TMLink      *dt_ExecLink;
                 struct TMLinkImage *dt_ImageLink;
                 struct TMLink      *dt_SoundLink;
                };

/* extended TMObject structure for TMOBJTYPE_Dock objects */
struct TMObjectDock {
                     struct TMObject  do_Object;
                     ULONG            do_Flags;
                     ULONG            do_Columns;
                     struct TextAttr *do_Font;   /* User supplied font */
                     char            *do_HotKey;
                     ULONG            do_LeftEdge;
                     char            *do_PubScreen;
                     char            *do_Title;
                     struct DockTool *do_Tools;
                     ULONG            do_TopEdge;
                     CxObj           *do_CxObj;
                     struct TMLink    do_Link;
                     UWORD            do_Left;   /* Drawing start position */
                     UWORD            do_Top;
                     UWORD            do_Width;  /* Inner Window Width/Height */
                     UWORD            do_Height;
                     UWORD            do_XSize;  /* Image/Gadget box size */
                     UWORD            do_YSize;
                     struct Window   *do_Window;
                     void            *do_AppWindow;
                     struct Gadget    do_DragGadget;
                     UWORD            do_FillPen;
                     UWORD            do_BackPen;
                     struct TextAttr  do_TextAttr;   /* Font for gadgets */
                     struct TextFont *do_TextFont;   /* Screen font (open) */
                     struct TextFont *do_GadgetFont; /* Gadget font (open) */
                     void            *do_VisualInfo;
                     struct Menu     *do_Menu;
                     struct Gadget   *do_GadToolsGadgets;
                     struct DockTool *do_Selected;
                     UWORD            do_SelectX;
                     UWORD            do_SelectY;
                     ULONG            do_Seconds;
                     ULONG            do_Micros;
                     BOOL             do_DeferClose;
                     BOOL             do_ReOpen;
                    };

/* do_Flags */
#define DO_Activated (1L<<0)
#define DO_Centered  (1L<<1)
#define DO_FrontMost (1L<<2)
#define DO_Menu      (1L<<3)
#define DO_Pattern   (1L<<4)
#define DO_PopUp     (1L<<5)
#define DO_Text      (1L<<6)
#define DO_Vertical  (1L<<7)
#define DO_Backdrop  (1L<<8)
#define DO_Sticky    (1L<<9)

/* Tag to Flag mapping table for PackBoolTags */
static struct TagItem flagmap[]={
                                 TMOP_Activated, DO_Activated,
                                 TMOP_Centered,  DO_Centered,
                                 TMOP_FrontMost, DO_FrontMost,
                                 TMOP_Menu,      DO_Menu,
                                 TMOP_Pattern,   DO_Pattern,
                                 TMOP_PopUp,     DO_PopUp,
                                 TMOP_Text,      DO_Text,
                                 TMOP_Vertical,  DO_Vertical,
                                 TMOP_Backdrop,  DO_Backdrop,
                                 TMOP_Sticky,    DO_Sticky,
                                 TAG_DONE};

/* Library bases */
struct Library *DiskfontBase;

/* Close a window safely */
static void SafeCloseWindow(struct Window *w)
{
 struct IntuiMessage *msg;

 DEBUG_PRINTF("SafeCloseWindow: 0x%08lx\n",w);

 /* we forbid here to keep out of race conditions with Intuition */
 Forbid();

 /* Remove all messsages for this window */
 msg=GetHead(&w->UserPort->mp_MsgList);
 while (msg)
  /* Does this message point to the window? */
  if (msg->IDCMPWindow==w) {
   struct IntuiMessage *nextmsg=GetSucc(msg);

   /* Yes. Remove it from port */
   Remove((struct Node *) msg);

   /* Reply it */
   ReplyMsg((struct Message *) msg);

   /* Get pointer to next message */
   msg=nextmsg;
  }
   /* No. Get pointer to next message */
  else msg=GetSucc(msg);

 /* clear UserPort so Intuition will not free it */
 w->UserPort=NULL;

 /* tell Intuition to stop sending more messages */
 ModifyIDCMP(w,0);

 /* turn multitasking back on */
 Permit();

 DEBUG_PRINTF("Closing window\n");

 /* and really close the window */
 CloseWindow(w);

 DEBUG_PRINTF("Window closed\n");
}

/* Pattern */
static UWORD BackgroundPattern[]={0xaaaa,0x5555};

/* Open Dock Window */
static void OpenDockWindow(struct TMObjectDock *tmobj, BOOL beep)
{
 struct Screen *pubsc;

 /* Open on frontmost public screen? */
 if (tmobj->do_Flags & DO_FrontMost) {
  ULONG lock;

  /* Avoid race conditions */
  Forbid();

  /* Lock IntuitionBase */
  lock=LockIBase(0);

  /* Get active screen */
  pubsc=IntuitionBase->ActiveScreen;
  if (pubsc) {
   ULONG type=pubsc->Flags & SCREENTYPE;

   DEBUG_PRINTF("Screen flags: 0x%08lx",pubsc->Flags);
   DEBUG_PRINTF(" Screen type: 0x%08lx\n",type);

   /* Found a public screen? */
   if (!((type==WBENCHSCREEN) || (type==PUBLICSCREEN)))
    /* No! */
    pubsc=NULL;
  }

  /* Unlock IntuitionBase */
  UnlockIBase(lock);

  /* Lock public screen */
  if (pubsc) {
   struct List *pubsclist;

   /* Get a pointer to the public screen list */
   if (pubsclist=LockPubScreenList()) {
    struct PubScreenNode *pubscnode=GetHead(pubsclist);
    UBYTE namebuf[MAXPUBSCREENNAME+1];

    /* Scan list */
    while (pubscnode) {
     /* Does this node point to our screen? */
     if (pubscnode->psn_Screen==pubsc) {
      /* Yes. Copy screen name */
      strcpy(namebuf,pubscnode->psn_Node.ln_Name);
      break;
     }

     /* get a pointer to next node */
     pubscnode=GetSucc(pubscnode);
    }

    /* Release public screen list */
    UnlockPubScreenList();

    /* Lock screen */
    if (pubscnode)
     pubsc=LockPubScreen(namebuf);
    else
     pubsc=NULL;
   }
   else pubsc=NULL; /* No public screens??? */
  }

  /* OK, we have a screen now */
  Permit();
 } else
  /* Lock public screen */
  pubsc=LockPubScreen(tmobj->do_PubScreen);

 DEBUG_PRINTF("PubScreen: 0x%08lx\n",pubsc);

 /* Got a locked public screen? */
 if (pubsc) {
  struct DrawInfo *dri;

  /* Get screen draw info */
  if (dri=GetScreenDrawInfo(pubsc)) {
   void *vi;

   /* Get screen visual info */
   if (vi=GetVisualInfo(pubsc,TAG_DONE)) {
    struct TextFont *tf;

    /* Open screen font */
    if (tf=OpenFont(pubsc->Font)) {
     struct Window *w;
     struct DockTool *dt=tmobj->do_Tools;
     struct TextFont *gadfont=NULL;
     UWORD wx=0,wy=0;
     BOOL borderless=tmobj->do_Title==NULL;
     BOOL text=(tmobj->do_Flags & DO_Text)!=0;

     /* Got ANY tools??? */
     if (dt) {
      /* Calculate box sizes */
      ULONG maxx=0,maxy=0,count=0;
      ULONG fheight;
      struct RastPort tmprp;

      /* Init RastPort for text writing */
      InitRastPort(&tmprp);

      /* Set default font */
      SetFont(&tmprp,tf);
      fheight=tf->tf_YSize+INTERHEIGHT+1;

      /* User specified font? */
      if (tmobj->do_Font &&
          (DiskfontBase=OpenLibrary("diskfont.library",36))) {
       /* OK, load font now */
       if (gadfont=OpenDiskFont(tmobj->do_Font)) {
        /* Set font */
        SetFont(&tmprp,gadfont);
        fheight=gadfont->tf_YSize+INTERHEIGHT+1;
       }

       /* Close library again */
       CloseLibrary(DiskfontBase);
      }

      DEBUG_PRINTF("TextAttr: 0x%08lx",tmobj->do_Font);
      DEBUG_PRINTF(" Font: 0x%08lx\n",gadfont);

      /* Scan tool list */
      while (dt) {
       ULONG valx=0,valy=0;

       if (text) {
        /* Gadgets */
        char *s=dt->dt_ExecName;

        /* Link and name valid? */
        if (dt->dt_ExecLink && s) {
         valx=TextLength(&tmprp,s,strlen(s))+2*INTERWIDTH+2;
         valy=fheight;
        }
       } else {
        /* Images */
        struct TMLinkImage *tmli=dt->dt_ImageLink;

        /* Link to image valid? */
        if (tmli) {
         /* max(width) */
         valx=tmli->tmli_Width;
         valy=tmli->tmli_Height-1;
        }
       }

       /* Check maxima */
       if (valx>maxx) maxx=valx;
       if (valy>maxy) maxy=valy;

       /* Increment counter & Get pointer to next tool */
       count++;
       dt=dt->dt_Next;
      }

      /* Calculate window sizes */
      tmobj->do_Width=tmobj->do_Columns*maxx;
      tmobj->do_Height=((count+tmobj->do_Columns-1)/tmobj->do_Columns)*maxy;
      tmobj->do_XSize=maxx;
      tmobj->do_YSize=maxy;
     }

     /* Got valid window sizes? */
     if (((LONG) tmobj->do_XSize>1) && ((LONG) tmobj->do_YSize>1) &&
         (tmobj->do_Columns>0) && (tmobj->do_Columns<=100)) {
      BOOL menu=(tmobj->do_Flags & DO_Menu)!=0;

      /* Correct window sizes */
      if (borderless) {
       /* Borderless window */
       struct Gadget *g=&tmobj->do_DragGadget;

       /* Gadget window */
       if (text) {
        tmobj->do_Width--;
        tmobj->do_Height--;
       }

       /* Calculate drag gadget dimensions */
       if (tmobj->do_Flags & DO_Vertical) {
        /* Vertical drag gadget */
        struct RastPort tmprp;
        UWORD gwidth;

        /* Init RastPort for text writing */
        InitRastPort(&tmprp);
        SetFont(&tmprp,tf);
        gwidth=TextLength(&tmprp,"A",1);

        tmobj->do_Left=gwidth;
        tmobj->do_Top=0;
        tmobj->do_Width+=gwidth;
        g->Width=gwidth;
        g->Height=tmobj->do_Height;
       } else {
        /* Horizontal drag gadget */
        UWORD gheight=(tf->tf_YSize+8)/2;

        tmobj->do_Left=0;
        tmobj->do_Top=gheight;
        tmobj->do_Height+=gheight;
        g->Width=tmobj->do_Width;
        g->Height=gheight;
       }

       /* Init drag gadget structure */
       g->Flags=GFLG_GADGHNONE;
       g->Activation=GACT_IMMEDIATE;
       g->GadgetType=GTYP_SYSGADGET|GTYP_WDRAGGING;

       /* Get pens */
       tmobj->do_FillPen=dri->dri_Pens[FILLPEN];
       tmobj->do_BackPen=dri->dri_Pens[BACKGROUNDPEN];
      } else {
       /* Normal window */
       tmobj->do_Left=pubsc->WBorLeft+1;
       tmobj->do_Top=pubsc->WBorTop+tf->tf_YSize+2;
       if (text) {
        tmobj->do_Width++;
        tmobj->do_Height++;
       } else {
        tmobj->do_Width+=2;
        tmobj->do_Height+=2;
       }
      }

      /* Centered window? */
      if (tmobj->do_Flags & DO_Centered) {
       /* Centered */
       /* Borderless window: X = MouseX - (width-left)/2 - left */
       /* Normal window    : X = MouseX -        width/2 - left */
       wx=tmobj->do_Width;
       wy=tmobj->do_Height;

       /* Borderless window? */
       if (borderless) {
        wx-=tmobj->do_Left;
        wy-=tmobj->do_Top;
       }

       wx=pubsc->MouseX-wx/2-tmobj->do_Left;
       wy=pubsc->MouseY-wy/2-tmobj->do_Top;
      } else {
       /* Not centered */
       wx=tmobj->do_LeftEdge;
       wy=tmobj->do_TopEdge;
      }

      /* Dock with menu? */
      if (menu &&
          (tmobj->do_Menu=CreateMenus(DockMenu,GTMN_FullMenu, TRUE,
                                               TAG_DONE)) &&
          !LayoutMenus(tmobj->do_Menu,vi,GTMN_NewLookMenus, TRUE,
                                         TAG_DONE)) {
       FreeMenus(tmobj->do_Menu);
       tmobj->do_Menu=NULL;
      }

      DEBUG_PRINTF("Boxes: X %ld",tmobj->do_XSize);
      DEBUG_PRINTF(" Y %ld",tmobj->do_YSize);
      DEBUG_PRINTF(" Window: Width %ld",tmobj->do_Width);
      DEBUG_PRINTF(" Height %ld\n",tmobj->do_Height);
      DEBUG_PRINTF("menu %ld",menu);
      DEBUG_PRINTF(" Menu 0x%08lx\n",tmobj->do_Menu);

      /* Open window */
      if ((!menu || tmobj->do_Menu) &&
          (w=OpenWindowTags(NULL,WA_Left,         wx,
                                 WA_Top,          wy,
                                 WA_InnerWidth,   tmobj->do_Width,
                                 WA_InnerHeight,  tmobj->do_Height,
                                 WA_Title,        tmobj->do_Title,
                                 WA_DragBar,      !borderless,
                                 WA_CloseGadget,  !borderless,
                                 WA_DepthGadget,  !borderless,
                                 WA_Borderless,   borderless,
                                 WA_PubScreen,    pubsc,
                                 WA_RMBTrap,      !menu,
                                 WA_AutoAdjust,   TRUE,
                                 WA_IDCMP,        0,
                                 WA_NewLookMenus, TRUE,
                                 TAG_DONE))) {
       /* Backdrop window? */
       if (tmobj->do_Flags & DO_Backdrop) WindowToBack(w);

       /* Set window pointers */
       w->UserPort=IDCMPPort;
       w->UserData=(APTR) tmobj;

       DEBUG_PRINTF("Window: 0x%08lx\n",w);

       /* Set IDCMP flags */
       if (ModifyIDCMP(w,IDCMP_ACTIVEWINDOW|IDCMP_INACTIVEWINDOW|IDCMP_GADGETUP|
                         IDCMP_MOUSEBUTTONS|IDCMP_CLOSEWINDOW|IDCMP_MENUPICK|
                         IDCMP_REFRESHWINDOW)) {
        struct Gadget *g;
        BOOL wbscreen=(pubsc->Flags & SCREENTYPE)==WBENCHSCREEN;

        /* Try to add the window as application window */
        tmobj->do_AppWindow=NULL;
        if (wbscreen && GetWorkbench() &&
            !(tmobj->do_AppWindow=AddAppWindowA((ULONG) &tmobj->do_Link,
                                                NULL,w,AppMsgPort,NULL)))
         /* AddAppWindow() failed (Workbench not running?) */
         FreeWorkbench();

        /* Draw drag gadget */
        if (borderless) {
         struct RastPort *rp=w->RPort;
         UWORD width=tmobj->do_DragGadget.Width-1;
         UWORD height=tmobj->do_DragGadget.Height-1;

         /* Draw lighted side */
         SetAPen(rp,dri->dri_Pens[SHINEPEN]);
         Move(rp,0,height);
         Draw(rp,0,0);
         Draw(rp,width,0);

         /* Draw shadowed side */
         SetAPen(rp,dri->dri_Pens[SHADOWPEN]);
         Move(rp,width,1);
         Draw(rp,width,height);
         Draw(rp,0,height);

         AddGadget(w,&tmobj->do_DragGadget,(UWORD) -1);
         RefreshGList(&tmobj->do_DragGadget,w,NULL,1);
        }

        /* Draw initial window state */
        {
         struct RastPort *rp=w->RPort;
         ULONG col=0,lin=0;
         UWORD x=tmobj->do_Left;
         UWORD y=tmobj->do_Top;
         UWORD dw=tmobj->do_XSize;
         UWORD dh=tmobj->do_YSize;
         BOOL pattern=((tmobj->do_Flags & DO_Pattern)!=0 && !text);
         struct NewGadget ng;

         /* Set pattern */
         if (pattern) {
          SetAPen(rp,dri->dri_Pens[SHADOWPEN]);
          SetDrMd(rp,JAM2);
          SetAfPt(rp,BackgroundPattern,1);
         }

         /* Set pointer to begin of tool list */
         dt=tmobj->do_Tools;

         /* Init TextAttr & NewGadget struct, create GadTools context */
         if (text) {
          /* Font set? */
          if (tmobj->do_Font)
           tmobj->do_TextAttr=*(tmobj->do_Font);
          else {
           /* No. Set screen font */
           tmobj->do_TextAttr.ta_Name=tf->tf_Message.mn_Node.ln_Name;
           tmobj->do_TextAttr.ta_YSize=tf->tf_YSize;
           tmobj->do_TextAttr.ta_Style=tf->tf_Style;
           tmobj->do_TextAttr.ta_Flags=tf->tf_Flags;
          }

          DEBUG_PRINTF("Font '%s'",tmobj->do_TextAttr.ta_Name);
          DEBUG_PRINTF(" Size %ld\n",tmobj->do_TextAttr.ta_YSize);

          ng.ng_Width=dw-1;
          ng.ng_Height=dh-1;
          ng.ng_TextAttr=&tmobj->do_TextAttr;
          ng.ng_Flags=PLACETEXT_IN;
          ng.ng_VisualInfo=vi;
          ng.ng_UserData=0;
          tmobj->do_GadToolsGadgets=NULL;
          if (!(g=CreateContext(&tmobj->do_GadToolsGadgets)))
           dt=NULL; /* Error!!! */
         }

         /* Scan tool list */
         while (dt) {
          if (text) {
           /* Gadgets. Link valid? */
           if (dt->dt_ExecLink) {
            /* Init NewGadget values */
            ng.ng_LeftEdge=x;
            ng.ng_TopEdge=y;
            ng.ng_GadgetText=dt->dt_ExecName;
            ng.ng_UserData=dt;

            /* Create button gadget */
            if (!(g=CreateGadget(BUTTON_KIND,g,&ng,TAG_DONE)))
             dt=NULL; /* Error!!!! */
           }
          } else {
           /* Images */
           struct TMLinkImage *tmli=dt->dt_ImageLink;

           /* Draw pattern? */
           if (pattern) {
            /* Set Pattern color */
            SetBPen(rp,(col+lin)&1 ? dri->dri_Pens[BACKGROUNDPEN] :
                                     dri->dri_Pens[FILLPEN]);

            /* Draw pattern */
            RectFill(rp,x,y,x+dw-1,y+dh-1);
           }

           /* Link valid? */
           if (tmli) {
            /* Yes. Set Parameters */
            tmli->tmli_LeftEdge=x+(dw - tmli->tmli_Width)/2;
            tmli->tmli_TopEdge=y+(dh + 1 - tmli->tmli_Height)/2;
            tmli->tmli_RastPort=w->RPort;

            /* Draw deactivated state */
            CallActivateTMObject((struct TMLink *) tmli,(void *) IOC_DEACTIVE);
           }
          }

          /* Next column */
          col++;

          /* Increment x,y. Last Column? */
          if (col==tmobj->do_Columns) {
           /* Yes */
           y+=dh;
           x=tmobj->do_Left;
           col=0;
           lin++;
          } else
           /* No */
           x+=dw;

          /* Get pointer to next node */
          if (dt) dt=dt->dt_Next;
         }

         /* Reset Areafill pattern */
         if (pattern) SetAfPt(rp,NULL,0);
        }

        /* All OK. */
        if (!text || g) {
         /* Add GadTools gadgets */
         if (text) {
          AddGList(w,tmobj->do_GadToolsGadgets,(UWORD) -1,(UWORD) -1,NULL);
          RefreshGList(tmobj->do_GadToolsGadgets,w,NULL,(UWORD) -1);
          GT_RefreshWindow(w,NULL);
         }

         /* Add menu */
         if (menu) SetMenuStrip(w,tmobj->do_Menu);

         /* Free resources */
         FreeScreenDrawInfo(pubsc,dri);
         UnlockPubScreen(NULL,pubsc);

         /* Save pointers */
         tmobj->do_VisualInfo=vi;
         tmobj->do_TextFont=tf;
         tmobj->do_GadgetFont=gadfont;
         tmobj->do_Window=w;
         tmobj->do_DeferClose=FALSE;
         return;
         /* NOT REACHED */
        }

        /* Remove drag Gadget */
        if (borderless) RemoveGadget(w,&tmobj->do_DragGadget);

        /* Free GadTools gadgets */
        if (text) {
         FreeGadgets(tmobj->do_GadToolsGadgets);
         tmobj->do_GadToolsGadgets=NULL;
        }

        /* Remove AppWindow, close Workbench */
        if (tmobj->do_AppWindow) {
         SafeRemoveAppWindow(tmobj->do_AppWindow,&tmobj->do_Link);
         FreeWorkbench();
        }
       }
       SafeCloseWindow(w);
      }
      if (tmobj->do_Menu) {
       FreeMenus(tmobj->do_Menu);
       tmobj->do_Menu=NULL;
      }
     }
     if (gadfont) CloseFont(gadfont);
     CloseFont(tf);
    }
    FreeVisualInfo(vi);
   }
   FreeScreenDrawInfo(pubsc,dri);
  }
  UnlockPubScreen(NULL,pubsc);
 }

 /* Dock couldn't be opened! */
 if (beep)
  DisplayBeep(NULL);
 else
  tmobj->do_ReOpen = TRUE;
}

/* Close Dock window */
static void CloseDockWindow(struct TMObjectDock *tmobj)
{
 struct DockTool *dt=tmobj->do_Tools;
 struct Window *w=tmobj->do_Window;

 DEBUG_PRINTF("CloseDockWindow: 0x%08lx\n",tmobj);

 /* Deactivate all Image objects */
 while (dt) {
  /* Image object active? */
  if (dt->dt_ImageLink && dt->dt_ImageLink->tmli_Link.tml_Active)
   /* Yes. Deactivate it first */
   CallActivateTMObject((struct TMLink *) dt->dt_ImageLink,
                        (void *) IOC_DEACTIVE);

  /* Get pointer to next node */
  dt=dt->dt_Next;
 }

 /* Remove menu */
 if (tmobj->do_Menu) {
  ClearMenuStrip(w);
  FreeMenus(tmobj->do_Menu);
  tmobj->do_Menu=NULL;
 }

 /* Remove drag gadget */
 if (!tmobj->do_Title) RemoveGadget(w,&tmobj->do_DragGadget);

 /* Remove gadtools gadgets */
 if (tmobj->do_GadToolsGadgets) {
  RemoveGList(w,tmobj->do_GadToolsGadgets,(UWORD) -1);
  FreeGadgets(tmobj->do_GadToolsGadgets);
  tmobj->do_GadToolsGadgets=NULL;
 }

 /* Remove AppWindow, free Workbench */
 if (tmobj->do_AppWindow) {
  SafeRemoveAppWindow(tmobj->do_AppWindow,&tmobj->do_Link);
  FreeWorkbench();
 }

 /* Sticky window? */
 if (!(tmobj->do_Flags & DO_Sticky)) {
  /* No, remember last window position */
  tmobj->do_LeftEdge=w->LeftEdge;
  tmobj->do_TopEdge=w->TopEdge;
 }

 /* Close Window */
 SafeCloseWindow(w);
 tmobj->do_Window=NULL;

 /* Free resources */
 if (tmobj->do_GadgetFont) CloseFont(tmobj->do_GadgetFont);
 CloseFont(tmobj->do_TextFont);
 FreeVisualInfo(tmobj->do_VisualInfo);
}

/* If dock window is on the screen then close it and set the re-open flag */
void ScreenCloseRequest(struct TMObject *tmobj, struct Screen *s)
{
 struct TMObjectDock *tmdo = (struct TMObjectDock *) tmobj;

 /* Window open and on the screen? */
 if (tmdo->do_Window && (tmdo->do_Window->WScreen == s)) {

  /* Yes, close dock */
  CloseDockWindow(tmdo);

  /* Set re-open flag */
  tmdo->do_ReOpen = TRUE;
 }
}

/* If the re-open flag is set then open the dock again */
void ScreenOpenRequest(struct TMObj *tmobj, char *name)
{
 struct TMObjectDock *tmdo = (struct TMObjectDock *) tmobj;

 /* Re-open flag set and public screen name matches? */
 if (tmdo->do_ReOpen && tmdo->do_PubScreen && !stricmp(tmdo->do_PubScreen, name)) {

  /* Yes, open dock */
  OpenDockWindow(tmdo, TRUE);

  /* Reset re-open flag */
  tmdo->do_ReOpen = FALSE;
 }
}


/* Free tools list */
static void FreeTools(struct TMObjectDock *tmobj)
{
 struct DockTool *dt,*nextdt=tmobj->do_Tools;

 /* Scan list */
 while (dt=nextdt) {
  /* Get pointer to next node */
  nextdt=dt->dt_Next;

  /* Remove links */
  if (dt->dt_ExecLink) RemLinkTMObject(dt->dt_ExecLink);
  if (dt->dt_ImageLink) RemLinkTMObject((struct TMLink *) dt->dt_ImageLink);
  if (dt->dt_SoundLink) RemLinkTMObject(dt->dt_SoundLink);

  /* Free Node */
  FreeMem(dt,sizeof(struct DockTool));
 }
}

/* Create a Dock object */
struct TMObject *CreateTMObjectDock(struct TMHandle *handle, char *name,
                                    struct TagItem *tags)
{
 struct TMObjectDock *tmobj;

 /* allocate memory for object */
 if (tmobj=(struct TMObjectDock *)
            AllocateTMObject(sizeof(struct TMObjectDock))) {
  struct TagItem *ti,*tstate;
  struct DockTool *dt=NULL;

  /* Set defaults */
  tmobj->do_Columns=1;

  /* Scan tag list */
  tstate=tags;
  while (ti=NextTagItem(&tstate)) {

   DEBUG_PRINTF("Got Tag (0x%08lx)\n",ti->ti_Tag);

   switch (ti->ti_Tag) {
    case TMOP_Columns:   if (ti->ti_Data) tmobj->do_Columns=ti->ti_Data;
                         break;
    case TMOP_Font:      {
                          struct TextAttr *ta=(struct TextAttr *) ti->ti_Data;

                          if (ta && ta->ta_Name) tmobj->do_Font=ta;
                         }
                         break;
    case TMOP_HotKey:    tmobj->do_HotKey=(char *) ti->ti_Data;
                         break;
    case TMOP_LeftEdge:  tmobj->do_LeftEdge=ti->ti_Data;
                         break;
    case TMOP_PubScreen: tmobj->do_PubScreen=(char *) ti->ti_Data;
                         break;
    case TMOP_Title:     tmobj->do_Title=(char *) ti->ti_Data;
                         break;
    case TMOP_Tool:      if (ti->ti_Data) {
                          struct DockTool *newdt;

                          /* Alloc DockTool structure */
                          if (newdt=AllocMem(sizeof(struct DockTool),
                                             MEMF_CLEAR)) {
                           char **names=(char **) ti->ti_Data;

                           /* Add link to Exec object */
                           if (names[0] &&
                               (newdt->dt_ExecLink=AddLinkTMObject(handle,
                                                                  names[0],
                                                                TMOBJTYPE_EXEC,
                                                            (struct TMObject *)
                                                                  tmobj)))
                            /* Get name of exec object. We use names[0]
                               instead of object name, because the link could
                               be deleted while window is still active. */
                            newdt->dt_ExecName=names[0];

                           /* Add link to Image object */
                           if (names[1])
                            newdt->dt_ImageLink=(struct TMLinkImage *)
                                    AddLinkTMObject(handle,names[1],
                                                    TMOBJTYPE_IMAGE,
                                                    (struct TMObject *) tmobj);

                           /* Add link to Sound object */
                           if (names[2])
                            newdt->dt_SoundLink=AddLinkTMObject(handle,names[2],
                                                                TMOBJTYPE_SOUND,
                                                            (struct TMObject *)
                                                                tmobj);

                           /* Add node to list. Head of list? */
                           if (dt) {
                            /* No. Add to tail */
                            dt->dt_Next=newdt;
                            dt=newdt;
                           } else {
                            /* Yes. Init list anchor */
                            tmobj->do_Tools=newdt;
                            dt=newdt;
                           }
                          }
                         }
                         break;
    case TMOP_TopEdge:   tmobj->do_TopEdge=ti->ti_Data;
                         break;
   }
  }

  {
   BOOL hotkey=tmobj->do_HotKey!=NULL;

   /* No HotKey or cannot create CxObject from HotKey description? */
   if (hotkey && (tmobj->do_CxObj=HotKey(tmobj->do_HotKey,BrokerPort,
                                         (ULONG) &tmobj->do_Link))) {

    DEBUG_PRINTF("Created CxObj (0x%08lx)\n",tmobj->do_CxObj);

    /* Attach object to broker */
    AttachCxObj(Broker,tmobj->do_CxObj);
   }

   /* No HotKey or Commodities error? */
   if (!hotkey || (tmobj->do_CxObj && !CxObjError(Broker))) {
    /* Set flags */
    tmobj->do_Flags=PackBoolTags(DO_Activated,tags,flagmap);

    /* Initialize rest of structure */
    tmobj->do_Link.tml_Linked=(struct TMObject *) tmobj;

    /* Active flag set? */
    if (tmobj->do_Flags & DO_Activated)
     /* Yes. Open dock window */
     OpenDockWindow(tmobj, FALSE);

    /* All OK */
    return(tmobj);
   }

   /* Free resources */
   if (tmobj->do_CxObj) SafeDeleteCxObjAll(tmobj->do_CxObj,&tmobj->do_Link);
  }
  FreeTools(tmobj);
 }

 /* call failed */
 return(NULL);
}

/* Delete a Dock object */
BOOL DeleteTMObjectDock(struct TMObjectDock *tmobj)
{
 DEBUG_PRINTF("Delete/Dock (0x%08lx)\n",tmobj);

 /* Remove links */
 DeleteAllLinksTMObject((struct TMObject *) tmobj);

 /* Free resources */
 if (tmobj->do_CxObj) SafeDeleteCxObjAll(tmobj->do_CxObj,&tmobj->do_Link);

 /* Close window and free its resources */
 if (tmobj->do_Window) CloseDockWindow(tmobj);

 /* Free tool nodes */
 FreeTools(tmobj);

 /* Remove object from list */
 Remove((struct Node *) tmobj);

 /* Free object */
 FreeMem(tmobj,sizeof(struct TMObjectDock));

 /* All OK. */
 return(TRUE);
}

/* Change a Dock object */
struct TMObject *ChangeTMObjectDock(struct TMHandle *handle,
                                    struct TMObjectDock *tmobj,
                                    struct TagItem *tags)
{
 struct TagItem *ti,*tstate;
 struct DockTool *dt;

 /* Search last dock tool */
 dt=tmobj->do_Tools;
 if (dt)
  while (dt->dt_Next) dt=dt->dt_Next;

 /* Close dock */
 if (tmobj->do_Window) CloseDockWindow(tmobj);

 /* Scan tag list */
 tstate=tags;
 while (ti=NextTagItem(&tstate)) {

  DEBUG_PRINTF("Got Tag (0x%08lx)\n",ti->ti_Tag);

  switch (ti->ti_Tag) {
   case TMOP_Columns:   if (ti->ti_Data) tmobj->do_Columns=ti->ti_Data;
                        break;
   case TMOP_Font:      {
                         struct TextAttr *ta=(struct TextAttr *) ti->ti_Data;

                         if (ta && ta->ta_Name) tmobj->do_Font=ta;
                        }
                        break;
   case TMOP_HotKey:    if (tmobj->do_CxObj) {
                         SafeDeleteCxObjAll(tmobj->do_CxObj,&tmobj->do_Link);
                         tmobj->do_CxObj=NULL;
                        }

                        tmobj->do_HotKey=(char *) ti->ti_Data;
                        break;
   case TMOP_LeftEdge:  tmobj->do_LeftEdge=ti->ti_Data;
                        break;
   case TMOP_PubScreen: tmobj->do_PubScreen=(char *) ti->ti_Data;
                        break;
   case TMOP_Title:     tmobj->do_Title=(char *) ti->ti_Data;
                        break;
   case TMOP_Tool:      if (ti->ti_Data) {
                         struct DockTool *newdt;

                         /* Alloc DockTool structure */
                         if (newdt=AllocMem(sizeof(struct DockTool),
                                            MEMF_CLEAR)) {
                          char **names=(char **) ti->ti_Data;

                          /* Add link to Exec object */
                          if (names[0] &&
                              (newdt->dt_ExecLink=AddLinkTMObject(handle,
                                                                  names[0],
                                                                TMOBJTYPE_EXEC,
                                                            (struct TMObject *)
                                                                  tmobj)))
                           /* Get name of exec object. We use names[0]
                              instead of object name, because the link could
                              be deleted while window is still active. */
                           newdt->dt_ExecName=names[0];

                          /* Add link to Image object */
                          if (names[1])
                           newdt->dt_ImageLink=(struct TMLinkImage *)
                                    AddLinkTMObject(handle,names[1],
                                                    TMOBJTYPE_IMAGE,
                                                    (struct TMObject *) tmobj);

                          /* Add link to Sound object */
                          if (names[2])
                           newdt->dt_SoundLink=AddLinkTMObject(handle,names[2],
                                                               TMOBJTYPE_SOUND,
                                                           (struct TMObject *)
                                                               tmobj);

                          /* Add node to list. Head of list? */
                          if (dt) {
                           /* No. Add to tail */
                           dt->dt_Next=newdt;
                           dt=newdt;
                          } else {
                           /* Yes. Init list anchor */
                           tmobj->do_Tools=newdt;
                           dt=newdt;
                          }
                         }
                        }
                        break;
   case TMOP_TopEdge:   tmobj->do_TopEdge=ti->ti_Data;
                        break;
  }
 }

 /* Set new flags */
 tmobj->do_Flags=PackBoolTags(tmobj->do_Flags,tags,flagmap);

 /* HotKey set? Create Commodities object from HotKey description */
 if (tmobj->do_HotKey && !tmobj->do_CxObj &&
     (tmobj->do_CxObj=HotKey(tmobj->do_HotKey,BrokerPort,
                             (ULONG) &tmobj->do_Link))) {

  DEBUG_PRINTF("Created CxObj (0x%08lx)\n",tmobj->do_CxObj);

  /* Attach object to broker */
  AttachCxObj(Broker,tmobj->do_CxObj);

  /* Commodities error? */
  if (CxObjError(Broker)) {
   SafeDeleteCxObjAll(tmobj->do_CxObj,&tmobj->do_Link);
   tmobj->do_CxObj=NULL;
  }
 }

 /* Active flag set? */
 if (tmobj->do_Flags & DO_Activated)
  /* Yes. Open dock window */
  OpenDockWindow(tmobj, FALSE);

 /* All OK. */
 return(TRUE);
}

/* Allocate & Initialize a TMLink structure */
struct TMLink *AllocLinkTMObjectDock(struct TMObjectDock *tmobj)
{
 struct TMLink *tml;

 /* Allocate memory for link structure */
 if (tml=AllocMem(sizeof(struct TMLink),MEMF_CLEAR|MEMF_PUBLIC))
  /* Initialize link structure */
  tml->tml_Size=sizeof(struct TMLink);

 return(tml);
}

/* Update link structures */
void DeleteLinkTMObjectDock(struct TMLink *tml)
{
 struct TMObjectDock *tmobj=(struct TMObjectDock *) tml->tml_LinkedTo;
 struct DockTool *dt=tmobj->do_Tools;

 /* Scan tool list */
 while (dt) {
  /* Link to Exec object? */
  if (tml==dt->dt_ExecLink) {
   dt->dt_ExecLink=NULL;
   dt->dt_ExecName=NULL;
   break;
  }
  /* Link to Image object? */
  else if (tml==(struct TMLink *) dt->dt_ImageLink) {
   /* Image object active? */
   if (tml->tml_Active)
    /* Yes. Deactivate it */
    CallActivateTMObject((struct TMLink *) tml,(void *) IOC_DEACTIVE);

   dt->dt_ImageLink=NULL;
   break;
  }
  /* Link to Sound object? */
  else if (tml==dt->dt_SoundLink) {
   dt->dt_SoundLink=NULL;
   break;
  }

  /* Get pointer to next tool */
  dt=dt->dt_Next;
 }
}

/* Find dock tool that corresponds to X,Y position */
static struct DockTool *FindDockTool(struct TMObjectDock *tmobj, ULONG x,
                                     ULONG y)
{
 struct DockTool *dt;
 UWORD dx=tmobj->do_Left;
 UWORD dy=tmobj->do_Top;
 UWORD w,h;
 ULONG col,cols;

 /* Out of bounds? */
 if ((x<dx) || (y<dy)) return(NULL); /* Yes! */

 /* Init variables */
 dt=tmobj->do_Tools;
 w=tmobj->do_XSize;
 h=tmobj->do_YSize;
 cols=tmobj->do_Columns;
 col=0;

 /* Scan dock tool list */
 while (dt)
  if ((x>=dx) && (y>=dy) && (x<dx+w) && (y<dy+h)) {
   /* Tool found */
   tmobj->do_Selected=dt;
   tmobj->do_SelectX=dx;
   tmobj->do_SelectY=dy;
   return(dt);
  } else {
   /* Increment column counter */
   col++;

   /* Last column? */
   if (col==cols) {
    /* Yes */
    dx=tmobj->do_Left;
    dy+=h;
    col=0;
   } else
    /* No */
    dx+=w;

   /* Get pointer to next dock tool */
   dt=dt->dt_Next;
  }

 /* Dock tool not found */
 return(NULL);
}

/* Activate one dock entry */
static BOOL ActivateDockEntry(struct TMObjectDock *tmobj, struct DockTool *dt,
                              struct AppMessage *msg, ULONG anim)
{
 /* Activate Sound object */
 if (dt->dt_SoundLink) CallActivateTMObject(dt->dt_SoundLink,NULL);

 /* Activate Image object */
 if (!(tmobj->do_Flags & DO_Text) && dt->dt_ImageLink && anim)
    CallActivateTMObject((struct TMLink *) dt->dt_ImageLink,(void *) anim);

 /* Set defered close flag */
 tmobj->do_DeferClose=TRUE;

 /* Activate Exec object */
 if (dt->dt_ExecLink) CallActivateTMObject(dt->dt_ExecLink,msg);

 /* PopUp dock or defered close? Yes, close window */
 if ((tmobj->do_Flags & DO_PopUp) || !tmobj->do_DeferClose)
  return(TRUE);
 else {
  /* Reset defered close flag */
  tmobj->do_DeferClose=FALSE;
  return(FALSE);
 }
}

/* Activate a Dock object */
void ActivateTMObjectDock(struct TMLink *tml, struct AppMessage *msg)
{
 struct TMObjectDock *tmobj=(struct TMObjectDock *) tml->tml_Linked;

 DEBUG_PRINTF("Activate/Dock (0x%08lx)\n",msg);

 /* Got arguments? */
 if (msg) {
  /* Yes. Icons were dropped on the dock */
  struct DockTool *dt;

  /* Find Tool */
  if (dt=FindDockTool(tmobj,msg->am_MouseX,msg->am_MouseY)) {
   /* Activate dock entry */
   if (ActivateDockEntry(tmobj,dt,msg,IOC_FULLANIM))
    CloseDockWindow(tmobj);

   /* Clear pointer */
   tmobj->do_Selected=NULL;
  }
 }
 /* No. User pressed HotKey. Window open? */
 else if (tmobj->do_Window)
  /* Defered close? */
  if (tmobj->do_DeferClose)
   /* Yes, clear flag */
   tmobj->do_DeferClose=FALSE;
  else
   /* No, close window and free its resources */
   CloseDockWindow(tmobj);
 else {
  /* Window not open. Open it. */
  OpenDockWindow(tmobj, TRUE);

  /* If DO_FrontMost is not set, move screen to front */
  if (!(tmobj->do_Flags & DO_FrontMost) && tmobj->do_Window)
   ScreenToFront(tmobj->do_Window->WScreen);
 }
}

/* Handle IDCMP events */
void HandleIDCMPEvents(void)
{
 struct IntuiMessage *msg;

 /* Scan IDCMP message port */
 while (msg=GT_GetIMsg(IDCMPPort)) {
  struct TMObjectDock *tmobj=(struct TMObjectDock *) msg->IDCMPWindow->UserData;
  BOOL closewindow=FALSE;

  DEBUG_PRINTF("IDCMP Class: 0x%08lx\n",msg->Class);

  switch (msg->Class) {
   case IDCMP_CLOSEWINDOW:    /* Set close flag */
                              closewindow=TRUE;
                              break;
   case IDCMP_REFRESHWINDOW:  {
                               struct Window *w=tmobj->do_Window;

                               GT_BeginRefresh(w);
                               GT_EndRefresh(w,TRUE);
                              }
                              break;
   case IDCMP_MOUSEBUTTONS:   /* Only docks with images need button events */
                              if (!(tmobj->do_Flags & DO_Text))
                               switch (msg->Code) {
                                case SELECTDOWN: /* Select button pressed */
                                 {
                                  struct DockTool *dt;

                                  if (dt=FindDockTool(tmobj,msg->MouseX,
                                                            msg->MouseY)) {
                                   struct TMLinkImage *tmli=dt->dt_ImageLink;

                                   DEBUG_PRINTF("Dock selected: 0x%08lx\n",dt);

                                   /* Got a dock tool with image object? */
                                   if (tmli)
                                    /* Image object with active anim? */
                                    if (tmli->tmli_Link.tml_Active)
                                     /* Yes, clear pointer */
                                     tmobj->do_Selected=NULL;
                                    else
                                     /* No, select it */
                                     CallActivateTMObject((struct TMLink *)
                                                          tmli,
                                                          (void *) IOC_ACTIVE);
                                  }
                                 }
                                 break;
                                case SELECTUP:   /* Select button released */
                                 {
                                  struct DockTool *dt=tmobj->do_Selected;

                                  /* Got a selected dock tool? */
                                  if (dt) {
                                   struct TMLinkImage *tmli=dt->dt_ImageLink;

                                   /* Dock tool with image object? */
                                   if (tmli) {
                                    UWORD x=msg->MouseX;
                                    UWORD y=msg->MouseY;
                                    UWORD dx=tmobj->do_SelectX;
                                    UWORD dy=tmobj->do_SelectY;

                                    /* Mouse still on dock tool and no */
                                    /* double click?                   */
                                    if ((x>=dx) && (y>=dy) &&
                                        (x<dx+tmobj->do_XSize) &&
                                        (y<dy+tmobj->do_YSize) &&
                                        !DoubleClick(tmobj->do_Seconds,
                                                     tmobj->do_Micros,
                                                     msg->Seconds,
                                                     msg->Micros)) {
                                     /* Yes. Activate dock entry */
                                     closewindow=ActivateDockEntry(tmobj,dt,
                                                            NULL,IOC_CONTANIM);

                                     /* Save time stamp */
                                     tmobj->do_Seconds=msg->Seconds;
                                     tmobj->do_Micros=msg->Micros;
                                    }
                                    else
                                     /* No, de-select image */
                                     CallActivateTMObject((struct TMLink *)
                                                          dt->dt_ImageLink,
                                                          (void *) IOC_DEACTIVE
                                                         );
                                   }

                                   /* Clear pointer */
                                   tmobj->do_Selected=NULL;
                                  }
                                 }
                                 break;
                               }
                              break;
   case IDCMP_GADGETUP:       /* Prevent double clicks */
                              if (!DoubleClick(tmobj->do_Seconds,
                                               tmobj->do_Micros,
                                               msg->Seconds,msg->Micros)) {
                               struct DockTool *dt=(struct DockTool *)
                                ((struct Gadget *) msg->IAddress)->UserData;

                               /* Activate dock entry */
                               closewindow=ActivateDockEntry(tmobj,dt,NULL,0);

                               /* Save time stamp */
                               tmobj->do_Seconds=msg->Seconds;
                               tmobj->do_Micros=msg->Micros;
                              }
                              break;
   case IDCMP_MENUPICK:       {
                               USHORT menunum=msg->Code;

                               /* Scan all menu events */
                               while (menunum!=MENUNULL) {
                                struct MenuItem *menuitem=
                                 ItemAddress(tmobj->do_Menu,menunum);

                                /* Which menu selected? */
                                switch(GTMENUITEM_USERDATA(menuitem)) {
                                 case MENU_CLOSE: closewindow=TRUE;
                                                  break;
                                 case MENU_QUIT:  Closing=TRUE;
                                                  break;
                                }

                                /* Get next menu event */
                                menunum=menuitem->NextSelect;
                               }
                              }
                              break;
   case IDCMP_ACTIVEWINDOW:   if (!tmobj->do_Title) {
                               /* Borderless window */
                               struct RastPort *rp=tmobj->do_Window->RPort;
                               struct Gadget *g=&tmobj->do_DragGadget;

                               SetDrMd(rp,JAM1);
                               SetAPen(rp,tmobj->do_FillPen);
                               RectFill(rp,1,1,g->Width-2,g->Height-2);
                              }
                              break;
   case IDCMP_INACTIVEWINDOW: {
                               struct DockTool *dt=tmobj->do_Selected;

                               if (!tmobj->do_Title) {
                                /* Borderless window */
                                struct RastPort *rp=tmobj->do_Window->RPort;
                                struct Gadget *g=&tmobj->do_DragGadget;

                                SetDrMd(rp,JAM1);
                                SetAPen(rp,tmobj->do_BackPen);
                                RectFill(rp,1,1,g->Width-2,g->Height-2);
                               }

                               /* Missed a selectup??? */
                               if (dt) {
                                struct TMLinkImage *tmli=dt->dt_ImageLink;

                                /* Got non-ANIM image object? */
                                if (tmli && !tmli->tmli_Link.tml_Active)
                                 CallActivateTMObject((struct TMLink *) tmli,
                                                      (void *) IOC_DEACTIVE);

                                tmobj->do_Selected=NULL;
                               }
                              }
                              break;
  }

  /* Reply message */
  GT_ReplyIMsg(msg);

  /* Close window? */
  if (closewindow) CloseDockWindow(tmobj);
 }
}
