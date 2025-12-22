/// Includes
#define INTUI_V36_NAMES_ONLY

#include <exec/nodes.h>                 // exec
#include <exec/lists.h>
#include <exec/types.h>
#include <dos/dos.h>                    // dos
#include <dos/dostags.h>
#include <intuition/intuition.h>        // intuition
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


/// WriteMain
void WriteMain( struct GenFiles *Files, struct IE_Data *IE )
{
    struct LibNode     *lib;
    struct WndToOpen   *wto;
    BOOL               bool;

    FPrintf( Files->Main,
	"#define INTUI_V36_NAMES_ONLY\n\n"
	"#include <dos/dos.h>\n"
	"#include <exec/libraries.h>\n"
	"#include <clib/exec_protos.h>\n"
	"#include <clib/dos_protos.h>\n\n"
	"#include <stdio.h>\n"
	"#include <stdlib.h>\n"
	"#include <string.h>\n"
	"#include <errno.h>\n\n"
	"#include \"%s\"\n"
	"int    main( void );\n"
	"void   OpenLibs( void );\n"
	"void   Setup( void );\n"
	"void   CloseLibs( void );\n"
	"void   CloseAll( void );\n"
	"void   PlayTheGame( void );\n"
	"void   Error( STRPTR, STRPTR );\n"
	"void   End( ULONG );\n",
	FilePart( Files->XDefName ));

    if( IE->MainProcFlags & MAIN_WB )
	FPuts( Files->Main, "int    wbmain( struct WBStartup * );\n" );

    if( IE->ExtraProc[0] ) {
	FPrintf( Files->Main, "extern void %s( void );\n", IE->ExtraProc );

	if( Prefs.Flags & GEN_TEMPLATE ) {
	    FPrintf( Files->Temp,
		"void %s( void )\n"
		"{\n"
		"\t/*  ...Initialization Stuff...  */\n"
		"}\n",
		IE->ExtraProc );
	}
    }

    if( IE->MainProcFlags & MAIN_OTHERBITS ) {
	FPuts( Files->Main, "extern BOOL HandleOtherSignals( void );\n" );

	if( Prefs.Flags & GEN_TEMPLATE ) {
	    FPuts( Files->Temp,
		"BOOL HandleOtherSignals( void )\n"
		"{\n"
		"\t/*  Routine to handle other signals  */\n"
		"\treturn( TRUE );\n"
		"}\n" );
	}
    }

    FPuts( Files->Main,
	"\nBOOL\t\t\tOk_to_Run = TRUE;\n"
	"ULONG\t\t\tmask = NULL;\n\n"
	"extern struct Library\t*SysBase;\n"
	"extern struct Library\t*DOSBase;\n" );

    if( IE->MainProcFlags & MAIN_WB )
	FPuts( Files->Main, "struct WBStartup\t\t*WBMsg = NULL;\n" );

    for( lib = IE->Libs_List.mlh_Head; lib->lbn_Node.ln_Succ; lib = lib->lbn_Node.ln_Succ )
	FPrintf( Files->Main, "struct Library\t\t*%s = NULL;\n", lib->lbn_Base );


    FPuts( Files->Main,
	"\n#include \"IE_Errors.h\"\n"
	"\nint main( void )\n"
	"{\n"
	"\tOpenLibs();\n"
	"\tSetup();\n" );

    if( IE->ExtraProc[0] )
	FPrintf( Files->Main, "\t%s();\n", IE->ExtraProc );

    FPuts( Files->Main,
	"\tPlayTheGame();\n"
	"\tEnd( RETURN_OK );\n"
	"}\n\n"
	"void End( ULONG RetCode )\n"
	"{\n"
	"\tCloseAll();\n"
	"\tCloseLibs();\n"
	"\texit( RetCode );\n"
	"}\n\n"
	"void OpenLibs( void )\n"
	"{\n" );

    for( lib = IE->Libs_List.mlh_Head; lib->lbn_Node.ln_Succ; lib = lib->lbn_Node.ln_Succ ) {
	if ( lib->lbn_Node.ln_Pri & L_FAIL )
	    FPrintf( Files->Main,
		     "\tif (!( %s = OpenLibrary( \"%s\", %ld )))\n"
		     "\t\tError( ErrStrings[ OPEN_LIB ], \"%s\" );\n",
		     lib->lbn_Base, lib->lbn_Name, lib->lbn_Version, lib->lbn_Name );
	else
	    FPrintf( Files->Main,
		     "\t%s = OpenLibrary( \"%s\", %ld );\n",
		     lib->lbn_Base, lib->lbn_Name, lib->lbn_Version );
    }

    FPuts( Files->Main,
	   "}\n\n"
	   "void Setup( void )\n"
	   "{\n"
	   "\tULONG\t\tret;\n" );

    if( IE->SrcFlags & OPENDISKFONT ) {
	struct TxtAttrNode *fnt;

	bool = FALSE;
	for( fnt = IE->FntLst.mlh_Head; fnt->txa_Next; fnt = fnt->txa_Next )
	    if( fnt->txa_Flags & FPB_DISKFONT )
		bool = TRUE;

	if( bool )
	    FPuts( Files->Main,
		   "\tif (!( OpenDiskFonts()))\n"
		   "\t\tError( ErrStrings[ OPEN_FONTS ], NULL );\n" );
    }

    if( IE->SrcFlags & LOCALIZE )
	FPuts( Files->Main, "\tSetupLocale();\n" );

    FPuts( Files->Main,
	   "\tif ( ret = SetupScreen())\n"
	   "\t\tError( ErrStrings[ SETUP_SCR ], ErrStrings[ SETUP_SCR+ret ]);\n" );

    for( wto = IE->WndTO_List.mlh_Head; wto->wto_Node.ln_Succ; wto = wto->wto_Node.ln_Succ )
	FPrintf( Files->Main,
		 "\tif ( ret = Open%sWindow())\n"
		 "\t\tError( ErrStrings[ OPEN_WND ], ErrStrings[ OPEN_WND+ret ]);\n",
		 wto->wto_Label );

    if( IE->NumRexxs )
	FPuts( Files->Main, "\tSetupRexxPort();\n" );

    FPuts( Files->Main,
	   "}\n\n"
	   "void CloseAll( void )\n"
	   "{\n" );

    for( wto = IE->WndTO_List.mlh_Head; wto->wto_Node.ln_Succ; wto = wto->wto_Node.ln_Succ )
	FPrintf( Files->Main, "\tClose%sWindow();\n", wto->wto_Label );

    FPuts( Files->Main, "\tCloseDownScreen();\n" );

    if(( IE->SrcFlags & OPENDISKFONT ) && ( bool ))
	FPuts( Files->Main, "\tCloseDiskFonts();\n" );

    if( IE->NumRexxs )
	FPuts( Files->Main, "\tDeleteRexxPort();\n" );

    FPuts( Files->Main, "}\n\nvoid CloseLibs( void )\n{\n" );

    for( lib = IE->Libs_List.mlh_Head; lib->lbn_Node.ln_Succ; lib = lib->lbn_Node.ln_Succ )
	FPrintf( Files->Main, "\tif ( %s )\n"
			      "\t\tCloseLibrary( %s );\n",
		 lib->lbn_Base, lib->lbn_Base );

    FPuts( Files->Main,
	   "}\n\n"
	   "void PlayTheGame( void )\n"
	   "{\n"
	   "\tULONG\tsignals" );

    if( IE->MainProcFlags & MAIN_OTHERBITS )
	FPuts( Files->Main, ", other = mask" );

    FPuts( Files->Main, ";\n" );

    for( wto = IE->WndTO_List.mlh_Head; wto->wto_Node.ln_Succ; wto = wto->wto_Node.ln_Succ )
	FPrintf( Files->Main, "\tULONG\t%s_signal = 1 << %sWnd->UserPort->mp_SigBit;\n",
		 wto->wto_Label, wto->wto_Label );

    if( IE->NumRexxs )
	FPuts( Files->Main, "\tULONG\trexx_signal = NULL;\n\n"
			    "\tif ( RexxPort )\n"
			    "\t\trexx_signal = 1 << RexxPort->mp_SigBit;\n\n" );

    FPuts( Files->Main, "\tmask = mask" );

    if( IE->MainProcFlags & MAIN_CTRL_C )
	FPuts( Files->Main, " | SIGBREAKF_CTRL_C" );

    for( wto = IE->WndTO_List.mlh_Head; wto->wto_Node.ln_Succ; wto = wto->wto_Node.ln_Succ )
	FPrintf( Files->Main, " | %s_signal", wto->wto_Label );

    if( IE->NumRexxs )
	FPuts( Files->Main, " | rexx_signal" );

    FPuts( Files->Main, ";\n\n\twhile( Ok_to_Run ) {\n\t\tsignals = Wait( mask );\n" );

    for( wto = IE->WndTO_List.mlh_Head; wto->wto_Node.ln_Succ; wto = wto->wto_Node.ln_Succ )
	FPrintf( Files->Main, "\t\tif (signals & %s_signal)\n"
			      "\t\t\tOk_to_Run = Handle%sIDCMP();\n",
		 wto->wto_Label, wto->wto_Label );

    if( IE->NumRexxs )
	FPuts( Files->Main, "\t\tif (signals & rexx_signal)\n"
			    "\t\t\tHandleRexxMsg();\n" );

    if( IE->MainProcFlags & MAIN_OTHERBITS )
	FPuts( Files->Main, "\t\tif (signals & other)\n"
			    "\t\t\tOk_to_Run = HandleOtherSignals();\n" );

    if( IE->MainProcFlags & MAIN_CTRL_C )
	FPuts( Files->Main, "\t\tif (signals & SIGBREAKF_CTRL_C)\n"
			    "\t\t\tOk_to_Run = FALSE;\n" );

    FPuts( Files->Main, "\t};\n\n}\n" );

    if( IE->MainProcFlags & MAIN_WB )
	FPuts( Files->Main, "\nint wbmain( struct WBStartup *msg )\n{\n"
			    "\tWBMsg = msg;\n"
			    "\treturn( main() );\n}\n" );
}
///

