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
#include <exec/ports.h>
#include <exec/libraries.h>
#include <intuition/intuition.h>        // intuition
#include <intuition/screens.h>
#include <intuition/sghooks.h>
#include <intuition/gadgetclass.h>
#include <dos/dos.h>                    // dos
#include <dos/rdargs.h>
#include <workbench/startup.h>          // workbench
#include <rexx/rexxio.h>                // rexx
#include <rexx/errors.h>
#include <rexx/storage.h>
#include <libraries/gadtools.h>         // libraries
#include <libraries/asl.h>
#include <libraries/reqtools.h>
#include <libraries/locale.h>
#include <clib/exec_protos.h>           // protos
#include <clib/intuition_protos.h>
#include <clib/graphics_protos.h>
#include <clib/dos_protos.h>
#include <clib/diskfont_protos.h>
#include <clib/rexxsyslib_protos.h>
#include <clib/locale_protos.h>
#include <clib/asl_protos.h>
#include <clib/reqtools_protos.h>
#include <clib/gadtools_protos.h>
#include <pragmas/exec_pragmas.h>       // pragmas
#include <pragmas/intuition_pragmas.h>
#include <pragmas/graphics_pragmas.h>
#include <pragmas/dos_pragmas.h>
#include <pragmas/locale_pragmas.h>
#include <pragmas/asl_pragmas.h>
#include <pragmas/reqtools_pragmas.h>
#include <pragmas/gadtools_pragmas.h>
#include <pragmas/rexxsyslib_pragmas.h>
#include <pragmas/diskfont_pragmas.h>


#include "DEV_IE:defs.h"
#include "DEV_IE:GUI.h"
#include "DEV_IE:GUI_locale.h"
#include "DEV_IE:Include/generatorlib-protos.h"
#include "DEV_IE:Include/generatorlib.h"
#include "DEV_IE:Include/generator_pragmas.h"
#include "DEV_IE:Include/expanders.h"
#include "DEV_IE:Include/expander_pragmas.h"
///
/// Prototipi
static BOOL     OpenLibs( void );
static void     CloseLibs( void );
static void     CleanUp( ULONG );
static void     ParseArguments( void );
static void     SetupNames( void );
void            wbmain( void * );
void            main( void );
static BOOL     OpenScr( void );
static void     CloseScr( void );
static void     CaricaPrefs( void );
static BOOL     processmenu( int );
static void     ProcessKey( int, int );
static void     ProcessRawKey( int, int );
static BOOL     CheckMacroKeys( int, int );
static BOOL     ListaSelect( void );
static void     ToolsCloseWindow( void );
static BOOL     GetLoaders( void );
static void     FreeLoaders( void );
static void     NewHandleRexxMsg( void );
static void     HandleSrcParams( void );

extern struct WBStartup *_WBMsg;

#define MAX_PATH        1024
#define PREFS_MENU         6
///

/// Basi delle librerie
struct Library          *GfxBase;
struct IntuitionBase    *IntuitionBase;
struct Library          *GadToolsBase;
struct Library          *AslBase;
struct Library          *ReqToolsBase;
struct Library          *DiskfontBase;
struct Library          *IFFParseBase;
struct Library          *IconBase;
struct Library          *RexxSysBase;
struct Library          *LocaleBase;
struct Generator        *GenBase;
struct Expander         *IEXBase;
///
/// Buffers
UBYTE                   allpath[ MAX_PATH ];
UBYTE                   allpath2[ MAX_PATH ];
UBYTE                   save_file[ MAX_PATH ];
UBYTE                   initial_drawer[ 300 ];
UBYTE                   initial_file[ 300 ];

UBYTE                   DefaultTool[256];

TEXT                    MyPubName[12];
TEXT                    MyRexxPort[12];
TEXT                    SharedPort[60];

BPTR                    File, KeyFileSeg;

long                    buffer, buffer2, buffer3;

int                     RetCode;

ULONG                  *list_from_eor, *list_to_eor;

UWORD                   toolsx, toolsy = 12, clickx, clicky;
WORD                    offx, offy, mousex, mousey, oldx, oldy;

UBYTE                   Macros[30][256];

UBYTE                   coord_txt[18];

UWORD                   ticks;

struct Process          *MyTask;
struct MsgPort          *IDCMP_Port;
///
/// Dati
struct TextAttr Topaz8Font = { "topaz.font", 8, 0, 1 };

struct IntuiText CoordIText = { 1, 2, JAM2, -155, 0, &Topaz8Font, coord_txt, 0 };

APTR                    old_WindowPtr;
static BPTR             old_Dir;

ULONG                   rexx_mask, signalset, editing_mask, back_mask;
BOOL                    Ok_to_Run = TRUE;

UWORD                   Generator;

static struct IEXFun    IEX_Functions = {
	SplitLines,
	GetFirstLine,
	WriteFormatted,
	AddGadgetKind,
	AddARexxCmd
};

static struct MiscFun   IE_Functions = {
	AggiungiFont,
	Stat,
	EliminaFont,
	AllocObject,
	FreeObject,
	GetGad,
	FindString,
	FindArray,
};

static struct UserData  UserData = { "Freeware Version", 0 };

struct IE_Data  IE = {
	    SALVATO,                    // flags
	    REXX,                       // flags_2
	    0,                          // mainprefs
	    0,                          // SrcFlags
	    0,                          // MainProcFlags
	    0, 0,                       // AsmPrefs, AsmPrefs2
	    0,                          // C_Prefs
	    NULL,                       // gad_id
	    NULL,                       // win_active
	    NULL,                       // win_info
	    NULL,                       // colortable
	    0, 0,                       // win_open, num_win
	    { &IE.win_list.mlh_Tail, NULL, &IE.win_list },
	    { &IE.FntLst.mlh_Tail, NULL, &IE.FntLst },
	    0,
	    { &IE.Img_List.mlh_Tail, NULL, &IE.Img_List },
	    MyPubName,
	    MyRexxPort,
	    0,
	    { &IE.Libs_List.mlh_Tail, NULL, &IE.Libs_List },
	    0,
	    { &IE.WndTO_List.mlh_Tail, NULL, &IE.WndTO_List },
	    0,
	    { &IE.Rexx_List.mlh_Tail, NULL, &IE.Rexx_List },
	    &ScrData,
	    &IE_Functions,
	    RexxExt,
	    ARexxPortName,
	    ExtraProc,
	    NULL,
	    CP_ChipString2,
	    AP_IntString2,
	    AP_DosString2,
	    AP_GfxString2,
	    AP_GadString2,
	    AP_FntString2,
	    AP_RexxString2,
	    &LocInfo,
	    &IEX_Functions,
	    &UserData,
	    { &IE.Expanders.mlh_Tail, NULL, &IE.Expanders.mlh_Head },
	    &IEXSrcFunctions,
	    SharedPort
    };

struct MinList Loaders = { &Loaders.mlh_Tail, NULL, &Loaders.mlh_Head };
struct MinList Generators = { &Generators.mlh_Tail, NULL, &Generators.mlh_Head };
///
/// Stringhe
static UBYTE    TEMPLATE[]    = "FILE";
static UBYTE    PubName_fmt[] = "IEDITOR.%d";

UBYTE           KeyFile[]   = "PROGDIR:IEditor.key";
UBYTE           PrefsFile[] = "S:IEditor.prefs";

UBYTE           ok_txt[] = "_Ok";

UBYTE   CoordFmt_txt[]  = "X: %4d  Y: %4d";

ULONG   DataHeader[]    = { 'IEDf', 3 };
ULONG   ScrHeader       = 'SCRN';
ULONG   InterfHeader    = 'INTF';
ULONG   FinestraHeader  = 'WNDW';
ULONG   GadgetHeader    = 'GADG';
ULONG   MenuHeader      = 'MENU';

UBYTE   smartrefresh_txt[] = "  Smart Refresh";
///
/// Dati requester
ULONG ReqTags[] = {
    RTEZ_ReqTitle, 0, RT_ReqPos, REQPOS_CENTERSCR,
    RT_Underscore, (ULONG)'_', TAG_DONE
};
///
/// idcmps & flags
ULONG idcmps[] = {
	    1, 2, 4, 8, 0x10, 0x20, 0x40, 0x80, 0x100, 0x200,
	    0x400, 0x800, 0x1000, 0x2000, 0x4000, 0x8000,
	    0x10000, 0x20000, 0x40000, 0x80000, 0x100000,
	    0x200000, 0x400000, 0x800000, 0x1000000,
	    0x2000000, 0x4000000
      };

ULONG wflgs[] = {
	    1, 2, 4, 8, 0x10, 0x20, 0, 0x40, 0x80, 0x100, 0x200,
	    0x400, 0x800, 0x1000, 0x10000, 0x20000, 0x40000,
	    0x200000
      };
///
/// Dati per i menu (e gadget) da attivare
ULONG attivamenu_nuovawin[] = {
	(4<<5), (5<<5), (-1<<11)|(8<<5), (2<<5)|1,
	(3<<5)|1, (4<<5)|1, (14<<5)|1, (22<<5)|1, (13<<5)|1,
	(6<<5)|1, (7<<5)|1, (9<<5)|1, (10<<5)|1, (11<<5)|1,
	(12<<5)|1, 4, (21<<5)|1, (-1<<11)|(-1<<5)|2,
	(-1<<11)|(16<<5)|1, (-1<<11)|(17<<5)|1,
	(-1<<11)|(18<<5)|1, (-1<<11)|(19<<5)|1
      };

ULONG disattiva_noopen[] = {
	(3<<5)|1, (4<<5)|1, (14<<5)|1, (22<<5)|1, (13<<5)|1,
	(6<<5)|1, (7<<5)|1, (9<<5)|1, (10<<5)|1, (11<<5)|1,
	(12<<5)|1, 4, (21<<5)|1, (-1<<11)|(-1<<5)|2,
	(-1<<11)|(16<<5)|1, (-1<<11)|(17<<5)|1,
	(-1<<11)|(18<<5)|1, (-1<<11)|(19<<5)|1
      };

