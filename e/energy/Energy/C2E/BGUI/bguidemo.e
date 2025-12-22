/*
 *	BGUIDEMO.E
 *
 *	(C) Copyright 1995 Jaba Development.
 *	(C) Copyright 1995 Jan van den Baard.
 *	    All Rights Reserved.
 */

OPT OSVERSION=37
OPT PREPROCESS

MODULE 	'libraries/bgui',
       	'libraries/bgui_macros',
       	'libraries/gadtools',
       	'bgui',
	'workbench/workbench',
	'workbench/startup',
       	'tools/boopsi',
	'utility/hooks',
       	'utility/tagitem',
	'devices/inputevent',
	'exec/ports',
	'exec/memory',
	'intuition/screens',
	'intuition/intuition',
       	'intuition/classes',
       	'intuition/classusr',
       	'intuition/gadgetclass'

/*
**	Window objects.
**/
DEF	wa_main , wa_groups , wa_notif , wa_info , wa_image , wa_bfill, wa_pages,

/*
**	Gadget objects from the main window.
**/
	bt_groups, bt_notif, bt_quit, bt_info, bt_images, bt_bfill,
	bt_pages, bt_icondone, bt_iconquit, lv_iconlist, pg_pager,

/*
**	One, shared, message port for all
**	demo windows.
**/
	sharedport:PTR TO mp

/*
**	Menus & gadget ID's.
**/
#define ID_ABOUT		1
#define ID_QUIT                 2

/*
**	Put up a simple requester.
**/
PROC req( win:PTR TO window, gadgets, body:PTR TO CHAR )

DEF	req:bguirequest

	req.gadgetformat:= gadgets
	req.textformat	:= body
	req.flags	:= BREQF_CENTERWINDOW OR BREQF_XEN_BUTTONS OR BREQF_AUTO_ASPECT

ENDPROC BgUI_RequestA( win, {req}, ( {body} + 1 ))

/*
**	Main window button ID's.
**/
#define ID_MAIN_GROUPS		3
#define ID_MAIN_NOTIF		4
#define ID_MAIN_INFO		5
#define ID_MAIN_IMAGE		6
#define ID_MAIN_BFILL		7
#define ID_MAIN_PAGES		8
#define ID_MAIN_ICON_CONT	9

/*
**	Open main window.
**/
PROC openmainwindow( appmask )

