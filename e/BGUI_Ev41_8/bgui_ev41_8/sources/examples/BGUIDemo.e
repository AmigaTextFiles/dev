/*
 *  BGUIDEMO.E
 *
 *  (C) Copyright 1995 Jaba Development.
 *  (C) Copyright 1995 Jan van den Baard.
 *      All Rights Reserved.
 *
 *  On 23 May 1996 : Custom hooks are removed. They will be back later.
 *  On 18 June 1996: FRM_FILLPATTERN example added.
 *  On 12 Aug 1996:  New naming styles
 *  On 31 Aug 1996:  Dynamic groups
 *  On 22 Dec 1996:  Hooks for custom backfill and tab key with pages added
 */
OPT OSVERSION=37
OPT PREPROCESS

MODULE  'libraries/bgui',
		'libraries/bguim',
		'libraries/gadtools',
		'bgui',
		'workbench/workbench',
		'workbench/startup',
		'tools/boopsi',
		'utility/hooks',
		'tools/installhook',
		'tools/inithook',
		'utility/tagitem',
		'devices/inputevent',
		'exec/ports',
		'exec/memory',
		'intuition/screens',
		'intuition/intuition',
		'intuition/classes',
		'intuition/classusr',
		'intuition/gadgetclass',
		'graphics',
		'graphics/gfx',
		'graphics/rastport',
		'graphics/gfxmacros'
/*
**  Window objects.
**/
DEF wa_main , wa_groups , wa_notif , wa_info , wa_image , wa_bfill, wa_pages,
/*
**  Gadget objects from the main window.
**/
	bt_groups, bt_notif, bt_quit, bt_info, bt_images, bt_bfill,
	bt_pages, bt_icondone, bt_iconquit, lv_iconlist, pg_pager,
/*
**  One, shared, message port for all
**  demo windows.
**/
	sharedport:PTR TO mp
/*
**  Menus & gadget ID's.
**/
CONST ID_ABOUT      = 1
CONST ID_QUIT       = 2
/*
**  Macros for the group objects. GObj() creates
**  a simple infoclass object with some text in
**  it. TObj() creates a simple groupclass object
**  with a button frame.
**/
#define GObj(t)\
			InfoObject,\
				INFO_TextFormat,    t,\
				INFO_FixTextWidth,  TRUE,\
				INFO_HorizOffset,   4,\
				INFO_VertOffset,    3,\
				ButtonFrame,\
				FRM_Flags,          FRF_RECESSED,\
			EndObject

#define NWObj(v,id)\
		   StringObject,\
			  FuzzRidgeFrame,\
			  STRINGA_LONGVAL,       v,\
			  STRINGA_MAXCHARS,      3,\
			  STRINGA_IntegerMin,    1,\
			  STRINGA_IntegerMax,    999,\
			  STRINGA_JUSTIFICATION, GACT_STRINGCENTER,\
			  GA_ID,                 id,\
		   EndObject

#define TObj\
			HGroupObject, HOffset( 3 ), VOffset( 2 ),\
				ButtonFrame,\
				FRM_BackFill,   FILL_RASTER,\
				FRM_Flags,      FRF_RECESSED,\
			EndObject

CONST   ID_GROUP_W0   = 500,
		ID_GROUP_W1   = 501,
		ID_GROUP_W2   = 502,
		ID_GROUP_W3   = 503

DEF w[4]:ARRAY OF LONG
DEF backfill:hook, tabhook:hook

/*
**  Main window button ID's.
**/
CONST ID_MAIN_GROUPS    = 3
CONST ID_MAIN_NOTIF     = 4
CONST ID_MAIN_INFO      = 5
CONST ID_MAIN_IMAGE     = 6
CONST ID_MAIN_BFILL     = 7
CONST ID_MAIN_PAGES     = 8
CONST ID_MAIN_ICON_CONT = 9

/*
**  Put up a simple requester.
**/
PROC req( win:PTR TO window, gadgets, body:PTR TO CHAR )
	DEF flags
	flags   := BREQF_LOCKWINDOW OR BREQF_CENTERWINDOW OR BREQF_XEN_BUTTONS OR BREQF_AUTO_ASPECT OR BREQF_FAST_KEYS
ENDPROC BgUI_RequestA( win, [ flags, NIL, gadgets, body, NIL, NIL, "_", 0, NIL, 0]:bguiRequest, NIL)

/*
**  Open main window.
**/
PROC openmainwindow( appmask )

