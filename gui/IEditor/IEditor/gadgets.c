/// Include
#include <stdarg.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>


#define INTUI_V36_NAMES_ONLY
#define ASL_V38_NAMES_ONLY
#define CATCOMP_NUMBERS

#include <exec/nodes.h>                 // exec
#include <exec/lists.h>
#include <exec/memory.h>
#include <exec/types.h>
#include <graphics/rastport.h>          // graphics
#include <intuition/intuition.h>        // intuition
#include <dos/dos.h>                    // dos
#include <libraries/gadtools.h>         // libraries
#include <libraries/asl.h>
#include <clib/exec_protos.h>           // protos
#include <clib/intuition_protos.h>
#include <clib/graphics_protos.h>
#include <clib/dos_protos.h>
#include <clib/locale_protos.h>
#include <clib/asl_protos.h>
#include <clib/gadtools_protos.h>
#include <pragmas/exec_pragmas.h>       // pragmas
#include <pragmas/intuition_pragmas.h>
#include <pragmas/graphics_pragmas.h>
#include <pragmas/dos_pragmas.h>
#include <pragmas/asl_pragmas.h>
#include <pragmas/gadtools_pragmas.h>
#include <pragmas/locale_pragmas.h>


#include "DEV_IE:defs.h"
#include "DEV_IE:GUI.h"
#include "DEV_IE:GUI_locale.h"
#include "DEV_IE:Include/expander_pragmas.h"
///
/// Prototipi
static BOOL     CopiaBooleano( struct BooleanInfo *, WORD, WORD );
static BOOL     Resizable( struct GadgetInfo * );
static UWORD    CheckResizeGad( void );
static BOOL     TraceGadRect( UWORD, WORD *, WORD * );
static void     RedrawResize( UWORD, WORD, WORD );
static BOOL     MuoviGadgets( struct GadgetInfo *, WORD, WORD, WORD *, WORD *, UWORD );
static BOOL     Attiva( WORD, WORD, WORD, WORD );
static BOOL     AttivaUno( WORD, WORD );
static void     IntegerDefault( struct GadgetInfo * );
static void     ListviewDefault( struct GadgetInfo * );
static void     MxDefault( struct GadgetInfo * );
static void     NumberDefault( struct GadgetInfo * );
static void     CycleDefault( struct GadgetInfo * );
static void     PaletteDefault( struct GadgetInfo * );
static void     ScrollerDefault( struct GadgetInfo * );
static void     SliderDefault( struct GadgetInfo * );
static void     StringDefault( struct GadgetInfo * );
static void     TextDefault( struct GadgetInfo * );
static void     SetButtonTag( ULONG *, ULONG, struct GadgetInfo * );
static void     SetCheckboxTag( ULONG *, ULONG, struct GadgetInfo * );
static void     SetIntegerTag( ULONG *, ULONG, struct GadgetInfo * );
static void     SetListviewTag( ULONG *, ULONG, struct GadgetInfo * );
static void     SetMxTag( ULONG *, ULONG, struct GadgetInfo * );
static void     SetNumberTag( ULONG *, ULONG, struct GadgetInfo * );
static void     SetCycleTag( ULONG *, ULONG, struct GadgetInfo * );
static void     SetPaletteTag( ULONG *, ULONG, struct GadgetInfo * );
static void     SetScrollerTag( ULONG *, ULONG, struct GadgetInfo * );
static void     SetSliderTag( ULONG *, ULONG, struct GadgetInfo * );
static void     SetStringTag( ULONG *, ULONG, struct GadgetInfo * );
static void     SetTextTag( ULONG *, ULONG, struct GadgetInfo * );
static void     ListEdStaccaLista( void );
static void     ListEdAttaccaLista( void );
static void     AttivaListEdGadgets( void );
static void     DisattivaListEdGadgets( void );
static void     SettaListEdIn( void );
static void     ParametriButton( struct GadgetInfo * );
static void     ParametriCheckbox( struct GadgetInfo * );
static void     ParametriInteger( struct GadgetInfo * );
static void     ParametriListview( struct GadgetInfo * );
static void     ParametriMx( struct GadgetInfo * );
static void     ParametriNumber( struct GadgetInfo * );
static void     ParametriCycle( struct GadgetInfo * );
static void     ParametriPalette( struct GadgetInfo * );
static void     ParametriScroller( struct GadgetInfo * );
static void     ParametriSlider( struct GadgetInfo * );
static void     ParametriString( struct GadgetInfo * );
static void     ParametriText( struct GadgetInfo * );
///
/// Dati
WORD    lastx, lasty;
APTR    buffer4;

static  ULONG   BackValue;

ULONG   gadget_flags[] = { 1, 2, 4, 8, 16, 0 };

struct MinList  ListEd_List;

static ULONG menugad_on[] = {
	    (1<<5)|2,
	    (2<<5)|2,
	    (4<<5)|2,
	    (5<<5)|2,
	    (-1<<11)|(6<<5)|2,
	    (7<<5)|2,
	    (-1<<11)|(9<<5)|2,
	    (-1<<11)|(10<<5)|2,
	    (-1<<11)|(11<<5)|2,
	    (-1<<11)|(12<<5)|2,
	    (13<<5)|2,
	    (14<<5)|2,
	    (16<<5)|2
	};

#define GADMENU_NUM 13

struct GXY gadgetxy_index[] = {
	    0, 0, 0,     // non esiste un Kind == 0
	    0, 0, TRUE,
	    CHECKBOX_WIDTH, CHECKBOX_HEIGHT, FALSE,
	    0, 0, TRUE,
	    0, 0, TRUE,
	    MX_WIDTH, MX_HEIGHT, FALSE,
	    0, 0, TRUE,
	    0, 0, TRUE,
	    0, 0, TRUE,
	    0, 0, TRUE,
	    0, 0, TRUE,
	    0, 0, TRUE,
	    0, 0, TRUE,
	    0, 0, TRUE,
	    0, 0, TRUE,
	};

APTR pre_gadget_index[] = {
	    NULL,
	    NULL,
	    (APTR)IntegerDefault,
	    (APTR)ListviewDefault,
	    (APTR)MxDefault,
	    (APTR)NumberDefault,
	    (APTR)CycleDefault,
	    (APTR)PaletteDefault,
	    (APTR)ScrollerDefault,
	    NULL,
	    (APTR)SliderDefault,
	    (APTR)StringDefault,
	    (APTR)TextDefault
	};

UWORD stringjusts[] = { GACT_STRINGLEFT, GACT_STRINGRIGHT, GACT_STRINGCENTER };

static ULONG button_newtag[] = {
    GT_Underscore, '_', GA_Disabled, FALSE, TAG_END };
static ULONG checkbox_newtag[] = {
    GT_Underscore, '_', GA_Disabled, FALSE, GTCB_Checked, FALSE, GTCB_Scaled, FALSE, TAG_END };
static ULONG integer_newtag[] = {
    GT_Underscore, '_', GTIN_Number, 0, STRINGA_Justification, 0, GA_Disabled, 0, GA_TabCycle, 0, STRINGA_ReplaceMode, 0, TAG_END };
static ULONG listview_newtag[] = {
    GT_Underscore, '_', GTLV_ScrollWidth, 0, LAYOUTA_Spacing, 0, GA_Disabled, FALSE, GTLV_Labels, 0, GTLV_ReadOnly, 0, TAG_END };
static ULONG mx_newtag[] = {
    GT_Underscore, '_', GTMX_Labels, 0, GTMX_Active, 0, GTMX_Spacing, 0, GTMX_TitlePlace, 0, GA_Disabled, FALSE, GTMX_Scaled, 0, TAG_END };
static ULONG number_newtag[] = {
    GT_Underscore, '_', GTNM_Number, 0, GTNM_Justification, 0, GTNM_MaxNumberLen, 0, GTNM_Border, 0, GTNM_Clipped, 0, GTNM_Format, 0, GTNM_FrontPen, 0, GTNM_BackPen, 0, TAG_END };
static ULONG cycle_newtag[] = {
    GT_Underscore, '_', GTCY_Labels, 0, GTCY_Active, 0, GA_Disabled, FALSE, TAG_END };
static ULONG palette_newtag[] = {
    GT_Underscore, '_', GTPA_Depth, 0, GTPA_Color, 0, GTPA_ColorOffset, 0, GTPA_IndicatorWidth, 0, GTPA_IndicatorHeight, 0, GTPA_NumColors, 0, GA_Disabled, FALSE, TAG_END };
static ULONG scroller_newtag[] = {
    GT_Underscore, '_', GTSC_Top, 0, GTSC_Total, 0, GTSC_Visible, 0, GTSC_Arrows, 0, PGA_Freedom, 0, GA_Disabled, FALSE, TAG_END };
static ULONG slider_newtag[] = {
    GT_Underscore, '_', GTSL_Min, 0, GTSL_Max, 0, GTSL_Level, 0, GTSL_MaxLevelLen, 0, GTSL_LevelFormat, 0, GTSL_LevelPlace, 0, GTSL_MaxPixelLen, 0, GTSL_Justification, 0, PGA_Freedom, 0, GA_Disabled, FALSE, TAG_END };
static ULONG string_newtag[] = {
    GT_Underscore, '_', GTST_MaxChars, 0, STRINGA_Justification, 0, GTST_String, 0, GA_Disabled, FALSE, GA_TabCycle, 0, STRINGA_ExitHelp, 0, STRINGA_ReplaceMode, 0, TAG_END };
static ULONG text_newtag[] = {
    GT_Underscore, '_', GTTX_Justification, 0, GTTX_Text, 0, GTTX_Border, 0, GTTX_Clipped, 0, GTTX_FrontPen, 0, GTTX_BackPen, 0, TAG_END };

APTR newtags_index[] = {
	    button_newtag,
	    checkbox_newtag,
	    integer_newtag,
	    listview_newtag,
	    mx_newtag,
	    number_newtag,
	    cycle_newtag,
	    palette_newtag,
	    scroller_newtag,
	    NULL,
	    slider_newtag,
	    string_newtag,
	    text_newtag
	};

APTR settag_index[] = {
	    NULL,
	    (APTR)SetButtonTag,
	    (APTR)SetCheckboxTag,
	    (APTR)SetIntegerTag,
	    (APTR)SetListviewTag,
	    (APTR)SetMxTag,
	    (APTR)SetNumberTag,
	    (APTR)SetCycleTag,
	    (APTR)SetPaletteTag,
	    (APTR)SetScrollerTag,
	    NULL,
	    (APTR)SetSliderTag,
	    (APTR)SetStringTag,
	    (APTR)SetTextTag
	};

APTR modifica_index[] = {
	    NULL,
	    (APTR)ParametriButton,
	    (APTR)ParametriCheckbox,
	    (APTR)ParametriInteger,
	    (APTR)ParametriListview,
	    (APTR)ParametriMx,
	    (APTR)ParametriNumber,
	    (APTR)ParametriCycle,
	    (APTR)ParametriPalette,
	    (APTR)ParametriScroller,
	    NULL,
	    (APTR)ParametriSlider,
	    (APTR)ParametriString,
	    (APTR)ParametriText,
	    (APTR)ParametriBooleano
	};
///



/// TestAttivi
BOOL TestAttivi( void )
{
    BOOL                ret = FALSE;
    struct GadgetInfo  *gad;

    for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
	if( gad->g_flags2 & G_ATTIVO )
	    ret = TRUE;
    }

    return( ret );
}
///

/// CheckSize  ( controllo dimensioni minime gadget )
void CheckSize( struct GadgetInfo *gad )
{
    UWORD   x;

    if(!( gad->g_Width ))
	gad->g_Width = 1;

    switch( gad->g_Kind ) {

	case STRING_KIND:
	case INTEGER_KIND:
	case TEXT_KIND:
	case NUMBER_KIND:
	    x = Scr->Font->ta_YSize + 1;
	    if( gad->g_Height < x )
		gad->g_Height = x;
	break;

	case LISTVIEW_KIND:
	    if( gad->g_Height < 12 )
		gad->g_Height = 12;
	    break;

	default:
	    if(!( gad->g_Height ))
		gad->g_Height = 1;
	    break;
    }
}
///

/// GetGad
struct GadgetInfo *GetGad( void )
{
    struct GadgetInfo      *gad = NULL, *gad2;
    struct IntuiMessage    *msg;
    ULONG                   class;
    int                     code, x, y;
    BOOL                    ok = TRUE;

    StaccaGadgets();

    Stat( CatCompArray[ MSG_CLICK ].cca_Str, FALSE, 0 );

    do {

	WaitPort( IE.win_active->UserPort );

	while( msg = GT_GetIMsg( IE.win_active->UserPort )) {

	    class = msg->Class;
	    code  = msg->Code;
	    x     = msg->MouseX;
	    y     = msg->MouseY;

	    GT_ReplyIMsg( msg );

	    switch( class ) {

		case IDCMP_VANILLAKEY:
		    if( code == 27 ) {
			ok = FALSE;
			Stat( CatCompArray[ MSG_ABORTED ].cca_Str, FALSE, 0 );
		    }
		    break;

		case IDCMP_REFRESHWINDOW:
		    RinfrescaFinestra();
		    break;

		case IDCMP_MOUSEBUTTONS:
		    switch( code ) {
			case 0x69:
			    ok = FALSE;
			    Stat( CatCompArray[ MSG_ABORTED ].cca_Str, FALSE, 0 );
			    break;

			case 0x68:
			    for( gad2 = IE.win_info->wi_Gadgets.mlh_Head; gad2->g_Node.ln_Succ; gad2 = gad2->g_Node.ln_Succ ) {
				BOOL can = FALSE;

				if( gad2->g_Kind < MIN_IEX_ID )
				    can = TRUE;
				else {
				    struct IEXNode *ex;

				    ex = IE.Expanders.mlh_Head;
				    while( ex->ID != gad2->g_Kind )
					ex = ex->Node.ln_Succ;

				    if( ex->Base->Movable || ex->Base->Resizable )
					can = TRUE;
				}

				if(( can ) && (( x >= gad2->g_Left ) && ( x < gad2->g_Left + gad2->g_Width ) && ( y >= gad2->g_Top ) && ( y < gad2->g_Top + gad2->g_Height ))) {
				    ok = FALSE;
				    gad2->g_flags2 |= G_WAS_ACTIVE;
				}
			    }

			    if(!( ok )) {
				ULONG area = 0xffffffff, area2;

				for( gad2 = IE.win_info->wi_Gadgets.mlh_Head; gad2->g_Node.ln_Succ; gad2 = gad2->g_Node.ln_Succ ) {
				    if( gad2->g_flags2 & G_WAS_ACTIVE ) {
					gad2->g_flags2 &= ~G_WAS_ACTIVE;

					area2 = gad2->g_Width * gad2->g_Height;

					if( area2 < area ) {
					    gad = gad2;
					    area = area2;
					}
				    }
				}
			    }
			    break;
		    }
		    break;

	    }

	}

    } while( ok );

    AttaccaGadgets();

    IE.flags &= ~MOVE;

    return( gad );
}
///

/// Copia Booleano
BOOL CopiaBooleano( struct BooleanInfo *from, WORD x, WORD y )
{
    struct BooleanInfo *to;
    BOOL                ret = FALSE;
    struct TxtAttrNode *font;

    if( to = AllocObject( IE_BOOLEAN )) {

	CopyMem(( char * )from, ( char * )to, sizeof( struct BooleanInfo ));
	AddTail((struct List *)&IE.win_info->wi_Gadgets, (struct Node *)to );

	to->b_GadgetText = &to->b_FrontPen;
	to->b_flags2 &= ~G_ATTIVO;
	to->b_Left   += x;
	to->b_Top    += y;

	if( font = to->b_TextFont ) {
	    (ULONG)font -= 14;
	    font->txa_OpenCnt += 1;
	}

	IE.win_info->wi_NumGads  += 1;
	IE.win_info->wi_NumBools += 1;

	ret = TRUE;
    }

    return( ret );
}
///

/// Copia Gadgets
BOOL CopiaGadMenued( void )
{
    struct GadgetInfo  *gad, *to;
    struct GadgetScelta *gs, *gs2;
    struct TxtAttrNode  *font;
    WORD                x, y;
    BOOL                ok = TRUE;
    ULONG              *ptr;


    if( TestAttivi() ) {

	gad = IE.win_info->wi_Gadgets.mlh_Head;
	while(!( gad->g_flags2 & G_ATTIVO ))
	    gad = gad->g_Node.ln_Succ;

	x = 0;
	y = 0;

	if( MuoviGadgets( gad, gad->g_Left, gad->g_Top, &x, &y, 0x68 )) {

	    for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
		if(( gad->g_flags2 & G_ATTIVO ) && ( gad->g_Kind < MIN_IEX_ID )) {

		    if( gad->g_Kind == BOOLEAN ) {

			ok = CopiaBooleano(( struct BooleanInfo * )gad, x, y );

		    } else {

			if( to = AllocObject( IE_GADGET )) {

			    CopyMem(( char * )gad, (char *)to, sizeof( struct GadgetInfo ));
			    AddTail(( struct List * )&IE.win_info->wi_Gadgets, (struct Node *)to );

			    IE.win_info->wi_NumGads += 1;

			    to->g_GadgetText = to->g_Titolo;
			    to->g_flags2    &= ~G_ATTIVO;
			    to->g_Left      += x;
			    to->g_Top       += y;

			    if( font = to->g_Font )
				font->txa_OpenCnt += 1;

			    NewList( &to->g_Scelte );

			    if(( ptr = gad->g_ExtraMem ) && ( gad->g_Kind != MX_KIND ) && ( gad->g_Kind != CYCLE_KIND )){

				(ULONG)ptr -= 4;

				if( to->g_ExtraMem = AllocVec( *ptr, 0L )) {
				    CopyMem((char *)gad->g_ExtraMem, (char *)to->g_ExtraMem, *ptr);
				} else {
				    ok = FALSE;
				}
			    } else {
				to->g_ExtraMem = NULL;
			    }

			    for( gs = gad->g_Scelte.mlh_Head; gs->gs_Node.ln_Succ; gs = gs->gs_Node.ln_Succ ) {
				if( gs2 = AllocObject( IE_ITEM )) {

				    AddTail(( struct List * )&to->g_Scelte, (struct Node *)gs2);
				    gs2->gs_Node.ln_Name = gs2->gs_Testo;
				    strcpy( gs2->gs_Testo, gs->gs_Testo );

				} else {
				    DisplayBeep( Scr );
				}
			    }

			} else {
			    ok = FALSE;
			}
		    }

		    if(!( ok )) {
			Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, FALSE, 0 );
			return( TRUE );
		    }
		}
	    }

	    struct IEXNode *ex;
	    for( ex = IE.Expanders.mlh_Head; ex->Node.ln_Succ; ex = ex->Node.ln_Succ ) {
		IEXBase = ex->Base;
		if(!( IEX_Copy( ex->ID, &IE, x, y ))) {
		    Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, FALSE, 0 );
		    return( TRUE );
		}
	    }

	    Stat( CatCompArray[ MSG_DONE ].cca_Str, FALSE, 0 );
	    RifaiGadgets();
	    RinfrescaFinestra();
	    offx = offy = 0;
	    Coord();
	    IE.flags &= ~SALVATO;

	} else {
	    Stat( CatCompArray[ MSG_ABORTED ].cca_Str, FALSE, 0 );
	}

    }
}
///

/// Font Request
struct TxtAttrNode *FontRequest( struct TextAttr *font, STRPTR titolo, ULONG titnum )
{
    struct TxtAttrNode *ret = NULL;
    static struct TextAttr     def = { "topaz.font", 8, 0, 1 };
    struct FontRequester *req;

    LockAllWindows();

    if( font ) {
	def.ta_Name  = font->ta_Name;
	def.ta_YSize = font->ta_YSize;
	def.ta_Style = font->ta_Style;
	def.ta_Flags = font->ta_Flags;
    }

    if( LocaleBase ) {
	titolo = GetCatalogStr( Catalog, titnum, titolo );
    }

    if( req = AllocAslRequest( ASL_FontRequest, NULL )) {

	if( AslRequestTags( req,
			ASLFO_TitleText,        titolo,
			ASLFO_DoStyle,          TRUE,
			ASLFO_MaxHeight,        300,
			ASLFO_InitialHeight,    Scr->Height - 40,
			ASLFO_InitialName,      def.ta_Name,
			ASLFO_InitialSize,      def.ta_YSize,
			ASLFO_InitialStyle,     def.ta_Style,
			ASLFO_InitialFlags,     def.ta_Flags,
			ASLFO_Window,           BackWnd,
			TAG_END )) {

	    ret = AggiungiFont( &req->fo_Attr );

	}

	FreeAslRequest( req );

    } else {
	Stat( CatCompArray[ ERR_NOASL ].cca_Str, TRUE, 0 );
    }

    UnlockAllWindows();
    return( ret );
}
///

