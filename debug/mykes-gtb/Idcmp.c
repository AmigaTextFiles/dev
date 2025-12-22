/*-- AutoRev header do NOT edit!
*
*   Program         :   Idcmp.c
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
*   24-Oct-91     1.00            Window IDCMP requester.
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
extern struct Gadget        *theObject;
extern ULONG                 WindowIDCMP;
extern struct ExtGadgetList  Gadgets;
extern BOOL   Saved;

#define NUMFLAGS        26

#define GD_OK           30
#define GD_CANCEL       31

/*
 * --- Module data.
 */
struct Window           *id_Wnd   = NULL;
struct Gadget           *id_GList = NULL;
struct Gadget           *id_Gadgets[ NUMFLAGS ];
BOOL                     id_Bools[ NUMFLAGS ];

WORD                     id_Zoom[4];

struct TagItem           id_nwTags[] = {
    WA_Left,                0l,
    WA_Top,                 0l,
    WA_Width,               0l,
    WA_Height,              0l,
    WA_IDCMP,               IDCMP_CLOSEWINDOW | BUTTONIDCMP | IDCMP_VANILLAKEY | IDCMP_REFRESHWINDOW,
    WA_Flags,               WFLG_DRAGBAR | WFLG_DEPTHGADGET| WFLG_CLOSEGADGET | WFLG_ACTIVATE | WFLG_RMBTRAP | WFLG_SMART_REFRESH,
    WA_Gadgets,             0l,
    WA_Title,               (ULONG)"Edit Window IDCMP:",
    WA_AutoAdjust,          TRUE,
    WA_Zoom,                (Tag)id_Zoom,
    WA_CustomScreen,        0l,
    TAG_DONE };

/*
 * --- Get necessary gadgets IDCMP.
 */
void GetGadgetIDCMP( void )
{
    struct ExtNewGadget *eng;

    for ( eng = Gadgets.gl_First; eng->en_Next; eng = eng->en_Next ) {
        switch ( eng->en_Kind ) {

            case    BUTTON_KIND:
                WindowIDCMP |= BUTTONIDCMP;
                break;

            case    CHECKBOX_KIND:
                WindowIDCMP |= CHECKBOXIDCMP;
                break;

            case    INTEGER_KIND:
                WindowIDCMP |= INTEGERIDCMP;
                break;

            case    LISTVIEW_KIND:
                WindowIDCMP |= LISTVIEWIDCMP;
                break;

            case    MX_KIND:
                WindowIDCMP |= MXIDCMP;
                break;

            case    CYCLE_KIND:
                WindowIDCMP |= CYCLEIDCMP;
                break;

            case    PALETTE_KIND:
                WindowIDCMP |= PALETTEIDCMP;
                break;

            case    SCROLLER_KIND:
                WindowIDCMP |= SCROLLERIDCMP;
                break;

            case    SLIDER_KIND:
                WindowIDCMP |= SLIDERIDCMP;
                break;

            case    STRING_KIND:
                WindowIDCMP |= STRINGIDCMP;
                break;
        }
    }
}

/*
 * --- Set all gadgets to IDCMP flags.
 */
void SetIDCMPGadgets( void )
{
    UWORD   i;

    for ( i = 0; i < 25; i++ )
        GT_SetGadgetAttrs( id_Gadgets[ i ], id_Wnd, 0l, GTCB_Checked, id_Bools[ i ], TAG_DONE );
}

/*
 * --- get user flags
 */
