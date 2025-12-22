/*
    C source code created by Interface Editor
    Copyright © 1994-1996 by Simone Tellini

    Generator:  C.generator 37.15 (6.12.96)

    Copy registered to :  Simone Tellini
    Serial Number      : #0
*/

#include <exec/types.h>
#include <exec/nodes.h>
#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <libraries/gadtools.h>
#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/graphics_protos.h>
#ifdef PRAGMAS
#include <pragmas/exec_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <pragmas/graphics_pragmas.h>
#include <pragmas/gadtools_pragmas.h>
#endif
#include <ctype.h>
#include <string.h>

#include "MultiSelect.h"



APTR			VisualInfo;
int			YOffset;
UWORD			XOffset;
struct Screen		*Scr = NULL;
struct TextAttr		*Font, Attr;
UWORD			FontX, FontY;
UBYTE			*PubScreenName = NULL;
struct Window		*MainWnd = NULL;
struct Gadget		*MainGList = NULL;
struct IntuiMessage	MainMsg;
struct Gadget		*MainGadgets[2];

UBYTE String0[] = "IEditor - MultiSelect Listview Test";
UBYTE String1[] = "_Quit";
UBYTE String2[] = "Test";
UBYTE String3[] = "This";
UBYTE String4[] = "is";
UBYTE String5[] = "a";
UBYTE String6[] = "test";
UBYTE String7[] = "for";
UBYTE String8[] = "MultiSelect";
UBYTE String9[] = "listviews";

struct Node ListNodes[] = {
	&ListNodes[1], (struct Node *)&ListList.mlh_Head, 0, 0, String3,
	&ListNodes[2], &ListNodes[0], 0, 0, String4,
	&ListNodes[3], &ListNodes[1], 0, 0, String5,
	&ListNodes[4], &ListNodes[2], 0, 0, String6,
	&ListNodes[5], &ListNodes[3], 0, 0, String7,
	&ListNodes[6], &ListNodes[4], 0, 0, String8,
	(struct Node *)&ListList.mlh_Tail, &ListNodes[5], 0, 0, String9 };

struct MinList ListList = {
	(struct MinNode *)&ListNodes[0], (struct MinNode *)NULL, (struct MinNode *)&ListNodes[6] };

UWORD MainGTypes[] = {
	BUTTON_KIND,
	LISTVIEW_KIND,
	NULL };

struct Hook ListHook = {
	{ 0 },
	(HOOKFUNC)ListHookFunc,
	NULL,
	NULL
};

struct NewGadget MainNGad[] = {
	293, 2, 78, 15, (UBYTE *)String1, NULL, GD_Quit, NULL, NULL, (APTR)QuitClicked,
	11, 21, 295, 108, (UBYTE *)String2, NULL, GD_List, NG_HIGHLABEL, NULL, (APTR)ListClicked
};

ULONG MainGTags[] = {
	(GT_Underscore), '_', (TAG_DONE),
	(GT_Underscore), '_', (GTLV_Labels), (ULONG)&ListList, (GTLV_CallBack), (ULONG)&ListHook, (TAG_DONE)
};

struct TagItem MainWTags[] = {
	{ WA_Left, 101 },
	{ WA_Top, 60 },
	{ WA_Width, 398 },
	{ WA_Height, 134 },
	{ WA_MinWidth, 0 },
	{ WA_MaxWidth, -1 },
	{ WA_MinHeight, 0 },
	{ WA_MaxHeight, -1 },
	{ WA_PubScreen, NULL },
	{ WA_Title, (ULONG)String0 },
	{ WA_Flags, WFLG_SIZEGADGET|WFLG_DRAGBAR|WFLG_DEPTHGADGET|WFLG_CLOSEGADGET|WFLG_SIMPLE_REFRESH|WFLG_NEWLOOKMENUS },
	{ WA_IDCMP, BUTTONIDCMP|LISTVIEWIDCMP|IDCMP_REFRESHWINDOW|IDCMP_GADGETUP|IDCMP_CLOSEWINDOW|IDCMP_VANILLAKEY },
	{ WA_Gadgets, NULL },
	{ TAG_DONE, NULL }
};

WORD ScaleX( WORD value )
{
	return(( WORD )((( FontX * value ) + 4 ) / 8 ));
}

WORD ScaleY( WORD value )
{
	return(( WORD )((( FontY * value ) + 4 ) / 8 ));
}

