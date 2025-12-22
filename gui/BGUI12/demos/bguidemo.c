;/* Execute me to compile with DICE V3.0
dcc bguidemo.c -proto -mi -ms -mRR -lbgui
quit
*/
/*
 *	BGUIDEMO.C
 *
 *	(C) Copyright 1995 Jaba Development.
 *	(C) Copyright 1995 Jan van den Baard.
 *	    All Rights Reserved.
 */

#include "democode.h"

/*
**	Online-Help texts.
**/
UBYTE		*MainHelp		= ISEQ_C "BGUI is a shared library which offers a set of\n"
					  "BOOPSI classes to allow for easy and flexible GUI creation.\n\n"
					  "The main window is also an AppWindow. Drop some icons\n"
					  "on it and see what happens.\n\n"
					  "All windows also detect the aspect ratio of the screen they are\n"
					  "located on and adjust frame thickness accoording to this.\n\n"
					  "All other windows in this demo also have online-help. To access\n"
					  "this help press the " ISEQ_B "HELP" ISEQ_N " key when the window is active.";

UBYTE		*GroupsHelp		= ISEQ_C "The BGUI layout engine is encapsulated in the groupclass.\n"
					  "The groupclass will layout all of it's members into a specific area.\n"
					  "You can pass layout specific attributes to all group members\n"
					  "which allows for flexible and powerful layout capabilities.";

UBYTE		*NotifHelp		= ISEQ_C "Notification can be used to let an object keep one or\n"
					  "more other objects informed about it's status. BGUI offers several\n"
					  "kinds of notification of which two (conditional and map-list) are\n"
					  "shown in this demonstration.";

UBYTE		*InfoHelp		= ISEQ_C "Not much more can be said about the BGUI infoclass than\n"
					  "is said in this window. Except maybe that this text is shown in an\n"
					  "infoclass object as are all body texts from a BGUI requester.";

UBYTE		*ImageHelp		= ISEQ_C "This window shows you the built-in images that BGUI has\n"
					  "to offer. Ofcourse these images are all scalable and it is possible\n"
					  "to create your own, scalable, imagery with the BGUI vectorclass.";

UBYTE		*BackfillHelp		= ISEQ_C "Here you see the built-in backfill patterns BGUI supports.\n"
					  "These backfill patterns can all be used in groups and frames.\n"
					  "The frameclass also offers you the possibility to add hooks for\n"
					  "custom backfills and frame rendering.\n\n"
					  "The bottom frame shows you a custom backfill hook which renders a\n"
					  "simple pattern known from the WBPattern prefs editor as background.";

UBYTE		*PagesHelp		= ISEQ_C "The pageclass allows you to setup a set of pages containing\n"
					  "BGUI gadgets or groups. This will give you the oppertunity to\n"
					  "have several set's of gadgets in a single window.\n\n"
					  "This window has a IDCMP-hook installed which allows you to\n"
					  "control the Tabs object with your TAB key.";


/*
**	Window objects.
**/
Object		*WA_Main  = NULL, *WA_Groups = NULL, *WA_Notif = NULL;
Object		*WA_Info  = NULL, *WA_Image  = NULL, *WA_BFill = NULL;
Object		*WA_Pages = NULL;

/*
**	Gadget objects from the main window.
**/
Object		*BT_Groups,   *BT_Notif,    *BT_Quit;
Object		*BT_Info,     *BT_Images,   *BT_BFill;
Object		*BT_Pages,    *BT_IconDone, *BT_IconQuit;
Object		*LV_IconList, *PG_Pager;

/*
**	One, shared, message port for all
**	demo windows.
**/
struct MsgPort	*SharedPort;

/*
**	Menus & gadget ID's.
**/
#define ID_ABOUT		1L
#define ID_QUIT                 2L

/*
**	A small menu strip.
**/
struct NewMenu MainMenus[] = {
	Title( "Project" ),
		Item( "About...", "?", ID_ABOUT ),
		ItemBar,
		Item( "Quit",     "Q", ID_QUIT  ),
	End
};

/*
**	Put up a simple requester.
**/
ULONG Req( struct Window *win, UBYTE *gadgets, UBYTE *body, ... )
{
	struct bguiRequest	req = { NULL };

	req.br_GadgetFormat	= gadgets;
	req.br_TextFormat	= body;
	req.br_Flags		= BREQF_CENTERWINDOW|BREQF_XEN_BUTTONS|BREQF_AUTO_ASPECT;

	return( BGUI_RequestA( win, &req, ( ULONG * )( &body + 1 )));
}

/*
**	Main window button ID's.
**/
#define ID_MAIN_GROUPS		3L
#define ID_MAIN_NOTIF		4L
#define ID_MAIN_INFO		5L
#define ID_MAIN_IMAGE		6L
#define ID_MAIN_BFILL		7L
#define ID_MAIN_PAGES		8L
#define ID_MAIN_ICON_CONT	9L

/*
**	Open main window.
**/
struct Window *OpenMainWindow( ULONG *appmask )
{
	struct Window		*window = NULL;