void GetUserIDCMP( void )
{
    UWORD i = 0;

    setmem(( char * )&id_Bools[0], NUMFLAGS << 1, 0l );

    if (( WindowIDCMP & IDCMP_SIZEVERIFY ) == IDCMP_SIZEVERIFY )
        id_Bools[ i++ ] = TRUE; else id_Bools[ i++ ] = FALSE;
    if (( WindowIDCMP & IDCMP_NEWSIZE ) == IDCMP_NEWSIZE )
        id_Bools[ i++ ] = TRUE; else id_Bools[ i++ ] = FALSE;
    if (( WindowIDCMP & IDCMP_REFRESHWINDOW ) == IDCMP_REFRESHWINDOW )
        id_Bools[ i++ ] = TRUE; else id_Bools[ i++ ] = FALSE;
    if (( WindowIDCMP & IDCMP_MOUSEBUTTONS ) == IDCMP_MOUSEBUTTONS )
        id_Bools[ i++ ] = TRUE; else id_Bools[ i++ ] = FALSE;
    if (( WindowIDCMP & IDCMP_MOUSEMOVE ) == IDCMP_MOUSEMOVE )
        id_Bools[ i++ ] = TRUE; else id_Bools[ i++ ] = FALSE;
    if (( WindowIDCMP & IDCMP_GADGETDOWN ) == IDCMP_GADGETDOWN )
        id_Bools[ i++ ] = TRUE; else id_Bools[ i++ ] = FALSE;
    if (( WindowIDCMP & IDCMP_GADGETUP ) == IDCMP_GADGETUP )
        id_Bools[ i++ ] = TRUE; else id_Bools[ i++ ] = FALSE;
    if (( WindowIDCMP & IDCMP_REQSET ) == IDCMP_REQSET )
        id_Bools[ i++ ] = TRUE; else id_Bools[ i++ ] = FALSE;
    if (( WindowIDCMP & IDCMP_REQCLEAR ) == IDCMP_REQCLEAR )
        id_Bools[ i++ ] = TRUE; else id_Bools[ i++ ] = FALSE;
    if (( WindowIDCMP & IDCMP_REQVERIFY ) == IDCMP_REQVERIFY )
        id_Bools[ i++ ] = TRUE; else id_Bools[ i++ ] = FALSE;
    if (( WindowIDCMP & IDCMP_MENUPICK ) == IDCMP_MENUPICK )
        id_Bools[ i++ ] = TRUE; else id_Bools[ i++ ] = FALSE;
    if (( WindowIDCMP & IDCMP_MENUVERIFY ) == IDCMP_MENUVERIFY )
        id_Bools[ i++ ] = TRUE; else id_Bools[ i++ ] = FALSE;
    if (( WindowIDCMP & IDCMP_CLOSEWINDOW ) == IDCMP_CLOSEWINDOW )
        id_Bools[ i++ ] = TRUE; else id_Bools[ i++ ] = FALSE;
    if (( WindowIDCMP & IDCMP_RAWKEY ) == IDCMP_RAWKEY )
        id_Bools[ i++ ] = TRUE; else id_Bools[ i++ ] = FALSE;
    if (( WindowIDCMP & IDCMP_NEWPREFS ) == IDCMP_NEWPREFS )
        id_Bools[ i++ ] = TRUE; else id_Bools[ i++ ] = FALSE;
    if (( WindowIDCMP & IDCMP_DISKINSERTED ) == IDCMP_DISKINSERTED )
        id_Bools[ i++ ] = TRUE; else id_Bools[ i++ ] = FALSE;
    if (( WindowIDCMP & IDCMP_DISKREMOVED ) == IDCMP_DISKREMOVED )
        id_Bools[ i++ ] = TRUE; else id_Bools[ i++ ] = FALSE;
    if (( WindowIDCMP & IDCMP_ACTIVEWINDOW ) == IDCMP_ACTIVEWINDOW )
        id_Bools[ i++ ] = TRUE; else id_Bools[ i++ ] = FALSE;
    if (( WindowIDCMP & IDCMP_INACTIVEWINDOW ) == IDCMP_INACTIVEWINDOW )
        id_Bools[ i++ ] = TRUE; else id_Bools[ i++ ] = FALSE;
    if (( WindowIDCMP & IDCMP_DELTAMOVE ) == IDCMP_DELTAMOVE )
        id_Bools[ i++ ] = TRUE; else id_Bools[ i++ ] = FALSE;
    if (( WindowIDCMP & IDCMP_VANILLAKEY ) == IDCMP_VANILLAKEY )
        id_Bools[ i++ ] = TRUE; else id_Bools[ i++ ] = FALSE;
    if (( WindowIDCMP & IDCMP_INTUITICKS ) == IDCMP_INTUITICKS )
        id_Bools[ i++ ] = TRUE; else id_Bools[ i++ ] = FALSE;
    if (( WindowIDCMP & IDCMP_IDCMPUPDATE ) == IDCMP_IDCMPUPDATE )
        id_Bools[ i++ ] = TRUE; else id_Bools[ i++ ] = FALSE;
    if (( WindowIDCMP & IDCMP_MENUHELP ) == IDCMP_MENUHELP )
        id_Bools[ i++ ] = TRUE; else id_Bools[ i++ ] = FALSE;
    if (( WindowIDCMP & IDCMP_CHANGEWINDOW ) == IDCMP_CHANGEWINDOW )
        id_Bools[ i++ ] = TRUE; else id_Bools[ i++ ] = FALSE;
}

