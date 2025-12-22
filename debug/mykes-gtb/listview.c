/*-- AutoRev header do NOT edit!
*
*   Program         :   ListView.c
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
*   05-Oct-91     1.00            ListView editor.
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
#define GD_HIGHLABEL        2
#define GD_READONLY         3
#define GD_SHOW             4
#define GD_SPACING          5
#define GD_SCROLLWIDTH      6
#define GD_LABELS           7
#define GD_LABELENTRY       8
#define GD_TEXTPLACE        9
#define GD_REMOVE           10
#define GD_OK               11
#define GD_CANCEL           12

/*
 * --- Module data
 */
struct Window              *lv_Wnd    = NULL;
struct Gadget              *lv_GList  = NULL;
struct Gadget              *lv_Gadgets[10];
BOOL                        lv_Read = FALSE, lv_Show = FALSE;
struct List                 lv_Labels;
struct ListViewNode        *lv_Node = 0l;
WORD                        lv_Zoom[4];

struct TagItem              lv_nwTags[] = {
    WA_Left,                0l,
    WA_Top,                 0l,
    WA_Width,               0l,
    WA_Height,              0l,
    WA_IDCMP,               IDCMP_CLOSEWINDOW | CYCLEIDCMP | BUTTONIDCMP | CHECKBOXIDCMP | LISTVIEWIDCMP | IDCMP_REFRESHWINDOW | IDCMP_VANILLAKEY,
    WA_Flags,               WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_CLOSEGADGET | WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_RMBTRAP,
    WA_Gadgets,             0l,
    WA_Title,               (ULONG)"Edit LISTVIEW gadget:",
    WA_AutoAdjust,          TRUE,
    WA_Zoom,                (Tag)lv_Zoom,
    WA_CustomScreen,        0l,
    TAG_DONE };

/*
 * --- Add the labels to the gadget list.
 */
void SetLabels( struct ExtNewGadget *eng )
{
    struct ListViewNode *node;

    NewList( &eng->en_Entries );

    while ( node = ( struct ListViewNode * )RemHead( &lv_Labels ))
        AddTail( &eng->en_Entries, ( struct Node * )node );
}

/*
 * --- Get the labels of the gadget list.
 */
void GetLabels( struct ExtNewGadget *eng )
{
    struct ListViewNode *node;

    NewList( &lv_Labels );

    while ( node = ( struct ListViewNode * )RemHead( &eng->en_Entries ))
        AddTail( &lv_Labels, ( struct Node * )node );
}

/*
 * --- Create the listview gadget.
 */