/// WriteSetupScr
void WriteSetupScr( struct GenFiles *Files, struct IE_Data *IE )
{
    if( IE->SrcFlags & FONTSENSITIVE ) {

	FPuts( Files->XDef, "extern WORD ScaleX( WORD );\n"
			    "extern WORD ScaleY( WORD );\n" );

	FPrintf( Files->Std, "\nWORD ScaleX( WORD value )\n"
			     "{\n"
			     "\treturn(( WORD )((( FontX * value ) + %ld ) / %ld ));\n"
			     "}\n"
			     "\n"
			     "WORD ScaleY( WORD value )\n"
			     "{\n"
			     "\treturn(( WORD )((( FontY * value ) + %ld ) / %ld ));\n"
			     "}\n"
			     "\n"
			     "static void ComputeFont( UWORD width, UWORD height )\n"
			     "{\n"
			     "\tFont = &Attr;\n"
			     "\tFont->ta_Name = (STRPTR)Scr->RastPort.Font->tf_Message.mn_Node.ln_Name;\n"
			     "\tFont->ta_YSize = FontY = Scr->RastPort.Font->tf_YSize;\n"
			     "\tFontX = Scr->RastPort.Font->tf_XSize;\n"
			     "\n"
			     "\tXOffset = Scr->WBorLeft;\n"
			     "\tYOffset = Scr->RastPort.TxHeight + Scr->WBorTop;\n"
			     "\n"
			     "\tif( width && height )\n"
			     "\t\tif((( ScaleX( width ) + Scr->WBorRight ) > Scr->Width ) ||\n"
			     "\t\t\t(( ScaleY( height ) + Scr->WBorBottom + YOffset ) > Scr->Height ))\n"
			     "\t\t\t\t{\n"
			     "\t\t\t\t\tFont->ta_Name = (STRPTR)\"topaz.font\";\n"
			     "\t\t\t\t\tFontX = FontY = Font->ta_YSize = 8;\n"
			     "\t\t\t\t}\n"
			     "}\n",
		 IE->ScreenData->Screen->RastPort.Font->tf_XSize >> 1,
		 IE->ScreenData->Screen->RastPort.Font->tf_XSize,
		 IE->ScreenData->Screen->RastPort.Font->tf_YSize >> 1,
		 IE->ScreenData->Screen->RastPort.Font->tf_YSize );
    }

    FPuts( Files->Std, "\nint SetupScreen( void )\n"
		       "{\n" );

    if( IE->flags_2 & GENERASCR ) {

	if( IE->ScreenData->Type == 0 )
	    FPrintf( Files->Std, "\tif( LockPubScreen( %s ))\n"
				 "\t\treturn( 1L );\n\n",
		     IE->ScreenData->PubName );

	FPuts( Files->Std, "\tif(!( Scr = OpenScreenTagList( NULL, (struct TagItem *)ScreenTags" );
    } else
	FPuts( Files->Std, "\tif(!( Scr = LockPubScreen( PubScreenName" );

    FPuts( Files->Std, " )))\n\t\treturn( 1L );\n\n" );

    if( IE->ScreenData->Type == 0 )
	FPuts( Files->Std, "\tPubScreenStatus( Scr, 0 );\n\n" );

    if( IE->SrcFlags & FONTSENSITIVE )
	FPuts( Files->Std, "\tComputeFont( 0, 0 );\n" );
    else
	FPuts( Files->Std, "\tYOffset = Scr->WBorTop + Scr->Font->ta_YSize;\n"
			   "\tXOffset = Scr->WBorLeft;\n" );

    FPuts( Files->Std, "\n\tif(!( VisualInfo = GetVisualInfo( Scr, TAG_DONE )))\n"
		       "\t\treturn( 2L );\n" );

    if(( IE->SrcFlags & SHARED_PORT ) && (!( IE->SharedPort[0] )))
	FPuts( Files->Std, "\n\tif(!( IDCMPPort = CreateMsgPort() ))\n"
			   "\t\treturn( 3L );\n" );

    // Expanders
    ( *IE->IEXSrcFun->Setup )( Files );

    FPuts( Files->Std, "\n"
		       "\treturn( 0L );\n"
		       "}\n\n"
		       "void CloseDownScreen( void )\n"
		       "{\n"
		       "\tif( VisualInfo ) {\n"
		       "\t\tFreeVisualInfo( VisualInfo );\n"
		       "\t\tVisualInfo = NULL;\n"
		       "\t}\n" );

    // Expanders
    ( *IE->IEXSrcFun->CloseDown )( Files );

    FPuts( Files->Std, "\n\tif( Scr ) {\n\t\t" );

    if( IE->flags_2 & GENERASCR )
	FPuts( Files->Std, "CloseScreen(" );
    else
	FPuts( Files->Std, "UnlockPubScreen( NULL," );

    FPuts( Files->Std, " Scr );\n"
		       "\t\tScr = NULL;\n"
		       "\t}\n" );

    if(( IE->SrcFlags & SHARED_PORT ) && (!( IE->SharedPort[0] )))
	FPuts( Files->Std, "\tif( IDCMPPort ) {\n"
			   "\t\tDeleteMsgPort( IDCMPPort );\n"
			   "\t\tIDCMPPort = NULL;\n"
			   "\t}" );

    FPuts( Files->Std, "\n}\n"
		       "\n"
		       "LONG OpenWnd( struct Gadget *GList, struct TagItem WTags[], struct Window **Wnd )\n"
		       "{\n"
		       "\tUWORD\t\ttc;\n" );

    if( IE->SrcFlags & FONTSENSITIVE )
	FPuts( Files->Std, "\tUWORD\t\tww, wh, oldww, oldwh;\n" );

    FPuts( Files->Std, "\n\tif( GList ) {\n"
		       "\t\ttc = 0;\n"
		       "\t\twhile( WTags[ tc ].ti_Tag != WA_Gadgets ) tc++;\n"
		       "\t\tWTags[ tc ].ti_Data = (ULONG)GList;\n"
		       "\t}\n\n" );

    if( IE->SrcFlags & FONTSENSITIVE )
	FPuts( Files->Std, "\tww = ScaleX( WTags[ WT_WIDTH  ].ti_Data ) + XOffset + Scr->WBorRight;\n"
			   "\twh = ScaleY( WTags[ WT_HEIGHT ].ti_Data ) + YOffset + Scr->WBorBottom;\n"
			   "\n"
			   "\tif(( WTags[ WT_LEFT ].ti_Data + ww ) > Scr->Width  )\n"
			   "\t\tWTags[ WT_LEFT ].ti_Data = Scr->Width  - ww;\n"
			   "\tif(( WTags[ WT_TOP  ].ti_Data + wh ) > Scr->Height )\n"
			   "\t\tWTags[ WT_TOP  ].ti_Data = Scr->Height - wh;\n"
			   "\n"
			   "\toldww = WTags[ WT_WIDTH  ].ti_Data;\n"
			   "\toldwh = WTags[ WT_HEIGHT ].ti_Data;\n"
			   "\tWTags[ WT_WIDTH  ].ti_Data = ww;\n"
			   "\tWTags[ WT_HEIGHT ].ti_Data = wh;\n\n" );

    FPuts( Files->Std, "\tWTags[8].ti_Data = (ULONG)Scr;\n"
		       "\n\t*Wnd = OpenWindowTagList( NULL, &WTags[0] );\n\n" );

    if( IE->SrcFlags & FONTSENSITIVE )
	FPuts( Files->Std, "\tWTags[ WT_WIDTH  ].ti_Data = oldww;\n"
			   "\tWTags[ WT_HEIGHT ].ti_Data = oldwh;\n\n" );

    FPuts( Files->Std, "\tif(!( *Wnd ))\n"
		       "\t\treturn( 4L );\n\n"
		       "\tGT_RefreshWindow( *Wnd, NULL );\n"
		       "\treturn( 0L );\n}\n"
		       "\n"
		       "void CloseWnd( struct Window **Wnd, struct Gadget **GList, struct Menu **Mn )\n"
		       "{\n"
		       "\tif( Mn ) {\n"
		       "\t\tif( *Wnd )\n"
		       "\t\t\tClearMenuStrip( *Wnd );\n\n"
		       "\t\tFreeMenus( *Mn );\n"
		       "\t\t*Mn = NULL;\n"
		       "\t}\n"
		       "\tif( *Wnd ) {\n"
		       "\t\tCloseWindow( *Wnd );\n"
		       "\t\t*Wnd = NULL;\n"
		       "\t}\n"
		       "\tif( GList ) {\n"
		       "\t\tFreeGadgets( *GList );\n"
		       "\t\t*GList = NULL;\n"
		       "\t}\n"
		       "}\n"
		       "\n"
		       "struct Gadget *MakeGadgets( struct Gadget **GList, struct Gadget *Gads[],\n"
		       "\tstruct NewGadget NGad[], UWORD GTypes[], ULONG GTags[], UWORD CNT )\n"
		       "{\n"
		       "\tstruct Gadget\t\t*g;\n"
		       "\tUWORD\t\t\tlc, tc;\n"
		       "\tstruct NewGadget\tng;\n\n"
		       "\tif(!( g = CreateContext( GList )))\n"
		       "\t\treturn( (struct Gadget *)-1 );\n\n"
		       "\tfor( lc = 0, tc = 0; lc < CNT; lc++ ) {\n\n"
		       "\t\tCopyMem(( char * )&NGad[ lc ], ( char * )&ng, ( long )sizeof( struct NewGadget ));\n"
		       "\t\tng.ng_VisualInfo = VisualInfo;\n" );

    if( IE->SrcFlags & FONTSENSITIVE )
	FPuts( Files->Std, "\t\tng.ng_TextAttr = Font;\n"
			   "\t\tng.ng_LeftEdge = XOffset + ScaleX( ng.ng_LeftEdge );\n"
			   "\t\tng.ng_TopEdge  = YOffset + ScaleY( ng.ng_TopEdge  );\n"
			   "\t\tng.ng_Width    = ScaleX( ng.ng_Width  );\n"
			   "\t\tng.ng_Height   = ScaleY( ng.ng_Height );\n" );
    else
	FPuts( Files->Std, "\t\tng.ng_TopEdge  += YOffset;\n"
			   "\t\tng.ng_LeftEdge += XOffset;\n" );

    FPuts( Files->Std, "\t\tGads[ lc ] = g = CreateGadgetA((ULONG)GTypes[ lc ], g, &ng, (struct TagItem *)&GTags[ tc ] );\n\n"
		       "\t\twhile( GTags[ tc ] )\n"
		       "\t\t\ttc += 2;\n"
		       "\t\ttc++;\n\n"
		       "\t\tif( !g )\n"
		       "\t\t\treturn( (struct Gadget *)-2 );\n"
		       "\t}\n\n"
		       "\treturn( g );\n"
		       "}\n" );
}
///