DEF	window:PTR TO window,mainhelp:PTR TO CHAR

	mainhelp := '\ecBGUI is a shared library which offers a set of\n'+
		'BOOPSI classes to allow for easy and flexible GUI creation.\n\n'+
		'The main window is also an AppWindow. Drop some icons\n'+
		'on it and see what happens.\n\n'+
		'All windows also detect the aspect ratio of the screen they are\n'+
		'located on and adjust frame thickness accoording to this.\n\n'+
		'All other windows in this demo also have online-help. To access\n'+
		'this help press the \eb"HELP"\en key when the window is active.'

	wa_main := WindowObject,
		WINDOW_TITLE,		'BGUIDemo - (C) Jaba Development.',
		WINDOW_SCREENTITLE,	'BGUIDemo - (C) Copyright 1993-1995 Jaba Development.',
		/*WINDOW_MENUSTRIP,    [  NM_TITLE,0,'Project', NIL, 0, 0, NIL,
					NM_ITEM, 0,'About...','?', 0, 0, ID_ABOUT,
					NM_ITEM, 0,NM_BARLABEL, NIL, 0, 0, NIL,
					NM_ITEM, 0,'Quit','Q', 0, 0, ID_QUIT,
					NM_END,  0,NIL, NIL, 0, 0, NIL]newmenu,*/
		WINDOW_SMARTREFRESH,	TRUE,
		WINDOW_APPWINDOW,	TRUE,
		WINDOW_SIZEGADGET,	FALSE,
		WINDOW_HELPTEXT,	mainhelp,
		WINDOW_AUTOASPECT,	TRUE,
		WINDOW_SHAREDPORT,	sharedport,
		WINDOW_MASTERGROUP,
			VGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing( 4 ), GROUP_BACKFILL, SHINE_RASTER,
				StartMember,
					pg_pager := PageObject,
						/*
						**	Main page.
						**/
						PageMember,
							VGroupObject, Spacing( 4 ), GROUP_BACKFILL, SHINE_RASTER,
								StartMember,
									InfoObject,
										INFO_TEXTFORMAT,	'\ecBGUIDemo\n\ed8\eb(C) Copyright 1993-1995 Jaba Development\ed2\en\n\nPress the HELP key for more info.',
										INFO_FIXTEXTWIDTH,	TRUE,
										INFO_MINLINES,		4,
										INFO_HORIZOFFSET,	13,
										FRM_TYPE,		FRTYPE_NEXT,
									EndObject,
								EndMember,
								StartMember,
									HGroupObject, Spacing( 4 ),
										StartMember,
											VGroupObject, Spacing( 4 ),
												StartMember, bt_groups := XenKeyButton( '_Groups',       ID_MAIN_GROUPS ), EndMember,
												StartMember, bt_notif  := XenKeyButton( '_Notification', ID_MAIN_NOTIF  ), EndMember,
												VarSpace( DEFAULT_WEIGHT ),
											EndObject,
										EndMember,
										StartMember,
											VGroupObject, Spacing( 4 ),
												StartMember, bt_images := XenKeyButton( '_Images',       ID_MAIN_IMAGE  ), EndMember,
												StartMember, bt_bfill  := XenKeyButton( '_BackFill',     ID_MAIN_BFILL  ), EndMember,
												StartMember, bt_quit   := XenKeyButton( '_Quit',         ID_QUIT        ), EndMember,
											EndObject,
										EndMember,
										StartMember,
											VGroupObject, Spacing( 4 ),
												StartMember, bt_pages  := XenKeyButton( '_Pages',        ID_MAIN_PAGES  ), EndMember,
												StartMember, bt_info   := XenKeyButton( 'Info_Class',    ID_MAIN_INFO   ), EndMember,
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
							VGroupObject, Spacing( 4 ), GROUP_BACKFILL, SHINE_RASTER,
								StartMember,
									InfoObject,
										INFO_TEXTFORMAT,	'\ecThe following icons where dropped\nin the window.',
										INFO_FIXTEXTWIDTH,	TRUE,
										INFO_MINLINES,		2,
										INFO_HORIZOFFSET,	13,
										FRM_TYPE,		FRTYPE_BUTTON,
										FRM_RECESSED,		TRUE,
									EndObject, FixMinHeight,
								EndMember,
								StartMember,
									lv_iconlist := ListviewObject,
										LISTV_READONLY,         TRUE,
									EndObject,
								EndMember,
								StartMember,
									HGroupObject,
										StartMember, bt_icondone := XenKeyButton( '_Continue', ID_MAIN_ICON_CONT ), EndMember,
										VarSpace( DEFAULT_WEIGHT ),
										StartMember, bt_iconquit := XenKeyButton( '_Quit',     ID_QUIT ), EndMember,
									EndObject, FixMinHeight,
								EndMember,
							EndObject,
					EndObject,
				EndMember,
			EndObject,
	EndObject

	/*
	**	Object created OK?
	**/
	IF wa_main
		/*
		**	Add keys to the buttons.
		**/
		GadgetKey( wa_main, bt_groups,	 'g' )
		GadgetKey( wa_main, bt_notif,	 'n' )
		GadgetKey( wa_main, bt_info,	 'c' )
		GadgetKey( wa_main, bt_images,	 'i' )
		GadgetKey( wa_main, bt_bfill,	 'b' )
		GadgetKey( wa_main, bt_pages,	 'p' )
		GadgetKey( wa_main, bt_quit,	 'q' )
		GadgetKey( wa_main, bt_icondone, 'c' )
		GadgetKey( wa_main, bt_iconquit, 'q' )
		/*
		**	Open the window.
		**/
		IF window := WindowOpen( wa_main )
			/*
			**	Obtain appwindow signal mask.
			**/
			GetAttr( WINDOW_APPMASK, wa_main, appmask )
		ENDIF
	ENDIF

ENDPROC window

/*
**	Macros for the group objects. GObj() creates
**	a simple infoclass object with some text in
**	it. TObj() creates a simple groupclass object
**	with a button frame.
**/
#define GObj(t)	InfoObject,INFO_TEXTFORMAT,t,INFO_FIXTEXTWIDTH,	TRUE,INFO_HORIZOFFSET,4,INFO_VERTOFFSET,3,ButtonFrame,FRM_FLAGS,FRF_RECESSED,EndObject

#define TObj  HGroupObject, HOffset( 3 ), VOffset( 2 ),ButtonFrame,FRM_FLAGS,FRF_RECESSED,EndObject

/*
**	Open up the groups window.
**/
PROC opengroupswindow()

