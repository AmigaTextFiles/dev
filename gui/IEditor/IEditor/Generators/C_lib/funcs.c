/*
**
**    C_IE_Mod.generator - Copyright © 1996 Simone Tellini
**                         All Rights Reserved
**
**    $VER: C_IE_Mod.generator 37.1 (29.4.96)
**
**    This is a cut-down version of the standard C generator.
**    I use it to generate the GUI for IE's external module.
**
*/

/// Includes
#define INTUI_V36_NAMES_ONLY

#include <exec/nodes.h>                 // exec
#include <exec/lists.h>
#include <exec/memory.h>
#include <exec/types.h>
#include <dos/dos.h>                    // dos
#include <dos/dostags.h>
#include <intuition/intuition.h>        // intuition
#include <intuition/gadgetclass.h>
#include <graphics/text.h>              // graphics
#include <libraries/gadtools.h>         // libraries
#include <libraries/reqtools.h>
#include <clib/exec_protos.h>           // protos
#include <clib/dos_protos.h>
#include <clib/intuition_protos.h>
#include <clib/reqtools_protos.h>
#include <pragmas/exec_pragmas.h>       // pragmas
#include <pragmas/dos_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <pragmas/graphics_pragmas.h>
#include <pragmas/gadtools_pragmas.h>
#include <pragmas/reqtools_pragmas.h>

#include <stdarg.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#include "DEV_IE:Generators/defs.h"
#include "DEV_IE:Include/IEditor.h"
#include "Config.h"
///
/// Prototypes
static void WriteSetupScr( struct GenFiles *, struct IE_Data * );
static void WriteOpenWnd( struct GenFiles *, struct IE_Data * );
static void WriteRender( struct GenFiles *, struct IE_Data * );
static void WriteIDCMPHandler( struct GenFiles *, struct IE_Data * );
static void WriteKeyHandler( struct GenFiles *, struct IE_Data * );
static void WriteClickedPtrs( struct GenFiles *, struct IE_Data * );

static BOOL AskFile( UBYTE *, struct IE_Data * );
static void WriteList( struct GenFiles *, struct MinList *, UBYTE *, UWORD, struct IE_Data *IE );

static void WriteNewGadgets( struct GenFiles *, struct IE_Data * );
static void WriteGadgetTags( struct GenFiles *, struct IE_Data * );
static void WriteITexts( struct GenFiles *, struct IE_Data * );
static void WriteImgStruct( struct GenFiles *, struct IE_Data * );
static void WriteImageStruct( struct GenFiles *, struct IE_Data * );
static void WriteWindowTags( struct GenFiles *, struct IE_Data *, struct WindowInfo * );
///
/// Data
static ULONG CheckedTag[] = { GTCB_Checked, 0, TAG_END };

static UWORD stringjusts[] = {
    GACT_STRINGLEFT, GACT_STRINGRIGHT, GACT_STRINGCENTER
};

static ULONG gadget_flags[] = { 1, 2, 4, 8, 16, 0 };

static ULONG idcmps[] = {
	    1, 2, 4, 8, 0x10, 0x20, 0x40, 0x80, 0x100, 0x200,
	    0x400, 0x800, 0x1000, 0x2000, 0x4000, 0x8000,
	    0x10000, 0x20000, 0x40000, 0x80000, 0x100000,
	    0x200000, 0x400000, 0x800000, 0x1000000,
	    0x2000000, 0x4000000
      };

#define IDCMPS_NUM 27

static ULONG wflgs[] = {
	    1, 2, 4, 8, 0x10, 0x20, 0, 0x40, 0x80, 0x100, 0x200,
	    0x400, 0x800, 0x1000, 0x10000, 0x20000, 0x40000,
	    0x200000
      };

#define WFLAGS_NUM 18

static UBYTE Header[] =
    "/*\n"
    "    C source code created by Interface Editor\n"
    "    Copyright © 1994-1996 by Simone Tellini\n\n"
    "    Generator:  %s\n"
    "    Copy registered to :  %s\n"
    "    Serial Number      : #%ld\n"
    "*/\n\n";

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

static UBYTE  *WndFlags[] = {
    "WFLG_SIZEGADGET",
    "WFLG_DRAGBAR",
    "WFLG_DEPTHGADGET",
    "WFLG_CLOSEGADGET",
    "WFLG_SIZEBRIGHT",
    "WFLG_SIZEBBOTTOM",
    "WFLG_SMART_REFRESH",
    "WFLG_SIMPLE_REFRESH",
    "WFLG_SUPER_BITMAP",
    "WFLG_BACKDROP",
    "WFLG_REPORTMOUSE",
    "WFLG_GIMMEZEROZERO",
    "WFLG_BORDERLESS",
    "WFLG_ACTIVATE",
    "WFLG_RMBTRAP",
    "WFLG_NOCAREREFRESH",
    "WFLG_NW_EXTENDED",
    "WFLG_NEWLOOKMENUS"
};

static UBYTE  *WndIDCMP[] = {
    "IDCMP_SIZEVERIFY",
    "IDCMP_NEWSIZE",
    "IDCMP_REFRESHWINDOW",
    "IDCMP_MOUSEBUTTONS",
    "IDCMP_MOUSEMOVE",
    "IDCMP_GADGETDOWN",
    "IDCMP_GADGETUP",
    "IDCMP_REQSET",
    "IDCMP_MENUPICK",
    "IDCMP_CLOSEWINDOW",
    "IDCMP_RAWKEY",
    "IDCMP_REQVERIFY",
    "IDCMP_REQCLEAR",
    "IDCMP_MENUVERIFY",
    "IDCMP_NEWPREFS",
    "IDCMP_DISKINSERTED",
    "IDCMP_DISKREMOVED",
    "IDCMP_WBENCHMESSAGE",
    "IDCMP_ACTIVEWINDOW",
    "IDCMP_INACTIVEWINDOW",
    "IDCMP_DELTAMOVE",
    "IDCMP_VANILLAKEY",
    "IDCMP_INTUITICKS",
    "IDCMP_IDCMPUPDATE",
    "IDCMP_MENUHELP",
    "IDCMP_CHANGEWINDOW",
    "IDCMP_GADGETHELP"
};

static UBYTE  *GadIDCMP[] = {
    "BUTTONIDCMP",
    "CHECKBOXIDCMP",
    "INTEGERIDCMP",
    "LISTVIEWIDCMP",
    "MXIDCMP",
    "NUMBERIDCMP",
    "CYCLEIDCMP",
    "PALETTEIDCMP",
    "SCROLLERIDCMP",
    NULL,
    "SLIDERIDCMP",
    "STRINGIDCMP",
    "TEXTIDCMP",
    "IDCMP_GADGETUP|IDCMP_GADGETDOWN"
};

static UBYTE   Null[] = "NULL";

static UBYTE   GADisabled[]         = "(GA_Disabled), TRUE, ";
static UBYTE   GAImmediate[]        = "(GA_Immediate), TRUE, ";
static UBYTE   GATabCycle[]         = "(GA_TabCycle), FALSE, ";
static UBYTE   GARelVerify[]        = "(GA_RelVerify), TRUE, ";
static UBYTE   STRINGAExitHelp[]    = "(STRINGA_ExitHelp), TRUE, ";
static UBYTE   STRINGAReplaceMode[] = "(STRINGA_ReplaceMode), TRUE, ";
static UBYTE   PGAFreedom[]         = "(PGA_Freedom), LORIENT_VERT, ";
static UBYTE   LAYOUTASpacing[]     = "(LAYOUTA_Spacing), %ld, ";

static UBYTE   MenuTmp[] = "\nBOOL %sMenued( void )\n"
		    "{\n"
		    "\t/*  Routine for menu \"%s\"  */\n"
		    "\treturn( TRUE );\n"
		    "}\n";

static ULONG IDCMPVer[] = { IDCMP_MENUVERIFY, IDCMP_REQVERIFY, IDCMP_SIZEVERIFY };
static UBYTE *IDCMPVerStr[] = {
    "\n\t\tif( class == IDCMP_MENUVERIFY )\n\t\t\trunning = %sMenuVerify( Wnd, Gadgets, IE );\n",
    "\n\t\tif( class == IDCMP_REQVERIFY )\n\t\t\trunning = %sReqVerify( Wnd, Gadgets, IE );\n"
    "\n\t\tif( class == IDCMP_SIZEVERIFY )\n\t\t\trunning = %sSizeVerify( Wnd, Gadgets, IE );\n"
};
static UBYTE *IDCMPVerProto[] = {
    "extern BOOL %sMenuVerify( struct Window *, struct Gadget **, struct IE_Data * );\n"
    "extern BOOL %sReqVerify( struct Window *, struct Gadget **, struct IE_Data * );\n"
    "extern BOOL %sSizeVerify( struct Window *, struct Gadget **, struct IE_Data * );\n"
};
static UBYTE *IDCMPVerTmp[] = {
    "\nBOOL %sMenuVerify( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )\n"
    "{\n"
    "\t/*  Routine for IDCMP_MENUVERIFY  */\n"
    "\treturn( TRUE );\n"
    "}\n", // ---
    "\nBOOL %sReqVerify( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )\n"
    "{\n"
    "\t/*  Routine for IDCMP_REQVERIFY  */\n"
    "\treturn( TRUE );\n"
    "}\n", // ---
    "\nBOOL %sSizeVerify( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )\n"
    "{\n"
    "\t/*  Routine for IDCMP_SIZEVERIFY  */\n"
    "\treturn( TRUE );\n"
    "}\n",
};

