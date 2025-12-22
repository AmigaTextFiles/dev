/*
 *  Source generated with GadToolsBox V1.0
 *  which is (c) Copyright 1991 Jaba Development
 */

#include <exec/types.h>
#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <libraries/gadtools.h>
#include <graphics/displayinfo.h>
#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/gadtools_protos.h>

#define GD_BUTTON                          	0
#define GD_STRING                          	1
#define GD_LISTVOEW                        	2

static struct Window		*Wnd = 0l;
static struct Screen		*Scr = 0l;
static APTR			VisualInfo = 0l;
static struct Gadget		*GList = 0l;
static struct Gadget		*Gadgets[3];

static struct TextAttr topaz8 = {
	( STRPTR )"topaz.font", 8, 0x00, 0x01 };

static struct TagItem	WindowTags[] = {
	WA_Left,		  10,
	WA_Top,		   15,
	WA_Width,		 213,
	WA_Height,		141,
	WA_IDCMP,		 IDCMP_MOUSEBUTTONS|IDCMP_MOUSEMOVE|IDCMP_GADGETDOWN|IDCMP_GADGETUP|IDCMP_CLOSEWINDOW|IDCMP_INTUITICKS|IDCMP_REFRESHWINDOW,
	WA_Flags,		 WFLG_SIZEGADGET|WFLG_DRAGBAR|WFLG_DEPTHGADGET|WFLG_CLOSEGADGET|WFLG_SMART_REFRESH|WFLG_ACTIVATE,
	WA_Gadgets,	   0l,
	WA_Title,		 (ULONG)"Work Window",
	WA_ScreenTitle,   (ULONG)"GadToolsBox v1.0 © 1991",
	WA_CustomScreen,  0l,
	WA_MinWidth,	  67,
	WA_MinHeight,	 21,
	WA_MaxWidth,	  640,
	WA_MaxHeight,	 400,
	TAG_DONE };

static struct ColorSpec  ScreenColors[] = {
	~0, 0x00, 0x00, 0x00 };

static UWORD			 DriPens[] = {
	~0 };

static struct TagItem	ScreenTags[] = {
	SA_Left,		  0,
	SA_Top,		   0,
	SA_Width,		 640,
	SA_Height,		400,
	SA_Depth,		 2,
	SA_Colors,		ScreenColors,
	SA_Font,		  &topaz8,
	SA_Type,		  CUSTOMSCREEN,
	SA_DisplayID,	 NTSC_MONITOR_ID|HIRESLACE_KEY,
	SA_Pens,		  DriPens,
	TAG_DONE };

static long InitStuff( void )
{
	struct NewGadget	 ng;
	struct Gadget	   *g;

	if ( NOT( Scr = OpenScreenTagList( 0l, ScreenTags )))
		return( 1l );

	WindowTags[ 9 ].ti_Data = (ULONG)Scr;

	if ( NOT( VisualInfo = GetVisualInfo( Scr, TAG_DONE )))
		return( 2l );

	if ( NOT( g = CreateContext( &GList )))
		return( 3l );

	ng.ng_LeftEdge		=	8;
	ng.ng_TopEdge		 =	13;
	ng.ng_Width		   =	61;
	ng.ng_Height		  =	14;
	ng.ng_GadgetText	  =	"_Button";
	ng.ng_TextAttr		=	&topaz8;
	ng.ng_GadgetID		=	GD_BUTTON;
	ng.ng_Flags		   =	PLACETEXT_IN;
	ng.ng_VisualInfo	  =	VisualInfo;

	g = CreateGadget( BUTTON_KIND, g, &ng, GT_Underscore, '_', TAG_DONE );

	Gadgets[ 0 ] = g;

	ng.ng_LeftEdge		=	96;
	ng.ng_TopEdge		 =	33;
	ng.ng_Width		   =	95;
	ng.ng_Height		  =	12;
	ng.ng_GadgetText	  =	"_String";
	ng.ng_GadgetID		=	GD_STRING;
	ng.ng_Flags		   =	PLACETEXT_LEFT;

	g = CreateGadget( STRING_KIND, g, &ng, GTST_MaxChars, 256, TAG_DONE );

	Gadgets[ 1 ] = g;

	ng.ng_LeftEdge		=	7;
	ng.ng_TopEdge		 =	62;
	ng.ng_Width		   =	186;
	ng.ng_Height		  =	75;
	ng.ng_GadgetText	  =	"_ListView";
	ng.ng_GadgetID		=	GD_LISTVOEW;
	ng.ng_Flags		   =	PLACETEXT_ABOVE|NG_HIGHLABEL;

	g = CreateGadget( LISTVIEW_KIND, g, &ng, GTLV_Labels, ~0, TAG_DONE );

	Gadgets[ 2 ] = g;

	if ( NOT g )
		return( 4l );

	WindowTags[ 6 ].ti_Data = (ULONG)GList;

	if ( NOT( Wnd = OpenWindowTagList( 0l, WindowTags )))
		return( 5l );

	GT_RefreshWindow( Wnd, 0l );

	return( 0l );
}

void CleanStuff( void )
{
	if ( Wnd		)
		CloseWindow( Wnd );

	if ( GList	  )
		FreeGadgets( GList );

	if ( VisualInfo )
		FreeVisualInfo( VisualInfo );

	if ( Scr		)
		CloseScreen( Scr );
}
