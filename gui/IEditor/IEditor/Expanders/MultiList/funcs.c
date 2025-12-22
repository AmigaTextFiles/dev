/// Includes
#define INTUI_V36_NAMES_ONLY

#include <exec/nodes.h>                 // exec
#include <exec/lists.h>
#include <exec/memory.h>
#include <exec/types.h>
#include <dos/dos.h>                    // dos
#include <intuition/intuition.h>        // intuition
#include <clib/exec_protos.h>           // protos
#include <clib/dos_protos.h>
#include <clib/gadtools_protos.h>
#include <pragmas/exec_pragmas.h>       // pragmas
#include <pragmas/dos_pragmas.h>
#include <pragmas/graphics_pragmas.h>
#include <pragmas/gadtools_pragmas.h>

#include <stdarg.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#include "DEV_IE:Expanders/defs.h"
///
/// Prototypes
/* we use a cut-down version of the ObjectInfo */
struct ObjectInfo {
	struct  Node    Node;
	UWORD           Kind;
	UBYTE           Flags;
	UBYTE           Pad;
	APTR            Reserved;
	UBYTE           Reserved2[80];
	UBYTE           Reserved3[40];
	WORD            User1;
	WORD            User2;
	WORD            Left;
	WORD            Top;
	UWORD           Width;
	UWORD           Height;
};
///



