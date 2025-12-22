/*-- AutoRev header do NOT edit!
*
*   Program         :   WindowText.c
*   Copyright       :   © Copyright 1991 Jaba Development
*   Author          :   Jan van den Baard
*   Creation Date   :   19-Oct-91
*   Current version :   1.00
*   Translator      :   DICE v2.6
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   19-Oct-91     1.00            Window text routines.
*
*-- REV_END --*/

#include	"defs.h"

/*
 * --- External referenced data.
 */
extern ULONG                 Class;
extern UWORD                 Code;
extern struct TextAttr       Topaz80, MainFont;
extern APTR                  MainVisualInfo;
extern struct Screen        *MainScreen;
extern struct Window        *MainWindow;
extern struct Gadget        *theObject;
extern struct RastPort      *MainRP;
extern struct IntuiText     *WindowTxt;
extern UBYTE                 MainWindowTitle[80], MainScreenTitle[80];
extern BOOL                  Saved;

/*
 * --- Gadget ID's "Edit" window
 */
#define GD_ENTER            0
#define GD_JAM1             1
#define GD_JAM2             2
#define GD_COMP             3
#define GD_INVE             4
#define GD_FPEN             5
#define GD_BPEN             6
#define GD_OK               7
#define GD_CANCEL           8

/*
 * --- Gadget ID's "Select" window
 */
#define GD_TEXTLIST         0
#define GD_OKS              1
#define GD_CANCELS          2

/*
 * --- Module data.
 */
struct Window           *wt_Wnd   = NULL;
struct Gadget           *wt_GList = NULL;
struct Gadget           *wt_Gadgets[7];
struct List              wt_Texts;
BOOL                     wt_Jam1 = TRUE, wt_Jam2 = FALSE;
BOOL                     wt_Comp = FALSE, wt_Inve = FALSE;
UBYTE                    wt_FPen = 1, wt_BPen = 0;

WORD                     wt_Zoom[4];

UBYTE                   *wt_Edit = "Edit Window IntuiText:";
UBYTE                   *wt_Get  = "Select Window IntuiText:";

struct TagItem           wt_nwTags[] = {
    WA_Left,                0l,
    WA_Top,                 0l,
    WA_Width,               0l,
    WA_Height,              0l,
    WA_IDCMP,               IDCMP_CLOSEWINDOW | BUTTONIDCMP | STRINGIDCMP | CHECKBOXIDCMP | LISTVIEWIDCMP | IDCMP_VANILLAKEY | IDCMP_REFRESHWINDOW,
    WA_Flags,               WFLG_DRAGBAR | WFLG_DEPTHGADGET| WFLG_CLOSEGADGET | WFLG_ACTIVATE | WFLG_RMBTRAP | WFLG_SMART_REFRESH,
    WA_Gadgets,             0l,
    WA_Title,               0l,
    WA_AutoAdjust,          TRUE,
    WA_Zoom,                (Tag)wt_Zoom,
    TAG_DONE };

/*
 * --- Put all IntuiText's in a list.
 */
long MakeTextList( void )
{
    struct ListViewNode *node;
    struct IntuiText    *txt;

    NewList( &wt_Texts );

    if ( NOT( txt = WindowTxt )) return TRUE;

    while ( txt ) {
        if ( node = MakeNode( txt->IText )) {
            node->ln_UserData[0] = (ULONG)txt;
            AddTail( &wt_Texts, ( struct Node * )node );
            txt = txt->NextText;
        } else {
            MyRequest( "Oops...", "ARGHHH!", "Out of memory !" );
            return FALSE;
        }
    }
    return TRUE;
}

/*
 * --- Allocate an IntuiText structure.
 */
struct IntuiText *AddAText( void )
{
    struct IntuiText    *tmp, *text = 0l;