static UBYTE VanillaTmp[] = "\nBOOL %sVanillaKey( UBYTE, struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )\n"
			    "{\n"
			    "\t/*  Routine for IDCMP_VANILLAKEY  */\n"
			    "\treturn( TRUE );\n"
			    "}\n";

static UBYTE CaseRefresh[] = "\n\t\t\tcase\tIDCMP_REFRESHWINDOW:\n"
			     "\t\t\t\tGT_BeginRefresh( Wnd );\n"
			     "\t\t\t\tGT_EndRefresh( Wnd, TRUE );\n"
			     "\t\t\t\tbreak;\n";

static UBYTE CaseRefresh2[] = "\n\t\t\tcase\tIDCMP_REFRESHWINDOW:\n"
			      "\t\t\t\tGT_BeginRefresh( Wnd );\n"
			      "\t\t\t\t%sRender( Wnd, IE );\n"
			      "\t\t\t\tGT_EndRefresh( Wnd, TRUE );\n"
			      "\t\t\t\tbreak;\n";

static UBYTE *IDCMPStr[] = {
    NULL,
    "\n\t\t\tcase\tIDCMP_NEWSIZE:\n"
    "\t\t\t\trunning = %sNewSize( Wnd, Gadgets, IE );\n"
    "\t\t\t\tbreak;\n",

    CaseRefresh,

    "\n\t\t\tcase\tIDCMP_MOUSEBUTTONS:\n"
    "\t\t\t\trunning = %sMouseButtons( Wnd, Gadgets, IE );\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_MOUSEMOVE:\n"
    "\t\t\t\trunning = %sMouseMove( Wnd, Gadgets, IE );\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_GADGETDOWN:\n"
    "\t\t\t\tfunc = gad->UserData;\n"
    "\t\t\t\trunning = (*func)( Wnd, Gadgets, IE, &Msg );\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_GADGETUP:\n"
    "\t\t\t\tfunc = gad->UserData;\n"
    "\t\t\t\trunning = (*func)( Wnd, Gadgets, IE, &Msg );\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_REQSET:\n"
    "\t\t\t\trunning = %sReqSet( Wnd, Gadgets, IE );\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_MENUPICK:\n"
    "\t\t\t\twhile( %sMsg.Code != MENUNULL ) {\n"
    "\t\t\t\t\tn = ItemAddress( %sMenus, %sMsg.Code );\n"
    "\t\t\t\t\tfunc = (GTMENUITEM_USERDATA( n ));\n"
    "\t\t\t\t\trunning = (*func)( Wnd, Gadgets, IE );\n"
    "\t\t\t\t\t%sMsg.Code = n->NextSelect;\n"
    "\t\t\t\t}\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_CLOSEWINDOW:\n"
    "\t\t\t\trunning = %sCloseWindow( Wnd, Gadgets, IE );\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_RAWKEY:\n"
    "\t\t\t\trunning = %sRawKey( Wnd, Gadgets, IE );\n"
    "\t\t\t\tbreak;\n",

    NULL,

    "\n\t\t\tcase\tIDCMP_REQCLEAR:\n"
    "\t\t\t\trunning = %sReqClear( Wnd, Gadgets, IE );\n"
    "\t\t\t\tbreak;\n",

    NULL,

    "\n\t\t\tcase\tIDCMP_NEWPREFS:\n"
    "\t\t\t\trunning = %sNewPrefs( Wnd, Gadgets, IE );\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_DISKINSERTED:\n"
    "\t\t\t\trunning = %sDiskInserted( Wnd, Gadgets, IE );\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_DISKREMOVED:\n"
    "\t\t\t\trunning = %sDiskRemoved( Wnd, Gadgets, IE );\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_WBENCHMESSAGE:\n"
    "\t\t\t\trunning = %sWBenchMessage( Wnd, Gadgets, IE );\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_ACTIVEWINDOW:\n"
    "\t\t\t\trunning = %sActiveWindow( Wnd, Gadgets, IE );\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_INACTIVEWINDOW:\n"
    "\t\t\t\trunning = %sInactiveWindow( Wnd, Gadgets, IE );\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_DELTAMOVE:\n"
    "\t\t\t\trunning = %sDeltaMove( Wnd, Gadgets, IE );\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_VANILLAKEY:\n"
    "\t\t\t\trunning = %sVanillaKey( Code, Wnd, Gadgets, IE );\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_INTUITICKS:\n"
    "\t\t\t\trunning = %sIntuiTicks( Wnd, Gadgets, IE );\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_IDCMPUPDATE:\n"
    "\t\t\t\trunning = %sIDCMPUpdate( Wnd, Gadgets, IE );\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_MENUHELP:\n"
    "\t\t\t\trunning = %sMenuHelp( Wnd, Gadgets, IE );\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_CHANGEWINDOW:\n"
    "\t\t\t\trunning = %sChangeWindow( Wnd, Gadgets, IE );\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_GADGETHELP:\n"
    "\t\t\t\trunning = %sGadgetHelp( Wnd, Gadgets, IE );\n"
    "\t\t\t\tbreak;\n"
};

static UBYTE *IDCMPProto[] = {
    NULL,
    "extern BOOL %sNewSize( struct Window *, struct Gadget **, struct IE_Data * );\n",
    NULL,
    "extern BOOL %sMouseButtons( struct Window *, struct Gadget **, struct IE_Data * );\n",
    "extern BOOL %sMouseMove( struct Window *, struct Gadget **, struct IE_Data * );\n",
    NULL,
    NULL,
    "extern BOOL %sReqSet( struct Window *, struct Gadget **, struct IE_Data * );\n",
    NULL,
    "extern BOOL %sCloseWindow( struct Window *, struct Gadget **, struct IE_Data * );\n",
    "extern BOOL %sRawKey( struct Window *, struct Gadget **, struct IE_Data * );\n",
    NULL,
    "extern BOOL %sReqClear( struct Window *, struct Gadget **, struct IE_Data * );\n",
    NULL,
    "extern BOOL %sNewPrefs( struct Window *, struct Gadget **, struct IE_Data * );\n",
    "extern BOOL %sDiskInserted( struct Window *, struct Gadget **, struct IE_Data * );\n",
    "extern BOOL %sDiskRemoved( struct Window *, struct Gadget **, struct IE_Data * );\n",
    "extern BOOL %sWBenchMessage( struct Window *, struct Gadget **, struct IE_Data * );\n",
    "extern BOOL %sActiveWindow( struct Window *, struct Gadget **, struct IE_Data * );\n",
    "extern BOOL %sInactiveWindow( struct Window *, struct Gadget **, struct IE_Data * );\n",
    "extern BOOL %sDeltaMove( struct Window *, struct Gadget **, struct IE_Data * );\n",
    "extern BOOL %sVanillaKey( UBYTE, struct Window *, struct Gadget **, struct IE_Data * );\n",
    "extern BOOL %sIntuiTicks( struct Window *, struct Gadget **, struct IE_Data * );\n",
    "extern BOOL %sIDCMPUpdate( struct Window *, struct Gadget **, struct IE_Data * );\n",
    "extern BOOL %sMenuHelp( struct Window *, struct Gadget **, struct IE_Data * );\n",
    "extern BOOL %sChangeWindow( struct Window *, struct Gadget **, struct IE_Data * );\n",
    "extern BOOL %sGadgetHelp( struct Window *, struct Gadget **, struct IE_Data * );\n"
};

