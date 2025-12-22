/// Include
#include <stdarg.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>


#define INTUI_V36_NAMES_ONLY
#define CATCOMP_NUMBERS

#include <exec/nodes.h>                 // exec
#include <exec/lists.h>
#include <exec/memory.h>
#include <exec/types.h>
#include <dos/dos.h>                    // dos
#include <workbench/workbench.h>        // workbench
#include <workbench/icon.h>
#include <libraries/gadtools.h>         // libraries
#include <libraries/reqtools.h>
#include <libraries/locale.h>
#include <clib/exec_protos.h>           // protos
#include <clib/intuition_protos.h>
#include <clib/dos_protos.h>
#include <clib/locale_protos.h>
#include <clib/icon_protos.h>
#include <clib/reqtools_protos.h>
#include <pragmas/exec_pragmas.h>       // pragmas
#include <pragmas/intuition_pragmas.h>
#include <pragmas/graphics_pragmas.h>
#include <pragmas/dos_pragmas.h>
#include <pragmas/locale_pragmas.h>
#include <pragmas/icon_pragmas.h>
#include <pragmas/reqtools_pragmas.h>


#include "DEV_IE:defs.h"
#include "DEV_IE:Include/loaderlib.h"
#include "DEV_IE:Include/loader_pragmas.h"
#include "DEV_IE:Include/expander_pragmas.h"
#include "DEV_IE:GUI.h"
#include "DEV_IE:GUI_locale.h"
///
/// Prototipi
static void     PutString2( STRPTR );
static void     WriteMainProc( void );
static void     WriteARexx( void );
static void     WriteMenus( struct WindowInfo * );
static void     SistemaImg( void );
static void     WriteImg( void );
static void     WriteITexts( struct WindowInfo * );
static void     WriteImages( struct WindowInfo * );
static void     WriteBoxes( struct WindowInfo * );
static struct WindowInfo *LoadWin( void );
static void     WriteWin( struct WindowInfo * );
static void     WriteGad( struct GadgetInfo * );
static void     WriteBool( struct BooleanInfo * );
static void     WriteLocaleStuff( void );
///
/// Dati
UBYTE   RawDataPattern[]    = "#?.gui";
UBYTE   FinestraPattern[]   = "#?.wnd";
UBYTE   GadgetPattern[]     = "#?.gad";

UBYTE   GUI_ext[]           = "gui";
UBYTE   WND_ext[]           = "wnd";
UBYTE   GAD_ext[]           = "gad";

struct Library     *LoaderBase;
///
/// Icona progetto
UWORD gr_data[] = {

	/* plane 0 */

	0x0000, 0x0000, 0x0000, 0x0000, 0x0010, 
	0x0000, 0x0000, 0x0000, 0x0000, 0x0030, 
	0x0000, 0x0000, 0x0003, 0x0030, 0x0030, 
	0x0000, 0x0000, 0x0002, 0x8030, 0x0030, 
	0x0000, 0x0000, 0x0003, 0x4030, 0x0030, 
	0x03ff, 0xffff, 0xffe2, 0xa030, 0x0030, 
	0x03aa, 0xaaaa, 0xaae3, 0x5031, 0xfc30, 
	0x0200, 0x0000, 0x0062, 0xa831, 0x8030, 
	0x0200, 0x0000, 0x0063, 0x5401, 0xe030, 
	0x0200, 0x0000, 0x0062, 0xaa01, 0x8030, 
	0x0200, 0x0155, 0x4063, 0x7501, 0x8030, 
	0x0200, 0x2100, 0x0062, 0xaa81, 0xfc30, 
	0x0200, 0x2100, 0x0063, 0x6540, 0x0030, 
	0x0200, 0x2100, 0x0062, 0xa2a0, 0x0030, 
	0x0200, 0x2100, 0x4063, 0x6150, 0x0030, 
	0x0200, 0x2100, 0x4062, 0xa0a8, 0x0030, 
	0x0255, 0x6001, 0xf063, 0x6054, 0x0030, 
	0x0200, 0x0000, 0x4062, 0xa02a, 0x0030, 
	0x0200, 0x0000, 0x4063, 0x6015, 0x0030, 
	0x0200, 0x0000, 0x0062, 0xbffa, 0x8030, 
	0x02aa, 0xaaaa, 0xaaa3, 0x5555, 0x4030, 
	0x0000, 0x0000, 0x0002, 0xaaaa, 0xa030, 
	0x0000, 0x0000, 0x0003, 0xffff, 0xf030, 
	0x0000, 0x0000, 0x0000, 0x0000, 0x0030, 
	0x7fff, 0xffff, 0xffff, 0xffff, 0xfff0, 

	/* plane 1 */

	0xffff, 0xffff, 0xffff, 0xffff, 0xffe0, 
	0xeaaa, 0xaaaa, 0xaaaa, 0xaaaa, 0xaa80, 
	0xeaaa, 0xaaaa, 0xaaa8, 0xaa8a, 0xaa80, 
	0xeaaa, 0xaaaa, 0xaaa8, 0x2a8a, 0xaa80, 
	0xeaaa, 0xaaaa, 0xaaa8, 0xaa8a, 0xaa80, 
	0xeaff, 0xffff, 0xffe8, 0x0a8a, 0xaa80, 
	0xeaaa, 0xaaaa, 0xaae8, 0xaa8b, 0xfe80, 
	0xea00, 0x0000, 0x0068, 0x028b, 0xaa80, 
	0xea00, 0x0000, 0x0068, 0xaaab, 0xea80, 
	0xea00, 0x0000, 0x0068, 0x00ab, 0xaa80, 
	0xea55, 0x4000, 0x0068, 0x8aab, 0xaa80, 
	0xea40, 0x0000, 0x4068, 0x002b, 0xfe80, 
	0xea40, 0x0000, 0x4068, 0x8aaa, 0xaa80, 
	0xea40, 0x0000, 0x4068, 0x080a, 0xaa80, 
	0xea40, 0x0000, 0x0068, 0x8aaa, 0xaa80, 
	0xea40, 0x0000, 0x0068, 0x0a02, 0xaa80, 
	0xea00, 0x0154, 0x0068, 0x8aaa, 0xaa80, 
	0xea00, 0x0000, 0x0068, 0x0a80, 0xaa80, 
	0xea00, 0x0000, 0x0068, 0x8aaa, 0xaa80, 
	0xea00, 0x0000, 0x0068, 0x0000, 0x2a80, 
	0xe800, 0x0000, 0x0028, 0xaaaa, 0xaa80, 
	0xeaaa, 0xaaaa, 0xaaa8, 0x0000, 0x0a80, 
	0xeaaa, 0xaaaa, 0xaaa8, 0x0000, 0x0a80, 
	0xeaaa, 0xaaaa, 0xaaaa, 0xaaaa, 0xaa80, 
	0x8000, 0x0000, 0x0000, 0x0000, 0x0000, 
};