DEF	window:PTR TO window,groupshelp:PTR TO CHAR

	groupshelp:= 	'\ecThe BGUI layout engine is encapsulated in the groupclass.\n'+
			'The groupclass will layout all of it\as members into a specific area.\n'+
			'You can pass layout specific attributes to all group members\n'+
			'which allows for flexible and powerful layout capabilities.'

	/*
	**	If the object has not been created
	**	already we build it.
	**/
	IF wa_groups=NIL
		wa_groups := WindowObject,
			WINDOW_TITLE,		'BGUI Groups',
			WINDOW_RMBTRAP,         TRUE,
			WINDOW_SMARTREFRESH,	TRUE,
			WINDOW_HELPTEXT,	groupshelp,
			WINDOW_AUTOASPECT,	TRUE,
			WINDOW_SHAREDPORT,	sharedport,
			WINDOW_MASTERGROUP,
				VGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing( 4 ),
					StartMember,
						HGroupObject, Spacing( 4 ),
							StartMember,
								HGroupObject, NeXTFrame, FrameTitle( 'Horizontal' ), HOffset( 8 ), TOffset( 4 ), BOffset( 6 ), Spacing( 4 ),
									StartMember, TObj, EndMember,
									StartMember, TObj, EndMember,
									StartMember, TObj, EndMember,
								EndObject,
							EndMember,
							StartMember,
								VGroupObject, NeXTFrame, FrameTitle( 'Vertical' ), HOffset( 8 ), TOffset( 4 ), BOffset( 6 ), Spacing( 4 ),
									StartMember, TObj, EndMember,
									StartMember, TObj, EndMember,
									StartMember, TObj, EndMember,
								EndObject,
							EndMember,
							StartMember,
								VGroupObject, NeXTFrame, FrameTitle( 'Grid' ), HOffset( 8 ), TOffset( 4 ), BOffset( 6 ), Spacing( 4 ),
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
							StartMember, TitleSeperator( 'Free, Fixed and Weight sizes.' ), EndMember,
							StartMember,
								HGroupObject, Spacing( 4 ),
									StartMember, GObj( '\ec25Kg'  ), Weight( 25  ), EndMember,
									StartMember, GObj( '\ec50Kg'  ), Weight( 50  ), EndMember,
									StartMember, GObj( '\ec75Kg'  ), Weight( 75  ), EndMember,
									StartMember, GObj( '\ec100Kg' ), Weight( 100 ), EndMember,
								EndObject,
							EndMember,
							StartMember,
								HGroupObject, Spacing( 4 ),
									StartMember, GObj( '\ecFree'  ), EndMember,
									StartMember, GObj( '\ec\ebFixed' ), FixMinWidth, EndMember,
									StartMember, GObj( '\ecFree'  ), EndMember,
									StartMember, GObj( '\ec\ebFixed' ), FixMinWidth, EndMember,
								EndObject,
							EndMember,
						EndObject, FixMinHeight,
					EndMember,
				EndObject,
		EndObject
	ENDIF

	/*
	**	Object OK?
	**/
	IF wa_groups
		/*
		**	Open the window.
		**/
		window := WindowOpen( wa_groups )
	ENDIF

ENDPROC window

/*
**	Open the notification window.
**/
PROC opennotifwindow()

DEF	window:PTR TO window,notifhelp:PTR TO CHAR,
	c, b, p1, p2, s1, s2, p, i1, i2

	notifhelp:= '\ecNotification can be used to let an object keep one or\n'+
		'more other objects informed about it\as status. BGUI offers several\n'+
		'kinds of notification of which two (conditional and map-list) are\n'+
		'shown in this demonstration.'

	/*
	**	Not created yet? Create it now!
	**/
	IF wa_notif=NIL
		wa_notif := WindowObject,
			WINDOW_TITLE,		'BGUI notification',
			WINDOW_RMBTRAP,         TRUE,
			WINDOW_SMARTREFRESH,	TRUE,
			WINDOW_HELPTEXT,	notifhelp,
			WINDOW_AUTOASPECT,	TRUE,
			WINDOW_SHAREDPORT,	sharedport,
			WINDOW_MASTERGROUP,
				VGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing( 4 ),
					StartMember, TitleSeperator( 'Conditional' ), EndMember,
					StartMember,
						HGroupObject, Spacing( 4 ),
							StartMember, c := XenCycle( NIL, [ 'Enabled-->', 'Disabled-->', 'Still Disabled-->', NIL ], 0, 0 ), EndMember,
							StartMember, b := XenButton( 'Target', 0 ), EndMember,
						EndObject, FixMinHeight,
					EndMember,
					StartMember, TitleSeperator( 'Map-List' ), EndMember,
					StartMember,
						HGroupObject, Spacing( 4 ),
							StartMember,
								VGroupObject, Spacing( 4 ),
									StartMember, i1 := IndicatorFormat( 0, 100, 0, IDJ_CENTER, '\d%%' ), FixMinHeight, EndMember,
									StartMember, p1 := HorizProgress( NIL, 0, 100, 0 ), EndMember,
								EndObject,
							EndMember,
							StartMember, s1 := VertSlider(	NIL, 0, 100, 0, 0 ), FixWidth( 16 ), EndMember,
							StartMember, p	:= VertScroller( NIL, 0, 101, 1, 0 ), FixWidth( 16 ), EndMember,
							StartMember, s2 := VertSlider(	NIL, 0, 100, 0, 0 ), FixWidth( 16 ), EndMember,
							StartMember,
								VGroupObject, Spacing( 4 ),
									StartMember, i2 := IndicatorFormat( 0, 100, 0, IDJ_CENTER, '\d%%' ), FixMinHeight, EndMember,
									StartMember, p2 := VertProgress( NIL, 0, 100, 0 ), EndMember,
								EndObject,
							EndMember,
						EndObject,
					EndMember,
				EndObject,
		EndObject

		IF wa_notif
			/*
			**	Connect the cycle object with the button.
			**/
			AddCondit( c, b, CYC_ACTIVE, 0, GA_DISABLED, FALSE, GA_DISABLED, TRUE )
			/*
			**	Connect sliders, prop, progression and indicators.
			**/
			AddMap( s1, p1, [ SLIDER_LEVEL,  PROGRESS_DONE, TAG_END ] )
			AddMap( s2, p2, [ SLIDER_LEVEL,  PROGRESS_DONE, TAG_END ] )
			AddMap( p,  s1, [ PGA_TOP,	 SLIDER_LEVEL,  TAG_END ] )
			AddMap( p,  s2, [ PGA_TOP,	 SLIDER_LEVEL,  TAG_END ] )
			AddMap( p1, i1, [ PROGRESS_DONE, INDIC_LEVEL,   TAG_END ] )
			AddMap( p2, i2, [ PROGRESS_DONE, INDIC_LEVEL,   TAG_END ] )
		ENDIF
	ENDIF

	/*
	**	Object OK?
	**/
	IF wa_notif
		/*
		**	Open window.
		**/
		window := WindowOpen( wa_notif )
	ENDIF

