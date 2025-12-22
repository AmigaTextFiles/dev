/***********************************************
**                                            **
**  ScrollerWindow.iex  ©1996 Simone Tellini  **
**                       All Rights Reserved  **
**                                            **
**  Based on:                                 **
**   scrollerwindow.c 0.3 by Christoph Feck   **
**                                            **
***********************************************/
/// Includes
#define INTUI_V36_NAMES_ONLY

#include <exec/nodes.h>                 // exec
#include <exec/lists.h>
#include <exec/memory.h>
#include <exec/types.h>
#include <dos/dos.h>                    // dos
#include <intuition/intuition.h>        // intuition
#include <intuition/classusr.h>
#include <intuition/imageclass.h>
#include <intuition/icclass.h>
#include <intuition/gadgetclass.h>
#include <clib/exec_protos.h>           // protos
#include <clib/dos_protos.h>
#include <clib/intuition_protos.h>
#include <pragmas/exec_pragmas.h>       // pragmas
#include <pragmas/dos_pragmas.h>
#include <pragmas/graphics_pragmas.h>
#include <pragmas/intuition_pragmas.h>

#include <stdarg.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#include "DEV_IE:Expanders/defs.h"
///
/// Prototypes
struct ObjInfo {
	struct  Node    Node;
	UWORD           Kind;
	UBYTE           Flags;
	Object         *HorizGad;
	Object         *VertGad;
	Object         *LeftGad;
	Object         *RightGad;
	Object         *UpGad;
	Object         *DownGad;
	Object         *SizeImg;
	Object         *LeftImg;
	Object         *RightImg;
	Object         *UpImg;
	Object         *DownImg;
};

#define IM(o) ((struct Image *)o)
#define GAD(o) ((struct Gadget *)o)

#define MAX(x,y) ((x) > (y) ? (x) : (y))
#define MIN(x,y) ((x) < (y) ? (x) : (y))

static int SysISize( struct IE_Data * );
///


/*  Support function            */
/// SysISize
int SysISize( struct IE_Data *IE )
{
    return(( IE->ScreenData->Screen->Flags & SCREENHIRES ) ?
	     SYSISIZE_MEDRES : SYSISIZE_LOWRES );
}
///


/*  Starting function           */
/// IEX_Mount
__geta4 ULONG IEX_Mount( __A0 struct IE_Data *IE )
{
    BPTR                    DescFile;
    struct FileInfoBlock   *fib;
    ULONG                   ret = IEX_ERROR_NO_DESC_FILE;
    static UBYTE            FileName[] = "PROGDIR:Expanders/ScrollerWindow.desc";

    Forbid();   /* we're going to write to a GLOBAL variable */

    if( Desc ) {            /* already mounted? */
	Permit();
	return( IEX_OK );
    }

    LibBase->Kind      = IEX_OBJECT_KIND;

    LibBase->Resizable = FALSE;
    LibBase->Movable   = FALSE;
    LibBase->HasItems  = FALSE;
    LibBase->UseFonts  = FALSE;

    LibBase->Node.ln_Name = "SCROLLER WINDOW";

    if( fib = AllocDosObject( DOS_FIB, NULL )) {
	if( DescFile = Lock( FileName, ACCESS_READ )) {

	    Examine( DescFile, fib );
	    UnLock( DescFile );

	    if( Desc = AllocVec( fib->fib_Size, 0L )) {
		if( DescFile = Open( FileName, MODE_OLDFILE )) {

		    Read( DescFile, Desc, fib->fib_Size );
		    Close( DescFile );

		    ( *IE->IEXFun->SplitLines )( Desc ); // VERY important!

		    STRPTR pri;

		    pri = ( *IE->IEXFun->GetFirstLine )( Desc, "RENDPRI" );

		    if( pri )
			LibBase->Node.ln_Pri = atoi( pri );
		    else
			LibBase->Node.ln_Pri = 0;

		    ret = IEX_OK;

		} else {
		    FreeVec( Desc );
		    Desc = NULL;
		}
	    }

	}

	FreeDosObject( DOS_FIB, fib );
    }

    Permit();

    return( ret );
}
///