static UBYTE *IDCMPTmp[] = {
    NULL,
    "\nBOOL %sNewSize( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )\n"
    "{\n"
    "\t/*  Routine for IDCMP_NEWSIZE  */\n"
    "\treturn( TRUE );\n"
    "}\n",
    NULL,
    "\nBOOL %sMouseButtons( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )\n"
    "{\n"
    "\t/*  Routine for IDCMP_MOUSEBUTTONS  */\n"
    "\treturn( TRUE );\n"
    "}\n",

    "\nBOOL %sMouseMove( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )\n"
    "{\n"
    "\t/*  Routine for IDCMP_MOUSEMOVE  */\n"
    "\treturn( TRUE );\n"
    "}\n",

    NULL,
    NULL,
    "\nBOOL %sReqSet( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )\n"
    "{\n"
    "\t/*  Routine for IDCMP_REQSET  */\n"
    "\treturn( TRUE );\n"
    "}\n",
    NULL,
    "\nBOOL %sCloseWindow( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )\n"
    "{\n"
    "\t/*  Routine for IDCMP_CLOSEWINDOW  */\n"
    "\t/*  Return FALSE to quit, I suppose... ;)  */\n"
    "\treturn( FALSE );\n"
    "}\n",

    "\nBOOL %sRawKey( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )\n"
    "{\n"
    "\t/*  Routine for IDCMP_RAWKEY  */\n"
    "\treturn( TRUE );\n"
    "}\n",

    NULL,
    "\nBOOL %sReqClear( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )\n"
    "{\n"
    "\t/*  Routine for IDCMP_REQCLEAR  */\n"
    "\treturn( TRUE );\n"
    "}\n",
    NULL,
    "\nBOOL %sNewPrefs( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )\n"
    "{\n"
    "\t/*  Routine for IDCMP_NEWPREFS  */\n"
    "\treturn( TRUE );\n"
    "}\n",

    "\nBOOL %sDiskInserted( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )\n"
    "{\n"
    "\t/*  Routine for IDCMP_DISKINSERTED  */\n"
    "\treturn( TRUE );\n"
    "}\n",

    "\nBOOL %sDiskRemoved( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )\n"
    "{\n"
    "\t/*  Routine for IDCMP_DISKREMOVED  */\n"
    "\treturn( TRUE );\n"
    "}\n",

    "\nBOOL %sWBenchMessage( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )\n"
    "{\n"
    "\t/*  Routine for IDCMP_WBENCHMESSAGE  */\n"
    "\treturn( TRUE );\n"
    "}\n",

    "\nBOOL %sActiveWindow( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )\n"
    "{\n"
    "\t/*  Routine for IDCMP_ACTIVEWINDOW  */\n"
    "\treturn( TRUE );\n"
    "}\n",

    "\nBOOL %sInactiveWindow( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )\n"
    "{\n"
    "\t/*  Routine for IDCMP_INACTIVEWINDOW  */\n"
    "\treturn( TRUE );\n"
    "}\n",

    "\nBOOL %sDeltaMove( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )\n"
    "{\n"
    "\t/*  Routine for IDCMP_DELTAMOVE  */\n"
    "\treturn( TRUE );\n"
    "}\n",

    "\nBOOL %sVanillaKey( UBYTE Code, struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )\n"
    "{\n"
    "\t/*  Routine for IDCMP_VANILLAKEY  */\n"
    "\treturn( TRUE );\n"
    "}\n",

    "\nBOOL %sIntuiTicks( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )\n"
    "{\n"
    "\t/*  Routine for IDCMP_INTUITICKS  */\n"
    "\treturn( TRUE );\n"
    "}\n",

    "\nBOOL %sIDCMPUpdate( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )\n"
    "{\n"
    "\t/*  Routine for IDCMP_IDCMPUPDATE  */\n"
    "\treturn( TRUE );\n"
    "}\n",

    "\nBOOL %sMenuHelp( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )\n"
    "{\n"
    "\t/*  Routine for IDCMP_MENUHELP  */\n"
    "\treturn( TRUE );\n"
    "}\n",

    "\nBOOL %sChangeWindow( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )\n"
    "{\n"
    "\t/*  Routine for IDCMP_CHANGEWINDOW  */\n"
    "\treturn( TRUE );\n"
    "}\n",

    "\nBOOL %sGadgetHelp( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )\n"
    "{\n"
    "\t/*  Routine for IDCMP_GADGETHELP  */\n"
    "\treturn( TRUE );\n"
    "}\n"
};
///


// Misc
/// AskFile
BOOL AskFile( UBYTE *File, struct IE_Data *IE )
{
    BOOL    ret = TRUE;
    BPTR    lock;

    if( lock = Lock( File, ACCESS_READ )) {

	UnLock( lock );

	ULONG   tags[] = { RT_ReqPos, REQPOS_CENTERSCR, RT_Underscore, '_',
			   RT_Screen, IE->ScreenData->Screen, TAG_DONE };

	ret = rtEZRequest( "%s alreay exists.\n"
			   "Overwrite?",
			   "_Yes|_No",
			   NULL, (struct TagItem *)tags,
			   FilePart( File )
			 );
    }

    return( ret );
}
///
/// WriteList
void WriteList( struct GenFiles *Files, struct MinList *List, UBYTE *Label, UWORD Num, struct IE_Data *IE )
{
    struct GadgetScelta *gs;
    UWORD                cnt;

    if( Num ) {

	FPrintf( Files->XDef, "extern struct MinList %sList;\n", Label );

	FPrintf( Files->Std, "\nstruct Node %sNodes[] = {\n\t", Label );

	gs = List->mlh_Head;

	if( Num == 1 ) {
	    FPrintf( Files->Std, "(struct Node *)&%sList.mlh_Tail, (struct Node *)&%sList.mlh_Head, 0, 0, ",
		     Label, Label );

	    FPrintf( Files->Std, "\"%s\"", gs->gs_Testo );

	    FPuts( Files->Std, " };\n" );
	} else {

	    FPrintf( Files->Std, "&%sNodes[1], (struct Node *)&%sList.mlh_Head, 0, 0, ",
		     Label, Label );

	    FPrintf( Files->Std, "\"%s\"", gs->gs_Testo );

	    FPuts( Files->Std, ",\n" );

	    for( cnt = 1; cnt < Num - 1; cnt++ ) {

		gs = gs->gs_Node.ln_Succ;

		FPrintf( Files->Std, "\t&%sNodes[%ld], &%sNodes[%ld], 0, 0, ",
			 Label, cnt + 1, Label, cnt - 1 );

		FPrintf( Files->Std, "\"%s\"", gs->gs_Testo );

		FPuts( Files->Std, ",\n" );
	    }

	    gs = gs->gs_Node.ln_Succ;
	    FPrintf( Files->Std, "\t(struct Node *)&%sList.mlh_Tail, &%sNodes[%ld], 0, 0, ",
		     Label, Label, Num - 2 );

	    FPrintf( Files->Std, "\"%s\"", gs->gs_Testo );

	    FPuts( Files->Std, " };\n" );
	}

	FPrintf( Files->Std, "\nstruct MinList %sList = {\n"
			     "\t(struct MinNode *)&%sNodes[0], (struct MinNode *)NULL, (struct MinNode *)&%sNodes[%ld] };\n",
		 Label, Label, Label, Num - 1 );
    }
}
///