/// Gadget Font
BOOL GadFontMenued( void )
{
    struct GadgetInfo   *gad;
    struct TxtAttrNode  *font;
    struct TextAttr     *ta;

    if( TestAttivi() ) {

	gad = IE.win_info->wi_Gadgets.mlh_Head;
	while(!( gad->g_flags2 & G_ATTIVO ))
	    gad = gad->g_Node.ln_Succ;

	if( gad->g_Kind >= MIN_IEX_ID ) {
	    struct IEXNode *ex;

	    ex = IE.Expanders.mlh_Head;
	    while( ex->ID != gad->g_Kind )
		ex = ex->Node.ln_Succ;

	    if(!( ex->Base->UseFonts ))
		return( TRUE );
	}

	ta = gad->g_Font ? &gad->g_Font->txa_FontName : NULL;

	if( font = FontRequest( ta, CatCompArray[ ASL_GAD_FONT ].cca_Str, ASL_GAD_FONT )) {

	    font->txa_OpenCnt -= 1;

	    for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
		if( gad->g_flags2 & G_ATTIVO ) {

		    BOOL ok = TRUE;

		    if( gad->g_Kind >= MIN_IEX_ID ) {
			struct IEXNode *ex2;

			ex2 = IE.Expanders.mlh_Head;
			while( ex2->ID != gad->g_Kind )
			    ex2 = ex2->Node.ln_Succ;

			ok = ex2->Base->UseFonts;
		    }

		    if( ok ) {
			EliminaFont( gad->g_Font );

			gad->g_Font = font;
			font->txa_OpenCnt += 1;
		    }

		    if( gad->g_Kind == BOOLEAN )
			((struct BooleanInfo *)gad)->b_TextFont = &font->txa_FontName;
		    else
			if( gad->g_Kind < MIN_IEX_ID )
			    gad->g_TextAttr = &font->txa_FontName;
		}
	    }

	    RifaiGadgets();
	    RinfrescaFinestra();
	    IE.flags &= ~SALVATO;
	}
    }

    return( TRUE );
}
///

/// Ridimensiona gadgets
BOOL Resizable( struct GadgetInfo *gad )
{
    BOOL    ret = TRUE;

    if( gad->g_Kind < MIN_IEX_ID ) {
	if(!( gadgetxy_index[ gad->g_Kind ].Resize )) {
	    if( gad->g_Kind == MX_KIND ) {
		ret = gad->g_Tags & 4;
	    } else {
		ret = gad->g_Tags & 8;
	    }
	}
    } else {
	struct IEXNode *ex;

	ex = IE.Expanders.mlh_Head;

	while( ex->ID != gad->g_Kind )
	    ex = ex->Node.ln_Succ;

	ret = ex->Base->Resizable;
    }

    return( ret );
}

BOOL ResizeGadgets( void )
{
    BOOL                ret = FALSE;
    UWORD               code;
    WORD                x, y, x1, y1, y2, x2;
    struct GadgetInfo  *gad;

    if(!( Resizable( IE.gad_id )))
	return( FALSE );

    code = CheckResizeGad();

    if( code != 0 ) {

	ret = TRUE;

	if( TraceGadRect( code, &x, &y )) {

	    for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
		if( gad->g_flags2 & G_ATTIVO ) {

		    if( Resizable( gad )) {

			x1 = gad->g_Left;
			x2 = x1 + gad->g_Width - 1;
			y1 = gad->g_Top;
			y2 = y1 + gad->g_Height - 1;

			if( code >= 3 ) { // parte destra
			    x2 += x;
			} else {
			    x1 += x;
			}

			if(!( code & 1 )) { // parte inferiore
			    y2 += y;
			} else {
			    y1 += y;
			}

			if( x1 > x2 ) {
			    x = x1;
			    x1 = x2;
			    x2 = x;
			}

			if( y1 > y2 ) {
			    y = y1;
			    y1 = y2;
			    y2 = y;
			}

			gad->g_Left   = x1;
			gad->g_Width  = x2 - x1 + 1;
			gad->g_Top    = y1;
			gad->g_Height = y2 - y1 + 1;

			CheckSize( gad );
		    }
		}
	    }

	    RifaiGadgets();
	    RinfrescaFinestra();
	    IE.flags &= ~(SALVATO | MOVE);
	    Stat( CatCompArray[ MSG_DONE ].cca_Str, FALSE, 0 );
	}
    }

    return( ret );
}

UWORD CheckResizeGad( void )
{
    struct GadgetInfo  *gad;
    WORD                xb, yb, x, y;
    UWORD               code = 0;
    BOOL                go = TRUE;

    x = clickx;
    y = clicky;

    gad = IE.win_info->wi_Gadgets.mlh_Head;
    while(( gad->g_Node.ln_Succ ) && ( go )) {

	xb = gad->g_Left;
	yb = gad->g_Top;

	IE.gad_id = gad;

	if( x >= xb ) {
	    if( x <= xb + Q_W ) {           // fascia sinistra
		if( y >= yb ) {             // fascia superiore
		    if( y <= yb + Q_H ) {   // angolo alto sinistra
			offx = xb + gad->g_Width - 1;
			offy = yb + gad->g_Height - 1;
			code = 1;
			go = FALSE;
		    } else {
			yb += (gad->g_Height - 1);
			if(( y <= yb ) && ( y >= yb - Q_H )) { // basso a sinistra
			    offx = xb + gad->g_Width - 1;
			    offy = gad->g_Top;
			    code = 2;
			    go = FALSE;
			}
		    }
		}
	    } else {
		xb += (gad->g_Width - 1);
		if(( x <= xb ) && ( x >= xb - Q_W )) {  // fascia destra
		    if( y >= yb ) {
			if( y <= yb + Q_H ) {           // alto a destra
			    offx = gad->g_Left;
			    offy = yb + gad->g_Height - 1;
			    code = 3;
			    go = FALSE;
			} else {
			    yb += (gad->g_Height - 1);
			    if(( y <= yb ) && ( y >= yb - Q_H )) { // basso a destra
				offx = gad->g_Left;
				offy = gad->g_Top;
				code = 4;
				go = FALSE;
			    }
			}
		    }
		}
	    }
	}

	gad = gad->g_Node.ln_Succ;
    }

    return( code );
}

BOOL TraceGadRect( UWORD code2, WORD *x, WORD *y )
{
    BOOL                    ok = TRUE, ret = FALSE;
    struct IntuiMessage    *msg;
    ULONG                   class;
    int                     code;
    struct Window          *wnd;

    *y = 0;
    *x = 0;

    IE.win_active->Flags |= WFLG_RMBTRAP;
    SetDrMd( IE.win_active->RPort, COMPLEMENT );

    do {

	WaitPort( IE.win_active->UserPort );

	while( msg = GT_GetIMsg( IE.win_active->UserPort )) {

	    class = msg->Class;
	    code  = msg->Code;
	    wnd   = msg->IDCMPWindow;

	    GT_ReplyIMsg( msg );

	    switch( class ) {

		case IDCMP_REFRESHWINDOW:
		    GT_BeginRefresh( wnd );
		    GT_EndRefresh( wnd, TRUE );
		    break;

		case IDCMP_MOUSEBUTTONS:
		    switch( code ) {
			case 0x69:
			    ok = FALSE;
			    Stat( CatCompArray[ MSG_ABORTED ].cca_Str, FALSE, 0 );
			    break;

			case 0xE8:
			    ok = FALSE;
			    ret = TRUE;
		    }
		    break;

		case IDCMP_MOUSEMOVE:
		    RedrawResize( code2, *x, *y );
		    Coord();
		    *x = mousex - clickx;
		    *y = mousey - clicky;
		    RedrawResize( code2, *x, *y );
		    break;
	    }
	}

    } while( ok );

    RedrawResize( code2, *x, *y );

    offx = offy = 0;
    Coord();

    SetDrMd( IE.win_active->RPort, JAM1 );
    IE.win_active->Flags &= ~WFLG_RMBTRAP;

    return( ret );
}

void RedrawResize( UWORD code, WORD x, WORD y )
{
    struct GadgetInfo  *gad;
    WORD                x1, x2, y1, y2;

    for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
	if( gad->g_flags2 & G_ATTIVO ) {

	    if( Resizable( gad )) {

		x1 = gad->g_Left;
		y1 = gad->g_Top;
		x2 = x1 + gad->g_Width - 1;
		y2 = y1 + gad->g_Height - 1;

		if( code >= 3 )
		    x2 += x;
		else
		    x1 += x;

		if(!( code & 1 ))
		    y2 += y;
		else
		    y1 += y;

		Rect( x1, y1, x2, y2 );
	    }
	}
    }
}
///

/// Specifica dimensioni gadgets
BOOL GadSizeMenued( void )
{
    struct GadgetInfo  *gad;

    LockAllWindows();
    LayoutWindow( GadSizeWTags );

    for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
	if( gad->g_flags2 & G_ATTIVO ) {

	    buffer = gad;

	    if (!( OpenGadSizeWindow() )) {

		IntegerTag[1] = gad->g_Left;
		GT_SetGadgetAttrsA( GadSizeGadgets[ GD_GS_X ], GadSizeWnd,
				    NULL, (struct TagItem *)IntegerTag );
		IntegerTag[1] = gad->g_Top;
		GT_SetGadgetAttrsA( GadSizeGadgets[ GD_GS_Y ], GadSizeWnd,
				    NULL, (struct TagItem *)IntegerTag );
		IntegerTag[1] = gad->g_Width;
		GT_SetGadgetAttrsA( GadSizeGadgets[ GD_GS_W ], GadSizeWnd,
				    NULL, (struct TagItem *)IntegerTag );
		IntegerTag[1] = gad->g_Height;
		GT_SetGadgetAttrsA( GadSizeGadgets[ GD_GS_H ], GadSizeWnd,
				    NULL, (struct TagItem *)IntegerTag );

		while( ReqHandle( GadSizeWnd, HandleGadSizeIDCMP ));

	    }

	    CloseGadSizeWindow();
	}
    }

    PostOpenWindow( GadSizeWTags );
    UnlockAllWindows();

    return( TRUE );
}

BOOL GadSizeVanillaKey( void )
{
    switch( GadSizeMsg.Code ) {
	case 13:
	    return( GS_OkClicked() );
	case 27:
	    return( GS_AnnullaClicked() );
    }
    return( TRUE );
}

BOOL GS_OkKeyPressed( void )
{
    return( GS_OkClicked() );
}

BOOL GS_OkClicked( void )
{
    (( struct GadgetInfo *)buffer )->g_Left   = GetNumber( GadSizeGadgets[ GD_GS_X ]);
    (( struct GadgetInfo *)buffer )->g_Top    = GetNumber( GadSizeGadgets[ GD_GS_Y ]);
    (( struct GadgetInfo *)buffer )->g_Width  = GetNumber( GadSizeGadgets[ GD_GS_W ]);
    (( struct GadgetInfo *)buffer )->g_Height = GetNumber( GadSizeGadgets[ GD_GS_H ]);

    CheckSize(( struct GadgetInfo *)buffer );
    RifaiGadgets();
    RinfrescaFinestra();
    IE.flags &= ~SALVATO;

    return( FALSE );
}

BOOL GS_AnnullaKeyPressed( void )
{
    return( FALSE );
}

BOOL GS_AnnullaClicked( void )
{
    return( FALSE );
}

BOOL GS_XClicked( void )
{
    ActivateGadget( GadSizeGadgets[ GD_GS_Y ], GadSizeWnd, NULL );
    return( TRUE );
}

BOOL GS_YClicked( void )
{
    ActivateGadget( GadSizeGadgets[ GD_GS_W ], GadSizeWnd, NULL );
    return( TRUE );
}

BOOL GS_WClicked( void )
{
    ActivateGadget( GadSizeGadgets[ GD_GS_H ], GadSizeWnd, NULL );
    return( TRUE );
}

BOOL GS_HClicked( void )
{
    return( TRUE );
}
///

/// Seleziona tutti
BOOL SelAllMenued( void )
{
    struct GadgetInfo *gad;

    for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {

	BOOL can = TRUE;

	if( gad->g_Kind >= MIN_IEX_ID ) {
	    struct IEXNode *ex;

	    ex = IE.Expanders.mlh_Head;
	    while( ex->ID != gad->g_Kind )
		ex = ex->Node.ln_Succ;

	    if( ex->Base->Movable || ex->Base->Resizable )
		can = TRUE;
	}

	if( can )
	    gad->g_flags2 |= G_ATTIVO;
    }

    RinfrescaFinestra();

    return( TRUE );
}
///

/// Disattiva tutti
void DisattivaTuttiGad( void )
{
    struct GadgetInfo *gad;

    ContornoGadgets( FALSE );

    for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
	gad->g_flags2 &= ~G_ATTIVO;
    }

}
///

/// Clonazioni
BOOL ClonaBothMenued( void )
{
    struct GadgetInfo *from, *to;

    if( TestAttivi() ) {
	if( from = GetGad() ) {
	    for( to = IE.win_info->wi_Gadgets.mlh_Head; to->g_Node.ln_Succ; to = to->g_Node.ln_Succ ) {
		if( to->g_flags2 & G_ATTIVO ) {
		    if( gadgetxy_index[ to->g_Kind ].Resize ) {
			to->g_Width  = from->g_Width;
			to->g_Height = from->g_Height;
		    }
		}
	    }
	}
    }

    RifaiGadgets();
    RinfrescaFinestra();
    IE.flags &= ~SALVATO;

    return( TRUE );
}

BOOL ClonaWMenued( void )
{
    struct GadgetInfo *from, *to;

    if( TestAttivi() ) {
	if( from = GetGad() ) {
	    for( to = IE.win_info->wi_Gadgets.mlh_Head; to->g_Node.ln_Succ; to = to->g_Node.ln_Succ ) {
		if( to->g_flags2 & G_ATTIVO ) {
		    if( gadgetxy_index[ to->g_Kind ].Resize ) {
			to->g_Width  = from->g_Width;
		    }
		}
	    }
	}
    }

    RifaiGadgets();
    RinfrescaFinestra();
    IE.flags &= ~SALVATO;

    return( TRUE );
}

BOOL ClonaHMenued( void )
{
    struct GadgetInfo *from, *to;

    if( TestAttivi() ) {
	if( from = GetGad() ) {
	    for( to = IE.win_info->wi_Gadgets.mlh_Head; to->g_Node.ln_Succ; to = to->g_Node.ln_Succ ) {
		if( to->g_flags2 & G_ATTIVO ) {
		    if( gadgetxy_index[ to->g_Kind ].Resize ) {
			to->g_Height = from->g_Height;
		    }
		}
	    }
	}
    }

    RifaiGadgets();
    RinfrescaFinestra();
    IE.flags &= ~SALVATO;

    return( TRUE );
}
///

/// Allineamenti
BOOL AlignDownMenued( void )
{
    struct GadgetInfo  *to, *from;
    WORD                y;

    if( TestAttivi() ) {
	if( from = GetGad() ) {

	    y = from->g_Top + from->g_Height;

	    for( to = IE.win_info->wi_Gadgets.mlh_Head; to->g_Node.ln_Succ; to = to->g_Node.ln_Succ ) {
		if( to->g_flags2 & G_ATTIVO ) {
		    to->g_Top = y - to->g_Height;
		}
	    }

	    RifaiGadgets();
	    RinfrescaFinestra();
	    IE.flags &= ~SALVATO;

	    Stat( CatCompArray[ MSG_GAD_ALIGNED ].cca_Str, FALSE, 0 );
	}
    }

    return( TRUE );
}

BOOL AlignUpMenued( void )
{
    struct GadgetInfo  *to, *from;

    if( TestAttivi() ) {
	if( from = GetGad() ) {

	    for( to = IE.win_info->wi_Gadgets.mlh_Head; to->g_Node.ln_Succ; to = to->g_Node.ln_Succ ) {
		if( to->g_flags2 & G_ATTIVO ) {
		    to->g_Top = from->g_Top;
		}
	    }

	    RifaiGadgets();
	    RinfrescaFinestra();
	    IE.flags &= ~SALVATO;

	    Stat( CatCompArray[ MSG_GAD_ALIGNED ].cca_Str, FALSE, 0 );
	}
    }

    return( TRUE );
}

BOOL AlignRightMenued( void )
{
    struct GadgetInfo  *to, *from;
    WORD                x;

    if( TestAttivi() ) {
	if( from = GetGad() ) {

	    x = from->g_Left + from->g_Width;

	    for( to = IE.win_info->wi_Gadgets.mlh_Head; to->g_Node.ln_Succ; to = to->g_Node.ln_Succ ) {
		if( to->g_flags2 & G_ATTIVO ) {
		    to->g_Left = x - to->g_Width;
		}
	    }

	    RifaiGadgets();
	    RinfrescaFinestra();
	    IE.flags &= ~SALVATO;

	    Stat( CatCompArray[ MSG_GAD_ALIGNED ].cca_Str, FALSE, 0 );
	}
    }

    return( TRUE );
}

BOOL AlignLeftMenued( void )
{
    struct GadgetInfo  *to, *from;

    if( TestAttivi() ) {
	if( from = GetGad() ) {

	    for( to = IE.win_info->wi_Gadgets.mlh_Head; to->g_Node.ln_Succ; to = to->g_Node.ln_Succ ) {
		if( to->g_flags2 & G_ATTIVO ) {
		    to->g_Left = from->g_Left;
		}
	    }

	    RifaiGadgets();
	    RinfrescaFinestra();
	    IE.flags &= ~SALVATO;

	    Stat( CatCompArray[ MSG_GAD_ALIGNED ].cca_Str, FALSE, 0 );
	}
    }

    return( TRUE );
}
///

/// Muovi gadgets
void PosizioneGadgets( WORD x, WORD y )
{
    BOOL                ret;
    struct GadgetInfo  *gad;

    ret = MuoviGadgets( IE.gad_id, mousex - x, mousey - y, &x, &y, 0xE8 );
    IE.flags &= ~MOVE;

    if( ret ) {

	for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
	    if( gad->g_flags2 & G_ATTIVO ) {
		gad->g_Left += x;
		gad->g_Top  += y;
	    }
	}

	RifaiGadgets();
	RinfrescaFinestra();
	offx = offy = 0;
	Coord();
	IE.flags &= ~SALVATO;
	Stat( CatCompArray[ MSG_DONE ].cca_Str, FALSE, 0 );
    }
}

BOOL MuoviGadgets( struct GadgetInfo *rif, WORD x, WORD y, WORD *ox, WORD *oy, UWORD EndCode )
{
    WORD                    x3, y3, x4, y4;
    BOOL                    ret = FALSE, ok = TRUE;
    struct IntuiMessage    *msg;
    int                     code;
    ULONG                   class;
    struct Window          *wnd;
    struct GadgetInfo      *gad;

    offx = x - rif->g_Left;
    offy = y - rif->g_Top;

    IE.win_active->Flags |= WFLG_RMBTRAP;
    SetDrMd( IE.win_active->RPort, COMPLEMENT );

    StaccaGadgets();

    for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
	if( gad->g_flags2 & G_ATTIVO ) {
	    x4 = gad->g_Left + *ox;
	    y4 = gad->g_Top  + *oy;
	    Rect( x4, y4, x4 + gad->g_Width - 1, y4 + gad->g_Height - 1 );
	}
    }

    do {

	WaitPort( IE.win_active->UserPort );

	while( msg = GT_GetIMsg( IE.win_active->UserPort )) {

	    class = msg->Class;
	    code  = msg->Code;
	    wnd   = msg->IAddress;

	    GT_ReplyIMsg( msg );

	    if( wnd == IE.win_active ) {

		switch( class ) {

		    case IDCMP_MOUSEBUTTONS:
			if( code == EndCode ) {
			    ok = FALSE;
			    ret = TRUE;
			} else {
			    if( code == 0x69 ) {
				ok = FALSE;
				Stat( CatCompArray[ MSG_ABORTED ].cca_Str, FALSE, 0 );
			    }
			}
			break;

		    case IDCMP_MOUSEMOVE:
			Coord();
			x3 = wnd->MouseX - x;
			y3 = wnd->MouseY - y;

			for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
			    if( gad->g_flags2 & G_ATTIVO ) {
				x4 = gad->g_Left + *ox;
				y4 = gad->g_Top  + *oy;
				Rect( x4, y4, x4 + gad->g_Width - 1, y4 + gad->g_Height - 1 );
			    }
			}

			*ox = x3;
			*oy = y3;

			for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
			    if( gad->g_flags2 & G_ATTIVO ) {
				x4 = gad->g_Left + *ox;
				y4 = gad->g_Top  + *oy;
				Rect( x4, y4, x4 + gad->g_Width - 1, y4 + gad->g_Height - 1 );
			    }
			}
			break;
		}
	    }

	}

    } while( ok );

    for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
	if( gad->g_flags2 & G_ATTIVO ) {
	    x4 = gad->g_Left + *ox;
	    y4 = gad->g_Top  + *oy;
	    Rect( x4, y4, x4 + gad->g_Width - 1, y4 + gad->g_Height - 1 );
	}
    }

    AttaccaGadgets();

    SetDrMd( IE.win_active->RPort, JAM1 );
    IE.win_active->Flags &= ~WFLG_RMBTRAP;

    return( ret );
}
///

