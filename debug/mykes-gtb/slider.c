/*-- AutoRev header do NOT edit!
*
*   Program         :   Slider.c
*   Copyright       :   © Copyright 1991 Jaba Development
*   Author          :   Jan van den Baard
*   Creation Date   :   08-Oct-91
*   Current version :   1.00
*   Translator      :   DICE v2.6
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   08-Oct-91     1.00            Slider editor.
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
#define GD_MIN              8
#define GD_MAX              9
#define GD_LEVEL            10
#define GD_LEVELLEN         11
#define GD_LEVELFORMAT      12
#define GD_LEVELPLACE       13
#define GD_TEXTPLACE        14
#define GD_OK               15
#define GD_CANCEL           16

/*
 * --- Module data
 */
struct Window              *sl_Wnd    = NULL;
struct Gadget              *sl_GList  = NULL;
struct Gadget              *sl_Gadgets[15];
BOOL                        sl_Score = FALSE, sl_Disabled = FALSE;
BOOL                        sl_Immediate = FALSE;
BOOL                        sl_RelVerify = FALSE;
UWORD                       sl_Lorient = LORIENT_HORIZ, sl_Place = PLACETEXT_LEFT;
WORD                        sl_Zoom[4];
UBYTE                      *sl_Free[] = {
    "Hori_zontal", "_Vertical  ", 0l };

struct TagItem              sl_nwTags[] = {
    WA_Left,                0l,
    WA_Top,                 0l,
    WA_Width,               0l,
    WA_Height,              0l,
    WA_IDCMP,               IDCMP_CLOSEWINDOW | CYCLEIDCMP | BUTTONIDCMP | CHECKBOXIDCMP | MXIDCMP | IDCMP_REFRESHWINDOW | IDCMP_VANILLAKEY,
    WA_Flags,               WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_CLOSEGADGET | WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_RMBTRAP,
    WA_Gadgets,             0l,
    WA_Title,               (ULONG)"Edit SLIDER gadget:",
    WA_AutoAdjust,          TRUE,
    WA_Zoom,                (Tag)sl_Zoom,
    WA_CustomScreen,        0l,
    TAG_DONE };

/*
 * --- Create the slider gadget.
 */
long MakeSlider( void )
{
    struct ExtNewGadget *eng  = 0l;
    struct TagItem      *tags = 0l;

    if ( eng = Malloc((long)sizeof( struct ExtNewGadget ))) {
        if ( tags = MakeTagList( 10l )) {

            eng->en_NumTags = 10l;
            eng->en_Tags = tags;

            ChangeSlider( eng );

            RemoveAllGadgets();

            AddTail(( struct List * )&Gadgets, ( struct Node * )eng );

            Renumber();

            if ( RemakeAllGadgets())
                return TRUE;

            Remove(( struct Node * )eng);
        }
    }

    MyRequest( "Ahem....", "CONTINUE", "Out of memory !" );

    if ( tags )         FreeTagList( tags, 10l );
    if ( eng  )         free(eng);

    return FALSE;
}

/*
 * --- Change the slider gadget.
 */
