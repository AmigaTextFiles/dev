/*
**	$VER: Gauge.c 1.1 (26.1.97)
**
**	Gauge.c -- An implementation of a progress requester as per the
**	           Amiga User Interface Style Guide.
**
**	Copyright © 1997 by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
**		Freely Distributable
*/

#include <intuition/intuitionbase.h>
#include <intuition/gadgetclass.h>
#include <intuition/imageclass.h>
#include <intuition/classusr.h>

#include <graphics/videocontrol.h>
#include <graphics/gfxmacros.h>

#include <exec/memory.h>

#include <clib/macros.h>

#include <clib/intuition_protos.h>
#include <clib/graphics_protos.h>
#include <clib/utility_protos.h>
#include <clib/exec_protos.h>
#include <clib/alib_protos.h>

#include <string.h>
#include <stdarg.h>

#include "gauge.h"

/***************************************************************************/

void kprintf(const char *,...);

/***************************************************************************/

	/* For quick casting. */

#define G(o) ((struct Gadget *)o)
#define I(o) ((struct Image *)o)

/***************************************************************************/

extern struct Library *IntuitionBase;
extern struct Library *GfxBase;
extern struct Library *UtilityBase;
extern struct Library *SysBase;

/***************************************************************************/

STATIC STRPTR Percent = "  0%100%";

/***************************************************************************/

	/* This is what NewGaugeA() will return. */

struct Gauge
{
	struct Window	*Window;
	struct Window	*Parent;
	struct Screen	*Screen;
	struct Screen	*PubScreen;
	LONG		 LeftPercentWidth;
	LONG		 RightPercentWidth;
	Object		*ButtonGadget;
	Object		*ButtonImage;
	Object		*BackgroundImage;
	Object		*BackgroundFrameImage;
	struct DrawInfo	*DrawInfo;
	struct Gadget	 BackgroundGadget;
	Class		*GaugeClass;
	Object		*GaugeObject;
	Object		*GaugeFrameImage;
	LONG		 FillSize;
	LONG		 FillLeft;
	LONG		 Space;
	struct MsgPort	*UserPort;
	BOOL		 UnlockPubScreen;
};

	/* The special info attached to the private gauge fill class. */

struct GaugeInfo
{
	struct Gauge	*Gauge;
	WORD		 Fill;
	WORD		 Flags;
};

	/* Control tags for the gauge fill class. */

#define GAUGE_Data	(TAG_USER+0x777)
/*#define GAUGE_Fill	(TAG_USER+0x778)*/

	/* Bit numbers for the update procedure. */

enum
{
	GAUGEB_Fill,
	GAUGEB_Frame
};

	/* Bit field definitions made from the above. */

#define GAUGEF_Fill	(1<<GAUGEB_Fill)
#define GAUGEF_Frame	(1<<GAUGEB_Frame)

/***************************************************************************/

	/* This works like TextLength() but takes negative
	 * kerning into account.
	 */

STATIC LONG
TextWidth(struct RastPort *RPort,STRPTR String,LONG Len)
{
	struct TextExtent Extent;

	TextFit(RPort,String,(Len < 0) ? strlen(String) : Len,&Extent,NULL,1,32767,32767);

	return(Extent.te_Width - Extent.te_Extent.MinX);
}

STATIC VOID
FillBox(struct RastPort *RPort,LONG Left,LONG Top,LONG Width,LONG Height)
{
	if(Width > 0 && Height > 0)
		RectFill(RPort,Left,Top,Left + Width - 1,Top + Height - 1);
}

	/* This implements the GM_RENDER method. */

STATIC ULONG
RenderMethod(Class *class,Object *object,struct gpRender *msg)
{
	struct GaugeInfo *GaugeInfo = INST_DATA(class,object);
	LONG Left,Top,Width,Height;
	struct RastPort *RPort;
	UWORD *Pens;
	LONG Flags;

		/* If this is a complete update, redraw everything. */

	if(msg->gpr_Redraw == GREDRAW_REDRAW)
		Flags = (GAUGEF_Fill|GAUGEF_Frame);
	else
		Flags = GaugeInfo->Flags;

		/* Reset these for good. */

	GaugeInfo->Flags = 0;

		/* Get the object's position and size. */

	Left	= G(object)->LeftEdge;
	Top	= G(object)->TopEdge;
	Width	= G(object)->Width;
	Height	= G(object)->Height;

		/* Handy shortcuts. */

	RPort	= msg->gpr_RPort;
	Pens	= msg->gpr_GInfo->gi_DrInfo->dri_Pens;

		/* Draw the frame and text around the fill gauge? */

	if(Flags & GAUGEF_Frame)
	{
			/* This draws the frame. */

		DrawImage(RPort,(struct Image *)GaugeInfo->Gauge->GaugeFrameImage,Left + GaugeInfo->Gauge->FillLeft,Top);

			/* And all this below draws the 0% and 100% labels. */

		SetAPen(RPort,Pens[TEXTPEN]);
		SetDrMd(RPort,JAM1);

		Move(RPort,Left + GaugeInfo->Gauge->FillLeft - (GaugeInfo->Gauge->Space + GaugeInfo->Gauge->LeftPercentWidth),Top + RPort->TxBaseline);
		Text(RPort,Percent,4);

		Move(RPort,Left + GaugeInfo->Gauge->FillLeft + GaugeInfo->Gauge->FillSize + GaugeInfo->Gauge->Space,Top + RPort->TxBaseline);
		Text(RPort,&Percent[4],4);
	}

		/* Draw the fill gauge? */

	if(Flags & GAUGEF_Fill)
	{
		LONG RightFill,LeftFill;
		LONG Fill;

		SetDrMd(RPort,JAM2);

		Left += GaugeInfo->Gauge->FillLeft;

		Fill = GaugeInfo->Fill;

		LeftFill	= (GaugeInfo->Gauge->FillSize * Fill) / 100;
		RightFill	= GaugeInfo->Gauge->FillSize - LeftFill;

		if(LeftFill > 0)
		{
			SetAPen(RPort,Pens[FILLPEN]);
			FillBox(RPort,Left,Top,LeftFill,Height);
		}

		if(RightFill > 0)
		{
			SetAPen(RPort,Pens[BACKGROUNDPEN]);
			FillBox(RPort,Left + GaugeInfo->Gauge->FillSize - RightFill,Top,RightFill,Height);
		}
	}

	return(1);
}

	/* This implements the OM_NEW method. */

