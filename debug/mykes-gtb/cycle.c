/*-- AutoRev header do NOT edit!
*
*   Program         :   Cycle.c
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
*   06-Oct-91     1.00            Cycle editor.
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
extern struct ExtGadgetList Gadgets;
extern UBYTE               *PlaceList[];
extern UWORD                PlaceFlags[];
extern BOOL                 Saved;

/*
 * --- Gadget ID's
 */
#define GD_TEXT             0
#define GD_LABEL            1
#define GD_UNDERSCORE       2
#define GD_DISABLED         3
#define GD_HIGHLABEL        4
#define GD_LABELS           5
#define GD_LABELENTRY       6
#define GD_TEXTPLACE        7
#define GD_REMOVE           8
#define GD_OK               9
#define GD_CANCEL           10

/*
 * --- Module data
 */
struct Window              *cy_Wnd    = NULL;
struct Gadget              *cy_GList  = NULL;
struct Gadget              *cy_Gadgets[8];
BOOL                        cy_UScore = FALSE, cy_Disable = FALSE;
struct List                 cy_Labels;
struct ListViewNode        *cy_Node = 0l;
UWORD                       cy_NumLabels = 0;
WORD                        cy_Zoom[4];

struct TagItem              cy_nwTags[] = {
    WA_Left,                0l,
    WA_Top,                 0l,
    WA_Width,               0l,
    WA_Height,              0l,
    WA_IDCMP,               IDCMP_CLOSEWINDOW | CYCLEIDCMP | BUTTONIDCMP | CHECKBOXIDCMP | LISTVIEWIDCMP | IDCMP_REFRESHWINDOW | IDCMP_VANILLAKEY,
    WA_Flags,               WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_CLOSEGADGET | WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_RMBTRAP,
    WA_Gadgets,             0l,
    WA_Title,               (ULONG)"Edit CYCLE gadget:",
    WA_AutoAdjust,          TRUE,
    WA_Zoom,                (Tag)cy_Zoom,
    WA_CustomScreen,        0l,
    TAG_DONE };

/*
 * --- Create the cycle gadget.
 */