/// Rinfresca Finestra
void RinfrescaFinestra( void )
{
    struct BevelBoxNode *box;
    struct WndImages    *img;
    struct ITextNode    *txt;
    struct IEXNode      *ex;
    UBYTE                oldmp;

    if( IE.win_active && IE.win_info ) {

	StaccaGadgets();

	ContornoGadgets( FALSE );

	EraseRect( IE.win_active->RPort,
		   IE.win_active->BorderLeft,
		   IE.win_active->BorderTop,
		   IE.win_active->Width  - IE.win_active->BorderRight,
		   IE.win_active->Height - IE.win_active->BorderBottom );

	RefreshWindowFrame( IE.win_active );

	for( ex = IE.Expanders.mlh_Head; ex->Node.ln_Succ && ex->Base->Node.ln_Pri < 0; ex = ex->Node.ln_Succ ) {
	    struct Expander *IEXBase;
	    IEXBase = ex->Base;
	    IEX_Refresh( ex->ID, &IE );
	}

	for( box = IE.win_info->wi_Boxes.mlh_Head; box->bb_Next; box = box->bb_Next ) {

	    box->bb_VisualInfo = VisualInfo;

	    DrawBevelBoxA( IE.win_active->RPort,
			   box->bb_Left,
			   box->bb_Top,
			   box->bb_Width,
			   box->bb_Height,
			   (struct TagItem *)&box->bb_VITag );
	}

	if( IE.win_info->wi_NumImages ) {
	    img = IE.win_info->wi_Images.mlh_Head;
	    DrawImage( IE.win_active->RPort, (struct Image *)&img->wim_Left, 0, 0 );
	}

	if( IE.win_info->wi_NumTexts ) {
	    txt = IE.win_info->wi_ITexts.mlh_Head;
	    PrintIText( IE.win_active->RPort, (struct IntuiText *)&txt->itn_FrontPen, 0, 0 );
	}

	ex = IE.Expanders.mlh_Head;
	while( ex->Node.ln_Succ )
	    if( ex->Base->Node.ln_Pri >= 0 )
		break;
	    else
		ex = ex->Node.ln_Succ;

	for( ; ex->Node.ln_Succ; ex = ex->Node.ln_Succ ) {
	    struct Expander *IEXBase;
	    IEXBase = ex->Base;
	    IEX_Refresh( ex->ID, &IE );
	}

	oldmp = IE.mainprefs;

	IE.mainprefs &= ~STACCATI;
	AttaccaGadgets();

	ContornoGadgets( TRUE );

	if( oldmp & STACCATI )
	    StaccaGadgets();

	IE.mainprefs = oldmp;
    }
}
///

/// Attiva Gadgets
void AttivaGadgets( void )
{
    struct IntuiMessage *msg;
    struct RastPort     *rport;
    struct Window       *wnd;
    BOOL                 ok = TRUE, go = FALSE;
    ULONG                class;
    int                  code;

    clickx = lastx = IE.win_active->MouseX;
    clicky = lasty = IE.win_active->MouseY;

    if(!( AttivaUno( clickx, clicky ) )) {

	rport = IE.win_active->RPort;

	SetDrMd( rport, COMPLEMENT );

	rport->LinePtrn = 0xFF00;

	IE.win_active->Flags |= WFLG_RMBTRAP;

	Stat( CatCompArray[ MSG_SELECT ].cca_Str, FALSE, 0 );

	do {

	    WaitPort( IE.win_active->UserPort );

	    while( msg = GT_GetIMsg( IE.win_active->UserPort )) {

		class = msg->Class;
		code  = msg->Code;
		wnd   = msg->IDCMPWindow;

		GT_ReplyIMsg( msg );

		if( IE.win_active == wnd ) {
		    switch( class ) {

			case IDCMP_INTUITICKS:
			    Rect( clickx, clicky, lastx, lasty );
			    code = rport->LinePtrn >> 3;
			    rport->LinePtrn = code | (( rport->LinePtrn % 8 ) << 13 );
			    Rect( clickx, clicky, lastx, lasty );
			    break;

			case IDCMP_REFRESHWINDOW:
			    GT_BeginRefresh( wnd );
			    GT_EndRefresh( wnd, TRUE );
			    break;

			case IDCMP_MOUSEBUTTONS:
			    switch( code ) {
				case 0xE8:
				    go = TRUE;
				    ok = FALSE;
				    break;
				case 0x69:
				    ok = FALSE;
				    Stat( CatCompArray[ MSG_ABORTED ].cca_Str, FALSE, 0 );
				    break;
			    }
			    break;

			case IDCMP_MOUSEMOVE:
			    Coord();
			    Rect( clickx, clicky, lastx, lasty );
			    lastx = ( wnd->MouseX >= 0 ) ? wnd->MouseX : 0;
			    lasty = ( wnd->MouseY >= 0 ) ? wnd->MouseY : 0;
			    Rect( clickx, clicky, lastx, lasty );
			    break;
		    }
		}
	    }

	} while( ok );

	Rect( clickx, clicky, lastx, lasty );

	if( go ) {

	    if( clickx > lastx ) {
		code = clickx;
		clickx = lastx;
		lastx = code;
	    }

	    if( clicky > lasty ) {
		code = clicky;
		clicky = lasty;
		lasty = code;
	    }

	    Attiva( clickx, clicky, lastx, lasty );

	    Stat( ok_txt+1, FALSE, 0 );
	}

	IE.win_active->Flags &= ~WFLG_RMBTRAP;
	SetDrMd( rport, JAM1 );
	rport->LinePtrn = 0xFFFF;

    } else {
	IE.flags |= MOVE;
    }

    ContornoGadgets( TRUE );
}

BOOL Attiva( WORD x, WORD y, WORD x2, WORD y2 )
{
    BOOL                ret = FALSE, can;
    struct GadgetInfo  *gad;

    for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {

	can = FALSE;

	if( gad->g_Kind < MIN_IEX_ID )
	    can = TRUE;
	else {
	    struct IEXNode *ex;

	    ex = IE.Expanders.mlh_Head;
	    while( ex->ID != gad->g_Kind )
		ex = ex->Node.ln_Succ;

	    if( ex->Base->Movable || ex->Base->Resizable )
		can = TRUE;
	}

	if(( can ) && (( x2 >= gad->g_Left ) && ( x < gad->g_Left + gad->g_Width ) && ( y2 >= gad->g_Top ) && ( y < gad->g_Top + gad->g_Height ))) {
	    gad->g_flags2 |= G_ATTIVO;
	    IE.gad_id = gad;
	    ret = TRUE;
	}

    }

    return( ret );
}

BOOL AttivaUno( WORD x, WORD y )
{
    BOOL                ret = FALSE, can;
    struct GadgetInfo  *gad;

    for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {

	can = FALSE;

	if( gad->g_Kind < MIN_IEX_ID )
	    can = TRUE;
	else {
	    struct IEXNode *ex;

	    ex = IE.Expanders.mlh_Head;
	    while( ex->ID != gad->g_Kind )
		ex = ex->Node.ln_Succ;

	    if( ex->Base->Movable || ex->Base->Resizable )
		can = TRUE;
	}

	if(( can ) && (( x >= gad->g_Left ) && ( x < gad->g_Left + gad->g_Width ) && ( y >= gad->g_Top ) && ( y < gad->g_Top + gad->g_Height ))) {
	    gad->g_flags2 |= G_WAS_ACTIVE;
	    ret = TRUE;
	}
    }

    if( ret ) {
	ULONG               area = 0xffffffff, area2;

	for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
	    if( gad->g_flags2 & G_WAS_ACTIVE ) {
		gad->g_flags2 &= ~G_WAS_ACTIVE;

		area2 = gad->g_Width * gad->g_Height;

		if( area2 < area ) {
		    IE.gad_id = gad;
		    area = area2;
		}
	    }
	}

	IE.gad_id->g_flags2 |= G_ATTIVO;
    }

    return( ret );
}
///

/// Contorno gadgets
void ContornoGadgets( BOOL what )
{
    struct GadgetInfo *gad;

    SetDrMd( IE.win_active->RPort, COMPLEMENT );

    for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
	if( what ) {
	    if( gad->g_flags2 & G_ATTIVO ) {
		if(!( gad->g_flags2 & G_CONTORNO )) {
		    gad->g_flags2 |= G_CONTORNO;
		    DisegnaContorno( gad->g_Left, gad->g_Top, gad->g_Width, gad->g_Height );
		}
	    }
	} else {
	    if( gad->g_flags2 & G_CONTORNO ) {
		gad->g_flags2 &= ~G_CONTORNO;
		DisegnaContorno( gad->g_Left, gad->g_Top, gad->g_Width, gad->g_Height );
	    }
	}
    }

    SetDrMd( IE.win_active->RPort, JAM1 );
}
///

/// MenuGadget Disattiva/Attiva
void MenuGadgetDisattiva( void )
{
    int cnt;

    for( cnt = 0; cnt < GADMENU_NUM; cnt++ )
	OffMenu( BackWnd, menugad_on[ cnt ]);

    if( ToolsWnd )
	OffGadget( &RemGadgetGadget, ToolsWnd, NULL );
}

void MenuGadgetAttiva( void )
{
    int cnt;

    for( cnt = 0; cnt < GADMENU_NUM; cnt++ )
	OnMenu( BackWnd, menugad_on[ cnt ]);

    if( ToolsWnd )
	OnGadget( &RemGadgetGadget, ToolsWnd, NULL );
}
///

/// Gadget Tags
BOOL GadTagsMenued( void )
{
    struct GadgetInfo  *gad;
    BOOL                change = FALSE;

    LockAllWindows();

    for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
	if( gad->g_flags2 & G_ATTIVO ) {
	    if( gad->g_Kind < MIN_IEX_ID ) {
		void    ( *func )( struct GadgetInfo * );
		BOOL    key;

		func = modifica_index[ gad->g_Kind ];

		do {
		    ( *func )( gad );

		    key = FALSE;

		    if( buffer ) {

			gad->g_Key = '\0';

			if( gad->g_Tags & 1 ) {
			    UBYTE  *ptr, ch;

			    ptr = gad->g_Titolo;

			    do {
				ch = *ptr++;
			    } while(( ch != '_' ) && ( ch != '\0' ));

			    if( ch ) {
				gad->g_Key = *ptr;
				IE.win_info->wi_NumKeys += 1;
			    }
			}

			if( key = CheckActivationKey( IE.win_info, gad ))
			    Stat( CatCompArray[ ERR_DUPLICATE_KEY ].cca_Str, TRUE, 0 );
		    }

		} while( key );

		change = TRUE;

	    } else if( gad->g_Node.ln_Type == IEX_BOOPSI_KIND )
		change = BoopsiEditor(( struct BOOPSIInfo * )gad );
	}
    }

    struct IEXNode  *ex;
    for( ex = IE.Expanders.mlh_Head; ex->Node.ln_Succ; ex = ex->Node.ln_Succ ) {
	struct Expander    *IEXBase;
	IEXBase = ex->Base;
	if( IEXBase->Kind != IEX_BOOPSI_KIND ) {
	    if( IEX_Edit( ex->ID, &IE ))
		change = TRUE;
	}
    }

    if( change ) {

	RifaiGadgets();
	RinfrescaFinestra();
	Stat( CatCompArray[ MSG_DONE ].cca_Str, FALSE, 0 );
	IE.flags &= ~SALVATO;
    }

    UnlockAllWindows();

    return( TRUE );
}
///

/// Aggiungi Gadget
BOOL AddGadClicked( void )
{
    return( AddGadMenued() );
}

BOOL AddGadMenued( void )
{
    int                 num;
    struct GadgetInfo  *gad;
    WORD                x1, x2, y1, y2, swap;
    UBYTE              *ptr, ch;
    void                ( *func )( struct GadgetInfo * );


    if( ApriListaFin( CatCompArray[ REQ_GADTYPE ].cca_Str, REQ_GADTYPE, &listgadgets )) {

	num = GestisciListaFin( EXIT, 12 );

	ChiudiListaFin();

	if( num >= 0 ) {

	    RinfrescaFinestra();

	    if( num == ( BOOLEAN - 2 )) {
		AggiungiBooleano();
	    } else {
		if( num >= ( MIN_IEX_ID - 2 )) {
		    AddObject( num );
		} else {
		    if( gad = AllocObject( IE_GADGET )) {

			AddTail((struct List *)&IE.win_info->wi_Gadgets, (struct Node *)gad );

			gad->g_Kind = num + 1;
			if( gad->g_Kind > SCROLLER_KIND )
			    gad->g_Kind += 1;

			if(( gad->g_Kind == STRING_KIND ) || ( gad->g_Kind == TEXT_KIND )) {
			    if(!( gad->g_ExtraMem = AllocVec( 120, MEMF_CLEAR ))) {
				Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, 0 );
				Remove((struct Node *)gad );
				FreeObject( gad, IE_GADGET );
				return( TRUE );
			    }
			}

			Stat( CatCompArray[ MSG_DRAW_GAD ].cca_Str, FALSE, 0 );

			ActivateWindow( IE.win_active );

			IE.flags &= ~RECTFIXED;

			if(!( gadgetxy_index[ gad->g_Kind ].Resize ))
			    IE.flags |= RECTFIXED;


			DrawRect( gadgetxy_index[ gad->g_Kind ].Width, gadgetxy_index[ gad->g_Kind ].Height );

			offx = offy = 0;
			Coord();

			x1 = clickx;
			x2 = lastx;
			y1 = clicky;
			y2 = lasty;

			if( x2 < x1 ) {
			    swap = x1;
			    x1 = x2;
			    x2 = swap;
			}

			if( y2 < y1 ) {
			    swap = y1;
			    y1 = y2;
			    y2 = swap;
			}

			gad->g_Left = x1;
			gad->g_Top  = y1;

			if(!( gadgetxy_index[ gad->g_Kind ].Resize )) {
			    gad->g_Width  = gadgetxy_index[ gad->g_Kind ].Width;
			    gad->g_Height = gadgetxy_index[ gad->g_Kind ].Height;
			} else {
			    gad->g_Width  = x2 - x1 + 1;
			    gad->g_Height = y2 - y1 + 1;
			}

			CheckSize( gad );

			DisattivaTuttiGad();

			gad->g_flags2 |= G_ATTIVO;

			if( func = pre_gadget_index[ gad->g_Kind - 1 ])
			    (*func)( gad );

			buffer = 0L;

			func = modifica_index[ gad->g_Kind ];
			(*func)( gad );

			if( buffer ) {

			    if( gad->g_Tags & 1 ) {
				ptr = gad->g_Titolo;
				do{
				    ch = *ptr++;
				} while(( ch != '_' ) && ( ch != '\0' ));
				if( ch ) {
				    gad->g_Key = *ptr;
				    IE.win_info->wi_NumKeys += 1;
				}
			    }

			    if(!( gad->g_Label[0] )) {
				sprintf( gad->g_Label, "%sGad%03ld",
					 IE.win_info->wi_Label,
					 IE.win_info->wi_NewGadID );
				IE.win_info->wi_NewGadID += 1;
			    }


			    if(!( IE.win_info->wi_NumGads ))
				MenuGadgetAttiva();

			    IE.win_info->wi_NumGads += 1;

			    IE.win_info->wi_GadTypes[ gad->g_Kind - 1 ] += 1;

			    RifaiGadgets();
			    RinfrescaFinestra();
			    IE.flags &= ~SALVATO;

			    Stat( CatCompArray[ MSG_GAD_ADDED ].cca_Str, FALSE, 0 );

			} else {

			    Remove(( struct Node * )gad );
			    FreeObject( gad, IE_GADGET );

			    Stat( CatCompArray[ MSG_ABORTED ].cca_Str, FALSE, 0 );
			}

		    } else {
			Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, 0 );
		    }
		}
	    }
	}
    }

    return( TRUE );
}
///

/// Elimina Gadget
BOOL RemGadgetClicked( void )
{
    return( DelGadMenued() );
}

BOOL DelGadMenued( void )
{
    struct GadgetInfo      *gad;
    struct IEXNode         *ex;

    if( TestAttivi() ) {

	if( IERequest( CatCompArray[ MSG_DELETE_GAD ].cca_Str,
		       CatCompArray[ ANS_YES_NO ].cca_Str,
		       MSG_DELETE_GAD, ANS_YES_NO )) {

	    for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
		if(( gad->g_flags2 & G_ATTIVO ) && ( gad->g_Kind < MIN_IEX_ID )) {

		    Remove(( struct Node *)gad );

		    IE.win_info->wi_NumGads -= 1;

		    if( gad->g_Kind == BOOLEAN ) {

			FreeObject( gad, IE_BOOLEAN );
			IE.win_info->wi_NumBools -= 1;

		    } else {

			IE.win_info->wi_GadTypes[ gad->g_Kind - 1 ] -= 1;
			FreeObject( gad, IE_GADGET );
		    }

		    gad = (struct GadgetInfo *)&IE.win_info->wi_Gadgets;
		}
	    }

	    for( ex = IE.Expanders.mlh_Head; ex->Node.ln_Succ; ex = ex->Node.ln_Succ ) {
		struct Expander    *IEXBase;
		IEXBase = ex->Base;
		IEX_Remove( ex->ID, &IE );
	    }

	    RifaiGadgets();
	    RinfrescaFinestra();

	    if(!( IE.win_info->wi_NumGads ))
		MenuGadgetDisattiva();

	    IE.flags &= ~SALVATO;
	    Stat( CatCompArray[ MSG_GAD_DELETED ].cca_Str, FALSE, 0 );
	} else
	    Stat( CatCompArray[ MSG_ABORTED ].cca_Str, FALSE, 0 );
    }

    return( TRUE );
}
///

/// Attacca/Stacca gadgets
void AttaccaGadgets( void )
{
    struct BooleanInfo *gad;
    struct Gadget      *glist;

    if(!( IE.mainprefs & STACCATI )) {
	if( IE.win_active ) {

	    if( IE.win_info->wi_NumBools ) {

		gad = IE.win_info->wi_Gadgets.mlh_Head;

		while( gad->b_Kind != BOOLEAN )
		    gad = gad->b_Node.ln_Succ;

		glist = &gad->b_NextGadget;

	    } else
		glist = IE.win_info->wi_GList;

	    if( glist ) {
		AddGList( IE.win_active, glist, -1, -1, NULL );
		RefreshGadgets( glist, IE.win_active, NULL );
		GT_RefreshWindow( IE.win_active, NULL );
	    }
	}
    }
}

void StaccaGadgets( void )
{
    if(!( IE.mainprefs & STACCATI )) {
	if( IE.win_active ) {
	    struct Gadget  *g;

	    if( g = IE.win_active->FirstGadget ) {

		while( g->GadgetType & GTYP_SYSGADGET )
		    if(!( g = g->NextGadget ))
			return;

		RemoveGList( IE.win_active, g, -1 );
	    }
	}
    }
}
///

/// Gadget Defaults
void IntegerDefault( struct GadgetInfo *gad )
{
    gad->g_Tags |= 8;
    ((struct IK)(gad->g_Data)).MaxC = 10;
}

void ListviewDefault( struct GadgetInfo *gad )
{
    ((struct LK)(gad->g_Data)).ScW = 16;
}

void MxDefault( struct GadgetInfo *gad )
{
    ((struct MK)(gad->g_Data)).Spc = 1;
    ListEditor( &gad->g_Scelte, TRUE, &gad->g_NumScelte, CatCompArray[ REQ_GAD_ITEMS ].cca_Str, REQ_GAD_ITEMS );
}

void CycleDefault( struct GadgetInfo *gad )
{
    ListEditor( &gad->g_Scelte, TRUE, &gad->g_NumScelte, CatCompArray[ REQ_GAD_ITEMS ].cca_Str, REQ_GAD_ITEMS );
}

void NumberDefault( struct GadgetInfo *gad )
{
    ((struct NK)(gad->g_Data)).MNL = 10;
    ((struct NK)(gad->g_Data)).FPen = -1;
    ((struct NK)(gad->g_Data)).BPen = -1;
    strcpy( ((struct NK)(gad->g_Data)).Format, "%ld" );
}

void PaletteDefault( struct GadgetInfo *gad )
{
    ((struct PK)(gad->g_Data)).Depth = ((struct PK)(gad->g_Data)).Color = 1;
}

void ScrollerDefault( struct GadgetInfo *gad )
{
    ((struct SK)(gad->g_Data)).Vis = 2;
}

void SliderDefault( struct GadgetInfo *gad )
{
    ((struct SlK)(gad->g_Data)).Max = 15;
    ((struct SlK)(gad->g_Data)).MLL = 2;
    strcpy( ((struct SlK)(gad->g_Data)).Format, "%ld" );
}

void StringDefault( struct GadgetInfo *gad )
{
    gad->g_Tags |= 8;
}

void TextDefault( struct GadgetInfo *gad )
{
    ((struct TK)(gad->g_Data)).FPen = -1;
    ((struct TK)(gad->g_Data)).BPen = -1;
}
///

/// Routines che settano le tags dei gadgets
void SetUnder( ULONG *array, ULONG tags )
{
    array[1] = ( tags & 1 ) ? '_' : 0xFF;
}

