/// Includes
#define INTUI_V36_NAMES_ONLY

#include <exec/types.h>                 // exec
#include <exec/lists.h>
#include <exec/nodes.h>
#include <dos/dos.h>                    // dos
#include <dos/dostags.h>
#include <intuition/intuition.h>        // intuition
#include <libraries/gadtools.h>         // libraries
#include <clib/exec_protos.h>           // protos
#include <clib/dos_protos.h>
#include <clib/intuition_protos.h>
#include <clib/graphics_protos.h>
#include <pragmas/exec_pragmas.h>       // pragmas
#include <pragmas/dos_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <pragmas/graphics_pragmas.h>

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#include "DEV_IE:Generators/defs.h"
#include "DEV_IE:Include/IEditor.h"
#include "DEV_IE:Generators/C/Protos.h"
///
/// Data
static UBYTE  *WndFlags[] = {
    "WFLG_SIZEGADGET",
    "WFLG_DRAGBAR",
    "WFLG_DEPTHGADGET",
    "WFLG_CLOSEGADGET",
    "WFLG_SIZEBRIGHT",
    "WFLG_SIZEBBOTTOM",
    "WFLG_SMART_REFRESH",
    "WFLG_SIMPLE_REFRESH",
    "WFLG_SUPER_BITMAP",
    "WFLG_BACKDROP",
    "WFLG_REPORTMOUSE",
    "WFLG_GIMMEZEROZERO",
    "WFLG_BORDERLESS",
    "WFLG_ACTIVATE",
    "WFLG_RMBTRAP",
    "WFLG_NOCAREREFRESH",
    "WFLG_NW_EXTENDED",
    "WFLG_NEWLOOKMENUS"
};

static UBYTE  *WndIDCMP[] = {
    "IDCMP_SIZEVERIFY",
    "IDCMP_NEWSIZE",
    "IDCMP_REFRESHWINDOW",
    "IDCMP_MOUSEBUTTONS",
    "IDCMP_MOUSEMOVE",
    "IDCMP_GADGETDOWN",
    "IDCMP_GADGETUP",
    "IDCMP_REQSET",
    "IDCMP_MENUPICK",
    "IDCMP_CLOSEWINDOW",
    "IDCMP_RAWKEY",
    "IDCMP_REQVERIFY",
    "IDCMP_REQCLEAR",
    "IDCMP_MENUVERIFY",
    "IDCMP_NEWPREFS",
    "IDCMP_DISKINSERTED",
    "IDCMP_DISKREMOVED",
    "IDCMP_WBENCHMESSAGE",
    "IDCMP_ACTIVEWINDOW",
    "IDCMP_INACTIVEWINDOW",
    "IDCMP_DELTAMOVE",
    "IDCMP_VANILLAKEY",
    "IDCMP_INTUITICKS",
    "IDCMP_IDCMPUPDATE",
    "IDCMP_MENUHELP",
    "IDCMP_CHANGEWINDOW",
    "IDCMP_GADGETHELP"
};

static UBYTE  *GadIDCMP[] = {
    "BUTTONIDCMP",
    "CHECKBOXIDCMP",
    "INTEGERIDCMP",
    "LISTVIEWIDCMP",
    "MXIDCMP",
    "NUMBERIDCMP",
    "CYCLEIDCMP",
    "PALETTEIDCMP",
    "SCROLLERIDCMP",
    NULL,
    "SLIDERIDCMP",
    "STRINGIDCMP",
    "TEXTIDCMP",
    "IDCMP_GADGETUP|IDCMP_GADGETDOWN"
};
///

