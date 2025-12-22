/*
    C source code created by Interface Editor
    Copyright © 1994-1996 by Simone Tellini

    Generator:  C_IE_Mod.generator 37.1 (29.4.96)

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

#include "DEV_IE:Include/IEditor.h"

#include "Config.h"


UWORD ConfGTypes[] = {
	CHECKBOX_KIND,
	CHECKBOX_KIND,
	BUTTON_KIND,
	BUTTON_KIND,
	CHECKBOX_KIND,
	CHECKBOX_KIND,
	CHECKBOX_KIND,
	CHECKBOX_KIND,
	STRING_KIND,
	CHECKBOX_KIND,
	CHECKBOX_KIND,
	STRING_KIND,
	BUTTON_KIND,
	BUTTON_KIND,
	CHECKBOX_KIND,
	STRING_KIND,
	STRING_KIND,
	CHECKBOX_KIND,
	NULL };

struct TextAttr topaz8_065 = {
	(STRPTR)"topaz.font", 8, 0x0, 0x41 };

struct NewGadget ConfNGad[] = {
	133, 3, 26, 11, "Intui_Message", &topaz8_065, GD_Msg, NULL, NULL, (APTR)MsgClicked,
	291, 3, 26, 11, "Clicked Pt_r", &topaz8_065, GD_Click, NULL, NULL, (APTR)ClickClicked,
	7, 125, 94, 14, "_Use", &topaz8_065, GD_Use, NULL, NULL, (APTR)UseClicked,
	241, 125, 94, 14, "_Cancel", &topaz8_065, GD_Canc, NULL, NULL, (APTR)CancClicked,
	133, 15, 26, 11, "IDCMP _Handler", &topaz8_065, GD_Handler, NULL, NULL, (APTR)HandlerClicked,
	291, 15, 26, 11, "_Key Handler", &topaz8_065, GD_KeyHandler, NULL, NULL, (APTR)KeyHandlerClicked,
	133, 27, 26, 11, "_Template", &topaz8_065, GD_Template, NULL, NULL, (APTR)TemplateClicked,
	291, 39, 26, 11, "To Lo_wer", &topaz8_065, GD_ToLower, NULL, NULL, (APTR)ToLowerClicked,
	112, 65, 223, 13, "UW_ORD chip:", &topaz8_065, GD_Chip, PLACETEXT_LEFT, NULL, (APTR)ChipClicked,
	133, 39, 26, 11, "Sm_art String", NULL, GD_SmartStr, NULL, NULL, (APTR)SmartStrClicked,
	291, 27, 26, 11, "Only _New Tmp", NULL, GD_NewTmp, NULL, NULL, (APTR)NewTmpClicked,
	112, 107, 202, 13, "Hea_ders:", &topaz8_065, GD_Headers, PLACETEXT_LEFT, NULL, (APTR)HeadersClicked,
	316, 107, 19, 13, "R", NULL, GD_GetH, NULL, NULL, (APTR)GetHClicked,
	124, 125, 94, 14, "_Save", &topaz8_065, GD_Save, NULL, NULL, (APTR)SaveClicked,
	133, 51, 26, 11, "Us_e CatComp", NULL, GD_CatComp, NULL, NULL, (APTR)CatCompClicked,
	112, 79, 223, 13, "HOOK_:", NULL, GD_Hook, NULL, NULL, (APTR)HookClicked,
	112, 93, 223, 13, "Ax Re_gister:", NULL, GD_Reg, NULL, NULL, (APTR)RegClicked,
	291, 51, 26, 11, "No Button K._P.", NULL, GD_NoKP, NULL, NULL, (APTR)NoKPClicked
};

ULONG ConfGTags[] = {
	(GT_Underscore), '_', (GTCB_Scaled), TRUE, (TAG_DONE),
	(GT_Underscore), '_', (GTCB_Scaled), TRUE, (TAG_DONE),
	(GT_Underscore), '_', (TAG_DONE),
	(GT_Underscore), '_', (TAG_DONE),
	(GT_Underscore), '_', (GTCB_Scaled), TRUE, (TAG_DONE),
	(GT_Underscore), '_', (GTCB_Scaled), TRUE, (TAG_DONE),
	(GT_Underscore), '_', (GTCB_Scaled), TRUE, (TAG_DONE),
	(GT_Underscore), '_', (GTCB_Scaled), TRUE, (TAG_DONE),
	(GT_Underscore), '_', (GTST_MaxChars), 24, (TAG_DONE),
	(GT_Underscore), '_', (GTCB_Scaled), TRUE, (TAG_DONE),
	(GT_Underscore), '_', (GTCB_Scaled), TRUE, (TAG_DONE),
	(GT_Underscore), '_', (GTST_MaxChars), 256, (TAG_DONE),
	(TAG_DONE),
	(GT_Underscore), '_', (TAG_DONE),
	(GT_Underscore), '_', (GTCB_Scaled), TRUE, (TAG_DONE),
	(GT_Underscore), '_', (GTST_MaxChars), 32, (TAG_DONE),
	(GT_Underscore), '_', (GTST_MaxChars), 32, (TAG_DONE),
	(GT_Underscore), '_', (GTCB_Scaled), TRUE, (TAG_DONE)
};

UWORD ScaleX( UWORD FontX, UWORD value )
{
	return(( UWORD )((( FontX * value ) + 4 ) / 8 ));
}

UWORD ScaleY( UWORD FontY, UWORD value )
{
	return(( UWORD )((( FontY * value ) + 4 ) / 8 ));
}

void CloseWnd( struct Window **Wnd, struct Gadget **GList )
{
	if( *Wnd ) {
		CloseWindow( *Wnd );
		*Wnd = NULL;
	}
	if( GList ) {
		FreeGadgets( *GList );
		*GList = NULL;
	}
}

LONG OpenConfWindow( struct Window **Wnd, struct Gadget **GList, struct Gadget *Gadgets[], struct IE_Data *IE )
{
	LONG		ret_code = NULL;
	UWORD		FontX, FontY;
	struct TextAttr	*Font;

	Font = IE->ScreenData->Screen->Font;
	FontY = IE->ScreenData->Screen->RastPort.Font->tf_YSize;
	FontX = IE->ScreenData->Screen->RastPort.Font->tf_XSize;

	if((( ScaleX( FontX, 346 ) + IE->ScreenData->Screen->WBorRight + IE->ScreenData->XOffset ) > IE->ScreenData->Screen->Width ) ||
		(( ScaleY( FontY, 141 ) + IE->ScreenData->Screen->WBorBottom + IE->ScreenData->YOffset ) > IE->ScreenData->Screen->Height )) {
			Font = &topaz8_065;
			FontX = FontY = 8;
		}

	struct Gadget		*g;
	UWORD			lc, tc;
	struct NewGadget	ng;

	if(!( g = CreateContext( GList )))
		return( 1L );

	for( lc = 0, tc = 0; lc < Conf_CNT; lc++ ) {

		CopyMem(( char * )&ConfNGad[ lc ], ( char * )&ng, ( long )sizeof( struct NewGadget ));
		ng.ng_VisualInfo = IE->ScreenData->Visual;
		ng.ng_TextAttr = Font;
		ng.ng_LeftEdge = IE->ScreenData->XOffset + ScaleX( FontX, ng.ng_LeftEdge );
		ng.ng_TopEdge  = IE->ScreenData->YOffset + ScaleY( FontY, ng.ng_TopEdge  );
		ng.ng_Width    = ScaleX( FontX, ng.ng_Width  );
		ng.ng_Height   = ScaleY( FontY, ng.ng_Height );
		Gadgets[ lc ] = g = CreateGadgetA((ULONG)ConfGTypes[ lc ], g, &ng, (struct TagItem *)&ConfGTags[ tc ] );

		while( ConfGTags[ tc ] ) tc += 2;
		tc++;

		if( !g )
			return( 2L );
	}


	struct TagItem WTags[] = {
		{ WA_Left, 146 },
		{ WA_Top, 62 },
		{ WA_Width, ScaleX( FontX, 346 ) + IE->ScreenData->XOffset + IE->ScreenData->Screen->WBorRight },
		{ WA_Height, ScaleY( FontY, 141 ) + IE->ScreenData->YOffset + IE->ScreenData->Screen->WBorBottom },
		{ WA_MinWidth, 0 },
		{ WA_MaxWidth, -1 },
		{ WA_MinHeight, 0 },
		{ WA_MaxHeight, -1 },
		{ WA_PubScreen, IE->ScreenData->Screen },
		{ WA_Title, (ULONG)"C.generator Config" },
		{ WA_Flags, WFLG_DRAGBAR|WFLG_DEPTHGADGET|WFLG_SIMPLE_REFRESH|WFLG_ACTIVATE|WFLG_RMBTRAP },
		{ WA_IDCMP, BUTTONIDCMP|CHECKBOXIDCMP|STRINGIDCMP|IDCMP_REFRESHWINDOW|IDCMP_GADGETUP|IDCMP_VANILLAKEY },
		{ WA_Gadgets, *GList },
		{ TAG_DONE, NULL }
	};

	WTags[ WT_LEFT ].ti_Data = (IE->ScreenData->Screen->Width  - WTags[ WT_WIDTH  ].ti_Data) >> 1;
	WTags[ WT_TOP  ].ti_Data = (IE->ScreenData->Screen->Height - WTags[ WT_HEIGHT ].ti_Data) >> 1;

	if(!( *Wnd = OpenWindowTagList( NULL, &WTags[0] )))
		return( 4L );

	GT_RefreshWindow( *Wnd, NULL );
	return( 0L );
}

LONG HandleConfIDCMP( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )
{
	struct IntuiMessage	*m, Msg;
	BOOL			(*func)( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
	BOOL			running = TRUE;
	int			class;
	short			code;
	struct Gadget	*gad;

	while( m = GT_GetIMsg( Wnd->UserPort )) {

		class = m->Class;
		code  = m->Code;
		gad   = (struct Gadget *)m->IAddress;

		CopyMem((char *)m, (char *)&Msg, (long)sizeof( struct IntuiMessage ));

		GT_ReplyIMsg( m );

		switch( class ) {

			case	IDCMP_VANILLAKEY:
				running = HandleConfKeys( code, Wnd, Gadgets, IE, &Msg );
				break;

			case	IDCMP_REFRESHWINDOW:
				GT_BeginRefresh( Wnd );
				GT_EndRefresh( Wnd, TRUE );
				break;

			case	IDCMP_GADGETUP:
				func = gad->UserData;
				running = (*func)( Wnd, Gadgets, IE, &Msg );
				break;

		}
	}
	return( running );
}

BOOL HandleConfKeys( UBYTE Code, struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	BOOL running = TRUE;

	switch( tolower( Code )) {

		case	'm':
			running = MsgKeyPressed( Wnd, Gadgets, IE, Msg );
			break;

		case	'r':
			running = ClickKeyPressed( Wnd, Gadgets, IE, Msg );
			break;

		case	'u':
			running = UseKeyPressed( Wnd, Gadgets, IE, Msg );
			break;

		case	'c':
			running = CancKeyPressed( Wnd, Gadgets, IE, Msg );
			break;

		case	'h':
			running = HandlerKeyPressed( Wnd, Gadgets, IE, Msg );
			break;

		case	'k':
			running = KeyHandlerKeyPressed( Wnd, Gadgets, IE, Msg );
			break;

		case	't':
			running = TemplateKeyPressed( Wnd, Gadgets, IE, Msg );
			break;

		case	'w':
			running = ToLowerKeyPressed( Wnd, Gadgets, IE, Msg );
			break;

		case	'o':
			if(!( Gadgets[ GD_Chip ]->Flags & GFLG_DISABLED ))
				ActivateGadget( Gadgets[ GD_Chip ], Wnd, NULL );
			break;

		case	'a':
			running = SmartStrKeyPressed( Wnd, Gadgets, IE, Msg );
			break;

		case	'n':
			running = NewTmpKeyPressed( Wnd, Gadgets, IE, Msg );
			break;

		case	'd':
			if(!( Gadgets[ GD_Headers ]->Flags & GFLG_DISABLED ))
				ActivateGadget( Gadgets[ GD_Headers ], Wnd, NULL );
			break;

		case	's':
			running = SaveKeyPressed( Wnd, Gadgets, IE, Msg );
			break;

		case	'e':
			running = CatCompKeyPressed( Wnd, Gadgets, IE, Msg );
			break;

		case	':':
			if(!( Gadgets[ GD_Hook ]->Flags & GFLG_DISABLED ))
				ActivateGadget( Gadgets[ GD_Hook ], Wnd, NULL );
			break;

		case	'g':
			if(!( Gadgets[ GD_Reg ]->Flags & GFLG_DISABLED ))
				ActivateGadget( Gadgets[ GD_Reg ], Wnd, NULL );
			break;

		case	'p':
			running = NoKPKeyPressed( Wnd, Gadgets, IE, Msg );
			break;

	}
	return( running );
}
