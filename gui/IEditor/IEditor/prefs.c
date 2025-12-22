/// Include
#define INTUI_V36_NAMES_ONLY
#define ASL_V38_NAMES_ONLY
#define CATCOMP_NUMBERS

#include <exec/memory.h>                // exec
#include <exec/execbase.h>
#include <intuition/intuition.h>        // intuition
#include <libraries/gadtools.h>         // libraries
#include <libraries/asl.h>
#include <clib/exec_protos.h>           // protos
#include <clib/intuition_protos.h>
#include <clib/dos_protos.h>
#include <clib/asl_protos.h>
#include <clib/locale_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/reqtools_protos.h>
#include <pragmas/exec_pragmas.h>       // pragmas
#include <pragmas/intuition_pragmas.h>
#include <pragmas/dos_pragmas.h>
#include <pragmas/locale_pragmas.h>
#include <pragmas/asl_pragmas.h>
#include <pragmas/gadtools_pragmas.h>
#include <pragmas/reqtools_pragmas.h>

#include <stdarg.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "DEV_IE:defs.h"
#include "DEV_IE:GUI.h"
#include "DEV_IE:GUI_locale.h"
#include "DEV_IE:Include/generatorlib-protos.h"
#include "DEV_IE:Include/generator_pragmas.h"
///
/// Prototipi
static void     AttaccaLibsList( void );
static void     AttaccaWndsList( void );
static void     StaccaLibsList( void );
static void     StaccaWndsList( void );
static void     AttivaLibsGads( void );
static void     AttivaWndsGads( void );
static void     DisattivaLibsGads( void );
static void     DisattivaWndsGads( void );
static void     SistemaLibsGads( struct LibNode * );
static BOOL     MP_EditLib( struct LibNode * );
static void     AttaccaRexxList( void );
static void     StaccaRexxList( void );
static BOOL     EditRexxCmd( struct RexxNode * );
static void     SistemaF( void );
static void     rx_GetFile( UWORD );
static void     RemakeMacroMenu( void );
static BOOL     ExecMenuMacro( void );
static struct Menu *GetMacroMenu( void );
static void     HandleGen( void );
static void     HandleMacro( void );
static void     HandleMainProc( void );
static void     HandleRexxEd( void );
///
/// Dati
static struct LibNode  *MP_BackLib;
static WORD             MP_RetCode;

static UWORD    MP_Timer, MP_buf, MP_buf2;
static ULONG    MP_ListTag[]  = { GTLV_Top, 0, GTLV_Selected, 0, TAG_END };
static ULONG    MP_ListTag2[] = { GTLV_Top, 0, GTLV_Selected, 0, TAG_END };

static ULONG    RE_ListTag[]  = { GTLV_Top, 0, GTLV_Selected, 0, TAG_END };
static UWORD    RE_Timer, RE_Last;

UWORD           NewRexxID;

UWORD           F_Offset;

TEXT            ExtraProc[60];
TEXT            RexxExt[15];
TEXT            ARexxPortName[50];

struct MinList MacroList = { &MacroList.mlh_Tail, NULL, &MacroList.mlh_Head };
UWORD           NumMacros;

WORD            Timer;

static TEXT     ReqFile[30];
static TEXT     ReqDrawer[256];

static STRPTR   LibBases[] = {
	    "ArpBase",
	    "AslBase",
	    "CommoditiesBase",
	    AP_FntString2,
	    "ExpansionBase",
	    AP_GadString2,
	    AP_GfxString2,
	    "IconBase",
	    "IFFParseBase",
	    AP_IntString2,
	    "KeymapBase",
	    "LayersBase",
	    "MathBase",
	    "MathIeeeDoubBasBase",
	    "MathIeeeDoubTransBase",
	    "MathIeeeSingBasBase",
	    "MathIeeeSingTransBase",
	    AP_RexxString2,
	    "ReqToolsBase",
	    "TranslatorBase",
	    "UtilityBase",
	    "WorkbenchBase",
	    "LocaleBase",
	    "BulletBase",
	    "DataTypesBase",
	    "XPKMasterBase",
	    AP_DosString2
	};

static UWORD MacroGads[] = {
	    GD_rx_1,
	    GD_rx_2,
	    GD_rx_3,
	    GD_rx_4,
	    GD_rx_5,
	    GD_rx_6,
	    GD_rx_7,
	    GD_rx_8,
	    GD_rx_9,
	    GD_rx_10,
	};

UBYTE   AsmPrefs, AsmPrefs2, C_Prefs;

TEXT    AP_IntString2[60]  = "IntuitionBase";
TEXT    AP_DosString2[60]  = "DOSBase";
TEXT    AP_GfxString2[60]  = "GfxBase";
TEXT    AP_GadString2[60]  = "GadToolsBase";
TEXT    AP_RexxString2[60] = "RexxSysBase";
TEXT    AP_FntString2[60]  = "DiskfontBase";

TEXT    CP_ChipString2[25] = "UWORD __chip";
///


