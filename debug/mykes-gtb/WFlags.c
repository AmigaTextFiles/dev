/*-- AutoRev header do NOT edit!
*
*   Program         :   WFlags.c
*   Copyright       :   © Copyright 1991 Jaba Development
*   Author          :   Jan van den Baard
*   Creation Date   :   24-Oct-91
*   Current version :   1.00
*   Translator      :   DICE v2.6
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   24-Oct-91     1.00            Window Flags requester.
*
*-- REV_END --*/

#include	"defs.h"

/*
 * --- External referenced data.
 */
extern ULONG                 Class;
extern UWORD                 Code;
extern struct TextAttr       Topaz80;
extern APTR                  MainVisualInfo;
extern struct Screen        *MainScreen;
extern struct Window        *MainWindow;
extern struct RastPort      *MainRP;
extern struct Gadget        *theObject;
extern ULONG                 WindowFlags;
extern BOOL                  Saved;
extern struct TagItem        nwTags[];
extern struct ExtGadgetList  Gadgets;
extern struct Menu          *MainMenus;
extern BOOL                  BreakDRAG;
extern struct Gadgets       *MainGList;

#define NUMFLAGS        16

#define GD_OK           20
#define GD_CANCEL       21

/*
 * --- Module data.
 */
struct Window           *fl_Wnd   = NULL;
struct Gadget           *fl_GList = NULL;
struct Gadget           *fl_Gadgets[ NUMFLAGS ];
BOOL                     fl_Bools[ NUMFLAGS ];

WORD                     fl_Zoom[4];

struct TagItem           fl_nwTags[] = {
    WA_Left,                0l,
    WA_Top,                 0l,
    WA_Width,               0l,
    WA_Height,              0l,
    WA_IDCMP,               IDCMP_CLOSEWINDOW | BUTTONIDCMP | IDCMP_VANILLAKEY | IDCMP_REFRESHWINDOW,
    WA_Flags,               WFLG_DRAGBAR | WFLG_DEPTHGADGET| WFLG_CLOSEGADGET | WFLG_ACTIVATE | WFLG_RMBTRAP | WFLG_SMART_REFRESH,
    WA_Gadgets,             0l,
    WA_Title,               (ULONG)"Edit Window Flags:",
    WA_AutoAdjust,          TRUE,
    WA_Zoom,                (Tag)fl_Zoom,
    WA_CustomScreen,        0l,
    TAG_DONE };

/*
 * --- Set all gadgets to flags.
 */
void SetFlagGadgets( void )
{
    UWORD   i;

    for ( i = 0; i < 16; i++ )
        GT_SetGadgetAttrs( fl_Gadgets[ i ], fl_Wnd, 0l, GTCB_Checked, fl_Bools[ i ], TAG_DONE );
}

/*
 * --- get user flags
 */
