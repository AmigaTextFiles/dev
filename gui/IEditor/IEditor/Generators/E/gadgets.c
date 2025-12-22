/// Includes
#define INTUI_V36_NAMES_ONLY

#include <exec/types.h>                 // exec
#include <exec/lists.h>
#include <exec/nodes.h>
#include <dos/dos.h>                    // dos
#include <dos/dostags.h>
#include <intuition/intuition.h>        // intuition
#include <intuition/gadgetclass.h>
#include <libraries/gadtools.h>         // libraries
#include <clib/exec_protos.h>           // protos
#include <clib/dos_protos.h>
#include <clib/intuition_protos.h>
#include <pragmas/exec_pragmas.h>       // pragmas
#include <pragmas/dos_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <pragmas/gadtools_pragmas.h>

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#include "DEV_IE:Generators/defs.h"
#include "DEV_IE:Include/IEditor.h"

#include "Protos.h"
///
/// Data
static UWORD stringjusts[] = {
    GACT_STRINGLEFT, GACT_STRINGRIGHT, GACT_STRINGCENTER
};

static ULONG gadget_flags[] = { 1, 2, 4, 8, 16, 0 };

static UBYTE *GadKinds[] = {
    "BUTTON_KIND",
    "CHECKBOX_KIND",
    "INTEGER_KIND",
    "LISTVIEW_KIND",
    "MX_KIND",
    "NUMBER_KIND",
    "CYCLE_KIND",
    "PALETTE_KIND",
    "SCROLLER_KIND",
    NULL,
    "SLIDER_KIND",
    "STRING_KIND",
    "TEXT_KIND"
};

static UBYTE  *GadFlags[] = {
    "PLACETEXT_LEFT",
    "PLACETEXT_RIGHT",
    "PLACETEXT_ABOVE",
    "PLACETEXT_BELOW",
    "PLACETEXT_IN"
};

static UBYTE  *STRINGA_txts[] = {
    NULL,
    "GACT_STRINGRIGHT",
    "GACT_STRINGCENTER"
};

static UBYTE  *GTJ_txts[] = {
    NULL,
    "GTJ_RIGHT",
    "GTJ_CENTER"
};

static UBYTE   GADisabled[]         = "GA_DISABLED, TRUE, ";
static UBYTE   GAImmediate[]        = "GA_IMMEDIATE, TRUE, ";
static UBYTE   GATabCycle[]         = "GA_TABCYCLE, FALSE, ";
static UBYTE   GARelVerify[]        = "GA_RELVERIFY, TRUE, ";
static UBYTE   STRINGAExitHelp[]    = "STRINGA_EXITHELP, TRUE, ";
static UBYTE   STRINGAReplaceMode[] = "STRINGA_REPLACEMODE, TRUE, ";
static UBYTE   PGAFreedom[]         = "PGA_FREEDOM, LORIENT_VERT, ";
static UBYTE   LAYOUTASpacing[]     = "LAYOUTA_SPACING, %ld, ";
///


