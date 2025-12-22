/// Include
#define INTUI_V36_NAMES_ONLY
#define ASL_V38_NAMES_ONLY
#define CATCOMP_NUMBERS

#include <exec/memory.h>                // exec
#include <exec/lists.h>
#include <exec/libraries.h>
#include <exec/execbase.h>
#include <intuition/intuition.h>        // intuition
#include <dos/dos.h>                    // dos
#include <libraries/gadtools.h>         // libraries
#include <libraries/asl.h>
#include <libraries/iffparse.h>
#include <iffp/ilbm.h>                  // iffp
#include <clib/exec_protos.h>           // protos
#include <clib/intuition_protos.h>
#include <clib/graphics_protos.h>
#include <clib/dos_protos.h>
#include <clib/iffparse_protos.h>
#include <clib/asl_protos.h>
#include <clib/locale_protos.h>
#include <clib/gadtools_protos.h>
#include <pragmas/exec_pragmas.h>       // pragmas
#include <pragmas/intuition_pragmas.h>
#include <pragmas/graphics_pragmas.h>
#include <pragmas/dos_pragmas.h>
#include <pragmas/locale_pragmas.h>
#include <pragmas/asl_pragmas.h>
#include <pragmas/reqtools_pragmas.h>
#include <pragmas/gadtools_pragmas.h>
#include <pragmas/iffparse_pragmas.h>

#include <stdarg.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "DEV_IE:defs.h"
#include "DEV_IE:GUI.h"
#include "DEV_IE:GUI_locale.h"
///
/// Prototipi
static void             StaccaMenuList( void );
static void             AttaccaMenuList( void );
static void             StaccaItemList( void );
static void             AttaccaItemList( void );
static void             StaccaSubList( void );
static void             AttaccaSubList( void );
static struct MenuTitle *GetMenuSel( void );
static struct _MenuItem *GetItemSel( void );
static struct MenuSub   *GetSubSel( void );
static void             OpenMutualExclude( struct MinList *, struct _MenuItem * );
static void             MX_StaccaExcList( void );
static void             MX_AttaccaExcList( void );
static void             MX_StaccaIncList( void );
static void             MX_AttaccaIncList( void );
static void             ME_AttivaTitle( void );
static void             ME_AttivaItem( void );
static void             ME_AttivaSub( void );
static void             ME_DisattivaTitle( void );
static void             ME_DisattivaItem( void );
static void             ME_DisattivaSub( void );
static void             AggiornaItemSub( void );
static void             AggiornaSub( void );
static void             ME_EditTitle( struct MenuTitle * );
static void             ME_EditItem( struct _MenuItem * );
static void             ME_AttivaChecks( void );
static void             MEd_BarLabel( void );
static void             MEd_SetChecks( struct _MenuItem * );
static void             AttaccaImgList( void );
static void             StaccaImgList( void );
static void             AnalyseBitmap( struct ImageNode * );
static void             ClrImgSpace( void );
static void             HandleImgBank( void );
///
/// Dati
TEXT    Bar_txt[] = "-------------------------";

TEXT    ImageFile[30];
TEXT    initial_imgdrawer[300];
TEXT    Img_Pattern[60] = "(#?.iff|#?.ilbm|#?.pic)";

static UWORD    LastTitle, LastItem, LastSub;
static WORD     VarA, VarB;

static BOOL     TitleAct, ItemAct, SubAct;

static struct MinList   Exc_List, Inc_List, Other_List;
///


//      Varie
/// Funzioni sui nodi
void NodeUp( APTR node )
{
    struct Node *pred, *succ;

    succ = ((struct Node *)node)->ln_Succ;
    pred = ((struct Node *)node)->ln_Pred;

    if( pred->ln_Pred ) {
	pred->ln_Succ = succ;
	succ->ln_Pred = pred;
	succ = pred->ln_Pred;
	succ->ln_Succ = node;
	pred->ln_Pred = node;
	((struct Node *)node)->ln_Succ = pred;
	((struct Node *)node)->ln_Pred = succ;

    }
}

void NodeDown( APTR node )
{
    struct Node *pred, *succ;

    succ = ((struct Node *)node)->ln_Succ;

    if( succ->ln_Succ ) {
	pred = ((struct Node *)node)->ln_Pred;
	pred->ln_Succ = succ;
	succ->ln_Pred = pred;
	pred = succ->ln_Succ;
	pred->ln_Pred = node;
	succ->ln_Succ = node;
	((struct Node *)node)->ln_Succ = pred;
	((struct Node *)node)->ln_Pred = succ;
    }
}
///
/// GetImgFile
BOOL GetImgFile( BOOL savemode, STRPTR titolo, ULONG titn, STRPTR ext )
{
    UBYTE   *ptr, ch;
    BOOL     ok;
    struct   FileRequester *req;

    if(( ext ) && ( ImageFile[0] )) {
	ptr = ImageFile;

	do {
	    ch = *ptr++;
	} while(( ch != '.' ) && ( ch != '\0' ));

	if( ch == '\0' ) {
	    ptr--;
	    *ptr++ = '.';
	}

	while( *ext != '\0' )
	    *ptr++ = *ext++;
	*ptr = '\0';
    }

    if( LocaleBase )
	titolo = GetCatalogStr( Catalog, titn, titolo );

    if( req = AllocAslRequest( ASL_FileRequest, NULL )) {

	if ( ok = AslRequestTags( req, ASLFR_DoPatterns,     TRUE,
			      ASLFR_InitialHeight,  Scr->Height - 40,
			      ASLFR_TitleText,      titolo,
			      ASLFR_InitialFile,    ImageFile,
			      ASLFR_InitialDrawer,  initial_imgdrawer,
			      ASLFR_InitialPattern, Img_Pattern,
			      ASLFR_Window,         BackWnd,
			      ASLFR_DoSaveMode,     (ULONG)savemode,
			      TAG_END )) {

	    strcpy( ImageFile, req->fr_File );
	    strcpy( initial_imgdrawer, req->fr_Drawer );
	    strcpy( allpath, req->fr_Drawer );
	    strcpy( Img_Pattern, req->fr_Pattern );
	    AddPart( allpath, req->fr_File, 1024 );

	}

	FreeAslRequest( req );

    } else {
	Stat( CatCompArray[ ERR_NOASL ].cca_Str, TRUE, 0 );
	ok = FALSE;
    }

    return( ok );
}
///

//      Menu Editor
/// Menu Editor
BOOL ME_IExcludeClicked( void )
{
    struct MenuTitle   *menu;

    menu = GetMenuSel();

    StaccaItemList;
    OpenMutualExclude( &menu->mt_Items, GetItemSel() );
    AttaccaItemList();

    return( TRUE );
}

BOOL ME_SExcludeClicked( void )
{
    struct _MenuItem   *item;

    item = GetItemSel();

    StaccaSubList();
    OpenMutualExclude( &item->min_Subs, (struct _MenuItem *)GetSubSel() );
    AttaccaSubList();

    return( TRUE );
}

BOOL MenuEdCloseWindow( void )
{
    return( FALSE );
}

BOOL ME_OkClicked( void )
{
    return( FALSE );
}

BOOL MenuEdIntuiTicks( void )
{
    Timer += 1;
    return( TRUE );
}

BOOL MenuEdMenued( void )
{
    int                 ret;
    struct MenuTitle   *menu;
    struct _MenuItem   *item;

    LockAllWindows();

    List2Tag[1] = List2Tag[3] = List2Tag2[1] = List2Tag2[3] = List2Tag3[1] = List2Tag3[3] = 0;

    AddHead((struct List *)&IE.Img_List, &NoneNode );

    LayoutWindow( MenuEdWTags );
    ret = OpenMenuEdWindow();
    PostOpenWindow( MenuEdWTags );

    if( ret ) {
	DisplayBeep( Scr );
    } else {

	MenuEdGadgets[ GD_ME_Test ]->Activation |= GACT_TOGGLESELECT;

	TitleAct = SubAct = ItemAct = TRUE;

	LastTitle = LastItem = LastSub = -1;

	if( IE.win_info->wi_NumMenus ) {
	    ME_AttivaTitle();
	    AttaccaMenuList();

	    menu = GetMenuSel();

	    if( menu->mt_NumItems ) {
		ME_AttivaItem();
		AttaccaItemList();

		item = GetItemSel();

		if( item->min_NumSubs ) {
		    ME_AttivaSub();
		    AttaccaSubList();
		}
	    }
	}

	Timer = 0;

	while( ReqHandle( MenuEdWnd, HandleMenuEdIDCMP ));
    }

    CloseMenuEdWindow();

    RemHead((struct List *)&IE.Img_List );

    if( IE.win_info->wi_NumMenus )
	IE.win_info->wi_IDCMP |= IDCMP_MENUPICK;

    UnlockAllWindows();

    return( TRUE );
}

BOOL ME_TitleClicked( void )
{
    UWORD   old = LastTitle;

    LastTitle = List2Tag[1] = List2Tag[3] = MenuEdMsg.Code;

    if( old == LastTitle ) {
	if( Timer < 3 )
	    ME_EditTitle( GetMenuSel() );
    } else {
	List2Tag2[1] = List2Tag2[3] = 0;
	AggiornaItemSub();
    }

    LastItem = LastSub = -1;

    Timer = 0;

    return( TRUE );
}