/*
 * --- Set IDCMP flags
 */
void SetIDCMP( void )
{
    UWORD i = 0;

    WindowIDCMP = 0l;

    if ( id_Bools[ i++ ] ) WindowIDCMP |= IDCMP_SIZEVERIFY;
    if ( id_Bools[ i++ ] ) WindowIDCMP |= IDCMP_NEWSIZE;
    if ( id_Bools[ i++ ] ) WindowIDCMP |= IDCMP_REFRESHWINDOW;
    if ( id_Bools[ i++ ] ) WindowIDCMP |= IDCMP_MOUSEBUTTONS;
    if ( id_Bools[ i++ ] ) WindowIDCMP |= IDCMP_MOUSEMOVE;
    if ( id_Bools[ i++ ] ) WindowIDCMP |= IDCMP_GADGETDOWN;
    if ( id_Bools[ i++ ] ) WindowIDCMP |= IDCMP_GADGETUP;
    if ( id_Bools[ i++ ] ) WindowIDCMP |= IDCMP_REQSET;
    if ( id_Bools[ i++ ] ) WindowIDCMP |= IDCMP_REQCLEAR;
    if ( id_Bools[ i++ ] ) WindowIDCMP |= IDCMP_REQVERIFY;
    if ( id_Bools[ i++ ] ) WindowIDCMP |= IDCMP_MENUPICK;
    if ( id_Bools[ i++ ] ) WindowIDCMP |= IDCMP_MENUVERIFY;
    if ( id_Bools[ i++ ] ) WindowIDCMP |= IDCMP_CLOSEWINDOW;
    if ( id_Bools[ i++ ] ) WindowIDCMP |= IDCMP_RAWKEY;
    if ( id_Bools[ i++ ] ) WindowIDCMP |= IDCMP_NEWPREFS;
    if ( id_Bools[ i++ ] ) WindowIDCMP |= IDCMP_DISKINSERTED;
    if ( id_Bools[ i++ ] ) WindowIDCMP |= IDCMP_DISKREMOVED;
    if ( id_Bools[ i++ ] ) WindowIDCMP |= IDCMP_ACTIVEWINDOW;
    if ( id_Bools[ i++ ] ) WindowIDCMP |= IDCMP_INACTIVEWINDOW;
    if ( id_Bools[ i++ ] ) WindowIDCMP |= IDCMP_DELTAMOVE;
    if ( id_Bools[ i++ ] ) WindowIDCMP |= IDCMP_VANILLAKEY;
    if ( id_Bools[ i++ ] ) WindowIDCMP |= IDCMP_INTUITICKS;
    if ( id_Bools[ i++ ] ) WindowIDCMP |= IDCMP_IDCMPUPDATE;
    if ( id_Bools[ i++ ] ) WindowIDCMP |= IDCMP_MENUHELP;
    if ( id_Bools[ i++ ] ) WindowIDCMP |= IDCMP_CHANGEWINDOW;
}

/*
 * --- Display the IDCMP requester.
 */
