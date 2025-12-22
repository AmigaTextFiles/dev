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
#include <intuition/intuition.h>        // intuition
#include <intuition/screens.h>
#include <intuition/sghooks.h>
#include <intuition/gadgetclass.h>
#include <dos/dos.h>                    // dos
#include <dos/rdargs.h>
#include <rexx/rexxio.h>                // rexx
#include <rexx/errors.h>
#include <rexx/storage.h>
#include <libraries/gadtools.h>         // libraries
#include <libraries/asl.h>
#include <libraries/reqtools.h>
#include <libraries/locale.h>
#include <clib/exec_protos.h>           // protos
#include <clib/dos_protos.h>
#include <clib/rexxsyslib_protos.h>
#include <clib/locale_protos.h>
#include <clib/asl_protos.h>
#include <clib/reqtools_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/alib_protos.h>
#include <pragmas/exec_pragmas.h>       // pragmas
#include <pragmas/intuition_pragmas.h>
#include <pragmas/dos_pragmas.h>
#include <pragmas/locale_pragmas.h>
#include <pragmas/asl_pragmas.h>
#include <pragmas/reqtools_pragmas.h>
#include <pragmas/gadtools_pragmas.h>
#include <pragmas/rexxsyslib_pragmas.h>


#include "DEV_IE:defs.h"
#include "DEV_IE:GUI.h"
#include "DEV_IE:GUI_locale.h"
///
/// Prototypes
static struct WindowInfo   *GimmeWnd( ULONG * );
static BOOL                 ActivateWnd( ULONG * );
///
/// Data
static UBYTE stem_ScreenTitle[] = ".SCREENTITLE";
static UBYTE stem_Title[]       = ".TITLE";
static UBYTE stem_Label[]       = ".LABEL";
static UBYTE stem_TopEdge[]     = ".TOPEDGE";
static UBYTE stem_LeftEdge[]    = ".LEFTEDGE";
static UBYTE stem_Width[]       = ".WIDTH";
static UBYTE stem_Height[]      = ".HEIGHT";
static UBYTE stem_MinWidth[]    = ".MINWIDTH";
static UBYTE stem_MinHeight[]   = ".MINHEIGHT";
static UBYTE stem_MaxWidth[]    = ".MAXWIDTH";
static UBYTE stem_MaxHeight[]   = ".MAXHEIGHT";
static UBYTE stem_InnerWidth[]  = ".INNERWIDTH";
static UBYTE stem_InnerHeight[] = ".INNERHEIGHT";
static UBYTE stem_MouseQueue[]  = ".MOUSEQUEUE";
static UBYTE stem_RptQueue[]    = ".RPTQUEUE";
static UBYTE stem_ZLeft[]       = ".ZOOMLEFT";
static UBYTE stem_ZTop[]        = ".ZOOMTOP";
static UBYTE stem_ZWidth[]      = ".ZOOMWIDTH";
static UBYTE stem_ZHeight[]     = ".ZOOMHEIGHT";
static UBYTE stem_NumGads[]     = ".NUMGADS";
static UBYTE stem_NumMenus[]    = ".NUMMENUS";
static UBYTE stem_NumBoxes[]    = ".NUMBOXES";
static UBYTE stem_NumTexts[]    = ".NUMTEXTS";
static UBYTE stem_NumBools[]    = ".NUMBOOLS";
static UBYTE stem_NumImages[]   = ".NUMIMAGES";
static UBYTE stem_IDCMP[]       = ".IDCMP";
static UBYTE stem_Tags[]        = ".TAGS";
static UBYTE stem_Depth[]       = ".DEPTH";
static UBYTE stem_PlanePick[]   = ".PLANEPICK";
static UBYTE stem_PlaneOnOff[]  = ".PLANEONOFF";
static UBYTE stem_FrontPen[]    = ".FRONTPEN";
static UBYTE stem_BackPen[]     = ".BACKPEN";
static UBYTE stem_DrawMode[]    = ".DRAWMODE";
static UBYTE stem_Font[]        = ".FONT";
static UBYTE stem_Text[]        = ".TEXT";
static UBYTE stem_Type[]        = ".TYPE";
static UBYTE stem_Recessed[]    = ".RECESSED";
static UBYTE stem_Name[]        = ".NAME";
static UBYTE stem_Style[]       = ".STYLE";
static UBYTE stem_Flags[]       = ".FLAGS";
static UBYTE stem_YSize[]       = ".YSIZE";

