/// Include
#include <stdarg.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#define INTUI_V36_NAMES_ONLY

#include <exec/nodes.h>                 // exec
#include <exec/lists.h>
#include <exec/memory.h>
#include <exec/ports.h>
#include <exec/libraries.h>
#include <dos/dos.h>                    // dos
#include <clib/exec_protos.h>           // protos
#include <clib/intuition_protos.h>
#include <clib/gadtools_protos.h>
#include <pragmas/exec_pragmas.h>       // pragmas
#include <pragmas/intuition_pragmas.h>
#include <pragmas/gadtools_pragmas.h>

#include "DEV_IE:defs.h"
#include "DEV_IE:GUI.h"
#include "DEV_IE:Include/expanders-protos.h"
#include "DEV_IE:Include/expanders.h"
#include "DEV_IE:Include/expander_pragmas.h"
///
/// Prototypes
static void     InitWindowInfo( APTR );
static void     InitGadgetInfo( APTR );
static void     InitBooleanInfo( APTR );
static void     InitGadgetScelta( APTR );
static void     InitBevelBox( APTR );
static void     InitIText( APTR );
static void     InitMenuSub( APTR );
static void     InitMenuItem( APTR );
static void     InitMenuTitle( APTR );
static void     InitRexxNode( APTR );
static void     InitWndToOpen( APTR );
static void     InitLibNode( APTR );
static void     InitGadgetBank( APTR );
static void     InitBOOPSIInfo( APTR );
static void     InitBTag( APTR );
static void     InitLocaleString( APTR );
static void     InitLocaleLanguage( APTR obj );
static void     InitLocaleTranslation( APTR obj );
static void     FreeWindowInfo( APTR );
static void     FreeGadgetInfo( APTR );
static void     FreeBooleanInfo( APTR );
static void     FreeIText( APTR );
static void     FreeMenuItem( APTR );
static void     FreeMenuTitle( APTR );
static void     FreeBOOPSIInfo( APTR );
static void     FreeLocaleString( APTR );
static void     FreeLocaleTranslation( APTR );
static void     FreeArrayNode( APTR );
static void     FreeTranslations( struct MinList * );
///
/// Data
static const struct ObjData {
			    ULONG   Size;
			    APTR    Init;
			    APTR    Free;
		    } Objects[] = {
    sizeof( struct WindowInfo ),        InitWindowInfo,         FreeWindowInfo,
    sizeof( struct GadgetInfo ),        InitGadgetInfo,         FreeGadgetInfo,
    sizeof( struct BooleanInfo ),       InitBooleanInfo,        FreeBooleanInfo,
    sizeof( struct GadgetScelta ),      InitGadgetScelta,       NULL,
    sizeof( struct BevelBoxNode ),      InitBevelBox,           NULL,
    sizeof( struct WndImages ),         NULL,                   NULL,
    sizeof( struct ITextNode ),         InitIText,              FreeIText,
    sizeof( struct ImageNode ),         NULL,                   NULL,
    sizeof( struct MenuSub ),           InitMenuSub,            NULL,
    sizeof( struct _MenuItem ),         InitMenuItem,           FreeMenuItem,
    sizeof( struct MenuTitle ),         InitMenuTitle,          FreeMenuTitle,
    sizeof( struct RexxNode ),          InitRexxNode,           NULL,
    sizeof( struct WndToOpen ),         InitWndToOpen,          NULL,
    sizeof( struct LibNode ),           InitLibNode,            NULL,
    sizeof( struct GadgetBank ),        InitGadgetBank,         NULL,
    sizeof( struct BGadget ),           NULL,                   NULL,
    sizeof( struct BOOPSIInfo ),        InitBOOPSIInfo,         FreeBOOPSIInfo,
    sizeof( struct BTag ),              InitBTag,               NULL,
    sizeof( struct LocaleStr ),         InitLocaleString,       FreeLocaleString,
    sizeof( struct LocaleLanguage ),    InitLocaleLanguage,     NULL,
    sizeof( struct LocaleTranslation ), NULL,                   FreeLocaleTranslation,
    sizeof( struct ArrayNode ),         NULL,                   FreeArrayNode,
};
///



/// AllocObject
APTR AllocObject( __D0 UWORD Type )
{
    APTR    Ptr = NULL;

    if( Type <= IE_LASTOBJ ) {
	struct ObjData *Data;

	Data = &Objects[ Type ];

	if( Ptr = AllocMem( Data->Size, MEMF_CLEAR )) {
	    void    ( *InitFunc )( APTR );

	    if( InitFunc = Data->Init )
		InitFunc( Ptr );
	}
    }

    return( Ptr );
}
///
/// FreeObject
void FreeObject( __A0 APTR Object, __D0 UWORD Type )
{
    void    ( *FreeFunc )( APTR );

    if(( Object ) && ( Type <= IE_LASTOBJ )) {
	struct ObjData *Data;

	Data = &Objects[ Type ];

	if( FreeFunc = Data->Free )
	    FreeFunc( Object );

	FreeMem( Object, Data->Size );
    }
}
///

