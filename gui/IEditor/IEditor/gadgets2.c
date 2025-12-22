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
#include <exec/types.h>
#include <intuition/intuition.h>        // intuition
#include <libraries/gadtools.h>         // libraries
#include <libraries/reqtools.h>
#include <clib/exec_protos.h>           // protos
#include <clib/intuition_protos.h>
#include <clib/graphics_protos.h>
#include <clib/dos_protos.h>
#include <clib/locale_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/reqtools_protos.h>
#include <pragmas/exec_pragmas.h>       // pragmas
#include <pragmas/intuition_pragmas.h>
#include <pragmas/graphics_pragmas.h>
#include <pragmas/dos_pragmas.h>
#include <pragmas/locale_pragmas.h>
#include <pragmas/gadtools_pragmas.h>
#include <pragmas/reqtools_pragmas.h>


#include "DEV_IE:defs.h"
#include "DEV_IE:GUI.h"
#include "DEV_IE:GUI_locale.h"
///
/// Prototipi
static void     AttaccaTabList( void );
static void     StaccaTabList( void );
static BOOL     SortXGadgets( void );
static BOOL     SortYGadgets( void );
static int      CmpGads( struct GadSort *, struct GadSort * );
static void     Img_AttivaSelRend( void );
static void     Img_AttivaTesto( void );
static void     Img_DisattivaSelRend( void );
static void     Img_DisattivaTesto( void );
static struct GadgetBank *GetGadgetBank( void );
static void     EditGBank( struct GadgetBank * );

struct GadSort {
    struct GadgetInfo  *Info;
    WORD                Weight;
};
///
/// Dati
struct MinList  TabOrder_List;

static struct GadSort *SortArray;

static UWORD InSort;

static ULONG IntReq_tags[] = {
	    RT_Screen, 0, RT_ReqPos, REQPOS_CENTERSCR,
	    RTGL_Min, 0, RTGL_Max, 1000,
	    RTGL_ShowDefault, -1,
	    TAG_END
	};

struct Node NoneNode = { NULL, NULL, 0, 0, "(---)" };

UBYTE DrawModes[] = { JAM1, JAM2, COMPLEMENT };

static UWORD GadgetFlags[] = { GFLG_GADGHNONE, GFLG_GADGHCOMP,
			       GFLG_GADGHBOX, GFLG_GADGHIMAGE };
///


//          Varie
/// Get Node Num
ULONG GetNodeNum( APTR list, APTR node )
{
    ULONG           num = 0;
    struct Node    *n2;

    n2 = ((struct List *)list)->lh_Head;

    while( n2 != node ) {
	n2 = n2->ln_Succ;
	num++;
    }

    return( num );
}
///

//          Gadgets In Generale
/// CheckActivationKey
BOOL CheckActivationKey( struct WindowInfo *wnd, struct GadgetInfo *gad )
{
    struct GadgetInfo  *g;

    if(( gad->g_Kind == BOOLEAN ) || ( gad->g_Key == '\0' ))
	return( FALSE );

    for( g = wnd->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ )
	if(( g != gad ) && ( g->g_Kind != BOOLEAN ) && ( g->g_Key == gad->g_Key ))
	    return( TRUE );

    return( FALSE );
}
///
/// TabCycle Order
BOOL TabOrderMenued( void )
{
    int                 ret;
    struct GadgetInfo  *gad;

    LockAllWindows();

    if( IE.win_info->wi_GadTypes[ INTEGER_KIND - 1 ] + IE.win_info->wi_GadTypes[ STRING_KIND - 1 ]) {

	NewList((struct List *)&TabOrder_List );

	buffer = 0;

	for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
	    if(( gad->g_Kind == INTEGER_KIND ) || ( gad->g_Kind == STRING_KIND )) {
		buffer += 1;
		Remove((struct Node *)gad );
		AddTail((struct List *)&TabOrder_List, (struct Node *)gad );
		gad->g_Node.ln_Name = gad->g_Label;
		gad = IE.win_info->wi_Gadgets.mlh_Head;
	    }
	}

	LayoutWindow( TabCycleWTags );
	ret = OpenTabCycleWindow();
	PostOpenWindow( TabCycleWTags );

	if( ret )
	    DisplayBeep( Scr );
	else {

	    List2Tag[1] = 0;
	    AttaccaTabList();

	    buffer2 = TabOrder_List.mlh_Head;

	    while( ReqHandle( TabCycleWnd, HandleTabCycleIDCMP ));
	}

	while( gad = RemHead((struct List *)&TabOrder_List ))
	    AddTail((struct List *)&IE.win_info->wi_Gadgets, (struct Node *)gad );

	CloseTabCycleWindow();

	RifaiGadgets();
    }

    UnlockAllWindows();

    return( TRUE );
}

void AttaccaTabList( void )
{
    ListTag[1] = &TabOrder_List;
    GT_SetGadgetAttrsA( TabCycleGadgets[ GD_TC_Gadgets ], TabCycleWnd,
			NULL, (struct TagItem *)ListTag );
    GT_SetGadgetAttrsA( TabCycleGadgets[ GD_TC_Gadgets ], TabCycleWnd,
			NULL, (struct TagItem *)List2Tag );
}

void StaccaTabList( void )
{
    ListTag[1] = 0L;
    GT_SetGadgetAttrsA( TabCycleGadgets[ GD_TC_Gadgets ], TabCycleWnd,
			NULL, (struct TagItem *)ListTag );
}

BOOL TC_GadgetsClicked( void )
{
    struct Node *node;
    int          n;

    List2Tag[1] = List2Tag[3] = TabCycleMsg.Code;

    node = (struct Node *)&TabOrder_List;
    for( n = 0; n <= TabCycleMsg.Code; n++ )
	node = node->ln_Succ;

    buffer2 = node;

    return( TRUE );
}

BOOL TC_TopClicked( void )
{

    StaccaTabList();

    Remove((struct Node *)buffer2 );
    AddHead((struct List *)&TabOrder_List, (struct Node *)buffer2 );
    List2Tag[1] = List2Tag[3] = 0;

    AttaccaTabList();

    return( TRUE );
}

BOOL TC_BottomClicked( void )
{

    StaccaTabList();

    Remove((struct Node *)buffer2 );
    AddTail((struct List *)&TabOrder_List, (struct Node *)buffer2 );
    List2Tag[1] = List2Tag[3] = buffer - 1;

    AttaccaTabList();

    return( TRUE );
}

BOOL TC_UpClicked( void )
{
    if( List2Tag[1] ) {

	List2Tag[1] -= 1;

	StaccaTabList();
	NodeUp( (APTR)buffer2 );
	AttaccaTabList();
    }

    return( TRUE );
}

BOOL TC_DownClicked( void )
{
    if( List2Tag[1] < buffer - 1 ) {

	List2Tag[1] += 1;

	StaccaTabList();
	NodeDown( (APTR)buffer2 );
	AttaccaTabList();
    }

    return( TRUE );
}