static UBYTE ld_fmt[]           = "%ld";
///


// Support Routines
/// GimmeWnd
struct WindowInfo *GimmeWnd( ULONG *Cnt )
{
    struct WindowInfo  *wnd;
    UWORD               c;

    if( Cnt ) {
	if( *Cnt <= IE.num_win ) {

	    wnd = (struct WindowInfo *)&IE.win_list;
	    for( c = 0; c < *Cnt; c++ )
		wnd = wnd->wi_succ;

	    return( wnd );

	}
    } else {
	return( IE.win_info );
    }

    return( NULL );
}
///
/// ActivateWnd
BOOL ActivateWnd( ULONG *Cnt )
{
    BOOL                ret = TRUE;
    struct WindowInfo  *wnd;

    if( wnd = GimmeWnd( Cnt )) {
	if( wnd->wi_flags1 & W_APERTA ) {

	    ActivateWindow( wnd->wi_winptr );

	    IE.win_active = wnd->wi_winptr;
	    IE.win_info   = wnd;
	} else {
	    ret = FALSE;
	}
    } else {
	ret = FALSE;
    }

    return( ret );
}
///


//      A
/// AddBox
LONG AddBoxRexxed( ULONG *ArgArray, struct RexxMsg *Msg )
{
    struct WindowInfo      *wnd;
    UBYTE                   buffer[12];
    struct BevelBoxNode    *box;

    if(!( wnd = GimmeWnd(( ULONG * )ArgArray[0] )))
	return( RC_ERROR );

    if(!( box = AllocObject( IE_BEVELBOX )))
	return( RC_FATAL );

    AddTail(( struct List * )&wnd->wi_Boxes, (struct Node *)box );

    wnd->wi_NumBoxes += 1;
    IE.flags &= ~SALVATO;

    box->bb_VITag       = GT_VisualInfo;
    box->bb_VisualInfo  = VisualInfo;
    box->bb_RTag        = TAG_IGNORE;
    box->bb_TTag        = GTBB_FrameType;

    box->bb_Left      = *((ULONG *)ArgArray[1]);
    box->bb_Top       = *((ULONG *)ArgArray[2]);
    box->bb_Width     = *((ULONG *)ArgArray[3]);
    box->bb_Height    = *((ULONG *)ArgArray[4]);
    box->bb_FrameType = *((ULONG *)ArgArray[5]);

    if( ArgArray[6] ) {
	box->bb_Recessed = TRUE;
	box->bb_RTag     = GTBB_Recessed;
    }

    if( wnd->wi_flags1 & W_APERTA ) {

	ActivateWindow( wnd->wi_winptr );
	IE.win_info   = wnd;
	IE.win_active = wnd->wi_winptr;

	RinfrescaFinestra();
	CheckMenuToActive();
    }

    sprintf( buffer, ld_fmt, wnd->wi_NumBoxes );
    Msg->rm_Result2 = CreateArgstring( buffer, strlen( buffer ));

    return( RC_OK );
}
///
/// AddIText
LONG AddITextRexxed( ULONG *ArgArray, struct RexxMsg *Msg )
{
    struct ITextNode   *txt, *pred;
    UWORD               cnt, num;
    struct TxtAttrNode *fnt;
    struct WindowInfo  *wnd;
    UBYTE               buffer[12];

    if(!( wnd = GimmeWnd(( ULONG * )ArgArray[0] )))
	return( RC_ERROR );

    if(!( txt = AllocObject( IE_INTUITEXT )))
	return( RC_FATAL );

    AddTail(( struct List * )&wnd->wi_ITexts, (struct Node *)txt );

    wnd->wi_NumTexts += 1;
    IE.flags &= ~SALVATO;

    txt->itn_Node.ln_Type = IT_SCRFONT;

    txt->itn_FrontPen = *((ULONG *)ArgArray[1]);
    txt->itn_BackPen  = *((ULONG *)ArgArray[2]);
    txt->itn_DrawMode = *((ULONG *)ArgArray[3]);
    txt->itn_LeftEdge = *((ULONG *)ArgArray[4]);
    txt->itn_TopEdge  = *((ULONG *)ArgArray[5]);
    strcpy( txt->itn_Text, (STRPTR)ArgArray[6] );

    txt->itn_Node.ln_Name = txt->itn_IText = txt->itn_Text;

    pred = txt->itn_Node.ln_Pred;
    if( pred->itn_Node.ln_Pred )
	pred->itn_NextText = &txt->itn_FrontPen;

    if( ArgArray[7] ) {

	fnt = IE.FntLst.mlh_Head;
	num = *((ULONG *)ArgArray[7]) - 1;
	for( cnt = 0; cnt < num; cnt++ )
	    if(!( fnt = fnt->txa_Next ))
		goto no;

	fnt->txa_OpenCnt += 1;

	txt->itn_FontCopy = txt->itn_ITextFont = &fnt->txa_FontName;
	txt->itn_Node.ln_Type = 0;
    }

no:

    if( wnd->wi_flags1 & W_APERTA ) {

	ActivateWindow( wnd->wi_winptr );
	IE.win_info   = wnd;
	IE.win_active = wnd->wi_winptr;

	RinfrescaFinestra();
	CheckMenuToActive();
    }

    sprintf( buffer, ld_fmt, wnd->wi_NumTexts );
    Msg->rm_Result2 = CreateArgstring( buffer, strlen( buffer ));

    return( RC_OK );
}
///

