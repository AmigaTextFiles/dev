/// Include
#include <stdarg.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>


#define INTUI_V36_NAMES_ONLY
#define ASL_V38_NAMES_ONLY
#define CATCOMP_NUMBERS

#include <exec/libraries.h>             // exec
#include <exec/nodes.h>
#include <exec/lists.h>
#include <exec/memory.h>
#include <exec/io.h>
#include <intuition/intuition.h>        // intuition
#include <intuition/screens.h>
#include <graphics/text.h>              // graphics
#include <graphics/view.h>
#include <graphics/rastport.h>
#include <libraries/gadtools.h>         // libraries
#include <libraries/reqtools.h>
#include <devices/printer.h>
#include <clib/exec_protos.h>           // protos
#include <clib/intuition_protos.h>
#include <clib/graphics_protos.h>
#include <clib/locale_protos.h>
#include <clib/reqtools_protos.h>
#include <pragmas/exec_pragmas.h>       // pragmas
#include <pragmas/intuition_pragmas.h>
#include <pragmas/graphics_pragmas.h>
#include <pragmas/locale_pragmas.h>
#include <pragmas/reqtools_pragmas.h>
#include <pragmas/gadtools_pragmas.h>


#include "DEV_IE:defs.h"
#include "DEV_IE:GUI.h"
#include "DEV_IE:GUI_locale.h"
#include "DEV_IE:Include/expanders.h"
#include "DEV_IE:Include/expander_pragmas.h"
///
/// Prototipi
BOOL    EditText( struct ITextNode * );
BOOL    MoveText( struct ITextNode * );
UBYTE   MoveRect( UWORD, UWORD, struct MyRect * );
struct BevelBoxNode *GetBoxSel( void );
void    BB_Update( void );
void    BB_MoveUp( struct BevelBoxNode * );
void    BB_MoveDown( struct BevelBoxNode * );
void    BB_MoveLeft( struct BevelBoxNode * );
void    BB_MoveRight( struct BevelBoxNode * );
void    EndBoxMove( void );
void    BB_SistemaXYGads( void );
void    BB_SistemaRecessed( struct BevelBoxNode * );
void    BB_SistemaType( struct BevelBoxNode * );
void    BB_EDable( BOOL );
BOOL    BB_CheckResize( void );
void    MuoviBoxes( WORD, WORD );
void    EditingBox( BOOL );
///
/// Dati
ULONG WorkWndTags[] = {
    WA_Flags,      W_F,
    WA_Top,         60,
    WA_Left,        80,
    WA_Width,      400,
    WA_Height,      80,
    WA_Title,        0,
    WA_CustomScreen, 0,
    WA_Gadgets,      0,
    WA_MinWidth,    30,
    WA_MaxWidth,    -1,
    WA_MinHeight,   12,
    WA_MaxHeight,   -1,
    WA_MouseQueue,   1,
    TAG_END
    };


BOOL    Locked;
APTR    BackLock, ToolsLock;

UWORD   NewWinID;
///



/// Lock delle finestre
void LockAllWindows( void )
{
    struct WindowInfo *wnd;

    if (!( Locked )) {

	Locked = TRUE;

	BackLock    = rtLockWindow( BackWnd  );

	if( ToolsWnd )
	    ToolsLock   = rtLockWindow( ToolsWnd );

	for( wnd = IE.win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	    if(( wnd->wi_flags1 & W_APERTA ) && ( wnd->wi_winptr )) {
		wnd->wi_Lock = rtLockWindow( wnd->wi_winptr );
//                ModifyIDCMP( wnd->wi_winptr, wnd->wi_winptr->IDCMPFlags & ~IDCMP_REFRESHWINDOW );
	    }
	}
    }
}


void UnlockAllWindows( void )
{
    struct WindowInfo *wnd;
    APTR   b1, b2;

    if ( Locked ) {

	if( BackLock ) {
	    rtUnlockWindow( BackWnd, BackLock );
	    BackLock = NULL;
	}

	if( ToolsLock ) {
	    rtUnlockWindow( ToolsWnd, ToolsLock );
	    ToolsLock = NULL;
	}

	b1 = IE.win_info;
	b2 = IE.win_active;

	for( wnd = IE.win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	    if(( wnd->wi_flags1 & W_APERTA ) && ( wnd->wi_Lock )) {

		rtUnlockWindow( wnd->wi_winptr, wnd->wi_Lock );
		wnd->wi_Lock = NULL;

		SetPointer( wnd->wi_winptr, puntatore, 13, 16, -7, -6 );
		IE.win_info = wnd;
		IE.win_active = wnd->wi_winptr;
//                RinfrescaFinestra();
//                ModifyIDCMP( wnd->wi_winptr, wnd->wi_winptr->IDCMPFlags | IDCMP_REFRESHWINDOW );
	    }
	}

	IE.win_info = b1;
	IE.win_active = b2;

	Locked = FALSE;
    }
}
///

/// OpenWindowShdIDCMP e CloseWindowSafely
struct Window *OpenWindowShdIDCMP( ULONG *tags, ULONG IDCMP )
{
    struct Window *wnd;

    if( wnd = OpenWindowTagList( NULL, (struct TagItem *)tags )) {
	wnd->UserPort = IDCMP_Port;
	ModifyIDCMP( wnd, IDCMP );
    }

    return( wnd );
}


void CloseWindowSafely( struct Window *Wnd )
{
    struct IntuiMessage *Msg;
    struct Node         *succ;

    ClearMenuStrip( Wnd );

    Forbid();

    Msg = (struct IntuiMessage *)Wnd->UserPort->mp_MsgList.lh_Head;
    while( succ = Msg->ExecMessage.mn_Node.ln_Succ ) {
	if( Msg->IDCMPWindow == Wnd ) {
	    Remove(( struct Node *)Msg );
	    ReplyMsg(( struct Message *)Msg );
	}
	Msg = (struct IntuiMessage *)succ;
    }

    Wnd->UserPort = NULL;
    ModifyIDCMP( Wnd, 0L );

    Permit();

    CloseWindow( Wnd );
}
///

/// EliminaAllWorkWnd
void EliminaAllWorkWnd( void )
{
    struct WindowInfo *wnd;

    while( wnd = RemTail(( struct List * )&IE.win_list )) {

	if( wnd->wi_flags1 & W_APERTA )
	    CloseWindowSafely( wnd->wi_winptr );

	FreeObject( wnd, IE_WINDOW );
    }

    IE.win_info = IE.win_active = NULL;
}
///

/// DisattivaNoOpen
void DisattivaNoOpen( void )
{
    int cnt;

    for( cnt = 0; cnt < DISATTIVAMENU_0WND_NUM; cnt++ )
	OffMenu( BackWnd, disattiva_noopen[ cnt ]);

    MenuGadgetDisattiva();
}
///

/// PrintWindow
BOOL StampaWndMenued( void )
{
    struct MsgPort     *port;
    struct IODRPReq    *req;
    BOOL                error = FALSE;

    Stat( CatCompArray[ MSG_PRINTING ].cca_Str, FALSE, MSG_PRINTING );

    if( port = CreateMsgPort() ) {
	if( req = CreateIORequest( port, sizeof( struct IODRPReq ))) {
	    if(! OpenDevice( "printer.device", 0, (struct IORequest *)req, 0 )) {

		req->io_Modes     = GetVPModeID( &Scr->ViewPort );
		req->io_ColorMap  = Scr->ViewPort.ColorMap;
		req->io_RastPort  = IE.win_active->RPort;
		req->io_SrcX      = req->io_SrcY = 0;
		req->io_SrcWidth  = req->io_DestCols = IE.win_active->Width << 1;
		req->io_SrcHeight = req->io_DestRows = IE.win_active->Height << 1;
		req->io_Special   = SPECIAL_ASPECT;
		req->io_Command   = PRD_DUMPRPORT;

		DoIO(( struct IORequest * )req );

		CloseDevice(( struct IORequest * )req );

	    } else {
		error = TRUE;
	    }

	    DeleteIORequest( req );

	} else {
	    error = TRUE;
	}

	DeleteMsgPort( port );

    } else {
	error = TRUE;
    }

    if( error )
	Stat( CatCompArray[ ERR_PRINTERR ].cca_Str, TRUE, ERR_PRINTERR );
    else
	Stat( &ok_txt[1], FALSE, 0 );

    return( TRUE );
}
///

/// EliminaWnd
BOOL DelWndClicked( void )
{
    return( EliminaWndMenued() );
}

BOOL EliminaWndMenued( void )
{
    struct WindowInfo  *wnd;
    int                 cnt;

    if( IERequest( CatCompArray[ MSG_DELETE_OR_NOT ].cca_Str,
		   CatCompArray[ ANS_YES_NO ].cca_Str,
		   MSG_DELETE_OR_NOT, ANS_YES_NO )) {

	wnd = IE.win_info;

	ChiudiWndMenued();

	Remove(( struct Node * )wnd );

	FreeObject( wnd, IE_WINDOW );

	IE.num_win -= 1;

	if(!( IE.num_win )) {

	    for( cnt = 0; cnt < ATTIVAMENU_NUOVAW_NUM; cnt++ )
		OffMenu( BackWnd, attivamenu_nuovawin[ cnt ]);

	    ToolsGadgetsOff();
	}

	Stat( CatCompArray[ MSG_DELETED_WND ].cca_Str, FALSE, MSG_DELETED_WND );

    } else
	Stat( CatCompArray[ MSG_ABORTED ].cca_Str, FALSE, MSG_ABORTED );


    return( TRUE );
}
///

/// EliminaAllWnd
BOOL EliminaAllWndMenued( void )
{
    int     cnt;

    if( IERequest( CatCompArray[ MSG_DELETE_OR_NOT ].cca_Str, CatCompArray[ ANS_YES_NO ].cca_Str, MSG_DELETE_OR_NOT, ANS_YES_NO )) {

	EliminaAllWorkWnd();

	for( cnt = 0; cnt < ATTIVAMENU_NUOVAW_NUM; cnt ++ )
	    OffMenu( BackWnd, attivamenu_nuovawin[ cnt ]);

	MenuGadgetDisattiva();
	ToolsGadgetsOff();

	IE.num_win  = 0;
	IE.win_open = 0;

	NewWinID = 0;

	IE.flags |= WNDCHIUSA;

	Stat( CatCompArray[ MSG_DELETED_ALLWNDS ].cca_Str, FALSE, MSG_DELETED_ALLWNDS );

    } else
	Stat( CatCompArray[ MSG_ABORTED ].cca_Str, FALSE, MSG_ABORTED );

    return( TRUE );
}
///

/// ChiudiWnd
BOOL ChiudiWndMenued( void )
{
    struct WindowInfo *wnd;

    CloseWindowSafely( IE.win_active );

    IE.win_info->wi_flags1 &= ~W_APERTA;
    IE.win_info->wi_winptr = NULL;

    if ( IE.win_info->wi_GList ) {
	FreeGadgets( IE.win_info->wi_GList );
	IE.win_info->wi_GList = NULL;
    }

    IE.win_open -= 1;

    if ( IE.win_open ) {

	wnd = IE.win_list.mlh_Head;
	while(!( wnd->wi_flags1 & W_APERTA ))
	    wnd = wnd->wi_succ;

	WindowToFront( wnd->wi_winptr );
	ActivateWindow( wnd->wi_winptr );
	IE.win_info = wnd;
	IE.win_active = wnd->wi_winptr;

    } else {

	IE.win_info = NULL;
	IE.win_active = NULL;
	DisattivaNoOpen();
	ToolsGadgetsOff();

    }

    IE.flags |= WNDCHIUSA;

    Stat( CatCompArray[ MSG_CLOSE_WND ].cca_Str, FALSE, MSG_CLOSE_WND );

    return( TRUE );
}
///

/// ChiudiAllWnd
BOOL ChiudiAllWndMenued( void )
{
    struct WindowInfo *wnd;

    IE.win_open = 0;

    for( wnd = IE.win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	if( wnd->wi_flags1 & W_APERTA ) {
	    CloseWindowSafely( wnd->wi_winptr );
	    wnd->wi_winptr = NULL;
	    wnd->wi_flags1 &= ~W_APERTA;
	}
    }

    DisattivaNoOpen();
    ToolsGadgetsOff();

    IE.win_active = NULL;

    IE.flags |= WNDCHIUSA;

    return( TRUE );
}
///

