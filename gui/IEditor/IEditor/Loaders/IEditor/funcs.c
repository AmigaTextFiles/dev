/*
	IEditor.loader ©1996 Simone Tellini
*/

/// Include
#include <stdarg.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>


#define INTUI_V36_NAMES_ONLY
#define CATCOMP_NUMBERS

#include <exec/nodes.h>                 // exec
#include <exec/lists.h>
#include <exec/memory.h>
#include <exec/types.h>
#include <exec/execbase.h>
#include <dos/dos.h>                    // dos
#include <libraries/gadtools.h>         // libraries
#include <clib/exec_protos.h>           // protos
#include <clib/dos_protos.h>
#include <pragmas/exec_pragmas.h>
#include <pragmas/dos_pragmas.h>

#include "DEV_IE:Loaders/defs.h"
#include "DEV_IE:Include/expander_pragmas.h"
#include "DEV_IE:Include/expanders.h"
///
/// Prototypes
static void                 FGetString( UBYTE *, BPTR );
static void                 FGetString2( UBYTE *, BPTR );
static void                 LoadLocale( struct IE_Data *, BPTR );
static BOOL                 LoadLocaleStuff( struct IE_Data *, BPTR );
static BOOL                 LoadMainProc( struct IE_Data *, BPTR );
static BOOL                 LoadARexx( struct IE_Data *, BPTR );
static BOOL                 LoadMenus( struct IE_Data *, struct WindowInfo *, BPTR );
static void                 SistemaImg( struct IE_Data * );
static BOOL                 LoadImg( struct IE_Data *, BPTR );
static BOOL                 LoadITexts( struct IE_Data *, struct WindowInfo *, BPTR );
static BOOL                 LoadImages( struct IE_Data *, struct WindowInfo *, BPTR );
static BOOL                 ReadBoxes( struct IE_Data *, struct WindowInfo *, BPTR );
static struct WindowInfo   *LoadWin( struct IE_Data *, BPTR );
static BOOL                 LoadGad( struct IE_Data *, BPTR, struct MinList * );
static BOOL                 LoadBool( struct IE_Data *, BPTR, struct MinList * );
static ULONG                LoadScr( struct IE_Data *, BPTR );
static ULONG                LoadColors( struct IE_Data *, UWORD, BPTR );
static BOOL                 LoadObjects( struct IE_Data *, BPTR );
static BOOL                 LoadGBank( struct IE_Data *, BPTR );
static void                 FixTranslations( struct IE_Data *, struct LocaleStr * );
static void                 SetOriginal( struct LocaleStr *, STRPTR );
static BOOL                 ProcessGadgets( struct MinList *, struct LocaleStr * );
///
/// Data
static const ULONG  DataHeader[]    = { 'IEDf', 3 };
static const ULONG  ScrHeader       = 'SCRN';
static const ULONG  InterfHeader    = 'INTF';
static const ULONG  FinestraHeader  = 'WNDW';
static const ULONG  GadgetHeader    = 'GADG';
static const ULONG  MenuHeader      = 'MENU';

static const UBYTE  Bar_txt[]       = "---------------------------";
///


/// Get string2
static void FGetString2( UBYTE *str, BPTR File )
{
    UWORD   len;

    FRead( File, &len, 2, 1 );
    FRead( File, str, len, 1 );

    str[ len ] = '\0';

    if( len & 1 )
	FGetC( File );
}
///
/// Get string
static void FGetString( UBYTE *str, BPTR File )
{
    UBYTE   len;

    len = FGetC( File );

    FRead( File, str, len, 1 );

    str[ len ] = '\0';

    if(!( len & 1 ))
	FGetC( File );
}
///

/// Objects
BOOL LoadObjects( struct IE_Data *IE, BPTR File )
{
    struct IEXNode *ex;
    UBYTE           ExName[256];
    UWORD           Num, Tot = 0;

    FRead( File, &IE->win_info->wi_NumObjects, 2, 1 );

    if( IE->win_info->wi_NumObjects ) {

	do {

	    FRead( File, &Num, 2, 1 );

	    Tot += Num;

	    FGetString( ExName, File );

	    BOOL found = FALSE;

	    ex = IE->Expanders.mlh_Head;
	    while( ex->Node.ln_Succ ) {
		if(!( strcmp( ex->Base->Lib.lib_Node.ln_Name, ExName ))) {
		    found = TRUE;
		    break;
		}
		ex = ex->Node.ln_Succ;
	    }

	    if( found ) {
		struct Expander *IEXBase;

		IEXBase = ex->Base;

		if(!( IEX_Load( ex->ID, IE, File, Num )))
		    return( FALSE );

		FRead( File, ExName, 4, 1 ); // 'IEXN'

	    } else {
		UWORD   id;

		do {        // skip these objects
		    do {
			FRead( File, &id, 2, 1 );
		    } while( id != 'IE' );
		    FRead( File, &id, 2, 1 );
		} while( id != 'XN' );

		IE->flags |= NO_IEX;
	    }

	} while( Tot < IE->win_info->wi_NumObjects );
    }

    return( TRUE );
}
///