static struct Gadget *Tools_gads[] = {
	&DelWndGadget,
	&AddGadGadget,
	&IDCMPGadget,
	&WFlagsGadget,
	&OpenImgBankGadget
      };
///
/// Liste
extern struct MinList listgadgets;

struct Node KindNodes[]= {
	&KindNodes[1], (struct Node *)&listgadgets.mlh_Head, 0, 0, "BUTTON KIND",
	&KindNodes[2], &KindNodes[0], 0, 0, "CHECKBOX KIND",
	&KindNodes[3], &KindNodes[1], 0, 0, "INTEGER KIND",
	&KindNodes[4], &KindNodes[2], 0, 0, "LISTVIEW KIND",
	&KindNodes[5], &KindNodes[3], 0, 0, "MX KIND",
	&KindNodes[6], &KindNodes[4], 0, 0, "NUMBER KIND",
	&KindNodes[7], &KindNodes[5], 0, 0, "CYCLE KIND",
	&KindNodes[8], &KindNodes[6], 0, 0, "PALETTE KIND",
	&KindNodes[9], &KindNodes[7], 0, 0, "SCROLLER KIND",
	&KindNodes[10], &KindNodes[8], 0, 0, "SLIDER KIND",
	&KindNodes[11], &KindNodes[9], 0, 0, "STRING KIND",
	&KindNodes[12], &KindNodes[10], 0, 0, "TEXT KIND",
	(struct Node *)&listgadgets.mlh_Tail, &KindNodes[11], 0, 0, "BOOLEAN" };

struct MinList listgadgets = {
	(struct MinNode *)&KindNodes[0], (struct MinNode *)NULL, (struct MinNode *)&KindNodes[12] };

extern struct MinList listidcmp;

struct Node IDCMPNodes[]= {
	&IDCMPNodes[1], (struct Node *)&listidcmp.mlh_Head, 0, 0, "  SIZE VERIFY",
	&IDCMPNodes[2], &IDCMPNodes[0], 0, 0, "  NEW SIZE",
	&IDCMPNodes[3], &IDCMPNodes[1], 0, 0, "  REFRESH WINDOW",
	&IDCMPNodes[4], &IDCMPNodes[2], 0, 0, "  MOUSE BUTTONS",
	&IDCMPNodes[5], &IDCMPNodes[3], 0, 0, "  MOUSE MOVE",
	&IDCMPNodes[6], &IDCMPNodes[4], 0, 0, "  GADGET DOWN",
	&IDCMPNodes[7], &IDCMPNodes[5], 0, 0, "  GADGET UP",
	&IDCMPNodes[8], &IDCMPNodes[6], 0, 0, "  REQ SET",
	&IDCMPNodes[9], &IDCMPNodes[7], 0, 0, "  MENU PICK",
	&IDCMPNodes[10], &IDCMPNodes[8], 0, 0, "  CLOSE WINDOW",
	&IDCMPNodes[11], &IDCMPNodes[9], 0, 0, "  RAW KEY",
	&IDCMPNodes[12], &IDCMPNodes[10], 0, 0, "  REQ VERIFY",
	&IDCMPNodes[13], &IDCMPNodes[11], 0, 0, "  REQ CLEAR",
	&IDCMPNodes[14], &IDCMPNodes[12], 0, 0, "  MENU VERIFY",
	&IDCMPNodes[15], &IDCMPNodes[13], 0, 0, "  NEW PREFS",
	&IDCMPNodes[16], &IDCMPNodes[14], 0, 0, "  DISK INSERTED",
	&IDCMPNodes[17], &IDCMPNodes[15], 0, 0, "  DISK REMOVED",
	&IDCMPNodes[18], &IDCMPNodes[16], 0, 0, "  WBENCH MESSAGE",
	&IDCMPNodes[19], &IDCMPNodes[17], 0, 0, "  ACTIVE WINDOW",
	&IDCMPNodes[20], &IDCMPNodes[18], 0, 0, "  INACTIVE WINDOW",
	&IDCMPNodes[21], &IDCMPNodes[19], 0, 0, "  DELTA MOVE",
	&IDCMPNodes[22], &IDCMPNodes[20], 0, 0, "  VANILLA KEY",
	&IDCMPNodes[23], &IDCMPNodes[21], 0, 0, "  INTUI TICKS",
	&IDCMPNodes[24], &IDCMPNodes[22], 0, 0, "  IDCMP UPDATE",
	&IDCMPNodes[25], &IDCMPNodes[23], 0, 0, "  MENU HELP",
	&IDCMPNodes[26], &IDCMPNodes[24], 0, 0, "  CHANGE WINDOW",
	(struct Node *)&listidcmp.mlh_Tail, &IDCMPNodes[25], 0, 0, "  GADGET HELP" };

struct MinList listidcmp = {
	(struct MinNode *)&IDCMPNodes[0], (struct MinNode *)NULL, (struct MinNode *)&IDCMPNodes[26] };

extern struct MinList listflags;

struct Node FlagsNodes[]= {
	&FlagsNodes[1], (struct Node *)&listflags.mlh_Head, 0, 0, "  Size Gadget",
	&FlagsNodes[2], &FlagsNodes[0], 0, 0, "  Drag Bar",
	&FlagsNodes[3], &FlagsNodes[1], 0, 0, "  Depth Gadget",
	&FlagsNodes[4], &FlagsNodes[2], 0, 0, "  Close Gadget",
	&FlagsNodes[5], &FlagsNodes[3], 0, 0, "  Size BRight",
	&FlagsNodes[6], &FlagsNodes[4], 0, 0, "  Size BBottom",
	&FlagsNodes[7], &FlagsNodes[5], 0, 0, smartrefresh_txt,
	&FlagsNodes[8], &FlagsNodes[6], 0, 0, "  Simple Refresh",
	&FlagsNodes[9], &FlagsNodes[7], 0, 0, "  Super Bitmap",
	&FlagsNodes[10], &FlagsNodes[8], 0, 0, "  Backdrop",
	&FlagsNodes[11], &FlagsNodes[9], 0, 0, "  Report Mouse",
	&FlagsNodes[12], &FlagsNodes[10], 0, 0, "  Gimme Zero Zero",
	&FlagsNodes[13], &FlagsNodes[11], 0, 0, "  Borderless",
	&FlagsNodes[14], &FlagsNodes[12], 0, 0, "  Activate",
	&FlagsNodes[15], &FlagsNodes[13], 0, 0, "  RMB Trap",
	&FlagsNodes[16], &FlagsNodes[14], 0, 0, "  No Care Refresh",
	&FlagsNodes[17], &FlagsNodes[15], 0, 0, "  Nw Extended",
	(struct Node *)&listflags.mlh_Tail, &FlagsNodes[16], 0, 0, "  New Look Menus" };

struct MinList listflags = {
	(struct MinNode *)&FlagsNodes[0], (struct MinNode *)NULL, (struct MinNode *)&FlagsNodes[17] };
///
/// Tags
ULONG   CheckedTag[]  = { GTCB_Checked, 0, TAG_END };
ULONG   PaletteTag[]  = { GTPA_Color, 0, TAG_END };
ULONG   PaletteTag2[] = { GTPA_Color, 0, TAG_END };
ULONG   CycleTag[]    = { GTCY_Active, 0, TAG_END };
ULONG   CycleTag2[]   = { GTCY_Active, 0, TAG_END };
ULONG   CycleTag3[]   = { GTCY_Active, 0, TAG_END };
ULONG   StringTag[]   = { GTST_String, 0, TAG_END };
ULONG   TextTag[]     = { GTTX_Text, 0, TAG_END };
ULONG   IntegerTag[]  = { GTIN_Number, 0, TAG_END };
ULONG   MXTag[]       = { GTMX_Active, 0, TAG_END };
ULONG   DisableTag[]  = { GA_Disabled, 0, TAG_END };
ULONG   ListTag[]     = { GTLV_Labels, 0, TAG_END };
ULONG   List2Tag[]    = { GTLV_Top, 0, GTLV_Selected, 0, TAG_END };
ULONG   List2Tag2[]   = { GTLV_Top, 0, GTLV_Selected, 0, TAG_END };
ULONG   List2Tag3[]   = { GTLV_Top, 0, GTLV_Selected, 0, TAG_END };
static ULONG   ListWndTag[]  = { GTLV_Top, 0, GTLV_Selected, 0, TAG_END };
///



/// Main
void wbmain( void *WBMsg )
{
    main();
}