void ChangeSlider( struct ExtNewGadget *eng )
{
    struct TagItem      *tags;
    UBYTE               *slab, *text, *fmt, tn = 0;
    long                 num;

    tags = eng->en_Tags;

    slab = (( struct StringInfo * )sl_Gadgets[ GD_LABEL ]->SpecialInfo )->Buffer;
    text = (( struct StringInfo * )sl_Gadgets[ GD_TEXT  ]->SpecialInfo )->Buffer;
    fmt  = (( struct StringInfo * )sl_Gadgets[ GD_LEVELFORMAT ]->SpecialInfo )->Buffer;

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

    eng->en_Kind    = SLIDER_KIND;

    if ( sl_Score && strlen( text )) {
        tags[ tn   ].ti_Tag  = GT_Underscore;
        tags[ tn++ ].ti_Data = (Tag)'_';
    }

    if ( sl_Disabled )
        eng->en_SpecialFlags |= EGF_DISABLED;

    if ( NOT sl_RelVerify )
        eng->en_SpecialFlags |= EGF_NOGADGETUP;

    tags[ tn   ].ti_Tag  = GA_RelVerify;
    tags[ tn++ ].ti_Data = TRUE;

    if ( sl_Immediate ) {
        tags[ tn   ].ti_Tag  = GA_Immediate;
        tags[ tn++ ].ti_Data = TRUE;
    }

    if ( sl_Lorient == LORIENT_VERT ) {
        tags[ tn   ].ti_Tag  = PGA_Freedom;
        tags[ tn++ ].ti_Data = sl_Lorient;
    }

    num = (( struct StringInfo * )sl_Gadgets[ GD_MIN ]->SpecialInfo )->LongInt;

    if ( num ) {
        tags[ tn   ].ti_Tag  = GTSL_Min;
        tags[ tn++ ].ti_Data = num;
    }

    num = (( struct StringInfo * )sl_Gadgets[ GD_MAX ]->SpecialInfo )->LongInt;

    if ( num != 15 ) {
        tags[ tn   ].ti_Tag  = GTSL_Max;
        tags[ tn++ ].ti_Data = num;
    }

    num = (( struct StringInfo * )sl_Gadgets[ GD_LEVEL ]->SpecialInfo )->LongInt;

    if ( num ) {
        tags[ tn   ].ti_Tag  = GTSL_Level;
        tags[ tn++ ].ti_Data = num;
    }

    num = (( struct StringInfo * )sl_Gadgets[ GD_LEVELLEN ]->SpecialInfo )->LongInt;

    if ( num ) {
        tags[ tn   ].ti_Tag  = GTSL_MaxLevelLen;
        tags[ tn++ ].ti_Data = num;
    }

    if ( fmt ) {
        if ( eng->en_LevelFormat ) free(eng->en_LevelFormat);

        if ( eng->en_LevelFormat = Malloc(strlen( fmt ) + 1)) {
            tags[ tn   ].ti_Tag  = GTSL_LevelFormat;
            tags[ tn++ ].ti_Data = (ULONG)eng->en_LevelFormat;
            strcpy( eng->en_LevelFormat, fmt );
        }
    }

    if ( sl_Place != PLACETEXT_LEFT ) {
        tags[ tn   ].ti_Tag  = GTSL_LevelPlace;
        tags[ tn++ ].ti_Data = sl_Place;
    }

    tags[ tn ].ti_Tag = TAG_DONE;

    Saved = FALSE;
}

/*
 * --- Open the EditSlider requester.
 */
