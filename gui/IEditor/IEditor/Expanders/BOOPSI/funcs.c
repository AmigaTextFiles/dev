/// Includes
#define INTUI_V36_NAMES_ONLY

#include <string.h>                     // ANSI
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#include <exec/nodes.h>                 // exec
#include <exec/lists.h>
#include <exec/memory.h>
#include <exec/types.h>
#include <dos/dos.h>                    // dos
#include <dos/dostags.h>
#include <intuition/intuition.h>        // intuition
#include <intuition/gadgetclass.h>
#include <graphics/text.h>              // graphics
#include <gadgets/colorwheel.h>         // gadgets
#include <libraries/gadtools.h>         // libraries
#include <libraries/reqtools.h>
#include <clib/exec_protos.h>           // protos
#include <clib/dos_protos.h>
#include <clib/intuition_protos.h>
#include <clib/reqtools_protos.h>
#include <pragmas/exec_pragmas.h>       // pragmas
#include <pragmas/dos_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <pragmas/graphics_pragmas.h>
#include <pragmas/gadtools_pragmas.h>
#include <pragmas/reqtools_pragmas.h>

#define BOOPSI_IEX

#include "DEV_IE:Expanders/defs.h"
///
/// Prototypes
static void     FGetString( BPTR, STRPTR );
static void     PutString( BPTR, STRPTR );
///
/// Data
struct BOOPSITag Tags[]= {
    NULL, NULL, TT_LONG, 0, "WHEEL_Hue", WHEEL_Hue, { NULL, NULL, NULL },
    NULL, NULL, TT_LONG, 0, "WHEEL_Saturation", WHEEL_Saturation, { NULL, NULL, NULL },
    NULL, NULL, TT_LONG, 0, "WHEEL_Brightness", WHEEL_Brightness, { NULL, NULL, NULL },
    NULL, NULL, TT_USER_STRUCT, 0, "WHEEL_HSB", WHEEL_HSB, { NULL, NULL, NULL },
    NULL, NULL, TT_LONG, 0, "WHEEL_Red", WHEEL_Red, { NULL, NULL, NULL },
    NULL, NULL, TT_LONG, 0, "WHEEL_Green", WHEEL_Green, { NULL, NULL, NULL },
    NULL, NULL, TT_LONG, 0, "WHEEL_Blue", WHEEL_Blue, { NULL, NULL, NULL },
    NULL, NULL, TT_USER_STRUCT, 0, "WHEEL_RGB", WHEEL_RGB, { NULL, NULL, NULL },
    NULL, NULL, TT_SCREEN, 0, "WHEEL_Screen", WHEEL_Screen, { NULL, NULL, NULL },
    NULL, NULL, TT_STRING, 0, "WHEEL_Abbrv", WHEEL_Abbrv, { NULL, NULL, NULL },
    NULL, NULL, TT_WORD_PTR, 0, "WHEEL_Donation", WHEEL_Donation, { NULL, NULL, NULL },
    NULL, NULL, TT_BOOL, 0, "WHEEL_BevelBox", WHEEL_BevelBox, { NULL, NULL, NULL },
    NULL, NULL, TT_LONG, 0, "WHEEL_MaxPens", WHEEL_MaxPens, { NULL, NULL, NULL },
    NULL, NULL, TT_OBJECT, 0, "WHEEL_GradientSlider", WHEEL_GradientSlider, { NULL, NULL, NULL },
    NULL, NULL, TT_WORD, 0, "GA_ID", GA_ID, { NULL, NULL, NULL },
};

#define NUM_TAGS    ( sizeof( Tags ) / sizeof( struct BOOPSITag ))
///



/// I/O support functions
void FGetString( BPTR File, STRPTR str )
{
    UBYTE   len;

    len = FGetC( File );

    FRead( File, str, len, 1 );

    str[ len ] = '\0';

    if(!( len & 1 ))
	FGetC( File );
}

