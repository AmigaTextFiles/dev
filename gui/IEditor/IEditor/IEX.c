/// Include
#include <stdarg.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>


#define INTUI_V36_NAMES_ONLY
#define ASL_V38_NAMES_ONLY
#define CATCOMP_NUMBERS

#include <exec/nodes.h>                 // exec
#include <exec/lists.h>
#include <exec/memory.h>
#include <exec/ports.h>
#include <exec/libraries.h>
#include <dos/dos.h>                    // dos
#include <libraries/reqtools.h>
#include <clib/exec_protos.h>           // protos
#include <clib/dos_protos.h>
#include <clib/reqtools_protos.h>
#include <clib/intuition_protos.h>
#include <clib/gadtools_protos.h>
#include <pragmas/exec_pragmas.h>       // pragmas
#include <pragmas/dos_pragmas.h>
#include <pragmas/reqtools_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <pragmas/gadtools_pragmas.h>


#include "DEV_IE:defs.h"
#include "DEV_IE:GUI.h"
#include "DEV_IE:GUI_locale.h"
#include "DEV_IE:Include/expanders-protos.h"
#include "DEV_IE:Include/expanders.h"
#include "DEV_IE:Include/expander_pragmas.h"
///
/// Prototypes
static void     IEXS_Globals( __A0 struct GenFiles * );
static void     IEXS_Setup( __A0 struct GenFiles * );
static void     IEXS_CloseDown( __A0 struct GenFiles * );
static void     IEXS_Headers( __A0 struct GenFiles * );
static void     IEXS_RenderPlusZero( __A0 struct GenFiles * );
static void     IEXS_RenderMinusZero( __A0 struct GenFiles * );
static ULONG    IEXS_IDCMP( __D0 ULONG );
static void     IEXS_Data( __A0 struct GenFiles * );
static void     IEXS_ChipData( __A0 struct GenFiles * );
static void     IEXS_Support( __A0 struct GenFiles * );
static void     IEXS_OpenWnd( __A0 struct GenFiles * );
static void     IEXS_CloseWnd( __A0 struct GenFiles * );
///
/// Data
struct IEXSrcFun IEXSrcFunctions = {
	IEXS_Globals,
	IEXS_Setup,
	IEXS_CloseDown,
	IEXS_Headers,
	IEXS_RenderMinusZero,
	IEXS_RenderPlusZero,
	IEXS_IDCMP,
	IEXS_Data,
	IEXS_ChipData,
	IEXS_Support,
	IEXS_OpenWnd,
	IEXS_CloseWnd
};

static ULONG    ExId = MIN_IEX_ID, FirstExId;
///

//      Expanders
/// GetExpanders
void GetExpanders( void )
{
    struct AnchorPath  *anchorpath;
    UBYTE               buffer[255];
    ULONG               error, ret; 

    if( anchorpath = (struct AnchorPath *)AllocMem( sizeof( struct AnchorPath ), MEMF_CLEAR )) {

	error = MatchFirst( "PROGDIR:Expanders/#?.iex", anchorpath );
	while( error == 0 ) {
	    struct Expander *IEXBase;

	    strcpy( buffer, "PROGDIR:Expanders/" );
	    strcat( buffer, anchorpath->ap_Info.fib_FileName );

	    if( IEXBase = OpenLibrary( buffer, 37 )) {

		FirstExId = ExId;

		if(!( ret = IEX_Mount( &IE ))) {

		    AddGadgetKind( IEXBase, &IEXBase->Node );

		} else {

		    ULONG tags[] = { RT_ReqPos, REQPOS_CENTERSCR,
				     RT_Underscore, '_',
				     RT_Screen, Scr, TAG_DONE };

		    rtEZRequest( "%s:\nMissing desc file!",
				 "_Ok", NULL, ( struct TagItem * )tags,
				 anchorpath->ap_Info.fib_FileName );

		    CloseLibrary(( struct Library * )IEXBase );
		}
	    }

	    if (!( error ))
		error = MatchNext( anchorpath );
	}

	MatchEnd( anchorpath );
	FreeMem( anchorpath, sizeof( struct AnchorPath ));
    }
}
///
/// FreeExpanders
void FreeExpanders( void )
{
    struct IEXNode *ex;

    while( ex = RemTail(( struct List * )&IE.Expanders )) {
	CloseLibrary(( struct Library * )ex->Base );
	FreeMem( ex, sizeof( struct IEXNode ));
    }
}
///
/// FreeARexxCmds
void FreeARexxCmds( void )
{
    struct CmdNode *Node;

    while( Node = RemTail(( struct List * )&RexxCommands ))
	if( Node->Node.ln_Type == 1 )
	    FreeMem( Node, sizeof( struct ExCmdNode ));
	else
	    break;
}
///