	WA_Main = WindowObject,
		WINDOW_Title,		"BGUIDemo - (C) Jaba Development.",
		WINDOW_ScreenTitle,	"BGUIDemo - (C) Copyright 1993-1995 Jaba Development.",
		WINDOW_MenuStrip,	MainMenus,
		WINDOW_SmartRefresh,	TRUE,
		WINDOW_AppWindow,	TRUE,
		WINDOW_SizeGadget,	FALSE,
		WINDOW_HelpText,	MainHelp,
		WINDOW_AutoAspect,	TRUE,
		WINDOW_SharedPort,	SharedPort,
		WINDOW_MasterGroup,
			VGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing( 4 ), GROUP_BackFill, SHINE_RASTER,
				StartMember,
					PG_Pager = PageObject,
						/*
						**	Main page.
						**/
						PageMember,
							VGroupObject, Spacing( 4 ), GROUP_BackFill, SHINE_RASTER,
								StartMember,
									InfoObject,
										INFO_TextFormat,	ISEQ_C
													"BGUIDemo\n"
													ISEQ_HIGHLIGHT
													ISEQ_B
													"(C) Copyright 1993-1995 Jaba Development"
													ISEQ_TEXT
													ISEQ_N
													"\n\n"
													"Press the HELP key for more info.",
										INFO_FixTextWidth,	TRUE,
										INFO_MinLines,		4,
										INFO_HorizOffset,	13,
										FRM_Type,		FRTYPE_NEXT,
									EndObject,
								EndMember,
								StartMember,
									HGroupObject, Spacing( 4 ),
										StartMember,
											VGroupObject, Spacing( 4 ),
												StartMember, BT_Groups = XenKeyButton( "_Groups",       ID_MAIN_GROUPS ), EndMember,
												StartMember, BT_Notif  = XenKeyButton( "_Notification", ID_MAIN_NOTIF  ), EndMember,
												VarSpace( DEFAULT_WEIGHT ),
											EndObject,
										EndMember,
										StartMember,
											VGroupObject, Spacing( 4 ),
												StartMember, BT_Images = XenKeyButton( "_Images",       ID_MAIN_IMAGE  ), EndMember,
												StartMember, BT_BFill  = XenKeyButton( "_BackFill",     ID_MAIN_BFILL  ), EndMember,
												StartMember, BT_Quit   = XenKeyButton( "_Quit",         ID_QUIT        ), EndMember,
											EndObject,
										EndMember,
										StartMember,
											VGroupObject, Spacing( 4 ),
												StartMember, BT_Pages  = XenKeyButton( "_Pages",        ID_MAIN_PAGES  ), EndMember,
												StartMember, BT_Info   = XenKeyButton( "Info_Class",    ID_MAIN_INFO   ), EndMember,
												VarSpace( DEFAULT_WEIGHT ),
											EndObject,
										EndMember,
									EndObject, FixMinHeight,
								EndMember,
							EndObject,
						/*
						**	Icon-drop list page.
						**/
						PageMember,
							VGroupObject, Spacing( 4 ), GROUP_BackFill, SHINE_RASTER,
								StartMember,
									InfoObject,
										INFO_TextFormat,	ISEQ_C
													"The following icons where dropped\n"
													"in the window.",
										INFO_FixTextWidth,	TRUE,
										INFO_MinLines,		2,
										INFO_HorizOffset,	13,
										FRM_Type,		FRTYPE_BUTTON,
										FRM_Recessed,		TRUE,
									EndObject, FixMinHeight,
								EndMember,
								StartMember,
									LV_IconList = ListviewObject,
										LISTV_ReadOnly,         TRUE,
									EndObject,
								EndMember,
								StartMember,
									HGroupObject,
										StartMember, BT_IconDone = XenKeyButton( "_Continue", ID_MAIN_ICON_CONT ), EndMember,
										VarSpace( DEFAULT_WEIGHT ),
										StartMember, BT_IconQuit = XenKeyButton( "_Quit",     ID_QUIT ), EndMember,
									EndObject, FixMinHeight,
								EndMember,
							EndObject,
					EndObject,
				EndMember,
			EndObject,
	EndObject;

	/*
	**	Object created OK?
	**/
	if ( WA_Main ) {
		/*
		**	Add keys to the buttons.
		**/
		GadgetKey( WA_Main, BT_Groups,	 "g" );
		GadgetKey( WA_Main, BT_Notif,	 "n" );
		GadgetKey( WA_Main, BT_Info,	 "c" );
		GadgetKey( WA_Main, BT_Images,	 "i" );
		GadgetKey( WA_Main, BT_BFill,	 "b" );
		GadgetKey( WA_Main, BT_Pages,	 "p" );
		GadgetKey( WA_Main, BT_Quit,	 "q" );
		GadgetKey( WA_Main, BT_IconDone, "c" );
		GadgetKey( WA_Main, BT_IconQuit, "q" );
		/*
		**	Open the window.
		**/
		if ( window = WindowOpen( WA_Main )) {
			/*
			**	Obtain appwindow signal mask.
			**/
			GetAttr( WINDOW_AppMask, WA_Main, appmask );
		}
	}

	return( window );
}

/*
**	Macros for the group objects. GObj() creates
**	a simple infoclass object with some text in
**	it. TObj() creates a simple groupclass object
**	with a button frame.
**/
#define GObj(t)\
	InfoObject,\
		INFO_TextFormat,	t,\
		INFO_FixTextWidth,	TRUE,\
		INFO_HorizOffset,	4,\
		INFO_VertOffset,	3,\
		ButtonFrame,\
		FRM_Flags,		FRF_RECESSED,\
	EndObject

