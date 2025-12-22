/*-- AutoRev header do NOT edit!
*
*   Program         :   WindowSpecial.c
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
*   29-Sep-91     1.00            Window Special requester.
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
extern BOOL              Saved;
extern UBYTE             MainWindowTitle[80], MainScreenTitle[80];

/*
 * --- Gadget ID
 */
#define GD_INNERW       0
#define GD_INNERH       1
#define GD_ZOOM         2
#define GD_MQUEUE       3
#define GD_KQUEUE       4
#define GD_ADJUST       5
#define GD_MENTER       6
#define GD_KENTER       7
#define GD_ZOOML        8
#define GD_ZOOMT        9
#define GD_ZOOMW        10
#define GD_ZOOMH        11
#define GD_WENTER       12
#define GD_HENTER       13
#define GD_WDTITLE      14
#define GD_SCTITLE      15
#define GD_OK           16
#define GD_CANCEL       17

/*
 * --- Module data.
 */
struct Window           *ws_Wnd   = NULL;
struct Gadget           *ws_GList = NULL;
struct Gadget           *ws_Gadgets[ 16 ];
WORD                     ws_Zoom[4];

BOOL                     ws_InnerW = FALSE, ws_InnerH = FALSE;
BOOL                     ws_ZoomF = FALSE, ws_MQueue = FALSE;
BOOL                     ws_RQueue = FALSE, ws_Adjust = FALSE;

WORD                     ws_ZLeft = 0, ws_ZTop = 0, ws_ZWidth = 200, ws_ZHeight = 0;
WORD                     ws_IWidth = 0, ws_IHeight = 0;
WORD                     ws_MQue = 1, ws_RQue = 1;

struct TagItem           ws_nwTags[] = {
    WA_Left,                0l,
    WA_Top,                 0l,
    WA_Width,               0l,
    WA_Height,              0l,
    WA_IDCMP,               IDCMP_CLOSEWINDOW | BUTTONIDCMP | CHECKBOXIDCMP | INTEGERIDCMP | IDCMP_VANILLAKEY | IDCMP_REFRESHWINDOW,
    WA_Flags,               WFLG_DRAGBAR | WFLG_DEPTHGADGET| WFLG_CLOSEGADGET | WFLG_ACTIVATE | WFLG_RMBTRAP | WFLG_SMART_REFRESH,
    WA_Gadgets,             0l,
    WA_Title,               (ULONG)"Edit Special Window Tags:",
    WA_AutoAdjust,          TRUE,
    WA_Zoom,                (Tag)ws_Zoom,
    TAG_DONE };

/*
 * --- Display the WindowSpecial requester.
 */