ENDPROC window

/*
**	Open infoclass window.
**/
PROC openinfowindow()

DEF	window:PTR TO window,infohelp:PTR TO CHAR,text:PTR TO CHAR,
	args[2]:ARRAY

	infohelp:= '\ecNot much more can be said about the BGUI infoclass than\n'+
		'is said in this window. Except maybe that this text is shown in an\n'+
		'infoclass object as are all body texts from a BGUI requester.'

	text:=  '\ecBGUI offers the InfoClass.\n'+
		'This class is a text display class which\n'+
		'allows things like:\n\n\ed3"C"\ed4"o"\ed5"l"\ed6"o"\ed8"r"\ed2s\n\n'+
		'\elLeft Aligned...\n\erRight Aligned...\n'+
		'\ecCentered...\n\n\ebBold...\n\en'+
		'\eiItalic...\n\en\euUnderlined...\n\n'+
		'\eb\eiAnd combinations!\n\n'+
		'\enFree CHIP:\ed3 \d \ed2 Free FAST: \ed3 \d\n'
	/*
	**	Setup arguments for the
	**	infoclass object.
	**/
	args[0] := AvailMem( MEMF_CHIP )
	args[1] := AvailMem( MEMF_FAST )

	/*
	**	Not created already?
	**/
	IF wa_info=NIL
		wa_info := WindowObject,
			WINDOW_TITLE,		'BGUI information class',
			WINDOW_RMBTRAP,         TRUE,
			WINDOW_SMARTREFRESH,	TRUE,
			WINDOW_HELPTEXT,	infohelp,
			WINDOW_AUTOASPECT,	TRUE,
			WINDOW_SHAREDPORT,	sharedport,
			WINDOW_MASTERGROUP,
				VGroupObject, HOffset( 4 ), VOffset( 4 ),
					StartMember,
						InfoFixed( NIL,text, args[ 0 ], 17 ),
					EndMember,
				EndObject,
		EndObject
	ENDIF

	/*
	**	Object OK?
	**/
	IF wa_info
		/*
		**	Open window.
		**/
		window := WindowOpen( wa_info )
	ENDIF

ENDPROC window

/*
**	Open images window.
**/
PROC openimagewindow()