/// Nuova finestra
BOOL AddWndClicked( void )
{
    return( NewWndMenued() );
}

BOOL NewWndMenued( void )
{
    struct WindowInfo *wnd;
    int                cnt;

    if( wnd = AllocObject( IE_WINDOW )) {

	AddTail(( struct List * )&IE.win_list, (struct Node *)wnd );

	wnd->wi_IDCMP    = IDCMP_GADGETUP | IDCMP_CLOSEWINDOW | IDCMP_REFRESHWINDOW;
	wnd->wi_Flags    = WFLG_SIMPLE_REFRESH | WFLG_SIZEGADGET | WFLG_DEPTHGADGET | WFLG_DRAGBAR | WFLG_CLOSEGADGET | WFLG_NEWLOOKMENUS;
	wnd->wi_Top      =  60;
	wnd->wi_Left     =  wnd->wi_Height = 80;
	wnd->wi_Width    = 400;
	wnd->wi_MaxWidth = wnd->wi_MaxHeight = -1;
	wnd->wi_Tags    |= 0x10;
	wnd->wi_name     = wnd->wi_Titolo;

	WorkWndTags[ WORKGADGETS ] = NULL;
	WorkWndTags[ WORKTOP     ] = 60;
	WorkWndTags[ WORKLEFT    ] = 80;
	WorkWndTags[ WORKWIDTH   ] = 400;
	WorkWndTags[ WORKHEIGHT  ] = 80;
	WorkWndTags[ WORKTITLE   ] = wnd->wi_Titolo;
	WorkWndTags[ WORKFLAGS   ] = ( IE.mainprefs & WFLAGS ) ? wnd->wi_Flags : W_F;

	if( wnd->wi_winptr = OpenWindowShdIDCMP( WorkWndTags, WorkWIDCMP )) {

	    IE.win_info   = wnd->wi_winptr->UserData = wnd;
	    IE.win_active = wnd->wi_winptr;

	    wnd->wi_winptr->ExtData = (APTR)HandleEdit;

	    wnd->wi_flags1 |= W_APERTA;

	    SetMenuStrip( wnd->wi_winptr, BackMenus );
	    SetPointer( wnd->wi_winptr, puntatore, 13, 16, -7, -6 );

	    if(!( IE.win_open )) {
		for( cnt = 0; cnt < ATTIVAMENU_NUOVAW_NUM; cnt++ )
		    OnMenu( BackWnd, attivamenu_nuovawin[ cnt ]);
		ToolsGadgetsOn();
	    }

	    IE.win_open += 1;
	    IE.num_win  += 1;
	    IE.flags &= ~SALVATO;

	    TitoloWndMenued();

	    if(!( IE.win_info->wi_Label[0] )) {
		sprintf( IE.win_info->wi_Label, "Wnd%03ld", NewWinID );
		NewWinID += 1;
	    }

	    Stat( CatCompArray[ MSG_OPEN_WND ].cca_Str, FALSE, MSG_OPEN_WND );

	} else {
	    Stat( CatCompArray[ ERR_NOWND ].cca_Str, TRUE, ERR_NOWND );
	    Remove((struct Node *)wnd);
	    FreeObject( wnd, IE_WINDOW );
	}

    } else
	Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, ERR_NOMEMORY );

    return( TRUE );
}
///

/// Apri finestra
BOOL ApriWndMenued( void )
{
    struct WindowInfo  *wnd;
    struct BooleanInfo *gad;
    int                 cnt;

    if( wnd = GetWnd() ) {

	if( wnd->wi_flags1 & W_APERTA ) {

	    WindowToFront( wnd->wi_winptr );
	    ActivateWindow( wnd->wi_winptr );
	    Stat( CatCompArray[ MSG_ALREADY_OPEN ].cca_Str, FALSE, MSG_ALREADY_OPEN );

	} else {

	    IE.win_info = wnd;
	    RifaiGadgets();

	    WorkWndTags[ WORKTOP    ] = wnd->wi_Top;
	    WorkWndTags[ WORKLEFT   ] = wnd->wi_Left;
	    WorkWndTags[ WORKWIDTH  ] = wnd->wi_Width;
	    WorkWndTags[ WORKHEIGHT ] = wnd->wi_Height;
	    WorkWndTags[ WORKTITLE  ] = wnd->wi_name;

	    if( wnd->wi_NumBools ) {
		gad = wnd->wi_Gadgets.mlh_Head;
		while( gad->b_Kind != BOOLEAN )
		    gad = gad->b_Node.ln_Succ;
		WorkWndTags[ WORKGADGETS ] = &gad->b_NextGadget;
	    } else
		WorkWndTags[ WORKGADGETS ] = wnd->wi_GList;

	    if( IE.mainprefs & WFLAGS )
		WorkWndTags[ WORKFLAGS ] = wnd->wi_Flags | WFLG_REPORTMOUSE;
	    else
		WorkWndTags[ WORKFLAGS ] = W_F;

	    if( wnd->wi_winptr = OpenWindowShdIDCMP( WorkWndTags, WorkWIDCMP )) {

		GT_RefreshWindow( wnd->wi_winptr, NULL );
		wnd->wi_flags1 |= W_APERTA;
		IE.win_active = wnd->wi_winptr;
		wnd->wi_winptr->UserData = wnd;
		wnd->wi_winptr->ExtData  = (APTR)HandleEdit;

		if(!( IE.win_open )) {
		    for( cnt = 0; cnt < DISATTIVAMENU_0WND_NUM; cnt++ )
			OnMenu( BackWnd, disattiva_noopen[ cnt ]);
		    ToolsGadgetsOn();
		}

		IE.win_open += 1;

		SetMenuStrip( wnd->wi_winptr, BackMenus );
		SetPointer( wnd->wi_winptr, puntatore, 13, 16, -7, -6 );

		CheckMenuToActive();

		if( IE.mainprefs & STACCATI ) {
		    IE.mainprefs &= ~STACCATI;
		    StaccaGadgets();
		    IE.mainprefs |= STACCATI;
		    RinfrescaFinestra();
		}

		Stat( CatCompArray[ MSG_OPEN_WND ].cca_Str, FALSE, MSG_OPEN_WND );

	    } else
		Stat( CatCompArray[ ERR_NOWND ].cca_Str, TRUE, ERR_NOWND );

	}

    } else
	Stat( CatCompArray[ MSG_ABORTED ].cca_Str, FALSE, MSG_ABORTED );

    return( TRUE );
}
///

/// Titolo finestra
BOOL TitoloWndMenued( void )
{
    WORD   ret;

    LockAllWindows();

    LayoutWindow( WndTitWTags );
    ret = OpenWndTitWindow();
    PostOpenWindow( WndTitWTags );

    if( ret ) {
	DisplayBeep( Scr );
    } else {

	StringTag[1] = IE.win_info->wi_name;
	GT_SetGadgetAttrsA( WndTitGadgets[ GD_TitFin ], WndTitWnd,
			    NULL, (struct TagItem *)StringTag );

	StringTag[1] = IE.win_info->wi_Label;
	GT_SetGadgetAttrsA( WndTitGadgets[ GD_TitLabel ], WndTitWnd,
			    NULL, (struct TagItem *)StringTag );

	ActivateGadget( WndTitGadgets[ GD_TitFin ], WndTitWnd, NULL );

	while( ReqHandle( WndTitWnd, HandleWndTitIDCMP ));
    }

    CloseWndTitWindow();
    UnlockAllWindows();
    return( TRUE );
}

BOOL WndTitVanillaKey( void )
{
    switch( WndTitMsg.Code ) {
	case 13:
	    return( TitFinOkClicked() );
	case 27:
	    return( TitFinAnnullaClicked() );
    }
    return( TRUE );
}

BOOL TitFinClicked( void )
{
    ActivateGadget( WndTitGadgets[ GD_TitLabel ], WndTitWnd, NULL );
    return( TRUE );
}

BOOL TitLabelClicked( void )
{
    return( TRUE );
}

BOOL TitFinOkClicked( void )
{
    STRPTR label;

    strcpy( IE.win_info->wi_Titolo, GetString( WndTitGadgets[ GD_TitFin ]) );

    label = GetString( WndTitGadgets[ GD_TitLabel ]);

    if( label[0] )
	strcpy( IE.win_info->wi_Label, label );

    SetWindowTitles( IE.win_active, IE.win_info->wi_name, (APTR)-1 );

    Stat( CatCompArray[ MSG_DONE ].cca_Str, FALSE, MSG_DONE );

    IE.flags &= ~SALVATO;

    return( FALSE );
}

BOOL TitFinAnnullaClicked( void )
{
    return( FALSE );
}
///