static void ComputeFont( UWORD width, UWORD height )
{
	Font = &Attr;
	Font->ta_Name = (STRPTR)Scr->RastPort.Font->tf_Message.mn_Node.ln_Name;
	Font->ta_YSize = FontY = Scr->RastPort.Font->tf_YSize;
	FontX = Scr->RastPort.Font->tf_XSize;

	XOffset = Scr->WBorLeft;
	YOffset = Scr->RastPort.TxHeight + Scr->WBorTop;

	if( width && height )
		if((( ScaleX( width ) + Scr->WBorRight ) > Scr->Width ) ||
			(( ScaleY( height ) + Scr->WBorBottom + YOffset ) > Scr->Height ))
				{
					Font->ta_Name = (STRPTR)"topaz.font";
					FontX = FontY = Font->ta_YSize = 8;
				}
}

int SetupScreen( void )
{
	if(!( Scr = LockPubScreen( PubScreenName )))
		return( 1L );

	ComputeFont( 0, 0 );

	if(!( VisualInfo = GetVisualInfo( Scr, TAG_DONE )))
		return( 2L );

	return( 0L );
}

void CloseDownScreen( void )
{
	if( VisualInfo ) {
		FreeVisualInfo( VisualInfo );
		VisualInfo = NULL;
	}

	if( Scr ) {
		UnlockPubScreen( NULL, Scr );
		Scr = NULL;
	}

}

LONG OpenWnd( struct Gadget *GList, struct TagItem WTags[], struct Window **Wnd )
{
	UWORD		tc;
	UWORD		ww, wh, oldww, oldwh;

	if( GList ) {
		tc = 0;
		while( WTags[ tc ].ti_Tag != WA_Gadgets ) tc++;
		WTags[ tc ].ti_Data = (ULONG)GList;
	}

	ww = ScaleX( WTags[ WT_WIDTH  ].ti_Data ) + XOffset + Scr->WBorRight;
	wh = ScaleY( WTags[ WT_HEIGHT ].ti_Data ) + YOffset + Scr->WBorBottom;

	if(( WTags[ WT_LEFT ].ti_Data + ww ) > Scr->Width  )
		WTags[ WT_LEFT ].ti_Data = Scr->Width  - ww;
	if(( WTags[ WT_TOP  ].ti_Data + wh ) > Scr->Height )
		WTags[ WT_TOP  ].ti_Data = Scr->Height - wh;

	oldww = WTags[ WT_WIDTH  ].ti_Data;
	oldwh = WTags[ WT_HEIGHT ].ti_Data;
	WTags[ WT_WIDTH  ].ti_Data = ww;
	WTags[ WT_HEIGHT ].ti_Data = wh;

	WTags[8].ti_Data = (ULONG)Scr;

	*Wnd = OpenWindowTagList( NULL, &WTags[0] );

	WTags[ WT_WIDTH  ].ti_Data = oldww;
	WTags[ WT_HEIGHT ].ti_Data = oldwh;

	if(!( *Wnd ))
		return( 4L );

	GT_RefreshWindow( *Wnd, NULL );
	return( 0L );
}

void CloseWnd( struct Window **Wnd, struct Gadget **GList, struct Menu **Mn )
{
	if( Mn ) {
		if( *Wnd )
			ClearMenuStrip( *Wnd );

		FreeMenus( *Mn );
		*Mn = NULL;
	}
	if( *Wnd ) {
		CloseWindow( *Wnd );
		*Wnd = NULL;
	}
	if( GList ) {
		FreeGadgets( *GList );
		*GList = NULL;
	}
}

struct Gadget *MakeGadgets( struct Gadget **GList, struct Gadget *Gads[],
	struct NewGadget NGad[], UWORD GTypes[], ULONG GTags[], UWORD CNT )
{
	struct Gadget		*g;
	UWORD			lc, tc;
	struct NewGadget	ng;

	if(!( g = CreateContext( GList )))
		return( (struct Gadget *)-1 );

	for( lc = 0, tc = 0; lc < CNT; lc++ ) {

		CopyMem(( char * )&NGad[ lc ], ( char * )&ng, ( long )sizeof( struct NewGadget ));
		ng.ng_VisualInfo = VisualInfo;
		ng.ng_TextAttr = Font;
		ng.ng_LeftEdge = XOffset + ScaleX( ng.ng_LeftEdge );
		ng.ng_TopEdge  = YOffset + ScaleY( ng.ng_TopEdge  );
		ng.ng_Width    = ScaleX( ng.ng_Width  );
		ng.ng_Height   = ScaleY( ng.ng_Height );
		Gads[ lc ] = g = CreateGadgetA((ULONG)GTypes[ lc ], g, &ng, (struct TagItem *)&GTags[ tc ] );

		while( GTags[ tc ] )
			tc += 2;
		tc++;

		if( !g )
			return( (struct Gadget *)-2 );
	}