DEF window:PTR TO window,mainhelp:PTR TO CHAR

	mainhelp := ISEQ_C + 'BGUI is a shared library which offers a set of\n'+
		'BOOPSI classes to allow for easy and flexible GUI creation.\n\n'+
		'The main window is also an AppWindow. Drop some icons\n'+
		'on it and see what happens.\n\n'+
		'All windows also detect the aspect ratio of the screen they are\n'+
		'located on and adjust frame thickness accoording to this.\n\n'+
		'All other windows in this demo also have online-help. To access\n'+
		'this help press the '+ISEQ_B+'HELP'+ISEQ_N+' key when the window is active.'

	wa_main := WindowObject,
		WINDOW_Title,           'BGUIDemo',
		WINDOW_ScreenTitle,     'BGUI Demo - ©1996 Ian J. Einman, ©1993-1995 Jaba Development.',
		WINDOW_MenuStrip,       StartMenu,
									Title( 'Project' ),
										Item( 'About...', '?', ID_ABOUT),
										ItemBar,
										Item( 'Quit',     'Q', ID_QUIT ),
								End,
		WINDOW_SmartRefresh,    TRUE,
		WINDOW_HelpText,        mainhelp,
		WINDOW_AppWindow,       TRUE,
		WINDOW_SizeGadget,      FALSE,
		WINDOW_AutoAspect,      TRUE,
		WINDOW_SharedPort,      sharedport,
		WINDOW_AutoKeyLabel,    TRUE,
		WINDOW_TitleZip,        TRUE,
		WINDOW_ScaleWidth,      10,
		WINDOW_CloseOnEsc,      TRUE,
		WINDOW_MasterGroup,
			VGroupObject, NormalOffset, NormalSpacing, GROUP_BackFill, SHINE_RASTER,
				StartMember,
					pg_pager := PageObject,
						/*
						**  Main page.
						**/
						PageMember,
							VGroupObject, WideSpacing, GROUP_BackFill, SHINE_RASTER,
								StartMember,
									InfoObject,
										INFO_TextFormat,    '\ecBGUIDemo in AmigaE!\n©1996 Dominique Dutoit\n©1996 Ian J. Einman\n©1993-1995 Jaba Development\n\nPress the HELP key for more info.',
										INFO_FixTextWidth,  TRUE,
										INFO_MinLines,      6,
										FRM_Type,           FRTYPE_NEXT,
									EndObject,
								EndMember,
								StartMember,
									HGroupObject, NormalSpacing,
										StartMember,
											VGroupObject, NormalSpacing,
												StartMember, bt_groups := KeyButton( '_Groups',       ID_MAIN_GROUPS ), EndMember,
												StartMember, bt_notif  := KeyButton( '_Notification', ID_MAIN_NOTIF  ), EndMember,
												VarSpace( DEFAULT_WEIGHT ),
											EndObject,
										EndMember,
										StartMember,
											VGroupObject, NormalSpacing,
												StartMember, bt_images := KeyButton( '_Images',       ID_MAIN_IMAGE  ), EndMember,
												StartMember, bt_bfill  := KeyButton( '_BackFill',     ID_MAIN_BFILL  ), EndMember,
												StartMember, bt_quit   := KeyButton( '_Quit',         ID_QUIT        ), EndMember,
											EndObject,
										EndMember,
										StartMember,
											VGroupObject, NormalSpacing,
												StartMember, bt_pages  := KeyButton( '_Pages',        ID_MAIN_PAGES  ), EndMember,
												StartMember, bt_info   := KeyButton( 'Info_Class',    ID_MAIN_INFO   ), EndMember,
												VarSpace( DEFAULT_WEIGHT ),
											EndObject,
										EndMember,
									EndObject, FixMinHeight,
								EndMember,
							EndObject,
						/*
						**  Icon-drop list page.
						**/
						PageMember,
							VGroupObject, NormalSpacing, GROUP_BackFill, SHINE_RASTER,
								StartMember,
									InfoObject,
										INFO_TextFormat,    'The following icons where dropped\nin the window.',
										INFO_FixTextWidth,  TRUE,
										INFO_MinLines,      2,
										INFO_HorizOffset,   13,
										FRM_Type,           FRTYPE_BUTTON,
										FRM_Recessed,       TRUE,
									EndObject, FixMinHeight,
								EndMember,
								StartMember,
									lv_iconlist := ListviewObject,
										LISTV_ReadOnly,         TRUE,
									EndObject,
								EndMember,
								StartMember,
									HGroupObject,
										StartMember, bt_icondone := KeyButton( '_Continue', ID_MAIN_ICON_CONT ), EndMember,
										VarSpace( DEFAULT_WEIGHT ),
										StartMember, bt_iconquit := KeyButton( '_Quit',     ID_QUIT ), EndMember,
									EndObject, FixMinHeight,
								EndMember,
							EndObject,
					EndObject,
				EndMember,
			EndObject,
	EndObject

	/*
	**  Object created OK?
	**/
	IF wa_main
		/*
		**  Open the window.
		**/
		IF window := WindowOpen( wa_main )
			/*
			**  Obtain appwindow signal mask.
			**/
			GetAttr( WINDOW_AppMask, wa_main, appmask )
		ENDIF
	ENDIF

ENDPROC window
/*
**  Open up the groups window.
**/
PROC opengroupswindow()