#define TObj\
	HGroupObject, HOffset( 3 ), VOffset( 2 ),\
		ButtonFrame,\
		FRM_Flags,		FRF_RECESSED,\
	EndObject

/*
**	Open up the groups window.
**/
struct Window *OpenGroupsWindow( void )
{
	struct Window			*window = NULL;

	/*
	**	If the object has not been created
	**	already we build it.
	**/
	if ( ! WA_Groups ) {
		WA_Groups = WindowObject,
			WINDOW_Title,		"BGUI Groups",
			WINDOW_RMBTrap,         TRUE,
			WINDOW_SmartRefresh,	TRUE,
			WINDOW_HelpText,	GroupsHelp,
			WINDOW_AutoAspect,	TRUE,
			WINDOW_SharedPort,	SharedPort,
			WINDOW_MasterGroup,
				VGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing( 4 ),
					StartMember,
						HGroupObject, Spacing( 4 ),
							StartMember,
								HGroupObject, NeXTFrame, FrameTitle( "Horizontal" ), HOffset( 8 ), TOffset( 4 ), BOffset( 6 ), Spacing( 4 ),
									StartMember, TObj, EndMember,
									StartMember, TObj, EndMember,
									StartMember, TObj, EndMember,
								EndObject,
							EndMember,
							StartMember,
								VGroupObject, NeXTFrame, FrameTitle( "Vertical" ), HOffset( 8 ), TOffset( 4 ), BOffset( 6 ), Spacing( 4 ),
									StartMember, TObj, EndMember,
									StartMember, TObj, EndMember,
									StartMember, TObj, EndMember,
								EndObject,
							EndMember,
							StartMember,
								VGroupObject, NeXTFrame, FrameTitle( "Grid" ), HOffset( 8 ), TOffset( 4 ), BOffset( 6 ), Spacing( 4 ),
									StartMember,
										HGroupObject, Spacing( 4 ),
											StartMember, TObj, EndMember,
											StartMember, TObj, EndMember,
											StartMember, TObj, EndMember,
										EndObject,
									EndMember,
									StartMember,
										HGroupObject, Spacing( 4 ),
											StartMember, TObj, EndMember,
											StartMember, TObj, EndMember,
											StartMember, TObj, EndMember,
										EndObject,
									EndMember,
									StartMember,
										HGroupObject, Spacing( 4 ),
											StartMember, TObj, EndMember,
											StartMember, TObj, EndMember,
											StartMember, TObj, EndMember,
										EndObject,
									EndMember,
								EndObject,
							EndMember,
						EndObject,
					EndMember,
					StartMember,
						VGroupObject, Spacing( 4 ),
							StartMember, TitleSeperator( "Free, Fixed and Weight sizes." ), EndMember,
							StartMember,
								HGroupObject, Spacing( 4 ),
									StartMember, GObj( ISEQ_C "25Kg"  ), Weight( 25  ), EndMember,
									StartMember, GObj( ISEQ_C "50Kg"  ), Weight( 50  ), EndMember,
									StartMember, GObj( ISEQ_C "75Kg"  ), Weight( 75  ), EndMember,
									StartMember, GObj( ISEQ_C "100Kg" ), Weight( 100 ), EndMember,
								EndObject,
							EndMember,
							StartMember,
								HGroupObject, Spacing( 4 ),
									StartMember, GObj( ISEQ_C	 "Free"  ), EndMember,
									StartMember, GObj( ISEQ_C ISEQ_B "Fixed" ), FixMinWidth, EndMember,
									StartMember, GObj( ISEQ_C	 "Free"  ), EndMember,
									StartMember, GObj( ISEQ_C ISEQ_B "Fixed" ), FixMinWidth, EndMember,
								EndObject,
							EndMember,
						EndObject, FixMinHeight,
					EndMember,
				EndObject,
		EndObject;
	}

	/*
	**	Object OK?
	**/
	if ( WA_Groups ) {
		/*
		**	Open the window.
		**/
		window = WindowOpen( WA_Groups );
	}

	return( window );
}

/*
**	Cycle gadget labels.
**/
UBYTE	*NotifLabels[] = { "Enabled-->", "Disabled-->", "Still Disabled-->", NULL };

/*
**	Notification map-lists.
**/
ULONG	pga2sl[] = { PGA_Top,	    SLIDER_Level,  TAG_END };
ULONG	sl2prg[] = { SLIDER_Level,  PROGRESS_Done, TAG_END };
ULONG	prg2in[] = { PROGRESS_Done, INDIC_Level,   TAG_END };

/*
**	Open the notification window.
**/
struct Window *OpenNotifWindow( void )
{
	struct Window			*window = NULL;
	Object				*c, *b, *p1, *p2, *s1, *s2, *p, *i1, *i2;