/// WriteNewGadgets
void WriteNewGadgets( struct GenFiles *Files, struct IE_Data *IE )
{
    struct WindowInfo  *wnd;
    LONG                loc;

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	if( wnd->wi_NumGads - wnd->wi_NumBools ) {
	    TEXT    Label[60];

	    StrToLower( wnd->wi_Label, Label );

	    FPrintf( Files->Std, "\nDEF %sngad = [\n\t", Label );

	    loc = IE->C_Prefs & SMART_STR;

	    if( IE->SrcFlags & LOCALIZE )
		loc = wnd->wi_Tags & W_LOC_GADGETS;

	    WriteNewGads( Files, IE, &wnd->wi_Gadgets, loc );
	}
    }

}
///
/// WriteGadgetTags
void WriteGadgetTags( struct GenFiles *Files, struct IE_Data *IE )
{
    struct WindowInfo  *wnd;
    ULONG               loc;

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	if( wnd->wi_NumGads - wnd->wi_NumBools ) {
	    TEXT    Label[60];

	    StrToLower( wnd->wi_Label, Label );

	    loc = IE->C_Prefs & SMART_STR;

	    if( IE->SrcFlags & LOCALIZE )
		loc = wnd->wi_Tags & W_LOC_GADGETS;

	    FPrintf( Files->Std, "\nDEF %sgtags = [\n\t", Label );

	    WriteTags( Files, IE, &wnd->wi_Gadgets, loc );
	}
    }
}
///
/// WriteBoolStruct
void WriteBoolStruct( struct GenFiles *Files, struct IE_Data *IE )
{
    struct WindowInfo  *wnd;

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ )
	if( wnd->wi_NumBools )
	    WriteBooleans( Files, IE, &wnd->wi_Gadgets, wnd );
}
///
/// WriteGadgetBanks
void WriteGadgetBanks( struct GenFiles *Files, struct IE_Data *IE )
{
    struct WindowInfo  *wnd;

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	struct GadgetBank  *bank;
	ULONG               loc;

	loc = IE->C_Prefs & SMART_STR;

	if( IE->SrcFlags & LOCALIZE )
	    loc = wnd->wi_Tags & W_LOC_GADGETS;

	for( bank = wnd->wi_GBanks.mlh_Head; bank->Node.ln_Succ; bank = bank->Node.ln_Succ ) {
	    ULONG               NotBool = 0;
	    struct GadgetInfo  *gad;

	    for( gad = bank->Storage.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ )
		if( gad->g_Kind != BOOLEAN )
		    NotBool += 1;

	    if( NotBool ) {
		TEXT    Label[60];

		StrToLower( bank->Label, Label );

		FPrintf( Files->Std, "\nDEF %sgtypes = [\n\t", Label );

		WriteGTypes( Files, IE, &bank->Storage );

		WriteGLabels( Files, IE, &bank->Storage, wnd );

		FPrintf( Files->Std, "\nDEF %sngad = [\n\t", Label );

		WriteNewGads( Files, IE, &bank->Storage, loc );

		FPrintf( Files->Std, "\nDEF %sgtags = [\n\t", Label );

		WriteTags( Files, IE, &bank->Storage, loc );
	    }

	    WriteBooleans( Files, IE, &bank->Storage, wnd );
	}
    }
}
///

