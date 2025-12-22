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

#include "Edit.h"


UBYTE *FreeLabels[] = {
	(UBYTE *)"Horizontal",
	(UBYTE *)"Vertical",
	NULL
};

UWORD MainGTypes[] = {
	BUTTON_KIND,
	BUTTON_KIND,
	MX_KIND,
	STRING_KIND,
	NULL };

struct TextAttr topaz8_065 = {
	(STRPTR)"topaz.font", 8, 0x0, 0x41 };

struct NewGadget MainNGad[] = {
	4, 43, 133, 14, "_Ok", &topaz8_065, GD_Ok, NULL, NULL, (APTR)OkClicked,
	247, 43, 133, 14, "_Cancel", &topaz8_065, GD_Canc, NULL, NULL, (APTR)CancClicked,
	259, 19, 17, 9, "_Freedom", &topaz8_065, GD_Free, PLACETEXT_RIGHT, NULL, (APTR)FreeClicked,
	79, 14, 153, 14, "_Label :", &topaz8_065, GD_Label, NULL, NULL, (APTR)LabelClicked
};

ULONG MainGTags[] = {
	(GT_Underscore), '_', (TAG_DONE),
	(GT_Underscore), '_', (TAG_DONE),
	(GT_Underscore), '_', (GTMX_Labels), (ULONG)&FreeLabels[0], (GTMX_TitlePlace), PLACETEXT_ABOVE, (TAG_DONE),
	(GT_Underscore), '_', (GTST_MaxChars), 40, (TAG_DONE)
};

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

LONG OpenMainWindow( struct Window **Wnd, struct Gadget **GList, struct Gadget *Gadgets[], struct IE_Data *IE )
{
	LONG		ret_code = NULL;

	struct Gadget		*g;
	UWORD			lc, tc;
	struct NewGadget	ng;

	if(!( g = CreateContext( GList )))
		return( 1L );

	for( lc = 0, tc = 0; lc < Main_CNT; lc++ ) {

		CopyMem(( char * )&MainNGad[ lc ], ( char * )&ng, ( long )sizeof( struct NewGadget ));
		ng.ng_VisualInfo = IE->ScreenData->Visual;
		ng.ng_TopEdge  += IE->ScreenData->YOffset;
		ng.ng_LeftEdge += IE->ScreenData->XOffset;
		Gadgets[ lc ] = g = CreateGadgetA((ULONG)MainGTypes[ lc ], g, &ng, (struct TagItem *)&MainGTags[ tc ] );

		while( MainGTags[ tc ] ) tc += 2;
		tc++;

		if( !g )
			return( 2L );
	}


	struct TagItem WTags[] = {
		{ WA_Left, 86 },
		{ WA_Top, 78 },
		{ WA_Width, 388 + IE->ScreenData->XOffset },
		{ WA_Height, 60 + IE->ScreenData->YOffset },
		{ WA_MinWidth, 0 },
		{ WA_MaxWidth, -1 },
		{ WA_MinHeight, 0 },
		{ WA_MaxHeight, -1 },
		{ WA_PubScreen, IE->ScreenData->Screen },
		{ WA_Title, (ULONG)"FuelGauge" },
		{ WA_Flags, WFLG_DRAGBAR|WFLG_DEPTHGADGET|WFLG_SIMPLE_REFRESH|WFLG_ACTIVATE|WFLG_RMBTRAP },
		{ WA_IDCMP, BUTTONIDCMP|MXIDCMP|STRINGIDCMP|IDCMP_REFRESHWINDOW|IDCMP_GADGETDOWN|IDCMP_GADGETUP|IDCMP_VANILLAKEY },
		{ WA_Gadgets, *GList },
		{ TAG_DONE, NULL }
	};

	if(!( *Wnd = OpenWindowTagList( NULL, &WTags[0] )))
		return( 4L );

	GT_RefreshWindow( *Wnd, NULL );

	MainRender( *Wnd, IE );
	return( 0L );
}

void MainRender( struct Window *Wnd, struct IE_Data *IE )
{

	DrawBevelBox( Wnd->RPort, 3 + IE->ScreenData->XOffset, 2 + IE->ScreenData->YOffset, 240, 41,
		GT_VisualInfo, IE->ScreenData->Visual, GTBB_Recessed, TRUE, TAG_DONE );

	DrawBevelBox( Wnd->RPort, 243 + IE->ScreenData->XOffset, 2 + IE->ScreenData->YOffset, 137, 41,
		GT_VisualInfo, IE->ScreenData->Visual, GTBB_Recessed, TRUE, TAG_DONE );
}

LONG HandleMainIDCMP( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )
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

			case	IDCMP_GADGETUP:
			case	IDCMP_GADGETDOWN:
				func = gad->UserData;
				running = (*func)( Wnd, Gadgets, IE, &Msg );
				break;

			case	IDCMP_VANILLAKEY:
				running = HandleMainKeys( code, Wnd, Gadgets, IE, &Msg );
				break;

			case	IDCMP_REFRESHWINDOW:
				GT_BeginRefresh( Wnd );
				MainRender( Wnd, IE );
				GT_EndRefresh( Wnd, TRUE );
				break;

		}
	}
	return( running );
}

BOOL HandleMainKeys( UBYTE Code, struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	BOOL running = TRUE;

	switch( tolower( Code )) {

		case	'o':
			running = OkKeyPressed( Wnd, Gadgets, IE, Msg );
			break;

		case	'c':
			running = CancKeyPressed( Wnd, Gadgets, IE, Msg );
			break;

		case	'f':
			running = FreeKeyPressed( Wnd, Gadgets, IE, Msg );
			break;

		case	'l':
			if(!( Gadgets[ GD_Label ]->Flags & GFLG_DISABLED ))
				ActivateGadget( Gadgets[ GD_Label ], Wnd, NULL );
			break;

		default:
			running = MainVanillaKey( Code, Wnd, Gadgets, IE );
			break;

	}
	return( running );
}