void GetUserFlags( void )
{
    UWORD i = 0;

    setmem(( char * )&fl_Bools[0], NUMFLAGS << 1, 0l );

    if (( WindowFlags & WFLG_SIZEGADGET ) == WFLG_SIZEGADGET )
        fl_Bools[ i++ ] = TRUE; else fl_Bools[ i++ ] = FALSE;
    if (( WindowFlags & WFLG_DRAGBAR ) == WFLG_DRAGBAR )
        fl_Bools[ i++ ] = TRUE; else fl_Bools[ i++ ] = FALSE;
    if (( WindowFlags & WFLG_DEPTHGADGET ) == WFLG_DEPTHGADGET )
        fl_Bools[ i++ ] = TRUE; else fl_Bools[ i++ ] = FALSE;
    if (( WindowFlags & WFLG_CLOSEGADGET ) == WFLG_CLOSEGADGET )
        fl_Bools[ i++ ] = TRUE; else fl_Bools[ i++ ] = FALSE;
    if (( WindowFlags & WFLG_SIZEBRIGHT ) == WFLG_SIZEBRIGHT )
        fl_Bools[ i++ ] = TRUE; else fl_Bools[ i++ ] = FALSE;
    if (( WindowFlags & WFLG_SIZEBBOTTOM ) == WFLG_SIZEBBOTTOM )
        fl_Bools[ i++ ] = TRUE; else fl_Bools[ i++ ] = FALSE;
    if (( WindowFlags & WFLG_SMART_REFRESH ) == WFLG_SMART_REFRESH )
        fl_Bools[ i++ ] = TRUE; else fl_Bools[ i++ ] = FALSE;
    if (( WindowFlags & WFLG_SIMPLE_REFRESH ) == WFLG_SIMPLE_REFRESH )
        fl_Bools[ i++ ] = TRUE; else fl_Bools[ i++ ] = FALSE;
    if (( WindowFlags & WFLG_SUPER_BITMAP ) == WFLG_SUPER_BITMAP )
        fl_Bools[ i++ ] = TRUE; else fl_Bools[ i++ ] = FALSE;
    if (( WindowFlags & WFLG_OTHER_REFRESH ) == WFLG_OTHER_REFRESH )
        fl_Bools[ i++ ] = TRUE; else fl_Bools[ i++ ] = FALSE;
    if (( WindowFlags & WFLG_BACKDROP ) == WFLG_BACKDROP )
        fl_Bools[ i++ ] = TRUE; else fl_Bools[ i++ ] = FALSE;
    if (( WindowFlags & WFLG_REPORTMOUSE ) == WFLG_REPORTMOUSE )
        fl_Bools[ i++ ] = TRUE; else fl_Bools[ i++ ] = FALSE;
    if (( WindowFlags & WFLG_GIMMEZEROZERO ) == WFLG_GIMMEZEROZERO )
        fl_Bools[ i++ ] = TRUE; else fl_Bools[ i++ ] = FALSE;
    if (( WindowFlags & WFLG_BORDERLESS ) == WFLG_BORDERLESS )
        fl_Bools[ i++ ] = TRUE; else fl_Bools[ i++ ] = FALSE;
    if (( WindowFlags & WFLG_ACTIVATE ) == WFLG_ACTIVATE )
        fl_Bools[ i++ ] = TRUE; else fl_Bools[ i++ ] = FALSE;
    if (( WindowFlags & WFLG_RMBTRAP ) == WFLG_RMBTRAP )
        fl_Bools[ i++ ] = TRUE; else fl_Bools[ i++ ] = FALSE;
}

/*
 * --- Set flags
 */
void SetFlags( void )
{
    UWORD i = 0;

    WindowFlags = 0l;

    if ( fl_Bools[ i++ ] ) WindowFlags |= WFLG_SIZEGADGET;
    if ( fl_Bools[ i++ ] ) WindowFlags |= WFLG_DRAGBAR;
    if ( fl_Bools[ i++ ] ) WindowFlags |= WFLG_DEPTHGADGET;
    if ( fl_Bools[ i++ ] ) WindowFlags |= WFLG_CLOSEGADGET;
    if ( fl_Bools[ i++ ] ) WindowFlags |= WFLG_SIZEBRIGHT;
    if ( fl_Bools[ i++ ] ) WindowFlags |= WFLG_SIZEBBOTTOM;
    if ( fl_Bools[ i++ ] ) WindowFlags |= WFLG_SMART_REFRESH;
    if ( fl_Bools[ i++ ] ) WindowFlags |= WFLG_SIMPLE_REFRESH;
    if ( fl_Bools[ i++ ] ) WindowFlags |= WFLG_SUPER_BITMAP;
    if ( fl_Bools[ i++ ] ) WindowFlags |= WFLG_OTHER_REFRESH;
    if ( fl_Bools[ i++ ] ) WindowFlags |= WFLG_BACKDROP;
    if ( fl_Bools[ i++ ] ) WindowFlags |= WFLG_REPORTMOUSE;
    if ( fl_Bools[ i++ ] ) WindowFlags |= WFLG_GIMMEZEROZERO;
    if ( fl_Bools[ i++ ] ) WindowFlags |= WFLG_BORDERLESS;
    if ( fl_Bools[ i++ ] ) WindowFlags |= WFLG_ACTIVATE;
    if ( fl_Bools[ i++ ] ) WindowFlags |= WFLG_RMBTRAP;
}

