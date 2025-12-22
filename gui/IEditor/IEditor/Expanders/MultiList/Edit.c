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


UBYTE *PosTitLabels[] = {
	(UBYTE *)"Left",
	(UBYTE *)"Right",
	(UBYTE *)"Above",
	(UBYTE *)"Below",
	(UBYTE *)"In",
	(UBYTE *)"Default",
	NULL
};

UWORD TagsGTypes[] = {
	STRING_KIND,
	STRING_KIND,
	CYCLE_KIND,
	CHECKBOX_KIND,
	CHECKBOX_KIND,
	BUTTON_KIND,
	BUTTON_KIND,
	INTEGER_KIND,
	INTEGER_KIND,
	INTEGER_KIND,
	INTEGER_KIND,
	CHECKBOX_KIND,
	CHECKBOX_KIND,
	CHECKBOX_KIND,
	INTEGER_KIND,
	INTEGER_KIND,
	NULL };

struct TextAttr topaz8_065 = {
	(STRPTR)"topaz.font", 8, 0x0, 0x41 };

struct NewGadget TagsNGad[] = {
	65, 6, 182, 14, "Tit_le", &topaz8_065, GD_Tit, NULL, NULL, (APTR)TitClicked,
	65, 21, 182, 14, "La_bel", &topaz8_065, GD_Label, NULL, NULL, (APTR)LabelClicked,
	88, 36, 159, 14, "_Position", &topaz8_065, GD_PosTit, NULL, NULL, (APTR)PosTitClicked,
	103, 51, 26, 11, "_Underscore", &topaz8_065, GD_Und, NULL, NULL, (APTR)UndClicked,
	221, 51, 26, 11, "H_ighlight", &topaz8_065, GD_High, NULL, NULL, (APTR)HighClicked,
	5, 121, 128, 14, "_Ok", &topaz8_065, GD_Ok, NULL, NULL, (APTR)OkClicked,
	337, 121, 127, 14, "_Cancel", &topaz8_065, GD_Annulla, NULL, NULL, (APTR)AnnullaClicked,
	381, 19, 74, 14, "_Top         ", &topaz8_065, GD_Top, NULL, NULL, (APTR)TopClicked,
	381, 34, 74, 14, "Make _Visible", &topaz8_065, GD_Vis, NULL, NULL, (APTR)VisClicked,
	183, 70, 64, 14, "Scroll _Width", &topaz8_065, GD_ScW, NULL, NULL, (APTR)ScWClicked,
	183, 85, 64, 14, "Sp_acing     ", &topaz8_065, GD_Spc, NULL, NULL, (APTR)SpcClicked,
	102, 106, 26, 11, "_Disabled", &topaz8_065, GD_Disab, NULL, NULL, (APTR)DisabClicked,
	266, 106, 26, 11, "_Read Only", &topaz8_065, GD_ROn, NULL, NULL, (APTR)ROnClicked,
	430, 106, 26, 11, "S_how Selected", &topaz8_065, GD_Show, NULL, NULL, (APTR)ShowClicked,
	391, 70, 64, 14, "Ite_m Height", &topaz8_065, GD_IH, NULL, NULL, (APTR)IHClicked,
	391, 85, 64, 14, "Ma_x Pen    ", &topaz8_065, GD_MaxP, NULL, NULL, (APTR)MaxPClicked
};

