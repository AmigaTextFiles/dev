/*-- AutoRev header do NOT edit!
*
*   Program         :   SetPalette.c
*   Copyright       :   © Copyright 1991 Jaba Development
*   Author          :   Jan van den Baard
*   Creation Date   :   22-Sep-91
*   Current version :   1.00
*   Translator      :   DICE v2.6
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   22-Sep-91     1.00            Screen palette editor.
*
*-- REV_END --*/

#include	"defs.h"

/*
 * --- External refrenced data.
 */
extern ULONG             Class;
extern UWORD             Code;
extern struct Gadget    *theObject;
extern APTR              MainVisualInfo;
extern struct TextAttr   Topaz80;
extern struct Screen    *MainScreen;
extern struct Window    *MainWindow;
extern struct ColorSpec  MainColors[33];
extern BOOL              Saved;

/*
 * --- Palette window gadget ID's
 */
#define GD_RED           0
#define GD_GREEN         1
#define GD_BLUE          2
#define GD_PALETTE       3
#define GD_OK            4
#define GD_RESET         5
#define GD_CANCEL        6

/*
 * --- Program gadget pointers that needs to be changed.
 */
struct Gadget           *sp_Red, *sp_Green, *sp_Blue, *sp_Palette;

struct Window           *sp_Wnd   = NULL;
struct Gadget           *sp_GList = NULL;
UWORD                    sp_Orig[32];
UWORD                    sp_Rc, sp_Gc, sp_Bc;
WORD                     sp_Zoom[4];

/*
 * --- TagItems for the palette window.
 */
struct TagItem  sp_nwTags[] = {
    WA_Left,                0l,
    WA_Top,                 0l,
    WA_Width,               0l,
    WA_Height,              0l,
    WA_IDCMP,               IDCMP_CLOSEWINDOW | SLIDERIDCMP | PALETTEIDCMP | BUTTONIDCMP | IDCMP_REFRESHWINDOW | IDCMP_VANILLAKEY,
    WA_Flags,               WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_CLOSEGADGET | WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_RMBTRAP,
    WA_Gadgets,             0l,
    WA_Title,               (ULONG)"Screen Palette",
    WA_AutoAdjust,          TRUE,
    WA_Zoom,                (Tag)sp_Zoom,
    WA_CustomScreen,        0l,
    TAG_DONE };

/*
 * --- TagItems for the slider gadgets.
 */
struct TagItem  sp_PTags[] = {
    GTSL_LevelFormat,       (ULONG)"%2ld",
    GTSL_MaxLevelLen,       2L,
    TAG_DONE };

/*
 * --- Set the slider levels accoording to color register 'reg'.
 */
void SetProp( long reg )
{
    UWORD   r, g, b, col;

    col = GetRGB4( MainScreen->ViewPort.ColorMap, reg );

    r = sp_Rc = (( col >> 8 ) & 0x0f );
    g = sp_Gc = (( col >> 4 ) & 0x0f );
    b = sp_Bc = ( col & 0x0f );

    GT_SetGadgetAttrs( sp_Red,   sp_Wnd, NULL, GTSL_Level, r, TAG_DONE );
    GT_SetGadgetAttrs( sp_Green, sp_Wnd, NULL, GTSL_Level, g, TAG_DONE );
    GT_SetGadgetAttrs( sp_Blue,  sp_Wnd, NULL, GTSL_Level, b, TAG_DONE );
}

/*
 * --- Open the palette editor and wait for user input.
 */
