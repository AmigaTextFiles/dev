/// Includes
#define INTUI_V36_NAMES_ONLY

#include <exec/types.h>                 // exec
#include <exec/lists.h>
#include <exec/memory.h>
#include <exec/nodes.h>
#include <dos/dos.h>                    // dos
#include <dos/dostags.h>
#include <intuition/intuition.h>        // intuition
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
/// Data
static UBYTE VanillaTmp[] = "\nBOOL %sVanillaKey( void )\n"
			    "{\n"
			    "\t/*  Routine for IDCMP_VANILLAKEY  */\n"
			    "\treturn( TRUE );\n"
			    "}\n";

ULONG IDCMPVer[] = { IDCMP_MENUVERIFY, IDCMP_REQVERIFY, IDCMP_SIZEVERIFY };

UBYTE *IDCMPVerStr[] = {
    "\n\t\tif( class == IDCMP_MENUVERIFY )\n\t\t\trunning = %sMenuVerify();\n",
    "\n\t\tif( class == IDCMP_REQVERIFY )\n\t\t\trunning = %sReqVerify();\n",
    "\n\t\tif( class == IDCMP_SIZEVERIFY )\n\t\t\trunning = %sSizeVerify();\n"
};

UBYTE *IDCMPVerProto[] = {
    "extern BOOL %sMenuVerify( void );\n",
    "extern BOOL %sReqVerify( void );\n",
    "extern BOOL %sSizeVerify( void );\n"
};

UBYTE *IDCMPVerTmp[] = {
    "\nBOOL %sMenuVerify( void )\n"
    "{\n"
    "\t/*  Routine for IDCMP_MENUVERIFY  */\n"
    "\treturn( TRUE );\n"
    "}\n", // ---
    "\nBOOL %sReqVerify( void )\n"
    "{\n"
    "\t/*  Routine for IDCMP_REQVERIFY  */\n"
    "\treturn( TRUE );\n"
    "}\n", // ---
    "\nBOOL %sSizeVerify( void )\n"
    "{\n"
    "\t/*  Routine for IDCMP_SIZEVERIFY  */\n"
    "\treturn( TRUE );\n"
    "}\n",
};

UBYTE CaseRefresh[] = "\n\t\t\tcase\tIDCMP_REFRESHWINDOW:\n"
			     "\t\t\t\tGT_BeginRefresh( %sWnd );\n"
			     "\t\t\t\tGT_EndRefresh( %sWnd, TRUE );\n"
			     "\t\t\t\tbreak;\n";

UBYTE CaseRefresh2[] = "\n\t\t\tcase\tIDCMP_REFRESHWINDOW:\n"
			      "\t\t\t\tGT_BeginRefresh( %sWnd );\n"
			      "\t\t\t\t%sRender();\n"
			      "\t\t\t\tGT_EndRefresh( %sWnd, TRUE );\n"
			      "\t\t\t\tbreak;\n";