void SetButtonTag( ULONG *array, ULONG tags, struct GadgetInfo *gad )
{
    array[3] = ( tags & 2 ) ? TRUE : FALSE;
}

void SetCheckboxTag( ULONG *array, ULONG tags, struct GadgetInfo *gad )
{
    array[3] = ( tags & 2 ) ? TRUE : FALSE;
    array[5] = ( tags & 4 ) ? TRUE : FALSE;
    array[7] = ( tags & 8 ) ? TRUE : FALSE;
}

void SetIntegerTag( ULONG *array, ULONG tags, struct GadgetInfo *gad )
{
    array[ 3] = ((struct IK)(gad->g_Data)).Num;
    array[ 5] = stringjusts[( ((struct IK)(gad->g_Data)).Just )];
    array[ 7] = ( tags & 2 ) ? TRUE : FALSE;
    array[ 9] = ( tags & 8 ) ? TRUE : FALSE;
    array[11] = ( tags & 0x20 ) ? TRUE : FALSE;
}

void SetListviewTag( ULONG *array, ULONG tags, struct GadgetInfo *gad )
{
    array[ 3] = ((struct LK)(gad->g_Data)).ScW;
    array[ 5] = ((struct LK)(gad->g_Data)).Spc;
    array[ 7] = ( tags & 2 ) ? TRUE : FALSE;
    array[11] = ( tags & 4 ) ? TRUE : FALSE;
    array[ 9] = NULL;
    if( gad->g_NumScelte )
	array[9] = &gad->g_Scelte;
}

void SetMxTag( ULONG *array, ULONG tags, struct GadgetInfo *gad )
{
    array[ 5] = ((struct MK)(gad->g_Data)).Act;
    array[ 7] = ((struct MK)(gad->g_Data)).Spc;
    array[ 9] = gadget_flags[( ((struct MK)(gad->g_Data)).TitPlc )];
    array[11] = ( tags & 2 ) ? TRUE : FALSE;
    array[13] = ( tags & 4 ) ? TRUE : FALSE;
}

void SetNumberTag( ULONG *array, ULONG tags, struct GadgetInfo *gad )
{
    array[ 3] = ((struct NK)(gad->g_Data)).Num;
    array[ 5] = ((struct NK)(gad->g_Data)).Just;
    array[ 7] = ((struct NK)(gad->g_Data)).MNL;
    array[ 9] = ( tags & 2 ) ? TRUE : FALSE;
    array[11] = ( tags & 4 ) ? TRUE : FALSE;
    array[13] = ((struct NK)(gad->g_Data)).Format;

    if( ((struct NK)(gad->g_Data)).FPen != -1 ) {
	array[14] = GTNM_FrontPen;
	array[15] = ((struct NK)(gad->g_Data)).FPen;
    } else {
	array[14] = TAG_IGNORE;
    }

    if( ((struct NK)(gad->g_Data)).BPen != -1 ) {
	array[16] = GTNM_BackPen;
	array[17] = ((struct NK)(gad->g_Data)).BPen;
    } else {
	array[16] = TAG_IGNORE;
    }
}

void SetCycleTag( ULONG *array, ULONG tags, struct GadgetInfo *gad )
{
    array[ 5] = ((struct CK)(gad->g_Data)).Act;
    array[ 7] = ( tags & 2 ) ? TRUE : FALSE;
}

void SetPaletteTag( ULONG *array, ULONG tags, struct GadgetInfo *gad )
{
    array[ 3] = ((struct PK)(gad->g_Data)).Depth;
    array[ 5] = ((struct PK)(gad->g_Data)).Color;
    array[ 7] = ((struct PK)(gad->g_Data)).ColOff;
    array[ 9] = ((struct PK)(gad->g_Data)).IW;
    array[11] = ((struct PK)(gad->g_Data)).IH;
    if( ((struct PK)(gad->g_Data)).NumCol ) {
	array[12] = GTPA_NumColors;
	array[13] = ((struct PK)(gad->g_Data)).NumCol;
    } else {
	array[12] = TAG_IGNORE;
    }
    array[15] = ( tags & 2 ) ? TRUE : FALSE;
}

void SetScrollerTag( ULONG *array, ULONG tags, struct GadgetInfo *gad )
{
    array[ 3] = ((struct SK)(gad->g_Data)).Top;
    array[ 5] = ((struct SK)(gad->g_Data)).Tot;
    array[ 7] = ((struct SK)(gad->g_Data)).Vis;
    array[ 9] = ((struct SK)(gad->g_Data)).Arr;
    array[11] = ( ((struct SK)(gad->g_Data)).Free ) + 1;
    array[13] = ( tags & 2 ) ? TRUE : FALSE;
}

void SetSliderTag( ULONG *array, ULONG tags, struct GadgetInfo *gad )
{
    array[ 3] = ((struct SlK)(gad->g_Data)).Min;
    array[ 5] = ((struct SlK)(gad->g_Data)).Max;
    array[ 7] = ((struct SlK)(gad->g_Data)).Level;
    array[ 9] = ((struct SlK)(gad->g_Data)).MLL;
    array[11] = ((struct SlK)(gad->g_Data)).Format;
    array[13] = gadget_flags[( ((struct SlK)(gad->g_Data)).LevPlc )];
    if( ((struct SlK)(gad->g_Data)).MPL ) {
	array[14] = GTSL_MaxPixelLen;
	array[15] = ((struct SlK)(gad->g_Data)).MPL;
    } else {
	array[14] = TAG_IGNORE;
    }
    array[17] = ((struct SlK)(gad->g_Data)).Just;
    array[19] = ((struct SlK)(gad->g_Data)).Free + 1;
    array[21] = ( tags & 2 ) ? TRUE : FALSE;
}

void SetStringTag( ULONG *array, ULONG tags, struct GadgetInfo *gad )
{
    array[ 3] = ((struct StK)(gad->g_Data)).MaxC;
    array[ 5] = stringjusts[( ((struct StK)(gad->g_Data)).Just )];
    array[ 7] = gad->g_ExtraMem;
    array[ 9] = ( tags & 2 ) ? TRUE : FALSE;
    array[11] = ( tags & 8 ) ? TRUE : FALSE;
    array[13] = ( tags & 0x10 ) ? TRUE : FALSE;
    array[15] = ( tags & 0x20 ) ? TRUE : FALSE;
}

void SetTextTag( ULONG *array, ULONG tags, struct GadgetInfo *gad )
{
    array[ 3] = ((struct TK)(gad->g_Data)).Just;
    array[ 5] = gad->g_ExtraMem;
    array[ 7] = ( tags & 4 ) ? TRUE : FALSE;
    array[ 9] = ( tags & 8 ) ? TRUE : FALSE;

    if( ((struct TK)(gad->g_Data)).FPen != -1 ) {
	array[10] = GTTX_FrontPen;
	array[11] = ((struct TK)(gad->g_Data)).FPen;
    } else {
	array[10] = TAG_IGNORE;
    }

    if( ((struct TK)(gad->g_Data)).BPen != -1 ) {
	array[12] = GTTX_BackPen;
	array[13] = ((struct TK)(gad->g_Data)).BPen;
    } else {
	array[12] = TAG_IGNORE;
    }
}
///

/// Scelte Gadgets
BOOL ScelteMenued( void )
{
    struct GadgetInfo  *gad;
    BOOL                min;

    for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
	if( gad->g_flags2 & G_ATTIVO ) {
	    BOOL    ok = FALSE;

	    if(( gad->g_Kind == LISTVIEW_KIND ) || ( gad->g_Kind == MX_KIND ) || ( gad->g_Kind == CYCLE_KIND ))
		ok = TRUE;
	    else {
		if( gad->g_Kind >= MIN_IEX_ID ) {
		    struct IEXNode *ex;

		    ex = IE.Expanders.mlh_Head;
		    while( ex->ID != gad->g_Kind )
			ex = ex->Node.ln_Succ;

		    if(!( ex->Base->HasItems ))
			return( TRUE );
		}
	    }

	    if( ok ) {
		if(( gad->g_Kind == MX_KIND ) || ( gad->g_Kind == CYCLE_KIND ))
		    min = TRUE;
		else
		    min = FALSE;

		ListEditor( &gad->g_Scelte, min, &gad->g_NumScelte, CatCompArray[ REQ_GAD_ITEMS ].cca_Str, REQ_GAD_ITEMS );

		RifaiGadgets();
	    }
	}
    }

    RinfrescaFinestra();

    return( TRUE );
}
///

/// List Editor
void ListEditor( struct MinList *list, BOOL min, UWORD *num, STRPTR titolo, ULONG titn )
{
    int                     ret;
    STRPTR                  old_tit;
    struct GadgetScelta    *gs, *gs2;

    NewList( &ListEd_List );

    for( gs = list->mlh_Head; gs->gs_Node.ln_Succ; gs = gs->gs_Node.ln_Succ ) {
	if( gs2 = AllocObject( IE_ITEM )) {
	    CopyMem( (char *)gs, (char *)gs2, sizeof( struct GadgetScelta ) );
	    gs2->gs_Node.ln_Name = gs2->gs_Testo;
	    AddTail(( struct List * )&ListEd_List, (struct Node *)gs2 );
	} else {
	    Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, 0 );
	    return;
	}
    }

    buffer3 = list;

    LockAllWindows();

    old_tit = (STRPTR)ListEdWTags[9].ti_Data;
    buffer = min;
    buffer2 = num;

    if( titolo ) {
	if(( LocaleBase ) && ( titn ))
	    titolo = GetCatalogStr( Catalog, titn, titolo );

	ListEdWTags[9].ti_Data = titolo;
    }

    LayoutWindow( ListEdWTags );
    ret = OpenListEdWindow();
    PostOpenWindow( ListEdWTags );

    if( ret ) {
	DisplayBeep( Scr );
    } else {

	ListTag[1] = &ListEd_List;
	GT_SetGadgetAttrsA( ListEdGadgets[ GD_LE_List ], ListEdWnd,
			    NULL, (struct TagItem *)ListTag );

	List2Tag[1] = List2Tag[3] = 0;

	buffer4 = ListEd_List.mlh_Head;

	if( *num )
	    AttivaListEdGadgets();

	while( ReqHandle( ListEdWnd, HandleListEdIDCMP ));

    }

    ListEdWTags[9].ti_Data = old_tit;

    CloseListEdWindow();
    UnlockAllWindows();

}

BOOL LE_AnnullaKeyPressed( void )
{
    return( LE_AnnullaClicked() );
}

BOOL LE_AnnullaClicked( void )
{
    struct GadgetScelta *gs;

    *((UWORD *)buffer2) = 0;

    for( gs = ((struct MinList *)buffer3)->mlh_Head; gs->gs_Node.ln_Succ; gs = gs->gs_Node.ln_Succ )
	*((UWORD *)buffer2) += 1;

    Stat( CatCompArray[ MSG_ABORTED ].cca_Str, FALSE, 0 );

    return( FALSE );
}

BOOL LE_OkKeyPressed( void )
{
    return( LE_OkClicked() );
}

BOOL LE_OkClicked( void )
{
    struct GadgetScelta *gs;

    if( buffer ) {
	if( *((UWORD *)buffer2) < 2 ) {
	    IERequest( CatCompArray[ MSG_TWO_ITEMS ].cca_Str, ok_txt, 0, 0 );
	    return( TRUE );
	}
    }

    while( gs = RemTail((struct List *)buffer3 ))
	FreeObject( gs, IE_ITEM );

    while( gs = RemHead(( struct List * )&ListEd_List ))
	AddTail((struct List *)buffer3, (struct Node *)gs );

    return( FALSE );
}

void ListEdStaccaLista( void )
{
    ListTag[1] = NULL;
    GT_SetGadgetAttrsA( ListEdGadgets[ GD_Lista ], ListEdWnd, NULL, (struct TagItem *)ListTag );
}

void ListEdAttaccaLista( void )
{
    ListTag[1] = &ListEd_List;
    GT_SetGadgetAttrsA( ListEdGadgets[ GD_Lista ], ListEdWnd, NULL, (struct TagItem *)ListTag );
    GT_SetGadgetAttrsA( ListEdGadgets[ GD_Lista ], ListEdWnd, NULL, (struct TagItem *)List2Tag );
}

BOOL LE_NewKeyPressed( void )
{
    return( LE_NewClicked() );
}

BOOL LE_NewClicked( void )
{
    struct GadgetScelta    *gs, *g2;
    int                     cnt;

    if( gs = AllocObject( IE_ITEM )) {

	strcpy( gs->gs_Testo, "(new)" );

	g2 = &ListEd_List;
	for( cnt = 0; cnt <= List2Tag[1]; cnt++ )
	    g2 = g2->gs_Node.ln_Succ;

	buffer4 = gs;

	List2Tag[1] += 1;
	List2Tag[3] = List2Tag[1];

	ListEdStaccaLista();
	Insert((struct List *)&ListEd_List, (struct Node *)gs, (struct Node *)g2 );
	ListEdAttaccaLista();

	*((UWORD *)buffer2) += 1;

	AttivaListEdGadgets();

	ActivateGadget( ListEdGadgets[ GD_LE_In ], ListEdWnd, NULL );

	IE.flags &= ~SALVATO;

    } else {
	Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, 0 );
    }

    return( TRUE );
}

void AttivaListEdGadgets( void )
{
    int pos;

    pos = RemoveGList( ListEdWnd, &LE_UpGadget, 4 );

    LE_UpGadget.Flags     &= ~GFLG_DISABLED;
    LE_TopGadget.Flags    &= ~GFLG_DISABLED;
    LE_DownGadget.Flags   &= ~GFLG_DISABLED;
    LE_BottomGadget.Flags &= ~GFLG_DISABLED;

    AddGList( ListEdWnd, &LE_UpGadget, pos, 4, NULL );
    RefreshGList( &LE_UpGadget, ListEdWnd, NULL, 4 );

    DisableTag[1] = FALSE;
    GT_SetGadgetAttrsA( ListEdGadgets[ GD_LE_In ], ListEdWnd,
			NULL, (struct TagItem *)DisableTag );
    GT_SetGadgetAttrsA( ListEdGadgets[ GD_LE_Del ], ListEdWnd,
			NULL, (struct TagItem *)DisableTag );

    SettaListEdIn();
}

void SettaListEdIn( void )
{
    StringTag[1] = ((struct Node *)buffer4)->ln_Name;
    GT_SetGadgetAttrsA( ListEdGadgets[ GD_LE_In ], ListEdWnd, NULL, (struct TagItem *)StringTag );
}

void DisattivaListEdGadgets( void )
{
    int pos;

    pos = RemoveGList( ListEdWnd, &LE_UpGadget, 4 );

    LE_UpGadget.Flags     |= GFLG_DISABLED;
    LE_TopGadget.Flags    |= GFLG_DISABLED;
    LE_DownGadget.Flags   |= GFLG_DISABLED;
    LE_BottomGadget.Flags |= GFLG_DISABLED;

    AddGList( ListEdWnd, &LE_UpGadget, pos, 4, NULL );
    RefreshGList( &LE_UpGadget, ListEdWnd, NULL, 4 );

    DisableTag[1] = TRUE;
    GT_SetGadgetAttrsA( ListEdGadgets[ GD_LE_In ], ListEdWnd,
			NULL, (struct TagItem *)DisableTag );
    GT_SetGadgetAttrsA( ListEdGadgets[ GD_LE_Del ], ListEdWnd,
			NULL, (struct TagItem *)DisableTag );
}

BOOL LE_DelKeyPressed( void )
{
    if( *((UWORD *)buffer2 ))
	return( LE_DelClicked() );
    else
	return( TRUE );
}

BOOL LE_DelClicked( void )
{
    struct Node *pred;

    pred = ((struct Node *)buffer4)->ln_Pred;

    if(!( pred->ln_Pred )) {
	pred = ((struct Node *)buffer4)->ln_Succ;
	List2Tag[1] += 1;
    } else {
	List2Tag[1] -= 1;
    }

    List2Tag[3] = List2Tag[1];

    ListEdStaccaLista();
    Remove((struct Node *)buffer4 );

    FreeObject( buffer4, IE_ITEM );

    buffer4 = pred;

    *((UWORD *)buffer2) -= 1;

    if( *((UWORD *)buffer2 )) {
	ListEdAttaccaLista();
	SettaListEdIn();
    } else {
	DisattivaListEdGadgets();
    }

    IE.flags &= ~SALVATO;

    return( TRUE );
}

BOOL LE_UpClicked( void )
{
    if( List2Tag[1] ) {
	ListEdStaccaLista();
	NodeUp((struct Node *)buffer4);
	List2Tag[1] -= 1;
	List2Tag[3] = List2Tag[1];
	ListEdAttaccaLista();
    }

    return( TRUE );
}

BOOL LE_TopClicked( void )
{
    if( List2Tag[1] ) {
	ListEdStaccaLista();
	Remove((struct Node *)buffer4);
	AddHead(( struct List * )&ListEd_List, (struct Node *)buffer4 );
	List2Tag[1] = List2Tag[3] = 0;
	ListEdAttaccaLista();
    }

    return( TRUE );
}

BOOL LE_DownClicked( void )
{
    if( List2Tag[1] < *((UWORD *)buffer2) - 1 ) {
	ListEdStaccaLista();
	NodeDown((struct Node *)buffer4);
	List2Tag[1] += 1;
	List2Tag[3] = List2Tag[1];
	ListEdAttaccaLista();
    }

    return( TRUE );
}

BOOL LE_BottomClicked( void )
{
    if( List2Tag[1] < *((UWORD *)buffer2) - 1 ) {
	ListEdStaccaLista();
	Remove((struct Node *)buffer4);
	AddTail(( struct List * )&ListEd_List, (struct Node *)buffer4 );
	List2Tag[1] = List2Tag[3] = *((UWORD *)buffer2) - 1;
	ListEdAttaccaLista();
    }

    return( TRUE );
}

BOOL ListEdVanillaKey( void )
{
    if( ListEdMsg.Code == 0x09 ) {
	if(!( ListEdGadgets[ GD_LE_In ]->Flags & GFLG_DISABLED ))
	    ActivateGadget( ListEdGadgets[ GD_LE_In ], ListEdWnd, NULL );
    }

    return( TRUE );
}

BOOL ListEdRawKey( void )
{
    switch( ListEdMsg.Code ) {
	case 0x43:                          // Enter
	case 0x44:                          // Return
	    return( LE_OkClicked() );
	    break;

	case 0x45:                          // ESC
	    return( LE_AnnullaClicked() );
	    break;

	case 0x4C:                          // Su
	    if( List2Tag[1] ) {
		List2Tag[1] -= 1;
		buffer4 = ((struct Node *)buffer4)->ln_Pred;
	    } else {
		List2Tag[1] = *((UWORD *)buffer2) - 1;
		buffer4 = ListEd_List.mlh_TailPred;
	    }
	    List2Tag[3] = List2Tag[1];
	    GT_SetGadgetAttrsA( ListEdGadgets[ GD_Lista ], ListEdWnd, NULL, (struct TagItem *)List2Tag );
	    SettaListEdIn();
	    break;

	case 0x4D:                          // Giù
	    if( List2Tag[1] < *((UWORD *)buffer2) - 1 ) {
		List2Tag[1] += 1;
		buffer4 = ((struct Node *)buffer4)->ln_Succ;
	    } else {
		List2Tag[1] = 0;
		buffer4 = ListEd_List.mlh_Head;
	    }
	    List2Tag[3] = List2Tag[1];
	    GT_SetGadgetAttrsA( ListEdGadgets[ GD_Lista ], ListEdWnd, NULL, (struct TagItem *)List2Tag );
	    SettaListEdIn();
	    break;
    }

    return( TRUE );
}

BOOL LE_InClicked( void )
{
    strcpy( ((struct GadgetScelta *)buffer4)->gs_Testo,
	    GetString( ListEdGadgets[ GD_LE_In ]) );

    GT_RefreshWindow( ListEdWnd, NULL );

    return( TRUE );
}

BOOL LE_ListClicked( void )
{
    struct Node *no;
    int          cnt;

    List2Tag[1] = List2Tag[3] = ListEdMsg.Code;

    no = (struct Node *)&ListEd_List;

    for( cnt = 0; cnt <= List2Tag[1]; cnt++ )
	no = no->ln_Succ;

    buffer4 = no;

    return( TRUE );
}
///