/*
 * --- Set visible changes.
 */
void SetChanges( void )
{
    struct Window *wnd;

    if ( fl_Bools[ 0 ] ) nwTags[5].ti_Data |= WFLG_SIZEGADGET;
    else                 nwTags[5].ti_Data &= ~WFLG_SIZEGADGET;
    if ( fl_Bools[ 1 ] ) nwTags[5].ti_Data |= WFLG_DRAGBAR;
    else                 nwTags[5].ti_Data &= ~WFLG_DRAGBAR;
    if ( fl_Bools[ 2 ] ) nwTags[5].ti_Data |= WFLG_DEPTHGADGET;
    else                 nwTags[5].ti_Data &= ~WFLG_DEPTHGADGET;
    if ( fl_Bools[ 3 ] ) nwTags[5].ti_Data |= WFLG_CLOSEGADGET;
    else                 nwTags[5].ti_Data &= ~WFLG_CLOSEGADGET;
    if ( fl_Bools[ 4 ] ) nwTags[5].ti_Data |= WFLG_SIZEBRIGHT;
    else                 nwTags[5].ti_Data &= ~WFLG_SIZEBRIGHT;
    if ( fl_Bools[ 5 ] ) nwTags[5].ti_Data |= WFLG_SIZEBBOTTOM;
    else                 nwTags[5].ti_Data &= ~WFLG_SIZEBBOTTOM;

    nwTags[0].ti_Data = MainWindow->LeftEdge;
    nwTags[1].ti_Data = MainWindow->TopEdge;
    nwTags[2].ti_Data = MainWindow->Width;
    nwTags[3].ti_Data = MainWindow->Height;

    if ( wnd = OpenWindowTagList( 0l, nwTags )) {
        if ( MainGList )
            RemoveGList( MainWindow, MainGList, -1l );
        ClearMenuStrip( MainWindow );
        CloseWindow( MainWindow );
        MainWindow = wnd;
        MainRP     = wnd->RPort;
        ResetMenuStrip( MainWindow, MainMenus );
        BreakDRAG = TRUE;
        if ( MainGList ) {
            AddGList( MainWindow, MainGList, -1l, -1l, 0l );
            RefreshGList( MainGList, MainWindow, 0l, -1l );
            GT_RefreshWindow( MainWindow, 0l );
        }
    } else
        MyRequest( "Hello there...", "OK", "Could not re-open the edit window !" );
}

/*
 * --- Exclude some refresh gadgets.
 */
void DoExclude( UWORD id )
{
    UWORD   i;

    for ( i = 6; i < 10; i++ ) {
        if ( fl_Bools[ i ] ) {
            if ( id != i ) {
                GT_SetGadgetAttrs( fl_Gadgets[ i ], fl_Wnd, 0l, GTCB_Checked, FALSE, TAG_DONE );
                fl_Bools[ i ] = FALSE;
            }
        } else {
            GT_SetGadgetAttrs( fl_Gadgets[ id ], fl_Wnd, 0l, GTCB_Checked, TRUE, TAG_DONE );
            fl_Bools[ id ] = TRUE;
        }
    }
}

/*
 * --- Display the flags requester.
 */