UBYTE *IDCMPStr[] = {
    NULL,
    "\n\t\t\tcase\tIDCMP_NEWSIZE:\n"
    "\t\t\t\trunning = %sNewSize();\n"
    "\t\t\t\tbreak;\n",

    CaseRefresh,

    "\n\t\t\tcase\tIDCMP_MOUSEBUTTONS:\n"
    "\t\t\t\trunning = %sMouseButtons();\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_MOUSEMOVE:\n"
    "\t\t\t\trunning = %sMouseMove();\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_GADGETDOWN:\n"
    "\t\t\t\tfunc = (( struct Gadget * )%sMsg.IAddress )->UserData;\n"
    "\t\t\t\trunning = (*func)();\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_GADGETUP:\n"
    "\t\t\t\tfunc = (( struct Gadget * )%sMsg.IAddress )->UserData;\n"
    "\t\t\t\trunning = (*func)();\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_REQSET:\n"
    "\t\t\t\trunning = %sReqSet();\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_MENUPICK:\n"
    "\t\t\t\twhile( %sMsg.Code != MENUNULL ) {\n"
    "\t\t\t\t\tn = ItemAddress( %sMenus, %sMsg.Code );\n"
    "\t\t\t\t\tfunc = (GTMENUITEM_USERDATA( n ));\n"
    "\t\t\t\t\trunning = (*func)();\n"
    "\t\t\t\t\t%sMsg.Code = n->NextSelect;\n"
    "\t\t\t\t}\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_CLOSEWINDOW:\n"
    "\t\t\t\trunning = %sCloseWindow();\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_RAWKEY:\n"
    "\t\t\t\trunning = %sRawKey();\n"
    "\t\t\t\tbreak;\n",

    NULL,

    "\n\t\t\tcase\tIDCMP_REQCLEAR:\n"
    "\t\t\t\trunning = %sReqClear();\n"
    "\t\t\t\tbreak;\n",

    NULL,

    "\n\t\t\tcase\tIDCMP_NEWPREFS:\n"
    "\t\t\t\trunning = %sNewPrefs();\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_DISKINSERTED:\n"
    "\t\t\t\trunning = %sDiskInserted();\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_DISKREMOVED:\n"
    "\t\t\t\trunning = %sDiskRemoved();\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_WBENCHMESSAGE:\n"
    "\t\t\t\trunning = %sWBenchMessage();\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_ACTIVEWINDOW:\n"
    "\t\t\t\trunning = %sActiveWindow();\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_INACTIVEWINDOW:\n"
    "\t\t\t\trunning = %sInactiveWindow();\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_DELTAMOVE:\n"
    "\t\t\t\trunning = %sDeltaMove();\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_VANILLAKEY:\n"
    "\t\t\t\trunning = %sVanillaKey();\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_INTUITICKS:\n"
    "\t\t\t\trunning = %sIntuiTicks();\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_IDCMPUPDATE:\n"
    "\t\t\t\trunning = %sIDCMPUpdate();\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_MENUHELP:\n"
    "\t\t\t\trunning = %sMenuHelp();\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_CHANGEWINDOW:\n"
    "\t\t\t\trunning = %sChangeWindow();\n"
    "\t\t\t\tbreak;\n",

    "\n\t\t\tcase\tIDCMP_GADGETHELP:\n"
    "\t\t\t\trunning = %sGadgetHelp();\n"
    "\t\t\t\tbreak;\n"
};

UBYTE *IDCMPProto[] = {
    NULL,
    "extern BOOL %sNewSize( void );\n",
    NULL,
    "extern BOOL %sMouseButtons( void );\n",
    "extern BOOL %sMouseMove( void );\n",
    NULL,
    NULL,
    "extern BOOL %sReqSet( void );\n",
    NULL,
    "extern BOOL %sCloseWindow( void );\n",
    "extern BOOL %sRawKey( void );\n",
    NULL,
    "extern BOOL %sReqClear( void );\n",
    NULL,
    "extern BOOL %sNewPrefs( void );\n",
    "extern BOOL %sDiskInserted( void );\n",
    "extern BOOL %sDiskRemoved( void );\n",
    "extern BOOL %sWBenchMessage( void );\n",
    "extern BOOL %sActiveWindow( void );\n",
    "extern BOOL %sInactiveWindow( void );\n",
    "extern BOOL %sDeltaMove( void );\n",
    "extern BOOL %sVanillaKey( void );\n",
    "extern BOOL %sIntuiTicks( void );\n",
    "extern BOOL %sIDCMPUpdate( void );\n",
    "extern BOOL %sMenuHelp( void );\n",
    "extern BOOL %sChangeWindow( void );\n",
    "extern BOOL %sGadgetHelp( void );\n"
};