void main( void )
{
    ULONG                   signals, class;
    struct IntuiMessage    *msg;
    int                     code, qualifier;
    struct Gadget          *addr;
    BOOL                    (*func)( void );

    if(!( OpenLibs() ))
	CleanUp( 20 );

    if(!( IDCMP_Port = CreateMsgPort() ))
	CleanUp( 20 );

    editing_mask = ( 1 << IDCMP_Port->mp_SigBit );


    ReqTags[1] = (ULONG)CatCompArray[ MSG_STRING_0 ].cca_Str;


    SetupNames();

    ParseArguments();

    if (!( OpenScr() ))
	CleanUp( 20 );

    if (!( opentoolswnd() ))
	CleanUp( 20 );

    CaricaPrefs();

    MyTask = FindTask( NULL );
    old_WindowPtr = MyTask->pr_WindowPtr;
    MyTask->pr_WindowPtr = BackWnd;
    IE.flags_2 |= WNDPTR;

    if( ((struct Library *)SysBase)->lib_Version >= 39 ) {
	List2Tag3[0] = List2Tag2[0] = List2Tag[0] = GTLV_MakeVisible;
	ListWndTag[0] = GTLV_MakeVisible;
    }

    SetupRexxPort();

    if( RexxPort )
	rexx_mask = 1 << RexxPort->mp_SigBit;

    signalset |= editing_mask | rexx_mask | SIGBREAKF_CTRL_C;


    if(!( GetLoaders() )) {
	IERequest( "Loaders non trovati.", "#@$%$@£#!!",
		   MSG_LOADERS_NOTFOUND, 0 );
    }

    GetExpanders();

    if( IE.flags & LOADGUI )
	CaricaMenued();

    IE.flags &= ~WNDCHIUSA;


    /*****************************************
    **          M A I N    L O O P          **
    *****************************************/


    do {

	signals = Wait( signalset );

	if( signals & SIGBREAKF_CTRL_C )
	    Ok_to_Run = FALSE;

	if( signals & rexx_mask )
	    NewHandleRexxMsg();

	if( signals & editing_mask )
	    HandleIDCMPPort();

	if( signals & back_mask ) {
	    while( msg = GT_GetIMsg( BackWnd->UserPort )) {

		code      = msg->Code;
		class     = msg->Class;
		qualifier = msg->Qualifier;

		GT_ReplyIMsg( msg );

		switch( class ) {
		    case IDCMP_RAWKEY:
			CheckMacroKeys( code, qualifier );
			break;
		    case IDCMP_MENUPICK:
			Ok_to_Run = processmenu( code );
			if( IE.flags & ESCI )
			    CleanUp( 0 );
			break;
		}
	    }
	}

	if (( ToolsWnd ) && ( Ok_to_Run )) {

	    while( msg = GT_GetIMsg( ToolsWnd->UserPort )) {

		code      = msg->Code;
		class     = msg->Class;
		addr      = msg->IAddress;
		qualifier = msg->Qualifier;

		GT_ReplyIMsg( msg );

		switch( class ) {

		    case IDCMP_REFRESHWINDOW:
			GT_BeginRefresh( ToolsWnd );
			GT_EndRefresh( ToolsWnd, TRUE );
			break;

		    case IDCMP_MENUPICK:
			Ok_to_Run = processmenu( code );
			if(!( IE.flags & TOOLSWND ))
			    goto chiusatools;
			break;

		    case IDCMP_CLOSEWINDOW:
			ToolsCloseWindow();
			goto chiusatools;
			break;

		    case IDCMP_RAWKEY:
			CheckMacroKeys( code, qualifier );
			break;

		    case IDCMP_GADGETUP:
			func = addr->UserData;
			Ok_to_Run = (*func)();
			if( IE.win_active )
			    ActivateWindow( IE.win_active );
			if( IE.flags & ESCI )
			    CleanUp( 0 );
			break;
		}
	    }
chiusatools:
	}

	if( IE.flags & WNDCHIUSA )
	    IE.flags &= ~WNDCHIUSA;

	if(!( Ok_to_Run )) {
	    if(!( IE.flags & SALVATO )) {

		 code = IERequest( "L'interfaccia attuale non è stata\n"
				   "salvata.  Uscendo   adesso  verrà\n"
				   "persa!",
				   "_Salva|_Esci|_Annulla",
				   MSG_GUI_NOT_SAVED,
				   ANS_SAVE_QUIT_CANCEL );

		switch( code ) {
		    case 0:
			Ok_to_Run = TRUE;
			break;
		    case 1:
			SalvaMenued();
			break;
		}
	    }
	}
    } while( Ok_to_Run );

    CleanUp( 0 );
}
///


/// Process Menu
BOOL processmenu( int code )
{
    struct MenuItem *item;
    BOOL            (*func)( void );
    BOOL            ret;

    while(( code != MENUNULL ) && (!( IE.flags & WNDCHIUSA ))) {
	item = ItemAddress( BackMenus, code );
	func = GTMENUITEM_USERDATA( item );
	BackMsg.Code = code;
	code = item->NextSelect;
	if (!( ret = (*func)() ))
	    code = MENUNULL;
    }

    return( ret );
}
///
/// Process Key
void ProcessKey( int key, int qual )
{
    struct GadgetInfo *gad;
    struct WindowInfo *wnd;

    switch( key ) {

	case 127:                   // DEL
	    DelGadMenued();
	    break;

	case 9:                     // TAB
	    if( qual & ( 0x10 | 0x20 )) {  // ALT TAB
		if( IE.win_open ) {

		    wnd = IE.win_info;
		    do{
			wnd = wnd->wi_succ;
			if(!( wnd->wi_succ ))
			    wnd = IE.win_list.mlh_Head;
		    } while(!( wnd->wi_flags1 & W_APERTA ));

		    DisattivaTuttiGad();
		    ActivateWindow( wnd->wi_winptr );
		    WindowToFront( wnd->wi_winptr );

		    IE.win_active = wnd->wi_winptr;
		    IE.win_info   = wnd;
		}
	    } else {
		if( IE.win_info->wi_NumGads ) {
		    if( IE.gad_id ) {
			DisattivaTuttiGad();
			gad = IE.gad_id->g_Node.ln_Succ;
			if (!( gad->g_Node.ln_Succ ))
			    gad = IE.win_info->wi_Gadgets.mlh_Head;
		    } else {
			gad = IE.win_info->wi_Gadgets.mlh_Head;
		    }

		    ContornoGadgets( FALSE );

		    gad->g_flags2 |= G_ATTIVO;
		    IE.gad_id = gad;

		    ContornoGadgets( TRUE );
		}
	    }
	    break;

	case 13:
	    GadTagsMenued();
	    IE.flags &= ~MOVE;
	    break;
    }
}
///
/// Process RawKey
void ProcessRawKey( int key, int qual )
{
    struct GadgetInfo *gad;
    struct WindowInfo *wnd;

    if( CheckMacroKeys( key, qual ))
	return;

    if( key == 0x42 ) {                     // TAB
	if( qual & (0x10 | 0x20) ) {
	    if( qual & 3 ) {          // SHIFT ALT TAB
		if( IE.win_open ) {

		    wnd = IE.win_info;
		    do{
			wnd = wnd->wi_pred;
			if(!( wnd->wi_pred ))
			    wnd = IE.win_list.mlh_TailPred;
		    } while(!( wnd->wi_flags1 & W_APERTA ));

		    DisattivaTuttiGad();
		    ActivateWindow( wnd->wi_winptr );
		    WindowToFront( wnd->wi_winptr );

		    IE.win_active = wnd->wi_winptr;
		    IE.win_info   = wnd;
		}
	    }
	} else {
	    if( qual & 3 ) {        /// SHIFT TAB
		if( IE.win_info->wi_NumGads ) {
		    if( IE.gad_id ) {
			DisattivaTuttiGad();
			gad = IE.gad_id->g_Node.ln_Pred;
			if (!( gad->g_Node.ln_Pred ))
			    gad = IE.win_info->wi_Gadgets.mlh_TailPred;
		    } else {
			gad = IE.win_info->wi_Gadgets.mlh_TailPred;
		    }
		    ContornoGadgets( FALSE );

		    gad->g_flags2 |= G_ATTIVO;
		    IE.gad_id = gad;

		    ContornoGadgets( TRUE );
		}
	    }
	}
    }
}
///
/// HandleEdit
void HandleEdit( void )
{
    struct GadgetInfo  *old_id;

    IE.win_active = IDCMPMsg.IDCMPWindow;
    IE.win_info   = IE.win_active->UserData;

    switch( IDCMPMsg.Class ) {

	case IDCMP_REFRESHWINDOW:
	    GT_BeginRefresh( IE.win_active );
	    GT_EndRefresh( IE.win_active, TRUE );
	    RinfrescaFinestra();
	    break;

	case IDCMP_MENUPICK:
	    Ok_to_Run = processmenu( IDCMPMsg.Code );
	    break;

	case IDCMP_VANILLAKEY:
	    ProcessKey( IDCMPMsg.Code, IDCMPMsg.Qualifier );
	    break;

	case IDCMP_ACTIVEWINDOW:
	    IE.gad_id = NULL;
	    CheckMenuToActive();
	    if( IE.mainprefs & PRIMOPIANO )
		WindowToFront( IE.win_active );
	    break;

	case IDCMP_MOUSEMOVE:
	    Coord();
	    if( IE.flags & MOVE )
		if(!( ResizeGadgets() ))
		    if( ticks > 1 )
			PosizioneGadgets( mousex - oldx, mousey - oldy );
	    break;

	case IDCMP_CHANGEWINDOW:
	    IE.win_info->wi_Width       = IE.win_active->Width;
	    IE.win_info->wi_Height      = IE.win_active->Height;
	    IE.win_info->wi_Left        = IE.win_active->LeftEdge;
	    IE.win_info->wi_Top         = IE.win_active->TopEdge;
	    IE.win_info->wi_InnerWidth  = IE.win_active->Width - IE.win_active->BorderLeft - IE.win_active->BorderRight;
	    IE.win_info->wi_InnerHeight = IE.win_active->Height - YOffset - IE.win_active->BorderBottom;
	    IE.flags &= ~SALVATO;
	    break;

	case IDCMP_CLOSEWINDOW:
	    ChiudiWndMenued();
	    break;

	case IDCMP_MOUSEBUTTONS:
	    switch( IDCMPMsg.Code ) {
		case 0xE8:
		    IE.flags &= ~MOVE;
		    break;
		case 0x68:
		    clickx = oldx = mousex;
		    clicky = oldy = mousey;
		    if(!( IDCMPMsg.Qualifier & 3 ))
			DisattivaTuttiGad();
		    old_id = IE.gad_id;
		    AttivaGadgets();
		    if( TestAttivi() ) {
			if( old_id == IE.gad_id ) {
			    static ULONG    OldSecs, OldMicros;

			    if( DoubleClick( OldSecs, OldMicros, IDCMPMsg.Seconds, IDCMPMsg.Micros )) {
				GadTagsMenued();
				IE.flags &= ~MOVE;
			    }

			    OldSecs   = IDCMPMsg.Seconds;
			    OldMicros = IDCMPMsg.Micros;
			}
			ticks = 0;
		    }
		    break;
	    }
	    break;

	case IDCMP_INTUITICKS:
	    ticks += 1;
	    break;

	case IDCMP_RAWKEY:
	    ProcessRawKey( IDCMPMsg.Code, IDCMPMsg.Qualifier );
	    break;
    }

    if( IE.flags & ESCI )
	CleanUp( 0 );
}
///


/// CheckMacroKeys
BOOL BackRawKey( void )
{
    CheckMacroKeys( BackMsg.Code, BackMsg.Qualifier );
}

