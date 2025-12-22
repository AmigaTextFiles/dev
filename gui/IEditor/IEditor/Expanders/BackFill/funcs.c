/// Includes
#define INTUI_V36_NAMES_ONLY

#include <exec/nodes.h>                 // exec
#include <exec/lists.h>
#include <exec/memory.h>
#include <exec/types.h>
#include <dos/dos.h>                    // dos
#include <intuition/intuition.h>        // intuition
#include <intuition/gadgetclass.h>
#include <graphics/text.h>              // graphics
#include <graphics/gfxmacros.h>
#include <libraries/gadtools.h>         // libraries
#include <clib/exec_protos.h>           // protos
#include <clib/dos_protos.h>
#include <clib/intuition_protos.h>
#include <clib/graphics_protos.h>
#include <pragmas/exec_pragmas.h>       // pragmas
#include <pragmas/dos_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <pragmas/graphics_pragmas.h>


#include <stdarg.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#include "DEV_IE:Expanders/defs.h"
///
/// Prototypes
/* we use the minimal version of the ObjectInfo */
struct BFInfo {
	struct Node Node;
	UWORD       Kind;
	UBYTE       Flags;
};
///



/*  Starting function           */
/// IEX_Mount
__geta4 ULONG IEX_Mount( __A0 struct IE_Data *IE )
{
    BPTR                    DescFile;
    struct FileInfoBlock   *fib;
    ULONG                   ret = IEX_ERROR_NO_DESC_FILE;
    static UBYTE            FileName[] = "PROGDIR:Expanders/BackFill.desc";

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

    LibBase->Node.ln_Name = "BACK FILL";

    Permit();

    if( fib = AllocDosObject( DOS_FIB, NULL )) {
	if( DescFile = Lock( FileName, ACCESS_READ )) {

	    Examine( DescFile, fib );
	    UnLock( DescFile );

	    if( Desc = AllocVec( fib->fib_Size, 0L )) {
		if( DescFile = Open( FileName, MODE_OLDFILE )) {
		    STRPTR pri;

		    Read( DescFile, Desc, fib->fib_Size );
		    Close( DescFile );

		    ( *IE->IEXFun->SplitLines )( Desc ); // VERY important!

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

    return( ret );
}
///


/*  Edit functions              */
/// IEX_Add
__geta4 BOOL IEX_Add( __D0 UWORD ID, __A0 struct IE_Data *IE, __D1 WORD x, __D2 WORD y, __D3 UWORD width, __D4 UWORD height )
{
    struct BFInfo  *bf;
    BOOL            ret = FALSE;

    /* we're a /toggle/ object ;-) */
    bf = IE->win_info->wi_Gadgets.mlh_Head;
    while(( bf->Node.ln_Succ ) && ( bf->Kind != ID ))
	bf = bf->Node.ln_Succ;

    if( bf->Node.ln_Succ ) {
	IE->win_info->wi_NumObjects -= 1;

	Remove(( struct Node * )bf );
	FreeMem( bf, sizeof( struct BFInfo ));

	return( TRUE );
    }

    if( bf = AllocMem( sizeof( struct BFInfo ), MEMF_CLEAR )) {

	bf->Kind   = ID;       /* DON'T FORGET!!! */

	/* add our object to the list */
	AddTail((struct List *)&IE->win_info->wi_Gadgets, (struct Node *)bf );

	IE->win_info->wi_NumObjects += 1;

	ret = TRUE;
    }

    return( ret );
}
///
/// IEX_Remove
__geta4 void IEX_Remove( __D0 UWORD ID, __A0 struct IE_Data *IE )
{
    struct BFInfo  *bf;

    for( bf = IE->win_info->wi_Gadgets.mlh_Head; bf->Node.ln_Succ; bf = bf->Node.ln_Succ )
	if(( bf->Kind == ID ) && ( bf->Flags & G_ATTIVO )) {
	    struct BFInfo *bf2 = bf->Node.ln_Pred;
	    Remove(( struct Node * )bf );
	    FreeMem( bf, sizeof( struct BFInfo ));
	    bf = bf2;
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
    /*  We don't need to make anything  */
    return( glist );
}
///
/// IEX_Free
__geta4 void IEX_Free( __D0 UWORD ID, __A0 struct IE_Data *IE )
{
    /*  We've got nothing to free when the window is closed  */
}
///
/// IEX_Refresh
__geta4 void IEX_Refresh( __D0 UWORD ID, __A0 struct IE_Data *IE )
{
    struct BFInfo *bf;

    for( bf = IE->win_info->wi_Gadgets.mlh_Head; bf->Node.ln_Succ; bf = bf->Node.ln_Succ ) {
	/*  always check the Kind  */
	if( bf->Kind == ID ) {
	    struct DrawInfo *dri;
	    static UWORD Pattern[2] = { 0xAAAA, 0x5555 };

	    if( dri = GetScreenDrawInfo( IE->ScreenData->Screen )) {
		WORD    x1, y1, x2, y2;

		SetAPen( IE->win_info->wi_winptr->RPort, dri->dri_Pens[ SHINEPEN ]);
		SetAfPt( IE->win_info->wi_winptr->RPort, &Pattern[0], 1 );

		x1 = IE->win_info->wi_winptr->BorderLeft;
		y1 = IE->win_info->wi_winptr->BorderTop;
		x2 = IE->win_info->wi_winptr->Width - IE->win_info->wi_winptr->BorderRight - 1;
		y2 = IE->win_info->wi_winptr->Height - IE->win_info->wi_winptr->BorderBottom - 1;

		if(( x2 >= x1 ) && ( y2 >= y1 ))
		    RectFill( IE->win_info->wi_winptr->RPort, x1, y1, x2, y2 );

		SetAfPt( IE->win_info->wi_winptr->RPort, NULL, 0 );

		FreeScreenDrawInfo( IE->ScreenData->Screen, dri );
	    }

	    return; /* there's just one BackFill a window...  */
	}
    }
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
    struct BFInfo   *bf;

    if( bf = AllocMem( sizeof( struct BFInfo ), MEMF_CLEAR )) {

	bf->Kind = ID;  /* VERY important!!! */

	AddTail(( struct List * )&IE->win_info->wi_Gadgets, ( struct Node * )bf );

    } else
	return( FALSE );

    return( TRUE );
}
///


/*  Source related functions    */
/// IEX_StartSrcGen
__geta4 STRPTR IEX_StartSrcGen( __D0 UWORD ID, __A0 struct IE_Data *IE )
{
    struct WindowInfo *wnd;
    struct BFInfo     *bf;

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	if( wnd->wi_NumObjects ) {
	    for( bf = wnd->wi_Gadgets.mlh_Head; bf->Node.ln_Succ; bf = bf->Node.ln_Succ ) {
		if( bf->Kind == ID ) {
		    wnd->wi_NeedRender = TRUE;
		    break;
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
    UBYTE   *String;

    if( String = ( *IE->IEXFun->GetFirstLine )( Desc, "GLOBAL" ))
	FPuts( Files->Std, String );
}
///
/// IEX_WriteSetup
__geta4 void IEX_WriteSetup( __D0 UWORD ID, __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{
}
///
/// IEX_WriteCloseDown
__geta4 void IEX_WriteCloseDown( __D0 UWORD ID, __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{
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
    struct BFInfo   *bf;
    STRPTR           String;

    if(( IE->win_info->wi_NumObjects ) && ( String = ( *IE->IEXFun->GetFirstLine )( Desc, "RENDER" ))) {
	for( bf = IE->win_info->wi_Gadgets.mlh_Head; bf->Node.ln_Succ; bf = bf->Node.ln_Succ ) {
	    if( bf->Kind == ID ) {
		( *IE->IEXFun->WriteFormatted )( Files->Std, String, &Dsc[0] );
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
}
///
/// IEX_WriteCloseWnd
__geta4 void IEX_WriteCloseWnd( __D0 UWORD ID, __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{
}
///