/// WriteWindowTags
void WriteWindowTags( struct GenFiles *Files, struct IE_Data *IE )
{
    struct WindowInfo  *wnd;
    UWORD               w, h;
    ULONG               idcmp;
    static UBYTE WAIdcmp[] = "\n\t{ WA_IDCMP, ";
    ULONG               loc;

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ )
	if( wnd->wi_Tags & W_BACKFILL ) {
	    TEXT    buffer[ 40 ];

	    sprintf( buffer, Prefs.HookDef, "ULONG" );

	    FPrintf( Files->XDef, "\nstruct BFHookMsg {\n"
				  "\tstruct Layer\t\t*Layer;\n"
				  "\tstruct Rectangle\tBounds;\n"
				  "\tLONG\t\t\tXOffset, YOffset;\n"
				  "};\n\n"
				  "extern struct Hook\t\tWndBFHook;\n"
				  "extern %s WndBFHookFunc( A0( struct Hook * ), A2( struct RastPort * ), A1( struct BFHookMsg * ));\n",
		     buffer );

	    FPuts( Files->Std, "\nstruct Hook BackFillHook = {\n"
			       "\t{ NULL }, (HOOKFUNC)WndBFHookFunc, NULL, NULL\n"
			       "};\n" );

	    break;
	}

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {

	FPrintf( Files->XDef, "extern struct TagItem\t\t%sWTags[];\n", wnd->wi_Label );

	FPrintf( Files->Std, "\nstruct TagItem %sWTags[] = {\n"
			     "\t{ WA_Left, %ld },\n"
			     "\t{ WA_Top, %ld },\n",
		 wnd->wi_Label, wnd->wi_Left, wnd->wi_Top );

	w = wnd->wi_Width;
	h = wnd->wi_Height;

	if( IE->SrcFlags & FONTSENSITIVE ) {
	    w -= ( IE->ScreenData->XOffset + IE->ScreenData->Screen->WBorRight  );
	    h -= ( IE->ScreenData->YOffset + IE->ScreenData->Screen->WBorBottom );
	}

	FPrintf( Files->Std, "\t{ WA_Width, %ld },\n"
			     "\t{ WA_Height, %ld },\n", w, h );

	VFPrintf( Files->Std, "\t{ WA_MinWidth, %d },\n"
			      "\t{ WA_MaxWidth, %d },\n"
			      "\t{ WA_MinHeight, %d },\n"
			      "\t{ WA_MaxHeight, %d },",
		  &wnd->wi_MinWidth );

	if( IE->flags_2 & GENERASCR )
	    FPuts( Files->Std, "\n\t{ WA_CustomScreen, NULL }," );
	else
	    FPuts( Files->Std, "\n\t{ WA_PubScreen, NULL }," );

	if( wnd->wi_Titolo[0] ) {
	    FPuts( Files->Std, "\n\t{ WA_Title, (ULONG)" );

	    loc = Prefs.Flags & SMART_STR;

	    if( IE->SrcFlags & LOCALIZE )
		loc = wnd->wi_Tags & W_LOC_TITLE;

	    if( loc )
		FPrintf( Files->Std, "%s", (( *IE->Functions->FindString )( &IE->Locale->ExtraStrings, wnd->wi_Titolo ))->ID );
	    else
		FPrintf( Files->Std, "\"%s\"", wnd->wi_Titolo );

	    FPuts( Files->Std, " }," );
	}

	if( wnd->wi_Flags ) {
	    FPuts( Files->Std, "\n\t{ WA_Flags, " );

	    for( w = 0; w < WFLAGS_NUM; w++ )
		if( wnd->wi_Flags & wflgs[ w ]) {
		    FPuts( Files->Std, WndFlags[ w ]);
		    FPutC( Files->Std, '|' );
		}

	    Flush( Files->Std );
	    Seek( Files->Std, -1, OFFSET_CURRENT );
	    FPuts( Files->Std, " }," );
	}

	h = FALSE;
	for( w = 0; w < 13; w++ )
	    if( wnd->wi_GadTypes[ w ])
		h = TRUE;

	if( h ) {
	    if(( IE->SrcFlags & SHARED_PORT ) && ( wnd->wi_Tags & W_SHARED_PORT ))
		FPrintf( Files->Std, "\n#define\t\t%s_IDCMP ", wnd->wi_Label );
	    else
		FPuts( Files->Std, WAIdcmp );

	    for( w = 0; w < 13; w++ ) {
		if( wnd->wi_GadTypes[ w ]) {
		    FPuts( Files->Std, GadIDCMP[ w ]);
		    FPutC( Files->Std, '|' );
		}
	    }

	    Flush( Files->Std );
	    Seek( Files->Std, -1, OFFSET_CURRENT );
	    FPutC( Files->Std, ' ' );
	}

	IE->win_info = wnd;
	if( idcmp = ( *IE->IEXSrcFun->IDCMP )( wnd->wi_IDCMP )) {

	    if(( Prefs.Flags & KEY_HANDLER ) && ( wnd->wi_NumKeys ))
		idcmp |= IDCMP_VANILLAKEY;

	    if( h ) {
		Flush( Files->Std );
		Seek( Files->Std, -1, OFFSET_CURRENT );
		FPutC( Files->Std, '|' );
	    } else {
		FPuts( Files->Std, WAIdcmp );
	    }

	    for( w = 0; w < IDCMPS_NUM; w++ ) {
		if( idcmp & idcmps[ w ]) {
		    FPuts( Files->Std, WndIDCMP[ w ]);
		    FPutC( Files->Std, '|' );
		}
	    }

	    Flush( Files->Std );
	    Seek( Files->Std, -1, OFFSET_CURRENT );
	    FPutC( Files->Std, ' ' );
	}

	if(( h ) || ( wnd->wi_IDCMP ))
	    if(( IE->SrcFlags & SHARED_PORT ) && ( wnd->wi_Tags & W_SHARED_PORT ))
		FPutC( Files->Std, '\n' );
	    else
		FPuts( Files->Std, "}," );

	if( wnd->wi_TitoloSchermo[0] ) {
	    FPuts( Files->Std, "\n\t{ WA_ScreenTitle, (ULONG)" );

	    loc = Prefs.Flags & SMART_STR;

	    if( IE->SrcFlags & LOCALIZE )
		loc = wnd->wi_Tags & W_LOC_SCRTITLE;

	    if( loc )
		FPrintf( Files->Std, "%s", (( *IE->Functions->FindString )( &IE->Locale->ExtraStrings, wnd->wi_TitoloSchermo ))->ID );
	    else
		FPrintf( Files->Std, "\"%s\"", wnd->wi_TitoloSchermo );

	    FPuts( Files->Std, " }," );
	}

	if( wnd->wi_Tags & W_MOUSEQUEUE )
	    VFPrintf( Files->Std, "\n\t{ WA_MouseQueue, %d },", &wnd->wi_MouseQueue );

	if( wnd->wi_Tags & W_RPTQUEUE )
	    VFPrintf( Files->Std, "\n\t{ WA_RptQueue, %d },", &wnd->wi_RptQueue );

	if(!( wnd->wi_Tags & W_AUTOADJUST ))
	    FPuts( Files->Std, "\n\t{ WA_AutoAdjust, FALSE }," );

	if( wnd->wi_Tags & W_FALLBACK )
	    FPuts( Files->Std, "\n\t{ WA_PubScreenFallBack, TRUE }," );

	if( wnd->wi_Tags & W_ZOOM )
	    FPrintf( Files->Std, "\n\t{ WA_Zoom, (ULONG)%sZoom },", wnd->wi_Label );

	if( wnd->wi_flags1 & W_USA_INNER_W )
	    VFPrintf( Files->Std, "\n\t{ WA_InnerWidth, %d },", &wnd->wi_InnerWidth );

	if( wnd->wi_flags1 & W_USA_INNER_H )
	    VFPrintf( Files->Std, "\n\t{ WA_InnerHeight, %d },", &wnd->wi_InnerHeight );

	if( wnd->wi_NumGads )
	    FPuts( Files->Std, "\n\t{ WA_Gadgets, NULL }," );

	if( wnd->wi_Tags & W_TABLETMESSAGE )
	    FPuts( Files->Std, "\n\t{ WA_TabletMessages, TRUE }," );

	if( wnd->wi_Tags & W_MENUHELP )
	    FPuts( Files->Std, "\n\t{ WA_MenuHelp, TRUE }," );

	if( wnd->wi_Tags & W_NOTIFYDEPTH )
	    FPuts( Files->Std, "\n\t{ WA_NotifyDepth, TRUE }," );

	if( wnd->wi_Tags & W_BACKFILL )
	    FPuts( Files->Std, "\n\t{ WA_BackFill, (ULONG)&BackFillHook }," );

	FPuts( Files->Std, "\n\t{ TAG_DONE, NULL }\n};\n" );
    }
}
///
/// WriteScreenTags
void WriteScreenTags( struct GenFiles *Files, struct IE_Data *IE )
{
    UWORD   cnt, col, r, g, b;

    FPuts( Files->XDef, "extern struct TextAttr\t\tScreenFont;\n"
			"extern struct ColorSpec\t\tScreenColors[];\n"
			"extern UWORD\t\t\tDriPens[];\n"
			"extern ULONG\t\t\tScreenTags[];\n" );

    FPrintf( Files->Std, "\nstruct TextAttr ScreenFont = {\n"
			 "\t( STRPTR )\"%s\", %ld, 0x%lx, 0x%lx };\n"
			 "\nstruct ColorSpec ScreenColors[] = {\n",
	     IE->ScreenData->FontScr, IE->ScreenData->NewFont.ta_YSize,
	     IE->ScreenData->NewFont.ta_Style,
	     IE->ScreenData->NewFont.ta_Flags );

    for( cnt = 0; cnt < 1 << IE->ScreenData->Tags[ SCRDEPTH ]; cnt++ ) {

	col = GetRGB4( IE->ScreenData->Screen->ViewPort.ColorMap, cnt );

	r = (col >> 8) & 0x0F;
	g = (col >> 4) & 0x0F;
	b = col & 0x0F;

	FPrintf( Files->Std, "\t%ld, 0x0%lx, 0x0%lx, 0x0%lx,\n", cnt, r, g, b );
    }

    VFPrintf( Files->Std, "\t~0, 0x00, 0x00, 0x00 };\n\n"
			  "UWORD DriPens[] = {\n"
			  "\t%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, (UWORD)~0 };\n",
	      IE->ScreenData->DriPens );

    FPuts( Files->Std, "\nULONG ScreenTags[] = {\n"
			 "\tSA_Type, " );

    if( IE->ScreenData->Type )
	FPuts( Files->Std, "CUSTOMSCREEN,\n" );
    else
	FPuts( Files->Std, "PUBLICSCREEN,\n" );

    if(!( IE->ScreenData->ScrAttrs & SC_LIKEWORKBENCH ))
	FPrintf( Files->Std, "\tSA_Depth, %ld, SA_DisplayID, 0x%lx,\n"
			     "\tSA_Pens, (ULONG)DriPens,\n"
			     "\tSA_Colors, (ULONG)ScreenColors,\n",
		 IE->ScreenData->Tags[ SCRDEPTH ],
		 IE->ScreenData->Tags[ SCRID ] );

    FPuts( Files->Std, "\tSA_Font, (ULONG)&ScreenFont,\n" );

    if(!( IE->ScreenData->ScrAttrs & ( SC_OVERSCAN | SC_LIKEWORKBENCH )))
	FPrintf( Files->Std, "\tSA_Width, %ld, SA_Height, %ld,\n",
		 IE->ScreenData->Screen->Width,
		 IE->ScreenData->Screen->Height );

    if( IE->ScreenData->Title[0] )
	FPrintf( Files->Std, "\tSA_Title, (ULONG)\"%s\",\n", IE->ScreenData->Title );

    if( IE->ScreenData->PubName[0] )
	FPrintf( Files->Std, "\tSA_PubName, (ULONG)\"%s\",\n", IE->ScreenData->PubName );

    if(!( IE->ScreenData->ScrAttrs & SC_LIKEWORKBENCH )) {
	if( IE->ScreenData->ScrAttrs & SC_LEFT )
	    FPrintf( Files->Std, "\tSA_Left, %ld,\n", IE->ScreenData->St_Left );
	if( IE->ScreenData->ScrAttrs & SC_TOP )
	    FPrintf( Files->Std, "\tSA_Top, %ld,\n", IE->ScreenData->St_Top );
    }

    if(!( IE->ScreenData->ScrAttrs & SC_SHOWTITLE ))
	FPuts( Files->Std, "\tSA_ShowTitle, FALSE,\n" );

    if( IE->ScreenData->ScrAttrs & SC_BEHIND )
	FPuts( Files->Std, "\tSA_Behind, TRUE,\n" );

    if( IE->ScreenData->ScrAttrs & SC_QUIET )
	FPuts( Files->Std, "\tSA_Quiet, TRUE,\n" );

    if(( IE->ScreenData->ScrAttrs & SC_OVERSCAN ) && (!( IE->ScreenData->ScrAttrs & SC_LIKEWORKBENCH )))
	FPrintf( Files->Std, "\tSA_Overscan, 0x%lx,\n", IE->ScreenData->Tags[ SCROVERSCAN ]);

    if( IE->ScreenData->ScrAttrs & SC_FULLPALETTE )
	FPuts( Files->Std, "\tSA_FullPalette, TRUE,\n" );

    if( IE->ScreenData->ScrAttrs & SC_ERRORCODE )
	FPuts( Files->Std, "\tSA_ErrorCode, (ULONG)&ScreenError,\n" );

    if(!( IE->ScreenData->ScrAttrs & SC_DRAGGABLE ))
	FPuts( Files->Std, "\tSA_Draggable, FALSE,\n" );

    if( IE->ScreenData->ScrAttrs & SC_EXCLUSIVE )
	FPuts( Files->Std, "\tSA_Exclusive, TRUE,\n" );

    if( IE->ScreenData->ScrAttrs & SC_SHAREPENS )
	FPuts( Files->Std, "\tSA_SharePens, TRUE,\n" );

    if( IE->ScreenData->ScrAttrs & SC_INTERLEAVED )
	FPuts( Files->Std, "\tSA_Interleaved, TRUE,\n" );

    if( IE->ScreenData->ScrAttrs & SC_LIKEWORKBENCH )
	FPuts( Files->Std, "\tSA_LikeWorkbench, TRUE,\n" );

    if( IE->ScreenData->ScrAttrs & SC_MINIMIZEISG )
	FPuts( Files->Std, "\tSA_MinimizeISG, TRUE,\n" );

    FPuts( Files->Std, "\tTAG_DONE\n};\n" );
}
///