BOOL CheckMacroKeys( int code, int qual )
{
    BOOL    ret = FALSE;

    code -= 80;

    if(( code >= 0 ) && ( code <= 9 )) {

	ret = TRUE;

	if( qual & 3 )          // shift
	    code += 10;
	else
	    if( qual & ( 0x10 | 0x20 ))     // alt
		code += 20;

	if( Macros[code][0] ) {
	    if (!( SendRexxMsg( "REXX", "IE", &Macros[code][0], NULL, 0 ))) {
		Stat( CatCompArray[ ERR_NOREXX ].cca_Str, TRUE, 0 );
	    }
	}
    }

    return( ret );
}
///

/// Fine
BOOL FineMenued( void )
{
    return( FALSE );
}
///

/// CheckMenuToActive
void CheckMenuToActive( void )
{
    if( IE.win_info->wi_NumGads + IE.win_info->wi_NumBools + IE.win_info->wi_NumObjects + IE.win_info->wi_NumGBanks )
	MenuGadgetAttiva();
    else
	MenuGadgetDisattiva();

    if( IE.win_info->wi_NumBoxes )
	OnMenu( BackWnd, (1<<11)|(16<<5)|1 );
    else
	OffMenu( BackWnd, (1<<11)|(16<<5)|1 );

    if( IE.win_info->wi_NumImages ) {
	OnMenu( BackWnd, (1<<11)|(17<<5)|1 );
	OnMenu( BackWnd, (2<<11)|(17<<5)|1 );
    } else {
	OffMenu( BackWnd, (1<<11)|(17<<5)|1 );
	OffMenu( BackWnd, (2<<11)|(17<<5)|1 );
    }

    if( IE.win_info->wi_NumTexts ) {
	OnMenu( BackWnd, (1<<11)|(18<<5)|1 );
	OnMenu( BackWnd, (2<<11)|(18<<5)|1 );
	OnMenu( BackWnd, (3<<11)|(18<<5)|1 );
    } else {
	OffMenu( BackWnd, (1<<11)|(18<<5)|1 );
	OffMenu( BackWnd, (2<<11)|(18<<5)|1 );
	OffMenu( BackWnd, (3<<11)|(18<<5)|1 );
    }
}
///

//      Routines di Chiusura
/// Chiusura librerie
void CloseLibs( void )
{
    if (GfxBase)        CloseLibrary(GfxBase);
    if (IntuitionBase)  CloseLibrary(IntuitionBase);
    if (AslBase)        CloseLibrary(AslBase);
    if (GadToolsBase)   CloseLibrary(GadToolsBase);
    if (ReqToolsBase)   CloseLibrary(ReqToolsBase);
    if (DiskfontBase)   CloseLibrary(DiskfontBase);
    if (IFFParseBase)   CloseLibrary(IFFParseBase);
    if (IconBase)       CloseLibrary(IconBase);
    if (LocaleBase)     CloseLibrary(LocaleBase);
    if (RexxSysBase)    CloseLibrary(RexxSysBase);
}
///
/// CleanUp
void CleanUp( ULONG ret )
{
    ClearGUI();

    FreeMacroItems();

    CloseScr();

    if( IDCMP_Port )
	DeleteMsgPort( IDCMP_Port );

    if( IE.flags_2 & WNDPTR )
	MyTask->pr_WindowPtr = old_WindowPtr;

    if( old_Dir )
	CurrentDir( old_Dir );

    UnLoadSeg( KeyFileSeg );

    if( IE.mainprefs & WB_OPEN )
	OpenWorkBench();

    FreeLoaders();
    FreeExpanders();
    FreeARexxCmds();

    DeleteRexxPort();

    if( GenBase )
	CloseLibrary(( struct Library * )GenBase );

    if(( LocaleBase ) && ( Catalog ))
	CloseCatalog( Catalog );

    CloseLibs();

    exit( ret );
}
///
/// FreeLoaders
void FreeLoaders( void )
{
    struct LoaderNode  *loader;

    while( loader = RemTail(( struct List * )&Loaders )) {
	CloseLibrary( loader->LoaderBase );
	FreeMem( loader, sizeof( struct LoaderNode ));
    }
}
///

//      Routines di Inizializzazione
/// Apertura librerie
BOOL OpenLibs(void)
{

    if (!( IntuitionBase = OpenLibrary("intuition.library",36)))    return( FALSE );
    if (!( GfxBase       = OpenLibrary("graphics.library", 36)))    return( FALSE );
    if (!( GadToolsBase  = OpenLibrary("gadtools.library", 36)))    return( FALSE );
    if (!( AslBase       = OpenLibrary("asl.library",      36)))    return( FALSE );
    if (!( ReqToolsBase  = OpenLibrary("reqtools.library", 38)))    return( FALSE );
    if (!( DiskfontBase  = OpenLibrary("diskfont.library", 36)))    return( FALSE );
    if (!( IFFParseBase  = OpenLibrary("iffparse.library", 36)))    return( FALSE );
    if (!( IconBase      = OpenLibrary("icon.library",     36)))    return( FALSE );

    LocaleBase = OpenLibrary( "locale.library", 38 );

    SetupLocale();

    RexxSysBase = OpenLibrary( "rexxsyslib.library", 36 );

    return( TRUE );
}
///
/// Parsing degli argomenti
void ParseArguments( void )
{
    struct WBArg       *Args;
    struct RDArgs      *Arguments;
    ULONG               ArgArray[] = { 0 };

    if(!( _WBMsg )) {

	NameFromLock( (BPTR)GetProgramDir(), DefaultTool, 256 );
	GetProgramName( save_file, MAX_PATH );
	AddPart( DefaultTool, save_file, 256 );
	save_file[0] = '\0';

	if( Arguments = ReadArgs( TEMPLATE, ArgArray, NULL )) {
	    if( ArgArray[0] ) {

		strcpy( allpath2, (STRPTR)ArgArray[0] );

		strcpy( initial_file, FilePart( allpath2 ));

		UBYTE   *to = initial_drawer, *ptr2, *from = allpath2;

		ptr2 = PathPart( allpath2 );
		while( to < ptr2 )
		    *to++ = *from++;
		*to = '\0';

		IE.flags |= LOADGUI;
	    }
	    FreeArgs( Arguments );
	}

    } else {

	Args = _WBMsg->sm_ArgList;

	old_Dir = CurrentDir( Args[0].wa_Lock );
	NameFromLock( Args[0].wa_Lock, DefaultTool, 256 );
	AddPart( DefaultTool, Args[0].wa_Name, 256 );

	if( _WBMsg->sm_NumArgs > 1 ) {

	    NameFromLock( Args[1].wa_Lock, allpath2, MAX_PATH );
	    strcpy( initial_drawer, allpath2 );

	    AddPart( allpath2, Args[1].wa_Name, MAX_PATH );
	    strcpy( initial_file, Args[1].wa_Name );

	    strcpy( save_file, allpath2 );

	    IE.flags |= LOADGUI;
	}

    }

}
///
/// Setup Names
void SetupNames( void )
{
    BOOL    Go = TRUE;
    WORD    cnt = 0;
    APTR    lock;

    Forbid();

    while ( Go ) {
	cnt += 1;
	sprintf( MyPubName, PubName_fmt, cnt );

	if ( lock = LockPubScreen( MyPubName ))
		UnlockPubScreen( NULL, lock );
	    else
		Go = FALSE;
    }

    Permit();

    cnt = 0;
    while ( ScreenTags[ cnt ] != SA_PubName ) cnt += 2;
    ScreenTags[ cnt+1 ] = (ULONG)MyPubName;

}
///
/// Get Loaders
BOOL GetLoaders( void )
{
    BOOL                ret = FALSE;
    struct AnchorPath  *anchorpath;
    struct LoaderNode  *loader;
    UBYTE               buffer[255];
    ULONG               error;

    if( anchorpath = (struct AnchorPath *)AllocMem( sizeof( struct AnchorPath ) ,MEMF_CLEAR )) {

	error = MatchFirst( "PROGDIR:Loaders/#?.loader", anchorpath );
	while( error == 0 ) {

	    if( loader = AllocMem( sizeof( struct LoaderNode ), MEMF_CLEAR )) {

		strcpy( buffer, "PROGDIR:Loaders/" );
		strcat( buffer, anchorpath->ap_Info.fib_FileName );

		if( loader->LoaderBase = OpenLibrary( buffer, 37 )) {

		    AddTail(( struct List * )&Loaders, (struct Node *)loader );
		    ret = TRUE;

		} else
		    FreeMem( loader, sizeof( struct LoaderNode ));

		error = MatchNext( anchorpath );
	    }
	}

	MatchEnd( anchorpath );
	FreeMem( anchorpath, sizeof( struct AnchorPath ));
    }

    return( ret );
}
///

/// ReqHandle
ULONG ReqHandle( struct Window *Wnd, ULONG ( *Handler )( void ))
{
    ULONG   mask, ed, req;

    ed  = 1 << IDCMP_Port->mp_SigBit;
    req = 1 << Wnd->UserPort->mp_SigBit;

    mask = ed | req;

    for(;;) {
	ULONG   signals;

	signals = Wait( mask );

	if( signals & ed ) {
	    struct IntuiMessage *msg;

	    while( msg = GT_GetIMsg( IDCMP_Port )) {
		ULONG   class;

		class         = msg->Class;
		IE.win_active = msg->IDCMPWindow;

		GT_ReplyIMsg( msg );

		IE.win_info = IE.win_active->UserData;

		if( class == IDCMP_REFRESHWINDOW ) {
		    GT_BeginRefresh( IE.win_active );
		    GT_EndRefresh( IE.win_active, TRUE );
		    RinfrescaFinestra();
		}
	    }
	}

	if( signals & req )
	    return(( *Handler )() );
    }
}
///