long EditSlider( WORD x, WORD y, WORD x1, WORD y1, struct Gadget *edit )
{
    struct Gadget       *g;
    struct ExtNewGadget *e;
    struct NewGadget     ng;
    BOOL                 running = TRUE, ok = FALSE, high = FALSE;
    WORD                 l, t, w, h, btop, bleft, gw, gh;
    UBYTE               *label = 0l, *slabel = 0l, *cycle, *cycle1;
    UBYTE               *fmt = 0l;
    Tag                  place = 0l, place1 = 0l, num;
    UWORD                flag  = PLACETEXT_LEFT, ID;
    UWORD                min = 0, max = 15, level = 0, len = 2;

    cycle = cycle1 = (UBYTE *)&PlaceList[1];

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

        sl_Score     = MyTagInArray( GT_Underscore, e->en_Tags );
        sl_Immediate = MyTagInArray( GA_Immediate,  e->en_Tags );
        sl_RelVerify = MyTagInArray( GA_RelVerify,  e->en_Tags );

        if (( e->en_SpecialFlags & EGF_NOGADGETUP ) == EGF_NOGADGETUP )
            sl_RelVerify = FALSE;

        if ( MyTagInArray( PGA_Freedom, e->en_Tags ))
            sl_Lorient = LORIENT_VERT;
        else
            sl_Lorient = LORIENT_HORIZ;

        min      = GetTagData( GTSL_Min,        0, e->en_Tags );
        max      = GetTagData( GTSL_Max,       15, e->en_Tags );
        level    = GetTagData( GTSL_Level,      0, e->en_Tags );
        len      = GetTagData( GTSL_MaxLevelLen,2, e->en_Tags );
        sl_Place = GetTagData( GTSL_LevelPlace, PLACETEXT_LEFT, e->en_Tags );

        if ( sl_Place == PLACETEXT_LEFT  ) place1 = 0l;
        if ( sl_Place == PLACETEXT_RIGHT ) place1 = 1l;
        if ( sl_Place == PLACETEXT_ABOVE ) place1 = 2l;
        if ( sl_Place == PLACETEXT_BELOW ) place1 = 3l;

        fmt = e->en_LevelFormat;

        if (( e->en_SpecialFlags & EGF_DISABLED ) == EGF_DISABLED )
            sl_Disabled = TRUE;
        else
            sl_Disabled = FALSE;

    } else {
        if ( x > x1 ) { gw = x; x = x1; x1 = gw; }
        if ( y > y1 ) { gh = y; y = y1; y1 = gh; }

        gw = x1 - x + 1;
        gh = y1 - y + 1;
    }

    btop  = MainScreen->WBorTop + 1 + MainScreen->RastPort.TxHeight;
    bleft = MainScreen->WBorLeft;

    w = bleft + MainScreen->WBorRight  + 300;
    h = btop  + MainScreen->WBorBottom + 175;
    l = (( MainScreen->Width  >> 1 ) - ( w >> 1 ));
    t = (( MainScreen->Height >> 1 ) - ( h >> 1 ));

    sl_Zoom[0] = 0;
    sl_Zoom[1] = btop;
    sl_Zoom[2] = 200;
    sl_Zoom[3] = btop;

    sl_nwTags[0 ].ti_Data = l;
    sl_nwTags[1 ].ti_Data = t;
    sl_nwTags[2 ].ti_Data = w;
    sl_nwTags[3 ].ti_Data = h;
    sl_nwTags[10].ti_Data = (Tag)MainScreen;

    if ( g = CreateContext( &sl_GList ))  {

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

        sl_Gadgets[ GD_TEXT ] = g;

        ng.ng_TopEdge       =   btop + 16;
        ng.ng_GadgetText    =   "La_bel";
        ng.ng_GadgetID      =   GD_LABEL;

        g = CreateGadget( STRING_KIND, g, &ng, GTST_String, (Tag)slabel, GTST_MaxChars, (Tag)GT_MAXLABEL + 1, GT_Underscore, (Tag)'_', TAG_DONE );

        SetStringGadget( g );

        sl_Gadgets[ GD_LABEL ] = g;

        ng.ng_LeftEdge      =   bleft + 96;
        ng.ng_TopEdge       =   btop + 28;
        ng.ng_GadgetText    =   "_Underscore";
        ng.ng_GadgetID      =   GD_UNDERSCORE;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)sl_Score, GT_Underscore, (Tag)'_', TAG_DONE );

        sl_Gadgets[ GD_UNDERSCORE ] = g;

        ng.ng_LeftEdge      =   bleft + 266;
        ng.ng_GadgetText    =   "_Disabled  ";
        ng.ng_GadgetID      =   GD_DISABLED;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)sl_Disabled, GT_Underscore, (Tag)'_', TAG_DONE );

        sl_Gadgets[ GD_DISABLED ] = g;

        ng.ng_LeftEdge      =   bleft + 96;
        ng.ng_TopEdge       =   btop + 39;
        ng.ng_GadgetText    =   "_High Label";
        ng.ng_GadgetID      =   GD_HIGHLABEL;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)high, GT_Underscore, '_', TAG_DONE );

        sl_Gadgets[ GD_HIGHLABEL ] = g;

        ng.ng_LeftEdge      =   bleft + 266;
        ng.ng_GadgetText    =   "_Immediate ";
        ng.ng_GadgetID      =   GD_IMMEDIATE;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)sl_Immediate, GT_Underscore, '_', TAG_DONE );

        sl_Gadgets[ GD_IMMEDIATE ] = g;

        ng.ng_LeftEdge      =   bleft + 96;
        ng.ng_TopEdge       =   btop +  50;
        ng.ng_GadgetText    =   "_Relverify ";
        ng.ng_GadgetID      =   GD_RELVERIFY;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)sl_RelVerify, GT_Underscore, '_', TAG_DONE );

        sl_Gadgets[ GD_RELVERIFY ] = g;

        ng.ng_TopEdge       =   btop + 50;
        ng.ng_LeftEdge      =   bleft + 266;
        ng.ng_GadgetText    =   0l;
        ng.ng_GadgetID      =   GD_LORIENT;

        g = CreateGadget( MX_KIND, g, &ng, GTMX_Labels, sl_Free, GTMX_Active, (Tag)sl_Lorient - 1, GT_Underscore, '_', TAG_DONE );

        sl_Gadgets[ GD_LORIENT ] = g;

        ng.ng_LeftEdge      =   bleft + 96;
        ng.ng_TopEdge       =   btop + 68;
        ng.ng_Width         =   196;
        ng.ng_Height        =   12;
        ng.ng_GadgetText    =   "_Min       ";
        ng.ng_GadgetID      =   GD_MIN;

        g = CreateGadget( INTEGER_KIND, g, &ng, GTIN_Number, min, GTIN_MaxChars, 5l, GT_Underscore, '_', TAG_DONE );

        SetStringGadget( g );

        sl_Gadgets[ GD_MIN ] = g;

        ng.ng_TopEdge       =   btop + 80;
        ng.ng_GadgetText    =   "Ma_x       ";
        ng.ng_GadgetID      =   GD_MAX;

        g = CreateGadget( INTEGER_KIND, g, &ng, GTIN_Number, max, GTIN_MaxChars, 5l, GT_Underscore, '_', TAG_DONE );

        SetStringGadget( g );

        sl_Gadgets[ GD_MAX ] = g;

        ng.ng_TopEdge       =   btop + 92;
        ng.ng_GadgetText    =   "L_evel     ";
        ng.ng_GadgetID      =   GD_LEVEL;

        g = CreateGadget( INTEGER_KIND, g, &ng, GTIN_Number, level, GTIN_MaxChars, 5l, GT_Underscore, '_', TAG_DONE );

        SetStringGadget( g );

        sl_Gadgets[ GD_LEVEL ] = g;

        ng.ng_TopEdge       =   btop + 104;
        ng.ng_GadgetText    =   "Level _Size";
        ng.ng_GadgetID      =   GD_LEVELLEN;

        g = CreateGadget( INTEGER_KIND, g, &ng, GTIN_Number, len, GTIN_MaxChars, 5l, GT_Underscore, '_', TAG_DONE );

        SetStringGadget( g );

        sl_Gadgets[ GD_LEVELLEN ] = g;

        ng.ng_TopEdge       =   btop +  116;
        ng.ng_GadgetText    =   "_Format    ";
        ng.ng_GadgetID      =   GD_LEVELFORMAT;

        g = CreateGadget( STRING_KIND, g, &ng, GTST_String, fmt, GTIN_MaxChars, 80l, GT_Underscore, '_', TAG_DONE );

        SetStringGadget( g );

        sl_Gadgets[ GD_LEVELFORMAT ] = g;

        ng.ng_TopEdge       =   btop + 128;
        ng.ng_Height        =   13;
        ng.ng_GadgetText    =   "Lev. _Place";
        ng.ng_GadgetID      =   GD_LEVELPLACE;

        g = CreateGadget( CYCLE_KIND, g, &ng, GTCY_Labels, cycle1, GTCY_Active, place1, GT_Underscore, '_', TAG_DONE );

        sl_Gadgets[ GD_LEVELPLACE ] = g;

        ng.ng_TopEdge       =   btop + 141;
        ng.ng_Height        =   13;
        ng.ng_GadgetText    =   "Text P_lace";
        ng.ng_GadgetID      =   GD_TEXTPLACE;

        g = CreateGadget( CYCLE_KIND, g, &ng, GTCY_Labels, (Tag)cycle, GTCY_Active, place, GT_Underscore, (Tag)'_', TAG_DONE );

        sl_Gadgets[ GD_TEXTPLACE ] = g;

        ng.ng_LeftEdge      =   bleft + 8;
        ng.ng_TopEdge       =   btop + 158;
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

            sl_nwTags[6].ti_Data = (Tag)sl_GList;

            if ( sl_Wnd = OpenWindowTagList( 0l, sl_nwTags )) {

                sl_Zoom[0] = l;
                sl_Zoom[1] = t;
                sl_Zoom[2] = w;
                sl_Zoom[3] = h;

                GT_RefreshWindow( sl_Wnd, 0l );

                do {
                    WaitPort( sl_Wnd->UserPort );

                    while ( ReadIMsg( sl_Wnd )) {

                        switch ( Class ) {

                            case    IDCMP_REFRESHWINDOW:
                                GT_BeginRefresh( sl_Wnd );
                                GT_EndRefresh( sl_Wnd, TRUE );
                                break;

                            case    IDCMP_CLOSEWINDOW:
                                running = FALSE;
                                break;

                            case    IDCMP_GADGETDOWN:
                                switch( theObject->GadgetID ) {

                                    case    GD_LORIENT:
                                        if ( NOT Code ) sl_Lorient = LORIENT_HORIZ;
                                        else            sl_Lorient = LORIENT_VERT;
                                        break;
                                }
                                break;

                            case    IDCMP_GADGETUP:
                                switch( theObject->GadgetID ) {

                                    case    GD_UNDERSCORE:
                                        FlipFlop( 0l, 0l, 0l, &sl_Score );
                                        break;

                                    case    GD_DISABLED:
                                        FlipFlop( 0l, 0l, 0l, &sl_Disabled );
                                        break;

                                    case    GD_HIGHLABEL:
                                        FlipFlop( 0l, 0l, 0l, &high );
                                        break;

                                    case    GD_IMMEDIATE:
                                        FlipFlop( 0l, 0l, 0l, &sl_Immediate );
                                        break;

                                    case    GD_RELVERIFY:
                                        FlipFlop( 0l, 0l, 0l, &sl_RelVerify );
                                        break;

                                    case    GD_MIN:

                                        num = (( struct StringInfo * )sl_Gadgets[ GD_MIN ]->SpecialInfo )->LongInt;

                                        if ( num < 0 ) {
                                            DisplayBeep( MainScreen );
                                            GT_SetGadgetAttrs( sl_Gadgets[ GD_MIN ], sl_Wnd, 0l, GTIN_Number, 0l, TAG_DONE );
                                        }
                                        break;

                                    case    GD_MAX:

                                        num = (( struct StringInfo * )sl_Gadgets[ GD_MAX ]->SpecialInfo )->LongInt;

                                        if ( num < 0 ) {
                                            DisplayBeep( MainScreen );
                                            GT_SetGadgetAttrs( sl_Gadgets[ GD_MAX ], sl_Wnd, 0l, GTIN_Number, 0l, TAG_DONE );
                                        }
                                        break;

                                    case    GD_LEVEL:

                                        num = (( struct StringInfo * )sl_Gadgets[ GD_LEVEL ]->SpecialInfo )->LongInt;

                                        if ( num < 0 ) {
                                            DisplayBeep( MainScreen );
                                            GT_SetGadgetAttrs( sl_Gadgets[ GD_LEVEL ], sl_Wnd, 0l, GTIN_Number, 0l, TAG_DONE );
                                        }
                                        break;

                                    case    GD_LEVELLEN:

                                        num = (( struct StringInfo * )sl_Gadgets[ GD_LEVELLEN ]->SpecialInfo )->LongInt;

                                        if ( num < 0 ) {
                                            DisplayBeep( MainScreen );
                                            GT_SetGadgetAttrs( sl_Gadgets[ GD_LEVELLEN ], sl_Wnd, 0l, GTIN_Number, 0l, TAG_DONE );
                                        }
                                        break;

                                    case    GD_LEVELPLACE:
                                        if( place1++ == 3 )
                                            place1 = 0;

                                        sl_Place = PlaceFlags[ place1 + 1 ];
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

                                    case    'b':
                                        ID = GD_LABEL;
                                        goto Activate;

                                    case    'u':
                                        FlipFlop( sl_Wnd, sl_Gadgets, GD_UNDERSCORE, &sl_Score );
                                        break;

                                    case    'd':
                                        FlipFlop( sl_Wnd, sl_Gadgets, GD_DISABLED, &sl_Disabled );
                                        break;

                                    case    'h':
                                        FlipFlop( sl_Wnd, sl_Gadgets, GD_HIGHLABEL, &high );
                                        break;

                                    case    'i':
                                        FlipFlop( sl_Wnd, sl_Gadgets, GD_IMMEDIATE, &sl_Immediate );
                                        break;

                                    case    'r':
                                        FlipFlop( sl_Wnd, sl_Gadgets, GD_RELVERIFY, &sl_RelVerify );
                                        break;

                                    case    'z':
                                        sl_Lorient = LORIENT_HORIZ;
                                        GT_SetGadgetAttrs( sl_Gadgets[ GD_LORIENT ], sl_Wnd, 0l, GTMX_Active, 0l, TAG_DONE );
                                        break;

                                    case    'v':
                                        sl_Lorient = LORIENT_VERT;
                                        GT_SetGadgetAttrs( sl_Gadgets[ GD_LORIENT ], sl_Wnd, 0l, GTMX_Active, 1l, TAG_DONE );
                                        break;

                                    case    'm':
                                        ID = GD_MIN;
                                        goto Activate;

                                    case    'x':
                                        ID = GD_MAX;
                                        goto Activate;

                                    case    'e':
                                        ID = GD_LEVEL;
                                        goto Activate;

                                    case    's':
                                        ID = GD_LEVELLEN;
                                        goto Activate;

                                    case    'f':
                                        ID = GD_LEVELFORMAT;
                                        goto Activate;

                                    case    'p':
                                        if ( place1++ == 3 )
                                            place1 = 0;

                                        sl_Place = PlaceFlags[ place1 + 1 ];
                                        GT_SetGadgetAttrs( sl_Gadgets[ GD_LEVELPLACE ], sl_Wnd, 0l, GTCY_Active, place1, TAG_DONE );
                                        break;

                                    case    'l':
                                        if ( place++ == 3 )
                                            place = 0;

                                        flag = PlaceFlags[ place + 1 ];
                                        GT_SetGadgetAttrs( sl_Gadgets[ GD_TEXTPLACE ], sl_Wnd, 0l, GTCY_Active, place, TAG_DONE );
                                        break;

                                    case    'o':
                                        goto Ok;

                                    case    'c':
                                        goto Cancel;
                                }
                                break;
                                Activate:
                                ActivateGadget( sl_Gadgets[ ID ], sl_Wnd, 0l );
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
            ok = MakeSlider();
        else {
            RemoveAllGadgets();
            ChangeSlider( e );
            Renumber();
            ok = RemakeAllGadgets();
        }
    } else if ( NOT edit )
        Box( x, y, x1, y1 );

    if ( sl_Wnd )           CloseWindow( sl_Wnd );
    if ( sl_GList )         FreeGadgets( sl_GList );

    sl_Wnd     = 0l;
    sl_GList   =  0l;

    ClearMsgPort( MainWindow->UserPort );

    return( (long)ok );
}
