/*-- AutoRev header do NOT edit!
*
*   Program         :   Mx.c
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
*   05-Oct-91     1.00            MX editor.
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
extern BOOL                 Saved;

/*
 * --- Gadget ID's
 */
#define GD_LABEL            0
#define GD_UNDERSCORE       1
#define GD_SPACING          2
#define GD_LABELS           3
#define GD_LABELENTRY       4
#define GD_TEXTPLACE        5
#define GD_REMOVE           6
#define GD_OK               7
#define GD_CANCEL           8

/*
 * --- Module data
 */
struct Window              *mx_Wnd    = NULL;
struct Gadget              *mx_GList  = NULL;
struct Gadget              *mx_Gadgets[6];
BOOL                        mx_UScore = FALSE;
struct List                 mx_Labels;
struct ListViewNode        *mx_Node = 0l;
UWORD                       mx_NumLabels = 0;
WORD                        mx_Zoom[4];
UBYTE                      *PlaceL[] = {
    "LEFT", "RIGHT", 0l };
UWORD                       PlaceF[] = {
    PLACETEXT_LEFT, PLACETEXT_RIGHT };

struct TagItem              mx_nwTags[] = {
    WA_Left,                0l,
    WA_Top,                 0l,
    WA_Width,               0l,
    WA_Height,              0l,
    WA_IDCMP,               IDCMP_CLOSEWINDOW | CYCLEIDCMP | BUTTONIDCMP | CHECKBOXIDCMP | LISTVIEWIDCMP | IDCMP_REFRESHWINDOW | IDCMP_VANILLAKEY,
    WA_Flags,               WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_CLOSEGADGET | WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_RMBTRAP,
    WA_Gadgets,             0l,
    WA_Title,               (ULONG)"Edit MX gadget:",
    WA_AutoAdjust,          TRUE,
    WA_Zoom,                (Tag)mx_Zoom,
    WA_CustomScreen,        0l,
    TAG_DONE };

/*
 * --- Create the mx gadget.
 */
long MakeMX( void )
{
    struct ExtNewGadget *eng  = 0l;
    struct TagItem      *tags = 0l;

    if ( eng = Malloc((long)sizeof( struct ExtNewGadget ))) {
        if ( tags = MakeTagList( 3l )) {

            eng->en_NumTags = 3l;
            eng->en_Tags = tags;

            ChangeMX( eng );

            RemoveAllGadgets();

            AddTail(( struct List * )&Gadgets, ( struct Node * )eng );

            Renumber();

            if ( RemakeAllGadgets())
                return TRUE;

            Remove(( struct Node * )eng);
        }
    }

    MyRequest( "Ahem....", "CONTINUE", "Out of memory !" );

    if ( tags )         FreeTagList( tags, 3l );
    if ( eng  )         free( eng );

    return FALSE;
}

/*
 * --- Change the mx gadget.
 */
void ChangeMX( struct ExtNewGadget *eng )
{
    struct TagItem      *tags;
    UBYTE               *slab, tn = 0;
    LONG                 num;

    tags = eng->en_Tags;

    slab = (( struct StringInfo * )mx_Gadgets[ GD_LABEL ]->SpecialInfo )->Buffer;

    eng->en_NewGadget.ng_LeftEdge   =   ngLeft;
    eng->en_NewGadget.ng_TopEdge    =   ngTop;
    eng->en_NewGadget.ng_Width      =   ngWidth;
    eng->en_NewGadget.ng_Height     =   ngHeight;

    if ( strncmp( slab, "Gadget", 6 ) && strlen( slab )) {
        strcpy( &eng->en_SourceLabel[0], slab );
        eng->en_SpecialFlags |= EGF_USERLABEL;
    } else
        eng->en_SpecialFlags = 0l;

    eng->en_NewGadget.ng_Flags      = ngFlags;
    eng->en_Kind                    = MX_KIND;

    tags[ tn   ].ti_Tag  = GTMX_Labels;
    tags[ tn++ ].ti_Data = (ULONG)&eng->en_Labels[0];

    num = (( struct StringInfo * )mx_Gadgets[ GD_SPACING ]->SpecialInfo )->LongInt;

    if ( num > 1 ) {
        tags[ tn   ].ti_Tag  = GTMX_Spacing;
        tags[ tn++ ].ti_Data = num;
        eng->en_Spacing      = num;
    }

    if ( mx_UScore ) {
        tags[ tn   ].ti_Tag  = GT_Underscore;
        tags[ tn++ ].ti_Data ='_';
    }

    tags[ tn ].ti_Tag = TAG_DONE;

    if ( NOT( mx_NumLabels = ListToLabels( &mx_Labels, eng )))
        MyRequest( "Oh oh...", "CONTINUE", "Out of memory !" );

    Saved = FALSE;
}

