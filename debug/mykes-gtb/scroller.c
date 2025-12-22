/*-- AutoRev header do NOT edit!
*
*   Program         :   Scroller.c
*   Copyright       :   © Copyright 1991 Jaba Development
*   Author          :   Jan van den Baard
*   Creation Date   :   07-Oct-91
*   Current version :   1.00
*   Translator      :   DICE v2.6
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   07-Oct-91     1.00            Scroller editor.
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
#define GD_IMMEDIATE        5
#define GD_RELVERIFY        6
#define GD_LORIENT          7
#define GD_TOP              8
#define GD_TOTAL            9
#define GD_VISIBLE          10
#define GD_ARROWS           11
#define GD_TEXTPLACE        12
#define GD_OK               13
#define GD_CANCEL           14

/*
 * --- Module data
 */
struct Window              *sr_Wnd    = NULL;
struct Gadget              *sr_GList  = NULL;
struct Gadget              *sr_Gadgets[13];
BOOL                        sr_Score = FALSE, sr_Disabled = FALSE;
BOOL                        sr_Immediate = FALSE;
BOOL                        sr_RelVerify = FALSE;
UWORD                       sr_Lorient = LORIENT_HORIZ;
WORD                        sr_Zoom[4];
UBYTE                      *sr_Free[] = {
    "Hori_zontal", "_Vertical  ", 0l };

struct TagItem              sr_nwTags[] = {
    WA_Left,                0l,
    WA_Top,                 0l,
    WA_Width,               0l,
    WA_Height,              0l,
    WA_IDCMP,               IDCMP_CLOSEWINDOW | CYCLEIDCMP | BUTTONIDCMP | CHECKBOXIDCMP | MXIDCMP | IDCMP_REFRESHWINDOW | IDCMP_VANILLAKEY,
    WA_Flags,               WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_CLOSEGADGET | WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_RMBTRAP,
    WA_Gadgets,             0l,
    WA_Title,               (ULONG)"Edit SCROLLER gadget:",
    WA_AutoAdjust,          TRUE,
    WA_Zoom,                (Tag)sr_Zoom,
    WA_CustomScreen,        0l,
    TAG_DONE };

/*
 * --- Create the scroller gadget.
 */
long MakeScroller( void )
{
    struct ExtNewGadget *eng  = 0l;
    struct TagItem      *tags = 0l;

    if ( eng = Malloc((long)sizeof( struct ExtNewGadget ))) {
        if ( tags = MakeTagList( 9l )) {

            eng->en_NumTags = 9l;
            eng->en_Tags = tags;

            ChangeScroller( eng );

            RemoveAllGadgets();

            AddTail(( struct List * )&Gadgets, ( struct Node * )eng );

            Renumber();

            if ( RemakeAllGadgets())
                return TRUE;

            Remove(( struct Node * )eng);
        }
    }

    MyRequest( "Ahem....", "CONTINUE", "Out of memory !" );

    if ( tags )         FreeTagList( tags, 9l );
    if ( eng  )         free( eng );

    return FALSE;
}

/*
 * --- Change the scroller gadget.
 */