//      Main Proc Editor
/// Elimina Main Proc Data
void EliminaMainProcData( void )
{
    struct LibNode     *lib;
    struct WndToOpen   *wto;

    IE.NumLibs = IE.NumWndTO = 0;

    while( lib = RemTail((struct List *)&IE.Libs_List ))
	FreeObject( lib, IE_LIBRARY );

    while( wto = RemTail((struct List *)&IE.WndTO_List ))
	FreeObject( wto, IE_WNDTOOPEN );
}
///
/// Main Proc Editor
BOOL MainProcMenued( void )
{
    int     ret;

    if( MainProcWnd ) {
	ActivateWindow( MainProcWnd );
	WindowToFront( MainProcWnd );
	return( TRUE );
    }

    LayoutWindow( MainProcWTags );
    ret = OpenMainProcWindow();
    PostOpenWindow( MainProcWTags );

    if( ret ) {
	DisplayBeep( Scr );
	CloseMainProcWindow();
    } else {

	if( GadToolsBase->lib_Version >= 39 ) {
	    MP_ListTag[0]  = GTLV_MakeVisible;
	    MP_ListTag2[0] = GTLV_MakeVisible;
	}

	MP_ListTag[1] = MP_ListTag[3] = MP_ListTag2[1] = MP_ListTag2[3] = 0;

	AttaccaLibsList();
	AttaccaWndsList();

	if( IE.NumLibs )
	    AttivaLibsGads();

	if( IE.NumWndTO )
	    AttivaWndsGads();

	CheckedTag[1] = ( IE.MainProcFlags & MAIN_CTRL_C ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( MainProcGadgets[ GD_MP_CtrlC ], MainProcWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( IE.MainProcFlags & MAIN_OTHERBITS ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( MainProcGadgets[ GD_MP_XtraBits ], MainProcWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( IE.MainProcFlags & MAIN_WB ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( MainProcGadgets[ GD_MP_WB ], MainProcWnd,
			    NULL, (struct TagItem *)CheckedTag );

	StringTag[1] = ExtraProc;
	GT_SetGadgetAttrsA( MainProcGadgets[ GD_MP_XtraProc ], MainProcWnd,
			    NULL, (struct TagItem *)StringTag );

	MP_Timer = 0;

	MP_buf = MP_buf2 = -1;

	MainProcWnd->ExtData = HandleMainProc;
    }

    return( TRUE );
}

void HandleMainProc( void )
{
    if(!( HandleMainProcIDCMP() ))
	CloseMainProcWindow();
}

void StaccaLibsList( void )
{
    ListTag[1] = NULL;
    GT_SetGadgetAttrsA( MainProcGadgets[ GD_MP_OpenLib ], MainProcWnd,
			NULL, (struct TagItem *)ListTag );
}

void StaccaWndsList( void )
{
    ListTag[1] = NULL;
    GT_SetGadgetAttrsA( MainProcGadgets[ GD_MP_OpenWnd ], MainProcWnd,
			NULL, (struct TagItem *)ListTag );
}

void AttaccaLibsList( void )
{
    ListTag[1] = &IE.Libs_List;
    GT_SetGadgetAttrsA( MainProcGadgets[ GD_MP_OpenLib ], MainProcWnd,
			NULL, (struct TagItem *)ListTag );
    GT_SetGadgetAttrsA( MainProcGadgets[ GD_MP_OpenLib ], MainProcWnd,
			NULL, (struct TagItem *)MP_ListTag );
}

void AttaccaWndsList( void )
{
    ListTag[1] = &IE.WndTO_List;
    GT_SetGadgetAttrsA( MainProcGadgets[ GD_MP_OpenWnd ], MainProcWnd,
			NULL, (struct TagItem *)ListTag );
    GT_SetGadgetAttrsA( MainProcGadgets[ GD_MP_OpenWnd ], MainProcWnd,
			NULL, (struct TagItem *)MP_ListTag2 );
}

BOOL MP_OpenLibClicked( void )
{
    UWORD           old = MP_buf;
    struct LibNode *lib;

    MP_buf = MP_ListTag[1] = MP_ListTag[3] = IDCMPMsg.Code;

    AttivaLibsGads();

    if( MP_Timer < 3 ) {
	if( old == MP_buf ) {
	    lib = (struct Node *)&IE.Libs_List;
	    for( old = 0; old <= MP_buf; old++ )
		lib = lib->lbn_Node.ln_Succ;

	    MP_EditLib( lib );
	}
    }

    MP_Timer = 0;

    return( TRUE );
}

void AttivaLibsGads( void )
{
    DisableTag[1] = FALSE;
    GT_SetGadgetAttrsA( MainProcGadgets[ GD_MP_DelLib ], MainProcWnd,
			NULL, (struct TagItem *)DisableTag );
}

void DisattivaLibsGads( void )
{
    DisableTag[1] = TRUE;
    GT_SetGadgetAttrsA( MainProcGadgets[ GD_MP_DelLib ], MainProcWnd,
			NULL, (struct TagItem *)DisableTag );
}

void AttivaWndsGads( void )
{
    struct Gadget  *g;
    int             pos, cnt;

    DisableTag[1] = FALSE;
    GT_SetGadgetAttrsA( MainProcGadgets[ GD_MP_DelWnd ], MainProcWnd,
			NULL, (struct TagItem *)DisableTag );

    g  = &MP_WndUpGadget;

    pos = RemoveGList( MainProcWnd, g, 4 );

    for( cnt = 0; cnt < 4; cnt++ ) {
	g->Flags &= ~GFLG_DISABLED;
	g = g->NextGadget;
    }

    AddGList( MainProcWnd, &MP_WndUpGadget, pos, 4, NULL );

    RefreshGList( &MP_WndUpGadget, MainProcWnd, NULL, 4 );
}

void DisattivaWndsGads( void )
{
    struct Gadget  *g;
    int             pos, cnt;

    DisableTag[1] = TRUE;
    GT_SetGadgetAttrsA( MainProcGadgets[ GD_MP_DelWnd ], MainProcWnd,
			NULL, (struct TagItem *)DisableTag );

    g  = &MP_WndUpGadget;

    pos = RemoveGList( MainProcWnd, g, 4 );

    for( cnt = 0; cnt < 4; cnt++ ) {
	g->Flags |= GFLG_DISABLED;
	g = g->NextGadget;
    }

    AddGList( MainProcWnd, &MP_WndUpGadget, pos, 4, NULL );

    RefreshGList( &MP_WndUpGadget, MainProcWnd, NULL, 4 );
}

BOOL MP_LibFromClicked( void )
{
    UWORD           old = MP_buf2;
    struct LibNode *lib;
    struct Node    *lib2;

    MP_buf2 = IDCMPMsg.Code;

    if( MP_Timer < 3 ) {
	if( old == MP_buf2 ) {

	    if( lib = AllocObject( IE_LIBRARY )) {

		lib2 = (struct Node *)&MP_LibFromList;
		for( old = 0; old <= MP_buf2; old++ )
		    lib2 = lib2->ln_Succ;

		lib->lbn_Node.ln_Pri |= L_FAIL;

		strcpy( lib->lbn_Name, lib2->ln_Name );
		strcpy( lib->lbn_Base, LibBases[ MP_buf2 ]);

		struct LibNode *lb;
		for( lb = IE.Libs_List.mlh_Head; lb->lbn_Node.ln_Succ; lb = lb->lbn_Node.ln_Succ )
		    if(!( strcmp( lib->lbn_Name, lb->lbn_Name ))) {
			FreeObject( lib, IE_LIBRARY );
			return( TRUE );
		    }

		StaccaLibsList();
		AddTail((struct List *)&IE.Libs_List, (struct Node *)lib );
		AttaccaLibsList();

		IE.NumLibs += 1;

		IE.flags &= ~SALVATO;

	    } else {
		Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, 0 );
	    }

	}
    }

    MP_Timer = 0;

    return( TRUE );
}

BOOL MP_DelLibClicked( void )
{
    struct LibNode *lib;
    int             cnt;

    lib = (struct LibNode *)&IE.Libs_List;
    for( cnt = 0; cnt <= MP_ListTag[1]; cnt++ )
	lib = lib->lbn_Node.ln_Succ;

    StaccaLibsList();
    Remove((struct Node *)lib );
    AttaccaLibsList();

    FreeObject( lib, IE_LIBRARY );

    IE.NumLibs -= 1;

    IE.flags &= ~SALVATO;

    DisattivaLibsGads();

    return( TRUE );
}

BOOL MP_AddLibClicked( void )
{
    struct LibNode *lib;

    if( lib = AllocObject( IE_LIBRARY )) {

	lib->lbn_Node.ln_Pri |= L_FAIL;

	if( MP_EditLib( lib )) {

	    lib->lbn_Node.ln_Name = lib->lbn_Name;

	    struct LibNode *lb;
	    for( lb = IE.Libs_List.mlh_Head; lb->lbn_Node.ln_Succ; lb = lb->lbn_Node.ln_Succ )
		if(!( strcmp( lib->lbn_Name, lb->lbn_Name ))) {
		    FreeObject( lib, IE_LIBRARY );
		    return( TRUE );
		}

	    StaccaLibsList();
	    AddTail((struct List *)&IE.Libs_List, (struct Node *)lib );
	    AttaccaLibsList();

	    IE.NumLibs += 1;

	    IE.flags &= ~SALVATO;

	} else {
	    FreeObject( lib, IE_LIBRARY );
	    Stat( CatCompArray[ MSG_ABORTED ].cca_Str, FALSE, 0 );
	}

    } else
	Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, 0 );

    return( TRUE );
}

BOOL MP_OpenWndClicked( void )
{
    MP_ListTag2[1] = MP_ListTag2[3] = IDCMPMsg.Code;
    AttivaWndsGads();
    return( TRUE );
}

BOOL MP_AddWndClicked( void )
{
    struct WindowInfo  *wnd;
    struct WndToOpen   *wto;
    APTR                Lock;

    Lock = rtLockWindow( MainProcWnd );

    if( wnd = GetWnd() ) {

	for( wto = IE.WndTO_List.mlh_Head; wto->wto_Node.ln_Succ; wto = wto->wto_Node.ln_Succ )
	    if(!( strcmp( wnd->wi_Label, wto->wto_Label ))) {
		rtUnlockWindow( MainProcWnd, Lock );
		return( TRUE );
	    }

	if( wto = AllocObject( IE_WNDTOOPEN )) {

	    strcpy( wto->wto_Label, wnd->wi_Label );

	    StaccaWndsList();
	    AddTail((struct List *)&IE.WndTO_List, (struct Node *)wto );
	    AttaccaWndsList();

	    IE.NumWndTO += 1;

	    IE.flags &= ~SALVATO;

	    AttivaWndsGads();

	} else
	    Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, 0 );

    } else
	Stat( CatCompArray[ MSG_ABORTED ].cca_Str, FALSE, 0 );

    rtUnlockWindow( MainProcWnd, Lock );

    return( TRUE );
}

BOOL MP_DelWndClicked( void )
{
    struct WndToOpen   *wto;
    int                 cnt;

    wto = (struct WndToOpen *)&IE.WndTO_List;
    for( cnt = 0; cnt <= MP_ListTag2[1]; cnt++ )
	wto = wto->wto_Node.ln_Succ;

    StaccaWndsList();
    Remove((struct Node *)wto );
    AttaccaWndsList();

    FreeObject( wto, IE_WNDTOOPEN );

    IE.NumWndTO -= 1;

    IE.flags &= ~SALVATO;

    DisattivaWndsGads();

    return( TRUE );
}

BOOL MP_WndTopClicked( void )
{
    struct WndToOpen   *wto;
    int                 cnt;

    wto = (struct WndToOpen *)&IE.WndTO_List;
    for( cnt = 0; cnt <= MP_ListTag2[1]; cnt++ )
	wto = wto->wto_Node.ln_Succ;

    StaccaWndsList();

    Remove((struct Node *)wto );
    AddHead((struct List *)&IE.WndTO_List, (struct Node *)wto );

    MP_ListTag2[1] = MP_ListTag2[3] = 0;

    AttaccaWndsList();

    IE.flags &= ~SALVATO;

    return( TRUE );
}

BOOL MP_WndBottomClicked( void )
{
    struct WndToOpen   *wto;
    int                 cnt;

    wto = (struct WndToOpen *)&IE.WndTO_List;
    for( cnt = 0; cnt <= MP_ListTag2[1]; cnt++ )
	wto = wto->wto_Node.ln_Succ;

    StaccaWndsList();

    Remove((struct Node *)wto );
    AddTail((struct List *)&IE.WndTO_List, (struct Node *)wto );

    MP_ListTag2[1] = MP_ListTag2[3] = IE.NumWndTO - 1;

    AttaccaWndsList();

    IE.flags &= ~SALVATO;

    return( TRUE );
}

BOOL MP_WndUpClicked( void )
{
    struct WndToOpen   *wto;
    int                 cnt;

    if( MP_ListTag2[1] ) {

	wto = (struct WndToOpen *)&IE.WndTO_List;
	for( cnt = 0; cnt <= MP_ListTag2[1]; cnt++ )
	    wto = wto->wto_Node.ln_Succ;

	StaccaWndsList();

	NodeUp( wto );

	MP_ListTag2[1] -= 1;
	MP_ListTag2[3] -= 1;

	AttaccaWndsList();

	IE.flags &= ~SALVATO;

    }

    return( TRUE );
}

BOOL MP_WndDownClicked( void )
{
    struct WndToOpen   *wto;
    int                 cnt;

    if( MP_ListTag2[1] < IE.NumWndTO - 1 ) {

	wto = (struct WndToOpen *)&IE.WndTO_List;
	for( cnt = 0; cnt <= MP_ListTag2[1]; cnt++ )
	    wto = wto->wto_Node.ln_Succ;

	StaccaWndsList();

	NodeDown( wto );

	MP_ListTag2[1] += 1;
	MP_ListTag2[3] += 1;

	AttaccaWndsList();

	IE.flags &= ~SALVATO;

    }

    return( TRUE );
}

BOOL MP_CtrlCClicked( void )
{
    IE.MainProcFlags ^= MAIN_CTRL_C;
    IE.flags &= ~SALVATO;
    return( TRUE );
}

BOOL MP_XtraBitsClicked( void )
{
    IE.MainProcFlags ^= MAIN_OTHERBITS;
    IE.flags &= ~SALVATO;
    return( TRUE );
}

BOOL MP_WBClicked( void )
{
    IE.MainProcFlags ^= MAIN_WB;
    IE.flags &= ~SALVATO;
    return( TRUE );
}

BOOL MP_XtraProcClicked( void )
{
    return( TRUE );
}

BOOL MainProcCloseWindow( void )
{
    strcpy( ExtraProc, GetString( MainProcGadgets[ GD_MP_XtraProc ]));
    return( FALSE );
}

BOOL MainProcIntuiTicks( void )
{
    MP_Timer += 1;
    return( TRUE );
}
///
/// EditLib
BOOL MP_EditLib( struct LibNode *lib )
{
    int     ret;
    APTR    MP_Lock;
    BYTE    MP_BackPri;

    LockAllWindows();
    MP_Lock = rtLockWindow( MainProcWnd );

    LayoutWindow( MPEdLibWTags );
    ret = OpenMPEdLibWindow();
    PostOpenWindow( MPEdLibWTags );

    if( ret )
	DisplayBeep( Scr );
    else {

	SistemaLibsGads( lib );

	MP_BackPri = lib->lbn_Node.ln_Pri;
	MP_BackLib = lib;

	MP_RetCode = 0;

	do {
	    ReqHandle( MPEdLibWnd, HandleMPEdLibIDCMP );
	} while(!( MP_RetCode ));

	if( MP_RetCode > 0 ) {
	    MP_BackLib->lbn_Node.ln_Pri = MP_BackPri;
	    ret = FALSE;
	} else {

	    StaccaLibsList();
	    strcpy( lib->lbn_Name, GetString( MPEdLibGadgets[ GD_MPEL_Lib ]) );
	    AttaccaLibsList();

	    strcpy( lib->lbn_Base, GetString( MPEdLibGadgets[ GD_MPEL_Base ]) );

	    lib->lbn_Version = GetNumber( MPEdLibGadgets[ GD_MPEL_Vers ]);

	    IE.flags &= ~SALVATO;

	    ret = TRUE;
	}
    }

    CloseMPEdLibWindow();

    rtUnlockWindow( MainProcWnd, MP_Lock );
    UnlockAllWindows();

    return( ret );
}

void SistemaLibsGads( struct LibNode *lib )
{
    StringTag[1] = lib->lbn_Node.ln_Name;
    GT_SetGadgetAttrsA( MPEdLibGadgets[ GD_MPEL_Lib ], MPEdLibWnd,
			NULL, (struct TagItem *)StringTag );

    StringTag[1] = lib->lbn_Base;
    GT_SetGadgetAttrsA( MPEdLibGadgets[ GD_MPEL_Base ], MPEdLibWnd,
			NULL, (struct TagItem *)StringTag );

    IntegerTag[1] = lib->lbn_Version;
    GT_SetGadgetAttrsA( MPEdLibGadgets[ GD_MPEL_Vers ], MPEdLibWnd,
			NULL, (struct TagItem *)IntegerTag );

    CheckedTag[1] = ( lib->lbn_Node.ln_Pri & L_FAIL ) ? TRUE : FALSE;
    GT_SetGadgetAttrsA( MPEdLibGadgets[ GD_MPEL_Fail ], MPEdLibWnd,
			NULL, (struct TagItem *)CheckedTag );
}

BOOL MPEdLibVanillaKey( void )
{
    switch( MPEdLibMsg.Code ) {
	case 13:
	    MP_RetCode = -1;
	    break;
	case 27:
	    MP_RetCode = 1;
	    break;
    }
}

BOOL MPEL_OkKeyPressed( void )
{
    MP_RetCode =  -1;
}

BOOL MPEL_OkClicked( void )
{
    MP_RetCode = -1;
}

BOOL MPEL_AnnullaKeyPressed( void )
{
    MP_RetCode = 1;
}

BOOL MPEL_AnnullaClicked( void )
{
    MP_RetCode = 1;
}

BOOL MPEL_VersClicked( void )
{
}

BOOL MPEL_LibClicked( void )
{
    ActivateGadget( MPEdLibGadgets[ GD_MPEL_Base ], MPEdLibWnd, NULL );
}

BOOL MPEL_BaseClicked( void )
{
    ActivateGadget( MPEdLibGadgets[ GD_MPEL_Vers ], MPEdLibWnd, NULL );
}

BOOL MPEL_FailKeyPressed( void )
{
    CheckedTag[1] = ( MP_BackLib->lbn_Node.ln_Pri & L_FAIL ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( MPEdLibGadgets[ GD_MPEL_Fail ], MPEdLibWnd,
			NULL, (struct TagItem *)CheckedTag );

    MPEL_FailClicked();
}

BOOL MPEL_FailClicked( void )
{
    MP_BackLib->lbn_Node.ln_Pri ^= L_FAIL;
}
///

//      ARexx Editor
/// Libera ARexx Cmds
void LiberaARexxCmds( void )
{
    struct RexxNode *rexx;

    while( rexx = RemTail((struct List *)&IE.Rexx_List ))
	FreeObject( rexx, IE_REXXCMD );

    IE.NumRexxs = 0;
    NewRexxID = 0;
}
///
/// ARexx Editor
BOOL RexxEdMenued( void )
{
    BOOL     ret;

    if( RexxEdWnd ) {
	ActivateWindow( RexxEdWnd );
	WindowToFront( RexxEdWnd );
	return( TRUE );
    }

    LayoutWindow( RexxEdWTags );
    ret = OpenRexxEdWindow();
    PostOpenWindow( RexxEdWTags );

    if( ret ) {
	DisplayBeep( Scr );
	CloseRexxEdWindow();
    } else {

	if( SysBase->LibNode.lib_Version >= 39 )
	    RE_ListTag[0]  = GTLV_MakeVisible;

	RE_Last = RE_Timer = 0;

	RE_ListTag[1] = RE_ListTag[3] = -1;

	AttaccaRexxList();

	StringTag[1] = ARexxPortName;
	GT_SetGadgetAttrsA( RexxEdGadgets[ GD_RXE_Port ], RexxEdWnd,
			    NULL, (struct TagItem *)StringTag );

	StringTag[1] = RexxExt;
	GT_SetGadgetAttrsA( RexxEdGadgets[ GD_RXE_Ext ], RexxEdWnd,
			    NULL, (struct TagItem *)StringTag );

	CycleTag[1] = ( IE.SrcFlags & AREXX_CMD_LIST ) ? 1 : 0;
	GT_SetGadgetAttrsA( RexxEdGadgets[ GD_RXE_CmdIn ], RexxEdWnd,
			    NULL, (struct TagItem *)CycleTag );

	RexxEdWnd->ExtData = HandleRexxEd;
    }

    return( TRUE );
}

void HandleRexxEd( void )
{
    if(!( HandleRexxEdIDCMP() ))
	CloseRexxEdReq();
}

void CloseRexxEdReq( void )
{
    if( RexxEdWnd ) {

	strcpy( IE.RexxPortName, GetString( RexxEdGadgets[ GD_RXE_Port ]) );
	strcpy( IE.RexxExt, GetString( RexxEdGadgets[ GD_RXE_Ext ]) );

	IE.flags &= ~SALVATO;

	CloseRexxEdWindow();
    }
}

void StaccaRexxList( void )
{
    ListTag[1] = NULL;
    GT_SetGadgetAttrsA( RexxEdGadgets[ GD_RXE_Cmd ], RexxEdWnd,
			NULL, (struct TagItem *)ListTag );
}

void AttaccaRexxList( void )
{
    ListTag[1] = &IE.Rexx_List;
    GT_SetGadgetAttrsA( RexxEdGadgets[ GD_RXE_Cmd ], RexxEdWnd,
			NULL, (struct TagItem *)ListTag );
    GT_SetGadgetAttrsA( RexxEdGadgets[ GD_RXE_Cmd ], RexxEdWnd,
			NULL, (struct TagItem *)RE_ListTag );
}

BOOL RexxEdIntuiTicks( void )
{
    RE_Timer += 1;
    return( TRUE );
}

BOOL RexxEdCloseWindow( void )
{
    return( FALSE );
}

BOOL RXE_CmdKeyPressed( void )
{

    if( IDCMPMsg.Code & 0x20 ) {

	if( RE_ListTag[1] < IE.NumRexxs - 1 )
	    RE_ListTag[1] += 1;
	else
	    RE_ListTag[1] = 0;

    } else {

	if( RE_ListTag[1] )
	    RE_ListTag[1] -= 1;
	else
	    RE_ListTag[1] = IE.NumRexxs - 1;
    }

    RE_ListTag[3] = IDCMPMsg.Code = RE_ListTag[1];

    GT_SetGadgetAttrsA( RexxEdGadgets[ GD_RXE_Cmd ], RexxEdWnd,
			NULL, (struct TagItem *)RE_ListTag );

    return( RXE_CmdClicked() );
}

BOOL RXE_CmdClicked( void )
{
    WORD                old = RE_Last;
    struct RexxNode    *rexx;

    RE_Last = RE_ListTag[1] = RE_ListTag[3] = IDCMPMsg.Code;

    if( RE_Timer < 3 ) {
	if( RE_Last == old ) {

	    rexx = (struct RexxNode *)&IE.Rexx_List;
	    for( old = 0; old <= RE_Last; old++ )
		rexx = rexx->rxn_Node.ln_Succ;

	    EditRexxCmd( rexx );
	}
    }

    RE_Timer = 0;

    DisableTag[1] = FALSE;
    GT_SetGadgetAttrsA( RexxEdGadgets[ GD_RXE_Del ], RexxEdWnd,
			NULL, (struct TagItem *)DisableTag );

    return( TRUE );
}

BOOL RexxEdVanillaKey( void )
{
    if( IDCMPMsg.Code == 27 )
	return( RexxEdCloseWindow() );

    return( TRUE );
}

BOOL RXE_ExtClicked( void )
{
    return( TRUE );
}

BOOL RXE_PortClicked( void )
{
    ActivateGadget( RexxEdGadgets[ GD_RXE_Ext], RexxEdWnd, NULL );
    return( TRUE );
}

BOOL RXE_DelKeyPressed( void )
{
    return( RXE_DelClicked() );
}

BOOL RXE_DelClicked( void )
{
    struct RexxNode    *rexx;
    int                 old;

    rexx = (struct RexxNode *)&IE.Rexx_List;
    for( old = 0; old <= RE_Last; old++ )
	rexx = rexx->rxn_Node.ln_Succ;

    StaccaRexxList();
    Remove((struct Node *)rexx );
    AttaccaRexxList();

    FreeObject( rexx, IE_REXXCMD );

    IE.NumRexxs -= 1;

    DisableTag[1] = TRUE;
    GT_SetGadgetAttrsA( RexxEdGadgets[ GD_RXE_Del ], RexxEdWnd,
			NULL, (struct TagItem *)DisableTag );

    return( TRUE );
}

BOOL RXE_AddKeyPressed( void )
{
    return( RXE_AddClicked() );
}

BOOL RXE_AddClicked( void )
{
    struct RexxNode    *rexx;

    if( rexx = AllocObject( IE_REXXCMD )) {

	if( EditRexxCmd( rexx )) {

	    IE.NumRexxs += 1;

	    if(!( rexx->rxn_Label[0] )) {
		sprintf( rexx->rxn_Label, "Command%03ld", NewRexxID );
		NewRexxID += 1;
	    }

	    StaccaRexxList();
	    AddTail((struct List *)&IE.Rexx_List, (struct Node *)rexx );
	    AttaccaRexxList();

	} else {
	    FreeObject( rexx, IE_REXXCMD );
	    Stat( CatCompArray[ MSG_ABORTED ].cca_Str, FALSE, 0 );
	}

    } else
	Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, 0 );

    return( TRUE );
}

BOOL RXE_CmdInKeyPressed( void )
{
    CycleTag[1] = ( IE.SrcFlags & AREXX_CMD_LIST ) ? 0 : 1;

    GT_SetGadgetAttrsA( RexxEdGadgets[ GD_RXE_CmdIn ], RexxEdWnd,
			NULL, (struct TagItem *)CycleTag );

    return( RXE_CmdInClicked() );
}

BOOL RXE_CmdInClicked( void )
{
    IE.SrcFlags ^= AREXX_CMD_LIST;

    return( TRUE );
}
///
/// Edit Rexx Cmd
BOOL EditRexxCmd( struct RexxNode *rexx )
{
    int     ret;
    APTR    Lock;

    LockAllWindows();

    Lock = rtLockWindow( RexxEdWnd );

    LayoutWindow( RexxCmdWTags );
    ret = OpenRexxCmdWindow();
    PostOpenWindow( RexxCmdWTags );

    if( ret ) {
	DisplayBeep( Scr );
	ret = FALSE;
    } else {

	StringTag[1] = rexx->rxn_Label;
	GT_SetGadgetAttrsA( RexxCmdGadgets[ GD_RXC_Label ], RexxCmdWnd,
			    NULL, (struct TagItem *)StringTag );

	StringTag[1] = rexx->rxn_Name;
	GT_SetGadgetAttrsA( RexxCmdGadgets[ GD_RXC_Cmd ], RexxCmdWnd,
			    NULL, (struct TagItem *)StringTag );

	StringTag[1] = rexx->rxn_Template;
	GT_SetGadgetAttrsA( RexxCmdGadgets[ GD_RXC_Template ], RexxCmdWnd,
			    NULL, (struct TagItem *)StringTag );

	ActivateGadget( RexxCmdGadgets[ GD_RXC_Label ], RexxCmdWnd, NULL );

	RetCode = 0;

	do {
	    ReqHandle( RexxCmdWnd, HandleRexxCmdIDCMP );
	} while(!( RetCode ));

	if( RetCode > 0 ) {
	    ret = FALSE;
	} else {

	    StaccaRexxList();
	    strcpy( rexx->rxn_Name, GetString( RexxCmdGadgets[ GD_RXC_Cmd ]) );
	    AttaccaRexxList();

	    STRPTR label;

	    label = GetString( RexxCmdGadgets[ GD_RXC_Label ]);

	    if( label[0] )
		strcpy( rexx->rxn_Label, label );

	    strcpy( rexx->rxn_Template, GetString( RexxCmdGadgets[ GD_RXC_Template ]) );

	    IE.flags &= ~SALVATO;

	    ret = TRUE;
	}
    }

    CloseRexxCmdWindow();

    rtUnlockWindow( RexxEdWnd, Lock );

    UnlockAllWindows();

    return( ret );
}

BOOL RexxCmdVanillaKey( void )
{
    switch( RexxCmdMsg.Code ) {
	case 13:
	    RetCode = -1;
	    break;
	case 27:
	    RetCode = 1;
    }
}

BOOL RXC_OkKeyPressed( void )
{
    STRPTR  cmd;

    cmd = GetString( RexxCmdGadgets[ GD_RXC_Cmd ]);

    if( cmd[0] )
	RetCode = -1;
    else
	DisplayBeep( Scr );
}

BOOL RXC_AnnullaKeyPressed( void )
{
    RetCode = 1;
}

BOOL RXC_OkClicked( void )
{
    STRPTR  cmd;

    cmd = GetString( RexxCmdGadgets[ GD_RXC_Cmd ]);

    if( cmd[0] )
	RetCode = -1;
    else
	DisplayBeep( Scr );
}

BOOL RXC_AnnullaClicked( void )
{
    RetCode = 1;
}

BOOL RXC_TemplateClicked( void )
{
}

BOOL RXC_LabelClicked( void )
{
    ActivateGadget( RexxCmdGadgets[ GD_RXC_Cmd ], RexxCmdWnd, NULL );
}

BOOL RXC_CmdClicked( void )
{
    ActivateGadget( RexxCmdGadgets[ GD_RXC_Template ], RexxCmdWnd, NULL );
}
///

//      Macros
/// Tasti funzione
BOOL MacrosMenued( void )
{
    int ret;

    if( MacroWnd ) {
	ActivateWindow( MacroWnd );
	WindowToFront( MacroWnd );
	return( TRUE );
    }

    LayoutWindow( MacroWTags );
    ret = OpenMacroWindow();
    PostOpenWindow( MacroWTags );

    if( ret ) {
	DisplayBeep( Scr );
	CloseMacroWindow();
    } else {

	F_Offset = 0;

	SistemaF();

	MacroWnd->ExtData = HandleMacro;
    }

    return( TRUE );
}

void HandleMacro( void )
{
    if(!( HandleMacroIDCMP() )) {
	GetF();
	CloseMacroWindow();
    }
}

BOOL rx_10Clicked( void )
{
    return( TRUE );
}

BOOL MacroCloseWindow( void )
{
    return( FALSE );
}

BOOL MacroVanillaKey( void )
{
    if(( IDCMPMsg.Code == 13 ) || ( IDCMPMsg.Code == 27 ))
	return( FALSE );

    return( TRUE );
}

void SistemaF( void )
{
    UWORD   cnt, m;

    m = F_Offset * 10;

    for( cnt = 0; cnt < 10; cnt++ ) {
	StringTag[1] = Macros[ m ];
	m += 1;
	GT_SetGadgetAttrsA( MacroGadgets[ MacroGads[ cnt ]], MacroWnd,
			    NULL, (struct TagItem *)StringTag );
    }
}

void GetF( void )
{
    int     cnt, m;

    m = F_Offset * 10;

    for( cnt = 0; cnt < 10; cnt++ ) {
	strcpy( &Macros[ m ][0], GetString( MacroGadgets[ MacroGads[ cnt ]]) );
	m += 1;
    }
}

BOOL QualifClicked( void )
{
    GetF();

    F_Offset = IDCMPMsg.Code;

    SistemaF();

    return( TRUE );
}

BOOL rx_1Clicked( void )
{
    ActivateGadget( MacroGadgets[ GD_rx_2 ], MacroWnd, NULL );
    return( TRUE );
}

BOOL rx_2Clicked( void )
{
    ActivateGadget( MacroGadgets[ GD_rx_3 ], MacroWnd, NULL );
    return( TRUE );
}

BOOL rx_3Clicked( void )
{
    ActivateGadget( MacroGadgets[ GD_rx_4 ], MacroWnd, NULL );
    return( TRUE );
}

BOOL rx_4Clicked( void )
{
    ActivateGadget( MacroGadgets[ GD_rx_5 ], MacroWnd, NULL );
    return( TRUE );
}

BOOL rx_5Clicked( void )
{
    ActivateGadget( MacroGadgets[ GD_rx_6 ], MacroWnd, NULL );
    return( TRUE );
}

BOOL rx_6Clicked( void )
{
    ActivateGadget( MacroGadgets[ GD_rx_7 ], MacroWnd, NULL );
    return( TRUE );
}

BOOL rx_7Clicked( void )
{
    ActivateGadget( MacroGadgets[ GD_rx_8 ], MacroWnd, NULL );
    return( TRUE );
}

BOOL rx_8Clicked( void )
{
    ActivateGadget( MacroGadgets[ GD_rx_9 ], MacroWnd, NULL );
    return( TRUE );
}

BOOL rx_9Clicked( void )
{
    ActivateGadget( MacroGadgets[ GD_rx_10 ], MacroWnd, NULL );
    return( TRUE );
}

BOOL rx_Get1Clicked( void )
{
    rx_GetFile( GD_rx_1 );
    return( TRUE );
}

BOOL rx_Get2Clicked( void )
{
    rx_GetFile( GD_rx_2 );
    return( TRUE );
}

BOOL rx_Get3Clicked( void )
{
    rx_GetFile( GD_rx_3 );
    return( TRUE );
}

BOOL rx_Get4Clicked( void )
{
    rx_GetFile( GD_rx_4 );
    return( TRUE );
}

BOOL rx_Get5Clicked( void )
{
    rx_GetFile( GD_rx_5 );
    return( TRUE );
}

BOOL rx_Get6Clicked( void )
{
    rx_GetFile( GD_rx_6 );
    return( TRUE );
}

BOOL rx_Get7Clicked( void )
{
    rx_GetFile( GD_rx_7 );
    return( TRUE );
}

BOOL rx_Get8Clicked( void )
{
    rx_GetFile( GD_rx_8 );
    return( TRUE );
}

BOOL rx_Get9Clicked( void )
{
    rx_GetFile( GD_rx_9 );
    return( TRUE );
}

BOOL rx_Get10Clicked( void )
{
    rx_GetFile( GD_rx_10 );
    return( TRUE );
}

void rx_GetFile( UWORD gad )
{
    if( GetFile3( FALSE, CatCompArray[ ASL_GET_MACRO ].cca_Str, "#?.ie",
		  ASL_GET_MACRO, "ie", ReqFile, ReqDrawer )) {

	StringTag[1] = allpath;
	GT_SetGadgetAttrsA( MacroGadgets[ gad ], MacroWnd, NULL, (struct TagItem *)StringTag );
    }
}
///
/// Esegui
BOOL ExecMacroMenued( void )
{
    if( GetFile3( FALSE, CatCompArray[ ASL_GET_MACRO ].cca_Str, "#?.ie", ASL_GET_MACRO, "ie", ReqFile, ReqDrawer ))
	SendRexxMsg( "REXX", "IE", allpath, NULL, 0 );

    return( TRUE );
}
///
/// Aggiungi
BOOL AddMacroMenued( void )
{
    if( GetFile3( FALSE, CatCompArray[ ASL_GET_MACRO ].cca_Str, "#?.ie", ASL_GET_MACRO, "ie", ReqFile, ReqDrawer ))
	AddMacroItem( allpath );

    return( TRUE );
}
///
/// Rimuovi
BOOL RemMacroMenued( void )
{
    WORD                num, cnt;
    struct MacroNode   *mac;

    if( ApriListaFin( CatCompArray[ ASL_GET_MACRO ].cca_Str, ASL_GET_MACRO, &MacroList )) {

	num = GestisciListaFin( EXIT, NumMacros );
	ChiudiListaFin();

	if( num >= 0 ) {

	    mac = MacroList.mlh_Head;
	    for( cnt = 0; cnt < num; cnt++ )
		mac = mac->Node.ln_Succ;

	    Remove(( struct Node * )mac );

	    StaccaMenus();
	    RemoveItem( GetMacroMenu(), mac->Menu );

	    mac->Menu->NextItem = NULL;
	    FreeMenus(( struct Menu * )mac->Menu );

	    FreeMem( mac, sizeof( struct MacroNode ));

	    NumMacros -= 1;

	    RemakeMacroMenu();
	}
    }

    return( TRUE );
}
///
/// ExecMenuMacro
BOOL ExecMenuMacro( void )
{
    struct MenuItem    *item;
    struct MacroNode   *mac;
    item = ItemAddress( BackMenus, BackMsg.Code );

    mac = MacroList.mlh_Head;

    while( strcmp( mac->Node.ln_Name, ((struct IntuiText *)item->ItemFill)->IText ))
	mac = mac->Node.ln_Succ;

    SendRexxMsg( "REXX", "IE", mac->File, NULL, 0 );
}
///
/// RemakeMacroMenu
void RemakeMacroMenu( void )
{
    struct Menu        *menu;

    menu = GetMacroMenu();

    LayoutMenuItems( menu->FirstItem, VisualInfo,
		     GTMN_Menu, menu,
		     GTMN_NewLookMenus, TRUE, TAG_END );

    AttaccaMenus();
}
///
/// GetMacroMenu
struct Menu *GetMacroMenu( void )
{
    struct Menu *menu = BackMenus;
    UWORD        cnt;

    for( cnt = 0; cnt < 5; cnt++ )
	menu = menu->NextMenu;

    return( menu );
}
///
/// FreeMacroItems
void FreeMacroItems( void )
{
    struct MacroNode *mac;

    StaccaMenus();

    while( mac = RemTail(( struct List * )&MacroList )) {
	RemoveItem( GetMacroMenu(), mac->Menu );

	mac->Menu->NextItem = NULL;
	FreeMenus(( struct Menu * )mac->Menu );

	FreeMem( mac, sizeof( struct MacroNode ));
    }

    AttaccaMenus();
}
///
/// AddMacroItem
void AddMacroItem( STRPTR File )
{
    struct MacroNode   *mac;

    if( mac = AllocMem( sizeof( struct MacroNode ), MEMF_CLEAR )) {

	AddTail(( struct List * )&MacroList, ( struct Node * )mac );

	strcpy( mac->File, File );
	mac->Node.ln_Name = FilePart( mac->File );

	struct NewMenu nm[] = { NM_ITEM, mac->Node.ln_Name,
				NULL, 0, 0, (APTR)ExecMenuMacro,
				NM_END, NULL, NULL, 0, 0, NULL };

	if( mac->Menu = CreateMenusA( nm, NULL )) {
	    StaccaMenus();
	    AddItem( GetMacroMenu(), mac->Menu );
	    RemakeMacroMenu();
	    NumMacros += 1;
	} else
	    DisplayBeep( Scr );

    } else {
	Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, 0 );
    }
}
///
/// SistemaMacroMenu
void SistemaMacroMenu( void )
{
    struct MacroNode   *mac;
    struct Menu        *menu;

    menu = GetMacroMenu();

    StaccaMenus();

    for( mac = MacroList.mlh_Head; mac->Node.ln_Succ; mac = mac->Node.ln_Succ )
	AddItem( menu, mac->Menu );

    RemakeMacroMenu();
}
///

//      Preferenze
/// Generatore
BOOL GenPrefsMenued( void )
{
    struct GeneratorNode   *gen;
    BOOL                    ret;

    if( GenWnd ) {
	ActivateWindow( GenWnd );
	WindowToFront( GenWnd );
	return( TRUE );
    }

    if( GetGenerators() ) {

	if( GenBase ) {

	    gen = Generators.mlh_Head;
	    Generator = 0;
	    while( gen->GenBase != GenBase ) {
		gen = gen->Node.ln_Succ;
		Generator += 1;
	    }

	    CloseLibrary(( struct Library * )GenBase );
	}

	LayoutWindow( GenWTags );
	ret = OpenGenWindow();
	PostOpenWindow( GenWTags );

	ListTag[1]  = &Generators;
	List2Tag[1] = List2Tag[3] = Generator;

	GT_SetGadgetAttrsA( GenGadgets[ GD_GenList ], GenWnd,
			    NULL, (struct TagItem *)ListTag );
	GT_SetGadgetAttrsA( GenGadgets[ GD_GenList ], GenWnd,
			    NULL, (struct TagItem *)List2Tag );

	GenWnd->ExtData = HandleGen;
    }

    return( TRUE );
}

void HandleGen( void )
{
    if(!( HandleGenIDCMP() ))
	CloseGenReq();
}

void CloseGenReq( void )
{
    if( GenWnd ) {

       GenBase->Lib.lib_OpenCnt += 1;  // prevent from closing

	CloseGenWindow();
	FreeGenerators();
    }
}

BOOL GenCloseWindow( void )
{
    return( FALSE );
}

BOOL GenConfigKeyPressed( void )
{
    return( GenConfigClicked() );
}

BOOL GenConfigClicked( void )
{
    APTR    Lock;

    LockAllWindows();
    Lock = rtLockWindow( GenWnd );

    Config( &IE );

    rtUnlockWindow( GenWnd, Lock );
    UnlockAllWindows();

    return( TRUE );
}

BOOL GenListClicked( void )
{
    ULONG                   i;
    struct GeneratorNode   *gen;

    Generator = IDCMPMsg.Code;

    gen = (struct GeneratorNode *)&Generators;
    for( i = 0; i <= Generator; i++ )
	gen = gen->Node.ln_Succ;

    GenBase = gen->GenBase;

    return( TRUE );
}
///


//      Varie
/// GetFile3
BOOL GetFile3( BOOL savemode, STRPTR titolo, STRPTR pattern, ULONG titn, STRPTR ext,
	       STRPTR File, STRPTR Drawer )
{
    UBYTE   *ptr, ch;
    BOOL     ok = TRUE;
    struct   FileRequester *req;

    if(( ext ) && ( ReqFile[0] )) {
	ptr = ReqFile;

	do {
	    ch = *ptr++;
	    if(( ch == '.' ) || ( ch == '\0' ))
		ok = FALSE;
	} while( ok );

	if( ch == '\0' ) {
	    ptr -= 1;
	    *ptr++ = '.';
	}

	strcpy( ptr, ext );
    }

    if( LocaleBase )
	titolo = GetCatalogStr( Catalog, titn, titolo );

    if( req = AllocAslRequest( ASL_FileRequest, NULL )) {

	if ( ok = AslRequestTags( req, ASLFR_DoPatterns,     TRUE,
				  ASLFR_InitialHeight,  Scr->Height - 40,
				  ASLFR_TitleText,      titolo,
				  ASLFR_InitialFile,    File,
				  ASLFR_InitialDrawer,  Drawer,
				  ASLFR_InitialPattern, pattern,
				  ASLFR_Window,         BackWnd,
				  ASLFR_DoSaveMode,     (ULONG)savemode,
				  TAG_DONE )) {

	    strcpy( File, req->fr_File );
	    strcpy( Drawer, req->fr_Drawer );
	    strcpy( allpath, req->fr_Drawer );
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
/// RemoveItem
void RemoveItem( struct Menu *From, struct MenuItem *Item )
{
    struct MenuItem *mi, *pred;

    mi = From->FirstItem;
    while( mi != Item ) {
	pred = mi;
	mi = mi->NextItem;
    }

    pred->NextItem = mi->NextItem;
}
///
/// AddItem
void AddItem( struct Menu *To, struct MenuItem *Item )
{
    struct MenuItem *mi;

    mi = To->FirstItem;

    while( mi->NextItem )
	mi = mi->NextItem;

    mi->NextItem    = Item;
    Item->NextItem  = NULL;
}
///
/// StaccaMenus
void StaccaMenus( void )
{
    struct WindowInfo  *wnd;

    ClearMenuStrip( BackWnd );

    if( ToolsWnd )
	ClearMenuStrip( ToolsWnd );

    for( wnd = IE.win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ )
	if( wnd->wi_flags1 & W_APERTA )
	    ClearMenuStrip( wnd->wi_winptr );
}
///
/// AttaccaMenus
void AttaccaMenus( void )
{
    struct WindowInfo  *wnd;

    SetMenuStrip( BackWnd, BackMenus );

    if( ToolsWnd )
	SetMenuStrip( ToolsWnd, BackMenus );

    for( wnd = IE.win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ )
	if( wnd->wi_flags1 & W_APERTA )
	    SetMenuStrip( wnd->wi_winptr, BackMenus );
}
///