/*  Edit functions              */
/// IEX_Add
__geta4 BOOL IEX_Add( __D0 UWORD ID, __A0 struct IE_Data *IE, __D1 WORD x, __D2 WORD y, __D3 UWORD width, __D4 UWORD height )
{
    struct ObjInfo *Obj;
    BOOL            ret = FALSE;

    for( Obj = IE->win_info->wi_Gadgets.mlh_Head; Obj->Node.ln_Succ; Obj = Obj->Node.ln_Succ )
	if( Obj->Kind == ID ) {
	    Remove(( struct Node * )Obj );
	    FreeMem( Obj, sizeof( struct ObjInfo ));
	    return( TRUE );
	}

    if( Obj = AllocMem( sizeof( struct ObjInfo ), MEMF_CLEAR )) {

	Obj->Kind   = ID;       /* DON'T FORGET!!! */

	/* add our object to the list */
	AddTail((struct List *)&IE->win_info->wi_Gadgets, (struct Node *)Obj );

	IE->win_info->wi_NumObjects += 1;

	/* set the right values */
	IE->win_info->wi_Flags |= WFLG_SIZEGADGET;
	IE->win_info->wi_IDCMP |= ( IDCMP_NEWSIZE | IDCMP_SIZEVERIFY | IDCMP_IDCMPUPDATE );
	IE->win_info->wi_MaxWidth  = 0;
	IE->win_info->wi_MaxHeight = 0;

	ret = TRUE;
    }

    return( ret );
}
///
/// IEX_Remove
__geta4 void IEX_Remove( __D0 UWORD ID, __A0 struct IE_Data *IE )
{
    struct ObjInfo   *Obj;

    IEX_Free( ID, IE );     /* make sure to release all memory */

    for( Obj = IE->win_info->wi_Gadgets.mlh_Head; Obj->Node.ln_Succ; Obj = Obj->Node.ln_Succ ) {
	if(( Obj->Kind == ID ) && ( Obj->Flags & G_ATTIVO )) {

	    Remove(( struct Node * )Obj );
	    IE->win_info->wi_NumObjects -= 1;
	    FreeMem( Obj, sizeof( struct ObjInfo ));

	    return;
	}
    }
}
///
/// IEX_Edit
__geta4 BOOL IEX_Edit( __D0 UWORD ID, __A0 struct IE_Data *IE )
{
    return( FALSE );
}
///
/// IEX_Copy
__geta4 BOOL IEX_Copy( __D0 UWORD ID, __A0 struct IE_Data *IE, __D1 WORD offx, __D2 WORD offy )
{
    return( TRUE );
}
///
/// IEX_Make
__geta4 struct Gadget *IEX_Make( __D0 UWORD ID, __A0 struct IE_Data *IE, __A1 struct Gadget *glist )
{
    struct ObjInfo     *Obj;
    struct DrawInfo    *dri;

    if(!( dri = GetScreenDrawInfo( IE->ScreenData->Screen ))) {
	DisplayBeep( IE->ScreenData->Screen );
	return( glist );
    }

    for( Obj = IE->win_info->wi_Gadgets.mlh_Head; Obj->Node.ln_Succ; Obj = Obj->Node.ln_Succ ) {
	if( Obj->Kind == ID ) {

	    if(!( Obj->SizeImg = NewObject( NULL, SYSICLASS,
					  SYSIA_DrawInfo, dri,
					  SYSIA_Which, SIZEIMAGE,
					  SYSIA_Size, SysISize( IE ),
					  TAG_DONE )))
		goto error;

	    if(!( Obj->LeftImg = NewObject( NULL, SYSICLASS,
					  SYSIA_DrawInfo, dri,
					  SYSIA_Which, LEFTIMAGE,
					  SYSIA_Size, SysISize( IE ),
					  TAG_DONE )))
		goto error;

	    if(!( Obj->RightImg = NewObject( NULL, SYSICLASS,
					  SYSIA_DrawInfo, dri,
					  SYSIA_Which, RIGHTIMAGE,
					  SYSIA_Size, SysISize( IE ),
					  TAG_DONE )))
		goto error;

	    if(!( Obj->UpImg = NewObject( NULL, SYSICLASS,
					  SYSIA_DrawInfo, dri,
					  SYSIA_Which, UPIMAGE,
					  SYSIA_Size, SysISize( IE ),
					  TAG_DONE )))
		goto error;

	    if(!( Obj->DownImg = NewObject( NULL, SYSICLASS,
					  SYSIA_DrawInfo, dri,
					  SYSIA_Which, DOWNIMAGE,
					  SYSIA_Size, SysISize( IE ),
					  TAG_DONE )))
		goto error;

	    int resolution = SysISize( IE );
	    WORD topborder = IE->ScreenData->YOffset + 1;
	    WORD w = IM( Obj->SizeImg )->Width;
	    WORD h = IM( Obj->SizeImg )->Height;
	    WORD bw = (resolution == SYSISIZE_LOWRES) ? 1 : 2;
	    WORD bh = (resolution == SYSISIZE_HIRES) ? 2 : 1;
	    WORD rw = (resolution == SYSISIZE_HIRES) ? 3 : 2;
	    WORD rh = (resolution == SYSISIZE_HIRES) ? 2 : 1;
	    WORD gw, gh;

	    gh = MAX( IM( Obj->LeftImg )->Height, h );
	    gh = MAX( IM( Obj->RightImg )->Height, gh );
	    gw = MAX( IM( Obj->UpImg )->Width, w );
	    gw = MAX( IM( Obj->DownImg )->Width, gw );

	    if(!( Obj->HorizGad = NewObject( NULL, PROPGCLASS,
					     PGA_Freedom, FREEHORIZ,
					     PGA_NewLook, TRUE,
					     PGA_Borderless, ((dri->dri_Flags & DRIF_NEWLOOK) && dri->dri_Depth |= 1),
					     GA_Left, rw + 1,
					     GA_RelBottom, bh - gh + 2,
					     GA_RelWidth, -gw - 1 - IM(Obj->LeftImg)->Width - IM(Obj->RightImg)->Width - rw - rw,
					     GA_Height, gh - bh - bh - 2,
					     GA_BottomBorder, TRUE,
					     GA_Previous, glist,
					     TAG_DONE )))
		goto error;

	    if(!( Obj->VertGad = NewObject( NULL, PROPGCLASS,
					     PGA_Freedom, FREEVERT,
					     PGA_NewLook, TRUE,
					     PGA_Borderless, ((dri->dri_Flags & DRIF_NEWLOOK) && dri->dri_Depth |= 1),
					     GA_Top, topborder + rh,
					     GA_RelRight, bw - gw + 3,
					     GA_RelHeight, -topborder - h - IM(Obj->UpImg)->Height - IM(Obj->DownImg)->Height - rh - rh,
					     GA_Width, gw - bw - bw - 4,
					     GA_RightBorder, TRUE,
					     GA_Previous, Obj->HorizGad,
					     TAG_DONE )))
		goto error;

	    if(!( Obj->LeftGad = NewObject( NULL, BUTTONGCLASS,
					     GA_Image, Obj->LeftImg,
					     GA_RelRight, 1 - IM(Obj->LeftImg)->Width - IM(Obj->RightImg)->Width - gw,
					     GA_RelBottom, 1 - IM(Obj->LeftImg)->Height,
					     GA_BottomBorder, TRUE,
					     GA_Previous, Obj->VertGad,
					     TAG_DONE )))
		goto error;

	    if(!( Obj->RightGad = NewObject( NULL, BUTTONGCLASS,
					     GA_Image, Obj->RightImg,
					     GA_RelRight, 1 - IM(Obj->RightImg)->Width - gw,
					     GA_RelBottom, 1 - IM(Obj->RightImg)->Height,
					     GA_BottomBorder, TRUE,
					     GA_Previous, Obj->LeftGad,
					     TAG_DONE )))
		goto error;

	    if(!( Obj->UpGad = NewObject( NULL, BUTTONGCLASS,
					     GA_Image, Obj->UpImg,
					     GA_RelRight, 1 - IM(Obj->UpImg)->Width,
					     GA_RelBottom, 1 - IM(Obj->UpImg)->Height - IM(Obj->DownImg)->Height - h,
					     GA_RightBorder, TRUE,
					     GA_Previous, Obj->RightGad,
					     TAG_DONE )))
		goto error;

	    if(!( Obj->DownGad = NewObject( NULL, BUTTONGCLASS,
					     GA_Image, Obj->DownImg,
					     GA_RelRight, 1 - IM(Obj->DownImg)->Width,
					     GA_RelBottom, 1 - IM(Obj->DownImg)->Height - h,
					     GA_RightBorder, TRUE,
					     GA_Previous, Obj->UpGad,
					     TAG_DONE )))
		goto error;

	    glist = Obj->DownGad;

	    break;
	}
    }

    FreeScreenDrawInfo( IE->ScreenData->Screen, dri );

    return( glist );

error:

    IEX_Free( ID, IE );

    return( glist );
}
///
/// IEX_Free
__geta4 void IEX_Free( __D0 UWORD ID, __A0 struct IE_Data *IE )
{
    struct ObjInfo *Obj;

    for( Obj = IE->win_info->wi_Gadgets.mlh_Head; Obj->Node.ln_Succ; Obj = Obj->Node.ln_Succ )
	if( Obj->Kind == ID ) {

	    DisposeObject( Obj->HorizGad );
	    DisposeObject( Obj->VertGad );
	    DisposeObject( Obj->UpGad );
	    DisposeObject( Obj->DownGad );
	    DisposeObject( Obj->LeftGad );
	    DisposeObject( Obj->RightGad );

	    DisposeObject( Obj->SizeImg );
	    DisposeObject( Obj->UpImg );
	    DisposeObject( Obj->DownImg );
	    DisposeObject( Obj->LeftImg );
	    DisposeObject( Obj->RightImg );

	    Obj->HorizGad = NULL;
	    Obj->VertGad = NULL;
	    Obj->UpGad = NULL;
	    Obj->DownGad = NULL;
	    Obj->LeftGad = NULL;
	    Obj->RightGad = NULL;

	    Obj->SizeImg = NULL;
	    Obj->UpImg = NULL;
	    Obj->DownImg = NULL;
	    Obj->LeftImg = NULL;
	    Obj->RightImg = NULL;

	    return;  /* there could be only one object of this kind */
		     /* in a window */
	}
}
///
/// IEX_Refresh
__geta4 void IEX_Refresh( __D0 UWORD ID, __A0 struct IE_Data *IE )
{
}
///