STATIC ULONG
NewMethod(Class *class,Object *object,struct opSet *msg)
{
		/* Let the superclass do its work. */

	if(object = (Object *)DoSuperMethodA(class,object,(Msg)msg))
	{
			/* Set any attributes passed in via the OM_NEW method. */

		DoMethod(object,OM_SET,msg->ops_AttrList,NULL);
	}

	return((ULONG)object);
}

	/* This implements the OM_SET method. */

STATIC VOID
SetMethod(Class *class,Object *object,struct opSet *msg)
{
	struct GaugeInfo *GaugeInfo = INST_DATA(class,object);
	struct TagItem *List,*Item;
	LONG Flags;

		/* This is where we will record the bits to change
		 * and redraw.
		 */

	Flags = 0;

		/* Scan the attribute list. */

	List = msg->ops_AttrList;

	while(Item = NextTagItem(&List))
	{
		switch(Item->ti_Tag)
		{
				/* The gauge data link. This is from the initial
				 * data passed during OM_NEW.
				 */

			case GAUGE_Data:

				GaugeInfo->Gauge = (struct Gauge *)Item->ti_Data;
				break;

				/* Gauge fill value (between 0 and 100). */

			case GAUGE_Fill:

				GaugeInfo->Fill = (LONG)Item->ti_Data;
				Flags |= GAUGEF_Fill;

				if(GaugeInfo->Fill > 100)
					GaugeInfo->Fill = 100;
				else if(GaugeInfo->Fill < 0)
					GaugeInfo->Fill = 0;

				break;
		}
	}

		/* If there is something to update, do just that. */

	if(Flags && msg->ops_GInfo)
	{
		struct RastPort *RPort;

		if(RPort = ObtainGIRPort(msg->ops_GInfo))
		{
				/* So the render method knows what to update. */

			GaugeInfo->Flags = Flags;

				/* Update its imagery. */

			DoMethod(object,GM_RENDER,msg->ops_GInfo,RPort,GREDRAW_UPDATE);

			ReleaseGIRPort(RPort);
		}
	}
}

	/* This is the fill gauge class dispatcher. */

STATIC ULONG
GaugeClassDispatch(Class *class,Object *object,Msg msg)
{
	extern void geta4(void);

	geta4();

	switch(msg->MethodID)
	{
		case GM_RENDER:

			return(RenderMethod(class,object,(struct gpRender *)msg));

		case OM_NEW:

			return(NewMethod(class,object,(struct opSet *)msg));

		case OM_SET:
		case OM_UPDATE:

			SetMethod(class,object,(struct opSet *)msg);
			break;
	}

	return(DoSuperMethodA(class,object,msg));
}

/***************************************************************************/

	/* This is to find out how large the visible portion of the screen
	 * is and where this portion's top left corner is.
	 */

STATIC VOID
GetScreenInfo(struct Screen *Screen,LONG *Left,LONG *Top,LONG *Width,LONG *Height)
{
	struct TagItem Tags[2] = { VTAG_VIEWPORTEXTRA_GET, NULL, TAG_DONE };
	struct ViewPortExtra *Extra;

	if(!VideoControl(Screen->ViewPort.ColorMap,Tags))
		Extra = (struct ViewPortExtra *)Tags[0].ti_Data;
	else
		Extra = NULL;

	if(Extra)
	{
		struct Rectangle Clip;

		QueryOverscan(GetVPModeID(&Screen->ViewPort),&Clip,OSCAN_TEXT);

		*Width	= Extra->DisplayClip.MaxX - Extra->DisplayClip.MinX + 1;
		*Height	= Extra->DisplayClip.MaxY - Extra->DisplayClip.MinY + 1;

		if(*Width < Clip.MaxX - Clip.MinX + 1)
			*Width = Clip.MaxX - Clip.MinX + 1;

		if(*Height < Clip.MaxY - Clip.MinY + 1)
			*Height = Clip.MaxY - Clip.MinY + 1;
	}
	else
	{
		*Width	= Screen->Width;
		*Height	= Screen->Height;
	}

	*Left	= ABS(Screen->LeftEdge);
	*Top	= ABS(Screen->TopEdge);

	if(*Left > Screen->Width || *Left < 0)
		*Left = 0;

	if(*Top > Screen->Height || *Top < 0)
		*Top = 0;
}

	/* This centres the window within the visible bounds of a screen,
	 * but actually it just fills in the window coordinates.
	 */