/// WriteBackFillHook
void WriteBackFillHook( struct GenFiles *Files, struct IE_Data *IE )
{
    struct WindowInfo  *wnd;

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ )
	if( wnd->wi_Tags & W_BACKFILL ) {
	    TEXT    buffer[ 40 ];

	    sprintf( buffer, Prefs.HookDef, "ULONG" );

	    FPrintf( Files->Std, "\n%s WndBFHookFunc( A0( struct Hook *Hook ), A2( struct RastPort *Rast ), A1( struct BFHookMsg *Msg ))\n"
				 "{\n"
				 "\tstatic UWORD Pattern[] = { 0xAAAA, 0x5555 };\n"
				 "\tstruct DrawInfo *dri;\n\n"
				 "\tif( dri = GetScreenDrawInfo( Scr )) {\n"
				 "\t\tSetABPenDrMd( Rast, dri->dri_Pens[ SHINEPEN ], dri->dri_Pens[ BACKPEN ], JAM2 );\n"
				 "\t\tSetAfPt( Rast, &Pattern[0], 1 );\n"
				 "\t\tBltPattern( Rast, NULL,\n"
				 "\t\t            Msg->Bounds.MinX, Msg->Bounds.MinY,\n"
				 "\t\t            Msg->Bounds.MaxX, Msg->Bounds.MaxY,\n"
				 "\t\t            0 );\n"
				 "\t\tSetAfPt( Rast, NULL, 0 );\n"
				 "\t\tFreeScreenDrawInfo( Scr, dri );\n"
				 "\t}\n"
				 "\n\treturn( 0L );\n"
				 "}\n",
		     buffer );

	    break;
	}
}
///