long MakeListView( void )
{
    struct ExtNewGadget *eng  = 0l;
    struct TagItem      *tags = 0l;

    if ( eng = Malloc((long)sizeof( struct ExtNewGadget ) )) {
        if ( tags = MakeTagList( 4l )) {

            eng->en_NumTags = 4l;
            eng->en_Tags = tags;

            ChangeListView( eng );

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
    if ( eng  )         free( eng );

    return FALSE;
}

/*
 * --- Change the listview gadget.
 */
void ChangeListView( struct ExtNewGadget *eng )
{
    struct TagItem      *tags;
    UBYTE               *slab, *text, tn = 0;
    LONG                 num;

    tags = eng->en_Tags;

    slab = (( struct StringInfo * )lv_Gadgets[ GD_LABEL ]->SpecialInfo )->Buffer;
    text = (( struct StringInfo * )lv_Gadgets[ GD_TEXT  ]->SpecialInfo )->Buffer;

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

    eng->en_Kind    = LISTVIEW_KIND;

    tags[ tn   ].ti_Tag  = GTLV_Labels;
    tags[ tn++ ].ti_Data = (ULONG)&eng->en_Entries;

    num = (( struct StringInfo * )lv_Gadgets[ GD_SCROLLWIDTH ]->SpecialInfo )->LongInt;

    if ( num > 16 ) {
        tags[ tn   ].ti_Tag  = GTLV_ScrollWidth;
        tags[ tn++ ].ti_Data = num;
        eng->en_ScrollWidth  = num;
    }
    else eng->en_ScrollWidth = 16;

    num = (( struct StringInfo * )lv_Gadgets[ GD_SPACING ]->SpecialInfo )->LongInt;

    if ( num > 0 ) {
        tags[ tn   ].ti_Tag  = LAYOUTA_Spacing;
        tags[ tn++ ].ti_Data = num;
        eng->en_Spacing      = num;
    }

    if ( lv_Read )
        eng->en_SpecialFlags |= EGF_READONLY;

    if ( lv_Show ) {
        tags[ tn   ].ti_Tag = GTLV_ShowSelected;
        tags[ tn++ ].ti_Data =  0l;
    }

    tags[ tn ].ti_Tag = TAG_DONE;

    SetLabels( eng );

    Saved = FALSE;
}

/*
 * --- Open the EditListView requester.
 */
long EditListView( WORD x, WORD y, WORD x1, WORD y1, struct Gadget *edit )
{
    struct Gadget       *g;
    struct ExtNewGadget *e;
    struct ListViewNode *a;
    struct NewGadget     ng;
    BOOL                 running = TRUE, ok = FALSE;
    WORD                 l, t, w, h, btop, bleft, gw, gh;
    UBYTE               *label = 0l, *slabel = 0l;
    UBYTE              **cycle, *string;
    Tag                  place = 0l;
    LONG                 num;
    UWORD                flag  = PLACETEXT_LEFT, high = FALSE;
    UWORD                swidth = 16, space = 0, ID;

    cycle = &PlaceList[1];

    lv_Node = 0l;

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

        if ( MyTagInArray( GTLV_ScrollWidth, e->en_Tags ))
            swidth = e->en_ScrollWidth;

        if ( MyTagInArray( LAYOUTA_Spacing, e->en_Tags ))
            space  = e->en_Spacing;

        if ( MyTagInArray( GTLV_ShowSelected, e->en_Tags ))
            lv_Show = TRUE; else lv_Show = FALSE;

        if (( e->en_SpecialFlags & EGF_READONLY ) == EGF_READONLY )
            lv_Read = TRUE;
        else
            lv_Read = FALSE;

        GetLabels( e );
    } else {
        if ( x > x1 ) { gw = x; x = x1; x1 = gw; }
        if ( y > y1 ) { gh = y; y = y1; y1 = gh; }

        gw = x1 - x + 1;
        gh = y1 - y + 1;

        NewList( &lv_Labels );

        if ( a = MakeNode( "!!ACTION GADGET!!" )) {
            a->ln_UserData[0] = 1l;
            AddTail( &lv_Labels, ( struct Node * )a );
        }
    }

    btop  = MainScreen->WBorTop + 1 + MainScreen->RastPort.TxHeight;
    bleft = MainScreen->WBorLeft;

    w = bleft + MainScreen->WBorRight  + 300;
    h = btop  + MainScreen->WBorBottom + 183;
    l = (( MainScreen->Width  >> 1 ) - ( w >> 1 ));
    t = (( MainScreen->Height >> 1 ) - ( h >> 1 ));

    lv_Zoom[0] = 0;
    lv_Zoom[1] = btop;
    lv_Zoom[2] = 200;
    lv_Zoom[3] = btop;

    lv_nwTags[0 ].ti_Data = l;
    lv_nwTags[1 ].ti_Data = t;
    lv_nwTags[2 ].ti_Data = w;
    lv_nwTags[3 ].ti_Data = h;
    lv_nwTags[10].ti_Data = (Tag)MainScreen;

    if ( g = CreateContext( &lv_GList ))  {

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

        lv_Gadgets[ GD_TEXT ] = g;

        ng.ng_TopEdge       =   btop + 20;
        ng.ng_GadgetText    =   "_Label";
        ng.ng_GadgetID      =   GD_LABEL;

        g = CreateGadget( STRING_KIND, g, &ng, GTST_String, (Tag)slabel, GTST_MaxChars, (Tag)GT_MAXLABEL + 1, GT_Underscore, (Tag)'_', TAG_DONE );

        SetStringGadget( g );

        lv_Gadgets[ GD_LABEL ] = g;

        ng.ng_LeftEdge      =   bleft + 96;
        ng.ng_TopEdge       =   btop + 36;
        ng.ng_GadgetText    =   "_High Label";
        ng.ng_GadgetID      =   GD_HIGHLABEL;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)high, GT_Underscore, '_', TAG_DONE );

        lv_Gadgets[ GD_HIGHLABEL ] = g;

        ng.ng_LeftEdge      =   bleft + 266;
        ng.ng_GadgetText    =   "_Read Only";
        ng.ng_GadgetID      =   GD_READONLY;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)lv_Read, GT_Underscore, '_', TAG_DONE );

        lv_Gadgets[ GD_READONLY ] = g;

        ng.ng_LeftEdge      =   bleft + 266;
        ng.ng_TopEdge       =   btop + 47;
        ng.ng_GadgetText    =   "ShowSelecte_d";
        ng.ng_GadgetID      =   GD_SHOW;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)lv_Show, GA_Disabled, (Tag)lv_Read, GT_Underscore, '_', TAG_DONE );

        lv_Gadgets[ GD_SHOW ] = g;

        ng.ng_LeftEdge      =   bleft + 96;
        ng.ng_TopEdge       =   btop + 62;
        ng.ng_Width         =   196;
        ng.ng_Height        =   12;
        ng.ng_GadgetText    =   "_Spacing   ";
        ng.ng_GadgetID      =   GD_SPACING;

        g = CreateGadget( INTEGER_KIND, g, &ng, GTIN_Number, (Tag)space, GTIN_MaxChars, 5l, GT_Underscore, '_', TAG_DONE );

        SetStringGadget( g );

        lv_Gadgets[ GD_SPACING ] = g;

        ng.ng_TopEdge       =   btop + 77;
        ng.ng_GadgetText    =   "Scr. _Width";
        ng.ng_GadgetID      =   GD_SCROLLWIDTH;

        g = CreateGadget( INTEGER_KIND, g, &ng, GTIN_Number, (Tag)swidth, GTIN_MaxChars, 5l, GT_Underscore, '_', TAG_DONE );

        SetStringGadget( g );

        lv_Gadgets[ GD_SCROLLWIDTH ] = g;

        ng.ng_TopEdge       =   btop + 92;
        ng.ng_GadgetText    =   "L_abels    ";
        ng.ng_GadgetID      =   GD_LABELENTRY;

        g = CreateGadget( STRING_KIND, g, &ng, GTST_MaxChars, 99l, GT_Underscore, '_', TAG_DONE );

        SetStringGadget( g );

        lv_Gadgets[ GD_LABELENTRY ] = g;

        ng.ng_TopEdge       =   btop + 92;
        ng.ng_Height        =   40;
        ng.ng_GadgetText    =   0l;
        ng.ng_GadgetID      =   GD_LABELS;

        g = CreateGadget( LISTVIEW_KIND, g, &ng, GTLV_Labels, &lv_Labels, GTLV_ShowSelected, lv_Gadgets[ GD_LABELENTRY ], TAG_DONE );

        lv_Gadgets[ GD_LABELS ] = g;

        ng.ng_LeftEdge      =   bleft + 8;
        ng.ng_TopEdge       =   btop + 136;
        ng.ng_Width         =   284;
        ng.ng_Height        =   12;
        ng.ng_GadgetText    =   "^ R_emove ^";
        ng.ng_GadgetID      =   GD_REMOVE;
        ng.ng_Flags         =   PLACETEXT_IN;

        g = CreateGadget( BUTTON_KIND, g, &ng, GT_Underscore, '_', TAG_DONE );

        ng.ng_LeftEdge      =   bleft + 96;
        ng.ng_TopEdge       =   btop + 151;
        ng.ng_Width         =   196;
        ng.ng_Height        =   13;
        ng.ng_GadgetText    =   "Text _Place";
        ng.ng_GadgetID      =   GD_TEXTPLACE;
        ng.ng_Flags         =   PLACETEXT_LEFT;

        g = CreateGadget( CYCLE_KIND, g, &ng, GTCY_Labels, (Tag)cycle, GTCY_Active, place, GT_Underscore, (Tag)'_', TAG_DONE );

        lv_Gadgets[ GD_TEXTPLACE ] = g;

        ng.ng_LeftEdge      =   bleft + 8;
        ng.ng_TopEdge       =   btop + 167;
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

            lv_nwTags[6].ti_Data = (Tag)lv_GList;

            if ( lv_Wnd = OpenWindowTagList( 0l, lv_nwTags )) {

                lv_Zoom[0] = l;
                lv_Zoom[1] = t;
                lv_Zoom[2] = w;
                lv_Zoom[3] = h;

                GT_RefreshWindow( lv_Wnd, 0l );

                do {
                    WaitPort( lv_Wnd->UserPort );

                    while ( ReadIMsg( lv_Wnd )) {

                        switch ( Class ) {

                            case    IDCMP_REFRESHWINDOW:
                                GT_BeginRefresh( lv_Wnd );
                                GT_EndRefresh( lv_Wnd, TRUE );
                                break;

                            case    IDCMP_CLOSEWINDOW:
                                running = FALSE;
                                break;

                            case    IDCMP_GADGETUP:
                                switch( theObject->GadgetID ) {

                                    case    GD_HIGHLABEL:
                                        FlipFlop( 0l, 0l, 0l, &high );
                                        break;

                                    case    GD_READONLY:
                                        FlipFlop( 0l, 0l, 0l, &lv_Read );
                                        noShow:
                                        if ( lv_Read ) {
                                            lv_Show = FALSE;
                                            GT_SetGadgetAttrs( lv_Gadgets[ GD_SHOW ], lv_Wnd, 0l, GTCB_Checked, lv_Show, GA_Disabled, lv_Read, TAG_DONE );
                                        } else
                                            GT_SetGadgetAttrs( lv_Gadgets[ GD_SHOW ], lv_Wnd, 0l, GA_Disabled, lv_Read, TAG_DONE );
                                        break;

                                    case    GD_SHOW:
                                        FlipFlop( 0l, 0l, 0l, &lv_Show );
                                        break;

                                    case    GD_SCROLLWIDTH:
                                        num = (( struct StringInfo * )lv_Gadgets[ GD_SCROLLWIDTH ]->SpecialInfo )->LongInt;

                                        if ( num < 16 ) {
                                            DisplayBeep( MainScreen );
                                            GT_SetGadgetAttrs( lv_Gadgets[ GD_SCROLLWIDTH ], lv_Wnd, 0l, GTIN_Number, 16l, TAG_DONE );
                                        }
                                        break;

                                    case    GD_SPACING:
                                        num = (( struct StringInfo * )lv_Gadgets[ GD_SPACING ]->SpecialInfo )->LongInt;

                                        if ( num < 0 ) {
                                            DisplayBeep( MainScreen );
                                            GT_SetGadgetAttrs( lv_Gadgets[ GD_SPACING ], lv_Wnd, 0l, GTIN_Number, 0l, TAG_DONE );
                                        }
                                        break;

                                    case    GD_LABELS:
                                        lv_Node = FindNode( &lv_Labels, Code );
                                        break;

                                    case    GD_LABELENTRY:
                                        string = (( struct StringInfo * )lv_Gadgets[ GD_LABELENTRY ]->SpecialInfo )->Buffer;

                                        if ( strlen( string )) {
                                            GT_SetGadgetAttrs( lv_Gadgets[ GD_LABELS ], lv_Wnd, 0l, GTLV_Labels, ~0, TAG_DONE );

                                            if ( lv_Node ) {
                                                if ( NOT lv_Node->ln_UserData[0] ) {
                                                    strcpy( &lv_Node->ln_NameBytes[0], string );
                                                    lv_Node = 0l;
                                                    goto done;
                                                } else goto make;
                                            }
                                            make:
                                            if ( lv_Node = MakeNode( string )) {
                                                AddTail( &lv_Labels, ( struct Node * )lv_Node );
                                                lv_Node = 0l;
                                            } else
                                                MyRequest( "Oh oh...", "CONTINUE", "Out of memory !" );
                                            done:
                                            GT_SetGadgetAttrs( lv_Gadgets[ GD_LABELS ], lv_Wnd, 0l, GTLV_Labels, &lv_Labels, TAG_DONE );
                                         }
                                         break;

                                    case    GD_REMOVE:
                                        remove:
                                        if ( lv_Node ) {
                                            if ( NOT lv_Node->ln_UserData[0] ) {
                                                GT_SetGadgetAttrs( lv_Gadgets[ GD_LABELS ], lv_Wnd, 0l, GTLV_Labels, ~0, TAG_DONE );
                                                Remove(( struct Node * )lv_Node );
                                                free( lv_Node );
                                                GT_SetGadgetAttrs( lv_Gadgets[ GD_LABELS ], lv_Wnd, 0l, GTLV_Labels, &lv_Labels, TAG_DONE );
                                            }
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

                                    case    'h':
                                        FlipFlop( lv_Wnd, lv_Gadgets, GD_HIGHLABEL, &high );
                                        break;

                                    case    'r':
                                        FlipFlop( lv_Wnd, lv_Gadgets, GD_READONLY, &lv_Read );
                                        goto noShow;
                                        break;

                                    case    'd':
                                        FlipFlop( lv_Wnd, lv_Gadgets, GD_SHOW, &lv_Show );
                                        break;

                                    case    's':
                                        ID = GD_SPACING;
                                        goto Activate;

                                    case    'w':
                                        ID = GD_SCROLLWIDTH;
                                        goto Activate;

                                    case    'a':
                                        ID = GD_LABELENTRY;
                                        goto Activate;

                                    case    'e':
                                        goto remove;

                                    case    'p':
                                        if ( place++ == 3 )
                                            place = 0;

                                        flag = PlaceFlags[ place + 1 ];
                                        GT_SetGadgetAttrs( lv_Gadgets[ GD_TEXTPLACE ], lv_Wnd, 0l, GTCY_Active, place, TAG_DONE );
                                        break;

                                    case    'o':
                                        goto Ok;

                                    case    'c':
                                        goto Cancel;
                                }
                                break;
                                Activate:
                                ActivateGadget( lv_Gadgets[ ID ], lv_Wnd, 0l );
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
            ok = MakeListView();
        else {
            RemoveAllGadgets();
            ChangeListView( e );
            Renumber();
            ok = RemakeAllGadgets();
        }
    } else if ( NOT edit )
        Box( x, y, x1, y1 );

    if ( lv_Wnd )           CloseWindow( lv_Wnd );
    if ( lv_GList )         FreeGadgets( lv_GList );

    lv_Wnd     = 0l;
    lv_GList   = 0l;

    ClearMsgPort( MainWindow->UserPort );

    return( (long)ok );
}