BOOL ME_ItemClicked( void )
{
    UWORD       old = LastItem;

    LastItem = List2Tag2[1] = List2Tag2[3] = MenuEdMsg.Code;

    if( old == LastItem ) {
	if( Timer < 3 )
	    ME_EditItem( GetItemSel() );
    } else {
	List2Tag3[1] = List2Tag3[3] = 0;
	AggiornaSub();
    }

    LastTitle = LastSub = -1;

    Timer = 0;

    return( TRUE );
}

BOOL ME_SubClicked( void )
{
    UWORD       old = LastSub;

    LastSub = List2Tag3[1] = List2Tag3[3] = MenuEdMsg.Code;

    LastTitle = LastItem = -1;

    if( Timer < 3 ) {
	if( LastSub == old ) {
	    ME_EditItem( (struct _MenuItem *)GetSubSel() );
	}
    }

    Timer = 0;

    return( TRUE );
}

BOOL ME_TNuovoClicked( void )
{
    struct MenuTitle   *menu;
    int                 ret;

    if( menu = AllocObject( IE_MENUTITLE )) {

	buffer4 = menu;

	LayoutWindow( MEEditWTags );
	ret = OpenMEEditWindow();
	PostOpenWindow( MEEditWTags );

	if( ret ) {
	    FreeObject( menu, IE_MENUTITLE );
	    DisplayBeep( Scr );
	} else {

	    RetCode = 0;

	    do {
		WaitPort( MEEditWnd->UserPort );
		HandleMEEditIDCMP();
	    } while(!( RetCode ));

	    strcpy( menu->mt_Text, GetString( MEEditGadgets[ GD_MEd_Txt ]) );
	    strcpy( menu->mt_Label, GetString( MEEditGadgets[ GD_MEd_Label ]) );

	    if( RetCode < 0 ) {

		StaccaMenuList();

		if(!( IE.win_info->wi_NumMenus ))
		    ME_AttivaTitle();

		List2Tag[1] = List2Tag[3] = IE.win_info->wi_NumMenus;
		IE.win_info->wi_NumMenus += 1;

		AddTail(( struct List * )&IE.win_info->wi_Menus, (struct Node *)menu );

		AttaccaMenuList();
		AggiornaItemSub();

		IE.flags &= ~SALVATO;

		LastTitle = -1;

	    } else {
		FreeObject( menu, IE_MENUTITLE );
	    }
	}

	CloseMEEditWindow();

    } else {
	Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, 0 );
    }

    return( TRUE );
}

BOOL ME_TSuClicked( void )
{
    if( List2Tag[1] ) {

	StaccaMenuList();

	NodeUp( GetMenuSel() );

	List2Tag[1] -= 1;
	List2Tag[3] = List2Tag[1];

	AttaccaMenuList();

	IE.flags &= ~SALVATO;
    }

    return( TRUE );
}

BOOL ME_TGiuClicked( void )
{
    if( List2Tag[1] < IE.win_info->wi_NumMenus - 1 ) {

	StaccaMenuList();

	NodeDown( GetMenuSel() );

	List2Tag[1] += 1;
	List2Tag[3] = List2Tag[1];

	AttaccaMenuList();

	IE.flags &= ~SALVATO;
    }

    return( TRUE );
}

BOOL ME_ISuClicked( void )
{
    if( List2Tag2[1] ) {

	StaccaItemList();

	NodeUp( GetItemSel() );

	List2Tag2[1] -= 1;
	List2Tag2[3] = List2Tag2[1];

	AttaccaItemList();

	IE.flags &= ~SALVATO;
    }

    return( TRUE );
}

BOOL ME_IGiuClicked( void )
{
    struct MenuTitle   *menu;

    menu = GetMenuSel();

    if( List2Tag2[1] < menu->mt_NumItems - 1 ) {

	StaccaItemList();

	NodeDown( GetItemSel() );

	List2Tag2[1] += 1;
	List2Tag2[3] = List2Tag2[1];

	AttaccaItemList();

	IE.flags &= ~SALVATO;
    }

    return( TRUE );
}

BOOL ME_SSuClicked( void )
{
    if( List2Tag3[1] ) {

	StaccaSubList();

	NodeUp( GetSubSel() );

	List2Tag3[1] -= 1;
	List2Tag3[3] = List2Tag3[1];

	AttaccaSubList();

	IE.flags &= ~SALVATO;
    }

    return( TRUE );
}

BOOL ME_SGiuClicked( void )
{
    struct _MenuItem   *item;

    item = GetItemSel();

    if( List2Tag3[1] < item->min_NumSubs - 1 ) {

	StaccaSubList();

	NodeDown( GetSubSel() );

	List2Tag3[1] += 1;
	List2Tag3[3] = List2Tag3[1];

	AttaccaSubList();

	IE.flags &= ~SALVATO;
    }

    return( TRUE );
}

BOOL ME_TDelClicked( void )
{
    struct MenuTitle   *menu;

    if( menu = GetMenuSel() ) {

	StaccaMenuList();

	Remove((struct Node *)menu );

	FreeObject( menu, IE_MENUTITLE );

	IE.win_info->wi_NumMenus -= 1;

	if( List2Tag[1] ) {
	    List2Tag[1] -= 1;
	    List2Tag[3] = List2Tag[1];
	}

	AttaccaMenuList();
	AggiornaItemSub();

	if(!( IE.win_info->wi_NumMenus )) {
	    ME_DisattivaTitle();
	    ME_DisattivaItem();
	    ME_DisattivaSub();
	}

	IE.flags &= ~SALVATO;
    }

    return( TRUE );
}

BOOL ME_IDelClicked( void )
{
    struct _MenuItem   *item;
    struct MenuTitle   *menu;

    if( item = GetItemSel() ) {

	StaccaItemList();

	Remove((struct Node *)item );

	FreeObject( item, IE_MENUITEM );

	menu = GetMenuSel();
	menu->mt_NumItems -= 1;

	if( List2Tag2[1] ) {
	    List2Tag2[1] -= 1;
	    List2Tag2[3] = List2Tag2[1];
	}

	AttaccaItemList();
	AggiornaSub();

	if(!( menu->mt_NumItems )) {
	    ME_DisattivaItem();
	    ME_DisattivaSub();
	}

	IE.flags &= ~SALVATO;
    }

    return( TRUE );
}

BOOL ME_SDelClicked( void )
{
    struct _MenuItem   *item;
    struct MenuSub     *sub;

    if( sub = GetSubSel() ) {

	StaccaSubList();

	Remove((struct Node *)sub );
	FreeObject( sub, IE_MENUSUB );

	item = GetItemSel();
	item->min_NumSubs -= 1;

	if( List2Tag3[1] ) {
	    List2Tag3[1] -= 1;
	    List2Tag3[3] = List2Tag3[1];
	}

	AttaccaSubList();

	if(!( item->min_NumSubs ))
	    ME_DisattivaSub();

	IE.flags &= ~SALVATO;
    }

    return( TRUE );
}

BOOL ME_SNuovoClicked( void )
{
    struct MenuSub     *sub;
    struct _MenuItem   *item;
    int                 ret;

    if( sub = AllocObject( IE_MENUSUB )) {

	buffer4 = sub;

	LayoutWindow( MEEditWTags );
	ret = OpenMEEditWindow();
	PostOpenWindow( MEEditWTags );

	if( ret ) {
	    FreeObject( sub, IE_MENUSUB );
	    DisplayBeep( Scr );
	} else {

	    ME_AttivaChecks();

	    RetCode = 0;
	    do {
		ReqHandle( MEEditWnd, HandleMEEditIDCMP );
	    } while(!( RetCode ));

	    if( sub->msn_Flags & M_BARLABEL )
		sub->msn_Node.ln_Name = Bar_txt;
	    else
		strcpy( sub->msn_Text, GetString( MEEditGadgets[ GD_MEd_Txt ]) );

	    strcpy( sub->msn_Label, GetString( MEEditGadgets[ GD_MEd_Label ]) );
	    strcpy( sub->msn_CommKey, GetString( MEEditGadgets[ GD_MEd_CmdK ]) );

	    if( RetCode < 0 ) {

		ME_AttivaSub();
		StaccaSubList();

		item = GetItemSel();
		List2Tag3[1] = List2Tag3[3] = item->min_NumSubs;
		item->min_NumSubs += 1;

		AddTail(( struct List * )&item->min_Subs, (struct Node *)sub );

		AttaccaSubList();

		IE.flags &= ~SALVATO;

		LastSub = -1;

	    } else {
		FreeObject( sub, IE_MENUSUB );
	    }
	}

	CloseMEEditWindow();

    } else {
	Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, 0 );
    }

    return( TRUE );
}