/// IERequest
int IERequest( STRPTR Body, STRPTR Gadgets, ULONG BodyID, ULONG GadID )
{
    int     ret;

    if( BodyID )
	Body = CatCompArray[ BodyID ].cca_Str;

    if( GadID )
	Gadgets = CatCompArray[ GadID ].cca_Str;

    LockAllWindows();

    ret = rtEZRequestA( Body, Gadgets, NULL, NULL, (struct TagItem *)ReqTags );

    UnlockAllWindows();

    return( ret );
}
///

/// Informazioni
BOOL AboutMenued( void )
{
    ULONG       chip, fast;

    if( IERequest( CatCompArray[ MSG_ABOUT ].cca_Str,
		   CatCompArray[ ANS_MORE_CONT ].cca_Str, 0, 0 )) {

	chip = AvailMem( MEMF_CHIP );
	fast = AvailMem( MEMF_FAST );

	LockAllWindows();

	rtEZRequest( CatCompArray[ MSG_SYSINFO ].cca_Str,
		     ok_txt, NULL, (struct TagItem *)ReqTags,
		     UserData.Name, UserData.Number, MyPubName, RexxPortName,
		     chip, fast, chip + fast );

	UnlockAllWindows();
    }

    return( TRUE );
}
///

/// Apre per la prima volta lo schermo
BOOL OpenScr( void )
{
    struct DrawInfo     *drinfo;
    int                 cnt, max;

    if( SetupScreen())
	return( FALSE );
    else {

	IE.ScreenData->Tags[1]          = Scr->Width;
	BackWTags[ WT_HEIGHT ].ti_Data  = Scr->Height;
	IE.ScreenData->Tags[3]          = Scr->Height;
	BackWTags[ WT_WIDTH  ].ti_Data  = Scr->Width;

	if( Scr->Flags & AUTOSCROLL )
	    IE.ScreenData->Tags[ SCRAUTOSCROLL ] = TRUE;

	IE.ScreenData->Tags[ SCRID ] = GetVPModeID( &Scr->ViewPort );

	if( drinfo = GetScreenDrawInfo( Scr )) {

	    if( drinfo->dri_NumPens > 12 )
		max = 12;
	    else
		max = drinfo->dri_NumPens;

	    for( cnt = 0; cnt < max; cnt++ )
		IE.ScreenData->DriPens[cnt] = drinfo->dri_Pens[ cnt ];

	    IE.ScreenData->Tags[ SCRDEPTH ] = drinfo->dri_Depth;

	    FreeScreenDrawInfo( Scr, drinfo );
	}

	if( OpenBackWindow() )
	    return( FALSE );
	else {

	    signalset = back_mask = 1 << BackWnd->UserPort->mp_SigBit;

	    IE.ScreenData->Screen  = (APTR)WorkWndTags[ WORKSCR ] = Scr;

	    IE.ScreenData->Visual  = VisualInfo;
	    IE.ScreenData->YOffset = YOffset;
	    IE.ScreenData->XOffset = XOffset;

	    PubScreenStatus( Scr, 0L );

	    return( TRUE );
	}

    }
}
///

/// Chiusura schermo
void CloseScr( void )
{
    struct Message  *Msg;

    Forbid();

    while( Msg = GetMsg( IDCMP_Port ))
	ReplyMsg( Msg );

    CloseReqs();

    if( ToolsWnd )
	ClearMenuStrip( ToolsWnd );

    ToolsCloseWindow();

    CloseBackWindow();

    Permit();

    CheckForVisitors();

    CloseDownScreen();

    if( IE.colortable ) {
	FreeVec( IE.colortable );
	IE.colortable = NULL;
    }
}
///

/// Varie
void Stat( __A0 STRPTR txt, __D0 BOOL beep, __D1 ULONG catn )
{
    if( beep )
	DisplayBeep( NULL );

    if( ToolsWnd ) {

	if( catn )
	    txt = CatCompArray[ catn ].cca_Str;

	TextTag[1] = txt;
	GT_SetGadgetAttrsA( ToolsGadgets[ GD_Status ], ToolsWnd,
			    NULL, (struct TagItem *)TextTag );
    }
}


void Coord( void )
{
    int     x, y;

    if( IE.win_active->MouseX > 0 )
	x = IE.win_active->MouseX;
    else
	x = 0;

    if( IE.win_active->MouseY > 0 )
	y = IE.win_active->MouseY;
    else
	y = 0;

    if( IE.win_active->Width < x )
	x = IE.win_active->Width;

    if( IE.win_active->Height < y )
	y = IE.win_active->Height;

    mousex = x;
    mousey = y;

    x -= offx;
    y -= offy;

    sprintf( coord_txt, CoordFmt_txt, x, y );

    PrintIText( &Scr->RastPort, &CoordIText, Scr->Width, 1 );
}

BOOL SaveGUIClicked( void )
{
    return( SalvaMenued() );
}
///

/// Finestra strumenti
BOOL opentoolswnd( void )
{
    LONG    ret;

    LayoutWindow( ToolsWTags );

    ToolsWTags[ WT_LEFT ].ti_Data = toolsx;
    ToolsWTags[ WT_TOP  ].ti_Data = toolsy;

    ret = OpenToolsWindow();

    PostOpenWindow( ToolsWTags );

    if( ret )
	return( FALSE );

    ModifyIDCMP( ToolsWnd, IDCMP_REFRESHWINDOW | IDCMP_GADGETUP | IDCMP_MENUPICK | IDCMP_CLOSEWINDOW | IDCMP_RAWKEY );
    signalset |= ( 1 << ToolsWnd->UserPort->mp_SigBit );

    SetMenuStrip( ToolsWnd, BackMenus );

    IE.mainprefs |= TOOLSWND;

    return( TRUE );
}

void ToolsCloseWindow( void )
{
    struct MenuItem *item;

    if ( ToolsWnd ) {

	toolsx = ToolsWnd->LeftEdge;
	toolsy = ToolsWnd->TopEdge;

	ClearMenuStrip( ToolsWnd );

	signalset &= ~(1 << ToolsWnd->UserPort->mp_SigBit);

	CloseToolsWindow();

	ClearMenuStrip( BackWnd );

	item = ItemAddress( BackMenus, PREFS_MENU );

	item->Flags &= ~CHECKED;

	ResetMenuStrip( BackWnd, BackMenus );

	IE.mainprefs &= ~TOOLSWND;
    }
}


BOOL ToolsWndMenued( void )
{
    if( ToolsWnd )
	ToolsCloseWindow();
    else {
	opentoolswnd();

	Stat( CatCompArray[ MSG_HERE_I_AM ].cca_Str, FALSE, 0 );
    }

    return( TRUE );
}
///

/// ToolsGadgets On e Off
void ToolsGadgetsOn( void )
{
    struct Gadget   *first;
    int             cnt;

    if( ToolsWnd ) {

	first = ToolsWnd->FirstGadget;

	while( first->GadgetType & GTYP_SYSGADGET )
	    first = first->NextGadget;

	RemoveGList( ToolsWnd, first, -1 );

	for( cnt = 0; cnt < 5; cnt++ )
	    Tools_gads[ cnt ]->Flags &= ~GFLG_DISABLED;

	AddGList( ToolsWnd, first, -1, -1, NULL );
	RefreshGadgets( first, ToolsWnd, NULL );
    }
}

void ToolsGadgetsOff( void )
{
    struct Gadget   *first;
    int             cnt;

    if( ToolsWnd ) {

	first = ToolsWnd->FirstGadget;

	while( first->GadgetType & GTYP_SYSGADGET )
	    first = first->NextGadget;

	RemoveGList( ToolsWnd, first, -1 );

	for( cnt = 0; cnt < 5; cnt++ )
	    Tools_gads[ cnt ]->Flags |= GFLG_DISABLED;

	AddGList( ToolsWnd, first, -1, -1, NULL );
	RefreshGadgets( first, ToolsWnd, NULL );
    }
}
///

/// Preferenze
void CaricaPrefs( void )
{
    int     cnt;
    UWORD   num = 0;
    UBYTE   buffer[256];
    static UBYTE buffer2[256] = "PROGDIR:Generators/";

    if ( File = Open( PrefsFile, MODE_OLDFILE )) {

	IE.mainprefs = FGetC( File );
	IE.AsmPrefs  = FGetC( File );
	IE.C_Prefs   = FGetC( File );
	IE.AsmPrefs2 = FGetC( File );
	FRead( File, AP_IntString2, 60, 1 );
	FRead( File, AP_GadString2, 60, 1 );
	FRead( File, CP_ChipString2, 25, 1 );

	for( cnt = 0; cnt < 30; cnt++ ) {
	    FGetString( &Macros[ cnt ][0] );
	}

	FGetString( AP_DosString2 );
	FGetString( AP_RexxString2 );
	FGetString( AP_GfxString2 );
	FGetString( AP_FntString2 );

	FGetString( buffer );
	strcat( buffer2, buffer );

	GenBase = OpenLibrary( buffer2, 37 );

	FRead( File, &num, 2, 1 );
	for( cnt = 0; cnt < num; cnt++ ) {
	    FGetString( buffer );
	    AddMacroItem( buffer );
	}

	Close( File );

	if(!( IE.mainprefs & TOOLSWND ))
	    ToolsWndMenued();

	SistemaPrefsMenu();
    }
}



BOOL SavePrefsMenued( void )
{
    int                 cnt;
    struct MacroNode   *mac;

    if ( File = Open( PrefsFile, MODE_NEWFILE )) {

	FPutC( File, IE.mainprefs );
	FPutC( File, IE.AsmPrefs );
	FPutC( File, IE.C_Prefs );
	FPutC( File, IE.AsmPrefs2 );
	FWrite( File, AP_IntString2, 60, 1 );
	FWrite( File, AP_GadString2, 60, 1 );
	FWrite( File, CP_ChipString2, 25, 1 );

	for( cnt = 0; cnt < 30; cnt++ )
	    PutString( Macros[ cnt ] );

	PutString( AP_DosString2 );
	PutString( AP_RexxString2 );
	PutString( AP_GfxString2 );
	PutString( AP_FntString2 );

	if( GenBase )
	    PutString( GenBase->Lib.lib_Node.ln_Name );
	else
	    PutString( "" );

	FWrite( File, &NumMacros, 2, 1 );
	for( mac = MacroList.mlh_Head; mac->Node.ln_Succ; mac = mac->Node.ln_Succ )
	    PutString( mac->File );

	Close( File );

    } else {

	Stat( CatCompArray[ ERR_IOERR ].cca_Str, TRUE, 0 );
    }

    return( TRUE );
}
///