DEF window:PTR TO window,groupshelp:PTR TO CHAR

	groupshelp:=    '\ecThe BGUI layout engine is encapsulated in the groupclass.\n'+
			'The groupclass will layout all of it\as members into a specific area.\n'+
			'You can pass layout specific attributes to all group members\n'+
			'which allows for flexible and powerful layout capabilities.'

	/*
	**  If the object has not been created
	**  already we build it.
	**/
	IF wa_groups=NIL

		w[0]:=NWObj( 25, ID_GROUP_W0)
		w[1]:=NWObj( 50, ID_GROUP_W1)
		w[2]:=NWObj( 75, ID_GROUP_W2)
		w[3]:=NWObj(100, ID_GROUP_W3)

		wa_groups := WindowObject,
			WINDOW_Title,           'BGUI Groups',
			WINDOW_RMBTrap,         TRUE,
			WINDOW_SmartRefresh,    TRUE,
			WINDOW_HelpText,        groupshelp,
			WINDOW_AutoAspect,      TRUE,
			WINDOW_SharedPort,      sharedport,
			WINDOW_CloseOnEsc,      TRUE,
			WINDOW_ScaleWidth,      20,
			WINDOW_ScaleHeight,     20,
			WINDOW_MasterGroup,
				VGroupObject, NormalOffset, NormalSpacing,
					StartMember,
						HGroupObject, WideSpacing,
							StartMember,
								HGroupObject, NeXTFrame, FrameTitle( 'Horizontal' ), NormalSpacing,
									NormalHOffset, TOffset(GRSPACE_NARROW), BOffset(GRSPACE_NORMAL),
									StartMember, TObj, EndMember,
									StartMember, TObj, EndMember,
									StartMember, TObj, EndMember,
								EndObject,
							EndMember,
							StartMember,
								VGroupObject, NeXTFrame, FrameTitle( 'Vertical' ), NormalSpacing,
									NormalHOffset, TOffset(GRSPACE_NARROW), BOffset(GRSPACE_NORMAL),
									StartMember, TObj, EndMember,
									StartMember, TObj, EndMember,
									StartMember, TObj, EndMember,
								EndObject,
							EndMember,
							StartMember,
								VGroupObject, NeXTFrame, FrameTitle( 'Grid' ), NormalSpacing,
									NormalHOffset, TOffset(GRSPACE_NARROW), BOffset(GRSPACE_NORMAL),
									StartMember,
										HGroupObject, NormalSpacing,
											StartMember, TObj, EndMember,
											StartMember, TObj, EndMember,
											StartMember, TObj, EndMember,
										EndObject,
									EndMember,
									StartMember,
										HGroupObject, NormalSpacing,
											StartMember, TObj, EndMember,
											StartMember, TObj, EndMember,
											StartMember, TObj, EndMember,
										EndObject,
									EndMember,
									StartMember,
										HGroupObject, NormalSpacing,
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
						VGroupObject, NormalSpacing, FrameTitle( 'Dynamic, Weight, Free and Fixed sizes.' ), NeXTFrame,
							NormalHOffset, TOffset(GRSPACE_NARROW), BOffset(GRSPACE_NORMAL),
							StartMember,
								HGroupObject, NormalSpacing,
									StartMember, w[0], Weight( 25 ), EndMember,
									StartMember, w[1], Weight( 50 ), EndMember,
									StartMember, w[2], Weight( 75 ), EndMember,
									StartMember, w[3], Weight( 100 ), EndMember,
								EndObject,
							EndMember,

							StartMember,
								HGroupObject, NormalSpacing,
									StartMember, GObj( '25Kg'  ), Weight( 25  ), EndMember,
									StartMember, GObj( '50Kg'  ), Weight( 50  ), EndMember,
									StartMember, GObj( '75Kg'  ), Weight( 75  ), EndMember,
									StartMember, GObj( '100Kg' ), Weight( 100 ), EndMember,
								EndObject,
							EndMember,
							StartMember,
								HGroupObject, NormalSpacing,
									StartMember, GObj( 'Free'  ), EndMember,
									StartMember, GObj( 'Fixed' ), FixMinWidth, EndMember,
									StartMember, GObj( 'Free'  ), EndMember,
									StartMember, GObj( 'Fixed' ), FixMinWidth, EndMember,
								EndObject,
							EndMember,
						EndObject, FixMinHeight,
					EndMember,
				EndObject,
		EndObject
	ENDIF

	/*
	**  Object OK?
	**/
	IF wa_groups
		/*
		**  Open the window.
		**/
		window := WindowOpen( wa_groups )
	ENDIF
ENDPROC window
/*
**  Open the notification window.
**/
PROC opennotifwindow()

DEF window:PTR TO window,notifhelp:PTR TO CHAR,
	c, b, p1, p2, s1, s2, p, i1, i2

	notifhelp:= '\ecNotification can be used to let an object keep one or\n'+
		'more other objects informed about it\as status. BGUI offers several\n'+
		'kinds of notification of which two (conditional and map-list) are\n'+
		'shown in this demonstration.'

	/*
	**  Not created yet? Create it now!
	**/
	IF wa_notif=NIL
		wa_notif := WindowObject,
			WINDOW_Title,           'BGUI notification',
			WINDOW_RMBTrap,         TRUE,
			WINDOW_SmartRefresh,    TRUE,
			WINDOW_HelpText,        notifhelp,
			WINDOW_AutoAspect,      TRUE,
			WINDOW_SharedPort,      sharedport,
			WINDOW_CloseOnEsc,      TRUE,
			WINDOW_MasterGroup,
				VGroupObject, NormalOffset, NormalSpacing,
					StartMember, TitleSeparator( 'Conditional' ), EndMember,
					StartMember,
						HGroupObject, Spacing( 4 ),
							StartMember, c := Cycle( NIL, [ 'Enabled-->', 'Disabled-->', 'Still Disabled-->', NIL ], 0, 0 ), EndMember,
							StartMember, b := Button( 'Target', 0 ), EndMember,
						EndObject, FixMinHeight,
					EndMember,
					StartMember, TitleSeparator( 'Map-List' ), EndMember,
					StartMember,
						HGroupObject, NormalSpacing,
							StartMember,
								VGroupObject, NormalSpacing,
									StartMember, i1 := IndicatorFormat( 0, 100, 0, IDJ_CENTER, '\d%%' ), FixMinHeight, EndMember,
									StartMember, p1 := HorizProgress( NIL, 0, 100, 0 ), EndMember,
								EndObject,
							EndMember,
							StartMember, s1 := VertSlider(  NIL, 0, 100, 0, 0 ), FixWidth( 16 ), EndMember,
							StartMember, p  := VertScroller( NIL, 0, 101, 1, 0 ), FixWidth( 16 ), EndMember,
							StartMember, s2 := VertSlider(  NIL, 0, 100, 0, 0 ), FixWidth( 16 ), EndMember,
							StartMember,
								VGroupObject, NormalSpacing,
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
			**  Connect the cycle object with the button.
			**/
			AddCondit( c, b, CYC_Active, 0, GA_DISABLED, FALSE, GA_DISABLED, TRUE )
			/*
			**  Connect sliders, prop, progression and indicators.
			**/
			AddMap( s1, p1, [ SLIDER_Level,  PROGRESS_Done, TAG_END ] )
			AddMap( s2, p2, [ SLIDER_Level,  PROGRESS_Done, TAG_END ] )
			AddMap( p,  s1, [ PGA_TOP,   SLIDER_Level,  TAG_END ] )
			AddMap( p,  s2, [ PGA_TOP,   SLIDER_Level,  TAG_END ] )
			AddMap( p1, i1, [ PROGRESS_Done, INDIC_Level,   TAG_END ] )
			AddMap( p2, i2, [ PROGRESS_Done, INDIC_Level,   TAG_END ] )
		ENDIF
	ENDIF

	/*
	**  Object OK?
	**/
	IF wa_notif
		/*
		**  Open window.
		**/
		window := WindowOpen( wa_notif )
	ENDIF