struct Image gr = {
	0,      /* LeftEdge */
	0,      /* TopEdge */
	76,     /* Width */
	25,     /* Height */
	2,      /* Depth */
	gr_data,        /* ImageData */
	3,      /* PlanePick */
	0,      /* PlaneOnOff */
	NULL,   /* NextImage */
};

UWORD sr_data[] = {

	/* plane 0 */

	0x0000, 0x0000, 0x0000, 0x0000, 0x0010, 
	0x0000, 0x0000, 0x0000, 0x0000, 0x0030, 
	0x0000, 0x0000, 0x0003, 0x0030, 0x0030, 
	0x0000, 0x0000, 0x0002, 0x8030, 0x0030, 
	0x0000, 0x0000, 0x0003, 0x4030, 0x0030, 
	0x03ff, 0xffff, 0xffe2, 0xa030, 0x0030, 
	0x03aa, 0xaaaa, 0xaae3, 0x5031, 0xfc30, 
	0x0200, 0x0000, 0x0062, 0xa831, 0x8030, 
	0x0200, 0x0000, 0x0063, 0x5401, 0xe030, 
	0x0200, 0x0000, 0x0062, 0xaa01, 0x8030, 
	0x0200, 0x0155, 0x4063, 0x7501, 0x8030, 
	0x0200, 0x2100, 0x0062, 0xaa81, 0xfc30, 
	0x0200, 0x2100, 0x0063, 0x6540, 0x0030, 
	0x0200, 0x2100, 0x0062, 0xa2a0, 0x0030, 
	0x0200, 0x2100, 0x4063, 0x6150, 0x0030, 
	0x0200, 0x2100, 0x4062, 0xa0a8, 0x0030, 
	0x0255, 0x6001, 0xf063, 0x6054, 0x0030, 
	0x0200, 0x0000, 0x4062, 0xa02a, 0x0030, 
	0x0200, 0x0000, 0x4063, 0x6015, 0x0030, 
	0x0200, 0x0000, 0x0062, 0xbffa, 0x8030, 
	0x02aa, 0xaaaa, 0xaaa3, 0x5555, 0x4030, 
	0x0000, 0x0000, 0x0002, 0xaaaa, 0xa030, 
	0x0000, 0x0000, 0x0003, 0xffff, 0xf030, 
	0x0000, 0x0000, 0x0000, 0x0000, 0x0030, 
	0x7fff, 0xffff, 0xffff, 0xffff, 0xfff0, 

	/* plane 1 */

	0xffff, 0xffff, 0xffff, 0xffff, 0xffe0, 
	0xeaaa, 0xaaaa, 0xaaaa, 0xaaaa, 0xaa80, 
	0xeaaa, 0xaaaa, 0xaaa8, 0xaaba, 0xaa80, 
	0xeaaa, 0xaaaa, 0xaaa8, 0x2aba, 0xaa80, 
	0xeaaa, 0xaaaa, 0xaaa8, 0xaaba, 0xaa80, 
	0xeaff, 0xffff, 0xffe8, 0x0aba, 0xaa80, 
	0xeaaa, 0xaaaa, 0xaae8, 0xaaba, 0x0280, 
	0xea00, 0x0000, 0x0068, 0x02ba, 0x2a80, 
	0xea00, 0x0000, 0x0068, 0xaaaa, 0x0a80, 
	0xea00, 0x0000, 0x0068, 0x00aa, 0x2a80, 
	0xea55, 0x4000, 0x0068, 0x8aaa, 0x2a80, 
	0xea40, 0x0000, 0x4068, 0x002a, 0x0280, 
	0xea40, 0x0000, 0x4068, 0x8aaa, 0xaa80, 
	0xea40, 0x0000, 0x4068, 0x080a, 0xaa80, 
	0xea40, 0x0000, 0x0068, 0x8aaa, 0xaa80, 
	0xea40, 0x0000, 0x0068, 0x0a02, 0xaa80, 
	0xea00, 0x0154, 0x0068, 0x8aaa, 0xaa80, 
	0xea00, 0x0000, 0x0068, 0x0a80, 0xaa80, 
	0xea00, 0x0000, 0x0068, 0x8aaa, 0xaa80, 
	0xea00, 0x0000, 0x0068, 0x0000, 0x2a80, 
	0xe800, 0x0000, 0x0028, 0xaaaa, 0xaa80, 
	0xeaaa, 0xaaaa, 0xaaa8, 0x0000, 0x0a80, 
	0xeaaa, 0xaaaa, 0xaaa8, 0x0000, 0x0a80, 
	0xeaaa, 0xaaaa, 0xaaaa, 0xaaaa, 0xaa80, 
	0x8000, 0x0000, 0x0000, 0x0000, 0x0000, 
};

struct Image sr = {
	0,      /* LeftEdge */
	0,      /* TopEdge */
	76,     /* Width */
	25,     /* Height */
	2,      /* Depth */
	sr_data,        /* ImageData */
	3,      /* PlanePick */
	0,      /* PlaneOnOff */
	NULL,   /* NextImage */
};

char *tt[] = {
	"»»» InterfaceEditor - ©1994-96 Simone Tellini «««",
	NULL
};