long EditFlags( void )
{
    struct Gadget       *g;
    struct NewGadget     ng;
    BOOL                 running =  TRUE, OK = FALSE;
    WORD                 l, t, w, h, btop, bleft, idc = 0, top = 4;

    btop  = MainScreen->WBorTop + MainScreen->RastPort.TxHeight;
    bleft = MainScreen->WBorLeft;

    w = bleft + MainScreen->WBorRight  + 300;
    h = btop  + MainScreen->WBorBottom + 113;
    l = (( MainScreen->Width  >> 1 ) - ( w >> 1 ));
    t = (( MainScreen->Height >> 1 ) - ( h >> 1 ));

    fl_Zoom[0] = 0;
    fl_Zoom[1] = btop;
    fl_Zoom[2] = 200;
    fl_Zoom[3] = btop;

    fl_nwTags[0].ti_Data = l;
    fl_nwTags[1].ti_Data = t;
    fl_nwTags[2].ti_Data = w;
    fl_nwTags[3].ti_Data = h;

    fl_nwTags[10].ti_Data = (Tag)MainScreen;

    if (( MainScreen->Flags & CUSTOMSCREEN) == CUSTOMSCREEN )
        fl_nwTags[10].ti_Tag  = WA_CustomScreen;
    else if (( MainScreen->Flags & PUBLICSCREEN ) == PUBLICSCREEN )
        fl_nwTags[10].ti_Tag  = WA_PubScreen;
    else
        fl_nwTags[10].ti_Tag  = TAG_DONE;

    GetUserFlags();

    if ( g = CreateContext( &fl_GList )) {

        ng.ng_LeftEdge      =   bleft + 118;
        ng.ng_TopEdge       =   btop + top;
        ng.ng_GadgetText    =   "SIZEGADGET";
        ng.ng_TextAttr      =   &Topaz80;
        ng.ng_GadgetID      =   idc;
        ng.ng_Flags         =   PLACETEXT_LEFT;
        ng.ng_VisualInfo    =   MainVisualInfo;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        fl_Gadgets[ idc++ ] = g;

        ng.ng_LeftEdge      =   bleft + 267;
        ng.ng_GadgetText    =   "DRAGBAR";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        fl_Gadgets[ idc++ ] = g;

        top += 11;

        ng.ng_LeftEdge      =   bleft + 118;
        ng.ng_TopEdge       =   btop + top;
        ng.ng_GadgetText    =   "DEPTHGADGET";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        fl_Gadgets[ idc++ ] = g;

        ng.ng_LeftEdge      =   bleft + 267;
        ng.ng_GadgetText    =   "CLOSEGADGET";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        fl_Gadgets[ idc++ ] = g;

        top += 11;

        ng.ng_LeftEdge      =   bleft + 118;
        ng.ng_TopEdge       =   btop + top;
        ng.ng_GadgetText    =   "SIZEBRIGHT";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        fl_Gadgets[ idc++ ] = g;

        ng.ng_LeftEdge      =   bleft + 267;
        ng.ng_GadgetText    =   "SIZEBBOTTOM";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        fl_Gadgets[ idc++ ] = g;

        top += 11;

        ng.ng_LeftEdge      =   bleft + 118;
        ng.ng_TopEdge       =   btop + top;
        ng.ng_GadgetText    =   "SMART_REFRESH";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        fl_Gadgets[ idc++ ] = g;

        ng.ng_LeftEdge      =   bleft + 267;
        ng.ng_GadgetText    =   "SIMPLE_REFRESH";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        fl_Gadgets[ idc++ ] = g;

        top += 11;

        ng.ng_LeftEdge      =   bleft + 118;
        ng.ng_TopEdge       =   btop + top;
        ng.ng_GadgetText    =   "SUPER_BITMAP";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        fl_Gadgets[ idc++ ] = g;

        ng.ng_LeftEdge      =   bleft + 267;
        ng.ng_GadgetText    =   "OTHER_REFRESH";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        fl_Gadgets[ idc++ ] = g;

        top += 11;

        ng.ng_LeftEdge      =   bleft + 118;
        ng.ng_TopEdge       =   btop + top;
        ng.ng_GadgetText    =   "BACKDROP";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        fl_Gadgets[ idc++ ] = g;

        ng.ng_LeftEdge      =   bleft + 267;
        ng.ng_GadgetText    =   "REPORTMOUSE";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        fl_Gadgets[ idc++ ] = g;

        top += 11;

        ng.ng_LeftEdge      =   bleft + 118;
        ng.ng_TopEdge       =   btop + top;
        ng.ng_GadgetText    =   "GIMMEZEROZERO";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        fl_Gadgets[ idc++ ] = g;

        ng.ng_LeftEdge      =   bleft + 267;
        ng.ng_GadgetText    =   "BORDERLESS";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        fl_Gadgets[ idc++ ] = g;

        top += 11;

        ng.ng_LeftEdge      =   bleft + 118;
        ng.ng_TopEdge       =   btop + top;
        ng.ng_GadgetText    =   "ACTIVATE";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        fl_Gadgets[ idc++ ] = g;

        ng.ng_LeftEdge      =   bleft + 267;
        ng.ng_GadgetText    =   "RMBTRAP";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        fl_Gadgets[ idc++ ] = g;

        top += 15;

        ng.ng_LeftEdge      =   bleft + 8;
        ng.ng_TopEdge       =   btop + top;
        ng.ng_Width         =   90;
        ng.ng_Height        =   13;
        ng.ng_GadgetText    =   "_OK";
        ng.ng_GadgetID      =   GD_OK;
        ng.ng_Flags         =   PLACETEXT_IN;

        g = CreateGadget( BUTTON_KIND, g, &ng, GT_Underscore, '_', TAG_DONE );

        ng.ng_LeftEdge      =   bleft + 202;
        ng.ng_GadgetText    =   "_CANCEL";
        ng.ng_GadgetID      =   GD_CANCEL;

        g = CreateGadget( BUTTON_KIND, g, &ng, GT_Underscore, '_', TAG_DONE );

        if ( g ) {

            fl_nwTags[6].ti_Data = (Tag)fl_GList;

            if ( fl_Wnd = OpenWindowTagList( NULL, fl_nwTags )) {

                fl_Zoom[0] = l;
                fl_Zoom[1] = t;
                fl_Zoom[2] = w;
                fl_Zoom[3] = h;

                GT_RefreshWindow( fl_Wnd, NULL );

                SetFlagGadgets();

                do {
                    WaitPort( fl_Wnd->UserPort );

                    while ( ReadIMsg( fl_Wnd )) {

                        switch ( Class ) {

                            case    IDCMP_REFRESHWINDOW:
                                GT_BeginRefresh( fl_Wnd );
                                GT_EndRefresh( fl_Wnd, TRUE );
                                break;

                            case    IDCMP_CLOSEWINDOW:
                                running = FALSE;
                                break;

                            case    IDCMP_VANILLAKEY:
                                switch ( Code ) {

                                    case    'o':
                                        goto Ok;

                                    case    'c':
                                        goto Cancel;
                                }
                                break;

                            case    IDCMP_GADGETUP:
                                if ( theObject->GadgetID >= 6 && theObject->GadgetID <= 9 ) {
                                    DoExclude( theObject->GadgetID );
                                    break;
                                }

                                if ( theObject->GadgetID < 20 ) {
                                    FlipFlop( 0l, 0l, 0l, &fl_Bools[ theObject->GadgetID ] );
                                    break;
                                }

                                switch ( theObject->GadgetID ) {

                                    case    GD_OK:
                                        Ok:
                                        OK = TRUE;
                                        running = FALSE;
                                        break;

                                    case    GD_CANCEL:
                                        Cancel:
                                        running = FALSE;
                                        break;
                                }
                                break;
                        }
                    }
                } while ( running );
            }
        }
    }

    if ( fl_Wnd )           CloseWindow( fl_Wnd );
    if ( fl_GList )         FreeGadgets( fl_GList );

    fl_Wnd   = 0l;
    fl_GList = 0l;

    if ( OK )  {
        SetFlags();
        SetChanges();
        Saved = FALSE;
    }

    ClearMsgPort( MainWindow->UserPort );
}
