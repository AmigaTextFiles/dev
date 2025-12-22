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
#include "DEV_IE:Generators/C/Protos.h"
///
/// Prototypes
static void WriteGED( struct GenFiles *, struct IE_Data *, struct MinList * );
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

static UBYTE   GADisabled[]         = "(GA_Disabled), TRUE, ";
static UBYTE   GAImmediate[]        = "(GA_Immediate), TRUE, ";
static UBYTE   GATabCycle[]         = "(GA_TabCycle), FALSE, ";
static UBYTE   GARelVerify[]        = "(GA_RelVerify), TRUE, ";
static UBYTE   STRINGAExitHelp[]    = "(STRINGA_ExitHelp), TRUE, ";
static UBYTE   STRINGAReplaceMode[] = "(STRINGA_ReplaceMode), TRUE, ";
static UBYTE   PGAFreedom[]         = "(PGA_Freedom), LORIENT_VERT, ";
static UBYTE   LAYOUTASpacing[]     = "(LAYOUTA_Spacing), %ld, ";
///


/// CheckMultiSelect
BOOL CheckMultiSelect( struct IE_Data *IE )
{
    struct WindowInfo  *wnd;

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	struct GadgetBank  *bank;

	if( wnd->wi_NumGads - wnd->wi_NumBools ) {
	    struct GadgetInfo  *gad;

	    for( gad = wnd->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ )
		if( gad->g_Kind == LISTVIEW_KIND )
		    if( ((struct LK)( gad->g_Data )).MultiSelect )
			return( TRUE );
	}

	for( bank = wnd->wi_GBanks.mlh_Head; bank->Node.ln_Succ; bank = bank->Node.ln_Succ ) {
	    struct GadgetInfo  *gad;

	    for( gad = bank->Storage.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ )
		if( gad->g_Kind == LISTVIEW_KIND )
		    if( ((struct LK)( gad->g_Data )).MultiSelect )
			return( TRUE );
	}
    }

    return( FALSE );
}
///