/*
 * --- Open the Edit MX requester.
 */
long EditMX( WORD x, WORD y, WORD x1, WORD y1, struct Gadget *edit )
{
    struct Gadget       *g;
    struct ExtNewGadget *e;
    struct NewGadget     ng;
    BOOL                 running = TRUE, ok = FALSE;
    WORD                 l, t, w, h, btop, bleft, gw, gh;
    UBYTE                *slabel = 0l;
    UBYTE                *string;
    Tag                  place = 0l;
    LONG                 num;
    UWORD                flag  = PLACETEXT_LEFT;
    UWORD                space = 1, ID;

    mx_Node = 0l;

    if ( edit ) {
        e = FindExtGad( edit );

        x  = e->en_NewGadget.ng_LeftEdge;
        y  = e->en_NewGadget.ng_TopEdge;
        gw = e->en_NewGadget.ng_Width;
        gh = e->en_NewGadget.ng_Height;

        slabel = &e->en_SourceLabel[0];

        flag = e->en_NewGadget.ng_Flags;

        if ( flag & PLACETEXT_LEFT  ) place = 0l;
        if ( flag & PLACETEXT_RIGHT ) place = 1l;

        if ( MyTagInArray( GTMX_Spacing, e->en_Tags ))
            space  = e->en_Spacing;

        mx_UScore = MyTagInArray( GT_Underscore, e->en_Tags );

        if ( NOT LabelsToList( &mx_Labels, e ))
            MyRequest( "Oh oh...", "CONTINUE", "Out of memory !" );

    } else {
        if ( x > x1 ) { gw = x; x = x1; x1 = gw; }
        if ( y > y1 ) { gh = y; y = y1; y1 = gh; }

        gw = x1 - x + 1;
        gh = y1 - y + 1;

        NewList( &mx_Labels );

        mx_NumLabels = 0;
    }

    btop  = MainScreen->WBorTop + 1 + MainScreen->RastPort.TxHeight;
    bleft = MainScreen->WBorLeft;

    w = bleft + MainScreen->WBorRight  + 300;
    h = btop  + MainScreen->WBorBottom + 147;
    l = (( MainScreen->Width  >> 1 ) - ( w >> 1 ));
    t = (( MainScreen->Height >> 1 ) - ( h >> 1 ));

    mx_Zoom[0] = 0;
    mx_Zoom[1] = btop;
    mx_Zoom[2] = 200;
    mx_Zoom[3] = btop;

    mx_nwTags[0 ].ti_Data = l;
    mx_nwTags[1 ].ti_Data = t;
    mx_nwTags[2 ].ti_Data = w;
    mx_nwTags[3 ].ti_Data = h;
    mx_nwTags[10].ti_Data = (Tag)MainScreen;

    if ( g = CreateContext( &mx_GList ))  {

        ng.ng_LeftEdge      =   bleft + 56;
        ng.ng_TopEdge       =   btop + 4;
        ng.ng_Width         =   236;
        ng.ng_Height        =   12;
        ng.ng_GadgetText    =   "_Label";
        ng.ng_TextAttr      =   &Topaz80;
        ng.ng_GadgetID      =   GD_LABEL;
        ng.ng_Flags         =   PLACETEXT_LEFT;
        ng.ng_VisualInfo    =   MainVisualInfo;
        ng.ng_UserData      =   0l;

        g = CreateGadget( STRING_KIND, g, &ng, GTST_String, (Tag)slabel, GTST_MaxChars, (Tag)GT_MAXLABEL + 1, GT_Underscore, (Tag)'_', TAG_DONE );

        SetStringGadget( g );

        mx_Gadgets[ GD_LABEL ] = g;

        ng.ng_LeftEdge      =   bleft + 96;
        ng.ng_TopEdge       =   btop + 20;
        ng.ng_GadgetText    =   "_Underscore";
        ng.ng_GadgetID      =   GD_UNDERSCORE;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GTCB_Checked, (Tag)mx_UScore, GT_Underscore, '_', TAG_DONE );

        mx_Gadgets[ GD_UNDERSCORE ] = g;

        ng.ng_LeftEdge      =   bleft + 96;
        ng.ng_TopEdge       =   btop + 36;
        ng.ng_Width         =   196;
        ng.ng_Height        =   12;
        ng.ng_GadgetText    =   "_Spacing   ";
        ng.ng_GadgetID      =   GD_SPACING;

        g = CreateGadget( INTEGER_KIND, g, &ng, GTIN_Number, (Tag)space, GTIN_MaxChars, 5l, GT_Underscore, '_', TAG_DONE );

        SetStringGadget( g );

        mx_Gadgets[ GD_SPACING ] = g;

        ng.ng_TopEdge       =   btop + 80;
        ng.ng_GadgetText    =   "L_abels    ";
        ng.ng_GadgetID      =   GD_LABELENTRY;

        g = CreateGadget( STRING_KIND, g, &ng, GTST_MaxChars, 99l, GT_Underscore, '_', TAG_DONE );

        SetStringGadget( g );

        mx_Gadgets[ GD_LABELENTRY ] = g;

        ng.ng_TopEdge       =   btop + 52;
        ng.ng_Height        =   40;
        ng.ng_GadgetText    =   0l;
        ng.ng_GadgetID      =   GD_LABELS;

        g = CreateGadget( LISTVIEW_KIND, g, &ng, GTLV_Labels, &mx_Labels, GTLV_ShowSelected, mx_Gadgets[ GD_LABELENTRY ], TAG_DONE );

        mx_Gadgets[ GD_LABELS ] = g;

        ng.ng_LeftEdge      =   bleft + 8;
        ng.ng_TopEdge       =   btop + 97;
        ng.ng_Width         =   284;
        ng.ng_Height        =   12;
        ng.ng_GadgetText    =   "^ R_emove ^";
        ng.ng_GadgetID      =   GD_REMOVE;
        ng.ng_Flags         =   PLACETEXT_IN;

        g = CreateGadget( BUTTON_KIND, g, &ng, GT_Underscore, '_', TAG_DONE );

        ng.ng_LeftEdge      =   bleft + 96;
        ng.ng_TopEdge       =   btop + 113;
        ng.ng_Width         =   196;
        ng.ng_Height        =   13;
        ng.ng_GadgetText    =   "Text _Place";
        ng.ng_GadgetID      =   GD_TEXTPLACE;
        ng.ng_Flags         =   PLACETEXT_LEFT;

        g = CreateGadget( CYCLE_KIND, g, &ng, GTCY_Labels, (Tag)&PlaceL[0], GTCY_Active, place, GT_Underscore, (Tag)'_', TAG_DONE );

        mx_Gadgets[ GD_TEXTPLACE ] = g;

        ng.ng_LeftEdge      =   bleft + 8;
        ng.ng_TopEdge       =   btop + 130;
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

            mx_nwTags[6].ti_Data = (Tag)mx_GList;

            if ( mx_Wnd = OpenWindowTagList( 0l, mx_nwTags )) {

                mx_Zoom[0] = l;
                mx_Zoom[1] = t;
                mx_Zoom[2] = w;
                mx_Zoom[3] = h;

                GT_RefreshWindow( mx_Wnd, 0l );

                do {
                    WaitPort( mx_Wnd->UserPort );

                    while ( ReadIMsg( mx_Wnd )) {

                        switch ( Class ) {

                            case    IDCMP_REFRESHWINDOW:
                                GT_BeginRefresh( mx_Wnd );
                                GT_EndRefresh( mx_Wnd, TRUE );
                                break;

                            case    IDCMP_CLOSEWINDOW:
                                running = FALSE;
                                break;

                            case    IDCMP_GADGETUP:
                                switch( theObject->GadgetID ) {

                                    case    GD_UNDERSCORE:
                                        FlipFlop( 0l, 0l, 0l, &mx_UScore );
                                        break;

                                    case    GD_SPACING:
                                        num = (( struct StringInfo * )mx_Gadgets[ GD_SPACING ]->SpecialInfo )->LongInt;

                                        if ( num < 1 ) {
                                            DisplayBeep( MainScreen );
                                            GT_SetGadgetAttrs( mx_Gadgets[ GD_SPACING ], mx_Wnd, 0l, GTIN_Number, 1l, TAG_DONE );
                                        }
                                        break;

                                    case    GD_LABELS:
                                        mx_Node = FindNode( &mx_Labels, Code );
                                        break;

                                    case    GD_LABELENTRY:
                                        string = (( struct StringInfo * )mx_Gadgets[ GD_LABELENTRY ]->SpecialInfo )->Buffer;

                                        if ( mx_NumLabels < 24 ) {
                                            if ( strlen( string )) {
                                                GT_SetGadgetAttrs( mx_Gadgets[ GD_LABELS ], mx_Wnd, 0l, GTLV_Labels, ~0, TAG_DONE );

                                                if ( mx_Node ) {
                                                    if ( NOT mx_Node->ln_UserData[0] ) {
                                                        strcpy( &mx_Node->ln_NameBytes[0], string );
                                                        mx_Node = 0l;
                                                        goto done;
                                                    } else goto make;
                                                }
                                                make:
                                                if ( mx_Node = MakeNode( string )) {
                                                    AddTail( &mx_Labels, ( struct Node * )mx_Node );
                                                    mx_Node = 0l;
                                                    mx_NumLabels++;
                                                } else
                                                    MyRequest( "Oh oh...", "CONTINUE", "Out of memory !" );
                                                done:
                                                GT_SetGadgetAttrs( mx_Gadgets[ GD_LABELS ], mx_Wnd, 0l, GTLV_Labels, &mx_Labels, TAG_DONE );
                                             }
                                         } else
                                            MyRequest( "What are you doing?", "OKIDOKI", "You already have the maximum\n number of labels entered !" );
                                         break;

                                    case    GD_REMOVE:
                                        remove:
                                        if ( mx_Node ) {
                                            GT_SetGadgetAttrs( mx_Gadgets[ GD_LABELS ], mx_Wnd, 0l, GTLV_Labels, ~0, TAG_DONE );
                                            Remove(( struct Node * )mx_Node );
                                            free( mx_Node );
                                            GT_SetGadgetAttrs( mx_Gadgets[ GD_LABELS ], mx_Wnd, 0l, GTLV_Labels, &mx_Labels, TAG_DONE );
                                            mx_NumLabels--;
                                        }
                                        break;

                                    case    GD_TEXTPLACE:
                                        if ( place++ == 1 )
                                            place = 0;

                                        flag = PlaceF[ place ];
                                        break;

                                    case    GD_OK:
                                        Ok:
                                        if ( NOT mx_Labels.lh_Head->ln_Succ->ln_Succ ) {
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

                                    case    'l':
                                        ID = GD_LABEL;
                                        goto Activate;

                                    case    'u':
                                        FlipFlop( mx_Wnd, mx_Gadgets, GD_UNDERSCORE, &mx_UScore );
                                        break;

                                    case    's':
                                        ID = GD_SPACING;
                                        goto Activate;

                                    case    'a':
                                        ID = GD_LABELENTRY;
                                        goto Activate;

                                    case    'e':
                                        goto remove;

                                    case    'p':
                                        if ( place++ == 1 )
                                            place = 0;

                                        flag = PlaceF[ place ];
                                        GT_SetGadgetAttrs( mx_Gadgets[ GD_TEXTPLACE ], mx_Wnd, 0l, GTCY_Active, place, TAG_DONE );
                                        break;

                                    case    'o':
                                        goto Ok;

                                    case    'c':
                                        goto Cancel;
                                }
                                break;
                                Activate:
                                ActivateGadget( mx_Gadgets[ ID ], mx_Wnd, 0l );
                                break;
                        }
                    }
                } while ( running );
            }
        }
    }

    if ( ok) {
        ngFlags     =   flag;
        ngLeft      =   x;
        ngTop       =   y;
        ngWidth     =   gw;
        ngHeight    =   gh;
        if ( NOT edit )
            ok = MakeMX();
        else {
            RemoveAllGadgets();
            ChangeMX( e );
            Renumber();
            ok = RemakeAllGadgets();
        }
    } else if ( NOT edit )
        Box( x, y, x1, y1 );

    if ( mx_Wnd )           CloseWindow( mx_Wnd );
    if ( mx_GList )         FreeGadgets( mx_GList );

    mx_Wnd     = 0l;
    mx_GList   = 0l;

    ClearMsgPort( MainWindow->UserPort );

    return( (long)ok );
}
