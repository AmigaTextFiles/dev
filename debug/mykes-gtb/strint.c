/*-- AutoRev header do NOT edit!
*
*   Program         :   StrInt.c
*   Copyright       :   © Copyright 1991 Jaba Development
*   Author          :   Jan van den Baard
*   Creation Date   :   05-Oct-91
*   Current version :   1.00
*   Translator      :   DICE v2.6
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   05-Oct-91     1.00            String and Integer editor.
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
extern UWORD                ActiveKind;
extern BOOL                 Saved;

/*
 * --- Gadget ID's
 */
#define GD_TEXT             0
#define GD_LABEL            1
#define GD_UNDERSCORE       2
#define GD_DISABLED         3
#define GD_HIGHLABEL        4
#define GD_DEFCONTENTS      5
#define GD_MAXCHARS         7
#define GD_TEXTPLACE        8
#define GD_OK               9
#define GD_CANCEL           10

/*
 * --- Module data
 */
struct Window              *si_Wnd    = NULL;
struct Gadget              *si_GList  = NULL;
struct Gadget              *si_Gadgets[11];
BOOL                        si_Score   = FALSE, si_Disabled = FALSE;
WORD                        si_Zoom[4];

UBYTE                      *si_String = "Edit STRING gadget:";
UBYTE                      *si_Int    = "Edit INTEGER gadget:";

struct TagItem              si_nwTags[] = {
    WA_Left,                0l,
    WA_Top,                 0l,
    WA_Width,               0l,
    WA_Height,              0l,
    WA_IDCMP,               IDCMP_CLOSEWINDOW | CYCLEIDCMP | BUTTONIDCMP | CHECKBOXIDCMP | IDCMP_REFRESHWINDOW | IDCMP_VANILLAKEY,
    WA_Flags,               WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_CLOSEGADGET | WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_RMBTRAP,
    WA_Gadgets,             0l,
    WA_Title,               0l,
    WA_AutoAdjust,          TRUE,
    WA_Zoom,                (Tag)si_Zoom,
    WA_CustomScreen,        0l,
    TAG_DONE };

/*
 * --- Create the string/integer gadget.
 */