STATIC VOID
CentreWindow(struct Screen *Screen,LONG Width,LONG Height,LONG *Left,LONG *Top)
{
	LONG ScreenWidth,ScreenHeight,ScreenLeft,ScreenTop;

	GetScreenInfo(Screen,&ScreenLeft,&ScreenTop,&ScreenWidth,&ScreenHeight);

	*Left	= ScreenLeft + (ScreenWidth - Width) / 2;
	*Top	= ScreenTop + (ScreenHeight - Height) / 2;
}

/***************************************************************************/

/****** gauge/GetGaugeA ******************************************
*
*   NAME
*	GetGaugeA -- Obtain information about the gauge display.
*
*   SYNOPSIS
*	Attributes = GetGaugeA(Gauge,TagList)
*
*	LONG GetGaugeA(struct Gauge *,struct TagItem *);
*
*	Attributes = GetGauge(Gauge,Tags);
*
*	LONG GetGauge(struct Gauge *,...);
*
*   FUNCTION
*	The Gauge structure is meant to be opaque, you should not peek
*	inside to find the information you need, such as the pointer
*	to the Window the display is built on top of. Rather, use this
*	routine to find out about it. This routine also provides means
*	to find out if a user has hit the "Stop" button.
*
*   INPUTS
*	Gauge - Pointer to a Gauge structure as created by NewGaugeA().
*	    NULL is a valid parameter.
*
*	TagList - Pointer to a table of TagItem structures.
*	    NULL is a valid parameter.
*
*	If you provide a tag list, the following item types are valid:
*
*	GAUGE_MsgPort (struct MsgPort *) - Pointer to the port IntuiMessages
*	    arrive at the gauge Window.
*
*	GAUGE_Window (struct Window *) - Pointer to the Window the progress
*	    requester is built on top of. If the gauge display is using a shared
*	    message arrival port, you can use the Window pointer to find out if
*	    an input event was meant for the gauge display rather than a different
*	    Window.
*
*	GAUGE_Hit (LONG) - If the user hit the "Stop" button, this routine will
*	    return TRUE, FALSE otherwise.
*
*	GAUGE_SigBit (LONG) - Provides the signal bit of the message arrival
*	    port the gauge Window uses.
*
*   RESULT
*	Attributes - Number of attributes this function could provide
*	    information on.
*
*   EXAMPLE
*	\* Find out whether the user has hit the "Stop" button. *\
*
*	LONG stop;
*
*	if(GetGauge(gauge,
*	    GAUGE_Hit,&stop,
*	TAG_END) == 1)
*	{
*	    if(stop)
*	        printf("user wants to stop the work in progress.\n");
*	    else
*	        printf("the work in progress can continue.\n");
*	}
*	else
*	{
*	    printf("something is wrong.\n");
*	}
*
*   NOTES
*	If this function returns a number smaller than the actual number
*	of attributes you inquired about, some of the variables you have
*	provided will not be initialized.
*
*   SEE ALSO
*	NewGaugeA
*	gadtools.library/GT_GetGadgetAttrs
*
*****************************************************************************
*
*/

LONG
GetGaugeA(struct Gauge *Gauge,struct TagItem *TagList)
{
	LONG Total;

	Total = 0;

	if(Gauge)
	{
		struct IntuiMessage *Message;
		struct TagItem *Item;

		while(Item = NextTagItem(&TagList))
		{
			switch(Item->ti_Tag)
			{
				case GAUGE_MsgPort:

					*(struct MsgPort **)Item->ti_Data = Gauge->Window->UserPort;
					Total++;
					break;

				case GAUGE_Window:

					*(struct Window **)Item->ti_Data = Gauge->Window;
					Total++;
					break;

				case GAUGE_Hit:

					if(Gauge->UserPort)
					{
						Forbid();

						*(LONG *)Item->ti_Data = FALSE;

						for(Message = (struct IntuiMessage *)Gauge->UserPort->mp_MsgList.lh_Head ; Message->ExecMessage.mn_Node.ln_Succ  ; Message = (struct IntuiMessage *)Message->ExecMessage.mn_Node.ln_Succ)
						{
							if(Message->IDCMPWindow == Gauge->Window && Message->Class == IDCMP_GADGETUP && Message->IAddress == G(Gauge->ButtonGadget))
							{
								*(LONG *)Item->ti_Data = TRUE;
								break;
							}
						}

						Permit();
					}
					else
					{
						if(SetSignal(0,0) & (1UL<<Gauge->Window->UserPort->mp_SigBit))
							*(LONG *)Item->ti_Data = TRUE;
						else
							*(LONG *)Item->ti_Data = FALSE;
					}

					Total++;

					break;

				case GAUGE_SigBit:

					*(LONG *)Item->ti_Data = Gauge->Window->UserPort->mp_SigBit;
					Total++;
					break;
			}
		}
	}

	return(Total);
}