BOOL ME_INuovoClicked( void )
{
    struct MenuTitle   *menu;
    struct _MenuItem   *item;
    int                 ret;

    if( item = AllocObject( IE_MENUITEM )) {

	buffer4 = item;

	LayoutWindow( MEEditWTags );
	ret = OpenMEEditWindow();
	PostOpenWindow( MEEditWTags );

	if( ret ) {
	    FreeObject( item, IE_MENUITEM );
	    DisplayBeep( Scr );
	} else {

	    ME_AttivaChecks();

	    RetCode = 0;
	    do {
		ReqHandle( MEEditWnd, HandleMEEditIDCMP );
	    } while(!( RetCode ));

	    if( item->min_Flags & M_BARLABEL )
		item->min_Node.ln_Name = Bar_txt;
	    else
		strcpy( item->min_Text, GetString( MEEditGadgets[ GD_MEd_Txt ]) );
	    strcpy( item->min_Label, GetString( MEEditGadgets[ GD_MEd_Label ]) );
	    strcpy( item->min_CommKey, GetString( MEEditGadgets[ GD_MEd_CmdK ]) );

	    if( RetCode < 0 ) {

		ME_AttivaItem();
		StaccaItemList();

		menu = GetMenuSel();
		List2Tag2[1] = List2Tag2[3] = menu->mt_NumItems;
		menu->mt_NumItems += 1;

		AddTail(( struct List * )&menu->mt_Items, (struct Node *)item );

		AttaccaItemList();
		AggiornaSub();

		IE.flags &= ~SALVATO;

		LastItem = -1;

	    } else {
		FreeObject( item, IE_MENUITEM );
	    }
	}

	CloseMEEditWindow();

    } else {
	Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, 0 );
    }

    return( TRUE );
}
///
/// Routine di gestione del MenuEd
void StaccaMenuList( void )
{
    ListTag[1] = NULL;
    GT_SetGadgetAttrsA( MenuEdGadgets[ GD_ME_Title ], MenuEdWnd,
			NULL, (struct TagItem *)ListTag );
}

void AttaccaMenuList( void )
{
    ListTag[1] = &IE.win_info->wi_Menus;
    GT_SetGadgetAttrsA( MenuEdGadgets[ GD_ME_Title ], MenuEdWnd,
			NULL, (struct TagItem *)ListTag );
    GT_SetGadgetAttrsA( MenuEdGadgets[ GD_ME_Title ], MenuEdWnd,
			NULL, (struct TagItem *)List2Tag );
}

void StaccaItemList( void )
{
    ListTag[1] = NULL;
    GT_SetGadgetAttrsA( MenuEdGadgets[ GD_ME_Item ], MenuEdWnd,
			NULL, (struct TagItem *)ListTag );
}

void AttaccaItemList( void )
{
    struct MenuTitle *menu;

    menu = GetMenuSel();

    ListTag[1] = &menu->mt_Items;
    GT_SetGadgetAttrsA( MenuEdGadgets[ GD_ME_Item ], MenuEdWnd,
			NULL, (struct TagItem *)ListTag );
    GT_SetGadgetAttrsA( MenuEdGadgets[ GD_ME_Item ], MenuEdWnd,
			NULL, (struct TagItem *)List2Tag2 );
}

void StaccaSubList( void )
{
    ListTag[1] = NULL;
    GT_SetGadgetAttrsA( MenuEdGadgets[ GD_ME_Sub ], MenuEdWnd,
			NULL, (struct TagItem *)ListTag );
}

void AttaccaSubList( void )
{
    struct _MenuItem *item;

    item = GetItemSel();

    ListTag[1] = &item->min_Subs;
    GT_SetGadgetAttrsA( MenuEdGadgets[ GD_ME_Sub ], MenuEdWnd,
			NULL, (struct TagItem *)ListTag );
    GT_SetGadgetAttrsA( MenuEdGadgets[ GD_ME_Sub ], MenuEdWnd,
			NULL, (struct TagItem *)List2Tag3 );
}

void ME_AttivaTitle( void )
{
    struct Window  *wnd;

    if( TitleAct ) {

	TitleAct = FALSE;

	wnd = MenuEdWnd;

	DisableTag[1] = FALSE;

	GT_SetGadgetAttrsA( MenuEdGadgets[ GD_ME_Title ], MenuEdWnd,
			    NULL, (struct TagItem *)DisableTag );
	GT_SetGadgetAttrsA( MenuEdGadgets[ GD_ME_Item ], MenuEdWnd,
			    NULL, (struct TagItem *)DisableTag );
	GT_SetGadgetAttrsA( MenuEdGadgets[ GD_ME_INuovo ], MenuEdWnd,
			    NULL, (struct TagItem *)DisableTag );
	GT_SetGadgetAttrsA( MenuEdGadgets[ GD_ME_TDel ], MenuEdWnd,
			    NULL, (struct TagItem *)DisableTag );
    }

    OnGadget( &ME_TSuGadget, MenuEdWnd, NULL );
    OnGadget( &ME_TGiuGadget, MenuEdWnd, NULL );
}

void ME_AttivaItem( void )
{
    struct Window  *wnd;

    if( ItemAct ) {

	ItemAct = FALSE;

	wnd = MenuEdWnd;

	DisableTag[1] = FALSE;

	GT_SetGadgetAttrsA( MenuEdGadgets[ GD_ME_Sub ], MenuEdWnd,
			    NULL, (struct TagItem *)DisableTag );
	GT_SetGadgetAttrsA( MenuEdGadgets[ GD_ME_IDel ], MenuEdWnd,
			    NULL, (struct TagItem *)DisableTag );
	GT_SetGadgetAttrsA( MenuEdGadgets[ GD_ME_SNuovo ], MenuEdWnd,
			    NULL, (struct TagItem *)DisableTag );
	GT_SetGadgetAttrsA( MenuEdGadgets[ GD_ME_IExclude ], MenuEdWnd,
			    NULL, (struct TagItem *)DisableTag );
    }

    OnGadget( &ME_ISuGadget, MenuEdWnd, NULL );
    OnGadget( &ME_IGiuGadget, MenuEdWnd, NULL );
}

void ME_DisattivaItem( void )
{
    struct Window  *wnd;

    if(!( ItemAct )) {

	ItemAct = TRUE;

	wnd = MenuEdWnd;

	DisableTag[1] = TRUE;

	GT_SetGadgetAttrsA( MenuEdGadgets[ GD_ME_Sub ], MenuEdWnd,
			    NULL, (struct TagItem *)DisableTag );
	GT_SetGadgetAttrsA( MenuEdGadgets[ GD_ME_IDel ], MenuEdWnd,
			    NULL, (struct TagItem *)DisableTag );
	GT_SetGadgetAttrsA( MenuEdGadgets[ GD_ME_SNuovo ], MenuEdWnd,
			    NULL, (struct TagItem *)DisableTag );
	GT_SetGadgetAttrsA( MenuEdGadgets[ GD_ME_IExclude ], MenuEdWnd,
			    NULL, (struct TagItem *)DisableTag );
    }

    OffGadget( &ME_ISuGadget, MenuEdWnd, NULL );
    OffGadget( &ME_IGiuGadget, MenuEdWnd, NULL );
}

void ME_DisattivaTitle( void )
{
    struct Window  *wnd;

    if(!( TitleAct )) {

	TitleAct = TRUE;

	wnd = MenuEdWnd;

	DisableTag[1] = TRUE;

	GT_SetGadgetAttrsA( MenuEdGadgets[ GD_ME_Title ], MenuEdWnd,
			    NULL, (struct TagItem *)DisableTag );
	GT_SetGadgetAttrsA( MenuEdGadgets[ GD_ME_Item ], MenuEdWnd,
			    NULL, (struct TagItem *)DisableTag );
	GT_SetGadgetAttrsA( MenuEdGadgets[ GD_ME_INuovo ], MenuEdWnd,
			    NULL, (struct TagItem *)DisableTag );
	GT_SetGadgetAttrsA( MenuEdGadgets[ GD_ME_TDel ], MenuEdWnd,
			    NULL, (struct TagItem *)DisableTag );
    }

    OffGadget( &ME_TSuGadget, MenuEdWnd, NULL );
    OffGadget( &ME_TGiuGadget, MenuEdWnd, NULL );
}

void ME_AttivaSub( void )
{
    struct Window  *wnd;

    if( SubAct ) {

	SubAct = FALSE;

	wnd = MenuEdWnd;

	DisableTag[1] = FALSE;

	GT_SetGadgetAttrsA( MenuEdGadgets[ GD_ME_SDel ], MenuEdWnd,
			    NULL, (struct TagItem *)DisableTag );
	GT_SetGadgetAttrsA( MenuEdGadgets[ GD_ME_SExclude ], MenuEdWnd,
			    NULL, (struct TagItem *)DisableTag );
    }

    OnGadget( &ME_SSuGadget, MenuEdWnd, NULL );
    OnGadget( &ME_SGiuGadget, MenuEdWnd, NULL );
}

void ME_DisattivaSub( void )
{
    struct Window  *wnd;

    if(!( SubAct )) {

	SubAct = TRUE;

	wnd = MenuEdWnd;

	DisableTag[1] = TRUE;

	GT_SetGadgetAttrsA( MenuEdGadgets[ GD_ME_SDel ], MenuEdWnd,
			    NULL, (struct TagItem *)DisableTag );
	GT_SetGadgetAttrsA( MenuEdGadgets[ GD_ME_SExclude ], MenuEdWnd,
			    NULL, (struct TagItem *)DisableTag );
    }

    OffGadget( &ME_SSuGadget, MenuEdWnd, NULL );
    OffGadget( &ME_SGiuGadget, MenuEdWnd, NULL );
}