/// InitWindowInfo
void InitWindowInfo( APTR wnd )
{
    NewList( &((struct WindowInfo *)wnd )->wi_Gadgets   );
    NewList( &((struct WindowInfo *)wnd )->wi_Menus     );
    NewList( &((struct WindowInfo *)wnd )->wi_Boxes     );
    NewList( &((struct WindowInfo *)wnd )->wi_Images    );
    NewList( &((struct WindowInfo *)wnd )->wi_ITexts    );
    NewList( &((struct WindowInfo *)wnd )->wi_GBanks    );
}
///
/// InitGadgetInfo
void InitGadgetInfo( APTR gad )
{
    NewList( &((struct GadgetInfo *)gad )->g_Scelte );

    ((struct GadgetInfo *)gad )->g_UserData   = gad;
    ((struct GadgetInfo *)gad )->g_GadgetText = ((struct GadgetInfo *)gad )->g_Titolo;
    ((struct GadgetInfo *)gad )->g_VisualInfo = VisualInfo;
}
///
/// InitBooleanInfo
void InitBooleanInfo( APTR gad )
{
    ((struct BooleanInfo *)gad )->b_GadgetType = GTYP_BOOLGADGET;
    ((struct BooleanInfo *)gad )->b_GadgetText = &((struct BooleanInfo *)gad )->b_FrontPen;
}
///
/// InitGadgetScelta
void InitGadgetScelta( APTR gs )
{
    ((struct GadgetScelta *)gs )->gs_Node.ln_Name = ((struct GadgetScelta *)gs )->gs_Testo;
}
///
/// InitBevelBox
void InitBevelBox( APTR box )
{
    (( struct BevelBoxNode *)box )->bb_VITag      = GT_VisualInfo;
    (( struct BevelBoxNode *)box )->bb_VisualInfo = VisualInfo;
    (( struct BevelBoxNode *)box )->bb_RTag       = TAG_IGNORE;
    (( struct BevelBoxNode *)box )->bb_TTag       = GTBB_FrameType;
}
///
/// InitIText
void InitIText( APTR itn )
{
    ((struct ITextNode *)itn )->itn_Node.ln_Name = ((struct ITextNode *)itn )->itn_IText = ((struct ITextNode *)itn )->itn_Text;
}
///
/// InitMenuSub
void InitMenuSub( APTR sub )
{
    ((struct MenuSub *)sub )->msn_Node.ln_Name = ((struct MenuSub *)sub )->msn_Text;
}
///
/// InitMenuItem
void InitMenuItem( APTR item )
{
    NewList( &(( struct _MenuItem *)item )->min_Subs          );

    (( struct _MenuItem *)item )->min_Node.ln_Name = (( struct _MenuItem *)item )->min_Text;
}
///
/// InitMenuTitle
void InitMenuTitle( APTR menu )
{
    NewList( &(( struct MenuTitle *)menu )->mt_Items  );

    (( struct MenuTitle *)menu )->mt_Node.ln_Name = (( struct MenuTitle *)menu )->mt_Text;
}
///
/// InitRexxNode
void InitRexxNode( APTR rexx )
{
    ((struct RexxNode *)rexx )->rxn_Node.ln_Name = ((struct RexxNode *)rexx )->rxn_Name;
}
///
/// InitWndToOpen
void InitWndToOpen( APTR wto )
{
    ((struct WndToOpen *)wto )->wto_Node.ln_Name = ((struct WndToOpen *)wto )->wto_Label;
}
///
/// InitLibNode
void InitLibNode( APTR lib )
{
    ((struct LibNode *)lib )->lbn_Node.ln_Name = ((struct LibNode *)lib )->lbn_Name;
}
///
/// InitGadgetBank
void InitGadgetBank( APTR bank )
{
    ((struct GadgetBank *)bank )->Node.ln_Name = ((struct GadgetBank *)bank )->Label;

    NewList(( struct List * )&((struct GadgetBank *)bank )->Gadgets );
    NewList(( struct List * )&((struct GadgetBank *)bank )->Storage );
}
///
/// InitBOOPSIInfo
void InitBOOPSIInfo( APTR obj )
{
    NewList(( struct List * )&(( struct BOOPSIInfo * )obj )->Tags   );
}
///
/// InitBTag
void InitBTag( APTR obj )
{
    NewList(( struct List * )&(( struct BTag * )obj )->Items );
}
///
/// InitLocaleString
void InitLocaleString( APTR obj )
{
    NewList(( struct List * )&(( struct LocaleStr * )obj )->Translations );

    (( struct LocaleStr * )obj )->Node.ln_Name = (( struct LocaleStr * )obj )->String;
}
///
/// InitLocaleLanguage
void InitLocaleLanguage( APTR obj )
{
    (( struct LocaleLanguage * )obj )->Node.ln_Name = (( struct LocaleLanguage * )obj )->Language;
}
///