    if ( strlen((( struct StringInfo * )wt_Gadgets[ GD_ENTER ]->SpecialInfo )->Buffer )) {
        tmp = WindowTxt;

        if ( tmp ) {
            while ( tmp->NextText ) tmp = tmp->NextText;
        }

        if ( text = ( struct IntuiText * )Malloc( (long)sizeof( struct IntuiText ))) {
            if ( text->IText = (UBYTE *)Malloc(80l)) {
                ChangeText( text );
                if ( tmp )  tmp->NextText = text;
                else        WindowTxt     = text;
                return( text );
            }
        }
        MyRequest( "pompompidom", "puke", "Out of memory !" );

        if ( text ) {
            if ( text->IText )  free(text->IText);
            free(text);
        }
    }
    return( 0l );
}

/*
 * --- Change the IntuiText attributes.
 */
void ChangeText( struct IntuiText *text )
{
    if ( wt_Jam2 )  text->DrawMode  = JAM2;
    else            text->DrawMode  = JAM1;
    if ( wt_Comp )  text->DrawMode |= COMPLEMENT;
    if ( wt_Inve )  text->DrawMode |= INVERSVID;

    text->FrontPen = wt_FPen;
    text->BackPen  = wt_BPen;

    strcpy( text->IText, (( struct StringInfo * )wt_Gadgets[ GD_ENTER ]->SpecialInfo )->Buffer );

    Saved = FALSE;
}

/*
 * --- Place an IntuiText on the EditWindow.
 */
void PlaceText( struct IntuiText *txt )
{
    WORD    x, y, x1, y1;

    if ( txt ) {
        GetMouseXY( &x, &y );
        SetTitle( 0l );
        UpdateCoords( 2l, x, y, 0, 0 );

        SetDrMd( MainRP, JAM1 | COMPLEMENT );

        Move( MainRP, x, y );
        Text( MainRP, txt->IText, strlen( txt->IText ));

        while ( Code != SELECTDOWN ) {
            while( ReadIMsg( MainWindow )) {
                if ( Code == SELECTDOWN ) break;
                if ( Class == IDCMP_MENUPICK ) {
                    SetTitle( 0l );
                    UpdateCoords( 2l, x, y, 0, 0 );
                }
            }
            GetMouseXY( &x1, &y1 );
            if ( x1 != x || y1 != y ) {
                Move( MainRP, x, y );
                Text( MainRP, txt->IText, strlen( txt->IText ));
                x = x1;
                y = y1;
                Move( MainRP, x, y );
                Text( MainRP, txt->IText, strlen( txt->IText ));
                UpdateCoords( 2l, x, y, 0, 0 );
            }
        }

        Move( MainRP, x, y );
        Text( MainRP, txt->IText, strlen( txt->IText ));

        txt->LeftEdge   =   x;
        txt->TopEdge    =   y - MainScreen->RastPort.TxBaseline;

        SetWindowTitles( MainWindow, MainWindowTitle, MainScreenTitle );
    }
}

/*
 * --- Deallocate all IntuiTexts.
 */
void DeleteTexts( void )
{
    struct IntuiText    *t1, *t2;

    if ( NOT( t1 = WindowTxt )) return;

    while ( t1 ) {
        t2 = t1->NextText;
        if ( t1->IText )    free(t1->IText);
        free(t1);
        t1 = t2;
    }
    WindowTxt = 0l;
}

/*
 * --- Remove and deallocate an IntuiText from the list.
 */
void RemoveText( struct IntuiText *txt )
{
    struct IntuiText    *pred = 0l;

    if ( txt ) {
        if ( txt != WindowTxt ) {
            pred = WindowTxt;
            while ( pred->NextText != txt ) pred = pred->NextText;
        }

        if ( pred ) pred->NextText = txt->NextText;
        else        WindowTxt      = txt->NextText;

        if ( txt->IText )   free(txt->IText);
        free(txt);
    }
}

/*
 * --- Display the EditText requester.
 */
