/// Include
#include <stdarg.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>


#define INTUI_V36_NAMES_ONLY
#define ASL_V38_NAMES_ONLY
#define CATCOMP_NUMBERS

#include <exec/libraries.h>             // exec
#include <exec/execbase.h>
#include <intuition/intuition.h>        // intuition
#include <intuition/screens.h>
#include <dos/dos.h>                    // dos
#include <dos/dosextens.h>
#include <graphics/text.h>              // graphics
#include <graphics/view.h>
#include <libraries/gadtools.h>         // libraries
#include <libraries/asl.h>
#include <libraries/reqtools.h>
#include <clib/exec_protos.h>           // protos
#include <clib/intuition_protos.h>
#include <clib/graphics_protos.h>
#include <clib/dos_protos.h>
#include <clib/diskfont_protos.h>
#include <clib/locale_protos.h>
#include <clib/asl_protos.h>
#include <clib/reqtools_protos.h>
#include <pragmas/exec_pragmas.h>       // pragmas
#include <pragmas/intuition_pragmas.h>
#include <pragmas/graphics_pragmas.h>
#include <pragmas/dos_pragmas.h>
#include <pragmas/locale_pragmas.h>
#include <pragmas/asl_pragmas.h>
#include <pragmas/reqtools_pragmas.h>
#include <pragmas/gadtools_pragmas.h>
#include <pragmas/diskfont_pragmas.h>


#include "DEV_IE:defs.h"
#include "DEV_IE:GUI.h"
#include "DEV_IE:GUI_locale.h"
#include "DEV_IE:Include/expander_pragmas.h"
///
/// Prototipi
static BOOL    ScrError( void );
static void    LoadColors( UWORD );
static void    WriteColors( UWORD );
static void    GrabPalette( void );
static void    HandleDriPens( void );
static void    HandleScrTags( void );
///
/// Tags varie
static UWORD pens[] = { 0,1,1,2,1,3,1,0,2,1,2,1, ~0 };

static ULONG    ScreenTags2[] = {
    SA_Width,       640,
    SA_Height,      256,
    SA_Depth,         2,
    SA_DisplayID,   800,
    SA_Font,        &ScrData.NewFont,
    SA_Overscan,      0,
    SA_AutoScroll,    0,
    SA_Type,        CUSTOMSCREEN,
    SA_Pens,        pens,
    SA_Title,       0,
    SA_PubName,     MyPubName,
    TAG_END
};

static ULONG MenuTag[] = { GTMN_NewLookMenus, TRUE, TAG_END };

static ULONG palreq_tags[] = { RT_ReqPos, REQPOS_CENTERSCR, TAG_END };
///
/// Dati
static ULONG PaletteChunk[] = { 'FORM', 0, 'ILBM', 'CMAP', 0 };

static UBYTE Title[ 200 ], PubName[ 200 ];

static UWORD pens_backup[12];

UBYTE   PalettePattern[] = "(#?.ilbm|#?.iff|#?.col|#?.pal)";
UBYTE   ScrPattern[] = "#?.scr";

static UBYTE FontScr[ 256 ] = "topaz.font";

struct ScreenInfo ScrData = {
	NULL,                           // Visual Info
	0,                              // YOffset
	FontScr, 8, 0, 1,
	SC_SHOWTITLE | SC_DRAGGABLE,
	0, 0,                           // Left, Top
	0,                              // Type
	FontScr,
	Title,
	PubName,
	ScreenTags2,
	pens
};
///


/// LayoutWindow & PostOpenWindow
void LayoutWindow( struct TagItem *tags )
{
    tags[ WT_HEIGHT ].ti_Data += (YOffset - 10);

    tags[ WT_LEFT ].ti_Data = (Scr->Width  - tags[ WT_WIDTH  ].ti_Data) >> 1;
    tags[ WT_TOP  ].ti_Data = (Scr->Height - tags[ WT_HEIGHT ].ti_Data) >> 1;
}


void PostOpenWindow( struct TagItem *tags )
{
    tags[ WT_HEIGHT ].ti_Data -= (YOffset - 10);
}
///

/// Routines di I/O
BOOL SalvaScrMenued( void )
{
    LockAllWindows();

    if ( GetFile2( TRUE, CatCompArray[ ASL_SAVE_SCR ].cca_Str,
		  ScrPattern, ASL_SAVE_SCR, "scr" )) {

	if ( File = Open( allpath, MODE_NEWFILE )) {
	    FWrite( File, DataHeader, 8, 1 );
	    FWrite( File, &ScrHeader, 4, 1 );
	    WriteScr();
	    Close( File );
	} else
	    Stat( CatCompArray[ ERR_IOERR ].cca_Str, TRUE, ERR_IOERR );
    }

    UnlockAllWindows();

    return( TRUE );
}

void WriteScr( void )
{
    WORD    *data = ScreenTags2;

    FWrite( File, &data[( SCRWIDTH      * 2 ) + 1 ], 2, 1 );
    FWrite( File, &data[( SCRHEIGHT     * 2 ) + 1 ], 2, 1 );
    FWrite( File, &data[( SCRDEPTH      * 2 ) + 1 ], 2, 1 );
    FWrite( File, &data[  SCRID         * 2 ], 4, 1 );
    FWrite( File, &data[  SCROVERSCAN   * 2 ], 4, 1 );
    FWrite( File, &data[( SCRAUTOSCROLL * 2 ) + 1 ], 2, 1 );
    FWrite( File, &ScrData.NewFont.ta_YSize, 4, 1 );
    FWrite( File, &ScrData.ScrAttrs, 2, 1 );
    FWrite( File, &ScrData.St_Left, 2, 1 );
    FWrite( File, &ScrData.St_Top, 2, 1 );
    FWrite( File, &ScrData.Type, 2, 1 );
    FWrite( File, pens, 24, 1 );
    PutString( FontScr );
    PutString( Title );
    PutString( PubName );
    WriteColors( 1 << ScreenTags2[ SCRDEPTH ] );
}