void ME_AttivaChecks( void )
{
    DisableTag[1] = FALSE;

    GT_SetGadgetAttrsA( MEEditGadgets[ GD_MEd_Bar ], MEEditWnd,
			NULL, (struct TagItem *)DisableTag );
    GT_SetGadgetAttrsA( MEEditGadgets[ GD_MEd_Toggle ], MEEditWnd,
			NULL, (struct TagItem *)DisableTag );
    GT_SetGadgetAttrsA( MEEditGadgets[ GD_MEd_ChkIt ], MEEditWnd,
			NULL, (struct TagItem *)DisableTag );
    GT_SetGadgetAttrsA( MEEditGadgets[ GD_MEd_Checked ], MEEditWnd,
			NULL, (struct TagItem *)DisableTag );
    GT_SetGadgetAttrsA( MEEditGadgets[ GD_MEd_Img ], MEEditWnd,
			NULL, (struct TagItem *)DisableTag );
    GT_SetGadgetAttrsA( MEEditGadgets[ GD_MEd_Label ], MEEditWnd,
			NULL, (struct TagItem *)DisableTag );
    GT_SetGadgetAttrsA( MEEditGadgets[ GD_MEd_CmdK ], MEEditWnd,
			NULL, (struct TagItem *)DisableTag );
}

void AggiornaItemSub( void )
{
    struct MenuTitle   *menu;
    struct _MenuItem   *item;

    StaccaItemList();
    StaccaSubList();

    if( menu = GetMenuSel() ) {

	if( menu->mt_NumItems ) {
	    ME_AttivaItem();
	    AttaccaItemList();

	    item = menu->mt_Items.mlh_Head;

	    if( item->min_NumSubs ) {
		ME_AttivaSub();
		List2Tag3[1] = List2Tag3[3] = 0;
		AttaccaSubList();
	    } else
		ME_DisattivaSub();

	} else
	    ME_DisattivaItem();
    }
}

void AggiornaSub( void )
{
    struct _MenuItem   *item;

    StaccaSubList();

    if( item = GetItemSel() ) {
	if( item->min_NumSubs ) {
	    ME_AttivaSub();
	    List2Tag3[1] = List2Tag3[3] = 0;
	    AttaccaSubList();
	} else {
	    ME_DisattivaSub();
	}
    } else {
	ME_DisattivaSub();
    }
}

struct MenuTitle *GetMenuSel( void )
{
    struct MenuTitle *menu;
    int               cnt;

    menu = (struct MenuTitle *)&IE.win_info->wi_Menus;
    for( cnt = 0; cnt <= List2Tag[1]; cnt++ ) {
	menu = menu->mt_Node.ln_Succ;
	if(!( menu->mt_Node.ln_Succ ))
	    return( NULL );
    }

    return( menu );
}

struct _MenuItem *GetItemSel( void )
{
    struct MenuTitle *menu;
    struct _MenuItem *item = NULL;
    int               cnt;

    if( menu = GetMenuSel() ) {

	if( menu->mt_NumItems ) {

	    item = (struct _MenuItem *)&menu->mt_Items;

	    for( cnt = 0; cnt <= List2Tag2[1]; cnt++ ) {
		item = item->min_Node.ln_Succ;
		if(!( item->min_Node.ln_Succ ))
		    return( NULL );
	    }
	}
    }

    return( item );
}

struct MenuSub *GetSubSel( void )
{
    struct _MenuItem *item;
    struct MenuSub   *sub = NULL;
    int               cnt;

    if( item = GetItemSel() ) {

	if( item->min_NumSubs ) {

	    sub = (struct MenuSub *)&item->min_Subs;

	    for( cnt = 0; cnt <= List2Tag3[1]; cnt++ ) {
		sub = sub->msn_Node.ln_Succ;
		if(!( sub->msn_Node.ln_Succ ))
		    return( NULL );
	    }
	}
    }

    return( sub );
}
///
/// Test Menu
BOOL ME_TestClicked( void )
{
    struct MenuTitle   *menu;
    struct _MenuItem   *item;
    struct MenuSub     *sub;
    struct NewMenu     *newmenu;
    ULONG               total, class;
    UWORD               num, flags;
    struct Menu        *menus;
    struct IntuiMessage *msg;
    struct Gadget      *gad;

    total = IE.win_info->wi_NumMenus + 1;

    for( menu = IE.win_info->wi_Menus.mlh_Head; menu->mt_Node.ln_Succ; menu = menu->mt_Node.ln_Succ ) {

	total += menu->mt_NumItems;

	for( item = menu->mt_Items.mlh_Head; item->min_Node.ln_Succ; item = item->min_Node.ln_Succ )
	    total += item->min_NumSubs;
    }

    total *= sizeof( struct NewMenu );

    if( newmenu = AllocMem( total, MEMF_CLEAR )) {

	num = 0;

	for( menu = IE.win_info->wi_Menus.mlh_Head; menu->mt_Node.ln_Succ; menu = menu->mt_Node.ln_Succ ) {

	    newmenu[ num ].nm_Type  = NM_TITLE;
	    newmenu[ num ].nm_Label = menu->mt_Node.ln_Name;
	    newmenu[ num ].nm_Flags = ( menu->mt_Flags & M_DISABLED ) ? NM_MENUDISABLED : 0;

	    for( item = menu->mt_Items.mlh_Head; item->min_Node.ln_Succ; item = item->min_Node.ln_Succ ) {

		num++;

		newmenu[ num ].nm_Type = item->min_Image ? IM_ITEM : NM_ITEM;

		if(!( item->min_Image ))
		    newmenu[ num ].nm_Label = ( item->min_Flags & M_BARLABEL ) ? (APTR)NM_BARLABEL : item->min_Node.ln_Name;
		else
		    newmenu[ num ].nm_Label = item->min_Image;

		if(!( item->min_NumSubs ))
		    if( item->min_CommKey[0] )
			newmenu[ num ].nm_CommKey = item->min_CommKey;

		flags = 0;

		if( item->min_Flags & M_DISABLED )
		    flags = NM_ITEMDISABLED;

		if( item->min_Flags & M_CHECKIT )
		    flags |= CHECKIT;

		if( item->min_Flags & M_CHECKED )
		    flags |= CHECKED;

		if( item->min_Flags & M_MENUTOGGLE )
		    flags |= MENUTOGGLE;

		if( item->min_CommKey[0] )
		    if( item->min_CommKey[1] )
			flags |= NM_COMMANDSTRING;

		newmenu[ num ].nm_Flags = flags;
		newmenu[ num ].nm_MutualExclude = item->min_MutualExclude;

		for( sub = item->min_Subs.mlh_Head; sub->msn_Node.ln_Succ; sub = sub->msn_Node.ln_Succ ) {

		    num++;

		    newmenu[ num ].nm_Type = sub->msn_Image ? IM_SUB : NM_SUB;

		    if(!( sub->msn_Image ))
			newmenu[ num ].nm_Label = ( sub->msn_Flags & M_BARLABEL ) ? (APTR)NM_BARLABEL : sub->msn_Node.ln_Name;
		    else
			newmenu[ num ].nm_Label = sub->msn_Image;

		    if( sub->msn_CommKey[0] )
			newmenu[ num ].nm_CommKey = sub->msn_CommKey;

		    flags = 0;

		    if( sub->msn_Flags & M_DISABLED )
			flags = NM_ITEMDISABLED;

		    if( sub->msn_Flags & M_CHECKIT )
			flags |= CHECKIT;

		    if( sub->msn_Flags & M_CHECKED )
			flags |= CHECKED;

		    if( sub->msn_Flags & M_MENUTOGGLE )
			flags |= MENUTOGGLE;

		    if( sub->msn_CommKey[0] )
			if( sub->msn_CommKey[1] )
			    flags |= NM_COMMANDSTRING;

		    newmenu[ num ].nm_Flags = flags;
		    newmenu[ num ].nm_MutualExclude = sub->msn_MutualExclude;
		}
	    }

	    num++;
	}

	if( menus = CreateMenusA( newmenu, NULL )) {

	    LayoutMenus( menus, VisualInfo, GTMN_NewLookMenus, TRUE, TAG_END );

	    SetMenuStrip( MenuEdWnd, menus );

	    flags = TRUE;

	    do {
		WaitPort( MenuEdWnd->UserPort );

		while( msg = GT_GetIMsg( MenuEdWnd->UserPort )) {

		    class = msg->Class;
		    gad   = msg->IAddress;

		    GT_ReplyIMsg( msg );

		    switch( class ) {
			case IDCMP_REFRESHWINDOW:
			    GT_BeginRefresh( MenuEdWnd );
			    GT_EndRefresh( MenuEdWnd, TRUE );
			    break;

			case IDCMP_GADGETUP:
			    if( gad->GadgetID == GD_ME_Test )
				flags = FALSE;
			    break;
		    }
		}
	    } while( flags );

	    ClearMenuStrip( MenuEdWnd );
	    FreeMenus( menus );

	} else
	    DisplayBeep( Scr );

	FreeMem( newmenu, total );

    } else
	Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, 0 );

    return( TRUE );
}
///
/// Edita un item/sub
BOOL MEd_ImgKeyPressed( void )
{
    MEd_ImgClicked();
}

