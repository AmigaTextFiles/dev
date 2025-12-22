/*-- AutoRev header do NOT edit!
*
*   Program         :   ScreenSelect.c
*   Copyright       :   © Copyright 1991 Jaba Development
*   Author          :   Jan van den Baard
*   Creation Date   :   01-Oct-91
*   Current version :   1.00
*   Translator      :   DICE v2.6
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   01-Oct-91     1.00            Screen type requester.
*
*-- REV_END --*/

#include	"defs.h"

/*
 * --- External referenced data
 */
extern ULONG                Class;
extern UWORD                Code;
extern struct Gadget       *theObject;
extern APTR                 MainVisualInfo;
extern struct TextAttr      Topaz80;
extern struct TagItem       MainSTags[];
extern struct Screen       *MainScreen;

/*
 * --- Gadget ID's
 */
#define GD_MODESELECT       0
#define GD_DEPTH            1
#define GD_OK               2
#define GD_CANCEL           3

/*
 * --- Module data
 */
struct Window              *sc_Wnd    = NULL;
struct Gadget              *sc_GList  = NULL;
struct Gadget              *sc_Slider = NULL;
struct List                 sc_AvailModes;
UWORD                       sc_ActiveMode = 1;

WORD                        sc_Zoom[4];

UWORD                       sc_Depth = 2l, sc_Width = 640, sc_Height;
ULONG                       sc_DisplayID = DEFAULT_MONITOR_ID | HIRES_KEY;

struct TagItem              sc_nwTags[] = {
    WA_Left,                0l,
    WA_Top,                 0l,
    WA_Width,               0l,
    WA_Height,              0l,
    WA_IDCMP,               IDCMP_CLOSEWINDOW | LISTVIEWIDCMP | SLIDERIDCMP | BUTTONIDCMP | IDCMP_REFRESHWINDOW | IDCMP_VANILLAKEY,
    WA_Flags,               WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_CLOSEGADGET | WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_RMBTRAP,
    WA_Gadgets,             0l,
    WA_Title,               (ULONG)"Edit screen type:",
    WA_AutoAdjust,          TRUE,
    WA_Zoom,                (Tag)sc_Zoom,
    WA_CustomScreen,        0l,
    TAG_DONE };

UBYTE                       *sc_PalMon[] = {
    "PAL Lores", "PAL Hires", "PAL Superhires",
    "PAL Lores Interlaced", "PAL Hires Interlaced",
    "PAL Superhires Interlaced"  };
UBYTE                       *sc_NtscMon[] = {
    "NTSC Lores", "NTSC Hires", "NTSC Superhires",
    "NTSC Lores Interlaced", "NTSC Hires Interlaced",
    "NTSC Superhires Interlaced"  };

/*
 * --- This routine looks for the availability of the
 * --- LORES, HIRES and SUPERHIRES displaymodes and the
 * --- LACE versions too. If found they will be added to
 * --- the list for the ListView gadget.
 */
long GetModes( long monitor )
{
    UBYTE                 **mon, c = 0;
    WORD                    maxn, maxl;
    struct ListViewNode    *node;

    if ( monitor == PAL_MONITOR_ID ) {
        mon  = sc_PalMon;
        maxn = 256;
        maxl = 512;
    } else {
        mon  = sc_NtscMon;
        maxn = 200;
        maxl = 400;
    }

    if ( NOT ModeNotAvailable( monitor | LORES_KEY )) {
        if( NOT( node = MakeNode( mon[c++] )))
            return FALSE;
        node->ln_UserData[0] = monitor | LORES_KEY;
        node->ln_UserData[1] = 5;
        node->ln_UserData[2] = 320;
        node->ln_UserData[3] = maxn;
        AddTail( &sc_AvailModes, (struct Node *)node );
    } else c++;
    if ( NOT ModeNotAvailable( monitor | HIRES_KEY )) {
        if( NOT( node = MakeNode( mon[c++] )))
            return FALSE;
        node->ln_UserData[0] = monitor | HIRES_KEY;
        node->ln_UserData[1] = 4;
        node->ln_UserData[2] = 640;
        node->ln_UserData[3] = maxn;
        AddTail( &sc_AvailModes, (struct Node *)node );
    } else c++;
    if ( NOT ModeNotAvailable( monitor | SUPER_KEY )) {
        if( NOT( node = MakeNode( mon[c++] )))
            return FALSE;
        node->ln_UserData[0] = monitor | SUPER_KEY;
        node->ln_UserData[1] = 2;
        node->ln_UserData[2] = 1280;
        node->ln_UserData[3] = maxn;
        AddTail( &sc_AvailModes, (struct Node *)node );
    } else c++;
    if ( NOT ModeNotAvailable( monitor | LORESLACE_KEY )) {
        if( NOT( node = MakeNode( mon[c++] )))
            return FALSE;
        node->ln_UserData[0] = monitor | LORESLACE_KEY;
        node->ln_UserData[1] = 5;
        node->ln_UserData[2] = 320;
        node->ln_UserData[3] = maxl;
        AddTail( &sc_AvailModes, (struct Node *)node );
    } else c++;
    if ( NOT ModeNotAvailable( monitor | HIRESLACE_KEY )) {
        if( NOT( node = MakeNode( mon[c++] )))
            return FALSE;
        node->ln_UserData[0] = monitor | HIRESLACE_KEY;
        node->ln_UserData[1] = 4;
        node->ln_UserData[2] = 640;
        node->ln_UserData[3] = maxl;
        AddTail( &sc_AvailModes, (struct Node *)node );
    } else c++;
    if ( NOT ModeNotAvailable( monitor | SUPERLACE_KEY )) {
        if( NOT( node = MakeNode( mon[c++] )))
            return FALSE;
        node->ln_UserData[0] = monitor | SUPERLACE_KEY;
        node->ln_UserData[1] = 2;
        node->ln_UserData[2] = 1280;
        node->ln_UserData[3] = maxl;
        AddTail( &sc_AvailModes, (struct Node *)node );
    }
    return TRUE;
}