ENDPROC window
/*
**  Open infoclass window.
**/
PROC openinfowindow()

	DEF window:PTR TO window,infohelp:PTR TO CHAR,text:PTR TO CHAR,
		args

	infohelp:= '\ecNot much more can be said about the BGUI infoclass than\n'+
		'is said in this window. Except maybe that this text is shown in an\n'+
		'infoclass object as are all body texts from a BGUI requester.'

	text:=  '\ecBGUI offers the InfoClass.\n'+
		'This class is a text display class which\n'+
		'allows things like:\n\n\ed3C\ed4o\ed5l\ed6o\ed8r\ed2s\n\n'+
		'\elLeft Aligned...\n\erRight Aligned...\n'+
		'\ecCentered...\n\n\ebBold...\n\en'+
		'\eiItalic...\n\en\euUnderlined...\n\n'+
		'\eb\eiAnd combinations!\n\n'+
		'\enFree CHIP:\ed3 \d \ed2 Free FAST: \ed3 \d'
	
	/*
	**  Not created already?
	**/
	IF wa_info=NIL
		/*
		**  Setup arguments for the
		**  infoclass object.
		**/
		args := [ AvailMem( MEMF_CHIP ), AvailMem( MEMF_FAST ), NIL ]

		wa_info := WindowObject,
			WINDOW_Title,           'BGUI information class',
			WINDOW_RMBTrap,         TRUE,
			WINDOW_SmartRefresh,    TRUE,
			WINDOW_HelpText,        infohelp,
			WINDOW_AutoAspect,      TRUE,
			WINDOW_SharedPort,      sharedport,
			WINDOW_CloseOnEsc,      TRUE,
			WINDOW_MasterGroup,
				VGroupObject, HOffset( 4 ), VOffset( 4 ),
					StartMember,
						InfoFixed( NIL,text, args, 17 ),
					EndMember,
				EndObject,
		EndObject
	ENDIF

	/*
	**  Object OK?
	**/
	IF wa_info
		/*
		**  Open window.
		**/
		window := WindowOpen( wa_info )
	ENDIF

ENDPROC window
/*
**  Open images window.
**/
PROC openimagewindow()