long WindowSpecial( void )
{
    struct Gadget       *g;
    struct NewGadget     ng;
    BOOL                 running = TRUE, OK = FALSE;
    WORD                 l, t, w, h, btop, bleft;
    BOOL                 InnerW, InnerH, ZoomF, MQueue, RQueue, Adjust;
    WORD                 MQue, RQue, Zl, Zt, Zw, Zh;

    InnerW = ws_InnerW;
    InnerH = ws_InnerH;
    ZoomF  = ws_ZoomF;
    MQueue = ws_MQueue;
    RQueue = ws_RQueue;
    Adjust = ws_Adjust;
    MQue   = ws_MQue;
    RQue   = ws_RQue;
    Zl     = ws_ZLeft;
    Zt     = ws_ZTop;
    Zw     = ws_ZWidth;
    Zh     = ws_ZHeight;

    btop  = MainScreen->WBorTop + MainScreen->RastPort.TxHeight;
    bleft = MainScreen->WBorLeft;

    w = bleft + MainScreen->WBorRight  + 300;
    h = btop  + MainScreen->WBorBottom + 169;
    l = (( MainScreen->Width  >> 1 ) - ( w >> 1 ));
    t = (( MainScreen->Height >> 1 ) - ( h >> 1 ));

    ws_Zoom[0] = 0;
    ws_Zoom[1] = btop;
    ws_Zoom[2] = 200;
    ws_Zoom[3] = btop;

    ws_nwTags[0].ti_Data = l;
    ws_nwTags[1].ti_Data = t;
    ws_nwTags[2].ti_Data = w;
    ws_nwTags[3].ti_Data = h;

    ws_nwTags[10].ti_Data = (Tag)MainScreen;

    if (( MainScreen->Flags & CUSTOMSCREEN) == CUSTOMSCREEN )
        ws_nwTags[10].ti_Tag  = WA_CustomScreen;
    else if (( MainScreen->Flags & PUBLICSCREEN ) == PUBLICSCREEN )
        ws_nwTags[10].ti_Tag  = WA_PubScreen;
    else
        ws_nwTags[10].ti_Tag  = TAG_DONE;

    ws_IWidth  = MainWindow->Width - MainWindow->BorderLeft - MainWindow->BorderRight;
    ws_IHeight = MainWindow->Height - MainWindow->BorderTop - MainWindow->BorderBottom;

    Zh = MainWindow->BorderTop;

    if ( g = CreateContext( &ws_GList )) {

        ng.ng_LeftEdge      =   bleft + 8;
        ng.ng_TopEdge       =   btop + 4;
        ng.ng_GadgetText    =   "Inner_Width";
        ng.ng_TextAttr      =   &Topaz80;
        ng.ng_GadgetID      =   GD_INNERW;
        ng.ng_Flags         =   PLACETEXT_RIGHT;
        ng.ng_VisualInfo    =   MainVisualInfo;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)InnerW, GT_Underscore, (Tag)'_', TAG_DONE );

        ws_Gadgets[ GD_INNERW ] = g;

        ng.ng_TopEdge       =   btop + 18;
        ng.ng_GadgetText    =   "Inner_Height";
        ng.ng_GadgetID      =   GD_INNERH;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)InnerH, GT_Underscore, (Tag)'_', TAG_DONE );

        ws_Gadgets[ GD_INNERH ] = g;

        ng.ng_TopEdge       =   btop + 32;
        ng.ng_GadgetText    =   "_MouseQueue";
        ng.ng_GadgetID      =   GD_MQUEUE;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)MQueue, GT_Underscore, (Tag)'_', TAG_DONE );

        ws_Gadgets[ GD_MQUEUE ] = g;

        ng.ng_TopEdge       =   btop + 46;
        ng.ng_GadgetText    =   "_RptQueue";
        ng.ng_GadgetID      =   GD_KQUEUE;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)RQueue, GT_Underscore, (Tag)'_', TAG_DONE );

        ws_Gadgets[ GD_KQUEUE ] = g;

        ng.ng_TopEdge       =   btop + 60;
        ng.ng_GadgetText    =   "_AutoAdjust";
        ng.ng_GadgetID      =   GD_ADJUST;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)Adjust, GT_Underscore, (Tag)'_', TAG_DONE );

        ws_Gadgets[ GD_ADJUST ] = g;

        ng.ng_TopEdge       =   btop + 74;
        ng.ng_GadgetText    =   "_Zoom";
        ng.ng_GadgetID      =   GD_ZOOM;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)ZoomF, GT_Underscore, (Tag)'_', TAG_DONE );

        ws_Gadgets[ GD_ZOOM ] = g;

        ng.ng_LeftEdge      =   bleft + 150;
        ng.ng_TopEdge       =   btop  + 3;
        ng.ng_Width         =   144;
        ng.ng_Height        =   12;
        ng.ng_GadgetText    =   0l;
        ng.ng_GadgetID      =   GD_WENTER;

        g = CreateGadget( NUMBER_KIND, g, &ng, GTNM_Number, (Tag)ws_IWidth, GTNM_Border, TRUE, TAG_DONE );

        ws_Gadgets[ GD_WENTER ] = g;

        ng.ng_TopEdge       =   btop  + 17;
        ng.ng_GadgetID      =   GD_HENTER;

        g = CreateGadget( NUMBER_KIND, g, &ng, GTNM_Number, (Tag)ws_IHeight, GTNM_Border, TRUE, TAG_DONE );

        ws_Gadgets[ GD_HENTER ] = g;

        ng.ng_TopEdge       =   btop  + 31;
        ng.ng_GadgetID      =   GD_MENTER;

        g = CreateGadget( INTEGER_KIND, g, &ng, GTIN_Number, (Tag)MQue, GTIN_MaxChars, 5l, TAG_DONE );

        SetStringGadget( g );

        ws_Gadgets[ GD_MENTER ] = g;

        ng.ng_TopEdge       =   btop  + 45;
        ng.ng_GadgetID      =   GD_KENTER;

        g = CreateGadget( INTEGER_KIND, g, &ng, GTIN_Number, (Tag)RQue, GTIN_MaxChars, 5l, TAG_DONE );

        SetStringGadget( g );

        ws_Gadgets[ GD_KENTER ] = g;

        ng.ng_TopEdge       =   btop  + 88;
        ng.ng_LeftEdge      =   bleft + 8;
        ng.ng_Width         =   88;
        ng.ng_GadgetID      =   GD_ZOOML;
        ng.ng_GadgetText    =   "Left";
        ng.ng_Flags         =   PLACETEXT_RIGHT;

        g = CreateGadget( INTEGER_KIND, g, &ng, GTIN_Number, (Tag)Zl, GTIN_MaxChars, 5l, TAG_DONE );

        SetStringGadget( g );

        ws_Gadgets[ GD_ZOOML ] = g;

        ng.ng_LeftEdge      =   bleft + 150;
        ng.ng_GadgetID      =   GD_ZOOMT;
        ng.ng_GadgetText    =   "Top";

        g = CreateGadget( INTEGER_KIND, g, &ng, GTIN_Number, (Tag)Zt, GTIN_MaxChars, 5l, TAG_DONE );

        SetStringGadget( g );

        ws_Gadgets[ GD_ZOOMT ] = g;

        ng.ng_LeftEdge      =   bleft + 8;
        ng.ng_TopEdge       =   btop + 104;
        ng.ng_GadgetID      =   GD_ZOOMW;
        ng.ng_GadgetText    =   "Width";

        g = CreateGadget( INTEGER_KIND, g, &ng, GTIN_Number, (Tag)Zw, GTIN_MaxChars, 5l, TAG_DONE );

        SetStringGadget( g );

        ws_Gadgets[ GD_ZOOMW ] = g;

        ng.ng_LeftEdge      =   bleft + 150;
        ng.ng_GadgetID      =   GD_ZOOMH;
        ng.ng_GadgetText    =   "Height";

        g = CreateGadget( INTEGER_KIND, g, &ng, GTIN_Number, (Tag)Zh, GTIN_MaxChars, 5l, TAG_DONE );

        SetStringGadget( g );

        ws_Gadgets[ GD_ZOOMH ] = g;

        ng.ng_TopEdge       =   btop + 120;
        ng.ng_LeftEdge      =   bleft + 150;
        ng.ng_Width         =   144;
        ng.ng_GadgetText    =   "Window_Title";
        ng.ng_Flags         =   PLACETEXT_LEFT;

        g = CreateGadget( STRING_KIND, g, &ng, GTST_String, MainWindowTitle, GTST_MaxChars, 80l, GT_Underscore, '_', TAG_DONE );

        SetStringGadget( g );

        ws_Gadgets[ GD_WDTITLE ] = g;

        ng.ng_TopEdge       =   btop + 136;
        ng.ng_GadgetText    =   "_ScreenTitle";
        ng.ng_GadgetID      =   GD_SCTITLE;

        g = CreateGadget( STRING_KIND, g, &ng, GTST_String, MainScreenTitle, GTST_MaxChars, 80l, GT_Underscore, '_', TAG_DONE );

        SetStringGadget( g );

        ws_Gadgets[ GD_SCTITLE ] = g;

        ng.ng_TopEdge       =   btop + 152;
        ng.ng_LeftEdge      =   bleft + 8;
        ng.ng_Width         =   60;
        ng.ng_Height        =   13;
        ng.ng_GadgetText    =   "_OK";
        ng.ng_GadgetID      =   GD_OK;
        ng.ng_Flags         =   PLACETEXT_IN;

        g = CreateGadget( BUTTON_KIND, g, &ng, GT_Underscore, (Tag)'_', TAG_DONE );

        ng.ng_LeftEdge      =   bleft + 232;
        ng.ng_GadgetText    =   "_CANCEL";
        ng.ng_GadgetID      =   GD_CANCEL;

        g = CreateGadget( BUTTON_KIND, g, &ng, GT_Underscore, (Tag)'_', TAG_DONE );

        if ( g ) {

            ws_nwTags[6].ti_Data = (Tag)ws_GList;

            if ( ws_Wnd = OpenWindowTagList( NULL, ws_nwTags )) {

                ws_Zoom[0] = l;
                ws_Zoom[1] = t;
                ws_Zoom[2] = w;
                ws_Zoom[3] = h;

                GT_RefreshWindow( ws_Wnd, NULL );

                EnableGadget( ws_Wnd, ws_Gadgets, GD_ZOOML, ZoomF );
                EnableGadget( ws_Wnd, ws_Gadgets, GD_ZOOMT, ZoomF );
                EnableGadget( ws_Wnd, ws_Gadgets, GD_ZOOMW, ZoomF );
                EnableGadget( ws_Wnd, ws_Gadgets, GD_ZOOMH, ZoomF );
                EnableGadget( ws_Wnd, ws_Gadgets, GD_MENTER, MQueue );
                EnableGadget( ws_Wnd, ws_Gadgets, GD_KENTER, RQueue );

                do {
                    WaitPort( ws_Wnd->UserPort );

                    while ( ReadIMsg( ws_Wnd )) {

                        switch ( Class ) {

                            case    IDCMP_REFRESHWINDOW:
                                GT_BeginRefresh( ws_Wnd );
                                GT_EndRefresh( ws_Wnd, TRUE );
                                break;

                            case    IDCMP_CLOSEWINDOW:
                                running = FALSE;
                                break;

                            case    IDCMP_VANILLAKEY:
                                switch ( Code ) {

                                    case    'w':
                                        FlipFlop( ws_Wnd, ws_Gadgets, GD_INNERW, &InnerW );
                                        break;

                                    case    'h':
                                        FlipFlop( ws_Wnd, ws_Gadgets, GD_INNERH, &InnerH );
                                        break;

                                    case    'm':
                                        FlipFlop( ws_Wnd, ws_Gadgets, GD_MQUEUE, &MQueue );
                                        goto Mouse;

                                    case    'r':
                                        FlipFlop( ws_Wnd, ws_Gadgets, GD_KQUEUE, &RQueue );
                                        goto Repeat;

                                    case    'a':
                                        FlipFlop( ws_Wnd, ws_Gadgets, GD_ADJUST, &Adjust );
                                        break;

                                    case    'z':
                                        FlipFlop( ws_Wnd, ws_Gadgets, GD_ZOOM, &ZoomF );
                                        goto zoom;
                                        break;

                                    case    't':
                                        ActivateGadget( ws_Gadgets[ GD_WDTITLE ], ws_Wnd, 0l );
                                        break;

                                    case    's':
                                        ActivateGadget( ws_Gadgets[ GD_SCTITLE ], ws_Wnd, 0l );
                                        break;

                                    case    'o':
                                        goto Ok;

                                    case    'c':
                                        goto Cancel;
                                }
                                break;

                            case    IDCMP_GADGETUP:
                                switch ( theObject->GadgetID ) {

                                    case    GD_INNERW:
                                        FlipFlop( 0l, 0l, 0l, &InnerW );
                                        break;

                                    case    GD_INNERH:
                                        FlipFlop( 0l, 0l, 0l, &InnerH );
                                        break;

                                    case    GD_ZOOM:
                                        FlipFlop( 0l, 0l, 0l, &ZoomF );
                                        zoom:
                                        EnableGadget( ws_Wnd, ws_Gadgets, GD_ZOOML, ZoomF );
                                        EnableGadget( ws_Wnd, ws_Gadgets, GD_ZOOMT, ZoomF );
                                        EnableGadget( ws_Wnd, ws_Gadgets, GD_ZOOMW, ZoomF );
                                        EnableGadget( ws_Wnd, ws_Gadgets, GD_ZOOMH, ZoomF );
                                        if ( ZoomF )
                                            ActivateGadget( ws_Gadgets[ GD_ZOOML ], ws_Wnd, 0l );
                                        break;

                                    case    GD_MQUEUE:
                                        FlipFlop( 0l, 0l, 0l, &MQueue );
                                        Mouse:
                                        EnableGadget( ws_Wnd, ws_Gadgets, GD_MENTER, MQueue );
                                        if ( MQueue )
                                            ActivateGadget( ws_Gadgets[ GD_MENTER ], ws_Wnd, 0l );
                                        break;

                                    case    GD_KQUEUE:
                                        FlipFlop( 0l, 0l, 0l, &RQueue );
                                        Repeat:
                                        EnableGadget( ws_Wnd, ws_Gadgets, GD_KENTER, RQueue );
                                        if ( RQueue )
                                            ActivateGadget( ws_Gadgets[ GD_KENTER ], ws_Wnd, 0l );
                                        break;

                                    case    GD_ADJUST:
                                        FlipFlop( 0l, 0l, 0l, &Adjust );
                                        break;

                                    case    GD_OK:
                                        Ok:
                                        OK = TRUE;
                                        running = FALSE;
                                        break;

                                    case    GD_CANCEL:
                                        Cancel:
                                        running = FALSE;
                                        break;

                                    case    GD_MENTER:
                                        MQue = (( struct StringInfo * )ws_Gadgets[ GD_MENTER ]->SpecialInfo )->LongInt;

                                        if ( MQue < 1 ) {
                                            MQue = 1;
                                            DisplayBeep( MainScreen );
                                            GT_SetGadgetAttrs( ws_Gadgets[ GD_MENTER ], ws_Wnd, 0l, GTIN_Number, (Tag)MQue, TAG_DONE );
                                        }
                                        break;

                                    case    GD_KENTER:
                                        RQue = (( struct StringInfo * )ws_Gadgets[ GD_KENTER ]->SpecialInfo )->LongInt;

                                        if ( RQue < 1 ) {
                                            RQue = 1;
                                            DisplayBeep( MainScreen );
                                            GT_SetGadgetAttrs( ws_Gadgets[ GD_KENTER ], ws_Wnd, 0l, GTIN_Number, (Tag)RQue, TAG_DONE );
                                        }
                                        break;
                                }
                                break;
                        }
                    }
                } while ( running );
            }
        }
    }

    if ( ws_Wnd )           CloseWindow( ws_Wnd );
    if ( ws_GList )         FreeGadgets( ws_GList );

    ws_Wnd   = 0l;
    ws_GList = 0l;

    if ( OK ) {
        ws_InnerW  = InnerW;
        ws_InnerH  = InnerH;
        ws_ZoomF   = ZoomF;
        ws_MQueue  = MQueue;
        ws_RQueue  = RQueue;
        ws_Adjust  = Adjust;
        ws_MQue    = MQue;
        ws_RQue    = RQue;
        ws_ZLeft   = Zl;
        ws_ZTop    = Zt;
        ws_ZWidth  = Zw;
        ws_ZHeight = Zh;
        strcpy( MainWindowTitle, (( struct StringInfo * )ws_Gadgets[ GD_WDTITLE ]->SpecialInfo )->Buffer );
        strcpy( MainScreenTitle, (( struct StringInfo * )ws_Gadgets[ GD_SCTITLE ]->SpecialInfo )->Buffer );
        SetWindowTitles( MainWindow, MainWindowTitle, MainScreenTitle );
        Saved = FALSE;
    }

    ClearMsgPort( MainWindow->UserPort );
}