	/*
	**	Not created yet? Create it now!
	**/
	if ( ! WA_Notif ) {
		WA_Notif = WindowObject,
			WINDOW_Title,		"BGUI notification",
			WINDOW_RMBTrap,         TRUE,
			WINDOW_SmartRefresh,	TRUE,
			WINDOW_HelpText,	NotifHelp,
			WINDOW_AutoAspect,	TRUE,
			WINDOW_SharedPort,	SharedPort,
			WINDOW_MasterGroup,
				VGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing( 4 ),
					StartMember, TitleSeperator( "Conditional" ), EndMember,
					StartMember,
						HGroupObject, Spacing( 4 ),
							StartMember, c = XenCycle( NULL, NotifLabels, 0, 0 ), EndMember,
							StartMember, b = XenButton( "Target", 0 ), EndMember,
						EndObject, FixMinHeight,
					EndMember,
					StartMember, TitleSeperator( "Map-List" ), EndMember,
					StartMember,
						HGroupObject, Spacing( 4 ),
							StartMember,
								VGroupObject, Spacing( 4 ),
									StartMember, i1 = IndicatorFormat( 0, 100, 0, IDJ_CENTER, "%ld%%" ), FixMinHeight, EndMember,
									StartMember, p1 = HorizProgress( NULL, 0, 100, 0 ), EndMember,
								EndObject,
							EndMember,
							StartMember, s1 = VertSlider(	NULL, 0, 100, 0, 0 ), FixWidth( 16 ), EndMember,
							StartMember, p	= VertScroller( NULL, 0, 101, 1, 0 ), FixWidth( 16 ), EndMember,
							StartMember, s2 = VertSlider(	NULL, 0, 100, 0, 0 ), FixWidth( 16 ), EndMember,
							StartMember,
								VGroupObject, Spacing( 4 ),
									StartMember, i2 = IndicatorFormat( 0, 100, 0, IDJ_CENTER, "%ld%%" ), FixMinHeight, EndMember,
									StartMember, p2 = VertProgress( NULL, 0, 100, 0 ), EndMember,
								EndObject,
							EndMember,
						EndObject,
					EndMember,
				EndObject,
		EndObject;

		if ( WA_Notif ) {
			/*
			**	Connect the cycle object with the button.
			**/
			AddCondit( c, b, CYC_Active, 0, GA_Disabled, FALSE, GA_Disabled, TRUE );
			/*
			**	Connect sliders, prop, progression and indicators.
			**/
			AddMap( s1, p1, sl2prg );
			AddMap( s2, p2, sl2prg );
			AddMap( p,  s1, pga2sl );
			AddMap( p,  s2, pga2sl );
			AddMap( p1, i1, prg2in );
			AddMap( p2, i2, prg2in );
		}
	}

	/*
	**	Object OK?
	**/
	if ( WA_Notif ) {
		/*
		**	Open window.
		**/
		window = WindowOpen( WA_Notif );
	}

	return( window );
}

/*
**	Open infoclass window.
**/
struct Window *OpenInfoWindow( void )
{
	struct Window			*window = NULL;
	ULONG				 args[2];

	/*
	**	Setup arguments for the
	**	infoclass object.
	**/
	args[0] = AvailMem( MEMF_CHIP );
	args[1] = AvailMem( MEMF_FAST );

	/*
	**	Not created already?
	**/
	if ( ! WA_Info ) {
		WA_Info = WindowObject,
			WINDOW_Title,		"BGUI information class",
			WINDOW_RMBTrap,         TRUE,
			WINDOW_SmartRefresh,	TRUE,
			WINDOW_HelpText,	InfoHelp,
			WINDOW_AutoAspect,	TRUE,
			WINDOW_SharedPort,	SharedPort,
			WINDOW_MasterGroup,
				VGroupObject, HOffset( 4 ), VOffset( 4 ),
					StartMember,
						InfoFixed( NULL,
							   ISEQ_C "BGUI offers the InfoClass.\n"
							   "This class is a text display class which\n"
							   "allows things like:\n\n"
							   ISEQ_SHINE	  "C"
							   ISEQ_SHADOW	  "o"
							   ISEQ_FILL	  "l"
							   ISEQ_FILLTEXT  "o"
							   ISEQ_HIGHLIGHT "r"
							   ISEQ_TEXT	  "s\n\n"
							   ISEQ_L "Left Aligned...\n"
							   ISEQ_R "Right Aligned...\n"
							   ISEQ_C "Centered...\n\n"
							   ISEQ_B "Bold...\n"   ISEQ_N
							   ISEQ_I "Italic...\n" ISEQ_N
							   ISEQ_U "Underlined...\n\n"
							   ISEQ_B ISEQ_I "And combinations!\n\n"
							   ISEQ_N "Free CHIP:" ISEQ_SHINE " %lD" ISEQ_TEXT", Free FAST:" ISEQ_SHINE " %lD\n",
							   &args[ 0 ],
							   17 ),
					EndMember,
				EndObject,
		EndObject;
	}

	/*
	**	Object OK?
	**/
	if ( WA_Info ) {
		/*
		**	Open window.
		**/
		window = WindowOpen( WA_Info );
	}

	return( window );
}

/*
**	Open images window.
**/
struct Window *OpenImageWindow( void )
{
	struct Window			*window = NULL;

