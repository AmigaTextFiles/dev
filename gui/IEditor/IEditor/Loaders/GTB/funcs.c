/*
	GTB.loader
	Copyright ©1996 Simone Tellini
	     All Rights Reserved

	Take this as an example... ;-)
*/

/// Include
#define INTUI_V36_NAMES_ONLY
#define CATCOMP_NUMBERS

#include <exec/types.h>                 // exec
#include <exec/lists.h>
#include <exec/memory.h>
#include <exec/nodes.h>
#include <exec/execbase.h>
#include <dos/dos.h>                    // dos
#include <intuition/intuition.h>        // intuition
#include <intuition/gadgetclass.h>
#include <libraries/gadtools.h>         // libraries
#include <gadtoolsbox/forms.h>          // gadtoolsbox
#include <gadtoolsbox/gui.h>
#include <clib/exec_protos.h>           // protos
#include <clib/dos_protos.h>
#include <clib/gtx_protos.h>
#include <clib/nofrag_protos.h>
#include <clib/utility_protos.h>
#include <pragmas/exec_pragmas.h>
#include <pragmas/dos_pragmas.h>
#include <pragmas/gtx_pragmas.h>
#include <pragmas/nofrag_pragmas.h>
#include <pragmas/graphics_pragmas.h>
#include <pragmas/utility_pragmas.h>

#include <stdarg.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#include "DEV_IE:Loaders/defs.h"
///
/// Prototypes
static BOOL                 ConvertMenus( struct IE_Data *, struct WindowInfo *, struct ExtMenuList * );
static BOOL                 ConvertIText( struct IE_Data *, struct WindowInfo *, struct IntuiText * );
static BOOL                 ConvertBox( struct IE_Data *, struct WindowInfo *, struct BevelBox * );
static struct WindowInfo   *ConvertWin( struct IE_Data *, struct ProjectWindow * );
static BOOL                 ConvertGad( struct IE_Data *, struct WindowInfo *, struct ExtNewGadget * );
static ULONG                ConvertScr( struct IE_Data *, GUIDATA * );
static ULONG                ConvertColors( struct IE_Data *, UWORD, GUIDATA * );

extern struct GTXBase *GTXBase;
extern struct Library *GfxBase;
///
/// Data
static const UBYTE  Bar_txt[] = "---------------------------";

static const UWORD stringjusts[] = {
    GACT_STRINGLEFT, GACT_STRINGRIGHT, GACT_STRINGCENTER
};

static const ULONG gadget_flags[] = { 1, 2, 4, 8, 16, 0 };
///


// Conversion routines
/// Windows
struct WindowInfo *ConvertWin( struct IE_Data *IE, struct ProjectWindow *from )
{
    struct WindowInfo   *wnd;
    struct Screen       *scr;

