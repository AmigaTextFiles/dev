/*-- AutoRev header do NOT edit!
*
*   Program         :   DriPen.c
*   Copyright       :   © Copyright 1991 Jaba Development
*   Author          :   Jan van den Baard
*   Creation Date   :   06-Oct-91
*   Current version :   1.00
*   Translator      :   DICE v2.6
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   06-Oct-91     1.00            Screen DriPen editor.
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
extern struct Screen       *MainScreen;
extern struct Window       *MainWindow;
extern UWORD                MainDriPen[ NUMDRIPENS + 1 ];
extern struct DrawInfo     *MainDrawInfo;
extern BOOL                 Saved;

/*
 * --- Gadget ID's
 */
#define GD_PEN              0
#define GD_PENSELECT        1
#define GD_OK               2
#define GD_CANCEL           3

/*
 * --- Module data
 */
struct Window              *dpWnd    = NULL;
struct Gadget              *dpGList  = NULL;
struct Gadget              *dpGadgets[2];

WORD                        dpZoom[4];

UWORD                       dpPens[ NUMDRIPENS + 1 ];

UBYTE                      *PenText[] = {
    "DETAILPEN", "BLOCKPEN", "TEXTPEN", "SHINEPEN", "SHADOWPEN",
    "FILLPEN", "FILLTEXTPEN", "BACKGROUNDPEN", "HIGHLIGHTTEXTPEN", 0l };

struct TagItem              dpnwTags[] = {
    WA_Left,                0l,
    WA_Top,                 0l,
    WA_Width,               0l,
    WA_Height,              0l,
    WA_IDCMP,               IDCMP_CLOSEWINDOW | CYCLEIDCMP | BUTTONIDCMP  | IDCMP_REFRESHWINDOW | IDCMP_VANILLAKEY,
    WA_Flags,               WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_CLOSEGADGET | WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_RMBTRAP,
    WA_Gadgets,             0l,
    WA_Title,               (ULONG)"Edit Screen DriPens:",
    WA_AutoAdjust,          TRUE,
    WA_Zoom,                (Tag)dpZoom,
    WA_CustomScreen,        0l,
    TAG_DONE };

/*
 * --- Open the Edit DriPens requester.
 */