UBYTE *IDCMPTmp[] = {
    NULL,
    "\nBOOL %sNewSize( void )\n"
    "{\n"
    "\t/*  Routine for IDCMP_NEWSIZE  */\n"
    "\treturn( TRUE );\n"
    "}\n",
    NULL,
    "\nBOOL %sMouseButtons( void )\n"
    "{\n"
    "\t/*  Routine for IDCMP_MOUSEBUTTONS  */\n"
    "\treturn( TRUE );\n"
    "}\n",

    "\nBOOL %sMouseMove( void )\n"
    "{\n"
    "\t/*  Routine for IDCMP_MOUSEMOVE  */\n"
    "\treturn( TRUE );\n"
    "}\n",

    NULL,
    NULL,
    "\nBOOL %sReqSet( void )\n"
    "{\n"
    "\t/*  Routine for IDCMP_REQSET  */\n"
    "\treturn( TRUE );\n"
    "}\n",
    NULL,
    "\nBOOL %sCloseWindow( void )\n"
    "{\n"
    "\t/*  Routine for IDCMP_CLOSEWINDOW  */\n"
    "\t/*  Return FALSE to quit, I suppose... ;)  */\n"
    "\treturn( FALSE );\n"
    "}\n",

    "\nBOOL %sRawKey( void )\n"
    "{\n"
    "\t/*  Routine for IDCMP_RAWKEY  */\n"
    "\treturn( TRUE );\n"
    "}\n",

    NULL,
    "\nBOOL %sReqClear( void )\n"
    "{\n"
    "\t/*  Routine for IDCMP_REQCLEAR  */\n"
    "\treturn( TRUE );\n"
    "}\n",
    NULL,
    "\nBOOL %sNewPrefs( void )\n"
    "{\n"
    "\t/*  Routine for IDCMP_NEWPREFS  */\n"
    "\treturn( TRUE );\n"
    "}\n",

    "\nBOOL %sDiskInserted( void )\n"
    "{\n"
    "\t/*  Routine for IDCMP_DISKINSERTED  */\n"
    "\treturn( TRUE );\n"
    "}\n",

    "\nBOOL %sDiskRemoved( void )\n"
    "{\n"
    "\t/*  Routine for IDCMP_DISKREMOVED  */\n"
    "\treturn( TRUE );\n"
    "}\n",

    "\nBOOL %sWBenchMessage( void )\n"
    "{\n"
    "\t/*  Routine for IDCMP_WBENCHMESSAGE  */\n"
    "\treturn( TRUE );\n"
    "}\n",

    "\nBOOL %sActiveWindow( void )\n"
    "{\n"
    "\t/*  Routine for IDCMP_ACTIVEWINDOW  */\n"
    "\treturn( TRUE );\n"
    "}\n",

    "\nBOOL %sInactiveWindow( void )\n"
    "{\n"
    "\t/*  Routine for IDCMP_INACTIVEWINDOW  */\n"
    "\treturn( TRUE );\n"
    "}\n",

    "\nBOOL %sDeltaMove( void )\n"
    "{\n"
    "\t/*  Routine for IDCMP_DELTAMOVE  */\n"
    "\treturn( TRUE );\n"
    "}\n",

    "\nBOOL %sVanillaKey( void )\n"
    "{\n"
    "\t/*  Routine for IDCMP_VANILLAKEY  */\n"
    "\treturn( TRUE );\n"
    "}\n",

    "\nBOOL %sIntuiTicks( void )\n"
    "{\n"
    "\t/*  Routine for IDCMP_INTUITICKS  */\n"
    "\treturn( TRUE );\n"
    "}\n",

    "\nBOOL %sIDCMPUpdate( void )\n"
    "{\n"
    "\t/*  Routine for IDCMP_IDCMPUPDATE  */\n"
    "\treturn( TRUE );\n"
    "}\n",

    "\nBOOL %sMenuHelp( void )\n"
    "{\n"
    "\t/*  Routine for IDCMP_MENUHELP  */\n"
    "\treturn( TRUE );\n"
    "}\n",

    "\nBOOL %sChangeWindow( void )\n"
    "{\n"
    "\t/*  Routine for IDCMP_CHANGEWINDOW  */\n"
    "\treturn( TRUE );\n"
    "}\n",

    "\nBOOL %sGadgetHelp( void )\n"
    "{\n"
    "\t/*  Routine for IDCMP_GADGETHELP  */\n"
    "\treturn( TRUE );\n"
    "}\n"
};
///