    if( wnd = ( *IE->Functions->AllocObject )( IE_WINDOW )) {

	NewList( &wnd->wi_Gadgets );
	NewList( &wnd->wi_Menus   );
	NewList( &wnd->wi_Boxes   );
	NewList( &wnd->wi_Images  );
	NewList( &wnd->wi_ITexts  );

	AddTail( (struct List *)&IE->win_list, (struct Node *)wnd );

	IE->num_win += 1;

	wnd->wi_name = wnd->wi_Titolo;

	wnd->wi_Flags           = from->pw_WindowFlags;
	wnd->wi_IDCMP           = from->pw_IDCMP;
	wnd->wi_InnerWidth      = from->pw_InnerWidth;
	wnd->wi_InnerHeight     = from->pw_InnerHeight;
	wnd->wi_MouseQueue      = from->pw_MouseQueue;
	wnd->wi_RptQueue        = from->pw_RptQueue;

	if( from->pw_TagFlags & WDF_INNERWIDTH )
	    wnd->wi_flags1 |= W_USA_INNER_W;

	if( from->pw_TagFlags & WDF_INNERHEIGHT )
	    wnd->wi_flags1 |= W_USA_INNER_H;

	if( from->pw_TagFlags & WDF_MOUSEQUEUE )
	    wnd->wi_Tags |= W_MOUSEQUEUE;

	if( from->pw_TagFlags & WDF_RPTQUEUE )
	    wnd->wi_Tags |= W_RPTQUEUE;

	if( from->pw_TagFlags & WDF_AUTOADJUST )
	    wnd->wi_Tags |= W_AUTOADJUST;

	if( from->pw_TagFlags & WDF_FALLBACK )
	    wnd->wi_Tags |= W_FALLBACK;

	if( from->pw_TagFlags & WDF_ZOOM ) {
	    wnd->wi_Tags   |= W_ZOOM;
	    wnd->wi_ZLeft   = wnd->wi_ZTop = -1;    // don't move
	    wnd->wi_ZWidth  = wnd->wi_Width;
	    wnd->wi_ZHeight = IE->ScreenData->YOffset + 1;
	}

	scr = IE->ScreenData->Screen;

	wnd->wi_Left     = GetTagData( WA_Left, 0, from->pw_Tags );
	wnd->wi_Top      = GetTagData( WA_Top,  0, from->pw_Tags );

	wnd->wi_Width    = wnd->wi_InnerWidth + scr->WBorRight + scr->WBorLeft;
	wnd->wi_Height   = wnd->wi_InnerHeight + IE->ScreenData->YOffset + 1 + scr->WBorBottom;
	wnd->wi_MaxWidth = wnd->wi_MaxHeight = -1;

	strcpy( wnd->wi_Titolo,         from->pw_WindowTitle );
	strcpy( wnd->wi_TitoloSchermo,  from->pw_ScreenTitle );
	strcpy( wnd->wi_Label,          from->pw_Name        );

	#ifdef DEBUG
	Printf( "WINDOW: %s\n", wnd->wi_Titolo );
	#endif

	struct ExtNewGadget *gad;
	for( gad = from->pw_Gadgets.gl_First; gad->en_Next; gad = gad->en_Next )
	    if(!( ConvertGad( IE, wnd, gad )))
		return( NULL );
	#ifdef DEBUG
	Printf( "ConvertGad() OK\n" );
	#endif

	struct BevelBox     *box;
	for( box = from->pw_Boxes.bl_First; box->bb_Next; box = box->bb_Next )
	    if(!( ConvertBox( IE, wnd, box )))
		return( NULL );
	#ifdef DEBUG
	Printf( "ConvertBox() OK\n" );
	#endif

	struct IntuiText    *txt;
	txt = from->pw_WindowText;
	while( txt ) {
	    if(!( ConvertIText( IE, wnd, txt )))
		return( NULL );
	    txt = txt->NextText;
	}
	#ifdef DEBUG
	Printf( "ConvertIText() OK\n" );
	#endif

	if(!( ConvertMenus( IE, wnd, &from->pw_Menus )))
	    return( NULL );
	#ifdef DEBUG
	Printf( "ConvertMenus() OK\n" );
	#endif

    }