/// WriteListHook
void WriteListHook( struct GenFiles *Files, struct IE_Data *IE )
{
    if( CheckMultiSelect( IE )) {
	TEXT    def[32];

	sprintf( def, Prefs.HookDef, "ULONG" );

	FPrintf( Files->XDef, "extern %s ListHookFunc( A0( struct Hook * ), A1( struct LVDrawMsg * ), A2( struct Node * ));\n"
			      "\n#define ML_SELECTED  (1<<0)\n\n",
		 def );

	FPrintf( Files->Std, "\n"
			     "%s ListHookFunc( A0( struct Hook *Hook ), A1( struct LVDrawMsg *Msg ), A2( struct Node *Node ))\n"
			     "{\n"
			     "\tULONG\t\t\tlen;\n"
			     "\tstruct TextExtent\textent;\n"
			     "\n"
			     "\tif( Msg->lvdm_MethodID != LV_DRAW ) {\n"
			     "\t\treturn( LVCB_UNKNOWN );\n"
			     "\t}\n"
			     "\n"
			     "\tswitch( Msg->lvdm_State ) {\n"
			     "\t\tcase LVR_NORMAL:\n"
			     "\t\tcase LVR_NORMALDISABLED:\n"
			     "\t\tcase LVR_SELECTED:\n"
			     "\t\tcase LVR_SELECTEDDISABLED:\n"
			     "\t\tlen = TextFit( Msg->lvdm_RastPort, Node->ln_Name,\n"
			     "\t\t               strlen( Node->ln_Name ), &extent, NULL, 1,\n"
			     "\t\t               Msg->lvdm_Bounds.MaxX - Msg->lvdm_Bounds.MinX - 3,\n"
			     "\t\t               Msg->lvdm_Bounds.MaxY - Msg->lvdm_Bounds.MinY + 1 );\n"
			     "\n"
			     "\t\tMove( Msg->lvdm_RastPort, Msg->lvdm_Bounds.MinX + 2,\n"
			     "\t\t      Msg->lvdm_Bounds.MinY + Msg->lvdm_RastPort->TxBaseline );\n"
			     "\n"
			     "\t\tif( Node->ln_Pri & ML_SELECTED ) {\n"
			     "\t\t\tSetABPenDrMd( Msg->lvdm_RastPort, Msg->lvdm_DrawInfo->dri_Pens[ FILLTEXTPEN ],\n"
			     "\t\t\t              Msg->lvdm_DrawInfo->dri_Pens[ FILLPEN ], JAM2 );\n"
			     "\t\t} else {\n"
			     "\t\t\tSetABPenDrMd( Msg->lvdm_RastPort, Msg->lvdm_DrawInfo->dri_Pens[ TEXTPEN ],\n"
			     "\t\t\t              Msg->lvdm_DrawInfo->dri_Pens[ BACKGROUNDPEN ], JAM2 );\n"
			     "\t\t}\n"
			     "\n"
			     "\t\tText( Msg->lvdm_RastPort, Node->ln_Name, len );\n"
			     "\n"
			     "\t\tSetAPen( Msg->lvdm_RastPort, Msg->lvdm_DrawInfo->dri_Pens[( Node->ln_Pri & ML_SELECTED ) ? FILLPEN : BACKGROUNDPEN ]);\n"
			     "\t\tRectFill( Msg->lvdm_RastPort, Msg->lvdm_RastPort->cp_x, Msg->lvdm_Bounds.MinY,\n"
			     "\t\t          Msg->lvdm_Bounds.MaxX, Msg->lvdm_Bounds.MaxY );\n"
			     "\t\tbreak;\n"
			     "\t}\n"
			     "\n"
			     "\treturn( LVCB_OK );\n"
			     "}\n\n",
		 def );
    }
}
///