ULONG TagsGTags[] = {
	(GT_Underscore), '_', (GTST_MaxChars), 40, (TAG_DONE),
	(GT_Underscore), '_', (GTST_MaxChars), 40, (TAG_DONE),
	(GT_Underscore), '_', (GTCY_Labels), (ULONG)&PosTitLabels[0], (GTCY_Active), 5, (TAG_DONE),
	(GT_Underscore), '_', (TAG_DONE),
	(GT_Underscore), '_', (TAG_DONE),
	(GT_Underscore), '_', (TAG_DONE),
	(GT_Underscore), '_', (TAG_DONE),
	(GT_Underscore), '_', (STRINGA_Justification), GACT_STRINGRIGHT, (TAG_DONE),
	(GT_Underscore), '_', (STRINGA_Justification), GACT_STRINGRIGHT, (TAG_DONE),
	(GT_Underscore), '_', (STRINGA_Justification), GACT_STRINGRIGHT, (TAG_DONE),
	(GT_Underscore), '_', (STRINGA_Justification), GACT_STRINGRIGHT, (TAG_DONE),
	(GT_Underscore), '_', (TAG_DONE),
	(GT_Underscore), '_', (TAG_DONE),
	(GT_Underscore), '_', (TAG_DONE),
	(GT_Underscore), '_', (STRINGA_Justification), GACT_STRINGRIGHT, (TAG_DONE),
	(GT_Underscore), '_', (STRINGA_Justification), GACT_STRINGRIGHT, (TAG_DONE)
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

LONG OpenTagsWindow( struct Window **Wnd, struct Gadget **GList, struct Gadget *Gadgets[], struct IE_Data *IE )
{
	LONG		ret_code = NULL;

	struct Gadget		*g;
	UWORD			lc, tc;
	struct NewGadget	ng;

	if(!( g = CreateContext( GList )))
		return( 1L );

	for( lc = 0, tc = 0; lc < Tags_CNT; lc++ ) {

		CopyMem(( char * )&TagsNGad[ lc ], ( char * )&ng, ( long )sizeof( struct NewGadget ));
		ng.ng_VisualInfo = IE->ScreenData->Visual;
		ng.ng_TopEdge  += IE->ScreenData->YOffset;
		ng.ng_LeftEdge += IE->ScreenData->XOffset;
		Gadgets[ lc ] = g = CreateGadgetA((ULONG)TagsGTypes[ lc ], g, &ng, (struct TagItem *)&TagsGTags[ tc ] );

		while( TagsGTags[ tc ] ) tc += 2;
		tc++;

		if( !g )
			return( 2L );
	}


	struct TagItem WTags[] = {
		{ WA_Left, 62 },
		{ WA_Top, 68 },
		{ WA_Width, 474 + IE->ScreenData->XOffset },
		{ WA_Height, 138 + IE->ScreenData->YOffset },
		{ WA_MinWidth, 0 },
		{ WA_MaxWidth, -1 },
		{ WA_MinHeight, 0 },
		{ WA_MaxHeight, -1 },
		{ WA_PubScreen, IE->ScreenData->Screen },
		{ WA_Title, (ULONG)"Multiselect Listview Gadget" },
		{ WA_Flags, WFLG_DRAGBAR|WFLG_DEPTHGADGET|WFLG_SIMPLE_REFRESH|WFLG_ACTIVATE|WFLG_RMBTRAP },
		{ WA_IDCMP, BUTTONIDCMP|CHECKBOXIDCMP|INTEGERIDCMP|CYCLEIDCMP|STRINGIDCMP|IDCMP_REFRESHWINDOW|IDCMP_GADGETUP|IDCMP_VANILLAKEY },
		{ WA_Gadgets, *GList },
		{ TAG_DONE, NULL }
	};

	if(!( *Wnd = OpenWindowTagList( NULL, &WTags[0] )))
		return( 4L );

	GT_RefreshWindow( *Wnd, NULL );

	TagsRender( *Wnd, IE );
	return( 0L );
}

void TagsRender( struct Window *Wnd, struct IE_Data *IE )
{

	DrawBevelBox( Wnd->RPort, 5 + IE->ScreenData->XOffset, 3 + IE->ScreenData->YOffset, 252, 62,
		GT_VisualInfo, IE->ScreenData->Visual, GTBB_Recessed, TRUE, TAG_DONE );

	DrawBevelBox( Wnd->RPort, 5 + IE->ScreenData->XOffset, 65 + IE->ScreenData->YOffset, 459, 37,
		GT_VisualInfo, IE->ScreenData->Visual, GTBB_Recessed, TRUE, TAG_DONE );

	DrawBevelBox( Wnd->RPort, 5 + IE->ScreenData->XOffset, 102 + IE->ScreenData->YOffset, 459, 19,
		GT_VisualInfo, IE->ScreenData->Visual, GTBB_Recessed, TRUE, TAG_DONE );

	DrawBevelBox( Wnd->RPort, 257 + IE->ScreenData->XOffset, 3 + IE->ScreenData->YOffset, 207, 62,
		GT_VisualInfo, IE->ScreenData->Visual, GTBB_Recessed, TRUE, TAG_DONE );
}

LONG HandleTagsIDCMP( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )
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
				running = HandleTagsKeys( code, Wnd, Gadgets, IE, &Msg );
				break;

			case	IDCMP_REFRESHWINDOW:
				GT_BeginRefresh( Wnd );
				TagsRender( Wnd, IE );
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

BOOL HandleTagsKeys( UBYTE Code, struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	BOOL running = TRUE;

	switch( tolower( Code )) {

		case	'l':
			if(!( Gadgets[ GD_Tit ]->Flags & GFLG_DISABLED ))
				ActivateGadget( Gadgets[ GD_Tit ], Wnd, NULL );
			break;

		case	'b':
			if(!( Gadgets[ GD_Label ]->Flags & GFLG_DISABLED ))
				ActivateGadget( Gadgets[ GD_Label ], Wnd, NULL );
			break;

		case	'p':
			running = PosTitKeyPressed( Wnd, Gadgets, IE, Msg );
			break;

		case	'u':
			running = UndKeyPressed( Wnd, Gadgets, IE, Msg );
			break;

		case	'i':
			running = HighKeyPressed( Wnd, Gadgets, IE, Msg );
			break;

		case	'o':
			running = OkKeyPressed( Wnd, Gadgets, IE, Msg );
			break;

		case	'c':
			running = AnnullaKeyPressed( Wnd, Gadgets, IE, Msg );
			break;

		case	't':
			if(!( Gadgets[ GD_Top ]->Flags & GFLG_DISABLED ))
				ActivateGadget( Gadgets[ GD_Top ], Wnd, NULL );
			break;

		case	'v':
			if(!( Gadgets[ GD_Vis ]->Flags & GFLG_DISABLED ))
				ActivateGadget( Gadgets[ GD_Vis ], Wnd, NULL );
			break;

		case	'w':
			if(!( Gadgets[ GD_ScW ]->Flags & GFLG_DISABLED ))
				ActivateGadget( Gadgets[ GD_ScW ], Wnd, NULL );
			break;

		case	'a':
			if(!( Gadgets[ GD_Spc ]->Flags & GFLG_DISABLED ))
				ActivateGadget( Gadgets[ GD_Spc ], Wnd, NULL );
			break;

		case	'd':
			running = DisabKeyPressed( Wnd, Gadgets, IE, Msg );
			break;

		case	'r':
			running = ROnKeyPressed( Wnd, Gadgets, IE, Msg );
			break;

		case	'h':
			running = ShowKeyPressed( Wnd, Gadgets, IE, Msg );
			break;

		case	'm':
			if(!( Gadgets[ GD_IH ]->Flags & GFLG_DISABLED ))
				ActivateGadget( Gadgets[ GD_IH ], Wnd, NULL );
			break;

		case	'x':
			if(!( Gadgets[ GD_MaxP ]->Flags & GFLG_DISABLED ))
				ActivateGadget( Gadgets[ GD_MaxP ], Wnd, NULL );
			break;

		default:
			running = TagsVanillaKey( Code, Wnd, Gadgets, IE );
			break;

	}
	return( running );
}