BOOL TabCycleCloseWindow( void )
{
    return( FALSE );
}
///
/// Ordinamento dei gadgets
int CmpGads( struct GadSort *g1, struct GadSort *g2 )
{
    return( g1->Weight - g2->Weight );
}

BOOL SortXGadgets( void )
{
    BOOL                ret = TRUE;
    struct GadgetInfo  *gad;
    int                 i;

    InSort = 0;

    for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ )
	if( gad->g_flags2 & G_ATTIVO )
	    InSort += 1;

    if( InSort ) {

	if( SortArray = AllocVec( InSort * sizeof( struct GadSort ), 0L )) {

	    i = 0;
	    for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
		if( gad->g_flags2 & G_ATTIVO ) {
		    SortArray[ i ].Info   = gad;
		    SortArray[ i ].Weight = gad->g_Left;
		    i += 1;
		}
	    }

	    qsort( SortArray, InSort, sizeof( struct GadSort ), CmpGads );

	} else {

	    Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, 0 );
	    ret = FALSE;

	}

    }

    return( ret );
}

BOOL SortYGadgets( void )
{
    BOOL                ret = TRUE;
    struct GadgetInfo  *gad;
    int                 i;

    InSort = 0;

    for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
	if( gad->g_flags2 & G_ATTIVO ) {

	    InSort++;

	}
    }

    if( InSort ) {

	if( SortArray = AllocVec( InSort * sizeof( struct GadSort ), 0L )) {

	    i = 0;

	    for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
		if( gad->g_flags2 & G_ATTIVO ) {
		    SortArray[ i ].Info   = gad;
		    SortArray[ i ].Weight = gad->g_Top;
		    i += 1;
		}
	    }

	    qsort( SortArray, InSort, sizeof( struct GadSort ), CmpGads );

	} else {

	    Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, 0 );
	    ret = FALSE;

	}

    }

    return( ret );
}
///
/// Spaziatura Gadgets
BOOL XSpaceMenued( void )
{
    ULONG               Space = 4;
    WORD                NewX, i;
    struct GadgetInfo  *gad;

    if( TestAttivi() ) {

	if( SortXGadgets() ) {

	    if( InSort > 1 ) {

		IntReq_tags[1] = Scr;

		if( rtGetLongA( &Space, "X...", NULL, (struct TagItem *)IntReq_tags ) ) {

		    gad = SortArray[0].Info;

		    NewX = gad->g_Left + gad->g_Width + Space;

		    for( i = 1; i < InSort; i++ ) {
			gad = SortArray[ i ].Info;
			gad->g_Left = NewX;
			NewX += ( gad->g_Width + Space );
		    }

		    RifaiGadgets();
		    RinfrescaFinestra();
		    IE.flags &= ~SALVATO;

		} else
		    Stat( CatCompArray[ MSG_ABORTED ].cca_Str, FALSE, 0 );
	    }

	    FreeVec( SortArray );
	}
    }

    return( TRUE );
}

BOOL YSpaceMenued( void )
{
    ULONG               Space = 2;
    WORD                NewY, i;
    struct GadgetInfo  *gad;

    if( TestAttivi() ) {

	if( SortYGadgets() ) {

	    if( InSort > 1 ) {

		IntReq_tags[1] = Scr;

		if( rtGetLongA( &Space, "Y...", NULL, (struct TagItem *)IntReq_tags ) ) {

		    gad = SortArray[0].Info;

		    NewY = gad->g_Top + gad->g_Height + Space;

		    for( i = 1; i < InSort; i++ ) {
			gad = SortArray[ i ].Info;
			gad->g_Top = NewY;
			NewY += ( gad->g_Height + Space );
		    }

		    RifaiGadgets();
		    RinfrescaFinestra();
		    IE.flags &= ~SALVATO;

		} else {
		    Stat( CatCompArray[ MSG_ABORTED ].cca_Str, FALSE, 0 );
		}
	    }
	}
    }

    return( TRUE );
}
///
/// Distribuisci Gadgets
BOOL SpreadVertMenued( void )
{
    struct IntuiMessage    *msg;
    struct Window          *wnd;
    int                     code, clicks = 0;
    ULONG                   class;
    BOOL                    ok = TRUE;
    WORD                    start, end, old, all;

    if( TestAttivi() ) {

	IE.win_active->Flags |= WFLG_RMBTRAP;
	SetDrMd( IE.win_active->RPort, COMPLEMENT );

	old = IE.win_active->MouseY;

	Move( IE.win_active->RPort, IE.win_active->BorderLeft + 1, old );
	Draw( IE.win_active->RPort, IE.win_active->Width - IE.win_active->BorderRight - 1, old );

	do {

	    WaitPort( IE.win_active->UserPort );

	    while( msg = GT_GetIMsg( IE.win_active->UserPort )) {

		class = msg->Class;
		code  = msg->Code;
		wnd   = msg->IDCMPWindow;

		GT_ReplyIMsg( msg );

		if( wnd == IE.win_active ) {

		    end = wnd->MouseY;

		    switch( class ) {

			case IDCMP_VANILLAKEY:
			    if( code == 27 ) {
				ok = FALSE;
				clicks = 3;
			    }
			    break;

			case IDCMP_REFRESHWINDOW:
			    RinfrescaFinestra();
			    break;

			case IDCMP_MOUSEBUTTONS:
			    switch( code ) {
				case 0x69:
				    ok = FALSE;
				    clicks = 3;
				    break;

				case 0x68:
				    if(!( clicks ))
					start = end;
				    clicks += 1;
				    Move( IE.win_active->RPort, IE.win_active->BorderLeft + 1, old );
				    Draw( IE.win_active->RPort, IE.win_active->Width - IE.win_active->BorderRight - 1, old );
				    break;
			    }
			    break;

			case IDCMP_MOUSEMOVE:
			    if( end < IE.win_active->BorderTop ) {
				end = IE.win_active->BorderTop;
			    } else {
				if( end >= IE.win_active->Height )
				    end = IE.win_active->Height - 1;
			    }
			    Coord();
			    Move( IE.win_active->RPort, IE.win_active->BorderLeft + 1, old );
			    Draw( IE.win_active->RPort, IE.win_active->Width - IE.win_active->BorderRight - 1, old );
			    old = end;
			    Move( IE.win_active->RPort, IE.win_active->BorderLeft + 1, old );
			    Draw( IE.win_active->RPort, IE.win_active->Width - IE.win_active->BorderRight - 1, old );
			    break;
		    }
		}

	    }

	} while( clicks < 2 );

	if( ok ) {

	    if( end < start ) {
		old   = end;
		end   = start;
		start = old;
	    }

	    if( SortYGadgets() ) {

		if( InSort > 1 ) {

		    all = start - 1;

		    for( old = 0; old < InSort; old++ )
			all += SortArray[ old ].Info->g_Height;

		    SortArray[ 0 ].Info->g_Top = start;

		    InSort -= 1;

		    SortArray[ InSort ].Info->g_Top = end - SortArray[ InSort ].Info->g_Height + 1;

		    all = ( end - all ) / InSort;

		    start += ( SortArray[ 0 ].Info->g_Height + all );

		    for( old = 1; old < InSort; old++ ) {
			SortArray[ old ].Info->g_Top = start;
			start += ( SortArray[ old ].Info->g_Height + all );
		    }

		} else {

		    SortArray[0].Info->g_Top = ( start + (( end - start ) >> 1 )) - ( SortArray[0].Info->g_Height >> 1 );

		}

		FreeVec( SortArray );

		RifaiGadgets();
		RinfrescaFinestra();

		Stat( CatCompArray[ MSG_DONE ].cca_Str, FALSE, 0 );
		IE.flags &= ~SALVATO;
	    }

	} else {
	    RinfrescaFinestra();
	    Stat( CatCompArray[ MSG_ABORTED ].cca_Str, FALSE, 0 );
	}

	SetDrMd( IE.win_active->RPort, JAM1 );
	IE.win_active->Flags &= ~WFLG_RMBTRAP;

    }

    return( TRUE );
}