BOOL CaricaColMenued( void )
{
    ULONG   b1, b2;

    LockAllWindows();

    if ( GetFile2( FALSE, CatCompArray[ ASL_LOAD_PALETTE ].cca_Str,
		  PalettePattern, ASL_LOAD_PALETTE, "ilbm" )) {

	if ( File = Open( allpath, MODE_OLDFILE )) {

	    Read( File, &b1, 4 );
	    Read( File, &b2, 4 );
	    Read( File, &b2, 4 );

	    if (( b1 == 'FORM' ) && ( b2 == 'ILBM' )) {

		Read( File, &b1, 4 );
		Read( File, &b2, 4 );

		while( b1 != 'CMAP' || b2 == 0 ) {
		    Seek( File, b2, OFFSET_CURRENT );
		    if ( b2 = Read( File, &b1, 4 ))
			Read( File, &b2, 4 );
		}

		if ( b2 != 0 )
		    LoadColors( b2 / 3 );
		else
		    Stat( CatCompArray[ ERR_NO_CMAP ].cca_Str, TRUE, ERR_NO_CMAP );

	    } else
		Stat( CatCompArray[ ERR_NOT_ILBM ].cca_Str, TRUE, ERR_NOT_ILBM );

	    Close( File );
	} else
	    Stat( CatCompArray[ ERR_IOERR ].cca_Str, TRUE, ERR_IOERR );
    }
    UnlockAllWindows();
    return( TRUE );
}



void LoadColors( UWORD num )
{
    UWORD   c, c2, c3;
    UBYTE   buf[3];

    if ( IE.colortable )  FreeVec( IE.colortable );

    c = 1 << ScreenTags2[ SCRDEPTH ];
    if ( num > c )  num = c;

    if ( SysBase->LibNode.lib_Version >= 39 ) {  // Kick 3.0

	ULONG  *ptr;
	if ( ptr = IE.colortable = AllocVec(( num * 12 ) + 8, 0L )) {

	    *((UWORD *)ptr)++ = num;
	    *((UWORD *)ptr)++ = 0;

	    for( c = 0; c < num; c++ ) {

		FRead( File, buf, 3, 1 );
		for( c2 = 0; c2 < 3 ; c2++ ) {
		    c3 = (buf[ c2 ] << 8) | buf[ c2 ];
		    *ptr++ = c3 | ( c3 << 16 );
		}
	    }
	    *ptr = NULL;

	    LoadRGB32( &Scr->ViewPort, IE.colortable );

	} else {
	    Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, 0 );
	    return;
	}
    } else {                             // Kick 2.0

	UWORD *ptr2;
	if( ptr2 = IE.colortable = AllocVec( num + num + 2, 0L )) {

	    *ptr2++ = num;

	    for( c2 = 0; c2 < num; c2 ++ ) {
		FRead( File, buf, 3, 1 );
		*ptr2++ = (buf[0] << 4) | buf[1] | (buf[2] >> 4);
	    }

	    LoadRGB4( &Scr->ViewPort, (APTR)((ULONG)IE.colortable+2), num );

	} else {
	    Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, 0 );
	}
    }
}


BOOL SalvaColMenued( void )
{
    UWORD   num, bytes;

    LockAllWindows();

    if( GetFile2( TRUE, CatCompArray[ ASL_SAVE_PALETTE ].cca_Str,
		 PalettePattern, ASL_SAVE_PALETTE, "ilbm" )) {

	if ( File = Open( allpath, MODE_NEWFILE )) {

	    num = 1 << ScreenTags2[ SCRDEPTH ];

	    PaletteChunk[4] = bytes = num * 3;
	    PaletteChunk[1] = bytes + 12;

	    FWrite( File, PaletteChunk, 20, 1 );

	    WriteColors( num );

	    Close( File );

	} else {
	    Stat( CatCompArray[ ERR_IOERR ].cca_Str, TRUE, ERR_IOERR );
	}
    }

    UnlockAllWindows();
    return( TRUE );
}


void WriteColors( UWORD num )
{
    UBYTE   *mem, *mem2;
    int     cnt, col;

    if( SysBase->LibNode.lib_Version >= 39 ) {      // Kick 3.0+

	if (mem = mem2 = AllocVec( num * 12, 0L )) {

	    GetRGB32( Scr->ViewPort.ColorMap, 0, num, (ULONG *)mem );

	    for( cnt = 0; cnt < num; cnt++ ) {
		mem += 3;
		FPutC( File, *mem++ );
		mem += 3;
		FPutC( File, *mem++ );
		mem += 3;
		FPutC( File, *mem++ );
	    }
	    FreeVec( mem2 );

	} else {
	    Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, 0 );
	}
    } else {                                // Kick 2.0

	for( cnt = 0; cnt < num; cnt++ ) {

	    col = GetRGB4( Scr->ViewPort.ColorMap, cnt );

	    FPutC( File, ( col >> 4 ) & 0xF0 );
	    FPutC( File,   col        & 0xF0 );
	    FPutC( File, ( col << 4 ) & 0xF0 );
	}

    }
}
///

/// Grab Palette
void GrabPalette( void )
{
    UWORD   num = 1 << ScreenTags2[ SCRDEPTH ];
    int     cnt;

    if( IE.colortable )
	FreeVec( IE.colortable );

    if ( SysBase->LibNode.lib_Version >= 39 ) {         // Kick 3.0+

	if ( IE.colortable = AllocVec(( num * 12 ) + 8, 0L )) {

	    ULONG *ptr = IE.colortable;

	    *ptr++ = num << 16;

	    GetRGB32( Scr->ViewPort.ColorMap, 0, num, ptr );

	    ptr[ num * 3 ] = NULL;
	}

    } else {                                    // Kick 2.0

	if ( IE.colortable = AllocVec( num + num + 2, 0L )) {

	    UWORD  *ptr2 = IE.colortable;

	    *ptr2++ = num;

	    for( cnt = 0; cnt < num; cnt++ )
		*ptr2++ = GetRGB4( Scr->ViewPort.ColorMap, cnt );

	}

    }
}
///