//      Expander support routines
/// SplitLines
void SplitLines( __A0 UBYTE *Buffer )
{
    UBYTE  *End, *Start;
    BOOL    ok = TRUE;

    Start = Buffer;

    do {
	while( *Buffer++ != '#' );
	if( *Buffer++ == '#' ) {
	    if(!( strncmp( "end", Buffer, 3 ))) {
		End = Buffer;
		ok = FALSE;
	    }
	}
    } while( ok );

    ok = FALSE;

    while( Start < End ) {

	if(( Start[0] == '#' ) && ( Start[1] == '#' ))
	    ok = TRUE;

	if( *Start == '\n' ) {
	    if( ok || (( Start[1] == '#' ) && ( Start[2] == '#' ))) {
		*Start = '\0';
		ok = FALSE;
	    }
	}

	Start++;
    }
}
///
/// GetFirstLine
UBYTE *GetFirstLine( __A0 UBYTE *Buffer, __A1 STRPTR ID )
{
    for(;;) {

	while( *Buffer++ != '#' );

	if( *Buffer++ == '#' ) {

	    if(!( strncmp( "end", Buffer, 3 )))
		return( NULL );

	    if(!( strcmp( ID, Buffer )))
		return( Buffer + strlen( ID ) + 1 );
	}
    }
}
///
/// WriteFormatted
void WriteFormatted( __D0 BPTR File, __A0 STRPTR String, __A1 struct Descriptor *Desc )
{
    UWORD       size = 0;
    UBYTE      *ptr, ch;

    ptr = String;

    while( *String ) {

	ch = *String++;

	if( ch == '%' ) {

	    FWrite( File, ptr, size, 1 );

	    ch = *String++;

	    if( ch == '%' )
		FPutC( File, '%' );
	    else {
		struct Descriptor *d = Desc;

		while( d->Key )
		    if( ch == d->Key ) {
			FPuts( File, d->Meaning );
			break;
		    } else
			d++;
	    }

	    ptr  = String;
	    size = 0;

	} else {
	    size += 1;
	}
    }

    FWrite( File, ptr, size, 1 );
}
///
/// AddGadgetKind
BOOL AddGadgetKind( __A0 struct Expander *Base, __A1 struct Node *Node )
{
    BOOL            ret = FALSE;
    struct IEXNode *ex;

    if( ex = AllocMem( sizeof( struct IEXNode ), MEMF_CLEAR )) {
	struct IEXNode *ex2, *ex3 = NULL;
	BYTE            pri = Node->ln_Pri;

	ex->Base        = Base;
	ex->Node.ln_Pri = pri;
	ex->ID          = ExId;

	for( ex2 = IE.Expanders.mlh_Head; ex2->Node.ln_Succ; ex2 = ex2->Node.ln_Succ )
	    if( ex2->Base == Base ) {
		ex->ID = ex2->ID;
		break;
	    }

	if( ex->ID == ExId )
	    ExId += 1;

	ex2 = IE.Expanders.mlh_Head;
	while(( ex2->Node.ln_Succ ) && ( ex2->Node.ln_Pri < pri )) {
	    ex3 = ex2;
	    ex2 = ex2->Node.ln_Succ;
	}

	Insert(( struct List * )&IE.Expanders, ( struct Node * )ex, ( struct Node * )ex3 );

	memcpy( &ex->Copy, Node, sizeof( struct Node ));

	AddTail(( struct List * )&listgadgets, &ex->Copy );

	ret = TRUE;
    }

    return( ret );
}
///
/// AddARexxCmd
BOOL AddARexxCmd( __A0 struct ExCmdNode *Cmd )
{
    BOOL                ret = FALSE;
    struct ExCmdNode   *Node;

    if( Node = AllocMem( sizeof( struct ExCmdNode ), 0L )) {

	CopyMem(( char * )Cmd, ( char * )Node, ( long )sizeof( struct ExCmdNode ));

	Node->Node.ln_Type = 1;
	Node->ID           = FirstExId;

	AddTail(( struct List * )&RexxCommands, ( struct Node * )Node );
    }

    return( ret );
}
///


//      Source related functions

