/*-- AutoRev header do NOT edit!
*
*   Program         :   CheckBox.c
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
*   05-Oct-91     1.00            CheckBox editor.
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
#define GD_CHECKED          4
#define GD_HIGHLABEL        5
#define GD_TEXTPLACE        6
#define GD_OK               7
#define GD_CANCEL           8

/*
 * --- Module data
 */
struct Window              *ec_Wnd    = NULL;
struct Gadget              *ec_GList  = NULL;
struct Gadget              *ec_Gadgets[7];
BOOL                        ec_Score   = FALSE, ec_Disabled = FALSE;
BOOL                        ec_Checked = FALSE;
WORD                        ec_Zoom[4];

struct TagItem              ec_nwTags[] = {
    WA_Left,                0l,
    WA_Top,                 0l,
    WA_Width,               0l,
    WA_Height,              0l,
    WA_IDCMP,               IDCMP_CLOSEWINDOW | CYCLEIDCMP | BUTTONIDCMP | CHECKBOXIDCMP | IDCMP_REFRESHWINDOW | IDCMP_VANILLAKEY,
    WA_Flags,               WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_CLOSEGADGET | WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_RMBTRAP,
    WA_Gadgets,             0l,
    WA_Title,               (ULONG)"Edit CHECKBOX gadget:",
    WA_AutoAdjust,          TRUE,
    WA_Zoom,                (Tag)ec_Zoom,
    WA_CustomScreen,        0l,
    TAG_DONE };

/*
 * --- Create the CheckBox gadget.
 */
long MakeCheckBox( void )
{
    struct ExtNewGadget *eng  = 0l;
    struct TagItem      *tags = 0l;

    if ( eng = Malloc((long)sizeof( struct ExtNewGadget ))) {
        if ( tags = MakeTagList( 2l )) {

            eng->en_NumTags = 2l;
            eng->en_Tags = tags;

            ChangeCheckBox( eng );

            RemoveAllGadgets();

            AddTail(( struct List * )&Gadgets, ( struct Node * )eng );

            Renumber();

            if ( RemakeAllGadgets())
                return TRUE;

            Remove(( struct Node * )eng);
        }
    }

    MyRequest( "Ahem....", "CONTINUE", "Out of memory !" );

    if ( tags )         FreeTagList( tags, 2l );
    if ( eng  )         free( eng );

    return FALSE;
}

/*
 * --- Change the checkbox gadget.
 */
void ChangeCheckBox( struct ExtNewGadget *eng )
{
    struct TagItem      *tags;
    UBYTE               *slab, *text, tn = 0;

    tags = eng->en_Tags;

    slab = (( struct StringInfo * )ec_Gadgets[ GD_LABEL ]->SpecialInfo )->Buffer;
    text = (( struct StringInfo * )ec_Gadgets[ GD_TEXT  ]->SpecialInfo )->Buffer;

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

    eng->en_Kind    = CHECKBOX_KIND;

    if ( ec_Score && strlen( text )) {
        tags[ tn   ].ti_Tag  = GT_Underscore;
        tags[ tn++ ].ti_Data = (Tag)'_';
    }

    if ( ec_Disabled )
        eng->en_SpecialFlags |= EGF_DISABLED;

    if ( ec_Checked ) {
        eng->en_SpecialFlags |= EGF_CHECKED;
        tags[ tn   ].ti_Tag  = GTCB_Checked;
        tags[ tn++ ].ti_Data = TRUE;
    }

    tags[ tn ].ti_Tag = TAG_DONE;

    Saved = FALSE;
}

/*
 * --- Open the EditCheckBox requester.
 */