    return( wnd );
}
///
/// IntuiTexts
BOOL ConvertIText( struct IE_Data *IE, struct WindowInfo *wnd, struct IntuiText *from )
{
    struct ITextNode   *itn, *itn2;
/*    struct TxtAttrNode *fnt; */

    if( itn = ( *IE->Functions->AllocObject )( IE_INTUITEXT )) {

	AddTail(( struct List * )&wnd->wi_ITexts, ( struct Node * )itn );
	itn->itn_Node.ln_Name = itn->itn_IText = itn->itn_Text;

	wnd->wi_NumTexts += 1;

	itn2 = itn->itn_Node.ln_Pred;

	if( itn2->itn_Node.ln_Pred )
	    itn2->itn_NextText = &itn->itn_FrontPen;

	strcpy( itn->itn_Text, from->IText );

	itn->itn_FrontPen = from->FrontPen;
	itn->itn_BackPen  = from->BackPen;
	itn->itn_DrawMode = from->DrawMode;
	itn->itn_LeftEdge = from->LeftEdge;
	itn->itn_TopEdge  = from->TopEdge;

	itn->itn_Node.ln_Type |= IT_SCRFONT;

/*
	This part causes some Enforcer hits, probably because GTB puts
	some strange data in the ITextFont field of IntuiText...
	Anyway, if you manage to fix this... ;-)

	if( from->ITextFont ) {
	    if( fnt = ( *IE->Functions->AddFont )( from->ITextFont )) {

		if(!( fnt->txa_Ptr ))
		    IE->flags |= NODISKFONT;
		else
		    itn->itn_Node.ln_Type &= ~IT_SCRFONT;

		itn->itn_FontCopy = &fnt->txa_FontName;
	    } else
		IE->flags |= NODISKFONT;

	    if(!( itn->itn_Node.ln_Type & IT_SCRFONT ))
		itn->itn_ITextFont = itn->itn_FontCopy;
	}  */

    } else
	return( FALSE );

    return( TRUE );
}
///
/// Bevel Box
BOOL ConvertBox( struct IE_Data *IE, struct WindowInfo *wnd, struct BevelBox *from )
{
    struct BevelBoxNode    *box;

    if( box = ( *IE->Functions->AllocObject )( IE_BEVELBOX )) {

	AddTail( (struct List *)&wnd->wi_Boxes, (struct Node *)box );

	wnd->wi_NumBoxes += 1;

	box->bb_VITag       = GT_VisualInfo;
	box->bb_TTag        = GTBB_FrameType;
	box->bb_RTag        = TAG_IGNORE;

	box->bb_Left        = from->bb_Left;
	box->bb_Top         = from->bb_Top;
	box->bb_Width       = from->bb_Width;
	box->bb_Height      = from->bb_Height;

	if( from->bb_Flags & BBF_RECESSED ) {
	    box->bb_RTag = GTBB_Recessed;
	    box->bb_Recessed = TRUE;
	}

	box->bb_FrameType = ( from->bb_Flags & BBF_DROPBOX ) ? BBFT_ICONDROPBOX : BBFT_BUTTON;

    } else {
	return( FALSE );
    }

    return( TRUE );
}
///
/// Gadgets
BOOL ConvertGad( struct IE_Data *IE, struct WindowInfo *wnd, struct ExtNewGadget *from )
{
    struct GadgetInfo      *gad;
    struct GadgetScelta    *gs;
    UBYTE                 **labels;
    UWORD                   cnt, cnt2;
    UBYTE                  *ptr, ch;

    if(( from->en_Kind >= BOOLEAN ) || ( from->en_Kind == GENERIC_KIND ))
	return( TRUE );

    if(!( gad = ( *IE->Functions->AllocObject )( IE_GADGET )))
	return( FALSE );

    AddTail( (struct List *)&wnd->wi_Gadgets, (struct Node *)gad );

    gad->g_UserData     = gad;
    gad->g_VisualInfo   = IE->ScreenData->Visual;
    gad->g_GadgetText   = gad->g_Titolo;

    NewList( &gad->g_Scelte );

    gad->g_Kind = from->en_Kind;

    // NewGadget structure
    gad->g_Left     = from->en_NewGadget.ng_LeftEdge;
    gad->g_Top      = from->en_NewGadget.ng_TopEdge - IE->ScreenData->YOffset;
    gad->g_Width    = from->en_NewGadget.ng_Width;
    gad->g_Height   = from->en_NewGadget.ng_Height;
    gad->g_Flags    = from->en_NewGadget.ng_Flags;

    // strings
    strcpy( gad->g_Titolo, from->en_GadgetText );
    strcpy( gad->g_Label, from->en_GadgetLabel );

    #ifdef DEBUG
    Printf( "    - Gadget: %s  \t  Kind: %ld\n", gad->g_Titolo, gad->g_Kind );
    #endif

    // let's alloc some space for its string
    if(( gad->g_Kind == STRING_KIND ) || ( gad->g_Kind == TEXT_KIND )) {
	if(!( gad->g_ExtraMem = AllocVec( 120, MEMF_CLEAR ))) {
	    Remove(( struct Node *)gad );
	    ( *IE->Functions->FreeObject )( gad, IE_GADGET );
	    return( FALSE );
	}
    }

    // Now we translate the tags. Note my more compact way of storing
    // them *;D

    switch( from->en_Kind ) {

	case CHECKBOX_KIND:
	    if( GTX_TagInArray( GTCB_Checked, from->en_Tags ))
		gad->g_Tags |= 2;
	    if( GTX_TagInArray( GA_Disabled, from->en_Tags ))
		gad->g_Tags |= 2;
	    break;

	case CYCLE_KIND:

	    labels = (UBYTE **)GetTagData( GTCY_Labels, NULL, from->en_Tags );

	    // count the labels
	    cnt = 0;
	    while( labels[ cnt ] )
		cnt++;

	    gad->g_NumScelte = cnt;

	    for( cnt2 = 0; cnt2 < gad->g_NumScelte; cnt2++ ) {
		if(!( gs = ( *IE->Functions->AllocObject )( IE_ITEM )))
		    return( FALSE );

		AddTail( (struct List *)&gad->g_Scelte, (struct Node *)gs );
		gs->gs_Node.ln_Name = gs->gs_Testo;

		strcpy( gs->gs_Testo, *labels++ );
	    }

	    if( GTX_TagInArray( GTCY_Active, from->en_Tags ))
		((struct CK)( gad->g_Data )).Act = GetTagData( GTCY_Active, NULL, from->en_Tags );
	    if( GTX_TagInArray( GA_Disabled, from->en_Tags ))
		gad->g_Tags |= 2;
	    break;

	case    INTEGER_KIND:
	    if ( GTX_TagInArray( GA_TabCycle, from->en_Tags ))
		gad->g_Tags |= 8;
	    if ( GTX_TagInArray( STRINGA_ExitHelp, from->en_Tags ))
		gad->g_Tags |= 0x10;

	    ((struct IK)( gad->g_Data )).Num = GetTagData( GTIN_Number, 0, from->en_Tags );

	    ((struct IK)( gad->g_Data )).MaxC = GetTagData( GTIN_MaxChars, 10, from->en_Tags );

	    if ( cnt = GetTagData( STRINGA_Justification, 0l, from->en_Tags )) {
		cnt2 = 0;
		while( stringjusts[ cnt2 ] != cnt )
		    cnt2++;
		((struct IK)( gad->g_Data )).Just = cnt2;
	    }
	    if( GTX_TagInArray( GA_Disabled, from->en_Tags ))
		gad->g_Tags |= 2;
	    break;

	case    LISTVIEW_KIND:
	    if (GTX_TagInArray( GTLV_ShowSelected, from->en_Tags ))
		gad->g_Tags |= 8;
	    if ( GTX_TagInArray( GTLV_ScrollWidth, from->en_Tags ))
		((struct LK)( gad->g_Data)).ScW = GetTagData( GTLV_ScrollWidth, 0, from->en_Tags );
	    else
		((struct LK)(gad->g_Data)).ScW = 16;
	    if ( GTX_TagInArray( GTLV_ReadOnly, from->en_Tags ))
		gad->g_Tags |= 4;
	    if ( GTX_TagInArray( LAYOUTA_Spacing, from->en_Tags ))
		((struct LK)( gad->g_Data)).Spc = GetTagData( LAYOUTA_Spacing, 0, from->en_Tags );
	    if( GTX_TagInArray( GA_Disabled, from->en_Tags ))
		gad->g_Tags |= 2;

	    if( GTX_TagInArray( GTLV_Labels, from->en_Tags )) {
		labels = (UBYTE **)GetTagData( GTLV_Labels, NULL, from->en_Tags );

		// count the labels
		cnt = 0;
		while( labels[ cnt ] )
		    cnt++;

		gad->g_NumScelte = cnt;

		for( cnt2 = 0; cnt2 < gad->g_NumScelte; cnt2++ ) {
		    if(!( gs = ( *IE->Functions->AllocObject )( IE_ITEM )))
			return( FALSE );

		    AddTail( (struct List *)&gad->g_Scelte, (struct Node *)gs );
		    gs->gs_Node.ln_Name = gs->gs_Testo;

		    strcpy( gs->gs_Testo, *labels++ );
		}
	    }
	    break;

	case    MX_KIND:
	    labels = (UBYTE **)GetTagData( GTMX_Labels, NULL, from->en_Tags );

	    // count the labels
	    cnt = 0;
	    while( labels[ cnt ] )
		cnt++;

	    gad->g_NumScelte = cnt;

	    for( cnt2 = 0; cnt2 < gad->g_NumScelte; cnt2++ ) {
		if(!( gs = ( *IE->Functions->AllocObject )( IE_ITEM )))
		    return( FALSE );

		AddTail( (struct List *)&gad->g_Scelte, (struct Node *)gs );
		gs->gs_Node.ln_Name = gs->gs_Testo;

		strcpy( gs->gs_Testo, *labels++ );
	    }

	    if ( GTX_TagInArray( GTMX_Spacing, from->en_Tags ))
		((struct MK)( gad->g_Data )).Spc = GetTagData( GTMX_Spacing, 0, from->en_Tags );
	    else
		((struct MK)(gad->g_Data)).Spc = 1;
	    if ( GTX_TagInArray( GTMX_Active, from->en_Tags ))
		((struct MK)( gad->g_Data )).Act = GetTagData( GTMX_Active, 0, from->en_Tags );
	    if( GTX_TagInArray( GA_Disabled, from->en_Tags ))
		gad->g_Tags |= 2;
	    break;

	case    PALETTE_KIND:
	    ((struct PK)( gad->g_Data)).Depth = GetTagData( GTPA_Depth, 1, from->en_Tags );
	    if ( GTX_TagInArray( GTPA_IndicatorWidth, from->en_Tags ))
		((struct PK)( gad->g_Data )).IW = GetTagData( GTPA_IndicatorWidth, NULL, from->en_Tags );
	    if ( GTX_TagInArray( GTPA_IndicatorHeight, from->en_Tags ))
		((struct PK)( gad->g_Data )).IH = GetTagData( GTPA_IndicatorHeight, NULL, from->en_Tags );
	    if ( GTX_TagInArray( GTPA_Color, from->en_Tags ))
		((struct PK)( gad->g_Data )).Color = GetTagData( GTPA_Color, 1, from->en_Tags );
	    else
		((struct PK)( gad->g_Data )).Color = 1;
	    if ( GTX_TagInArray( GTPA_ColorOffset, from->en_Tags ))
		((struct PK)( gad->g_Data)).ColOff = GetTagData( GTPA_ColorOffset, 0, from->en_Tags );
	    if( GTX_TagInArray( GA_Disabled, from->en_Tags ))
		gad->g_Tags |= 2;
	    break;

	case    SCROLLER_KIND:
	    if ( GTX_TagInArray( GTSC_Top, from->en_Tags ))
		((struct SK)( gad->g_Data)).Top = GetTagData( GTSC_Top, NULL, from->en_Tags );
	    if ( GTX_TagInArray( GTSC_Total, from->en_Tags ))
		((struct SK)( gad->g_Data)).Tot = GetTagData( GTSC_Total, NULL, from->en_Tags );
	    if ( GTX_TagInArray( GTSC_Visible, from->en_Tags ))
		((struct SK)( gad->g_Data)).Vis = GetTagData( GTSC_Visible, NULL, from->en_Tags );
	    else
		((struct SK)(gad->g_Data)).Vis = 2;
	    if ( GTX_TagInArray( GTSC_Arrows, from->en_Tags ))
		((struct SK)( gad->g_Data)).Arr = GetTagData( GTSC_Arrows, 0, from->en_Tags );
	    if ( GTX_TagInArray( PGA_Freedom, from->en_Tags ))
		((struct SK)( gad->g_Data)).Free = 1;
	    if ( GTX_TagInArray( GA_Immediate, from->en_Tags ))
		gad->g_Tags |= 8;
	    if ( GTX_TagInArray( GA_RelVerify, from->en_Tags ))
		gad->g_Tags |= 4;
	    if( GTX_TagInArray( GA_Disabled, from->en_Tags ))
		gad->g_Tags |= 2;
	    break;

	case    SLIDER_KIND:
	    if ( GTX_TagInArray( GTSL_Min, from->en_Tags ))
		((struct SlK)( gad->g_Data)).Min = GetTagData( GTSL_Min, NULL, from->en_Tags );
	    if ( GTX_TagInArray( GTSL_Max, from->en_Tags ))
		((struct SlK)( gad->g_Data)).Max = GetTagData( GTSL_Max, NULL, from->en_Tags );
	    else
		((struct SlK)( gad->g_Data)).Max = 15;
	    if ( GTX_TagInArray( GTSL_Level, from->en_Tags ))
		((struct SlK)( gad->g_Data)).Level = GetTagData( GTSL_Level, NULL, from->en_Tags );
	    if ( GTX_TagInArray( GTSL_MaxLevelLen, from->en_Tags ))
		((struct SlK)( gad->g_Data)).MLL = GetTagData( GTSL_MaxLevelLen, NULL, from->en_Tags );
	    else
		((struct SlK)( gad->g_Data)).MLL = 2;

	    if ( GTX_TagInArray( GTSL_LevelFormat, from->en_Tags ))
		strcpy( ((struct SlK)( gad->g_Data)).Format, ( UBYTE * )GetTagData( GTSL_LevelFormat, 0, from->en_Tags ));
	    else
		strcpy( ((struct SlK)( gad->g_Data)).Format, "%ld" );

	    if ( GTX_TagInArray( GTSL_LevelPlace, from->en_Tags )) {
		cnt = GetTagData( GTSL_LevelPlace, NULL, from->en_Tags );

		cnt2 = 0;
		while( gadget_flags[ cnt2 ] != cnt )
		    cnt2++;

		((struct SlK)( gad->g_Data)).LevPlc = cnt2;
	    }
	    if ( GTX_TagInArray( PGA_Freedom, from->en_Tags ))
		((struct SlK)( gad->g_Data)).Free = 1;

	    if ( GTX_TagInArray( GA_Immediate, from->en_Tags ))
		gad->g_Tags |= 8;
	    if ( GTX_TagInArray( GA_RelVerify, from->en_Tags ))
		gad->g_Tags |= 4;
	    if( GTX_TagInArray( GA_Disabled, from->en_Tags ))
		gad->g_Tags |= 2;
	    break;

	case    STRING_KIND:
	    if ( GTX_TagInArray( GA_TabCycle, from->en_Tags ))
		gad->g_Tags |= 8;
	    if ( GTX_TagInArray( STRINGA_ExitHelp, from->en_Tags ))
		gad->g_Tags |= 0x10;
	    if ( ptr = ( UBYTE * )GetTagData( GTST_String, NULL, from->en_Tags )) {
		strcpy( gad->g_ExtraMem, ptr );
	    }
	    ((struct StK)( gad->g_Data)).MaxC = GetTagData( GTST_MaxChars, 64, from->en_Tags );

	    if ( cnt = GetTagData( STRINGA_Justification, 0l, from->en_Tags )) {
		cnt2 = 0;
		while( stringjusts[ cnt2 ] != cnt )
		    cnt2++;
		((struct StK)( gad->g_Data )).Just = cnt2;
	    }
	    if( GTX_TagInArray( GA_Disabled, from->en_Tags ))
		gad->g_Tags |= 2;
	    break;

	case    NUMBER_KIND:
	    if ( GTX_TagInArray( GTNM_Number, from->en_Tags ))
		((struct NK)( gad->g_Data )).Num = GetTagData( GTNM_Number, 0, from->en_Tags );
	    if ( GTX_TagInArray( GTNM_Border, from->en_Tags ))
		gad->g_Tags |= 2;
	    ((struct NK)(gad->g_Data)).MNL = 10;
	    ((struct NK)(gad->g_Data)).FPen = -1;
	    ((struct NK)(gad->g_Data)).BPen = -1;
	    strcpy( ((struct NK)(gad->g_Data)).Format, "%ld" );
	    break;

	case    TEXT_KIND:
	    {
		STRPTR  txt;

		if( txt = (STRPTR)GetTagData( GTTX_Text, NULL, from->en_Tags ))
		    strcpy( gad->g_ExtraMem, txt );
	    }

	    ((struct TK)(gad->g_Data)).FPen = -1;
	    ((struct TK)(gad->g_Data)).BPen = -1;

	    if ( GTX_TagInArray( GTTX_Border, from->en_Tags ))
		gad->g_Tags |= 4;
	    if ( GTX_TagInArray( GTTX_CopyText, from->en_Tags ))
		gad->g_Tags |= 2;
	    break;

    }

    if( GTX_TagInArray( GT_Underscore, from->en_Tags ))
	gad->g_Tags |= 1;

    // let's get the activation key
    if( gad->g_Tags & 1 ) {
	ptr = gad->g_Titolo;
	do{
	    ch = *ptr++;
	} while(( ch != '_' ) && ( ch != '\0' ));
	if( ch ) {
	    gad->g_Key = *ptr;
	    wnd->wi_NumKeys += 1;
	}
    }

    wnd->wi_GadTypes[ gad->g_Kind - 1 ] += 1;
    wnd->wi_NumGads += 1;

    return( TRUE );
}
///
/// Menus
BOOL ConvertMenus( struct IE_Data *IE, struct WindowInfo *wnd, struct ExtMenuList *from )
{
    struct MenuTitle   *title;
    struct _MenuItem   *item;
    struct MenuSub     *sub;
    struct ExtNewMenu  *from_m, *from_i, *from_s;

    for( from_m = from->ml_First; from_m->em_Next; from_m = from_m->em_Next ) {
	if( title = ( *IE->Functions->AllocObject )( IE_MENUTITLE )) {

	    AddTail( (struct List *)&wnd->wi_Menus, (struct Node *)title );
	    title->mt_Node.ln_Name = title->mt_Text;

	    wnd->wi_NumMenus += 1;

	    NewList( &title->mt_Items );

	    strcpy( title->mt_Text, from_m->em_MenuTitle );
	    strcpy( title->mt_Label, from_m->em_MenuLabel );

	    for( from_i = from_m->em_Items->ml_First; from_i->em_Next; from_i = from_i->em_Next ) {

		if( item = ( *IE->Functions->AllocObject )( IE_MENUITEM )) {

		    AddTail( (struct List *)&title->mt_Items, (struct Node *)item );
		    item->min_Node.ln_Name = item->min_Text;
		    NewList( &item->min_Subs );

		    title->mt_NumItems += 1;

		    if( from_i->em_NewMenu.nm_Label == NM_BARLABEL ) {
			item->min_Node.ln_Name = Bar_txt;
			item->min_Flags       |= M_BARLABEL;
		    }

		    strcpy( item->min_Text, from_i->em_MenuTitle );
		    strcpy( item->min_CommKey, from_i->em_CommKey );
		    strcpy( item->min_Label, from_i->em_MenuLabel );

		    item->min_MutualExclude = from_i->em_NewMenu.nm_MutualExclude;

		    for( from_s = from_i->em_Items->ml_First; from_s->em_Next; from_s = from_s->em_Next ) {

			if( sub = ( *IE->Functions->AllocObject )( IE_MENUSUB )) {

			    AddTail( (struct List *)&item->min_Subs, (struct Node *)sub );
			    sub->msn_Node.ln_Name = sub->msn_Text;

			    item->min_NumSubs += 1;

			    if( from_s->em_NewMenu.nm_Label == NM_BARLABEL ) {
				sub->msn_Node.ln_Name = Bar_txt;
				sub->msn_Flags       |= M_BARLABEL;
			    }

			    strcpy( sub->msn_Text, from_s->em_MenuTitle );
			    strcpy( sub->msn_CommKey, from_s->em_CommKey );
			    strcpy( sub->msn_Label, from_s->em_MenuLabel );

			    sub->msn_MutualExclude = from_s->em_NewMenu.nm_MutualExclude;

			} else {
			    return( FALSE );
			}
		    }

		} else {
		    return( FALSE );
		}
	    }

	} else {
	    return( FALSE );
	}
    }

    return( TRUE );
}
///
/// Screen
ULONG ConvertScr( struct IE_Data *IE, GUIDATA *GuiInfo )
{
    IE->ScreenData->Tags[ SCRWIDTH    ] = GuiInfo->gui_Width;
    IE->ScreenData->Tags[ SCRHEIGHT   ] = GuiInfo->gui_Height;
    IE->ScreenData->Tags[ SCRDEPTH    ] = GuiInfo->gui_Depth;
    IE->ScreenData->Tags[ SCRID       ] = GuiInfo->gui_DisplayID;
    IE->ScreenData->Tags[ SCROVERSCAN ] = GuiInfo->gui_Overscan;
    IE->ScreenData->Tags[ SCRAUTOSCROLL ] = ( GuiInfo->gui_Flags0 & GU0_AUTOSCROLL ) ? TRUE : FALSE;

    IE->ScreenData->NewFont.ta_YSize = GuiInfo->gui_Font.ta_YSize;
    IE->ScreenData->NewFont.ta_Flags = GuiInfo->gui_Font.ta_Flags;
    IE->ScreenData->NewFont.ta_Style = GuiInfo->gui_Font.ta_Style;
    strcpy( IE->ScreenData->NewFont.ta_Name, GuiInfo->gui_Font.ta_Name );

    ( *IE->Functions->AddFont )( &GuiInfo->gui_Font );

    strcpy( IE->ScreenData->Title, GuiInfo->gui_ScreenTitle );

    IE->ScreenData->St_Left = GuiInfo->gui_Left;
    IE->ScreenData->St_Top  = GuiInfo->gui_Top;

    if( GuiInfo->gui_Flags0 & GU0_PUBLIC )
	IE->ScreenData->Type = PUBLICSCREEN;
    else
	IE->ScreenData->Type = CUSTOMSCREEN;

    memcpy( IE->ScreenData->DriPens, GuiInfo->gui_DriPens, 20 );
    IE->ScreenData->DriPens[10] = GuiInfo->gui_MoreDriPens[0];
    IE->ScreenData->DriPens[11] = GuiInfo->gui_MoreDriPens[1];

    #ifdef DEBUG
    Printf( "ConvertScr() OK\n" );
    #endif

    return( ConvertColors( IE, 1 << IE->ScreenData->Tags[ SCRDEPTH ], GuiInfo ));
}