/// IEXS_Globals
void IEXS_Globals( __A0 struct GenFiles *Files )
{
    struct IEXNode  *ex;
    struct Expander *IEXBase;

    for( ex = IE.Expanders.mlh_Head; ex->Node.ln_Succ; ex = ex->Node.ln_Succ ) {
	if( ex->UseCount ) {
	    IEXBase = ex->Base;
	    IEX_WriteGlobals( ex->ID, Files, &IE );
	}
    }
}
///
/// IEXS_Setup
void IEXS_Setup( __A0 struct GenFiles *Files )
{
    struct IEXNode  *ex;
    struct Expander *IEXBase;

    for( ex = IE.Expanders.mlh_Head; ex->Node.ln_Succ; ex = ex->Node.ln_Succ ) {
	if( ex->UseCount ) {
	    IEXBase = ex->Base;
	    IEX_WriteSetup( ex->ID, Files, &IE );
	}
    }
}
///
/// IEXS_CloseDown
void IEXS_CloseDown( __A0 struct GenFiles *Files )
{
    struct IEXNode  *ex;
    struct Expander *IEXBase;

    for( ex = IE.Expanders.mlh_Head; ex->Node.ln_Succ; ex = ex->Node.ln_Succ ) {
	if( ex->UseCount ) {
	    IEXBase = ex->Base;
	    IEX_WriteCloseDown( ex->ID, Files, &IE );
	}
    }
}
///
/// IEXS_Headers
void IEXS_Headers( __A0 struct GenFiles *Files )
{
    struct IEXNode  *ex;
    struct Expander *IEXBase;

    for( ex = IE.Expanders.mlh_Head; ex->Node.ln_Succ; ex = ex->Node.ln_Succ ) {
	if( ex->UseCount ) {
	    IEXBase = ex->Base;
	    IEX_WriteHeaders( ex->ID, Files, &IE );
	}
    }
}
///
/// IEXS_RenderMinusZero
void IEXS_RenderMinusZero( __A0 struct GenFiles *Files )
{
    struct IEXNode  *ex;
    struct Expander *IEXBase;

    for( ex = IE.Expanders.mlh_Head; ex->Node.ln_Succ && ex->Base->Node.ln_Pri < 0; ex = ex->Node.ln_Succ ) {
	if( ex->UseCount ) {
	    IEXBase = ex->Base;
	    IEX_WriteRender( ex->ID, Files, &IE );
	}
    }
}
///
/// IEXS_RenderPlusZero
void IEXS_RenderPlusZero( __A0 struct GenFiles *Files )
{
    struct IEXNode  *ex;
    struct Expander *IEXBase;

    ex = IE.Expanders.mlh_Head;
    while(( ex->Node.ln_Succ ) && ( ex->Base->Node.ln_Pri < 0 ))
	ex = ex->Node.ln_Succ;

    if( ex->Node.ln_Succ ) {
	for( ; ex->Node.ln_Succ; ex = ex->Node.ln_Succ ) {
	    if( ex->UseCount ) {
		IEXBase = ex->Base;
		IEX_WriteRender( ex->ID, Files, &IE );
	    }
	}
    }
}
///
/// IEXS_IDCMP
ULONG IEXS_IDCMP( __D0 ULONG idcmp )
{
    struct IEXNode  *ex;
    struct Expander *IEXBase;

    for( ex = IE.Expanders.mlh_Head; ex->Node.ln_Succ; ex = ex->Node.ln_Succ )
	if( ex->UseCount ) {
	    IEXBase = ex->Base;
	    idcmp = IEX_GetIDCMP( ex->ID, idcmp, &IE );
	}

    return( idcmp );
}
///
/// IEXS_Data
void IEXS_Data( __A0 struct GenFiles *Files )
{
    struct IEXNode  *ex;
    struct Expander *IEXBase;

    for( ex = IE.Expanders.mlh_Head; ex->Node.ln_Succ; ex = ex->Node.ln_Succ ) {
	if( ex->UseCount ) {
	    IEXBase = ex->Base;
	    IEX_WriteData( ex->ID, Files, &IE );
	}
    }
}
///
/// IEXS_ChipData
void IEXS_ChipData( __A0 struct GenFiles *Files )
{
    struct IEXNode  *ex;
    struct Expander *IEXBase;

    for( ex = IE.Expanders.mlh_Head; ex->Node.ln_Succ; ex = ex->Node.ln_Succ ) {
	if( ex->UseCount ) {
	    IEXBase = ex->Base;
	    IEX_WriteChipData( ex->ID, Files, &IE );
	}
    }
}
///
/// IEXS_Support
void IEXS_Support( __A0 struct GenFiles *Files )
{
    struct IEXNode *ex;

    for( ex = IE.Expanders.mlh_Head; ex->Node.ln_Succ; ex = ex->Node.ln_Succ ) {
	if( ex->UseCount ) {

	    struct IEXNode *ex2;
	    BOOL            ok = TRUE;

	    for( ex2 = IE.Expanders.mlh_Head; ex2 != ex; ex2 = ex2->Node.ln_Succ ) {
		if(!( strcmp( ex->Support, ex2->Support )) && ( ex2->UseCount ))
		    ok = FALSE;
	    }

	    if( ok )
		FPuts( Files->Std, ex->Support );
	}
    }
}
///
/// IEXS_OpenWnd
void IEXS_OpenWnd( __A0 struct GenFiles *Files )
{
    struct IEXNode  *ex;
    struct Expander *IEXBase;

    for( ex = IE.Expanders.mlh_Head; ex->Node.ln_Succ; ex = ex->Node.ln_Succ ) {
	if( ex->UseCount ) {
	    IEXBase = ex->Base;
	    IEX_WriteOpenWnd( ex->ID, Files, &IE );
	}
    }
}
///
/// IEXS_CloseWnd
void IEXS_CloseWnd( __A0 struct GenFiles *Files )
{
    struct IEXNode  *ex;
    struct Expander *IEXBase;

    for( ex = IE.Expanders.mlh_Head; ex->Node.ln_Succ; ex = ex->Node.ln_Succ ) {
	if( ex->UseCount ) {
	    IEXBase = ex->Base;
	    IEX_WriteCloseWnd( ex->ID, Files, &IE );
	}
    }
}
///