DEF window:PTR TO window,imagehelp:PTR TO CHAR

	imagehelp :=    '\ecThis window shows you the built-in images that BGUI has\n'+
			'to offer. Ofcourse these images are all scalable and it is possible\n'+
			'to create your own, scalable, imagery with the BGUI vectorclass.'

	/*
	**  Not yet created?
	**/
	IF wa_image=NIL
		wa_image := WindowObject,
			WINDOW_Title,           'BGUI images',
			WINDOW_RMBTrap,         TRUE,
			WINDOW_SmartRefresh,    TRUE,
			WINDOW_HelpText,        imagehelp,
			WINDOW_AutoAspect,      TRUE,
			WINDOW_SharedPort,      sharedport,
			WINDOW_CloseOnEsc,      TRUE,
			WINDOW_ScaleHeight,     10,
			WINDOW_MasterGroup,
				VGroupObject, NormalOffset, WideSpacing,
					StartMember,
						HGroupObject, TOffset(GRSPACE_NARROW), BOffset(GRSPACE_NORMAL), NormalSpacing, NeXTFrame, FrameTitle('Fixed size'),
							VarSpace( DEFAULT_WEIGHT ),
							StartMember, ButtonObject, VIT_BuiltIn, BUILTIN_GETPATH,     ButtonFrame, EndObject, FixWidth( GETPATH_WIDTH     ), FixHeight( GETPATH_HEIGHT     ), EndMember,
							StartMember, ButtonObject, VIT_BuiltIn, BUILTIN_GETFILE,     ButtonFrame, EndObject, FixWidth( GETFILE_WIDTH     ), FixHeight( GETFILE_HEIGHT     ), EndMember,
							StartMember, ButtonObject, VIT_BuiltIn, BUILTIN_CHECKMARK,   ButtonFrame, EndObject, FixWidth( CHECKMARK_WIDTH   ), FixHeight( CHECKMARK_HEIGHT   ), EndMember,
							StartMember, ButtonObject, VIT_BuiltIn, BUILTIN_POPUP,       ButtonFrame, EndObject, FixWidth( POPUP_WIDTH   ), FixHeight( POPUP_HEIGHT   ), EndMember,
							StartMember, ButtonObject, VIT_BuiltIn, BUILTIN_ARROW_UP,    ButtonFrame, EndObject, FixWidth( ARROW_UP_WIDTH    ), FixHeight( ARROW_UP_HEIGHT    ), EndMember,
							StartMember, ButtonObject, VIT_BuiltIn, BUILTIN_ARROW_DOWN,  ButtonFrame, EndObject, FixWidth( ARROW_DOWN_WIDTH  ), FixHeight( ARROW_DOWN_HEIGHT  ), EndMember,
							StartMember, ButtonObject, VIT_BuiltIn, BUILTIN_ARROW_LEFT,  ButtonFrame, EndObject, FixWidth( ARROW_LEFT_WIDTH  ), FixHeight( ARROW_LEFT_HEIGHT  ), EndMember,
							StartMember, ButtonObject, VIT_BuiltIn, BUILTIN_ARROW_RIGHT, ButtonFrame, EndObject, FixWidth( ARROW_RIGHT_WIDTH ), FixHeight( ARROW_RIGHT_HEIGHT ), EndMember,
							VarSpace( DEFAULT_WEIGHT ),
						EndObject, FixMinHeight,
					EndMember,
					StartMember,
						HGroupObject, NeXTFrame, FrameTitle( 'Free size' ), HOffset( 8 ), TOffset( 4 ), BOffset( 6 ), Spacing( 4 ),
							StartMember, ButtonObject, VIT_BuiltIn, BUILTIN_GETPATH,     ButtonFrame, EndObject, EndMember,
							StartMember, ButtonObject, VIT_BuiltIn, BUILTIN_GETFILE,     ButtonFrame, EndObject, EndMember,
							StartMember, ButtonObject, VIT_BuiltIn, BUILTIN_CHECKMARK,   ButtonFrame, EndObject, EndMember,
							StartMember, ButtonObject, VIT_BuiltIn, BUILTIN_POPUP,       ButtonFrame, EndObject, EndMember,
							StartMember, ButtonObject, VIT_BuiltIn, BUILTIN_ARROW_UP,    ButtonFrame, EndObject, EndMember,
							StartMember, ButtonObject, VIT_BuiltIn, BUILTIN_ARROW_DOWN,  ButtonFrame, EndObject, EndMember,
							StartMember, ButtonObject, VIT_BuiltIn, BUILTIN_ARROW_LEFT,  ButtonFrame, EndObject, EndMember,
							StartMember, ButtonObject, VIT_BuiltIn, BUILTIN_ARROW_RIGHT, ButtonFrame, EndObject, EndMember,
						EndObject,
					EndMember,
				EndObject,
		EndObject
	ENDIF

	/*
	**  Object OK?
	**/
	IF wa_image
		/*
		**  Open the window.
		**/
		window := WindowOpen( wa_image )
	ENDIF

ENDPROC window

/*
** The backFill hook to show custom backfills.
** Renders a pattern from the WBPattern preferences
** editor as back-fill.
**/
PROC backFillHook( hook:PTR TO hook, imo:PTR TO object, fdm:PTR TO frameDrawMsg )
   DEF pat

   pat := [ $0000, $0000, $0002, $0002, $000A, $000A, $002A, $002A,
			$00AA, $002A, $03EA, $000A, $0FFA, $0002, $3FFE, $0000,
			$0000, $7FFC, $4000, $5FF0, $5000, $57C0, $5400, $5500,
			$5400, $5400, $5000, $5000, $4000, $4000, $0000, $0000 ]:INT

   fdm.rPort.mask := $03
   SetAfPt( fdm.rPort, pat, -4 )
   SetAPen( fdm.rPort, Shl( 1 , fdm.drawInfo.depth ) - 1 )
   RectFill( fdm.rPort, fdm.bounds.minx, fdm.bounds.miny,
			  fdm.bounds.maxx, fdm.bounds.maxy )
   SetAfPt( fdm.rPort, NIL, 0 )

ENDPROC FRC_OK