DEF	window:PTR TO window,imagehelp:PTR TO CHAR

	imagehelp := 	'\ecThis window shows you the built-in images that BGUI has\n'+
			'to offer. Ofcourse these images are all scalable and it is possible\n'+
			'to create your own, scalable, imagery with the BGUI vectorclass.'

	/*
	**	Not yet created?
	**/
	IF wa_image=NIL
		wa_image := WindowObject,
			WINDOW_TITLE,		'BGUI images',
			WINDOW_RMBTRAP,         TRUE,
			WINDOW_SMARTREFRESH,	TRUE,
			WINDOW_HELPTEXT,	imagehelp,
			WINDOW_AUTOASPECT,	TRUE,
			WINDOW_SHAREDPORT,	sharedport,
			WINDOW_MASTERGROUP,
				VGroupObject, HOffset( 4 ), VOffset( 4 ),
					StartMember,
						HGroupObject, NeXTFrame, FrameTitle( 'Fixed size' ), HOffset( 8 ), TOffset( 4 ), BOffset( 6 ), Spacing( 4 ),
							VarSpace( DEFAULT_WEIGHT ),
							StartMember, ButtonObject, VIT_BUILTIN, BUILTIN_GETPATH,     ButtonFrame, EndObject, FixWidth( GETPATH_WIDTH	 ), FixHeight( GETPATH_HEIGHT	  ), EndMember,
							StartMember, ButtonObject, VIT_BUILTIN, BUILTIN_GETFILE,     ButtonFrame, EndObject, FixWidth( GETFILE_WIDTH	 ), FixHeight( GETFILE_HEIGHT	  ), EndMember,
							StartMember, ButtonObject, VIT_BUILTIN, BUILTIN_CHECKMARK,   ButtonFrame, EndObject, FixWidth( CHECKMARK_WIDTH	 ), FixHeight( CHECKMARK_HEIGHT   ), EndMember,
							StartMember, ButtonObject, VIT_BUILTIN, BUILTIN_POPUP,	     ButtonFrame, EndObject, FixWidth( POPUP_WIDTH	 ), FixHeight( POPUP_HEIGHT	  ), EndMember,
							StartMember, ButtonObject, VIT_BUILTIN, BUILTIN_ARROW_UP,    ButtonFrame, EndObject, FixWidth( ARROW_UP_WIDTH	 ), FixHeight( ARROW_UP_HEIGHT	  ), EndMember,
							StartMember, ButtonObject, VIT_BUILTIN, BUILTIN_ARROW_DOWN,  ButtonFrame, EndObject, FixWidth( ARROW_DOWN_WIDTH  ), FixHeight( ARROW_DOWN_HEIGHT  ), EndMember,
							StartMember, ButtonObject, VIT_BUILTIN, BUILTIN_ARROW_LEFT,  ButtonFrame, EndObject, FixWidth( ARROW_LEFT_WIDTH  ), FixHeight( ARROW_LEFT_HEIGHT  ), EndMember,
							StartMember, ButtonObject, VIT_BUILTIN, BUILTIN_ARROW_RIGHT, ButtonFrame, EndObject, FixWidth( ARROW_RIGHT_WIDTH ), FixHeight( ARROW_RIGHT_HEIGHT ), EndMember,
							VarSpace( DEFAULT_WEIGHT ),
						EndObject, FixMinHeight,
					EndMember,
					StartMember,
						HGroupObject, NeXTFrame, FrameTitle( 'Free size' ), HOffset( 8 ), TOffset( 4 ), BOffset( 6 ), Spacing( 4 ),
							StartMember, ButtonObject, VIT_BUILTIN, BUILTIN_GETPATH,     ButtonFrame, EndObject, EndMember,
							StartMember, ButtonObject, VIT_BUILTIN, BUILTIN_GETFILE,     ButtonFrame, EndObject, EndMember,
							StartMember, ButtonObject, VIT_BUILTIN, BUILTIN_CHECKMARK,   ButtonFrame, EndObject, EndMember,
							StartMember, ButtonObject, VIT_BUILTIN, BUILTIN_POPUP,	     ButtonFrame, EndObject, EndMember,
							StartMember, ButtonObject, VIT_BUILTIN, BUILTIN_ARROW_UP,    ButtonFrame, EndObject, EndMember,
							StartMember, ButtonObject, VIT_BUILTIN, BUILTIN_ARROW_DOWN,  ButtonFrame, EndObject, EndMember,
							StartMember, ButtonObject, VIT_BUILTIN, BUILTIN_ARROW_LEFT,  ButtonFrame, EndObject, EndMember,
							StartMember, ButtonObject, VIT_BUILTIN, BUILTIN_ARROW_RIGHT, ButtonFrame, EndObject, EndMember,
						EndObject,
					EndMember,
				EndObject,
		EndObject
	ENDIF

	/*
	**	Object OK?
	**/
	IF wa_image
		/*
		**	Open the window.
		**/
		window := WindowOpen( wa_image )
	ENDIF

ENDPROC window
/*
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

*/

/*
**	Open back-fill window.
**/
PROC openfillwindow()

DEF	window:PTR TO window,backfillhelp:PTR TO CHAR,pat:PTR TO hook

	backfillhelp := '\ecHere you see the built-in backfill patterns BGUI supports.\n'+
			'These backfill patterns can all be used in groups and frames.\n'+
			'The frameclass also offers you the possibility to add hooks for\n'+
			'custom backfills and frame rendering.\n\n'+
			'The bottom frame shows you a custom backfill hook which renders a\n'+
			'simple pattern known from the WBPattern prefs editor as background.'