/****** gauge/SetGaugeA ******************************************
*
*   NAME
*	SetGaugeA -- Change the title or the position of the
*	    progress indicator of the gauge display.
*
*   SYNOPSIS
*	SetGaugeA(Gauge,TagList)
*
*	VOID SetGaugeA(struct Gauge *Gauge,struct TagItem *);
*
*	SetGauge(Gauge,Tags);
*
*	VOID SetGauge(struct Gauge *,...);
*
*   FUNCTION
*	After you have opened the progress requester display, you
*	will want to change the indicator that shows how far the
*	work the requester represents has progressed. Occasionally,
*	the requester title may need changing, too, as work progresses
*	into a different phase.
*
*   INPUTS
*	Gauge - Pointer to a Gauge structure as created by NewGaugeA().
*	    NULL is a valid parameter.
*
*	TagList - Pointer to a table of TagItem structures.
*	    NULL is a valid parameter.
*
*	If you provide a tag list, the following item types are valid:
*
*	GAUGE_Title (STRPTR) - The gauge display bears a title which tells
*	    about the action in progress the display indicates. This title
*	    will be eventually be the title of the progress Window. Steps
*	    will be taken to make the progress gauge Window large enough to
*	    show the complete title.
*
*	GAUGE_Fill (LONG) - Progress is shown with a bar that grows from
*	    left to right. You specify how far the bar should grow with this
*	    tags in percentage, i.e. a value of 0 will show no bar, 50 will
*	    show a bar that covers half its maximum size and 100 will produce
*	    the complete bar. Any values outside this range will be truncated
*	    to the range.
*
*   EXAMPLE
*	\* Set the fill indicator to 70% *\
*
*	SetGauge(gauge,
*	    GAUGE_Fill, 70,
*	TAG_END);
*
*   SEE ALSO
*	NewGaugeA
*	intuition.library/SetAttrsA
*
*****************************************************************************
*
*/

VOID
SetGaugeA(struct Gauge *Gauge,struct TagItem *TagList)
{
	if(Gauge)
	{
		struct TagItem *Item;

		while(Item = NextTagItem(&TagList))
		{
			switch(Item->ti_Tag)
			{
				case GAUGE_Title:

					SetWindowTitles(Gauge->Window,(STRPTR)Item->ti_Data,(STRPTR)~0);
					break;

				case GAUGE_Fill:

					SetGadgetAttrs(G(Gauge->GaugeObject),Gauge->Window,NULL,
						GAUGE_Fill,Item->ti_Data,
					TAG_DONE);
					break;
			}
		}
	}
}

/****** gauge/DisposeGauge ******************************************
*
*   NAME
*	DisposeGauge -- Close a progress requester Window.
*
*   SYNOPSIS
*	DisposeGauge(Gauge)
*
*	VOID DisposeGauge(struct Gauge *);
*
*   FUNCTION
*	When you are finished with the work the progress gauge represents,
*	you should close the gauge Window. This routine will close the
*	display opened by NewGaugeA().
*
*   INPUTS
*	Gauge - Pointer to a Gauge structure as created by NewGaugeA().
*	    NULL is a valid parameter.
*
*   EXAMPLE
*	\* Close the gauge display *\
*
*	DisposeGauge(gauge);
*
*   SEE ALSO
*	NewGaugeA
*
*****************************************************************************
*
*/

VOID
DisposeGauge(struct Gauge *Gauge)
{
	if(Gauge)
	{
		if(Gauge->Window)
		{
			if(Gauge->UserPort && Gauge->Window->UserPort)
			{
				struct IntuiMessage *IntuiMsg;
				struct Node *Next;

				Forbid();

				for(IntuiMsg = (struct IntuiMessage *)Gauge->Window->UserPort->mp_MsgList.lh_Head ; Next = IntuiMsg->ExecMessage.mn_Node.ln_Succ ; IntuiMsg = (struct IntuiMessage *)Next)
				{
					if(IntuiMsg->IDCMPWindow == Gauge->Window)
					{
						Remove((struct Node *)IntuiMsg);

						ReplyMsg((struct Message *)IntuiMsg);
					}
				}

				Gauge->Window->UserPort = NULL;

				ModifyIDCMP(Gauge->Window,NULL);

				Permit();
			}

			CloseWindow(Gauge->Window);
		}

		DisposeObject(Gauge->ButtonImage);
		DisposeObject(Gauge->BackgroundImage);
		DisposeObject(Gauge->BackgroundFrameImage);
		DisposeObject(Gauge->ButtonGadget);
		DisposeObject(Gauge->GaugeObject);
		DisposeObject(Gauge->GaugeFrameImage);

		FreeScreenDrawInfo(Gauge->Screen,Gauge->DrawInfo);

		if(Gauge->GaugeClass)
			FreeClass(Gauge->GaugeClass);

		if(Gauge->UnlockPubScreen)
			UnlockPubScreen(NULL,Gauge->PubScreen);

		FreeVec(Gauge);
	}
}