long MakeCycle( void )
{
    struct ExtNewGadget *eng  = 0l;
    struct TagItem      *tags = 0l;

    if ( eng = Malloc((long)sizeof( struct ExtNewGadget ))) {
        if ( tags = MakeTagList( 2l )) {

            eng->en_NumTags = 2l;
            eng->en_Tags = tags;

            ChangeCycle( eng );

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
 * --- Change the cycle gadget.
 */
void ChangeCycle( struct ExtNewGadget *eng )
{
    struct TagItem      *tags;
    UBYTE               *slab, *text, tn = 0;

    tags = eng->en_Tags;

    slab = (( struct StringInfo * )cy_Gadgets[ GD_LABEL ]->SpecialInfo )->Buffer;
    text = (( struct StringInfo * )cy_Gadgets[ GD_TEXT  ]->SpecialInfo )->Buffer;

    eng->en_NewGadget.ng_LeftEdge   =   ngLeft;
    eng->en_NewGadget.ng_TopEdge    =   ngTop;
    eng->en_NewGadget.ng_Width      =   ngWidth;
    eng->en_NewGadget.ng_Height     =   ngHeight;

    if ( strncmp( slab, "Gadget", 6) && strlen( slab )) {
        strcpy( &eng->en_SourceLabel[0], slab );
        eng->en_SpecialFlags |= EGF_USERLABEL;
    } else
        eng->en_SpecialFlags         = 0l;

    if ( strlen( text )) {
        eng->en_NewGadget.ng_Flags      = ngFlags;
        eng->en_NewGadget.ng_GadgetText = &eng->en_GadgetText[0];
        strcpy( &eng->en_GadgetText[0], text );
    } else {
        eng->en_NewGadget.ng_Flags      = 0;
        eng->en_NewGadget.ng_GadgetText = 0l;
    }

    eng->en_Kind                    = CYCLE_KIND;

    tags[ tn   ].ti_Tag  = GTCY_Labels;
    tags[ tn++ ].ti_Data = (ULONG)&eng->en_Labels[0];

    if ( cy_UScore ) {
        tags[ tn   ].ti_Tag  = GT_Underscore;
        tags[ tn++ ].ti_Data ='_';
    }

    tags[ tn ].ti_Tag = TAG_DONE;

    if( NOT( cy_NumLabels = ListToLabels( &cy_Labels, eng )))
        MyRequest( "Oh  oh...", "CONTINUE", "Out of memory !" );

    Saved = FALSE;
}

/*
 * --- Open the Edit Cycle requester.
 */
long EditCycle( WORD x, WORD y, WORD x1, WORD y1, struct Gadget *edit )
{
    struct Gadget       *g;
    struct ExtNewGadget *e;
    struct NewGadget     ng;
    BOOL                 running = TRUE, ok = FALSE;
    WORD                 l, t, w, h, btop, bleft, gw, gh;
    UBYTE                *label = 0l, *slabel = 0l;
    UBYTE                *string, **cycle;
    Tag                  place = 0l;
    BOOL                 high = 0l;
    UWORD                flag  = PLACETEXT_LEFT, ID;

    cy_Node = 0l;
    cycle   = &PlaceList[ 1 ];

    if ( edit ) {
        e = FindExtGad( edit );

        x  = e->en_NewGadget.ng_LeftEdge;
        y  = e->en_NewGadget.ng_TopEdge;
        gw = e->en_NewGadget.ng_Width;
        gh = e->en_NewGadget.ng_Height;

        slabel = &e->en_SourceLabel[0];
        label  = &e->en_GadgetText[0];

        flag = e->en_NewGadget.ng_Flags;

        if ( flag & PLACETEXT_LEFT  ) place = 0l;
        if ( flag & PLACETEXT_RIGHT ) place = 1l;
        if ( flag & PLACETEXT_ABOVE ) place = 2l;
        if ( flag & PLACETEXT_BELOW ) place = 3l;

        if ( flag & NG_HIGHLABEL    ) high = TRUE;

        cy_UScore = MyTagInArray( GT_Underscore, e->en_Tags );

        if (( e->en_SpecialFlags & EGF_DISABLED ) == EGF_DISABLED )
            cy_Disable = TRUE;
        else
            cy_Disable = FALSE;

        if( NOT LabelsToList( &cy_Labels, e ))
            MyRequest( "Oh oh...", "CONTINUE", "Out of memory !" );

    } else {
        if ( x > x1 ) { gw = x; x = x1; x1 = gw; }
        if ( y > y1 ) { gh = y; y = y1; y1 = gh; }

        gw = x1 - x + 1;
        gh = y1 - y + 1;

        NewList( &cy_Labels );

        cy_NumLabels = 0;
    }

    btop  = MainScreen->WBorTop + 1 + MainScreen->RastPort.TxHeight;
    bleft = MainScreen->WBorLeft;

    w = bleft + MainScreen->WBorRight  + 300;
    h = btop  + MainScreen->WBorBottom + 161;
    l = (( MainScreen->Width  >> 1 ) - ( w >> 1 ));
    t = (( MainScreen->Height >> 1 ) - ( h >> 1 ));

    cy_Zoom[0] = 0;
    cy_Zoom[1] = btop;
    cy_Zoom[2] = 200;
    cy_Zoom[3] = btop;

    cy_nwTags[0 ].ti_Data = l;
    cy_nwTags[1 ].ti_Data = t;
    cy_nwTags[2 ].ti_Data = w;
    cy_nwTags[3 ].ti_Data = h;
    cy_nwTags[10].ti_Data = (Tag)MainScreen;

    if ( g = CreateContext( &cy_GList ))  {

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

        cy_Gadgets[ GD_TEXT ] = g;

        ng.ng_TopEdge       =   btop + 20;
        ng.ng_GadgetText    =   "_Label";
        ng.ng_GadgetID      =   GD_LABEL;

        g = CreateGadget( STRING_KIND, g, &ng, GTST_String, (Tag)slabel, GTST_MaxChars, (Tag)GT_MAXLABEL + 1, GT_Underscore, (Tag)'_', TAG_DONE );

        SetStringGadget( g );

        cy_Gadgets[ GD_LABEL ] = g;

        ng.ng_LeftEdge      =   bleft + 96;
        ng.ng_TopEdge       =   btop + 36;
        ng.ng_GadgetText    =   "_Underscore";
        ng.ng_GadgetID      =   GD_UNDERSCORE;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)cy_UScore, GT_Underscore, '_', TAG_DONE );

        cy_Gadgets[ GD_UNDERSCORE ] = g;

        ng.ng_LeftEdge      =   bleft + 266;
        ng.ng_TopEdge       =   btop + 36;
        ng.ng_GadgetText    =   "_Disabled";
        ng.ng_GadgetID      =   GD_DISABLED;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)cy_Disable, GT_Underscore, '_', TAG_DONE );

        cy_Gadgets[ GD_DISABLED ] = g;

        ng.ng_LeftEdge      =   bleft + 96;
        ng.ng_TopEdge       =   btop + 51;
        ng.ng_GadgetText    =   "_High Label";
        ng.ng_GadgetID      =   GD_HIGHLABEL;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)high, GT_Underscore, '_', TAG_DONE );

        cy_Gadgets[ GD_HIGHLABEL ] = g;

        ng.ng_TopEdge       =   btop + 93;
        ng.ng_Width         =   196;
        ng.ng_GadgetText    =   "L_abels    ";
        ng.ng_GadgetID      =   GD_LABELENTRY;

        g = CreateGadget( STRING_KIND, g, &ng, GTST_MaxChars, 99l, GT_Underscore, '_', TAG_DONE );

        SetStringGadget( g );

        cy_Gadgets[ GD_LABELENTRY ] = g;

        ng.ng_TopEdge       =   btop + 65;
        ng.ng_Height        =   40;
        ng.ng_GadgetText    =   0l;
        ng.ng_GadgetID      =   GD_LABELS;

        g = CreateGadget( LISTVIEW_KIND, g, &ng, GTLV_Labels, &cy_Labels, GTLV_ShowSelected, cy_Gadgets[ GD_LABELENTRY ], TAG_DONE );

        cy_Gadgets[ GD_LABELS ] = g;

        ng.ng_LeftEdge      =   bleft + 8;
        ng.ng_TopEdge       =   btop + 110;
        ng.ng_Width         =   284;
        ng.ng_Height        =   12;
        ng.ng_GadgetText    =   "^ R_emove ^";
        ng.ng_GadgetID      =   GD_REMOVE;
        ng.ng_Flags         =   PLACETEXT_IN;

        g = CreateGadget( BUTTON_KIND, g, &ng, GT_Underscore, '_', TAG_DONE );

        ng.ng_LeftEdge      =   bleft + 96;
        ng.ng_TopEdge       =   btop + 126;
        ng.ng_Width         =   196;
        ng.ng_Height        =   13;
        ng.ng_GadgetText    =   "Text _Place";
        ng.ng_GadgetID      =   GD_TEXTPLACE;
        ng.ng_Flags         =   PLACETEXT_LEFT;

        g = CreateGadget( CYCLE_KIND, g, &ng, GTCY_Labels, (Tag)cycle, GTCY_Active, place, GT_Underscore, (Tag)'_', TAG_DONE );

        cy_Gadgets[ GD_TEXTPLACE ] = g;

        ng.ng_LeftEdge      =   bleft + 8;
        ng.ng_TopEdge       =   btop + 144;
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

            cy_nwTags[6].ti_Data = (Tag)cy_GList;

            if ( cy_Wnd = OpenWindowTagList( 0l, cy_nwTags )) {

                cy_Zoom[0] = l;
                cy_Zoom[1] = t;
                cy_Zoom[2] = w;
                cy_Zoom[3] = h;

                GT_RefreshWindow( cy_Wnd, 0l );

                do {
                    WaitPort( cy_Wnd->UserPort );

                    while ( ReadIMsg( cy_Wnd )) {

                        switch ( Class ) {

                            case    IDCMP_REFRESHWINDOW:
                                GT_BeginRefresh( cy_Wnd );
                                GT_EndRefresh( cy_Wnd, TRUE );
                                break;

                            case    IDCMP_CLOSEWINDOW:
                                running = FALSE;
                                break;

                            case    IDCMP_GADGETUP:
                                switch( theObject->GadgetID ) {

                                    case    GD_UNDERSCORE:
                                        FlipFlop( 0l, 0l, 0l, &cy_UScore );
                                        break;

                                    case    GD_DISABLED:
                                        FlipFlop( 0l, 0l, 0l, &cy_Disable );
                                        break;

                                    case    GD_HIGHLABEL:
                                        FlipFlop( 0l, 0l, 0l, &high );
                                        break;

                                    case    GD_LABELS:
                                        cy_Node = FindNode( &cy_Labels, Code );
                                        break;

                                    case    GD_LABELENTRY:
                                        string = (( struct StringInfo * )cy_Gadgets[ GD_LABELENTRY ]->SpecialInfo )->Buffer;

                                        if ( cy_NumLabels < 24 ) {
                                            if ( strlen( string )) {
                                                GT_SetGadgetAttrs( cy_Gadgets[ GD_LABELS ], cy_Wnd, 0l, GTLV_Labels, ~0, TAG_DONE );

                                                if ( cy_Node ) {
                                                    if ( NOT cy_Node->ln_UserData[0] ) {
                                                        strcpy( &cy_Node->ln_NameBytes[0], string );
                                                        cy_Node = 0l;
                                                        goto done;
                                                    } else goto make;
                                                }
                                                make:
                                                if ( cy_Node = MakeNode( string )) {
                                                    AddTail( &cy_Labels, ( struct Node * )cy_Node );
                                                    cy_Node = 0l;
                                                    cy_NumLabels++;
                                                } else
                                                    MyRequest( "Oh oh...", "CONTINUE", "Out of memory !" );
                                                done:
                                                GT_SetGadgetAttrs( cy_Gadgets[ GD_LABELS ], cy_Wnd, 0l, GTLV_Labels, &cy_Labels, TAG_DONE );
                                            }
                                        } else
                                            MyRequest( "What are you doing?", "OKIDOKI", "You already have the maximum\n number of labels entered !" );
                                        break;

                                    case    GD_REMOVE:
                                        remove:
                                        if ( cy_Node ) {
                                            GT_SetGadgetAttrs( cy_Gadgets[ GD_LABELS ], cy_Wnd, 0l, GTLV_Labels, ~0, TAG_DONE );
                                            Remove(( struct Node * )cy_Node );
                                            free( cy_Node );
                                            GT_SetGadgetAttrs( cy_Gadgets[ GD_LABELS ], cy_Wnd, 0l, GTLV_Labels, &cy_Labels, TAG_DONE );
                                            cy_NumLabels--;
                                        }
                                        break;

                                    case    GD_TEXTPLACE:
                                        if ( place++ == 3 )
                                            place = 0;

                                        flag = PlaceFlags[ place + 1 ];
                                        break;

                                    case    GD_OK:
                                        Ok:
                                        if ( NOT cy_Labels.lh_Head->ln_Succ->ln_Succ ) {
                                            MyRequest( "Hey man...", "OK", "I need aleast TWO labels !" );
                                            break;
                                        }
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
                                        FlipFlop( cy_Wnd, cy_Gadgets, GD_UNDERSCORE, &cy_UScore );
                                        break;

                                    case    'h':
                                        FlipFlop( cy_Wnd, cy_Gadgets, GD_HIGHLABEL, &high );
                                        break;

                                    case    'd':
                                        FlipFlop( cy_Wnd, cy_Gadgets, GD_DISABLED, &cy_Disable );
                                        break;

                                    case    'a':
                                        ID = GD_LABELENTRY;
                                        goto Activate;

                                    case    'e':
                                        goto remove;

                                    case    'p':
                                        if ( place++ == 3 )
                                            place = 0;

                                        flag = PlaceFlags[ place + 1 ];
                                        GT_SetGadgetAttrs( cy_Gadgets[ GD_TEXTPLACE ], cy_Wnd, 0l, GTCY_Active, place, TAG_DONE );
                                        break;

                                    case    'o':
                                        goto Ok;

                                    case    'c':
                                        goto Cancel;
                                }
                                break;
                                Activate:
                                ActivateGadget( cy_Gadgets[ ID ], cy_Wnd, 0l );
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
            ok = MakeCycle();
        else {
            RemoveAllGadgets();
            ChangeCycle( e );
            Renumber();
            ok = RemakeAllGadgets();
        }
    } else if ( NOT edit )
        Box( x, y, x1, y1 );

    if ( cy_Wnd )           CloseWindow( cy_Wnd );
    if ( cy_GList )         FreeGadgets( cy_GList );

    cy_Wnd     = 0l;
    cy_GList   = 0l;

    ClearMsgPort( MainWindow->UserPort );

    return( (long)ok );
}