pat.data := 		[ $0000, $0000, $0002, $0002, $000A, $000A, $002A, $002A,
			  $00AA, $002A, $03EA, $000A, $0FFA, $0002, $3FFE, $0000,
			  $0000, $7FFC, $4000, $5FF0, $5000, $57C0, $5400, $5500,
			  $5400, $5400, $5000, $5000, $4000, $4000, $0000, $0000,
			  $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
			  $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000 ]:INT
	/*
	**	Not yet created?
	**/
	IF wa_bfill=NIL
		wa_bfill := WindowObject,
			WINDOW_TITLE,		'BGUI back fill patterns',
			WINDOW_RMBTRAP,         TRUE,
			WINDOW_SMARTREFRESH,	TRUE,
			WINDOW_HELPTEXT,	backfillhelp,
			WINDOW_SCALEWIDTH,	50,
			WINDOW_SCALEHEIGHT,	50,
			WINDOW_AUTOASPECT,	TRUE,
			WINDOW_SHAREDPORT,	sharedport,
			WINDOW_MASTERGROUP,
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
					StartMember, InfoObject, ButtonFrame, FRM_BACKFILLHOOK, pat, EndObject, Weight( 200 ), EndMember,
				EndObject,
		EndObject
	ENDIF

	/*
	**	Object OK?
	**/
	IF wa_bfill
		/*
		**	Open window.
		**/
		window := WindowOpen( wa_bfill )
	ENDIF

ENDPROC window


/*
**	Tabs-key control of the tabs gadget.
**/

PROC tabhookfunc( hook:PTR TO hook, obj, msg:PTR TO intuimessage )

DEF	window:PTR TO window,
	mx_obj,pos

mx_obj := hook.data
	/*
	**	Obtain window pointer and
	**	current tab position.
	**/
	GetAttr( WINDOW_WINDOW, obj,{window} )
	GetAttr( MX_ACTIVE,	mx_obj, {pos} )

	/*
	**	What key is pressed?
	**/
	IF ( msg.code = $42 )
		IF ( msg.qualifier AND ( IEQUALIFIER_LSHIFT OR IEQUALIFIER_RSHIFT ))
		 DEC pos
		ELSE
		 INC pos
		ENDIF
		SetGadgetAttrsA(mx_obj, window, NIL, [MX_ACTIVE, pos, TAG_END] )
	ENDIF

ENDPROC

#define String(label,contents,maxchars,id)\
	StringObject,\
		LAB_LABEL,		label,\
		RidgeFrame,\
		STRINGA_TEXTVAL,	contents,\
		STRINGA_MAXCHARS,	maxchars,\
		GA_ID,			id,\
	EndObject

/*
**	Open pages window.
**/
PROC openpageswindow()