/// Palette
BOOL ChangeColMenued( void )
{
    LockAllWindows();

    rtPaletteRequestA( CatCompArray[ REQ_MODIFY_PALETTE ].cca_Str,
		       NULL, (struct TagItem *)palreq_tags );

    GrabPalette();

    if( IE.flags_2 & GENERASCR )
	IE.flags &= ~SALVATO;

    UnlockAllWindows();

    return( TRUE );
}
///

/// DriPens
static ULONG    DP_PaletteTag[] = { GTPA_Color, 0, TAG_END };
static ULONG    DP_CycleTag[]   = { GTCY_Active, 0, TAG_END };
static BOOL     DP_Ret;

BOOL DriPensMenued( void )
{
    ULONG   *ptr;
    BOOL    ret;
    int     cnt;

    if( DriPensWnd ) {
	ActivateWindow( DriPensWnd );
	WindowToFront( DriPensWnd );
	return( TRUE );
    }

    DP_Ret = FALSE;

    for( cnt = 0; cnt < 12; cnt++ )
	pens_backup[ cnt ] = pens[ cnt ];

    ptr = DriPensGTags;
    while( *ptr++ != GTPA_Depth );
    *ptr = ScreenTags2[ SCRDEPTH ];

    LayoutWindow( DriPensWTags );
    ret = OpenDriPensWindow();
    PostOpenWindow( DriPensWTags );

    if ( ret ) {
	CloseDriPensWindow();
	DisplayBeep( Scr );
    } else {

	DP_PaletteTag[1] = pens[0];

	GT_SetGadgetAttrsA( DriPensGadgets[ GD_DP_Pal ], DriPensWnd,
			   NULL, (struct TagItem *)DP_PaletteTag );

	DP_CycleTag[1]   = 0;

	DriPensWnd->ExtData = HandleDriPens;
    }

    return( TRUE );
}

void HandleDriPens( void )
{               
    if(!( HandleDriPensIDCMP() )) {
	CloseDriPensWindow();

	if( DP_Ret )
	    UpdateScr();
    }
}

BOOL DriPensVanillaKey( void )
{
    switch( IDCMPMsg.Code ) {
	case 13:
	    return( DP_OkClicked() );
	case 27:
	    return( DP_AnnClicked() );
    }
    return( TRUE );
}

BOOL DP_OkKeyPressed( void )
{
    return( DP_OkClicked() );
}

BOOL DP_OkClicked( void )
{
    DP_Ret = TRUE;
    return( FALSE );
}

BOOL DP_AnnKeyPressed( void )
{
    return( FALSE );
}

BOOL DP_AnnClicked( void )
{
    ULONG   cnt;

    for( cnt = 0; cnt < 12; cnt++ )
	pens[ cnt ] = pens_backup[ cnt ];

    return( FALSE );
}


BOOL DP_PensKeyPressed( void )
{
    if( IDCMPMsg.Code & 0x20 ) {
	if ( DP_CycleTag[1] < 12 )
	    DP_CycleTag[1] += 1;
	else
	    DP_CycleTag[1] = 0;
    } else {
	if( DP_CycleTag[1] )
	    DP_CycleTag[1] -= 1;
	else
	    DP_CycleTag[1] = 11;
    }

    IDCMPMsg.Code = DP_CycleTag[1];

    GT_SetGadgetAttrsA( DriPensGadgets[ GD_DP_Pens ], DriPensWnd,
			NULL, (struct TagItem *)DP_CycleTag );

    return( DP_PensClicked() );
}


BOOL DP_PensClicked( void )
{
    DP_PaletteTag[1] = pens[ IDCMPMsg.Code ];

    GT_SetGadgetAttrsA( DriPensGadgets[ GD_DP_Pal ], DriPensWnd,
			NULL, (struct TagItem *)DP_PaletteTag );

    return( TRUE );
}


BOOL DP_PalKeyPressed( void )
{
    ULONG   n = DP_CycleTag[1];
    ULONG   max = ( 1 << ScreenTags2[ SCRDEPTH ]) - 1;

    if( IDCMPMsg.Code & 0x20 ) {
	if ( pens[n] < max )
	    pens[n] += 1;
	else
	    pens[n] = 0;
    } else {
	if( pens[n] )
	    pens[n] -= 1;
	else
	    pens[n] = max;
    }

    DP_PaletteTag[1] = pens[ n ];

    GT_SetGadgetAttrsA( DriPensGadgets[ GD_DP_Pal ], DriPensWnd,
			NULL, (struct TagItem *)DP_PaletteTag );

    return( TRUE );
}


BOOL DP_PalClicked( void )
{
    pens[ DP_CycleTag[1] ] = IDCMPMsg.Code;

    return( TRUE );
}
///

/// Screen Tags
static  UWORD   ScrAttrsBack;
static  ULONG   ST_CycleTag[] = { GTCY_Active, 0, TAG_END };