/*  I/O Functions               */
/// IEX_Save
__geta4 void IEX_Save( __D0 UWORD ID, __A0 struct IE_Data *IE, __D1 BPTR File )
{
}
///
/// IEX_Load
__geta4 BOOL IEX_Load( __D0 UWORD ID, __A0 struct IE_Data *IE, __D1 BPTR File, __D2 UWORD Num )
{
    struct ObjInfo   *Obj;

    if( Obj = AllocMem( sizeof( struct ObjInfo ), MEMF_CLEAR )) {

	Obj->Kind = ID;  /* VERY important!!! */

	AddTail(( struct List * )&IE->win_info->wi_Gadgets, ( struct Node * )Obj );

    } else
	return( FALSE );

    return( TRUE );
}
///


/*  Source related functions    */
/// IEX_StartSrcGen
__geta4 STRPTR IEX_StartSrcGen( __D0 UWORD ID, __A0 struct IE_Data *IE )
{
    struct WindowInfo  *wnd;
    struct ObjInfo     *Obj;

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	if( wnd->wi_NumObjects ) {
	    for( Obj = wnd->wi_Gadgets.mlh_Head; Obj->Node.ln_Succ; Obj = Obj->Node.ln_Succ ) {
		if( Obj->Kind == ID ) {
		    wnd->wi_NeedRender = TRUE;
		    wnd->wi_NoOpenWnd  = TRUE;
		    break; /* next window */
		}
	    }
	}
    }

    return(( *IE->IEXFun->GetFirstLine )( Desc, "SUPPORT" ));
}
///
/// IEX_WriteGlobals
__geta4 void IEX_WriteGlobals( __D0 UWORD ID, __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{
    STRPTR string;

    if( string = ( *IE->IEXFun->GetFirstLine )( Desc, "GLOBAL" ))
	FPuts( Files->Std, string );
}
///
/// IEX_WriteSetup
__geta4 void IEX_WriteSetup( __D0 UWORD ID, __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{
    STRPTR string;

    if( string = ( *IE->IEXFun->GetFirstLine )( Desc, "SETUP" ))
	FPuts( Files->Std, string );
}
///
/// IEX_WriteCloseDown
__geta4 void IEX_WriteCloseDown( __D0 UWORD ID, __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{
    STRPTR string;

    if( string = ( *IE->IEXFun->GetFirstLine )( Desc, "CLOSEDOWN" ))
	FPuts( Files->Std, string );
}
///
/// IEX_WriteHeaders
__geta4 void IEX_WriteHeaders( __D0 UWORD ID, __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{
    STRPTR string;

    if( string = ( *IE->IEXFun->GetFirstLine )( Desc, "HEADER" ))
	FPuts( Files->XDef, string );

    if( string = ( *IE->IEXFun->GetFirstLine )( Desc, "INCLUDE" ))
	FPuts( Files->Std, string );
}
///
/// IEX_WriteRender
__geta4 void IEX_WriteRender( __D0 UWORD ID, __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{
    struct Descriptor   Dsc[] = {
	{ 'w', IE->win_info->wi_Label },
	{ 0, NULL }
    };
    struct ObjInfo     *Obj;
    STRPTR              String;

    if( IE->win_info->wi_NumObjects ) {
	if( String = ( *IE->IEXFun->GetFirstLine )( Desc, "RENDER" )) {

	    for( Obj = IE->win_info->wi_Gadgets.mlh_Head; Obj->Node.ln_Succ; Obj = Obj->Node.ln_Succ ) {
		if( Obj->Kind == ID ) {

		    ( *IE->IEXFun->WriteFormatted )( Files->Std, String, &Dsc[0] );

		    return;
		}
	    }
	}
    }
}
///
/// IEX_GetIDCMP
__geta4 ULONG IEX_GetIDCMP( __D0 UWORD ID, __D1 ULONG idcmp, __A0 struct IE_Data *IE )
{
    return( idcmp );
}
///
/// IEX_WriteData
__geta4 void IEX_WriteData( __D0 UWORD ID, __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{
    struct Descriptor   Dsc[] = {
	{ 'w', NULL },
	{ 0, NULL }
    };
    struct ObjInfo     *Obj;
    struct WindowInfo  *wnd;
    STRPTR              String;

    if( String = ( *IE->IEXFun->GetFirstLine )( Desc, "DATA" )) {
	for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	    if( wnd->wi_NumObjects ) {
		for( Obj = wnd->wi_Gadgets.mlh_Head; Obj->Node.ln_Succ; Obj = Obj->Node.ln_Succ ) {
		    if( Obj->Kind == ID ) {

			Dsc[0].Meaning = wnd->wi_Label;

			( *IE->IEXFun->WriteFormatted )( Files->Std, String, &Dsc[0] );

			break;
		    }
		}
	    }
	}
    }
}
///
/// IEX_WriteChipData
__geta4 void IEX_WriteChipData( __D0 UWORD ID, __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{
}
///
/// IEX_WriteOpenWnd
__geta4 void IEX_WriteOpenWnd( __D0 UWORD ID, __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{
    struct Descriptor   Dsc[] = {
	{ 'w', IE->win_info->wi_Label },
	{ 'n', NULL },
	{ 0, NULL }
    };
    struct ObjInfo     *Obj;
    STRPTR              String;

    if( IE->win_info->wi_NumObjects ) {
	if( String = ( *IE->IEXFun->GetFirstLine )( Desc, "OPENWND" )) {

	    for( Obj = IE->win_info->wi_Gadgets.mlh_Head; Obj->Node.ln_Succ; Obj = Obj->Node.ln_Succ ) {
		if( Obj->Kind == ID ) {

		    ( *IE->IEXFun->WriteFormatted )( Files->Std, String, &Dsc[0] );

		    /*
			   This expanders provides a brand new
			   Open<Window Label>Window routine for
			   every scroller window.

			   So far, it supports only windows with
			   menus.
		    */

		    if( IE->SrcFlags & LOCALIZE ) {

			if( String = ( *IE->IEXFun->GetFirstLine )( Desc, "OPENWND-LOCALE" )) {
			    ULONG               cnt = 0;
			    TEXT                num[4];
			    struct WindowInfo  *w;

			    for( w = IE->win_list.mlh_Head; w->wi_succ; w = w->wi_succ, cnt++ )
				if( w == IE->win_info )
				    break;

			    sprintf( num, "%ld", cnt );

			    Dsc[1].Meaning = num;

			    ( *IE->IEXFun->WriteFormatted )( Files->Std, String, &Dsc[0] );

			    if( IE->win_info->wi_NumMenus )
				if( String = ( *IE->IEXFun->GetFirstLine )( Desc, "OPENWND-LOCALE-MENUS" ))
				    ( *IE->IEXFun->WriteFormatted )( Files->Std, String, &Dsc[0] );

			    if( String = ( *IE->IEXFun->GetFirstLine )( Desc, "OPENWND-LOCALE-2" ))
				( *IE->IEXFun->WriteFormatted )( Files->Std, String, &Dsc[0] );
			}
		    }

		    if( IE->win_info->wi_NumMenus )
			if( String = ( *IE->IEXFun->GetFirstLine )( Desc, "OPENWND-MENUS" ))
			    ( *IE->IEXFun->WriteFormatted )( Files->Std, String, &Dsc[0] );

		    if( String = ( *IE->IEXFun->GetFirstLine )( Desc, "OPENWND-2" ))
			( *IE->IEXFun->WriteFormatted )( Files->Std, String, &Dsc[0] );

		    if( IE->win_info->wi_NumMenus )
			if( String = ( *IE->IEXFun->GetFirstLine )( Desc, "OPENWND-MENUS-2" ))
			    ( *IE->IEXFun->WriteFormatted )( Files->Std, String, &Dsc[0] );

		    if( String = ( *IE->IEXFun->GetFirstLine )( Desc, "OPENWND-END" ))
			( *IE->IEXFun->WriteFormatted )( Files->Std, String, &Dsc[0] );

		    if( String = ( *IE->IEXFun->GetFirstLine )( Desc, "EXTERN" ))
			( *IE->IEXFun->WriteFormatted )( Files->XDef, String, &Dsc[0] );

		    return;
		}
	    }
	}
    }
}
///
/// IEX_WriteCloseWnd
__geta4 void IEX_WriteCloseWnd( __D0 UWORD ID, __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{
    struct Descriptor   Dsc[] = {
	{ 'w', IE->win_info->wi_Label },
	{ 0, NULL }
    };
    struct ObjInfo     *Obj;
    STRPTR              String;

    if( IE->win_info->wi_NumObjects ) {
	if( String = ( *IE->IEXFun->GetFirstLine )( Desc, "CLOSEWND" )) {

	    for( Obj = IE->win_info->wi_Gadgets.mlh_Head; Obj->Node.ln_Succ; Obj = Obj->Node.ln_Succ ) {
		if( Obj->Kind == ID ) {

		    ( *IE->IEXFun->WriteFormatted )( Files->Std, String, &Dsc[0] );

		    return;
		}
	    }
	}
    }
}
///
