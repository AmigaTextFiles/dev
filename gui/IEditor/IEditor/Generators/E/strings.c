/// Includes
#define INTUI_V36_NAMES_ONLY

#include <exec/nodes.h>                 // exec
#include <exec/lists.h>
#include <exec/types.h>
#include <dos/dos.h>                    // dos
#include <libraries/gadtools.h>         // libraries
#include <clib/exec_protos.h>           // protos
#include <clib/dos_protos.h>
#include <pragmas/exec_pragmas.h>       // pragmas
#include <pragmas/dos_pragmas.h>

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#include "DEV_IE:Generators/defs.h"
#include "DEV_IE:Include/IEditor.h"
#include "DEV_IE:Generators/C/Protos.h"
///


/// CountArray
UWORD CountArray( UBYTE **Array )
{
    UWORD   cnt = 0;

    while( *Array++ )
	cnt += 1;

    return( cnt );
}
///
/// CmpArrays
BOOL CmpArrays( UBYTE **First, struct MinList *Second )
{
    UWORD                   num, cnt;
    struct GadgetScelta    *gs;

    num = CountArray( First );

    gs = Second->mlh_Head;
    cnt = 0;
    while( gs->gs_Node.ln_Succ ) {
	cnt += 1;
	gs = gs->gs_Node.ln_Succ;
    }

    if( num != cnt )
	return( FALSE );

    gs = Second->mlh_Head;

    for( cnt = 0; cnt < num; cnt++ ) {
	if( strcmp( *First++, gs->gs_Testo ))
	    return( FALSE );
	gs = gs->gs_Node.ln_Succ;
    }

    return( TRUE );
}
///
/// FindString
struct StringNode *FindString( struct MinList *List, UBYTE *String )
{
    struct StringNode  *str;

    for( str = List->mlh_Head; str->Next; str = str->Next )
	if(!( strcmp( str->String, String )))
	    return( str );

    return( NULL );
}
///
/// FindArray
struct ArrayNode *FindArray( struct MinList *List, struct MinList *Array )
{
    struct ArrayNode   *ar;

    for( ar = List->mlh_Head; ar->Next; ar = ar->Next )
	if( CmpArrays( ar->Array, Array ))
	    return( ar );