DEF	c, p, m, s1, s2, s3,
	window:PTR TO window,pageshelp:PTR TO CHAR,tabhook:PTR TO hook

	pageshelp :=    '\ecThe pageclass allows you to setup a set of pages containing\n'+
			'BGUI gadgets or groups. This will give you the oppertunity to\n'+
			'have several set\as of gadgets in a single window.\n\n'+
			'This window has a IDCMP-hook installed which allows you to\n'+
			 'control the Tabs object with your TAB key.'


	/*
	**	Not yet created?
	**/
	IF wa_pages=NIL
		/*
		**	Create tabs-object.
		**/
		c := MxObject,
			MX_TABSOBJECT,		TRUE,
			LAB_LABEL,		NIL,
			MX_LABELS,		['Buttons', 'Strings', 'CheckBoxes', 'Radio-Buttons', NIL ],
			MX_ACTIVE,		NIL,
			GA_ID,			NIL,
		     EndObject

		/*
		**	Put it in the hook data.
		**/
		tabhook.data := c
		tabhook.entry := {tabhookfunc}

		wa_pages := WindowObject,
			WINDOW_TITLE,		'BGUI pages',
			WINDOW_RMBTRAP,         TRUE,
			WINDOW_SMARTREFRESH,	TRUE,
			WINDOW_HELPTEXT,	pageshelp,
			WINDOW_AUTOASPECT,	TRUE,
			WINDOW_IDCMPHOOKBITS,	IDCMP_RAWKEY,
			WINDOW_IDCMPHOOK,	tabhook,
			WINDOW_SHAREDPORT,	sharedport,
			WINDOW_MASTERGROUP,
				VGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing( 4 ),
					StartMember, c, FixMinHeight, EndMember,
					StartMember,
						p := PageObject,
							/*
							**	Button page.
							**/
							PageMember,
								VGroupObject, Spacing(4),
									VarSpace( DEFAULT_WEIGHT ),
									StartMember, XenButton( 'Button #1', 0 ), FixMinHeight, EndMember,
									StartMember, XenButton( 'Button #2', 0 ), FixMinHeight, EndMember,
									StartMember, XenButton( 'Button #3', 0 ), FixMinHeight, EndMember,
									VarSpace( DEFAULT_WEIGHT ),
								EndObject,
							/*
							**	String page.
							**/
							PageMember,
								VGroupObject, Spacing(4),
									VarSpace( DEFAULT_WEIGHT ),
									StartMember, s1 := String( 'String #1', '', 256, 0 ), FixMinHeight, EndMember,
									StartMember, s2 := String( 'String #2', '', 256, 0 ), FixMinHeight, EndMember,
									StartMember, s3 := String( 'String #3', '', 256, 0 ), FixMinHeight, EndMember,
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
													StartMember, CheckBox( 'CheckBox #1', FALSE, 0 ), EndMember,
													StartMember, CheckBox( 'CheckBox #2', FALSE, 0 ), EndMember,
													StartMember, CheckBox( 'CheckBox #3', FALSE, 0 ), EndMember,
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
											StartMember, m := MxObject,
													GROUP_STYLE,GRSTYLE_VERTICAL,
													LAB_LABEL,'_Mx Object',
													LAB_PLACE,PLACE_ABOVE,
													LAB_UNDERSCORE,"_",
													LAB_HIGHLIGHT,TRUE,
													MX_LABELS,[ 'MX #1', 'MX #2', 'MX #3', 'MX #4', NIL ],
													MX_LABELPLACE,PLACE_LEFT,
														EndObject, FixMinSize,
											EndMember,
											VarSpace( DEFAULT_WEIGHT ),
										EndObject, FixMinHeight,
									EndMember,
									VarSpace( DEFAULT_WEIGHT ),
								EndObject,
						EndObject,
					EndMember,
				EndObject,
		EndObject

		/*
		**	Object OK?
		**/
		IF wa_pages
			/*
			**	Add key for the MX object.
			**/
			GadgetKey( wa_pages, m, 'm' )
			/*
			**	Connect the cycle to the page.
			**/
			AddMap( c, p, [ MX_ACTIVE, PAGE_ACTIVE, TAG_END ] )
			/*
			**	Set tab-cycling order.
			**/
			domethod( wa_pages, [WM_TABCYCLE_ORDER, s1, s2, s3, NIL] )
		ENDIF
	ENDIF

	/*
	**	Object OK?
	**/
	IF wa_pages
		/*
		**	Open the window.
		**/
		window := WindowOpen( wa_pages )
	ENDIF

ENDPROC window

/*
**	Main entry.
**/
PROC main()