struct DiskObject IconStruct = {
	WB_DISKMAGIC,   /* do_Magic */
	WB_DISKVERSION, /* do_Version */
	NULL,   /* do_Gadget.NextGadget */
	0,     /* do_Gadget.LeftEdge */
	0,     /* do_Gadget.TopEdge */
	76,     /* do_Gadget.Width */
	26,     /* do_Gadget.Height */
	6, 1, 1,
	(APTR)&gr,      /* do_Gadget.GadgetRender */
	(APTR)&sr,      /* do_Gadget.SelectRender */
	NULL,   /* do_Gadget.GadgetText */
	0,      /* do_Gadget.MutualExclude */
	NULL,   /* do_Gadget.SpecialInfo */
	0,      /* do_Gadget.GadgetID */
	(APTR)WB_DISKREVISION,  /* do_Gadget.UserData */
	WBPROJECT,      /* do_Type */
	&DefaultTool[0],   /* do_DefaultTool */
	&tt[0], /* do_ToolTypes */
	NO_ICON_POSITION,       /* do_CurrentX */
	NO_ICON_POSITION,       /* do_CurrentY */
	NULL,   /* do_DrawerData */
	NULL,   /* do_ToolWindow */
	8192,   /* do_StackSize */
};
///


/// Put string 2
void PutString2( STRPTR str )
{
    UWORD   len;

    len = strlen( str );

    FWrite( File, &len, 2, 1 );
    FWrite( File, str, len, 1 );

    if( len & 1 )
	FPutC( File, 0 );
}
///
/// Get e Put string
void FGetString( UBYTE *str )
{
    UBYTE   len;

    len = FGetC( File );

    FRead( File, str, len, 1 );

    str[ len ] = '\0';

    if(!( len & 1 ))
	FGetC( File );
}

void PutString( STRPTR str )
{
    UBYTE   len;

    len = strlen( str );

    FPutC( File, len );
    FWrite( File, str, len, 1 );

    if(!( len & 1 ))
	FPutC( File, 0 );
}
///
/// CountNodes
ULONG CountNodes( struct MinList *List )
{
    ULONG           cnt = 0;
    struct Node    *node;

    for( node = List->mlh_Head; node->ln_Succ; node = node->ln_Succ )
	++cnt;

    return( cnt );
}
///
/// AskFile
BOOL AskFile( STRPTR File )
{
    BOOL    ret = TRUE;
    BPTR    lock;

    if( lock = Lock( File, ACCESS_READ )) {
	ULONG   tags[] = { RT_ReqPos,       REQPOS_CENTERSCR,
			   RT_Underscore,   '_',
			   RT_Screen,       Scr,
			   TAG_DONE };

	UnLock( lock );

	ret = rtEZRequest( "%s alreay exists.\n"
			   "Overwrite?",
			   CatCompArray[ ANS_YES_NO ].cca_Str,
			   NULL, (struct TagItem *)tags,
			   FilePart( File )
			 );
    }

    return( ret );
}
///


/// Locale
void WriteLocale( void )
{
    PutString( IE.Locale->Catalog );
    PutString( IE.Locale->JoinFile );
    PutString( IE.Locale->BuiltIn );

    FWrite( File, &IE.Locale->Version, 4, 1 );
}
///
/// LocaleStuff
void WriteLocaleStuff( void )
{
    ULONG                       num;
    struct LocaleLanguage      *lang;
    struct LocaleStr           *str;

    num = CountNodes( &IE.Locale->Languages );

    FWrite( File, &num, 4, 1 );

    for( lang = IE.Locale->Languages.mlh_Head; lang->Node.ln_Succ; lang = lang->Node.ln_Succ ) {
	PutString( lang->Language );
	PutString( lang->File );
    }

    num = CountNodes( &IE.Locale->ExtraStrings );

    FWrite( File, &num, 4, 1 );

    for( str = IE.Locale->ExtraStrings.mlh_Head; str->Node.ln_Succ; str = str->Node.ln_Succ ) {
	struct LocaleTranslation   *tran;
	UWORD                       flags;

	flags = str->Node.ln_Pri;

	FWrite( File, &flags, 2, 1 );

	PutString2( str->Node.ln_Name );
	PutString( str->ID );

	num = CountNodes( &str->Translations );

	FWrite( File, &num, 4, 1 );

	for( tran = str->Translations.mlh_Head; tran->Node.ln_Succ; tran = tran->Node.ln_Succ ) {

	    PutString2( tran->String );

	    FPutC( File, tran->Node.ln_Type );
	    FPutC( File, 0 );
	}
    }
}
///

/// Main Proc
void WriteMainProc( void )
{
    UWORD   data;
    APTR    node;

    PutString( IE.ExtraProc );

    data = IE.MainProcFlags;

    FWrite( File, &data, 2, 1 );

    FWrite( File, &IE.NumLibs, 2 , 1 );

#define no ((struct LibNode *)node)

    for( no = IE.Libs_List.mlh_Head; no->lbn_Node.ln_Succ; no = no->lbn_Node.ln_Succ ){

	PutString( no->lbn_Name );
	PutString( no->lbn_Base );
	FWrite( File, &no->lbn_Version, 2, 1 );
	FWrite( File, &no->lbn_Node.ln_Type, 2, 1 );
    }

#undef  no

    FWrite( File, &IE.NumWndTO, 2 , 1 );

#define no ((struct WndToOpen *)node)

    for( no  = IE.WndTO_List.mlh_Head; no->wto_Node.ln_Succ; no = no->wto_Node.ln_Succ )
	PutString( no->wto_Label );

#undef no
}
///

/// ARexx
void WriteARexx( void )
{
    struct RexxNode *node;

    PutString( IE.RexxPortName );
    PutString( IE.RexxExt );

    FWrite( File, &IE.NumRexxs, 2, 1 );

    for( node = IE.Rexx_List.mlh_Head; node->rxn_Node.ln_Succ; node = node->rxn_Node.ln_Succ ) {

	PutString( node->rxn_Label );
	PutString( node->rxn_Name );
	PutString( node->rxn_Template );

    }
}
///