	/*
	**	Not yet created?
	**/
	if ( ! WA_Image ) {
		WA_Image = WindowObject,
			WINDOW_Title,		"BGUI images",
			WINDOW_RMBTrap,         TRUE,
			WINDOW_SmartRefresh,	TRUE,
			WINDOW_HelpText,	ImageHelp,
			WINDOW_AutoAspect,	TRUE,
			WINDOW_SharedPort,	SharedPort,
			WINDOW_MasterGroup,
				VGroupObject, HOffset( 4 ), VOffset( 4 ),
					StartMember,
						HGroupObject, NeXTFrame, FrameTitle( "Fixed size" ), HOffset( 8 ), TOffset( 4 ), BOffset( 6 ), Spacing( 4 ),
							VarSpace( DEFAULT_WEIGHT ),
							StartMember, ButtonObject, VIT_BuiltIn, BUILTIN_GETPATH,     ButtonFrame, EndObject, FixWidth( GETPATH_WIDTH	 ), FixHeight( GETPATH_HEIGHT	  ), EndMember,
							StartMember, ButtonObject, VIT_BuiltIn, BUILTIN_GETFILE,     ButtonFrame, EndObject, FixWidth( GETFILE_WIDTH	 ), FixHeight( GETFILE_HEIGHT	  ), EndMember,
							StartMember, ButtonObject, VIT_BuiltIn, BUILTIN_CHECKMARK,   ButtonFrame, EndObject, FixWidth( CHECKMARK_WIDTH	 ), FixHeight( CHECKMARK_HEIGHT   ), EndMember,
							StartMember, ButtonObject, VIT_BuiltIn, BUILTIN_POPUP,	     ButtonFrame, EndObject, FixWidth( POPUP_WIDTH	 ), FixHeight( POPUP_HEIGHT	  ), EndMember,
							StartMember, ButtonObject, VIT_BuiltIn, BUILTIN_ARROW_UP,    ButtonFrame, EndObject, FixWidth( ARROW_UP_WIDTH	 ), FixHeight( ARROW_UP_HEIGHT	  ), EndMember,
							StartMember, ButtonObject, VIT_BuiltIn, BUILTIN_ARROW_DOWN,  ButtonFrame, EndObject, FixWidth( ARROW_DOWN_WIDTH  ), FixHeight( ARROW_DOWN_HEIGHT  ), EndMember,
							StartMember, ButtonObject, VIT_BuiltIn, BUILTIN_ARROW_LEFT,  ButtonFrame, EndObject, FixWidth( ARROW_LEFT_WIDTH  ), FixHeight( ARROW_LEFT_HEIGHT  ), EndMember,
							StartMember, ButtonObject, VIT_BuiltIn, BUILTIN_ARROW_RIGHT, ButtonFrame, EndObject, FixWidth( ARROW_RIGHT_WIDTH ), FixHeight( ARROW_RIGHT_HEIGHT ), EndMember,
							VarSpace( DEFAULT_WEIGHT ),
						EndObject, FixMinHeight,
					EndMember,
					StartMember,
						HGroupObject, NeXTFrame, FrameTitle( "Free size" ), HOffset( 8 ), TOffset( 4 ), BOffset( 6 ), Spacing( 4 ),
							StartMember, ButtonObject, VIT_BuiltIn, BUILTIN_GETPATH,     ButtonFrame, EndObject, EndMember,
							StartMember, ButtonObject, VIT_BuiltIn, BUILTIN_GETFILE,     ButtonFrame, EndObject, EndMember,
							StartMember, ButtonObject, VIT_BuiltIn, BUILTIN_CHECKMARK,   ButtonFrame, EndObject, EndMember,
							StartMember, ButtonObject, VIT_BuiltIn, BUILTIN_POPUP,	     ButtonFrame, EndObject, EndMember,
							StartMember, ButtonObject, VIT_BuiltIn, BUILTIN_ARROW_UP,    ButtonFrame, EndObject, EndMember,
							StartMember, ButtonObject, VIT_BuiltIn, BUILTIN_ARROW_DOWN,  ButtonFrame, EndObject, EndMember,
							StartMember, ButtonObject, VIT_BuiltIn, BUILTIN_ARROW_LEFT,  ButtonFrame, EndObject, EndMember,
							StartMember, ButtonObject, VIT_BuiltIn, BUILTIN_ARROW_RIGHT, ButtonFrame, EndObject, EndMember,
						EndObject,
					EndMember,
				EndObject,
		EndObject;
	}

	/*
	**	Object OK?
	**/
	if ( WA_Image ) {
		/*
		**	Open the window.
		**/
		window = WindowOpen( WA_Image );
	}

	return( window );
}

/*
**	The BackFill hook to show custom backfills.
**	Renders a pattern from the WBPattern preferences
**	editor as back-fill.
**/
SAVEDS ASM ULONG BackFillHook( REG(a0) struct Hook *hook, REG(a2) Object *imo, REG(a1) struct FrameDrawMsg *fdm )
{
	UWORD	pat[] = { 0x0000, 0x0000, 0x0002, 0x0002, 0x000A, 0x000A, 0x002A, 0x002A,
			  0x00AA, 0x002A, 0x03EA, 0x000A, 0x0FFA, 0x0002, 0x3FFE, 0x0000,
			  0x0000, 0x7FFC, 0x4000, 0x5FF0, 0x5000, 0x57C0, 0x5400, 0x5500,
			  0x5400, 0x5400, 0x5000, 0x5000, 0x4000, 0x4000, 0x0000, 0x0000,
			  0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
			  0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000 };

	SetAfPt( fdm->fdm_RPort, pat, -4 );
	SetAPen( fdm->fdm_RPort, ( 1 << fdm->fdm_DrawInfo->dri_Depth ) - 1 );
	RectFill( fdm->fdm_RPort, fdm->fdm_Bounds->MinX, fdm->fdm_Bounds->MinY,
				  fdm->fdm_Bounds->MaxX, fdm->fdm_Bounds->MaxY );
	SetAfPt( fdm->fdm_RPort, NULL, 0 );

	return( FRC_OK );
}

