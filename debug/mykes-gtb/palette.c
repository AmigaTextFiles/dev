/*-- AutoRev header do NOT edit!
*
*   Program         :   Palette.c
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
*   06-Oct-91     1.00            Palette gadgets editor.
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
extern UWORD                ngFlags;
extern WORD                 ngLeft, ngTop, ngWidth, ngHeight;
extern UBYTE               *PlaceList[];
extern UWORD                PlaceFlags[];
extern struct ExtGadgetList Gadgets;
extern BOOL                 Saved;

/*
 * --- Gadget ID's
 */
#define GD_TEXT             0
#define GD_LABEL            1
#define GD_UNDERSCORE       2
#define GD_DISABLED         3
#define GD_HIGHLABEL        4
#define GD_IWIDTH           5
#define GD_IHEIGHT          6
#define GD_TEXTPLACE        7
#define GD_OK               8
#define GD_CANCEL           9

/*
 * --- Module data
 */
struct Window              *plWnd    = NULL;
struct Gadget              *plGList  = NULL;
struct Gadget              *plGadgets[8];
BOOL                        plScore   = FALSE, plDisabled = FALSE;
WORD                        plZoom[4];

struct TagItem              plnwTags[] = {
    WA_Left,                0l,
    WA_Top,                 0l,
    WA_Width,               0l,
    WA_Height,              0l,
    WA_IDCMP,               IDCMP_CLOSEWINDOW | CYCLEIDCMP | BUTTONIDCMP | CHECKBOXIDCMP | IDCMP_REFRESHWINDOW | IDCMP_VANILLAKEY,
    WA_Flags,               WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_CLOSEGADGET | WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_RMBTRAP,
    WA_Gadgets,             0l,
    WA_Title,               (ULONG)"Edit PALETTE gadget:",
    WA_AutoAdjust,          TRUE,
    WA_Zoom,                (Tag)plZoom,
    WA_CustomScreen,        0l,
    TAG_DONE };

/*
 * --- Create the palette gadget.
 */
long MakePalette( void )
{
    struct ExtNewGadget *eng  = 0l;
    struct TagItem      *tags = 0l;

    if ( eng = Malloc((long)sizeof( struct ExtNewGadget ))) {
        if ( tags = MakeTagList( 4l )) {

            eng->en_NumTags = 4l;
            eng->en_Tags = tags;

            eng->en_Kind = PALETTE_KIND;

            ChangePalette( eng );

            RemoveAllGadgets();

            AddTail(( struct List * )&Gadgets, ( struct Node * )eng );

            Renumber();

            if ( RemakeAllGadgets())
                return TRUE;

            Remove(( struct Node * )eng);
        }
    }

    MyRequest( "Ahem....", "CONTINUE", "Out of memory !" );

    if ( tags )         FreeTagList( tags, 4l );
    if ( eng  )         free(eng);

    return FALSE;
}

/*
 * --- Change the palette gadget.
 */
void ChangePalette( struct ExtNewGadget *eng )
{
    struct TagItem      *tags;
    UBYTE               *slab, *text, tn = 0;
    LONG                 num;

    tags = eng->en_Tags;

    slab = (( struct StringInfo * )plGadgets[ GD_LABEL ]->SpecialInfo )->Buffer;
    text = (( struct StringInfo * )plGadgets[ GD_TEXT  ]->SpecialInfo )->Buffer;

    eng->en_NewGadget.ng_LeftEdge   =   ngLeft;
    eng->en_NewGadget.ng_TopEdge    =   ngTop;
    eng->en_NewGadget.ng_Width      =   ngWidth;
    eng->en_NewGadget.ng_Height     =   ngHeight;

    if ( strncmp( slab, "Gadget", 6 ) && strlen( slab )) {
        strcpy( &eng->en_SourceLabel[0], slab );
        eng->en_SpecialFlags |= EGF_USERLABEL;
    } else
        eng->en_SpecialFlags = 0l;

    if ( strlen( text )) {
        strcpy( &eng->en_GadgetText[0], text );
        eng->en_NewGadget.ng_GadgetText = &eng->en_GadgetText[0];
        eng->en_NewGadget.ng_Flags      = ngFlags;
    } else {
        eng->en_NewGadget.ng_GadgetText = 0l;
        eng->en_NewGadget.ng_Flags      = 0;
    }

    if ( plScore && strlen( text )) {
        tags[ tn   ].ti_Tag  = GT_Underscore;
        tags[ tn++ ].ti_Data = (Tag)'_';
    }

    if ( plDisabled )
        eng->en_SpecialFlags |= EGF_DISABLED;

    num = (( struct StringInfo * )plGadgets[ GD_IWIDTH ]->SpecialInfo )->LongInt;

    if ( num > 8 ) {
        eng->en_IndicatorSize = num;
        tags[ tn   ].ti_Tag    = GTPA_IndicatorWidth;
        tags[ tn++ ].ti_Data   = num;
    } else {

        num = (( struct StringInfo * )plGadgets[ GD_IHEIGHT ]->SpecialInfo )->LongInt;

        if ( num > 8 ) {
            eng->en_IndicatorSize = num;
            tags[ tn   ].ti_Tag   = GTPA_IndicatorHeight;
            tags[ tn++ ].ti_Data  = num;
        }
    }

    tags[ tn   ].ti_Tag  = GTPA_Depth;
    tags[ tn++ ].ti_Data = MainScreen->BitMap.Depth;

    tags[ tn ].ti_Tag = TAG_DONE;

    Saved = FALSE;
}