    return( NULL );
}
///
/// AddString
BOOL AddString( struct MinList *List, UBYTE *String )
{
    struct StringNode  *str;

    if(!( FindString( List, String ))) {
	if(!( str = AllocMem( sizeof( struct StringNode ), 0L )))
	    return( FALSE );

	AddTail(( struct List * )List, ( struct Node * )str );

	str->String = String;
    }

    return( TRUE );
}
///
/// AddArray
BOOL AddArray( struct GenFiles *Files, struct MinList *Items )
{
    struct ArrayNode       *ar;
    struct GadgetScelta    *gs;
    UBYTE                 **Array;
    UBYTE                   size = 4;

    if(!( FindArray( &Files->Arrays, Items ))) {
	if(!( ar = AllocMem( sizeof( struct ArrayNode ), 0L )))
	    return( FALSE );

	AddTail(( struct List * )&Files->Arrays, ( struct Node * )ar );

	gs = Items->mlh_Head;
	while( gs = gs->gs_Node.ln_Succ )
	    size += 4;

	if(!( Array = AllocVec( size, 0L )))
	    return( FALSE );

	ar->Array = Array;

	for( gs = Items->mlh_Head; gs->gs_Node.ln_Succ; gs = gs->gs_Node.ln_Succ ) {

	    *Array++ = gs->gs_Testo;

	    if(!( AddString( &Files->Strings, gs->gs_Testo ))) {
		FreeVec( ar->Array );
		return( FALSE );
	    }
	}

	*Array = NULL;

    }

    return( TRUE );
}
///
/// PutLabels
void PutLabels( struct IE_Data *IE, struct GenFiles *Files )
{
    UWORD               cnt;
    struct StringNode  *str;
    STRPTR              label;

    label = ( IE->SrcFlags & LOCALIZE ) ? "MSG_STRING_%ld" : "String%ld";

    for( str = Files->Strings.mlh_Head, cnt = 0; str->Next; str = str->Next ) {
	sprintf( str->Label, label, cnt );
	cnt += 1;
    }

    struct ArrayNode   *ar;

    for( ar = Files->Arrays.mlh_Head, cnt = 0; ar->Next; ar = ar->Next ) {
	sprintf( ar->Label, "Array%ld", cnt );
	cnt += 1;
    }
}
///
/// ProcessStrings
BOOL ProcessStrings( struct IE_Data *IE, struct GenFiles *Files )
{
    struct WindowInfo  *wnd;
    BOOL                loc;

    if(( IE->ScreenData->Title[0] ) && ( IE->flags_2 & GENERASCR ))
	if(!( AddString( &Files->Strings, IE->ScreenData->Title )))
	    return( FALSE );

    loc = ( IE->SrcFlags & LOCALIZE ) ? TRUE : FALSE;

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {

	LONG   add;

	add = loc ? ( wnd->wi_Tags & W_LOC_TITLE ) : TRUE;

	if(( wnd->wi_Titolo[0] ) && ( add ))
	    if(!( AddString( &Files->Strings, wnd->wi_Titolo )))
		return( FALSE );

	if( loc )
	    add = wnd->wi_Tags & W_LOC_SCRTITLE;
	else
	    add = TRUE;

	if(( wnd->wi_TitoloSchermo[0] ) && ( add ))
	    if(!( AddString( &Files->Strings, wnd->wi_TitoloSchermo )))
		return( FALSE );



	if( loc )
	    add = wnd->wi_Tags & W_LOC_GADGETS;
	else
	    add = TRUE;

	if( add ) {
	    struct GadgetBank  *bank;

	    ProcessGadgets( Files, &wnd->wi_Gadgets );

	    for( bank = wnd->wi_GBanks.mlh_Head; bank->Node.ln_Succ; bank = bank->Node.ln_Succ )
		ProcessGadgets( Files, &bank->Storage );
	}

	struct ITextNode   *txt;

	if( loc )
	    add = wnd->wi_Tags & W_LOC_TEXTS;
	else
	    add = TRUE;

	if( add )
	    for( txt = wnd->wi_ITexts.mlh_Head; txt->itn_Node.ln_Succ; txt = txt->itn_Node.ln_Succ )
		if( txt->itn_Text[0] )
		    if(!( AddString( &Files->Strings, txt->itn_Text )))
			return( FALSE );

	if( loc )
	    add = wnd->wi_Tags & W_LOC_MENUS;
	else
	    add = TRUE;

	if( add ) {
	    struct MenuTitle   *menu;
	    for( menu = wnd->wi_Menus.mlh_Head; menu->mt_Node.ln_Succ; menu = menu->mt_Node.ln_Succ ) {

		if( menu->mt_Text[0] )
		    if(!( AddString( &Files->Strings, menu->mt_Text )))
			return( FALSE );

		struct _MenuItem *item;
		for( item = menu->mt_Items.mlh_Head; item->min_Node.ln_Succ; item = item->min_Node.ln_Succ ) {

		    if(( item->min_Text[0] ) && (!( item->min_Flags & M_BARLABEL )))
			if(!( AddString( &Files->Strings, item->min_Text )))
			    return( FALSE );

		    if( item->min_CommKey[0] )
			if(!( AddString( &Files->Strings, item->min_CommKey )))
			    return( FALSE );

		    struct MenuSub *sub;
		    for( sub = item->min_Subs.mlh_Head; sub->msn_Node.ln_Succ; sub = sub->msn_Node.ln_Succ ) {

			if(( sub->msn_Text[0] ) && (!( sub->msn_Flags & M_BARLABEL )))
			    if(!( AddString( &Files->Strings, sub->msn_Text )))
				return( FALSE );

			if( sub->msn_CommKey[0] )
			    if(!( AddString( &Files->Strings, sub->msn_CommKey )))
				return( FALSE );
		    }
		}
	    }
	}

    }

    PutLabels( IE, Files );

    return( TRUE );
}
///
/// ProcessGadgets
BOOL ProcessGadgets( struct GenFiles *Files, struct MinList *Gadgets )
{
    struct GadgetInfo  *gad;

    for( gad = Gadgets->mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {

	if(( gad->g_Kind < MIN_IEX_ID ) && ( gad->g_Titolo[0] ))
	    if(!( AddString( &Files->Strings, gad->g_Titolo )))
		return( FALSE );

	switch( gad->g_Kind ) {

	    case MX_KIND:
	    case CYCLE_KIND:
		if(!( AddArray( Files, &gad->g_Scelte )))
		    return( FALSE );
		break;

	    case LISTVIEW_KIND:
		{
		    struct GadgetScelta *gs;
		    for( gs = gad->g_Scelte.mlh_Head; gs->gs_Node.ln_Succ; gs = gs->gs_Node.ln_Succ )
			if(!( AddString( &Files->Strings, gs->gs_Testo )))
			    return( FALSE );
		}
		break;

	    case TEXT_KIND:
	    case STRING_KIND:
		if( *((UBYTE *)(gad->g_ExtraMem)) )
		    if(!( AddString( &Files->Strings, gad->g_ExtraMem )))
			return( FALSE );
		break;

	    case NUMBER_KIND:
		if(( ((struct NK)(gad->g_Data)).Format[0] ) && ( strcmp( ((struct NK)(gad->g_Data)).Format, "%ld" )))
		    if(!( AddString( &Files->Strings, ((struct NK)(gad->g_Data)).Format )))
			return( FALSE );
		break;

	    case SLIDER_KIND:
		if( ((struct SlK)(gad->g_Data)).Format[0] )
		    if(!( AddString( &Files->Strings, ((struct SlK)(gad->g_Data)).Format )))
			return( FALSE );
		break;
	}
    }
}
///
/// FreeStrings
void FreeStrings( struct GenFiles *Files )
{
    struct StringNode  *Str;
    struct ArrayNode   *Array;

    while( Str = RemHead(( struct List * )&Files->Strings ))
	FreeMem( Str, sizeof( struct StringNode ));

    while( Array = RemHead(( struct List * )&Files->Arrays )) {
	FreeVec( Array->Array );
	FreeMem( Array, sizeof( struct ArrayNode ));
    }
}
///