/*
**	The hook structure.
**/
struct Hook BackFill = {
	NULL, NULL, (HOOKFUNC)BackFillHook, NULL, NULL
};

/*
**	Open back-fill window.
**/
struct Window *OpenFillWindow( void )
{
	struct Window			*window = NULL;

	/*
	**	Not yet created?
	**/
	if ( ! WA_BFill ) {
		WA_BFill = WindowObject,
			WINDOW_Title,		"BGUI back fill patterns",
			WINDOW_RMBTrap,         TRUE,
			WINDOW_SmartRefresh,	TRUE,
			WINDOW_HelpText,	BackfillHelp,
			WINDOW_ScaleWidth,	50,
			WINDOW_ScaleHeight,	50,
			WINDOW_AutoAspect,	TRUE,
			WINDOW_SharedPort,	SharedPort,
			WINDOW_MasterGroup,
				VGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing( 4 ),
					StartMember,
						HGroupObject, Spacing( 4 ),
							StartMember, InfoObject, ButtonFrame, ShineRaster,  EndObject, EndMember,
							StartMember, InfoObject, ButtonFrame, ShadowRaster, EndObject, EndMember,
						EndObject,
					EndMember,
					StartMember,
						HGroupObject, Spacing( 4 ),
							StartMember, InfoObject, ButtonFrame, ShineShadowRaster, EndObject, EndMember,
							StartMember, InfoObject, ButtonFrame, FillRaster,	 EndObject, EndMember,
						EndObject,
					EndMember,
					StartMember,
						HGroupObject, Spacing( 4 ),
							StartMember, InfoObject, ButtonFrame, ShineFillRaster,	EndObject, EndMember,
							StartMember, InfoObject, ButtonFrame, ShadowFillRaster, EndObject, EndMember,
						EndObject,
					EndMember,
					StartMember,
						HGroupObject, Spacing( 4 ),
							StartMember, InfoObject, ButtonFrame, ShineBlock,  EndObject, EndMember,
							StartMember, InfoObject, ButtonFrame, ShadowBlock, EndObject, EndMember,
						EndObject,
					EndMember,
					StartMember, HorizSeperator, EndMember,
					StartMember, InfoObject, ButtonFrame, FRM_BackFillHook, &BackFill, EndObject, Weight( 200 ), EndMember,
				EndObject,
		EndObject;
	}

	/*
	**	Object OK?
	**/
	if ( WA_BFill ) {
		/*
		**	Open window.
		**/
		window = WindowOpen( WA_BFill );
	}

	return( window );
}

/*
**	Cycle and Mx labels.
**/
UBYTE *PageLab[] = { "Buttons", "Strings", "CheckBoxes", "Radio-Buttons", NULL };
UBYTE *MxLab[]	 = { "MX #1",   "MX #2",   "MX #3",      "MX #4",         NULL };

/*
**	Cycle to Page map-list.
**/
ULONG Cyc2Page[] = { MX_Active, PAGE_Active, TAG_END };

/*
**	Create a MX object with a title on top.
**/
#define MxGadget(label,labels)\
	MxObject,\
		GROUP_Style,		GRSTYLE_VERTICAL,\
		LAB_Label,		label,\
		LAB_Place,		PLACE_ABOVE,\
		LAB_Underscore,         '_',\
		LAB_Highlight,		TRUE,\
		MX_Labels,		labels,\
		MX_LabelPlace,		PLACE_LEFT,\
	EndObject, FixMinSize

/*
**	Tabs-key control of the tabs gadget.
**/
SAVEDS ASM VOID TabHookFunc( REG(a0) struct Hook *hook, REG(a2) Object *obj, REG(a1) struct IntuiMessage *msg )
{
	struct Window			*window;
	Object				*mx_obj = ( Object * )hook->h_Data;
	ULONG				 pos;

	/*
	**	Obtain window pointer and
	**	current tab position.
	**/
	GetAttr( WINDOW_Window, obj,	( ULONG * )&window );
	GetAttr( MX_Active,	mx_obj, &pos );

	/*
	**	What key is pressed?
	**/
	if ( msg->Code == 0x42 ) {
		if ( msg->Qualifier & ( IEQUALIFIER_LSHIFT | IEQUALIFIER_RSHIFT )) pos--;
		else								   pos++;
		SetGadgetAttrs(( struct Gadget * )mx_obj, window, NULL, MX_Active, pos, TAG_END );
	}
}

struct Hook TabHook = { NULL, NULL, ( HOOKFUNC )TabHookFunc, NULL, NULL };

/*
**	Open pages window.
**/
struct Window *OpenPagesWindow( void )
{
	Object				*c, *p, *m, *s1, *s2, *s3;
	struct Window			*window = NULL;