/// Locale
void LoadLocale( struct IE_Data *IE, BPTR File )
{
    FGetString( IE->Locale->Catalog, File );
    FGetString( IE->Locale->JoinFile, File );
    FGetString( IE->Locale->BuiltIn, File );

    FRead( File, &IE->Locale->Version, 4, 1 );
}
///
/// LocaleStuff
BOOL LoadLocaleStuff( struct IE_Data *IE, BPTR File )
{
    ULONG   num;

    if( FRead( File, &num, 4, 1 )) {
	ULONG               cnt;
	struct LocaleStr   *str;

	for( cnt = 0; cnt < num; cnt++ ) {
	    struct LocaleLanguage  *lang;

	    if( lang = ( *IE->Functions->AllocObject )( IE_LOCALE_LANGUAGE )) {

		AddTail(( struct List * )&IE->Locale->Languages, ( struct Node * )lang );

		FGetString( lang->Language, File );
		FGetString( lang->File, File );

	    } else
		return( FALSE );
	}

	FRead( File, &num, 4, 1 );

	for( cnt = 0; cnt < num; cnt++ ) {

	    if( str = ( *IE->Functions->AllocObject )( IE_LOCALE_STRING )) {
		UWORD   flags;
		ULONG   cnt2, num2;

		AddTail(( struct List * )&IE->Locale->ExtraStrings, ( struct Node * )str );

		FRead( File, &flags, 2, 1 );

		str->Node.ln_Pri = flags;

		FGetString2( str->String, File );
		FGetString( str->ID, File );

		FRead( File, &num2, 4, 1 );

		for( cnt2 = 0; cnt2 < num2; cnt2++ ) {
		    struct LocaleTranslation   *tran;

		    if( tran = ( *IE->Functions->AllocObject )( IE_LOCALE_TRANSLATION )) {
			TEXT    buffer[1024];

			AddTail(( struct List * )&str->Translations, ( struct Node * )tran );

			FGetString2( buffer, File );

			if( tran->String = AllocVec( strlen( buffer ) + 1, MEMF_ANY ))
			    strcpy( tran->String, buffer );
			else
			    return( FALSE );

			tran->Node.ln_Name = tran->String;
			tran->Node.ln_Type = FGetC( File );

			FGetC( File );

		    } else
			return( FALSE );
		}

		if( str->Node.ln_Pri & LOC_GUI )
		    FixTranslations( IE, str );

	    } else
		return( FALSE );
	}

	for( str = IE->Locale->ExtraStrings.mlh_Head; str->Node.ln_Succ; str = str->Node.ln_Succ ) {

	    if( str->Node.ln_Pri & LOC_GUI ) {
		struct LocaleStr           *pred;
		struct LocaleTranslation   *tran;

		pred = str->Node.ln_Pred;

		Remove(( struct Node * )str );

		while( tran = (struct LocaleTranslation *) RemHead(( struct List * )&str->Translations ))
		    AddTail(( struct List * )&IE->Locale->Translations, ( struct Node * )tran );

		( *IE->Functions->FreeObject )( str, IE_LOCALE_STRING );

		str = pred;
	    }
	}
    }

    return( TRUE );
}
///
/// FixTranslations
void FixTranslations( struct IE_Data *IE, struct LocaleStr *String )
{
    struct WindowInfo  *wnd;
    BOOL                loc;

    if( IE->flags_2 & GENERASCR )
	if( strcmp( IE->ScreenData->Title, String->String ) == 0 ) {
	    SetOriginal( String, IE->ScreenData->Title );
	    return;
	}


    loc = ( IE->SrcFlags & LOCALIZE ) ? TRUE : FALSE;

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	LONG                add;
	struct ITextNode   *txt;

	add = loc ? ( wnd->wi_Tags & W_LOC_TITLE ) : TRUE;

	if(( wnd->wi_Titolo[0] ) && ( add ))
	    if( strcmp( wnd->wi_Titolo, String->String ) == 0 ) {
		SetOriginal( String, wnd->wi_Titolo );
		return;
	    }

	if( loc )
	    add = wnd->wi_Tags & W_LOC_SCRTITLE;
	else
	    add = TRUE;

	if(( wnd->wi_TitoloSchermo[0] ) && ( add ))
	    if( strcmp( wnd->wi_TitoloSchermo, String->String ) == 0 ) {
		SetOriginal( String, wnd->wi_TitoloSchermo );
		return;
	    }


	if( loc )
	    add = wnd->wi_Tags & W_LOC_GADGETS;
	else
	    add = TRUE;

	if( add ) {
	    struct GadgetBank  *bank;

	    if( ProcessGadgets( &wnd->wi_Gadgets, String ))
		return;

	    for( bank = wnd->wi_GBanks.mlh_Head; bank->Node.ln_Succ; bank = bank->Node.ln_Succ )
		if( ProcessGadgets( &bank->Storage, String ))
		    return;
	}


	if( loc )
	    add = wnd->wi_Tags & W_LOC_TEXTS;
	else
	    add = TRUE;

	if( add )
	    for( txt = wnd->wi_ITexts.mlh_Head; txt->itn_Node.ln_Succ; txt = txt->itn_Node.ln_Succ )
		if( txt->itn_Text[0] )
		    if( strcmp( txt->itn_Text, String->String ) == 0 ) {
			SetOriginal( String, txt->itn_Text );
			return;
		    }

	if( loc )
	    add = wnd->wi_Tags & W_LOC_MENUS;
	else
	    add = TRUE;

	if( add ) {
	    struct MenuTitle   *menu;
	    for( menu = wnd->wi_Menus.mlh_Head; menu->mt_Node.ln_Succ; menu = menu->mt_Node.ln_Succ ) {
		struct _MenuItem *item;

		if( menu->mt_Text[0] )
		    if( strcmp( menu->mt_Text, String->String ) == 0 ) {
			SetOriginal( String, menu->mt_Text );
			return;
		    }

		for( item = menu->mt_Items.mlh_Head; item->min_Node.ln_Succ; item = item->min_Node.ln_Succ ) {
		    struct MenuSub *sub;

		    if(( item->min_Text[0] ) && (!( item->min_Flags & M_BARLABEL )))
			if( strcmp( item->min_Text, String->String ) == 0 ) {
			    SetOriginal( String, item->min_Text );
			    return;
			}

		    if( item->min_CommKey[0] )
			if( strcmp( item->min_CommKey, String->String ) == 0 ) {
			    SetOriginal( String, item->min_CommKey );
			    return;
			}

		    for( sub = item->min_Subs.mlh_Head; sub->msn_Node.ln_Succ; sub = sub->msn_Node.ln_Succ ) {

			if(( sub->msn_Text[0] ) && (!( sub->msn_Flags & M_BARLABEL )))
			    if( strcmp( sub->msn_Text, String->String ) == 0 ) {
				SetOriginal( String, sub->msn_Text );
				return;
			    }

			if( sub->msn_CommKey[0] )
			    if( strcmp( sub->msn_CommKey, String->String ) == 0 ) {
				SetOriginal( String, sub->msn_CommKey );
				return;
			    }
		    }
		}
	    }
	}

    }
}
///
/// ProcessGadgets
BOOL ProcessGadgets( struct MinList *Gadgets, struct LocaleStr *String )
{
    struct GadgetInfo  *gad;

    for( gad = Gadgets->mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {

	if(( gad->g_Kind < MIN_IEX_ID ) && ( gad->g_Titolo[0] ))
	    if( strcmp( gad->g_Titolo, String->String ) == 0 ) {
		SetOriginal( String, gad->g_Titolo );
		return( TRUE );
	    }

	switch( gad->g_Kind ) {

	    case MX_KIND:
	    case CYCLE_KIND:
	    case LISTVIEW_KIND:
		{
		    struct GadgetScelta *gs;
		    for( gs = gad->g_Scelte.mlh_Head; gs->gs_Node.ln_Succ; gs = gs->gs_Node.ln_Succ )
			if( strcmp( gs->gs_Testo, String->String ) == 0 ) {
			    SetOriginal( String, gs->gs_Testo );
			    return( TRUE );
			}
		}
		break;

	    case TEXT_KIND:
	    case STRING_KIND:
		if( *((UBYTE *)(gad->g_ExtraMem)) )
		    if( strcmp( gad->g_ExtraMem, String->String ) == 0 ) {
			SetOriginal( String, gad->g_ExtraMem );
			return( TRUE );
		    }
		break;

	    case NUMBER_KIND:
		if(( ((struct NK)(gad->g_Data)).Format[0] ) && ( strcmp( ((struct NK)(gad->g_Data)).Format, "%ld" )))
		    if( strcmp( ((struct NK)(gad->g_Data)).Format, String->String ) == 0 ) {
			SetOriginal( String, ((struct NK)(gad->g_Data)).Format );
			return( TRUE );
		    }
		break;

	    case SLIDER_KIND:
		if( ((struct SlK)(gad->g_Data)).Format[0] )
		    if( strcmp( ((struct SlK)(gad->g_Data)).Format, String->String ) == 0 ) {
			SetOriginal( String, ((struct SlK)(gad->g_Data)).Format );
			return( TRUE );
		    }
		break;
	}
    }

    return( FALSE );
}
///
/// SetOriginal
void SetOriginal( struct LocaleStr *String, STRPTR Original )
{
    struct LocaleTranslation   *tran;

    String->Node.ln_Name = Original;

    for( tran = String->Translations.mlh_Head; tran->Node.ln_Succ; tran = tran->Node.ln_Succ )
	tran->Original = Original;
}
///

/// Main Proc
BOOL LoadMainProc( struct IE_Data *IE, BPTR File )
{
    UWORD   data;
    UWORD   cnt;
    APTR    node;

    FGetString( IE->ExtraProc, File );

    FRead( File, &data, 2, 1 );

    IE->MainProcFlags = data;

    FRead( File, &IE->NumLibs, 2, 1 );

#define no ((struct LibNode *)node)

    for( cnt = 0; cnt < IE->NumLibs; cnt++ ) {

	if( no = ( *IE->Functions->AllocObject )( IE_LIBRARY )) {

	    AddTail( (struct List *)&IE->Libs_List, (struct Node *)node );

	    FGetString( no->lbn_Name, File );
	    FGetString( no->lbn_Base, File );
	    FRead( File, &no->lbn_Version, 2, 1 );
	    FRead( File, &no->lbn_Node.ln_Type, 2, 1 );

	} else {
	    return( FALSE );
	}
    }

#undef no

    FRead( File, &IE->NumWndTO, 2, 1 );

#define no ((struct WndToOpen *)node)

    for( cnt = 0; cnt < IE->NumWndTO; cnt++ ) {

	if( no = ( *IE->Functions->AllocObject )( IE_WNDTOOPEN )) {

	    AddTail( (struct List *)&IE->WndTO_List, (struct Node *)node );

	    FGetString( no->wto_Label, File );

	} else {
	    return( FALSE );
	}
    }

#undef no

    return( TRUE );
}
///

/// ARexx
BOOL LoadARexx( struct IE_Data *IE, BPTR File )
{
    UWORD               cnt;
    struct RexxNode    *node;

    FGetString( IE->RexxPortName, File );
    FGetString( IE->RexxExt, File );

    FRead( File, &IE->NumRexxs, 2, 1 );

    for( cnt = 0; cnt < IE->NumRexxs; cnt++ ) {
	if( node = ( *IE->Functions->AllocObject )( IE_REXXCMD )) {

	    AddTail( (struct List *)&IE->Rexx_List, (struct Node *)node );

	    FGetString( node->rxn_Label, File );
	    FGetString( node->rxn_Name, File );
	    FGetString( node->rxn_Template, File );

	} else {
	    return( FALSE );
	}
    }

    return( TRUE );
}
///

/// Menus
BOOL LoadMenus( struct IE_Data *IE, struct WindowInfo *wnd, BPTR File )
{
    UWORD               c1, c2, c3;
    struct MenuTitle   *title;
    struct _MenuItem   *item;
    struct MenuSub     *sub;
    ULONG               ptr;

    for( c1 = 0; c1 < wnd->wi_NumMenus; c1++ ) {
	if( title = ( *IE->Functions->AllocObject )( IE_MENUTITLE )) {

	    AddTail( (struct List *)&wnd->wi_Menus, (struct Node *)title );

	    FRead( File, &title->mt_Flags, 4, 1 ); // Flags, Pad, NumItems
	    FGetString( title->mt_Text, File );
	    FGetString( title->mt_Label, File );

	    for( c2 = 0; c2 < title->mt_NumItems; c2++ ) {
		if( item = ( *IE->Functions->AllocObject )( IE_MENUITEM )) {

		    AddTail( (struct List *)&title->mt_Items, (struct Node *)item );

		    FRead( File, &item->min_Flags, 2, 1 ); // Flags, Pad

		    if( item->min_Flags & M_BARLABEL )
			item->min_Node.ln_Name = Bar_txt;

		    FGetString( item->min_Text, File );
		    FGetString( item->min_CommKey, File );
		    FGetString( item->min_Label, File );

		    ptr = (ULONG)&item->min_Image;
		    ptr += 2;
		    FRead( File, (APTR)ptr, 2, 1 );

		    FRead( File, &item->min_MutualExclude, 6, 1 );

		    for( c3 = 0; c3 < item->min_NumSubs; c3++ ) {
			if( sub = ( *IE->Functions->AllocObject )( IE_MENUSUB )) {

			    AddTail( (struct List *)&item->min_Subs, (struct Node *)sub );

			    FRead( File, &sub->msn_Flags, 2, 1 ); // Flags, Pad

			    if( sub->msn_Flags & M_BARLABEL )
				sub->msn_Node.ln_Name = Bar_txt;

			    FGetString( sub->msn_Text, File );
			    FGetString( sub->msn_CommKey, File );
			    FGetString( sub->msn_Label, File );

			    ptr = (ULONG)&sub->msn_Image;
			    ptr += 2;
			    FRead( File, (APTR)ptr, 2, 1 );

			    FRead( File, &sub->msn_MutualExclude, 4, 1 );

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

/// SistemaImg
void SistemaImg( struct IE_Data *IE )
{
    struct WindowInfo  *wnd;
    struct WndImages   *wimg;
    struct ImageNode   *img;
    UWORD               cnt;
    WORD                num;
    APTR                ptr;

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {

	for( wimg = wnd->wi_Images.mlh_Head; wimg->wim_Next; wimg = wimg->wim_Next ) {

	    img = (struct ImageNode *)&IE->Img_List;
	    for( cnt = 0; cnt <= (ULONG)wimg->wim_ImageNode; cnt++ )
		img = img->in_Node.ln_Succ;

	    wimg->wim_ImageNode = img;
	    memcpy( &wimg->wim_Width, &img->in_Width, 12 );

	}

	ptr = NULL;  // sistemo i ptr NextImage
	for( wimg = wnd->wi_Images.mlh_TailPred; wimg->wim_Prev; wimg = wimg->wim_Prev ) {
	    wimg->wim_NextImage = ptr;
	    ptr = &wimg->wim_Left;
	}

	// sistemo i booleani
	struct BooleanInfo *bool;
	for( bool = wnd->wi_Gadgets.mlh_Head; bool->b_Node.ln_Succ; bool = bool->b_Node.ln_Succ ) {
	    if( bool->b_Kind == BOOLEAN ) {

		num = (LONG)bool->b_GadgetRender;

		if( num >= 0 ) {

		    img = (struct ImageNode *)&IE->Img_List;
		    for( cnt = 0; cnt <= num; cnt++ )
			img = img->in_Node.ln_Succ;
		    bool->b_GadgetRender = &img->in_Left;

		} else {
		    bool->b_GadgetRender = NULL;
		}

		num = (LONG)bool->b_SelectRender;

		if( num >= 0 ) {

		    img = (struct ImageNode *)&IE->Img_List;
		    for( cnt = 0; cnt <= num; cnt++ )
			img = img->in_Node.ln_Succ;
		    bool->b_SelectRender = &img->in_Left;

		} else {
		    bool->b_SelectRender = NULL;
		}

	    }
	}

	// sistemo i menu

	struct MenuTitle *title;
	struct _MenuItem *item;
	struct MenuSub   *sub;
	for( title = wnd->wi_Menus.mlh_Head; title->mt_Node.ln_Succ; title = title->mt_Node.ln_Succ ) {
	    for( item = title->mt_Items.mlh_Head; item->min_Node.ln_Succ; item = item->min_Node.ln_Succ ) {

		num = (LONG)item->min_Image;

		if( num >= 0 ) {
		    img = (struct ImageNode *)&IE->Img_List;
		    for( cnt = 0; cnt <= num; cnt++ )
			img = img->in_Node.ln_Succ;
		    item->min_Image = &img->in_Left;
		} else {
		    item->min_Image = NULL;
		}

		for( sub = item->min_Subs.mlh_Head; sub->msn_Node.ln_Succ; sub = sub->msn_Node.ln_Succ ) {

		    num = (LONG)sub->msn_Image;

		    if( num >= 0 ) {
			img = (struct ImageNode *)&IE->Img_List;
			for( cnt = 0; cnt <= num; cnt++ )
			    img = img->in_Node.ln_Succ;
			sub->msn_Image = &img->in_Left;
		    } else {
			sub->msn_Image = NULL;
		    }
		}

	    }
	}
    }
}
///

/// Images
BOOL LoadImg( struct IE_Data *IE, BPTR File )
{
    struct ImageNode   *img;
    UWORD               num, cnt;

    FRead( File, &num, 2, 1 );

    IE->NumImgs += num;

    for( cnt = 0; cnt < num; cnt++ ) {
	if( img = ( *IE->Functions->AllocObject )( IE_IMAGE )) {

	    AddTail( (struct List *)&IE->Img_List, (struct Node *)img );
	    img->in_Node.ln_Name = img->in_Label;

	    FRead( File, &img->in_Width, 6, 1 );
	    FRead( File, &img->in_Size, 4, 1 );

	    if( img->in_Size ) {
		if(!( img->in_Data = AllocMem( img->in_Size, MEMF_CHIP|MEMF_CLEAR ))) {
		    img->in_Size = 0L;
		    return( FALSE );
		}
	    }

	    FRead( File, img->in_Data, img->in_Size, 1 );
	    FRead( File, &img->in_PlanePick, 2, 1 );

	    FGetString( img->in_Label, File );

	} else {
	    return( FALSE );
	}
    }

    return( TRUE );
}
///

/// IntuiTexts
BOOL LoadITexts( struct IE_Data *IE, struct WindowInfo *wnd, BPTR File )
{
    UWORD               cnt;
    struct ITextNode   *itn, *itn2;
    BOOL                pred = FALSE;
    struct TextAttr     font;
    struct TxtAttrNode *fnt;
    UWORD               more;
    UBYTE               buf[48];

    FRead( File, &wnd->wi_NumTexts, 2, 1 );

    for( cnt = 0; cnt < wnd->wi_NumTexts; cnt++ ) {
	if( itn = ( *IE->Functions->AllocObject )( IE_INTUITEXT )) {

	    AddTail( (struct List *)&wnd->wi_ITexts, (struct Node *)itn );

	    if( pred ) {
		itn2 = itn->itn_Node.ln_Pred;
		itn2->itn_NextText = &itn->itn_FrontPen;
	    } else {
		pred = TRUE;
	    }

	    FRead( File, &itn->itn_FrontPen, 8, 1 );
	    itn->itn_Node.ln_Type = itn->itn_AdjustToWord;
	    itn->itn_AdjustToWord = 0;

	    FGetString( itn->itn_Text, File );

	    FRead( File, &more, 2, 1 );

	    if( more ) {

		FGetString( buf, File );
		FRead( File, &font.ta_YSize, 4, 1 );

		font.ta_Name = buf;

		if( fnt = (*IE->Functions->AddFont)( &font )) {

		    if(!( fnt->txa_Ptr ))
			IE->flags |= NODISKFONT;
		    itn->itn_FontCopy = &fnt->txa_FontName;

		} else {
		    IE->flags |= NODISKFONT;
		}

		if(!( itn->itn_Node.ln_Type & IT_SCRFONT ))
		    itn->itn_ITextFont = itn->itn_FontCopy;

	    }

	} else {
	    return( FALSE );
	}
    }

    return( TRUE );
}
///

/// Images (in windows)
BOOL LoadImages( struct IE_Data *IE, struct WindowInfo *wnd, BPTR File )
{
    UWORD               cnt;
    struct WndImages   *img;
    ULONG               ptr;

    FRead( File, &wnd->wi_NumImages, 2, 1 );

    for( cnt = 0; cnt < wnd->wi_NumImages; cnt++ ) {
	if( img = ( *IE->Functions->AllocObject )( IE_WNDIMAGE )) {

	    AddTail( (struct List *)&wnd->wi_Images, (struct Node *)img );
	    FRead( File, &img->wim_Left, 4, 1 );

	    ptr = (ULONG)&img->wim_ImageNode;
	    ptr += 2;
	    FRead( File, (APTR)ptr, 2, 1 );

	} else {
	    return( FALSE );
	}
    }

    return( TRUE );
}
///

/// Bevel Box
BOOL ReadBoxes( struct IE_Data *IE, struct WindowInfo *wnd, BPTR File )
{
    UWORD                   cnt;
    struct BevelBoxNode    *box;

    FRead( File, &wnd->wi_NumBoxes, 2, 1 );

    for( cnt = 0; cnt < wnd->wi_NumBoxes; cnt++ ) {
	if( box = ( *IE->Functions->AllocObject )( IE_BEVELBOX )) {

	    AddTail( (struct List *)&wnd->wi_Boxes, (struct Node *)box );

	    FRead( File, &box->bb_Left, 8, 1 );
	    FRead( File, &box->bb_Recessed, 4, 1 );

	    if( box->bb_Recessed )
		box->bb_RTag = GTBB_Recessed;

	    FRead( File, &box->bb_FrameType, 4, 1 );

	} else {
	    return( FALSE );
	}
    }

    return( TRUE );
}
///

/// Windows
struct WindowInfo *LoadWin( struct IE_Data *IE, BPTR File )
{
    struct WindowInfo *wnd;

    if( wnd = ( *IE->Functions->AllocObject )( IE_WINDOW )) {

	AddTail( (struct List *)&IE->win_list, (struct Node *)wnd );

	wnd->wi_name = wnd->wi_Titolo;

	FRead( File, &wnd->wi_Top , 44, 1 );

	FGetString( wnd->wi_Titolo, File );
	FGetString( wnd->wi_TitoloSchermo, File );
	FGetString( wnd->wi_Label, File );
    }

    return( wnd );
}
///

/// Gadgets
BOOL LoadGad( struct IE_Data *IE, BPTR File, struct MinList *List )
{
    struct GadgetInfo      *gad;
    struct GadgetScelta    *gs;
    struct TextAttr         font;
    UBYTE                   name[40];
    UWORD                   cnt;
    UBYTE                  *ptr, ch;
    ULONG                   data;

    if(!( gad = ( *IE->Functions->AllocObject )( IE_GADGET )))
	return( FALSE );

    AddTail(( struct List * )List, ( struct Node * )gad );

    gad->g_UserData   = gad;
    gad->g_VisualInfo = IE->ScreenData->Visual;
    gad->g_flags2    |= G_CARICATO;

    NewList( &gad->g_Scelte );

    FRead( File, &gad->g_Left, 8, 1 );
    FRead( File, &gad->g_Flags, 4, 1 );
    FRead( File, &gad->g_Kind, 2, 1 );

    if(( gad->g_Kind == STRING_KIND ) || ( gad->g_Kind == TEXT_KIND )) {
	if(!( gad->g_ExtraMem = AllocVec( 120, MEMF_CLEAR ))) {
	    Remove(( struct Node *)gad );
	    ( *IE->Functions->FreeObject )( gad, IE_GADGET );
	    return( FALSE );
	}
    }

    FRead( File, &gad->g_Tags, 32, 1 );

    FRead( File, &data, 4, 1 );
    if( data & 1 )
	gad->g_flags2 |= G_NO_TEMPLATE;

    FRead( File, &font.ta_YSize, 4, 1 );

    FRead( File, &gad->g_NumScelte, 2, 1 );

    for( cnt = 0; cnt < gad->g_NumScelte; cnt++ ) {
	if(!( gs = ( *IE->Functions->AllocObject )( IE_ITEM )))
	    return( FALSE );

	AddTail( (struct List *)&gad->g_Scelte, (struct Node *)gs );
	gs->gs_Node.ln_Name = gs->gs_Testo;

	FGetString( gs->gs_Testo, File );
    }



    if(( gad->g_Kind == STRING_KIND ) || ( gad->g_Kind == TEXT_KIND ))
	FGetString( gad->g_ExtraMem, File );


    FGetString( gad->g_Titolo, File );

    if( gad->g_Tags & 1 ) {
	ptr = gad->g_Titolo;
	do {
	    ch = *ptr++;
	} while(( ch != '_' ) && ( ch != '\0' ));
	if( ch ) {
	    gad->g_Key = *ptr;
	    IE->win_info->wi_NumKeys += 1;
	}
    }

    FGetString( gad->g_Label, File );

    FGetString( name, File );

    if( name[0] ) {
	font.ta_Name = name;
	if( gad->g_Font = (*IE->Functions->AddFont)( &font )) {
	    gad->g_TextAttr = &gad->g_Font->txa_FontName;
	    if(!( gad->g_Font->txa_Ptr ))
		IE->flags |= NODISKFONT;
	} else {
	    gad->g_TextAttr = NULL;
	    IE->flags |= NODISKFONT;
	}
    }

    IE->win_info->wi_GadTypes[ gad->g_Kind - 1 ] += 1;

    return( TRUE );
}
///

/// Booleans
BOOL LoadBool( struct IE_Data *IE, BPTR File, struct MinList *List )
{
    struct BooleanInfo *gad;
    UBYTE               name[40];
    struct TextAttr     font;
    WORD                len;
    ULONG               ptr, data;

    if(!( gad = ( *IE->Functions->AllocObject )( IE_BOOLEAN )))
	return( FALSE );

    AddTail(( struct List * )List, ( struct Node * )gad );

    gad->b_flags2 |= G_CARICATO;
    gad->b_Kind = BOOLEAN;

    FRead( File, &gad->b_Left, 14, 1 );

    ptr = (ULONG)&gad->b_GadgetRender;
    ptr += 2;
    FRead( File, (APTR)ptr, 2, 1 );

    ptr = (ULONG)&gad->b_SelectRender;
    ptr += 2;
    FRead( File, (APTR)ptr, 2, 1 );

    FRead( File, &gad->b_FrontPen, 8, 1 );

    FRead( File, &data, 4, 1 );
    if( data & 1 )
	gad->b_flags2 |= G_NO_TEMPLATE;

    FRead( File, &font.ta_YSize, 4, 1 );

    if( FGetC( File ) )
	gad->b_flags2 |= B_TEXT;
    else
	gad->b_Text = NULL;

    len = FGetC( File );
    FRead( File, gad->b_Titolo, len, 1 );
    if( len & 1 )
	FGetC( File );

    FGetString( gad->b_Label, File );

    FGetString( name, File ); // for compatibility reasons
    FGetString( name, File );

    if( name[0] ) {
	font.ta_Name = name;
	if(!( gad->b_Font = (*IE->Functions->AddFont)( &font ))) {
	    IE->flags |= NODISKFONT;
	    gad->b_TextFont = NULL;
	} else {
	    gad->b_TextFont = &gad->b_Font->txa_FontName;
	    if(!( gad->b_Font->txa_Ptr ))
		IE->flags |= NODISKFONT;
	}
    }

    return( TRUE );
}
///

/// Gadget Banks
BOOL LoadGBank( struct IE_Data *IE, BPTR File )
{
    struct GadgetBank  *bank;
    UWORD               num, cnt;

    if(!( bank = ( *IE->Functions->AllocObject )( IE_GADGETBANK )))
	return( FALSE );

    AddTail(( struct List * )&IE->win_info->wi_GBanks, ( struct Node * )bank );

    FGetString( bank->Label, File );

    FRead( File, &num, 2, 1 );

    for( cnt = 0; cnt < num; cnt++ ) {
	struct BGadget *bgad;

	if(!( bgad = ( *IE->Functions->AllocObject )( IE_BGADGET )))
	    return( FALSE );

	AddTail(( struct List * )&bank->Gadgets, ( struct Node * )bgad );

	if(!( LoadGad( IE, File, &bank->Storage )))
	    return( FALSE );

	bgad->Gadget = (struct GadgetInfo *)bank->Storage.mlh_TailPred;
    }

    FRead( File, &num, 2, 1 );

    for( cnt = 0; cnt < num; cnt++ )
	if(!( LoadBool( IE, File, &bank->Storage )))
	    return( FALSE );

    FRead( File, &num, 2, 1 );

    return( TRUE );
}
///

/// Screen
ULONG LoadScr( struct IE_Data *IE, BPTR File )
{
    WORD    *data = IE->ScreenData->Tags;

    FRead( File, &data[( SCRWIDTH      * 2 ) + 1 ], 2, 1 );
    FRead( File, &data[( SCRHEIGHT     * 2 ) + 1 ], 2, 1 );
    FRead( File, &data[( SCRDEPTH      * 2 ) + 1 ], 2, 1 );
    FRead( File, &data[  SCRID         * 2 ], 4, 1 );
    FRead( File, &data[  SCROVERSCAN   * 2 ], 4, 1 );
    FRead( File, &data[( SCRAUTOSCROLL * 2 ) + 1 ], 2, 1 );
    FRead( File, &IE->ScreenData->NewFont.ta_YSize, 4, 1 );
    FRead( File, &IE->ScreenData->ScrAttrs, 2, 1 );
    FRead( File, &IE->ScreenData->St_Left, 2, 1 );
    FRead( File, &IE->ScreenData->St_Top, 2, 1 );
    FRead( File, &IE->ScreenData->Type, 2, 1 );
    FRead( File, IE->ScreenData->DriPens, 24, 1 );
    FGetString( IE->ScreenData->FontScr, File );
    FGetString( IE->ScreenData->Title, File );
    FGetString( IE->ScreenData->PubName, File );
    return( LoadColors( IE, 1 << IE->ScreenData->Tags[ SCRDEPTH ], File ));
}

ULONG LoadColors( struct IE_Data *IE, UWORD num, BPTR File )
{
    UWORD   c, c2, c3;
    UBYTE   buf[3];
    ULONG   ret = LOADER_OK;

    if ( IE->colortable )           // make sure to release it
	FreeVec( IE->colortable );

    c = 1 << IE->ScreenData->Tags[ SCRDEPTH ];
    if ( num > c )
	num = c;

    if ( SysBase->LibNode.lib_Version >= 39 ) {  // Kick 3.0

	ULONG  *ptr;
	if ( ptr = IE->colortable = AllocVec(( num * 12 ) + 8, 0L )) {

	    *((UWORD *)ptr)++ = num;
	    *((UWORD *)ptr)++ = 0;

	    for( c = 0; c < num; c++ ) {

		FRead( File, buf, 3, 1 );
		for( c2 = 0; c2 < 3 ; c2++ ) {
		    c3 = (buf[ c2 ] << 8) | buf[ c2 ];
		    *ptr++ = c3 | ( c3 << 16 );
		}
	    }
	    *ptr = NULL;

	} else {
	    ret = LOADER_NOMEMORY;
	    return;
	}
    } else {                             // Kick 2.0

	UWORD *ptr2;
	if( ptr2 = IE->colortable = AllocVec( num + num + 2, 0L )) {

	    *ptr2++ = num;

	    for( c2 = 0; c2 < num; c2 ++ ) {
		FRead( File, buf, 3, 1 );
		*ptr2++ = (buf[0] << 4) | buf[1] | (buf[2] >> 4);
	    }

	} else {
	    ret = LOADER_NOMEMORY;
	}
    }

    return( ret );
}
///


// Main routines
/// LoadGUI
ULONG LoadGUI( __A0 struct IE_Data *IE, __A1 UBYTE *Filename )
{
    ULONG               buf[3];
    UBYTE               buf2;
    UWORD               cnt, cnt2;
    UWORD               more;
    struct GadgetInfo  *gad;
    ULONG               ret;
    BPTR                File;

    if(!( File = Open( Filename, MODE_OLDFILE )))
	return( LOADER_IOERR );


    FRead( File, buf, 12, 1 );

    if( buf[0] != DataHeader[0] ) {
	ret = LOADER_UNKNOWN;
	goto chiudi;
    }


    if( buf[1] != DataHeader[1] ) {
	ret = LOADER_WRONGVERSION;
	goto chiudi;
    }

    if( buf[2] != InterfHeader ) {
	ret = LOADER_UNWELCOME;
	goto chiudi;
    }

    FRead( File, &IE->SrcFlags, 1, 1 );
    FRead( File, &buf2, 1, 1 );

    if( buf2 )
	IE->flags_2 |= GENERASCR;
    else
	IE->flags_2 &= ~GENERASCR;

    LoadScr( IE, File );

    FRead( File, &IE->num_win, 2, 1 );



    for( cnt = 0; cnt < IE->num_win; cnt++ ) {

	if(!( IE->win_info = LoadWin( IE, File ) ))
	    goto CaricaErr;

	FRead( File, &IE->win_info->wi_NumGads, 2, 1 );

	for( cnt2 = 0; cnt2 < IE->win_info->wi_NumGads; cnt2++ )
	    LoadGad( IE, File, &IE->win_info->wi_Gadgets );

	FRead( File, &IE->win_info->wi_NumMenus, 2, 1 );
	if( IE->win_info->wi_NumMenus )
	    LoadMenus( IE, IE->win_info, File );

	FRead( File, &IE->win_info->wi_NumBools, 2, 1 );
	IE->win_info->wi_NumGads += IE->win_info->wi_NumBools;

	for( cnt2 = 0; cnt2 < IE->win_info->wi_NumBools; cnt2++ )
	    LoadBool( IE, File, &IE->win_info->wi_Gadgets );

	if(!( ReadBoxes( IE, IE->win_info, File ) ))
	    goto CaricaErr;

	if(!( LoadImages( IE, IE->win_info, File ) ))
	    goto CaricaErr;

	FRead( File, &more, 2, 1 );

	if( more ) {

	    if(!( LoadITexts( IE, IE->win_info, File ) ))
		goto CaricaErr;

	    FRead( File, &more, 2, 1 );

	    if( more ) {
		if(!( LoadObjects( IE, File )))
		    goto CaricaErr;

		FRead( File, &more, 2, 1 );


		if( more ) {

		    FRead( File, &IE->win_info->wi_NumGBanks, 2, 1 );

		    for( cnt2 = 0; cnt2 < IE->win_info->wi_NumGBanks; cnt2++ )
			if(!( LoadGBank( IE, File )))
			    goto CaricaErr;

		    FRead( File, &more, 2, 1 );
		}
	    }
	}

	for( gad = IE->win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ )
	    gad->g_flags2 &= ~G_CARICATO;
    }

    LoadImg( IE, File );
    SistemaImg( IE );

    if( FRead( File, &more, 2, 1 )) {

	if(!( LoadARexx( IE, File ) ))
	    goto CaricaErr;

	if( FRead( File, &more, 2, 1 )) {

	    if(!( LoadMainProc( IE, File ) ))
		goto CaricaErr;

	    if( FRead( File, &more, 2, 1 )) {
		LoadLocale( IE, File );

		FGetString( IE->SharedPort, File );

		if(!( LoadLocaleStuff( IE, File )))
		    goto CaricaErr;
	    }
	}
    }

    ret = LOADER_OK;

chiudi:

    Close( File );
    return( ret );

CaricaErr:

    ret = LOADER_IOERR;
    goto chiudi;
}
///
/// LoadWindows
ULONG LoadWindows( __A0 struct IE_Data *IE, __A1 UBYTE *Filename )
{
    struct WindowInfo  *wnd;
    ULONG               buf[3], ret;
    BPTR                File;

    if(!( File = Open( Filename, MODE_OLDFILE )))
	return( LOADER_IOERR );

    FRead( File, buf, 12, 1 );

    if( buf[0] != DataHeader[0] ) {
	ret = LOADER_UNKNOWN;
	goto chiudi;
    }

    if( buf[1] != DataHeader[1] ) {
	ret = LOADER_WRONGVERSION;
	goto chiudi;
    }

    if( buf[2] != FinestraHeader ) {
	ret = LOADER_UNWELCOME;
	goto chiudi;
    }


    if(!( wnd = LoadWin( IE, File ) )) {
	ret = LOADER_IOERR;
	goto chiudi;
    }

    if(!( IE->win_open ))
	IE->win_info = wnd;

    IE->num_win += 1;

    ret = LOADER_OK;

chiudi:

    Close( File );

    return( ret );
}
///
/// LoadGadgets
ULONG LoadGadgets( __A0 struct IE_Data *IE, __A1 UBYTE *Filename )
{
    struct GadgetInfo  *gad;
    UWORD               num, cnt;
    ULONG               buf[3], ret;
    BPTR                File;

    if(!( File = Open( Filename, MODE_OLDFILE ))) {
	ret = LOADER_IOERR;
	return( TRUE );
    }

    FRead( File, buf, 12, 1 );

    if( buf[0] != DataHeader[0] ) {
	ret = LOADER_UNKNOWN;
	goto chiudi;
    }

    if( buf[1] != DataHeader[1] ) {
	ret = LOADER_WRONGVERSION;
	goto chiudi;
    }

    if( buf[2] != GadgetHeader ) {
	ret = LOADER_UNWELCOME;
	goto chiudi;
    }

    FRead( File, &num, 2, 1 );

    IE->win_info->wi_NumGads += num;

    for( cnt = 0; cnt < num; cnt++ ) {
	if(!( LoadGad( IE, File, &IE->win_info->wi_Gadgets ) )) {
	    ret = LOADER_IOERR;
	    goto chiudi;
	}
    }

    FRead( File, &num, 2, 1 );

    IE->win_info->wi_NumGads  += num;
    IE->win_info->wi_NumBools += num;

    for( cnt = 0; cnt < num; cnt++ ) {
	if(!( LoadBool( IE, File, &IE->win_info->wi_Gadgets ) )) {
	    ret = LOADER_IOERR;
	    goto chiudi;
	}
    }

    LoadImg( IE, File );
    SistemaImg( IE );

    if(!( LoadObjects( IE, File ))) {
	ret = LOADER_IOERR;
	goto chiudi;
    }

    for( gad = IE->win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
	if( gad->g_flags2 & G_CARICATO ) {
	    gad->g_Top += IE->ScreenData->YOffset;
	    gad->g_flags2 &= ~G_CARICATO;
	}
    }

    ret = LOADER_OK;

chiudi:

    Close( File );

    return( ret );
}
///
/// LoadScreen
ULONG LoadScreen( __A0 struct IE_Data *IE, __A1 UBYTE *Filename )
{
    UBYTE   buffer[ 12 ];
    ULONG   *data1 = buffer, *data2, ret;
    BPTR    File;

    data2 = DataHeader;

    if ( File = Open( Filename, MODE_OLDFILE )) {

	FRead( File, buffer, 12, 1 );

	if ( *data1++ == *data2++ ) {
	    if ( *data1++ == *data2++ ) {
		if ( *data1 == ScrHeader ) {
		    ret = LoadScr( IE, File );
		} else {
		    ret = LOADER_UNWELCOME;
		}
	    } else {
		ret = LOADER_WRONGVERSION;
	    }
	} else {
	    ret = LOADER_UNKNOWN;
	}
	Close( File );
    } else {
	ret = LOADER_IOERR;
    }

    return( ret );
}
///