/// WriteGadgetExtData
void WriteGadgetExtData( struct GenFiles *Files, struct IE_Data *IE )
{
    if( CheckMultiSelect( IE ))
	FPuts( Files->Std, "\nstruct Hook ListHook = {\n"
			   "\t{ 0 },\n"
			   "\t(HOOKFUNC)ListHookFunc,\n"
			   "\tNULL,\n"
			   "\tNULL\n"
			   "};\n" );
}
///
/// WriteNewGadgets
void WriteNewGadgets( struct GenFiles *Files, struct IE_Data *IE )
{
    struct WindowInfo  *wnd;
    LONG                loc;

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	if( wnd->wi_NumGads - wnd->wi_NumBools ) {

	    FPrintf( Files->XDef, "extern struct NewGadget\t\t%sNGad[];\n", wnd->wi_Label );
	    FPrintf( Files->Std, "\nstruct NewGadget %sNGad[] = {\n\t", wnd->wi_Label );

	    loc = Prefs.Flags & SMART_STR;

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

	    loc = Prefs.Flags & SMART_STR;

	    if( IE->SrcFlags & LOCALIZE )
		loc = wnd->wi_Tags & W_LOC_GADGETS;

	    FPrintf( Files->XDef, "extern ULONG\t\t\t%sGTags[];\n", wnd->wi_Label );
	    FPrintf( Files->Std, "\nULONG %sGTags[] = {\n\t", wnd->wi_Label );

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

	loc = Prefs.Flags & SMART_STR;

	if( IE->SrcFlags & LOCALIZE )
	    loc = wnd->wi_Tags & W_LOC_GADGETS;

	for( bank = wnd->wi_GBanks.mlh_Head; bank->Node.ln_Succ; bank = bank->Node.ln_Succ ) {
	    ULONG               NotBool = 0;
	    struct GadgetInfo  *gad;

	    for( gad = bank->Storage.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ )
		if( gad->g_Kind != BOOLEAN )
		    NotBool += 1;

	    if( NotBool ) {
		FPrintf( Files->XDef, "extern UWORD\t\t\t%sGTypes[];\n", bank->Label );
		FPrintf( Files->Std, "\nUWORD %sGTypes[] = {\n\t", bank->Label );

		WriteGTypes( Files, IE, &bank->Storage );

		WriteGLabels( Files, IE, &bank->Storage, wnd );

		FPrintf( Files->XDef, "extern struct NewGadget\t\t%sNGad[];\n", bank->Label );
		FPrintf( Files->Std, "\nstruct NewGadget %sNGad[] = {\n\t", bank->Label );

		WriteNewGads( Files, IE, &bank->Storage, loc );

		FPrintf( Files->XDef, "extern ULONG\t\t\t%sGTags[];\n", bank->Label );
		FPrintf( Files->Std, "\nULONG %sGTags[] = {\n\t", bank->Label );

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

	    FPrintf( Files->Std, "%ld, %ld, %ld, %ld, ",
		     gad->g_Left - IE->ScreenData->XOffset,
		     gad->g_Top  - IE->ScreenData->YOffset,
		     gad->g_Width, gad->g_Height );

	    if( gad->g_Titolo[0] ) {
		if( loc )
		    FPrintf( Files->Std, "(UBYTE *)%s", (( *IE->Functions->FindString )( &IE->Locale->ExtraStrings, gad->g_Titolo ))->ID );
		else
		    FPrintf( Files->Std, "\"%s\"", gad->g_Titolo );
	    } else
		FPuts( Files->Std, Null );

	    FPuts( Files->Std, ", " );

	    if( gad->g_Font )
		FPrintf( Files->Std, "&%s", gad->g_Font->txa_Label );
	    else
		FPuts( Files->Std, Null );

	    FPrintf( Files->Std, ", GD_%s, ", gad->g_Label );

	    if( gad->g_Flags ) {

		buffer[0] = '\0';

		if( gad->g_Flags & 32 ) {
		    strcpy( buffer, "NG_HIGHLABEL" );
		    or = "|";
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


	    FPuts( Files->Std, ", NULL, " );

	    if(( Prefs.Flags & CLICKED ) && ( gad->g_Kind != TEXT_KIND ) && ( gad->g_Kind != NUMBER_KIND ))
		FPrintf( Files->Std, "(APTR)%sClicked", gad->g_Label );
	    else
		FPuts( Files->Std, Null );

	    FPuts( Files->Std, ",\n\t" );
	}
    }

    Flush( Files->Std );
    Seek( Files->Std, -3, OFFSET_CURRENT );
    FPuts( Files->Std, "\n};\n" );
}
///
/// WriteTags
void WriteTags( struct GenFiles *Files, struct IE_Data *IE, struct MinList *Gadgets, ULONG loc )
{
    struct GadgetInfo  *gad;

    for( gad = Gadgets->mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
	if( gad->g_Kind < BOOLEAN ) {

	    if( gad->g_Tags & 1 )
		FPuts( Files->Std, "(GT_Underscore), '_', " );

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
			FPuts( Files->Std, "(GTCB_Checked), TRUE, " );
		    if( gad->g_Tags & 8 )
			FPuts( Files->Std, "(GTCB_Scaled), TRUE, " );
		    break;

		case INTEGER_KIND:
		    if( ((struct IK)(gad->g_Data)).Num )
			FPrintf( Files->Std, "(GTIN_Number), %ld, ", ((struct IK)(gad->g_Data)).Num );
		    if( ((struct IK)(gad->g_Data)).MaxC != 10 )
			FPrintf( Files->Std, "(GTIN_MaxChars), %ld, ", ((struct IK)(gad->g_Data)).MaxC );
		    if( ((struct IK)(gad->g_Data)).Just )
			FPrintf( Files->Std, "(STRINGA_Justification), %s, ", STRINGA_txts[ ((struct IK)(gad->g_Data)).Just ]);
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
			FPrintf( Files->Std, "(GTLV_Labels), (ULONG)&%sList, ", gad->g_Label );
		    if( ((struct LK)(gad->g_Data)).Top )
			FPrintf( Files->Std, "(GTLV_Top), %ld, ", ((struct LK)(gad->g_Data)).Top );
		    if( ((struct LK)(gad->g_Data)).Vis )
			FPrintf( Files->Std, "(GTLV_MakeVisible), %ld, ", ((struct LK)(gad->g_Data)).Vis );
		    if( ((struct LK)(gad->g_Data)).ScW != 16 )
			FPrintf( Files->Std, "(GTLV_ScrollWidth), %ld, ", ((struct LK)(gad->g_Data)).ScW );
		    if( ((struct LK)(gad->g_Data)).MultiSelect )
			FPuts( Files->Std, "(GTLV_CallBack), (ULONG)&ListHook, " );
		    else if( ((struct LK)(gad->g_Data)).Sel )
			FPrintf( Files->Std, "(GTLV_Selected), %ld, ", ((struct LK)(gad->g_Data)).Sel );
		    if( ((struct LK)(gad->g_Data)).Spc )
			FPrintf( Files->Std, LAYOUTASpacing, ((struct LK)(gad->g_Data)).Spc );
		    if( ((struct LK)(gad->g_Data)).IH )
			FPrintf( Files->Std, "(GTLV_ItemHeight), %ld, ", ((struct LK)(gad->g_Data)).IH );
		    if( ((struct LK)(gad->g_Data)).MaxP )
			FPrintf( Files->Std, "(GTLV_MaxPen), %ld, ", ((struct LK)(gad->g_Data)).MaxP );
		    if( gad->g_Tags & 2 )
			FPuts( Files->Std, GADisabled );
		    if( gad->g_Tags & 4 )
			FPuts( Files->Std, "(GTLV_ReadOnly), TRUE, " );
		    if( gad->g_Tags & 8 )
			FPuts( Files->Std, "(GTLV_ShowSelected), NULL, " );
		    break;

		case MX_KIND:
		    FPuts( Files->Std, "(GTMX_Labels), (ULONG)&" );
		    if( loc )
			FPrintf( Files->Std, "%s", (( *IE->Functions->FindArray )( &IE->Locale->Arrays, &gad->g_Scelte ))->Label );
		    else
			FPrintf( Files->Std, "%sLabels", gad->g_Label );
		    FPuts( Files->Std, "[0], " );
		    if( ((struct MK)(gad->g_Data)).Act )
			FPrintf( Files->Std, "(GTMX_Active), %ld, ", ((struct MK)(gad->g_Data)).Act );
		    if( ((struct MK)(gad->g_Data)).Spc != 1 )
			FPrintf( Files->Std, "(GTMX_Spacing), %ld, ", ((struct MK)(gad->g_Data)).Spc );
		    if( gad->g_Titolo[0] )
			FPrintf( Files->Std, "(GTMX_TitlePlace), %s, ", GadFlags[ ((struct MK)(gad->g_Data)).TitPlc ]);
		    if( gad->g_Tags & 2 )
			FPuts( Files->Std, GADisabled );
		    if( gad->g_Tags & 4 )
			FPuts( Files->Std, "(GTMX_Scaled), TRUE, " );
		    break;

		case NUMBER_KIND:
		    if( ((struct NK)(gad->g_Data)).Num )
			FPrintf( Files->Std, "(GTNM_Number), %ld, ", ((struct NK)(gad->g_Data)).Num );
		    if( ((struct NK)(gad->g_Data)).FPen != -1 )
			FPrintf( Files->Std, "(GTNM_FrontPen), %ld, ", ((struct NK)(gad->g_Data)).FPen );
		    if( ((struct NK)(gad->g_Data)).BPen != -1 )
			FPrintf( Files->Std, "(GTNM_BackPen), %ld, ", ((struct NK)(gad->g_Data)).BPen );
		    if( ((struct NK)(gad->g_Data)).Just )
			FPrintf( Files->Std, "(GTNM_Justification), %s, ", GTJ_txts[ ((struct NK)(gad->g_Data)).Just ]);
		    if( ((struct NK)(gad->g_Data)).MNL != 10 )
			FPrintf( Files->Std, "(GTNM_MaxNumberLen), %ld, ", ((struct NK)(gad->g_Data)).MNL );
		    if( strcmp( ((struct NK)(gad->g_Data)).Format, "%ld" )) {
			FPuts( Files->Std, "(GTNM_Format), (ULONG)" );
			if( loc )
			    FPrintf( Files->Std, "%s, ", (( *IE->Functions->FindString )( &IE->Locale->ExtraStrings, ((struct NK)(gad->g_Data)).Format ))->ID );
			else
			    FPrintf( Files->Std, "\"%s\", ", ((struct NK)(gad->g_Data)).Format );
		    }
		    if( gad->g_Tags & 2 )
			FPuts( Files->Std, "(GTNM_Border), TRUE, " );
		    if( gad->g_Tags & 4 )
			FPuts( Files->Std, "(GTNM_Clipped), TRUE, " );
		    break;

		case CYCLE_KIND:
		    FPuts( Files->Std, "(GTCY_Labels), (ULONG)&" );
		    if( loc )
			FPrintf( Files->Std, "%s", (( *IE->Functions->FindArray )( &IE->Locale->Arrays, &gad->g_Scelte ))->Label );
		    else
			FPrintf( Files->Std, "%sLabels", gad->g_Label );
		    FPuts( Files->Std, "[0], " );
		    if( ((struct CK)(gad->g_Data)).Act )
			FPrintf( Files->Std, "(GTCY_Active), %ld, ", ((struct CK)(gad->g_Data)).Act );
		    if( gad->g_Tags & 2 )
			FPuts( Files->Std, GADisabled );
		    break;

		case PALETTE_KIND:
		    if( ((struct PK)(gad->g_Data)).Depth != 1 )
			FPrintf( Files->Std, "(GTPA_Depth), %ld, ", ((struct PK)(gad->g_Data)).Depth );
		    if( ((struct PK)(gad->g_Data)).Color != 1 )
			FPrintf( Files->Std, "(GTPA_Color), %ld, ", ((struct PK)(gad->g_Data)).Color );
		    if( ((struct PK)(gad->g_Data)).ColOff )
			FPrintf( Files->Std, "(GTPA_ColorOffset), %ld, ", ((struct PK)(gad->g_Data)).ColOff );
		    if( ((struct PK)(gad->g_Data)).IW )
			FPrintf( Files->Std, "(GTPA_IndicatorWidth), %ld, ", ((struct PK)(gad->g_Data)).IW );
		    if( ((struct PK)(gad->g_Data)).IH )
			FPrintf( Files->Std, "(GTPA_IndicatorHeight), %ld, ", ((struct PK)(gad->g_Data)).IH );
		    if(( ((struct PK)(gad->g_Data)).NumCol ) && ( ((struct PK)(gad->g_Data)).NumCol != 2 ))
			FPrintf( Files->Std, "(GTPA_NumColors), %ld, ", ((struct PK)(gad->g_Data)).NumCol );
		    if( gad->g_Tags & 2 )
			FPuts( Files->Std, GADisabled );
		    break;

		case SCROLLER_KIND:
		    if( ((struct SK)(gad->g_Data)).Top )
			FPrintf( Files->Std, "(GTSC_Top), %ld, ", ((struct SK)(gad->g_Data)).Top );
		    if( ((struct SK)(gad->g_Data)).Tot )
			FPrintf( Files->Std, "(GTSC_Total), %ld, ", ((struct SK)(gad->g_Data)).Tot );
		    if( ((struct SK)(gad->g_Data)).Vis != 2 )
			FPrintf( Files->Std, "(GTSC_Visible), %ld, ", ((struct SK)(gad->g_Data)).Vis );
		    if( ((struct SK)(gad->g_Data)).Arr )
			FPrintf( Files->Std, "(GTSC_Arrows), %ld, ", ((struct SK)(gad->g_Data)).Arr );
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
			FPrintf( Files->Std, "(GTSL_Min), %ld, ", ((struct SlK)(gad->g_Data)).Min );
		    if( ((struct SlK)(gad->g_Data)).Max != 15 )
			FPrintf( Files->Std, "(GTSL_Max), %ld, ", ((struct SlK)(gad->g_Data)).Max );
		    if( ((struct SlK)(gad->g_Data)).Level )
			FPrintf( Files->Std, "(GTSL_Level), %ld, ", ((struct SlK)(gad->g_Data)).Level );
		    if( ((struct SlK)(gad->g_Data)).MLL != 2 )
			FPrintf( Files->Std, "(GTSL_MaxLevelLen), %ld, ", ((struct SlK)(gad->g_Data)).MLL );
		    FPrintf( Files->Std, "(GTSL_LevelPlace), %s, ", GadFlags[ ((struct SlK)(gad->g_Data)).LevPlc ]);
		    if( ((struct SlK)(gad->g_Data)).Just )
			FPrintf( Files->Std, "(GTSL_Justification), %ld, ", GTJ_txts[ ((struct SlK)(gad->g_Data)).Just ]);
		    if( ((struct SlK)(gad->g_Data)).Free )
			FPuts( Files->Std, PGAFreedom );
		    if( ((struct SlK)(gad->g_Data)).MPL )
			FPrintf( Files->Std, "(GTSL_MaxPixelLen), %ld, ", ((struct SlK)(gad->g_Data)).MPL );
		    FPuts( Files->Std, "(GTSL_LevelFormat), (ULONG)" );
		    if( loc )
			FPrintf( Files->Std, "%s, ", (( *IE->Functions->FindString )( &IE->Locale->ExtraStrings, ((struct SlK)(gad->g_Data)).Format ))->ID );
		    else
			FPrintf( Files->Std, "\"%s\", ", ((struct SlK)(gad->g_Data)).Format );
		    if( gad->g_Tags & 2 )
			FPuts( Files->Std, GADisabled );
		    if( gad->g_Tags & 2 )
			FPuts( Files->Std, GARelVerify );
		    if( gad->g_Tags & 8 )
			FPuts( Files->Std, GAImmediate );
		    break;

		case STRING_KIND:
		    if( ((struct StK)(gad->g_Data)).MaxC )
			FPrintf( Files->Std, "(GTST_MaxChars), %ld, ", ((struct StK)(gad->g_Data)).MaxC );
		    if( ((struct StK)(gad->g_Data)).Just )
			FPrintf( Files->Std, "(STRINGA_Justification), %s, ", STRINGA_txts[ ((struct StK)(gad->g_Data)).Just ]);
		    if ( *((UBYTE *)(gad->g_ExtraMem)) ) {
			FPuts( Files->Std, "(GTST_String), (ULONG)" );
			if( loc )
			    FPrintf( Files->Std, "%s, ", (( *IE->Functions->FindString )( &IE->Locale->ExtraStrings, gad->g_ExtraMem ))->ID );
			else
			    FPrintf( Files->Std, "\"%s\", ", gad->g_ExtraMem );
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
			FPrintf( Files->Std, "(GTTX_FrontPen), %ld, ", ((struct TK)(gad->g_Data)).FPen );
		    if( ((struct TK)(gad->g_Data)).BPen != -1 )
			FPrintf( Files->Std, "(GTTX_BackPen), %ld, ", ((struct TK)(gad->g_Data)).BPen );
		    if( ((struct TK)(gad->g_Data)).Just )
			FPrintf( Files->Std, "(GTTX_Justification), %s, ", GTJ_txts[ ((struct TK)(gad->g_Data)).Just ]);
		    if ( *((UBYTE *)(gad->g_ExtraMem)) ) {
			FPuts( Files->Std, "(GTTX_Text), (ULONG)" );
			if( loc )
			    FPrintf( Files->Std, "%s, ", (( *IE->Functions->FindString )( &IE->Locale->ExtraStrings, gad->g_ExtraMem ))->ID );
			else
			    FPrintf( Files->Std, "\"%s\", ", gad->g_ExtraMem );
		    }
		    if( gad->g_Tags & 2 )
			FPuts( Files->Std, "(GTTX_CopyText), TRUE, " );
		    if( gad->g_Tags & 4 )
			FPuts( Files->Std, "(GTTX_Border), TRUE, " );
		    if( gad->g_Tags & 8 )
			FPuts( Files->Std, "(GTTX_Clipped), TRUE, " );
		    break;
	    }

	    FPuts( Files->Std, "(TAG_DONE),\n\t" );
	}
    }

    Flush( Files->Std );
    Seek( Files->Std, -3, OFFSET_CURRENT );
    FPuts( Files->Std, "\n};\n" );
}
///
/// WriteBooleans
void WriteBooleans( struct GenFiles *Files, struct IE_Data *IE, struct MinList *Gadgets, struct WindowInfo *wnd )
{
    struct BooleanInfo *gad, *next;
    UBYTE              *str;
    struct ImageNode   *img;
    LONG                loc;

    loc = Prefs.Flags & SMART_STR;

    if( IE->SrcFlags & LOCALIZE )
	loc = wnd->wi_Tags & W_LOC_GADGETS;

    for( gad = Gadgets->mlh_TailPred; gad->b_Node.ln_Pred; gad = gad->b_Node.ln_Pred ) {
	if( gad->b_Kind == BOOLEAN ) {

	    if(( gad->b_flags2 & B_TEXT ) && ( gad->b_Titolo[0] )) {

		FPrintf( Files->Std, "\nstruct IntuiText %sIText = {\n", gad->b_Label );

		FPrintf( Files->Std, "\t%ld, %ld, %ld,\n"
				      "\t%ld, %ld,\n\t",
			  gad->b_FrontPen, gad->b_BackPen,
			  gad->b_DrawMode, gad->b_TxtLeft,
			  gad->b_TxtTop );

		if( gad->b_Font )
		    FPrintf( Files->Std, "&%s", gad->b_Font->txa_Label );
		else
		    FPuts( Files->Std, Null );

		FPuts( Files->Std, ",\n\t(UBYTE *)" );

		if( loc )
		    FPrintf( Files->Std, "%s", (( *IE->Functions->FindString )( &IE->Locale->ExtraStrings, gad->b_Titolo ))->ID );
		else
		    FPrintf( Files->Std, "\"%s\"", gad->b_Titolo );
		FPuts( Files->Std, ",\n\tNULL\n};\n" );
	    }

	    str = ( wnd->wi_IDCMP & IDCMP_GADGETHELP ) ? "extern struct ExtGadget\t\t%sGadget;\n" : "extern struct Gadget\t\t%sGadget;\n";
	    FPrintf( Files->XDef, str, gad->b_Label );

	    str = ( wnd->wi_IDCMP & IDCMP_GADGETHELP ) ? "\nstruct ExtGadget %sGadget = {\n\t" : "\nstruct Gadget %sGadget = {\n\t";
	    FPrintf( Files->Std, str, gad->b_Label );

	    next = gad->b_Node.ln_Succ;
	    if( next->b_Node.ln_Succ )
		FPrintf( Files->Std, "&%sGadget", next->b_Label );
	    else
		FPuts( Files->Std, Null );


	    FPrintf( Files->Std, ",\n\t%ld, %ld, %ld, %ld,\n",
		     gad->b_Left - IE->ScreenData->XOffset,
		     gad->b_Top  - IE->ScreenData->YOffset,
		     gad->b_Width, gad->b_Height );


	    VFPrintf( Files->Std, "\t0x%04x, 0x%04x, 1,\n", &gad->b_Flags );


	    if( img = gad->b_GadgetRender ) {
		(ULONG)img -= sizeof( struct Node );
		FPrintf( Files->Std, "\t&%sImg, ", img->in_Label );
	    } else
		FPuts( Files->Std, "\tNULL, " );


	    if( img = gad->b_SelectRender ) {
		(ULONG)img -= sizeof( struct Node );
		FPrintf( Files->Std, "&%sImg,\n", img->in_Label );
	    } else
		FPuts( Files->Std, "NULL,\n" );


	    if(( gad->b_flags2 & B_TEXT ) && ( gad->b_Titolo[0] ))
		FPrintf( Files->Std, "\t&%sIText", gad->b_Label );
	    else
		FPuts( Files->Std, "\tNULL" );

	    FPrintf( Files->Std, ",\n\t0, 0,\n\tGD_%s,\n\t", gad->b_Label );

	    if( Prefs.Flags & CLICKED )
		FPrintf( Files->Std, "(APTR)%sClicked", gad->b_Label );
	    else
		FPuts( Files->Std, Null );

	    if( wnd->wi_IDCMP & IDCMP_GADGETHELP )
		FPrintf( Files->Std, ",\n\t3,\n\t%ld, %ld, %ld, %ld",
			 gad->b_Left - IE->ScreenData->XOffset,
			 gad->b_Top  - IE->ScreenData->YOffset,
			 gad->b_Width, gad->b_Height );

	    FPuts( Files->Std, "\n};\n" );
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

    FPuts( Files->Std, "NULL };\n" );
}
///
/// WriteGLabels
void WriteGLabels( struct GenFiles *Files, struct IE_Data *IE, struct MinList *Gadgets, struct WindowInfo *Wnd )
{
    struct GadgetInfo  *gad;
    ULONG               loc;

    loc = Prefs.Flags & SMART_STR;

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
		    struct GadgetScelta *gs;

		    FPrintf( Files->XDef, "extern UBYTE\t\t\t*%sLabels[];\n", gad->g_Label );
		    FPrintf( Files->Std,  "\nUBYTE *%sLabels[] = {\n\t", gad->g_Label );

		    for( gs = gad->g_Scelte.mlh_Head; gs->gs_Node.ln_Succ; gs = gs->gs_Node.ln_Succ )
			FPrintf( Files->Std, "(UBYTE *)\"%s\",\n\t", gs->gs_Testo );

		    FPuts( Files->Std, "NULL\n};\n" );
		}
		break;
	}
    }
}
///