/// Menus
void WriteMenus( struct WindowInfo *wnd )
{
    struct MenuTitle   *title;
    struct _MenuItem   *item;
    struct MenuSub     *sub;
    WORD                num;

    for( title = wnd->wi_Menus.mlh_Head; title->mt_Node.ln_Succ; title = title->mt_Node.ln_Succ ) {

	FWrite( File, &title->mt_Flags, 4, 1 );  // Flags, Pad, NumItems

	PutString( title->mt_Text );
	PutString( title->mt_Label );

	for( item = title->mt_Items.mlh_Head; item->min_Node.ln_Succ; item = item->min_Node.ln_Succ ) {

	    FWrite( File, &item->min_Flags, 2, 1 );

	    PutString( item->min_Text );
	    PutString( item->min_CommKey );
	    PutString( item->min_Label );

	    if( item->min_Image ) {
		num = GetNodeNum( &IE.Img_List, (APTR)((ULONG)item->min_Image - 14 ));
	    } else {
		num = -1;
	    }

	    FWrite( File, &num, 2, 1 );
	    FWrite( File, &item->min_MutualExclude, 6, 1 ); // Mutual Exclude, NumSubs

	    for( sub = item->min_Subs.mlh_Head; sub->msn_Node.ln_Succ; sub = sub->msn_Node.ln_Succ) {

		FWrite( File, &sub->msn_Flags, 2, 1 );

		PutString( sub->msn_Text );
		PutString( sub->msn_CommKey );
		PutString( sub->msn_Label );

		if( sub->msn_Image ) {
		    num = GetNodeNum( &IE.Img_List, (APTR)((ULONG)sub->msn_Image - 14 ));
		} else {
		    num = -1;
		}

		FWrite( File, &num, 2, 1 );
		FWrite( File, &sub->msn_MutualExclude, 4, 1 );

	    }
	}
    }
}
///

