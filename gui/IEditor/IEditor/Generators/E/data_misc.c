/// Includes
#define INTUI_V36_NAMES_ONLY

#include <exec/types.h>                 // exec
#include <exec/lists.h>
#include <exec/nodes.h>
#include <dos/dos.h>                    // dos
#include <dos/dostags.h>
#include <intuition/intuition.h>        // intuition
#include <graphics/text.h>              // graphics
#include <libraries/gadtools.h>         // libraries
#include <clib/exec_protos.h>           // protos
#include <clib/dos_protos.h>
#include <clib/intuition_protos.h>
#include <pragmas/exec_pragmas.h>       // pragmas
#include <pragmas/dos_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <pragmas/gadtools_pragmas.h>

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#include "DEV_IE:Generators/defs.h"
#include "DEV_IE:Include/IEditor.h"

#include "Protos.h"
///
/// Data
static UBYTE   MenuTmp[] = "\nPROC %smenued()\n"
		    "\t/*  Routine for menu \"%s\"  */\n"
		    "\tRETURN TRUE\n"
		    "ENDPROC\n";
///


/// WriteMenuStruct
void WriteMenuStruct( struct GenFiles *Files, struct IE_Data *IE )
{
    struct MenuTitle   *title;
    struct _MenuItem   *item;
    struct MenuSub     *sub;
    struct WindowInfo  *wnd;
    struct ImageNode   *img;
    UBYTE               buffer[300], lent, leni, lens, *str;
    ULONG               smart;

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	if( wnd->wi_NumMenus ) {
	    TEXT    Label[60];

	    StrToLower( wnd->wi_Label, Label );

	    smart = IE->C_Prefs & SMART_STR;

	    if( IE->SrcFlags & LOCALIZE )
		smart = wnd->wi_Tags & W_LOC_MENUS;

	    FPrintf( Files->Std, "\nDEF %snewmenu = [\n", Label );

	    for( title = wnd->wi_Menus.mlh_Head; title->mt_Node.ln_Succ; title = title->mt_Node.ln_Succ ) {

		FPuts( Files->Std, "\tNM_TITLE, " );

		if( title->mt_Text[0] ) {
		    lent = strlen( title->mt_Text );
		    strcpy( buffer, title->mt_Text );
		    strcat( buffer, "/" );

		    if( smart )
			FPrintf( Files->Std, "%s", (FindString( &Files->Strings, title->mt_Text ))->Label );
		    else
			FPrintf( Files->Std, "'%s'", title->mt_Text );
		} else {
		    FPuts( Files->Std, Null );
		}

		FPuts( Files->Std, ", NIL, " );

		if( title->mt_Flags & M_DISABLED )
		    FPuts( Files->Std, "NM_MENUDISABLED" );
		else
		    FPuts( Files->Std, Null );

		FPuts( Files->Std, ", 0, NIL,\n" );

		for( item = title->mt_Items.mlh_Head; item->min_Node.ln_Succ; item = item->min_Node.ln_Succ ) {

		    str = item->min_Image ? "\t  IM_ITEM" : "\t  NM_ITEM";
		    FPuts( Files->Std, str );

		    leni = strlen( item->min_Text );
		    strcat( buffer, item->min_Text );

		    FPuts( Files->Std, ", " );

		    if( item->min_Flags & M_BARLABEL ) {
			FPuts( Files->Std, "NM_BARLABEL" );
		    } else {
			if( img = item->min_Image ) {
			    TEXT    Label[60];

			    (ULONG)img -= sizeof( struct Node );

			    StrToLower( img->in_Label, Label );
			    FPrintf( Files->Std, "{%simg}", Label );
			} else {
			    if( item->min_Text[0] )
				if( smart )
				    FPrintf( Files->Std, "%s", (FindString( &Files->Strings, item->min_Text ))->Label );
				else
				    FPrintf( Files->Std, "'%s'", item->min_Text );
			    else
				FPuts( Files->Std, Null );
			}
		    }

		    FPuts( Files->Std, ", " );

		    if(!( item->min_NumSubs )) {
			if( item->min_CommKey[0] ) {
			    if( smart )
				FPrintf( Files->Std, "%s", (FindString( &Files->Strings, item->min_CommKey ))->Label );
			    else
				FPrintf( Files->Std, "'%s'", item->min_CommKey );
			} else
			    FPuts( Files->Std, Null );
		    } else {
			FPuts( Files->Std, Null );
		    }

		    FPrintf( Files->Std, ", $%lx, %ld, ", item->min_Flags, item->min_MutualExclude );

		    if(( IE->C_Prefs & CLICKED ) && (!( item->min_NumSubs )) && (!( item->min_Flags & M_BARLABEL ))) {
			TEXT    Label[60];

			StrToLower( item->min_Label, Label );

			FPrintf( Files->Std, "{%smenued}", Label );

			if( IE->C_Prefs & GEN_TEMPLATE )
			    FPrintf( Files->Temp, MenuTmp, Label, buffer );

		    } else {
			FPuts( Files->Std, Null );
		    }

		    FPuts( Files->Std, ",\n" );

		    strcat( buffer, "/" );

		    for( sub = item->min_Subs.mlh_Head; sub->msn_Node.ln_Succ; sub = sub->msn_Node.ln_Succ ) {

			lens = strlen( sub->msn_Text );
			strcat( buffer, sub->msn_Text );

			str = sub->msn_Image ? "\t    IM_SUB" : "\t    NM_SUB";
			FPuts( Files->Std, str );

			FPuts( Files->Std, ", " );

			if( sub->msn_Flags & M_BARLABEL ) {
			    FPuts( Files->Std, "NM_BARLABEL" );
			} else {
			    if( img = sub->msn_Image ) {
				TEXT    Label[60];

				(ULONG)img -= sizeof( struct Node );

				StrToLower( img->in_Label, Label );
				FPrintf( Files->Std, "{%simg}", Label );
			    } else {
				if( sub->msn_Text[0] )
				    if( smart )
					FPrintf( Files->Std, "%s", (FindString( &Files->Strings, sub->msn_Text ))->Label );
				    else
					FPrintf( Files->Std, "'%s'", sub->msn_Text );
				else
				    FPuts( Files->Std, Null );
			    }
			}

			FPuts( Files->Std, ", " );

			if( sub->msn_CommKey[0] ) {
			    if( smart )
				FPrintf( Files->Std, "%s", (FindString( &Files->Strings, sub->msn_CommKey ))->Label );
			    else
				FPrintf( Files->Std, "'%s'", sub->msn_CommKey );
			} else
			    FPuts( Files->Std, Null );

			FPrintf( Files->Std, ", $%lx, %ld, ", sub->msn_Flags, sub->msn_MutualExclude );

			if(( IE->C_Prefs & CLICKED ) && (!( sub->msn_Flags & M_BARLABEL ))) {
			    TEXT    Label[60];

			    StrToLower( sub->msn_Label, Label );

			    FPrintf( Files->Std, "{%smenued}", Label );

			    if( IE->C_Prefs & GEN_TEMPLATE )
				FPrintf( Files->Temp, MenuTmp, Label, buffer );

			} else {
			    FPuts( Files->Std, Null );
			}

			FPuts( Files->Std, ",\n" );

			buffer[ lent+leni+2 ] = '\0';
		    }

		    buffer[ lent+1 ] = '\0';
		}
	    }

	    FPuts( Files->Std, "\tNM_END, NIL, NIL, 0, 0, NIL ]:newmenu\n" );
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
    ULONG               loc;

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	if( wnd->wi_NumTexts ) {
	    TEXT    Label[60];

	    StrToLower( wnd->wi_Label, Label );

	    loc = IE->C_Prefs & SMART_STR;

	    if( IE->SrcFlags & LOCALIZE )
		loc = wnd->wi_Tags & W_LOC_TEXTS;

	    FPrintf( Files->Std, "\nDEF %sitext = [\n", Label );

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
		    TEXT    Label[30];

		    (ULONG)fnt -= sizeof( struct Node );

		    StrToLower( fnt->txa_Label, Label );
		    FPrintf( Files->Std, "{%s}", Label );
		} else {
		    FPuts( Files->Std, Null );
		}

		FPuts( Files->Std, ", " );

		if( loc )
		    FPrintf( Files->Std, "%s", (FindString( &Files->Strings, txt->itn_Text ))->Label );
		else
		    FPrintf( Files->Std, "'%s'", txt->itn_Text );

		if((!( IE->SrcFlags & FONTSENSITIVE )) && ( next != wnd->wi_NumTexts )) {
		    FPrintf( Files->Std, ", {%sitext[%ld]},\n", Label, next );
		    next += 1;
		} else {
		    FPuts( Files->Std, ", NIL,\n" );
		}
	    }

	    Flush( Files->Std );
	    Seek( Files->Std, -2, OFFSET_CURRENT );
	    FPuts( Files->Std, "\n]:intuitext\n" );

	}
    }
}
///
/// WriteImgStruct
void WriteImgStruct( struct GenFiles *Files, struct IE_Data *IE )
{
    struct ImageNode   *img;

    for( img = IE->Img_List.mlh_Head; img->in_Node.ln_Succ; img = img->in_Node.ln_Succ ) {

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