// Code
/// WriteSetupScr
void WriteSetupScr( struct GenFiles *Files, struct IE_Data *IE )
{
    if( IE->SrcFlags & FONTSENSITIVE ) {

	FPuts( Files->XDef, "extern UWORD ScaleX( UWORD, UWORD );\n"
			    "extern UWORD ScaleY( UWORD, UWORD );\n" );

	FPrintf( Files->Std, "\nUWORD ScaleX( UWORD FontX, UWORD value )\n"
			     "{\n"
			     "\treturn(( UWORD )((( FontX * value ) + %ld ) / %ld ));\n"
			     "}\n"
			     "\n"
			     "UWORD ScaleY( UWORD FontY, UWORD value )\n"
			     "{\n"
			     "\treturn(( UWORD )((( FontY * value ) + %ld ) / %ld ));\n"
			     "}\n",
		 IE->ScreenData->Screen->RastPort.Font->tf_XSize >> 1,
		 IE->ScreenData->Screen->RastPort.Font->tf_XSize,
		 IE->ScreenData->Screen->RastPort.Font->tf_YSize >> 1,
		 IE->ScreenData->Screen->RastPort.Font->tf_YSize );
    }

    FPuts( Files->Std, "\nvoid CloseWnd( struct Window **Wnd, struct Gadget **GList )\n"
		       "{\n"
		       "\tif( *Wnd ) {\n"
		       "\t\tCloseWindow( *Wnd );\n"
		       "\t\t*Wnd = NULL;\n"
		       "\t}\n"
		       "\tif( GList ) {\n"
		       "\t\tFreeGadgets( *GList );\n"
		       "\t\t*GList = NULL;\n"
		       "\t}\n"
		       "}\n" );
}
///
/// WriteOpenWnd
void WriteOpenWnd( struct GenFiles *Files, struct IE_Data *IE )
{
    struct WindowInfo  *wnd;
    UWORD               cnt = 0;

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {

	FPrintf( Files->XDef, "extern LONG Open%sWindow( struct Window **, struct Gadget **, struct Gadget **, struct IE_Data * );\n",
		 wnd->wi_Label );

	FPrintf( Files->Std, "\nLONG Open%sWindow( struct Window **Wnd, struct Gadget **GList, struct Gadget *Gadgets[], struct IE_Data *IE )\n"
			     "{\n"
			     "\tLONG\t\tret_code = NULL;\n",
		 wnd->wi_Label );

	if( IE->SrcFlags & FONTSENSITIVE ) {
	    FPrintf( Files->Std, "\tUWORD\t\tFontX, FontY;\n"
				 "\tstruct TextAttr\t*Font;\n\n"
				 "\tFont = IE->ScreenData->Screen->Font;\n"
				 "\tFontY = IE->ScreenData->Screen->RastPort.Font->tf_YSize;\n"
				 "\tFontX = IE->ScreenData->Screen->RastPort.Font->tf_XSize;\n"
				 "\n"
				 "\tif((( ScaleX( FontX, %ld ) + IE->ScreenData->Screen->WBorRight + IE->ScreenData->XOffset ) > IE->ScreenData->Screen->Width ) ||\n"
				 "\t\t(( ScaleY( FontY, %ld ) + IE->ScreenData->Screen->WBorBottom + IE->ScreenData->YOffset ) > IE->ScreenData->Screen->Height )) {\n"
				 "\t\t\tFont = &topaz8_065;\n"
				 "\t\t\tFontX = FontY = 8;\n"
				 "\t\t}\n",
		     wnd->wi_Width - ( IE->ScreenData->XOffset + IE->ScreenData->Screen->WBorRight  ),
		     wnd->wi_Height - ( IE->ScreenData->YOffset + IE->ScreenData->Screen->WBorBottom ));
	}

	if( wnd->wi_NumGads ) {

	    FPrintf( Files->Std, "\n\tstruct Gadget\t\t*g;\n"
				 "\tUWORD\t\t\tlc, tc;\n"
				 "\tstruct NewGadget\tng;\n"
				 "\n"
				 "\tif(!( g = CreateContext( GList )))\n"
				 "\t\treturn( 1L );\n"
				 "\n"
				 "\tfor( lc = 0, tc = 0; lc < %s_CNT; lc++ ) {\n\n"
				 "\t\tCopyMem(( char * )&%sNGad[ lc ], ( char * )&ng, ( long )sizeof( struct NewGadget ));\n"
				 "\t\tng.ng_VisualInfo = IE->ScreenData->Visual;\n",
		     wnd->wi_Label, wnd->wi_Label );

	    if( IE->SrcFlags & FONTSENSITIVE )
		FPuts( Files->Std, "\t\tng.ng_TextAttr = Font;\n"
				   "\t\tng.ng_LeftEdge = IE->ScreenData->XOffset + ScaleX( FontX, ng.ng_LeftEdge );\n"
				   "\t\tng.ng_TopEdge  = IE->ScreenData->YOffset + ScaleY( FontY, ng.ng_TopEdge  );\n"
				   "\t\tng.ng_Width    = ScaleX( FontX, ng.ng_Width  );\n"
				   "\t\tng.ng_Height   = ScaleY( FontY, ng.ng_Height );\n" );
	    else
		FPuts( Files->Std, "\t\tng.ng_TopEdge  += IE->ScreenData->YOffset;\n"
				   "\t\tng.ng_LeftEdge += IE->ScreenData->XOffset;\n" );

	    FPrintf( Files->Std, "\t\tGadgets[ lc ] = g = CreateGadgetA((ULONG)%sGTypes[ lc ], g, &ng, (struct TagItem *)&%sGTags[ tc ] );\n\n"
				 "\t\twhile( %sGTags[ tc ] ) tc += 2;\n"
				 "\t\ttc++;\n\n"
				 "\t\tif( !g )\n"
				 "\t\t\treturn( 2L );\n"
				 "\t}\n\n",
		     wnd->wi_Label, wnd->wi_Label, wnd->wi_Label );

	}

	WriteWindowTags( Files, IE, wnd );

	if( IE->SrcFlags & FONTSENSITIVE )
	    FPuts( Files->Std, "\n\tWTags[ WT_LEFT ].ti_Data = (IE->ScreenData->Screen->Width  - WTags[ WT_WIDTH  ].ti_Data) >> 1;\n"
			       "\tWTags[ WT_TOP  ].ti_Data = (IE->ScreenData->Screen->Height - WTags[ WT_HEIGHT ].ti_Data) >> 1;\n" );

	FPuts( Files->Std, "\n\tif(!( *Wnd = OpenWindowTagList( NULL, &WTags[0] )))\n"
			   "\t\treturn( 4L );\n"
			   "\n\tGT_RefreshWindow( *Wnd, NULL );\n" );

	if( wnd->wi_NumBoxes + wnd->wi_NumImages + wnd->wi_NumTexts )
	    FPrintf( Files->Std, "\n\t%sRender( *Wnd, IE );\n", wnd->wi_Label );

	FPrintf( Files->Std, "\treturn( 0L );\n"
			     "}\n",
		 wnd->wi_Label );
    }
}
///
/// WriteRender
void WriteRender( struct GenFiles *Files, struct IE_Data *IE )
{
    struct WindowInfo      *wnd;
    struct BevelBoxNode    *box;
    WORD                    x, y;

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	if( wnd->wi_NumBoxes + wnd->wi_NumImages + wnd->wi_NumTexts ) {

	    FPrintf( Files->XDef, "extern void %sRender( struct Window *, struct IE_Data * );\n", wnd->wi_Label );

	    FPrintf( Files->Std, "\nvoid %sRender( struct Window *Wnd, struct IE_Data *IE )\n{\n", wnd->wi_Label );

	    if( IE->SrcFlags & FONTSENSITIVE ) {

		if( wnd->wi_NumImages )
		    FPuts( Files->Std, "\tstruct Image\t\tim;\n"
				       "\tstruct Image\t\t*imp;\n" );

		if( wnd->wi_NumTexts )
		    FPuts( Files->Std, "\tstruct IntuiText\tit;\n" );

		if(( wnd->wi_NumImages ) || ( wnd->wi_NumTexts ))
		    FPuts( Files->Std, "\tUWORD\t\t\tc;\n" );
	    }

	    for( box = wnd->wi_Boxes.mlh_Head; box->bb_Next; box = box->bb_Next ) {
		x = box->bb_Left - IE->ScreenData->XOffset;
		y = box->bb_Top  - IE->ScreenData->YOffset;

		if( IE->SrcFlags & FONTSENSITIVE )
		    FPrintf( Files->Std, "\n\tDrawBevelBox( Wnd->RPort, ScaleX( FontX, %ld ) + IE->ScreenData->XOffset, ScaleY( FontY, %ld ) + IE->ScreenData->YOffset, ScaleX( %ld ), ScaleY( %ld ),\n"
					 "\t\tGT_VisualInfo, IE->ScreenData->Visual,",
			     x, y, box->bb_Width, box->bb_Height );
		else
		    FPrintf( Files->Std, "\n\tDrawBevelBox( Wnd->RPort, %ld + IE->ScreenData->XOffset, %ld + IE->ScreenData->YOffset, %ld, %ld,\n"
					 "\t\tGT_VisualInfo, IE->ScreenData->Visual,",
			     x, y, box->bb_Width, box->bb_Height );

		if( box->bb_Recessed )
		    FPuts( Files->Std, " GTBB_Recessed, TRUE," );

		if( box->bb_FrameType != 1 )
		    VFPrintf( Files->Std, " GTBB_FrameType, %ld,", &box->bb_FrameType );

		FPuts( Files->Std, " TAG_DONE );\n" );
	    }

	    if( wnd->wi_NumImages ) {
		if( IE->SrcFlags & FONTSENSITIVE ) {
		    FPrintf( Files->Std, "\n\timp = &%s_0Image;\n"
					 "\tfor( c = 0; c < %ld; c++ ) {\n"
					 "\t\tCopyMem(( char * )imp, ( char * )&im, ( long )sizeof( struct Image ));\n"
					 "\t\timp = imp->NextImage;\n"
					 "\t\tim.NextImage = NULL;\n"
					 "\t\tim.LeftEdge  = IE->ScreenData->XOffset + ScaleX( im.LeftEdge );\n"
					 "\t\tim.TopEdge   = IE->ScreenData->YOffset + ScaleY( im.TopEdge  );\n"
					 "\t\tDrawImage( Wnd->RPort, &im, 0, 0 );\n"
					 "\t}\n",
			     wnd->wi_Label, wnd->wi_NumImages );
		} else {
		    FPrintf( Files->Std, "\n\tDrawImage( Wnd->RPort, &%s_0Image, XOffset, YOffset );\n",
			     wnd->wi_Label );
		}
	    }

	    if( wnd->wi_NumTexts ) {
		if( IE->SrcFlags & FONTSENSITIVE ) {
		    FPrintf( Files->Std, "\n\tfor( c = 0; c < %ld; c++ ) {\n"
					 "\t\tCopyMem(( char * )&%sIText[ c ], ( char * )&it, ( long )sizeof( struct IntuiText ));\n"
					 "\t\tit.LeftEdge = IE->ScreenData->XOffset + ScaleX( it.LeftEdge ) - ( IntuiTextLength( &it ) >> 1 );\n"
					 "\t\tit.TopEdge  = IE->ScreenData->YOffset + ScaleY( it.TopEdge  ) - ( Font->ta_YSize >> 1 );\n"
					 "\t\tPrintIText( Wnd->RPort, &it, 0, 0 );\n"
					 "\t}\n",
			     wnd->wi_NumTexts, wnd->wi_Label );
		} else {
		    FPrintf( Files->Std, "\n\tPrintIText( Wnd->RPort, %sIText, XOffset, YOffset );\n",
			     wnd->wi_Label );
		}
	    }

	    FPuts( Files->Std, "}\n" );

	}
    }
}
///
/// WriteIDCMPHandler
void WriteIDCMPHandler( struct GenFiles *Files, struct IE_Data *IE )
{
    struct WindowInfo  *wnd;
    UWORD               c;
    ULONG               idcmp;


    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	if( wnd->wi_IDCMP ) {

	    FPrintf( Files->XDef, "extern LONG Handle%sIDCMP( struct Window *, struct Gadget **, struct IE_Data * );\n", wnd->wi_Label );

	    FPrintf( Files->Std, "\nLONG Handle%sIDCMP( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )\n"
				 "{\n"
				 "\tstruct IntuiMessage\t*m, Msg;\n",
		     wnd->wi_Label );

	    if( wnd->wi_IDCMP & IDCMP_MENUPICK )
		FPuts( Files->Std, "\tstruct MenuItem\t\t*n;\n" );

	    FPuts( Files->Std, "\tBOOL\t\t\t(*func)( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );\n"
				 "\tBOOL\t\t\trunning = TRUE;\n"
				 "\tint\t\t\tclass;\n"
				 "\tshort\t\t\tcode;\n"
				 "\tstruct Gadget\t*gad;\n"
				 "\n"
				 "\twhile( m = GT_GetIMsg( Wnd->UserPort )) {\n\n"
				 "\t\tclass = m->Class;\n"
				 "\t\tcode  = m->Code;\n"
				 "\t\tgad   = (struct Gadget *)m->IAddress;\n\n"
				 "\t\tCopyMem((char *)m, (char *)&Msg, (long)sizeof( struct IntuiMessage ));\n"  );


	    for( c = 0; c < 3; c++ ) {
		if( wnd->wi_IDCMP & IDCMPVer[ c ]) {
		    FPrintf( Files->XDef, IDCMPVerProto[ c ], wnd->wi_Label );
		    FPrintf( Files->Std, IDCMPVerStr[ c ], wnd->wi_Label );
		    if( IE->C_Prefs & GEN_TEMPLATE )
			FPrintf( Files->Temp, IDCMPVerTmp[ c ], wnd->wi_Label );
		}
	    }

	    FPuts( Files->Std, "\n\t\tGT_ReplyIMsg( m );\n\n"
			       "\t\tswitch( class ) {\n" );

	    idcmp = wnd->wi_IDCMP;

	    if(( idcmp & IDCMP_GADGETUP ) && ( idcmp & IDCMP_GADGETDOWN )) {
		idcmp &= ~( IDCMP_GADGETUP | IDCMP_GADGETDOWN );
		FPrintf( Files->Std, "\n\t\t\tcase\tIDCMP_GADGETUP:\n"
				     "\t\t\tcase\tIDCMP_GADGETDOWN:\n"
				     "\t\t\t\tfunc = gad->UserData;\n"
				     "\t\t\t\trunning = (*func)( Wnd, Gadgets, IE, &Msg );\n"
				     "\t\t\t\tbreak;\n",
			 wnd->wi_Label );
	    }

	    if(( IE->C_Prefs & KEY_HANDLER ) && ( wnd->wi_NumKeys )) {

		FPrintf( Files->Std, "\n\t\t\tcase\tIDCMP_VANILLAKEY:\n"
				     "\t\t\t\trunning = Handle%sKeys( code, Wnd, Gadgets, IE, &Msg );\n"
				     "\t\t\t\tbreak;\n",
			 wnd->wi_Label );

		if( idcmp & IDCMP_VANILLAKEY ) {
		    idcmp &= ~IDCMP_VANILLAKEY;
		    FPrintf( Files->XDef, "extern BOOL %sVanillaKey( UBYTE, struct Window *, struct Gadget **, struct IE_Data * );\n", wnd->wi_Label );
		    if( IE->C_Prefs & GEN_TEMPLATE )
			FPrintf( Files->Temp, VanillaTmp, wnd->wi_Label );
		}
	    }

	    IDCMPStr[2] = ( wnd->wi_NumBoxes + wnd->wi_NumImages + wnd->wi_NumTexts ) ? CaseRefresh2 : CaseRefresh;

	    for( c = 0; c < IDCMPS_NUM; c++ ) {
		if( idcmp & idcmps[ c ]) {
		    if( IDCMPStr[ c ]) {

			FPrintf( Files->Std, IDCMPStr[ c ],
				 wnd->wi_Label, wnd->wi_Label,
				 wnd->wi_Label, wnd->wi_Label );

			if( IDCMPProto[ c ])
			    FPrintf( Files->XDef, IDCMPProto[ c ], wnd->wi_Label );

			if(( IE->C_Prefs & GEN_TEMPLATE ) && ( IDCMPTmp[ c ]))
			    FPrintf( Files->Temp, IDCMPTmp[ c ], wnd->wi_Label );
		    }
		}
	    }

	    FPuts( Files->Std, "\n\t\t}\n\t}\n\treturn( running );\n}\n" );
	}
    }
}
///
/// WriteKeyHandler
void WriteKeyHandler( struct GenFiles *Files, struct IE_Data *IE )
{
    struct WindowInfo  *wnd;
    struct GadgetInfo  *gad;
    UBYTE               ch;

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	if( wnd->wi_NumKeys ) {

	    FPrintf( Files->XDef, "extern BOOL Handle%sKeys( UBYTE, struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );\n", wnd->wi_Label );

	    FPrintf( Files->Std, "\nBOOL Handle%sKeys( UBYTE Code, struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )\n"
				 "{\n"
				 "\tBOOL running = TRUE;\n\n",
		     wnd->wi_Label );

	    if( IE->C_Prefs & TO_LOWER )
		FPuts( Files->Std, "\tswitch( tolower( Code )) {\n" );
	    else
		FPuts( Files->Std, "\tswitch( Code ) {\n" );

	    for( gad = wnd->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
		if(( gad->g_Tags & 1 ) && ( gad->g_Key )) {

		    ch = ( IE->C_Prefs & TO_LOWER ) ? tolower( gad->g_Key ) : gad->g_Key;

		    if(( gad->g_Kind == STRING_KIND ) || ( gad->g_Kind == INTEGER_KIND )) {
			FPrintf( Files->Std, "\n\t\tcase\t'%lc':\n"
					     "\t\t\tif(!( Gadgets[ GD_%s ]->Flags & GFLG_DISABLED ))\n"
					     "\t\t\t\tActivateGadget( Gadgets[ GD_%s ], Wnd, NULL );\n"
					     "\t\t\tbreak;\n",
				 ch, gad->g_Label, gad->g_Label );
		    } else {
			FPrintf( Files->Std, "\n\t\tcase\t'%lc':\n"
					     "\t\t\trunning = %sKeyPressed( Wnd, Gadgets, IE, Msg );\n"
					     "\t\t\tbreak;\n",
				 ch, gad->g_Label );

			FPrintf( Files->XDef, "extern BOOL %sKeyPressed( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );\n", gad->g_Label );

			if( IE->C_Prefs & GEN_TEMPLATE )
			    FPrintf( Files->Temp, "\nBOOL %sKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )\n"
						  "{\n"
						  "\t/*  Routine when \"%s\"'s activation key is pressed  */\n"
						  "\n"
						  "\t/*  ...or return TRUE not to call the gadget function  */\n"
						  "\treturn %sClicked( Wnd, Gadgets, IE );\n"
						  "}\n",
				     gad->g_Label, gad->g_Titolo, gad->g_Label );
		    }
		}
	    }

	    if( wnd->wi_IDCMP & IDCMP_VANILLAKEY )
		FPrintf( Files->Std, "\n\t\tdefault:\n"
				     "\t\t\trunning = %sVanillaKey( Code, Wnd, Gadgets, IE );\n"
				     "\t\t\tbreak;\n",
			 wnd->wi_Label );

	    FPuts( Files->Std, "\n\t}\n\treturn( running );\n}\n" );
	}
    }
}
///
/// WriteClickedPtrs
void WriteClickedPtrs( struct GenFiles *Files, struct IE_Data *IE )
{
    struct WindowInfo  *wnd;
    struct GadgetInfo  *gad;

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	for( gad = wnd->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
	    if(( gad->g_Kind != NUMBER_KIND ) && ( gad->g_Kind != TEXT_KIND )) {

		FPrintf( Files->XDef, "extern BOOL %sClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );\n", gad->g_Label );

		if( IE->C_Prefs & GEN_TEMPLATE )
		    FPrintf( Files->Temp, "\nBOOL %sClicked( struct Window *wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )\n"
					  "{\n"
					  "\t/*  Routine when \"%s\" is clicked  */\n"
					  "\treturn( TRUE );\n"
					  "}\n",
			     gad->g_Label, gad->g_Titolo );
	    }

	}

    }
}
///