long EditIDCMP( void )
{
    struct Gadget       *g;
    struct NewGadget     ng;
    BOOL                 running =  TRUE, OK = FALSE;
    WORD                 l, t, w, h, btop, bleft, idc = 0, top = 4;

    btop  = MainScreen->WBorTop + MainScreen->RastPort.TxHeight;
    bleft = MainScreen->WBorLeft;

    w = bleft + MainScreen->WBorRight  + 300;
    h = btop  + MainScreen->WBorBottom + 168;
    l = (( MainScreen->Width  >> 1 ) - ( w >> 1 ));
    t = (( MainScreen->Height >> 1 ) - ( h >> 1 ));

    id_Zoom[0] = 0;
    id_Zoom[1] = btop;
    id_Zoom[2] = 200;
    id_Zoom[3] = btop;

    id_nwTags[0].ti_Data = l;
    id_nwTags[1].ti_Data = t;
    id_nwTags[2].ti_Data = w;
    id_nwTags[3].ti_Data = h;

    id_nwTags[10].ti_Data = (Tag)MainScreen;

    if (( MainScreen->Flags & CUSTOMSCREEN) == CUSTOMSCREEN )
        id_nwTags[10].ti_Tag  = WA_CustomScreen;
    else if (( MainScreen->Flags & PUBLICSCREEN ) == PUBLICSCREEN )
        id_nwTags[10].ti_Tag  = WA_PubScreen;
    else
        id_nwTags[10].ti_Tag  = TAG_DONE;

    GetGadgetIDCMP();
    GetUserIDCMP();

    if ( g = CreateContext( &id_GList )) {

        ng.ng_LeftEdge      =   bleft + 125;
        ng.ng_TopEdge       =   btop + top;
        ng.ng_GadgetText    =   "SIZEVERIFY";
        ng.ng_TextAttr      =   &Topaz80;
        ng.ng_GadgetID      =   idc;
        ng.ng_Flags         =   PLACETEXT_LEFT;
        ng.ng_VisualInfo    =   MainVisualInfo;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        id_Gadgets[ idc++ ] = g;

        ng.ng_LeftEdge      =   bleft + 267;
        ng.ng_GadgetText    =   "NEWSIZE";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        id_Gadgets[ idc++ ] = g;

        top += 11;

        ng.ng_LeftEdge      =   bleft + 125;
        ng.ng_TopEdge       =   btop + top;
        ng.ng_GadgetText    =   "REFRESHWINDOW";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        id_Gadgets[ idc++ ] = g;

        ng.ng_LeftEdge      =   bleft + 267;
        ng.ng_GadgetText    =   "MOUSEBUTTONS";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        id_Gadgets[ idc++ ] = g;

        top += 11;

        ng.ng_LeftEdge      =   bleft + 125;
        ng.ng_TopEdge       =   btop + top;
        ng.ng_GadgetText    =   "MOUSEMOVE";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        id_Gadgets[ idc++ ] = g;

        ng.ng_LeftEdge      =   bleft + 267;
        ng.ng_GadgetText    =   "GADGETDOWN";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        id_Gadgets[ idc++ ] = g;

        top += 11;

        ng.ng_LeftEdge      =   bleft + 125;
        ng.ng_TopEdge       =   btop + top;
        ng.ng_GadgetText    =   "GADGETUP";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        id_Gadgets[ idc++ ] = g;

        ng.ng_LeftEdge      =   bleft + 267;
        ng.ng_GadgetText    =   "REQSET";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        id_Gadgets[ idc++ ] = g;

        top += 11;

        ng.ng_LeftEdge      =   bleft + 125;
        ng.ng_TopEdge       =   btop + top;
        ng.ng_GadgetText    =   "REQCLEAR";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        id_Gadgets[ idc++ ] = g;

        ng.ng_LeftEdge      =   bleft + 267;
        ng.ng_GadgetText    =   "REQVERIFY";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        id_Gadgets[ idc++ ] = g;

        top += 11;

        ng.ng_LeftEdge      =   bleft + 125;
        ng.ng_TopEdge       =   btop + top;
        ng.ng_GadgetText    =   "MENUPICK";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        id_Gadgets[ idc++ ] = g;

        ng.ng_LeftEdge      =   bleft + 267;
        ng.ng_GadgetText    =   "MENUVERIFY";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        id_Gadgets[ idc++ ] = g;

        top += 11;

        ng.ng_LeftEdge      =   bleft + 125;
        ng.ng_TopEdge       =   btop + top;
        ng.ng_GadgetText    =   "CLOSEWINDOW";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        id_Gadgets[ idc++ ] = g;

        ng.ng_LeftEdge      =   bleft + 267;
        ng.ng_GadgetText    =   "RAWKEY";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        id_Gadgets[ idc++ ] = g;

        top += 11;

        ng.ng_LeftEdge      =   bleft + 125;
        ng.ng_TopEdge       =   btop + top;
        ng.ng_GadgetText    =   "NEWPREFS";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        id_Gadgets[ idc++ ] = g;

        ng.ng_LeftEdge      =   bleft + 267;
        ng.ng_GadgetText    =   "DISKINSERTED";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        id_Gadgets[ idc++ ] = g;

        top += 11;

        ng.ng_LeftEdge      =   bleft + 125;
        ng.ng_TopEdge       =   btop + top;
        ng.ng_GadgetText    =   "DISKREMOVED";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        id_Gadgets[ idc++ ] = g;

        ng.ng_LeftEdge      =   bleft + 267;
        ng.ng_GadgetText    =   "ACTIVEWINDOW";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        id_Gadgets[ idc++ ] = g;

        top += 11;

        ng.ng_LeftEdge      =   bleft + 125;
        ng.ng_TopEdge       =   btop + top;
        ng.ng_GadgetText    =   "INACTIVEWINDOW";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        id_Gadgets[ idc++ ] = g;

        ng.ng_LeftEdge      =   bleft + 267;
        ng.ng_GadgetText    =   "DELTAMOVE";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        id_Gadgets[ idc++ ] = g;

        top += 11;

        ng.ng_LeftEdge      =   bleft + 125;
        ng.ng_TopEdge       =   btop + top;
        ng.ng_GadgetText    =   "VANILLAKEY";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        id_Gadgets[ idc++ ] = g;

        ng.ng_LeftEdge      =   bleft + 267;
        ng.ng_GadgetText    =   "INTUITICKS";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        id_Gadgets[ idc++ ] = g;

        top += 11;

        ng.ng_LeftEdge      =   bleft + 125;
        ng.ng_TopEdge       =   btop + top;
        ng.ng_GadgetText    =   "IDCMPUPDATE";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        id_Gadgets[ idc++ ] = g;

        ng.ng_LeftEdge      =   bleft + 267;
        ng.ng_GadgetText    =   "MENUHELP";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        id_Gadgets[ idc++ ] = g;

        top += 11;

        ng.ng_LeftEdge      =   bleft + 125;
        ng.ng_TopEdge       =   btop + top;
        ng.ng_GadgetText    =   "CHANGEWINDOW";
        ng.ng_GadgetID      =   idc;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, TAG_DONE );

        id_Gadgets[ idc++ ] = g;

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

            id_nwTags[6].ti_Data = (Tag)id_GList;

            if ( id_Wnd = OpenWindowTagList( NULL, id_nwTags )) {

                id_Zoom[0] = l;
                id_Zoom[1] = t;
                id_Zoom[2] = w;
                id_Zoom[3] = h;

                GT_RefreshWindow( id_Wnd, NULL );

                SetIDCMPGadgets();

                do {
                    WaitPort( id_Wnd->UserPort );

                    while ( ReadIMsg( id_Wnd )) {

                        switch ( Class ) {

                            case    IDCMP_REFRESHWINDOW:
                                GT_BeginRefresh( id_Wnd );
                                GT_EndRefresh( id_Wnd, TRUE );
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
                                if ( theObject-> GadgetID < 30 ) {
                                    FlipFlop( 0l, 0l, 0l, &id_Bools[ theObject->GadgetID ] );
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

    if ( OK )  {
        SetIDCMP();
        Saved = FALSE;
    }

    if ( id_Wnd )           CloseWindow( id_Wnd );
    if ( id_GList )         FreeGadgets( id_GList );

    id_Wnd   = 0l;
    id_GList = 0l;

    ClearMsgPort( MainWindow->UserPort );
}
