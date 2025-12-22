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
	"MODULE 'dos/dos', 'exec/libraries', 'exec', 'dos', '%s'\n",
	FilePart( Files->XDefName ));

    if( IE->ExtraProc[0] ) {

	if( IE->C_Prefs & GEN_TEMPLATE ) {
	    FPrintf( Files->Temp,
		"PROC %s()\n"
		"\t/*  ...Initialization Stuff...  */\n"
		"ENDPROC\n",
		IE->ExtraProc );
	}
    }

    if( IE->MainProcFlags & MAIN_OTHERBITS ) {

	if( IE->C_Prefs & GEN_TEMPLATE ) {
	    FPuts( Files->Temp,
		"PROC handleOtherSignals()\n"
		"\t/*  Routine to handle other signals  */\n"
		"\tRETURN TRUE\n"
		"ENDPROC\n" );
	}
    }


    FPuts( Files->Main, "\nDEF\tok_to_run=TRUE, mask=NIL\n\n" );



    FPuts( Files->Main,
	"\nPROC main() HANDLE\n"
	"\tIF ( openLibs() = FALSE ) THEN Raise( 1 )\n"
	"\tIF ( setup() = FALSE ) THEN Raise( 1 )\n" );

    if( IE->ExtraProc[0] )
	FPrintf( Files->Main, "\tIF ( %s() = FALSE ) THEN Raise( 1 )\n", IE->ExtraProc );

    FPuts( Files->Main,
	"\tplayTheGame()\n"
	"EXCEPT DO:\n"
	"\tend()\n"
	"ENDPROC 0\n"
	"\n"
	"PROC end()\n"
	"\tcloseAll()\n"
	"\tcloseLibs()\n"
	"ENDPROC\n"
	"\n"
	"PROC openLibs()\n" );

    for( lib = IE->Libs_List.mlh_Head; lib->lbn_Node.ln_Succ; lib = lib->lbn_Node.ln_Succ ) {
	if ( lib->lbn_Node.ln_Pri & L_FAIL )
	    FPrintf( Files->Main,
		     "\tIF ( %s:= OpenLibrary( \"%s\", %ld )) = NIL THEN\n"
		     "\t\terror( errstrings[ OPEN_LIB ], \"%s\" )\n"
		     "\t\tRETURN FALSE\n"
		     "\tENDIF\n",
		     lib->lbn_Base, lib->lbn_Name, lib->lbn_Version, lib->lbn_Name );
	else
	    FPrintf( Files->Main,
		     "\t%s:= OpenLibrary( \"%s\", %ld )\n",
		     lib->lbn_Base, lib->lbn_Name, lib->lbn_Version );
    }

    FPuts( Files->Main,
	   "ENDPROC TRUE\n"
	   "\n"
	   "PROC setup()\n"
	   "\tDEF\tret\n" );

    if( IE->SrcFlags & OPENDISKFONT ) {
	struct TxtAttrNode *fnt;

	bool = FALSE;
	for( fnt = IE->FntLst.mlh_Head; fnt->txa_Next; fnt = fnt->txa_Next )
	    if( fnt->txa_Flags & FPB_DISKFONT )
		bool = TRUE;

	if( bool )
	    FPuts( Files->Main,
		   "\tIF openDiskFonts() = FALSE THEN\n"
		   "\t\terror( errstrings[ OPEN_FONTS ], NULL )\n"
		   "\t\tRETURN FALSE\n"
		   "\tENDIF\n" );
    }

    FPuts( Files->Main,
	   "\tIF ( ret:= setupScreen()) THEN\n"
	   "\t\terror( errstrings[ SETUP_SCR ], errstrings[ SETUP_SCR+ret ]);\n"
	   "\t\tRETURN FALSE\n"
	   "\tENDIF\n" );

    for( wto = IE->WndTO_List.mlh_Head; wto->wto_Node.ln_Succ; wto = wto->wto_Node.ln_Succ )
	FPrintf( Files->Main,
		 "\tIF ( ret = open%sWindow()) THEN\n"
		 "\t\terror( errstrings[ OPEN_WND ], errstrings[ OPEN_WND+ret ])\n"
		 "\t\tRETURN FALSE\n"
		 "\tENDIF\n",
		 wto->wto_Label );

    if( IE->NumRexxs )
	FPuts( Files->Main, "\tsetupRexxPort()\n" );

    FPuts( Files->Main, "ENDPROC TRUE\n"
			"\n"
			"PROC closeAll()\n" );

    for( wto = IE->WndTO_List.mlh_Head; wto->wto_Node.ln_Succ; wto = wto->wto_Node.ln_Succ )
	FPrintf( Files->Main, "\tclose%sWindow()\n", wto->wto_Label );

    FPuts( Files->Main, "\tcloseDownScreen()\n" );

    if(( IE->SrcFlags & OPENDISKFONT ) && ( bool ))
	FPuts( Files->Main, "\tcloseDiskFonts()\n" );

    if( IE->NumRexxs )
	FPuts( Files->Main, "\tdeleteRexxPort()\n" );

    FPuts( Files->Main, "ENDPROC\n\nPROC closeLibs()\n" );

    for( lib = IE->Libs_List.mlh_Head; lib->lbn_Node.ln_Succ; lib = lib->lbn_Node.ln_Succ )
	FPrintf( Files->Main, "\tIF ( %s ) THEN CloseLibrary( %s )\n",
		 lib->lbn_Base, lib->lbn_Base );

    FPuts( Files->Main,
	   "ENDPROC\n\n"
	   "PROC playTheGame()\n"
	   "\tDEF signals,other = mask" );

    for( wto = IE->WndTO_List.mlh_Head; wto->wto_Node.ln_Succ; wto = wto->wto_Node.ln_Succ )
	FPrintf( Files->Main, ",%s_signal = Shl( 1, %sWnd.userport.sigbit )",
		 wto->wto_Label, wto->wto_Label );

    if( IE->NumRexxs )
	FPuts( Files->Main, ",rexx_signal=NIL;\n\n"
			    "\tIF ( RexxPort ) THEN rexx_signal:= Shl( 1, rexxPort.sigbit )\n" );

    FPuts( Files->Main, "\n\tmask = mask" );

    if( IE->MainProcFlags & MAIN_CTRL_C )
	FPuts( Files->Main, " | SIGBREAKF_CTRL_C" );

    for( wto = IE->WndTO_List.mlh_Head; wto->wto_Node.ln_Succ; wto = wto->wto_Node.ln_Succ )
	FPrintf( Files->Main, " | %s_signal", wto->wto_Label );

    if( IE->NumRexxs )
	FPuts( Files->Main, " | rexx_signal" );

    FPuts( Files->Main, "\n\n\tWHILE( ok_to_run )\n\t\tsignals := Wait( mask )\n" );

    for( wto = IE->WndTO_List.mlh_Head; wto->wto_Node.ln_Succ; wto = wto->wto_Node.ln_Succ )
	FPrintf( Files->Main, "\t\tIF (signals AND %s_signal) THEN ok_to_run:= handle%sIDCMP()\n",
		 wto->wto_Label, wto->wto_Label );

    if( IE->NumRexxs )
	FPuts( Files->Main, "\t\tIF (signals AND rexx_signal) THEN handleRexxMsg()\n" );

    if( IE->MainProcFlags & MAIN_OTHERBITS )
	FPuts( Files->Main, "\t\tIF (signals AND other) THEN ok_to_run:= handleOtherSignals()\n" );

    if( IE->MainProcFlags & MAIN_CTRL_C )
	FPuts( Files->Main, "\t\tIF (signals AND SIGBREAKF_CTRL_C) THEN ok_to_run:= FALSE\n" );

    FPuts( Files->Main, "\tENDWHILE\n\nENDPROC\n" );
}
///

