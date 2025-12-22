/*-- AutoRev header do NOT edit!
*
*   Program         :   About.c
*   Copyright       :   © Copyright 1991 Jaba Development
*   Author          :   Jan van den Baard
*   Creation Date   :   29-Sep-91
*   Current version :   1.00
*   Translator      :   DICE v2.6
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   29-Sep-91     1.00            About requester.
*
*-- REV_END --*/

#include	"defs.h"

/*
 * --- External referenced data.
 */
extern ULONG             Class;
extern UWORD             Code;
extern struct TextAttr   Topaz80;
extern APTR              MainVisualInfo;
extern struct Screen    *MainScreen;
extern struct Window    *MainWindow;
extern struct Gadget    *theObject;

/*
 * --- Gadget ID
 */
#define GD_CONTINUE      0

/*
 * --- Module data.
 */
struct Window           *ab_Wnd   = NULL;
struct Gadget           *ab_GList = NULL;

WORD                     ab_Zoom[4];

struct TagItem           ab_nwTags[] = {
    WA_Left,                0l,
    WA_Top,                 0l,
    WA_Width,               0l,
    WA_Height,              0l,
    WA_IDCMP,               IDCMP_CLOSEWINDOW | BUTTONIDCMP | IDCMP_VANILLAKEY | IDCMP_REFRESHWINDOW,
    WA_Flags,               WFLG_DRAGBAR | WFLG_DEPTHGADGET| WFLG_CLOSEGADGET | WFLG_ACTIVATE | WFLG_RMBTRAP | WFLG_SMART_REFRESH,
    WA_Gadgets,             0l,
    WA_Title,               (ULONG)"GadToolsBox v1.0",
    WA_AutoAdjust,          TRUE,
    WA_Zoom,                (Tag)ab_Zoom,
    WA_CustomScreen,        0l,
    TAG_DONE };

/*
 * --- Print the About info using PrintIText so that I
 * --- can use the topaz 8 font no matter what font  might
 * --- be used on the screen.
 */
void PrintAbout( WORD l, WORD t )
{
    struct IntuiText     it;
    struct RastPort     *rp = ab_Wnd->RPort;
    UBYTE                buf[40];

    it.LeftEdge         = l + 18;
    it.TopEdge          = t + 4;
    it.DrawMode         = JAM1;
    it.FrontPen         = 1;
    it.ITextFont        = &Topaz80;
    it.IText            = "© Copyright 1991 Jaba Development";
    it.NextText         = 0l;

    PrintIText( rp, &it, 0, 0 );

    it.LeftEdge         = l + 46;
    it.TopEdge          = t + 14;
    it.IText            = "Written using DICE v2.6 by";

    PrintIText( rp, &it, 0, 0 );

    it.LeftEdge         = l + 82;
    it.TopEdge          = t + 24;
    it.IText            = "Jan van den Baard";

    PrintIText( rp, &it, 0, 0 );

    sprintf( buf, "Free CHIP : %4.4ld KBytes.", AvailMem( MEMF_CHIP ) / 1024 );

    it.LeftEdge         = l + 54;
    it.TopEdge          = t + 34;
    it.IText            = buf;

    PrintIText( rp, &it, 0, 0 );

    sprintf( buf, "Free FAST : %4.4ld KBytes.", AvailMem( MEMF_FAST ) / 1024 );

    it.TopEdge          = t + 44;
    it.IText            = buf;

    PrintIText( rp, &it, 0, 0 );
}

/*
 * --- Display the About requester.
 */
void About( void )
{
    struct Gadget       *g;
    struct NewGadget     ng;
    BOOL                 running =  TRUE;
    WORD                 l, t, w, h, btop, bleft;

    btop  = MainScreen->WBorTop + MainScreen->RastPort.TxHeight;
    bleft = MainScreen->WBorLeft;

    w = bleft + MainScreen->WBorRight  + 300;
    h = btop  + MainScreen->WBorBottom + 70;
    l = (( MainScreen->Width  >> 1 ) - ( w >> 1 ));
    t = (( MainScreen->Height >> 1 ) - ( h >> 1 ));

    ab_Zoom[0] = 0;
    ab_Zoom[1] = btop;
    ab_Zoom[2] = 200;
    ab_Zoom[3] = btop;

    ab_nwTags[0].ti_Data = l;
    ab_nwTags[1].ti_Data = t;
    ab_nwTags[2].ti_Data = w;
    ab_nwTags[3].ti_Data = h;

    ab_nwTags[10].ti_Data = (Tag)MainScreen;

    if (( MainScreen->Flags & CUSTOMSCREEN) == CUSTOMSCREEN )
        ab_nwTags[10].ti_Tag  = WA_CustomScreen;
    else if (( MainScreen->Flags & PUBLICSCREEN ) == PUBLICSCREEN )
        ab_nwTags[10].ti_Tag  = WA_PubScreen;
    else
        ab_nwTags[10].ti_Tag  = TAG_DONE;

    if ( g = CreateContext( &ab_GList )) {

        ng.ng_LeftEdge      =   bleft + 100;
        ng.ng_TopEdge       =   btop + 54;
        ng.ng_Width         =   100;
        ng.ng_Height        =   12;
        ng.ng_GadgetText    =   "_CONTINUE";
        ng.ng_TextAttr      =   &Topaz80;
        ng.ng_GadgetID      =   GD_CONTINUE;
        ng.ng_Flags         =   PLACETEXT_IN;
        ng.ng_VisualInfo    =   MainVisualInfo;

        g = CreateGadget( BUTTON_KIND, g, &ng, GT_Underscore, (Tag)'_', TAG_DONE );

        if ( g ) {

            ab_nwTags[6].ti_Data = (Tag)ab_GList;

            if ( ab_Wnd = OpenWindowTagList( NULL, ab_nwTags )) {

                ab_Zoom[0] = l;
                ab_Zoom[1] = t;
                ab_Zoom[2] = w;
                ab_Zoom[3] = h;

                GT_RefreshWindow( ab_Wnd, NULL );

                PrintAbout( bleft, btop );

                do {
                    WaitPort( ab_Wnd->UserPort );

                    while ( ReadIMsg( ab_Wnd )) {

                        switch ( Class ) {

                            case    IDCMP_REFRESHWINDOW:
                                GT_BeginRefresh( ab_Wnd );
                                PrintAbout( bleft, btop );
                                GT_EndRefresh( ab_Wnd, TRUE );
                                break;

                            case    IDCMP_CLOSEWINDOW:
                                running = FALSE;
                                break;

                            case    IDCMP_VANILLAKEY:
                                switch( Code ) {

                                    case    'c':
                                        running = FALSE;
                                        break;
                                }
                                break;

                            case    IDCMP_GADGETUP:
                                switch ( theObject->GadgetID ) {

                                    case    GD_CONTINUE:
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

    if ( ab_Wnd )           CloseWindow( ab_Wnd );
    if ( ab_GList )         FreeGadgets( ab_GList );

    ab_Wnd   = 0l;
    ab_GList = 0l;

    ClearMsgPort( MainWindow->UserPort );
}