/*  Starting function           */
/// IEX_Mount
__geta4 ULONG IEX_Mount( __A0 struct IE_Data *IE )
{
    BPTR                    DescFile;
    struct FileInfoBlock   *fib;
    ULONG                   ret = IEX_ERROR_NO_DESC_FILE;
    static UBYTE            FileName[] = "PROGDIR:Expanders/MultiList.desc";

    Forbid();   /* we're going to write to a GLOBAL variable */

    if( Desc ) {            /* already mounted? */
	Permit();
	return( IEX_OK );
    }

    LibBase->Kind      = IEX_OBJECT_KIND;

    LibBase->Resizable = TRUE;
    LibBase->Movable   = TRUE;
    LibBase->HasItems  = TRUE;
    LibBase->UseFonts  = TRUE;

    LibBase->Node.ln_Name = "MULTISELECT LISTVIEW";

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
    struct ObjectInfo   *Object;
    BOOL                ret = FALSE;

    if( Object = AllocMem( sizeof( struct ObjectInfo ), MEMF_CLEAR )) {

	Object->Kind   = ID;       /* DON'T FORGET!!! */
	Object->Left   = x;
	Object->Top    = y;
	Object->Width  = width;
	Object->Height = height;
	Object->Flags  = G_ATTIVO; /* make it active  */

	/* add our object to the list */
	AddTail((struct List *)&IE->win_info->wi_Gadgets, (struct Node *)Object );

	IE->win_info->wi_NumObjects += 1;

	ret = TRUE;
    }

    return( ret );
}
///
/// IEX_Remove
__geta4 void IEX_Remove( __D0 UWORD ID, __A0 struct IE_Data *IE )
{
    struct ObjectInfo   *Object, *next;

    for( Object = IE->win_info->wi_Gadgets.mlh_Head; Object->Node.ln_Succ; Object = Object->Node.ln_Succ ) {
	/* remove only the objects of our kind and that are selected  */
	if(( Object->Kind == ID ) && ( Object->Flags & G_ATTIVO )) {
	    next = Object->Node.ln_Pred;

	    Remove(( struct Node * )Object );

	    IE->win_info->wi_NumObjects -= 1;

	    FreeMem( Object, sizeof( struct ObjectInfo ));
	    Object = next;
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
    struct ObjectInfo   *Object, *copy;

    for( Object = IE->win_info->wi_Gadgets.mlh_Head; Object->Node.ln_Succ; Object = Object->Node.ln_Succ ) {
	if(( Object->Kind == ID ) && ( Object->Flags & G_ATTIVO )) {

	    if( copy = AllocMem( sizeof( struct ObjectInfo ), 0L )) {

		CopyMem((char *)Object, (char *)copy, (long)sizeof( struct ObjectInfo ));

		AddTail((struct List *)&IE->win_info->wi_Gadgets, (struct Node *)copy );

		IE->win_info->wi_NumObjects += 1; /* Don't forget! */

		copy->Left += offx;  /* update its position */
		copy->Top  += offy;

		/* I don't want a neverending loop... ;-) */
		copy->Flags &= ~G_ATTIVO;

	    } else
		return( FALSE );
	}
    }

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
    struct ObjectInfo *Object;

    for( Object = IE->win_info->wi_Gadgets.mlh_Head; Object->Node.ln_Succ; Object = Object->Node.ln_Succ ) {
	/*  always check the Kind  */
	if( Object->Kind == ID ) {

	    DrawObjectBox( IE->win_active->RPort,
			  Object->Left, Object->Top,
			  Object->Width, Object->Height,
			  GTBB_Recessed, TRUE,
			  GT_VisualInfo, IE->ScreenData->Visual, TAG_DONE );

	    SetAPen( IE->win_active->RPort, 0 );
	    RectFill( IE->win_active->RPort,
		      Object->Left + 2, Object->Top + 1,
		      Object->Left + Object->Width  - 3,
		      Object->Top  + Object->Height - 2  );
	}
    }
}
///


/*  I/O Functions               */
/// IEX_Save
__geta4 void IEX_Save( __D0 UWORD ID, __A0 struct IE_Data *IE, __D1 BPTR File )
{
    struct ObjectInfo   *Object;

    for( Object = IE->win_info->wi_Gadgets.mlh_Head; Object->Node.ln_Succ; Object = Object->Node.ln_Succ )
	if(( Object->Kind == ID ) && ( Object->Flags & G_ATTIVO ))
	    FWrite( File, &Object->Left, 8, 1 );
}
///
/// IEX_Load
__geta4 BOOL IEX_Load( __D0 UWORD ID, __A0 struct IE_Data *IE, __D1 BPTR File, __D2 UWORD Num )
{
    struct ObjectInfo   *Object;
    UWORD               cnt;

    for( cnt = 0; cnt < Num; cnt++ ) {
	if( Object = AllocMem( sizeof( struct ObjectInfo ), MEMF_CLEAR )) {

	    Object->Kind = ID;  /* VERY important!!! */

	    AddTail(( struct List * )&IE->win_info->wi_Gadgets, ( struct Node * )Object );

	    FRead( File, &Object->Left, 8, 1 );

	} else
	    return( FALSE );
    }

    return( TRUE );
}
///


/*  Source related functions    */
/// IEX_StartSrcGen
__geta4 STRPTR IEX_StartSrcGen( __D0 UWORD ID, __A0 struct IE_Data *IE )
{
    struct WindowInfo  *wnd;
    struct ObjectInfo   *Object;
    STRPTR              func;

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	if( wnd->wi_NumObjects ) {
	    for( Object = wnd->wi_Gadgets.mlh_Head; Object->Node.ln_Succ; Object = Object->Node.ln_Succ ) {
		if( Object->Kind == ID )
		    wnd->wi_NeedRender = TRUE;
	    }
	}
    }

    func = ( IE->SrcFlags & FONTSENSITIVE ) ? "SUPPORT-FA" : "SUPPORT";

    return(( *IE->IEXFun->GetFirstLine )( Desc, func ));
}
///
/// IEX_WriteGlobals
__geta4 void IEX_WriteGlobals( __D0 UWORD ID, __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{
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
}
///
/// IEX_WriteRender
__geta4 void IEX_WriteRender( __D0 UWORD ID, __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{
    UBYTE               X[6], Y[6], Width[6], Height[6];
    struct Descriptor   Dsc[] = {
	{ 'x', X },
	{ 'y', Y },
	{ 'W', Width },
	{ 'h', Height },
	{ 'w', IE->win_info->wi_Label },
	{ 'g', NULL },
	{ 0, NULL }
    };
    struct ObjectInfo   *Object;
    STRPTR              String;
    static UBYTE        ld[] = "%ld";

    if( IE->win_info->wi_NumObjects ) {
	if( String = ( *IE->IEXFun->GetFirstLine )( Desc, IE->win_info->wi_NumBools ? "RENDER-BOOL" : "RENDER" )) {

	    if( IE->win_info->wi_NumBools ) {
		struct BooleanInfo *bool;

		bool = IE->win_info->wi_Gadgets.mlh_Head;

		while( bool->b_Kind != BOOLEAN )
		    bool = bool->b_Node.ln_Succ;

		Dsc[5].Meaning = bool->b_Label;
	    }

	    for( Object = IE->win_info->wi_Gadgets.mlh_Head; Object->Node.ln_Succ; Object = Object->Node.ln_Succ ) {
		if( Object->Kind == ID ) {

		    sprintf( X, ld, Object->Left - IE->ScreenData->XOffset );
		    sprintf( Y, ld, Object->Top  - IE->ScreenData->YOffset );
		    sprintf( Width, ld, Object->Width );
		    sprintf( Height, ld, Object->Height );

		    ( *IE->IEXFun->WriteFormatted )( Files->Std, String, &Dsc[0] );
		}
	    }
	}
    }
}
///
/// IEX_GetIDCMP
__geta4 ULONG IEX_GetIDCMP( __D0 UWORD ID, __D1 ULONG idcmp, __A0 struct IE_Data *IE )
{
    struct WindowInfo  *wnd;
    struct ObjectInfo   *Object;

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ )
	for( Object = wnd->wi_Gadgets.mlh_Head; Object->Node.ln_Succ; Object = Object->Node.ln_Succ )
	    if( Object->Kind == ID )
		return( idcmp | LISTVIEWIDCMP );

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