/// WriteSetupScr
void WriteSetupScr( struct GenFiles *Files, struct IE_Data *IE )
{
    if( IE->SrcFlags & FONTSENSITIVE ) {

	FPuts( Files->XDef, "extern UWORD ScaleX( UWORD );\n"
			    "extern UWORD ScaleY( UWORD );\n" );

	FPrintf( Files->Std, "\nUWORD ScaleX( UWORD value )\n"
			     "{\n"
			     "\treturn(( UWORD )((( FontX * value ) + %ld ) / %ld ));\n"
			     "}\n"
			     "\n"
			     "UWORD ScaleY( UWORD value )\n"
			     "{\n"
			     "\treturn(( UWORD )((( FontY * value ) + %ld ) / %ld ));\n"
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
		       "{\n"
		       "\tif(!( Scr = " );

    if( IE->flags_2 & GENERASCR )
	FPuts( Files->Std, "OpenScreenTagList( NULL, (struct TagItem *)ScreenTags" );
    else
	FPuts( Files->Std, "LockPubScreen( PubScreenName" );

    FPuts( Files->Std, " )))\n\t\treturn( 1L );\n\n" );

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
		       "\t\treturn( -1 );\n\n"
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
		       "\t\t\treturn( -2 );\n"
		       "\t}\n\n"
		       "\treturn( g );\n"
		       "}\n" );
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