BOOL SpreadHorizMenued( void )
{
    struct IntuiMessage    *msg;
    struct Window          *wnd;
    int                     code, clicks = 0;
    ULONG                   class;
    BOOL                    ok = TRUE;
    WORD                    start, end, old, all;

    if( TestAttivi() ) {

	IE.win_active->Flags |= WFLG_RMBTRAP;
	SetDrMd( IE.win_active->RPort, COMPLEMENT );

	old = IE.win_active->MouseX;

	Move( IE.win_active->RPort, old, YOffset + 1 );
	Draw( IE.win_active->RPort, old, IE.win_active->Height - IE.win_active->BorderBottom - 1 );

	do {

	    WaitPort( IE.win_active->UserPort );

	    while( msg = GT_GetIMsg( IE.win_active->UserPort )) {

		class = msg->Class;
		code  = msg->Code;
		wnd   = msg->IDCMPWindow;

		GT_ReplyIMsg( msg );

		if( wnd == IE.win_active ) {

		    end = wnd->MouseX;

		    switch( class ) {

			case IDCMP_VANILLAKEY:
			    if( code == 27 ) {
				ok = FALSE;
				clicks = 3;
			    }
			    break;

			case IDCMP_REFRESHWINDOW:
			    RinfrescaFinestra();
			    break;

			case IDCMP_MOUSEBUTTONS:
			    switch( code ) {
				case 0x69:
				    ok = FALSE;
				    clicks = 3;
				    break;

				case 0x68:
				    if(!( clicks ))
					start = end;
				    clicks += 1;
				    Move( IE.win_active->RPort, old, YOffset + 1 );
				    Draw( IE.win_active->RPort, old, IE.win_active->Height - IE.win_active->BorderBottom - 1 );
				    break;
			    }
			    break;

			case IDCMP_MOUSEMOVE:
			    if( end < 0 ) {
				end = 0;
			    } else {
				if( end >= IE.win_active->Width )
				    end = IE.win_active->Width - 1;
			    }
			    Coord();
			    Move( IE.win_active->RPort, old, YOffset + 1 );
			    Draw( IE.win_active->RPort, old, IE.win_active->Height - IE.win_active->BorderBottom - 1 );
			    old = end;
			    Move( IE.win_active->RPort, old, YOffset + 1 );
			    Draw( IE.win_active->RPort, old, IE.win_active->Height - IE.win_active->BorderBottom - 1 );
			    break;
		    }
		}

	    }

	} while( clicks < 2 );

	if( ok ) {

	    if( end < start ) {
		old   = end;
		end   = start;
		start = old;
	    }

	    if( SortXGadgets() ) {

		if( InSort > 1 ) {

		    all = start - 1;

		    for( old = 0; old < InSort; old++ )
			all += SortArray[ old ].Info->g_Width;

		    SortArray[ 0 ].Info->g_Left = start;

		    InSort -= 1;

		    SortArray[ InSort ].Info->g_Left = end - SortArray[ InSort ].Info->g_Width + 1;

		    all = ( end - all ) / InSort;

		    start += ( SortArray[ 0 ].Info->g_Width + all );

		    for( old = 1; old < InSort; old++ ) {
			SortArray[ old ].Info->g_Left = start;
			start += ( SortArray[ old ].Info->g_Width + all );
		    }

		} else {

		    SortArray[0].Info->g_Left = ( start + (( end - start ) >> 1 )) - ( SortArray[0].Info->g_Width >> 1 );

		}

		FreeVec( SortArray );

		RifaiGadgets();
		RinfrescaFinestra();

		Stat( CatCompArray[ MSG_DONE ].cca_Str, FALSE, 0 );
		IE.flags &= ~SALVATO;
	    }

	} else {
	    RinfrescaFinestra();
	    Stat( CatCompArray[ MSG_ABORTED ].cca_Str, FALSE, 0 );
	}

	SetDrMd( IE.win_active->RPort, JAM1 );
	IE.win_active->Flags &= ~WFLG_RMBTRAP;

    }

    return( TRUE );
}
///