/// WriteIDCMPHandler
void WriteIDCMPHandler( struct GenFiles *Files, struct IE_Data *IE )
{
    struct WindowInfo  *wnd;
    UWORD               c;
    ULONG               idcmp;


    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	if( wnd->wi_IDCMP ) {

	    FPrintf( Files->XDef, "extern LONG Handle%sIDCMP( void );\n", wnd->wi_Label );

	    FPrintf( Files->Std, "\nLONG Handle%sIDCMP( void )\n"
				 "{\n",
		     wnd->wi_Label );

	    if(!(( IE->SrcFlags & SHARED_PORT ) && ( wnd->wi_Tags & W_SHARED_PORT )))
		FPuts( Files->Std, "\tstruct IntuiMessage\t*m;\n" );

	    if( wnd->wi_IDCMP & IDCMP_MENUPICK )
		FPuts( Files->Std, "\tstruct MenuItem\t\t*n;\n" );

	    FPuts( Files->Std, "\tBOOL\t\t\t(*func)(void);\n"
			       "\tBOOL\t\t\trunning = TRUE;\n"
			       "\tint\t\t\tclass;\n"
			       "\n" );

	    if(!(( IE->SrcFlags & SHARED_PORT ) && ( wnd->wi_Tags & W_SHARED_PORT )))
		FPrintf( Files->Std, "\twhile( m = GT_GetIMsg( %sWnd->UserPort )) {\n\n"
				     "\t\tCopyMem((char *)m, (char *)&%sMsg, (long)sizeof( struct IntuiMessage ));\n\n",
			 wnd->wi_Label, wnd->wi_Label );
	    else
		FPrintf( Files->Std, "#define\t%sMsg IDCMPMsg\n\n", wnd->wi_Label );

	    FPrintf( Files->Std, "\t\tclass = %sMsg.Class;\n", wnd->wi_Label );

	    IE->win_info = wnd;

	    idcmp = ( *IE->IEXSrcFun->IDCMP )( wnd->wi_IDCMP );

	    for( c = 0; c < 3; c++ ) {
		if( idcmp & IDCMPVer[ c ]) {
		    FPrintf( Files->XDef, IDCMPVerProto[ c ], wnd->wi_Label );
		    FPrintf( Files->Std, IDCMPVerStr[ c ], wnd->wi_Label );
		    if( Prefs.Flags & GEN_TEMPLATE )
			FPrintf( Files->Temp, IDCMPVerTmp[ c ], wnd->wi_Label );
		}
	    }

	    if(!(( IE->SrcFlags & SHARED_PORT ) && ( wnd->wi_Tags & W_SHARED_PORT )))
		FPuts( Files->Std, "\n\t\tGT_ReplyIMsg( m );\n\n" );

	    FPuts( Files->Std, "\t\tswitch( class ) {\n" );

	    if(( idcmp & IDCMP_GADGETUP ) && ( idcmp & IDCMP_GADGETDOWN )) {
		idcmp &= ~( IDCMP_GADGETUP | IDCMP_GADGETDOWN );
		FPrintf( Files->Std, "\n\t\t\tcase\tIDCMP_GADGETUP:\n"
				     "\t\t\tcase\tIDCMP_GADGETDOWN:\n"
				     "\t\t\t\tfunc = (( struct Gadget * )%sMsg.IAddress )->UserData;\n"
				     "\t\t\t\trunning = (*func)();\n"
				     "\t\t\t\tbreak;\n",
			 wnd->wi_Label );
	    }

	    if(( Prefs.Flags & KEY_HANDLER ) && ( wnd->wi_NumKeys )) {

		FPrintf( Files->Std, "\n\t\t\tcase\tIDCMP_VANILLAKEY:\n"
				     "\t\t\t\trunning = Handle%sKeys();\n"
				     "\t\t\t\tbreak;\n",
			 wnd->wi_Label );

		if( idcmp & IDCMP_VANILLAKEY ) {
		    idcmp &= ~IDCMP_VANILLAKEY;
		    FPrintf( Files->XDef, "extern BOOL %sVanillaKey( void );\n", wnd->wi_Label );
		    if( Prefs.Flags & GEN_TEMPLATE )
			FPrintf( Files->Temp, VanillaTmp, wnd->wi_Label );
		}
	    }

	    IDCMPStr[2] = wnd->wi_NeedRender ? &CaseRefresh2[0] : &CaseRefresh[0];

	    for( c = 0; c < IDCMPS_NUM; c++ ) {

		if( idcmp & idcmps[ c ]) {
		    if( IDCMPStr[ c ]) {

			FPrintf( Files->Std, IDCMPStr[ c ],
				 wnd->wi_Label, wnd->wi_Label,
				 wnd->wi_Label, wnd->wi_Label );

			if( IDCMPProto[ c ])
			    FPrintf( Files->XDef, IDCMPProto[ c ], wnd->wi_Label );

			if(( Prefs.Flags & GEN_TEMPLATE ) && ( IDCMPTmp[ c ]))
			    FPrintf( Files->Temp, IDCMPTmp[ c ], wnd->wi_Label );
		    }
		}
	    }

	    if(!(( IE->SrcFlags & SHARED_PORT ) && ( wnd->wi_Tags & W_SHARED_PORT )))
		FPuts( Files->Std, "\n\t\t}" );

	    FPuts( Files->Std, "\n\t}\n\treturn( running );\n}\n" );
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

	    FPrintf( Files->XDef, "extern BOOL Handle%sKeys( void );\n", wnd->wi_Label );

	    FPrintf( Files->Std, "\nBOOL Handle%sKeys( void )\n"
				 "{\n"
				 "\tBOOL running = TRUE;\n\n",
		     wnd->wi_Label );

	    if(!(( IE->SrcFlags & LOCALIZE ) && ( wnd->wi_Tags & W_LOC_GADGETS ))) {
		if( Prefs.Flags & TO_LOWER )
		    FPrintf( Files->Std, "\tswitch( tolower( %sMsg.Code )) {\n", wnd->wi_Label );
		else
		    FPrintf( Files->Std, "\tswitch( %sMsg.Code ) {\n", wnd->wi_Label );
	    } else {
		FPuts( Files->Std, "\tUBYTE ch = " );
		if( Prefs.Flags & TO_LOWER )
		    FPrintf( Files->Std, "tolower( %sMsg.Code );\n", wnd->wi_Label );
		else
		    FPrintf( Files->Std, "%sMsg.Code;\n", wnd->wi_Label );
	    }

	    for( gad = wnd->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
		if( gad->g_flags2 & G_KEYPRESSED ) {


		    if(( IE->SrcFlags & LOCALIZE ) && ( wnd->wi_Tags & W_LOC_GADGETS )) {
			if( Prefs.Flags & TO_LOWER )
			    FPrintf( Files->Std, "\n\tif( ch == tolower( GetActivationKey( %sNGad[ GD_%s ].ng_GadgetText ))) {\n",
				     wnd->wi_Label, gad->g_Label );
			else
			    FPrintf( Files->Std, "\n\tif( ch == GetActivationKey( %sNGad[ GD_%s ].ng_GadgetText )) {\n",
				     wnd->wi_Label, gad->g_Label );
		    } else {
			ch = ( Prefs.Flags & TO_LOWER ) ? tolower( gad->g_Key ) : gad->g_Key;
			FPrintf( Files->Std, "\n\t\tcase\t'%lc':\n", ch );
		    }


		    if(( gad->g_Kind == STRING_KIND ) || ( gad->g_Kind == INTEGER_KIND )) {
			FPrintf( Files->Std, "\t\t\tif(!( %sGadgets[ GD_%s ]->Flags & GFLG_DISABLED ))\n"
					     "\t\t\t\tActivateGadget( %sGadgets[ GD_%s ], %sWnd, NULL );\n",
				 wnd->wi_Label, gad->g_Label, wnd->wi_Label, gad->g_Label, wnd->wi_Label );
		    } else {

			if(( IE->SrcFlags & LOCALIZE ) && ( wnd->wi_Tags & W_LOC_GADGETS )) {
			    if(( Prefs.MoreFlags & NO_BUTTON_KP ) && ( gad->g_Kind == BUTTON_KIND ))
				FPrintf( Files->Std, "\t\treturn( %sClicked() );\n",
					 gad->g_Label );
			    else
				FPrintf( Files->Std, "\t\treturn( %sKeyPressed() );\n",
					 gad->g_Label );
			} else {
			    if(( Prefs.MoreFlags & NO_BUTTON_KP ) && ( gad->g_Kind == BUTTON_KIND ))
				FPrintf( Files->Std, "\t\t\trunning = %sClicked();\n",
					 gad->g_Label );
			    else
				FPrintf( Files->Std, "\t\t\trunning = %sKeyPressed();\n",
					 gad->g_Label );
			}

			if(!(( Prefs.MoreFlags & NO_BUTTON_KP ) && ( gad->g_Kind == BUTTON_KIND ))) {
			    FPrintf( Files->XDef, "extern BOOL %sKeyPressed( void );\n", gad->g_Label );

			    if( Prefs.Flags & GEN_TEMPLATE )
				if(!( Prefs.Flags & ONLY_NEW_TMP ) || (!( gad->g_flags2 & G_NO_TEMPLATE )))
				    FPrintf( Files->Temp, "\nBOOL %sKeyPressed( void )\n"
							  "{\n"
							  "\t/*  Routine when \"%s\"'s activation key is pressed  */\n"
							  "\n"
							  "\t/*  ...or return TRUE not to call the gadget function  */\n"
							  "\treturn %sClicked();\n"
							  "}\n",
					     gad->g_Label, gad->g_Titolo, gad->g_Label );
			}
		    }

		    if(( IE->SrcFlags & LOCALIZE ) && ( wnd->wi_Tags & W_LOC_GADGETS ))
			FPuts( Files->Std, "\t}\n" );
		    else
			FPuts( Files->Std, "\t\tbreak;\n" );
		}
	    }

	    if( wnd->wi_IDCMP & IDCMP_VANILLAKEY )
		if(( IE->SrcFlags & LOCALIZE ) && ( wnd->wi_Tags & W_LOC_GADGETS ))
		    FPrintf( Files->Std, "\n\trunning = %sVanillaKey();\n",
			     wnd->wi_Label );
		else
		    FPrintf( Files->Std, "\n\t\tdefault:\n"
					 "\t\t\trunning = %sVanillaKey();\n"
					 "\t\t\tbreak;\n",
			     wnd->wi_Label );

	    if(!(( IE->SrcFlags & LOCALIZE ) && ( wnd->wi_Tags & W_LOC_GADGETS )))
		FPuts( Files->Std, "\n\t}" ); /* end Select */

	    FPuts( Files->Std, "\n\treturn( running );\n}\n" );
	}
    }
}
///
/// WriteClickedPtrs
void WriteClickedPtrs( struct GenFiles *Files, struct IE_Data *IE )
{
    struct WindowInfo  *wnd;

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	struct GadgetBank  *bank;

	WriteClicked( Files, IE, &wnd->wi_Gadgets );

	for( bank = wnd->wi_GBanks.mlh_Head; bank->Node.ln_Succ; bank = bank->Node.ln_Succ )
	    WriteClicked( Files, IE, &bank->Storage );
    }
}
///
/// WriteClicked
void WriteClicked( struct GenFiles *Files, struct IE_Data *IE, struct MinList *Gadgets )
{
    struct GadgetInfo  *gad;

    for( gad = Gadgets->mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
	if( gad->g_flags2 & G_CLICKED ) {

	    FPrintf( Files->XDef, "extern BOOL %sClicked( void );\n", gad->g_Label );

	    if( Prefs.Flags & GEN_TEMPLATE ) {
		if((!( Prefs.Flags & ONLY_NEW_TMP )) || (!( gad->g_flags2 & G_NO_TEMPLATE )))
		    FPrintf( Files->Temp, "\nBOOL %sClicked( void )\n"
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

