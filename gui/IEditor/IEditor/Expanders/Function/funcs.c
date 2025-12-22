/*
**  $VER: Function.iex 37.0 (3.5.96)
**
**  © 1996 Simone Tellini
**
**    Feel free to adapt it to your own needs.
**
**  PROGRAMNAME:  Function.iex
**
**  FUNCTION:     Add functions to gadgets
**
**  $HISTORY:
**
**   03 May 1996 : 37.0 : initial release
*/


/// Includes
#define INTUI_V36_NAMES_ONLY

#include <exec/nodes.h>                 // exec
#include <exec/lists.h>
#include <exec/memory.h>
#include <exec/types.h>
#include <dos/dos.h>                    // dos
#include <intuition/intuition.h>        // intuition
#include <rexx/storage.h>               // rexx
#include <rexx/errors.h>
#include <libraries/reqtools.h>         // libraries
#include <clib/exec_protos.h>           // protos
#include <clib/dos_protos.h>
#include <clib/reqtools_protos.h>
#include <pragmas/exec_pragmas.h>       // pragmas
#include <pragmas/dos_pragmas.h>
#include <pragmas/reqtools_pragmas.h>

#include <stdio.h>
#include <stdlib.h>

#include "DEV_IE:Expanders/defs.h"
///
/// Prototypes
/* we use a cut-down version of the ObjectInfo */
struct MyInfo {
	struct  Node        Node;
	UWORD               Kind;
	UBYTE               Flags;
	UBYTE               Pad;
	struct GadgetInfo  *Gadget; /* gadget the function is linked to     */
	APTR                Function;   /* function text                    */
};

static BOOL AddFunction( struct IE_Data *, struct GadgetInfo *, UWORD );
static APTR EditFunction( STRPTR );
static APTR FGetString( BPTR );
static void FPutString( BPTR, STRPTR );
static struct WindowInfo *GimmeWnd( ULONG *, struct IE_Data * );
static __geta4 ULONG AddFuncRexxed( __A0 ULONG *, __A1 struct RexxMsg *, __A2 struct IE_Data *, __D0 ULONG );
static __geta4 ULONG RemFuncRexxed( __A0 ULONG *, __A1 struct RexxMsg *, __A2 struct IE_Data *, __D0 ULONG );

extern struct Library *ReqToolsBase;
///
/// Data
static TEXT     Editor[256] = "C:Ed %s";
///


/*  Support routines            */
/// GimmeWnd
struct WindowInfo *GimmeWnd( ULONG *Cnt, struct IE_Data *IE )
{
    struct WindowInfo  *wnd;
    UWORD               c;

    if( Cnt ) {
	if( *Cnt <= IE->num_win ) {

	    wnd = (struct WindowInfo *)&IE->win_list;
	    for( c = 0; c < *Cnt; c++ )
		wnd = wnd->wi_succ;

	    return( wnd );
	}
    } else
	return( IE->win_info ); /*  Active Window   */