/*
 * --- Open the EditPalette requester.
 */
long EditPalette( WORD x, WORD y, WORD x1, WORD y1, struct Gadget *edit )
{
    struct Gadget       *g;
    struct ExtNewGadget *e;
    struct NewGadget     ng;
    BOOL                 running = TRUE, ok = FALSE;
    WORD                 l, t, w, h, btop, bleft, gw, gh;
    UBYTE               *label = 0l, *slabel = 0l;
    UBYTE              **cycle;
    Tag                  place = 0l, iwidth = 0l, iheight = 0;
    LONG                 num;
    UWORD                flag  = PLACETEXT_LEFT, high = FALSE, ID;

    if ( edit ) {
        e = FindExtGad( edit );

        x  = e->en_NewGadget.ng_LeftEdge;
        y  = e->en_NewGadget.ng_TopEdge;
        gw = e->en_NewGadget.ng_Width;
        gh = e->en_NewGadget.ng_Height;

        label  = &e->en_GadgetText[0];
        slabel = &e->en_SourceLabel[0];

        flag = e->en_NewGadget.ng_Flags;

        if ( flag & PLACETEXT_LEFT  ) place = 0l;
        if ( flag & PLACETEXT_RIGHT ) place = 1l;
        if ( flag & PLACETEXT_ABOVE ) place = 2l;
        if ( flag & PLACETEXT_BELOW ) place = 3l;

        if ( flag & NG_HIGHLABEL )    high = TRUE;

        plScore = MyTagInArray( GT_Underscore, e->en_Tags );

        iwidth  = GetTagData( GTPA_IndicatorWidth, 0l, e->en_Tags );
        iheight = GetTagData( GTPA_IndicatorHeight,0l, e->en_Tags );

        if (( e->en_SpecialFlags & EGF_DISABLED ) == EGF_DISABLED )
            plDisabled = TRUE;
        else
            plDisabled = FALSE;

    } else {
        if ( x > x1 ) { gw = x; x = x1; x1 = gw; }
        if ( y > y1 ) { gh = y; y = y1; y1 = gh; }

        gw = x1 - x + 1;
        gh = y1 - y + 1;
    }

    cycle = &PlaceList[1];

    btop  = MainScreen->WBorTop + 1 + MainScreen->RastPort.TxHeight;
    bleft = MainScreen->WBorLeft;

    w = bleft + MainScreen->WBorRight  + 300;
    h = btop  + MainScreen->WBorBottom + 132;
    l = (( MainScreen->Width  >> 1 ) - ( w >> 1 ));
    t = (( MainScreen->Height >> 1 ) - ( h >> 1 ));

    plZoom[0] = 0;
    plZoom[1] = btop;
    plZoom[2] = 200;
    plZoom[3] = btop;

    plnwTags[0 ].ti_Data = l;
    plnwTags[1 ].ti_Data = t;
    plnwTags[2 ].ti_Data = w;
    plnwTags[3 ].ti_Data = h;
    plnwTags[10].ti_Data = (Tag)MainScreen;

    if ( g = CreateContext( &plGList ))  {

        ng.ng_LeftEdge      =   bleft + 56;
        ng.ng_TopEdge       =   btop + 4;
        ng.ng_Width         =   236;
        ng.ng_Height        =   12;
        ng.ng_GadgetText    =   "_Text ";
        ng.ng_TextAttr      =   &Topaz80;
        ng.ng_GadgetID      =   GD_TEXT;
        ng.ng_Flags         =   PLACETEXT_LEFT;
        ng.ng_VisualInfo    =   MainVisualInfo;
        ng.ng_UserData      =   0l;

        g = CreateGadget( STRING_KIND, g, &ng, GTST_String, (Tag)label, GTST_MaxChars, (Tag)GT_MAXLABELNAME + 1, GT_Underscore, (Tag)'_', TAG_DONE );

        SetStringGadget( g );

        plGadgets[ GD_TEXT ] = g;

        ng.ng_TopEdge       =   btop + 20;
        ng.ng_GadgetText    =   "_Label";
        ng.ng_GadgetID      =   GD_LABEL;

        g = CreateGadget( STRING_KIND, g, &ng, GTST_String, (Tag)slabel, GTST_MaxChars, (Tag)GT_MAXLABEL + 1, GT_Underscore, (Tag)'_', TAG_DONE );

        SetStringGadget( g );

        plGadgets[ GD_LABEL ] = g;

        ng.ng_LeftEdge      =   bleft + 96;
        ng.ng_TopEdge       =   btop + 36;
        ng.ng_GadgetText    =   "_Underscore";
        ng.ng_GadgetID      =   GD_UNDERSCORE;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)plScore, GT_Underscore, (Tag)'_', TAG_DONE );

        plGadgets[ GD_UNDERSCORE ] = g;

        ng.ng_LeftEdge      =   bleft + 266;
        ng.ng_GadgetText    =   "_Disabled";
        ng.ng_GadgetID      =   GD_DISABLED;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)plDisabled, GT_Underscore, (Tag)'_', TAG_DONE );

        plGadgets[ GD_DISABLED ] = g;

        ng.ng_LeftEdge      =   bleft + 96;
        ng.ng_TopEdge       =   btop + 51;
        ng.ng_GadgetText    =   "_High Label";
        ng.ng_GadgetID      =   GD_HIGHLABEL;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)high, GT_Underscore, '_', TAG_DONE );

        plGadgets[ GD_HIGHLABEL ] = g;

        ng.ng_LeftEdge      =   bleft + 96;
        ng.ng_TopEdge       =   btop + 66;
        ng.ng_Width         =   196;
        ng.ng_Height        =   12;
        ng.ng_GadgetText    =   "_Width     ";
        ng.ng_GadgetID      =   GD_IWIDTH;

        g = CreateGadget( INTEGER_KIND, g, &ng, GTIN_Number, (Tag)iwidth, GTIN_MaxChars, 5l, GT_Underscore, '_', TAG_DONE );

        SetStringGadget( g );

        plGadgets[ GD_IWIDTH ] = g;

        ng.ng_TopEdge       =   btop + 82;
        ng.ng_GadgetText    =   "H_eight    ";
        ng.ng_GadgetID      =   GD_IHEIGHT;

        g = CreateGadget( INTEGER_KIND, g, &ng, GTIN_Number, (Tag)iheight, GTIN_MaxChars, 5l, GT_Underscore, '_', TAG_DONE );

        SetStringGadget( g );

        plGadgets[ GD_IHEIGHT ] = g;

        ng.ng_TopEdge       =   btop + 98;
        ng.ng_Height        =   13;
        ng.ng_GadgetText    =   "Text _Place";
        ng.ng_GadgetID      =   GD_TEXTPLACE;

        g = CreateGadget( CYCLE_KIND, g, &ng, GTCY_Labels, (Tag)cycle, GTCY_Active, place, GT_Underscore, (Tag)'_', TAG_DONE );

        plGadgets[ GD_TEXTPLACE ] = g;

        ng.ng_LeftEdge      =   bleft + 8;
        ng.ng_TopEdge       =   btop + 115;
        ng.ng_Width         =   90;
        ng.ng_GadgetText    =   "_OK";
        ng.ng_Flags         =   PLACETEXT_IN;
        ng.ng_GadgetID      =   GD_OK;

        g = CreateGadget( BUTTON_KIND, g, &ng, GT_Underscore, (Tag)'_', TAG_DONE );

        ng.ng_LeftEdge      =   bleft + 202;
        ng.ng_GadgetText    =   "_CANCEL";
        ng.ng_GadgetID      =   GD_CANCEL;

        g = CreateGadget( BUTTON_KIND, g, &ng, GT_Underscore, (Tag)'_', TAG_DONE );

        if ( g ) {

            plnwTags[6].ti_Data = (Tag)plGList;

            if ( plWnd = OpenWindowTagList( 0l, plnwTags )) {

                plZoom[0] = l;
                plZoom[1] = t;
                plZoom[2] = w;
                plZoom[3] = h;

                GT_RefreshWindow( plWnd, 0l );

                do {
                    WaitPort( plWnd->UserPort );

                    while ( ReadIMsg( plWnd )) {

                        switch ( Class ) {

                            case    IDCMP_REFRESHWINDOW:
                                GT_BeginRefresh( plWnd );
                                GT_EndRefresh( plWnd, TRUE );
                                break;

                            case    IDCMP_CLOSEWINDOW:
                                running = FALSE;
                                break;

                            case    IDCMP_GADGETUP:
                                switch( theObject->GadgetID ) {

                                    case    GD_UNDERSCORE:
                                        FlipFlop( 0l, 0l, 0l, &plScore );
                                        break;

                                    case    GD_DISABLED:
                                        FlipFlop( 0l, 0l, 0l, &plDisabled );
                                        break;

                                    case    GD_HIGHLABEL:
                                        FlipFlop( 0l, 0l, 0l, &high );
                                        break;

                                    case    GD_IWIDTH:
                                        num = (( struct StringInfo * )plGadgets[ GD_IWIDTH ]->SpecialInfo )->LongInt;

                                        if ( num > 8 )
                                            GT_SetGadgetAttrs( plGadgets[ GD_IWIDTH ], plWnd, 0l, GTIN_Number, num, TAG_DONE );
                                        break;

                                    case    GD_IHEIGHT:
                                        num = (( struct StringInfo * )plGadgets[ GD_IHEIGHT ]->SpecialInfo )->LongInt;

                                        if ( num > 8 )
                                            GT_SetGadgetAttrs( plGadgets[ GD_IHEIGHT ], plWnd, 0l, GTIN_Number, num, TAG_DONE );
                                        break;

                                    case    GD_TEXTPLACE:
                                        if ( place++ == 3 )
                                            place = 0;

                                        flag = PlaceFlags[ place + 1 ];
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

                                    case    't':
                                        ID = GD_TEXT;
                                        goto Activate;

                                    case    'l':
                                        ID = GD_LABEL;
                                        goto Activate;

                                    case    'u':
                                        FlipFlop( plWnd, plGadgets, GD_UNDERSCORE, &plScore );
                                        break;

                                    case    'd':
                                        FlipFlop( plWnd, plGadgets, GD_DISABLED, &plDisabled );
                                        break;

                                    case    'h':
                                        FlipFlop( plWnd, plGadgets, GD_HIGHLABEL, &high );
                                        break;

                                    case    'w':
                                        ID = GD_IWIDTH;
                                        goto Activate;

                                    case    'e':
                                        ID = GD_IHEIGHT;
                                        goto Activate;

                                    case    'p':
                                        if ( place++ == 3 )
                                            place = 0;

                                        flag = PlaceFlags[ place + 1 ];
                                        GT_SetGadgetAttrs( plGadgets[ GD_TEXTPLACE ], plWnd, 0l, GTCY_Active, place, TAG_DONE );
                                        break;

                                    case    'o':
                                        goto Ok;

                                    case    'c':
                                        goto Cancel;
                                }
                                break;
                                Activate:
                                ActivateGadget( plGadgets[ ID ], plWnd, 0l );
                                break;
                        }
                    }
                } while ( running );
            }
        }
    }

    if ( ok) {
        if ( high )  flag |= NG_HIGHLABEL;

        ngFlags     =   flag;
        ngLeft      =   x;
        ngTop       =   y;
        ngWidth     =   gw;
        ngHeight    =   gh;
        if ( NOT edit )
            ok = MakePalette();
        else {
            RemoveAllGadgets();
            ChangePalette( e );
            Renumber();
            ok = RemakeAllGadgets();
        }
    } else if ( NOT edit )
        Box( x, y, x1, y1 );

    if ( plWnd )           CloseWindow( plWnd );
    if ( plGList )         FreeGadgets( plGList );

    plWnd     = 0l;
    plGList   = 0l;

    ClearMsgPort( MainWindow->UserPort );

    return( (long)ok );
}