void ChangeScroller( struct ExtNewGadget *eng )
{
    struct TagItem      *tags;
    UBYTE               *slab, *text, tn = 0;
    long                 num;

    tags = eng->en_Tags;

    slab = (( struct StringInfo * )sr_Gadgets[ GD_LABEL ]->SpecialInfo )->Buffer;
    text = (( struct StringInfo * )sr_Gadgets[ GD_TEXT  ]->SpecialInfo )->Buffer;

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

    eng->en_Kind    = SCROLLER_KIND;

    if ( sr_Score && strlen( text )) {
        tags[ tn   ].ti_Tag  = GT_Underscore;
        tags[ tn++ ].ti_Data = (Tag)'_';
    }

    if ( sr_Disabled )
        eng->en_SpecialFlags |= EGF_DISABLED;

    if ( NOT sr_RelVerify )
        eng->en_SpecialFlags |= EGF_NOGADGETUP;

    tags[ tn   ].ti_Tag  = GA_RelVerify;
    tags[ tn++ ].ti_Data = TRUE;

    if ( sr_Immediate ) {
        tags[ tn   ].ti_Tag  = GA_Immediate;
        tags[ tn++ ].ti_Data = TRUE;
    }

    if ( sr_Lorient == LORIENT_VERT ) {
        tags[ tn   ].ti_Tag  = PGA_Freedom;
        tags[ tn++ ].ti_Data = sr_Lorient;
    }

    num = (( struct StringInfo * )sr_Gadgets[ GD_TOP ]->SpecialInfo )->LongInt;

    if ( num ) {
        tags[ tn   ].ti_Tag  = GTSC_Top;
        tags[ tn++ ].ti_Data = num;
    }

    num = (( struct StringInfo * )sr_Gadgets[ GD_TOTAL ]->SpecialInfo )->LongInt;

    if ( num ) {
        tags[ tn   ].ti_Tag  = GTSC_Total;
        tags[ tn++ ].ti_Data = num;
    }

    num = (( struct StringInfo * )sr_Gadgets[ GD_VISIBLE ]->SpecialInfo )->LongInt;

    if ( num != 2 ) {
        tags[ tn   ].ti_Tag  = GTSC_Visible;
        tags[ tn++ ].ti_Data = num;
    }

    num = (( struct StringInfo * )sr_Gadgets[ GD_ARROWS ]->SpecialInfo )->LongInt;

    if ( num > 7 ) {
        eng->en_ArrowSize = num;
        tags[ tn   ].ti_Tag  = GTSC_Arrows;
        tags[ tn++ ].ti_Data = num;
    }

    tags[ tn ].ti_Tag = TAG_DONE;

    Saved = FALSE;
}

/*
 * --- Open the EditScroller requester.
 */