/// Parametri BUTTON
void ParametriButton( struct GadgetInfo *gad )
{
    int     ret;

    LayoutWindow( ButTagWTags );
    ret = OpenButTagWindow();
    PostOpenWindow( ButTagWTags );

    if( ret ) {
	DisplayBeep( Scr );
    } else {

	StringTag[1] = gad->g_Titolo;
	GT_SetGadgetAttrsA( ButTagGadgets[ GD_BT_Tit ], ButTagWnd,
			    NULL, (struct TagItem *)StringTag );

	StringTag[1] = gad->g_Label;
	GT_SetGadgetAttrsA( ButTagGadgets[ GD_BT_Label ], ButTagWnd,
			    NULL, (struct TagItem *)StringTag );

	ret = 0;
	while((!( gadget_flags[ ret ] & gad->g_Flags )) && ret < 5 )
	    ret += 1;

	CycleTag[1] = ret;
	GT_SetGadgetAttrsA( ButTagGadgets[ GD_BT_PosTit ], ButTagWnd,
			    NULL, (struct TagItem *)CycleTag );

	CheckedTag[1] = ( gad->g_Tags & 1 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( ButTagGadgets[ GD_BT_Und ], ButTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Flags & NG_HIGHLABEL ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( ButTagGadgets[ GD_BT_High ], ButTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Tags & 2 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( ButTagGadgets[ GD_BT_Disab ], ButTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Tags & 4 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( ButTagGadgets[ GD_BT_Imm ], ButTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	ActivateGadget( ButTagGadgets[ GD_BT_Tit ], ButTagWnd, NULL );

	if( gad->g_Key )
	    IE.win_info->wi_NumKeys -= 1;

	buffer4 = (APTR)gad->g_Flags;
	buffer2 = gad->g_Tags;
	buffer3 = gad;
	buffer  = FALSE;

	while( ReqHandle( ButTagWnd, HandleButTagIDCMP ));
    }

    CloseButTagWindow();
}

BOOL BT_TitClicked( void )
{
    ActivateGadget( ButTagGadgets[ GD_BT_Label ], ButTagWnd, NULL );
    return( TRUE );
}

BOOL BT_LabelClicked( void )
{
    return( TRUE );
}

BOOL ButTagVanillaKey( void )
{
    switch( ButTagMsg.Code ) {
	case 13:
	    return( BT_OkClicked() );
	case 27:
	    return( BT_AnnullaClicked() );
    }
}

BOOL BT_AnnullaKeyPressed( void )
{
    return( BT_AnnullaClicked() );
}

BOOL BT_AnnullaClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Flags = buffer4;
    ((struct GadgetInfo *)buffer3)->g_Tags  = buffer2;
    return( FALSE );
}

BOOL BT_OkKeyPressed( void )
{
    return( BT_OkClicked() );
}

BOOL BT_OkClicked( void )
{
    buffer = TRUE;

    strcpy( ((struct GadgetInfo *)buffer3)->g_Titolo,
	    GetString( ButTagGadgets[ GD_BT_Tit ]));

    STRPTR label;

    label = GetString( ButTagGadgets[ GD_BT_Label ]);

    if( label[0] )
	strcpy( ((struct GadgetInfo *)buffer3)->g_Label, label );

    return( FALSE );
}

BOOL BT_UndKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 1 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( ButTagGadgets[ GD_BT_Und ], ButTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( BT_UndClicked() );
}

BOOL BT_UndClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 1;
    return( TRUE );
}

BOOL BT_HighKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Flags & NG_HIGHLABEL ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( ButTagGadgets[ GD_BT_High ], ButTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( BT_HighClicked() );
}

BOOL BT_HighClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Flags ^= NG_HIGHLABEL;
    return( TRUE );
}

BOOL BT_DisabKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 2 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( ButTagGadgets[ GD_BT_Disab ], ButTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( BT_DisabClicked() );
}

BOOL BT_DisabClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 2;
    return( TRUE );
}

BOOL BT_ImmKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 4 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( ButTagGadgets[ GD_BT_Imm ], ButTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( BT_ImmClicked() );
}

BOOL BT_ImmClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 4;
    return( TRUE );
}

BOOL BT_PosTitKeyPressed( void )
{
    if( CycleTag[1] < 5 )
	CycleTag[1] += 1;
    else
	CycleTag[1] = 0;

    GT_SetGadgetAttrsA( ButTagGadgets[ GD_BT_PosTit ], ButTagWnd,
			NULL, (struct TagItem *)CycleTag );

    ButTagMsg.Code = CycleTag[1];

    return( BT_PosTitClicked() );
}

BOOL BT_PosTitClicked( void )
{
    ULONG   t;

    CycleTag[1] = ButTagMsg.Code;

    t = ((struct GadgetInfo *)buffer3)->g_Flags & 32;
    ((struct GadgetInfo *)buffer3)->g_Flags = t | gadget_flags[ ButTagMsg.Code ];

    return( TRUE );
}
///
/// Parametri CHECKBOX
void ParametriCheckbox( struct GadgetInfo *gad )
{
    int     ret;

    LayoutWindow( ChkTagWTags );
    ret = OpenChkTagWindow();
    PostOpenWindow( ChkTagWTags );

    if( ret ) {
	DisplayBeep( Scr );
    } else {

	StringTag[1] = gad->g_Titolo;
	GT_SetGadgetAttrsA( ChkTagGadgets[ GD_CT_Tit ], ChkTagWnd,
			    NULL, (struct TagItem *)StringTag );

	StringTag[1] = gad->g_Label;
	GT_SetGadgetAttrsA( ChkTagGadgets[ GD_CT_Label ], ChkTagWnd,
			    NULL, (struct TagItem *)StringTag );

	ret = 0;
	while((!( gadget_flags[ ret ] & gad->g_Flags )) && ret < 5 )
	    ret += 1;

	CycleTag[1] = ret;
	GT_SetGadgetAttrsA( ChkTagGadgets[ GD_CT_PosTit ], ChkTagWnd,
			    NULL, (struct TagItem *)CycleTag );

	CheckedTag[1] = ( gad->g_Tags & 1 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( ChkTagGadgets[ GD_CT_Und ], ChkTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Flags & NG_HIGHLABEL ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( ChkTagGadgets[ GD_CT_High ], ChkTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Tags & 2 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( ChkTagGadgets[ GD_CT_Disab ], ChkTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Tags & 4 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( ChkTagGadgets[ GD_CT_Chk ], ChkTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Tags & 8 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( ChkTagGadgets[ GD_CT_Scaled ], ChkTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	ActivateGadget( ChkTagGadgets[ GD_CT_Tit ], ChkTagWnd, NULL );

	if( gad->g_Key )
	    IE.win_info->wi_NumKeys -= 1;

	buffer4 = (APTR)gad->g_Flags;
	buffer2 = gad->g_Tags;
	buffer3 = gad;
	buffer  = FALSE;

	while( ReqHandle( ChkTagWnd, HandleChkTagIDCMP ));
    }

    CloseChkTagWindow();
}

BOOL CT_TitClicked( void )
{
    ActivateGadget( ChkTagGadgets[ GD_CT_Label ], ChkTagWnd, NULL );
    return( TRUE );
}

BOOL CT_LabelClicked( void )
{
    return( TRUE );
}

BOOL ChkTagVanillaKey( void )
{
    switch( ChkTagMsg.Code ) {
	case 13:
	    return( CT_OkClicked() );
	case 27:
	    return( CT_AnnullaClicked() );
    }
}

BOOL CT_AnnullaKeyPressed( void )
{
    return( CT_AnnullaClicked() );
}

BOOL CT_AnnullaClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Flags = buffer4;
    ((struct GadgetInfo *)buffer3)->g_Tags  = buffer2;
    return( FALSE );
}

BOOL CT_OkKeyPressed( void )
{
    return( CT_OkClicked() );
}

BOOL CT_OkClicked( void )
{
    buffer = TRUE;

    strcpy( ((struct GadgetInfo *)buffer3)->g_Titolo,
	    GetString( ChkTagGadgets[ GD_CT_Tit ]));

    STRPTR label;

    label = GetString( ChkTagGadgets[ GD_CT_Label ]);

    if( label[0] )
	strcpy( ((struct GadgetInfo *)buffer3)->g_Label, label );

    return( FALSE );
}

BOOL CT_UndKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 1 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( ChkTagGadgets[ GD_CT_Und ], ChkTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( CT_UndClicked() );
}

BOOL CT_UndClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 1;
    return( TRUE );
}

BOOL CT_HighKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Flags & NG_HIGHLABEL ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( ChkTagGadgets[ GD_CT_High ], ChkTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( CT_HighClicked() );
}

BOOL CT_HighClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Flags ^= NG_HIGHLABEL;
    return( TRUE );
}

BOOL CT_DisabKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 2 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( ChkTagGadgets[ GD_CT_Disab ], ChkTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( CT_DisabClicked() );
}

BOOL CT_DisabClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 2;
    return( TRUE );
}

BOOL CT_ChkKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 4 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( ChkTagGadgets[ GD_CT_Chk ], ChkTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( CT_ChkClicked() );
}

BOOL CT_ChkClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 4;
    return( TRUE );
}

BOOL CT_ScaledKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 8 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( ChkTagGadgets[ GD_CT_Scaled ], ChkTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( CT_ScaledClicked() );
}

BOOL CT_ScaledClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 8;
    return( TRUE );
}

BOOL CT_PosTitKeyPressed( void )
{
    if( CycleTag[1] < 5 )
	CycleTag[1] += 1;
    else
	CycleTag[1] = 0;

    GT_SetGadgetAttrsA( ChkTagGadgets[ GD_CT_PosTit ], ChkTagWnd,
			NULL, (struct TagItem *)CycleTag );

    ChkTagMsg.Code = CycleTag[1];

    return( CT_PosTitClicked() );
}

