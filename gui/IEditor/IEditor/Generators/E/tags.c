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

#include "Protos.h"
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

static ULONG    GadIDCMP[] = {
    BUTTONIDCMP,
    CHECKBOXIDCMP,
    INTEGERIDCMP,
    LISTVIEWIDCMP,
    MXIDCMP,
    NUMBERIDCMP,
    CYCLEIDCMP,
    PALETTEIDCMP,
    SCROLLERIDCMP,
    NULL,
    SLIDERIDCMP,
    STRINGIDCMP,
    TEXTIDCMP,
    IDCMP_GADGETUP | IDCMP_GADGETDOWN
};
///

/// WriteWindowTags
void WriteWindowTags( struct GenFiles *Files, struct IE_Data *IE )
{
    struct WindowInfo  *wnd;
    UWORD               w, h;
    ULONG               idcmp;
    static UBYTE WAIdcmp[] = "\n\tWA_IDCMP, ";
    ULONG               loc;

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	TEXT    Label[60];

	StrToLower( wnd->wi_Label, Label );

	FPrintf( Files->Std, "\nDEF %swtags = [\n"
			     "\tWA_LEFT, %ld,\n"
			     "\tWA_TOP, %ld,\n",
		 wnd->wi_Label, wnd->wi_Left, wnd->wi_Top );

	w = wnd->wi_Width;
	h = wnd->wi_Height;

	if( IE->SrcFlags & FONTSENSITIVE ) {
	    w -= ( IE->ScreenData->XOffset + IE->ScreenData->Screen->WBorRight  );
	    h -= ( IE->ScreenData->YOffset + IE->ScreenData->Screen->WBorBottom );
	}

	FPrintf( Files->Std, "\tWA_WIDTH, %ld,\n"
			     "\tWA_HEIGHT, %ld,\n", w, h );

	VFPrintf( Files->Std, "\tWA_MINWIDTH, %d,\n"
			      "\tWA_MAXWIDTH, %d,\n"
			      "\tWA_MINHEIGHT, %d,\n"
			      "\tWA_MAXHEIGHT, %d,",
		  &wnd->wi_MinWidth );

	if( IE->flags_2 & GENERASCR )
	    FPuts( Files->Std, "\n\tWA_CUSTOMSCREEN, NIL," );
	else
	    FPuts( Files->Std, "\n\tWA_PUBSCREEN, NIL," );

	if( wnd->wi_Titolo[0] ) {
	    FPuts( Files->Std, "\n\tWA_TITLE, " );

	    loc = IE->C_Prefs & SMART_STR;

	    if( IE->SrcFlags & LOCALIZE )
		loc = wnd->wi_Tags & W_LOC_TITLE;

	    if( loc )
		FPrintf( Files->Std, "%s,", (FindString( &Files->Strings, wnd->wi_Titolo ))->Label );
	    else
		FPrintf( Files->Std, "'%s',", wnd->wi_Titolo );
	}

	if( wnd->wi_Flags ) {
	    VFPrintf( Files->Std, "\n\tWA_FLAGS, &%lx, ", &wnd->wi_Flags );
	}

	h     = FALSE;
	idcmp = 0L;

	for( w = 0; w < 13; w++ )
	    if( wnd->wi_GadTypes[ w ]) {
		h      = TRUE;
		idcmp |= GadIDCMP[ w ];
	    }

	IE->win_info = wnd;
	if( idcmp = ( *IE->IEXSrcFun->IDCMP )( idcmp )) {

	    if(( IE->C_Prefs & KEY_HANDLER ) && ( wnd->wi_NumKeys ))
		idcmp |= IDCMP_VANILLAKEY;

	    FPuts( Files->Std, WAIdcmp );

	    FPrintf( Files->Std, "$%lx,", idcmp );
	}


	if( wnd->wi_TitoloSchermo[0] ) {
	    FPuts( Files->Std, "\n\tWA_SCREENTITLE, " );

	    loc = IE->C_Prefs & SMART_STR;

	    if( IE->SrcFlags & LOCALIZE )
		loc = wnd->wi_Tags & W_LOC_SCRTITLE;

	    if( loc )
		FPrintf( Files->Std, "%s,", (FindString( &Files->Strings, wnd->wi_TitoloSchermo ))->Label );
	    else
		FPrintf( Files->Std, "'%s',", wnd->wi_TitoloSchermo );
	}

	if( wnd->wi_Tags & W_MOUSEQUEUE )
	    VFPrintf( Files->Std, "\n\tWA_MOUSEQUEUE, %d,", &wnd->wi_MouseQueue );

	if( wnd->wi_Tags & W_RPTQUEUE )
	    VFPrintf( Files->Std, "\n\tWA_RPTQUEUE, %d,", &wnd->wi_RptQueue );

	if(!( wnd->wi_Tags & W_AUTOADJUST ))
	    FPuts( Files->Std, "\n\tWA_AUTOADJUST, FALSE," );

	if( wnd->wi_Tags & W_FALLBACK )
	    FPuts( Files->Std, "\n\tWA_PUBSCREENFALLBACK, TRUE," );

	if( wnd->wi_Tags & W_ZOOM )
	    FPrintf( Files->Std, "\n\tWA_ZOOM, {%szoom},", Label );

	if( wnd->wi_flags1 & W_USA_INNER_W )
	    VFPrintf( Files->Std, "\n\tWA_INNERWIDTH, %d,", &wnd->wi_InnerWidth );

	if( wnd->wi_flags1 & W_USA_INNER_H )
	    VFPrintf( Files->Std, "\n\tWA_INNERHEIGHT, %d,", &wnd->wi_InnerHeight );

	if( wnd->wi_NumGads )
	    FPuts( Files->Std, "\n\tWA_GADGETS, NIL," );

	if( wnd->wi_Tags & W_TABLETMESSAGE )
	    FPuts( Files->Std, "\n\tWA_TABLETMESSAGES, TRUE," );

	if( wnd->wi_Tags & W_MENUHELP )
	    FPuts( Files->Std, "\n\tWA_MENUHELP, TRUE," );

	if( wnd->wi_Tags & W_NOTIFYDEPTH )
	    FPuts( Files->Std, "\n\tWA_NOTIFYDEPTH, TRUE," );

	FPuts( Files->Std, "\n\tTAG_DONE, NIL ]:tagitem\n" );
    }
}
///
/// WriteScreenTags
void WriteScreenTags( struct GenFiles *Files, struct IE_Data *IE )
{
    UWORD   cnt;

    FPrintf( Files->Std, "\nDEF screenfont = [ '%s', %ld, $%lx, $%lx ]:textattr,\n"
			 "    screencolors = [\n",
	     IE->ScreenData->FontScr, IE->ScreenData->NewFont.ta_YSize,
	     IE->ScreenData->NewFont.ta_Style,
	     IE->ScreenData->NewFont.ta_Flags );

    for( cnt = 0; cnt < 1 << IE->ScreenData->Tags[ SCRDEPTH ]; cnt++ ) {
	UWORD   col, r, g, b;

	col = GetRGB4( IE->ScreenData->Screen->ViewPort.ColorMap, cnt );

	r = ( col >> 8 ) & 0x0F;
	g = ( col >> 4 ) & 0x0F;
	b = col & 0x0F;

	FPrintf( Files->Std, "\t%ld, $0%lx, $0%lx, $0%lx,\n", cnt, r, g, b );
    }

    VFPrintf( Files->Std, "\t-1, $00, $00, $00 ]:colorspec\n\n"
			  "DEF dripens = [\n"
			  "\t%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, -1 ]:INT\n",
	      IE->ScreenData->DriPens );

    FPuts( Files->Std, "\nDEF screentags = [\n"
			 "\tSA_TYPE, " );

    if( IE->ScreenData->Type )
	FPuts( Files->Std, "CUSTOMSCREEN,\n" );
    else
	FPuts( Files->Std, "PUBLICSCREEN,\n" );

    if(!( IE->ScreenData->ScrAttrs & SC_LIKEWORKBENCH ))
	FPrintf( Files->Std, "\tSA_DEPTH, %ld, SA_DISPLAYID, $%lx,\n"
			     "\tSA_PENS, {dripens},\n"
			     "\tSA_COLORS, {screencolors},\n",
		 IE->ScreenData->Tags[ SCRDEPTH ],
		 IE->ScreenData->Tags[ SCRID ] );

    FPuts( Files->Std, "\tSA_FONT, {screenfont},\n" );

    if(!( IE->ScreenData->ScrAttrs & ( SC_OVERSCAN | SC_LIKEWORKBENCH )))
	FPrintf( Files->Std, "\tSA_WIDTH, %ld, SA_HEIGHT, %ld,\n",
		 IE->ScreenData->Screen->Width,
		 IE->ScreenData->Screen->Height );

    if( IE->ScreenData->Title[0] )
	FPrintf( Files->Std, "\tSA_TITLE, '%s',\n", IE->ScreenData->Title );

    if( IE->ScreenData->PubName[0] )
	FPrintf( Files->Std, "\tSA_PUBNAME, '%s',\n", IE->ScreenData->PubName );

    if(!( IE->ScreenData->ScrAttrs & SC_LIKEWORKBENCH )) {
	if( IE->ScreenData->ScrAttrs & SC_LEFT )
	    FPrintf( Files->Std, "\tSA_LEFT, %ld,\n", IE->ScreenData->St_Left );
	if( IE->ScreenData->ScrAttrs & SC_TOP )
	    FPrintf( Files->Std, "\tSA_TOP, %ld,\n", IE->ScreenData->St_Top );
    }

    if(!( IE->ScreenData->ScrAttrs & SC_SHOWTITLE ))
	FPuts( Files->Std, "\tSA_SHOWTITLE, FALSE,\n" );

    if( IE->ScreenData->ScrAttrs & SC_BEHIND )
	FPuts( Files->Std, "\tSA_BEHIND, TRUE,\n" );

    if( IE->ScreenData->ScrAttrs & SC_QUIET )
	FPuts( Files->Std, "\tSA_QUIET, TRUE,\n" );

    if(( IE->ScreenData->ScrAttrs & SC_OVERSCAN ) && (!( IE->ScreenData->ScrAttrs & SC_LIKEWORKBENCH )))
	FPrintf( Files->Std, "\tSA_OVERSCAN, $%lx,\n", IE->ScreenData->Tags[ SCROVERSCAN ]);

    if( IE->ScreenData->ScrAttrs & SC_FULLPALETTE )
	FPuts( Files->Std, "\tSA_FULLPALETTE, TRUE,\n" );

    if( IE->ScreenData->ScrAttrs & SC_ERRORCODE )
	FPuts( Files->Std, "\tSA_ERRORCODE, {screenerror},\n" );

    if(!( IE->ScreenData->ScrAttrs & SC_DRAGGABLE ))
	FPuts( Files->Std, "\tSA_DRAGGABLE, FALSE,\n" );

    if( IE->ScreenData->ScrAttrs & SC_EXCLUSIVE )
	FPuts( Files->Std, "\tSA_EXCLUSIVE, TRUE,\n" );

    if( IE->ScreenData->ScrAttrs & SC_SHAREPENS )
	FPuts( Files->Std, "\tSA_SHAREPENS, TRUE,\n" );

    if( IE->ScreenData->ScrAttrs & SC_INTERLEAVED )
	FPuts( Files->Std, "\tSA_INTERLEAVED, TRUE,\n" );

    if( IE->ScreenData->ScrAttrs & SC_LIKEWORKBENCH )
	FPuts( Files->Std, "\tSA_LIKEWORKBENCH, TRUE,\n" );

    if( IE->ScreenData->ScrAttrs & SC_MINIMIZEISG )
	FPuts( Files->Std, "\tSA_MINIMIZEISG, TRUE,\n" );

    FPuts( Files->Std, "\tTAG_DONE\n]:LONG\n" );
}
///