//      G
/// Generate
LONG GenerateRexxed( ULONG *ArgArray, struct RexxMsg *Msg )
{
    struct Generator    *gbase, *other = NULL;

    if( ArgArray[1] )
	strcpy( allpath2, (STRPTR)ArgArray[1] );

    if(!( ArgArray[0] ))
	IE.flags_2 |= REXXCALL;

    if( ArgArray[2] ) {
	UBYTE   buffer[256];

	strcpy( buffer, "PROGDIR:Generators/" );
	strcat( buffer, (STRPTR)ArgArray[2] );

	gbase = GenBase;

	if(!( GenBase = ( struct Generator * )OpenLibrary( buffer, 37 )))
	    GenBase = gbase;
	else
	    other = GenBase;
    }

    GeneraMenued();

    if( ArgArray[2] ) {
	GenBase = gbase;
	if( other )
	    CloseLibrary(( struct Library * )other );
    }

    IE.flags_2 &= ~REXXCALL;

    return( RC_OK );
}
///
/// GetActWndData
LONG GetActWndDataRexxed( ULONG *ArgArray, struct RexxMsg *Msg )
{
    ULONG   ret;

    if( IE.win_info ) {
	ULONG   num;

	num = GetNodeNum( &IE.win_list, IE.win_info ) + 1;

	ArgArray[1] = ArgArray[0];
	ArgArray[0] = (ULONG)&num;

	ret = GetWndDataRexxed( ArgArray, Msg );

    } else
	return( RC_WARN );

    return( ret );
}
///
/// GetBox
LONG GetBoxRexxed( ULONG *ArgArray, struct RexxMsg *Msg )
{
    struct BevelBoxNode *box;
    UBYTE                buf[12];

    if( ActivateWnd( (ULONG *)ArgArray[0] )) {

	if(!( IE.win_info->wi_NumBoxes ))
	    return( RC_WARN );

	if( box = GetBox() ) {

	    sprintf( buf, ld_fmt, GetNodeNum( &IE.win_info->wi_Boxes, box ) + 1 );

	    if(!( Msg->rm_Result2 = CreateArgstring( buf, strlen( buf ))))
		return( RC_FATAL );

	} else {
	    return( RC_WARN );
	}

    } else {
	return( RC_ERROR );
    }

    return( RC_OK );
}
///
/// GetBoxAttr
LONG GetBoxAttrRexxed( ULONG *ArgArray, struct RexxMsg *Msg )
{
    struct WindowInfo      *wnd;
    struct BevelBoxNode    *box;
    UWORD                   cnt, len;
    UBYTE                   buffer[256], num[12];

    if(!( wnd = GimmeWnd(( ULONG * )ArgArray[0] )))
	return( RC_ERROR );

    cnt = *((ULONG *)ArgArray[1]);

    if((!( wnd->wi_NumBoxes )) || ( cnt > wnd->wi_NumBoxes ))
	return( RC_WARN );

    for( box = wnd->wi_Boxes.mlh_Head, len = 1; len < cnt; len++ )
	box = box->bb_Next;

    strcpy( buffer, (STRPTR)ArgArray[2] );
    len = strlen( buffer );

    strcat( buffer, stem_LeftEdge );
    sprintf( num, ld_fmt, box->bb_Left );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_TopEdge );
    sprintf( num, ld_fmt, box->bb_Top );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_Width );
    sprintf( num, ld_fmt, box->bb_Width );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_Height );
    sprintf( num, ld_fmt, box->bb_Height );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_Type );
    sprintf( num, ld_fmt, box->bb_FrameType );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_Recessed );
    sprintf( num, ld_fmt, box->bb_Recessed & 1 );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    return( RC_OK );
}
///
/// GetDriPen
LONG GetDriPenRexxed( ULONG *ArgArray, struct RexxMsg *Msg )
{
    UBYTE               num[12];
    struct DrawInfo    *dri;
    UWORD               pen;

    if( dri = GetScreenDrawInfo( Scr )) {

	pen = *(( ULONG * )ArgArray[0] );

	if( pen >= dri->dri_NumPens )
	    return( RC_FATAL );

	sprintf( num, ld_fmt, dri->dri_Pens[ pen ] );

	FreeScreenDrawInfo( Scr, dri );

	if(!( Msg->rm_Result2 = CreateArgstring( num, strlen( num ))))
	    return( RC_FATAL );

    } else {
	return( RC_FATAL );
    }

    return( RC_OK );
}
///
/// GetFontAttr
LONG GetFontAttrRexxed( ULONG *ArgArray, struct RexxMsg *Msg )
{
    UBYTE               buffer[255], num[12];
    UWORD               len, cnt;
    struct TxtAttrNode *fnt;

    strcpy( buffer, (STRPTR)ArgArray[1] );

    fnt = IE.FntLst.mlh_Head;
    len = *((ULONG *)ArgArray[0]);
    for( cnt = 1; cnt < len; cnt++ )
	if(!( fnt = fnt->txa_Next ))
	    return( RC_ERROR );

    len = strlen( buffer );

    strcat( buffer, stem_Style );
    sprintf( num, ld_fmt, fnt->txa_Style );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_Flags );
    sprintf( num, ld_fmt, fnt->txa_Flags );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_YSize );
    sprintf( num, ld_fmt, fnt->txa_Size );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_Name );
    if( SetRexxVar( (struct Message *)Msg, buffer, fnt->txa_FontName, strlen( fnt->txa_FontName )))
	return( RC_FATAL );

    return( RC_OK );
}
///
/// GetFile
LONG GetFileRexxed( ULONG *ArgArray, struct RexxMsg *Msg )
{
    UBYTE FileBuf[64], DrawerBuf[256], All[512];

    if( ArgArray[1] )
	strcpy( FileBuf, (STRPTR)ArgArray[1] );
    else
	strcpy( FileBuf, initial_file );

    if( ArgArray[2] )
	strcpy( DrawerBuf, (STRPTR)ArgArray[2] );
    else
	strcpy( DrawerBuf, initial_drawer );

    if( GetFile3( ArgArray[4], (STRPTR)ArgArray[0],
		  (STRPTR)ArgArray[3], 0, NULL,
		  FileBuf, DrawerBuf )) {

	strcpy( All, DrawerBuf );
	AddPart( All, FileBuf, 512 );

	if(!( Msg->rm_Result2 = CreateArgstring( All, strlen( All ))))
	    return( RC_FATAL );

    } else {
	return( RC_WARN );
    }

    return( RC_OK );
}
///
/// GetImg
LONG GetImgRexxed( ULONG *ArgArray, struct RexxMsg *Msg )
{
    struct WndImages   *img;
    UBYTE               buf[12];

    if( ActivateWnd( (ULONG *)ArgArray[0] )) {

	if(!( IE.win_info->wi_NumImages ))
	    return( RC_WARN );

	if( img = GetImg() ) {

	    sprintf( buf, ld_fmt, GetNodeNum( &IE.win_info->wi_Images, img ) + 1 );

	    if(!( Msg->rm_Result2 = CreateArgstring( buf, strlen( buf ))))
		return( RC_FATAL );

	} else {
	    return( RC_WARN );
	}

    } else {
	return( RC_ERROR );
    }

    return( RC_OK );
}
///
/// GetImgAttr
LONG GetImgAttrRexxed( ULONG *ArgArray, struct RexxMsg *Msg )
{
    struct WindowInfo  *wnd;
    struct WndImages   *img;
    UWORD               cnt, len;
    UBYTE               buffer[256], num[12];

    if(!( wnd = GimmeWnd(( ULONG * )ArgArray[0] )))
	return( RC_ERROR );

    cnt = *((ULONG *)ArgArray[1]);

    if((!( wnd->wi_NumImages )) || ( cnt > wnd->wi_NumImages ))
	return( RC_WARN );

    for( img = wnd->wi_Images.mlh_Head, len = 1; len < cnt; len++ )
	img = img->wim_Next;

    strcpy( buffer, (STRPTR)ArgArray[2] );
    len = strlen( buffer );

    strcat( buffer, stem_LeftEdge );
    sprintf( num, ld_fmt, img->wim_Left );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_TopEdge );
    sprintf( num, ld_fmt, img->wim_Top );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_Width );
    sprintf( num, ld_fmt, img->wim_Width );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_Height );
    sprintf( num, ld_fmt, img->wim_Height );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_Depth );
    sprintf( num, ld_fmt, img->wim_Depth );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_PlanePick );
    sprintf( num, ld_fmt, img->wim_PlanePick );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_PlaneOnOff );
    sprintf( num, ld_fmt, img->wim_PlaneOnOff );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    return( RC_OK );
}
///
/// GetIText
LONG GetITextRexxed( ULONG *ArgArray, struct RexxMsg *Msg )
{
    struct ITextNode   *txt;
    UBYTE               num[12];

    if(!( ActivateWnd(( ULONG * )ArgArray[0] )))
	return( RC_ERROR );

    if(!( IE.win_info->wi_NumTexts ))
	return( RC_WARN );

    if( txt = GetText() ) {

	sprintf( num, ld_fmt, GetNodeNum( &IE.win_info->wi_ITexts, txt ) + 1 );

	if(!( Msg->rm_Result2 = CreateArgstring( num, strlen( num ))))
	    return( RC_FATAL );

    } else {
	return( RC_WARN );
    }

    return( RC_OK );
}
///
/// GetITextAttr
LONG GetITextAttrRexxed( ULONG *ArgArray, struct RexxMsg *Msg )
{
    UBYTE               buffer[255], num[12];
    UWORD               len;
    WORD                cnt;
    struct ITextNode   *txt;
    struct WindowInfo  *wnd;

    if(!( wnd = GimmeWnd(( ULONG * )ArgArray[0] )))
	return( RC_ERROR );

    if(!( wnd->wi_NumTexts ))
	return( RC_WARN );

    strcpy( buffer, (STRPTR)ArgArray[2] );

    txt = wnd->wi_ITexts.mlh_Head;
    len = *((ULONG *)ArgArray[1]);
    for( cnt = 1; cnt < len; cnt++ )
	txt = txt->itn_Node.ln_Succ;

    len = strlen( buffer );

    strcat( buffer, stem_FrontPen );
    sprintf( num, ld_fmt, txt->itn_FrontPen );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_BackPen );
    sprintf( num, ld_fmt, txt->itn_BackPen );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_DrawMode );
    sprintf( num, ld_fmt, txt->itn_DrawMode );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_LeftEdge );
    sprintf( num, ld_fmt, txt->itn_LeftEdge );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_TopEdge );
    sprintf( num, ld_fmt, txt->itn_TopEdge );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_Text );
    if( SetRexxVar( (struct Message *)Msg, buffer, txt->itn_IText, strlen( txt->itn_IText )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_Font );

    if( txt->itn_ITextFont ) {

	struct TxtAttrNode *fnt;

	fnt = (struct TxtAttrNode *)((ULONG)txt->itn_ITextFont - 14);
	cnt = GetNodeNum( &IE.FntLst, fnt ) + 1;

    } else {
	cnt = -1;
    }

    sprintf( num, ld_fmt, cnt );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    return( RC_OK );
}
///
/// GetName
LONG GetNameRexxed( ULONG *ArgArray, struct RexxMsg *Msg )
{
    if( Msg->rm_Result2 = CreateArgstring( save_file, strlen( save_file )))
	return( RC_OK );
    else
	return( RC_FATAL );
}
///
/// GetScrFont
LONG GetScrFontRexxed( ULONG *ArgArray, struct RexxMsg *Msg )
{
    UBYTE   buffer[256], num[12];
    UWORD   len;

    len  = strlen( (STRPTR)ArgArray[0] );
    strcpy( buffer, (STRPTR)ArgArray[0] );

    strcat( buffer, stem_Style );
    sprintf( num, ld_fmt, Scr->Font->ta_Style );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_Flags );
    sprintf( num, ld_fmt, Scr->Font->ta_Flags );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_YSize );
    sprintf( num, ld_fmt, Scr->Font->ta_YSize );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_Name );
    if( SetRexxVar( (struct Message *)Msg, buffer, Scr->Font->ta_Name, strlen( Scr->Font->ta_Name )))
	return( RC_FATAL );

    return( RC_OK );
}
///
/// GetTxtLen
LONG GetTxtLenRexxed( ULONG *ArgArray, struct RexxMsg *Msg )
{
    struct WindowInfo  *wnd;
    struct ITextNode   *txt;
    UWORD               len, cnt;
    UBYTE               buf[12];

    if(!( wnd = GimmeWnd(( ULONG * )ArgArray[0] )))
	return( RC_ERROR );

    if(!( wnd->wi_NumTexts ))
	return( RC_WARN );

    txt = wnd->wi_ITexts.mlh_Head;
    len = *((ULONG *)ArgArray[1]);
    for( cnt = 1; cnt < len; cnt++ )
	txt = txt->itn_Node.ln_Succ;

    sprintf( buf, ld_fmt, IntuiTextLength(( struct IntuiText *)&txt->itn_FrontPen ));

    if(!( Msg->rm_Result2 = CreateArgstring( buf, strlen( buf ))))
	return( RC_FATAL );

    return( RC_OK );
}
///
/// GetWndData
LONG GetWndDataRexxed( ULONG *ArgArray, struct RexxMsg *Msg )
{
    UBYTE               buffer[255], num[12];
    UWORD               len;
    struct WindowInfo  *wnd;

    if(!( wnd = GimmeWnd(( ULONG * )ArgArray[0] )))
	return( RC_ERROR );

    strcpy( buffer, (STRPTR)ArgArray[1] );
    len = strlen( buffer );

    strcat( buffer, stem_Title );
    if( SetRexxVar( (struct Message *)Msg, buffer, wnd->wi_Titolo, strlen( wnd->wi_Titolo )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_ScreenTitle );
    if( SetRexxVar( (struct Message *)Msg, buffer, wnd->wi_TitoloSchermo, strlen( wnd->wi_TitoloSchermo )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_Label );
    if( SetRexxVar( (struct Message *)Msg, buffer, wnd->wi_Label, strlen( wnd->wi_Label )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_TopEdge );
    sprintf( num, ld_fmt, wnd->wi_Top );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_LeftEdge );
    sprintf( num, ld_fmt, wnd->wi_Left );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_Width );
    sprintf( num, ld_fmt, wnd->wi_Width );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_Height );
    sprintf( num, ld_fmt, wnd->wi_Height );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_MinWidth );
    sprintf( num, ld_fmt, wnd->wi_MinWidth );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_MinHeight );
    sprintf( num, ld_fmt, wnd->wi_MinHeight );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_MaxWidth );
    sprintf( num, ld_fmt, wnd->wi_MaxWidth );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_MaxHeight );
    sprintf( num, ld_fmt, wnd->wi_MaxHeight );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_InnerWidth );
    sprintf( num, ld_fmt, wnd->wi_InnerWidth );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_InnerHeight );
    sprintf( num, ld_fmt, wnd->wi_InnerHeight );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_MouseQueue );
    sprintf( num, ld_fmt, wnd->wi_MouseQueue );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_RptQueue );
    sprintf( num, ld_fmt, wnd->wi_RptQueue );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_NumGads );
    sprintf( num, ld_fmt, wnd->wi_NumGads );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_NumMenus );
    sprintf( num, ld_fmt, wnd->wi_NumMenus );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_NumBoxes );
    sprintf( num, ld_fmt, wnd->wi_NumBoxes );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_NumTexts );
    sprintf( num, ld_fmt, wnd->wi_NumTexts );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_NumBools );
    sprintf( num, ld_fmt, wnd->wi_NumBools );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_NumImages );
    sprintf( num, ld_fmt, wnd->wi_NumImages );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_ZLeft );
    sprintf( num, ld_fmt, wnd->wi_ZLeft );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_ZTop );
    sprintf( num, ld_fmt, wnd->wi_ZTop );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_ZWidth );
    sprintf( num, ld_fmt, wnd->wi_ZWidth );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_ZHeight );
    sprintf( num, ld_fmt, wnd->wi_ZHeight );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_IDCMP );
    sprintf( num, ld_fmt, wnd->wi_IDCMP );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_Flags );
    sprintf( num, ld_fmt, wnd->wi_Flags );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    buffer[ len ] = '\0';
    strcat( buffer, stem_Tags );
    sprintf( num, ld_fmt, wnd->wi_Tags );
    if( SetRexxVar( (struct Message *)Msg, buffer, num, strlen( num )))
	return( RC_FATAL );

    return( RC_OK );
}
///