BOOL MEd_ImgClicked( void )
{
    UWORD               cnt;
    WORD                num;
    struct ImageNode   *img;

    if( ApriListaFin( CatCompArray[ REQ_GETIMG ].cca_Str, REQ_GETIMG, &IE.Img_List )) {

	num = GestisciListaFin( EXIT, IE.NumImgs );
	ChiudiListaFin();

	if( num >= 0 ) {
	    if(!( num )) {
		((struct _MenuItem *)buffer4)->min_Image = NULL;
		TextTag[1] = "---";
	    } else {

		img = (struct ImageNode *)&IE.Img_List;
		for( cnt = 0; cnt <= num; cnt++ )
		    img = img->in_Node.ln_Succ;

		((struct _MenuItem *)buffer4)->min_Image = &img->in_Left;
		TextTag[1] = img->in_Node.ln_Name;
	    }

	    GT_SetGadgetAttrsA( MEEditGadgets[ GD_MEd_ImgDisp ], MEEditWnd,
				NULL, (struct TagItem *)TextTag );

	    IE.flags &= ~SALVATO;
	}
    }
}

void ME_EditTitle( struct MenuTitle *menu )
{
    int     ret;
    UBYTE   BackUpFlags;

    LayoutWindow( MEEditWTags );
    ret = OpenMEEditWindow();
    PostOpenWindow( MEEditWTags );

    if( ret ) {
	DisplayBeep( Scr );
    } else {

	BackUpFlags = menu->mt_Flags;

	MEd_SetChecks(( struct _MenuItem *)menu );

	StringTag[1] = menu->mt_Node.ln_Name;
	GT_SetGadgetAttrsA( MEEditGadgets[ GD_MEd_Txt ], MEEditWnd,
			    NULL, (struct TagItem *)StringTag );

	StringTag[1] = menu->mt_Label;
	GT_SetGadgetAttrsA( MEEditGadgets[ GD_MEd_Label ], MEEditWnd,
			    NULL, (struct TagItem *)StringTag );

	ActivateGadget( MEEditGadgets[ GD_MEd_Txt ], MEEditWnd, NULL );

	buffer4 = menu;

	RetCode = 0;

	do {
	    ReqHandle( MEEditWnd, HandleMEEditIDCMP );
	} while(!( RetCode ));

	if( RetCode < 0 ) {

	    StaccaMenuList();
	    strcpy( menu->mt_Text, GetString( MEEditGadgets[ GD_MEd_Txt ]) );
	    strcpy( menu->mt_Label, GetString( MEEditGadgets[ GD_MEd_Label ]) );
	    AttaccaMenuList();

	    IE.flags &= ~SALVATO;

	} else {
	    menu->mt_Flags = BackUpFlags;
	}
    }

    CloseMEEditWindow();
}

void ME_EditItem( struct _MenuItem *item )
{
    int                 ret;
    UBYTE               BackUpFlags;
    APTR                BackUpImage;
    struct ImageNode   *in;

    LayoutWindow( MEEditWTags );
    ret = OpenMEEditWindow();
    PostOpenWindow( MEEditWTags );

    if( ret ) {
	DisplayBeep( Scr );
    } else {

	BackUpFlags = item->min_Flags;
	BackUpImage = item->min_Image;

	buffer4 = item;

	MEd_SetChecks( item );
	ME_AttivaChecks();

	if( in = item->min_Image ) {
	    (ULONG)in -= 14;
	    TextTag[1] = in->in_Node.ln_Name;
	    GT_SetGadgetAttrsA( MEEditGadgets[ GD_MEd_ImgDisp ], MEEditWnd,
				NULL, (struct TagItem *)TextTag );
	}

	StringTag[1] = item->min_Node.ln_Name;
	GT_SetGadgetAttrsA( MEEditGadgets[ GD_MEd_Txt ], MEEditWnd,
			    NULL, (struct TagItem *)StringTag );

	StringTag[1] = item->min_Label;
	GT_SetGadgetAttrsA( MEEditGadgets[ GD_MEd_Label ], MEEditWnd,
			    NULL, (struct TagItem *)StringTag );

	StringTag[1] = item->min_CommKey;
	GT_SetGadgetAttrsA( MEEditGadgets[ GD_MEd_CmdK ], MEEditWnd,
			    NULL, (struct TagItem *)StringTag );

	DisableTag[1] = ( item->min_Flags & M_BARLABEL ) ? TRUE : FALSE;
	MEd_BarLabel();

	ActivateGadget( MEEditGadgets[ GD_MEd_Txt ], MEEditWnd, NULL );

	RetCode = 0;

	do {
	    ReqHandle( MEEditWnd, HandleMEEditIDCMP );
	} while(!( RetCode ));

	if( RetCode < 0 ) {

	    StaccaMenuList();

	    if( item->min_Flags & M_BARLABEL ) {
		item->min_Node.ln_Name = Bar_txt;
	    } else {
		item->min_Node.ln_Name = item->min_Text;
	    }

	    strcpy( item->min_Text, GetString( MEEditGadgets[ GD_MEd_Txt ]) );
	    strcpy( item->min_Label, GetString( MEEditGadgets[ GD_MEd_Label ]) );
	    strcpy( item->min_CommKey, GetString( MEEditGadgets[ GD_MEd_CmdK ]) );
	    AttaccaMenuList();

	    IE.flags &= ~SALVATO;

	} else {
	    item->min_Flags = BackUpFlags;
	    item->min_Image = BackUpImage;
	}
    }

    CloseMEEditWindow();
}

void MEd_BarLabel( void )
{
    GT_SetGadgetAttrsA( MEEditGadgets[ GD_MEd_Txt ], MEEditWnd,
			NULL, (struct TagItem *)DisableTag );
    GT_SetGadgetAttrsA( MEEditGadgets[ GD_MEd_Label ], MEEditWnd,
			NULL, (struct TagItem *)DisableTag );
    GT_SetGadgetAttrsA( MEEditGadgets[ GD_MEd_Img ], MEEditWnd,
			NULL, (struct TagItem *)DisableTag );
    GT_SetGadgetAttrsA( MEEditGadgets[ GD_MEd_CmdK ], MEEditWnd,
			NULL, (struct TagItem *)DisableTag );
    GT_SetGadgetAttrsA( MEEditGadgets[ GD_MEd_ChkIt ], MEEditWnd,
			NULL, (struct TagItem *)DisableTag );
    GT_SetGadgetAttrsA( MEEditGadgets[ GD_MEd_Checked ], MEEditWnd,
			NULL, (struct TagItem *)DisableTag );
    GT_SetGadgetAttrsA( MEEditGadgets[ GD_MEd_Toggle ], MEEditWnd,
			NULL, (struct TagItem *)DisableTag );
}

void MEd_SetChecks( struct _MenuItem *item )
{
    CheckedTag[1] = ( item->min_Flags & M_BARLABEL ) ? TRUE : FALSE;
    GT_SetGadgetAttrsA( MEEditGadgets[ GD_MEd_Bar ], MEEditWnd,
			NULL, (struct TagItem *)CheckedTag );

    CheckedTag[1] = ( item->min_Flags & M_DISABLED ) ? TRUE : FALSE;
    GT_SetGadgetAttrsA( MEEditGadgets[ GD_MEd_Disab ], MEEditWnd,
			NULL, (struct TagItem *)CheckedTag );

    CheckedTag[1] = ( item->min_Flags & M_CHECKIT ) ? TRUE : FALSE;
    GT_SetGadgetAttrsA( MEEditGadgets[ GD_MEd_ChkIt ], MEEditWnd,
			NULL, (struct TagItem *)CheckedTag );

    CheckedTag[1] = ( item->min_Flags & M_CHECKED ) ? TRUE : FALSE;
    GT_SetGadgetAttrsA( MEEditGadgets[ GD_MEd_Checked ], MEEditWnd,
			NULL, (struct TagItem *)CheckedTag );

    CheckedTag[1] = ( item->min_Flags & M_MENUTOGGLE ) ? TRUE : FALSE;
    GT_SetGadgetAttrsA( MEEditGadgets[ GD_MEd_Toggle ], MEEditWnd,
			NULL, (struct TagItem *)CheckedTag );
}