/****** gauge/NewGaugeA ******************************************
*
*   NAME
*	NewGaugeA -- Create a progress gauge display requester
*
*   SYNOPSIS
*	Gauge = NewGaugeA(TagList)
*
*	struct Gauge *NewGaugeA(struct TagItem *);
*
*	Gauge = NewGauge(Tags);
*
*	struct Gauge *NewGauge(Tag firstTag,...);
*
*   FUNCTION
*	The "Amiga User Interface Style Guide" gives an example of how a
*	progress requester should look like (page 29). This example
*	lacks "teeth" as it just represents a visual cue, not something
*	you can work with--until you implement it. NewGaugeA() will create
*	such a progress requester.
*
*   INPUTS
*	You control the initial attributes of the gauge display with
*	tagitems:
*
*	GAUGE_Window (struct Window *) - The parent Window to "attach"
*	    the gauge to. The gauge display will appear on the same Screen
*	    as the parent Window, centred within the bounds of the Window.
*	    These are the only relations to the "parent" Window.
*
*	GAUGE_Screen (struct Screen *) - The Screen to open the gauge on.
*	    The gauge will appear centred within the visible part of
*	    this Screen.
*
*	GAUGE_PubScreen (struct Screen *) - Pointer to a Public Screen the
*	    gauge display should be opened on as a Visitor Window. The gauge
*	    will appear centred within the visible part of this Screen.
*
*	GAUGE_PubScreenName (STRPTR) - Name of a Public Screen the gauge
*	    display should be opened on as a Visitor Window. If the named
*	    Screen cannot be found, the display will default to open on the
*	    Default Public Screen. You can control the fall-back behaviour
*	    with the GAUGE_PubScreenFallback tag.
*
*	GAUGE_PubScreenFallback (BOOL) - If the named Public Screen the
*	    display is to open on cannot be found, the gauge display will
*	    default to open on the Default Public Screen. In most cases,
*	    this will be the Workbench Screen. This tag controls whether
*	    the fall-back will take place or whether the display will fail
*	    to open.
*	    (Default: TRUE)
*
*	GAUGE_UserPort (struct MsgPort *) - You can have multiple Windows
*	    sharing the IntuiMessage arrival MsgPort. If you with to share
*	    some other Window's arrival port with the gauge display, you
*	    can specify the port address with this tag.
*
*	GAUGE_ButtonLabel (STRPTR) - There is one single button in the
*	    gauge display, which when hit by the user indicates that
*	    whatever action in progress the gauge represents should be
*	    brought to a stop. By default, this button bears the label
*	    "Stop". You can provide a replacement label, such as for
*	    localization, using this tag.
*	    (Default: "Stop")
*
*	GAUGE_Title (STRPTR) - The gauge display bears a title which tells
*	    about the action in progress the display indicates. This title
*	    will be eventually be the title of the progress Window. Steps
*	    will be taken to make the progress gauge Window large enough to
*	    show the complete title.
*	    (Default: "")
*
*	GAUGE_Fill (LONG) - Progress is shown with a bar that grows from
*	    left to right. You specify how far the bar should grow with this
*	    tags in percentage, i.e. a value of 0 will show no bar, 50 will
*	    show a bar that covers half its maximum size and 100 will produce
*	    the complete bar. Any values outside this range will be truncated
*	    to the range.
*	    (Default: 0)
*
*   RESULT
*	Gauge - Pointer to a Gauge structure that represents the progress
*	    requester Window and its contents. You should not peek the data
*	    this structure holds, but use the GetGaugeA() function instead.
*	    If NewGaugeA() cannot create the progress display, it will return
*	    NULL.
*
*   EXAMPLE
*	\* Create the progress report Window and wait for the user to
*	 * hit the "Stop" button. Make it look like the example in
*	 * the "Amiga User Interface Style Guide".
*	 *\
*
*	struct Gauge *gauge;
*	struct MsgPort *port;
*
*	gauge = NewGauge(
*	    GAUGE_Title, "Rendering \"Boing.Ball\"",
*	    GAUGE_Fill,  40,
*	TAG_END);
*
*	if(gauge != NULL)
*	{
*	    GetGauge(&gauge,
*	        GAUGE_MsgPort,&port,
*	    TAG_END);
*
*	    WaitPort(port);
*
*	    DisposeGauge(gauge);
*	}
*
*   NOTES
*	Unless you provide a MsgPort to be used as the IntuiMessage
*	arrival port, this function will create one for you. To find
*	out about this port, use GetGaugeA().
*
*	If this function is not told about the Screen it should open
*	the progress requester Window on, it will default to opening
*	the Window on the Default Public Screen. Usually, this will
*	be the Workbench Screen.
*
*	The gauge Window contains one single button the user can
*	hit if the action the requester represents should be aborted.
*	In this event, an IDCMP_GADGETUP message will be generated.
*	This is the *only* type of event the gauge Window can generate.
*	Thus, when you receive any kind of input from this Window you
*	can be certain that the user wants to stop the work in progress.
*
*   SEE ALSO
*	intuition.library/OpenWindow
*	intuition.library/OpenWindowTagList
*
*****************************************************************************
*
*/