//      N
/// New
LONG NewRexxed( ULONG *ArgArray, struct RexxMsg *Msg )
{
    IE.flags |= SALVATO;
    NuovoMenued();
    return( RC_OK );
}
///

//      O
/// Open
LONG OpenRexxed( ULONG *ArgArray, struct RexxMsg *Msg )
{
    if(!( ArgArray[0] )) {

	strcpy( allpath2, (STRPTR)ArgArray[1] );

	if(!( IE.flags_2 & DEMO ))
	    strcpy( save_file, allpath2 );

	IE.flags |= LOADGUI;
    }

    NewRexxed( NULL, NULL );

    CaricaMenued();

    return( RC_OK );
}
///

//      Q
/// Quit
LONG QuitRexxed( ULONG *ArgArray, struct RexxMsg *Msg )
{
    Ok_to_Run = FALSE;
    IE.flags |= SALVATO;
    return( RC_OK );
}
///

//      S
/// Save
LONG SaveRexxed( ULONG *ArgArray, struct RexxMsg *Msg )
{
    if( IE.flags & DEMO )
	return( 15 );

    SalvaMenued();
    return( RC_OK );
}
///
/// SaveAs
LONG SaveAsRexxed( ULONG *ArgArray, struct RexxMsg *Msg )
{
    if( IE.flags & DEMO )
	return( 15 );

    save_file[0] = '\0';

    if( ArgArray[1] )
	strcpy( save_file, (STRPTR)ArgArray[1] );

    if( ArgArray[0] )
	SalvaComeMenued();
    else
	SalvaMenued();

    return( RC_OK );
}
///
/// SetBoxAttr
LONG SetBoxAttrRexxed( ULONG *ArgArray, struct RexxMsg *Msg )
{
    struct WindowInfo      *wnd;
    struct BevelBoxNode    *box;
    UWORD                   num, cnt;

    if(!( wnd = GimmeWnd(( ULONG * )ArgArray[0] )))
	return( RC_ERROR );

    num = *((ULONG *)ArgArray[1]);

    if((!( wnd->wi_NumBoxes )) || ( num > wnd->wi_NumBoxes ))
	return( RC_WARN );

    box = wnd->wi_Boxes.mlh_Head;

    for( cnt = 1; cnt < num; cnt++ )
	box = box->bb_Next;

    if( ArgArray[2] )
	box->bb_Left      = *((ULONG *)ArgArray[2]);

    if( ArgArray[3] )
	box->bb_Top       = *((ULONG *)ArgArray[3]);

    if( ArgArray[4] )
	box->bb_Width     = *((ULONG *)ArgArray[4]);

    if( ArgArray[5] )
	box->bb_Height    = *((ULONG *)ArgArray[5]);

    if( ArgArray[6] )
	box->bb_FrameType = *((ULONG *)ArgArray[6]);

    if( ArgArray[7] ) {
	if( box->bb_Recessed ) {
	    box->bb_Recessed = FALSE;
	    box->bb_RTag     = TAG_IGNORE;
	} else {
	    box->bb_Recessed = TRUE;
	    box->bb_RTag     = GTBB_Recessed;
	}
    }

    if( wnd->wi_flags1 & W_APERTA ) {

	IE.win_active = wnd->wi_winptr;
	IE.win_info   = wnd;

	ActivateWindow( wnd->wi_winptr );

	RinfrescaFinestra();
    }

    IE.flags &= ~SALVATO;

    return( RC_OK );
}
///
/// SetImgAttr
LONG SetImgAttrRexxed( ULONG *ArgArray, struct RexxMsg *Msg )
{
    struct WindowInfo  *wnd;
    struct WndImages   *img;
    UWORD               num, cnt;

    if(!( wnd = GimmeWnd(( ULONG * )ArgArray[0] )))
	return( RC_ERROR );

    num = *((ULONG *)ArgArray[1]);

    if((!( wnd->wi_NumImages )) || ( num > wnd->wi_NumImages ))
	return( RC_WARN );

    img = wnd->wi_Images.mlh_Head;

    for( cnt = 1; cnt < num; cnt++ )
	img = img->wim_Next;

    if( ArgArray[2] )
	img->wim_Left = *((ULONG *)ArgArray[2]);

    if( ArgArray[3] )
	img->wim_Top  = *((ULONG *)ArgArray[3]);

    if( wnd->wi_flags1 & W_APERTA ) {

	IE.win_active = wnd->wi_winptr;
	IE.win_info   = wnd;

	ActivateWindow( wnd->wi_winptr );

	RinfrescaFinestra();
    }

    IE.flags &= ~SALVATO;

    return( RC_OK );
}
///
/// SetITextAttr
LONG SetITextAttrRexxed( ULONG *ArgArray, struct RexxMsg *Msg )
{
    struct WindowInfo  *wnd;
    UWORD               num, cnt;
    struct ITextNode   *txt;

    if(!( wnd = GimmeWnd(( ULONG * )ArgArray[0] )))
	return( RC_ERROR );

    num = *(( ULONG * )ArgArray[1]);

    if((!( wnd->wi_NumTexts )) || ( num > wnd->wi_NumTexts ))
	return( RC_WARN );

    for( txt = wnd->wi_ITexts.mlh_Head, cnt = 1; cnt < num; cnt++ )
	txt = txt->itn_Node.ln_Succ;

    if( ArgArray[2] )
	txt->itn_FrontPen = *(( ULONG * )ArgArray[2]);

    if( ArgArray[3] )
	txt->itn_BackPen  = *(( ULONG * )ArgArray[3]);

    if( ArgArray[4] )
	txt->itn_DrawMode = *(( ULONG * )ArgArray[4]);

    if( ArgArray[5] )
	txt->itn_LeftEdge = *(( ULONG * )ArgArray[5]);

    if( ArgArray[6] )
	txt->itn_TopEdge  = *(( ULONG * )ArgArray[6]);

    if( ArgArray[7] ) {

	struct TxtAttrNode *fnt;

	fnt = IE.FntLst.mlh_Head;
	num = *((ULONG *)ArgArray[7]);
	for( cnt = 1; cnt < num; cnt++ )
	    if(!( fnt = fnt->txa_Next ))
		return( RC_ERROR );

	fnt->txa_OpenCnt += 1;

	txt->itn_FontCopy = txt->itn_ITextFont = &fnt->txa_FontName;
	txt->itn_Node.ln_Type &= ~IT_SCRFONT;
    }

    if( ArgArray[8] )
	strcpy( txt->itn_Text, (STRPTR)ArgArray[8] );

    if( wnd->wi_flags1 & W_APERTA ) {

	IE.win_info   = wnd;
	IE.win_active = wnd->wi_winptr;

	ActivateWindow( wnd->wi_winptr );

	RinfrescaFinestra();
    }

    IE.flags &= ~SALVATO;

    return( RC_OK );
}
///
/// SetName
LONG SetNameRexxed( ULONG *ArgArray, struct RexxMsg *Msg )
{
    strcpy( save_file, (STRPTR)ArgArray[0] );
    return( RC_OK );
}
///

