/// Includes
#define INTUI_V36_NAMES_ONLY

#include <exec/types.h>                 // exec
#include <exec/lists.h>
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

/// WriteOpenWnd
void WriteOpenWnd( struct GenFiles *Files, struct IE_Data *IE )
{
    struct WindowInfo  *wnd;
    struct GadgetInfo  *gad;
    UWORD               cnt = 0;

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {

	FPrintf( Files->XDef, "extern LONG Open%sWindow( void );\n"
			      "extern void Close%sWindow( void );\n",
		 wnd->wi_Label, wnd->wi_Label );

	if(!( wnd->wi_NoOpenWnd )) { // supplied by an expander?

	    FPrintf( Files->Std, "\nLONG Open%sWindow( void )\n"
				 "{\n"
				 "\tLONG\t\tret_code = NULL;\n"
				 "\tstruct Gadget\t*g;\n",
		     wnd->wi_Label );

	    if( wnd->wi_NumGads ) {
		if( wnd->wi_NumBools )
		    if( wnd->wi_IDCMP & IDCMP_GADGETHELP )
			FPuts( Files->Std, "\tint\t\tc;\n" );
		    else
			FPuts( Files->Std, "\tint\t\tc;\n" );
	    }

	    if( IE->SrcFlags & FONTSENSITIVE )
		FPrintf( Files->Std, "\n\tComputeFont( %ld, %ld );\n",
			 wnd->wi_Width - ( IE->ScreenData->XOffset + IE->ScreenData->Screen->WBorRight  ),
			 wnd->wi_Height - ( IE->ScreenData->YOffset + IE->ScreenData->Screen->WBorBottom ));

	    if(( IE->SrcFlags & LOCALIZE ) && ( wnd->wi_Tags & ( W_LOC_TITLE | W_LOC_SCRTITLE | W_LOC_GADGETS | W_LOC_MENUS | W_LOC_TEXTS ))) {

		FPrintf( Files->Std, "\n\tif(!( Localized[ %ld ] )) {\n", cnt );

		if(( wnd->wi_Titolo[0] ) && ( wnd->wi_Tags & W_LOC_TITLE ))
		    FPrintf( Files->Std, "\n\t\t%sWTags[ 9 ].ti_Data = (ULONG)CatCompArray[ %sWTags[ 9 ].ti_Data ].cca_Str;\n",
			     wnd->wi_Label, wnd->wi_Label );

		if(( wnd->wi_TitoloSchermo[0] ) && ( wnd->wi_Tags & W_LOC_SCRTITLE ))
		    FPrintf( Files->Std, "\n\t\tULONG *tg;\n"
					 "\t\ttg = (ULONG *)&%sWTags[0];\n"
					 "\t\twhile( *tg++ != WA_ScreenTitle );\n"
					 "\t\t*tg = (ULONG)CatCompArray[ *tg ].cca_Str;\n",
			     wnd->wi_Label );

		if( wnd->wi_Tags & W_LOC_GADGETS ) {
		    struct GadgetBank  *bank;

		    if( wnd->wi_NumGads - wnd->wi_NumBools ) {

			FPrintf( Files->Std, "\n\t\tLocalizeGadgets( &%sNGad[0], &%sGTags[0], &%sGTypes[0], %s_CNT );\n",
				 wnd->wi_Label, wnd->wi_Label,
				 wnd->wi_Label, wnd->wi_Label );

			for( gad = wnd->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ )
			    if(( gad->g_Kind == LISTVIEW_KIND ) && ( gad->g_NumScelte ))
				FPrintf( Files->Std, "\t\tLocalizeList( &%sList );\n",
					 gad->g_Label );
		    }

		    for( bank = wnd->wi_GBanks.mlh_Head; bank->Node.ln_Succ; bank = bank->Node.ln_Succ ) {

			FPrintf( Files->Std, "\n\t\tLocalizeGadgets( &%sNGad[0], &%sGTags[0], &%sGTypes[0], %s_CNT );\n",
				 bank->Label, bank->Label, bank->Label, bank->Label );

			for( gad = bank->Storage.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ )
			    if(( gad->g_Kind == LISTVIEW_KIND ) && ( gad->g_NumScelte ))
				FPrintf( Files->Std, "\t\tLocalizeList( &%sList );\n", gad->g_Label );
		    }
		}


		if(( wnd->wi_NumTexts ) && ( wnd->wi_Tags & W_LOC_TEXTS ))
		    FPrintf( Files->Std, "\n\t\tLocalizeITexts( &%sIText[0], %ld );\n",
			     wnd->wi_Label, wnd->wi_NumTexts );

		if(( wnd->wi_NumMenus ) && ( wnd->wi_Tags & W_LOC_MENUS ))
		    FPrintf( Files->Std, "\n\t\tLocalizeMenus( &%sNewMenu[0] );\n",
			     wnd->wi_Label );

		FPuts( Files->Std, "\t}\n" );
	    }

	    if( wnd->wi_NumGads ) {

		FPrintf( Files->Std, "\n\tg = MakeGadgets( &%sGList, %sGadgets, %sNGad,\n"
				     "\t\t%sGTypes, %sGTags, %s_CNT );\n"
				     "\tif( (LONG)g < 0 )\n"
				     "\t\treturn( -((LONG)g) );\n",
			 wnd->wi_Label, wnd->wi_Label, wnd->wi_Label,
			 wnd->wi_Label, wnd->wi_Label, wnd->wi_Label );

		if( wnd->wi_NumBools ) {

		    gad = wnd->wi_Gadgets.mlh_Head;
		    while( gad->g_Kind != BOOLEAN )
			gad = gad->g_Node.ln_Succ;

		    if( wnd->wi_IDCMP & IDCMP_GADGETHELP ) {
			if( IE->SrcFlags & FONTSENSITIVE )
			    FPrintf( Files->Std, "\tg = &%sGadget;\n"
					       "\tfor( c = 0; c < %ld; c++ ) {\n"
					       "\t\tg->BoundsLeftEdge = g->LeftEdge = XOffset + ScaleX( g->LeftEdge );\n"
					       "\t\tg->BoundsTopEdge  = g->TopEdge  = YOffset + ScaleY( g->TopEdge );\n",
				   gad->g_Label, wnd->wi_NumBools );
			else
			    FPrintf( Files->Std, "\tg = &%sGadget;\n"
					       "\tfor( c = 0; c < %ld; c++ ) {\n"
					       "\t\tg->LeftEdge       += XOffset;\n"
					       "\t\tg->TopEdge        += YOffset;\n"
					       "\t\tg->BoundsLeftEdge += XOffset;\n"
					       "\t\tg->BoundsTopEdge  += YOffset;\n",
				   gad->g_Label, wnd->wi_NumBools );
		    } else {
			if( IE->SrcFlags & FONTSENSITIVE )
			    FPrintf( Files->Std, "\tg = &%sGadget;\n"
					       "\tfor( c = 0; c < %ld; c++ ) {\n"
					       "\t\tg->LeftEdge = XOffset + ScaleX( g->LeftEdge );\n"
					       "\t\tg->TopEdge  = YOffset + ScaleY( g->TopEdge );\n",
				   gad->g_Label, wnd->wi_NumBools );
			else
			    FPrintf( Files->Std, "\tg = &%sGadget;\n"
					       "\tfor( c = 0; c < %ld; c++ ) {\n"
					       "\t\tg->LeftEdge += XOffset;\n"
					       "\t\tg->TopEdge  += YOffset;\n",
				   gad->g_Label, wnd->wi_NumBools );
		    }

		    if(( IE->SrcFlags & LOCALIZE ) && ( wnd->wi_Tags & W_LOC_GADGETS ))
			FPrintf( Files->Std, "\t\tif( g->GadgetText )\n"
					     "\t\t\tif(!( Localized[ %ld ] ) && ( g->GadgetText->IText ))\n"
					     "\t\t\t\tg->GadgetText->IText = (UBYTE *)CatCompArray[ (ULONG)g->GadgetText->IText ].cca_Str;\n",
				 cnt );

		    FPuts( Files->Std, "\t\tg = g->NextGadget;\n"
				       "\t}\n" );

		    gad = wnd->wi_Gadgets.mlh_TailPred;
		    while( gad->g_Kind != BOOLEAN )
			gad = gad->g_Node.ln_Pred;

		    FPrintf( Files->Std, "\t%sGadget.NextGadget = %sGList;\n",
			     gad->g_Label, wnd->wi_Label );
		}
	    }

	    if( wnd->wi_NumMenus )
		FPrintf( Files->Std, "\tif(!( %sMenus = CreateMenus( %sNewMenu, TAG_END )))\n"
				     "\t\treturn( 3L );\n\n"
				     "\tLayoutMenus( %sMenus, VisualInfo, GTMN_NewLookMenus, TRUE, TAG_END );\n\n",
			 wnd->wi_Label, wnd->wi_Label, wnd->wi_Label );
	}



	// Gadget Banks
	{
	    struct GadgetBank  *bank;
	    ULONG               count = 0;

	    for( bank = wnd->wi_GBanks.mlh_Head; bank->Node.ln_Succ; bank = bank->Node.ln_Succ ) {
		if( bank->Node.ln_Type & GB_ONOPEN ) {

		    FPrintf( Files->Std, "\t{\n"
					 "\t\tstruct Gadget\t*gad;\n"
					 "\t\tgad = MakeGadgets( &%sGList, %sGadgets, %sNGad,\n"
					 "\t\t\t%sGTypes, %sGTags, %s_CNT );\n"
					 "\t\tif( (LONG)gad < 0 )\n"
					 "\t\t\treturn( -((LONG)gad) );\n"
					 "\t\t%sWBanks.Banks[%ld] = g->NextGadget = %sGList;\n"
					 "\t\tg = gad;\n"
					 "\t}\n",
			     bank->Label, bank->Label, bank->Label, bank->Label,
			     bank->Label, bank->Label, wnd->wi_Label, count++,
			     bank->Label );
		}
	    }

	    if( count )
		FPrintf( Files->Std, "\t%sWBanks.Count = %ld;\n",
			 wnd->wi_Label, count );
	}



	// Expanders
	IE->win_info = wnd;
	( *IE->IEXSrcFun->OpenWnd )( Files );

	if(!( wnd->wi_NoOpenWnd )) {

	    FPuts( Files->Std, (( IE->SrcFlags & SHARED_PORT ) && ( wnd->wi_Tags & W_SHARED_PORT )) ?
			       "\tret_code = OpenWndShd( " : "\tret_code = OpenWnd( " );

	    if( wnd->wi_NumGads )
		if( wnd->wi_NumBools ) {
		    gad = wnd->wi_Gadgets.mlh_Head;
		    while( gad->g_Kind != BOOLEAN )
			gad = gad->g_Node.ln_Succ;
		    FPrintf( Files->Std, "&%sGadget", gad->g_Label );
		} else {
		    FPrintf( Files->Std, "%sGList", wnd->wi_Label );
		}
	    else
		FPuts( Files->Std, Null );

	    FPrintf( Files->Std, ", %sWTags, &%sWnd",
		     wnd->wi_Label, wnd->wi_Label );

	    if(( IE->SrcFlags & SHARED_PORT ) && ( wnd->wi_Tags & W_SHARED_PORT ))
		FPrintf( Files->Std, ", %s_IDCMP", wnd->wi_Label );

	    FPuts( Files->Std, " );\n"
			       "\tif( ret_code )\n"
			       "\t\treturn( ret_code );\n" );

	    if( wnd->wi_NumMenus )
		FPrintf( Files->Std, "\tSetMenuStrip( %sWnd, %sMenus );\n",
			 wnd->wi_Label, wnd->wi_Label );

	    if( wnd->wi_NeedRender )
		FPrintf( Files->Std, "\n\t%sRender();\n", wnd->wi_Label );

	    if(( IE->SrcFlags & LOCALIZE ) && ( wnd->wi_Tags & ( W_LOC_TITLE | W_LOC_SCRTITLE | W_LOC_GADGETS | W_LOC_MENUS | W_LOC_TEXTS )))
		FPrintf( Files->Std, "\n\tLocalized[ %ld ] = TRUE;\n", cnt );

	    FPuts( Files->Std, "\treturn( 0L );\n}\n\n" );
	}

	FPrintf( Files->Std, "void Close%sWindow( void )\n"
			     "{\n",
		 wnd->wi_Label );

	if( wnd->wi_NumBools )
	    if( wnd->wi_IDCMP & IDCMP_GADGETHELP )
		FPuts( Files->Std, "\tstruct ExtGadget\t*g;\n"
				   "\tint\t\tc;\n" );
	    else
		FPuts( Files->Std, "\tstruct Gadget\t*g;\n"
				   "\tint\t\tc;\n" );

	FPrintf( Files->Std, (( IE->SrcFlags & SHARED_PORT ) && ( wnd->wi_Tags & W_SHARED_PORT )) ?
		 "\n\tCloseWndShd( &%sWnd, " : "\n\tCloseWnd( &%sWnd, ", wnd->wi_Label );

	if( wnd->wi_NumGads - wnd->wi_NumBools )
	    FPrintf( Files->Std, "&%sGList, ", wnd->wi_Label );
	else
	    FPuts( Files->Std, "NULL, " );

	if( wnd->wi_NumMenus )
	    FPrintf( Files->Std, "&%sMenus", wnd->wi_Label );
	else
	    FPuts( Files->Std, Null );

	FPuts( Files->Std, " );\n" );

	if( wnd->wi_NumBools ) {

	    gad = wnd->wi_Gadgets.mlh_Head;
	    while( gad->g_Kind != BOOLEAN )
		gad = gad->g_Node.ln_Succ;

	    if( wnd->wi_IDCMP & IDCMP_GADGETHELP ) {
		if( IE->SrcFlags & FONTSENSITIVE )
		    FPrintf( Files->Std, "\tg = &%sGadget;\n"
				       "\tfor( c = 0; c < %ld; c++ ) {\n"
				       "\t\tg->BoundsLeftEdge = g->LeftEdge = (((( g->LeftEdge - XOffset ) * %ld ) - %ld ) / FontX);\n"
				       "\t\tg->BoundsTopEdge  = g->TopEdge  = (((( g->TopEdge  - YOffset ) * %ld ) - %ld ) / FontY);\n"
				       "\t\tg = g->NextGadget;\n"
				       "\t}\n",
			   gad->g_Label, wnd->wi_NumBools,
			   IE->ScreenData->Screen->RastPort.Font->tf_XSize,
			   IE->ScreenData->Screen->RastPort.Font->tf_XSize >> 1,
			   IE->ScreenData->Screen->RastPort.Font->tf_YSize,
			   IE->ScreenData->Screen->RastPort.Font->tf_XSize >> 1 );
		else
		    FPrintf( Files->Std, "\tg = &%sGadget;\n"
				       "\tfor( c = 0; c < %ld; c++ ) {\n"
				       "\t\tg->LeftEdge       -= XOffset;\n"
				       "\t\tg->TopEdge        -= YOffset;\n"
				       "\t\tg->BoundsLeftEdge -= XOffset;\n"
				       "\t\tg->BoundsTopEdge  -= YOffset;\n"
				       "\t\tg = g->NextGadget;\n"
				       "\t}\n",
			   gad->g_Label, wnd->wi_NumBools );
	    } else {
		if( IE->SrcFlags & FONTSENSITIVE )
		    FPrintf( Files->Std, "\tg = &%sGadget;\n"
				       "\tfor( c = 0; c < %ld; c++ ) {\n"
				       "\t\tg->LeftEdge = (((( g->LeftEdge - XOffset ) * %ld ) - %ld ) / FontX);\n"
				       "\t\tg->TopEdge  = (((( g->TopEdge  - YOffset ) * %ld ) - %ld ) / FontY);\n"
				       "\t\tg = g->NextGadget;\n"
				       "\t}\n",
			   gad->g_Label, wnd->wi_NumBools,
			   IE->ScreenData->Screen->RastPort.Font->tf_XSize,
			   IE->ScreenData->Screen->RastPort.Font->tf_XSize >> 1,
			   IE->ScreenData->Screen->RastPort.Font->tf_YSize,
			   IE->ScreenData->Screen->RastPort.Font->tf_XSize >> 1 );
		else
		    FPrintf( Files->Std, "\tg = &%sGadget;\n"
				       "\tfor( c = 0; c < %ld; c++ ) {\n"
				       "\t\tg->LeftEdge -= XOffset;\n"
				       "\t\tg->TopEdge  -= YOffset;\n"
				       "\t\tg = g->NextGadget;\n"
				       "\t}\n",
			   gad->g_Label, wnd->wi_NumBools );
	    }
	}

	// Expanders
	( *IE->IEXSrcFun->CloseWnd )( Files );

	FPuts( Files->Std, "\n}\n" );

	cnt += 1;
    }
}
///
/// WriteOpenWndShd
void WriteOpenWndShd( struct GenFiles *Files, struct IE_Data *IE )
{
    FPuts( Files->Std, "LONG OpenWndShd( struct Gadget *GList, struct TagItem *WTags, struct Window **Wnd, ULONG IDCMP )\n"
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

    FPrintf( Files->Std, "\tWTags[8].ti_Data = (ULONG)Scr;\n"
			 "\n\tif( *Wnd = OpenWindowTagList( NULL, &WTags[0] )) {\n"
			 "\t\t( *Wnd )->UserPort = %s;\n"
			 "\t\tModifyIDCMP( *Wnd, IDCMP );\n"
			 "\t}\n\n",
	   Files->User2 );

    if( IE->SrcFlags & FONTSENSITIVE )
	FPuts( Files->Std, "\tWTags[ WT_WIDTH  ].ti_Data = oldww;\n"
			   "\tWTags[ WT_HEIGHT ].ti_Data = oldwh;\n\n" );

    FPrintf( Files->Std, "\tif(!( *Wnd ))\n"
			 "\t\treturn( 4L );\n\n"
			 "\tGT_RefreshWindow( *Wnd, NULL );\n"
			 "\treturn( 0L );\n"
			 "}\n"
			 "\nvoid CloseWndShd( struct Window **Wnd, struct Gadget **GList, struct Menu **Mn )\n"
			 "{\n"
			 "\tstruct IntuiMessage\t*Msg;\n"
			 "\tstruct Node\t\t\t*succ;\n"
			 "\n\tif( Mn ) {\n"
			 "\t\tif( *Wnd )\n"
			 "\t\t\tClearMenuStrip( *Wnd );\n"
			 "\t\tFreeMenus( *Mn );\n"
			 "\t\t*Mn = NULL;\n"
			 "\t}\n"
			 "\n\tif( *Wnd ) {\n"
			 "\n\t\tForbid();\n"
			 "\n\t\tMsg = (struct IntuiMessage *)( *Wnd )->UserPort->mp_MsgList.lh_Head;\n"
			 "\t\twhile( succ = Msg->ExecMessage.mn_Node.ln_Succ ) {\n"
			 "\t\t\tif( Msg->IDCMPWindow == *Wnd ) {\n"
			 "\t\t\t\tRemove(( struct Node *)Msg );\n"
			 "\t\t\t\tReplyMsg(( struct Message *)Msg );\n"
			 "\t\t\t}\n"
			 "\t\t\tMsg = (struct IntuiMessage *)succ;\n"
			 "\t\t}\n"
			 "\n\t\t( *Wnd )->UserPort = NULL;\n"
			 "\t\tModifyIDCMP( *Wnd, 0L );\n"
			 "\n\t\tPermit();\n"
			 "\n\t\tCloseWindow( *Wnd );\n"
			 "\t\t*Wnd = NULL;\n"
			 "\t}\n"
			 "\n\tif( GList ) {\n"
			 "\t\tFreeGadgets( *GList );\n"
			 "\t\t*GList = NULL;\n"
			 "\t}\n"
			 "\n}\n"
			 "\n"
			 "void HandleIDCMPPort( void )\n"
			 "{\n"
			 "\tstruct IntuiMsg\t*m;\n"
			 "\tvoid\t\t(*func)(void);\n"
			 "\n"
			 "\twhile( m = GT_GetIMsg( %s )) {\n"
			 "\t\tCopyMem((char *)m, (char *)&IDCMPMsg, (long)sizeof( struct IntuiMessage ));\n"
			 "\t\tGT_ReplyIMsg( m );\n"
			 "\t\tfunc = IDCMPMsg.IDCMPWindow->ExtData;\n"
			 "\t\t(*func)();\n"
			 "\t}\n"
			 "}\n",
		    Files->User2 );
}
///