struct Gauge *
NewGaugeA(struct TagItem *TagList)
{
	struct Gauge *Gauge;

		/* Start by allocating memory for the data structures. */

	if(Gauge = (struct Gauge *)AllocVec(sizeof(struct Gauge),MEMF_ANY|MEMF_CLEAR))
	{
		STRPTR ButtonLabel,Title;
		LONG Fill;

		ButtonLabel	= (STRPTR)GetTagData(GAUGE_ButtonLabel,(ULONG)"Stop",TagList);
		Title		= (STRPTR)GetTagData(GAUGE_Title,(ULONG)"",TagList);
		Fill		= (LONG)GetTagData(GAUGE_Fill,0,TagList);
		Gauge->Parent	= (struct Window *)GetTagData(GAUGE_Window,NULL,TagList);
		Gauge->Screen	= (struct Screen *)GetTagData(GAUGE_Screen,NULL,TagList);
		Gauge->UserPort	= (struct MsgPort *)GetTagData(GAUGE_UserPort,NULL,TagList);

			/* If no parent window and screen are provided,
			 * use the default public screen instead.
			 */

		if(!Gauge->Screen && !Gauge->Parent)
		{
			Gauge->PubScreen = (struct Screen *)GetTagData(GAUGE_PubScreen,NULL,TagList);

			if(!Gauge->PubScreen)
			{
				STRPTR Name;

				Name = (STRPTR)GetTagData(GAUGE_PubScreenName,NULL,TagList);

				if(Name)
				{
					if(Gauge->PubScreen = LockPubScreen(Name))
						Gauge->UnlockPubScreen = TRUE;
					else
					{
						if(!GetTagData(GAUGE_PubScreenFallback,TRUE,TagList))
							return(NULL);
					}
				}
			}

			if(!Gauge->PubScreen)
			{
				if(!(Gauge->PubScreen = LockPubScreen(NULL)))
					return(NULL);
				else
				{
					Gauge->Screen = Gauge->PubScreen;
					Gauge->UnlockPubScreen = TRUE;
				}
			}
		}

			/* Now check which screen to use. */

		if(!Gauge->Screen)
			Gauge->Screen = Gauge->Parent->WScreen;

			/* Get the screen drawing info and create the private
			 * gauge fill class.
			 */

		Gauge->DrawInfo		= GetScreenDrawInfo(Gauge->Screen);
		Gauge->GaugeClass	= MakeClass(NULL,GADGETCLASS,NULL,sizeof(struct GaugeInfo),0);

			/* Did we get what we wanted? */

		if(Gauge->DrawInfo && Gauge->GaugeClass)
		{
			STATIC UWORD Crosshatch[] = { 0x5555, 0xAAAA };
			extern ULONG HookEntry( struct Hook *, Object *, APTR );

				/* Fill in the class dispatcher. */

			Gauge->GaugeClass->cl_Dispatcher.h_Entry = (HOOKFUNC)HookEntry;
			Gauge->GaugeClass->cl_Dispatcher.h_SubEntry = (HOOKFUNC)GaugeClassDispatch;

				/* Create the cross-hatch window background. */

			Gauge->BackgroundImage = NewObject(NULL,FILLRECTCLASS,
				IA_APattern,	Crosshatch,
				IA_APatSize,	1,
				IA_Mode,	JAM2,
				IA_FGPen,	Gauge->DrawInfo->dri_Pens[SHINEPEN],
				IA_BGPen,	Gauge->DrawInfo->dri_Pens[BACKGROUNDPEN],
			TAG_DONE);

				/* Create the frame within the background. */

			Gauge->BackgroundFrameImage = NewObject(NULL,FRAMEICLASS,
				IA_Recessed,	TRUE,
			TAG_DONE);

				/* Create the frame to surround the gauge fill bar. */

			Gauge->GaugeFrameImage = NewObject(NULL,FRAMEICLASS,
				IA_Recessed,	TRUE,
				IA_EdgesOnly,	TRUE,
			TAG_DONE);

				/* Create the frame to be placed around the gauge
				 * button and if this succeeds, create the
				 * button itself.
				 */

			if(Gauge->ButtonImage = NewObjectA(NULL,FRAMEICLASS,NULL))
			{
				Gauge->ButtonGadget = NewObject(NULL,FRBUTTONCLASS,
					GA_Text,	ButtonLabel,
					GA_Image,	Gauge->ButtonImage,
					GA_RelVerify,	TRUE,
					GA_DrawInfo,	Gauge->DrawInfo,
				TAG_DONE);
			}

				/* Did we get everything we wanted? */

			if(Gauge->ButtonImage &&
			   Gauge->BackgroundImage &&
			   Gauge->BackgroundFrameImage &&
			   Gauge->ButtonGadget &&
			   Gauge->GaugeFrameImage)
			{
				LONG Size,Max,InteriorWidth,InteriorHeight;
				struct TextExtent Extent;
				struct RastPort RastPort;
				LONG DistX,DistY;
				ULONG TitleWidth,DepthWidth;
				Object *DepthImage;
				struct IBox FrameBox,ContentsBox;

					/* Check how wide the window depth arrangement
					 * gadget will become.
					 */

				if(DepthImage = NewObject(NULL,SYSICLASS,
					SYSIA_Size,	(Gauge->Screen->Flags & SCREENHIRES) ? SYSISIZE_MEDRES : SYSISIZE_LOWRES,
					SYSIA_Which,	DEPTHIMAGE,
					SYSIA_DrawInfo,	Gauge->DrawInfo,
				TAG_DONE))
				{
					GetAttr(IA_Width,DepthImage,&DepthWidth);

					DisposeObject(DepthImage);
				}
				else
					DepthWidth = (Gauge->Screen->Flags & SCREENHIRES) ? 23 : 17;

					/* We need a RastPort to measure font sizes, so we
					 * set up one here.
					 */

				InitRastPort(&RastPort);
				SetFont(&RastPort,Gauge->DrawInfo->dri_Font);

					/* This is how wide the window title will become. */

				TitleWidth = TextWidth(&RastPort,Title,strlen(Title)) + 2 + DepthWidth;

					/* Find out how large the gauge button will become.
					 * We'll use this information in a minute.
					 */

				TextFit(&RastPort,ButtonLabel,strlen(ButtonLabel),&Extent,NULL,1,32767,32767);

					/* This determines the layout distances. The screen
					 * aspect ratio is taken into account.
					 */

				DistY = 2;
				DistX = (DistY * Gauge->DrawInfo->dri_Resolution.Y) / Gauge->DrawInfo->dri_Resolution.X;

					/* Now set up the button size. We must do this after
					 * creating the button. If we set the size in the
					 * NewObject() call the button will ignore it.
					 */

				SetGadgetAttrs(G(Gauge->ButtonGadget),NULL,NULL,
					GA_DrawInfo,	Gauge->DrawInfo,
					GA_Width,	4*DistX + Extent.te_Width - Extent.te_Extent.MinX,
					GA_Height,	4*DistY + Extent.te_Height,
				TAG_DONE);

					/* We need to fit the frame around the fill
					 * gauge. To find out how large this frame
					 * would become, we tell the frame image to
					 * determine its layout size.
					 */

				FrameBox.Left	= 0;
				FrameBox.Top	= 0;
				FrameBox.Width	= 10;
				FrameBox.Height	= 10;

				DoMethod(Gauge->GaugeFrameImage,IM_FRAMEBOX,&FrameBox,&ContentsBox,Gauge->DrawInfo,0);

					/* Determine how much room the 0% and 100% text will occupy. */

				Gauge->LeftPercentWidth		= TextWidth(&RastPort,Percent,4);
				Gauge->RightPercentWidth	= TextWidth(&RastPort,&Percent[4],4);
				Gauge->Space			= (4 * DistX) + (FrameBox.Width - 10);

				Max = 2 * Gauge->Space + Gauge->LeftPercentWidth + 100 + Gauge->RightPercentWidth;

					/* Make sure that the gauge display will be wide enough. */

				if(3 * G(Gauge->ButtonGadget)->Width > Max)
					Max = 3 * G(Gauge->ButtonGadget)->Width;

					/* We want the entire title to be visible. This is why
					 * we inquired about the widths of the window depth
					 * arrangement gadget and the title text.
					 */

				if(TitleWidth > Max)
					Max = TitleWidth;

					/* Now we can set up the size of the interior
					 * window area.
					 */

				InteriorWidth	= DistX * 4 + Max + DistX * 4;
				InteriorHeight	= DistY * 4 + Extent.te_Height + DistY * 4;

					/* Guess I'm the first guy who uses the golden section
					 * for the gadget layout.
					 */

				Size = (1618 * InteriorHeight) / 1000;

				if(Size > InteriorWidth)
					InteriorWidth = Size;

					/* All the image data will be attached to one
					 * dummy gadget that goes into the window
					 * background.
					 */

				Gauge->BackgroundGadget.LeftEdge	= Gauge->Screen->WBorLeft;
				Gauge->BackgroundGadget.TopEdge		= Gauge->Screen->WBorTop + Gauge->Screen->Font->ta_YSize + 1;
				Gauge->BackgroundGadget.Flags		= GFLG_GADGIMAGE|GFLG_GADGHNONE;
				Gauge->BackgroundGadget.GadgetRender	= Gauge->BackgroundImage;
				Gauge->BackgroundGadget.Width		= DistX * 4 + InteriorWidth + DistX * 4;
				Gauge->BackgroundGadget.Height		= DistY * 4 + InteriorHeight + DistY * 2 + G(Gauge->ButtonGadget)->Height + DistY * 2;

					/* Link the two images together. I wish there were
					 * an imageclass attribute to do this.
					 */

				I(Gauge->BackgroundImage)->NextImage = I(Gauge->BackgroundFrameImage);

					/* Now find out how wide the fill gauge will be
					 * and where it should be placed.
					 */

				Gauge->FillSize	= InteriorWidth - (2 * Gauge->Space + Gauge->LeftPercentWidth + Gauge->RightPercentWidth + 2 * DistX * 4);
				Gauge->FillLeft = Gauge->LeftPercentWidth + Gauge->Space;

					/* Now comes the magic part; we need to fit
					 * the frame around the fill gauge. This is
					 * done by telling the frame image how large
					 * the fill gauge will become and requesting
					 * that it should find the proper placement
					 * and size for this.
					 */

				FrameBox.Left	= 0;
				FrameBox.Top	= 0;
				FrameBox.Width	= Gauge->FillSize;
				FrameBox.Height	= Extent.te_Height;

				DoMethod(Gauge->GaugeFrameImage,IM_FRAMEBOX,&FrameBox,&ContentsBox,Gauge->DrawInfo,0);

					/* That's all, now make the coordinates and size permanent. */

				SetAttrs(Gauge->GaugeFrameImage,
					IA_Left,	ContentsBox.Left,
					IA_Top,		ContentsBox.Top,
					IA_Width,	ContentsBox.Width,
					IA_Height,	ContentsBox.Height,
				TAG_DONE);

					/* Make the cross-hatch window background as large
					 * as the dummy gadget.
					 */

				SetAttrs(Gauge->BackgroundImage,
					IA_Left,	0,
					IA_Top,		0,
					IA_Width,	Gauge->BackgroundGadget.Width,
					IA_Height,	Gauge->BackgroundGadget.Height,
				TAG_DONE);

					/* Put the frame into the top left corner of
					 * the background.
					 */

				SetAttrs(Gauge->BackgroundFrameImage,
					IA_Left,	DistX * 4,
					IA_Top,		DistY * 4,
					IA_Width,	InteriorWidth,
					IA_Height,	InteriorHeight,
				TAG_DONE);

					/* Centre the button within the window. */

				SetAttrs(Gauge->ButtonGadget,
					GA_Left,	Gauge->BackgroundGadget.LeftEdge + (Gauge->BackgroundGadget.Width - G(Gauge->ButtonGadget)->Width) / 2,
					GA_Top,		Gauge->BackgroundGadget.TopEdge	+ DistY * 4 + DistY * 4 + Extent.te_Height + DistY * 4 + DistY * 2,
				TAG_DONE);

					/* Now create the gauge display object. */

				if(Fill < 0)
					Fill = 0;
				else if (Fill > 100)
					Fill = 100;

				Gauge->GaugeObject = NewObject(Gauge->GaugeClass,NULL,
					GA_Left,	Gauge->BackgroundGadget.LeftEdge + DistX * 4 + DistX * 4,
					GA_Top,		Gauge->BackgroundGadget.TopEdge	+ DistY * 4 + DistY * 4,
					GA_Width,	InteriorWidth - (DistX * 4 + DistX * 4),
					GA_Height,	InteriorHeight - (DistY * 4 + DistY * 4),
					GA_Previous,	Gauge->ButtonGadget,
					GA_Next,	&Gauge->BackgroundGadget,
					GAUGE_Data,	Gauge,
					GAUGE_Fill,	Fill,
				TAG_DONE);

					/* Did we get what we wanted? */

				if(Gauge->GaugeObject)
				{
					LONG Left,Top,Width,Height;
					ULONG TagValue;

						/* Now determine the size of the window to open
						 * and its placement.
						 */

					Width	= Gauge->Screen->WBorLeft + Gauge->BackgroundGadget.Width + Gauge->Screen->WBorRight;
					Height	= Gauge->Screen->WBorTop + Gauge->Screen->Font->ta_YSize + 1 + Gauge->BackgroundGadget.Height + Gauge->Screen->WBorBottom;

					if(Gauge->Parent)
					{
						Left	= Gauge->Parent->LeftEdge + (Gauge->Parent->Width - Width) / 2;
						Top	= Gauge->Parent->TopEdge + (Gauge->Parent->Height - Height) / 2;
					}
					else
					{
						Left	= 0;
						Top	= 0;

						CentreWindow(Gauge->Screen,Width,Height,&Left,&Top);
					}

						/* Special treatment for public screens. */

					if(Gauge->PubScreen)
						TagValue = WA_PubScreen;
					else
						TagValue = WA_CustomScreen;

						/* Now open the window, putting it all together. */

					if(Gauge->Window = OpenWindowTags(NULL,
						WA_Left,	Left,
						WA_Top,		Top,
						WA_Width,	Width,
						WA_Height,	Height,
						WA_Title,	Title,
						WA_Flags,	WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_RMBTRAP | WFLG_NOCAREREFRESH | WFLG_SIMPLE_REFRESH | WFLG_ACTIVATE,
						WA_Gadgets,	Gauge->ButtonGadget,
						WA_IDCMP,	Gauge->UserPort ? NULL : IDCMP_GADGETUP,
						TagValue,	Gauge->Screen,
					TAG_DONE))
					{
						if(Gauge->UserPort)
						{
							Gauge->Window->UserPort = Gauge->UserPort;

							if(ModifyIDCMP(Gauge->Window,IDCMP_GADGETUP))
								return(Gauge);
							else
								Gauge->Window->UserPort = NULL;
						}
						else
							return(Gauge);
					}
				}
			}
		}

		DisposeGauge(Gauge);
	}

	return(NULL);
}