//      Objects management
/// AddObject
void AddObject( UWORD node )
{
    struct IEXNode     *ex;
    UWORD               cnt, ID;
    struct Node        *Node;

    Node = ( struct Node * )&listgadgets;

    for( cnt = 0; cnt <= node; cnt++ )
	Node = Node->ln_Succ;

    ex = IE.Expanders.mlh_Head;
    while( &ex->Copy != Node )
	ex = ex->Node.ln_Succ;

    IEXBase = ex->Base;
    ID      = ex->ID;

    if( IEXBase->Resizable || IEXBase->Movable ) {
	WORD    x1, x2, y1, y2, swap;
	UWORD   w, h;

	Stat( CatCompArray[ MSG_DRAW_GAD ].cca_Str, FALSE, 0 );

	ActivateWindow( IE.win_active );

	IE.flags &= ~RECTFIXED;

	if(!( IEXBase->Resizable ))
	    IE.flags |= RECTFIXED;

	DrawRect( IEXBase->Width, IEXBase->Height );

	offx = offy = 0;
	Coord();


	x1 = clickx;
	x2 = lastx;
	y1 = clicky;
	y2 = lasty;

	if( x2 < x1 ) {
	    swap = x1;
	    x1 = x2;
	    x2 = swap;
	}

	if( y2 < y1 ) {
	    swap = y1;
	    y1 = y2;
	    y2 = swap;
	}

	if(!( IEXBase->Resizable )) {
	    w = IEXBase->Width;
	    h = IEXBase->Height;
	} else {
	    w = x2 - x1 + 1;
	    h = y2 - y1 + 1;
	}

	DisattivaTuttiGad();

	if( IEX_Add( ex->ID, &IE, x1, y1, w, h )) {

	    ((struct BOOPSIInfo *)IE.win_info->wi_Gadgets.mlh_TailPred )->Node.ln_Type = IEXBase->Kind;

	    switch( IEXBase->Kind ) {
		case IEX_BOOPSI_KIND:
		    BoopsiEditor(( struct BOOPSIInfo *)IE.win_info->wi_Gadgets.mlh_TailPred );
		    break;

		default:
		    IEX_Edit( ex->ID, &IE );
	    }

	    if(!( IE.win_info->wi_NumGads ))
		MenuGadgetAttiva();

	    RifaiGadgets();
	    RinfrescaFinestra();
	    IE.flags &= ~SALVATO;

	    Stat( CatCompArray[ MSG_GAD_ADDED ].cca_Str, FALSE, 0 );

	} else
	    Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, 0 );

    } else {
	if(!( IEX_Add( ex->ID, &IE, 0, 0, IEXBase->Width, IEXBase->Height )))
	    Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, 0 );
	else {
	    IEX_Edit( ex->ID, &IE );

	    if(!( IE.win_info->wi_NumGads ))
		MenuGadgetAttiva();

	    RifaiGadgets();
	    RinfrescaFinestra();
	    IE.flags &= ~SALVATO;

	    Stat( CatCompArray[ MSG_GAD_ADDED ].cca_Str, FALSE, 0 );
	}
    }
}
///