long EditDriPens( void )
{
    struct Gadget       *g;
    struct NewGadget     ng;
    BOOL                 running = TRUE, ok = FALSE;
    WORD                 l, t, w, h, btop, bleft;
    UWORD                penno = 0l;

    btop  = MainScreen->WBorTop + 1 + MainScreen->RastPort.TxHeight;
    bleft = MainScreen->WBorLeft;

    w = bleft + MainScreen->WBorRight  + 298;
    h = btop  + MainScreen->WBorBottom + 95;
    l = (( MainScreen->Width  >> 1 ) - ( w >> 1 ));
    t = (( MainScreen->Height >> 1 ) - ( h >> 1 ));

    dpZoom[0] = 0;
    dpZoom[1] = btop;
    dpZoom[2] = 200;
    dpZoom[3] = btop;

    dpnwTags[0 ].ti_Data = (ULONG)l;
    dpnwTags[1 ].ti_Data = (ULONG)t;
    dpnwTags[2 ].ti_Data = (ULONG)w;
    dpnwTags[3 ].ti_Data = (ULONG)h;
    dpnwTags[10].ti_Data = (Tag)MainScreen;

    CopyMem(( void * )MainDrawInfo->dri_Pens, (void * )&dpPens[0], NUMDRIPENS << 1);

    if ( g = CreateContext( &dpGList ))  {

        ng.ng_LeftEdge      =   bleft + 8;
        ng.ng_TopEdge       =   btop + 16;
        ng.ng_Width         =   282;
        ng.ng_Height        =   13;
        ng.ng_GadgetText    =   "_Pens";
        ng.ng_TextAttr      =   &Topaz80;
        ng.ng_GadgetID      =   GD_PEN;
        ng.ng_Flags         =   PLACETEXT_ABOVE;
        ng.ng_VisualInfo    =   MainVisualInfo;
        ng.ng_UserData      =   0l;

        g = CreateGadget( CYCLE_KIND, g, &ng, GTCY_Labels, (Tag)&PenText[0], GTCY_Active, 0l, GT_Underscore, '_', TAG_DONE );

        dpGadgets[ GD_PEN ] = g;

        ng.ng_TopEdge       =   btop + 33;
        ng.ng_Height        =   40;
        ng.ng_GadgetText    =   0l;
        ng.ng_GadgetID      =   GD_PENSELECT;

        g = CreateGadget( PALETTE_KIND, g, &ng, GTPA_Depth, (Tag)MainScreen->BitMap.Depth, GTPA_Color, (Tag)MainDrawInfo->dri_Pens[0], GTPA_IndicatorWidth, 50l, TAG_DONE );

        dpGadgets[ GD_PENSELECT ] = g;

        ng.ng_TopEdge       =   btop + 78;
        ng.ng_Height        =   13;
        ng.ng_Width         =   90;
        ng.ng_GadgetText    =   "_OK";
        ng.ng_Flags         =   PLACETEXT_IN;
        ng.ng_GadgetID      =   GD_OK;

        g = CreateGadget( BUTTON_KIND, g, &ng, GT_Underscore, (Tag)'_', TAG_DONE );

        ng.ng_LeftEdge      =   bleft + 200;
        ng.ng_GadgetText    =   "_CANCEL";
        ng.ng_GadgetID      =   GD_CANCEL;

        g = CreateGadget( BUTTON_KIND, g, &ng, GT_Underscore, (Tag)'_', TAG_DONE );

        if ( g ) {

            dpnwTags[6].ti_Data = (Tag)dpGList;

            if ( dpWnd = OpenWindowTagList( 0l, dpnwTags )) {

                dpZoom[0] = l;
                dpZoom[1] = t;
                dpZoom[2] = w;
                dpZoom[3] = h;

                GT_RefreshWindow( dpWnd, 0l );

                do {
                    WaitPort( dpWnd->UserPort );

                    while ( ReadIMsg( dpWnd )) {

                        switch ( Class ) {

                            case    IDCMP_REFRESHWINDOW:
                                GT_BeginRefresh( dpWnd );
                                GT_EndRefresh( dpWnd, TRUE );
                                break;

                            case    IDCMP_CLOSEWINDOW:
                                running = FALSE;
                                break;

                            case    IDCMP_GADGETUP:
                                switch( theObject->GadgetID ) {

                                    case    GD_PEN:
                                        if ( penno++ == 8 )
                                            penno = 0;
                                        setIt:
                                        GT_SetGadgetAttrs( dpGadgets[ GD_PENSELECT ], dpWnd, 0l, GTPA_Color, MainDrawInfo->dri_Pens[ penno ], TAG_DONE );
                                        break;

                                    case    GD_PENSELECT:
                                        dpPens[ penno ] = Code;
                                        break;

                                    case    GD_OK:
                                        Ok:
                                        ok = TRUE;

                                    case    GD_CANCEL:
                                        Cancel:
                                        running = FALSE;
                                        break;
                                }
                                break;

                            case    IDCMP_VANILLAKEY:
                                switch( Code ) {

                                    case    'p':
                                        if ( penno++ == 8 )
                                            penno = 0;

                                        GT_SetGadgetAttrs( dpGadgets[ GD_PEN ], dpWnd, 0l, GTCY_Active, (Tag)penno, TAG_DONE );
                                        goto setIt;

                                        break;

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

    if ( dpWnd )           CloseWindow( dpWnd );
    if ( dpGList )         FreeGadgets( dpGList );

    dpWnd     = 0l;
    dpGList   = 0l;

    if ( ok ) {
        CopyMem(( void * )&dpPens[0], ( void * )&MainDriPen[0], NUMDRIPENS << 1);
        MainDriPen[ NUMDRIPENS ] = ~0;
        ok = ReOpenScreen( FALSE );
        Saved = FALSE;
    }

    ClearMsgPort( MainWindow->UserPort );

    return( (long)ok );
}