/// WriteGBanksHandling
void WriteGBanksHandling( struct GenFiles *Files, struct IE_Data *IE )
{
    struct WindowInfo  *wnd;

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ )
	if( wnd->wi_NumGBanks ) {

	    FPuts( Files->XDef, "extern void AddGadgetBank( struct Window *, struct WindowBanks *, struct Gadget * );\n"
				"extern void RemGadgetBank( struct Window *, struct WindowBanks *, struct Gadget * );\n" );

	    FPuts( Files->Std, "\nvoid AddGadgetBank( struct Window *Wnd, struct WindowBanks *WindowBanks, struct Gadget *Bank )\n"
			       "{\n"
			       "\tWindowBanks->Banks[ WindowBanks->Count++ ] = Bank;\n\n"
			       "\tAddGList( Wnd, Bank, (UWORD)~0, -1, NULL );\n"
			       "\tRefreshGadgets( Bank, Wnd, NULL );\n"
			       "}\n\n"
			       "void RemGadgetBank( struct Window *Wnd, struct WindowBanks *WindowBanks, struct Gadget *Bank )\n"
			       "{\n"
			       "\tUWORD   ReAttach = WindowBanks->Count - 1;\n\n"
			       "\twhile( WindowBanks->Count > 0 ) {\n"
			       "\t\tRemoveGList( Wnd, WindowBanks->Banks[ --WindowBanks->Count ], -1 );\n"
			       "\t}\n\n"
			       "\twhile( WindowBanks->Count < ReAttach ) {\n"
			       "\t\tstruct Gadget *Bnk;\n\n"
			       "\t\tif(( Bnk = WindowBanks->Banks[ WindowBanks->Count ]) != Bank ) {\n"
			       "\t\t\tAddGList( Wnd, Bnk, (UWORD)~0, -1, NULL );\n"
			       "\t\t\tWindowBanks->Banks[ WindowBanks->Count++ ] = Bnk;\n"
			       "\t\t}\n"
			       "\t}\n"
			       "}\n\n" );
	    break;
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
	if( wnd->wi_NeedRender ) {

	    FPrintf( Files->XDef, "extern void %sRender( void );\n", wnd->wi_Label );

	    FPrintf( Files->Std, "\nvoid %sRender( void )\n{\n", wnd->wi_Label );

	    if( IE->SrcFlags & FONTSENSITIVE ) {

		if( wnd->wi_NumImages )
		    FPuts( Files->Std, "\tstruct Image\t\tim;\n"
				       "\tstruct Image\t\t*imp;\n" );

		if( wnd->wi_NumTexts )
		    FPuts( Files->Std, "\tstruct IntuiText\tit;\n" );

		if(( wnd->wi_NumImages ) || ( wnd->wi_NumTexts ))
		    FPuts( Files->Std, "\tUWORD\t\t\tc;\n" );
	    }

	    IE->win_info = wnd;
	    ( *IE->IEXSrcFun->RenderMinusZero )( Files );

	    for( box = wnd->wi_Boxes.mlh_Head; box->bb_Next; box = box->bb_Next ) {
		x = box->bb_Left - IE->ScreenData->XOffset;
		y = box->bb_Top  - IE->ScreenData->YOffset;

		if( IE->SrcFlags & FONTSENSITIVE )
		    FPrintf( Files->Std, "\n\tDrawBevelBox( %sWnd->RPort, ScaleX( %ld ) + XOffset, ScaleY( %ld ) + YOffset, ScaleX( %ld ), ScaleY( %ld ),\n"
					 "\t\tGT_VisualInfo, VisualInfo,",
			     wnd->wi_Label, x, y, box->bb_Width, box->bb_Height );
		else
		    FPrintf( Files->Std, "\n\tDrawBevelBox( %sWnd->RPort, %ld + XOffset, %ld + YOffset, %ld, %ld,\n"
					 "\t\tGT_VisualInfo, VisualInfo,",
			     wnd->wi_Label, x, y, box->bb_Width, box->bb_Height );

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
					 "\t\tim.LeftEdge  = XOffset + ScaleX( im.LeftEdge );\n"
					 "\t\tim.TopEdge   = YOffset + ScaleY( im.TopEdge  );\n"
					 "\t\tDrawImage( %sWnd->RPort, &im, 0, 0 );\n"
					 "\t}\n",
			     wnd->wi_Label, wnd->wi_NumImages, wnd->wi_Label );
		} else {
		    FPrintf( Files->Std, "\n\tDrawImage( %sWnd->RPort, &%s_0Image, XOffset, YOffset );\n",
			     wnd->wi_Label, wnd->wi_Label );
		}
	    }

	    if( wnd->wi_NumTexts ) {
		if( IE->SrcFlags & FONTSENSITIVE ) {
		    FPrintf( Files->Std, "\n\tfor( c = 0; c < %ld; c++ ) {\n"
					 "\t\tCopyMem(( char * )&%sIText[ c ], ( char * )&it, ( long )sizeof( struct IntuiText ));\n"
					 "\t\tit.ITextFont = Font;\n"
					 "\t\tit.LeftEdge  = XOffset + ScaleX( it.LeftEdge ) - ( IntuiTextLength( &it ) >> 1 );\n"
					 "\t\tit.TopEdge   = YOffset + ScaleY( it.TopEdge  ) - ( Font->ta_YSize >> 1 );\n"
					 "\t\tPrintIText( %sWnd->RPort, &it, 0, 0 );\n"
					 "\t}\n",
			     wnd->wi_NumTexts, wnd->wi_Label, wnd->wi_Label );
		} else {
		    FPrintf( Files->Std, "\n\tPrintIText( %sWnd->RPort, %sIText, XOffset, YOffset );\n",
			     wnd->wi_Label, wnd->wi_Label );
		}
	    }

	    ( *IE->IEXSrcFun->RenderPlusZero )( Files );

	    FPuts( Files->Std, "}\n" );

	}
    }
}
///