struct IntuiText *EditText( struct IntuiText *itxt )
{
    struct Gadget       *g;
    struct IntuiText    *i = 0l;
    struct NewGadget     ng;
    BOOL                 running =  TRUE, OK = FALSE;
    WORD                 l, t, w, h, btop, bleft;
    UBYTE               *string = 0l;

    btop  = MainScreen->WBorTop + MainScreen->RastPort.TxHeight;
    bleft = MainScreen->WBorLeft;

    w = bleft + MainScreen->WBorRight  + 300;
    h = btop  + MainScreen->WBorBottom + 115;
    l = (( MainScreen->Width  >> 1 ) - ( w >> 1 ));
    t = (( MainScreen->Height >> 1 ) - ( h >> 1 ));

    wt_Zoom[0] = 0;
    wt_Zoom[1] = btop;
    wt_Zoom[2] = 200;
    wt_Zoom[3] = btop;

    wt_nwTags[0].ti_Data = l;
    wt_nwTags[1].ti_Data = t;
    wt_nwTags[2].ti_Data = w;
    wt_nwTags[3].ti_Data = h;

    wt_nwTags[10].ti_Data = (Tag)MainScreen;

    if (( MainScreen->Flags & CUSTOMSCREEN) == CUSTOMSCREEN )
        wt_nwTags[10].ti_Tag  = WA_CustomScreen;
    else if (( MainScreen->Flags & PUBLICSCREEN ) == PUBLICSCREEN )
        wt_nwTags[10].ti_Tag  = WA_PubScreen;
    else
        wt_nwTags[10].ti_Tag  = TAG_DONE;

    if ( itxt ) {
        if (( itxt->DrawMode & JAM2 ) == JAM2 )
            { wt_Jam2 = TRUE; wt_Jam1 = FALSE; }
        else
            { wt_Jam2 = FALSE; wt_Jam1 = TRUE; }
        if (( itxt->DrawMode & COMPLEMENT ) == COMPLEMENT )
            wt_Comp = TRUE; else wt_Comp = FALSE;
        if (( itxt->DrawMode & INVERSVID ) == INVERSVID )
            wt_Inve = TRUE; else wt_Inve = FALSE;

        wt_FPen = itxt->FrontPen;
        wt_BPen = itxt->BackPen;

        string = itxt->IText;
    } else {
        wt_Jam1 = TRUE;
        wt_Jam2 = FALSE;
        wt_Comp = FALSE;
        wt_Inve = FALSE;
        wt_FPen = 1;
        wt_BPen = 0;
    }

