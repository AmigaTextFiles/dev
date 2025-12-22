#include "Geometry.h"

/*
  Just a crude demo of Geometry Engine.

*/

struct IntuitionBase *IntuitionBase;
struct Library *GadToolsBase;

struct TagItem fonttags[] =
{
  TA_DeviceDPI,100<<16 | 50,
  TAG_DONE
};

struct TTextAttr FontAttr =
{
  "cgtimes.font",
  12,
  FSF_TAGGED,
  FPF_DISKFONT,
  fonttags,
};

STRPTR CycleLabels[] =
{
  "The wheels",
  "Of the bus",
  "Go round",
  "And round..",
  NULL
};

VOID process_window_events(GUI *MyGUI);

void main(void)
{
  GUI *MyGUI;

  IntuitionBase = (struct IntuitionBase *)OpenLibrary("intuition.library", 37);
  GadToolsBase = OpenLibrary("gadtools.library", 37);

  if (MyGUI = GE_CreateGUI(GE_FontAttr, &FontAttr, TAG_DONE));

  if (MyGUI->Geom =
    GE_CreateGeometry(GYF_VERT | GYF_RAISED,1,1,
      GE_Child, GE_CreateGeometry(GYF_HORIZ | GYF_RAISED,1,1,
	GE_Child, GE_CreateGeometry(GYF_VERT | GYF_RAISED,0,1,
	  GE_Child, GE_CreateGT(1,0,TEXT_KIND, "Some gadgets here...",0,PLACETEXT_IN,GTTX_Border,TRUE,GTTX_Justification, GTJ_CENTER, TAG_DONE),
	  GE_Child, GE_CreateGT(0,0,CHECKBOX_KIND,"Check this out",1,PLACETEXT_LEFT,TAG_DONE),
	  GE_Child, GE_CreateGT(0,0,CHECKBOX_KIND,"No, check this one",2,PLACETEXT_LEFT,TAG_DONE),
	  GE_Child, GE_CreateGT(0,0,CHECKBOX_KIND,"No, ME!",3,PLACETEXT_RIGHT,TAG_DONE),
	  GE_Child, GE_CreateGT(1,1,PALETTE_KIND,"Pick a colour",1000,PLACETEXT_ABOVE,GTPA_Depth,MyGUI->DrInfo->dri_Depth,
									GTPA_Color,1,
									GTPA_IndicatorWidth, 20,
									/*GTPA_IndicatorHeight, 8,*/ TAG_DONE),
          TAG_DONE),
	GE_Child, GE_CreateGeometry(GYF_VERT | GYF_RAISED,2,1,
	  GE_Child, GE_CreateGT(2,0,BUTTON_KIND,"A Button",4,PLACETEXT_IN,TAG_DONE),
	  GE_Child, GE_CreateGT(2,2,LISTVIEW_KIND,"A Listview",5,PLACETEXT_BELOW,GTLV_ScrollWidth,16,TAG_DONE),
	  GE_Child, GE_CreateGT(2,0,CYCLE_KIND,"Cycle",6,PLACETEXT_LEFT,GTCY_Labels, CycleLabels, TAG_DONE),
	  GE_Child, GE_CreateGT(2,0,INTEGER_KIND,"Number",6,PLACETEXT_LEFT,GTIN_Number,42,GTIN_MaxChars,10, TAG_DONE),
	  GE_Child, GE_CreateGT(2,0,NUMBER_KIND,"Magic Number is:",6,PLACETEXT_LEFT,GTNM_Number,42,GTNM_Border,TRUE, TAG_DONE),
          TAG_DONE),
        TAG_DONE),
      GE_Child, GE_CreateGT(1,0,SLIDER_KIND,"Slider",1000,PLACETEXT_LEFT,GTSL_Min, 10, GTSL_Max,100,TAG_DONE),
      GE_Child, GE_CreateGT(1,0,SCROLLER_KIND,"Scroller",1000,PLACETEXT_LEFT,GTSC_Top, 5, GTSC_Visible,10,GTSC_Total, 30, GTSC_Arrows,18,TAG_DONE),
      GE_Child, GE_CreateGT(1,0,BUTTON_KIND,"Another Button",1000,PLACETEXT_IN,TAG_DONE),
    TAG_DONE)
  );

  GE_InitGeometry(MyGUI, TAG_DONE);

    if (GE_OpenWindow(MyGUI,
		WA_Title, "Geometry Demo",
		WA_Flags, WFLG_SIZEGADGET | WFLG_CLOSEGADGET | WFLG_ACTIVATE |
			  WFLG_DEPTHGADGET | WFLG_DRAGBAR | WFLG_SIMPLE_REFRESH,
                WA_IDCMP, IDCMP_CLOSEWINDOW | IDCMP_REFRESHWINDOW | IDCMP_NEWSIZE | BUTTONIDCMP | IDCMP_SIZEVERIFY,
		TAG_END))
    {
      process_window_events(MyGUI);

      GE_CloseWindow(MyGUI);
    }

    GE_FreeGUI(MyGUI);

  CloseLibrary(GadToolsBase);
  CloseLibrary((struct Library *)IntuitionBase);
}

VOID process_window_events(GUI *MyGUI)
{
  struct IntuiMessage *imsg;
  struct Gadget *gad;
  BOOL  terminated = FALSE;

  while (!terminated)
  {
    Wait (1 << MyGUI->Win->UserPort->mp_SigBit);

    /* Use GT_GetIMsg() and GT_ReplyIMsg() for handling */
    /* IntuiMessages with GadTools gadgets.             */
    while ((!terminated) && (imsg = GT_GetIMsg(MyGUI->Win->UserPort)))
    {
      switch (imsg->Class)
      {
        case IDCMP_GADGETUP:       /* Buttons only report GADGETUP */
          gad = (struct Gadget *)imsg->IAddress;
//          if (gad->GadgetID == MYGAD_BUTTON) Printf("Button was pressed.\n");
          break;
        case IDCMP_CLOSEWINDOW:
          terminated = TRUE;
          break;
        case IDCMP_REFRESHWINDOW:
          /* This handling is REQUIRED with GadTools. */
          GT_BeginRefresh(MyGUI->Win);
	  //** Draw Geometry stuff
	  GE_RenderGeometry(MyGUI,TAG_DONE);
          GT_EndRefresh(MyGUI->Win, TRUE);
          break;
	case IDCMP_SIZEVERIFY:
	  //** Preliminary calculations...
	  GE_BeginResizeGeometry(MyGUI,TAG_DONE);
	  //** Quick, reply this message -- never keep the user waiting!
	  GT_ReplyIMsg(imsg);
	  //** Do some more stuff while the user twiddles the size.
	  GE_BeginResizeGeometry(MyGUI,TAG_DONE);
	  continue;
	case IDCMP_NEWSIZE:
	  GE_ResizeGeometry(MyGUI,TAG_DONE);
	  GE_RenderGeometry(MyGUI,TAG_DONE);
	  break;
      }
      /* Use the toolkit message-replying function here... */
      GT_ReplyIMsg(imsg);
    }
  }
}