BOOL CT_PosTitClicked( void )
{
    ULONG   t;

    CycleTag[1] = ChkTagMsg.Code;

    t = ((struct GadgetInfo *)buffer3)->g_Flags & 32;
    ((struct GadgetInfo *)buffer3)->g_Flags = t | gadget_flags[ ChkTagMsg.Code ];

    return( TRUE );
}
///
/// Parametri INTEGER
void ParametriInteger( struct GadgetInfo *gad )
{
    int     ret;

    LayoutWindow( IntTagWTags );
    ret = OpenIntTagWindow();
    PostOpenWindow( IntTagWTags );

    if( ret ) {
	DisplayBeep( Scr );
    } else {

	StringTag[1] = gad->g_Titolo;
	GT_SetGadgetAttrsA( IntTagGadgets[ GD_ITg_Tit ], IntTagWnd,
			    NULL, (struct TagItem *)StringTag );

	StringTag[1] = gad->g_Label;
	GT_SetGadgetAttrsA( IntTagGadgets[ GD_ITg_Label ], IntTagWnd,
			    NULL, (struct TagItem *)StringTag );

	ret = 0;
	while((!( gadget_flags[ ret ] & gad->g_Flags )) && ret < 5 )
	    ret += 1;

	CycleTag[1] = ret;
	GT_SetGadgetAttrsA( IntTagGadgets[ GD_ITg_PosTit ], IntTagWnd,
			    NULL, (struct TagItem *)CycleTag );

	CycleTag2[1] = ((struct IK)(gad->g_Data)).Just;
	GT_SetGadgetAttrsA( IntTagGadgets[ GD_ITg_Just ], IntTagWnd,
			    NULL, (struct TagItem *)CycleTag2 );

	IntegerTag[1] = ((struct IK)(gad->g_Data)).Num;
	GT_SetGadgetAttrsA( IntTagGadgets[ GD_ITg_Num ], IntTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = ((struct IK)(gad->g_Data)).MaxC;
	GT_SetGadgetAttrsA( IntTagGadgets[ GD_ITg_MaxCh ], IntTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	CheckedTag[1] = ( gad->g_Tags & 1 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( IntTagGadgets[ GD_ITg_Und ], IntTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Flags & NG_HIGHLABEL ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( IntTagGadgets[ GD_ITg_High ], IntTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Tags & 2 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( IntTagGadgets[ GD_ITg_Disab ], IntTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Tags & 4 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( IntTagGadgets[ GD_ITg_Imm ], IntTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Tags & 8 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( IntTagGadgets[ GD_ITg_Tab ], IntTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Tags & 0x10 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( IntTagGadgets[ GD_ITg_Help ], IntTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Tags & 0x20 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( IntTagGadgets[ GD_ITg_Rep ], IntTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	ActivateGadget( IntTagGadgets[ GD_ITg_Tit ], IntTagWnd, NULL );

	if( gad->g_Key )
	    IE.win_info->wi_NumKeys -= 1;

	buffer4 = (APTR)gad->g_Flags;
	buffer2 = gad->g_Tags;
	buffer3 = gad;
	buffer  = FALSE;

	while( ReqHandle( IntTagWnd, HandleIntTagIDCMP ));
    }

    CloseIntTagWindow();
}

BOOL ITg_TitClicked( void )
{
    ActivateGadget( IntTagGadgets[ GD_ITg_Label ], IntTagWnd, NULL );
    return( TRUE );
}

BOOL ITg_LabelClicked( void )
{
    return( TRUE );
}

BOOL IntTagVanillaKey( void )
{
    switch( IntTagMsg.Code ) {
	case 13:
	    return( ITg_OkClicked() );
	case 27:
	    return( ITg_AnnullaClicked() );
    }
}

BOOL ITg_AnnullaKeyPressed( void )
{
    return( ITg_AnnullaClicked() );
}

BOOL ITg_AnnullaClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Flags = buffer4;
    ((struct GadgetInfo *)buffer3)->g_Tags  = buffer2;
    return( FALSE );
}

BOOL ITg_OkKeyPressed( void )
{
    return( ITg_OkClicked() );
}

BOOL ITg_OkClicked( void )
{
    buffer = TRUE;

    strcpy( ((struct GadgetInfo *)buffer3)->g_Titolo,
	    GetString( IntTagGadgets[ GD_ITg_Tit ]));

    STRPTR label;

    label = GetString( IntTagGadgets[ GD_ITg_Label ]);

    if( label[0] )
	strcpy( ((struct GadgetInfo *)buffer3)->g_Label, label );

    ((struct IK)(((struct GadgetInfo *)buffer3)->g_Data)).Num  = GetNumber( IntTagGadgets[ GD_ITg_Num ]);
    ((struct IK)(((struct GadgetInfo *)buffer3)->g_Data)).MaxC = GetNumber( IntTagGadgets[ GD_ITg_MaxCh ]);
    ((struct IK)(((struct GadgetInfo *)buffer3)->g_Data)).Just = CycleTag2[1];

    return( FALSE );
}

BOOL ITg_UndKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 1 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( IntTagGadgets[ GD_ITg_Und ], IntTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( ITg_UndClicked() );
}

BOOL ITg_UndClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 1;
    return( TRUE );
}

BOOL ITg_HighKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Flags & NG_HIGHLABEL ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( IntTagGadgets[ GD_ITg_High ], IntTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( ITg_HighClicked() );
}

BOOL ITg_HighClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Flags ^= NG_HIGHLABEL;
    return( TRUE );
}

BOOL ITg_DisabKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 2 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( IntTagGadgets[ GD_ITg_Disab ], IntTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( ITg_DisabClicked() );
}

BOOL ITg_DisabClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 2;
    return( TRUE );
}

BOOL ITg_ImmKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 4 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( IntTagGadgets[ GD_ITg_Imm ], IntTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( ITg_ImmClicked() );
}

BOOL ITg_ImmClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 4;
    return( TRUE );
}

BOOL ITg_TabKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 8 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( IntTagGadgets[ GD_ITg_Tab ], IntTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( ITg_TabClicked() );
}

BOOL ITg_TabClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 8;
    return( TRUE );
}

BOOL ITg_HelpKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 0x10 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( IntTagGadgets[ GD_ITg_Help ], IntTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( ITg_HelpClicked() );
}

BOOL ITg_HelpClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 0x10;
    return( TRUE );
}

BOOL ITg_RepKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 0x20 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( IntTagGadgets[ GD_ITg_Rep ], IntTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( ITg_RepClicked() );
}

BOOL ITg_RepClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 0x20;
    return( TRUE );
}

BOOL ITg_PosTitKeyPressed( void )
{
    if( CycleTag[1] < 5 )
	CycleTag[1] += 1;
    else
	CycleTag[1] = 0;

    GT_SetGadgetAttrsA( IntTagGadgets[ GD_ITg_PosTit ], IntTagWnd,
			NULL, (struct TagItem *)CycleTag );

    IntTagMsg.Code = CycleTag[1];

    return( ITg_PosTitClicked() );
}

BOOL ITg_NumClicked( void )
{
    ActivateGadget( IntTagGadgets[ GD_ITg_MaxCh ], IntTagWnd, NULL );
    return( TRUE );
}

BOOL ITg_JustKeyPressed( void )
{
    if( CycleTag2[1] < 2 )
	CycleTag2[1] += 1;
    else
	CycleTag2[1] = 0;

    GT_SetGadgetAttrsA( IntTagGadgets[ GD_ITg_Just ], IntTagWnd,
			NULL, (struct TagItem *)CycleTag2 );

    return( TRUE );
}

BOOL ITg_JustClicked( void )
{
    CycleTag2[1] = IntTagMsg.Code;
    return( TRUE );
}

BOOL ITg_MaxChClicked( void )
{
    return( TRUE );
}

BOOL ITg_PosTitClicked( void )
{
    ULONG   t;

    CycleTag[1] = IntTagMsg.Code;

    t = ((struct GadgetInfo *)buffer3)->g_Flags & 32;
    ((struct GadgetInfo *)buffer3)->g_Flags = t | gadget_flags[ IntTagMsg.Code ];

    return( TRUE );
}
///
/// Parametri LISTVIEW

#define gd ((struct LK)(((struct GadgetInfo *)buffer3)->g_Data))

void ParametriListview( struct GadgetInfo *gad )
{
    int     ret;

    LayoutWindow( LstTagWTags );
    ret = OpenLstTagWindow();
    PostOpenWindow( LstTagWTags );

    if( ret ) {
	DisplayBeep( Scr );
    } else {

	buffer3 = gad;

	StringTag[1] = gad->g_Titolo;
	GT_SetGadgetAttrsA( LstTagGadgets[ GD_LT_Tit ], LstTagWnd,
			    NULL, (struct TagItem *)StringTag );

	StringTag[1] = gad->g_Label;
	GT_SetGadgetAttrsA( LstTagGadgets[ GD_LT_Label ], LstTagWnd,
			    NULL, (struct TagItem *)StringTag );

	ret = 0;
	while((!( gadget_flags[ ret ] & gad->g_Flags )) && ret < 5 )
	    ret += 1;

	CycleTag[1] = ret;
	GT_SetGadgetAttrsA( LstTagGadgets[ GD_LT_PosTit ], LstTagWnd,
			    NULL, (struct TagItem *)CycleTag );

	CheckedTag[1] = ( gad->g_Tags & 1 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( LstTagGadgets[ GD_LT_Und ], LstTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Flags & NG_HIGHLABEL ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( LstTagGadgets[ GD_LT_High ], LstTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Tags & 2 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( LstTagGadgets[ GD_LT_Disab ], LstTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Tags & 4 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( LstTagGadgets[ GD_LT_ROn ], LstTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Tags & 8 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( LstTagGadgets[ GD_LT_Show ], LstTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = gd.MultiSelect;
	GT_SetGadgetAttrsA( LstTagGadgets[ GD_LT_Multi ], LstTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	if( gd.MultiSelect ) {
	    DisableTag[1] = TRUE;
	    GT_SetGadgetAttrsA( LstTagGadgets[ GD_LT_Sel ], LstTagWnd,
				NULL, (struct TagItem *)DisableTag );
	}

	IntegerTag[1] = gd.Top;
	GT_SetGadgetAttrsA( LstTagGadgets[ GD_LT_Top ], LstTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = gd.Vis;
	GT_SetGadgetAttrsA( LstTagGadgets[ GD_LT_Vis ], LstTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = gd.ScW;
	GT_SetGadgetAttrsA( LstTagGadgets[ GD_LT_ScW ], LstTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = gd.Sel;
	GT_SetGadgetAttrsA( LstTagGadgets[ GD_LT_Sel ], LstTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = gd.Spc;
	GT_SetGadgetAttrsA( LstTagGadgets[ GD_LT_Spc ], LstTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = gd.IH;
	GT_SetGadgetAttrsA( LstTagGadgets[ GD_LT_IH ], LstTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = gd.MaxP;
	GT_SetGadgetAttrsA( LstTagGadgets[ GD_LT_MaxP ], LstTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	if( gad->g_Key )
	    IE.win_info->wi_NumKeys -= 1;

	buffer4     = (APTR)gad->g_Flags;
	buffer2     = gad->g_Tags;
	buffer      = FALSE;
	BackValue   = gd.MultiSelect;

	ActivateGadget( LstTagGadgets[ GD_LT_Tit ], LstTagWnd, NULL );

	while( ReqHandle( LstTagWnd, HandleLstTagIDCMP ));
    }

    CloseLstTagWindow();
}

BOOL LT_TitClicked( void )
{
    ActivateGadget( LstTagGadgets[ GD_LT_Label ], LstTagWnd, NULL );
    return( TRUE );
}

BOOL LT_LabelClicked( void )
{
    return( TRUE );
}

BOOL LstTagVanillaKey( void )
{
    switch( LstTagMsg.Code ) {
	case 13:
	    return( LT_OkClicked() );
	case 27:
	    return( LT_AnnullaClicked() );
    }
}

BOOL LT_AnnullaKeyPressed( void )
{
    return( LT_AnnullaClicked() );
}

BOOL LT_AnnullaClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Flags = buffer4;
    ((struct GadgetInfo *)buffer3)->g_Tags  = buffer2;
    return( FALSE );
}

BOOL LT_OkKeyPressed( void )
{
    return( LT_OkClicked() );
}

BOOL LT_OkClicked( void )
{
    STRPTR label;

    buffer = TRUE;

    strcpy( ((struct GadgetInfo *)buffer3)->g_Titolo,
	    GetString( LstTagGadgets[ GD_LT_Tit ]));

    label = GetString( LstTagGadgets[ GD_LT_Label ]);

    if( label[0] )
	strcpy( ((struct GadgetInfo *)buffer3)->g_Label, label );

    gd.Top          = GetNumber( LstTagGadgets[ GD_LT_Top  ]);
    gd.Vis          = GetNumber( LstTagGadgets[ GD_LT_Vis  ]);
    gd.ScW          = GetNumber( LstTagGadgets[ GD_LT_ScW  ]);
    gd.Sel          = GetNumber( LstTagGadgets[ GD_LT_Sel  ]);
    gd.Spc          = GetNumber( LstTagGadgets[ GD_LT_Spc  ]);
    gd.IH           = GetNumber( LstTagGadgets[ GD_LT_IH   ]);
    gd.MaxP         = GetNumber( LstTagGadgets[ GD_LT_MaxP ]);
    gd.MultiSelect  = BackValue;

    return( FALSE );
}

BOOL LT_UndKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 1 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( LstTagGadgets[ GD_LT_Und ], LstTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( LT_UndClicked() );
}

BOOL LT_UndClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 1;
    return( TRUE );
}

BOOL LT_HighKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Flags & NG_HIGHLABEL ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( LstTagGadgets[ GD_LT_High ], LstTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( LT_HighClicked() );
}

BOOL LT_HighClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Flags ^= NG_HIGHLABEL;
    return( TRUE );
}

BOOL LT_DisabKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 2 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( LstTagGadgets[ GD_LT_Disab ], LstTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( LT_DisabClicked() );
}

BOOL LT_DisabClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 2;
    return( TRUE );
}

BOOL LT_ROnKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 4 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( LstTagGadgets[ GD_LT_ROn ], LstTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( LT_ROnClicked() );
}

BOOL LT_ROnClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 4;
    return( TRUE );
}

BOOL LT_ShowKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 8 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( LstTagGadgets[ GD_LT_Show ], LstTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( LT_ShowClicked() );
}

BOOL LT_ShowClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 8;
    return( TRUE );
}

BOOL LT_MultiKeyPressed( void )
{
    CheckedTag[1] = LstTagMsg.Code = BackValue ? FALSE : TRUE;
    GT_SetGadgetAttrsA( LstTagGadgets[ GD_LT_Multi ], LstTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( LT_MultiClicked() );
}

BOOL LT_MultiClicked( void )
{
    BackValue = LstTagMsg.Code;

    DisableTag[1] = BackValue;
    GT_SetGadgetAttrsA( LstTagGadgets[ GD_LT_Sel ], LstTagWnd,
			NULL, (struct TagItem *)DisableTag );

    return( TRUE );
}

BOOL LT_PosTitKeyPressed( void )
{
    if( CycleTag[1] < 5 )
	CycleTag[1] += 1;
    else
	CycleTag[1] = 0;

    GT_SetGadgetAttrsA( LstTagGadgets[ GD_LT_PosTit ], LstTagWnd,
			NULL, (struct TagItem *)CycleTag );

    LstTagMsg.Code = CycleTag[1];

    return( LT_PosTitClicked() );
}

BOOL LT_TopClicked( void )
{
    ActivateGadget( LstTagGadgets[ GD_LT_Vis ], LstTagWnd, NULL );
    return( TRUE );
}

BOOL LT_VisClicked( void )
{
    ActivateGadget( LstTagGadgets[ GD_LT_Sel ], LstTagWnd, NULL );
    return( TRUE );
}

BOOL LT_SelClicked( void )
{
    ActivateGadget( LstTagGadgets[ GD_LT_ScW ], LstTagWnd, NULL );
    return( TRUE );
}

BOOL LT_ScWClicked( void )
{
    ActivateGadget( LstTagGadgets[ GD_LT_Spc ], LstTagWnd, NULL );
    return( TRUE );
}

BOOL LT_SpcClicked( void )
{
    ActivateGadget( LstTagGadgets[ GD_LT_IH ], LstTagWnd, NULL );
    return( TRUE );
}

BOOL LT_IHClicked( void )
{
    ActivateGadget( LstTagGadgets[ GD_LT_MaxP ], LstTagWnd, NULL );
    return( TRUE );
}

BOOL LT_MaxPClicked( void )
{
    return( TRUE );
}

BOOL LT_PosTitClicked( void )
{
    ULONG   t;

    CycleTag[1] = LstTagMsg.Code;

    t = ((struct GadgetInfo *)buffer3)->g_Flags & 32;
    ((struct GadgetInfo *)buffer3)->g_Flags = t | gadget_flags[ LstTagMsg.Code ];

    return( TRUE );
}

#undef gd
///
/// Parametri MX
#define gd ((struct MK)(((struct GadgetInfo *)buffer3)->g_Data))

void ParametriMx( struct GadgetInfo *gad )
{
    int     ret;

    LayoutWindow( MxTagWTags );
    ret = OpenMxTagWindow();
    PostOpenWindow( MxTagWTags );

    if( ret ) {
	DisplayBeep( Scr );
    } else {

	buffer3 = gad;

	StringTag[1] = gad->g_Titolo;
	GT_SetGadgetAttrsA( MxTagGadgets[ GD_MT_Tit ], MxTagWnd,
			    NULL, (struct TagItem *)StringTag );

	StringTag[1] = gad->g_Label;
	GT_SetGadgetAttrsA( MxTagGadgets[ GD_MT_Label ], MxTagWnd,
			    NULL, (struct TagItem *)StringTag );

	ret = 0;
	while((!( gadget_flags[ ret ] & gad->g_Flags )) && ret < 5 )
	    ret += 1;

	CycleTag[1] = ret;
	GT_SetGadgetAttrsA( MxTagGadgets[ GD_MT_PosTit ], MxTagWnd,
			    NULL, (struct TagItem *)CycleTag );

	CycleTag2[1] = gd.TitPlc;
	GT_SetGadgetAttrsA( MxTagGadgets[ GD_MT_TitPlc ], MxTagWnd,
			    NULL, (struct TagItem *)CycleTag2 );

	CheckedTag[1] = ( gad->g_Tags & 1 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( MxTagGadgets[ GD_MT_Und ], MxTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Flags & NG_HIGHLABEL ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( MxTagGadgets[ GD_MT_High ], MxTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Tags & 2 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( MxTagGadgets[ GD_MT_Disab ], MxTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Tags & 4 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( MxTagGadgets[ GD_MT_Scaled ], MxTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	IntegerTag[1] = gd.Act;
	GT_SetGadgetAttrsA( MxTagGadgets[ GD_MT_Act ], MxTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = gd.Spc;
	GT_SetGadgetAttrsA( MxTagGadgets[ GD_MT_Spc ], MxTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	ActivateGadget( MxTagGadgets[ GD_MT_Tit ], MxTagWnd, NULL );

	if( gad->g_Key )
	    IE.win_info->wi_NumKeys -= 1;

	buffer4 = (APTR)gad->g_Flags;
	buffer2 = gad->g_Tags;
	buffer  = FALSE;

	while( ReqHandle( MxTagWnd, HandleMxTagIDCMP ));
    }

    CloseMxTagWindow();
}

BOOL MT_TitClicked( void )
{
    ActivateGadget( MxTagGadgets[ GD_MT_Label ], MxTagWnd, NULL );
    return( TRUE );
}

BOOL MT_LabelClicked( void )
{
    return( TRUE );
}

BOOL MxTagVanillaKey( void )
{
    switch( MxTagMsg.Code ) {
	case 13:
	    return( MT_OkClicked() );
	case 27:
	    return( MT_AnnullaClicked() );
    }
}

BOOL MT_AnnullaKeyPressed( void )
{
    return( MT_AnnullaClicked() );
}

BOOL MT_AnnullaClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Flags = buffer4;
    ((struct GadgetInfo *)buffer3)->g_Tags  = buffer2;
    return( FALSE );
}

BOOL MT_OkKeyPressed( void )
{
    return( MT_OkClicked() );
}

BOOL MT_OkClicked( void )
{
    buffer = TRUE;

    strcpy( ((struct GadgetInfo *)buffer3)->g_Titolo,
	    GetString( MxTagGadgets[ GD_MT_Tit ]));

    STRPTR label;

    label = GetString( MxTagGadgets[ GD_MT_Label ]);

    if( label[0] )
	strcpy( ((struct GadgetInfo *)buffer3)->g_Label, label );

    gd.Act    = GetNumber( MxTagGadgets[ GD_MT_Act ]);
    gd.Spc    = GetNumber( MxTagGadgets[ GD_MT_Spc ]);
    gd.TitPlc = CycleTag2[1];

    return( FALSE );
}

BOOL MT_UndKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 1 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( MxTagGadgets[ GD_MT_Und ], MxTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( MT_UndClicked() );
}

BOOL MT_UndClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 1;
    return( TRUE );
}

BOOL MT_HighKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Flags & NG_HIGHLABEL ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( MxTagGadgets[ GD_MT_High ], MxTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( MT_HighClicked() );
}

BOOL MT_HighClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Flags ^= NG_HIGHLABEL;
    return( TRUE );
}

BOOL MT_DisabKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 2 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( MxTagGadgets[ GD_MT_Disab ], MxTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( MT_DisabClicked() );
}

BOOL MT_DisabClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 2;
    return( TRUE );
}

BOOL MT_ScaledKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 4 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( MxTagGadgets[ GD_MT_Scaled ], MxTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( MT_ScaledClicked() );
}

BOOL MT_ScaledClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 4;
    return( TRUE );
}

BOOL MT_ActClicked( void )
{
    ActivateGadget( MxTagGadgets[ GD_MT_Spc ], MxTagWnd, NULL );
    return( TRUE );
}

BOOL MT_SpcClicked( void )
{
    return( TRUE );
}

BOOL MT_PosTitKeyPressed( void )
{
    if( CycleTag[1] < 5 )
	CycleTag[1] += 1;
    else
	CycleTag[1] = 0;

    GT_SetGadgetAttrsA( MxTagGadgets[ GD_MT_PosTit ], MxTagWnd,
			NULL, (struct TagItem *)CycleTag );

    MxTagMsg.Code = CycleTag[1];

    return( MT_PosTitClicked() );
}

BOOL MT_PosTitClicked( void )
{
    ULONG   t;

    CycleTag[1] = MxTagMsg.Code;

    t = ((struct GadgetInfo *)buffer3)->g_Flags & 32;
    ((struct GadgetInfo *)buffer3)->g_Flags = t | gadget_flags[ MxTagMsg.Code ];

    return( TRUE );
}

BOOL MT_TitPlcKeyPressed( void )
{
    if( CycleTag2[1] < 3 )
	CycleTag2[1] += 1;
    else
	CycleTag2[1] = 0;

    GT_SetGadgetAttrsA( MxTagGadgets[ GD_MT_TitPlc ], MxTagWnd,
			NULL, (struct TagItem *)CycleTag2 );

    return( TRUE );
}

BOOL MT_TitPlcClicked( void )
{
    CycleTag2[1] = MxTagMsg.Code;

    return( TRUE );
}

#undef gd
///
/// Parametri NUMBER
#define gd ((struct NK)(((struct GadgetInfo *)buffer3)->g_Data))

void ParametriNumber( struct GadgetInfo *gad )
{
    int     ret;

    LayoutWindow( NumTagWTags );
    ret = OpenNumTagWindow();
    PostOpenWindow( NumTagWTags );

    if( ret ) {
	DisplayBeep( Scr );
    } else {

	buffer3 = gad;

	StringTag[1] = gad->g_Titolo;
	GT_SetGadgetAttrsA( NumTagGadgets[ GD_NT_Tit ], NumTagWnd,
			    NULL, (struct TagItem *)StringTag );

	StringTag[1] = gad->g_Label;
	GT_SetGadgetAttrsA( NumTagGadgets[ GD_NT_Label ], NumTagWnd,
			    NULL, (struct TagItem *)StringTag );

	ret = 0;
	while((!( gadget_flags[ ret ] & gad->g_Flags )) && ret < 5 )
	    ret += 1;

	CycleTag[1] = ret;
	GT_SetGadgetAttrsA( NumTagGadgets[ GD_NT_PosTit ], NumTagWnd,
			    NULL, (struct TagItem *)CycleTag );

	CycleTag2[1] = gd.Just;
	GT_SetGadgetAttrsA( NumTagGadgets[ GD_NT_Just ], NumTagWnd,
			    NULL, (struct TagItem *)CycleTag2 );

	CheckedTag[1] = ( gad->g_Tags & 1 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( NumTagGadgets[ GD_NT_Und ], NumTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Flags & NG_HIGHLABEL ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( NumTagGadgets[ GD_NT_High ], NumTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Tags & 2 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( NumTagGadgets[ GD_NT_Border ], NumTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Tags & 4 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( NumTagGadgets[ GD_NT_Clip ], NumTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	IntegerTag[1] = gd.Num;
	GT_SetGadgetAttrsA( NumTagGadgets[ GD_NT_Num ], NumTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = gd.MNL;
	GT_SetGadgetAttrsA( NumTagGadgets[ GD_NT_MNL ], NumTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = gd.FPen;
	GT_SetGadgetAttrsA( NumTagGadgets[ GD_NT_FPen ], NumTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = gd.BPen;
	GT_SetGadgetAttrsA( NumTagGadgets[ GD_NT_BPen ], NumTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	StringTag[1] = gd.Format;
	GT_SetGadgetAttrsA( NumTagGadgets[ GD_NT_Format ], NumTagWnd,
			    NULL, (struct TagItem *)StringTag );

	ActivateGadget( NumTagGadgets[ GD_NT_Tit ], NumTagWnd, NULL );

	if( gad->g_Key )
	    IE.win_info->wi_NumKeys -= 1;

	buffer4 = (APTR)gad->g_Flags;
	buffer2 = gad->g_Tags;
	buffer  = FALSE;

	while( ReqHandle( NumTagWnd, HandleNumTagIDCMP ));
    }

    CloseNumTagWindow();
}

BOOL NT_TitClicked( void )
{
    ActivateGadget( NumTagGadgets[ GD_NT_Label ], NumTagWnd, NULL );
    return( TRUE );
}

BOOL NT_LabelClicked( void )
{
    return( TRUE );
}

BOOL NumTagVanillaKey( void )
{
    switch( NumTagMsg.Code ) {
	case 13:
	    return( NT_OkClicked() );
	case 27:
	    return( NT_AnnullaClicked() );
    }
}

BOOL NT_AnnullaKeyPressed( void )
{
    return( NT_AnnullaClicked() );
}

BOOL NT_AnnullaClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Flags = buffer4;
    ((struct GadgetInfo *)buffer3)->g_Tags  = buffer2;
    return( FALSE );
}

BOOL NT_OkKeyPressed( void )
{
    return( NT_OkClicked() );
}

BOOL NT_OkClicked( void )
{
    buffer = TRUE;

    strcpy( ((struct GadgetInfo *)buffer3)->g_Titolo,
	    GetString( NumTagGadgets[ GD_NT_Tit ]));

    STRPTR label;

    label = GetString( NumTagGadgets[ GD_NT_Label ]);

    if( label[0] )
	strcpy( ((struct GadgetInfo *)buffer3)->g_Label, label );

    strcpy( gd.Format, GetString( NumTagGadgets[ GD_NT_Format ]));

    gd.Num  = GetNumber( NumTagGadgets[ GD_NT_Num  ]);
    gd.FPen = GetNumber( NumTagGadgets[ GD_NT_FPen ]);
    gd.BPen = GetNumber( NumTagGadgets[ GD_NT_BPen ]);
    gd.Just = CycleTag2[1];
    gd.MNL  = GetNumber( NumTagGadgets[ GD_NT_MNL  ]);

    return( FALSE );
}

BOOL NT_UndKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 1 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( NumTagGadgets[ GD_NT_Und ], NumTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( NT_UndClicked() );
}

BOOL NT_UndClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 1;
    return( TRUE );
}

BOOL NT_HighKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Flags & NG_HIGHLABEL ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( NumTagGadgets[ GD_NT_High ], NumTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( NT_HighClicked() );
}

BOOL NT_HighClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Flags ^= NG_HIGHLABEL;
    return( TRUE );
}

BOOL NT_BorderKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 2 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( NumTagGadgets[ GD_NT_Border ], NumTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( NT_BorderClicked() );
}

BOOL NT_BorderClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 2;
    return( TRUE );
}

BOOL NT_ClipKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 4 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( NumTagGadgets[ GD_NT_Clip ], NumTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( NT_ClipClicked() );
}

BOOL NT_ClipClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 4;
    return( TRUE );
}

BOOL NT_NumClicked( void )
{
    ActivateGadget( NumTagGadgets[ GD_NT_MNL ], NumTagWnd, NULL );
    return( TRUE );
}

BOOL NT_MNLClicked( void )
{
    ActivateGadget( NumTagGadgets[ GD_NT_FPen ], NumTagWnd, NULL );
    return( TRUE );
}

BOOL NT_FPenClicked( void )
{
    ActivateGadget( NumTagGadgets[ GD_NT_BPen ], NumTagWnd, NULL );
    return( TRUE );
}

BOOL NT_BPenClicked( void )
{
    return( TRUE );
}

BOOL NT_FormatClicked( void )
{
    return( TRUE );
}

BOOL NT_PosTitKeyPressed( void )
{
    if( CycleTag[1] < 5 )
	CycleTag[1] += 1;
    else
	CycleTag[1] = 0;

    GT_SetGadgetAttrsA( NumTagGadgets[ GD_NT_PosTit ], NumTagWnd,
			NULL, (struct TagItem *)CycleTag );

    NumTagMsg.Code = CycleTag[1];

    return( NT_PosTitClicked() );
}

BOOL NT_PosTitClicked( void )
{
    ULONG   t;

    CycleTag[1] = NumTagMsg.Code;

    t = ((struct GadgetInfo *)buffer3)->g_Flags & 32;
    ((struct GadgetInfo *)buffer3)->g_Flags = t | gadget_flags[ NumTagMsg.Code ];

    return( TRUE );
}

BOOL NT_JustKeyPressed( void )
{
    if( CycleTag2[1] < 2 )
	CycleTag2[1] += 1;
    else
	CycleTag2[1] = 0;

    GT_SetGadgetAttrsA( NumTagGadgets[ GD_NT_Just ], NumTagWnd,
			NULL, (struct TagItem *)CycleTag2 );

    return( TRUE );
}

BOOL NT_JustClicked( void )
{
    CycleTag2[1] = NumTagMsg.Code;

    return( TRUE );
}

#undef gd
///
/// Parametri CYCLE
#define gd ((struct CK)(((struct GadgetInfo *)buffer3)->g_Data))

void ParametriCycle( struct GadgetInfo *gad )
{
    int     ret;

    LayoutWindow( CycTagWTags );
    ret = OpenCycTagWindow();
    PostOpenWindow( CycTagWTags );

    if( ret ) {
	DisplayBeep( Scr );
    } else {

	buffer3 = gad;

	StringTag[1] = gad->g_Titolo;
	GT_SetGadgetAttrsA( CycTagGadgets[ GD_CyT_Tit ], CycTagWnd,
			    NULL, (struct TagItem *)StringTag );

	StringTag[1] = gad->g_Label;
	GT_SetGadgetAttrsA( CycTagGadgets[ GD_CyT_Label ], CycTagWnd,
			    NULL, (struct TagItem *)StringTag );

	ret = 0;
	while((!( gadget_flags[ ret ] & gad->g_Flags )) && ret < 5 )
	    ret += 1;

	CycleTag[1] = ret;
	GT_SetGadgetAttrsA( CycTagGadgets[ GD_CyT_PosTit ], CycTagWnd,
			    NULL, (struct TagItem *)CycleTag );

	CheckedTag[1] = ( gad->g_Tags & 1 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( CycTagGadgets[ GD_CyT_Und ], CycTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Flags & NG_HIGHLABEL ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( CycTagGadgets[ GD_CyT_High ], CycTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Tags & 2 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( CycTagGadgets[ GD_CyT_Disab ], CycTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	IntegerTag[1] = gd.Act;
	GT_SetGadgetAttrsA( CycTagGadgets[ GD_CyT_Act ], CycTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	ActivateGadget( CycTagGadgets[ GD_CyT_Tit ], CycTagWnd, NULL );

	if( gad->g_Key )
	    IE.win_info->wi_NumKeys -= 1;

	buffer4 = (APTR)gad->g_Flags;
	buffer2 = gad->g_Tags;
	buffer  = FALSE;

	while( ReqHandle( CycTagWnd, HandleCycTagIDCMP ));
    }

    CloseCycTagWindow();
}

BOOL CyT_TitClicked( void )
{
    ActivateGadget( CycTagGadgets[ GD_CyT_Label ], CycTagWnd, NULL );
    return( TRUE );
}

BOOL CyT_LabelClicked( void )
{
    return( TRUE );
}

BOOL CycTagVanillaKey( void )
{
    switch( CycTagMsg.Code ) {
	case 13:
	    return( CyT_OkClicked() );
	case 27:
	    return( CyT_AnnullaClicked() );
    }
}

BOOL CyT_AnnullaKeyPressed( void )
{
    return( CyT_AnnullaClicked() );
}

BOOL CyT_AnnullaClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Flags = buffer4;
    ((struct GadgetInfo *)buffer3)->g_Tags  = buffer2;
    return( FALSE );
}

BOOL CyT_OkKeyPressed( void )
{
    return( CyT_OkClicked() );
}

BOOL CyT_OkClicked( void )
{
    buffer = TRUE;

    strcpy( ((struct GadgetInfo *)buffer3)->g_Titolo,
	    GetString( CycTagGadgets[ GD_CyT_Tit ]));

    STRPTR label;

    label = GetString( CycTagGadgets[ GD_CyT_Label ]);

    if( label[0] )
	strcpy( ((struct GadgetInfo *)buffer3)->g_Label, label );

    gd.Act  = GetNumber( CycTagGadgets[ GD_CyT_Act ]);

    return( FALSE );
}

BOOL CyT_UndKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 1 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( CycTagGadgets[ GD_CyT_Und ], CycTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( CyT_UndClicked() );
}

BOOL CyT_UndClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 1;
    return( TRUE );
}

BOOL CyT_HighKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Flags & NG_HIGHLABEL ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( CycTagGadgets[ GD_CyT_High ], CycTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( CyT_HighClicked() );
}

BOOL CyT_HighClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Flags ^= NG_HIGHLABEL;
    return( TRUE );
}

BOOL CyT_DisabKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 2 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( CycTagGadgets[ GD_CyT_Disab ], CycTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( CyT_DisabClicked() );
}

BOOL CyT_DisabClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 2;
    return( TRUE );
}

BOOL CyT_ActClicked( void )
{
    return( TRUE );
}

BOOL CyT_PosTitKeyPressed( void )
{
    if( CycleTag[1] < 5 )
	CycleTag[1] += 1;
    else
	CycleTag[1] = 0;

    GT_SetGadgetAttrsA( CycTagGadgets[ GD_CyT_PosTit ], CycTagWnd,
			NULL, (struct TagItem *)CycleTag );

    CycTagMsg.Code = CycleTag[1];

    return( CyT_PosTitClicked() );
}

BOOL CyT_PosTitClicked( void )
{
    ULONG   t;

    CycleTag[1] = CycTagMsg.Code;

    t = ((struct GadgetInfo *)buffer3)->g_Flags & 32;
    ((struct GadgetInfo *)buffer3)->g_Flags = t | gadget_flags[ CycTagMsg.Code ];

    return( TRUE );
}

#undef gd
///
/// Parametri PALETTE
#define gd ((struct PK)(((struct GadgetInfo *)buffer3)->g_Data))

void ParametriPalette( struct GadgetInfo *gad )
{
    int     ret;

    LayoutWindow( PalTagWTags );
    ret = OpenPalTagWindow();
    PostOpenWindow( PalTagWTags );

    if( ret ) {
	DisplayBeep( Scr );
    } else {

	buffer3 = gad;

	StringTag[1] = gad->g_Titolo;
	GT_SetGadgetAttrsA( PalTagGadgets[ GD_PT_Tit ], PalTagWnd,
			    NULL, (struct TagItem *)StringTag );

	StringTag[1] = gad->g_Label;
	GT_SetGadgetAttrsA( PalTagGadgets[ GD_PT_Label ], PalTagWnd,
			    NULL, (struct TagItem *)StringTag );

	ret = 0;
	while((!( gadget_flags[ ret ] & gad->g_Flags )) && ret < 5 )
	    ret += 1;

	CycleTag[1] = ret;
	GT_SetGadgetAttrsA( PalTagGadgets[ GD_PT_PosTit ], PalTagWnd,
			    NULL, (struct TagItem *)CycleTag );

	CheckedTag[1] = ( gad->g_Tags & 1 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( PalTagGadgets[ GD_PT_Und ], PalTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Flags & NG_HIGHLABEL ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( PalTagGadgets[ GD_PT_High ], PalTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Tags & 2 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( PalTagGadgets[ GD_PT_Disab ], PalTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	IntegerTag[1] = gd.Depth;
	GT_SetGadgetAttrsA( PalTagGadgets[ GD_PT_Depth ], PalTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = gd.Color;
	GT_SetGadgetAttrsA( PalTagGadgets[ GD_PT_Col ], PalTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = gd.ColOff;
	GT_SetGadgetAttrsA( PalTagGadgets[ GD_PT_COff ], PalTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = gd.NumCol;
	GT_SetGadgetAttrsA( PalTagGadgets[ GD_PT_NumC ], PalTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = gd.IW;
	GT_SetGadgetAttrsA( PalTagGadgets[ GD_PT_IW ], PalTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = gd.IH;
	GT_SetGadgetAttrsA( PalTagGadgets[ GD_PT_IH ], PalTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	ActivateGadget( PalTagGadgets[ GD_PT_Tit ], PalTagWnd, NULL );

	if( gad->g_Key )
	    IE.win_info->wi_NumKeys -= 1;

	buffer4 = (APTR)gad->g_Flags;
	buffer2 = gad->g_Tags;
	buffer  = FALSE;

	while( ReqHandle( PalTagWnd, HandlePalTagIDCMP ));
    }

    ClosePalTagWindow();
}

BOOL PT_TitClicked( void )
{
    ActivateGadget( PalTagGadgets[ GD_PT_Label ], PalTagWnd, NULL );
    return( TRUE );
}

BOOL PT_LabelClicked( void )
{
    return( TRUE );
}

BOOL PalTagVanillaKey( void )
{
    switch( PalTagMsg.Code ) {
	case 13:
	    return( PT_OkClicked() );
	case 27:
	    return( PT_AnnullaClicked() );
    }
}

BOOL PT_AnnullaKeyPressed( void )
{
    return( PT_AnnullaClicked() );
}

BOOL PT_AnnullaClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Flags = buffer4;
    ((struct GadgetInfo *)buffer3)->g_Tags  = buffer2;
    return( FALSE );
}

BOOL PT_OkKeyPressed( void )
{
    return( PT_OkClicked() );
}

BOOL PT_OkClicked( void )
{
    buffer = TRUE;

    strcpy( ((struct GadgetInfo *)buffer3)->g_Titolo,
	    GetString( PalTagGadgets[ GD_PT_Tit ]));

    STRPTR label;

    label = GetString( PalTagGadgets[ GD_PT_Label ]);

    if( label[0] )
	strcpy( ((struct GadgetInfo *)buffer3)->g_Label, label );

    gd.Depth  = GetNumber( PalTagGadgets[ GD_PT_Depth ]);
    gd.Color  = GetNumber( PalTagGadgets[ GD_PT_Col   ]);
    gd.ColOff = GetNumber( PalTagGadgets[ GD_PT_COff  ]);
    gd.NumCol = GetNumber( PalTagGadgets[ GD_PT_NumC  ]);
    gd.IW     = GetNumber( PalTagGadgets[ GD_PT_IW    ]);
    gd.IH     = GetNumber( PalTagGadgets[ GD_PT_IH    ]);

    return( FALSE );
}

BOOL PT_UndKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 1 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( PalTagGadgets[ GD_PT_Und ], PalTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( PT_UndClicked() );
}

BOOL PT_UndClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 1;
    return( TRUE );
}

BOOL PT_HighKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Flags & NG_HIGHLABEL ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( PalTagGadgets[ GD_PT_High ], PalTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( PT_HighClicked() );
}

BOOL PT_HighClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Flags ^= NG_HIGHLABEL;
    return( TRUE );
}

BOOL PT_DisabKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 2 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( PalTagGadgets[ GD_PT_Disab ], PalTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( PT_DisabClicked() );
}

BOOL PT_DisabClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 2;
    return( TRUE );
}

BOOL PT_DepthClicked( void )
{
    ActivateGadget( PalTagGadgets[ GD_PT_Col ], PalTagWnd, NULL );
    return( TRUE );
}

BOOL PT_ColClicked( void )
{
    ActivateGadget( PalTagGadgets[ GD_PT_COff ], PalTagWnd, NULL );
    return( TRUE );
}

BOOL PT_COffClicked( void )
{
    ActivateGadget( PalTagGadgets[ GD_PT_NumC ], PalTagWnd, NULL );
    return( TRUE );
}

BOOL PT_NumCClicked( void )
{
    return( TRUE );
}

BOOL PT_IWClicked( void )
{
    ActivateGadget( PalTagGadgets[ GD_PT_IH ], PalTagWnd, NULL );
    return( TRUE );
}

BOOL PT_IHClicked( void )
{
    return( TRUE );
}

BOOL PT_PosTitKeyPressed( void )
{
    if( CycleTag[1] < 5 )
	CycleTag[1] += 1;
    else
	CycleTag[1] = 0;

    GT_SetGadgetAttrsA( PalTagGadgets[ GD_PT_PosTit ], PalTagWnd,
			NULL, (struct TagItem *)CycleTag );

    PalTagMsg.Code = CycleTag[1];

    return( PT_PosTitClicked() );
}

BOOL PT_PosTitClicked( void )
{
    ULONG   t;

    CycleTag[1] = PalTagMsg.Code;

    t = ((struct GadgetInfo *)buffer3)->g_Flags & 32;
    ((struct GadgetInfo *)buffer3)->g_Flags = t | gadget_flags[ PalTagMsg.Code ];

    return( TRUE );
}

#undef gd
///
/// Parametri SCROLLER
#define gd ((struct SK)(((struct GadgetInfo *)buffer3)->g_Data))

void ParametriScroller( struct GadgetInfo *gad )
{
    int     ret;

    LayoutWindow( SclTagWTags );
    ret = OpenSclTagWindow();
    PostOpenWindow( SclTagWTags );

    if( ret ) {
	DisplayBeep( Scr );
    } else {

	buffer3 = gad;

	StringTag[1] = gad->g_Titolo;
	GT_SetGadgetAttrsA( SclTagGadgets[ GD_ST_Tit ], SclTagWnd,
			    NULL, (struct TagItem *)StringTag );

	StringTag[1] = gad->g_Label;
	GT_SetGadgetAttrsA( SclTagGadgets[ GD_ST_Label ], SclTagWnd,
			    NULL, (struct TagItem *)StringTag );

	ret = 0;
	while((!( gadget_flags[ ret ] & gad->g_Flags )) && ret < 5 )
	    ret += 1;

	CycleTag[1] = ret;
	GT_SetGadgetAttrsA( SclTagGadgets[ GD_ST_PosTit ], SclTagWnd,
			    NULL, (struct TagItem *)CycleTag );

	CheckedTag[1] = ( gad->g_Tags & 1 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( SclTagGadgets[ GD_ST_Und ], SclTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Flags & NG_HIGHLABEL ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( SclTagGadgets[ GD_ST_High ], SclTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Tags & 2 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( SclTagGadgets[ GD_ST_Disab ], SclTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Tags & 4 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( SclTagGadgets[ GD_ST_RelVer ], SclTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Tags & 8 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( SclTagGadgets[ GD_ST_Imm ], SclTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	IntegerTag[1] = gd.Top;
	GT_SetGadgetAttrsA( SclTagGadgets[ GD_ST_Top ], SclTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = gd.Tot;
	GT_SetGadgetAttrsA( SclTagGadgets[ GD_ST_Tot ], SclTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = gd.Vis;
	GT_SetGadgetAttrsA( SclTagGadgets[ GD_ST_Vis ], SclTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = gd.Arr;
	GT_SetGadgetAttrsA( SclTagGadgets[ GD_ST_Arrows ], SclTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	MXTag[1] = gd.Free;
	GT_SetGadgetAttrsA( SclTagGadgets[ GD_ST_Free ], SclTagWnd,
			    NULL, (struct TagItem *)MXTag );

	ActivateGadget( SclTagGadgets[ GD_ST_Tit ], SclTagWnd, NULL );

	if( gad->g_Key )
	    IE.win_info->wi_NumKeys -= 1;

	buffer4 = (APTR)gad->g_Flags;
	buffer2 = gad->g_Tags;
	buffer  = FALSE;

	while( ReqHandle( SclTagWnd, HandleSclTagIDCMP ));
    }

    CloseSclTagWindow();
}

BOOL ST_TitClicked( void )
{
    ActivateGadget( SclTagGadgets[ GD_ST_Label ], SclTagWnd, NULL );
    return( TRUE );
}

BOOL ST_LabelClicked( void )
{
    return( TRUE );
}

BOOL SclTagVanillaKey( void )
{
    switch( SclTagMsg.Code ) {
	case 13:
	    return( ST_OkClicked() );
	case 27:
	    return( ST_AnnullaClicked() );
    }
}

BOOL ST_AnnullaKeyPressed( void )
{
    return( ST_AnnullaClicked() );
}

BOOL ST_AnnullaClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Flags = buffer4;
    ((struct GadgetInfo *)buffer3)->g_Tags  = buffer2;
    return( FALSE );
}

BOOL ST_OkKeyPressed( void )
{
    return( ST_OkClicked() );
}

BOOL ST_OkClicked( void )
{
    buffer = TRUE;

    strcpy( ((struct GadgetInfo *)buffer3)->g_Titolo,
	    GetString( SclTagGadgets[ GD_ST_Tit ]));

    STRPTR label;

    label = GetString( SclTagGadgets[ GD_ST_Label ]);

    if( label[0] )
	strcpy( ((struct GadgetInfo *)buffer3)->g_Label, label );

    gd.Top  = GetNumber( SclTagGadgets[ GD_ST_Top ]);
    gd.Tot  = GetNumber( SclTagGadgets[ GD_ST_Tot ]);
    gd.Vis  = GetNumber( SclTagGadgets[ GD_ST_Vis  ]);
    gd.Arr  = GetNumber( SclTagGadgets[ GD_ST_Arrows  ]);
//    gd.Free = MXTag[1];

    return( FALSE );
}

BOOL ST_UndKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 1 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( SclTagGadgets[ GD_ST_Und ], SclTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( ST_UndClicked() );
}

BOOL ST_UndClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 1;
    return( TRUE );
}

BOOL ST_HighKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Flags & NG_HIGHLABEL ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( SclTagGadgets[ GD_ST_High ], SclTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( ST_HighClicked() );
}

BOOL ST_HighClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Flags ^= NG_HIGHLABEL;
    return( TRUE );
}

BOOL ST_DisabKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 2 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( SclTagGadgets[ GD_ST_Disab ], SclTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( ST_DisabClicked() );
}

BOOL ST_DisabClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 2;
    return( TRUE );
}

BOOL ST_RelVerKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 4 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( SclTagGadgets[ GD_ST_RelVer ], SclTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( ST_RelVerClicked() );
}

BOOL ST_RelVerClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 4;
    return( TRUE );
}

BOOL ST_ImmKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 8 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( SclTagGadgets[ GD_ST_Imm ], SclTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( ST_ImmClicked() );
}

BOOL ST_ImmClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 8;
    return( TRUE );
}

BOOL ST_TopClicked( void )
{
    ActivateGadget( SclTagGadgets[ GD_ST_Tot ], SclTagWnd, NULL );
    return( TRUE );
}

BOOL ST_TotClicked( void )
{
    ActivateGadget( SclTagGadgets[ GD_ST_Vis ], SclTagWnd, NULL );
    return( TRUE );
}

BOOL ST_VisClicked( void )
{
    ActivateGadget( SclTagGadgets[ GD_ST_Arrows ], SclTagWnd, NULL );
    return( TRUE );
}

BOOL ST_ArrowsClicked( void )
{
    return( TRUE );
}

BOOL ST_PosTitKeyPressed( void )
{
    if( CycleTag[1] < 5 )
	CycleTag[1] += 1;
    else
	CycleTag[1] = 0;

    GT_SetGadgetAttrsA( SclTagGadgets[ GD_ST_PosTit ], SclTagWnd,
			NULL, (struct TagItem *)CycleTag );

    SclTagMsg.Code = CycleTag[1];

    return( ST_PosTitClicked() );
}

BOOL ST_PosTitClicked( void )
{
    ULONG   t;

    CycleTag[1] = SclTagMsg.Code;

    t = ((struct GadgetInfo *)buffer3)->g_Flags & 32;
    ((struct GadgetInfo *)buffer3)->g_Flags = t | gadget_flags[ SclTagMsg.Code ];

    return( TRUE );
}

BOOL ST_FreeKeyPressed( void )
{
    if( MXTag[1] == 0 )
	MXTag[1] = 1;
    else
	MXTag[1] = 0;

    GT_SetGadgetAttrsA( SclTagGadgets[ GD_ST_Free ], SclTagWnd,
			NULL, (struct TagItem *)MXTag );

    gd.Free = MXTag[1];

    return( TRUE );
}

BOOL ST_FreeClicked( void )
{
    return( ST_FreeKeyPressed() );
}

#undef gd
///
/// Parametri SLIDER
#define gd ((struct SlK)(((struct GadgetInfo *)buffer3)->g_Data))

void ParametriSlider( struct GadgetInfo *gad )
{
    int     ret;

    LayoutWindow( SliTagWTags );
    ret = OpenSliTagWindow();
    PostOpenWindow( SliTagWTags );

    if( ret ) {
	DisplayBeep( Scr );
    } else {

	buffer3 = gad;

	StringTag[1] = gad->g_Titolo;
	GT_SetGadgetAttrsA( SliTagGadgets[ GD_SlT_Tit ], SliTagWnd,
			    NULL, (struct TagItem *)StringTag );

	StringTag[1] = gad->g_Label;
	GT_SetGadgetAttrsA( SliTagGadgets[ GD_SlT_Label ], SliTagWnd,
			    NULL, (struct TagItem *)StringTag );

	ret = 0;
	while((!( gadget_flags[ ret ] & gad->g_Flags )) && ret < 5 )
	    ret += 1;

	CycleTag[1] = ret;
	GT_SetGadgetAttrsA( SliTagGadgets[ GD_SlT_PosTit ], SliTagWnd,
			    NULL, (struct TagItem *)CycleTag );

	CheckedTag[1] = ( gad->g_Tags & 1 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( SliTagGadgets[ GD_SlT_Und ], SliTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Flags & NG_HIGHLABEL ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( SliTagGadgets[ GD_SlT_High ], SliTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Tags & 2 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( SliTagGadgets[ GD_SlT_Disab ], SliTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Tags & 4 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( SliTagGadgets[ GD_SlT_RelVer ], SliTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Tags & 8 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( SliTagGadgets[ GD_SlT_Imm ], SliTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	IntegerTag[1] = gd.Min;
	GT_SetGadgetAttrsA( SliTagGadgets[ GD_SlT_Min ], SliTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = gd.Max;
	GT_SetGadgetAttrsA( SliTagGadgets[ GD_SlT_Max ], SliTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = gd.Level;
	GT_SetGadgetAttrsA( SliTagGadgets[ GD_SlT_Lev ], SliTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = gd.MLL;
	GT_SetGadgetAttrsA( SliTagGadgets[ GD_SlT_MLL ], SliTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = gd.MPL;
	GT_SetGadgetAttrsA( SliTagGadgets[ GD_SlT_MPL ], SliTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	StringTag[1] = gd.Format;
	GT_SetGadgetAttrsA( SliTagGadgets[ GD_SlT_Fmt ], SliTagWnd,
			    NULL, (struct TagItem *)StringTag );

	MXTag[1] = gd.Free;
	GT_SetGadgetAttrsA( SliTagGadgets[ GD_SlT_Free ], SliTagWnd,
			    NULL, (struct TagItem *)MXTag );

	CycleTag2[1] = gd.Just;
	GT_SetGadgetAttrsA( SliTagGadgets[ GD_SlT_Just ], SliTagWnd,
			    NULL, (struct TagItem *)CycleTag2 );

	CycleTag3[1] = gd.LevPlc;
	GT_SetGadgetAttrsA( SliTagGadgets[ GD_SlT_LevPlc ], SliTagWnd,
			    NULL, (struct TagItem *)CycleTag3 );

	ActivateGadget( SliTagGadgets[ GD_SlT_Tit ], SliTagWnd, NULL );

	if( gad->g_Key )
	    IE.win_info->wi_NumKeys -= 1;

	buffer4 = (APTR)gad->g_Flags;
	buffer2 = gad->g_Tags;
	buffer  = FALSE;

	while( ReqHandle( SliTagWnd, HandleSliTagIDCMP ));
    }

    CloseSliTagWindow();
}

BOOL SlT_TitClicked( void )
{
    ActivateGadget( SliTagGadgets[ GD_SlT_Label ], SliTagWnd, NULL );
    return( TRUE );
}

BOOL SlT_LabelClicked( void )
{
    return( TRUE );
}

BOOL SliTagVanillaKey( void )
{
    switch( SliTagMsg.Code ) {
	case 13:
	    return( SlT_OkClicked() );
	case 27:
	    return( SlT_AnnullaClicked() );
    }
}

BOOL SlT_AnnullaKeyPressed( void )
{
    return( SlT_AnnullaClicked() );
}

BOOL SlT_AnnullaClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Flags = buffer4;
    ((struct GadgetInfo *)buffer3)->g_Tags  = buffer2;
    return( FALSE );
}

BOOL SlT_OkKeyPressed( void )
{
    return( SlT_OkClicked() );
}

BOOL SlT_OkClicked( void )
{
    buffer = TRUE;

    strcpy( ((struct GadgetInfo *)buffer3)->g_Titolo,
	    GetString( SliTagGadgets[ GD_SlT_Tit ]));

    STRPTR label;

    label = GetString( SliTagGadgets[ GD_SlT_Label ]);

    if( label[0] )
	strcpy( ((struct GadgetInfo *)buffer3)->g_Label, label );

    strcpy( gd.Format, GetString( SliTagGadgets[ GD_SlT_Fmt ]));

    gd.Min    = GetNumber( SliTagGadgets[ GD_SlT_Min ]);
    gd.Max    = GetNumber( SliTagGadgets[ GD_SlT_Max ]);
    gd.Level  = GetNumber( SliTagGadgets[ GD_SlT_Lev ]);
    gd.MLL    = GetNumber( SliTagGadgets[ GD_SlT_MLL ]);
    gd.MPL    = GetNumber( SliTagGadgets[ GD_SlT_MPL ]);
    gd.Free   = MXTag[1];
    gd.Just   = CycleTag2[1];
    gd.LevPlc = CycleTag3[1];

    return( FALSE );
}

BOOL SlT_UndKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 1 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( SliTagGadgets[ GD_SlT_Und ], SliTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( SlT_UndClicked() );
}

BOOL SlT_UndClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 1;
    return( TRUE );
}

BOOL SlT_HighKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Flags & NG_HIGHLABEL ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( SliTagGadgets[ GD_SlT_High ], SliTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( SlT_HighClicked() );
}

BOOL SlT_HighClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Flags ^= NG_HIGHLABEL;
    return( TRUE );
}

BOOL SlT_DisabKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 2 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( SliTagGadgets[ GD_SlT_Disab ], SliTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( SlT_DisabClicked() );
}

BOOL SlT_DisabClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 2;
    return( TRUE );
}

BOOL SlT_RelVerKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 4 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( SliTagGadgets[ GD_SlT_RelVer ], SliTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( SlT_RelVerClicked() );
}

BOOL SlT_RelVerClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 4;
    return( TRUE );
}

BOOL SlT_ImmKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 8 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( SliTagGadgets[ GD_SlT_Imm ], SliTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( SlT_ImmClicked() );
}

BOOL SlT_ImmClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 8;
    return( TRUE );
}

BOOL SlT_MinClicked( void )
{
    ActivateGadget( SliTagGadgets[ GD_SlT_Max ], SliTagWnd, NULL );
    return( TRUE );
}

BOOL SlT_MaxClicked( void )
{
    ActivateGadget( SliTagGadgets[ GD_SlT_Lev ], SliTagWnd, NULL );
    return( TRUE );
}

BOOL SlT_LevClicked( void )
{
    return( TRUE );
}

BOOL SlT_MLLClicked( void )
{
    ActivateGadget( SliTagGadgets[ GD_SlT_Fmt ], SliTagWnd, NULL );
    return( TRUE );
}

BOOL SlT_FmtClicked( void )
{
    ActivateGadget( SliTagGadgets[ GD_SlT_MPL ], SliTagWnd, NULL );
    return( TRUE );
}

BOOL SlT_MPLClicked( void )
{
    return( TRUE );
}

BOOL SlT_PosTitKeyPressed( void )
{
    if( CycleTag[1] < 5 )
	CycleTag[1] += 1;
    else
	CycleTag[1] = 0;

    GT_SetGadgetAttrsA( SliTagGadgets[ GD_SlT_PosTit ], SliTagWnd,
			NULL, (struct TagItem *)CycleTag );

    SliTagMsg.Code = CycleTag[1];

    return( SlT_PosTitClicked() );
}

BOOL SlT_PosTitClicked( void )
{
    ULONG   t;

    CycleTag[1] = SliTagMsg.Code;

    t = ((struct GadgetInfo *)buffer3)->g_Flags & 32;
    ((struct GadgetInfo *)buffer3)->g_Flags = t | gadget_flags[ SliTagMsg.Code ];

    return( TRUE );
}

BOOL SlT_FreeKeyPressed( void )
{
    if( MXTag[1] == 0 )
	MXTag[1] = 1;
    else
	MXTag[1] = 0;

    GT_SetGadgetAttrsA( SliTagGadgets[ GD_SlT_Free ], SliTagWnd,
			NULL, (struct TagItem *)MXTag );

    return( TRUE );
}

BOOL SlT_FreeClicked( void )
{
    return( SlT_FreeKeyPressed() );
}

BOOL SlT_JustKeyPressed( void )
{
    if( CycleTag2[1] < 2 )
	CycleTag2[1] += 1;
    else
	CycleTag2[1] = 0;

    GT_SetGadgetAttrsA( SliTagGadgets[ GD_SlT_Just ], SliTagWnd,
			NULL, (struct TagItem *)CycleTag2 );

    return( TRUE );
}

BOOL SlT_JustClicked( void )
{
    CycleTag2[1] = SliTagMsg.Code;

    return( TRUE );
}

BOOL SlT_LevPlcKeyPressed( void )
{
    if( CycleTag3[1] < 2 )
	CycleTag3[1] += 1;
    else
	CycleTag3[1] = 0;

    GT_SetGadgetAttrsA( SliTagGadgets[ GD_SlT_LevPlc ], SliTagWnd,
			NULL, (struct TagItem *)CycleTag3 );

    return( TRUE );
}

BOOL SlT_LevPlcClicked( void )
{
    CycleTag3[1] = SliTagMsg.Code;

    return( TRUE );
}

#undef gd
///
/// Parametri STRING
#define gd ((struct StK)(((struct GadgetInfo *)buffer3)->g_Data))

void ParametriString( struct GadgetInfo *gad )
{
    int     ret;

    LayoutWindow( StrTagWTags );
    ret = OpenStrTagWindow();
    PostOpenWindow( StrTagWTags );

    if( ret ) {
	DisplayBeep( Scr );
    } else {

	buffer3 = gad;

	StringTag[1] = gad->g_Titolo;
	GT_SetGadgetAttrsA( StrTagGadgets[ GD_StrT_Tit ], StrTagWnd,
			    NULL, (struct TagItem *)StringTag );

	StringTag[1] = gad->g_Label;
	GT_SetGadgetAttrsA( StrTagGadgets[ GD_StrT_Label ], StrTagWnd,
			    NULL, (struct TagItem *)StringTag );

	ret = 0;
	while((!( gadget_flags[ ret ] & gad->g_Flags )) && ret < 5 )
	    ret += 1;

	CycleTag[1] = ret;
	GT_SetGadgetAttrsA( StrTagGadgets[ GD_StrT_PosTit ], StrTagWnd,
			    NULL, (struct TagItem *)CycleTag );

	CheckedTag[1] = ( gad->g_Tags & 1 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( StrTagGadgets[ GD_StrT_Und ], StrTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Flags & NG_HIGHLABEL ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( StrTagGadgets[ GD_StrT_High ], StrTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Tags & 2 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( StrTagGadgets[ GD_StrT_Disab ], StrTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Tags & 4 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( StrTagGadgets[ GD_StrT_Imm ], StrTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Tags & 8 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( StrTagGadgets[ GD_StrT_Tab ], StrTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Tags & 0x10 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( StrTagGadgets[ GD_StrT_Help ], StrTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Tags & 0x20 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( StrTagGadgets[ GD_StrT_Rep ], StrTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	IntegerTag[1] = gd.MaxC;
	GT_SetGadgetAttrsA( StrTagGadgets[ GD_StrT_MaxC ], StrTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	StringTag[1] = gad->g_ExtraMem;
	GT_SetGadgetAttrsA( StrTagGadgets[ GD_StrT_Str ], StrTagWnd,
			    NULL, (struct TagItem *)StringTag );

	CycleTag2[1] = gd.Just;
	GT_SetGadgetAttrsA( StrTagGadgets[ GD_StrT_Just ], StrTagWnd,
			    NULL, (struct TagItem *)CycleTag2 );

	ActivateGadget( StrTagGadgets[ GD_StrT_Tit ], StrTagWnd, NULL );

	if( gad->g_Key )
	    IE.win_info->wi_NumKeys -= 1;

	buffer4 = (APTR)gad->g_Flags;
	buffer2 = gad->g_Tags;
	buffer  = FALSE;

	while( ReqHandle( StrTagWnd, HandleStrTagIDCMP ));
    }

    CloseStrTagWindow();
}

BOOL StrT_TitClicked( void )
{
    ActivateGadget( StrTagGadgets[ GD_StrT_Label ], StrTagWnd, NULL );
    return( TRUE );
}

BOOL StrT_LabelClicked( void )
{
    return( TRUE );
}

BOOL StrTagVanillaKey( void )
{
    switch( StrTagMsg.Code ) {
	case 13:
	    return( StrT_OkClicked() );
	case 27:
	    return( StrT_AnnullaClicked() );
    }
}

BOOL StrT_AnnullaKeyPressed( void )
{
    return( StrT_AnnullaClicked() );
}

BOOL StrT_AnnullaClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Flags = buffer4;
    ((struct GadgetInfo *)buffer3)->g_Tags  = buffer2;
    return( FALSE );
}

BOOL StrT_OkKeyPressed( void )
{
    return( StrT_OkClicked() );
}

BOOL StrT_OkClicked( void )
{
    buffer = TRUE;

    strcpy( ((struct GadgetInfo *)buffer3)->g_Titolo,
	    GetString( StrTagGadgets[ GD_StrT_Tit ]));

    STRPTR label;

    label = GetString( StrTagGadgets[ GD_StrT_Label ]);

    if( label[0] )
	strcpy( ((struct GadgetInfo *)buffer3)->g_Label, label );

    strcpy( ((struct GadgetInfo *)buffer3)->g_ExtraMem,
	    GetString( StrTagGadgets[ GD_StrT_Str ]));

    gd.MaxC = GetNumber( StrTagGadgets[ GD_StrT_MaxC ]);
    gd.Just = CycleTag2[1];

    return( FALSE );
}

BOOL StrT_UndKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 1 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( StrTagGadgets[ GD_StrT_Und ], StrTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( StrT_UndClicked() );
}

BOOL StrT_UndClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 1;
    return( TRUE );
}

BOOL StrT_HighKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Flags & NG_HIGHLABEL ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( StrTagGadgets[ GD_StrT_High ], StrTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( StrT_HighClicked() );
}

BOOL StrT_HighClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Flags ^= NG_HIGHLABEL;
    return( TRUE );
}

BOOL StrT_DisabKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 2 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( StrTagGadgets[ GD_StrT_Disab ], StrTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( StrT_DisabClicked() );
}

BOOL StrT_DisabClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 2;
    return( TRUE );
}

BOOL StrT_ImmKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 4 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( StrTagGadgets[ GD_StrT_Imm ], StrTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( StrT_ImmClicked() );
}

BOOL StrT_ImmClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 4;
    return( TRUE );
}

BOOL StrT_TabKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 8 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( StrTagGadgets[ GD_StrT_Tab ], StrTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( StrT_TabClicked() );
}

BOOL StrT_TabClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 8;
    return( TRUE );
}

BOOL StrT_HelpKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 0x10 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( StrTagGadgets[ GD_StrT_Help ], StrTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( StrT_HelpClicked() );
}

BOOL StrT_HelpClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 0x10;
    return( TRUE );
}

BOOL StrT_RepKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 0x20 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( StrTagGadgets[ GD_StrT_Rep ], StrTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( StrT_RepClicked() );
}

BOOL StrT_RepClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 0x20;
    return( TRUE );
}

BOOL StrT_MaxCClicked( void )
{
    ActivateGadget( StrTagGadgets[ GD_StrT_Str ], StrTagWnd, NULL );
    return( TRUE );
}

BOOL StrT_StrClicked( void )
{
    return( TRUE );
}

BOOL StrT_PosTitKeyPressed( void )
{
    if( CycleTag[1] < 5 )
	CycleTag[1] += 1;
    else
	CycleTag[1] = 0;

    GT_SetGadgetAttrsA( StrTagGadgets[ GD_StrT_PosTit ], StrTagWnd,
			NULL, (struct TagItem *)CycleTag );

    StrTagMsg.Code = CycleTag[1];

    return( StrT_PosTitClicked() );
}

BOOL StrT_PosTitClicked( void )
{
    ULONG   t;

    CycleTag[1] = StrTagMsg.Code;

    t = ((struct GadgetInfo *)buffer3)->g_Flags & 32;
    ((struct GadgetInfo *)buffer3)->g_Flags = t | gadget_flags[ StrTagMsg.Code ];

    return( TRUE );
}

BOOL StrT_JustKeyPressed( void )
{
    if( CycleTag2[1] < 2 )
	CycleTag2[1] += 1;
    else
	CycleTag2[1] = 0;

    GT_SetGadgetAttrsA( StrTagGadgets[ GD_StrT_Just ], StrTagWnd,
			NULL, (struct TagItem *)CycleTag2 );

    return( TRUE );
}

BOOL StrT_JustClicked( void )
{
    CycleTag2[1] = StrTagMsg.Code;

    return( TRUE );
}

#undef gd
///
/// Parametri TEXT
#define gd ((struct TK)(((struct GadgetInfo *)buffer3)->g_Data))

void ParametriText( struct GadgetInfo *gad )
{
    int     ret;

    LayoutWindow( TxtTagWTags );
    ret = OpenTxtTagWindow();
    PostOpenWindow( TxtTagWTags );

    if( ret ) {
	DisplayBeep( Scr );
    } else {

	buffer3 = gad;

	StringTag[1] = gad->g_Titolo;
	GT_SetGadgetAttrsA( TxtTagGadgets[ GD_TT_Tit ], TxtTagWnd,
			    NULL, (struct TagItem *)StringTag );

	StringTag[1] = gad->g_Label;
	GT_SetGadgetAttrsA( TxtTagGadgets[ GD_TT_Label ], TxtTagWnd,
			    NULL, (struct TagItem *)StringTag );

	ret = 0;
	while((!( gadget_flags[ ret ] & gad->g_Flags )) && ret < 5 )
	    ret += 1;

	CycleTag[1] = ret;
	GT_SetGadgetAttrsA( TxtTagGadgets[ GD_TT_PosTit ], TxtTagWnd,
			    NULL, (struct TagItem *)CycleTag );

	CheckedTag[1] = ( gad->g_Tags & 1 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( TxtTagGadgets[ GD_TT_Und ], TxtTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Flags & NG_HIGHLABEL ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( TxtTagGadgets[ GD_TT_High ], TxtTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Tags & 2 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( TxtTagGadgets[ GD_TT_Copy ], TxtTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Tags & 4 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( TxtTagGadgets[ GD_TT_Border ], TxtTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->g_Tags & 8 ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( TxtTagGadgets[ GD_TT_Clip ], TxtTagWnd,
			    NULL, (struct TagItem *)CheckedTag );

	IntegerTag[1] = gd.FPen;
	GT_SetGadgetAttrsA( TxtTagGadgets[ GD_TT_FPen ], TxtTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = gd.BPen;
	GT_SetGadgetAttrsA( TxtTagGadgets[ GD_TT_BPen ], TxtTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	StringTag[1] = gad->g_ExtraMem;
	GT_SetGadgetAttrsA( TxtTagGadgets[ GD_TT_Txt ], TxtTagWnd,
			    NULL, (struct TagItem *)StringTag );

	CycleTag2[1] = gd.Just;
	GT_SetGadgetAttrsA( TxtTagGadgets[ GD_TT_Just ], TxtTagWnd,
			    NULL, (struct TagItem *)CycleTag2 );

	ActivateGadget( TxtTagGadgets[ GD_TT_Tit ], TxtTagWnd, NULL );

	if( gad->g_Key )
	    IE.win_info->wi_NumKeys -= 1;

	buffer4 = (APTR)gad->g_Flags;
	buffer2 = gad->g_Tags;
	buffer  = FALSE;

	while( ReqHandle( TxtTagWnd, HandleTxtTagIDCMP ));
    }

    CloseTxtTagWindow();
}

BOOL TT_TitClicked( void )
{
    ActivateGadget( TxtTagGadgets[ GD_TT_Label ], TxtTagWnd, NULL );
    return( TRUE );
}

BOOL TT_LabelClicked( void )
{
    return( TRUE );
}

BOOL TxtTagVanillaKey( void )
{
    switch( TxtTagMsg.Code ) {
	case 13:
	    return( TT_OkClicked() );
	case 27:
	    return( TT_AnnullaClicked() );
    }
}

BOOL TT_AnnullaKeyPressed( void )
{
    return( TT_AnnullaClicked() );
}

BOOL TT_AnnullaClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Flags = buffer4;
    ((struct GadgetInfo *)buffer3)->g_Tags  = buffer2;
    return( FALSE );
}

BOOL TT_OkKeyPressed( void )
{
    return( TT_OkClicked() );
}

BOOL TT_OkClicked( void )
{
    STRPTR label;

    buffer = TRUE;

    strcpy( ((struct GadgetInfo *)buffer3)->g_Titolo,
	    GetString( TxtTagGadgets[ GD_TT_Tit ]));

    label = GetString( TxtTagGadgets[ GD_TT_Label ]);

    if( label[0] )
	strcpy( ((struct GadgetInfo *)buffer3)->g_Label, label );

    strcpy( ((struct GadgetInfo *)buffer3)->g_ExtraMem,
	    GetString( TxtTagGadgets[ GD_TT_Txt ]));

    gd.FPen = GetNumber( TxtTagGadgets[ GD_TT_FPen ]);
    gd.BPen = GetNumber( TxtTagGadgets[ GD_TT_BPen ]);
    gd.Just = CycleTag2[1];

    return( FALSE );
}

BOOL TT_UndKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 1 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( TxtTagGadgets[ GD_TT_Und ], TxtTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( TT_UndClicked() );
}

BOOL TT_UndClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 1;
    return( TRUE );
}

BOOL TT_HighKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Flags & NG_HIGHLABEL ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( TxtTagGadgets[ GD_TT_High ], TxtTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( TT_HighClicked() );
}

BOOL TT_HighClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Flags ^= NG_HIGHLABEL;
    return( TRUE );
}

BOOL TT_CopyKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 2 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( TxtTagGadgets[ GD_TT_Copy ], TxtTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( TT_CopyClicked() );
}

BOOL TT_CopyClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 2;
    return( TRUE );
}

BOOL TT_BorderKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 4 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( TxtTagGadgets[ GD_TT_Border ], TxtTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( TT_BorderClicked() );
}

BOOL TT_BorderClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 4;
    return( TRUE );
}

BOOL TT_ClipKeyPressed( void )
{
    CheckedTag[1] = (((struct GadgetInfo *)buffer3)->g_Tags & 8 ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( TxtTagGadgets[ GD_TT_Clip ], TxtTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( TT_ClipClicked() );
}

BOOL TT_ClipClicked( void )
{
    ((struct GadgetInfo *)buffer3)->g_Tags ^= 8;
    return( TRUE );
}

BOOL TT_FPenClicked( void )
{
    ActivateGadget( TxtTagGadgets[ GD_TT_BPen ], TxtTagWnd, NULL );
    return( TRUE );
}

BOOL TT_BPenClicked( void )
{
    ActivateGadget( TxtTagGadgets[ GD_TT_Txt ], TxtTagWnd, NULL );
    return( TRUE );
}

BOOL TT_TxtClicked( void )
{
    return( TRUE );
}

BOOL TT_PosTitKeyPressed( void )
{
    if( CycleTag[1] < 5 )
	CycleTag[1] += 1;
    else
	CycleTag[1] = 0;

    GT_SetGadgetAttrsA( TxtTagGadgets[ GD_TT_PosTit ], TxtTagWnd,
			NULL, (struct TagItem *)CycleTag );

    TxtTagMsg.Code = CycleTag[1];

    return( TT_PosTitClicked() );
}

BOOL TT_PosTitClicked( void )
{
    ULONG   t;

    CycleTag[1] = TxtTagMsg.Code;

    t = ((struct GadgetInfo *)buffer3)->g_Flags & 32;
    ((struct GadgetInfo *)buffer3)->g_Flags = t | gadget_flags[ TxtTagMsg.Code ];

    return( TRUE );
}

BOOL TT_JustKeyPressed( void )
{
    if( CycleTag2[1] < 2 )
	CycleTag2[1] += 1;
    else
	CycleTag2[1] = 0;

    GT_SetGadgetAttrsA( TxtTagGadgets[ GD_TT_Just ], TxtTagWnd,
			NULL, (struct TagItem *)CycleTag2 );

    return( TRUE );
}

BOOL TT_JustClicked( void )
{
    CycleTag2[1] = TxtTagMsg.Code;

    return( TRUE );
}

#undef gd
///