    if ( g = CreateContext( &wt_GList )) {

        ng.ng_LeftEdge      =   bleft + 8;
        ng.ng_TopEdge       =   btop + 16;
        ng.ng_Width         =   284;
        ng.ng_Height        =   12;
        ng.ng_GadgetText    =   "_Enter Text";
        ng.ng_TextAttr      =   &Topaz80;
        ng.ng_GadgetID      =   GD_ENTER;
        ng.ng_Flags         =   PLACETEXT_ABOVE;
        ng.ng_VisualInfo    =   MainVisualInfo;

        g = CreateGadget( STRING_KIND, g, &ng, GTST_String, (Tag)string, GTST_MaxChars, 80l, GT_Underscore, (Tag)'_', TAG_DONE );

        SetStringGadget( g );

        wt_Gadgets[ GD_ENTER ] = g;

        ng.ng_LeftEdge      =   bleft + 125;
        ng.ng_TopEdge       =   btop + 32;
        ng.ng_GadgetText    =   "JAM_1      ";
        ng.ng_GadgetID      =   GD_JAM1;
        ng.ng_Flags         =   PLACETEXT_LEFT;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)wt_Jam1, GT_Underscore, (Tag)'_', TAG_DONE );

        wt_Gadgets[ GD_JAM1 ] = g;

        ng.ng_LeftEdge      =   bleft + 266;
        ng.ng_GadgetText    =   "JAM_2     ";
        ng.ng_GadgetID      =   GD_JAM2;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)wt_Jam2, GT_Underscore, (Tag)'_', TAG_DONE );

        wt_Gadgets[ GD_JAM2 ] = g;

        ng.ng_TopEdge       =   btop + 46;
        ng.ng_LeftEdge      =   bleft + 125;
        ng.ng_GadgetText    =   "COM_PLEMENT";
        ng.ng_GadgetID      =   GD_COMP;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)wt_Comp, GT_Underscore, (Tag)'_', TAG_DONE );

        wt_Gadgets[ GD_COMP ] = g;

        ng.ng_LeftEdge      =   bleft + 266;
        ng.ng_GadgetText    =   "_INVERSVID";
        ng.ng_GadgetID      =   GD_INVE;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)wt_Inve, GT_Underscore, (Tag)'_', TAG_DONE );

        wt_Gadgets[ GD_INVE ] = g;

        ng.ng_LeftEdge      =   bleft + 125;
        ng.ng_TopEdge       =   btop + 60;
        ng.ng_Width         =   167;
        ng.ng_Height        =   15;
        ng.ng_GadgetText    =   "FrontPen  ";
        ng.ng_GadgetID      =   GD_FPEN;

        g = CreateGadget( PALETTE_KIND, g, &ng, GTPA_Depth, (Tag)MainScreen->BitMap.Depth, GTPA_Color, (Tag)wt_FPen, GTPA_IndicatorWidth, 27l, TAG_DONE );

        wt_Gadgets[ GD_FPEN ] = g;

        ng.ng_TopEdge       =   btop + 79;
        ng.ng_GadgetText    =   "BackPen   ";
        ng.ng_GadgetID      =   GD_BPEN;

        g = CreateGadget( PALETTE_KIND, g, &ng, GTPA_Depth, (Tag)MainScreen->BitMap.Depth, GTPA_Color, (Tag)wt_BPen, GTPA_IndicatorWidth, 27l, TAG_DONE );

        wt_Gadgets[ GD_BPEN ] = g;

        ng.ng_LeftEdge      =   bleft + 8;
        ng.ng_TopEdge       =   btop + 98;
        ng.ng_Width         =   90;
        ng.ng_Height        =   13;
        ng.ng_GadgetText    =   "_OK";
        ng.ng_GadgetID      =   GD_OK;
        ng.ng_Flags         =   PLACETEXT_IN;

        g = CreateGadget( BUTTON_KIND, g, &ng, GT_Underscore, (Tag)'_', TAG_DONE );

        ng.ng_LeftEdge      =   bleft + 201;
        ng.ng_GadgetText    =   "_CANCEL";
        ng.ng_GadgetID      =   GD_CANCEL;

        g = CreateGadget( BUTTON_KIND, g, &ng, GT_Underscore, (Tag)'_', TAG_DONE );

        if ( g ) {

            wt_nwTags[6].ti_Data = (Tag)wt_GList;
            wt_nwTags[7].ti_Data = (Tag)wt_Edit;

            if ( wt_Wnd = OpenWindowTagList( NULL, wt_nwTags )) {

                wt_Zoom[0] = l;
                wt_Zoom[1] = t;
                wt_Zoom[2] = w;
                wt_Zoom[3] = h;

                GT_RefreshWindow( wt_Wnd, NULL );

                do {
                    WaitPort( wt_Wnd->UserPort );

                    while ( ReadIMsg( wt_Wnd )) {

                        switch ( Class ) {

                            case    IDCMP_REFRESHWINDOW:
                                GT_BeginRefresh( wt_Wnd );
                                GT_EndRefresh( wt_Wnd, TRUE );
                                break;

                            case    IDCMP_CLOSEWINDOW:
                                goto Cancel;
                                break;

                            case    IDCMP_VANILLAKEY:
                                switch ( Code ) {

                                    case    'e':
                                        ActivateGadget( wt_Gadgets[ GD_ENTER ], wt_Wnd, 0l );
                                        break;

                                    case    '1':
                                        FlipFlop( wt_Wnd, wt_Gadgets, GD_JAM1, &wt_Jam1 );
                                        goto Excl1;

                                    case    '2':
                                        FlipFlop( wt_Wnd, wt_Gadgets, GD_JAM2, &wt_Jam2 );
                                        goto Excl2;

                                    case    'p':
                                        FlipFlop( wt_Wnd, wt_Gadgets, GD_COMP, &wt_Comp );
                                        break;

                                    case    'i':
                                        FlipFlop( wt_Wnd, wt_Gadgets, GD_INVE, &wt_Inve );
                                        break;

                                    case    'c':
                                        goto Cancel;

                                    case    'o':
                                        goto Ok;
                                }
                                break;

                            case    IDCMP_GADGETUP:
                                switch ( theObject->GadgetID ) {

                                    case    GD_JAM1:
                                        FlipFlop( 0l, 0l, 0l, &wt_Jam1 );
                                        Excl1:
                                        if ( wt_Jam2 )
                                            FlipFlop( wt_Wnd, wt_Gadgets, GD_JAM2, &wt_Jam2 );
                                        break;

                                    case    GD_JAM2:
                                        FlipFlop( 0l, 0l, 0l, &wt_Jam2 );
                                        Excl2:
                                        if ( wt_Jam1 )
                                            FlipFlop( wt_Wnd, wt_Gadgets, GD_JAM1, &wt_Jam1 );
                                        break;

                                    case    GD_COMP:
                                        FlipFlop( 0l, 0l, 0l, &wt_Comp );
                                        break;

                                    case    GD_INVE:
                                        FlipFlop( 0l, 0l, 0l, &wt_Inve );
                                        break;

                                    case    GD_FPEN:
                                        wt_FPen = Code;
                                        break;

                                    case    GD_BPEN:
                                        wt_BPen = Code;
                                        break;

                                    case    GD_CANCEL:
                                        Cancel:
                                        running = FALSE;
                                        break;

                                    case    GD_OK:
                                        Ok:
                                        OK = TRUE;
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

    if ( OK && NOT itxt )   i = AddAText();
    else if ( OK && itxt ) {
        i = itxt;
        ChangeText( i );
    }

    if ( wt_Wnd )           CloseWindow( wt_Wnd );
    if ( wt_GList )         FreeGadgets( wt_GList );

    wt_Wnd   = 0l;
    wt_GList = 0l;

    ClearMsgPort( MainWindow->UserPort );

    return ( i );
}

/*
 * --- Display the SelectText requester.
 */
struct IntuiText *SelectText( void )
{
    struct Gadget       *g;
    struct IntuiText    *i = 0l, *tmp;
    struct ListViewNode *nde;
    struct NewGadget     ng;
    BOOL                 running =  TRUE, OK = FALSE;
    WORD                 l, t, w, h, btop, bleft;
    long                 tc = 0l;

    btop  = MainScreen->WBorTop + MainScreen->RastPort.TxHeight;
    bleft = MainScreen->WBorLeft;

    w = bleft + MainScreen->WBorRight  + 300;
    h = btop  + MainScreen->WBorBottom + 97;
    l = (( MainScreen->Width  >> 1 ) - ( w >> 1 ));
    t = (( MainScreen->Height >> 1 ) - ( h >> 1 ));

    wt_Zoom[0] = 0;
    wt_Zoom[1] = btop;
    wt_Zoom[2] = 200;
    wt_Zoom[3] = btop;

    wt_nwTags[0].ti_Data = l;
    wt_nwTags[1].ti_Data = t;
    wt_nwTags[2].ti_Data = w;
    wt_nwTags[3].ti_Data = h;

    wt_nwTags[10].ti_Data = (Tag)MainScreen;

    if (( MainScreen->Flags & CUSTOMSCREEN) == CUSTOMSCREEN )
        wt_nwTags[10].ti_Tag  = WA_CustomScreen;
    else if (( MainScreen->Flags & PUBLICSCREEN ) == PUBLICSCREEN )
        wt_nwTags[10].ti_Tag  = WA_PubScreen;
    else
        wt_nwTags[10].ti_Tag  = TAG_DONE;

    if ( NOT( tmp = WindowTxt )) return( 0l );

    while ( tmp ) {
        tc++;
        tmp = tmp->NextText;
    }

    if ( tc == 1 )
        return( WindowTxt );

    if ( NOT MakeTextList())
        return( 0l );

    if ( g = CreateContext( &wt_GList )) {

        ng.ng_LeftEdge      =   bleft + 8;
        ng.ng_TopEdge       =   btop + 16;
        ng.ng_Width         =   284;
        ng.ng_Height        =   60;
        ng.ng_GadgetText    =   "Available Texts:";
        ng.ng_TextAttr      =   &Topaz80;
        ng.ng_GadgetID      =   GD_TEXTLIST;
        ng.ng_Flags         =   PLACETEXT_ABOVE;
        ng.ng_VisualInfo    =   MainVisualInfo;

        g = CreateGadget( LISTVIEW_KIND, g, &ng, GTLV_Labels, (Tag)&wt_Texts, GTLV_ShowSelected, 0l, TAG_DONE );

        wt_Gadgets[ GD_TEXTLIST ] = g;

        ng.ng_LeftEdge      =   bleft + 8;
        ng.ng_TopEdge       =   btop + 80;
        ng.ng_Width         =   90;
        ng.ng_Height        =   13;
        ng.ng_GadgetText    =   "_OK";
        ng.ng_GadgetID      =   GD_OKS;
        ng.ng_Flags         =   PLACETEXT_IN;

        g = CreateGadget( BUTTON_KIND, g, &ng, GT_Underscore, (Tag)'_', TAG_DONE );

        ng.ng_LeftEdge      =   bleft + 201;
        ng.ng_GadgetText    =   "_CANCEL";
        ng.ng_GadgetID      =   GD_CANCELS;

        g = CreateGadget( BUTTON_KIND, g, &ng, GT_Underscore, (Tag)'_', TAG_DONE );

        if ( g ) {

            wt_nwTags[6].ti_Data = (Tag)wt_GList;
            wt_nwTags[7].ti_Data = (Tag)wt_Get;

            if ( wt_Wnd = OpenWindowTagList( NULL, wt_nwTags )) {

                wt_Zoom[0] = l;
                wt_Zoom[1] = t;
                wt_Zoom[2] = w;
                wt_Zoom[3] = h;

                GT_RefreshWindow( wt_Wnd, NULL );

                do {
                    WaitPort( wt_Wnd->UserPort );

                    while ( ReadIMsg( wt_Wnd )) {

                        switch ( Class ) {

                            case    IDCMP_REFRESHWINDOW:
                                GT_BeginRefresh( wt_Wnd );
                                GT_EndRefresh( wt_Wnd, TRUE );
                                break;

                            case    IDCMP_CLOSEWINDOW:
                                goto Cancel;
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
                                switch ( theObject->GadgetID ) {

                                    case    GD_TEXTLIST:
                                        nde = FindNode( &wt_Texts, Code );
                                        i = ( struct IntuiText * )nde->ln_UserData[0];
                                        break;

                                    case    GD_CANCELS:
                                        Cancel:
                                        i = 0l;
                                        running = FALSE;
                                        break;

                                    case    GD_OKS:
                                        Ok:
                                        OK = TRUE;
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

    if ( wt_Wnd )           CloseWindow( wt_Wnd );
    if ( wt_GList )         FreeGadgets( wt_GList );

    wt_Wnd   = 0l;
    wt_GList = 0l;

    ClearMsgPort( MainWindow->UserPort );

    return ( i );
}