/*
 * --- This routine call's GetModes() for both the PAL
 * --- and NTSC monitor ID's.
 */
long CheckModes( struct Screen *scr )
{
    struct ListViewNode     *node;
    struct ViewPort         *vp = &scr->ViewPort;
    UWORD                    num = 0l;

    NewList( &sc_AvailModes );

    if ( NOT GetModes( PAL_MONITOR_ID ) || NOT GetModes( NTSC_MONITOR_ID )) {
        FreeList( &sc_AvailModes );
        return FALSE;
    }


    for ( node = ( struct ListViewNode * )sc_AvailModes.lh_Head; node->ln_Succ; node = node->ln_Succ ) {
        if ( GetVPModeID( vp ) == node->ln_UserData[0] ) {
            sc_ActiveMode = num;
            break;
        }
        num++;
    }

    return TRUE;
}

/*
 * --- Open the ScreenSelect() requester.
 */
long ScreenSelect( void )
{
    struct ListViewNode *node;
    struct Gadget       *g;
    struct Screen       *scr;
    struct NewGadget     ng;
    BOOL                 running = TRUE, lock = FALSE, ok = FALSE;
    WORD                 l, t, w, h, btop, bleft;


    if ( NOT MainScreen ) {
        if( scr = LockPubScreen( 0l )) {
            lock = TRUE;
            GetScreenInfo( scr );
        } else
            return FALSE;
    } else
        scr = MainScreen;

    if ( NOT CheckModes( scr ))
        return FALSE;

    btop  = scr->WBorTop + 1 + scr->RastPort.TxHeight;
    bleft = scr->WBorLeft;

    w = bleft + scr->WBorRight  + 298;
    h = btop  + scr->WBorBottom + 106;
    l = (( scr->Width  >> 1 ) - ( w >> 1 ));
    t = (( scr->Height >> 1 ) - ( h >> 1 ));

    sc_Zoom[0] = 0;
    sc_Zoom[1] = btop;
    sc_Zoom[2] = 200;
    sc_Zoom[3] = btop;

    sc_nwTags[0].ti_Data = l;
    sc_nwTags[1].ti_Data = t;
    sc_nwTags[2].ti_Data = w;
    sc_nwTags[3].ti_Data = h;

    sc_nwTags[10].ti_Data = (Tag)scr;

    if (( scr->Flags & CUSTOMSCREEN ) == CUSTOMSCREEN )
        sc_nwTags[10].ti_Tag  = WA_CustomScreen;
    else if (( scr->Flags & PUBLICSCREEN ) == PUBLICSCREEN )
        sc_nwTags[10].ti_Tag  = WA_PubScreen;
    else
        sc_nwTags[10].ti_Tag = TAG_DONE;

    node = FindNode( &sc_AvailModes, sc_ActiveMode );
    sc_DisplayID  = node->ln_UserData[0];
    sc_Width      = node->ln_UserData[2];
    sc_Height     = node->ln_UserData[3];

    sc_Depth = scr->BitMap.Depth;

    if ( g = CreateContext( &sc_GList ))  {

        ng.ng_LeftEdge      =   bleft + 8;
        ng.ng_TopEdge       =   btop + 16;
        ng.ng_Width         =   284;
        ng.ng_Height        =   60;
        ng.ng_GadgetText    =   "Available modes:";
        ng.ng_TextAttr      =   &Topaz80;
        ng.ng_GadgetID      =   GD_MODESELECT;
        ng.ng_Flags         =   PLACETEXT_ABOVE;
        ng.ng_VisualInfo    =   MainVisualInfo;
        ng.ng_UserData      =   0l;

        g = CreateGadget( LISTVIEW_KIND, g, &ng, GTLV_Selected, sc_ActiveMode, GTLV_ShowSelected, 0l, GTLV_Labels, &sc_AvailModes, TAG_DONE );

        ng.ng_LeftEdge      =   bleft + 79;
        ng.ng_TopEdge       =   btop + 76;
        ng.ng_Width         =   213;
        ng.ng_Height        =   10;
        ng.ng_GadgetText    =   "Depth   ";
        ng.ng_GadgetID      =   GD_DEPTH;
        ng.ng_Flags         =   PLACETEXT_LEFT + NG_HIGHLABEL;

        g = CreateGadget( SLIDER_KIND, g, &ng, GTSL_LevelFormat, "%1ld", GTSL_MaxLevelLen, 1l, GTSL_Min, 1l, GTSL_Max, 4l, GTSL_Level, sc_Depth, TAG_DONE );

        sc_Slider = g;

        ng.ng_LeftEdge      =   bleft  +  8;
        ng.ng_TopEdge       =   btop + 90;
        ng.ng_Width         =   60;
        ng.ng_Height        =   12;
        ng.ng_GadgetText    =   "_OK";
        ng.ng_Flags         =   PLACETEXT_IN;
        ng.ng_GadgetID      =   GD_OK;

        g = CreateGadget( BUTTON_KIND, g, &ng, GT_Underscore, '_', TAG_DONE );

        ng.ng_LeftEdge      =   236;
        ng.ng_GadgetText    =   "_CANCEL";
        ng.ng_GadgetID      =   GD_CANCEL;

        g = CreateGadget( BUTTON_KIND, g, &ng, GT_Underscore, '_', TAG_DONE );

        if ( g ) {

            sc_nwTags[6].ti_Data = (Tag)sc_GList;

            if ( sc_Wnd = OpenWindowTagList( 0l, sc_nwTags )) {

                sc_Zoom[0] = l;
                sc_Zoom[1] = t;
                sc_Zoom[2] = w;
                sc_Zoom[3] = h;

                GT_RefreshWindow( sc_Wnd, 0l );

                do {
                    WaitPort( sc_Wnd->UserPort );

                    while ( ReadIMsg( sc_Wnd )) {

                        switch ( Class ) {

                            case    IDCMP_REFRESHWINDOW:
                                GT_BeginRefresh( sc_Wnd );
                                GT_EndRefresh( sc_Wnd, TRUE );
                                break;

                            case    IDCMP_CLOSEWINDOW:
                                FreeList( &sc_AvailModes );
                                running = FALSE;
                                break;

                            case    IDCMP_MOUSEMOVE:
                                switch( theObject->GadgetID ) {

                                    case    GD_DEPTH:
                                        sc_Depth = Code;
                                        break;
                                }
                                break;

                            case    IDCMP_GADGETUP:
                                switch( theObject->GadgetID ) {

                                    case    GD_MODESELECT:
                                        node = FindNode( &sc_AvailModes, Code );
                                        sc_DisplayID  = node->ln_UserData[0];
                                        sc_Depth      = node->ln_UserData[1];
                                        sc_Width      = node->ln_UserData[2];
                                        sc_Height     = node->ln_UserData[3];
                                        GT_SetGadgetAttrs( sc_Slider, sc_Wnd, 0l, GTSL_Min, 1l, GTSL_Max, sc_Depth, GTSL_Level, sc_Depth, TAG_DONE );
                                        sc_ActiveMode = Code;
                                        break;

                                    case    GD_OK:
                                        Ok:
                                        ok = TRUE;

                                    case    GD_CANCEL:
                                        Cancel:
                                        FreeList( &sc_AvailModes );
                                        running = FALSE;
                                        break;
                                }
                                break;

                            case    IDCMP_VANILLAKEY:
                                switch( Code ) {

                                    case    'o':
                                        goto Ok;

                                    case    'c':
                                        goto Cancel;
                                }
                                break;
                        }
                    }
                } while ( running );
            }
        }
    }

    if ( sc_Wnd )           CloseWindow( sc_Wnd );
    if ( sc_GList )         FreeGadgets( sc_GList );
    if ( lock ) {
        FreeScreenInfo( scr );
        UnlockPubScreen( 0l, scr );
    }

    sc_Wnd     = 0l;
    sc_GList   =  0l;

    if ( ok ) {
        MainSTags[2].ti_Data = (Tag)sc_Width;
        MainSTags[3].ti_Data = (Tag)sc_Height;
        MainSTags[4].ti_Data = (Tag)sc_Depth;
        MainSTags[5].ti_Data = (Tag)sc_DisplayID;
        return TRUE;
    }

    return FALSE;
}