long EditCheckBox( WORD x, WORD y, WORD x1, WORD y1, struct Gadget *edit )
{
    struct Gadget       *g;
    struct ExtNewGadget *e;
    struct NewGadget     ng;
    BOOL                 running = TRUE, ok = FALSE;
    WORD                 l, t, w, h, btop, bleft, gw, gh;
    UBYTE               *label = 0l, *slabel = 0l;
    UBYTE              **cycle;
    Tag                  place = 0l;
    UWORD                flag  = PLACETEXT_LEFT, high = FALSE, ID;

    cycle = &PlaceList[1];

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

        ec_Score = MyTagInArray( GT_Underscore, e->en_Tags );

        if (( e->en_SpecialFlags & EGF_DISABLED ) == EGF_DISABLED )
            ec_Disabled = TRUE;
        else
            ec_Disabled = FALSE;

        if (( e->en_SpecialFlags & EGF_CHECKED ) == EGF_CHECKED )
            ec_Checked = TRUE;
        else
            ec_Checked = FALSE;

    } else {
        if ( x > x1 ) { gw = x; x = x1; x1 = gw; }
        if ( y > y1 ) { gh = y; y = y1; y1 = gh; }

        gw = x1 - x + 1;
        gh = y1 - y + 1;
    }

    btop  = MainScreen->WBorTop + 1 + MainScreen->RastPort.TxHeight;
    bleft = MainScreen->WBorLeft;

    w = bleft + MainScreen->WBorRight  + 300;
    h = btop  + MainScreen->WBorBottom + 100;
    l = (( MainScreen->Width  >> 1 ) - ( w >> 1 ));
    t = (( MainScreen->Height >> 1 ) - ( h >> 1 ));

    ec_Zoom[0] = 0;
    ec_Zoom[1] = btop;
    ec_Zoom[2] = 200;
    ec_Zoom[3] = btop;

    ec_nwTags[0 ].ti_Data = l;
    ec_nwTags[1 ].ti_Data = t;
    ec_nwTags[2 ].ti_Data = w;
    ec_nwTags[3 ].ti_Data = h;
    ec_nwTags[10].ti_Data = (Tag)MainScreen;

    if ( g = CreateContext( &ec_GList ))  {

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

        ec_Gadgets[ GD_TEXT ] = g;

        ng.ng_TopEdge       =   btop + 20;
        ng.ng_GadgetText    =   "_Label";
        ng.ng_GadgetID      =   GD_LABEL;

        g = CreateGadget( STRING_KIND, g, &ng, GTST_String, (Tag)slabel, GTST_MaxChars, (Tag)GT_MAXLABEL + 1, GT_Underscore, (Tag)'_', TAG_DONE );

        SetStringGadget( g );

        ec_Gadgets[ GD_LABEL ] = g;

        ng.ng_LeftEdge      =   bleft + 96;
        ng.ng_TopEdge       =   btop + 36;
        ng.ng_GadgetText    =   "_Underscore";
        ng.ng_GadgetID      =   GD_UNDERSCORE;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)ec_Score, GT_Underscore, (Tag)'_', TAG_DONE );

        ec_Gadgets[ GD_UNDERSCORE ] = g;

        ng.ng_LeftEdge      =   bleft + 266;
        ng.ng_GadgetText    =   "_Disabled";
        ng.ng_GadgetID      =   GD_DISABLED;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)ec_Disabled, GT_Underscore, (Tag)'_', TAG_DONE );

        ec_Gadgets[ GD_DISABLED ] = g;

        ng.ng_LeftEdge      =   bleft + 96;
        ng.ng_TopEdge       =   btop + 51;
        ng.ng_GadgetText    =   "_High Label";
        ng.ng_GadgetID      =   GD_HIGHLABEL;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)high, GT_Underscore, '_', TAG_DONE );

        ec_Gadgets[ GD_HIGHLABEL ] = g;

        ng.ng_LeftEdge      =   bleft + 266;
        ng.ng_GadgetText    =   "Ch_ecked ";
        ng.ng_GadgetID      =   GD_CHECKED;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)ec_Checked, GT_Underscore, '_', TAG_DONE );

        ec_Gadgets[ GD_CHECKED ] = g;

        ng.ng_LeftEdge      =   bleft + 96;
        ng.ng_TopEdge       =   btop + 66;
        ng.ng_Width         =   196;
        ng.ng_Height        =   13;
        ng.ng_GadgetText    =   "Text _Place";
        ng.ng_GadgetID      =   GD_TEXTPLACE;

        g = CreateGadget( CYCLE_KIND, g, &ng, GTCY_Labels, (Tag)cycle, GTCY_Active, place, GT_Underscore, (Tag)'_', TAG_DONE );

        ec_Gadgets[ GD_TEXTPLACE ] = g;

        ng.ng_LeftEdge      =   bleft + 8;
        ng.ng_TopEdge       =   btop + 83;
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

            ec_nwTags[6].ti_Data = (Tag)ec_GList;

            if ( ec_Wnd = OpenWindowTagList( 0l, ec_nwTags )) {

                ec_Zoom[0] = l;
                ec_Zoom[1] = t;
                ec_Zoom[2] = w;
                ec_Zoom[3] = h;

                GT_RefreshWindow( ec_Wnd, 0l );

                do {
                    WaitPort( ec_Wnd->UserPort );

                    while ( ReadIMsg( ec_Wnd )) {

                        switch ( Class ) {

                            case    IDCMP_REFRESHWINDOW:
                                GT_BeginRefresh( ec_Wnd );
                                GT_EndRefresh( ec_Wnd, TRUE );
                                break;

                            case    IDCMP_CLOSEWINDOW:
                                running = FALSE;
                                break;

                            case    IDCMP_GADGETUP:
                                switch( theObject->GadgetID ) {

                                    case    GD_UNDERSCORE:
                                        FlipFlop(  0l, 0l, 0l, &ec_Score );
                                        break;

                                    case    GD_DISABLED:
                                        FlipFlop( 0l, 0l, 0l, &ec_Disabled );
                                        break;

                                    case    GD_CHECKED:
                                        FlipFlop( 0l, 0l, 0l, &ec_Checked );
                                        break;

                                    case    GD_HIGHLABEL:
                                        FlipFlop( 0l, 0l, 0l, &high );
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
                                        FlipFlop( ec_Wnd, ec_Gadgets, GD_UNDERSCORE, &ec_Score );
                                        break;

                                    case    'd':
                                        FlipFlop( ec_Wnd, ec_Gadgets, GD_DISABLED, &ec_Disabled );
                                        break;

                                    case    'h':
                                        FlipFlop( ec_Wnd, ec_Gadgets, GD_HIGHLABEL, &high );
                                        break;

                                    case    'e':
                                        FlipFlop( ec_Wnd, ec_Gadgets, GD_CHECKED, &ec_Checked );
                                        break;

                                    case    'p':
                                        if ( place++ == 3 )
                                            place = 0;

                                        flag = PlaceFlags[ place + 1 ];
                                        GT_SetGadgetAttrs( ec_Gadgets[ GD_TEXTPLACE ], ec_Wnd, 0l, GTCY_Active, place, TAG_DONE );
                                        break;

                                    case    'o':
                                        goto Ok;

                                    case    'c':
                                        goto Cancel;
                                }
                                break;
                                Activate:
                                ActivateGadget( ec_Gadgets[ ID ], ec_Wnd, 0l );
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
            ok = MakeCheckBox();
        else {
            RemoveAllGadgets();
            ChangeCheckBox( e );
            Renumber();
            ok = RemakeAllGadgets();
        }
    } else if ( NOT edit )
        Box( x, y, x1, y1 );

    if ( ec_Wnd )           CloseWindow( ec_Wnd );
    if ( ec_GList )         FreeGadgets( ec_GList );

    ec_Wnd     = 0l;
    ec_GList   = 0l;

    ClearMsgPort( MainWindow->UserPort );

    return( (long)ok );
}