//          Gadgets BOOLEANI
/// Aggiungi Booleano
void AggiungiBooleano( void )
{
    struct BooleanInfo  *gad;
    int                  swap;

    if( gad = AllocObject( IE_BOOLEAN )) {

	gad->b_FrontPen     = 1;
	gad->b_Kind         = BOOLEAN;

	ActivateWindow( IE.win_active );

	IE.flags &= ~RECTFIXED;
	DrawRect( 0, 0 );

	offx = offy = 0;
	Coord();

	if( clickx > lastx ) {
	    swap = lastx;
	    lastx = clickx;
	    clickx = swap;
	}

	if( clicky > lasty ) {
	    swap = lasty;
	    lasty = clicky;
	    clicky = swap;
	}

	gad->b_Left     = clickx;
	gad->b_Top      = clicky;
	gad->b_Width    = ( lastx - clickx ) + 1;
	gad->b_Height   = ( lasty - clicky ) + 1;

	CheckSize((struct GadgetInfo *)gad );

	ParametriBooleano( gad );

	if( buffer ) {
	    UBYTE   prefs;

	    prefs = IE.mainprefs;

	    if(!( gad->b_Label[0] )) {
		sprintf( gad->b_Label, "%sGad%03ld",
			 IE.win_info->wi_Label,
			 IE.win_info->wi_NewGadID );
		IE.win_info->wi_NewGadID += 1;
	    }

	    if(!( IE.win_info->wi_NumGads ))
		MenuGadgetAttiva();

	    IE.win_info->wi_NumGads  += 1;
	    IE.win_info->wi_NumBools += 1;

	    AddTail((struct List *)&IE.win_info->wi_Gadgets, (struct Node *)gad );

	    if(!( prefs & STACCATI ))
		StaccaGadgets();

	    SistemaNextBool();
	    AttaccaGadgets();

	    if( prefs & STACCATI ) {
		IE.mainprefs &= ~STACCATI;
		StaccaGadgets();
		IE.mainprefs |= STACCATI;
	    }

	    DisattivaTuttiGad();

	    gad->b_flags2 |= G_ATTIVO;

	    RinfrescaFinestra();

	    IE.flags &= ~SALVATO;

	    Stat( CatCompArray[ MSG_GAD_ADDED ].cca_Str, FALSE, 0 );

	} else {
	    FreeObject( gad, IE_BOOLEAN );
	    Stat( CatCompArray[ MSG_ABORTED ].cca_Str, FALSE, 0 );
	}

    } else {
	Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, 0 );
    }
}
///
/// Parametri Booleano
void ParametriBooleano( struct BooleanInfo *gad )
{
    ULONG   old_Flags;
    APTR    old_GR, old_SR;
    UBYTE   old_FP, old_BP, old_DM, old_flags2, dm;
    int     ret, cnt;
    UWORD   flg;
    ULONG  *ptr;

    old_Flags   = gad->b_Flags;
    old_GR      = gad->b_GadgetRender;
    old_SR      = gad->b_SelectRender;
    old_FP      = gad->b_FrontPen;
    old_BP      = gad->b_BackPen;
    old_DM      = gad->b_DrawMode;
    old_flags2  = gad->b_flags2;

    LockAllWindows();
    AddHead(( struct List * )&IE.Img_List, &NoneNode );


    ptr = ImgButGTags;

    while( *ptr++ != GTPA_Depth ) {}
    *ptr++ = IE.ScreenData->Tags[ SCRDEPTH ];
    while( *ptr++ != GTPA_Depth ) {}
    *ptr   = IE.ScreenData->Tags[ SCRDEPTH ];

    LayoutWindow( ImgButWTags );
    ret = OpenImgButWindow();
    PostOpenWindow( ImgButWTags );

    if(!( ret )) {

	IntegerTag[1] = gad->b_Width;
	GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_Width ], ImgButWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = gad->b_Height;
	GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_Height ], ImgButWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = gad->b_TxtLeft;
	GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_X ], ImgButWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = gad->b_TxtTop;
	GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_Y ], ImgButWnd,
			    NULL, (struct TagItem *)IntegerTag );

	StringTag[1] = gad->b_Label;
	GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_Label ], ImgButWnd,
			    NULL, (struct TagItem *)StringTag );

	StringTag[1] = gad->b_Titolo;
	GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_Txt ], ImgButWnd,
			    NULL, (struct TagItem *)StringTag );

	PaletteTag[1] = gad->b_FrontPen;
	GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_FP ], ImgButWnd,
			    NULL, (struct TagItem *)PaletteTag );

	PaletteTag2[1] = gad->b_BackPen;
	GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_BP ], ImgButWnd,
			    NULL, (struct TagItem *)PaletteTag2 );

	dm = gad->b_DrawMode & ~INVERSVID;
	cnt = 0;
	while( DrawModes[ cnt ] != dm )
	    cnt++;

	CycleTag[1] = dm;
	GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_RPMode ], ImgButWnd,
			    NULL, (struct TagItem *)CycleTag );

	CheckedTag[1] = ( gad->b_DrawMode & INVERSVID ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_Invers ], ImgButWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->b_Flags & GFLG_SELECTED ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_Sel ], ImgButWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->b_Flags & GFLG_DISABLED ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_Disab ], ImgButWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->b_Activation & GACT_TOGGLESELECT ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_Toggle ], ImgButWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->b_Activation & GACT_IMMEDIATE ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_Immediate ], ImgButWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->b_Activation & GACT_RELVERIFY ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_RelVer ], ImgButWnd,
			    NULL, (struct TagItem *)CheckedTag );

	CheckedTag[1] = ( gad->b_Activation & GACT_FOLLOWMOUSE ) ? TRUE : FALSE;
	GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_Follow ], ImgButWnd,
			    NULL, (struct TagItem *)CheckedTag );

	flg = gad->b_Flags & ~(GFLG_GADGIMAGE | GFLG_DISABLED | GFLG_SELECTED );
	cnt = 0;
	while( GadgetFlags[ cnt ] != flg )
	    cnt++;

	MXTag[1] = cnt;
	GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_High ], ImgButWnd,
			    NULL, (struct TagItem *)MXTag );

	if( flg == GFLG_GADGHIMAGE )
	    Img_AttivaSelRend();

	if( gad->b_flags2 & B_TEXT ) {
	    CheckedTag[1] = TRUE;
	    GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_ChkTxt ], ImgButWnd,
				NULL, (struct TagItem *)CheckedTag );
	    Img_AttivaTesto();
	}

	ListTag[1] = &IE.Img_List;
	GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_GadRend ], ImgButWnd,
			    NULL, (struct TagItem *)ListTag );
	GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_SelRend ], ImgButWnd,
			    NULL, (struct TagItem *)ListTag );

	if( gad->b_GadgetRender ) {
	    List2Tag[1] = List2Tag[3] = GetNodeNum( &IE.Img_List, (APTR)((ULONG)gad->b_GadgetRender - 14 ));
	    GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_GadRend ], ImgButWnd,
				NULL, (struct TagItem *)List2Tag );
	}

	if( gad->b_SelectRender ) {
	    List2Tag2[1] = List2Tag2[3] = GetNodeNum( &IE.Img_List, (APTR)((ULONG)gad->b_SelectRender - 14 ));
	    GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_SelRend ], ImgButWnd,
				NULL, (struct TagItem *)List2Tag2 );
	}

	buffer = FALSE;
	buffer2 = gad;

	RetCode = 0;

	do {
	    ReqHandle( ImgButWnd, HandleImgButIDCMP );
	} while(!( RetCode ));

	if( RetCode > 0 ) {

	    gad->b_Flags        = old_Flags;
	    gad->b_flags2       = old_flags2;
	    gad->b_FrontPen     = old_FP;
	    gad->b_BackPen      = old_BP;
	    gad->b_DrawMode     = old_DM;
	    gad->b_GadgetRender = old_GR;
	    gad->b_SelectRender = old_SR;

	} else {

	    STRPTR label;

	    label = GetString( ImgButGadgets[ GD_Img_Label ]);

	    if( label[0] )
		strcpy( gad->b_Label, label );
	    strcpy( gad->b_Titolo, GetString( ImgButGadgets[ GD_Img_Txt ]) );

	    if( gad->b_flags2 & B_TEXT )
		gad->b_Text = gad->b_Titolo;
	    else
		gad->b_Text = NULL;

	    gad->b_Width    = GetNumber( ImgButGadgets[ GD_Img_Width ]);
	    gad->b_Height   = GetNumber( ImgButGadgets[ GD_Img_Height ]);
	    gad->b_TxtLeft  = GetNumber( ImgButGadgets[ GD_Img_X ]);
	    gad->b_TxtTop   = GetNumber( ImgButGadgets[ GD_Img_Y ]);

	    buffer = TRUE;
	}

    } else {
	DisplayBeep( Scr );
    }

    CloseImgButWindow();

    RemHead(( struct List * )&IE.Img_List );
    UnlockAllWindows();
}