/*
**  Open back-fill window.
**/
PROC openfillwindow()
	DEF window=NIL:PTR TO window,backfillhelp:PTR TO CHAR
	DEF screen:PTR TO screen
	DEF bp:PTR TO bguiPattern

	installhook( backfill, {backFillHook} )

	backfillhelp := 'Here you see the built-in backfill patterns BGUI supports.\n'+
			'These backfill patterns can all be used in groups and frames.\n' +
			'The frameclass also offers you the possibility to add hooks for\n' +
			'custom backfills and frame rendering.\n\n' +
			'The middle frame shows you a custom backfill hook which renders a\n' +
			'simple pattern known from the WBPattern prefs editor as background.'

	/*
	**  Not yet created?
	**/
	IF wa_bfill = NIL
		NEW bp
		screen := LockPubScreen( NIL )
		bp.flags := 0
		bp.left := 0
		bp.top := 0
		bp.width := 120
		bp.height := 80
		bp.bitMap := screen.rastport.bitmap
		bp.object := NIL
		UnlockPubScreen( NIL, screen )
		wa_bfill := WindowObject,
			WINDOW_Title,           'BGUI back fill patterns',
			WINDOW_RMBTrap,         TRUE,
			WINDOW_SmartRefresh,    TRUE,
			WINDOW_HelpText,        backfillhelp,
			WINDOW_ScaleWidth,      50,
			WINDOW_ScaleHeight,     50,
			WINDOW_AutoAspect,      TRUE,
			WINDOW_SharedPort,      sharedport,
			WINDOW_CloseOnEsc,      TRUE,
			WINDOW_MasterGroup,
				HGroupObject, NormalOffset, WideSpacing,
					StartMember,
						VGroupObject, NormalOffset, NeXTFrame, FrameTitle('Raster Fill'), NormalSpacing,
							StartMember,
								HGroupObject, NormalSpacing,
									StartMember, InfoObject, ButtonFrame, ShineRaster,  EndObject, EndMember,
									StartMember, InfoObject, ButtonFrame, ShadowRaster, EndObject, EndMember,
								EndObject,
							EndMember,
							StartMember,
								HGroupObject, NormalSpacing,
									StartMember, InfoObject, ButtonFrame, ShineShadowRaster, EndObject, EndMember,
									StartMember, InfoObject, ButtonFrame, FillRaster,    EndObject, EndMember,
								EndObject,
							EndMember,
							StartMember,
								HGroupObject, NormalSpacing,
									StartMember, InfoObject, ButtonFrame, ShineFillRaster,  EndObject, EndMember,
									StartMember, InfoObject, ButtonFrame, ShadowFillRaster, EndObject, EndMember,
								EndObject,
							EndMember,
							StartMember,
								HGroupObject, NormalSpacing,
									StartMember, InfoObject, ButtonFrame, ShineBlock,  EndObject, EndMember,
									StartMember, InfoObject, ButtonFrame, ShadowBlock, EndObject, EndMember,
								EndObject,
							EndMember,
						EndObject,
					EndMember,
					StartMember,
					   VGroupObject, NormalOffset, NeXTFrame, FrameTitle('Custom Hook'),
						  StartMember,
							 InfoObject, ButtonFrame, FRM_BackFillHook, backfill, EndObject,
						  EndMember,
					   EndObject,
					EndMember,
					StartMember,
						VGroupObject, NormalOffset, NeXTFrame, FrameTitle('Bitmap Pattern'),
							StartMember,
								InfoObject, ButtonFrame, FRM_FillPattern, bp, EndObject,
							EndMember,
						EndObject,
					EndMember,
				EndObject,
		EndObject
	ENDIF
	/*
	**  Object OK?
	**/
	IF wa_bfill
		/*
		**  Open window.
		**/
		window := WindowOpen( wa_bfill )
	ENDIF
ENDPROC window

/*
** Tabs-key control of the tabs gadget.
**/
PROC tabHookFunc( hook:PTR TO hook, obj:PTR TO object, msg:PTR TO intuimessage)
	DEF window:PTR TO window
	DEF mx_obj:PTR TO object
	DEF pos

	mx_obj := hook.data

	GetAttr( WINDOW_Window, obj,  {window} )
	GetAttr( MX_Active,  mx_obj, {pos} )

	IF ( msg.code = $42 )
		IF ( msg.qualifier AND ( IEQUALIFIER_LSHIFT OR IEQUALIFIER_RSHIFT ) ) THEN DEC pos ELSE INC pos
		SetGadgetAttrsA( mx_obj, window, NIL, [ MX_Active, pos, TAG_END ] )
	ENDIF
ENDPROC

