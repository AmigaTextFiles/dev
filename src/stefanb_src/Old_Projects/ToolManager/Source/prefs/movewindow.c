/*
 * movewindow.c  V2.1
 *
 * move window handling
 *
 * (c) 1990-1993 Stefan Becker
 */

#include "ToolManagerConf.h"

/* Window data */
struct Window *MoveWindowPtr=NULL; /* Window */
static UWORD ww,wh;                /* Window size */

/* Gadget data */
static struct IntuiText it={1,0,JAM2,INTERWIDTH,INTERHEIGHT/2,NULL,NULL,NULL};
static struct Gadget g={NULL,0,0,0,0,GFLG_GADGHNONE|GFLG_LABELITEXT,
                        GACT_IMMEDIATE,GTYP_SYSGADGET|GTYP_WDRAGGING,NULL,NULL,
                        &it,0,NULL,0,NULL};
static struct Window *GadWindow;
static struct Gadget *XGad,*YGad;
static ULONG OldX,OldY;
ULONG MoveWindowOffX,MoveWindowOffY;

/* Init move window */
void InitMoveWindow(UWORD left, UWORD fheight)
{
 struct DrawInfo *dri;
 char *s=AppStrings[MSG_MOVEWIN_DRAG_GAD];

 /* Get screen draw info */
 if (dri=GetScreenDrawInfo(PublicScreen)) {
  /* Set pens for IntuiText */
  it.FrontPen=dri->dri_Pens[TEXTPEN];
  it.BackPen=dri->dri_Pens[BACKGROUNDPEN];

  FreeScreenDrawInfo(PublicScreen,dri);
 }

 /* Set gadget text & text attr */
 it.ITextFont=&ScreenTextAttr;
 it.IText=s;

 /* Calculate drag gadget & window sizes */
 ww=TextLength(&TmpRastPort,s,strlen(s))+2*INTERWIDTH;
 wh=fheight;
 g.Width=ww;
 g.Height=wh;
}

/* Open move window */
void OpenMoveWindow(struct Window *w, struct Gadget *xgad,
                                      struct Gadget *ygad)
{
 /* Read current position */
 OldX=((struct StringInfo *) xgad->SpecialInfo)->LongInt+MoveWindowOffX;
 OldY=((struct StringInfo *) ygad->SpecialInfo)->LongInt+MoveWindowOffY;

 if (MoveWindowPtr=OpenWindowTags(NULL,WA_Left,       OldX,
                                       WA_Top,        OldY,
                                       WA_Width,      ww,
                                       WA_Height,     wh,
                                       WA_AutoAdjust, TRUE,
                                       WA_PubScreen,  PublicScreen,
                                       WA_Flags,      WFLG_BORDERLESS|
                                                      WFLG_RMBTRAP,
                                       WA_Gadgets,    &g,
                                       TAG_DONE)) {
  /* Draw bevel box */
  DrawBevelBox(MoveWindowPtr->RPort,0,0,ww,wh,GT_VisualInfo,ScreenVI,
                                              TAG_DONE);

  /* Set window variables */
  MoveWindowPtr->UserPort=IDCMPPort;
  MoveWindowPtr->UserData=(BYTE *) HandleMoveWindowIDCMP;
  ModifyIDCMP(MoveWindowPtr,IDCMP_INTUITICKS|IDCMP_INACTIVEWINDOW);
  GadWindow=w;
  XGad=xgad;
  YGad=ygad;
 }
}

/* Close move window */
void CloseMoveWindow(void)
{
 RemoveGList(MoveWindowPtr,&g,-1);
 CloseWindowSafely(MoveWindowPtr);
 MoveWindowPtr=NULL;
}

/* Handle move window IDCMP events */
void *HandleMoveWindowIDCMP(struct IntuiMessage *msg)
{
 ULONG val;

 /* Window moved in X? */
 if ((val=MoveWindowPtr->LeftEdge)!=OldX) {
  /* Yes, set new value */
  OldX=val;
  GT_SetGadgetAttrs(XGad,GadWindow,NULL,GTIN_Number,val-MoveWindowOffX,
                                        TAG_DONE);
 }

 /* Window moved in Y? */
 if ((val=MoveWindowPtr->TopEdge)!=OldY) {
  /* Yes, set new value */
  OldY=val;
  GT_SetGadgetAttrs(YGad,GadWindow,NULL,GTIN_Number,val-MoveWindowOffY,
                                        TAG_DONE);
 }

 /* All OK! */
 return(NULL);
}