/// SistemaPrefsMenu
void SistemaPrefsMenu( void )
{
    struct MenuItem *item;

    SistemaGadgetsItem();

    ClearMenuStrip( BackWnd );

    if( IE.mainprefs & WB_OPEN ){

	ToggleWBMenued();
	item = ItemAddress( BackMenus, (3<<5)|PREFS_MENU );
	item->Flags &= ~CHECKED;
    }

    if( IE.mainprefs & PRIMOPIANO ) {

	item = ItemAddress( BackMenus, (5<<5)|PREFS_MENU );
	item->Flags |= CHECKED;
    }

    if( IE.mainprefs & WFLAGS ) {

	item = ItemAddress( BackMenus, (6<<5)|PREFS_MENU );
	item->Flags |= CHECKED;
    }

    if( IE.mainprefs & CREAICONE ) {

	item = ItemAddress( BackMenus, (11<<5)|PREFS_MENU );
	item->Flags |= CHECKED;
    }

    ResetMenuStrip( BackWnd, BackMenus );
}
///

/// Usa Gadgets
BOOL UsaGadsMenued( void )
{
    return( ToggleGadgetsClicked() );
}

BOOL ToggleGadgetsClicked( void )
{
    if( IE.mainprefs & STACCATI ) {
	IE.mainprefs &= ~STACCATI;
	AttaccaGadgets();
    } else {
	StaccaGadgets();
	IE.mainprefs |= STACCATI;
    }

    SistemaGadgetsItem();

    return( TRUE );
}

void SistemaGadgetsItem( void )
{
    struct MenuItem *item;
    int              pos;

    ClearMenuStrip( BackWnd );

    item = ItemAddress( BackMenus, (( 1 << 5 ) | PREFS_MENU ));

    if( ToolsWnd )
	pos = RemoveGadget( ToolsWnd, &ToggleGadgetsGadget );

    if(!( IE.mainprefs & STACCATI )) {
	item->Flags |= CHECKED;
	ToggleGadgetsGadget.Flags |= GFLG_SELECTED;
    } else {
	item->Flags &= ~CHECKED;
	ToggleGadgetsGadget.Flags &= ~GFLG_SELECTED;
    }

    ResetMenuStrip( BackWnd, BackMenus );

    if( ToolsWnd ) {
	AddGadget( ToolsWnd, &ToggleGadgetsGadget, pos );
	RefreshGList( &ToggleGadgetsGadget, ToolsWnd, NULL, 1 );
    }
}
///

/// Gestione flags vari
BOOL IconeMenued( void )
{
    IE.mainprefs ^= CREAICONE;
    return( TRUE );
}

BOOL WndInFrontMenued( void )
{
    IE.mainprefs ^= PRIMOPIANO;
    return( TRUE );
}
///

/// Apertura/Chiusura del WB
BOOL ToggleWBMenued( void )
{
    struct MenuItem *item;

    ClearMenuStrip( BackWnd );

    item = ItemAddress( BackMenus, (3<<5)|PREFS_MENU );

    if( IE.mainprefs & WB_OPEN ) {
	if( OpenWorkBench() ) {
	    IE.mainprefs &= ~WB_OPEN;
	} else {
	    Stat( CatCompArray[ ERR_NOWB ].cca_Str, TRUE, 0 );
	    item->Flags &= ~CHECKED;
	}
    } else {
	if( CloseWorkBench() ) {
	    IE.mainprefs |= WB_OPEN;
	} else {
	    Stat( CatCompArray[ ERR_CLOSEWB ].cca_Str, TRUE, 0 );
	    item->Flags |= CHECKED;
	}
    }

    ResetMenuStrip( BackWnd, BackMenus );

    return( TRUE );
}
///

/// Parametri Sorgente
static  UBYTE   FlagsBack, SrcFlagsBack;

BOOL SrcParamsMenued( void )
{
    ULONG    ret;

    LayoutWindow( SrcParamsWTags );
    ret = OpenSrcParamsWindow();
    PostOpenWindow( SrcParamsWTags );

    if( ret ) {
	DisplayBeep( Scr );
	CloseSrcParamsWindow();
    } else {

	FlagsBack = IE.flags_2;
	SrcFlagsBack = IE.SrcFlags;

	IE.flags_2 ^= GENERASCR;
	IE.SrcFlags = ~IE.SrcFlags;
	SP_GenScrKeyPressed();
	SP_FontAdaptKeyPressed();
	SP_OpenFontsKeyPressed();
	SP_mainKeyPressed();
	SP_ShdPortKeyPressed();
	IE.SrcFlags = SrcFlagsBack;

	StringTag[1] = SharedPort;
	GT_SetGadgetAttrsA( SrcParamsGadgets[ GD_SP_ShdPortIn ], SrcParamsWnd,
			    NULL, (struct TagItem *)StringTag );

	SrcParamsWnd->ExtData = HandleSrcParams;
    }

    return( TRUE );
}

void HandleSrcParams( void )
{
    if(!( HandleSrcParamsIDCMP() ))
	CloseSrcParamsWindow();
}

BOOL SrcParamsVanillaKey( void )
{
    switch( IDCMPMsg.Code ) {
	case 13:
	    return( SP_OkClicked() );
	case 27:
	    return( SP_AnnullaClicked() );
    }

    return( TRUE );
}

BOOL SP_OkKeyPressed( void )
{
    return( SP_OkClicked() );
}

BOOL SP_OkClicked( void )
{
    strcpy( SharedPort, GetString( SrcParamsGadgets[ GD_SP_ShdPortIn ]));

    return( FALSE );
}

BOOL SP_AnnullaKeyPressed( void )
{
    return( SP_AnnullaClicked() );
}

BOOL SP_AnnullaClicked( void )
{
    IE.flags_2  = FlagsBack;
    IE.SrcFlags = SrcFlagsBack;
    return( FALSE );
}