/// SistemaImg
void SistemaImg( void )
{
    struct WindowInfo  *wnd;
    struct WndImages   *wimg;
    struct ImageNode   *img;
    UWORD               cnt;
    WORD                num;
    APTR                ptr;

    for( wnd = IE.win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {

	for( wimg = wnd->wi_Images.mlh_Head; wimg->wim_Next; wimg = wimg->wim_Next ) {

	    img = (struct ImageNode *)&IE.Img_List;
	    for( cnt = 0; cnt <= (LONG)wimg->wim_ImageNode; cnt++ )
		img = img->in_Node.ln_Succ;

	    wimg->wim_ImageNode = img;
	    memcpy( &img->in_Width, &wimg->wim_Width, 12 );

	}

	ptr = NULL;  // sistemo i ptr NextImage
	for( wimg = wnd->wi_Images.mlh_TailPred; wimg->wim_Prev; wimg = wimg->wim_Prev ) {
	    wimg->wim_NextImage = ptr;
	    ptr = &wimg->wim_Left;
	}

	// sistemo i booleani
	struct BooleanInfo *bool;
	for( bool = wnd->wi_Gadgets.mlh_Head; bool->b_Node.ln_Succ; bool = bool->b_Node.ln_Succ ) {
	    if( bool->b_Kind == BOOLEAN ) {

		num = (LONG)bool->b_GadgetRender;

		if( num >= 0 ) {

		    img = (struct ImageNode *)&IE.Img_List;
		    for( cnt = 0; cnt <= num; cnt++ )
			img = img->in_Node.ln_Succ;
		    bool->b_GadgetRender = &img->in_Left;

		} else {
		    bool->b_GadgetRender = NULL;
		}

		num = (LONG)bool->b_SelectRender;

		if( num >= 0 ) {

		    img = (struct ImageNode *)&IE.Img_List;
		    for( cnt = 0; cnt <= num; cnt++ )
			img = img->in_Node.ln_Succ;
		    bool->b_SelectRender = &img->in_Left;

		} else {
		    bool->b_SelectRender = NULL;
		}

	    }
	}

	// sistemo i menu

	struct MenuTitle *title;
	struct _MenuItem *item;
	struct MenuSub   *sub;
	for( title = wnd->wi_Menus.mlh_Head; title->mt_Node.ln_Succ; title = title->mt_Node.ln_Succ ) {
	    for( item = title->mt_Items.mlh_Head; item->min_Node.ln_Succ; item = item->min_Node.ln_Succ ) {

		num = (LONG)item->min_Image;

		if( num >= 0 ) {
		    img = (struct ImageNode *)&IE.Img_List;
		    for( cnt = 0; cnt <= num; cnt++ )
			img = img->in_Node.ln_Succ;
		    item->min_Image = &img->in_Left;
		} else {
		    item->min_Image = NULL;
		}

		for( sub = item->min_Subs.mlh_Head; sub->msn_Node.ln_Succ; sub = sub->msn_Node.ln_Succ ) {

		    num = (LONG)sub->msn_Image;

		    if( num >= 0 ) {
			img = (struct ImageNode *)&IE.Img_List;
			for( cnt = 0; cnt <= num; cnt++ )
			    img = img->in_Node.ln_Succ;
			sub->msn_Image = &img->in_Left;
		    } else {
			sub->msn_Image = NULL;
		    }
		}

	    }
	}
    }
}
///

/// Immagini
void WriteImg( void )
{
    struct ImageNode    *img;

    FWrite( File, &IE.NumImgs, 2, 1 );

    for( img = IE.Img_List.mlh_Head; img->in_Node.ln_Succ; img = img->in_Node.ln_Succ ){

	FWrite( File, &img->in_Width, 6, 1 ); // Width, Height, Depth
	FWrite( File, &img->in_Size, 4, 1 );
	FWrite( File, img->in_Data, img->in_Size, 1 );
	FWrite( File, &img->in_PlanePick, 2, 1 );

	PutString( img->in_Label );

    }
}
///

/// IntuiTexts
void WriteITexts( struct WindowInfo *wnd )
{
    struct ITextNode   *itn;
    WORD                more;

    FWrite( File, &wnd->wi_NumTexts, 2, 1 );

    for( itn = wnd->wi_ITexts.mlh_Head; itn->itn_Node.ln_Succ; itn = itn->itn_Node.ln_Succ ) {

	itn->itn_AdjustToWord = itn->itn_Node.ln_Type;
	FWrite( File, &itn->itn_FrontPen, 8, 1 );
	itn->itn_AdjustToWord = 0;

	PutString( itn->itn_Text );

	if( itn->itn_FontCopy )
	    more = TRUE;
	else
	    more = FALSE;

	FWrite( File, &more, 2, 1 );

	if( more ){

	    PutString( itn->itn_FontCopy->ta_Name );
	    FWrite( File, &itn->itn_FontCopy->ta_YSize, 4, 1 );

	}
    }
}
///

/// Immagini (nelle finestre)
void WriteImages( struct WindowInfo *wnd )
{
    struct WndImages   *img;
    UWORD               num;

    FWrite( File, &wnd->wi_NumImages, 2, 1 );

    for( img = wnd->wi_Images.mlh_Head; img->wim_Next; img = img->wim_Next ) {

	FWrite( File, &img->wim_Left, 4, 1 );
	num = GetNodeNum( &IE.Img_List, img->wim_ImageNode );
	FWrite( File, &num, 2, 1 );

    }
}
///

/// Bevel Box
void WriteBoxes( struct WindowInfo *wnd )
{
    struct BevelBoxNode *box;

    for( box = wnd->wi_Boxes.mlh_Head; box->bb_Next; box = box->bb_Next ) {

	FWrite( File, &box->bb_Left, 8, 1 );
	FWrite( File, &box->bb_Recessed, 4, 1 );
	FWrite( File, &box->bb_FrameType, 4, 1 );

    }
}
///

/// Finestre
void WriteWin( struct WindowInfo *wnd )
{
    FWrite( File, &wnd->wi_Top, 44, 1 );
    PutString( wnd->wi_Titolo );
    PutString( wnd->wi_TitoloSchermo );
    PutString( wnd->wi_Label );
}
///

/// Gadgets
void WriteGad( struct GadgetInfo *gad )
{
    struct GadgetScelta *gs;
    ULONG                data = 0;

    FWrite( File, &gad->g_Left, 8, 1 ); // g_Left-g_Height
    FWrite( File, &gad->g_Flags, 4, 1 );
    FWrite( File, &gad->g_Kind, 2, 1 );
    FWrite( File, &gad->g_Tags, 32, 1 );

    if( gad->g_flags2 & G_NO_TEMPLATE )
	data = 1;

    FWrite( File, &data, 4, 1 );

    if( gad->g_Font )
	FWrite( File, &gad->g_Font->txa_Size, 4, 1 );
    else
	FWrite( File, &data, 4, 1 );

    FWrite( File, &gad->g_NumScelte, 2, 1 );

    for( gs = gad->g_Scelte.mlh_Head; gs->gs_Node.ln_Succ; gs = gs->gs_Node.ln_Succ )
	PutString( gs->gs_Testo );

    if(( gad->g_Kind == STRING_KIND ) || ( gad->g_Kind == TEXT_KIND ))
	PutString( gad->g_ExtraMem );

    PutString( gad->g_Titolo );
    PutString( gad->g_Label );

    if( gad->g_Font )
	PutString( gad->g_Font->txa_FontName );
    else
	FWrite( File, &data, 2, 1 );
}
///

/// Booleani
void WriteBool( struct BooleanInfo *gad )
{
    WORD        num;
    ULONG       data = 0;

    FWrite( File, &gad->b_Left, 14, 1 );

    if( gad->b_GadgetRender )
	num = GetNodeNum( &IE.Img_List, (APTR)((ULONG)gad->b_GadgetRender - 14 ));
    else
	num = -1;

    FWrite( File, &num, 2, 1 );

    if( gad->b_SelectRender )
	num = GetNodeNum( &IE.Img_List, (APTR)((ULONG)gad->b_SelectRender - 14 ));
    else
	num = -1;

    FWrite( File, &num, 2, 1 );

    FWrite( File, &gad->b_FrontPen, 8, 1 );

    if( gad->b_flags2 & G_NO_TEMPLATE )
	data = 1;

    FWrite( File, &data, 4, 1 );

    if( gad->b_Font )
	FWrite( File, &gad->b_Font->txa_Size, 4, 1 );
    else
	FWrite( File, &data, 4, 1 );

    num = ( gad->b_flags2 & B_TEXT ) ? -1 : 0;
    FPutC( File, num );

    num = strlen( gad->b_Titolo );
    FPutC( File, num );
    FWrite( File, gad->b_Titolo, num, 1 );
    if( num & 1 )
	FPutC( File, 0 );

    PutString( gad->b_Label );

    FWrite( File, &data, 2, 1 );

    if( gad->b_Font )
	PutString( gad->b_Font->txa_FontName );
    else
	FWrite( File, &data, 2, 1 );
}
///


//      Salvataggio
/// Salva GUI
BOOL SalvaComeMenued( void )
{
    UBYTE   *ptr;

    if(!( GetFile2( TRUE, CatCompArray[ ASL_SAVE_GUI ].cca_Str, RawDataPattern,
		   ASL_SAVE_GUI, GUI_ext ))) {
	return( TRUE );
    }

    ptr = allpath;

    while( *ptr != '\0' )
	if( *ptr++ == '.' )
	    break;

    if( *ptr == '\0' )
	strcat( allpath, ".gui" );

    strcpy( save_file, allpath );

    return( SalvaMenued() );
}

BOOL SalvaMenued( void )
{
    struct WindowInfo  *wnd, *backwnd;
    struct GadgetInfo  *gad;
    UWORD               data2;

    if( IE.flags_2 & DEMO )
	return( TRUE );

    if(!( save_file[0] )) {
	SalvaComeMenued();
	return( TRUE );
    }

    Stat( CatCompArray[ MSG_SAVING ].cca_Str, FALSE, 0 );

    if(!( GetStrings() )) {
	Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, 0 );
	return( TRUE );
    }

    if(!( File = Open( save_file, MODE_NEWFILE ))) {
	Stat( CatCompArray[ ERR_IOERR ].cca_Str, TRUE, 0 );
	return( TRUE );
    }

    backwnd = IE.win_info;


    FWrite( File, DataHeader, 8, 1 );
    FWrite( File, &InterfHeader, 4, 1 );

    FPutC( File, IE.SrcFlags );

    if( IE.flags_2 & GENERASCR )
	FPutC( File, -1 );
    else
	FPutC( File, 0 );

    WriteScr();

    DetacheGBanks();
    GadgetsDown();

    FWrite( File, &IE.num_win, 2, 1 );

    for( wnd = IE.win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {

	WriteWin( wnd );

	data2 = wnd->wi_NumGads - wnd->wi_NumBools;

	FWrite( File, &data2, 2, 1 );

	for( gad = wnd->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
	    if( gad->g_Kind < BOOLEAN )
		WriteGad( gad );
	}

	FWrite( File, &wnd->wi_NumMenus, 2, 1 );
	if( wnd->wi_NumMenus )
	    WriteMenus( wnd );

	FWrite( File, &wnd->wi_NumBools, 2, 1 );
	for( gad = wnd->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
	    if( gad->g_Kind == BOOLEAN )
		WriteBool(( struct BooleanInfo *)gad );
	}

	FWrite( File, &wnd->wi_NumBoxes, 2, 1 );
	WriteBoxes( wnd );

	WriteImages( wnd );

	data2 = -1;
	FWrite( File, &data2, 2, 1 );

	WriteITexts( wnd );

	FWrite( File, &data2, 2, 1 );
	FWrite( File, &wnd->wi_NumObjects, 2, 1 );

	if( wnd->wi_NumObjects ) {

	    struct IEXNode *ex;

	    for( ex = IE.Expanders.mlh_Head; ex->Node.ln_Succ; ex = ex->Node.ln_Succ ) {
		UWORD   num = 0;

		for( gad = wnd->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ )
		    if( gad->g_Kind == ex->ID ) {
			if( gad->g_flags2 & G_ATTIVO )
			    gad->g_flags2 |= G_WAS_ACTIVE;
			else
			    gad->g_flags2 |= G_ATTIVO;
			num += 1;
		    }

		if( num ) {
		    FWrite( File, &num, 2, 1 );
		    PutString( ex->Base->Lib.lib_Node.ln_Name );

		    IEXBase = ex->Base;

		    IE.win_info = wnd;
		    IEX_Save( ex->ID, &IE, File );

		    FWrite( File, "IEXN", 4, 1 );   /* Next IEX */

		    for( gad = wnd->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ )
			if( gad->g_Kind == ex->ID )
			    if( gad->g_flags2 & G_WAS_ACTIVE )
				gad->g_flags2 &= ~G_WAS_ACTIVE;
			    else
				gad->g_flags2 &= ~G_ATTIVO;
		}
	    }
	}

	FWrite( File, &data2, 2, 1 );

	FWrite( File, &wnd->wi_NumGBanks, 2, 1 );

	{
	    struct GadgetBank  *bank;

	    for( bank = wnd->wi_GBanks.mlh_Head; bank->Node.ln_Succ; bank = bank->Node.ln_Succ ) {
		UWORD   gadtools = 0, bools = 0, ext = 0;

		PutString( bank->Label );

		for( gad = bank->Storage.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {

		    if( gad->g_Kind < BOOLEAN )
			gadtools += 1;
		    else {
			if( gad->g_Kind == BOOLEAN )
			    bools += 1;
			else
			    ext += 1;
		    }
		}

		FWrite( File, &gadtools, 2, 1 );
		for( gad = bank->Storage.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ )
		    if( gad->g_Kind < BOOLEAN )
			WriteGad( gad );

		FWrite( File, &bools, 2, 1 );
		for( gad = bank->Storage.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ )
		    if( gad->g_Kind == BOOLEAN )
			WriteBool(( struct BooleanInfo * )gad );

		FWrite( File, &ext, 2, 1 );
	    }
	}


	data2 = 0;
	FWrite( File, &data2, 2, 1 );
    }

    WriteImg();

    data2 = 0;

    FWrite( File, &data2, 2, 1 );
    WriteARexx();

    FWrite( File, &data2, 2, 1 );
    WriteMainProc();

    FWrite( File, &data2, 2, 1 );
    WriteLocale();

    PutString( IE.SharedPort );

    WriteLocaleStuff();

    Close( File );

    if( IE.mainprefs & CREAICONE )
	PutDiskObject( allpath, &IconStruct );

    IE.flags |= SALVATO;

    GadgetsUp();
    ReAttachGBanks();
    PutStrings();

    Stat( CatCompArray[ MSG_SAVED ].cca_Str, FALSE, 0 );

    IE.win_info = backwnd;

    return( TRUE );
}
///
/// Salva Finestra
BOOL SalvaWndMenued( void )
{
    if(!( GetFile2( TRUE, CatCompArray[ ASL_SAVE_WND ].cca_Str, FinestraPattern,
		   ASL_SAVE_WND, WND_ext )))
	return( TRUE );

    if(!( File = Open( allpath, MODE_NEWFILE ))) {
	Stat( CatCompArray[ ERR_IOERR ].cca_Str, TRUE, 0 );
	return( TRUE );
    }

    Stat( CatCompArray[ MSG_SAVING ].cca_Str, FALSE, 0 );

    FWrite( File, DataHeader, 8, 1 );
    FWrite( File, &FinestraHeader, 4, 1 );

    WriteWin( IE.win_info );

    Close( File );

    Stat( CatCompArray[ MSG_SAVED ].cca_Str, FALSE, 0 );
}
///
/// Salva Gadgets
BOOL SalvaGadMenued( void )
{
    struct GadgetInfo  *gad;
    UWORD               num;

    if(!( TestAttivi() ))
	return( TRUE );

    if(!( GetFile2( TRUE, CatCompArray[ ASL_SAVE_GAD ].cca_Str, GadgetPattern,
		   ASL_SAVE_GAD, GAD_ext )))
	return( TRUE );

    if(!( File = Open( allpath, MODE_NEWFILE ))) {
	Stat( CatCompArray[ ERR_IOERR ].cca_Str, TRUE, 0 );
	return( TRUE );
    }

    Stat( CatCompArray[ MSG_SAVING ].cca_Str, FALSE, 0 );

    FWrite( File, DataHeader, 8, 1 );
    FWrite( File, &GadgetHeader, 4, 1 );

    num = 0;
    for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
	if(( gad->g_flags2 & G_ATTIVO ) && ( gad->g_Kind < BOOLEAN ))
	    num += 1;
    }

    FWrite( File, &num, 2, 1 );

    GadgetsDown();

    for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
	if(( gad->g_flags2 & G_ATTIVO ) && ( gad->g_Kind < BOOLEAN ))
	    WriteGad( gad );
    }

    num = 0;
    for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
	if(( gad->g_flags2 & G_ATTIVO ) && ( gad->g_Kind == BOOLEAN ))
	    num += 1;
    }

    FWrite( File, &num, 2, 1 );

    for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ ) {
	if(( gad->g_flags2 & G_ATTIVO ) && ( gad->g_Kind == BOOLEAN ))
	    WriteBool(( struct BooleanInfo *)gad );
    }

    if( num ) {
	num = 0;
	FWrite( File, &num, 2, 1 );
    } else {
	WriteImg();
    }

    FWrite( File, &IE.win_info->wi_NumObjects, 2, 1 );

    if( IE.win_info->wi_NumObjects ) {
	struct IEXNode *ex;

	for( ex = IE.Expanders.mlh_Head; ex->Node.ln_Succ; ex = ex->Node.ln_Succ ) {
	    UWORD   num = 0;

	    for( gad = IE.win_info->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ )
		if( gad->g_Kind == ex->ID )
		    num += 1;

	    if( num ) {
		FWrite( File, &num, 2, 1 );
		PutString( ex->Base->Lib.lib_Node.ln_Name );

		IEXBase = ex->Base;
		IEX_Save( ex->ID, &IE, File );

		FWrite( File, "IEXN", 4, 1 );   /* Next IEX */
	    }
	}
    }

    GadgetsUp();

    Close( File );

    Stat( CatCompArray[ MSG_GAD_SAVED ].cca_Str, FALSE, 0 );

    return( TRUE );
}
///