	/*
	**	Not yet created?
	**/
	if ( ! WA_Pages ) {
		/*
		**	Create tabs-object.
		**/
		c = Tabs( NULL, PageLab, 0, 0 );

		/*
		**	Put it in the hook data.
		**/
		TabHook.h_Data = ( APTR )c;

		WA_Pages = WindowObject,
			WINDOW_Title,		"BGUI pages",
			WINDOW_RMBTrap,         TRUE,
			WINDOW_SmartRefresh,	TRUE,
			WINDOW_HelpText,	PagesHelp,
			WINDOW_AutoAspect,	TRUE,
			WINDOW_IDCMPHookBits,	IDCMP_RAWKEY,
			WINDOW_IDCMPHook,	&TabHook,
			WINDOW_SharedPort,	SharedPort,
			WINDOW_MasterGroup,
				VGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing( 4 ),
					StartMember, c, FixMinHeight, EndMember,
					StartMember,
						p = PageObject,
							/*
							**	Button page.
							**/
							PageMember,
								VGroupObject, Spacing(4),
									VarSpace( DEFAULT_WEIGHT ),
									StartMember, XenButton( "Button #1", 0 ), FixMinHeight, EndMember,
									StartMember, XenButton( "Button #2", 0 ), FixMinHeight, EndMember,
									StartMember, XenButton( "Button #3", 0 ), FixMinHeight, EndMember,
									VarSpace( DEFAULT_WEIGHT ),
								EndObject,
							/*
							**	String page.
							**/
							PageMember,
								VGroupObject, Spacing(4),
									VarSpace( DEFAULT_WEIGHT ),
									StartMember, s1 = String( "String #1", "", 256, 0 ), FixMinHeight, EndMember,
									StartMember, s2 = String( "String #2", "", 256, 0 ), FixMinHeight, EndMember,
									StartMember, s3 = String( "String #3", "", 256, 0 ), FixMinHeight, EndMember,
									VarSpace( DEFAULT_WEIGHT ),
								EndObject,
							/*
							**	CheckBox page.
							**/
							PageMember,
								VGroupObject, Spacing(4),
									StartMember,
										HGroupObject, Spacing( 4 ),
											VarSpace( DEFAULT_WEIGHT ),
											StartMember,
												VGroupObject, Spacing( 4 ),
													VarSpace( DEFAULT_WEIGHT ),
													StartMember, CheckBox( "CheckBox #1", FALSE, 0 ), EndMember,
													StartMember, CheckBox( "CheckBox #2", FALSE, 0 ), EndMember,
													StartMember, CheckBox( "CheckBox #3", FALSE, 0 ), EndMember,
													VarSpace( DEFAULT_WEIGHT ),
												EndObject, FixMinWidth,
											EndMember,
											VarSpace( DEFAULT_WEIGHT ),
										EndObject,
									EndMember,
								EndObject,
							/*
							**	Mx page.
							**/
							PageMember,
								VGroupObject, Spacing(4),
									VarSpace( DEFAULT_WEIGHT ),
									StartMember,
										HGroupObject,
											VarSpace( DEFAULT_WEIGHT ),
											StartMember, m = MxGadget( "_Mx Object", MxLab ), EndMember,
											VarSpace( DEFAULT_WEIGHT ),
										EndObject, FixMinHeight,
									EndMember,
									VarSpace( DEFAULT_WEIGHT ),
								EndObject,
						EndObject,
					EndMember,
				EndObject,
		EndObject;

		/*
		**	Object OK?
		**/
		if ( WA_Pages ) {
			/*
			**	Add key for the MX object.
			**/
			GadgetKey( WA_Pages, m, "m" );
			/*
			**	Connect the cycle to the page.
			**/
			AddMap( c, p, Cyc2Page );
			/*
			**	Set tab-cycling order.
			**/
			DoMethod( WA_Pages, WM_TABCYCLE_ORDER, s1, s2, s3, NULL );
		}
	}

	/*
	**	Object OK?
	**/
	if ( WA_Pages ) {
		/*
		**	Open the window.
		**/
		window = WindowOpen( WA_Pages );
	}

	return( window );
}