/***************************************************************************/

LONG
GetGauge(struct Gauge *Gauge,...)
{
	va_list VarArgs;
	LONG Result;

	va_start(VarArgs,Gauge);
	Result = GetGaugeA(Gauge,(struct TagItem *)VarArgs);
	va_end(VarArgs);

	return(Result);
}

VOID
SetGauge(struct Gauge *Gauge,...)
{
	va_list VarArgs;

	va_start(VarArgs,Gauge);
	SetGaugeA(Gauge,(struct TagItem *)VarArgs);
	va_end(VarArgs);
}

struct Gauge *
NewGauge(Tag tag1,...)
{
	return(NewGaugeA((struct TagItem *)&tag1));
}

/***************************************************************************/

/****** gauge/--background-- ******************************************
*
*   PURPOSE
*	The "Amiga User Interface Style Guide" contains an example of how
*	a progress requester should look like (page 29), but this example
*	has no "teeth". It is just a visual cue, you still have to implement
*	the requester yourself. Around Christmas Day, the issue was brought
*	up in comp.sys.amiga.programmer how to program these progress
*	requesters. This is my attempt at solving the problem.
*
*   GOALS
*	- The progress requester should be entirely self-contained and
*	  reentrant.
*	- It should be simple to find out if the user has hit the
*	  "Stop" button.
*	- Creation and management of the requester should follow a
*	  familiar model.
*	- The display should be font sensitive.
*
*   IMPLEMENTATION
*	The implementation consists of a set of BOOPSI objects, which are
*	linked together, plus a display element for the gauge. This is
*	similar to how Intuition builds system requesters and has the
*	advantage of delegating the work load of refreshing and maintaining
*	the display to Intuition. The application to create the display
*	just has to listen for the user to hit the "Stop" button, it need
*	not worry about housekeeping work.
*
*	The gauge creation code is reentrant, it was written with SAS/C
*	in mind. The only compiler dependant part is the custom class
*	dispatcher. You must initialize IntuitionBase, GfxBase,
*	UtilityBase and SysBase for the gauge code to work.
*
*   COPYRIGHT AND USAGE RESTRICTIONS
*	This implementation is Copyright © 1997 by Olaf `Olsen' Barthel.
*	It is freely distributable. I place no restrictions on its usage.
*	You may use this code in commercial software or shareware programs
*	without having to pay royalties to me. An acknowledgement would
*	still be nice, though :^) If you find bugs in the code or make
*	enhancements, please notify me. I would like to keep this code
*	updated, so everyone will be able to take advantage of it.
*
*	My electronic mail address:
*
*	    olsen@sourcery.han.de
*
*	My postal address:
*
*	    Olaf Barthel
*	    Brabeckstrasse 35
*	    D-30559 Hannover
*	    Federal Republic of Germany
*
*****************************************************************************
*
*/