BOOL MEd_BarKeyPressed( void )
{
    CheckedTag[1] = ( ((struct _MenuItem *)buffer4)->min_Flags & M_BARLABEL ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( MEEditGadgets[ GD_MEd_Bar ], MEEditWnd,
			NULL, (struct TagItem *)CheckedTag );

    MEd_BarClicked();
}

BOOL MEd_BarClicked( void )
{
    ((struct _MenuItem *)buffer4)->min_Flags ^= M_BARLABEL;

    DisableTag[1] = ( ((struct _MenuItem *)buffer4)->min_Flags & M_BARLABEL ) ? TRUE : FALSE;
    MEd_BarLabel();
}

BOOL MEd_DisabKeyPressed( void )
{
    CheckedTag[1] = ( ((struct _MenuItem *)buffer4)->min_Flags & M_DISABLED ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( MEEditGadgets[ GD_MEd_Disab ], MEEditWnd,
			NULL, (struct TagItem *)CheckedTag );

    MEd_DisabClicked();
}

BOOL MEd_DisabClicked( void )
{
    ((struct _MenuItem *)buffer4)->min_Flags ^= M_DISABLED;
}

BOOL MEd_ChkItKeyPressed( void )
{
    CheckedTag[1] = ( ((struct _MenuItem *)buffer4)->min_Flags & M_CHECKIT ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( MEEditGadgets[ GD_MEd_ChkIt ], MEEditWnd,
			NULL, (struct TagItem *)CheckedTag );

    MEd_ChkItClicked();
}

BOOL MEd_ChkItClicked( void )
{
    ((struct _MenuItem *)buffer4)->min_Flags ^= M_CHECKIT;
}

BOOL MEd_CheckedKeyPressed( void )
{
    CheckedTag[1] = ( ((struct _MenuItem *)buffer4)->min_Flags & M_CHECKED ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( MEEditGadgets[ GD_MEd_Checked ], MEEditWnd,
			NULL, (struct TagItem *)CheckedTag );

    MEd_CheckedClicked();
}

BOOL MEd_CheckedClicked( void )
{
    ((struct _MenuItem *)buffer4)->min_Flags ^= M_CHECKED;
}

BOOL MEd_ToggleKeyPressed( void )
{
    CheckedTag[1] = ( ((struct _MenuItem *)buffer4)->min_Flags & M_MENUTOGGLE ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( MEEditGadgets[ GD_MEd_Toggle ], MEEditWnd,
			NULL, (struct TagItem *)CheckedTag );

    MEd_ToggleClicked();
}

BOOL MEd_ToggleClicked( void )
{
    ((struct _MenuItem *)buffer4)->min_Flags ^= M_MENUTOGGLE;
}

BOOL MEd_TxtClicked( void )
{
    if(!( MEEditGadgets[ GD_MEd_CmdK ]->Flags & GFLG_DISABLED ))
	ActivateGadget( MEEditGadgets[ GD_MEd_CmdK ], MEEditWnd, NULL );
}

BOOL MEd_CmdKClicked( void )
{
    ActivateGadget( MEEditGadgets[ GD_MEd_Label ], MEEditWnd, NULL );
}

BOOL MEd_LabelClicked( void )
{
}

BOOL MEd_OkClicked( void )
{
    RetCode = -1;
}

BOOL MEd_AnnullaClicked( void )
{
    RetCode = 1;
}

BOOL MEd_OkKeyPressed( void )
{
    RetCode = -1;
}

BOOL MEd_AnnullaKeyPressed( void )
{
    RetCode = 1;
}

BOOL MEEditVanillaKey( void )
{
    switch( MEEditMsg.Code ) {
	case 13:
	    RetCode = -1;
	    break;
	case 27:
	    RetCode = 1;
	    break;
    }
}
///
/// Edita i Mutual Exclude
void OpenMutualExclude( struct MinList *list, struct _MenuItem *item )
{
    int                 ret, cnt, num = -1;
    struct _MenuItem   *mi;
    struct _MenuItem  **back;
    ULONG               size = 0, mx = 0;

    NewList((struct List *)&Inc_List );
    NewList((struct List *)&Exc_List );
    NewList((struct List *)&Other_List );

    for( mi = list->mlh_Head; mi->min_Node.ln_Succ; mi = mi->min_Node.ln_Succ )
	size += sizeof( struct _MenuItem * );

    if(!( back = AllocMem( size, MEMF_ANY ))) {
	Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, 0 );
	return;
    }

    while( mi = RemHead((struct List *)list )) {

	num += 1;

	back[ num ] = mi;

	if(( mi->min_Flags & M_BARLABEL ) || ( mi == item )) {
	    AddTail((struct List *)&Other_List, (struct Node *)mi );
	} else {
	    if( item->min_MutualExclude & ( 1 << num )) {
		AddTail((struct List *)&Exc_List, (struct Node *)mi );
	    } else {
		AddTail((struct List *)&Inc_List, (struct Node *)mi );
	    }
	}
    }

    VarA = VarB = -1;

    LayoutWindow( MutualXWTags );
    ret = OpenMutualXWindow();
    PostOpenWindow( MutualXWTags );

    if( ret ) {
	DisplayBeep( Scr );
    } else {

	MX_AttaccaIncList();
	MX_AttaccaExcList();

	RetCode = 0;

	do {
	    ReqHandle( MutualXWnd, HandleMutualXIDCMP );
	} while(!( RetCode ));

	if( RetCode < 0 ) {

	    for( mi = Exc_List.mlh_Head; mi->min_Node.ln_Succ; mi = mi->min_Node.ln_Succ ) {

		cnt = 0;
		while( back[ cnt ] != mi )
		    cnt++;

		mx |= 1 << cnt;
	    }

	    item->min_MutualExclude = mx;
	}
    }

    for( cnt = 0; cnt <= num; cnt++ )
	AddTail((struct List *)list, (struct Node *)back[ cnt ]);

    CloseMutualXWindow();

    FreeMem( back, size );
}

void MX_StaccaExcList( void )
{
    ListTag[1] = NULL;
    GT_SetGadgetAttrsA( MutualXGadgets[ GD_MX_Exc ], MutualXWnd,
			NULL, (struct TagItem *)ListTag );
}

void MX_AttaccaExcList( void )
{
    ListTag[1] = &Exc_List;
    GT_SetGadgetAttrsA( MutualXGadgets[ GD_MX_Exc ], MutualXWnd,
			NULL, (struct TagItem *)ListTag );
}

void MX_StaccaIncList( void )
{
    ListTag[1] = NULL;
    GT_SetGadgetAttrsA( MutualXGadgets[ GD_MX_Inc ], MutualXWnd,
			NULL, (struct TagItem *)ListTag );
}

void MX_AttaccaIncList( void )
{
    ListTag[1] = &Inc_List;
    GT_SetGadgetAttrsA( MutualXGadgets[ GD_MX_Inc ], MutualXWnd,
			NULL, (struct TagItem *)ListTag );
}

// Esclude tutti i nodi
BOOL MX_ExAllClicked( void )
{
    struct Node *node;

    MX_StaccaIncList();
    MX_StaccaExcList();

    while( node = RemHead((struct List *)&Inc_List ))
	AddTail((struct List *)&Exc_List, node );

    MX_AttaccaIncList();
    MX_AttaccaExcList();

    VarA = VarB = -1;

    IE.flags &= ~SALVATO;
}

BOOL MX_IncAllClicked( void )
{
    struct Node *node;

    MX_StaccaIncList();
    MX_StaccaExcList();

    while( node = RemHead((struct List *)&Exc_List ))
	AddTail((struct List *)&Inc_List, node );

    MX_AttaccaIncList();
    MX_AttaccaExcList();

    VarA = VarB = -1;

    IE.flags &= ~SALVATO;
}

BOOL MX_IncClicked( void )
{
    VarA = MutualXMsg.Code;
}

BOOL MX_ExcClicked( void )
{
    VarB = MutualXMsg.Code;
}

BOOL MX_ExThisClicked( void )
{
    struct Node    *node;
    int             cnt;

    if( VarA >= 0 ) {

	node = Inc_List.mlh_Head;
	for( cnt = 0; cnt < VarA; cnt++ )
	    node = node->ln_Succ;

	MX_StaccaIncList();
	MX_StaccaExcList();

	Remove( node );
	AddTail((struct List *)&Exc_List, node );

	MX_AttaccaIncList();
	MX_AttaccaExcList();
    }

    VarA = VarB = -1;
    IE.flags &= ~SALVATO;
}

BOOL MX_IncThisClicked( void )
{
    struct Node    *node;
    int             cnt;

    if( VarB >= 0 ) {

	node = Exc_List.mlh_Head;
	for( cnt = 0; cnt < VarB; cnt++ )
	    node = node->ln_Succ;

	MX_StaccaIncList();
	MX_StaccaExcList();

	Remove( node );
	AddTail((struct List *)&Inc_List, node );

	MX_AttaccaIncList();
	MX_AttaccaExcList();
    }

    VarA = VarB = -1;
    IE.flags &= ~SALVATO;
}

BOOL MX_OkClicked( void )
{
    RetCode = -1;
}

BOOL MX_AnnullaClicked( void )
{
    RetCode = 1;
}
///

//      Banco Immagini
/// Banco Immagini
BOOL OpenImgBankClicked( void )
{
    return( ImgBankMenued() );
}

static ULONG    IB_ListTag[] = { GTLV_Top, 0, GTLV_Selected, 0, TAG_END };

BOOL ImgBankMenued( void )
{
    int                 ret;
    UWORD               y = Scr->WBorTop + Scr->Font->ta_YSize + 1;
    UWORD               y2 = Scr->WBorBottom + 1;
    struct ImageNode   *img;

    if( ImgBankWnd )    /*  Already open?   */
	return( TRUE );

    if((( struct Library * )SysBase )->lib_Version >= 39 )
	IB_ListTag[1] = GTLV_MakeVisible;

    LayoutWindow( ImgBankWTags );
    ret = OpenImgBankWindow();
    PostOpenWindow( ImgBankWTags );

    if( ret ) {
	DisplayBeep( Scr );
	CloseImgBankWindow();
    } else {

	SetAPen( ImgBankWnd->RPort, 2 );
	Move( ImgBankWnd->RPort, 232, y );
	Draw( ImgBankWnd->RPort, 232, ImgBankWnd->Height - y2 );

	SetAPen( ImgBankWnd->RPort, 1 );
	Move( ImgBankWnd->RPort, 233, y );
	Draw( ImgBankWnd->RPort, 233, ImgBankWnd->Height - y2 );

	buffer2 = FALSE;

	if( IE.NumImgs ) {

	    buffer2 = TRUE;

	    IB_ListTag[1] = IB_ListTag[3] = 0;
	    AttaccaImgList();

	    img = IE.Img_List.mlh_Head;

	    DrawImg( ImgBankWnd, img, 235, 1 );

	    DisableTag[1] = FALSE;
	    GT_SetGadgetAttrsA( ImgBankGadgets[ GD_IB_Label ], ImgBankWnd,
				NULL, (struct TagItem *)DisableTag );
	    GT_SetGadgetAttrsA( ImgBankGadgets[ GD_IB_Del ], ImgBankWnd,
				NULL, (struct TagItem *)DisableTag );

	    StringTag[1] = img->in_Node.ln_Name;
	    GT_SetGadgetAttrsA( ImgBankGadgets[ GD_IB_Label ], ImgBankWnd,
				NULL, (struct TagItem *)StringTag );
	}

	ImgBankWnd->ExtData = HandleImgBank;
    }

    return( TRUE );
}

void HandleImgBank( void )
{
    if(!( HandleImgBankIDCMP() ))
	CloseImgBankWindow();
}

BOOL ImgBankCloseWindow( void )
{
    return( FALSE );
}

BOOL IB_NewKeyPressed( void )
{
    return( IB_NewClicked() );
}

BOOL IB_NewClicked( void )
{
    struct ImageNode       *img;
    UWORD                   ret;
    struct BitMapHeader    *bmh;
    struct ContextNode     *cn;
    BYTE                   *buf, *dest, *buf2;

    if( img = AllocObject( IE_IMAGE )) {
	BOOL ok = FALSE;

	if( GetImgFile( FALSE, CatCompArray[ ASL_LOADIMG ].cca_Str, ASL_LOADIMG, NULL )) {
	    struct IFFHandle       *iff;

	    if( iff = AllocIFF() ) {
		if( iff->iff_Stream = Open( allpath, MODE_OLDFILE )) {

		    InitIFFasDOS( iff );

		    if(!( OpenIFF( iff, IFFF_READ ))) {

			PropChunk( iff, 'ILBM', 'BMHD' );
			StopChunk( iff, 'ILBM', 'BODY' );

			ret = ParseIFF( iff, IFFPARSE_SCAN );

			if(( ret == 0 ) || ( ret == IFFERR_EOF )) {
			    struct StoredProperty  *prop;

			    if( prop = FindProp( iff, 'ILBM', 'BMHD' )) {
				UWORD   RowBytes;
				ULONG   PlaneSize;

				bmh = prop->sp_Data;

				img->in_Width  = bmh->w;
				img->in_Height = bmh->h;
				img->in_Depth  = bmh->nPlanes;

				RowBytes     = ((( img->in_Width + 15 ) & 0xFFF0 ) >> 3 );
				PlaneSize    = RowBytes * img->in_Height;
				img->in_Size = PlaneSize * img->in_Depth;

				if( img->in_Data = AllocMem( img->in_Size, MEMF_CHIP | MEMF_CLEAR )) {

				    cn = CurrentChunk( iff );

				    if( cn->cn_ID == 'BODY' ) {

					if( buf = AllocVec( cn->cn_Size, MEMF_CLEAR )) {

					    buf2 = buf;

					    ReadChunkBytes( iff, buf, cn->cn_Size );

					    switch( bmh->compression ) {
						ULONG   c;
						case 0:
						    for( c = 0; c < img->in_Height; c++ ) {
							dest = img->in_Data;

							ULONG   d;
							for( d = 0; d < img->in_Depth; d++ ) {
							    BYTE   *dest2;

							    dest2 = dest + ( c * RowBytes );

							    ULONG   e;
							    for( e = 0; e < RowBytes; e++ )
								*dest2++ = *buf++;

							    dest += PlaneSize;
							}
						    }
						    ok = TRUE;
						    break;

						case 1:
						    for( c = 0; c < img->in_Height; c++ ) {
							ULONG   d;

							dest = img->in_Data;

							for( d = 0; d < img->in_Depth; d++ ) {
							    BYTE   *dest2;
							    ULONG   e;

							    dest2 = dest + ( c * RowBytes );

							    e = 0;

							    do {
								BYTE    new;

								new = *buf++;

								if( new >= 0 ) {
								    ULONG   f;

								    new += 1;
								    e   += new;

								    for( f = 0; f < new; f++ )
									*dest2++ = *buf++;

								} else if( new != -128 ) {
								    ULONG   f;
								    BYTE    put;

								    new  = -new + 1;
								    e   += new;
								    put  = *buf++;

								    for( f = 0; f < new; f++ )
									*dest2++ = put;
								}

							    } while( e < RowBytes );

							    dest += PlaneSize;
							}
						    }
						    ok = TRUE;
						    break;

						default:
						    Stat("Unknown IFF-ILBM compression type!", TRUE, 0 );
						    break;
					    }

					    FreeVec( buf2 );

					    if( ok ) {

						img->in_PlanePick = ( 0xFF >> ( 8 - img->in_Depth ));

						AnalyseBitmap( img );

						ClrImgSpace();
						DrawImg( ImgBankWnd, img, 235, 1 );
						RefreshWindowFrame( ImgBankWnd );

						dest = img->in_Node.ln_Name = img->in_Label;
						buf = ImageFile;

						BYTE    new;
						while( new = *buf++ ) {
						    if( new == '.' )
							new = '_';
						    *dest++ = new;
						}
						*dest = '\0';

						StaccaImgList();
						AddTail((struct List *)&IE.Img_List, (struct Node *)img );
						IB_ListTag[1] = IB_ListTag[3] = IE.NumImgs;
						IE.NumImgs += 1;
						AttaccaImgList();

						IE.flags &= ~SALVATO;

						if( IE.NumImgs == 1 ) {
						    DisableTag[1] = FALSE;
						    GT_SetGadgetAttrsA( ImgBankGadgets[ GD_IB_Label ], ImgBankWnd,
									NULL, (struct TagItem *)DisableTag );
						    GT_SetGadgetAttrsA( ImgBankGadgets[ GD_IB_Del ], ImgBankWnd,
									NULL, (struct TagItem *)DisableTag );
						    buffer2 = TRUE;
						}

						StringTag[1] = img->in_Node.ln_Name;
						GT_SetGadgetAttrsA( ImgBankGadgets[ GD_IB_Label ], ImgBankWnd,
								    NULL, (struct TagItem *)StringTag );
					    }
					}
				    }
				}
			    }

			} else
			    Stat( CatCompArray[ ERR_IOERR ].cca_Str, TRUE, ERR_IOERR );

			CloseIFF( iff );
		    }

		    Close( iff->iff_Stream );

		} else
		    Stat( CatCompArray[ ERR_IOERR ].cca_Str, TRUE, ERR_IOERR );

		FreeIFF( iff );

	    } else
		DisplayBeep( Scr );
	}

	if(!( ok )) {
	    if( img->in_Data )
		FreeMem( img->in_Data, img->in_Size );
	    FreeObject( img, IE_IMAGE );
	}

    } else
	Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, ERR_NOMEMORY );

    return( TRUE );
}

BOOL IB_ImgsKeyPressed( void )
{
    if(!( IDCMPMsg.Code & 0x20 )) {
	if( IB_ListTag[1] )
	    IB_ListTag[1] -= 1;
	else
	    IB_ListTag[1] = IE.NumImgs - 1;
    } else {
	if( IB_ListTag[1] < IE.NumImgs - 1 )
	    IB_ListTag[1] += 1;
	else
	    IB_ListTag[1] = 0;
    }

    IB_ListTag[3] = IDCMPMsg.Code = IB_ListTag[1];
    GT_SetGadgetAttrsA( ImgBankGadgets[ GD_IB_Imgs ], ImgBankWnd,
			NULL, (struct TagItem *)IB_ListTag );

    return( IB_ImgsClicked() );
}

BOOL IB_ImgsClicked( void )
{
    struct ImageNode   *img;
    int                 cnt;

    IB_ListTag[1] = IB_ListTag[3] = IDCMPMsg.Code;

    img = (struct ImageNode *)&IE.Img_List;
    for( cnt = 0; cnt <= IDCMPMsg.Code; cnt++ )
	img = img->in_Node.ln_Succ;

    ClrImgSpace();
    DrawImg( ImgBankWnd, img, 235, 1 );
    RefreshWindowFrame( ImgBankWnd );

    StringTag[1] = img->in_Node.ln_Name;
    GT_SetGadgetAttrsA( ImgBankGadgets[ GD_IB_Label ], ImgBankWnd,
			NULL, (struct TagItem *)StringTag );

    return( TRUE );
}

BOOL IB_LabelClicked( void )
{
    struct ImageNode   *img;
    int                 cnt;

    img = (struct ImageNode *)&IE.Img_List;
    for( cnt = 0; cnt <= IB_ListTag[1]; cnt++ )
	img = img->in_Node.ln_Succ;

    StaccaImgList();
    strcpy( img->in_Label, GetString( ImgBankGadgets[ GD_IB_Label ]) );
    AttaccaImgList();

    return( TRUE );
}

BOOL IB_DelKeyPressed( void )
{
    if( buffer2 )
	return( IB_DelClicked() );
    else
	return( TRUE );
}

BOOL IB_DelClicked( void )
{
    struct MenuTitle   *menu;
    struct _MenuItem   *item;
    struct MenuSub     *sub;
    struct BooleanInfo *gad;
    struct WindowInfo  *wnd;
    struct ImageNode   *img, *img2;
    struct Image       *image;
    struct WndImages   *wim;
    int                 cnt;
    BOOL                usata = FALSE;
    UWORD               old;

    img = (struct ImageNode *)&IE.Img_List;
    for( cnt = 0; cnt <= IB_ListTag[1]; cnt++ )
	img = img->in_Node.ln_Succ;

    if( old = IB_ListTag[1] ) {
	IB_ListTag[1] -= 1;
	IB_ListTag[3] = IB_ListTag[1];
    }

    image = &img->in_Left;

    for( wnd = IE.win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {

	for( wim = wnd->wi_Images.mlh_Head; wim->wim_Next; wim = wim->wim_Next ) {
	    if( wim->wim_ImageNode == img )
		usata = TRUE;
	}

	for( gad = wnd->wi_Gadgets.mlh_Head; gad->b_Node.ln_Succ; gad = gad->b_Node.ln_Succ ) {
	    if( gad->b_Kind == BOOLEAN ) {
		if(( gad->b_GadgetRender == image ) || ( gad->b_SelectRender == image ))
		    usata = TRUE;
	    }
	}

	for( menu = wnd->wi_Menus.mlh_Head; menu->mt_Node.ln_Succ; menu = menu->mt_Node.ln_Succ ) {
	    for( item = menu->mt_Items.mlh_Head; item->min_Node.ln_Succ; item = item->min_Node.ln_Succ ) {
		if( item->min_Image == image )
		    usata = TRUE;
		for( sub = item->min_Subs.mlh_Head; sub->msn_Node.ln_Succ; sub = sub->msn_Node.ln_Succ ) {
		    if( sub->msn_Image == image )
			usata = TRUE;
		}
	    }
	}
    }

    if( usata ) {
	if(!( IERequest( CatCompArray[ MSG_IMGUSED ].cca_Str,
			 CatCompArray[ ANS_YES_NO  ].cca_Str,
			 MSG_IMGUSED, ANS_YES_NO ))) {

	    IB_ListTag[1] = IB_ListTag[3] = old;
	    return( TRUE );
	}

	    for( wnd = IE.win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {

		for( wim = wnd->wi_Images.mlh_Head; wim->wim_Next; wim = wim->wim_Next ) {
		    if( wim->wim_ImageNode == img ) {
			Remove((struct Node *)wim );
			FreeObject( wim, IE_WNDIMAGE );
		    }
		}

		for( gad = wnd->wi_Gadgets.mlh_Head; gad->b_Node.ln_Succ; gad = gad->b_Node.ln_Succ ) {
		    if( gad->b_Kind == BOOLEAN ) {

			if( gad->b_GadgetRender == image )
			    gad->b_GadgetRender = NULL;

			if( gad->b_SelectRender == image )
			    gad->b_SelectRender = NULL;
		    }
		}

		for( menu = wnd->wi_Menus.mlh_Head; menu->mt_Node.ln_Succ; menu = menu->mt_Node.ln_Succ ) {
		    for( item = menu->mt_Items.mlh_Head; item->min_Node.ln_Succ; item = item->min_Node.ln_Succ ) {

			if( item->min_Image == image )
			    item->min_Image = NULL;

			for( sub = item->min_Subs.mlh_Head; sub->msn_Node.ln_Succ; sub = sub->msn_Node.ln_Succ ) {
			    if( sub->msn_Image == image )
				sub->msn_Image = NULL;
			}
		    }
		}
	    }
	}

    img2 = img->in_Node.ln_Pred;

    if(!( img2->in_Node.ln_Pred ))
	img2 = img->in_Node.ln_Succ;

    StaccaImgList();
    Remove((struct Node *)img );
    AttaccaImgList();

    if( img->in_Data )
	FreeMem( img->in_Data, img->in_Size );

    FreeObject( img, IE_IMAGE );

    IE.NumImgs -= 1;

    ClrImgSpace();

    if( IE.NumImgs ) {
	DrawImg( ImgBankWnd, img2, 235, 1 );

	StringTag[1] = img2->in_Node.ln_Name;
	GT_SetGadgetAttrsA( ImgBankGadgets[ GD_IB_Label ], ImgBankWnd,
			    NULL, (struct TagItem *)StringTag );
    } else {
	DisableTag[1] = TRUE;
	GT_SetGadgetAttrsA( ImgBankGadgets[ GD_IB_Label ], ImgBankWnd,
			    NULL, (struct TagItem *)DisableTag );
	GT_SetGadgetAttrsA( ImgBankGadgets[ GD_IB_Del ], ImgBankWnd,
			    NULL, (struct TagItem *)DisableTag );
	buffer2 = FALSE;
    }

    IE.flags &= ~SALVATO;

    return( TRUE );
}

void StaccaImgList( void )
{
    ListTag[1] = NULL;
    GT_SetGadgetAttrsA( ImgBankGadgets[ GD_IB_Imgs ], ImgBankWnd,
			NULL, (struct TagItem *)ListTag );
}

void AttaccaImgList( void )
{
    ListTag[1] = &IE.Img_List;
    GT_SetGadgetAttrsA( ImgBankGadgets[ GD_IB_Imgs ], ImgBankWnd,
			NULL, (struct TagItem *)ListTag );
    GT_SetGadgetAttrsA( ImgBankGadgets[ GD_IB_Imgs ], ImgBankWnd,
			NULL, (struct TagItem *)IB_ListTag );
}
///
/// Analyse Bitmap
void AnalyseBitmap( struct ImageNode *img )
{
    UBYTE   oldPP;
    ULONG   PlaneSize, elimina, oldsize;
    UWORD   RowBytes, resto, bytes, c, d, e;
    UBYTE   *ptr, *ptr2, *ptr3, new, mask2, mask, byte;

    oldPP       = img->in_PlanePick;
    PlaneSize   = img->in_Size / img->in_Depth;
    RowBytes    = (( img->in_Width + 15 ) & 0xFFF0 ) >> 3;
    resto       = img->in_Width % 8;
    bytes       = img->in_Width >> 3;
    mask2       = 0x01;
    elimina     = 0;

    if( resto )
	bytes -= 1;

    ptr3 = img->in_Data;

    for( c = 0; c < img->in_Depth; c++ ) {
	ptr = ptr3;
	new = *ptr;

	if(( new == 0 ) || ( new == 0xFF )) {
	    for( d = 0; d < img->in_Height; d++ ) {
		ptr2 = ptr;
		for( e = 0; e < bytes; e++ ) {
		    if( *ptr2++ != new )
			goto next_plane;
		}

		if( resto ) {
		    mask = 0x80;
		    byte = *ptr2;
		    if( new ) {
			for( e = 0; e < resto; e++ ) {
			    if(!( byte & mask ))
				goto next_plane;
			    mask >>= 1;
			}
		    } else {
			for( e = 0; e < resto; e++ ) {
			    if( byte & mask )
				goto next_plane;
			    mask >>= 1;
			}
		    }
		}

		ptr += RowBytes;
	    }
	} else {
	    goto next_plane;
	}

	img->in_PlanePick  &= ~mask2;

	if( new )
	    img->in_PlaneOnOff |=  mask2;

	elimina += PlaneSize;

next_plane:
	ptr3 += PlaneSize;
	mask2 <<= 1;
    }

    if( oldPP != img->in_PlanePick ) {

	ptr2 = ptr3 = img->in_Data;
	oldsize     = img->in_Size;

	if( img->in_Size - elimina ) {
	    if( ptr = AllocMem( img->in_Size - elimina, MEMF_CHIP | MEMF_CLEAR )) {

		img->in_Data =  ptr;
		img->in_Size -= elimina;

		mask = 1;
		for( c = 0; c < img->in_Depth; c++ ) {
		    if( img->in_PlanePick & mask ) {
			CopyMem( ptr3, ptr, PlaneSize );
		    }
		    ptr3 += PlaneSize;
		    ptr  += PlaneSize;
		    mask <<= 1;
		}

	    } else {
		img->in_PlanePick = oldPP;
		return;
	    }
	} else {
	    img->in_Data = NULL;
	    img->in_Size = 0L;
	}
	FreeMem( ptr2, oldsize );
    }
}
///
/// Draw Img & ClearImgSpace
void DrawImg( struct Window *wnd, struct ImageNode *img, WORD x, WORD y )
{
    DrawImage( wnd->RPort, (struct Image *)&img->in_Left, x, y + YOffset );
}

void ClrImgSpace( void )
{
    EraseRect( ImgBankWnd->RPort, 235, YOffset + 1,
	       ImgBankWnd->Width - Scr->WBorRight - 1,
	       ImgBankWnd->Height - Scr->WBorBottom - 1 );
}
///
/// FreeImgList
void FreeImgList( void )
{
    struct ImageNode   *img;

    while( img = RemTail((struct List *)&IE.Img_List )) {
	if( img->in_Data )
	    FreeMem( img->in_Data, img->in_Size );
	FreeObject( img, IE_IMAGE );
    }

    IE.NumImgs = 0;
}
///