DEF	main=NIL:PTR TO window, groups=NIL:PTR TO window, notif=NIL:PTR TO window,
	info=NIL:PTR TO window,	image=NIL:PTR TO window, bfill=NIL:PTR TO window,
	 pages=NIL:PTR TO window, sigwin = -1,
	apm:PTR TO appmessage,
	ap:PTR TO wbarg,
	sigmask = 0, sigrec, rc, appsig = 0,
	running = FALSE,
	name[ 256 ]:STRING

        /*
        **      Open the library.
        **/
        IF bguibase := OpenLibrary( 'bgui.library', 37 )

	/*
	**	Create the shared message port.
	**/
	IF sharedport := CreateMsgPort()
		/*
		**	Open the main window.
		**/
		IF main := openmainwindow( {appsig} )
			/*
			**	OR signal masks.
			**/
			sigmask :=sigmask OR ( appsig OR Shl( 1,sharedport.sigbit ))
			/*
			**	Loop...
			**/
			REPEAT
				/*
				**	Wait for the signals to come.
				**/
				sigrec := Wait( sigmask )

				/*
				**	AppWindow signal?
				**/
				IF ( sigrec AND appsig )
					/*
					**	Obtain AppWindow messages.
					**/
					WHILE apm := GetAppMsg( wa_main )
						/*
						**	Get all dropped icons.
						**/
						FOR ap := apm.arglist TO apm.numargs-1
							/*
							**	Build fully qualified name.
							**/
							NameFromLock( ap.lock, name, 256 )
							AddPart( name, ap.name, 256 )
							/*
							**	Add it to the listview.
							**/
							AddEntry( main, lv_iconlist, name, LVAP_SORTED )
						ENDFOR
						/*
						**	Important! We must reply the message!
						**/
						ReplyMsg( apm )
					ENDWHILE
					/*
					**	Switch to the Icon page.
					**/
					SetGadgetAttrsA(pg_pager, main, NIL,[ PAGE_ACTIVE, 1, TAG_END] )
				ENDIF

				/*
				**	Find out the which window signalled us.
				**/
				IF ( sigrec AND Shl( 1,sharedport.sigbit ))
					WHILE sigwin := domethod( wa_main,[ WM_GET_SIGNAL_WINDOW] )

						/*
						**	Main window signal?
						**/
						IF sigwin = main
							/*
							**	Call the main-window event handler.
							**/
							WHILE ( rc := HandleEvent( wa_main )) <> WMHI_NOMORE
								SELECT rc

									CASE	WMHI_CLOSEWINDOW
										running := TRUE
									CASE	ID_QUIT
										running := TRUE

									CASE	ID_ABOUT
										req( main, 'OK', '\ec\eb\\ed8BGUIDemo\en\ed2\n(C) Copyright 1993-1995 Jaba Development' )

									CASE	ID_MAIN_GROUPS
										/*
										**	Open groups window.
										**/
										 IF groups=NIL THEN groups := opengroupswindow()

									CASE	ID_MAIN_NOTIF
										/*
										**	Open notification window.
										**/
										 IF notif=NIL THEN notif := opennotifwindow()

									CASE	ID_MAIN_INFO
										/*
										**	Open infoclass window.
										**/
										 IF info=NIL THEN info := openinfowindow()

									CASE	ID_MAIN_IMAGE
										/*
										**	Open images window.
										**/
										 IF image=NIL THEN image := openimagewindow()

									CASE	ID_MAIN_BFILL
										/*
										**	Open backfill window.
										**/
										 IF bfill=NIL THEN bfill := openfillwindow()

									CASE	ID_MAIN_PAGES
										/*
										**	Open pages window.
										**/
										IF pages=NIL THEN pages := openpageswindow()

									CASE	ID_MAIN_ICON_CONT
										/*
										**	Switch back to the main page.
										**/
										SetGadgetAttrsA(pg_pager, main, NIL,[ PAGE_ACTIVE, 0, TAG_END] )
										/*
										**	Clear all entries from the listview.
										**/
										ClearList( main, lv_iconlist )
								ENDSELECT
							ENDWHILE
						ENDIF

						/*
						**	The code below will close the
						**	specific window.
						**/
						IF ( sigwin = groups )
							WHILE ( rc := HandleEvent( wa_groups )) <> WMHI_NOMORE
								SELECT rc
									CASE	WMHI_CLOSEWINDOW
										WindowClose( wa_groups )
										groups := NIL
								ENDSELECT
							ENDWHILE
						ENDIF

						IF ( sigwin = notif )
							WHILE ( rc := HandleEvent( wa_notif )) <> WMHI_NOMORE
								SELECT rc
									CASE	WMHI_CLOSEWINDOW
										WindowClose( wa_notif )
										notif := NIL
								ENDSELECT
							ENDWHILE
						ENDIF

						IF ( sigwin = info )
							WHILE ( rc := HandleEvent( wa_info )) <> WMHI_NOMORE
								SELECT rc
									CASE	WMHI_CLOSEWINDOW
										WindowClose( wa_info )
										info := NIL
								ENDSELECT
							ENDWHILE
						ENDIF

						IF ( sigwin = image )
							WHILE ( rc := HandleEvent( wa_image )) <> WMHI_NOMORE
								SELECT rc
									CASE	WMHI_CLOSEWINDOW
										WindowClose( wa_image )
										image := NIL
								ENDSELECT
							ENDWHILE
						ENDIF

						IF ( sigwin = bfill )
							WHILE ( rc := HandleEvent( wa_bfill )) <> WMHI_NOMORE
								SELECT rc
									CASE	WMHI_CLOSEWINDOW
										WindowClose( wa_bfill )
										bfill := NIL
								ENDSELECT
							ENDWHILE
						ENDIF

						IF ( sigwin = pages )
							WHILE ( rc := HandleEvent( wa_pages )) <> WMHI_NOMORE
								SELECT rc
									CASE	WMHI_CLOSEWINDOW
										WindowClose( wa_pages )
										pages := NIL
								ENDSELECT
							ENDWHILE
						ENDIF
					ENDWHILE
				ENDIF
			UNTIL running
		ENDIF
		/*
		**	Dispose of all window objects.
		**/
		IF ( wa_pages )   THEN      DisposeObject( wa_pages )
		IF ( wa_bfill )   THEN      DisposeObject( wa_bfill )
		IF ( wa_image )   THEN      DisposeObject( wa_image )
		IF ( wa_info )	  THEN	    DisposeObject( wa_info )
		IF ( wa_notif )   THEN      DisposeObject( wa_notif )
		IF ( wa_groups )  THEN      DisposeObject( wa_groups )
		IF ( wa_main )	  THEN      DisposeObject( wa_main )
		/*
		**	Delete the shared message port.
		**/
		DeleteMsgPort( sharedport )
	ELSE
		WriteF( 'Unable to create a message port.\n' )
	ENDIF
	CloseLibrary( bguibase )
	ELSE
		WriteF('Could not open the bgui.library\n')
	ENDIF
ENDPROC