long EditScroller( WORD x, WORD y, WORD x1, WORD y1, struct Gadget *edit )
{
    struct Gadget       *g;
    struct ExtNewGadget *e;
    struct NewGadget     ng;
    BOOL                 running = TRUE, ok = FALSE, high = FALSE;
    WORD                 l, t, w, h, btop, bleft, gw, gh;
    UBYTE               *label = 0l, *slabel = 0l, *cycle;
    Tag                  place = 0l, num;
    UWORD                flag  = PLACETEXT_LEFT, ID;
    UWORD                top = 0, total = 0, visible = 2, arrows = 8;

    cycle = (UBYTE *)&PlaceList[1];

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

        if ( flag & NG_HIGHLABEL    ) high = TRUE;

        sr_Score     = MyTagInArray( GT_Underscore, e->en_Tags );
        sr_Immediate = MyTagInArray( GA_Immediate,  e->en_Tags );
        sr_RelVerify = MyTagInArray( GA_RelVerify,  e->en_Tags );

        if (( e->en_SpecialFlags & EGF_NOGADGETUP ) == EGF_NOGADGETUP )
            sr_RelVerify = FALSE;

        if ( MyTagInArray( PGA_Freedom, e->en_Tags ))
            sr_Lorient = LORIENT_VERT;
        else
            sr_Lorient = LORIENT_HORIZ;

        top     = GetTagData( GTSC_Top,     0, e->en_Tags );
        total   = GetTagData( GTSC_Total,   0, e->en_Tags );
        visible = GetTagData( GTSC_Visible, 2, e->en_Tags );
        arrows  = GetTagData( GTSC_Arrows,  8, e->en_Tags );

        if (( e->en_SpecialFlags & EGF_DISABLED ) == EGF_DISABLED )
            sr_Disabled = TRUE;
        else
            sr_Disabled = FALSE;

    } else {
        if ( x > x1 ) { gw = x; x = x1; x1 = gw; }
        if ( y > y1 ) { gh = y; y = y1; y1 = gh; }

        gw = x1 - x + 1;
        gh = y1 - y + 1;
    }

    btop  = MainScreen->WBorTop + 1 + MainScreen->RastPort.TxHeight;
    bleft = MainScreen->WBorLeft;

    w = bleft + MainScreen->WBorRight  + 300;
    h = btop  + MainScreen->WBorBottom + 182;
    l = (( MainScreen->Width  >> 1 ) - ( w >> 1 ));
    t = (( MainScreen->Height >> 1 ) - ( h >> 1 ));

    sr_Zoom[0] = 0;
    sr_Zoom[1] = btop;
    sr_Zoom[2] = 200;
    sr_Zoom[3] = btop;

    sr_nwTags[0 ].ti_Data = l;
    sr_nwTags[1 ].ti_Data = t;
    sr_nwTags[2 ].ti_Data = w;
    sr_nwTags[3 ].ti_Data = h;
    sr_nwTags[10].ti_Data = (Tag)MainScreen;

    if ( g = CreateContext( &sr_GList ))  {

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

        sr_Gadgets[ GD_TEXT ] = g;

        ng.ng_TopEdge       =   btop + 20;
        ng.ng_GadgetText    =   "_Label";
        ng.ng_GadgetID      =   GD_LABEL;

        g = CreateGadget( STRING_KIND, g, &ng, GTST_String, (Tag)slabel, GTST_MaxChars, (Tag)GT_MAXLABEL + 1, GT_Underscore, (Tag)'_', TAG_DONE );

        SetStringGadget( g );

        sr_Gadgets[ GD_LABEL ] = g;

        ng.ng_LeftEdge      =   bleft + 96;
        ng.ng_TopEdge       =   btop + 36;
        ng.ng_GadgetText    =   "_Underscore";
        ng.ng_GadgetID      =   GD_UNDERSCORE;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)sr_Score, GT_Underscore, (Tag)'_', TAG_DONE );

        sr_Gadgets[ GD_UNDERSCORE ] = g;

        ng.ng_LeftEdge      =   bleft + 266;
        ng.ng_GadgetText    =   "_Disabled  ";
        ng.ng_GadgetID      =   GD_DISABLED;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)sr_Disabled, GT_Underscore, (Tag)'_', TAG_DONE );

        sr_Gadgets[ GD_DISABLED ] = g;

        ng.ng_LeftEdge      =   bleft + 96;
        ng.ng_TopEdge       =   btop + 51;
        ng.ng_GadgetText    =   "_High Label";
        ng.ng_GadgetID      =   GD_HIGHLABEL;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)high, GT_Underscore, '_', TAG_DONE );

        sr_Gadgets[ GD_HIGHLABEL ] = g;

        ng.ng_LeftEdge      =   bleft + 266;
        ng.ng_GadgetText    =   "_Immediate ";
        ng.ng_GadgetID      =   GD_IMMEDIATE;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)sr_Immediate, GT_Underscore, '_', TAG_DONE );

        sr_Gadgets[ GD_IMMEDIATE ] = g;

        ng.ng_LeftEdge      =   bleft + 96;
        ng.ng_TopEdge       =   btop +  66;
        ng.ng_GadgetText    =   "_Relverify ";
        ng.ng_GadgetID      =   GD_RELVERIFY;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)sr_RelVerify, GT_Underscore, '_', TAG_DONE );

        sr_Gadgets[ GD_RELVERIFY ] = g;

        ng.ng_TopEdge       =   btop + 64;
        ng.ng_LeftEdge      =   bleft + 266;
        ng.ng_GadgetText    =   0l;
        ng.ng_GadgetID      =   GD_LORIENT;

        g = CreateGadget( MX_KIND, g, &ng, GTMX_Labels, sr_Free, GTMX_Active, (Tag)sr_Lorient - 1, GT_Underscore, '_', TAG_DONE );

        sr_Gadgets[ GD_LORIENT ] = g;

        ng.ng_LeftEdge      =   bleft + 96;
        ng.ng_TopEdge       =   btop + 84;
        ng.ng_Width         =   196;
        ng.ng_Height        =   12;
        ng.ng_GadgetText    =   "To_p       ";
        ng.ng_GadgetID      =   GD_TOP;

        g = CreateGadget( INTEGER_KIND, g, &ng, GTIN_Number, top, GTIN_MaxChars, 5l, GT_Underscore, '_', TAG_DONE );

        SetStringGadget( g );

        sr_Gadgets[ GD_TOP ] = g;

        ng.ng_TopEdge       =   btop + 100;
        ng.ng_GadgetText    =   "Tot_al     ";
        ng.ng_GadgetID      =   GD_TOTAL;

        g = CreateGadget( INTEGER_KIND, g, &ng, GTIN_Number, total, GTIN_MaxChars, 5l, GT_Underscore, '_', TAG_DONE );

        SetStringGadget( g );

        sr_Gadgets[ GD_TOTAL ] = g;

        ng.ng_TopEdge       =   btop + 116;
        ng.ng_GadgetText    =   "Vi_sible   ";
        ng.ng_GadgetID      =   GD_VISIBLE;

        g = CreateGadget( INTEGER_KIND, g, &ng, GTIN_Number, visible, GTIN_MaxChars, 5l, GT_Underscore, '_', TAG_DONE );

        SetStringGadget( g );

        sr_Gadgets[ GD_VISIBLE ] = g;

        ng.ng_TopEdge       =   btop + 132;
        ng.ng_GadgetText    =   "Arro_ws    ";
        ng.ng_GadgetID      =   GD_ARROWS;

        g = CreateGadget( INTEGER_KIND, g, &ng, GTIN_Number, arrows, GTIN_MaxChars, 5l, GT_Underscore, '_', TAG_DONE );

        SetStringGadget( g );

        sr_Gadgets[ GD_ARROWS ] = g;

        ng.ng_TopEdge       =   btop + 148;
        ng.ng_Height        =   13;
        ng.ng_GadgetText    =   "T_ext Place";
        ng.ng_GadgetID      =   GD_TEXTPLACE;

        g = CreateGadget( CYCLE_KIND, g, &ng, GTCY_Labels, (Tag)cycle, GTCY_Active, place, GT_Underscore, (Tag)'_', TAG_DONE );

        sr_Gadgets[ GD_TEXTPLACE ] = g;

        ng.ng_LeftEdge      =   bleft + 8;
        ng.ng_TopEdge       =   btop + 165;
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

            sr_nwTags[6].ti_Data = (Tag)sr_GList;

            if ( sr_Wnd = OpenWindowTagList( 0l, sr_nwTags )) {

                sr_Zoom[0] = l;
                sr_Zoom[1] = t;
                sr_Zoom[2] = w;
                sr_Zoom[3] = h;

                GT_RefreshWindow( sr_Wnd, 0l );

                do {
                    WaitPort( sr_Wnd->UserPort );

                    while ( ReadIMsg( sr_Wnd )) {

                        switch ( Class ) {

                            case    IDCMP_REFRESHWINDOW:
                                GT_BeginRefresh( sr_Wnd );
                                GT_EndRefresh( sr_Wnd, TRUE );
                                break;

                            case    IDCMP_CLOSEWINDOW:
                                running = FALSE;
                                break;

                            case    IDCMP_GADGETDOWN:
                                switch( theObject->GadgetID ) {

                                    case    GD_LORIENT:
                                        if ( NOT Code ) sr_Lorient = LORIENT_HORIZ;
                                        else            sr_Lorient = LORIENT_VERT;
                                        break;
                                }
                                break;

                            case    IDCMP_GADGETUP:
                                switch( theObject->GadgetID ) {

                                    case    GD_UNDERSCORE:
                                        FlipFlop( 0l, 0l, 0l, &sr_Score );
                                        break;

                                    case    GD_DISABLED:
                                        FlipFlop( 0l, 0l, 0l, &sr_Disabled );
                                        break;

                                    case    GD_HIGHLABEL:
                                        FlipFlop( 0l, 0l, 0l, &high );
                                        break;

                                    case    GD_IMMEDIATE:
                                        FlipFlop( 0l, 0l, 0l, &sr_Immediate );
                                        break;

                                    case    GD_RELVERIFY:
                                        FlipFlop( 0l, 0l, 0l, &sr_RelVerify );
                                        break;

                                    case    GD_TOP:

                                        num = (( struct StringInfo * )sr_Gadgets[ GD_TOP ]->SpecialInfo )->LongInt;

                                        if ( num < 0 ) {
                                            DisplayBeep( MainScreen );
                                            GT_SetGadgetAttrs( sr_Gadgets[ GD_TOP ], sr_Wnd, 0l, GTIN_Number, 0l, TAG_DONE );
                                        }
                                        break;

                                    case    GD_TOTAL:

                                        num = (( struct StringInfo * )sr_Gadgets[ GD_TOTAL ]->SpecialInfo )->LongInt;

                                        if ( num < 0 ) {
                                            DisplayBeep( MainScreen );
                                            GT_SetGadgetAttrs( sr_Gadgets[ GD_TOTAL ], sr_Wnd, 0l, GTIN_Number, 0l, TAG_DONE );
                                        }
                                        break;

                                    case    GD_VISIBLE:

                                        num = (( struct StringInfo * )sr_Gadgets[ GD_VISIBLE ]->SpecialInfo )->LongInt;

                                        if ( num < 0 ) {
                                            DisplayBeep( MainScreen );
                                            GT_SetGadgetAttrs( sr_Gadgets[ GD_VISIBLE ], sr_Wnd, 0l, GTIN_Number, 0l, TAG_DONE );
                                        }
                                        break;

                                    case    GD_ARROWS:

                                        num = (( struct StringInfo * )sr_Gadgets[ GD_TOP ]->SpecialInfo )->LongInt;

                                        if ( num < 0 ) {
                                            DisplayBeep( MainScreen );
                                            GT_SetGadgetAttrs( sr_Gadgets[ GD_ARROWS ], sr_Wnd, 0l, GTIN_Number, 0l, TAG_DONE );
                                        }
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
                                        FlipFlop( sr_Wnd, sr_Gadgets, GD_UNDERSCORE, &sr_Score );
                                        break;

                                    case    'd':
                                        FlipFlop( sr_Wnd, sr_Gadgets, GD_DISABLED, &sr_Disabled );
                                        break;

                                    case    'h':
                                        FlipFlop( sr_Wnd, sr_Gadgets, GD_HIGHLABEL, &high );
                                        break;

                                    case    'i':
                                        FlipFlop( sr_Wnd, sr_Gadgets, GD_IMMEDIATE, &sr_Immediate );
                                        break;

                                    case    'r':
                                        FlipFlop( sr_Wnd, sr_Gadgets, GD_RELVERIFY, &sr_RelVerify );
                                        break;

                                    case    'z':
                                        sr_Lorient = LORIENT_HORIZ;
                                        GT_SetGadgetAttrs( sr_Gadgets[ GD_LORIENT ], sr_Wnd, 0l, GTMX_Active, 0l, TAG_DONE );
                                        break;

                                    case    'v':
                                        sr_Lorient = LORIENT_VERT;
                                        GT_SetGadgetAttrs( sr_Gadgets[ GD_LORIENT ], sr_Wnd, 0l, GTMX_Active, 1l, TAG_DONE );
                                        break;

                                    case    'p':
                                        ID = GD_TOP;
                                        goto Activate;

                                    case    'a':
                                        ID = GD_TOTAL;
                                        goto Activate;

                                    case    's':
                                        ID = GD_VISIBLE;
                                        goto Activate;

                                    case    'w':
                                        ID = GD_ARROWS;
                                        goto Activate;

                                    case    'e':
                                        if ( place++ == 3 )
                                            place = 0;

                                        flag = PlaceFlags[ place + 1 ];
                                        GT_SetGadgetAttrs( sr_Gadgets[ GD_TEXTPLACE ], sr_Wnd, 0l, GTCY_Active, place, TAG_DONE );
                                        break;

                                    case    'o':
                                        goto Ok;

                                    case    'c':
                                        goto Cancel;
                                }
                                break;
                                Activate:
                                ActivateGadget( sr_Gadgets[ ID ], sr_Wnd, 0l );
                                break;
                        }
                    }
                } while ( running );
            }
        }
    }

    if ( ok) {
        if ( high ) flag |= NG_HIGHLABEL;

        ngFlags     =   flag;
        ngLeft      =   x;
        ngTop       =   y;
        ngWidth     =   gw;
        ngHeight    =   gh;
        if ( NOT edit )
            ok = MakeScroller();
        else {
            RemoveAllGadgets();
            ChangeScroller( e );
            Renumber();
            ok = RemakeAllGadgets();
        }
    } else if ( NOT edit )
        Box( x, y, x1, y1 );

    if ( sr_Wnd )           CloseWindow( sr_Wnd );
    if ( sr_GList )         FreeGadgets( sr_GList );

    sr_Wnd     = 0l;
    sr_GList   =  0l;

    ClearMsgPort( MainWindow->UserPort );

    return( (long)ok );
}