BOOL ScrTagsMenued( void )
{
    int             ret, code;
    static UWORD    gads[] = {
			GD_ScrT_Left,
			GD_ScrT_Top,
			GD_ScrT_ShowTit,
			GD_ScrT_Behind,
			GD_ScrT_Quiet,
			GD_ScrT_Overscan,
			GD_ScrT_FullPal,
			GD_ScrT_Error,
			GD_ScrT_Drag,
			GD_ScrT_Exclusive,
			GD_ScrT_SharePens,
			GD_ScrT_Interleaved,
			GD_ScrT_LikeWB,
			GD_ScrT_MinISG
		    };

    if( ScrTagsWnd ) {
	ActivateWindow( ScrTagsWnd );
	WindowToFront( ScrTagsWnd );
	return( TRUE );
    }

    LayoutWindow( ScrTagsWTags );
    ret = OpenScrTagsWindow();
    PostOpenWindow( ScrTagsWTags );

    if( ret ) {
	DisplayBeep( Scr );
	CloseScrTagsWindow();
    } else {

	ScrAttrsBack = ScrData.ScrAttrs;

	code = 1;
	for( ret = 0; ret < 14; ret ++ ) {

	    CheckedTag[1] = ( ScrData.ScrAttrs & code) ? TRUE : FALSE;
	    GT_SetGadgetAttrsA( ScrTagsGadgets[ gads[ ret ]], ScrTagsWnd,
				NULL, (struct TagItem *)CheckedTag );

	    code <<= 1;
	}

	StringTag[1] = Title;
	GT_SetGadgetAttrsA( ScrTagsGadgets[ GD_ScrT_TitIn ], ScrTagsWnd,
			    NULL, (struct TagItem *)StringTag );

	StringTag[1] = PubName;
	GT_SetGadgetAttrsA( ScrTagsGadgets[ GD_ScrT_PubNameIn ], ScrTagsWnd,
			    NULL, (struct TagItem *)StringTag );

	DisableTag[1] = ( ScrData.ScrAttrs & 1 ) ? FALSE : TRUE;
	GT_SetGadgetAttrsA( ScrTagsGadgets[ GD_ScrT_LeftIn ], ScrTagsWnd,
			    NULL, (struct TagItem *)DisableTag );

	DisableTag[1] = ( ScrData.ScrAttrs & 2 ) ? FALSE : TRUE;
	GT_SetGadgetAttrsA( ScrTagsGadgets[ GD_ScrT_TopIn ], ScrTagsWnd,
			    NULL, (struct TagItem *)DisableTag );

	IntegerTag[1] = ScrData.St_Left;
	GT_SetGadgetAttrsA( ScrTagsGadgets[ GD_ScrT_LeftIn ], ScrTagsWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = ScrData.St_Top;
	GT_SetGadgetAttrsA( ScrTagsGadgets[ GD_ScrT_TopIn ], ScrTagsWnd,
			    NULL, (struct TagItem *)IntegerTag );

	ST_CycleTag[1] = ScrData.Type;
	GT_SetGadgetAttrsA( ScrTagsGadgets[ GD_ScrT_Type ], ScrTagsWnd,
			    NULL, (struct TagItem *)ST_CycleTag );

	ScrTagsWnd->ExtData = HandleScrTags;
    }

    return( TRUE );
}

void HandleScrTags( void )
{
    if(!( HandleScrTagsIDCMP() ))
	CloseScrTagsWindow();
}

BOOL ScrTagsVanillaKey( void )
{
    switch( IDCMPMsg.Code ) {
	case 13:
	    return( ScrT_OkClicked() );
	case 27:
	    return( ScrT_AnnullaClicked() );
    }

    return( TRUE );
}

BOOL ScrT_AnnullaKeyPressed( void )
{
    return( ScrT_AnnullaClicked() );
}

BOOL ScrT_AnnullaClicked( void )
{
    ScrData.ScrAttrs = ScrAttrsBack;
    return( FALSE );
}

BOOL ScrT_OkKeyPressed( void )
{
    return( ScrT_OkClicked() );
}

BOOL ScrT_OkClicked( void )
{

    strcpy( Title,   GetString( ScrTagsGadgets[ GD_ScrT_TitIn     ]) );
    strcpy( PubName, GetString( ScrTagsGadgets[ GD_ScrT_PubNameIn ]) );

    ScrData.St_Left = GetNumber( ScrTagsGadgets[ GD_ScrT_LeftIn ]);
    ScrData.St_Top  = GetNumber( ScrTagsGadgets[ GD_ScrT_TopIn  ]);

    IE.flags &= ~SALVATO;

    return( FALSE );
}

BOOL ScrT_LeftInClicked( void )
{
    return( TRUE );
}

BOOL ScrT_TopInClicked( void )
{
    return( TRUE );
}

BOOL ScrT_TitInClicked( void )
{
    return( TRUE );
}

BOOL ScrT_PubNameInClicked( void )
{
    return( TRUE );
}

BOOL ScrT_LeftKeyPressed( void )
{
    IDCMPMsg.Code = CheckedTag[1] = ( ScrData.ScrAttrs & SC_LEFT ) ? TRUE : FALSE;
    GT_SetGadgetAttrsA( ScrTagsGadgets[ GD_ScrT_Left ], ScrTagsWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( ScrT_LeftClicked() );
}

BOOL ScrT_LeftClicked( void )
{
    DisableTag[1] = !IDCMPMsg.Code;
    GT_SetGadgetAttrsA( ScrTagsGadgets[ GD_ScrT_LeftIn ], ScrTagsWnd,
			NULL, (struct TagItem *)DisableTag );

    if(!( DisableTag[1] ))
	ActivateGadget( ScrTagsGadgets[ GD_ScrT_LeftIn ], ScrTagsWnd, NULL );

    ScrData.ScrAttrs ^= SC_LEFT;

    return( TRUE );
}

BOOL ScrT_TopKeyPressed( void )
{
    IDCMPMsg.Code = CheckedTag[1] = ( ScrData.ScrAttrs & SC_TOP ) ? TRUE : FALSE;
    GT_SetGadgetAttrsA( ScrTagsGadgets[ GD_ScrT_Top ], ScrTagsWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( ScrT_TopClicked() );
}

BOOL ScrT_TopClicked( void )
{
    DisableTag[1] = !IDCMPMsg.Code;
    GT_SetGadgetAttrsA( ScrTagsGadgets[ GD_ScrT_TopIn ], ScrTagsWnd,
			NULL, (struct TagItem *)DisableTag );

    if(!( DisableTag[1] ))
	ActivateGadget( ScrTagsGadgets[ GD_ScrT_TopIn ], ScrTagsWnd, NULL );

    ScrData.ScrAttrs ^= SC_TOP;

    return( TRUE );
}

BOOL ScrT_ShowTitKeyPressed( void )
{
    CheckedTag[1] = ( ScrData.ScrAttrs & SC_SHOWTITLE ) ? TRUE : FALSE;
    GT_SetGadgetAttrsA( ScrTagsGadgets[ GD_ScrT_ShowTit ], ScrTagsWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( ScrT_ShowTitClicked() );
}

BOOL ScrT_ShowTitClicked( void )
{
    ScrData.ScrAttrs ^= SC_SHOWTITLE;
    return( TRUE );
}

BOOL ScrT_BehindKeyPressed( void )
{
    CheckedTag[1] = ( ScrData.ScrAttrs & SC_BEHIND ) ? TRUE : FALSE;
    GT_SetGadgetAttrsA( ScrTagsGadgets[ GD_ScrT_Behind ], ScrTagsWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( ScrT_BehindClicked() );
}

BOOL ScrT_BehindClicked( void )
{
    ScrData.ScrAttrs ^= SC_BEHIND;
    return( TRUE );
}

BOOL ScrT_QuietKeyPressed( void )
{
    CheckedTag[1] = ( ScrData.ScrAttrs & SC_QUIET ) ? TRUE : FALSE;
    GT_SetGadgetAttrsA( ScrTagsGadgets[ GD_ScrT_Quiet ], ScrTagsWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( ScrT_QuietClicked() );
}

BOOL ScrT_QuietClicked( void )
{
    ScrData.ScrAttrs ^= SC_QUIET;
    return( TRUE );
}

BOOL ScrT_OverscanKeyPressed( void )
{
    CheckedTag[1] = ( ScrData.ScrAttrs & SC_OVERSCAN ) ? TRUE : FALSE;
    GT_SetGadgetAttrsA( ScrTagsGadgets[ GD_ScrT_Overscan ], ScrTagsWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( ScrT_OverscanClicked() );
}

BOOL ScrT_OverscanClicked( void )
{
    ScrData.ScrAttrs ^= SC_OVERSCAN;
    return( TRUE );
}

BOOL ScrT_FullPalKeyPressed( void )
{
    CheckedTag[1] = ( ScrData.ScrAttrs & SC_FULLPALETTE ) ? TRUE : FALSE;
    GT_SetGadgetAttrsA( ScrTagsGadgets[ GD_ScrT_FullPal ], ScrTagsWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( ScrT_FullPalClicked() );
}

BOOL ScrT_FullPalClicked( void )
{
    ScrData.ScrAttrs ^= SC_FULLPALETTE;
    return( TRUE );
}

BOOL ScrT_ErrorKeyPressed( void )
{
    CheckedTag[1] = ( ScrData.ScrAttrs & SC_ERRORCODE ) ? TRUE : FALSE;
    GT_SetGadgetAttrsA( ScrTagsGadgets[ GD_ScrT_Error ], ScrTagsWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( ScrT_ErrorClicked() );
}

BOOL ScrT_ErrorClicked( void )
{
    ScrData.ScrAttrs ^= SC_ERRORCODE;
    return( TRUE );
}

BOOL ScrT_DragKeyPressed( void )
{
    CheckedTag[1] = ( ScrData.ScrAttrs & SC_DRAGGABLE ) ? TRUE : FALSE;
    GT_SetGadgetAttrsA( ScrTagsGadgets[ GD_ScrT_Drag ], ScrTagsWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( ScrT_DragClicked() );
}

BOOL ScrT_DragClicked( void )
{
    ScrData.ScrAttrs ^= SC_DRAGGABLE;
    return( TRUE );
}

BOOL ScrT_ExclusiveKeyPressed( void )
{
    CheckedTag[1] = ( ScrData.ScrAttrs & SC_EXCLUSIVE ) ? TRUE : FALSE;
    GT_SetGadgetAttrsA( ScrTagsGadgets[ GD_ScrT_Exclusive ], ScrTagsWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( ScrT_ExclusiveClicked() );
}

BOOL ScrT_ExclusiveClicked( void )
{
    ScrData.ScrAttrs ^= SC_EXCLUSIVE;
    return( TRUE );
}

BOOL ScrT_SharePensKeyPressed( void )
{
    CheckedTag[1] = ( ScrData.ScrAttrs & SC_SHAREPENS ) ? TRUE : FALSE;
    GT_SetGadgetAttrsA( ScrTagsGadgets[ GD_ScrT_SharePens ], ScrTagsWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( ScrT_SharePensClicked() );
}

BOOL ScrT_SharePensClicked( void )
{
    ScrData.ScrAttrs ^= SC_SHAREPENS;
    return( TRUE );
}

BOOL ScrT_InterleavedKeyPressed( void )
{
    CheckedTag[1] = ( ScrData.ScrAttrs & SC_INTERLEAVED ) ? TRUE : FALSE;
    GT_SetGadgetAttrsA( ScrTagsGadgets[ GD_ScrT_Interleaved ], ScrTagsWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( ScrT_InterleavedClicked() );
}

BOOL ScrT_InterleavedClicked( void )
{
    ScrData.ScrAttrs ^= SC_INTERLEAVED;
    return( TRUE );
}

BOOL ScrT_LikeWBKeyPressed( void )
{
    CheckedTag[1] = ( ScrData.ScrAttrs & SC_LIKEWORKBENCH ) ? TRUE : FALSE;
    GT_SetGadgetAttrsA( ScrTagsGadgets[ GD_ScrT_LikeWB ], ScrTagsWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( ScrT_LikeWBClicked() );
}

BOOL ScrT_LikeWBClicked( void )
{
    ScrData.ScrAttrs ^= SC_LIKEWORKBENCH;
    return( TRUE );
}

BOOL ScrT_MinISGKeyPressed( void )
{
    CheckedTag[1] = ( ScrData.ScrAttrs & SC_MINIMIZEISG ) ? TRUE : FALSE;
    GT_SetGadgetAttrsA( ScrTagsGadgets[ GD_ScrT_MinISG ], ScrTagsWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( ScrT_MinISGClicked() );
}

BOOL ScrT_MinISGClicked( void )
{
    ScrData.ScrAttrs ^= SC_MINIMIZEISG;
    return( TRUE );
}

BOOL ScrT_TypeKeyPressed( void )
{
    ScrData.Type = ST_CycleTag[1] = ST_CycleTag[1] ? 0 : 1;
    GT_SetGadgetAttrsA( ScrTagsGadgets[ GD_ScrT_Type ], ScrTagsWnd,
			NULL, (struct TagItem *)ST_CycleTag );

    return( TRUE );
}

BOOL ScrT_TypeClicked( void )
{
    ScrData.Type = IDCMPMsg.Code;
    return( TRUE );
}
///

/// Screen Font
BOOL ScrFontMenued( void )
{
    struct FontRequester   *req;

    if( req = AllocAslRequest( ASL_FontRequest, NULL )) {

	if( AslRequestTags( req, ASLFO_InitialHeight, Scr->Height - 40,
				 ASLFO_Screen, Scr,
				 ASLFO_TitleText, CatCompArray[ ASL_SCR_FONT ].cca_Str,
				 ASLFO_DoStyle, -1,
				 ASLFO_MaxHeight, 300,
				 ASLFO_InitialName, ScrData.FontScr,
				 ASLFO_InitialStyle, ScrData.NewFont.ta_Style,
				 ASLFO_InitialSize, ScrData.NewFont.ta_YSize,
				 ASLFO_InitialFlags, ScrData.NewFont.ta_Flags,
				 TAG_DONE )) {

	    ScrData.NewFont.ta_Style = req->fo_Attr.ta_Style;
	    ScrData.NewFont.ta_YSize = req->fo_Attr.ta_YSize;
	    ScrData.NewFont.ta_Flags = req->fo_Attr.ta_Flags;
	    strcpy( ScrData.FontScr, req->fo_Attr.ta_Name );

	    ScreenTags2[ SCRFNT ] = &ScrData.NewFont;

	    UpdateScr();

	    if( IE.flags_2 & GENERASCR )
		IE.flags &= ~SALVATO;

	} else
	    Stat( CatCompArray[ MSG_ABORTED ].cca_Str, FALSE, MSG_ABORTED );

	FreeAslRequest( req );

    } else
	Stat( CatCompArray[ ERR_NOASL ].cca_Str, TRUE, 0 );

    return( TRUE );
}
///

/// Gadgets Up & Down
void GadgetsUp( void )
{
    struct GadgetInfo *gad;
    struct WindowInfo *wnd;

    for( wnd = IE.win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ )
	for ( gad = wnd->wi_Gadgets.mlh_Head ; gad->g_Node.ln_Succ ; gad = gad->g_Node.ln_Succ ) {
	    BOOL can = FALSE;

	    if( gad->g_Kind < MIN_IEX_ID )
		can = TRUE;
	    else {
		struct IEXNode *ex;

		ex = IE.Expanders.mlh_Head;
		while( ex->ID != gad->g_Kind )
		    ex = ex->Node.ln_Succ;

		if( ex->Base->Movable || ex->Base->Resizable )
		    can = TRUE;
	    }

	    if( can )
		gad->g_Top += YOffset;
	}
}


void GadgetsDown( void )
{
    struct GadgetInfo *gad;
    struct WindowInfo *wnd;

    for( wnd = IE.win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ )
	for ( gad = wnd->wi_Gadgets.mlh_Head ; gad->g_Node.ln_Succ ; gad = gad->g_Node.ln_Succ ) {
	    BOOL can = FALSE;

	    if( gad->g_Kind < MIN_IEX_ID )
		can = TRUE;
	    else {
		struct IEXNode *ex;

		ex = IE.Expanders.mlh_Head;
		while( ex->ID != gad->g_Kind )
		    ex = ex->Node.ln_Succ;

		if( ex->Base->Movable || ex->Base->Resizable )
		    can = TRUE;
	    }

	    if( can )
	    gad->g_Top -= YOffset;
	}
}
///

/// ScreenMode requester
BOOL ScrTypeClicked( void )
{
    return( ScrTypeMenued() );
}

BOOL ScrTypeMenued( void )
{
    struct ScreenModeRequester  *req;
    struct Window               *wnd;

    if( req = AllocAslRequest( ASL_ScreenModeRequest, NULL )) {

	wnd = BackWnd;
	if( IE.flags_2 & DONTUPDATESCR )
	    wnd = NULL;

	if( buffer = AslRequestTags( req,
		ASLSM_Window, wnd,
		ASLSM_TitleText, CatCompArray[ ASL_SCR_TYPE ].cca_Str,
		ASLSM_InitialDisplayID, ScreenTags2[ SCRID ],
		ASLSM_InitialDisplayWidth, ScreenTags2[ SCRWIDTH ],
		ASLSM_InitialDisplayHeight, ScreenTags2[ SCRHEIGHT ],
		ASLSM_InitialDisplayDepth, ScreenTags2[ SCRDEPTH ],
		ASLSM_InitialOverscanType, ScreenTags2[ SCROVERSCAN ],
		ASLSM_InitialAutoScroll, ScreenTags2[ SCRAUTOSCROLL ],
		ASLSM_DoWidth, TRUE, ASLSM_DoHeight, TRUE,
		ASLSM_DoDepth, TRUE, ASLSM_DoOverscanType, TRUE,
		ASLSM_DoAutoScroll, TRUE, TAG_END )) {

	    ScreenTags2[ SCRID         ] = req->sm_DisplayID;
	    ScreenTags2[ SCRWIDTH      ] = req->sm_DisplayWidth;
	    ScreenTags2[ SCRHEIGHT     ] = req->sm_DisplayHeight;
	    ScreenTags2[ SCRDEPTH      ] = req->sm_DisplayDepth;
	    ScreenTags2[ SCROVERSCAN   ] = req->sm_OverscanType;
	    ScreenTags2[ SCRAUTOSCROLL ] = req->sm_AutoScroll;

	    if(!( IE.flags_2 & DONTUPDATESCR ))
		UpdateScr();

	    if( IE.flags_2 & GENERASCR )
		IE.flags &= ~SALVATO;
	}

	FreeAslRequest( req );

    } else
	Stat( CatCompArray[ ERR_NO_ASL ].cca_Str, TRUE, 0 );

    return( TRUE );
}
///

/// UpdateScr
void UpdateScr( void )
{
    struct WindowInfo   *wnd;
    UWORD               old_YOffset;

    CloseReqs();

    CheckForVisitors();

    GadgetsDown();

    if( ToolsWnd ) {
	toolsx = ToolsWnd->LeftEdge;
	toolsy = ToolsWnd->TopEdge;
	CloseToolsWindow();
    }

    IE.win_open    = 0;
    IE.win_info    = NULL;
    IE.win_active  = NULL;

    for( wnd = IE.win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	if ( wnd->wi_flags1 & W_APERTA ) {
	    CloseWindowSafely( wnd->wi_winptr );
	    wnd->wi_flags1 &= ~W_APERTA;
	    wnd->wi_flags1 |=  W_RIAPRI;
	    wnd->wi_winptr  =  NULL;
	}
    }

    IE.flags |= WNDCHIUSA;

    CloseBackWindow();

    old_YOffset = YOffset;

    if(!( IE.colortable ))
	GrabPalette();

    CloseDownScreen();

    ScreenTags2[19] = (ULONG)CatCompArray[ MSG_STRING_0 ].cca_Str;

    do {

	while(!( Scr = OpenScreenTagList( NULL, (struct TagItem *)ScreenTags2 )))
	    if( ScrError() )
		return;

	if( IE.colortable ) {
	    if( SysBase->LibNode.lib_Version >= 39 )
		LoadRGB32( &Scr->ViewPort, (ULONG *)IE.colortable );
	    else
		LoadRGB4( &Scr->ViewPort, (UWORD *)IE.colortable+2, *((UWORD *)IE.colortable));
	}

	ScrData.Visual = VisualInfo = GetVisualInfoA( Scr, NULL );

	LayoutMenusA( BackMenus, VisualInfo, (struct TagItem *)MenuTag );

	BackWTags[ WT_WIDTH  ].ti_Data = Scr->Width;
	BackWTags[ WT_HEIGHT ].ti_Data = Scr->Height;

    } while( OpenBackWindow() );

    MyTask->pr_WindowPtr = BackWnd;

    back_mask = 1 << BackWnd->UserPort->mp_SigBit;
    signalset = back_mask | 0x1000 | editing_mask | rexx_mask;

    ScrData.Screen  = Scr;
    ScrData.YOffset = YOffset = Scr->WBorTop + Scr->Font->ta_YSize;
    ScrData.XOffset = XOffset = Scr->WBorLeft;

    old_YOffset = YOffset - old_YOffset;

    WorkWndTags[ WORKSCR ] = Scr;

    GadgetsUp();

    for( wnd = IE.win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {

	wnd->wi_Height += old_YOffset;

	if( wnd->wi_flags1 & W_RIAPRI ) {

	    IE.win_info = wnd;

	    RifaiGadgets();

	    WorkWndTags[ WORKTOP     ] = wnd->wi_Top;
	    WorkWndTags[ WORKLEFT    ] = wnd->wi_Left;
	    WorkWndTags[ WORKHEIGHT  ] = wnd->wi_Height;
	    WorkWndTags[ WORKWIDTH   ] = wnd->wi_Width;
	    WorkWndTags[ WORKTITLE   ] = wnd->wi_name;
	    WorkWndTags[ WORKFLAGS   ] = ( IE.mainprefs & WFLAGS ) ? ( wnd->wi_Flags | WFLG_REPORTMOUSE ) : ( W_F );

	    if( wnd->wi_NumBools ) {
		struct BooleanInfo *bool;

		bool = ( struct BooleanInfo * )wnd->wi_Gadgets.mlh_Head;

		while( bool->b_Kind != BOOLEAN )
		    bool = bool->b_Node.ln_Succ;

		WorkWndTags[ WORKGADGETS ] = ( ULONG )&bool->b_NextGadget;

	    } else
		WorkWndTags[ WORKGADGETS ] = ( ULONG )wnd->wi_GList;

	    if(!( wnd->wi_winptr = OpenWindowShdIDCMP( WorkWndTags, WorkWIDCMP ))) {
		Stat( CatCompArray[ ERR_NOWND ].cca_Str, TRUE, ERR_NOWND );
		return;
	    }

	    wnd->wi_flags1 &= ~W_RIAPRI;
	    wnd->wi_flags1 |=  W_APERTA;

	    IE.win_active = wnd->wi_winptr;

	    wnd->wi_winptr->UserData = wnd;
	    wnd->wi_winptr->ExtData  = HandleEdit;

	    IE.win_open += 1;

	    if( IE.mainprefs & STACCATI ) {
		IE.mainprefs &= ~STACCATI;
		StaccaGadgets();
		IE.mainprefs |= STACCATI;
	    }

	    RinfrescaFinestra();

	    SetMenuStrip( wnd->wi_winptr, BackMenus );
	    SetPointer( wnd->wi_winptr, puntatore, 13, 16, -7, -6 );
	}
    }

    if( IE.num_win ) {
	OnMenu( BackWnd, (2<<5)|1 );
	if( IE.win_open ) {
	    CheckMenuToActive();
	    for( old_YOffset = 0; old_YOffset < ATTIVAMENU_NUOVAW_NUM; old_YOffset++ )
		OnMenu( BackWnd, attivamenu_nuovawin[ old_YOffset ]);
	}
    }

    opentoolswnd();

    SistemaMacroMenu();

    SistemaPrefsMenu();

    PubScreenStatus( Scr, 0 );

    if( IE.win_active )
	ActivateWindow( IE.win_active );

    IE.flags |= WNDCHIUSA;
}



BOOL ScrError( void )
{
    ULONG   back = buffer;

    CloseDownScreen();
    CloseBackWindow();

    IE.flags_2 |= DONTUPDATESCR;

    ScreenToFront( NULL );

    ScrTypeMenued();

    IE.flags_2 &= ~DONTUPDATESCR;

    if( buffer ) {
	buffer = back;
	return( FALSE );
    } else {
	buffer = back;
	IE.flags |= ESCI;
	return( TRUE );
    }
}
///

/// CheckForVisitors
void CheckForVisitors( void )
{
    while (!( PubScreenStatus( Scr, PSNF_PRIVATE ) & 1 ))
	IERequest( CatCompArray[ MSG_UPDATESCR ].cca_Str,
		   ok_txt, MSG_UPDATESCR, 0L );
}
///

/// CloseReqs
void CloseReqs( void )
{
    CloseDriPensWindow();

    if( ScrTagsWnd ) {
	ScrT_OkClicked();
	CloseScrTagsWindow();
    }

    if( LocaleWnd ) {
	LOC_OkClicked();
	CloseLocaleWindow();
    }

    CloseGenReq();

    if( MacroWnd ) {
	GetF();
	CloseMacroWindow();
    }

    if( MainProcWnd ) {
	MainProcCloseWindow();
	CloseMainProcWindow();
    }

    CloseRexxEdReq();

    CloseImgBankWindow();

    if( SrcParamsWnd ) {
	SP_OkClicked();
	CloseSrcParamsWindow();
    }
}
///

/// RifaiGadgets
void RifaiGadgets( void )
{
    ULONG              *tags;
    UWORD               kind;
    int                 cnt;
    struct Gadget      *last, *next;
    struct GadgetInfo  *gad;
    struct IEXNode     *ex;


    if( IE.win_info->wi_flags1 & W_APERTA )
	StaccaGadgets();

    if ( IE.win_info->wi_GList ) {
	FreeGadgets( IE.win_info->wi_GList );
	IE.win_info->wi_GList = NULL;
    }

    if(!( last = CreateContext( &IE.win_info->wi_GList )))
	return;

    if( IE.win_info->wi_NumGads ) {

	for ( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
	    kind = gad->g_Kind;
	    if( kind < BOOLEAN ) {
		void  ( *func )( ULONG *, ULONG, struct GadgetInfo * );

		tags = newtags_index[ kind - 1 ];
		SetUnder( tags, gad->g_Tags );

		func = settag_index[ kind ];
		( *func )( tags, gad->g_Tags, gad );

		if(( kind == MX_KIND ) || ( kind == CYCLE_KIND )) {
		    struct GadgetScelta *gs;
		    ULONG  *point;

		    if( gad->g_ExtraMem )
			FreeVec( gad->g_ExtraMem );

		    gad->g_ExtraMem = AllocVec(( gad->g_NumScelte << 2 ) + 4, 0L );
		    if (!( tags[ 3 ] = gad->g_ExtraMem ))
			return;

		    gs = gad->g_Scelte.mlh_Head;
		    point = gad->g_ExtraMem;

		    for ( cnt = 0; cnt < gad->g_NumScelte; cnt++ ) {
			point[ cnt ] = gs->gs_Node.ln_Name;
			gs = gs->gs_Node.ln_Succ;
		    }
		    point[ cnt ] = NULL;
		}

		gad->g_VisualInfo = VisualInfo;

		if ( gad->g_Ptr = CreateGadgetA( kind,
						 last,
						 (struct NewGadget *)&gad->g_Left,
						 (struct TagItem *)tags )) {
		    last = gad->g_Ptr;
		} else
		    DisplayBeep( Scr );
	    }
	}
    }

    for( ex = IE.Expanders.mlh_Head; ex->Node.ln_Succ; ex = ex->Node.ln_Succ ) {
	IEXBase = ex->Base;
	if( next = IEX_Make( ex->ID, &IE, last ))
	    last = next;
	else
	    DisplayBeep( Scr );
    }

    if( IE.win_info->wi_NumBools ) {

	SistemaNextBool();

	gad = IE.win_info->wi_Gadgets.mlh_Head;
	while ( gad->g_Kind != BOOLEAN )
	    gad = gad->g_Node.ln_Succ;

	last = (struct Gadget *)&((struct BooleanInfo *)gad)->b_NextGadget;

    } else
	last = IE.win_info->wi_GList;


    if(( IE.win_info->wi_flags1 & W_APERTA ) && ( IE.win_info->wi_winptr )) {

	AddGList( IE.win_info->wi_winptr, last, -1, -1, NULL );
	RefreshGadgets( last, IE.win_info->wi_winptr, NULL );
	GT_RefreshWindow( IE.win_info->wi_winptr, NULL );

	if( IE.mainprefs & STACCATI ) {
	    IE.mainprefs &= ~STACCATI;
	    StaccaGadgets();
	    IE.mainprefs |= STACCATI;
	}
    }
}
///