BOOL Img_AnnullaKeyPressed( void )
{
    RetCode = 1;
}

BOOL Img_AnnullaClicked( void )
{
    RetCode = 1;
}

BOOL Img_OKKeyPressed( void )
{
    RetCode = -1;
}

BOOL Img_OKClicked( void )
{
    RetCode = -1;
}

BOOL ImgButVanillaKey( void )
{
    switch( ImgButMsg.Code ) {
	case 13:
	    RetCode = -1;
	    break;
	case 27:
	    RetCode = 1;
	    break;
    }
}

BOOL Img_WidthClicked( void )
{
    ActivateGadget( ImgButGadgets[ GD_Img_Height ], ImgButWnd, NULL );
}

BOOL Img_HeightClicked( void )
{
}

BOOL Img_LabelClicked( void )
{
}

BOOL Img_YClicked( void )
{
}

BOOL Img_TxtClicked( void )
{
    ActivateGadget( ImgButGadgets[ GD_Img_X ], ImgButWnd, NULL );
}

BOOL Img_XClicked( void )
{
    ActivateGadget( ImgButGadgets[ GD_Img_Y ], ImgButWnd, NULL );
}

BOOL Img_GadRendKeyPressed( void )
{

    if( ImgButMsg.Code & 0x20 ) {

	if( List2Tag[1] < IE.NumImgs )
	    List2Tag[1] += 1;
	else
	    List2Tag[1] = 0;

    } else {

	if( List2Tag[1] )
	    List2Tag[1] -= 1;
	else
	    List2Tag[1] = IE.NumImgs;
    }

    ImgButMsg.Code = List2Tag[3] = List2Tag[1];

    GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_GadRend ], ImgButWnd,
			NULL, (struct TagItem *)List2Tag );

    Img_GadRendClicked();
}

BOOL Img_GadRendClicked( void )
{
    struct ImageNode   *img;
    int                 cnt;

    List2Tag[1] = List2Tag[3] = ImgButMsg.Code;

    if( ImgButMsg.Code ) {

	img = (struct ImageNode *)&IE.Img_List;
	for( cnt = 0; cnt <= ImgButMsg.Code; cnt++ )
	    img = img->in_Node.ln_Succ;

	((struct BooleanInfo *)buffer2)->b_GadgetRender = &img->in_Left;
	((struct BooleanInfo *)buffer2)->b_Flags |= GFLG_GADGIMAGE;
    } else {
	((struct BooleanInfo *)buffer2)->b_GadgetRender = NULL;
	((struct BooleanInfo *)buffer2)->b_Flags &= ~GFLG_GADGIMAGE;
    }
}

BOOL Img_SelRendKeyPressed( void )
{

    if( ImgButMsg.Code & 0x20 ) {

	if( List2Tag2[1] < IE.NumImgs )
	    List2Tag2[1] += 1;
	else
	    List2Tag2[1] = 0;

    } else {

	if( List2Tag2[1] )
	    List2Tag2[1] -= 1;
	else
	    List2Tag2[1] = IE.NumImgs;
    }

    ImgButMsg.Code = List2Tag2[3] = List2Tag2[1];

    GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_SelRend ], ImgButWnd,
			NULL, (struct TagItem *)List2Tag );

    Img_SelRendClicked();
}

BOOL Img_SelRendClicked( void )
{
    struct ImageNode   *img;
    int                 cnt;

    List2Tag2[1] = List2Tag2[3] = ImgButMsg.Code;

    if( ImgButMsg.Code ) {

	img = (struct ImageNode *)&IE.Img_List;
	for( cnt = 0; cnt <= ImgButMsg.Code; cnt++ )
	    img = img->in_Node.ln_Succ;

	((struct BooleanInfo *)buffer2)->b_SelectRender = &img->in_Left;
    } else {
	((struct BooleanInfo *)buffer2)->b_SelectRender = NULL;
    }
}

BOOL Img_HighKeyPressed( void )
{
    if( ImgButMsg.Code & 0x20 ) {

	if( MXTag[1] < 3 )
	    MXTag[1] += 1;
	else
	    MXTag[1] = 0;

    } else {

	if( MXTag[1] )
	    MXTag[1] -= 1;
	else
	    MXTag[1] = 3;

    }

    GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_High ], ImgButWnd,
			NULL, (struct TagItem *)MXTag );

    ImgButMsg.Code = MXTag[1];

    Img_HighClicked();
}

BOOL Img_HighClicked( void )
{
    MXTag[1] = ImgButMsg.Code;

    ((struct BooleanInfo *)buffer2)->b_Flags = (((struct BooleanInfo *)buffer2)->b_Flags & ( GFLG_GADGIMAGE | GFLG_DISABLED | GFLG_SELECTED ) | GadgetFlags[ ImgButMsg.Code ]);

    if( ImgButMsg.Code == 3 )
	Img_AttivaSelRend();
    else
	Img_DisattivaSelRend();
}

void Img_AttivaSelRend( void )
{
    DisableTag[1] = FALSE;
    GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_SelRend ], ImgButWnd,
			NULL, (struct TagItem *)DisableTag );
}

void Img_DisattivaSelRend( void )
{
    DisableTag[1] = TRUE;
    GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_SelRend ], ImgButWnd,
			NULL, (struct TagItem *)DisableTag );
}

BOOL Img_ChkTxtKeyPressed( void )
{
    CheckedTag[1] = ( ((struct BooleanInfo *)buffer2)->b_flags2 & B_TEXT ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_ChkTxt ], ImgButWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( Img_ChkTxtClicked() );
}

BOOL Img_ChkTxtClicked( void )
{
    ((struct BooleanInfo *)buffer2)->b_flags2 ^= B_TEXT;

    if( ((struct BooleanInfo *)buffer2)->b_flags2 & B_TEXT )
	Img_AttivaTesto();
    else
	Img_DisattivaTesto();
}

void Img_AttivaTesto( void )
{
    DisableTag[1] = FALSE;

    GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_Txt ], ImgButWnd,
			NULL, (struct TagItem *)DisableTag );
    GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_X ], ImgButWnd,
			NULL, (struct TagItem *)DisableTag );
    GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_Y ], ImgButWnd,
			NULL, (struct TagItem *)DisableTag );
    GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_Invers ], ImgButWnd,
			NULL, (struct TagItem *)DisableTag );
    GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_RPMode ], ImgButWnd,
			NULL, (struct TagItem *)DisableTag );
    GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_FP ], ImgButWnd,
			NULL, (struct TagItem *)DisableTag );
    GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_BP ], ImgButWnd,
			NULL, (struct TagItem *)DisableTag );
}