// Data & Structures
/// WriteNewGadgets
void WriteNewGadgets( struct GenFiles *Files, struct IE_Data *IE )
{
    struct WindowInfo  *wnd;
    struct GadgetInfo  *gad;
    UBYTE               buffer[256], *or;
    UWORD               c, c2;

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	if( wnd->wi_NumGads - wnd->wi_NumBools ) {

	    FPrintf( Files->XDef, "extern struct NewGadget\t\t%sNGad[];\n", wnd->wi_Label );
	    FPrintf( Files->Std, "\nstruct NewGadget %sNGad[] = {\n\t", wnd->wi_Label );

	    for( gad = wnd->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
		if( gad->g_Kind < BOOLEAN ) {

		    FPrintf( Files->Std, "%ld, %ld, %ld, %ld, ",
			     gad->g_Left - IE->ScreenData->XOffset,
			     gad->g_Top  - IE->ScreenData->YOffset,
			     gad->g_Width, gad->g_Height );

		    if( gad->g_Titolo[0] ) {
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
			} else {
			    or = "";
			}

			c = gad->g_Flags & 0xFFDF;
			if( c ) {
			    strcat( buffer, or );

			    c2 = 0;
			    while(!( c & gadget_flags[ c2 ]))
				c2 += 1;

			    strcat( buffer, GadFlags[ c2 ]);
			}

			FPuts( Files->Std, buffer );
		    } else {
			FPuts( Files->Std, Null );
		    }

		    FPuts( Files->Std, ", NULL, " );

		    if(( IE->C_Prefs & CLICKED ) && ( gad->g_Kind != TEXT_KIND ) && ( gad->g_Kind != NUMBER_KIND ))
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
    }

}
///
/// WriteGadgetTags
void WriteGadgetTags( struct GenFiles *Files, struct IE_Data *IE )
{
    struct WindowInfo  *wnd;
    struct GadgetInfo  *gad;

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	if( wnd->wi_NumGads - wnd->wi_NumBools ) {

	    FPrintf( Files->XDef, "extern ULONG\t\t\t%sGTags[];\n", wnd->wi_Label );
	    FPrintf( Files->Std, "\nULONG %sGTags[] = {\n\t", wnd->wi_Label );

	    for( gad = wnd->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
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
			    if( ((struct LK)(gad->g_Data)).Sel )
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
				FPrintf( Files->Std, "\"%s\", ", ((struct NK)(gad->g_Data)).Format );
			    }
			    if( gad->g_Tags & 2 )
				FPuts( Files->Std, "(GTNM_Border), TRUE, " );
			    if( gad->g_Tags & 4 )
				FPuts( Files->Std, "(GTNM_Clipped), TRUE, " );
			    break;

			case CYCLE_KIND:
			    FPuts( Files->Std, "(GTCY_Labels), (ULONG)&" );
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
    }
}
///
/// WriteITexts
void WriteITexts( struct GenFiles *Files, struct IE_Data *IE )
{
    struct WindowInfo  *wnd;
    struct ITextNode   *txt;
    struct TxtAttrNode *fnt;
    UWORD               x, y, next;

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	if( wnd->wi_NumTexts ) {

	    FPrintf( Files->XDef, "extern struct IntuiText\t\t%sIText[];\n", wnd->wi_Label );
	    FPrintf( Files->Std, "\nstruct IntuiText %sIText[] = {\n", wnd->wi_Label );

	    next = 1;

	    for( txt = wnd->wi_ITexts.mlh_Head; txt->itn_Node.ln_Succ; txt = txt->itn_Node.ln_Succ ) {

		FPrintf( Files->Std, "\t%ld, %ld, %ld, ",
			 txt->itn_FrontPen, txt->itn_BackPen, txt->itn_DrawMode );

		x = txt->itn_LeftEdge - IE->ScreenData->XOffset;
		y = txt->itn_TopEdge - IE->ScreenData->YOffset;

		if( IE->SrcFlags & FONTSENSITIVE ) {
		    x += ( IntuiTextLength(( struct IntuiText * )&txt->itn_FrontPen ) >> 1 );
		    y += ( IE->ScreenData->Screen->RastPort.TxHeight >> 1 );
		}

		FPrintf( Files->Std, "%ld, %ld, ", x, y );

		if( fnt = txt->itn_ITextFont ) {
		    (ULONG)fnt -= sizeof( struct Node );
		    FPrintf( Files->Std, "&%s", fnt->txa_Label );
		} else {
		    FPuts( Files->Std, Null );
		}

		FPuts( Files->Std, ", (UBYTE *)" );

		FPrintf( Files->Std, "\"%s\"", txt->itn_Text );

		if((!( IE->SrcFlags & FONTSENSITIVE )) && ( next != wnd->wi_NumTexts )) {
		    FPrintf( Files->Std, ", &%sIText[%ld],\n", wnd->wi_Label, next );
		    next += 1;
		} else {
		    FPuts( Files->Std, ", NULL,\n" );
		}
	    }

	    Flush( Files->Std );
	    Seek( Files->Std, -2, OFFSET_CURRENT );
	    FPuts( Files->Std, "\n};\n" );

	}
    }
}
///
/// WriteImgStruct
void WriteImgStruct( struct GenFiles *Files, struct IE_Data *IE )
{
    struct ImageNode   *img;

    for( img = IE->Img_List.mlh_Head; img->in_Node.ln_Succ; img = img->in_Node.ln_Succ ) {

	FPrintf( Files->XDef, "extern struct Image\t\t%sImg;\n", img->in_Label );
	FPrintf( Files->Std, "\nstruct Image %sImg = {\n", img->in_Label );

	VFPrintf( Files->Std, "\t%d, %d,\n\t%d, %d, %d,\n\t", &img->in_Left );

	if( img->in_Size )
	    FPrintf( Files->Std, "%sImgData", img->in_Label );
	else
	    FPuts( Files->Std, Null );

	FPrintf( Files->Std, ",\n\t%ld, %ld,\n\t0\n};\n",
		 img->in_PlanePick, img->in_PlaneOnOff );
    }
}
///
/// WriteImageStruct
void WriteImageStruct( struct GenFiles *Files, struct IE_Data *IE )
{
    struct WindowInfo  *wnd;
    struct WndImages   *img;
    UWORD               cnt;

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {

	cnt = 0;

	for( img = wnd->wi_Images.mlh_Head; img->wim_Next; img = img->wim_Next ) {

	    FPrintf( Files->XDef, "extern struct Image\t\t%s_%ldImage;\n", wnd->wi_Label, cnt );
	    FPrintf( Files->Std, "\nstruct Image %s_%ldImage = {\n", wnd->wi_Label, cnt );

	    cnt += 1;

	    FPrintf( Files->Std, "\t%ld, %ld,\n\t%ld, %ld, %ld,\n\t",
		     img->wim_Left - IE->ScreenData->XOffset,
		     img->wim_Top  - IE->ScreenData->YOffset,
		     img->wim_Width, img->wim_Height, img->wim_Depth );

	    if( img->wim_ImageNode->in_Size )
		FPrintf( Files->Std, "%sImgData", img->wim_ImageNode->in_Label );
	    else
		FPuts( Files->Std, Null );

	    FPrintf( Files->Std, ",\n\t%ld, %ld,\n\t",
		     img->wim_PlanePick, img->wim_PlaneOnOff );

	    if( cnt < wnd->wi_NumImages )
		FPrintf( Files->Std, "&%s_%ldImage", wnd->wi_Label, cnt );
	    else
		FPuts( Files->Std, Null );

	    FPuts( Files->Std, "\n};\n" );
	}
    }
}
///
/// WriteWindowTags
void WriteWindowTags( struct GenFiles *Files, struct IE_Data *IE, struct WindowInfo *wnd )
{
    UWORD               w, h;
    ULONG               idcmp;
    static UBYTE WAIdcmp[] = "\n\t\t{ WA_IDCMP, ";

    FPrintf( Files->Std, "\n\tstruct TagItem WTags[] = {\n"
			 "\t\t{ WA_Left, %ld },\n"
			 "\t\t{ WA_Top, %ld },\n",
	     wnd->wi_Left, wnd->wi_Top );

    if( IE->SrcFlags & FONTSENSITIVE ) {
	w = wnd->wi_Width - ( IE->ScreenData->XOffset + IE->ScreenData->Screen->WBorRight  );
	h = wnd->wi_Height - ( IE->ScreenData->YOffset + IE->ScreenData->Screen->WBorBottom );
	FPrintf( Files->Std, "\t\t{ WA_Width, ScaleX( FontX, %ld ) + IE->ScreenData->XOffset + IE->ScreenData->Screen->WBorRight },\n"
			     "\t\t{ WA_Height, ScaleY( FontY, %ld ) + IE->ScreenData->YOffset + IE->ScreenData->Screen->WBorBottom },\n",
		 w, h );
    } else {
	FPrintf( Files->Std, "\t\t{ WA_Width, %ld + IE->ScreenData->XOffset },\n"
			     "\t\t{ WA_Height, %ld + IE->ScreenData->YOffset },\n",
		 wnd->wi_Width - IE->ScreenData->XOffset,
		 wnd->wi_Height - IE->ScreenData->YOffset );
    }

    VFPrintf( Files->Std, "\t\t{ WA_MinWidth, %d },\n"
			  "\t\t{ WA_MaxWidth, %d },\n"
			  "\t\t{ WA_MinHeight, %d },\n"
			  "\t\t{ WA_MaxHeight, %d },",
	      &wnd->wi_MinWidth );

    FPuts( Files->Std, "\n\t\t{ WA_PubScreen, IE->ScreenData->Screen }," );

    if( wnd->wi_Titolo[0] ) {
	FPuts( Files->Std, "\n\t\t{ WA_Title, (ULONG)" );

	FPrintf( Files->Std, "\"%s\"", wnd->wi_Titolo );

	FPuts( Files->Std, " }," );
    }

    if( wnd->wi_Flags ) {
	FPuts( Files->Std, "\n\t\t{ WA_Flags, " );

	for( w = 0; w < WFLAGS_NUM; w++ )
	    if( wnd->wi_Flags & wflgs[ w ]) {
		FPuts( Files->Std, WndFlags[ w ]);
		FPutC( Files->Std, '|' );
	    }

	Flush( Files->Std );
	Seek( Files->Std, -1, OFFSET_CURRENT );
	FPuts( Files->Std, " }," );
    }

    h = FALSE;
    for( w = 0; w < 13; w++ )
	if( wnd->wi_GadTypes[ w ])
	    h = TRUE;

    if( h ) {
	FPuts( Files->Std, WAIdcmp );

	for( w = 0; w < 13; w++ ) {
	    if( wnd->wi_GadTypes[ w ]) {
		FPuts( Files->Std, GadIDCMP[ w ]);
		FPutC( Files->Std, '|' );
	    }
	}

	Flush( Files->Std );
	Seek( Files->Std, -1, OFFSET_CURRENT );
	FPutC( Files->Std, ' ' );
    }

    if( idcmp = wnd->wi_IDCMP ) {

	if(( IE->C_Prefs & KEY_HANDLER ) && ( wnd->wi_NumKeys ))
	    idcmp |= IDCMP_VANILLAKEY;

	if( h ) {
	    Flush( Files->Std );
	    Seek( Files->Std, -1, OFFSET_CURRENT );
	    FPutC( Files->Std, '|' );
	} else {
	    FPuts( Files->Std, WAIdcmp );
	}

	for( w = 0; w < IDCMPS_NUM; w++ ) {
	    if( idcmp & idcmps[ w ]) {
		FPuts( Files->Std, WndIDCMP[ w ]);
		FPutC( Files->Std, '|' );
	    }
	}

	Flush( Files->Std );
	Seek( Files->Std, -1, OFFSET_CURRENT );
	FPutC( Files->Std, ' ' );
    }

    if(( h ) || ( wnd->wi_IDCMP ))
	FPuts( Files->Std, "}," );

    if( wnd->wi_TitoloSchermo[0] ) {
	FPuts( Files->Std, "\n\t\t{ WA_ScreenTitle, (ULONG)" );

	FPrintf( Files->Std, "\"%s\"", wnd->wi_TitoloSchermo );

	FPuts( Files->Std, " }," );
    }

    if( wnd->wi_Tags & W_MOUSEQUEUE )
	VFPrintf( Files->Std, "\n\t\t{ WA_MouseQueue, %d },", &wnd->wi_MouseQueue );

    if( wnd->wi_Tags & W_RPTQUEUE )
	VFPrintf( Files->Std, "\n\t\t{ WA_RptQueue, %d },", &wnd->wi_RptQueue );

    if(!( wnd->wi_Tags & W_AUTOADJUST ))
	FPuts( Files->Std, "\n\t\t{ WA_AutoAdjust, FALSE }," );

    if( wnd->wi_Tags & W_ZOOM )
	FPrintf( Files->Std, "\n\t\t{ WA_Zoom, %sZoom },", wnd->wi_Label );

    if( wnd->wi_flags1 & W_USA_INNER_W )
	VFPrintf( Files->Std, "\n\t\t{ WA_InnerWidth, %d },", &wnd->wi_InnerWidth );

    if( wnd->wi_flags1 & W_USA_INNER_H )
	VFPrintf( Files->Std, "\n\t\t{ WA_InnerHeight, %d },", &wnd->wi_InnerHeight );

    if( wnd->wi_NumGads )
	FPuts( Files->Std, "\n\t\t{ WA_Gadgets, *GList }," );

    if( wnd->wi_Tags & W_TABLETMESSAGE )
	FPuts( Files->Std, "\n\t\t{ WA_TabletMessages, TRUE }," );

    if( wnd->wi_Tags & W_NOTIFYDEPTH )
	FPuts( Files->Std, "\n\t\t{ WA_NotifyDepth, TRUE }," );

    FPuts( Files->Std, "\n\t\t{ TAG_DONE, NULL }\n\t};\n" );
}
///