    return( NULL );
}
///
/// RemFuncRexxed
__geta4 ULONG RemFuncRexxed( __A0 ULONG *ArgArray, __A1 struct RexxMsg *Msg, __A2 struct IE_Data *IE, __D0 ULONG ID )
{
    struct GadgetInfo  *gad;
    struct WindowInfo  *wnd;
    ULONG               cnt, i;

    /*  Get the window pointer   */

    if(!( wnd = GimmeWnd(( ULONG * )ArgArray[0], IE )))
	return( RC_ERROR );

    if( ArgArray[1] ) {     /*  gadget specified ?  */

	cnt = *((ULONG *)ArgArray[1]);

	/*  Gadget out of range?    */

	if((!( wnd->wi_NumGads + wnd->wi_NumObjects )) || ( cnt > wnd->wi_NumGads + wnd->wi_NumObjects ))
	    return( RC_WARN );

	/*  Get gadget ptr          */

	for( gad = wnd->wi_Gadgets.mlh_Head, i = 1; i < cnt; i++ )
	    gad = gad->g_Node.ln_Succ;

	struct MyInfo  *Info;

	/*  Is there a function attached to it? */

	for( Info = wnd->wi_Gadgets.mlh_Head; Info->Node.ln_Succ; Info = Info->Node.ln_Succ )
	    if(( Info->Kind == ID ) && ( Info->Gadget == gad )) {
		Remove(( struct Node * )Info );
		IE->win_info->wi_NumObjects -= 1;
		FreeVec( Info->Function );
		FreeMem( Info, sizeof( struct MyInfo ));
		break;
	    }

    } else {    /*  let's remove every function... ;-)  */

	struct MyInfo  *Info;

	for( Info = wnd->wi_Gadgets.mlh_Head; Info->Node.ln_Succ; Info = Info->Node.ln_Succ )
	    if( Info->Kind == ID ) {
		struct MyInfo  *next;

		next = Info->Node.ln_Pred;

		Remove(( struct Node * )Info );

		IE->win_info->wi_NumObjects -= 1;

		FreeVec( Info->Function );

		FreeMem( Info, sizeof( struct MyInfo ));
		Info = next;
	    }
    }

    return( RC_OK );
}
///
/// AddFuncRexxed
__geta4 ULONG AddFuncRexxed( __A0 ULONG *ArgArray, __A1 struct RexxMsg *Msg, __A2 struct IE_Data *IE, __D0 ULONG ID )
{
    struct GadgetInfo  *gad;
    struct WindowInfo  *wnd;
    ULONG               cnt, i, ret;

    /*  Get the window pointer   */

    if(!( wnd = GimmeWnd(( ULONG * )ArgArray[0], IE )))
	return( RC_ERROR );

    if( ArgArray[1] ) {     /*  gadget specified ?  */

	cnt = *((ULONG *)ArgArray[1]);

	/*  Gadget out of range?    */

	if((!( wnd->wi_NumGads + wnd->wi_NumObjects )) || ( cnt > wnd->wi_NumGads + wnd->wi_NumObjects ))
	    return( RC_WARN );

	/*  Get gadget ptr          */

	for( gad = wnd->wi_Gadgets.mlh_Head, i = 1; i < cnt; i++ )
	    gad = gad->g_Node.ln_Succ;

	ret = AddFunction( IE, gad, ID ) ? RC_OK : RC_FATAL;

    } else {    /*  let's take every active gadget... ;-)   */

	ret = RC_OK;

	for( gad = wnd->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ )
	    if(( gad->g_flags2 & G_ATTIVO ) && ( gad->g_Kind != ID ))
		if(!( AddFunction( IE, gad, ID ))) {
		    ret = RC_FATAL;
		    break;
		}
    }

    return( ret );
}
///
/// AddFunction
BOOL AddFunction( struct IE_Data *IE, struct GadgetInfo *gad, UWORD ID )
{
    BOOL                ret = FALSE, old = FALSE;
    struct MyInfo      *Info;
    TEXT                Header[ 256 ];


    for( Info = IE->win_info->wi_Gadgets.mlh_Head; Info->Node.ln_Succ; Info = Info->Node.ln_Succ )
	if(( Info->Kind == ID ) && ( gad == Info->Gadget )) {
	    old = TRUE;
	    break;
	}


    if( old ) {
	STRPTR  src, dest;

	src  = Info->Function;
	dest = Header;

	while( *src == '\n' ) /* skip initial newlines */
	    src++;

	while(( *src != '\0' ) && ( *src != '\n' ))
	    *dest++ = *src++;

	*dest = '\0';

    } else {
	STRPTR  h;

	if( h = ( *IE->IEXFun->GetFirstLine )( Desc, "HEADER" ))
	    strcpy( Header, h );
	else
	    Header[0] = '\0';
    }

    if(( gad->g_Kind >= MIN_IEX_ID ) && (!( old ))) {
	ULONG   tags[] = { RT_ReqPos, REQPOS_CENTERSCR, RT_Underscore, '_',
			   RT_Screen, IE->ScreenData->Screen, TAG_DONE };

	if( rtEZRequestA( "Gadget kind unknown.\n"
			   "Do you want to add a function to it?",
			   "_Yes|_No", NULL,
			   NULL, (struct TagItem *)tags )) {

	    if(!( rtGetStringA( Header, 255, "Function.iex", NULL, (struct TagItem *)tags )))
		return( FALSE );

	} else
	    return( FALSE );
    }

    if(!( old ))
	Info = AllocMem( sizeof( struct MyInfo ), MEMF_CLEAR );

    if( Info ) {

	Info->Kind = ID;       /* DON'T FORGET!!! */

	ret = TRUE;

	TEXT    file[16];

	sprintf( file, "T:%08lx.txt", gad );

	DeleteFile( file ); /* Make sure there's no file with this name */

	BPTR    fh;

	if( fh = Open( file, MODE_NEWFILE )) {

	    if( old ) {

		FPuts( fh, Info->Function );

	    } else {
		struct Descriptor   Dsc[] = {
		    { 'g', gad->g_Label }
		};
		STRPTR  body;

		/*  Write an empty template for the function    */
		( *IE->IEXFun->WriteFormatted )( fh, Header, &Dsc[0] );

		if( body = ( *IE->IEXFun->GetFirstLine )( Desc, "BODY" ))
		    ( *IE->IEXFun->WriteFormatted )( fh, body, &Dsc[0] );
	    }

	    Close( fh );

	    APTR    fun;

	    if( fun = EditFunction( file )) {

		if( old )
		    FreeVec( Info->Function );

		Info->Function = fun;

		if(!( old )) {

		    Info->Gadget = gad;

		    /* add our object to the list */
		    AddTail((struct List *)&IE->win_info->wi_Gadgets, (struct Node *)Info );

		    IE->win_info->wi_NumObjects += 1;
		}

	    } else if(!( old ))
		FreeMem( Info, sizeof( struct MyInfo ));

	    DeleteFile( file );
	}
    }

    return( ret );
}
///
/// EditFunction
APTR EditFunction( STRPTR File )
{
    TEXT    command[ 512 ];
    APTR    Function = NULL;

    sprintf( command, Editor, File );

    if( SystemTagList( command, NULL ) == 0 ) {

	BPTR    lock;

	if( lock = Lock( File, ACCESS_READ )) {

	    struct FileInfoBlock   *fib;

	    if( fib = AllocDosObject( DOS_FIB, NULL )) {

		Examine( lock, fib );

		if( fib->fib_Size ) {
		    if( Function = AllocVec( fib->fib_Size + 1, MEMF_CLEAR )) {
		    /*                                     ^^^
			So we can be sure to have a NULL end
		    */

			BPTR    fh;

			if( fh = Open( File, MODE_OLDFILE )) {

			    Read( fh, Function, fib->fib_Size );
			    Close( fh );
			}
		    }
		}

		FreeDosObject( DOS_FIB, fib );
	    }

	    UnLock( lock );
	}

    }

    return( Function );
}
///
/// I/O support functions
APTR FGetString( BPTR File )
{
    ULONG   len;
    UBYTE  *buf = NULL;

    FRead( File, &len, 4, 1 );

    if( buf = AllocVec( len, 0L )) {

	FRead( File, buf, len, 1 );

	buf[ len ] = '\0';

	if( len & 1 )
	    FGetC( File );
    }

    return( buf );
}