void PutString( BPTR File, STRPTR str )
{
    UBYTE   len;

    len = strlen( str );

    FPutC( File, len );
    FWrite( File, str, len, 1 );

    if(!( len & 1 ))
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
    static UBYTE            FileName[] = "PROGDIR:Expanders/BOOPSI.desc";
    ULONG                   c;

    Forbid();   /* we're going to write to a GLOBAL variable */

    if( Desc ) {            /* already mounted? */
	Permit();
	return( IEX_OK );
    }

    LibBase->IEX.Kind       = IEX_BOOPSI_KIND;

    LibBase->IEX.Resizable  = TRUE;
    LibBase->IEX.Movable    = TRUE;
    LibBase->IEX.HasItems   = FALSE;
    LibBase->IEX.UseFonts   = FALSE;

    LibBase->IEX.Node.ln_Name = "Color Wheel";

    LibBase->BOOPSIType     = BT_GADGET;

    NewList(( struct List * )&LibBase->Tags );

    for( c = 0; c < NUM_TAGS; c++ )
	AddTail(( struct List * )&LibBase->Tags, ( struct Node * )&Tags[ c ]);

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
			LibBase->IEX.Node.ln_Pri = atoi( pri );
		    else
			LibBase->IEX.Node.ln_Pri = 0;

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
    struct BOOPSIInfo   *Obj;
    BOOL                ret = FALSE;

    if( Obj = (*IE->Functions->AllocObject)( IE_BOOPSI )) {

	Obj->Kind   = ID;       /* DON'T FORGET!!! */
	Obj->Left   = x;
	Obj->Top    = y;
	Obj->Width  = width;
	Obj->Height = height;
	Obj->Flags  = G_ATTIVO; /* make it active  */

	sprintf( Obj->Label, "%sGad%03ld",
		 IE->win_info->wi_Label,
		 IE->win_info->wi_NewGadID );
	IE->win_info->wi_NewGadID += 1;

	/* add our object to the list */
	AddTail((struct List *)&IE->win_info->wi_Gadgets, (struct Node *)Obj );

	IE->win_info->wi_NumObjects += 1;

	ret = TRUE;
    }

    return( ret );
}
///
/// IEX_Remove
__geta4 void IEX_Remove( __D0 UWORD ID, __A0 struct IE_Data *IE )
{
    struct BOOPSIInfo   *Obj, *next;

    for( Obj = IE->win_info->wi_Gadgets.mlh_Head; Obj->Node.ln_Succ; Obj = Obj->Node.ln_Succ ) {
	/* remove only the objects of our kind and that are selected  */
	if(( Obj->Kind == ID ) && ( Obj->Flags & G_ATTIVO )) {
	    next = Obj->Node.ln_Pred;

	    Remove(( struct Node * )Obj );

	    IE->win_info->wi_NumObjects -= 1;

	    (*IE->Functions->FreeObject)( Obj, IE_BOOPSI );
	    Obj = next;
	}
    }
}
///
/// IEX_Edit
__geta4 BOOL IEX_Edit( __D0 UWORD ID, __A0 struct IE_Data *IE )
{
    /*      This function is not used by BOOPSI expanders       */
    return( TRUE );
}
///
/// IEX_Copy
__geta4 BOOL IEX_Copy( __D0 UWORD ID, __A0 struct IE_Data *IE, __D1 WORD offx, __D2 WORD offy )
{
    struct BOOPSIInfo   *Obj, *copy;

    for( Obj = IE->win_info->wi_Gadgets.mlh_Head; Obj->Node.ln_Succ; Obj = Obj->Node.ln_Succ ) {
	if(( Obj->Kind == ID ) && ( Obj->Flags & G_ATTIVO )) {

	    if( copy = (*IE->Functions->AllocObject)( IE_BOOPSI )) {

		CopyMem((char *)Obj, (char *)copy, (long)sizeof( struct BOOPSIInfo ));

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
}
///


/*  Source related functions    */
/// IEX_StartSrcGen
__geta4 STRPTR IEX_StartSrcGen( __D0 UWORD ID, __A0 struct IE_Data *IE )
{
    struct WindowInfo  *wnd;
    struct BOOPSIInfo   *Obj;
    STRPTR              func;

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	if( wnd->wi_NumObjects ) {
	    for( Obj = wnd->wi_Gadgets.mlh_Head; Obj->Node.ln_Succ; Obj = Obj->Node.ln_Succ ) {
		if( Obj->Kind == ID )
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
    struct Descriptor   Dsc[] = {
	{ 'w', IE->win_info->wi_Label },
	{ 'o', NULL },
	{ 0, NULL }
    };
    struct BOOPSIInfo   *Obj;
    STRPTR              String;

    if(( IE->win_info->wi_NumObjects ) && ( String = ( *IE->IEXFun->GetFirstLine )( Desc, "RENDER" ))) {
	for( Obj = IE->win_info->wi_Gadgets.mlh_Head; Obj->Node.ln_Succ; Obj = Obj->Node.ln_Succ ) {
	    if( Obj->Kind == ID ) {
		Dsc[1].Meaning = Obj->Label;
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
    UBYTE               X[6], Y[6], Width[6], Height[6];
    struct Descriptor   Dsc[] = {
	{ 'o', NULL },
	{ 'x', X },
	{ 'y', Y },
	{ 'W', Width },
	{ 'h', Height },
	{ 0, NULL }
    };
    struct BOOPSIInfo   *Obj;
    struct WindowInfo  *wnd;
    STRPTR              Xdef, Data;
    static UBYTE        ld[] = "%ld";

    Xdef = ( *IE->IEXFun->GetFirstLine )( Desc, "EXTERN" );
    Data = ( *IE->IEXFun->GetFirstLine )( Desc, "DATA" );

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	if( wnd->wi_NumObjects ) {
	    for( Obj = wnd->wi_Gadgets.mlh_Head; Obj->Node.ln_Succ; Obj = Obj->Node.ln_Succ ) {
		if( Obj->Kind == ID ) {

		    Dsc[0].Meaning = Obj->Label;

		    if( Xdef )
			( *IE->IEXFun->WriteFormatted )( Files->XDef, Xdef, &Dsc[0] );

		    sprintf( X, ld, Obj->Left - IE->ScreenData->XOffset );
		    sprintf( Y, ld, Obj->Top  - IE->ScreenData->YOffset );
		    sprintf( Width, ld, Obj->Width );
		    sprintf( Height, ld, Obj->Height );

		    if( Data )
			( *IE->IEXFun->WriteFormatted )( Files->Std, Data, &Dsc[0] );
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
}
///
/// IEX_WriteCloseWnd
__geta4 void IEX_WriteCloseWnd( __D0 UWORD ID, __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{
}
///