/// Dimensioni Finestra
BOOL WndSizeMenued( void )
{
    int     ret;

    LockAllWindows();

    LayoutWindow( DimFinWTags );
    ret = OpenDimFinWindow();
    PostOpenWindow( DimFinWTags );

    if(!( ret )) {

	buffer = IE.win_info->wi_flags1;

	IntegerTag[1] = IE.win_info->wi_MinWidth;
	GT_SetGadgetAttrsA( DimFinGadgets[ GD_DF_MinW ], DimFinWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = IE.win_info->wi_MaxWidth;
	GT_SetGadgetAttrsA( DimFinGadgets[ GD_DF_MaxW ], DimFinWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = IE.win_info->wi_MinHeight;
	GT_SetGadgetAttrsA( DimFinGadgets[ GD_DF_MinH ], DimFinWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = IE.win_info->wi_MaxHeight;
	GT_SetGadgetAttrsA( DimFinGadgets[ GD_DF_MaxH ], DimFinWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = IE.win_info->wi_InnerWidth;
	GT_SetGadgetAttrsA( DimFinGadgets[ GD_DF_InW ], DimFinWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = IE.win_info->wi_InnerHeight;
	GT_SetGadgetAttrsA( DimFinGadgets[ GD_DF_InH ], DimFinWnd,
			    NULL, (struct TagItem *)IntegerTag );

	if( IE.win_info->wi_flags1 & W_USA_INNER_W ) {
	    CheckedTag[1]  = TRUE;
	    DisableTag[1] = FALSE;
	    GT_SetGadgetAttrsA( DimFinGadgets[ GD_DF_InW ], DimFinWnd,
				NULL, (struct TagItem *)DisableTag );
	    GT_SetGadgetAttrsA( DimFinGadgets[ GD_DF_InWc ], DimFinWnd,
				NULL, (struct TagItem *)CheckedTag );
	}

	if( IE.win_info->wi_flags1 & W_USA_INNER_H ) {
	    CheckedTag[1]  = TRUE;
	    DisableTag[1] = FALSE;
	    GT_SetGadgetAttrsA( DimFinGadgets[ GD_DF_InH ], DimFinWnd,
				NULL, (struct TagItem *)DisableTag );
	    GT_SetGadgetAttrsA( DimFinGadgets[ GD_DF_InHc ], DimFinWnd,
				NULL, (struct TagItem *)CheckedTag );
	}

	ret = TRUE;

	do {
	    WaitPort( DimFinWnd->UserPort );
	    ret = HandleDimFinIDCMP();
	} while( ret );

    } else
	DisplayBeep( Scr );

    CloseDimFinWindow();
    UnlockAllWindows();

    return( TRUE );
}

BOOL DimFinVanillaKey( void )
{
    BOOL    ret = TRUE;

    switch( DimFinMsg.Code ) {

	case 13:
	    ret = DF_OkClicked();
	    break;

	case 27:
	    ret = DF_AnnullaClicked();
	    break;
    }

    return( ret );
}

BOOL DF_AnnullaClicked( void )
{
    IE.win_info->wi_flags1 = buffer;
    return( FALSE );
}

BOOL DF_OkClicked( void )
{
    IE.win_info->wi_MinWidth    = GetNumber( DimFinGadgets[ GD_DF_MinW ]);
    IE.win_info->wi_MaxWidth    = GetNumber( DimFinGadgets[ GD_DF_MaxW ]);
    IE.win_info->wi_MinHeight   = GetNumber( DimFinGadgets[ GD_DF_MinH ]);
    IE.win_info->wi_MaxHeight   = GetNumber( DimFinGadgets[ GD_DF_MaxH ]);
    IE.win_info->wi_InnerWidth  = GetNumber( DimFinGadgets[ GD_DF_InW  ]);
    IE.win_info->wi_InnerHeight = GetNumber( DimFinGadgets[ GD_DF_InH  ]);

    IE.flags &= ~SALVATO;

    return( FALSE );
}

BOOL DF_MinWClicked( void )
{
    ActivateGadget( DimFinGadgets[ GD_DF_MaxW ], DimFinWnd, NULL );
    return( TRUE );
}

BOOL DF_MaxWClicked( void )
{
    ActivateGadget( DimFinGadgets[ GD_DF_MinH ], DimFinWnd, NULL );
    return( TRUE );
}

BOOL DF_MinHClicked( void )
{
    ActivateGadget( DimFinGadgets[ GD_DF_MaxH ], DimFinWnd, NULL );
    return( TRUE );
}

BOOL DF_MaxHClicked( void )
{
    if(!( DimFinGadgets[ GD_DF_InW ]->Flags & GFLG_DISABLED ))
	ActivateGadget( DimFinGadgets[ GD_DF_InW ], DimFinWnd, NULL );
    return( TRUE );
}

BOOL DF_InWClicked( void )
{
    if(!( DimFinGadgets[ GD_DF_InH ]->Flags & GFLG_DISABLED ))
	ActivateGadget( DimFinGadgets[ GD_DF_InH ], DimFinWnd, NULL );
    return( TRUE );
}

BOOL DF_InHClicked( void )
{
    return( TRUE );
}

BOOL DF_MinWbClicked( void )
{
    IntegerTag[1] = IE.win_active->Width;
    GT_SetGadgetAttrsA( DimFinGadgets[ GD_DF_MinW ], DimFinWnd,
			NULL, (struct TagItem *)IntegerTag );

    return( TRUE );
}

BOOL DF_MaxWbClicked( void )
{
    IntegerTag[1] = IE.win_active->Width;
    GT_SetGadgetAttrsA( DimFinGadgets[ GD_DF_MaxW ], DimFinWnd,
			NULL, (struct TagItem *)IntegerTag );

    return( TRUE );
}

BOOL DF_MinHbClicked( void )
{
    IntegerTag[1] = IE.win_active->Height;
    GT_SetGadgetAttrsA( DimFinGadgets[ GD_DF_MinH ], DimFinWnd,
			NULL, (struct TagItem *)IntegerTag );

    return( TRUE );
}

BOOL DF_MaxHbClicked( void )
{
    IntegerTag[1] = IE.win_active->Height;
    GT_SetGadgetAttrsA( DimFinGadgets[ GD_DF_MaxH ], DimFinWnd,
			NULL, (struct TagItem *)IntegerTag );

    return( TRUE );
}

BOOL DF_InWcKeyPressed( void )
{
    return( DF_InWcClicked() );
}

BOOL DF_InWcClicked( void )
{
    IE.win_info->wi_flags1 ^= W_USA_INNER_W;

    if( IE.win_info->wi_flags1 & W_USA_INNER_W ) {
	DisableTag[1] = FALSE;
	CheckedTag[1]  = TRUE;
    } else {
	DisableTag[1] = TRUE;
	CheckedTag[1]  = FALSE;
    }

    GT_SetGadgetAttrsA( DimFinGadgets[ GD_DF_InWc ], DimFinWnd,
			NULL, (struct TagItem *)CheckedTag );
    GT_SetGadgetAttrsA( DimFinGadgets[ GD_DF_InW ], DimFinWnd,
			NULL, (struct TagItem *)DisableTag );

    return( TRUE );
}

BOOL DF_InHcKeyPressed( void )
{
    return( DF_InHcClicked() );
}

BOOL DF_InHcClicked( void )
{
    IE.win_info->wi_flags1 ^= W_USA_INNER_H;

    if( IE.win_info->wi_flags1 & W_USA_INNER_H ) {
	DisableTag[1] = FALSE;
	CheckedTag[1]  = TRUE;
    } else {
	DisableTag[1] = TRUE;
	CheckedTag[1]  = FALSE;
    }

    GT_SetGadgetAttrsA( DimFinGadgets[ GD_DF_InHc ], DimFinWnd,
			NULL, (struct TagItem *)CheckedTag );
    GT_SetGadgetAttrsA( DimFinGadgets[ GD_DF_InH ], DimFinWnd,
			NULL, (struct TagItem *)DisableTag );

    return( TRUE );
}
///

/// Zoom
BOOL ZoomMenued( void )
{
    int     ret;

    LockAllWindows();

    LayoutWindow( ZoomWTags );
    ret = OpenZoomWindow();
    PostOpenWindow( ZoomWTags );

    if(!( ret )) {

	buffer = IE.win_info->wi_Tags;

	IntegerTag[1] = IE.win_info->wi_ZLeft;
	GT_SetGadgetAttrsA( ZoomGadgets[ GD_Z_Left ], ZoomWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = IE.win_info->wi_ZTop;
	GT_SetGadgetAttrsA( ZoomGadgets[ GD_Z_Top ], ZoomWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = IE.win_info->wi_ZWidth;
	GT_SetGadgetAttrsA( ZoomGadgets[ GD_Z_Width ], ZoomWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = IE.win_info->wi_ZHeight;
	GT_SetGadgetAttrsA( ZoomGadgets[ GD_Z_Height ], ZoomWnd,
			    NULL, (struct TagItem *)IntegerTag );

	DisableTag[1] = ( IE.win_info->wi_Tags & W_ZOOM ) ? FALSE : TRUE;
	CheckedTag[1] = ( IE.win_info->wi_Tags & W_ZOOM ) ? TRUE : FALSE;

	GT_SetGadgetAttrsA( ZoomGadgets[ GD_Z_Usa    ], ZoomWnd, NULL, (struct TagItem *)CheckedTag );
	GT_SetGadgetAttrsA( ZoomGadgets[ GD_Z_Left   ], ZoomWnd, NULL, (struct TagItem *)DisableTag );
	GT_SetGadgetAttrsA( ZoomGadgets[ GD_Z_Top    ], ZoomWnd, NULL, (struct TagItem *)DisableTag );
	GT_SetGadgetAttrsA( ZoomGadgets[ GD_Z_Width  ], ZoomWnd, NULL, (struct TagItem *)DisableTag );
	GT_SetGadgetAttrsA( ZoomGadgets[ GD_Z_Height ], ZoomWnd, NULL, (struct TagItem *)DisableTag );

	while( ReqHandle( ZoomWnd, HandleZoomIDCMP ));

    } else {
	DisplayBeep( Scr );
    }

    CloseZoomWindow();
    UnlockAllWindows();

    return( TRUE );
}

BOOL ZoomVanillaKey( void )
{
    switch( ZoomMsg.Code ) {
	case 13:
	    return( Z_OkClicked() );
	case 27:
	    return( Z_AnnullaClicked() );
    }
}

BOOL Z_OkClicked( void )
{
    IE.win_info->wi_ZLeft   = GetNumber( ZoomGadgets[ GD_Z_Left   ]);
    IE.win_info->wi_ZTop    = GetNumber( ZoomGadgets[ GD_Z_Top    ]);
    IE.win_info->wi_ZWidth  = GetNumber( ZoomGadgets[ GD_Z_Width  ]);
    IE.win_info->wi_ZHeight = GetNumber( ZoomGadgets[ GD_Z_Height ]);

    return( FALSE );
}

BOOL Z_AnnullaClicked( void )
{
    IE.win_info->wi_Tags = buffer;
    return( FALSE );
}

BOOL Z_UsaKeyPressed( void )
{
    if( IE.win_info->wi_Tags & W_ZOOM )
	CheckedTag[1] = FALSE;
    else
	CheckedTag[1] = TRUE;

    GT_SetGadgetAttrsA( ZoomGadgets[ GD_Z_Usa ], ZoomWnd, NULL, (struct TagItem *)CheckedTag );

    return( Z_UsaClicked() );
}

BOOL Z_UsaClicked( void )
{
    IE.win_info->wi_Tags ^= W_ZOOM;

    DisableTag[1] = ( IE.win_info->wi_Tags & W_ZOOM ) ? FALSE : TRUE;

    GT_SetGadgetAttrsA( ZoomGadgets[ GD_Z_Left   ], ZoomWnd, NULL, (struct TagItem *)DisableTag );
    GT_SetGadgetAttrsA( ZoomGadgets[ GD_Z_Top    ], ZoomWnd, NULL, (struct TagItem *)DisableTag );
    GT_SetGadgetAttrsA( ZoomGadgets[ GD_Z_Width  ], ZoomWnd, NULL, (struct TagItem *)DisableTag );
    GT_SetGadgetAttrsA( ZoomGadgets[ GD_Z_Height ], ZoomWnd, NULL, (struct TagItem *)DisableTag );

    return( TRUE );
}

BOOL Z_LeftClicked( void )
{
    ActivateGadget( ZoomGadgets[ GD_Z_Top ], ZoomWnd, NULL );
    return( TRUE );
}

BOOL Z_TopClicked( void )
{
    ActivateGadget( ZoomGadgets[ GD_Z_Width ], ZoomWnd, NULL );
    return( TRUE );
}

BOOL Z_WidthClicked( void )
{
    ActivateGadget( ZoomGadgets[ GD_Z_Height ], ZoomWnd, NULL );
    return( TRUE );
}

BOOL Z_HeightClicked( void )
{
    return( TRUE );
}

BOOL Z_LbClicked( void )
{
    IntegerTag[1] = IE.win_active->LeftEdge;
    GT_SetGadgetAttrsA( ZoomGadgets[ GD_Z_Left ], ZoomWnd, NULL, (struct TagItem *)IntegerTag );
    return( TRUE );
}

BOOL Z_TbClicked( void )
{
    IntegerTag[1] = IE.win_active->TopEdge;
    GT_SetGadgetAttrsA( ZoomGadgets[ GD_Z_Top ], ZoomWnd, NULL, (struct TagItem *)IntegerTag );
    return( TRUE );
}

BOOL Z_WbClicked( void )
{
    IntegerTag[1] = IE.win_active->Width;
    GT_SetGadgetAttrsA( ZoomGadgets[ GD_Z_Width ], ZoomWnd, NULL, (struct TagItem *)IntegerTag );
    return( TRUE );
}

BOOL Z_HbClicked( void )
{
    IntegerTag[1] = IE.win_active->Height;
    GT_SetGadgetAttrsA( ZoomGadgets[ GD_Z_Height ], ZoomWnd, NULL, (struct TagItem *)IntegerTag );
    return( TRUE );
}
///

/// Window Tags
BOOL WndTagsMenued( void )
{
    int     ret, cnt;
    static WORD    gads[] = {
		GD_WTg_ScTitle,
		GD_WTg_MQ,
		GD_WTg_RQ,
		GD_WTg_Adjust,
		GD_WTg_FallBack,
		GD_WTg_NotDepth,
		GD_WTg_TabMsg,
		GD_WTg_MenuH,
		GD_WTg_LocTit,
		GD_WTg_LocScrTit,
		GD_WTg_LocGad,
		GD_WTg_LocTxt,
		GD_WTg_LocMenu,
		GD_WT_ShdPort,
		GD_WTg_Back,
	    };
    static ULONG   tags[] = {
		W_SCREENTITLE,
		W_MOUSEQUEUE,
		W_RPTQUEUE,
		W_AUTOADJUST,
		W_FALLBACK,
		W_NOTIFYDEPTH,
		W_TABLETMESSAGE,
		W_MENUHELP,
		W_LOC_TITLE,
		W_LOC_SCRTITLE,
		W_LOC_GADGETS,
		W_LOC_TEXTS,
		W_LOC_MENUS,
		W_SHARED_PORT,
		W_BACKFILL,
	    };
    static WORD    gads2[] = {
		GD_WTg_ScTitIn,
		GD_WTg_MQIn,
		GD_WTg_RQIn,
	    };

    LockAllWindows();

    LayoutWindow( WndTagWTags );
    ret = OpenWndTagWindow();
    PostOpenWindow( WndTagWTags );

    if(!( ret )) {

	IntegerTag[1] = IE.win_info->wi_MouseQueue;
	GT_SetGadgetAttrsA( WndTagGadgets[ GD_WTg_MQIn ], WndTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = IE.win_info->wi_RptQueue;
	GT_SetGadgetAttrsA( WndTagGadgets[ GD_WTg_RQIn ], WndTagWnd,
			    NULL, (struct TagItem *)IntegerTag );

	StringTag[1] = IE.win_info->wi_TitoloSchermo;
	GT_SetGadgetAttrsA( WndTagGadgets[ GD_WTg_ScTitIn ], WndTagWnd,
			    NULL, (struct TagItem *)StringTag );

	for( cnt = 0; cnt < sizeof( tags ) / sizeof( ULONG ); cnt++ ){
	    CheckedTag[1] = (IE.win_info->wi_Tags & tags[ cnt ]) ? TRUE : FALSE;
	    GT_SetGadgetAttrsA( WndTagGadgets[ gads[ cnt ]], WndTagWnd,
				NULL, (struct TagItem *)CheckedTag );
	}

	for( cnt = 0; cnt < sizeof( gads2 ) / sizeof( WORD ); cnt++ ){
	    DisableTag[1] = (IE.win_info->wi_Tags & tags[ cnt ]) ? FALSE : TRUE;
	    GT_SetGadgetAttrsA( WndTagGadgets[ gads2[ cnt ]], WndTagWnd,
				NULL, (struct TagItem *)DisableTag );
	}

	buffer = IE.win_info->wi_Tags;
	buffer2 = IE.win_info->wi_flags1;
	buffer3 = IE.win_info->wi_flags2;

	while( ReqHandle( WndTagWnd, HandleWndTagIDCMP ));

    } else {
	DisplayBeep( Scr );
    }

    CloseWndTagWindow();
    UnlockAllWindows();

    return( TRUE );
}

BOOL WndTagVanillaKey( void )
{
    switch( WndTagMsg.Code ){
	case 13:
	    return( WTg_OkClicked() );
	case 27:
	    return( WTg_AnnullaClicked() );
    }

    return( TRUE );
}

BOOL WTg_OkClicked( void )
{
    strcpy( IE.win_info->wi_TitoloSchermo, GetString( WndTagGadgets[ GD_WTg_ScTitIn ]) );
    IE.win_info->wi_MouseQueue = GetNumber( WndTagGadgets[ GD_WTg_MQIn ]);
    IE.win_info->wi_RptQueue   = GetNumber( WndTagGadgets[ GD_WTg_RQIn ]);
    IE.flags &= ~SALVATO;
    return( FALSE );
}

BOOL WTg_AnnullaClicked( void )
{
    IE.win_info->wi_Tags = buffer;
    IE.win_info->wi_flags1 = buffer2;
    IE.win_info->wi_flags2 = buffer3;
    return( FALSE );
}

BOOL WTg_ScTitInClicked( void )
{
    return( TRUE );
}

BOOL WTg_MQInClicked( void )
{
    return( TRUE );
}

BOOL WTg_RQInClicked( void )
{
    return( TRUE );
}

BOOL WTg_ScTitleKeyPressed( void )
{
    CheckedTag[1] = (IE.win_info->wi_Tags & W_SCREENTITLE) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( WndTagGadgets[ GD_WTg_ScTitle ], WndTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( WTg_ScTitleClicked() );
}

BOOL WTg_ScTitleClicked( void )
{
    IE.win_info->wi_Tags ^= W_SCREENTITLE;

    DisableTag[1] = (IE.win_info->wi_Tags & W_SCREENTITLE) ? FALSE : TRUE;

    GT_SetGadgetAttrsA( WndTagGadgets[ GD_WTg_ScTitIn ], WndTagWnd,
			NULL, (struct TagItem *)DisableTag );

    if(!( DisableTag[1] ))
	ActivateGadget( WndTagGadgets[ GD_WTg_ScTitIn ], WndTagWnd, NULL );

    return( TRUE );
}

BOOL WTg_MQKeyPressed( void )
{
    CheckedTag[1] = (IE.win_info->wi_Tags & W_MOUSEQUEUE) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( WndTagGadgets[ GD_WTg_MQ ], WndTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( WTg_MQClicked() );
}

BOOL WTg_MQClicked( void )
{
    IE.win_info->wi_Tags ^= W_MOUSEQUEUE;

    DisableTag[1] = (IE.win_info->wi_Tags & W_MOUSEQUEUE) ? FALSE : TRUE;

    GT_SetGadgetAttrsA( WndTagGadgets[ GD_WTg_MQIn ], WndTagWnd,
			NULL, (struct TagItem *)DisableTag );

    if(!( DisableTag[1] ))
	ActivateGadget( WndTagGadgets[ GD_WTg_MQIn ], WndTagWnd, NULL );

    return( TRUE );
}

BOOL WTg_RQKeyPressed( void )
{
    CheckedTag[1] = (IE.win_info->wi_Tags & W_RPTQUEUE) ? FALSE : TRUE;

    GT_SetGadgetAttrsA( WndTagGadgets[ GD_WTg_RQ ], WndTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( WTg_RQClicked() );
}

BOOL WTg_RQClicked( void )
{
    IE.win_info->wi_Tags ^= W_RPTQUEUE;

    DisableTag[1] = (IE.win_info->wi_Tags & W_RPTQUEUE) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( WndTagGadgets[ GD_WTg_RQIn ], WndTagWnd,
			NULL, (struct TagItem *)DisableTag );

    if(!( DisableTag[1] ))
	ActivateGadget( WndTagGadgets[ GD_WTg_RQIn ], WndTagWnd, NULL );

    return( TRUE );
}

BOOL WTg_AdjustKeyPressed( void )
{
    CheckedTag[1] = (IE.win_info->wi_Tags & W_AUTOADJUST) ? FALSE : TRUE;

    GT_SetGadgetAttrsA( WndTagGadgets[ GD_WTg_Adjust ], WndTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( WTg_AdjustClicked() );
}

BOOL WTg_AdjustClicked( void )
{
    IE.win_info->wi_Tags ^= W_AUTOADJUST;
    return( TRUE );
}

BOOL WTg_FallBackKeyPressed( void )
{
    CheckedTag[1] = (IE.win_info->wi_Tags & W_FALLBACK) ? FALSE : TRUE;

    GT_SetGadgetAttrsA( WndTagGadgets[ GD_WTg_FallBack ], WndTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( WTg_FallBackClicked() );
}

BOOL WTg_FallBackClicked( void )
{
    IE.win_info->wi_Tags ^= W_FALLBACK;
    return( TRUE );
}

BOOL WTg_NotDepthKeyPressed( void )
{
    CheckedTag[1] = (IE.win_info->wi_Tags & W_NOTIFYDEPTH) ? FALSE : TRUE;

    GT_SetGadgetAttrsA( WndTagGadgets[ GD_WTg_NotDepth ], WndTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( WTg_NotDepthClicked() );
}

BOOL WTg_NotDepthClicked( void )
{
    IE.win_info->wi_Tags ^= W_NOTIFYDEPTH;
    return( TRUE );
}

BOOL WTg_MenuHKeyPressed( void )
{
    CheckedTag[1] = (IE.win_info->wi_Tags & W_MENUHELP) ? FALSE : TRUE;

    GT_SetGadgetAttrsA( WndTagGadgets[ GD_WTg_MenuH ], WndTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( WTg_MenuHClicked() );
}

BOOL WTg_MenuHClicked( void )
{
    IE.win_info->wi_Tags ^= W_MENUHELP;
    return( TRUE );
}

BOOL WTg_TabMsgKeyPressed( void )
{
    CheckedTag[1] = (IE.win_info->wi_Tags & W_TABLETMESSAGE) ? FALSE : TRUE;

    GT_SetGadgetAttrsA( WndTagGadgets[ GD_WTg_TabMsg ], WndTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( WTg_TabMsgClicked() );
}

BOOL WTg_TabMsgClicked( void )
{
    IE.win_info->wi_Tags ^= W_TABLETMESSAGE;
    return( TRUE );
}

BOOL WTg_LocTitKeyPressed( void )
{
    CheckedTag[1] = (IE.win_info->wi_Tags & W_LOC_TITLE) ? FALSE : TRUE;

    GT_SetGadgetAttrsA( WndTagGadgets[ GD_WTg_LocTit ], WndTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( WTg_LocTitClicked() );
}

BOOL WTg_LocTitClicked( void )
{
    IE.win_info->wi_Tags ^= W_LOC_TITLE;
    return( TRUE );
}

BOOL WTg_LocScrTitKeyPressed( void )
{
    CheckedTag[1] = (IE.win_info->wi_Tags & W_LOC_SCRTITLE) ? FALSE : TRUE;

    GT_SetGadgetAttrsA( WndTagGadgets[ GD_WTg_LocScrTit ], WndTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( WTg_LocScrTitClicked() );
}

BOOL WTg_LocScrTitClicked( void )
{
    IE.win_info->wi_Tags ^= W_LOC_SCRTITLE;
    return( TRUE );
}

BOOL WTg_LocGadKeyPressed( void )
{
    CheckedTag[1] = (IE.win_info->wi_Tags & W_LOC_GADGETS) ? FALSE : TRUE;

    GT_SetGadgetAttrsA( WndTagGadgets[ GD_WTg_LocGad ], WndTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( WTg_LocGadClicked() );
}

BOOL WTg_LocGadClicked( void )
{
    IE.win_info->wi_Tags ^= W_LOC_GADGETS;
    return( TRUE );
}

BOOL WTg_LocTxtKeyPressed( void )
{
    CheckedTag[1] = (IE.win_info->wi_Tags & W_LOC_TEXTS) ? FALSE : TRUE;

    GT_SetGadgetAttrsA( WndTagGadgets[ GD_WTg_LocTxt ], WndTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( WTg_LocTxtClicked() );
}

BOOL WTg_LocTxtClicked( void )
{
    IE.win_info->wi_Tags ^= W_LOC_TEXTS;
    return( TRUE );
}

BOOL WTg_LocMenuKeyPressed( void )
{
    CheckedTag[1] = (IE.win_info->wi_Tags & W_LOC_MENUS) ? FALSE : TRUE;

    GT_SetGadgetAttrsA( WndTagGadgets[ GD_WTg_LocMenu ], WndTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( WTg_LocMenuClicked() );
}

BOOL WTg_LocMenuClicked( void )
{
    IE.win_info->wi_Tags ^= W_LOC_MENUS;
    return( TRUE );
}

BOOL WT_ShdPortKeyPressed( void )
{
    CheckedTag[1] = (IE.win_info->wi_Tags & W_SHARED_PORT) ? FALSE : TRUE;

    GT_SetGadgetAttrsA( WndTagGadgets[ GD_WT_ShdPort ], WndTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( WT_ShdPortClicked() );
}

BOOL WT_ShdPortClicked( void )
{
    IE.win_info->wi_Tags ^= W_SHARED_PORT;

    return( TRUE );
}

BOOL WTg_BackKeyPressed( void )
{
    CheckedTag[1] = (IE.win_info->wi_Tags & W_BACKFILL) ? FALSE : TRUE;

    GT_SetGadgetAttrsA( WndTagGadgets[ GD_WTg_Back ], WndTagWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( WTg_BackClicked() );
}

BOOL WTg_BackClicked( void )
{
    IE.win_info->wi_Tags ^= W_BACKFILL;

    return( TRUE );
}
///

/// Usa i flags settati
BOOL UseWFlagsMenued( void )
{
    struct WindowInfo  *wnd;

    IE.mainprefs ^= WFLAGS;

    for( wnd = IE.win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	if( wnd->wi_flags1 & W_APERTA ) {
	    SettaWFlags( wnd );
	}
    }

    return( TRUE );
}
///

/// Get Wnd
struct WindowInfo *GetWnd( void )
{
    struct WindowInfo  *wnd = NULL;
    int                 num, cnt;

    if( ApriListaFin( CatCompArray[ REQ_OPENW ].cca_Str, 0, &IE.win_list )) {

	num = GestisciListaFin( EXIT, IE.num_win );
	ChiudiListaFin();

	if( num >= 0 ) {

	    wnd = (struct WindowInfo *)&IE.win_list.mlh_Head;
	    for( cnt = 0; cnt <= num; cnt++ )
		wnd = wnd->wi_succ;
	}
    }

    return( wnd );
}
///

/// Add Txt
BOOL AddTxtMenued( void )
{
    struct ITextNode   *itn, *itn2;
    BOOL                canc = FALSE;

    if( itn = AllocObject( IE_INTUITEXT )) {

	AddTail(( struct List * )&IE.win_info->wi_ITexts, (struct Node * )itn );

	itn->itn_FrontPen = 1;

	if( EditText( itn )) {

	    RinfrescaFinestra();

	    if( MoveText( itn ))  {

		if( IE.win_info->wi_NumTexts ) {
		    itn2 = itn->itn_Node.ln_Pred;
		    itn2->itn_NextText = &itn->itn_FrontPen;
		}

		IE.win_info->wi_NumTexts += 1;

		RinfrescaFinestra();
		CheckMenuToActive();

		IE.flags &= ~SALVATO;

	    } else {
		canc = TRUE;
	    }
	} else {
	    canc = TRUE;
	}

	if( canc ) {
	    Remove(( struct Node * )itn );
	    FreeObject( itn, IE_INTUITEXT );
	    Stat( CatCompArray[ MSG_ABORTED ].cca_Str, FALSE, MSG_ABORTED );
	} else {
	    Stat( ok_txt+1, FALSE, 0 );
	}
    } else {
	Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, 0 );
    }

    return( TRUE );
}
///

/// Edit Text
BOOL EditTxtMenued( void )
{
    struct ITextNode *itn;

    if( itn = GetText() )
	EditText( itn );

    return( TRUE );
}

BOOL EditText( struct ITextNode *itn )
{
    ULONG   *ptr;
    int     ret;
    APTR    old_font;
    UBYTE   old_FP, old_BP, old_DM, dm;
    int     cnt;

    LockAllWindows();

    ptr = ITextGTags;

    while( *ptr++ != GTPA_Depth ) {}
    *ptr++ = IE.ScreenData->Tags[ SCRDEPTH ];

    while( *ptr++ != GTPA_Depth ) {}
    *ptr = IE.ScreenData->Tags[ SCRDEPTH ];

    old_font = itn->itn_ITextFont;
    old_BP   = itn->itn_BackPen;
    old_FP   = itn->itn_FrontPen;
    old_DM   = itn->itn_DrawMode;

    LayoutWindow( ITextWTags );
    ret = OpenITextWindow();
    PostOpenWindow( ITextWTags );

    if(!( ret )) {

	PaletteTag[1] = itn->itn_FrontPen;
	GT_SetGadgetAttrsA( ITextGadgets[ GD_TXT_FPen ], ITextWnd,
			    NULL, (struct TagItem *)PaletteTag );

	PaletteTag2[1] = itn->itn_BackPen;
	GT_SetGadgetAttrsA( ITextGadgets[ GD_TXT_BPen ], ITextWnd,
			    NULL, (struct TagItem *)PaletteTag2 );

	StringTag[1] = itn->itn_Node.ln_Name;
	GT_SetGadgetAttrsA( ITextGadgets[ GD_TXT_Txt ], ITextWnd,
			    NULL, (struct TagItem *)StringTag );

	dm = itn->itn_DrawMode & ~INVERSVID;
	cnt = 0;

	while( DrawModes[ cnt ] != dm )
	    cnt++;

	CycleTag[1] = cnt;
	GT_SetGadgetAttrsA( ITextGadgets[ GD_TXT_Mode ], ITextWnd,
			    NULL, (struct TagItem *)CycleTag );

	CheckedTag[1] = ( itn->itn_DrawMode & INVERSVID ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( ITextGadgets[ GD_TXT_Inv ], ITextWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( itn->itn_Node.ln_Type & IT_SCRFONT ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( ITextGadgets[ GD_TXT_ScrFont ], ITextWnd,
			    NULL, (struct TagItem *)CheckedTag );

	buffer = itn;

	RetCode = 0;

	do {
	    ReqHandle( ITextWnd, HandleITextIDCMP );
	} while(!( RetCode ));

	if( RetCode < 1 ) {

	    strcpy( itn->itn_Text, GetString( ITextGadgets[ GD_TXT_Txt ]) );
	    IE.flags &= ~SALVATO;
	    ret = TRUE;

	} else {

	    itn->itn_FrontPen  = old_FP;
	    itn->itn_BackPen   = old_BP;
	    itn->itn_DrawMode  = old_DM;
	    itn->itn_ITextFont = old_font;

	    ret = FALSE;

	}

    } else {
	DisplayBeep( Scr );
    }

    CloseITextWindow();

    UnlockAllWindows();

    return( ret );
}


BOOL ITextVanillaKey( void )
{
    switch( ITextMsg.Code ) {
	case 27:
	    RetCode = 1;
	    break;
	case 13:
	    RetCode = -1;
	    break;
    }
}


BOOL TXT_OkClicked( void )
{
    RetCode = -1;
}

BOOL TXT_AnnullaClicked( void )
{
    RetCode = 1;
}

BOOL TXT_FPenKeyPressed( void )
{
    UWORD   c, max = (1 << IE.ScreenData->Tags[ SCRDEPTH ]) - 1;

    c = PaletteTag[1];

    if( ITextMsg.Code & 0x20 ) {        // minuscolo
	if( c < max )
	    c++;
	else
	    c = max;
    } else {                            // MAIUSCOLO
	if( c )
	    c--;
	else
	    c = max;
    }

    PaletteTag[1] = ITextMsg.Code = c;

    GT_SetGadgetAttrsA( ITextGadgets[ GD_TXT_FPen ], ITextWnd,
			NULL, (struct TagItem *)PaletteTag );

    TXT_FPenClicked();
}

BOOL TXT_FPenClicked( void )
{
    ((struct ITextNode *)buffer)->itn_FrontPen = PaletteTag[1] = ITextMsg.Code;
}

BOOL TXT_BPenKeyPressed( void )
{
    UWORD   c, max = (1 << IE.ScreenData->Tags[ SCRDEPTH ]) - 1;

    c = PaletteTag2[1];

    if( ITextMsg.Code & 0x20 ) {        // minuscolo
	if( c < max )
	    c++;
	else
	    c = 0;
    } else {                            // MAIUSCOLO
	if( c )
	    c--;
	else
	    c = max;
    }

    PaletteTag2[1] = ITextMsg.Code = c;

    GT_SetGadgetAttrsA( ITextGadgets[ GD_TXT_BPen ], ITextWnd,
			NULL, (struct TagItem *)PaletteTag2 );

    TXT_BPenClicked();
}

BOOL TXT_BPenClicked( void )
{
    ((struct ITextNode *)buffer)->itn_BackPen = PaletteTag2[1] = ITextMsg.Code;

    return( TRUE );
}

BOOL TXT_ScrFontKeyPressed( void )
{
    if((( struct ITextNode *)buffer)->itn_Node.ln_Type & IT_SCRFONT)
	CheckedTag[1] = FALSE;
    else
	CheckedTag[1] = TRUE;

    GT_SetGadgetAttrsA( ITextGadgets[ GD_TXT_ScrFont ], ITextWnd,
			NULL, (struct TagItem *)CheckedTag );

    TXT_ScrFontClicked();

    return( TRUE );
}

BOOL TXT_ScrFontClicked( void )
{
    ((struct ITextNode *)buffer)->itn_Node.ln_Type ^= IT_SCRFONT;
    if((( struct ITextNode *)buffer)->itn_Node.ln_Type & IT_SCRFONT) {
	((struct ITextNode *)buffer)->itn_ITextFont = NULL;
    } else {
	((struct ITextNode *)buffer)->itn_ITextFont = ((struct ITextNode *)buffer)->itn_FontCopy;
    }

    return( TRUE );
}

BOOL TXT_ModeKeyPressed( void )
{
    int     c;

    c = CycleTag[1];

    if( ITextMsg.Code & 0x20 ) {        // minuscolo
	if( c < 2 )
	    c++;
	else
	    c = 0;
    } else {                            // MAIUSCOLO
	if( c )
	    c--;
	else
	    c = 2;
    }

    CycleTag[1] = ITextMsg.Code = c;

    GT_SetGadgetAttrsA( ITextGadgets[ GD_TXT_Mode ], ITextWnd,
			NULL, (struct TagItem *)CycleTag );

    TXT_ModeClicked();

    return( TRUE );
}

BOOL TXT_ModeClicked( void )
{
    CycleTag[1] = ITextMsg.Code;
    ((struct ITextNode *)buffer)->itn_DrawMode = (((struct ITextNode *)buffer)->itn_DrawMode & INVERSVID) | DrawModes[ ITextMsg.Code ];
}

BOOL TXT_InvKeyPressed( void )
{
    if((( struct ITextNode *)buffer)->itn_DrawMode & INVERSVID )
	CheckedTag[1] = FALSE;
    else
	CheckedTag[1] = TRUE;

    GT_SetGadgetAttrsA( ITextGadgets[ GD_TXT_Inv ], ITextWnd,
			NULL, (struct TagItem *)CheckedTag );

    TXT_InvClicked();
}

BOOL TXT_InvClicked( void )
{
    ((struct ITextNode *)buffer)->itn_DrawMode ^= INVERSVID;
}

BOOL TXT_FontKeyPressed( void )
{
    TXT_FontClicked();
}

BOOL TXT_FontClicked( void )
{
    struct TxtAttrNode *ta;
    struct TextAttr    *old;

    old = ( ((struct ITextNode *)buffer)->itn_FontCopy ) ? ((struct ITextNode *)buffer)->itn_FontCopy : NULL;

    if( ta = FontRequest( old, "Scegli un font per il testo..." , ASL_TEXTFONT )) {

	if( old )
	    EliminaFont(( struct TxtAttrNode *)((ULONG)old - 14 ));

	((struct ITextNode *)buffer)->itn_FontCopy = &ta->txa_FontName;

	if(!( (( struct ITextNode *)buffer)->itn_Node.ln_Type & IT_SCRFONT ))
	    ((struct ITextNode *)buffer)->itn_ITextFont = ((struct ITextNode *)buffer)->itn_FontCopy;

	RinfrescaFinestra();
    }
}

BOOL TXT_TxtClicked( void )
{
}
///

/// Move Text
BOOL MoveText( struct ITextNode *txt )
{
    UBYTE               old_DM;
    struct IntuiMessage *msg;
    BOOL                ok = TRUE, ret = TRUE;
    int                 code;
    ULONG               class;
    struct Window      *wnd;

    buffer = txt->itn_NextText;
    txt->itn_NextText = NULL;
    buffer2 = txt->itn_LeftEdge;
    buffer3 = txt->itn_TopEdge;

    old_DM = txt->itn_DrawMode;

    IE.win_active->Flags |= WFLG_RMBTRAP;

    txt->itn_DrawMode |= COMPLEMENT;
    txt->itn_LeftEdge  = IE.win_active->MouseX;
    txt->itn_TopEdge   = IE.win_active->MouseY;

    PrintIText( IE.win_active->RPort, (struct IntuiText *)&txt->itn_FrontPen, 0, 0 );

    Stat( CatCompArray[ MSG_MOVETEXT ].cca_Str, FALSE, 0 );

    do {
	WaitPort( IE.win_active->UserPort );

	if( msg = GT_GetIMsg( IE.win_active->UserPort )) {

	    class = msg->Class;
	    code  = msg->Code;
	    wnd   = msg->IDCMPWindow;

	    GT_ReplyIMsg( msg );

	    switch( class ) {

		case IDCMP_REFRESHWINDOW:
		    GT_BeginRefresh( IE.win_active );
		    GT_EndRefresh( IE.win_active, TRUE );
		    break;

		case IDCMP_MOUSEBUTTONS:
		    switch( code ) {
			case 0xE8:
			    Stat( ok_txt+1, FALSE, 0 );
			    ok = FALSE;
			    break;

			case 0x69:
			    txt->itn_LeftEdge = buffer2;
			    txt->itn_TopEdge  = buffer3;
			    Stat( CatCompArray[ MSG_ABORTED ].cca_Str, FALSE, MSG_ABORTED );
			    ret = ok = FALSE;
			    break;
		    }
		    break;

		case IDCMP_MOUSEMOVE:
		    PrintIText( IE.win_active->RPort, (struct IntuiText *)&txt->itn_FrontPen, 0, 0 );
		    mousex = txt->itn_LeftEdge = IE.win_active->MouseX;
		    mousey = txt->itn_TopEdge  = IE.win_active->MouseY;
		    PrintIText( IE.win_active->RPort, (struct IntuiText *)&txt->itn_FrontPen, 0, 0 );
		    Coord();
		    break;
	    }
	}
    } while( ok );

    PrintIText( IE.win_active->RPort, (struct IntuiText *)&txt->itn_FrontPen, 0, 0 );

    IE.win_active->Flags &= ~WFLG_RMBTRAP;
    txt->itn_DrawMode = old_DM;
    txt->itn_NextText = (APTR)buffer;

    return( ret );
}

BOOL MoveTextMenued( void )
{
    struct ITextNode *txt;

    if( txt = GetText() ) {

	RinfrescaFinestra();

	if( MoveText( txt )) {
	    RinfrescaFinestra();
	    IE.flags &= ~SALVATO;
	}
    }

    return( TRUE );
}
///

/// Get Text
struct ITextNode *GetText( void )
{
    struct ITextNode *txt = NULL;
    WORD              num, cnt;

    if( ApriListaFin( CatCompArray[ REQ_GETTEXT ].cca_Str, 0, &IE.win_info->wi_ITexts )) {

	num = GestisciListaFin( EXIT, IE.win_info->wi_NumTexts );

	if( num >= 0 ) {
	    txt = &IE.win_info->wi_ITexts.mlh_Head;
	    for( cnt = 0; cnt <= num; cnt++ )
		txt = txt->itn_Node.ln_Succ;
	}

	ChiudiListaFin();
    } else {
	DisplayBeep( Scr );
    }

    return( txt );
}
///

/// Del Text
BOOL DelTextMenued( void )
{
    struct ITextNode *txt, *pred, *succ;

    if( txt = GetText() ) {

	pred = txt->itn_Node.ln_Pred;
	succ = txt->itn_Node.ln_Succ;

	if( pred->itn_Node.ln_Pred ) {
	    if( succ->itn_Node.ln_Succ )
		pred->itn_NextText = &succ->itn_FrontPen;
	    else
		pred->itn_NextText = NULL;
	}

	Remove(( struct Node *)txt );

	FreeObject( txt, IE_INTUITEXT );

	IE.win_info->wi_NumTexts -= 1;

	CheckMenuToActive();
	RinfrescaFinestra();
	IE.flags &= ~SALVATO;
    }

    return( TRUE );
}
///

/// Get Image
struct WndImages *GetImg( void )
{
    struct WndImages   *img;

    Stat( CatCompArray[ MSG_SELECTIMG ].cca_Str, FALSE, 0 );

forever:
	if( WaitButton() ) {
	    for( img = IE.win_info->wi_Images.mlh_Head; img->wim_Next; img = img->wim_Next ){
		if(( clickx >= img->wim_Left ) && ( clickx < img->wim_Left + img->wim_Width ) && ( clicky >= img->wim_Top ) && ( clicky < img->wim_Top + img->wim_Height )) {
		    Stat( &ok_txt[1], FALSE, 0 );
		    return( img );
		}
	    }
	} else
	    return( NULL );

    goto forever;

}
///

/// MoveImage
BOOL MoveImgMenued( void )
{
    struct WndImages   *img;
    UBYTE               code;
    struct MyRect       r;

    if( img = GetImg() ) {

	r.Left   = img->wim_Left;
	r.Top    = img->wim_Top;
	r.Width  = img->wim_Width;
	r.Height = img->wim_Height;

	code = MoveRect( clickx, clicky, &r );

	if( code == 0x69 )
	    Stat( CatCompArray[ MSG_ABORTED ].cca_Str, FALSE, 0 );
	else {
	    img->wim_Left = r.Left;
	    img->wim_Top  = r.Top;
	    RinfrescaFinestra();
	    IE.flags &= ~SALVATO;
	}

    }

    return( TRUE );
}
///

/// Del Image
BOOL DelImgMenued( void )
{
    struct WndImages *img, *pred, *succ;

    if( img = GetImg() ) {

	pred = img->wim_Prev;
	succ = img->wim_Next;

	if( pred->wim_Prev ) {
	    if( succ->wim_Next ){
		pred->wim_NextImage = &succ->wim_Left;
	    } else {
		pred->wim_NextImage = NULL;
	    }
	}

	Remove(( struct Node *)img );

	FreeObject( img, IE_WNDIMAGE );

	IE.win_info->wi_NumImages -= 1;

	CheckMenuToActive();
	RinfrescaFinestra();
	IE.flags &= ~SALVATO;
    }

    return( TRUE );
}
///

/// Add Img
BOOL AddImgMenued( void )
{
    int                 cnt, num;
    struct ImageNode   *img;
    struct WndImages   *wi, *pred;
    struct MyRect       r;
    UBYTE               code;

    if( IE.NumImgs ) {
	if( ApriListaFin( CatCompArray[ REQ_GETIMG ].cca_Str, REQ_GETIMG, &IE.Img_List )) {

	    num = GestisciListaFin( EXIT, IE.NumImgs-1 );
	    ChiudiListaFin();

	    RinfrescaFinestra();

	    if( num >= 0 ) {

		img = (struct ImageNode *)&IE.Img_List.mlh_Head;
		for( cnt = 0; cnt <= num; cnt++ )
		    img = img->in_Node.ln_Succ;

		r.Width  = img->in_Width;
		r.Height = img->in_Height;
		r.Left   = IE.win_active->MouseX - ( r.Width >> 1 );
		r.Top    = IE.win_active->MouseY - ( r.Height >> 1 );

		code = MoveRect( IE.win_active->MouseX, IE.win_active->MouseY, &r );

		if( code == 0x69 )
		    Stat( CatCompArray[ MSG_ABORTED ].cca_Str, FALSE, MSG_ABORTED );
		else {
		    if ( wi = AllocObject( IE_WNDIMAGE )) {

			AddTail((struct List *)&IE.win_info->wi_Images, (struct Node *)wi );

			IE.win_info->wi_NumImages += 1;

			wi->wim_Left        = r.Left;
			wi->wim_Top         = r.Top;
			wi->wim_Width       = r.Width;
			wi->wim_Height      = r.Height;
			wi->wim_Depth       = img->in_Depth;
			wi->wim_Data        = img->in_Data;
			wi->wim_PlanePick   = img->in_PlanePick;
			wi->wim_PlaneOnOff  = img->in_PlaneOnOff;
			wi->wim_ImageNode   = img;

			pred = wi->wim_Prev;
			if( pred->wim_Prev )
			    pred->wim_NextImage = &wi->wim_Left;

			RinfrescaFinestra();
			CheckMenuToActive();
			IE.flags &= ~SALVATO;

		    } else {
			Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, 0 );
		    }
		}

		SetDrMd( IE.win_active->RPort, JAM1 );
	    }
	}
    }

    return( TRUE );
}
///

/// Add Box
BOOL AddBoxMenued( void )
{
    struct BevelBoxNode *box;
    BOOL                 ok = FALSE;

    if( box = AllocObject( IE_BEVELBOX )) {

	AddTail(( struct List * )&IE.win_info->wi_Boxes, (struct Node *)box );

	box->bb_FrameType  = BBFT_BUTTON;

	Stat( "Traccia il Bevel Box...", FALSE, MSG_DRAWBBOX );

	if( WaitButton() )
	    ok = TraceRect();

	if(!( ok )) {
	    Remove((struct Node *)box );
	    FreeObject( box, IE_BEVELBOX );
	} else {

	    box->bb_Left    = clickx;
	    box->bb_Top     = clicky;
	    box->bb_Width   = mousex - clickx + 1;
	    box->bb_Height  = mousey - clicky + 1;

	    IE.win_info->wi_NumBoxes += 1;

	    OnMenu( BackWnd, (1<<11)|(16<<5)|1 );

	    RinfrescaFinestra();

	    Stat( &ok_txt[1], FALSE, 0 );
	}

    } else {
	Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, 0 );
    }

    return( TRUE );
}
///

/// Edit Boxes
BOOL EditBoxesMenued( void )
{
    struct GadgetInfo      *gad;
    struct BevelBoxNode    *box;
    int                     ret, code;
    ULONG                   sig, mask, req_mask;
    ULONG                   class;
    struct Window          *wnd, *this;
    struct IntuiMessage    *msg;

    ContornoGadgets( FALSE );

    for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
	if( gad->g_flags2 & G_ATTIVO ) {
	    gad->g_flags2 &= ~G_ATTIVO;
	    gad->g_flags2 |= G_WAS_ACTIVE;
	}
    }

    LayoutWindow( BBoxWTags );
    ret = OpenBBoxWindow();
    PostOpenWindow( BBoxWTags );

    if (!( ret )) {

	req_mask = 1 << BBoxWnd->UserPort->mp_SigBit;
	mask = req_mask | editing_mask;

	this = IE.win_active;
	buffer = 0L;

	IE.win_active->Flags |= WFLG_RMBTRAP;

	for( box = IE.win_info->wi_Boxes.mlh_Head; box->bb_Next; box = box->bb_Next )
	    box->bb_Flags &= ~BB_SELECTED;

	ret = TRUE;
	do {
	    sig = Wait( mask );

	    if( sig & editing_mask ) {
		while( msg = GT_GetIMsg( IDCMP_Port )) {

		    class = msg->Class;
		    code  = msg->Code;
		    wnd   = msg->IDCMPWindow;

		    GT_ReplyIMsg( msg );

		    IE.win_info   = wnd->UserData;
		    IE.win_active = wnd;

		    if( class == IDCMP_REFRESHWINDOW ) {
			if( this == wnd )
			    EditingBox( FALSE );
			RinfrescaFinestra();
			if( this == wnd )
			    EditingBox( TRUE );
		    }

		    if( this != wnd ) {
			    ActivateWindow( this );
			    IE.win_info = this->UserData;
			    IE.win_active = this;
			    Stat( "Ora non puoi cambiare finestra!", FALSE, MSG_NOOTHERWND );
		    } else {

			switch( class ) {

			    case IDCMP_MOUSEMOVE:
				Coord();
				if( IE.flags & MOVE ) {
				    MuoviBoxes( wnd->MouseX, wnd->MouseY );
				    IE.flags &= ~MOVE;
				}
				break;

			    case IDCMP_MOUSEBUTTONS:
				switch( code ) {
				    case 0x68:
					mousex = wnd->MouseX;
					mousey = wnd->MouseY;
					if (!( BB_CheckResize() )) {
					    EditingBox( FALSE );
					    for( box = IE.win_info->wi_Boxes.mlh_Head; box->bb_Next; box = box->bb_Next ) {
						box->bb_Flags &= ~BB_SELECTED;
					    }
					    if( box = CheckBox() ) {
						BB_EDable( TRUE );
						box->bb_Flags |= BB_SELECTED;
						BB_SistemaXYGads();
						EditingBox( TRUE );
						IE.flags |= MOVE;
					    } else {
						BB_EDable( FALSE );
					    }
					}
					break;

				    case 0xE8:
					IE.flags &= ~MOVE;
					break;
				}
				break;
			}
		    }
		}
	    }

	    if( sig & req_mask )
		ret = HandleBBoxIDCMP();

	} while( ret );

	IE.win_active->Flags &= ~WFLG_RMBTRAP;
	EditingBox( FALSE );
	IE.flags &= ~MOVE;

	IE.win_info->wi_Top    = this->TopEdge;
	IE.win_info->wi_Left   = this->LeftEdge;
	IE.win_info->wi_Width  = this->Width;
	IE.win_info->wi_Height = this->Height;
	IE.win_info->wi_InnerWidth  = this->Width - this->BorderLeft - this->BorderRight;
	IE.win_info->wi_InnerHeight = this->Height - this->BorderTop - this->BorderBottom;

    } else {
	DisplayBeep( Scr );
    }

    CloseBBoxWindow();

    for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
	if( gad->g_flags2 & G_WAS_ACTIVE ) {
	    gad->g_flags2 |= G_ATTIVO;
	    gad->g_flags2 &= ~G_WAS_ACTIVE;
	}
    }

    ContornoGadgets( TRUE );

    return( TRUE );
}

BOOL BBoxCloseWindow( void )
{
    return( FALSE );
}

BOOL BBoxVanillaKey( void )
{
    if( BBoxMsg.Code == 27 )
	return( FALSE );

    return( TRUE );
}

struct BevelBoxNode *GetBoxSel( void )
{
    struct BevelBoxNode *box;

    for( box = IE.win_info->wi_Boxes.mlh_Head; box->bb_Next; box = box->bb_Next )
	if( box->bb_Flags & BB_SELECTED )
	    return( box );

    return( NULL );
}

BOOL BB_XClicked( void )
{
    struct BevelBoxNode *box;

    box = GetBoxSel();
    box->bb_Left = GetNumber( BBoxGadgets[ GD_BB_X ]);

    BB_Update();

    IE.flags &= ~SALVATO;

    ActivateGadget( BBoxGadgets[ GD_BB_Y ], BBoxWnd, NULL );

    return( TRUE );
}

BOOL BB_YClicked( void )
{
    struct BevelBoxNode *box;

    box = GetBoxSel();
    box->bb_Top = GetNumber( BBoxGadgets[ GD_BB_Y ]);

    BB_Update();

    IE.flags &= ~SALVATO;

    ActivateGadget( BBoxGadgets[ GD_BB_W ], BBoxWnd, NULL );

    return( TRUE );
}

BOOL BB_WClicked( void )
{
    struct BevelBoxNode *box;

    box = GetBoxSel();
    box->bb_Width = GetNumber( BBoxGadgets[ GD_BB_W ]);

    BB_Update();

    IE.flags &= ~SALVATO;

    ActivateGadget( BBoxGadgets[ GD_BB_H ], BBoxWnd, NULL );

    return( TRUE );
}

BOOL BB_HClicked( void )
{
    struct BevelBoxNode *box;

    box = GetBoxSel();
    box->bb_Height = GetNumber( BBoxGadgets[ GD_BB_H ]);

    BB_Update();

    IE.flags &= ~SALVATO;

    return( TRUE );
}

void BB_Update( void )
{
    EditingBox( FALSE );
    RinfrescaFinestra();
    EditingBox( TRUE );
}

BOOL BB_DeleteClicked( void )
{
    struct BevelBoxNode *box;
    BOOL                ret = TRUE;

    box = GetBoxSel();

    IE.win_info->wi_NumBoxes -= 1;

    if(!( IE.win_info->wi_NumBoxes )) {
	OffMenu( BackWnd, (1<<11)|(16<<5)|1 );
	ret = FALSE;
    }

    Remove((struct Node *)box);

    FreeObject( box, IE_BEVELBOX );

    EditingBox( FALSE );
    RinfrescaFinestra();
    EditingBox( TRUE );

    BB_EDable( FALSE );

    return( ret );
}

BOOL BBoxIntuiTicks( void )
{
    void                    ( *func )( struct BevelBoxNode * );
    struct BevelBoxNode    *box;

    if( func = (APTR)buffer ) {
	if( box = GetBoxSel() ) {

	    EditingBox( FALSE );
	    ( *func )( box );
	    EditingBox( TRUE );

	    IE.flags &= ~SALVATO;
	}
    }

    return( TRUE );
}

void BB_MoveUp( struct BevelBoxNode *box )
{
    box->bb_Top -= 1;
}

void BB_MoveDown( struct BevelBoxNode *box )
{
    box->bb_Top += 1;
}

void BB_MoveRight( struct BevelBoxNode *box )
{
    box->bb_Left += 1;
}

void BB_MoveLeft( struct BevelBoxNode *box )
{
    box->bb_Left -= 1;
}

BOOL BB_UpClicked( void )
{
    if( BBoxMsg.Class == IDCMP_GADGETDOWN )
	buffer = (APTR)BB_MoveUp;
    else
	EndBoxMove();
    return( TRUE );
}

BOOL BB_DownClicked( void )
{
    if( BBoxMsg.Class == IDCMP_GADGETDOWN )
	buffer = (APTR)BB_MoveDown;
    else
	EndBoxMove();
    return( TRUE );
}

BOOL BB_RightClicked( void )
{
    if( BBoxMsg.Class == IDCMP_GADGETDOWN )
	buffer = (APTR)BB_MoveRight;
    else
	EndBoxMove();
    return( TRUE );
}

BOOL BB_LeftClicked( void )
{
    if( BBoxMsg.Class == IDCMP_GADGETDOWN )
	buffer = (APTR)BB_MoveLeft;
    else
	EndBoxMove();
    return( TRUE );
}

void EndBoxMove( void )
{
    EditingBox( FALSE );
    RinfrescaFinestra();
    buffer = 0L;
    EditingBox( TRUE );
}

void BB_SistemaXYGads( void )
{
    struct BevelBoxNode *box;

    if( box = GetBoxSel() ) {

	IntegerTag[1] = box->bb_Left;
	GT_SetGadgetAttrsA( BBoxGadgets[ GD_BB_X ], BBoxWnd, NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = box->bb_Top;
	GT_SetGadgetAttrsA( BBoxGadgets[ GD_BB_Y ], BBoxWnd, NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = box->bb_Width;
	GT_SetGadgetAttrsA( BBoxGadgets[ GD_BB_W ], BBoxWnd, NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = box->bb_Height;
	GT_SetGadgetAttrsA( BBoxGadgets[ GD_BB_H ], BBoxWnd, NULL, (struct TagItem *)IntegerTag );

	BB_SistemaRecessed( box );
	BB_SistemaType( box );
    }
}

void BB_EDable( BOOL what )
{
    struct Gadget  *gad;
    int             cnt, pos;
    static UWORD   gads[] = {
			GD_BB_X,
			GD_BB_Y,
			GD_BB_W,
			GD_BB_H,
			GD_BB_Recessed,
			GD_BB_Type
		    };

    pos = RemoveGList( BBoxWnd, &BB_LeftGadget, 5 );

    gad = &BB_LeftGadget;

    for( cnt = 0; cnt < 5; cnt++ ) {
	if( what )
	    gad->Flags &= ~GFLG_DISABLED;
	else
	    gad->Flags |= GFLG_DISABLED;
	gad = gad->NextGadget;
    }

    AddGList( BBoxWnd, &BB_LeftGadget, pos, 5, NULL );
    RefreshGList( &BB_LeftGadget, BBoxWnd, NULL, 5 );

    DisableTag[1] = what ? FALSE : TRUE;
    for( cnt = 0; cnt < 6; cnt++ )
	GT_SetGadgetAttrsA( BBoxGadgets[ gads[ cnt ]], BBoxWnd,
			    NULL, (struct TagItem *)DisableTag );
}

BOOL BB_TypeClicked( void )
{
    struct BevelBoxNode *box;

    if( box = GetBoxSel() ) {

	EditingBox( FALSE );
	box->bb_FrameType = BBoxMsg.Code + 1;
	RinfrescaFinestra();
	EditingBox( TRUE );

	IE.flags &= ~SALVATO;
    }

    return( TRUE );
}

BOOL BB_RecessedKeyPressed( void )
{
    struct BevelBoxNode *box;

    if ( box = GetBoxSel() ) {

	CheckedTag[1] = box->bb_Recessed ? FALSE : TRUE;
	GT_SetGadgetAttrsA( BBoxGadgets[ GD_BB_Recessed ], BBoxWnd,
			    NULL, (struct TagItem *)CheckedTag );

	return( BB_RecessedClicked() );

    } else {
	return( TRUE );
    }
}

BOOL BB_RecessedClicked( void )
{
    struct BevelBoxNode *box;

    if( box = GetBoxSel() ) {

	box->bb_Recessed = ~box->bb_Recessed;

	if( box->bb_Recessed )
	    box->bb_RTag = GTBB_Recessed;
	else
	    box->bb_RTag = TAG_IGNORE;

	BB_SistemaRecessed( box );
	EditingBox( FALSE );
	RinfrescaFinestra();
	EditingBox( TRUE );
	IE.flags &= ~SALVATO;
    }

    return( TRUE );
}

void BB_SistemaRecessed( struct BevelBoxNode *box )
{
    CheckedTag[1] = box->bb_Recessed;
    GT_SetGadgetAttrsA( BBoxGadgets[ GD_BB_Recessed ], BBoxWnd,
			NULL, (struct TagItem *)CheckedTag );
}

void BB_SistemaType( struct BevelBoxNode *box )
{
    MXTag[1] = box->bb_FrameType - 1;
    GT_SetGadgetAttrsA( BBoxGadgets[ GD_BB_Type ], BBoxWnd, NULL, (struct TagItem *)MXTag );
}

BOOL BB_CheckResize( void )
{
    struct BevelBoxNode *box;
    WORD                x, y, xb, yb;
    BOOL                ret = FALSE;

    if(!( box = GetBoxSel() ))
	return( FALSE );

    x = IE.win_active->MouseX;
    y = IE.win_active->MouseY;

    xb = box->bb_Left;
    yb = box->bb_Top;

    if( x >= xb ) {
	if( x <= xb + Q_W ) {           // fascia sinistra
	    if( y >= yb ) {             // fascia superiore
		if( y <= yb + Q_H ) {   // angolo alto sinistra
		    x = xb + box->bb_Width - 1;
		    y = yb + box->bb_Height - 1;
		    ret = TRUE;
		} else {
		    yb += (box->bb_Height - 1);
		    if(( y <= yb ) && ( y >= yb - Q_H )) { // basso a sinistra
			x = xb + box->bb_Width - 1;
			y = box->bb_Top;
			ret = TRUE;
		    }
		}
	    }
	} else {
	    xb += (box->bb_Width - 1);
	    if(( x <= xb ) && ( x >= xb - Q_W )) {  // fascia destra
		if( y >= yb ) {
		    if( y <= yb + Q_H ) {           // alto a destra
			x = box->bb_Left;
			y = yb + box->bb_Height - 1;
			ret = TRUE;
		    } else {
			yb += (box->bb_Height - 1);
			if(( y <= yb ) && ( y >= yb - Q_H )) { // basso a destra
			    x = box->bb_Left;
			    y = box->bb_Top;
			    ret = TRUE;
			}
		    }
		}
	    }
	}
    }

    if( ret ) {

	offx = clickx = x;
	offy = clicky = y;

	if( TraceRect() ) {

	    box->bb_Left    = clickx;
	    box->bb_Top     = clicky;
	    box->bb_Width   = mousex - clickx + 1;
	    box->bb_Height  = mousey - clicky + 1;

	    EditingBox( FALSE );
	    RinfrescaFinestra();
	    EditingBox( TRUE );
	    BB_SistemaXYGads();
	    IE.flags &= ~SALVATO;

	}
    }

    return( ret );
}
///

/// CheckBox
struct BevelBoxNode *CheckBox( void )
{
    struct BevelBoxNode    *box, *ret = NULL;
    ULONG                   area, area2 = -1;

    for( box = IE.win_info->wi_Boxes.mlh_Head; box->bb_Next; box = box->bb_Next )
	if(( mousex >= box->bb_Left ) && ( mousex < box->bb_Left + box->bb_Width ) && ( mousey >= box->bb_Top ) && ( mousey < box->bb_Top + box->bb_Height ))
	    box->bb_Flags |= BB_MAYBE;


    for( box = IE.win_info->wi_Boxes.mlh_Head; box->bb_Next; box = box->bb_Next ) {
	if( box->bb_Flags & BB_MAYBE ) {
	    box->bb_Flags &= ~BB_MAYBE;
	    area = box->bb_Width * box->bb_Height;
	    if( area < area2 ){
		area2 = area;
		ret = box;
	    }
	}
    }

    return( ret );
}
///

/// Get Box
struct BevelBoxNode *GetBox( void )
{
    Stat( CatCompArray[ MSG_SELECTBOX ].cca_Str, FALSE, 0 );
    if( WaitButton() ) {
	Stat( &ok_txt[1], FALSE, 0 );
	return( CheckBox() );
    }
}
///

/// Editing Box
void EditingBox( BOOL what )
{
    struct BevelBoxNode *box;

    SetDrMd( IE.win_active->RPort, COMPLEMENT );

    for( box = IE.win_info->wi_Boxes.mlh_Head; box->bb_Next; box = box->bb_Next ) {
	if( what ) {
	    if( box->bb_Flags & BB_SELECTED ) {
		if(!( box->bb_Flags & G_CONTORNO )) {
		    box->bb_Flags |= G_CONTORNO;
		    DisegnaContorno( box->bb_Left, box->bb_Top, box->bb_Width, box->bb_Height );
		}
	    }
	} else {
	    if( box->bb_Flags & G_CONTORNO ) {
		box->bb_Flags &= ~G_CONTORNO;
		DisegnaContorno( box->bb_Left, box->bb_Top, box->bb_Width, box->bb_Height );
	    }
	}
    }

    SetDrMd( IE.win_active->RPort, JAM1 );
}
///

/// Muovi Boxes
void MuoviBoxes( WORD x, WORD y )
{
    struct BevelBoxNode *box;
    struct MyRect       r;
    UBYTE               code;

    box = GetBoxSel();

    EditingBox( FALSE );

    r.Left   = box->bb_Left;
    r.Top    = box->bb_Top;
    r.Width  = box->bb_Width;
    r.Height = box->bb_Height;

    code = MoveRect( x, y, &r );

    if( code != 0x69 ) {
	box->bb_Left = r.Left;
	box->bb_Top  = r.Top;
    }

    RinfrescaFinestra();

    EditingBox( TRUE );

    BB_SistemaXYGads();

    IE.flags &= ~SALVATO;
}
///

/// Move Rect
UBYTE MoveRect( UWORD x, UWORD y, struct MyRect *r )
{
    int     code = 0;
    WORD    x2, y2;
    struct IntuiMessage *msg;
    struct Window       *wnd;
    ULONG                class;

    offx = x - r->Left;
    offy = y - r->Top;

    ActivateWindow( IE.win_active );
    WindowToFront( IE.win_active );

    IE.win_active->Flags |= WFLG_RMBTRAP;
    SetDrMd( IE.win_active->RPort, COMPLEMENT );

    Rect( r->Left, r->Top, r->Left + r->Width - 1, r->Top + r->Height - 1 );

forever:
	WaitPort( IE.win_active->UserPort );

	while( msg = GT_GetIMsg( IE.win_active->UserPort )) {

	    class = msg->Class;
	    code  = msg->Code;
	    wnd   = msg->IDCMPWindow;

	    GT_ReplyIMsg( msg );

	    if( IE.win_active == wnd ){

		x2 = IE.win_active->MouseX - offx;
		y2 = IE.win_active->MouseY - offy;

		switch( class ) {

		    case IDCMP_MOUSEBUTTONS:
			if( code != 0xE9 )
			    goto done;
			break;

		    case IDCMP_MOUSEMOVE:
			code = 0;
			Coord();
			Rect( r->Left, r->Top,
			      r->Left + r->Width  - 1,
			      r->Top  + r->Height - 1 );
			r->Left = x2;
			r->Top  = y2;
			Rect( r->Left, r->Top,
			      r->Left + r->Width  - 1,
			      r->Top  + r->Height - 1 );
			break;
		}
	    }
	}
    goto forever;

done:

    Rect( r->Left, r->Top,
	  r->Left + r->Width  - 1,
	  r->Top  + r->Height - 1 );

    offx = offy = 0;
    Coord();

    SetDrMd( IE.win_active->RPort, JAM1 );
    IE.win_active->Flags &= ~WFLG_RMBTRAP;

    return( code );
}
///

/// Disegna Contorno
void DisegnaContorno( WORD x, WORD y, UWORD w, UWORD h )
{
    WORD    x2, y2;

    Rect( x, y, x + w - 1, y + h - 1 );

    y2 = y + Q_H + 1;

    // alto a sinistra
    RectFill( IE.win_active->RPort, x + 1, y + 1, x + Q_W + 1, y2 );

    x2 = x + w - 2;

    // alto a destra
    RectFill( IE.win_active->RPort, x2 - Q_W, y, x2, y2 );

    y2 = y + h - 2;

    // basso a destra
    RectFill( IE.win_active->RPort, x2 - Q_W, y2 - Q_H, x2, y2 );

    // basso a sinistra
    RectFill( IE.win_active->RPort, x + 1, y2 - Q_H, x + 1 + Q_W, y2);
}
///

/// Wait Button
BOOL WaitButton( void )
{
    BOOL                    ret = FALSE, ok = TRUE;
    struct IntuiMessage    *msg;
    int                     code;
    ULONG                   class;
    struct Window          *wnd;

    IE.win_active->Flags |= WFLG_RMBTRAP;

    do {

	WaitPort( IE.win_active->UserPort );

	while( msg = GT_GetIMsg( IE.win_active->UserPort )) {

	    class = msg->Class;
	    code  = msg->Code;
	    wnd   = msg->IDCMPWindow;

	    GT_ReplyIMsg( msg );

	    switch( class ) {

		case IDCMP_REFRESHWINDOW:
		    buffer  = IE.win_info;
		    buffer2 = IE.win_active;
		    IE.win_info = wnd->UserData;
		    IE.win_active = wnd;
		    RinfrescaFinestra();
		    IE.win_info = (APTR)buffer;
		    IE.win_active = (APTR)buffer2;
		    break;

		case IDCMP_MOUSEMOVE:
		    Coord();
		    break;

		case IDCMP_MOUSEBUTTONS:
		    switch( code ) {
			case 0x68:
			    ret = TRUE;
			    ok = FALSE;
			    clickx = wnd->MouseX;
			    clicky = wnd->MouseY;
			    break;
			case 0x69:
			    Stat( CatCompArray[ MSG_ABORTED ].cca_Str, FALSE, MSG_ABORTED );
			    ok = FALSE;
			    break;
		    }
		    break;
	    }
	}
    } while( ok );

    IE.win_active->Flags &= ~WFLG_RMBTRAP;

    return( ret );
}
///

/// Trace Rect
BOOL TraceRect( void )
{
    BOOL                 ret = FALSE, ok = TRUE;
    struct IntuiMessage *msg;
    struct Window       *wnd;
    int                  code, swap;
    ULONG                class;

    offx = mousex = clickx;
    offy = mousey = clicky;

    IE.win_active->Flags |= WFLG_RMBTRAP;
    SetDrMd( IE.win_active->RPort, COMPLEMENT );

    do {

	WaitPort( IDCMP_Port );

	while( msg = GT_GetIMsg( IDCMP_Port )) {

	    class = msg->Class;
	    code  = msg->Code;
	    wnd   = msg->IDCMPWindow;

	    GT_ReplyIMsg( msg );

	    switch( class ) {

		case IDCMP_REFRESHWINDOW:
		    {
			APTR    info, act;
			info  = IE.win_info;
			act   = IE.win_active;
			IE.win_info   = wnd->UserData;
			IE.win_active = wnd;
			RinfrescaFinestra();
			IE.win_info   = info;
			IE.win_active = act;
		    }
		    SetDrMd( IE.win_active->RPort, COMPLEMENT );
		    break;

		case IDCMP_MOUSEBUTTONS:
		    switch( code ) {
			case 0xE8:
			    ok = FALSE;
			    ret = TRUE;
			    break;
			case 0x69:
			    ok = FALSE;
			    Stat( CatCompArray[ MSG_ABORTED ].cca_Str, FALSE, MSG_ABORTED );
			    break;
		    }
		    break;

		case IDCMP_MOUSEMOVE:
		    Rect( clickx, clicky, mousex, mousey );
		    Coord();
		    Rect( clickx, clicky, mousex, mousey );
		    break;
	    }
	}
    } while( ok );

    offx = offy = 0;
    Coord();

    if( clickx > mousex ) {
	swap = clickx;
	clickx = mousex;
	mousex = swap;
    }

    if( clicky > mousey ) {
	swap = clicky;
	clicky = mousey;
	mousey = swap;
    }

    Rect( clickx, clicky, mousex, mousey );

    IE.win_active->Flags &= ~WFLG_RMBTRAP;
    SetDrMd( IE.win_active->RPort, JAM1 );
    return( ret );
}
///

/// Setta gli IDCMP
BOOL IDCMPClicked( void )
{
    return( IDCMPMenued() );
}

BOOL IDCMPMenued( void )
{
    struct Node    *node;
    int             cnt;

    list_from_eor = idcmps;
    list_to_eor   = &IE.win_info->wi_IDCMP;

    node = listidcmp.mlh_Head;

    for( cnt = 0; cnt < NUM_IDCMPS; cnt++ ){
	if( IE.win_info->wi_IDCMP & idcmps[ cnt ])
	    node->ln_Name[0] = '*';
	else
	    node->ln_Name[0] = ' ';
	node = node->ln_Succ;
    }

    if( ApriListaFin( CatCompArray[ REQ_SETIDCMP ].cca_Str, 0, &listidcmp )) {

	GestisciListaFin( MARK_SELECTED, NUM_IDCMPS );
	ChiudiListaFin();
	IE.flags &= ~SALVATO;

    }

    return( TRUE );
}
///

/// Setta i flags
BOOL WFlagsClicked( void )
{
    return( WndFlagsMenued() );
}

BOOL WndFlagsMenued( void )
{
    struct Node    *node;
    int             cnt;

    list_from_eor = wflgs;
    list_to_eor   = &IE.win_info->wi_Flags;

    node = listflags.mlh_Head;

    for( cnt = 0; cnt < NUM_FLAGS; cnt++ ){
	if( IE.win_info->wi_Flags & wflgs[ cnt ])
	    node->ln_Name[0] = '*';
	else
	    node->ln_Name[0] = ' ';
	node = node->ln_Succ;
    }

    if(!( IE.win_info->wi_Flags & WFLG_REFRESHBITS ))
	smartrefresh_txt[0] = '*';

    if( ApriListaFin( CatCompArray[ REQ_SETFLAGS ].cca_Str, 0, &listflags )) {

	GestisciListaFin( MARK_SELECTED, NUM_FLAGS );
	ChiudiListaFin();
	IE.flags &= ~SALVATO;

	if( IE.mainprefs & WFLAGS )
	    SettaWFlags( IE.win_info );

    }

    return( TRUE );
}
///

/// Setta i flags di una finestra di editing
void SettaWFlags( struct WindowInfo *wnd )
{
    struct BooleanInfo *gad;

    ContornoGadgets( FALSE );

    CloseWindowSafely( wnd->wi_winptr );

    WorkWndTags[ WORKTOP    ] = wnd->wi_Top;
    WorkWndTags[ WORKLEFT   ] = wnd->wi_Left;
    WorkWndTags[ WORKWIDTH  ] = wnd->wi_Width;
    WorkWndTags[ WORKHEIGHT ] = wnd->wi_Height;
    WorkWndTags[ WORKTITLE  ] = wnd->wi_name;

    if( wnd->wi_NumBools ) {
	gad = wnd->wi_Gadgets.mlh_Head;
	while( gad->b_Kind != BOOLEAN )
	    gad = gad->b_Node.ln_Succ;
	WorkWndTags[ WORKGADGETS ] = &gad->b_NextGadget;
    } else
	WorkWndTags[ WORKGADGETS ] = wnd->wi_GList;

    WorkWndTags[ WORKFLAGS ] = ( IE.mainprefs & WFLAGS ) ? ( wnd->wi_Flags | WFLG_REPORTMOUSE ) : W_F;

    if( wnd->wi_winptr = OpenWindowShdIDCMP( WorkWndTags, WorkWIDCMP )) {

	wnd->wi_flags1 |= W_APERTA;
	IE.win_info   = wnd->wi_winptr->UserData = wnd;
	IE.win_active = wnd->wi_winptr;
	wnd->wi_winptr->ExtData = (APTR)HandleEdit;

	GT_RefreshWindow( IE.win_active, NULL );
	SetMenuStrip( IE.win_active, BackMenus );
	SetPointer( IE.win_active, puntatore, 13, 16, -7, -6 );

	if( IE.mainprefs & STACCATI ) {
	    IE.mainprefs &= ~STACCATI;
	    StaccaGadgets();
	    IE.mainprefs |= STACCATI;
	}

	RinfrescaFinestra();

    } else {
	wnd->wi_flags1 &= ~W_APERTA;
	Stat( CatCompArray[ ERR_NOWND ].cca_Str, TRUE, ERR_NOWND );
    }
}
///