ULONG ConvertColors( struct IE_Data *IE, UWORD num, GUIDATA *GuiInfo )
{
    UWORD               c;
    struct ColorSpec   *col;
    ULONG               ret = LOADER_OK;

    if( GuiInfo->gui_Colors[0].ColorIndex == -1 )
	return( LOADER_OK );

    if( IE->colortable )           // make sure to release it
	FreeVec( IE->colortable );

    if( SysBase->LibNode.lib_Version >= 39 ) {  // Kick 3.0

	ULONG  *ptr;
	if( ptr = IE->colortable = AllocVec(( num * 12 ) + 8, 0L )) {

	    *ptr++ = num << 16;

	    for( c = 0; c < num; c++ ) {

		col = &GuiInfo->gui_Colors[ c ];

		if( col->ColorIndex != -1 ) {
		    ULONG c3;

		    // Now we MUST scale the color values from
		    // 4 bit per gun to 32 bit per gun

		    c3 = (col->Red << 4) | col->Red;
		    c3 |= c3 << 8;
		    *ptr++ = c3 | ( c3 << 16 );

		    c3 = (col->Green << 4) | col->Green;
		    c3 |= c3 << 8;
		    *ptr++ = c3 | ( c3 << 16 );

		    c3 = (col->Blue << 4) | col->Blue;
		    c3 |= c3 << 8;
		    *ptr++ = c3 | ( c3 << 16 );

		} else {
		    c = num;
		}

	    }
	    *ptr = NULL;

	} else {
	    ret = LOADER_NOMEMORY;
	}
    } else {                             // Kick 2.0

	UWORD *ptr2;
	if( ptr2 = IE->colortable = AllocVec( num + num + 2, 0L )) {

	    *ptr2++ = num;

	    for( c = 0; c < num; c ++ ) {

		col = &GuiInfo->gui_Colors[ c ];

		*ptr2++ = (col->Red << 8) | (col->Green << 4) | col->Blue;
	    }

	} else {
	    ret = LOADER_NOMEMORY;
	}
    }

    #ifdef DEBUG
    Printf( "ConvertColors() OK\n" );
    #endif

    return( ret );
}
///