//  ***  Main Routines  ***
/// OpenFiles
struct GenFiles *OpenFiles( __A0 struct IE_Data *IE, __A1 UBYTE *BaseName )
{
    UBYTE               buffer[1024], buffer2[1024];
    UBYTE              *ptr, *ptr2, *ptr3;
    struct GenFiles    *Files;

    if(!( Files = AllocMem( sizeof( struct GenFiles ), MEMF_CLEAR )))
	return( NULL );

    ptr2 = FilePart( BaseName );

    ptr  = BaseName;
    ptr3 = buffer;
    while( ptr != ptr2 )
	*ptr3++ = *ptr++;

    *ptr3 = '\0';

    ptr = buffer2;
    while(( *ptr2 != '.' ) && ( *ptr2 ))
	*ptr++ = *ptr2++;
    *ptr = '\0';

    AddPart( buffer, buffer2, 1024 );

    strcpy( buffer2, buffer );
    strcat( buffer2, ".c" );

    if(!( Files->Std = Open( buffer2, MODE_NEWFILE )))
	return( NULL );

    strcpy( buffer2, buffer );
    strcat( buffer2, ".h" );
    strcpy( Files->XDefName, buffer2 );

    if(!( Files->XDef = Open( buffer2, MODE_NEWFILE )))
	goto error;