void FPutString( BPTR File, STRPTR str )
{
    ULONG   len;

    len = strlen( str );

    FWrite( File, &len, 4, 1 );
    FWrite( File, str, len, 1 );

    if( len & 1 )
	FPutC( File, 0 );
}
///


/*  Starting function           */
/// IEX_Mount
__geta4 ULONG IEX_Mount( __A0 struct IE_Data *IE )
{
    BPTR                    DescFile;
    struct FileInfoBlock   *fib;
    ULONG                   ret = IEX_ERROR_NO_DESC_FILE;
    static UBYTE            FileName[] = "PROGDIR:Expanders/Function.desc";
    struct ExCmdNode        RexxCmd = { 0 };

    RexxCmd.Node.ln_Name = "ADDFUNCTION";
    RexxCmd.Template     = "WINDOW/N/K,GADGET/N";
    RexxCmd.Routine      = AddFuncRexxed;

    ( *IE->IEXFun->AddARexxCmd )( &RexxCmd );

    RexxCmd.Node.ln_Name = "REMOVEFUNCTION";
    RexxCmd.Routine      = RemFuncRexxed;

    ( *IE->IEXFun->AddARexxCmd )( &RexxCmd );


    /*  This part needs to be done just 1 time  */

    Forbid();   /* we're going to write to a GLOBAL variable */

    if( Desc ) {            /* already done this part? */
	Permit();
	return( IEX_OK );
    }

    LibBase->Kind      = IEX_ATTRIBUTE_KIND;

    LibBase->Resizable = FALSE;
    LibBase->Movable   = FALSE;
    LibBase->HasItems  = FALSE;
    LibBase->UseFonts  = FALSE;

    LibBase->Node.ln_Name = "FUNCTION";

    GetVar( "IEditor/FunctionEd", Editor, 256, 0 );

    if( fib = AllocDosObject( DOS_FIB, NULL )) {
	if( DescFile = Lock( FileName, ACCESS_READ )) {

	    Examine( DescFile, fib );
	    UnLock( DescFile );

	    if( Desc = AllocVec( fib->fib_Size, 0L )) {
		if( DescFile = Open( FileName, MODE_OLDFILE )) {

		    Read( DescFile, Desc, fib->fib_Size );
		    Close( DescFile );

		    ( *IE->IEXFun->SplitLines )( Desc ); // VERY important!

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
    struct GadgetInfo  *gad;
    BOOL                ret = TRUE;

    if( gad = ( *IE->Functions->GetGadget )())
	ret = AddFunction( IE, gad, ID );

    return( ret );
}
///
/// IEX_Remove
__geta4 void IEX_Remove( __D0 UWORD ID, __A0 struct IE_Data *IE )
{
    struct MyInfo  *Info;

    for( Info = IE->win_info->wi_Gadgets.mlh_Head; Info->Node.ln_Succ; Info = Info->Node.ln_Succ ) {
	if( Info->Kind == ID ) {
	    BOOL                rem = TRUE;
	    struct GadgetInfo  *gad;

	    /* Has the gadget this function is linked to been removed? */
	    for( gad = IE->win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ )
		if( gad == Info->Gadget ) {
		    rem = FALSE;
		    break;
		}

	    /* If so, remove also the function... */
	    if( rem ) {
		struct MyInfo  *next;

		next = Info->Node.ln_Pred;

		Remove(( struct Node * )Info );

		IE->win_info->wi_NumObjects -= 1;

		FreeVec( Info->Function );

		FreeMem( Info, sizeof( struct MyInfo ));
		Info = next;
	    }
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
    /* Nothing to refresh */
}
///


/*  I/O Functions               */
/// IEX_Save
__geta4 void IEX_Save( __D0 UWORD ID, __A0 struct IE_Data *IE, __D1 BPTR File )
{
    struct MyInfo  *Info;

    for( Info = IE->win_info->wi_Gadgets.mlh_Head; Info->Node.ln_Succ; Info = Info->Node.ln_Succ )
	if(( Info->Kind == ID ) && (( Info->Gadget->g_flags2 & G_ATTIVO ) || ( Info->Flags & G_ATTIVO ))) {
				   /*  ^^ if the gadget this func is linked to is active
					  if this is active (= when saving all the GUI)   ^^  */

	    UWORD               num;
	    struct GadgetInfo  *gad;

	    num = 0;
	    gad = IE->win_info->wi_Gadgets.mlh_Head;

	    while( gad != Info->Gadget ) {
		gad = gad->g_Node.ln_Succ;
		num++;
	    }

	    FWrite( File, &num, 2, 1 );
	    FPutString( File, Info->Function );
	}
}
///
/// IEX_Load
__geta4 BOOL IEX_Load( __D0 UWORD ID, __A0 struct IE_Data *IE, __D1 BPTR File, __D2 UWORD Num )
{
    struct MyInfo      *Info;
    struct GadgetInfo  *gad;
    UWORD               cnt, num, i;

    for( cnt = 0; cnt < Num; cnt++ ) {
	if( Info = AllocMem( sizeof( struct MyInfo ), MEMF_CLEAR )) {

	    Info->Kind = ID;  /* VERY important!!! */

	    FRead( File, &num, 2, 1 );

	    gad = (struct GadgetInfo *)&IE->win_info->wi_Gadgets.mlh_Head;
	    for( i = 0; i <= num; i++ )
		gad = gad->g_Node.ln_Succ;

	    Info->Gadget = gad;

	    if( Info->Function = FGetString( File ))
		AddTail(( struct List * )&IE->win_info->wi_Gadgets, ( struct Node * )Info );
	    else {
		FreeMem( Info, sizeof( struct MyInfo ));
		return( FALSE );
	    }

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
    return( NULL );
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
    struct MyInfo      *Info;
    struct WindowInfo  *wnd;

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ )
	if( wnd->wi_NumObjects )
	    for( Info = wnd->wi_Gadgets.mlh_Head; Info->Node.ln_Succ; Info = Info->Node.ln_Succ )
		if( Info->Kind == ID )
		    FPuts( Files->Std, Info->Function );
}
///
/// IEX_WriteRender
__geta4 void IEX_WriteRender( __D0 UWORD ID, __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{
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