/// FreeWindowInfo
#define wnd (( struct WindowInfo * )obj )

void FreeWindowInfo( APTR obj )
{
    struct GadgetInfo  *gad;
    struct WindowInfo  *wnd2;
    struct IEXNode     *ex;

    /*  GList               */

    if( wnd->wi_GList )
	FreeGadgets( wnd->wi_GList );

    /*  Gadget Banks        */
    EliminaGBanks( wnd );

    /*  Gadgets             */

    for( gad = wnd->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
	if( gad->g_Kind < MIN_IEX_ID ) {
	    struct GadgetInfo  *next;

	    next = gad->g_Node.ln_Pred;

	    Remove(( struct Node * )gad );

	    if( gad->g_Kind < BOOLEAN )
		FreeObject( gad, IE_GADGET );
	    else
		FreeObject( gad, IE_BOOLEAN );

	    gad = next;

	} else
	    gad->g_flags2 |= G_ATTIVO;
    }

    /*  Objects             */

    wnd2 = IE.win_info;
    IE.win_info = wnd;

    for( ex = IE.Expanders.mlh_Head; ex->Node.ln_Succ; ex = ex->Node.ln_Succ ) {
	struct Expander *IEXBase;
	IEXBase = ex->Base;
	IEX_Remove( ex->ID, &IE );
    }

    IE.win_info = wnd2;


    /*  Bevel Boxes         */
    {
	struct BevelBoxNode *bb;

	while( bb = RemTail(( struct List * )&wnd->wi_Boxes ))
	    FreeObject( bb, IE_BEVELBOX );
    }


    /*  IntuiTexts          */
    {
	struct ITextNode    *itn;

	while( itn = RemTail(( struct List * )&wnd->wi_ITexts ))
	    FreeObject( itn, IE_INTUITEXT );
    }

    /*  Images              */
    {
	struct WndImages    *im;

	while( im = RemTail(( struct List * )&wnd->wi_Images ))
	    FreeObject( im, IE_WNDIMAGE );
    }

    /*  Menus               */
    {
	struct MenuTitle    *menu;

	while( menu = (struct MenuTitle *) RemTail(( struct List * )&wnd->wi_Menus ))
	   FreeObject( menu, IE_MENUTITLE );
    }
}
#undef wnd
///
/// FreeGadgetInfo
void FreeGadgetInfo( APTR obj )
{
    struct GadgetScelta    *gs;

    EliminaFont((( struct GadgetInfo * )obj )->g_Font );

    if((( struct GadgetInfo * )obj )->g_ExtraMem )
	FreeVec((( struct GadgetInfo * )obj )->g_ExtraMem );

    while( gs = (struct GadgetScelta *)RemTail(( struct List * )&(( struct GadgetInfo * )obj )->g_Scelte ))
	FreeObject( gs, IE_ITEM );
}
///
/// FreeBooleanInfo
void FreeBooleanInfo( APTR obj )
{
    EliminaFont((( struct BooleanInfo * )obj )->b_Font );
}
///
/// FreeIText
void FreeIText( APTR obj )
{
    if((( struct ITextNode * )obj )->itn_FontCopy )
	EliminaFont(( struct TxtAttrNode *)((ULONG)(( struct ITextNode * )obj )->itn_FontCopy - 14 ));
}
///
/// FreeMenuTitle
void FreeMenuTitle( APTR obj )
{
    struct _MenuItem    *item;

    while( item = (struct _MenuItem *)RemTail((struct List *)&(( struct MenuTitle * )obj )->mt_Items ))
	FreeObject( item, IE_MENUITEM );
}
///
/// FreeMenuItem
void FreeMenuItem( APTR obj )
{
    struct MenuSub  *sub;

    while( sub = ( struct MenuSub * )RemTail((struct List *)&(( struct _MenuItem * )obj )->min_Subs ))
	FreeObject( sub, IE_MENUSUB );
}
///
/// FreeBOOPSIInfo
void FreeBOOPSIInfo( APTR obj )
{
    struct BTag    *tag;

    while( tag = ( struct BTag * )RemTail(( struct List * )&(( struct BOOPSIInfo * )obj )->Tags ))
	FreeObject( tag, IE_BTAG );
}
///
/// FreeLocaleString
void FreeLocaleString( APTR obj )
{
    struct LocaleTranslation   *tran;

    while( tran = ( struct LocaleTranslation * )RemTail(( struct List * )&(( struct LocaleStr * )obj )->Translations ))
	FreeObject( tran, IE_LOCALE_TRANSLATION );
}
///
/// FreeLocaleTranslation
void FreeLocaleTranslation( APTR obj )
{
    FreeVec((( struct LocaleTranslation * )obj )->String );
}
///
/// FreeArrayNode
void FreeArrayNode( APTR obj )
{
    if((( struct ArrayNode * )obj )->Array )
	FreeVec((( struct ArrayNode * )obj )->Array );
}
///