long SetPalette( void )
{
    struct Gadget       *g;
    struct NewGadget     ng;
    BOOL                 running  = TRUE;
    WORD                 reg = 0, l, t, w, h, btop, bleft, r;
    UWORD                col;

    btop  = MainScreen->WBorTop + 1 + MainScreen->RastPort.TxHeight;
    bleft = MainScreen->WBorLeft;

    w = bleft + MainScreen->WBorRight  + 302;
    h = btop  + MainScreen->WBorBottom + 94;
    l = (( MainScreen->Width  >> 1 ) - ( w >> 1 ));
    t = (( MainScreen->Height >> 1 ) - ( h >> 1 ));

    sp_Zoom[0] = 0;
    sp_Zoom[1] = btop;
    sp_Zoom[2] = 200;
    sp_Zoom[3] = btop;

    sp_nwTags[0].ti_Data = l;
    sp_nwTags[1].ti_Data = t;
    sp_nwTags[2].ti_Data = w;
    sp_nwTags[3].ti_Data = h;

    sp_nwTags[10].ti_Data = (Tag)MainScreen;

    if (( MainScreen->Flags & CUSTOMSCREEN ) == CUSTOMSCREEN )
        sp_nwTags[10].ti_Tag  = WA_CustomScreen;
    else if (( MainScreen->Flags & PUBLICSCREEN ) == PUBLICSCREEN )
        sp_nwTags[10].ti_Tag  = WA_PubScreen;
    else
        sp_nwTags[10].ti_Tag = TAG_DONE;

    for ( r = 0; r < ( 1L << MainScreen->BitMap.Depth ); r++ )
        sp_Orig[r] = GetRGB4( MainScreen->ViewPort.ColorMap, (long)r );

    if ( g = CreateContext( &sp_GList )) {

        ng.ng_LeftEdge      =   bleft + 79;
        ng.ng_TopEdge       =   btop + 3;
        ng.ng_Width         =   216;
        ng.ng_Height        =   10;
        ng.ng_GadgetText    =   "Red     ";
        ng.ng_TextAttr      =   &Topaz80;
        ng.ng_GadgetID      =   GD_RED;
        ng.ng_Flags         =   PLACETEXT_LEFT | NG_HIGHLABEL;
        ng.ng_VisualInfo    =   MainVisualInfo;
        ng.ng_UserData      =   NULL;

        g = CreateGadgetA( SLIDER_KIND, g, &ng, sp_PTags );

        sp_Red = g;

        ng.ng_TopEdge       =   btop + 17;
        ng.ng_GadgetText    =   "Green   ";
        ng.ng_GadgetID      =   GD_GREEN;

        g = CreateGadgetA( SLIDER_KIND, g, &ng, sp_PTags );

        sp_Green = g;

        ng.ng_TopEdge       =  btop +  31;
        ng.ng_GadgetText    =   "Blue    ";
        ng.ng_GadgetID      =  GD_BLUE;

        g = CreateGadgetA( SLIDER_KIND, g, &ng, sp_PTags);

        sp_Blue  = g;

        ng.ng_LeftEdge      =  bleft + 7;
        ng.ng_TopEdge       =  btop + 45;
        ng.ng_Width         =  288;
        ng.ng_Height        =  30;
        ng.ng_GadgetText    =  0L;
        ng.ng_GadgetID      =  GD_PALETTE;
        ng.ng_Flags         =  0;

        g = CreateGadget( PALETTE_KIND, g, &ng, GTPA_Depth, (Tag)MainScreen->BitMap.Depth, GTPA_IndicatorWidth, 64l, GTPA_Color, (Tag)reg, TAG_DONE );

        ng.ng_TopEdge       =   btop + 79;
        ng.ng_Width         =   64;
        ng.ng_Height        =   12;
        ng.ng_GadgetText    =   "_OK";
        ng.ng_GadgetID      =   GD_OK;
        ng.ng_Flags         =   PLACETEXT_IN;

        g = CreateGadget( BUTTON_KIND, g, &ng, GT_Underscore, (Tag)'_', TAG_DONE );

        ng.ng_LeftEdge      =   bleft + 120;
        ng.ng_GadgetText    =   "_Reset";
        ng.ng_GadgetID      =   GD_RESET;

        g = CreateGadget( BUTTON_KIND, g, &ng, GT_Underscore, (Tag)'_', TAG_DONE );

        ng.ng_LeftEdge      =   bleft + 231;
        ng.ng_GadgetText    =   "_CANCEL";
        ng.ng_GadgetID      =   GD_CANCEL;

        g = CreateGadget( BUTTON_KIND, g, &ng, GT_Underscore, (Tag)'_', TAG_DONE );

        if ( g ) {

            sp_nwTags[6].ti_Data    =   (Tag)sp_GList;

            if ( sp_Wnd = OpenWindowTagList( NULL, sp_nwTags )) {

                sp_Zoom[0] = l;
                sp_Zoom[1] = t;
                sp_Zoom[2] = w;
                sp_Zoom[3] = h;

                GT_RefreshWindow( sp_Wnd, NULL );
                SetProp( reg );

                do {
                    WaitPort( sp_Wnd->UserPort );

                    while ( ReadIMsg( sp_Wnd )) {

                        switch ( Class ) {

                            case    IDCMP_REFRESHWINDOW:
                                GT_BeginRefresh( sp_Wnd );
                                GT_EndRefresh( sp_Wnd, TRUE );
                                break;

                            case    IDCMP_CLOSEWINDOW:
                                goto Cancel;
                                break;

                            case    IDCMP_VANILLAKEY:

                                switch ( Code ) {

                                    case    'o':
                                        goto Ok;

                                    case    'r':
                                        goto Reset;

                                    case    'c':
                                        goto Cancel;

                                }
                                break;

                            case    IDCMP_MOUSEMOVE:

                                switch ( theObject->GadgetID ) {

                                    case    GD_RED:
                                        sp_Rc = Code;
                                        goto Set;

                                    case    GD_GREEN:
                                        sp_Gc = Code;
                                        goto Set;

                                    case    GD_BLUE:
                                        sp_Bc = Code;

                                        Set:
                                        SetRGB4( &MainScreen->ViewPort, reg, sp_Rc, sp_Gc, sp_Bc );
                                        break;
                                }
                                break;

                            case    IDCMP_GADGETUP:

                                    switch ( theObject->GadgetID ) {

                                        case    GD_PALETTE:
                                            reg = Code;
                                            SetProp( (long)reg );
                                            break;

                                        case    GD_OK:
                                            Ok:
                                            running = FALSE;
                                            for ( r = 0; r < ( 1L << MainScreen->BitMap.Depth ); r++ ) {
                                                col = GetRGB4( MainScreen->ViewPort.ColorMap, (long)r );
                                                MainColors[r].ColorIndex = r;
                                                MainColors[r].Red        = (( col >> 8 ) & 0x0f );
                                                MainColors[r].Green      = (( col >> 4 ) & 0x0f );
                                                MainColors[r].Blue       = (( col      ) & 0x0f );
                                            }
                                            MainColors[r].ColorIndex = ~0;
                                            Saved = FALSE;
                                            break;

                                        case    GD_RESET:
                                            Reset:
                                            LoadRGB4( &MainScreen->ViewPort, sp_Orig, ( 1L << MainScreen->BitMap.Depth ));
                                            SetProp( reg );
                                            break;

                                        case    GD_CANCEL:
                                            Cancel:
                                            LoadRGB4( &MainScreen->ViewPort, sp_Orig, ( 1L << MainScreen->BitMap.Depth ));
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

    if ( sp_Wnd )           CloseWindow( sp_Wnd );
    if ( sp_GList )         FreeGadgets( sp_GList );

    sp_GList = 0l;
    sp_Wnd   = 0l;

    ClearMsgPort( MainWindow->UserPort );

    return TRUE;
}