/*
**  Open pages window.
**/
PROC openpageswindow()

	DEF c, p, m, s1, s2, s3,
	window:PTR TO window,pageshelp:PTR TO CHAR

	pageshelp :=    '\ecThe pageclass allows you to setup a set of pages containing\n'+
			'BGUI gadgets or groups. This will give you the oppertunity to\n'+
			'have several set\as of gadgets in a single window.\n\n'+
			'This window has a IDCMP-hook installed which allows you to\n'+
			'control the Tabs object with your TAB key.'


	/*
	**  Not yet created?
	**/
	IF wa_pages=NIL
		/*
		**  Create tabs-object.
		**/
		c := MxObject,
				MX_TabsObject,      TRUE,
				LAB_Label,      NIL,
				MX_Labels,      ['Buttons', 'Strings', 'CheckBoxes', 'Radio-Buttons', NIL ],
				MX_Active,      NIL,
				GA_ID,          NIL,
			 EndObject

		inithook( tabhook, {tabHookFunc}, c )

		wa_pages := WindowObject,
			WINDOW_Title,           'BGUI pages',
			WINDOW_RMBTrap,         TRUE,
			WINDOW_SmartRefresh,    TRUE,
			WINDOW_HelpText,        pageshelp,
			WINDOW_AutoAspect,      TRUE,
			WINDOW_SharedPort,      sharedport,
			WINDOW_IDCMPHookBits,   IDCMP_RAWKEY,
			WINDOW_IDCMPHook,       tabhook,
			WINDOW_AutoKeyLabel,    TRUE,
			WINDOW_CloseOnEsc,      TRUE,
			WINDOW_MasterGroup,
				VGroupObject, NormalOffset,
					StartMember, c, FixMinHeight, EndMember,
					StartMember, VGroupObject, FRM_Type, FRTYPE_TAB_ABOVE,
					StartMember,
						p := PageObject,
							/*
							**  Button page.
							**/
							PageMember,
								VGroupObject, Spacing(4), NormalOffset,
									VarSpace( DEFAULT_WEIGHT ),
									StartMember, PrefButton( 'Button #_1', 0 ), FixMinHeight, EndMember,
									StartMember, PrefButton( 'Button #_2', 0 ), FixMinHeight, EndMember,
									StartMember, PrefButton( 'Button #_3', 0 ), FixMinHeight, EndMember,
									VarSpace( DEFAULT_WEIGHT ),
								EndObject,
							/*
							**  String page.
							**/
							PageMember,
								VGroupObject, Spacing(4), NormalOffset,
									VarSpace( DEFAULT_WEIGHT ),
									StartMember, s1 := PrefString( 'String #_1', '', 256, 0 ), FixMinHeight, EndMember,
									StartMember, s2 := PrefString( 'String #_2', '', 256, 0 ), FixMinHeight, EndMember,
									StartMember, s3 := PrefString( 'String #_3', '', 256, 0 ), FixMinHeight, EndMember,
									VarSpace( DEFAULT_WEIGHT ),
								EndObject,
							/*
							**  CheckBox page.
							**/
							PageMember,
								VGroupObject, Spacing(4), NormalOffset,
									StartMember,
										HGroupObject, Spacing( 4 ),
											VarSpace( DEFAULT_WEIGHT ),
											StartMember,
												VGroupObject, Spacing( 4 ),
													VarSpace( DEFAULT_WEIGHT ),
													StartMember, CheckBox( 'CheckBox #_1', FALSE, 0 ), EndMember,
													StartMember, CheckBox( 'CheckBox #_2', FALSE, 0 ), EndMember,
													StartMember, CheckBox( 'CheckBox #_3', FALSE, 0 ), EndMember,
													VarSpace( DEFAULT_WEIGHT ),
												EndObject, FixMinWidth,
											EndMember,
											VarSpace( DEFAULT_WEIGHT ),
										EndObject,
									EndMember,
								EndObject,
							/*
							**  Mx page.
							**/
							PageMember,
								VGroupObject, Spacing(4), NormalOffset,
									VarSpace( DEFAULT_WEIGHT ),
									StartMember,
										HGroupObject,
											VarSpace( DEFAULT_WEIGHT ),
											StartMember, m := MxObject,
													GROUP_Style,    GRSTYLE_VERTICAL,
													GROUP_Spacing,  2,
													LAB_Label,      '_Mx Object',
													LAB_Place,      PLACE_ABOVE,
													LAB_Underscore, "_",
													LAB_Highlight,  TRUE,
													MX_Labels,      [ 'MX #1', 'MX #2', 'MX #3', 'MX #4', NIL ],
													MX_LabelPlace,  PLACE_LEFT,
													EndObject, FixMinSize,
											EndMember,
											VarSpace( DEFAULT_WEIGHT ),
										EndObject, FixMinHeight,
									EndMember,
									VarSpace( DEFAULT_WEIGHT ),
								EndObject,
						EndObject,
					EndMember,
					EndObject, EndMember,
				EndObject,
		EndObject

		/*
		**  Object OK?
		**/
		IF wa_pages
			/*
			**  Connect the cycle to the page.
			**/
			AddMap( c, p, [ MX_Active, PAGE_Active, TAG_END ] )
			/*
			**  Set tab-cycling order.
			**/
			domethod( wa_pages, [WM_TABCYCLE_ORDER, s1, s2, s3, NIL] )
		ENDIF
	ENDIF

	/*
	**  Object OK?
	**/
	IF wa_pages
		/*
		**  Open the window.
		**/
		window := WindowOpen( wa_pages )
	ENDIF
ENDPROC window
/*
**  Main entry.
**/
PROC main()

