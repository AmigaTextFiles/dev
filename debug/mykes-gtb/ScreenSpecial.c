/*-- AutoRev header do NOT edit!
*
*   Program         :   ScreenSpecial.c
*   Copyright       :   © Copyright 1991 Jaba Development
*   Author          :   Jan van den Baard
*   Creation Date   :   21-Oct-91
*   Current version :   1.00
*   Translator      :   DICE v2.6
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   21-Oct-91     1.00            Screen Special requester.
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
extern struct TagItem    MainSTags[];
extern struct Rectangle  CustomRect;

/*
 * --- Gadget ID
 */
#define GD_SCROLL       0
#define GD_TYPE         1
#define GD_OK           2
#define GD_CANCEL       3


/*
 * --- Module data.
 */
struct Window           *cs_Wnd   = NULL;
struct Gadget           *cs_GList = NULL;
struct Gadget           *cs_Gadgets[ 2 ];
WORD                     cs_Zoom[4];

BOOL                     cs_AutoScroll = FALSE;
UWORD                    cs_ScreenType = 2;

UBYTE                   *cs_Types[] = {
    "WBENCHSCREEN", "PUBLICSCREEN", "CUSTOMSCREEN", 0l };

struct TagItem           cs_nwTags[] = {
    WA_Left,                0l,
    WA_Top,                 0l,
    WA_Width,               0l,
    WA_Height,              0l,
    WA_IDCMP,               IDCMP_CLOSEWINDOW | BUTTONIDCMP | CHECKBOXIDCMP | INTEGERIDCMP | IDCMP_VANILLAKEY | IDCMP_REFRESHWINDOW,
    WA_Flags,               WFLG_DRAGBAR | WFLG_DEPTHGADGET| WFLG_CLOSEGADGET | WFLG_ACTIVATE | WFLG_RMBTRAP | WFLG_SMART_REFRESH,
    WA_Gadgets,             0l,
    WA_Title,               (ULONG)"Edit Special Screen Tags:",
    WA_AutoAdjust,          TRUE,
    WA_Zoom,                (Tag)cs_Zoom,
    TAG_DONE };

/*
 * --- Display the ScreenSpecial requester.
 */
long ScreenSpecial( void )
{
    struct Gadget       *g;
    struct NewGadget     ng;
    BOOL                 running = TRUE, OK = FALSE, ok = TRUE;
    WORD                 l, t, w, h, btop, bleft;
    BOOL                 AutoScroll;
    UWORD                Type;

    AutoScroll   = cs_AutoScroll;
    Type         = cs_ScreenType;

    btop  = MainScreen->WBorTop + MainScreen->RastPort.TxHeight;
    bleft = MainScreen->WBorLeft;

    w = bleft + MainScreen->WBorRight  + 300;
    h = btop  + MainScreen->WBorBottom + 52;
    l = (( MainScreen->Width  >> 1 ) - ( w >> 1 ));
    t = (( MainScreen->Height >> 1 ) - ( h >> 1 ));

    cs_Zoom[0] = 0;
    cs_Zoom[1] = btop;
    cs_Zoom[2] = 200;
    cs_Zoom[3] = btop;

    cs_nwTags[0].ti_Data = l;
    cs_nwTags[1].ti_Data = t;
    cs_nwTags[2].ti_Data = w;
    cs_nwTags[3].ti_Data = h;

    cs_nwTags[10].ti_Data = (Tag)MainScreen;

    if (( MainScreen->Flags & CUSTOMSCREEN) == CUSTOMSCREEN )
        cs_nwTags[10].ti_Tag  = WA_CustomScreen;
    else if (( MainScreen->Flags & PUBLICSCREEN ) == PUBLICSCREEN )
        cs_nwTags[10].ti_Tag  = WA_PubScreen;
    else
        cs_nwTags[10].ti_Tag  = TAG_DONE;

    if ( g = CreateContext( &cs_GList )) {

        ng.ng_LeftEdge      =   bleft + 8;
        ng.ng_TopEdge       =   btop + 4;
        ng.ng_GadgetText    =   "_AutoScroll";
        ng.ng_TextAttr      =   &Topaz80;
        ng.ng_GadgetID      =   GD_SCROLL;
        ng.ng_Flags         =   PLACETEXT_RIGHT;
        ng.ng_VisualInfo    =   MainVisualInfo;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)AutoScroll, GT_Underscore, (Tag)'_', TAG_DONE );

        cs_Gadgets[ GD_SCROLL ] = g;

        ng.ng_TopEdge       =   btop + 18;
        ng.ng_Width         =   284;
        ng.ng_Height        =   13;
        ng.ng_GadgetText    =   0l;
        ng.ng_GadgetID      =   GD_TYPE;

        g = CreateGadget( CYCLE_KIND, g, &ng, GTCY_Labels, cs_Types, GTCY_Active, Type, TAG_DONE );

        cs_Gadgets[ GD_TYPE ] = g;

        ng.ng_TopEdge       =   btop + 35;
        ng.ng_Width         =   60;
        ng.ng_GadgetText    =   "_OK";
        ng.ng_GadgetID      =   GD_OK;
        ng.ng_Flags         =   PLACETEXT_IN;

        g = CreateGadget( BUTTON_KIND, g, &ng, GT_Underscore, (Tag)'_', TAG_DONE );

        ng.ng_LeftEdge      =   bleft + 232;
        ng.ng_GadgetText    =   "_CANCEL";
        ng.ng_GadgetID      =   GD_CANCEL;

        g = CreateGadget( BUTTON_KIND, g, &ng, GT_Underscore, (Tag)'_', TAG_DONE );

        if ( g ) {

            cs_nwTags[6].ti_Data = (Tag)cs_GList;

            if ( cs_Wnd = OpenWindowTagList( NULL, cs_nwTags )) {

                cs_Zoom[0] = l;
                cs_Zoom[1] = t;
                cs_Zoom[2] = w;
                cs_Zoom[3] = h;

                GT_RefreshWindow( cs_Wnd, NULL );

                do {
                    WaitPort( cs_Wnd->UserPort );

                    while ( ReadIMsg( cs_Wnd )) {

                        switch ( Class ) {

                            case    IDCMP_REFRESHWINDOW:
                                GT_BeginRefresh( cs_Wnd );
                                GT_EndRefresh( cs_Wnd, TRUE );
                                break;

                            case    IDCMP_CLOSEWINDOW:
                                running = FALSE;
                                break;

                            case    IDCMP_VANILLAKEY:
                                switch ( Code ) {

                                    case    'a':
                                        FlipFlop( cs_Wnd, cs_Gadgets, GD_SCROLL, &AutoScroll );
                                        break;

                                    case    'o':
                                        goto Ok;

                                    case    'c':
                                        goto Cancel;
                                }
                                break;

                            case    IDCMP_GADGETUP:
                                switch ( theObject->GadgetID ) {

                                    case    GD_SCROLL:
                                        FlipFlop( 0l, 0l, 0l, &AutoScroll );
                                        break;

                                    case    GD_TYPE:
                                        if ( Type++ == 2 )
                                            Type = 0l;
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
                                }
                                break;
                        }
                    }
                } while ( running );
            }
        }
    }

    if ( OK ) {
        cs_AutoScroll = AutoScroll;
        cs_ScreenType = Type;

        Saved = FALSE;
    }

    if ( cs_Wnd )           CloseWindow( cs_Wnd );
    if ( cs_GList )         FreeGadgets( cs_GList );

    cs_Wnd   = 0l;
    cs_GList = 0l;

    ClearMsgPort( MainWindow->UserPort );

    return( (long)ok );
}
