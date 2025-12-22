/*

		MCC_MysticView © 1999 by Steve Quartly

		Registered class of the Magic User Interface.

		MysticView_mcc.h

*/


/*** Include stuff ***/

/*** MUI Defines ***/

#define MUIC_MysticView "MysticView.mcc"
#define MysticViewObject MUI_NewObject(MUIC_MysticView

#define MUISERIALNR_QUARTLY 31601
#define TAGBASE_QUARTLY ( TAG_USER | ( MUISERIALNR_QUARTLY << 16 ) )
#define TAGBASE_MYSTICVIEW ( TAGBASE_QUARTLY + 1500 )


/*** Methods ***/
#define MUIA_MysticView_DisplayMode 				( TAGBASE_MYSTICVIEW + 2 )
#define MUIA_MysticView_ShowArrows					( TAGBASE_MYSTICVIEW + 3 )
#define MUIA_MysticView_ShowPIP							( TAGBASE_MYSTICVIEW + 4 )
#define MUIA_MysticView_ShowCursor					( TAGBASE_MYSTICVIEW + 5 )
#define MUIA_MysticView_MouseDrag						( TAGBASE_MYSTICVIEW + 6 )
#define MUIA_MysticView_RotateLeftRelative	( TAGBASE_MYSTICVIEW + 7 )
#define MUIA_MysticView_RotateRightRelative	( TAGBASE_MYSTICVIEW + 8 )
#define MUIA_MysticView_RotateLeftAbsolute	( TAGBASE_MYSTICVIEW + 9 )
#define MUIA_MysticView_RotateRightAbsolute	( TAGBASE_MYSTICVIEW + 10 )
#define MUIA_MysticView_ResetRotate					( TAGBASE_MYSTICVIEW + 11 )
#define MUIA_MysticView_ZoomInRelative			( TAGBASE_MYSTICVIEW + 12 )
#define MUIA_MysticView_ZoomOutRelative			( TAGBASE_MYSTICVIEW + 13 )
#define MUIA_MysticView_ZoomInAbsolute			( TAGBASE_MYSTICVIEW + 14 )
#define MUIA_MysticView_ZoomOutAbsolute			( TAGBASE_MYSTICVIEW + 15 )
#define MUIA_MysticView_ResetZoom						( TAGBASE_MYSTICVIEW + 16 )
#define MUIA_MysticView_MoveLeftRelative		( TAGBASE_MYSTICVIEW + 17 )
#define MUIA_MysticView_MoveRightRelative		( TAGBASE_MYSTICVIEW + 18 )
#define MUIA_MysticView_MoveUpRelative			( TAGBASE_MYSTICVIEW + 19 )
#define MUIA_MysticView_MoveDownRelative		( TAGBASE_MYSTICVIEW + 20 )
#define MUIA_MysticView_MoveLeftAbsolute		( TAGBASE_MYSTICVIEW + 21 )
#define MUIA_MysticView_MoveRightAbsolute		( TAGBASE_MYSTICVIEW + 22 )
#define MUIA_MysticView_MoveUpAbsolute			( TAGBASE_MYSTICVIEW + 23 )
#define MUIA_MysticView_MoveDownAbsolute		( TAGBASE_MYSTICVIEW + 24 )
#define MUIA_MysticView_Center							( TAGBASE_MYSTICVIEW + 25 )
#define MUIA_MysticView_ResetAll						( TAGBASE_MYSTICVIEW + 26 )
#define MUIA_MysticView_FileName						( TAGBASE_MYSTICVIEW + 27 )
#define MUIA_MysticView_Picture							( TAGBASE_MYSTICVIEW + 28 )
#define MUIA_MysticView_RefreshMode					( TAGBASE_MYSTICVIEW + 29 )
#define MUIA_MysticView_StaticPalette				( TAGBASE_MYSTICVIEW + 30 )
#define MUIA_MysticView_ImageWidth					( TAGBASE_MYSTICVIEW + 31 )
#define MUIA_MysticView_ImageHeight					( TAGBASE_MYSTICVIEW + 32 )
#define MUIA_MysticView_BackColour					( TAGBASE_MYSTICVIEW + 33 )
#define MUIA_MysticView_TextColour					( TAGBASE_MYSTICVIEW + 34 )
#define MUIA_MysticView_MarkColour					( TAGBASE_MYSTICVIEW + 35 )
#define MUIA_MysticView_Text								( TAGBASE_MYSTICVIEW + 36 )

/*** Tags ***/


/*** Method structs ***/

/*** Special method values ***/


/*** Special method flags ***/


/*** Attributes ***/


/*** Special attribute values ***/
#define	MVDISPMODE_FIT					0		// image fits exactly into view
#define	MVDISPMODE_KEEPASPECT_MIN		1		// image is fully visible
#define	MVDISPMODE_KEEPASPECT_MAX		2		// width or height is fully visible
#define	MVDISPMODE_ONEPIXEL				3		// the image aspect is ignored
#define	MVDISPMODE_IGNOREASPECT			4		// aspect ratios are ignored

#define	MVPREVMODE_NONE					0		// no realtime refresh
#define	MVPREVMODE_GRID					1		// grid realtime refresh
#define	MVPREVMODE_OPAQUE				2		// opaque realtime refresh

/*** Structures, Flags & Values ***/


/*** Configs ***/

/*** Errors ***/