void Img_DisattivaTesto( void )
{
    DisableTag[1] = TRUE;

    GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_Txt ], ImgButWnd,
			NULL, (struct TagItem *)DisableTag );
    GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_X ], ImgButWnd,
			NULL, (struct TagItem *)DisableTag );
    GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_Y ], ImgButWnd,
			NULL, (struct TagItem *)DisableTag );
    GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_Invers ], ImgButWnd,
			NULL, (struct TagItem *)DisableTag );
    GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_RPMode ], ImgButWnd,
			NULL, (struct TagItem *)DisableTag );
    GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_FP ], ImgButWnd,
			NULL, (struct TagItem *)DisableTag );
    GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_BP ], ImgButWnd,
			NULL, (struct TagItem *)DisableTag );
}

BOOL Img_InversKeyPressed( void )
{
    CheckedTag[1] = ( ((struct BooleanInfo *)buffer2)->b_DrawMode & INVERSVID ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_Invers ], ImgButWnd,
			NULL, (struct TagItem *)CheckedTag );

    Img_InversClicked();
}

BOOL Img_InversClicked( void )
{
    ((struct BooleanInfo *)buffer2)->b_DrawMode ^= INVERSVID;
}

BOOL Img_ToggleKeyPressed( void )
{
    CheckedTag[1] = ( ((struct BooleanInfo *)buffer2)->b_Activation & GACT_TOGGLESELECT ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_Toggle ], ImgButWnd,
			NULL, (struct TagItem *)CheckedTag );

    Img_ToggleClicked();
}

BOOL Img_ToggleClicked( void )
{
    ((struct BooleanInfo *)buffer2)->b_Activation ^= GACT_TOGGLESELECT;
}

BOOL Img_ImmediateKeyPressed( void )
{
    CheckedTag[1] = ( ((struct BooleanInfo *)buffer2)->b_Activation & GACT_IMMEDIATE ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_Immediate ], ImgButWnd,
			NULL, (struct TagItem *)CheckedTag );

    Img_ImmediateClicked();
}

BOOL Img_ImmediateClicked( void )
{
    ((struct BooleanInfo *)buffer2)->b_Activation ^= GACT_IMMEDIATE;
}

BOOL Img_RelVerKeyPressed( void )
{
    CheckedTag[1] = ( ((struct BooleanInfo *)buffer2)->b_Activation & GACT_RELVERIFY ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_RelVer ], ImgButWnd,
			NULL, (struct TagItem *)CheckedTag );

    Img_RelVerClicked();
}

BOOL Img_RelVerClicked( void )
{
    ((struct BooleanInfo *)buffer2)->b_Activation ^= GACT_RELVERIFY;
}

BOOL Img_FollowKeyPressed( void )
{
    CheckedTag[1] = ( ((struct BooleanInfo *)buffer2)->b_Activation & GACT_FOLLOWMOUSE ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_Follow ], ImgButWnd,
			NULL, (struct TagItem *)CheckedTag );

    Img_FollowClicked();
}

BOOL Img_FollowClicked( void )
{
    ((struct BooleanInfo *)buffer2)->b_Activation ^= GACT_FOLLOWMOUSE;
}

BOOL Img_SelKeyPressed( void )
{
    CheckedTag[1] = ( ((struct BooleanInfo *)buffer2)->b_Flags & GFLG_SELECTED ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_Sel ], ImgButWnd,
			NULL, (struct TagItem *)CheckedTag );

    Img_SelClicked();
}

BOOL Img_SelClicked( void )
{
    ((struct BooleanInfo *)buffer2)->b_Flags ^= GFLG_SELECTED;
}

BOOL Img_DisabKeyPressed( void )
{
    CheckedTag[1] = ( ((struct BooleanInfo *)buffer2)->b_Flags & GFLG_DISABLED ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_Disab ], ImgButWnd,
			NULL, (struct TagItem *)CheckedTag );

    Img_DisabClicked();
}

BOOL Img_DisabClicked( void )
{
    ((struct BooleanInfo *)buffer2)->b_Flags ^= GFLG_DISABLED;
}

BOOL Img_RPModeKeyPressed( void )
{
    if( ImgButMsg.Code & 0x20 ) {

	if( CycleTag[1] < 2 )
	    CycleTag[1] += 1;
	else
	    CycleTag[1] = 0;

    } else {

	if( CycleTag[1] )
	    CycleTag[1] -= 1;
	else
	    CycleTag[1] = 2;

    }

    GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_RPMode ], ImgButWnd,
			NULL, (struct TagItem *)CycleTag );

    ImgButMsg.Code = CycleTag[1];

    Img_RPModeClicked();
}

BOOL Img_RPModeClicked( void )
{
    CycleTag[1] = ImgButMsg.Code;

    ((struct BooleanInfo *)buffer2)->b_DrawMode = ( ((struct BooleanInfo *)buffer2)->b_DrawMode & INVERSVID ) | DrawModes[ ImgButMsg.Code ];
}

BOOL Img_FPKeyPressed( void )
{
    if( ImgButMsg.Code & 0x20 ) {

	if( PaletteTag[1] < ( 1 << IE.ScreenData->Tags[ SCRDEPTH ]) - 1 )
	    PaletteTag[1] += 1;
	else
	    PaletteTag[1] = 0;

    } else {

	if( PaletteTag[1] )
	    PaletteTag[1] -= 1;
	else
	    PaletteTag[1] = ( 1 << IE.ScreenData->Tags[ SCRDEPTH ]) - 1;

    }

    GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_FP ], ImgButWnd,
			NULL, (struct TagItem *)PaletteTag );

    ImgButMsg.Code = PaletteTag[1];

    Img_FPClicked();
}

BOOL Img_FPClicked( void )
{
    PaletteTag[1] = ((struct BooleanInfo *)buffer2)->b_FrontPen = ImgButMsg.Code;
}

BOOL Img_BPKeyPressed( void )
{
    if( ImgButMsg.Code & 0x20 ) {

	if( PaletteTag2[1] < ( 1 << IE.ScreenData->Tags[ SCRDEPTH ]) - 1 )
	    PaletteTag2[1] += 1;
	else
	    PaletteTag2[1] = 0;

    } else {

	if( PaletteTag2[1] )
	    PaletteTag2[1] -= 1;
	else
	    PaletteTag2[1] = ( 1 << IE.ScreenData->Tags[ SCRDEPTH ]) - 1;

    }

    GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_BP ], ImgButWnd,
			NULL, (struct TagItem *)PaletteTag2 );

    ImgButMsg.Code = PaletteTag2[1];

    Img_BPClicked();
}