DEF main=NIL:PTR TO window, groups=NIL:PTR TO window, notif=NIL:PTR TO window,
	info=NIL:PTR TO window, image=NIL:PTR TO window, bfill=NIL:PTR TO window,
	pages=NIL:PTR TO window, sigwin = -1,
	apm:PTR TO appmessage, ap:PTR TO wbarg,
	sigmask = 0, sigrec, rc, appsig = 0, i,
	running = TRUE, name[ 256 ]:STRING, id
	/*
	**      Open the library.
	**/
	IF bguibase := OpenLibrary( 'bgui.library', BGUIVERSION )
		/*
		**  Create the shared message port.
		**/
		IF sharedport := CreateMsgPort()
			/*
			**  Open the main window.
			**/
			IF main := openmainwindow( {appsig} )
				/*
				**  OR signal masks.
				**/
				sigmask :=sigmask OR ( appsig OR Shl( 1,sharedport.sigbit ))
				/*
				**  Loop...
				**/
				WHILE running = TRUE
					/*
					**  Wait for the signals to come.
					**/
					sigrec := Wait( sigmask )
					/*
					**  AppWindow signal?
					**/
					IF ( sigrec AND appsig )
						/*
						**  Obtain AppWindow messages.
						**/
						WHILE apm := GetAppMsg( wa_main )
							/*
							**  Get all dropped icons.
							**/
							ap := apm.arglist
							FOR i := 0 TO apm.numargs - 1
								/* Build fully qualified name. */
								NameFromLock( ap[ i ].lock, name, 256 )
								AddPart( name, ap[ i ].name, 256 )
								/* Add it to the listview. */
								AddEntry( main, lv_iconlist, name, LVAP_SORTED )
							ENDFOR
							/*
							**  Important! We must reply the message!
							**/
							ReplyMsg( apm )
						ENDWHILE
						/*
						**  Switch to the Icon page.
						**/
						SetGadgetAttrsA(pg_pager, main, NIL,[ PAGE_Active, 1, TAG_END] )
					ENDIF
					/*
					**  Find out the which window signalled us.
					**/
					IF ( sigrec AND Shl( 1,sharedport.sigbit ))
						WHILE sigwin := domethod( wa_main,[ WM_GET_SIGNAL_WINDOW] )

							/*
							**  Main window signal?
							**/
							IF sigwin = main
								/*
								**  Call the main-window event handler.
								**/
								WHILE ( rc := HandleEvent( wa_main )) <> WMHI_NOMORE
									SELECT rc

										CASE    WMHI_CLOSEWINDOW
											running := FALSE
										CASE    ID_QUIT
											running := FALSE

										CASE    ID_ABOUT
											req( main, '_OK', '\ec\eb\ed8BGUIDemo in AmigaE!\en\ed2\n(C) Copyright 1993-1995 Jaba Development\nAmigaE''tized by Dominique Dutoit' )

										CASE    ID_MAIN_GROUPS
											/*
											**  Open groups window.
											**/
											 IF groups=NIL THEN groups := opengroupswindow()

										CASE    ID_MAIN_NOTIF
											/*
											**  Open notification window.
											**/
											 IF notif=NIL THEN notif := opennotifwindow()

										CASE    ID_MAIN_INFO
											/*
											**  Open infoclass window.
											**/
											 IF info=NIL THEN info := openinfowindow()

										CASE    ID_MAIN_IMAGE
											/*
											**  Open images window.
											**/
											 IF image=NIL THEN image := openimagewindow()

										CASE    ID_MAIN_BFILL
											/*
											**  Open backfill window.
											**/
											 IF bfill=NIL THEN bfill := openfillwindow()

										CASE    ID_MAIN_PAGES
											/*
											**  Open pages window.
											**/
											IF pages=NIL THEN pages := openpageswindow()

										CASE    ID_MAIN_ICON_CONT
											/*
											**  Switch back to the main page.
											**/
											SetGadgetAttrsA(pg_pager, main, NIL,[ PAGE_Active, 0, TAG_END] )
											/*
											**  Clear all entries from the listview.
											**/
											ClearList( main, lv_iconlist )
									ENDSELECT
								ENDWHILE
							ENDIF
							/*
							**  The code below will close the
							**  specific window.
							**/
							IF ( sigwin = groups )
								WHILE ( rc := HandleEvent( wa_groups )) <> WMHI_NOMORE
									SELECT rc
										CASE    ID_GROUP_W0
											id := rc - ID_GROUP_W0
											GetAttr(STRINGA_LONGVAL, w[id], {rc})
											SetAttrsA(w[id], [ LGO_Weight, rc, TAG_DONE ])
										CASE    ID_GROUP_W1
											id := rc - ID_GROUP_W0
											GetAttr(STRINGA_LONGVAL, w[id], {rc})
											SetAttrsA(w[id], [ LGO_Weight, rc, TAG_DONE ])
										CASE    ID_GROUP_W2
											id := rc - ID_GROUP_W0
											GetAttr(STRINGA_LONGVAL, w[id], {rc})
											SetAttrsA(w[id], [ LGO_Weight, rc, TAG_DONE ])
										CASE    ID_GROUP_W3
											id := rc - ID_GROUP_W0
											GetAttr(STRINGA_LONGVAL, w[id], {rc})
											SetAttrsA(w[id], [ LGO_Weight, rc, TAG_DONE ])
										CASE    WMHI_CLOSEWINDOW
											WindowClose( wa_groups )
											groups := NIL
									ENDSELECT
								ENDWHILE
							ENDIF

							IF ( sigwin = notif )
								WHILE ( rc := HandleEvent( wa_notif )) <> WMHI_NOMORE
									SELECT rc
										CASE    WMHI_CLOSEWINDOW
											WindowClose( wa_notif )
											notif := NIL
									ENDSELECT
								ENDWHILE
							ENDIF

							IF ( sigwin = info )
								WHILE ( rc := HandleEvent( wa_info )) <> WMHI_NOMORE
									SELECT rc
										CASE    WMHI_CLOSEWINDOW
											WindowClose( wa_info )
											info := NIL
									ENDSELECT
								ENDWHILE
							ENDIF

							IF ( sigwin = image )
								WHILE ( rc := HandleEvent( wa_image )) <> WMHI_NOMORE
									SELECT rc
										CASE    WMHI_CLOSEWINDOW
											WindowClose( wa_image )
											image := NIL
									ENDSELECT
								ENDWHILE
							ENDIF

							IF ( sigwin = bfill )
								WHILE ( rc := HandleEvent( wa_bfill )) <> WMHI_NOMORE
									SELECT rc
										CASE    WMHI_CLOSEWINDOW
											WindowClose( wa_bfill )
											bfill := NIL
									ENDSELECT
								ENDWHILE
							ENDIF

							IF ( sigwin = pages )
								WHILE ( rc := HandleEvent( wa_pages )) <> WMHI_NOMORE
									SELECT rc
										CASE    WMHI_CLOSEWINDOW
											WindowClose( wa_pages )
											pages := NIL
									ENDSELECT
								ENDWHILE
							ENDIF
						ENDWHILE
					ENDIF
				ENDWHILE
			ENDIF
			/*
			**  Dispose of all window objects.
			**/
			IF ( wa_pages )   THEN      DisposeObject( wa_pages )
			IF ( wa_bfill )   THEN      DisposeObject( wa_bfill )
			IF ( wa_image )   THEN      DisposeObject( wa_image )
			IF ( wa_info )    THEN      DisposeObject( wa_info )
			IF ( wa_notif )   THEN      DisposeObject( wa_notif )
			IF ( wa_groups )  THEN      DisposeObject( wa_groups )
			IF ( wa_main )    THEN      DisposeObject( wa_main )
			/*
			**  Delete the shared message port.
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