long MakeStrInt( void )
{
    struct ExtNewGadget *eng  = 0l;
    struct TagItem      *tags = 0l;

    if ( eng = Malloc((long)sizeof( struct ExtNewGadget ))) {
        if ( tags = MakeTagList( 4l )) {

            eng->en_NumTags = 4l;
            eng->en_Tags = tags;

            eng->en_Kind = ActiveKind;

            ChangeStrInt( eng );

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
 * --- Change the string/integer gadget.
 */
void ChangeStrInt( struct ExtNewGadget *eng )
{
    struct TagItem      *tags;
    UBYTE               *slab, *text, *defstr, tn = 0;

    tags = eng->en_Tags;

    slab = (( struct StringInfo * )si_Gadgets[ GD_LABEL ]->SpecialInfo )->Buffer;
    text = (( struct StringInfo * )si_Gadgets[ GD_TEXT  ]->SpecialInfo )->Buffer;

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

    if ( si_Score && strlen( text )) {
        tags[ tn   ].ti_Tag  = GT_Underscore;
        tags[ tn++ ].ti_Data = (Tag)'_';
    }

    if ( si_Disabled )
        eng->en_SpecialFlags |= EGF_DISABLED;

    if ( eng->en_Kind == INTEGER_KIND ) {
        tags[ tn   ].ti_Tag  = GTIN_Number;
        tags[ tn++ ].ti_Data = eng->en_DefInt = (( struct StringInfo * )si_Gadgets[ GD_DEFCONTENTS ]->SpecialInfo )->LongInt;

        tags[ tn   ].ti_Tag  = GTIN_MaxChars;
        tags[ tn++ ].ti_Data = eng->en_MaxChars = (( struct StringInfo * )si_Gadgets[ GD_MAXCHARS ]->SpecialInfo )->LongInt;
    } else {
        defstr = (( struct StringInfo * )si_Gadgets[ GD_DEFCONTENTS ]->SpecialInfo )->Buffer;

        if ( strlen( defstr )) {
            if ( eng->en_DefString )
                free(eng->en_DefString);

            if ( eng->en_DefString = Malloc(strlen( defstr ) + 1)) {
                tags[ tn   ].ti_Tag  = GTST_String;
                tags[ tn++ ].ti_Data = (ULONG)eng->en_DefString;
                strcpy( eng->en_DefString, defstr );
            }
        }

        tags[ tn   ].ti_Tag  = GTST_MaxChars;
        tags[ tn++ ].ti_Data = eng->en_MaxChars = (( struct StringInfo * )si_Gadgets[ GD_MAXCHARS ]->SpecialInfo )->LongInt;
    }

    tags[ tn ].ti_Tag = TAG_DONE;

    Saved = FALSE;
}

/*
 * --- Open the EditStrInt requester.
 */
long EditStrInt( WORD x, WORD y, WORD x1, WORD y1, struct Gadget *edit )
{
    struct Gadget       *g;
    struct ExtNewGadget *e;
    struct NewGadget     ng;
    BOOL                 running = TRUE, ok = FALSE;
    WORD                 l, t, w, h, btop, bleft, gw, gh;
    UBYTE               *label = 0l, *slabel = 0l;
    UBYTE              **cycle, *defstr = 0l;
    Tag                  place = 0l, defint = 0l, maxn = 10, maxc = 256;
    LONG                 num;
    UWORD                flag  = PLACETEXT_LEFT, high = FALSE, kind, ID;

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

        si_Score = MyTagInArray( GT_Underscore, e->en_Tags );

        if (( e->en_SpecialFlags & EGF_DISABLED ) == EGF_DISABLED )
            si_Disabled = TRUE;
        else
            si_Disabled = FALSE;

        if ( e->en_Kind == STRING_KIND )
            defstr = e->en_DefString;
        else
            defint = e->en_DefInt;

        maxn = maxc = e->en_MaxChars;

        kind = e->en_Kind;
    } else {
        if ( x > x1 ) { gw = x; x = x1; x1 = gw; }
        if ( y > y1 ) { gh = y; y = y1; y1 = gh; }

        gw = x1 - x + 1;
        gh = y1 - y + 1;

        kind = ActiveKind;
    }

    if ( kind == STRING_KIND )
        si_nwTags[7].ti_Data = (Tag)si_String;
    else
        si_nwTags[7].ti_Data = (Tag)si_Int;

    cycle = &PlaceList[1];

    btop  = MainScreen->WBorTop + 1 + MainScreen->RastPort.TxHeight;
    bleft = MainScreen->WBorLeft;

    w = bleft + MainScreen->WBorRight  + 300;
    h = btop  + MainScreen->WBorBottom + 132;
    l = (( MainScreen->Width  >> 1 ) - ( w >> 1 ));
    t = (( MainScreen->Height >> 1 ) - ( h >> 1 ));

    si_Zoom[0] = 0;
    si_Zoom[1] = btop;
    si_Zoom[2] = 200;
    si_Zoom[3] = btop;

    si_nwTags[0 ].ti_Data = l;
    si_nwTags[1 ].ti_Data = t;
    si_nwTags[2 ].ti_Data = w;
    si_nwTags[3 ].ti_Data = h;
    si_nwTags[10].ti_Data = (Tag)MainScreen;

    if ( g = CreateContext( &si_GList ))  {

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

        si_Gadgets[ GD_TEXT ] = g;

        ng.ng_TopEdge       =   btop + 20;
        ng.ng_GadgetText    =   "_Label";
        ng.ng_GadgetID      =   GD_LABEL;

        g = CreateGadget( STRING_KIND, g, &ng, GTST_String, (Tag)slabel, GTST_MaxChars, (Tag)GT_MAXLABEL + 1, GT_Underscore, (Tag)'_', TAG_DONE );

        SetStringGadget( g );

        si_Gadgets[ GD_LABEL ] = g;

        ng.ng_LeftEdge      =   bleft + 96;
        ng.ng_TopEdge       =   btop + 36;
        ng.ng_GadgetText    =   "_Underscore";
        ng.ng_GadgetID      =   GD_UNDERSCORE;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)si_Score, GT_Underscore, (Tag)'_', TAG_DONE );

        si_Gadgets[ GD_UNDERSCORE ] = g;

        ng.ng_LeftEdge      =   bleft + 266;
        ng.ng_GadgetText    =   "_Disabled";
        ng.ng_GadgetID      =   GD_DISABLED;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)si_Disabled, GT_Underscore, (Tag)'_', TAG_DONE );

        si_Gadgets[ GD_DISABLED ] = g;

        ng.ng_LeftEdge      =   bleft + 96;
        ng.ng_TopEdge       =   btop + 51;
        ng.ng_GadgetText    =   "_High Label";
        ng.ng_GadgetID      =   GD_HIGHLABEL;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)high, GT_Underscore, '_', TAG_DONE );

        si_Gadgets[ GD_HIGHLABEL ] = g;

        ng.ng_LeftEdge      =   bleft + 96;
        ng.ng_TopEdge       =   btop + 66;
        ng.ng_Width         =   196;
        ng.ng_Height        =   12;
        ng.ng_GadgetText    =   "_MaxChars  ";
        ng.ng_GadgetID      =   GD_MAXCHARS;

        if ( kind == STRING_KIND )
            g = CreateGadget( INTEGER_KIND, g, &ng, GTIN_Number, maxc, GTIN_MaxChars, 10l, GT_Underscore, '_', TAG_DONE );
        else
            g = CreateGadget( INTEGER_KIND, g, &ng, GTIN_Number, maxn, GTIN_MaxChars, 10l, GT_Underscore, '_', TAG_DONE );

        SetStringGadget( g );

        si_Gadgets[ GD_MAXCHARS ] = g;

        ng.ng_TopEdge       =   btop + 82;
        ng.ng_GadgetID      =   GD_DEFCONTENTS;

        if ( kind == STRING_KIND ) {
            ng.ng_GadgetText    =   "_String    ";
            g = CreateGadget( STRING_KIND, g, &ng, GTST_String, defstr, GTST_MaxChars, 256l, GT_Underscore, '_', TAG_DONE );
        } else {
            ng.ng_GadgetText    =   "_Number    ";
            g = CreateGadget( INTEGER_KIND, g, &ng, GTIN_Number, defint, GTIN_MaxChars, 10l, GT_Underscore, '_', TAG_DONE );
        }

        SetStringGadget( g );

        si_Gadgets[ GD_DEFCONTENTS ] = g;

        ng.ng_TopEdge       =   btop + 98;
        ng.ng_Height        =   13;
        ng.ng_GadgetText    =   "Text _Place";
        ng.ng_GadgetID      =   GD_TEXTPLACE;

        g = CreateGadget( CYCLE_KIND, g, &ng, GTCY_Labels, (Tag)cycle, GTCY_Active, place, GT_Underscore, (Tag)'_', TAG_DONE );

        si_Gadgets[ GD_TEXTPLACE ] = g;

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

            si_nwTags[6].ti_Data = (Tag)si_GList;

            if ( si_Wnd = OpenWindowTagList( 0l, si_nwTags )) {

                si_Zoom[0] = l;
                si_Zoom[1] = t;
                si_Zoom[2] = w;
                si_Zoom[3] = h;

                GT_RefreshWindow( si_Wnd, 0l );

                do {
                    WaitPort( si_Wnd->UserPort );

                    while ( ReadIMsg( si_Wnd )) {

                        switch ( Class ) {

                            case    IDCMP_REFRESHWINDOW:
                                GT_BeginRefresh( si_Wnd );
                                GT_EndRefresh( si_Wnd, TRUE );
                                break;

                            case    IDCMP_CLOSEWINDOW:
                                running = FALSE;
                                break;

                            case    IDCMP_GADGETUP:
                                switch( theObject->GadgetID ) {

                                    case    GD_UNDERSCORE:
                                        FlipFlop( 0l, 0l, 0l, &si_Score );
                                        break;

                                    case    GD_DISABLED:
                                        FlipFlop( 0l, 0l, 0l, &si_Disabled );
                                        break;

                                    case    GD_HIGHLABEL:
                                        FlipFlop( 0l, 0l, 0l, &high );
                                        break;

                                    case    GD_MAXCHARS:
                                        num = (( struct StringInfo * )si_Gadgets[ GD_MAXCHARS ]->SpecialInfo )->LongInt;

                                        if ( num < 2l ) {
                                            DisplayBeep( MainScreen );
                                            GT_SetGadgetAttrs( si_Gadgets[ GD_MAXCHARS ], si_Wnd, 0l, GTIN_Number, 2l, TAG_DONE );
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
                                        FlipFlop( si_Wnd, si_Gadgets, GD_UNDERSCORE, &si_Score );
                                        break;

                                    case    'd':
                                        FlipFlop( si_Wnd, si_Gadgets, GD_DISABLED, &si_Disabled );
                                        break;

                                    case    'm':
                                        ID = GD_MAXCHARS;
                                        goto Activate;

                                    case    's':
                                        if ( kind == STRING_KIND ) {
                                            ID = GD_DEFCONTENTS;
                                            goto Activate;
                                        }
                                        break;

                                    case    'n':
                                        if ( kind == INTEGER_KIND ) {
                                            ID = GD_DEFCONTENTS;
                                            goto Activate;
                                        }
                                        break;

                                    case    'h':
                                        FlipFlop( si_Wnd, si_Gadgets, GD_HIGHLABEL, &high );
                                        break;

                                    case    'p':
                                        if ( place++ == 3 )
                                            place = 0;

                                        flag = PlaceFlags[ place + 1 ];
                                        GT_SetGadgetAttrs( si_Gadgets[ GD_TEXTPLACE ], si_Wnd, 0l, GTCY_Active, place, TAG_DONE );
                                        break;

                                    case    'o':
                                        goto Ok;

                                    case    'c':
                                        goto Cancel;
                                }
                                break;
                                Activate:
                                ActivateGadget( si_Gadgets[ ID ], si_Wnd, 0l );
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
            ok = MakeStrInt();
        else {
            RemoveAllGadgets();
            ChangeStrInt( e );
            Renumber();
            ok = RemakeAllGadgets();
        }
    } else if ( NOT edit )
        Box( x, y, x1, y1 );

    if ( si_Wnd )           CloseWindow( si_Wnd );
    if ( si_GList )         FreeGadgets( si_GList );

    si_Wnd     = 0l;
    si_GList   = 0l;

    ClearMsgPort( MainWindow->UserPort );

    return( (long)ok );
}