//      Caricamento
/// Carica GUI
BOOL LoadGUIClicked( void )
{
    return( CaricaMenued() );
}

BOOL CaricaMenued( void )
{
    ULONG               ret, ret2 = 0L, cnt;
    struct LoaderNode  *loader;

    loader = Loaders.mlh_Head;

    if(!( loader->Node.ln_Succ ))
	return( TRUE );

    if(!( IE.flags & LOADGUI )) {
	if(!( GetFile2( FALSE, CatCompArray[ ASL_LOADGUI ].cca_Str, RawDataPattern,
		    ASL_LOADGUI, GUI_ext )))
	    return( TRUE );
	else {
	    if( IE.num_win ) {
		EliminaAllWndMenued();
		if( IE.num_win ) {
		    Stat( CatCompArray[ MSG_ABORTED ].cca_Str, FALSE, 0 );
		    return( TRUE );
		}
	    }
	}
    } else {
	IE.flags &= ~LOADGUI;
    }

    ClearGUI();

    Stat( CatCompArray[ MSG_LOADING ].cca_Str, FALSE, 0 );

    do {

	LoaderBase = loader->LoaderBase;

	if(!( ret = LoadGUI( &IE, allpath2 ))) {
	    UpdateScr();
	    IE.flags |= SALVATO;
	} else {
	    if( ret != LOADER_UNKNOWN ) {
		switch( ret ) {
		    case LOADER_IOERR:
			Stat( CatCompArray[ ERR_IOERR ].cca_Str, TRUE, 0 );
			break;

		    case LOADER_UNWELCOME:
			Stat( CatCompArray[ ERR_NOT_PROJECT ].cca_Str, TRUE, 0 );
			break;

		    case LOADER_WRONGVERSION:
			Stat( CatCompArray[ MSG_WRONG_VERSION ].cca_Str, TRUE, 0 );
			break;

		    case LOADER_NOTSUPPORTED:
			ret2 = ret;
			break;
		}
		return( TRUE );
	    }
	}

	loader = loader->Node.ln_Succ;

    } while(( ret == LOADER_UNKNOWN ) && ( loader->Node.ln_Succ ));

    if( ret != LOADER_OK ) {
	switch( ret2 ) {
	    case LOADER_NOTSUPPORTED:
		Stat( CatCompArray[ ERR_NOT_SUPPORTED ].cca_Str, TRUE, 0 );
		break;
	    default:
		Stat( CatCompArray[ ERR_DATA_FORMAT ].cca_Str, TRUE, 0 );
	}
	return( TRUE );
    }

    for( cnt = 0; cnt < ATTIVA_CARICATA_NUM; cnt++ )
	OnMenu( BackWnd, attivamenu_nuovawin[ cnt ] );

    strcpy( save_file, allpath2 );

    GadgetsUp();

    Stat( CatCompArray[ MSG_LOADED ].cca_Str, FALSE, 0 );

    if( IE.flags & NODISKFONT ) {
	IE.flags &= ~NODISKFONT;
	IERequest( CatCompArray[ MSG_NO_DISKFONT ].cca_Str, ok_txt, 0, 0 );
    }

    if( IE.flags & NO_IEX ) {
	IE.flags &= ~NO_IEX;
	IERequest( CatCompArray[ MSG_NO_IEX ].cca_Str, ok_txt, 0, 0 );
    }

    return( TRUE );
}
///
/// Carica Finestra
BOOL CaricaWndMenued( void )
{
    UWORD               cnt;
    ULONG               ret, ret2 = 0L;
    struct LoaderNode  *loader;

    loader = Loaders.mlh_Head;

    if(!( loader->Node.ln_Succ ))
	return( TRUE );

    if(!( GetFile2( FALSE, CatCompArray[ ASL_LOAD_WND ].cca_Str, FinestraPattern,
		    ASL_LOAD_WND, WND_ext ))) {
	return( TRUE );
    }

    Stat( CatCompArray[ MSG_LOADING ].cca_Str, FALSE, 0 );

    do {

	LoaderBase = loader->LoaderBase;

	if( ret = LoadWindows( &IE, allpath2 )) {
	    if( ret != LOADER_UNKNOWN ) {
		switch( ret ) {
		    case LOADER_IOERR:
			Stat( CatCompArray[ ERR_IOERR ].cca_Str, TRUE, 0 );
			break;

		    case LOADER_UNWELCOME:
			Stat( CatCompArray[ ERR_NOT_A_WND ].cca_Str, TRUE, 0 );
			break;

		    case LOADER_WRONGVERSION:
			Stat( CatCompArray[ MSG_WRONG_VERSION ].cca_Str, TRUE, 0 );
			break;

		    case LOADER_NOTSUPPORTED:
			ret2 = ret;
			break;
		}
		return( TRUE );
	    }
	}

	loader = loader->Node.ln_Succ;

    } while(( ret == LOADER_UNKNOWN ) && ( loader->Node.ln_Succ ));

    if( ret != LOADER_OK ) {
	if( ret2 == LOADER_NOTSUPPORTED )
	    Stat( CatCompArray[ ERR_NOT_SUPPORTED ].cca_Str, TRUE, 0 );
	else
	    Stat( CatCompArray[ ERR_DATA_FORMAT ].cca_Str, TRUE, 0 );
	return( TRUE );
    }

    if( IE.num_win == 1 ) {
	for( cnt = 0; cnt < ATTIVA_CARICATA_NUM; cnt++ )
	    OnMenu( BackWnd, attivamenu_nuovawin[ cnt ]);
    }

    Stat( CatCompArray[ MSG_WND_LOADED ].cca_Str, FALSE, 0 );

    return( TRUE );
}
///
/// Carica Gadgets
BOOL CaricaGadMenued( void )
{
    struct LoaderNode  *loader;
    ULONG               ret, ret2 = 0L;

    loader = Loaders.mlh_Head;

    if(!( loader->Node.ln_Succ ))
	return( TRUE );

    if(!( GetFile2( FALSE, CatCompArray[ ASL_LOAD_GAD ].cca_Str, GadgetPattern,
		    ASL_LOAD_GAD, GAD_ext ))) {
	return( TRUE );
    }

    Stat( CatCompArray[ MSG_LOADING ].cca_Str, FALSE, 0 );

    do {

	LoaderBase = loader->LoaderBase;

	if( ret = LoadGadgets( &IE, allpath2 )) {
	    if( ret != LOADER_UNKNOWN ) {
		switch( ret ) {
		    case LOADER_IOERR:
			Stat( CatCompArray[ ERR_IOERR ].cca_Str, TRUE, 0 );
			break;

		    case LOADER_UNWELCOME:
			Stat( CatCompArray[ ERR_NO_GADGETS ].cca_Str, TRUE, 0 );
			break;

		    case LOADER_WRONGVERSION:
			Stat( CatCompArray[ MSG_WRONG_VERSION ].cca_Str, TRUE, 0 );
			break;

		    case LOADER_NOTSUPPORTED:
			ret2 = ret;
			break;
		}
		return( TRUE );
	    }
	}

	loader = loader->Node.ln_Succ;

    } while(( ret == LOADER_UNKNOWN ) && ( loader->Node.ln_Succ ));

    if( ret != LOADER_OK ) {
	if( ret2 == LOADER_NOTSUPPORTED )
	    Stat( CatCompArray[ ERR_NOT_SUPPORTED ].cca_Str, TRUE, 0 );
	else
	    Stat( CatCompArray[ ERR_DATA_FORMAT ].cca_Str, TRUE, 0 );
	return( TRUE );
    }

    RifaiGadgets();
    RinfrescaFinestra();

    Stat( CatCompArray[ MSG_GAD_LOADED ].cca_Str, FALSE, 0 );

    if( IE.flags & NODISKFONT ) {
	IE.flags &= ~NODISKFONT;
	IERequest( CatCompArray[ MSG_NO_DISKFONT ].cca_Str, ok_txt, 0, 0 );
    }

    if( IE.flags & NO_IEX ) {
	IE.flags &= ~NO_IEX;
	IERequest( CatCompArray[ MSG_NO_IEX ].cca_Str, ok_txt,
		   0, 0 );
    }

    return( TRUE );
}
///
/// Carica Schermo
BOOL CaricaScrMenued( void )
{
    struct LoaderNode  *loader;
    ULONG               ret, ret2 = 0L;

    loader = Loaders.mlh_Head;

    if(!( loader->Node.ln_Succ ))
	return( TRUE );

    if (!( GetFile2( FALSE, CatCompArray[ ASL_LOAD_SCR ].cca_Str, ScrPattern, ASL_LOAD_SCR, "scr" )))
	return( TRUE );

    Stat( CatCompArray[ MSG_LOADING ].cca_Str, FALSE, 0 );

    do {

	LoaderBase = loader->LoaderBase;

	if( ret = LoadScreen( &IE, allpath )) {
	    if( ret != LOADER_UNKNOWN ) {
		switch( ret ) {
		    case LOADER_IOERR:
			Stat( CatCompArray[ ERR_IOERR ].cca_Str, TRUE, 0 );
			break;

		    case LOADER_UNWELCOME:
			Stat( CatCompArray[ ERR_NO_SCR ].cca_Str, TRUE, 0 );
			break;

		    case LOADER_WRONGVERSION:
			Stat( CatCompArray[ MSG_WRONG_VERSION ].cca_Str, TRUE, 0 );
			break;

		    case LOADER_NOTSUPPORTED:
			ret2 = ret;
			break;
		}
		return( TRUE );
	    }
	}

	loader = loader->Node.ln_Succ;

    } while(( ret == LOADER_UNKNOWN ) && ( loader->Node.ln_Succ ));

    if( ret != LOADER_OK ) {
	if( ret2 == LOADER_NOTSUPPORTED )
	    Stat( CatCompArray[ ERR_NOT_SUPPORTED ].cca_Str, TRUE, 0 );
	else
	    Stat( CatCompArray[ ERR_DATA_FORMAT ].cca_Str, TRUE, 0 );
	return( TRUE );
    }

    UpdateScr();

    return( TRUE );
}
///