// Main routines
/// LoadGUI
ULONG LoadGUI( __A0 struct IE_Data *IE, __A1 UBYTE *Filename )
{
    APTR                    Chain;
    ULONG                   ret;
    struct WindowList       Windows;
    GUIDATA                 GuiInfo;
    struct ProjectWindow   *wnd;

    if(!( Chain = GetMemoryChain( 4096L )))
	return( LOADER_NOMEMORY );

    NewList( &Windows );

    if( ret = GTX_LoadGUI( Chain, Filename,
			   RG_WindowList, &Windows,
			   RG_GUI, &GuiInfo,
			   TAG_END )) {

	switch( ret ) {
	    case ERROR_NOMEM:
		ret = LOADER_NOMEMORY;
		break;

	    case ERROR_OPEN:
	    case ERROR_READ:
	    case ERROR_WRITE:
	    case ERROR_PARSE:
	    case ERROR_PACKER:
	    case ERROR_PPLIB:
		ret = LOADER_IOERR;
		break;

	    case ERROR_NOTGUIFILE:
		ret = LOADER_UNKNOWN;
		break;
	}

    } else {

	for( wnd = Windows.wl_First; wnd->pw_Next; wnd = wnd->pw_Next ) {

	    if(!( IE->win_info = ConvertWin( IE, wnd ))) {
		ret = LOADER_NOMEMORY;
		goto done;
	    }
	}

	ret = ConvertScr( IE, &GuiInfo );

done:

	GTX_FreeWindows( Chain, &Windows );
    }

    FreeMemoryChain( Chain, TRUE );

    return( ret );
}
///

// These routines are not supported by this module since they need
// some *private* functions of gadtoolsbox.library... But if you can
// implement them, well, you'd do a great thing! ;-)
/// LoadWindows
ULONG LoadWindows( __A0 struct IE_Data *IE, __A1 UBYTE *Filename )
{
    return( LOADER_NOTSUPPORTED );
}
///
/// LoadGadgets
ULONG LoadGadgets( __A0 struct IE_Data *IE, __A1 UBYTE *Filename )
{
    return( LOADER_NOTSUPPORTED );
}
///
/// LoadScreen
ULONG LoadScreen( __A0 struct IE_Data *IE, __A1 UBYTE *Filename )
{
    return( LOADER_NOTSUPPORTED );
}
///