    if( IE->C_Prefs & GEN_TEMPLATE ) {

	strcpy( buffer2, buffer );
	strcat( buffer2, "_temp.c" );

	if(!( Files->Temp = Open( buffer2, MODE_NEWFILE )))
	    goto error;

    }

    return( Files );


error:

    CloseFiles( Files );

    return( NULL );
}
///
/// CloseFiles
void CloseFiles( __A0 struct GenFiles *Files )
{
    if( Files ) {
	if( Files->Std   )  Close( Files->Std   );
	if( Files->Temp  )  Close( Files->Temp  );
	if( Files->XDef  )  Close( Files->XDef  );

	FreeMem( Files, sizeof( struct GenFiles ));
    }
}
///

/// WriteHeaders
BOOL WriteHeaders( __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{

    FPrintf( Files->Std,  Header, LibId, IE->User->Name, IE->User->Number );
    FPrintf( Files->XDef, Header, LibId, IE->User->Name, IE->User->Number );

    if( Files->Temp ) {
	FPrintf( Files->Temp, Header, LibId, IE->User->Name, IE->User->Number );

	FPuts( Files->Temp,
	    "/*\n"
	    "   In this file you'll find empty  template  routines\n"
	    "   referenced in the GUI source.  You  can fill these\n"
	    "   routines with your code or use them as a reference\n"
	    "   to create your main program.\n"
	    "*/\n\n"
	    "#include <stdio.h>\n"
	    "#include <exec/types.h>\n\n" );
    }

    FPuts( Files->Std, "#include <exec/types.h>\n"
		       "#include <exec/nodes.h>\n"
		       "#include <intuition/intuition.h>\n"
		       "#include <intuition/gadgetclass.h>\n"
		       "#include <libraries/gadtools.h>\n"
		       "#include <clib/exec_protos.h>\n"
		       "#include <clib/intuition_protos.h>\n"
		       "#include <clib/gadtools_protos.h>\n"
		       "#include <clib/graphics_protos.h>\n"
		       "#ifdef PRAGMAS\n"
		       "#include <pragmas/exec_pragmas.h>\n"
		       "#include <pragmas/intuition_pragmas.h>\n"
		       "#include <pragmas/graphics_pragmas.h>\n"
		       "#include <pragmas/gadtools_pragmas.h>\n"
		       "#endif\n"
		       "#include <ctype.h>\n"
		       "#include <string.h>\n\n"
		       "#include \"DEV_IE:Include/IEditor.h\"\n\n" );

    FPuts( Files->XDef, "#ifndef EXEC_TYPES_H\n"
			"#include <exec/types.h>\n"
			"#endif\n"
			"#ifndef EXEC_NODES_H\n"
			"#include <exec/nodes.h>\n"
			"#endif\n"
			"#ifndef INTUITION_INTUITION_H\n"
			"#include <intuition/intuition.h>\n"
			"#endif\n"
			"#ifndef INTUITION_GADGETCLASS_H\n"
			"#include <intuition/gadgetclass.h>\n"
			"#endif\n"
			"#ifndef LIBRARIES_GADTOOLS_H\n"
			"#include <libraries/gadtools.h>\n"
			"#endif\n"
			"#ifndef CLIB_EXEC_PROTOS_H\n"
			"#include <clib/exec_protos.h>\n"
			"#endif\n"
			"#ifndef CLIB_INTUITION_PROTOS_H\n"
			"#include <clib/intuition_protos.h>\n"
			"#endif\n"
			"#ifndef CLIB_GADTOOLS_PROTOS_H\n"
			"#include <clib/gadtools_protos.h>\n"
			"#endif\n"
			"#ifndef CLIB_GRAPHICS_PROTOS_H\n"
			"#include <clib/graphics_protos.h>\n"
			"#endif\n"
			"#ifndef CTYPE_H\n"
			"#include <ctype.h>\n"
			"#endif\n"
			"#ifndef STRING_H\n"
			"#include <string.h>\n"
			"#endif\n\n" );



    FPrintf( Files->Std, "#include \"%s\"\n\n", FilePart( Files->XDefName ));


    FPuts( Files->XDef, "#define GetString( g )\t((( struct StringInfo * )g->SpecialInfo )->Buffer  )\n"
			"#define GetNumber( g )\t((( struct StringInfo * )g->SpecialInfo )->LongInt )\n\n"
			"#define WT_LEFT\t\t\t\t0\n"
			"#define WT_TOP\t\t\t\t1\n"
			"#define WT_WIDTH\t\t\t2\n"
			"#define WT_HEIGHT\t\t\t3\n\n" );


    struct WindowInfo  *wnd;
    struct GadgetInfo  *gad;
    int                 cnt;
    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	if( wnd->wi_NumGads - wnd->wi_NumBools ) {
	    cnt = 0;
	    for( gad = wnd->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
		FPrintf( Files->XDef, "#define GD_%s\t\t\t\t\t%ld\n", gad->g_Label, cnt );
		cnt += 1;
	    }
	    FPutC( Files->XDef, 10 );
	}
    }

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	cnt = wnd->wi_NumGads - wnd->wi_NumBools;
	if( cnt )
	    FPrintf( Files->XDef, "#define %s_CNT %ld\n", wnd->wi_Label, cnt );
    }

    FPutC( Files->XDef, 10 );

    return( TRUE );
}
///
/// WriteVars
BOOL WriteVars( __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{
    FPuts( Files->XDef, "extern struct IntuitionBase\t*IntuitionBase;\n"
			"extern struct Library\t\t*GadToolsBase;\n" );

    return( TRUE );
}
///
/// WriteData
BOOL WriteData( __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{
    struct WindowInfo  *wnd;
    struct GadgetInfo  *gad;

    // Gadget Labels

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {

	for( gad = wnd->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {

	    switch( gad->g_Kind ) {

		case LISTVIEW_KIND:
		    WriteList( Files, &gad->g_Scelte, gad->g_Label, gad->g_NumScelte, IE );
		    break;

		case MX_KIND:
		case CYCLE_KIND:

		    struct GadgetScelta *gs;

		    FPrintf( Files->XDef, "extern UBYTE\t\t\t*%sLabels[];\n", gad->g_Label );
		    FPrintf( Files->Std,  "\nUBYTE *%sLabels[] = {\n\t", gad->g_Label );

		    for( gs = gad->g_Scelte.mlh_Head; gs->gs_Node.ln_Succ; gs = gs->gs_Node.ln_Succ )
			FPrintf( Files->Std, "(UBYTE *)\"%s\",\n\t", gs->gs_Testo );

		    FPuts( Files->Std, "NULL\n};\n" );
		    break;
	    }

	}
    }

    // Gadget Types

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	if( wnd->wi_NumGads - wnd->wi_NumBools ) {

	    FPrintf( Files->XDef, "extern UWORD\t\t\t%sGTypes[];\n", wnd->wi_Label );
	    FPrintf( Files->Std, "\nUWORD %sGTypes[] = {\n\t", wnd->wi_Label );

	    for( gad = wnd->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
		if( gad->g_Kind < BOOLEAN ) {
		    FPuts( Files->Std, GadKinds[ gad->g_Kind - 1 ]);
		    FPuts( Files->Std, ",\n\t" );
		}
	    }

	    FPuts( Files->Std, "NULL };\n" );

	}
    }

    // Fonts

    struct TxtAttrNode *fnt;
    for( fnt = IE->FntLst.mlh_Head; fnt->txa_Next; fnt = fnt->txa_Next ) {
	FPrintf( Files->XDef, "extern struct TextAttr\t\t%s;\n", fnt->txa_Label );
	FPrintf( Files->Std, "\nstruct TextAttr %s = {\n"
			     "\t(STRPTR)\"%s\", %ld, 0x%lx, 0x%lx };\n",
		 fnt->txa_Label, fnt->txa_FontName, fnt->txa_Size,
		 fnt->txa_Style, fnt->txa_Flags );
    }


    // NewGadget structures
    WriteNewGadgets( Files, IE );

    // Gadget Tags
    WriteGadgetTags( Files, IE );

    // IntuiTexts
    WriteITexts( Files, IE );

    // Images (used by the GUI)
    WriteImgStruct( Files, IE );

    // Images (in windows)
    WriteImageStruct( Files, IE );

    // Windows' Zoom
    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	if( wnd->wi_Tags & W_ZOOM ) {
	    FPrintf( Files->XDef, "extern UWORD\t\t\t%sZoom[];\n", wnd->wi_Label );
	    FPrintf( Files->Std, "\nUWORD %sZoom[] = { ", wnd->wi_Label );
	    VFPrintf( Files->Std, "%d, %d, %d, %d };\n", &wnd->wi_ZLeft );
	}
    }

    return( TRUE );
}
///
/// WriteChipData
BOOL WriteChipData( __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{
    struct ImageNode   *img;
    UWORD               words, num, *ptr;

    for( img = IE->Img_List.mlh_Head; img->in_Node.ln_Succ; img = img->in_Node.ln_Succ ) {
	if( img->in_Size ) {

	    words = img->in_Size >> 1;

	    FPrintf( Files->Std, "\n%s %sImgData[%ld] = {\n\t",
		     IE->ChipString, img->in_Label, words );

	    FPrintf( Files->XDef, "extern %s %sImgData[%ld];\n",
		     IE->ChipString, img->in_Label, words );

	    ptr = img->in_Data;

	    num = 8;
	    do {

		FPrintf( Files->Std, "0x%04lx", *ptr++ );

		num   -= 1;
		words -= 1;

		if( words ) {

		    FPutC( Files->Std, ',' );

		    if(!( num )) {
			FPuts( Files->Std, "\n\t" );
			num = 8;
		    }
		}

	    } while( words );

	    FPuts( Files->Std, "\n};\n" );

	}
    }

    return( TRUE );
}
///
/// WriteCode
BOOL WriteCode( __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{

    WriteSetupScr( Files, IE );

    WriteOpenWnd( Files, IE );

    WriteRender( Files, IE );

    if( IE->C_Prefs & IDCMP_HANDLER )
	WriteIDCMPHandler( Files, IE );

    if( IE->C_Prefs & KEY_HANDLER )
	WriteKeyHandler( Files, IE );

    FPuts( Files->XDef, "\nextern void CloseWnd( struct Window **Wnd, struct Gadget **GList );\n" );

    if( IE->C_Prefs & CLICKED )
	WriteClickedPtrs( Files, IE );

    return( TRUE );
}
///
/// WriteStrings
BOOL WriteStrings( __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{
    return( TRUE );
}
///

/// Config
void Config( __A0 struct IE_Data *IE )
{
    struct Window  *Wnd = NULL;
    struct Gadget  *GList = NULL, *Gadgets[ Conf_CNT ];
    UBYTE           Back;
    BOOL            ret;

    if( OpenConfWindow( &Wnd, &GList, &Gadgets[0], IE )) {

	(*IE->Functions->Status)( "Cannot open my window!", TRUE, 0 );

    } else {

	Back = IE->C_Prefs;

	IE->C_Prefs = ~IE->C_Prefs;
	TemplateKeyPressed( Wnd, Gadgets, IE );
	ClickKeyPressed( Wnd, Gadgets, IE );
	HandlerKeyPressed( Wnd, Gadgets, IE );
	KeyHandlerKeyPressed( Wnd, Gadgets, IE );
	ToLowerKeyPressed( Wnd, Gadgets, IE );

	IE->C_Prefs = Back;

	GT_SetGadgetAttrs( Gadgets[ GD_Chip ], Wnd, NULL,
			   GTST_String, IE->ChipString, TAG_END );

	do {
	    WaitPort( Wnd->UserPort );
	    ret = HandleConfIDCMP( Wnd, &Gadgets[0], IE );
	} while ( ret == 0 );

	if( ret > 0 ) {
	    IE->C_Prefs = Back;
	} else {
	    strcpy( IE->ChipString, GetString( Gadgets[ GD_Chip ] ));
	}

    }

    CloseWnd( &Wnd, &GList );
}


BOOL ClickKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )
{
	/*  Routine when "Clicked _Ptr  "'s activation key is pressed  */

    CheckedTag[1] = ( IE->C_Prefs & CLICKED ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( Gadgets[ GD_Click ], Wnd,
			NULL, (struct TagItem *)CheckedTag );

	/*  ...or return TRUE not to call the gadget function  */
	return ClickClicked( Wnd, Gadgets, IE );
}

BOOL OkKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )
{
	/*  Routine when "_Ok"'s activation key is pressed  */

	/*  ...or return TRUE not to call the gadget function  */
	return OkClicked( Wnd, Gadgets, IE );
}

BOOL CancKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )
{
	/*  Routine when "_Cancel"'s activation key is pressed  */

	/*  ...or return TRUE not to call the gadget function  */
	return CancClicked( Wnd, Gadgets, IE );
}

BOOL HandlerKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )
{
	/*  Routine when "IDCMP _Handler"'s activation key is pressed  */

    CheckedTag[1] = ( IE->C_Prefs & IDCMP_HANDLER ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( Gadgets[ GD_Handler ], Wnd,
			NULL, (struct TagItem *)CheckedTag );

	/*  ...or return TRUE not to call the gadget function  */
	return HandlerClicked( Wnd, Gadgets, IE );
}

BOOL KeyHandlerKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )
{
	/*  Routine when "_Key Handler  "'s activation key is pressed  */

    CheckedTag[1] = ( IE->C_Prefs & KEY_HANDLER ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( Gadgets[ GD_KeyHandler ], Wnd,
			NULL, (struct TagItem *)CheckedTag );

	/*  ...or return TRUE not to call the gadget function  */
	return KeyHandlerClicked( Wnd, Gadgets, IE );
}

BOOL TemplateKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )
{
	/*  Routine when "_Template     "'s activation key is pressed  */
    CheckedTag[1] = ( IE->C_Prefs & GEN_TEMPLATE ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( Gadgets[ GD_Template ], Wnd,
			NULL, (struct TagItem *)CheckedTag );

	/*  ...or return TRUE not to call the gadget function  */
	return TemplateClicked( Wnd, Gadgets, IE );
}

BOOL ToLowerKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )
{
	/*  Routine when "To Lo_wer     "'s activation key is pressed  */
    CheckedTag[1] = ( IE->C_Prefs & TO_LOWER ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( Gadgets[ GD_ToLower ], Wnd,
			NULL, (struct TagItem *)CheckedTag );

	/*  ...or return TRUE not to call the gadget function  */
	return ToLowerClicked( Wnd, Gadgets, IE );
}

BOOL ClickClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )
{
	/*  Routine when "Clicked _Ptr  " is clicked  */

	IE->C_Prefs ^= CLICKED;

	return( 0 );
}

BOOL OkClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )
{
	/*  Routine when "_Ok" is clicked  */
	return( -1 );
}