/*
**	Main entry.
**/
VOID StartDemo( void )
{
	struct Window	       *main = NULL, *groups = NULL, *notif = NULL, *info = NULL, *image = NULL, *bfill = NULL, *pages = NULL, *sigwin = ( struct Window * )~0;
	struct AppMessage      *apm;
	struct WBArg	       *ap;
	ULONG			sigmask = 0L, sigrec, rc, i, appsig = 0L;
	BOOL			running = TRUE;
	UBYTE			name[ 256 ];

	/*
	**	Create the shared message port.
	**/
	if ( SharedPort = CreateMsgPort()) {
		/*
		**	Open the main window.
		**/
		if ( main = OpenMainWindow( &appsig )) {
			/*
			**	OR signal masks.
			**/
			sigmask |= ( appsig | ( 1L << SharedPort->mp_SigBit ));
			/*
			**	Loop...
			**/
			do {
				/*
				**	Wait for the signals to come.
				**/
				sigrec = Wait( sigmask );

				/*
				**	AppWindow signal?
				**/
				if ( sigrec & appsig ) {
					/*
					**	Obtain AppWindow messages.
					**/
					while ( apm = GetAppMsg( WA_Main )) {
						/*
						**	Get all dropped icons.
						**/
						for ( ap = apm->am_ArgList, i = 0; i < apm->am_NumArgs; i++, ap++ ) {
							/*
							**	Build fully qualified name.
							**/
							NameFromLock( ap->wa_Lock, name, 256 );
							AddPart( name, ap->wa_Name, 256 );
							/*
							**	Add it to the listview.
							**/
							AddEntry( main, LV_IconList, (APTR)name, LVAP_SORTED );
						}
						/*
						**	Important! We must reply the message!
						**/
						ReplyMsg(( struct Message * )apm );
					}
					/*
					**	Switch to the Icon page.
					**/
					SetGadgetAttrs(( struct Gadget * )PG_Pager, main, NULL, PAGE_Active, 1, TAG_END );
				}

				/*
				**	Find out the which window signalled us.
				**/
				if ( sigrec & ( 1 << SharedPort->mp_SigBit )) {
					while ( sigwin = GetSignalWindow( WA_Main )) {

						/*
						**	Main window signal?
						**/
						if ( sigwin == main ) {
							/*
							**	Call the main-window event handler.
							**/
							while (( rc = HandleEvent( WA_Main )) != WMHI_NOMORE ) {
								switch ( rc ) {

									case	WMHI_CLOSEWINDOW:
									case	ID_QUIT:
										running = FALSE;
										break;

									case	ID_ABOUT:
										Req( main, "OK", ISEQ_C ISEQ_B "\33d8BGUIDemo" ISEQ_N "\33d2\n(C) Copyright 1993-1995 Jaba Development" );
										break;

									case	ID_MAIN_GROUPS:
										/*
										**	Open groups window.
										**/
										if ( ! groups )
											groups = OpenGroupsWindow();
										break;

									case	ID_MAIN_NOTIF:
										/*
										**	Open notification window.
										**/
										if ( ! notif )
											notif = OpenNotifWindow();
										break;

									case	ID_MAIN_INFO:
										/*
										**	Open infoclass window.
										**/
										if ( ! info )
											info = OpenInfoWindow();
										break;

									case	ID_MAIN_IMAGE:
										/*
										**	Open images window.
										**/
										if ( ! image )
											image = OpenImageWindow();
										break;

									case	ID_MAIN_BFILL:
										/*
										**	Open backfill window.
										**/
										if ( ! bfill )
											bfill = OpenFillWindow();
										break;

									case	ID_MAIN_PAGES:
										/*
										**	Open pages window.
										**/
										if ( ! pages )
											pages = OpenPagesWindow();
										break;

									case	ID_MAIN_ICON_CONT:
										/*
										**	Switch back to the main page.
										**/
										SetGadgetAttrs(( struct Gadget * )PG_Pager, main, NULL, PAGE_Active, 0, TAG_END );
										/*
										**	Clear all entries from the listview.
										**/
										ClearList( main, LV_IconList );
										break;
								}
							}
						}

						/*
						**	The code below will close the
						**	specific window.
						**/
						if ( sigwin == groups ) {
							while (( rc = HandleEvent( WA_Groups )) != WMHI_NOMORE ) {
								switch ( rc ) {
									case	WMHI_CLOSEWINDOW:
										WindowClose( WA_Groups );
										groups = NULL;
										break;
								}
							}
						}

						if ( sigwin == notif ) {
							while (( rc = HandleEvent( WA_Notif )) != WMHI_NOMORE ) {
								switch ( rc ) {
									case	WMHI_CLOSEWINDOW:
										WindowClose( WA_Notif );
										notif = NULL;
										break;
								}
							}
						}

						if ( sigwin == info ) {
							while (( rc = HandleEvent( WA_Info )) != WMHI_NOMORE ) {
								switch ( rc ) {
									case	WMHI_CLOSEWINDOW:
										WindowClose( WA_Info );
										info = NULL;
										break;
								}
							}
						}

						if ( sigwin == image ) {
							while (( rc = HandleEvent( WA_Image )) != WMHI_NOMORE ) {
								switch ( rc ) {
									case	WMHI_CLOSEWINDOW:
										WindowClose( WA_Image );
										image = NULL;
										break;
								}
							}
						}

						if ( sigwin == bfill ) {
							while (( rc = HandleEvent( WA_BFill )) != WMHI_NOMORE ) {
								switch ( rc ) {
									case	WMHI_CLOSEWINDOW:
										WindowClose( WA_BFill );
										bfill = NULL;
										break;
								}
							}
						}

						if ( sigwin == pages ) {
							while (( rc = HandleEvent( WA_Pages )) != WMHI_NOMORE ) {
								switch ( rc ) {
									case	WMHI_CLOSEWINDOW:
										WindowClose( WA_Pages );
										pages = NULL;
										break;
								}
							}
						}
					}
				}
			} while ( running );
		}
		/*
		**	Dispose of all window objects.
		**/
		if ( WA_Pages )         DisposeObject( WA_Pages );
		if ( WA_BFill )         DisposeObject( WA_BFill );
		if ( WA_Image )         DisposeObject( WA_Image );
		if ( WA_Info )		DisposeObject( WA_Info );
		if ( WA_Notif )         DisposeObject( WA_Notif );
		if ( WA_Groups )	DisposeObject( WA_Groups );
		if ( WA_Main )		DisposeObject( WA_Main );
		/*
		**	Delete the shared message port.
		**/
		DeleteMsgPort( SharedPort );
	} else
		Tell( "Unable to create a message port.\n" );
}