/// WriteNewGads
void WriteNewGads( struct GenFiles *Files, struct IE_Data *IE, struct MinList *Gadgets, ULONG loc )
{
    struct GadgetInfo  *gad;
    UBYTE               buffer[256], *or;
    UWORD               c, c2;

    for( gad = Gadgets->mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
	if( gad->g_Kind < BOOLEAN ) {
	    TEXT    Label[60];

	    FPrintf( Files->Std, "%ld, %ld, %ld, %ld, ",
		     gad->g_Left - IE->ScreenData->XOffset,
		     gad->g_Top  - IE->ScreenData->YOffset,
		     gad->g_Width, gad->g_Height );

	    if( gad->g_Titolo[0] ) {
		if( loc )
		    FPrintf( Files->Std, "%s,", (FindString( &Files->Strings, gad->g_Titolo ))->Label );
		else
		    FPrintf( Files->Std, "'%s',", gad->g_Titolo );
	    } else
		FPuts( Files->Std, Null );

	    if( gad->g_Font )
		FPrintf( Files->Std, "{%s}", gad->g_Font->txa_Label );
	    else
		FPuts( Files->Std, Null );

	    StrToUpper( gad->g_Label, Label );

	    FPrintf( Files->Std, ", GD_%s, ", Label );

	    if( gad->g_Flags ) {

		buffer[0] = '\0';

		if( gad->g_Flags & 32 ) {
		    strcpy( buffer, "NG_HIGHLABEL" );
		    or = " OR ";
		} else
		    or = "";


		c = gad->g_Flags & 0xFFDF;
		if( c ) {
		    strcat( buffer, or );

		    c2 = 0;
		    while(!( c & gadget_flags[ c2 ]))
			c2 += 1;

		    strcat( buffer, GadFlags[ c2 ]);
		}

		FPuts( Files->Std, buffer );
	    } else
		FPuts( Files->Std, Null );


	    FPuts( Files->Std, ", NIL, " );

	    if(( IE->C_Prefs & CLICKED ) && ( gad->g_Kind != TEXT_KIND ) && ( gad->g_Kind != NUMBER_KIND ))
		FPrintf( Files->Std, "{%sclicked}", gad->g_Label );
	    else
		FPuts( Files->Std, Null );

	    FPuts( Files->Std, ",\n\t" );
	}
    }

    Flush( Files->Std );
    Seek( Files->Std, -3, OFFSET_CURRENT );
    FPuts( Files->Std, "\n]:newgadget\n" );
}
///
/// WriteTags
void WriteTags( struct GenFiles *Files, struct IE_Data *IE, struct MinList *Gadgets, ULONG loc )
{
    struct GadgetInfo  *gad;

    for( gad = Gadgets->mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
	if( gad->g_Kind < BOOLEAN ) {

	    if( gad->g_Tags & 1 )
		FPuts( Files->Std, "GT_UNDERSCORE, \"_\", " );

	    switch( gad->g_Kind ) {

		case BUTTON_KIND:
		    if( gad->g_Tags & 2 )
			FPuts( Files->Std, GADisabled );
		    if( gad->g_Tags & 4 )
			FPuts( Files->Std, GAImmediate );
		    break;

		case CHECKBOX_KIND:
		    if( gad->g_Tags & 2 )
			FPuts( Files->Std, GADisabled );
		    if( gad->g_Tags & 4 )
			FPuts( Files->Std, "GTCB_CHECKED, TRUE, " );
		    if( gad->g_Tags & 8 )
			FPuts( Files->Std, "GTCB_SCALED, TRUE, " );
		    break;

		case INTEGER_KIND:
		    if( ((struct IK)(gad->g_Data)).Num )
			FPrintf( Files->Std, "GTIN_NUMBER, %ld, ", ((struct IK)(gad->g_Data)).Num );
		    if( ((struct IK)(gad->g_Data)).MaxC != 10 )
			FPrintf( Files->Std, "GTIN_MAXCHARS, %ld, ", ((struct IK)(gad->g_Data)).MaxC );
		    if( ((struct IK)(gad->g_Data)).Just )
			FPrintf( Files->Std, "STRINGA_JUSTIFICATION, %s, ", STRINGA_txts[ ((struct IK)(gad->g_Data)).Just ]);
		    if( gad->g_Tags & 2 )
			FPuts( Files->Std, GADisabled );
		    if( gad->g_Tags & 4 )
			FPuts( Files->Std, GAImmediate );
		    if(!( gad->g_Tags & 8 ))
			FPuts( Files->Std, GATabCycle );
		    if( gad->g_Tags & 0x10 )
			FPuts( Files->Std, STRINGAExitHelp );
		    if( gad->g_Tags & 0x20 )
			FPuts( Files->Std, STRINGAReplaceMode );
		    break;

		case LISTVIEW_KIND:
		    if( gad->g_NumScelte )
			FPrintf( Files->Std, "GTLV_LABELS, {%slist}, ", gad->g_Label );
		    if( ((struct LK)(gad->g_Data)).Top )
			FPrintf( Files->Std, "GTLV_TOP, %ld, ", ((struct LK)(gad->g_Data)).Top );
		    if( ((struct LK)(gad->g_Data)).Vis )
			FPrintf( Files->Std, "GTLV_MAKEVISIBLE, %ld, ", ((struct LK)(gad->g_Data)).Vis );
		    if( ((struct LK)(gad->g_Data)).ScW != 16 )
			FPrintf( Files->Std, "GTLV_SCROLLWIDTH, %ld, ", ((struct LK)(gad->g_Data)).ScW );
		    if( ((struct LK)(gad->g_Data)).Sel )
			FPrintf( Files->Std, "GTLV_SELECTED, %ld, ", ((struct LK)(gad->g_Data)).Sel );
		    if( ((struct LK)(gad->g_Data)).Spc )
			FPrintf( Files->Std, LAYOUTASpacing, ((struct LK)(gad->g_Data)).Spc );
		    if( ((struct LK)(gad->g_Data)).IH )
			FPrintf( Files->Std, "GTLV_ITEMHEIGHT, %ld, ", ((struct LK)(gad->g_Data)).IH );
		    if( ((struct LK)(gad->g_Data)).MaxP )
			FPrintf( Files->Std, "GTLV_MAXPEN, %ld, ", ((struct LK)(gad->g_Data)).MaxP );
		    if( gad->g_Tags & 2 )
			FPuts( Files->Std, GADisabled );
		    if( gad->g_Tags & 4 )
			FPuts( Files->Std, "GTLV_READONLY, TRUE, " );
		    if( gad->g_Tags & 8 )
			FPuts( Files->Std, "GTLV_SHOWSELECTED, NIL, " );
		    break;

		case MX_KIND:
		    FPuts( Files->Std, "GTMX_LABLES, {" );
		    if( loc )
			FPrintf( Files->Std, "%s", (FindArray( &Files->Arrays, &gad->g_Scelte ))->Label );
		    else
			FPrintf( Files->Std, "%slabels", gad->g_Label );
		    FPuts( Files->Std, "}, " );
		    if( ((struct MK)(gad->g_Data)).Act )
			FPrintf( Files->Std, "GTMX_ACTIVE, %ld, ", ((struct MK)(gad->g_Data)).Act );
		    if( ((struct MK)(gad->g_Data)).Spc != 1 )
			FPrintf( Files->Std, "GTMX_SPACING, %ld, ", ((struct MK)(gad->g_Data)).Spc );
		    if( gad->g_Titolo[0] )
			FPrintf( Files->Std, "GTMX_TITLEPLACE, %s, ", GadFlags[ ((struct MK)(gad->g_Data)).TitPlc ]);
		    if( gad->g_Tags & 2 )
			FPuts( Files->Std, GADisabled );
		    if( gad->g_Tags & 4 )
			FPuts( Files->Std, "GTMX_SCALED, TRUE, " );
		    break;

		case NUMBER_KIND:
		    if( ((struct NK)(gad->g_Data)).Num )
			FPrintf( Files->Std, "GTNM_NUMBER), %ld, ", ((struct NK)(gad->g_Data)).Num );
		    if( ((struct NK)(gad->g_Data)).FPen != -1 )
			FPrintf( Files->Std, "GTNM_FRONTPEN, %ld, ", ((struct NK)(gad->g_Data)).FPen );
		    if( ((struct NK)(gad->g_Data)).BPen != -1 )
			FPrintf( Files->Std, "GTNM_BACKPEN, %ld, ", ((struct NK)(gad->g_Data)).BPen );
		    if( ((struct NK)(gad->g_Data)).Just )
			FPrintf( Files->Std, "GTNM_JUSTIFICATION, %s, ", GTJ_txts[ ((struct NK)(gad->g_Data)).Just ]);
		    if( ((struct NK)(gad->g_Data)).MNL != 10 )
			FPrintf( Files->Std, "GTNM_MAXNUMBERLEN, %ld, ", ((struct NK)(gad->g_Data)).MNL );
		    if( strcmp( ((struct NK)(gad->g_Data)).Format, "%ld" )) {
			FPuts( Files->Std, "GTNM_FORMAT, " );
			if( loc )
			    FPrintf( Files->Std, "%s, ", (FindString( &Files->Strings, ((struct NK)(gad->g_Data)).Format ))->Label );
			else
			    FPrintf( Files->Std, "'%s', ", ((struct NK)(gad->g_Data)).Format );
		    }
		    if( gad->g_Tags & 2 )
			FPuts( Files->Std, "GTNM_BORDER, TRUE, " );
		    if( gad->g_Tags & 4 )
			FPuts( Files->Std, "GTNM_CLIPPED, TRUE, " );
		    break;

		case CYCLE_KIND:
		    FPuts( Files->Std, "GTCY_LABELS, {" );
		    if( loc )
			FPrintf( Files->Std, "%s", (FindArray( &Files->Arrays, &gad->g_Scelte ))->Label );
		    else
			FPrintf( Files->Std, "%slabels", gad->g_Label );
		    FPuts( Files->Std, "}, " );
		    if( ((struct CK)(gad->g_Data)).Act )
			FPrintf( Files->Std, "GTCY_ACTIVE, %ld, ", ((struct CK)(gad->g_Data)).Act );
		    if( gad->g_Tags & 2 )
			FPuts( Files->Std, GADisabled );
		    break;

		case PALETTE_KIND:
		    if( ((struct PK)(gad->g_Data)).Depth != 1 )
			FPrintf( Files->Std, "GTPA_DEPTH, %ld, ", ((struct PK)(gad->g_Data)).Depth );
		    if( ((struct PK)(gad->g_Data)).Color != 1 )
			FPrintf( Files->Std, "GTPA_COLOR, %ld, ", ((struct PK)(gad->g_Data)).Color );
		    if( ((struct PK)(gad->g_Data)).ColOff )
			FPrintf( Files->Std, "GTPA_COLOROFFSET, %ld, ", ((struct PK)(gad->g_Data)).ColOff );
		    if( ((struct PK)(gad->g_Data)).IW )
			FPrintf( Files->Std, "GTPA_INDICATORWIDTH, %ld, ", ((struct PK)(gad->g_Data)).IW );
		    if( ((struct PK)(gad->g_Data)).IH )
			FPrintf( Files->Std, "GTPA_INDICATORHEIGHT, %ld, ", ((struct PK)(gad->g_Data)).IH );
		    if(( ((struct PK)(gad->g_Data)).NumCol ) && ( ((struct PK)(gad->g_Data)).NumCol != 2 ))
			FPrintf( Files->Std, "GTPA_NUMCOLORS, %ld, ", ((struct PK)(gad->g_Data)).NumCol );
		    if( gad->g_Tags & 2 )
			FPuts( Files->Std, GADisabled );
		    break;

		case SCROLLER_KIND:
		    if( ((struct SK)(gad->g_Data)).Top )
			FPrintf( Files->Std, "GTSC_TOP, %ld, ", ((struct SK)(gad->g_Data)).Top );
		    if( ((struct SK)(gad->g_Data)).Tot )
			FPrintf( Files->Std, "GTSC_TOTAL, %ld, ", ((struct SK)(gad->g_Data)).Tot );
		    if( ((struct SK)(gad->g_Data)).Vis != 2 )
			FPrintf( Files->Std, "GTSC_VISIBLE, %ld, ", ((struct SK)(gad->g_Data)).Vis );
		    if( ((struct SK)(gad->g_Data)).Arr )
			FPrintf( Files->Std, "GTSC_ARROWS, %ld, ", ((struct SK)(gad->g_Data)).Arr );
		    if( ((struct SK)(gad->g_Data)).Free )
			FPuts( Files->Std, PGAFreedom );
		    if( gad->g_Tags & 2 )
			FPuts( Files->Std, GADisabled );
		    if( gad->g_Tags & 2 )
			FPuts( Files->Std, GARelVerify );
		    if( gad->g_Tags & 8 )
			FPuts( Files->Std, GAImmediate );
		    break;

		case SLIDER_KIND:
		    if( ((struct SlK)(gad->g_Data)).Min )
			FPrintf( Files->Std, "GTSL_MIN, %ld, ", ((struct SlK)(gad->g_Data)).Min );
		    if( ((struct SlK)(gad->g_Data)).Max != 15 )
			FPrintf( Files->Std, "GTSL_MAX, %ld, ", ((struct SlK)(gad->g_Data)).Max );
		    if( ((struct SlK)(gad->g_Data)).Level )
			FPrintf( Files->Std, "GTSL_LEVEL, %ld, ", ((struct SlK)(gad->g_Data)).Level );
		    if( ((struct SlK)(gad->g_Data)).MLL != 2 )
			FPrintf( Files->Std, "GTSL_MAXLEVELLEN, %ld, ", ((struct SlK)(gad->g_Data)).MLL );
		    FPrintf( Files->Std, "GTSL_LEVELPLACE, %s, ", GadFlags[ ((struct SlK)(gad->g_Data)).LevPlc ]);
		    if( ((struct SlK)(gad->g_Data)).Just )
			FPrintf( Files->Std, "GTSL_JUSTIFICATION, %ld, ", GTJ_txts[ ((struct SlK)(gad->g_Data)).Just ]);
		    if( ((struct SlK)(gad->g_Data)).Free )
			FPuts( Files->Std, PGAFreedom );
		    if( ((struct SlK)(gad->g_Data)).MPL )
			FPrintf( Files->Std, "GTSL_MAXPIXELLEN, %ld, ", ((struct SlK)(gad->g_Data)).MPL );
		    FPuts( Files->Std, "GTSL_LEVELFORMAT, " );
		    if( loc )
			FPrintf( Files->Std, "%s, ", (FindString( &Files->Strings, ((struct SlK)(gad->g_Data)).Format ))->Label );
		    else
			FPrintf( Files->Std, "'%s', ", ((struct SlK)(gad->g_Data)).Format );
		    if( gad->g_Tags & 2 )
			FPuts( Files->Std, GADisabled );
		    if( gad->g_Tags & 2 )
			FPuts( Files->Std, GARelVerify );
		    if( gad->g_Tags & 8 )
			FPuts( Files->Std, GAImmediate );
		    break;

		case STRING_KIND:
		    if( ((struct StK)(gad->g_Data)).MaxC )
			FPrintf( Files->Std, "GTST_MAXCHARS, %ld, ", ((struct StK)(gad->g_Data)).MaxC );
		    if( ((struct StK)(gad->g_Data)).Just )
			FPrintf( Files->Std, "STRINGA_JUSTIFICATION, %s, ", STRINGA_txts[ ((struct StK)(gad->g_Data)).Just ]);
		    if ( *((UBYTE *)(gad->g_ExtraMem)) ) {
			FPuts( Files->Std, "GTST_STRING, " );
			if( loc )
			    FPrintf( Files->Std, "%s, ", (FindString( &Files->Strings, gad->g_ExtraMem ))->Label );
			else
			    FPrintf( Files->Std, "'%s', ", gad->g_ExtraMem );
		    }
		    if( gad->g_Tags & 2 )
			FPuts( Files->Std, GADisabled );
		    if( gad->g_Tags & 4 )
			FPuts( Files->Std, GAImmediate );
		    if(!( gad->g_Tags & 8 ))
			FPuts( Files->Std, GATabCycle );
		    if( gad->g_Tags & 0x10 )
			FPuts( Files->Std, STRINGAExitHelp );
		    if( gad->g_Tags & 0x20 )
			FPuts( Files->Std, STRINGAReplaceMode );
		    break;

		case TEXT_KIND:
		    if( ((struct TK)(gad->g_Data)).FPen != -1 )
			FPrintf( Files->Std, "GTTX_FRONTPEN, %ld, ", ((struct TK)(gad->g_Data)).FPen );
		    if( ((struct TK)(gad->g_Data)).BPen != -1 )
			FPrintf( Files->Std, "GTTX_BACKPEN, %ld, ", ((struct TK)(gad->g_Data)).BPen );
		    if( ((struct TK)(gad->g_Data)).Just )
			FPrintf( Files->Std, "GTTX_JUSTIFICATION, %s, ", GTJ_txts[ ((struct TK)(gad->g_Data)).Just ]);
		    if ( *((UBYTE *)(gad->g_ExtraMem)) ) {
			FPuts( Files->Std, "GTTX_TEXT, " );
			if( loc )
			    FPrintf( Files->Std, "%s, ", (FindString( &Files->Strings, gad->g_ExtraMem ))->Label );
			else
			    FPrintf( Files->Std, "'%s', ", gad->g_ExtraMem );
		    }
		    if( gad->g_Tags & 2 )
			FPuts( Files->Std, "GTTX_COPYTEXT, TRUE, " );
		    if( gad->g_Tags & 4 )
			FPuts( Files->Std, "GTTX_BORDER, TRUE, " );
		    if( gad->g_Tags & 8 )
			FPuts( Files->Std, "GTTX_CLIPPED, TRUE, " );
		    break;
	    }

	    FPuts( Files->Std, "TAG_DONE,\n\t" );
	}
    }

    Flush( Files->Std );
    Seek( Files->Std, -3, OFFSET_CURRENT );
    FPuts( Files->Std, "\n]:LONG\n" );
}
///
/// WriteBooleans
void WriteBooleans( struct GenFiles *Files, struct IE_Data *IE, struct MinList *Gadgets, struct WindowInfo *wnd )
{
    struct BooleanInfo *gad, *next;
    struct ImageNode   *img;
    LONG                loc;

    loc = IE->C_Prefs & SMART_STR;

    if( IE->SrcFlags & LOCALIZE )
	loc = wnd->wi_Tags & W_LOC_GADGETS;

    for( gad = Gadgets->mlh_TailPred; gad->b_Node.ln_Pred; gad = gad->b_Node.ln_Pred ) {
	if( gad->b_Kind == BOOLEAN ) {
	    TEXT    Label[60];

	    StrToLower( gad->b_Label, Label );

	    if(( gad->b_flags2 & B_TEXT ) && ( gad->b_Titolo[0] )) {

		FPrintf( Files->Std, "\nDEF %sitext = [\n", Label );

		FPrintf( Files->Std, "\t%ld, %ld, %ld,\n"
				      "\t%ld, %ld,\n\t",
			  gad->b_FrontPen, gad->b_BackPen,
			  gad->b_DrawMode, gad->b_TxtLeft,
			  gad->b_TxtTop );

		if( gad->b_Font ) {
		    TEXT    Label[60];

		    StrToLower( gad->b_Font->txa_Label, Label );
		    FPrintf( Files->Std, "{%s}", Label );
		} else
		    FPuts( Files->Std, Null );

		FPuts( Files->Std, ",\n\t" );

		if( loc )
		    FPrintf( Files->Std, "%s", (FindString( &Files->Strings, gad->b_Titolo ))->Label );
		else
		    FPrintf( Files->Std, "'%s'", gad->b_Titolo );
		FPuts( Files->Std, ",\n\tNIL\n]:intuitext\n" );
	    }

	    FPrintf( Files->Std, "DEF %sgadget = [", Label );

	    next = gad->b_Node.ln_Succ;
	    if( next->b_Node.ln_Succ )
		FPrintf( Files->Std, "{%sgadget}", next->b_Label );
	    else
		FPuts( Files->Std, Null );


	    FPrintf( Files->Std, ",\n\t%ld, %ld, %ld, %ld,\n",
		     gad->b_Left - IE->ScreenData->XOffset,
		     gad->b_Top  - IE->ScreenData->YOffset,
		     gad->b_Width, gad->b_Height );


	    VFPrintf( Files->Std, "\t$%04x, $%04x, 1,\n", &gad->b_Flags );


	    if( img = gad->b_GadgetRender ) {
		TEXT    Label[60];

		(ULONG)img -= sizeof( struct Node );

		StrToLower( img->in_Label, Label );
		FPrintf( Files->Std, "\t{%simg}, ", Label );
	    } else
		FPuts( Files->Std, "\tNIL, " );


	    if( img = gad->b_SelectRender ) {
		TEXT    Label[60];

		(ULONG)img -= sizeof( struct Node );

		StrToLower( img->in_Label, Label );
		FPrintf( Files->Std, "{%simg},\n", Label );
	    } else
		FPuts( Files->Std, "NIL,\n" );


	    if(( gad->b_flags2 & B_TEXT ) && ( gad->b_Titolo[0] ))
		FPrintf( Files->Std, "\t{%sitext}", Label );
	    else
		FPuts( Files->Std, "\tNIL" );

	    {
		TEXT    Label[60];
		StrToUpper( gad->b_Label, Label );
		FPrintf( Files->Std, ",\n\t0, 0,\n\tGD_%s,\n\t", Label );
	    }

	    if( IE->C_Prefs & CLICKED )
		FPrintf( Files->Std, "{%sclicked}", gad->b_Label );
	    else
		FPuts( Files->Std, Null );

	    if( wnd->wi_IDCMP & IDCMP_GADGETHELP )
		FPrintf( Files->Std, ",\n\t3,\n\t%ld, %ld, %ld, %ld",
			 gad->b_Left - IE->ScreenData->XOffset,
			 gad->b_Top  - IE->ScreenData->YOffset,
			 gad->b_Width, gad->b_Height );

	    FPuts( Files->Std,
		   ( wnd->wi_IDCMP & IDCMP_GADGETHELP ) ? " ]:extgadget\n" : " ]:gadget\n" );
	}
    }
}
///
/// WriteGTypes
void WriteGTypes( struct GenFiles *Files, struct IE_Data *IE, struct MinList *Gadgets )
{
    struct GadgetInfo  *gad;

    for( gad = Gadgets->mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
	if( gad->g_Kind < BOOLEAN ) {
	    FPuts( Files->Std, GadKinds[ gad->g_Kind - 1 ]);
	    FPuts( Files->Std, ",\n\t" );
	}
    }

    FPuts( Files->Std, "NIL ]:INT\n" );
}
///
/// WriteGLabels
void WriteGLabels( struct GenFiles *Files, struct IE_Data *IE, struct MinList *Gadgets, struct WindowInfo *Wnd )
{
    struct GadgetInfo  *gad;
    ULONG               loc;

    loc = IE->C_Prefs & SMART_STR;

    if( IE->SrcFlags & LOCALIZE )
	loc = Wnd->wi_Tags & W_LOC_GADGETS;

    for( gad = Gadgets->mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {

	switch( gad->g_Kind ) {

	    case LISTVIEW_KIND:
		WriteList( Files, &gad->g_Scelte, gad->g_Label, gad->g_NumScelte, IE );
		break;

	    case MX_KIND:
	    case CYCLE_KIND:

		if(!( loc )) {
		    struct GadgetScelta    *gs;
		    TEXT                    Label[60];

		    StrToLower( gad->g_Label, Label );

		    FPrintf( Files->Std,  "\nDEF %slabels = [\n\t", Label );

		    for( gs = gad->g_Scelte.mlh_Head; gs->gs_Node.ln_Succ; gs = gs->gs_Node.ln_Succ )
			FPrintf( Files->Std, "'%s',\n\t", gs->gs_Testo );

		    FPuts( Files->Std, "NIL\n]\n" );
		}
		break;
	}
    }
}
///