BOOL CancClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )
{
	/*  Routine when "_Cancel" is clicked  */
	return( 1 );
}

BOOL HandlerClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )
{
	/*  Routine when "IDCMP _Handler" is clicked  */

	IE->C_Prefs ^= IDCMP_HANDLER;

	if( IE->C_Prefs & IDCMP_HANDLER ) {

	    IE->C_Prefs &= ~( CLICKED | INTUIMSG );

	    ClickKeyPressed( Wnd, Gadgets, IE );
	}

	return( 0 );
}

BOOL KeyHandlerClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )
{
	/*  Routine when "_Key Handler  " is clicked  */

	IE->C_Prefs ^= KEY_HANDLER;

	if( IE->C_Prefs & KEY_HANDLER ) {

	    IE->C_Prefs &= ~( CLICKED | INTUIMSG );

	    ClickKeyPressed( Wnd, Gadgets, IE );
	}

	return( 0 );
}

BOOL TemplateClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )
{
	/*  Routine when "_Template     " is clicked  */

	IE->C_Prefs ^= GEN_TEMPLATE;

	return( 0 );
}

BOOL ToLowerClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )
{
	/*  Routine when "To Lo_wer     " is clicked  */

	IE->C_Prefs ^= TO_LOWER;

	return( 0 );
}

BOOL ChipClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )
{
	/*  Routine when "_UWORD chip:" is clicked  */
	return( 0 );
}                
///