	return( g );
}

__geta4 ULONG ListHookFunc( A0( struct Hook *Hook ), A1( struct LVDrawMsg *Msg ), A2( struct Node *Node ))
{
	ULONG			len;
	struct TextExtent	extent;

	if( Msg->lvdm_MethodID != LV_DRAW ) {
		return( LVCB_UNKNOWN );
	}

	switch( Msg->lvdm_State ) {
		case LVR_NORMAL:
		case LVR_NORMALDISABLED:
		case LVR_SELECTED:
		case LVR_SELECTEDDISABLED:
		len = TextFit( Msg->lvdm_RastPort, Node->ln_Name,
		               strlen( Node->ln_Name ), &extent, NULL, 1,
		               Msg->lvdm_Bounds.MaxX - Msg->lvdm_Bounds.MinX - 3,
		               Msg->lvdm_Bounds.MaxY - Msg->lvdm_Bounds.MinY + 1 );

		Move( Msg->lvdm_RastPort, Msg->lvdm_Bounds.MinX + 2,
		      Msg->lvdm_Bounds.MinY + Msg->lvdm_RastPort->TxBaseline );

		if( Node->ln_Pri & ML_SELECTED ) {
			SetABPenDrMd( Msg->lvdm_RastPort, Msg->lvdm_DrawInfo->dri_Pens[ FILLTEXTPEN ],
			              Msg->lvdm_DrawInfo->dri_Pens[ FILLPEN ], JAM2 );
		} else {
			SetABPenDrMd( Msg->lvdm_RastPort, Msg->lvdm_DrawInfo->dri_Pens[ TEXTPEN ],
			              Msg->lvdm_DrawInfo->dri_Pens[ BACKGROUNDPEN ], JAM2 );
		}

		Text( Msg->lvdm_RastPort, Node->ln_Name, len );

		SetAPen( Msg->lvdm_RastPort, Msg->lvdm_DrawInfo->dri_Pens[( Node->ln_Pri & ML_SELECTED ) ? FILLPEN : BACKGROUNDPEN ]);
		RectFill( Msg->lvdm_RastPort, Msg->lvdm_RastPort->cp_x, Msg->lvdm_Bounds.MinY,
		          Msg->lvdm_Bounds.MaxX, Msg->lvdm_Bounds.MaxY );
		break;
	}

	return( LVCB_OK );
}


LONG OpenMainWindow( void )
{
	LONG		ret_code = NULL;
	struct Gadget	*g;

	ComputeFont( 398, 134 );

	g = MakeGadgets( &MainGList, MainGadgets, MainNGad,
		MainGTypes, MainGTags, Main_CNT );
	if( (LONG)g < 0 )
		return( -((LONG)g) );
	ret_code = OpenWnd( MainGList, MainWTags, &MainWnd );
	if( ret_code )
		return( ret_code );
	return( 0L );
}

void CloseMainWindow( void )
{

	CloseWnd( &MainWnd, &MainGList, NULL );

}

LONG HandleMainIDCMP( void )
{
	struct IntuiMessage	*m;
	BOOL			(*func)(void);
	BOOL			running = TRUE;
	int			class;

	while( m = GT_GetIMsg( MainWnd->UserPort )) {

		CopyMem((char *)m, (char *)&MainMsg, (long)sizeof( struct IntuiMessage ));

		class = MainMsg.Class;

		GT_ReplyIMsg( m );

		switch( class ) {

			case	IDCMP_VANILLAKEY:
				running = HandleMainKeys();
				break;

			case	IDCMP_REFRESHWINDOW:
				GT_BeginRefresh( MainWnd );
				GT_EndRefresh( MainWnd, TRUE );
				break;

			case	IDCMP_GADGETUP:
				func = (( struct Gadget * )MainMsg.IAddress )->UserData;
				running = (*func)();
				break;

			case	IDCMP_CLOSEWINDOW:
				running = MainCloseWindow();
				break;

		}
	}
	return( running );
}

BOOL HandleMainKeys( void )
{
	BOOL running = TRUE;

	switch( tolower( MainMsg.Code )) {

		case	'q':
			running = QuitKeyPressed();
		break;

	}
	return( running );
}