BOOL SP_FontAdaptKeyPressed( void )
{
    if( IE.SrcFlags & FONTSENSITIVE )
	CheckedTag[1] = FALSE;
    else
	CheckedTag[1] = TRUE;

    GT_SetGadgetAttrsA( SrcParamsGadgets[ GD_SP_FontAdapt ], SrcParamsWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( SP_FontAdaptClicked() );
}

BOOL SP_FontAdaptClicked( void )
{
    IE.SrcFlags ^= FONTSENSITIVE;
    return( TRUE );
}

BOOL SP_GenScrKeyPressed( void )
{
    if( IE.flags_2 & GENERASCR )
	CheckedTag[1] = FALSE;
    else
	CheckedTag[1] = TRUE;

    GT_SetGadgetAttrsA( SrcParamsGadgets[ GD_SP_GenScr ], SrcParamsWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( SP_GenScrClicked() );
}

BOOL SP_GenScrClicked( void )
{
    IE.flags_2 ^= GENERASCR;
    return( TRUE );
}

BOOL SP_OpenFontsKeyPressed( void )
{
    if( IE.SrcFlags & OPENDISKFONT )
	CheckedTag[1] = FALSE;
    else
	CheckedTag[1] = TRUE;

    GT_SetGadgetAttrsA( SrcParamsGadgets[ GD_SP_OpenFonts ], SrcParamsWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( SP_OpenFontsClicked() );
}

BOOL SP_OpenFontsClicked( void )
{
    IE.SrcFlags ^= OPENDISKFONT;
    return( TRUE );
}

BOOL SP_mainKeyPressed( void )
{
    if( IE.SrcFlags & MAINPROC )
	CheckedTag[1] = FALSE;
    else
	CheckedTag[1] = TRUE;

    GT_SetGadgetAttrsA( SrcParamsGadgets[ GD_SP_main ], SrcParamsWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( SP_mainClicked() );
}

BOOL SP_mainClicked( void )
{
    IE.SrcFlags ^= MAINPROC;
    return( TRUE );
}

BOOL SP_ShdPortKeyPressed( void )
{
    CheckedTag[1] = ( IE.SrcFlags & SHARED_PORT ) ? FALSE : TRUE;

    GT_SetGadgetAttrsA( SrcParamsGadgets[ GD_SP_ShdPort ], SrcParamsWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( SP_ShdPortClicked() );
}

BOOL SP_ShdPortClicked( void )
{
    IE.SrcFlags ^= SHARED_PORT;

    DisableTag[1] = (IE.SrcFlags & SHARED_PORT) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( SrcParamsGadgets[ GD_SP_ShdPortIn ], SrcParamsWnd,
			NULL, (struct TagItem *)DisableTag );

    if(!( DisableTag[1] ))
	ActivateGadget( SrcParamsGadgets[ GD_SP_ShdPortIn ], SrcParamsWnd, NULL );


    return( TRUE );
}

BOOL SP_ShdPortInClicked( void )
{
    return( TRUE );
}
///

/// Aggiungi/Elimina font
void LiberaFntLst( void )
{
    struct TxtAttrNode *ta;

    while( ta = RemTail((struct List *)&IE.FntLst )) {

	if( ta->txa_Ptr )
	    CloseFont( ta->txa_Ptr );

	FreeMem( ta, sizeof( struct TxtAttrNode ));
    }
}

void EliminaFont( __A0 struct TxtAttrNode *font )
{
    if( font ) {
	font->txa_OpenCnt -= 1;

	if(!( font->txa_OpenCnt )) {

	    if( font->txa_Ptr )
		CloseFont( font->txa_Ptr );

	    Remove(( struct Node *)font );

	    FreeMem( font, sizeof( struct TxtAttrNode ));
	}
    }
}

struct TxtAttrNode *AggiungiFont( __A0 struct TextAttr *font )
{
    struct TxtAttrNode *ta;

    if(!( font ))
	return( NULL );

    for( ta = IE.FntLst.mlh_Head; ta->txa_Next; ta = ta->txa_Next ) {
	if( strcmp( ta->txa_Name, font->ta_Name ) == 0 )
	    if(( ta->txa_Size == font->ta_YSize ) && ( ta->txa_Flags == font->ta_Flags ) && ( ta->txa_Style == font->ta_Style )) {
		ta->txa_OpenCnt += 1;
		return( ta );
	    }
    }

    if( ta = AllocMem( sizeof( struct TxtAttrNode ), MEMF_CLEAR )) {

	AddTail(( struct List * )&IE.FntLst, (struct Node *)ta );

	ta->txa_Ptr         = OpenDiskFont( font );
	ta->txa_OpenCnt     = 1;
	ta->txa_FontName    = ta->txa_Name;

	strcpy( ta->txa_FontName, font->ta_Name );

	ta->txa_Size        = font->ta_YSize;
	ta->txa_Style       = font->ta_Style;
	ta->txa_Flags       = font->ta_Flags;

	UBYTE   *from, *to;
	TEXT     buf[32];

	from = ta->txa_FontName;
	to   = buf;
	while( *from != '.' )
	    *to++ = *from++;
	*to = '\0';

	sprintf( ta->txa_Label, "%s%d_%d%d",
		 buf,
		 ta->txa_Size,
		 ta->txa_Style,
		 ta->txa_Flags );

    } else {
	Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, 0 );
	ta = NULL;
    }

    return( ta );
}
///

/// Rect
void Rect( int x1, int y1, int x2, int y2 )
{
    APTR    rp = IE.win_active->RPort;

    SetAPen( rp, 1 );

    Move( rp, x1, y1 );
    Draw( rp, x2, y1 );
    Draw( rp, x2, y2 );
    Draw( rp, x1, y2 );
    Draw( rp, x1, y1 );
    WritePixel( rp, x1, y1 );
}
///

/// Draw Rect
void DrawRect( UWORD w, UWORD h )
{
    struct IntuiMessage    *msg;
    int                     code, x, y;
    ULONG                   class;
    struct Window          *wnd;
    BOOL                    ok = TRUE, trace = FALSE;

    SetDrMd( IE.win_active->RPort, COMPLEMENT );

    w -= 1;
    h -= 1;

    do {
	WaitPort( IE.win_active->UserPort );

	while( msg = GT_GetIMsg( IE.win_active->UserPort )) {

	    class = msg->Class;
	    code  = msg->Code;
	    wnd   = msg->IDCMPWindow;

	    GT_ReplyIMsg( msg );

	    if( IE.win_active == wnd ) {

		x = wnd->MouseX;
		y = wnd->MouseY;

		switch( class ) {

		    case IDCMP_REFRESHWINDOW:
			GT_BeginRefresh( wnd );
			GT_EndRefresh( wnd, TRUE );
			break;

		    case IDCMP_MOUSEBUTTONS:
			switch( code ) {
			    case 0xE8:
				ok = FALSE;
				break;

			    case 0x68:
				trace = TRUE;
				clickx = lastx = wnd->MouseX;
				clicky = lasty = wnd->MouseY;
				if( IE.flags & RECTFIXED ) {
				    offx = w >> 1;
				    offy = h >> 1;
				    Rect( clickx, clicky, clickx + w, clicky + h );
				} else {
				    offx = clickx;
				    offy = clicky;
				}
				break;
			}
			break;

		    case IDCMP_MOUSEMOVE:
			Coord();
			if( trace ) {
			    if( IE.flags & RECTFIXED ) {
				Rect( clickx, clicky, clickx + w, clicky + h );
				clickx = x - offx;
				clicky = y - offy;
				Rect( clickx, clicky, clickx + w, clicky + h );
			    } else {
				Rect( clickx, clicky, lastx, lasty );
				lastx = x;
				lasty = y;
				Rect( clickx, clicky, lastx, lasty );
			    }
			}
			break;
		}
	    }
	}

    } while( ok );

    if( IE.flags & RECTFIXED ) {
	lastx = clickx;
	lasty = clicky;
	Rect( clickx, clicky, clickx + w, clicky + h );
    } else {
	Rect( clickx, clicky, lastx, lasty );
    }

    offx = offy = 0;
    Coord();

    SetDrMd( IE.win_active->RPort, JAM1 );
}
///

/// Nuovo
BOOL NuovoMenued( void )
{
    int     cnt;

    if(!( IE.flags & SALVATO )) {
	if(!( IERequest( CatCompArray[ MSG_DELETE_OR_NOT ].cca_Str, CatCompArray[ ANS_YES_NO ].cca_Str, 0, 0 )))
	    return( TRUE );
    }

    IE.flags |= SALVATO;

    save_file[0] = '\0';

    for( cnt = 0; cnt < ATTIVAMENU_NUOVAW_NUM; cnt++ )
	OffMenu( BackWnd, attivamenu_nuovawin[ cnt ]);

    MenuGadgetDisattiva();
    ToolsGadgetsOff();

    ClearGUI();

    return( TRUE );
}
///

/// Clear GUI
void ClearGUI( void )
{
    IE.num_win = IE.win_open = 0;
    IE.win_active = IE.win_info = NULL;

    IE.flags |= WNDCHIUSA;

    EliminaAllWorkWnd();
    FreeImgList();
    LiberaARexxCmds();
    EliminaMainProcData();
    LiberaFntLst();

    IE.ScreenData->St_Left    = 0;
    IE.ScreenData->St_Top     = 0;
    IE.ScreenData->Title[0]   = '\0';
    IE.ScreenData->PubName[0] = '\0';
    IE.ScreenData->ScrAttrs   = SC_SHOWTITLE | SC_DRAGGABLE;

    IE.MainProcFlags = 0;
    IE.SrcFlags      = 0;

    IE.RexxExt[0]      = '\0';
    IE.RexxPortName[0] = '\0';
    IE.ExtraProc[0]    = '\0';

    IE.Locale->Catalog[0]  = '\0';
    IE.Locale->JoinFile[0] = '\0';
    IE.Locale->BuiltIn[0]  = '\0';
    IE.Locale->Version     = 0;

    FreeLocaleData();

    IE.SharedPort[0] = '\0';
}
///

/// Lista Fin
BOOL ApriListaFin( STRPTR titolo, ULONG titnum, struct MinList *list )
{
    int     ret;

    LockAllWindows();

    if(( LocaleBase ) && ( titnum ))
	titolo = GetCatalogStr( Catalog, titnum, titolo );

    ListaWTags[9].ti_Data = titolo;

    LayoutWindow( ListaWTags );
    ret = OpenListaWindow();
    PostOpenWindow( ListaWTags );

    if( ret ) {
	DisplayBeep( Scr );
	ChiudiListaFin();
	ret = FALSE;
    } else {

//        SetWindowTitles( ListaWnd, titolo, (APTR)-1 );

	ListTag[1] = list;
	GT_SetGadgetAttrsA( ListaGadgets[ GD_Lista ], ListaWnd,
			    NULL, (struct TagItem *)ListTag );

	ret = TRUE;
    }

    return( ret );
}

void ChiudiListaFin( void )
{
    CloseListaWindow();
    UnlockAllWindows();
}

WORD GestisciListaFin( UWORD code, UWORD max )
{
    WORD   ret = -1;

    buffer  = max;
    buffer2 = code;
    buffer3 = TRUE;

    while( ReqHandle( ListaWnd, HandleListaIDCMP ));

    if(( code ) && ( buffer3 ))
	ret = ListWndTag[1];

    return( ret );
}

BOOL ListaCloseWindow( void )
{
    buffer3 = FALSE;
    return( FALSE );
}

BOOL ListaRawKey( void )
{
    switch( ListaMsg.Code ){

	case 0x45:              // ESC
	    buffer3 = FALSE;
	    return( FALSE );

	case 0x44:              // return
	    return( ListaSelect() );

	case 0x4D:              // giù
	    if( ListWndTag[1] < buffer - 1 )
		ListWndTag[1] += 1;
	    else
		ListWndTag[1] = 0;
	    ListWndTag[3] = ListWndTag[1];
	    GT_SetGadgetAttrsA( ListaGadgets[ GD_Lista ], ListaWnd, NULL, (struct TagItem *)ListWndTag );
	    break;

	case 0x4C:              // su
	    if( ListWndTag[1] )
		ListWndTag[1] -= 1;
	    else
		ListWndTag[1] = buffer - 1;
	    ListWndTag[3] = ListWndTag[1];
	    GT_SetGadgetAttrsA( ListaGadgets[ GD_Lista ], ListaWnd, NULL, (struct TagItem *)ListWndTag );
	    break;
    }
    return( TRUE );
}

BOOL ListaSelect( void )
{
    int          cnt;
    struct Node *node;

    if( buffer2 == EXIT ) {
	return( FALSE );
    } else {

	*list_to_eor ^= list_from_eor[ ListWndTag[1] ];

	node = (APTR)ListTag[1];
	for( cnt = 0; cnt <= ListWndTag[1]; cnt ++ )
	    node = node->ln_Succ;

	if( node->ln_Name[0] == ' ' )
	    node->ln_Name[0] = '*';
	else
	    node->ln_Name[0] = ' ';

	GT_RefreshWindow( ListaWnd, NULL );

    }

    return( TRUE );
}

BOOL ListaClicked( void )
{
    ListWndTag[1] = ListWndTag[3] = ListaMsg.Code;
    return( ListaSelect() );
}
///

/// GetFile2
BOOL GetFile2( BOOL savemode, STRPTR titolo, STRPTR pattern, ULONG titn, STRPTR ext )
{
    UBYTE   *ptr, ch;
    BOOL     ok;
    struct   FileRequester *req;

    if(( ext ) && ( initial_file[0] )) {
	ptr = initial_file;

	do {
	    ch = *ptr++;
	} while(( ch != '.' ) && ( ch ));

	if(!( ch )) {
	    ptr--;
	    *ptr++ = '.';
	}

	strcpy( ptr, ext );
    }

    if( LocaleBase )
	titolo = GetCatalogStr( Catalog, titn, titolo );

    if( req = AllocAslRequest( ASL_FileRequest, NULL )) {

	if( ok = AslRequestTags( req, ASLFR_DoPatterns,     TRUE,
				 ASLFR_InitialHeight,  Scr->Height - 40,
				 ASLFR_TitleText,      titolo,
				 ASLFR_InitialFile,    initial_file,
				 ASLFR_InitialDrawer,  initial_drawer,
				 ASLFR_InitialPattern, pattern,
				 ASLFR_Window,         BackWnd,
				 ASLFR_DoSaveMode,     (ULONG)savemode,
				 TAG_DONE )) {

	    strcpy( initial_file, req->fr_File );
	    strcpy( initial_drawer, req->fr_Drawer );
	    strcpy( allpath2, req->fr_Drawer );
	    AddPart( allpath2, req->fr_File, MAX_PATH );
	    strcpy( allpath, allpath2 );

	}

	FreeAslRequest( req );

    } else {
	Stat( CatCompArray[ ERR_NOASL ].cca_Str, TRUE, 0 );
	ok = FALSE;
    }

    return( ok );
}
///

/// Generazione Sorgente
BOOL GeneraMenued( void )
{
    struct GenFiles    *files;
    struct IEXNode     *ex;
    struct WindowInfo  *BackUpWnd, *wnd;
    struct ArrayNode   *array;
    ULONG               cnt;

    if(!( GenBase )) {
	GenPrefsMenued();
	return( TRUE );
    }

    if(!( IE.flags_2 & REXXCALL ))
	if(!( GetFile2( TRUE, CatCompArray[ MSG_CREATE ].cca_Str, GenBase->Pattern, MSG_CREATE, GenBase->Ext )))
	    return( TRUE );

    Stat( CatCompArray[ MSG_CREATE ].cca_Str, FALSE, 0 );

    AccodaBooleani();

    BackUpWnd = IE.win_info;

    for( wnd = IE.win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {

	SistemaGadgetsFlags( &wnd->wi_Gadgets );

	if( wnd->wi_NumTexts + wnd->wi_NumBoxes + wnd->wi_NumImages )
	    wnd->wi_NeedRender = TRUE;
	else
	    wnd->wi_NeedRender = FALSE;
    }

    DetacheGBanks();

    GetStrings();

    if(!( IE.SrcFlags & LOCALIZE )) {
	struct LocaleStr   *str;

	for( str = IE.Locale->ExtraStrings.mlh_Head; str->Node.ln_Succ; str = str->Node.ln_Succ )
	    if( str->Node.ln_Pri & LOC_GUI )
		break;

	for( cnt = 0; str->Node.ln_Succ; str = str->Node.ln_Succ )
	    sprintf( str->ID, "String%ld", cnt++ );
    }

    for( cnt = 0, array = IE.Locale->Arrays.mlh_Head; array->Next; array = array->Next )
	sprintf( array->Label, "Array%ld", cnt++ );

    for( ex = IE.Expanders.mlh_Head; ex->Node.ln_Succ; ex = ex->Node.ln_Succ ) {
	struct Generator *IEXBase = ex->Base;

	ex->Support = IEX_StartSrcGen( ex->ID, &IE );

	ex->UseCount = 0;
	for( wnd = IE.win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	    struct GadgetInfo *gad;
	    for( gad = wnd->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {

		if( gad->g_Kind == ex->ID )
		    ex->UseCount += 1;
	    }
	}
    }

    WriteCatalogs( allpath2 );

    if( files = OpenFiles( &IE, allpath2 )) {

	WriteHeaders( files, &IE );

	WriteVars( files, &IE );

	WriteChipData( files, &IE );

	WriteStrings( files, &IE );

	WriteData( files, &IE );

	WriteCode( files, &IE );

	CloseFiles( files );

	Stat( CatCompArray[ MSG_SOURCE_CREATED ].cca_Str, FALSE, 0 );

    } else
	Stat( CatCompArray[ ERR_IOERR ].cca_Str, TRUE, 0 );

    ReAttachGBanks();
    PutStrings();

    IE.win_info = BackUpWnd;

    return( TRUE );
}
///
/// SistemaGadgetsFlags
void SistemaGadgetsFlags( struct MinList *Gadgets )
{
    struct GadgetInfo  *gad;

    for( gad = Gadgets->mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
	if( gad->g_Kind < MIN_IEX_ID ) {

	    if(( gad->g_Kind != TEXT_KIND ) && ( gad->g_Kind != NUMBER_KIND ))
		gad->g_flags2 |= G_CLICKED;

	    if(( gad->g_Tags & 1 ) && ( gad->g_Key ))
		gad->g_flags2 |= G_KEYPRESSED;
	    else
		gad->g_flags2 &= ~G_KEYPRESSED;
	}
    }
}
///

/// Get Generators
BOOL GetGenerators( void )
{
    BOOL                    ret = FALSE;
    struct AnchorPath      *anchorpath;
    struct GeneratorNode   *gen;
    UBYTE                   buffer[255];
    ULONG                   error;

    if( anchorpath = (struct AnchorPath *)AllocMem( sizeof( struct AnchorPath ) ,MEMF_CLEAR )) {

	error = MatchFirst( "PROGDIR:Generators/#?.generator", anchorpath );
	while( error == 0 ) {

	    if( gen = AllocMem( sizeof( struct LoaderNode ), MEMF_CLEAR )) {

		strcpy( buffer, "PROGDIR:Generators/" );
		strcat( buffer, anchorpath->ap_Info.fib_FileName );

		if( gen->GenBase = OpenLibrary( buffer, 37 )) {

		    AddTail(( struct List * )&Generators, (struct Node *)gen );

		    gen->Node.ln_Name = gen->GenBase->Lib.lib_Node.ln_Name;

		    ret = TRUE;

		} else {
		    FreeMem( gen, sizeof( struct GeneratorNode ));
		    error = TRUE;
		}

		if (!( error ))
		    error = MatchNext( anchorpath );
	    }
	}

	MatchEnd( anchorpath );
	FreeMem( anchorpath, sizeof( struct AnchorPath ));
    }

    return( ret );
}
///
/// Free Generators
void FreeGenerators( void )
{
    struct GeneratorNode   *gen;

    while( gen = RemTail(( struct List * )&Generators )) {
	CloseLibrary(( struct Library * )gen->GenBase );
	FreeMem( gen, sizeof( struct GeneratorNode ));
    }
}
///

/// NewHandleRexxMsg
void NewHandleRexxMsg( void )
{
    ULONG           ArgArray[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
    WORD            n;
    struct RDArgs   *args = NULL, *rdargs;
    struct RexxMsg  *RxMsg;
    UBYTE           buffer[1024], command[256];
    UBYTE           *arguments;
    BOOL            found = FALSE, fail = FALSE;

    while( RxMsg = (struct RexxMsg *)GetMsg( RexxPort )) {

	if( RxMsg->rm_Node.mn_Node.ln_Type == NT_REPLYMSG ) {

	    if( RxMsg->rm_Args[15] )
		    ReplyMsg(( struct Message * )RxMsg->rm_Args[15] );

	    DeleteArgstring( RxMsg->rm_Args[0] );
	    DeleteRexxMsg( RxMsg );
	    RX_Unconfirmed -= 1;

	} else {

	    RxMsg->rm_Result1 = NULL;
	    RxMsg->rm_Result2 = NULL;
	    strcpy( buffer, RxMsg->rm_Args[0] );

	    n = 0;
	    while(( buffer[n] != '\0' ) && ( buffer[n] != ' ' )) {
		command[n] = buffer[n];
		n++;
	    };
	    command[n] = '\0';

	    n = 0;
	    struct CmdNode *Cmd;
	    for( Cmd = RexxCommands.mlh_Head; Cmd->Node.ln_Succ; Cmd = Cmd->Node.ln_Succ ) {
		if( stricmp( Cmd->Node.ln_Name, command ) == 0 ) {
		    found = TRUE;
		    break;
		}
	    };

	    if( found ) {
		if( Cmd->Template ) {
		    if( args = AllocDosObject( DOS_RDARGS, NULL )) {

			arguments = buffer + strlen( Cmd->Node.ln_Name );

			strcat( arguments, "\12" );
			args->RDA_Source.CS_Buffer = arguments;
			args->RDA_Source.CS_Length = strlen( arguments );
			args->RDA_Source.CS_CurChr = 0;
			args->RDA_DAList           = NULL;
			args->RDA_Buffer           = NULL;
			args->RDA_BufSiz           = 0L;
			args->RDA_Flags           |= RDAF_NOPROMPT;

			if( rdargs = ReadArgs( Cmd->Template, ArgArray, args )) {

			    switch( Cmd->Node.ln_Type ) {
				case 0:
				    RxMsg->rm_Result1 = (*Cmd->Routine)(ArgArray, RxMsg);
				    break;
				case 1:
				    RxMsg->rm_Result1 = ( *(( struct ExCmdNode * )Cmd )->Routine )( ArgArray, RxMsg, &IE, (( struct ExCmdNode * )Cmd )->ID );
				    break;
			    }

			    FreeArgs( rdargs );

			} else
			    fail = TRUE;

			FreeDosObject( DOS_RDARGS, args );

		    } else
			fail = TRUE;

		} else {
		    switch( Cmd->Node.ln_Type ) {
			case 0:
			    RxMsg->rm_Result1 = (*Cmd->Routine)(ArgArray, RxMsg);
			    break;
			case 1:
			    RxMsg->rm_Result1 = ( *(( struct ExCmdNode * )Cmd )->Routine )( ArgArray, RxMsg, &IE, (( struct ExCmdNode * )Cmd )->ID );
			    break;
		    }
		}

	    } else
		if(!( SendRexxMsg( "REXX", "IE", RxMsg->rm_Args[0], RxMsg, 0 )))
			fail = TRUE;

	    if( fail )
		RxMsg->rm_Result1 = RC_FATAL;

	    if( found )
		ReplyMsg(( struct Message * )RxMsg );

	}
    }
}
///