BOOL Img_BPClicked( void )
{
    PaletteTag2[1] = ((struct BooleanInfo *)buffer2)->b_BackPen = ImgButMsg.Code;
}

BOOL Img_SameKeyPressed( void )
{
    Img_SameClicked();
}

BOOL Img_SameClicked( void )
{
    if( ((struct BooleanInfo *)buffer2)->b_GadgetRender ) {

	IntegerTag[1] = ((struct BooleanInfo *)buffer2)->b_GadgetRender->Width;
	GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_Width ], ImgButWnd,
			    NULL, (struct TagItem *)IntegerTag );

	IntegerTag[1] = ((struct BooleanInfo *)buffer2)->b_GadgetRender->Height;
	GT_SetGadgetAttrsA( ImgButGadgets[ GD_Img_Height ], ImgButWnd,
			    NULL, (struct TagItem *)IntegerTag );
    }
}
///
/// Accoda Booleani
void AccodaBooleani( void )
{
    struct BooleanInfo *gad;
    struct WindowInfo  *wnd;

    NewList((struct List *)&TabOrder_List );

    for( wnd = IE.win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	if( wnd->wi_NumBools ) {

	    for(;;) {
		gad = wnd->wi_Gadgets.mlh_Head;
		while(( gad->b_Node.ln_Succ ) && ( gad->b_Kind != BOOLEAN ))
		    gad = gad->b_Node.ln_Succ;

		if( gad->b_Node.ln_Succ ) {
		    Remove((struct Node *)gad );
		    AddTail((struct List *)&TabOrder_List, (struct Node *)gad );
		} else
		    break;
	    }

	    while( gad = RemHead((struct List *)&TabOrder_List ))
		AddTail((struct List *)&wnd->wi_Gadgets, (struct Node *)gad );
	}
    }
}
///
/// SistemaNextBool
void SistemaNextBool( void )
{
    struct BooleanInfo     *gad, *gad2;

    if( IE.win_info->wi_NumBools ) {

	gad = IE.win_info->wi_Gadgets.mlh_Head;
	while( gad->b_Kind != BOOLEAN )
	    gad = gad->b_Node.ln_Succ;

	for( gad2 = gad->b_Node.ln_Succ; gad2->b_Node.ln_Succ; gad2 = gad2->b_Node.ln_Succ ) {
	    if( gad2->b_Kind == BOOLEAN ) {
		gad->b_NextGadget = &gad2->b_NextGadget;
		gad  = gad2;
	    }
	}

	gad = IE.win_info->wi_Gadgets.mlh_TailPred;
	while( gad->b_Kind != BOOLEAN )
	    gad = gad->b_Node.ln_Pred;
	gad->b_NextGadget = IE.win_info->wi_GList;
    }
}
///

//          Banchi di gadget
/// Crea
BOOL MakeGBankMenued( void )
{
    struct GadgetBank  *bank;

    if( TestAttivi() ) {
	if( bank = AllocObject( IE_GADGETBANK )) {
	    struct GadgetInfo  *gad;

	    bank->Node.ln_Type |= GB_ATTACHED;

	    EditGBank( bank );

	    if(!( RetCode )) {
		FreeObject( bank, IE_GADGETBANK );
		Stat( CatCompArray[ MSG_ABORTED ].cca_Str, FALSE, 0 );
		return( TRUE );
	    }

	    AddTail(( struct List * )&IE.win_info->wi_GBanks, ( struct Node * )bank );

	    IE.win_info->wi_NumGBanks += 1;

	    for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ )
		if( gad->g_flags2 & G_ATTIVO ) {
		    struct BGadget *bg;

		    if( bg = AllocObject( IE_BGADGET )) {
			bg->Gadget = gad;
			AddTail((struct List *)&bank->Gadgets, (struct Node *)bg );
		    }
		}

		IE.flags &= ~SALVATO;

	} else
	    Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, 0 );
    }

    return( TRUE );
}
///
/// Elimina
BOOL DelGBankMenued( void )
{
    struct GadgetBank  *bank;

    if( bank = GetGadgetBank() ) {
	struct GadgetInfo  *gad;
	struct BGadget     *bg;

	if(!( bank->Node.ln_Type & GB_ATTACHED ))
	    AddGBank( bank );

	for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ )
	    if( gad->g_flags2 & G_ATTIVO ) {
		gad->g_flags2 &= ~G_ATTIVO;
		gad->g_flags2 |=  G_WAS_ACTIVE;
	    }

	while( bg = RemTail(( struct List * )&bank->Gadgets )) {
	    bg->Gadget->g_flags2 |= G_ATTIVO;
	    FreeObject( bg, IE_BGADGET );
	}

	DelGadMenued();

	for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
	    gad->g_flags2 &= ~G_ATTIVO;
	    if( gad->g_flags2 & G_WAS_ACTIVE ) {
		gad->g_flags2 |=  G_ATTIVO;
		gad->g_flags2 &= ~G_WAS_ACTIVE;
	    }
	}

	Remove(( struct Node * )bank );

	FreeObject( bank, IE_GADGETBANK );

	IE.win_info->wi_NumGBanks -= 1;

	RinfrescaFinestra();

	IE.flags &= ~SALVATO;
    }

    return( TRUE );
}
///
/// Mostra
BOOL EditGBankMenued( void )
{
    struct GadgetBank  *bank;

    if( bank = GetGadgetBank() ) {

	if( bank != (struct GadgetBank *)&NoneNode ) {
	    if(!( bank->Node.ln_Type & GB_ATTACHED )) {
		AddGBank( bank );

		RifaiGadgets();
		RinfrescaFinestra();
	    }
	}
    }

    return( TRUE );
}
///
/// Nascondi
BOOL HideGBankMenued( void )
{
    struct GadgetBank  *bank;

    if( bank = GetGadgetBank() )
	if( bank != (struct GadgetBank *)&NoneNode ) {
	    if( bank->Node.ln_Type & GB_ATTACHED ) {

		RemGBank( bank );

		RifaiGadgets();
		RinfrescaFinestra();
	    }
	}

    return( TRUE );
}
///
/// Parametri
BOOL ParamGBankMenued( void )
{
    struct GadgetBank  *bank;

    if( bank = GetGadgetBank() )
	if( bank != (struct GadgetBank *)&NoneNode )
	    EditGBank( bank );

    return( TRUE );
}
///
/// EditGBank
void EditGBank( struct GadgetBank *bank )
{
    ULONG   ret;

    LockAllWindows();

    LayoutWindow( GBankParamWTags );
    ret = OpenGBankParamWindow();
    PostOpenWindow( GBankParamWTags );

    if( ret )
	DisplayBeep( Scr );
    else {

	StringTag[1] = bank->Label;
	GT_SetGadgetAttrsA( GBankParamGadgets[ GD_GB_Lab ], GBankParamWnd,
			    NULL, (struct TagItem *)StringTag );

	buffer = ( bank->Node.ln_Type & GB_ONOPEN ) ? FALSE : TRUE;
	GB_ShowOnOpenKeyPressed();

	RetCode = FALSE;

	while( ReqHandle( GBankParamWnd, HandleGBankParamIDCMP ));

	if( RetCode ) {

	    if( buffer )
		bank->Node.ln_Type |= GB_ONOPEN;
	    else
		bank->Node.ln_Type &= ~GB_ONOPEN;

	    strcpy( bank->Label, GetString( GBankParamGadgets[ GD_GB_Lab ] ));

	    IE.flags &= ~SALVATO;
	}
    }

    CloseGBankParamWindow();

    UnlockAllWindows();
}

BOOL GBankParamVanillaKey( void )
{
    switch( GBankParamMsg.Code ) {
	case    13:
	    return( GB_OkClicked() );
	case    27:
	    return( GB_AnnullaClicked() );
    }

    return( TRUE );
}

BOOL GB_OkKeyPressed( void )
{
    return( GB_OkClicked() );
}

BOOL GB_AnnullaKeyPressed( void )
{
    return( GB_AnnullaClicked() );
}

BOOL GB_OkClicked( void )
{
    RetCode = TRUE;

    return( FALSE );
}

BOOL GB_AnnullaClicked( void )
{
    return( FALSE );
}

BOOL GB_ShowOnOpenKeyPressed( void )
{
    CheckedTag[1] = buffer ? FALSE : TRUE;

    GT_SetGadgetAttrsA( GBankParamGadgets[ GD_GB_ShowOnOpen ], GBankParamWnd,
			NULL, (struct TagItem *)CheckedTag );

    return( GB_ShowOnOpenClicked() );
}

BOOL GB_ShowOnOpenClicked( void )
{
    buffer = buffer ? FALSE : TRUE;

    return( TRUE );
}

BOOL GB_LabClicked( void )
{
    return( TRUE );
}
///
/// GetGadgetBank
struct GadgetBank *GetGadgetBank( void )
{
    struct GadgetBank  *bank = NULL;

    AddHead(( struct List * )&IE.win_info->wi_GBanks, &NoneNode );

    if( ApriListaFin( CatCompArray[ REQ_GETGADGETBANK ].cca_Str, 0, &IE.win_info->wi_GBanks )) {
	int                 num;
	struct GadgetBank  *b;

	num = 0;
	b   = IE.win_info->wi_GBanks.mlh_Head;
	while( b->Node.ln_Succ ) {
	    num += 1;
	    b = b->Node.ln_Succ;
	}

	num = GestisciListaFin( EXIT, num );
	ChiudiListaFin();

	if( num >= 0 ) {
	    ULONG   cnt;

	    bank = (struct GadgetBank *)&IE.win_info->wi_GBanks.mlh_Head;
	    for( cnt = 0; cnt <= num; cnt++ )
		bank = bank->Node.ln_Succ;
	}
    }

    RemHead(( struct List * )&IE.win_info->wi_GBanks );

    return( bank );
}
///
/// RemGBank
void RemGBank( struct GadgetBank *bank )
{
    struct BGadget *bg;

    if(!( IE.win_info ))
	return;

    bank->Count = 0;

    for( bg = (struct BGadget *)bank->Gadgets.mlh_Head; bg->Succ; bg = bg->Succ ) {
	struct GadgetInfo  *gad;
	BOOL                ok = FALSE;

	/* check if the gadget still exists */
	for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ )
	    if( gad == bg->Gadget ) {
		ok = TRUE;
		break;
	    }

	if( ok ) {
	    Remove(( struct Node * )bg->Gadget );
	    AddTail(( struct List * )&bank->Storage, ( struct Node * )bg->Gadget );
	    bank->Count += 1;

	    if( bg->Gadget->g_Kind < BOOLEAN )
		IE.win_info->wi_NumGads -= 1;
	    else if( bg->Gadget->g_Kind == BOOLEAN )
		IE.win_info->wi_NumBools -= 1;
	    else
		IE.win_info->wi_NumObjects -= 1;

	} else {
	    struct BGadget *prev;

	    prev = bg->Pred;

	    Remove(( struct Node * )bg );

	    FreeObject( bg, IE_BGADGET );

	    bg = prev;
	}
    }

    bank->Node.ln_Type &= ~GB_ATTACHED;
}
///
/// AddGBank
void AddGBank( struct GadgetBank *bank )
{
    struct GadgetInfo  *gad;

    while( gad = RemHead(( struct List * )&bank->Storage )) {
	AddTail(( struct List * )&IE.win_info->wi_Gadgets, ( struct Node * )gad );

	if( gad->g_Kind < BOOLEAN )
	    IE.win_info->wi_NumGads += 1;
	else if( gad->g_Kind == BOOLEAN )
	    IE.win_info->wi_NumBools += 1;
	else
	    IE.win_info->wi_NumObjects += 1;
    }

    bank->Node.ln_Type |= GB_ATTACHED;
}
///
/// DetacheGBanks
void DetacheGBanks( void )
{
    struct WindowInfo  *BackUp, *wnd;

    BackUp = IE.win_info;

    for( wnd = IE.win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	struct GadgetBank *bank;

	IE.win_info = wnd;

	for( bank = wnd->wi_GBanks.mlh_Head; bank->Node.ln_Succ; bank = bank->Node.ln_Succ ) {
	    if( bank->Node.ln_Type & GB_ATTACHED ) {
		RemGBank( bank );
		bank->Node.ln_Type |= GB_REATTACH;
	    }

	    SistemaGadgetsFlags( &bank->Storage );
	}

	SistemaGadgetsFlags( &wnd->wi_Gadgets );
    }

    IE.win_info = BackUp;
}
///
/// ReAttachGBanks
void ReAttachGBanks( void )
{
    struct WindowInfo  *BackUp, *wnd;

    BackUp = IE.win_info;

    for( wnd = IE.win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	struct GadgetBank *bank;

	IE.win_info = wnd;

	for( bank = wnd->wi_GBanks.mlh_Head; bank->Node.ln_Succ; bank = bank->Node.ln_Succ )
	    if( bank->Node.ln_Type & GB_REATTACH ) {
		AddGBank( bank );
		bank->Node.ln_Type &= ~GB_REATTACH;
	    }
    }

    IE.win_info = BackUp;
}
///
/// EliminaGBanks
void EliminaGBanks( struct WindowInfo *wnd )
{
    struct GadgetBank  *bank;

    while( bank = RemTail(( struct List * )&wnd->wi_GBanks )) {
	struct GadgetInfo  *gad;

	RemGBank( bank );

	while( gad = RemTail(( struct List * )&bank->Storage ))
	    AddTail(( struct List * )&wnd->wi_Gadgets, ( struct Node * )gad );

	FreeObject( bank, IE_GADGETBANK );
    }
}
///
