/*-- AutoRev header do NOT edit!
*
*   Program         :   ItemEd.c
*   Copyright       :   © Copyright 1991 Jaba Development
*   Author          :   Jan van den Baard
*   Creation Date   :   30-Oct-91
*   Current version :   1.00
*   Translator      :   DICE v2.6
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   30-Oct-91     1.00            (Sub)Item edit requester.
*
*-- REV_END --*/

#include	"defs.h"

/*
 * --- External referenced data.
 */
extern ULONG                 Class;
extern UWORD                 Code;
extern struct TextAttr       Topaz80, MainFont;
extern APTR                  MainVisualInfo;
extern struct Screen        *MainScreen;
extern struct Window        *MainWindow, *meWnd;
extern struct Gadget        *theObject;
extern struct Menu          *MainMenus;
extern UBYTE                 MainScreenTitle[80], MainWindowTitle[80];
extern BOOL                  Saved;

/*
 * --- Gadget ID
 */
#define GD_LIST          0
#define GD_ENTER         1
#define GD_DISABLED      2
#define GD_CHECKIT       3
#define GD_TOGGLE        4
#define GD_CHECKED       5
#define GD_SHORTCUT      6
#define GD_ITEMED        7
#define GD_BARLABEL      8
#define GD_DELETE        9
#define GD_DONE          10

/*
 * --- Module data.
 */
struct Window           *ieWnd   = NULL;
struct Gadget           *ieGList = NULL;
struct Gadget           *ieGadgets[8];
struct ExtNewMenu       *ieItem = 0l;
UWORD                    ieActEd = NM_ITEM;
struct ExtMenuList      *ieList, *ieParent;

BOOL                     ieDisabled = FALSE, ieCheckit = FALSE;
BOOL                     ieToggle = FALSE, ieChecked = FALSE;

WORD                     ieZoom[4];

struct TagItem           ienwTags[] = {
    WA_Left,                0l,
    WA_Top,                 0l,
    WA_Width,               0l,
    WA_Height,              0l,
    WA_IDCMP,               IDCMP_CLOSEWINDOW | BUTTONIDCMP | LISTVIEWIDCMP  | CHECKBOXIDCMP | IDCMP_VANILLAKEY | IDCMP_REFRESHWINDOW,
    WA_Flags,               WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_CLOSEGADGET | WFLG_ACTIVATE | WFLG_SMART_REFRESH,
    WA_Gadgets,             0l,
    WA_Title,               (ULONG)"Edit Items",
    WA_AutoAdjust,          TRUE,
    WA_Zoom,                (Tag)ieZoom,
    WA_CustomScreen,        0l,
    TAG_DONE };

/*
 * --- Set the MutualExclude for a item or a subitem
 */
void MutualExclude( void )
{
    struct ExtNewMenu   *item;
    struct NewMenu      *strip, *tmp;
    struct Menu         *themenu;
    struct MenuItem     *excluding;
    LONG                 bitnum = 0l, numitems = 0l;

    GT_SetGadgetAttrs( ieGadgets[ GD_LIST], ieWnd, 0l, GTLV_Labels, ~0, TAG_DONE );

    for ( item = ieList->ml_First; item->em_Next; item = item->em_Next, numitems++ );

    if ( numitems <= 1 ) goto noWay;

    numitems += 2;

    if ( strip = tmp = ( struct NewMenu * )Malloc( (long)sizeof( struct NewMenu ) * numitems )) {
        tmp->nm_Type  = NM_TITLE;
        tmp->nm_Label = "MutualExclusion";
        tmp++;
        for ( item = ieList->ml_First; item->em_Next; item = item->em_Next ) {
            tmp->nm_Type  = NM_ITEM;
            tmp->nm_Label = item->em_NodeName;
            tmp->nm_Flags = CHECKIT | MENUTOGGLE;

            if (( ieItem->em_NewMenu.nm_MutualExclude & ( 1 << bitnum )) == ( 1 << bitnum ))
                tmp->nm_Flags |= CHECKED;

            if ( item == ieItem )
                tmp->nm_Flags |= NM_ITEMDISABLED;

            tmp++;
            bitnum++;
        }

        tmp->nm_Type = NM_END;

        if ( themenu = CreateMenus( strip, GTMN_FrontPen, 0l, TAG_DONE )) {
            LayoutMenus( themenu, MainVisualInfo, GTMN_TextAttr, &MainFont, TAG_DONE );

            Forbid();
            ieWnd->Flags &= ~WFLG_RMBTRAP;
            Permit();

            ModifyIDCMP( ieWnd, IDCMP_MENUPICK | IDCMP_RAWKEY | IDCMP_REFRESHWINDOW );

            SetMenuStrip( ieWnd, themenu );
            SetWindowTitles( ieWnd, "DRAG-SELECT ITEMS TO EXCLUDE", ( char * ) ~0 );

            while ( 1 ) {
                WaitPort( ieWnd->UserPort );
                while( ReadIMsg( ieWnd )) {
                    switch ( Class ) {

                        case    IDCMP_RAWKEY:
                            if ( Code == 0x45 )
                                goto Esc;
                            break;

                        case    IDCMP_MENUPICK:
                            if ( Code != MENUNULL )
                                goto doIt;
                            break;

                        case IDCMP_REFRESHWINDOW:
                            GT_BeginRefresh( ieWnd );
                            GT_EndRefresh( ieWnd, TRUE );
                            break;
                        }
                }
            }

            doIt:
            excluding = ItemAddress( themenu, SHIFTMENU( 0 ) | SHIFTITEM( 0 ) | SHIFTSUB( NOSUB ));

            bitnum = 0l;
            ieItem->em_NewMenu.nm_MutualExclude = 0l;

            while ( excluding ) {
                if (( excluding->Flags & CHECKED ) == CHECKED )
                    ieItem->em_NewMenu.nm_MutualExclude |= ( 1 << bitnum );
                bitnum++;
                excluding = excluding->NextItem;
            }

            Esc:
            ClearMenuStrip( ieWnd );
            Forbid();
            ieWnd->Flags |= WFLG_RMBTRAP;
            Permit();
            ModifyIDCMP( ieWnd, ienwTags[4].ti_Data );
            if ( ieActEd == NM_ITEM ) SetWindowTitles( ieWnd, "Edit Items:", ( char * )~0 );
            else                      SetWindowTitles( ieWnd, "Edit SubItems:", ( char * )~0 );
            FreeMenus( themenu );
        }
        free( strip );
    }

    noWay:
    GT_SetGadgetAttrs( ieGadgets[ GD_LIST ], ieWnd, 0l, GTLV_Labels, ieList, TAG_DONE );
}


/*
 * --- Set ed for items or subs
 */
void SetEd( long type, struct ExtNewMenu *item )
{
    GT_SetGadgetAttrs( ieGadgets[ GD_LIST ], ieWnd, 0l, GTLV_Labels, ~0, TAG_DONE );

    if ( type == NM_SUB ) {
        if ( NOT( ieList = item->em_Items )) {
            if ( NOT( item->em_Items = Malloc((long)sizeof( struct ExtMenuList ))))
                return;

            ieList = item->em_Items;
            NewList(( struct List * )ieList );
        }
        SetWindowTitles( ieWnd, "Edit SubItems:", (char *)-1l );
        GT_SetGadgetAttrs( ieGadgets[ GD_ITEMED ], ieWnd, 0l, GA_Disabled, TRUE, TAG_DONE );
        ieActEd  = NM_SUB;
    } else {
        SetWindowTitles( ieWnd, "Edit Items:", (char *)-1l );
        GT_SetGadgetAttrs( ieGadgets[ GD_ITEMED ], ieWnd, 0l, GA_Disabled, FALSE, TAG_DONE );
        ieList  = ieParent;
        ieActEd = NM_ITEM;
    }

    GT_SetGadgetAttrs( ieGadgets[ GD_DISABLED ], ieWnd, 0l, GTCB_Checked, FALSE, TAG_DONE );
    GT_SetGadgetAttrs( ieGadgets[ GD_CHECKIT  ], ieWnd, 0l, GTCB_Checked, FALSE, TAG_DONE );
    GT_SetGadgetAttrs( ieGadgets[ GD_CHECKED  ], ieWnd, 0l, GTCB_Checked, FALSE, TAG_DONE );
    GT_SetGadgetAttrs( ieGadgets[ GD_TOGGLE   ], ieWnd, 0l, GTCB_Checked, FALSE, TAG_DONE );
    GT_SetGadgetAttrs( ieGadgets[ GD_SHORTCUT ], ieWnd, 0l, GTST_String, 0l, TAG_DONE );

    ieDisabled = ieCheckit = ieChecked = ieToggle = FALSE;

    GT_SetGadgetAttrs( ieGadgets[ GD_LIST ], ieWnd, 0l, GTLV_Labels, ieList, TAG_DONE );

    ieItem = 0l;
}

/*
 * --- Set the used flags
 */
void SetTheFlags( struct ExtNewMenu *item )
{
    UBYTE           *ptr;

    ptr = (( struct StringInfo * )ieGadgets[ GD_SHORTCUT ]->SpecialInfo )->Buffer;

    if ( ieDisabled ) item->em_NewMenu.nm_Flags |= NM_ITEMDISABLED;
    else              item->em_NewMenu.nm_Flags &= ~NM_ITEMDISABLED;
    if ( ieCheckit  ) item->em_NewMenu.nm_Flags |= CHECKIT;
    else              item->em_NewMenu.nm_Flags &= ~CHECKIT;
    if ( ieChecked  ) item->em_NewMenu.nm_Flags |= CHECKED;
    else              item->em_NewMenu.nm_Flags &= ~CHECKED;
    if ( ieToggle   ) item->em_NewMenu.nm_Flags |= MENUTOGGLE;
    else              item->em_NewMenu.nm_Flags &= ~MENUTOGGLE;

    if ( strlen( ptr )) {
        strcpy( &item->em_ShortCut[0], ptr );
        item->em_NewMenu.nm_CommKey = &item->em_ShortCut[0];
    } else
        item->em_NewMenu.nm_CommKey = 0l;
}

/*
 * --- Display the Item Edit requester.
 */
long ItemEdit( struct ExtNewMenu *parent )
{
    struct Gadget       *g;
    struct NewGadget     ng;
    BOOL                 running =  TRUE;
    WORD                 l, t, w, h, btop, bleft;
    struct ExtNewMenu   *menu, *dummy;
    UBYTE               *ptr;

    btop  = MainScreen->WBorTop + MainScreen->RastPort.TxHeight;
    bleft = MainScreen->WBorLeft;

    w = bleft + MainScreen->WBorRight  + 300;
    h = btop  + MainScreen->WBorBottom + 147;
    l = (( MainScreen->Width  >> 1 ) - ( w >> 1 ));
    t = (( MainScreen->Height >> 1 ) - ( h >> 1 ));

    ieZoom[0] = 0;
    ieZoom[1] = btop;
    ieZoom[2] = 200;
    ieZoom[3] = btop;

    ienwTags[0].ti_Data = l;
    ienwTags[1].ti_Data = t;
    ienwTags[2].ti_Data = w;
    ienwTags[3].ti_Data = h;

    ienwTags[10].ti_Data = (Tag)MainScreen;

    if (( MainScreen->Flags & CUSTOMSCREEN) == CUSTOMSCREEN )
        ienwTags[10].ti_Tag  = WA_CustomScreen;
    else if (( MainScreen->Flags & PUBLICSCREEN ) == PUBLICSCREEN )
        ienwTags[10].ti_Tag  = WA_PubScreen;
    else
        ienwTags[10].ti_Tag  = TAG_DONE;

    ieDisabled = ieCheckit = ieToggle = ieChecked = FALSE;

    ieList = parent->em_Items;

    if ( parent->em_NewMenu.nm_Type == NM_TITLE ) {
        if ( ieList->ml_First->em_Dummy )
            FreeMenuList( ieList, FALSE );
    }

    if ( g = CreateContext( &ieGList )) {

        ng.ng_Width         =   284;
        ng.ng_Height        =   12;
        ng.ng_GadgetText    =   0l;
        ng.ng_GadgetID      =   GD_ENTER;
        ng.ng_TextAttr      =   &Topaz80;
        ng.ng_VisualInfo    =   MainVisualInfo;

        g = CreateGadget( STRING_KIND, g, &ng, GTST_MaxChars, GT_MAXLABELNAME + 1, GT_Underscore, '_', TAG_DONE );

        SetStringGadget( g );

        ieGadgets[ GD_ENTER ] = g;

        ng.ng_LeftEdge      =   bleft + 8;
        ng.ng_TopEdge       =   btop + 16;
        ng.ng_Width         =   284;
        ng.ng_Height        =   60;
        ng.ng_GadgetText    =   "(Sub)Items:";
        ng.ng_GadgetID      =   GD_LIST;
        ng.ng_Flags         =   PLACETEXT_ABOVE;

        g = CreateGadget( LISTVIEW_KIND, g, &ng, GTLV_Labels, ieList, GTLV_ShowSelected, ieGadgets[ GD_ENTER ], GTLV_Selected, ~0, TAG_DONE );

        ieGadgets[ GD_LIST ] = g;

        ng.ng_LeftEdge      =   bleft + 266;
        ng.ng_TopEdge       =   btop + 85;
        ng.ng_GadgetText    =   "_Disabled";
        ng.ng_Flags         =   PLACETEXT_LEFT;
        ng.ng_GadgetID      =   GD_DISABLED;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GT_Underscore, '_', TAG_DONE );

        ieGadgets[ GD_DISABLED ] = g;

        ng.ng_LeftEdge      =   bleft + 125;
        ng.ng_GadgetText    =   "Check_it";
        ng.ng_GadgetID      =   GD_CHECKIT;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GT_Underscore, '_', TAG_DONE );

        ieGadgets[ GD_CHECKIT ] = g;

        ng.ng_TopEdge       =   btop + 100;
        ng.ng_GadgetText    =   "_Checked";
        ng.ng_GadgetID      =   GD_CHECKED;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GT_Underscore, '_', TAG_DONE );

        ieGadgets[ GD_CHECKED ] = g;

        ng.ng_LeftEdge      =   bleft + 266;
        ng.ng_GadgetText    =   "_MenuToggle";
        ng.ng_GadgetID      =   GD_TOGGLE;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GT_Underscore, '_', TAG_DONE );

        ieGadgets[ GD_TOGGLE ] = g;

        ng.ng_LeftEdge      =   bleft + 125;
        ng.ng_TopEdge       =   btop + 114;
        ng.ng_Width         =   167;
        ng.ng_Height        =   12;
        ng.ng_GadgetText    =   "_ShortCut";
        ng.ng_GadgetID      =   GD_SHORTCUT;

        g = CreateGadget( STRING_KIND, g, &ng, GTST_MaxChars, 1l, GT_Underscore, '_', TAG_DONE );

        SetStringGadget( g );

        ieGadgets[ GD_SHORTCUT ] = g;

        ng.ng_TopEdge       =   btop + 130;
        ng.ng_LeftEdge      =   bleft + 231;
        ng.ng_Width         =   60;
        ng.ng_Height        =   13;
        ng.ng_GadgetText    =   "D_ONE";
        ng.ng_GadgetID      =   GD_DONE;
        ng.ng_Flags         =   PLACETEXT_IN;

        g = CreateGadget( BUTTON_KIND, g, &ng, GT_Underscore, '_', TAG_DONE );

        ng.ng_LeftEdge      =   bleft + 83;
        ng.ng_GadgetText    =   "S_ubEd";
        ng.ng_GadgetID      =   GD_ITEMED;

        g = CreateGadget( BUTTON_KIND, g, &ng, GT_Underscore, '_', TAG_DONE );

        ieGadgets[ GD_ITEMED ] = g;

        ng.ng_LeftEdge      =   bleft + 158;
        ng.ng_GadgetText    =   "D_elete";
        ng.ng_GadgetID      =   GD_DELETE;

        g = CreateGadget( BUTTON_KIND, g, &ng, GT_Underscore, '_', TAG_DONE );

        ng.ng_LeftEdge      =   bleft + 8;
        ng.ng_GadgetText    =   "_BarLab";
        ng.ng_GadgetID      =   GD_BARLABEL;

        g = CreateGadget( BUTTON_KIND, g, &ng, GT_Underscore, '_', TAG_DONE );

        if ( g ) {

            ienwTags[6].ti_Data = (Tag)ieGList;

            if ( ieWnd = OpenWindowTagList( NULL, ienwTags )) {

                ieZoom[0] = l;
                ieZoom[1] = t;
                ieZoom[2] = w;
                ieZoom[3] = h;

                GT_RefreshWindow( ieWnd, NULL );

                do {
                    WaitPort( ieWnd->UserPort );

                    while ( ReadIMsg( ieWnd )) {

                        switch ( Class ) {

                            case    IDCMP_REFRESHWINDOW:
                                GT_BeginRefresh( ieWnd );
                                GT_EndRefresh( ieWnd, TRUE );
                                break;

                            case    IDCMP_CLOSEWINDOW:
                                running = FALSE;
                                break;

                            case    IDCMP_VANILLAKEY:
                                switch( Code ) {

                                    case    'd':
                                        FlipFlop( ieWnd, ieGadgets, GD_DISABLED, &ieDisabled );
                                        break;

                                    case    'i':
                                        FlipFlop( ieWnd, ieGadgets, GD_CHECKIT, &ieCheckit );
                                        break;

                                    case    'c':
                                        FlipFlop( ieWnd, ieGadgets, GD_CHECKED, &ieChecked );
                                        break;

                                    case    'm':
                                        FlipFlop( ieWnd, ieGadgets, GD_TOGGLE, &ieToggle );
                                        break;

                                    case    's':
                                        ActivateGadget( ieGadgets[ GD_SHORTCUT ], ieWnd, 0l );
                                        break;

                                    case    'u':
                                        if ( ieActEd == NM_ITEM )
                                            goto Sub;
                                        break;

                                    case    'e':
                                        goto Delete;

                                    case    'o':
                                        goto Done;

                                    case    'x':
                                        if ( ieItem ) {
                                            MutualExclude();
                                            ieItem = 0l;
                                        }
                                        break;
                                }
                                break;

                            case    IDCMP_GADGETUP:
                                switch ( theObject->GadgetID ) {

                                    case    GD_LIST:
                                        if ( ieItem ) SetTheFlags( ieItem );
                                        ieItem = ( struct ExtNewMenu * )FindNode(( struct List * )ieList, Code );
                                        if (( ieItem->em_NewMenu.nm_Flags & NM_ITEMDISABLED ) == NM_ITEMDISABLED )
                                            ieDisabled = TRUE; else ieDisabled = FALSE;
                                        if (( ieItem->em_NewMenu.nm_Flags & CHECKIT ) == CHECKIT )
                                            ieCheckit = TRUE; else ieCheckit = FALSE;
                                        if (( ieItem->em_NewMenu.nm_Flags & CHECKED ) == CHECKED )
                                            ieChecked = TRUE; else ieChecked = FALSE;
                                        if (( ieItem->em_NewMenu.nm_Flags & MENUTOGGLE ) == MENUTOGGLE )
                                            ieToggle = TRUE; else ieToggle = FALSE;

                                        GT_SetGadgetAttrs( ieGadgets[ GD_DISABLED ], ieWnd, 0l, GTCB_Checked, ieDisabled, TAG_DONE );
                                        GT_SetGadgetAttrs( ieGadgets[ GD_CHECKIT  ], ieWnd, 0l, GTCB_Checked, ieCheckit, TAG_DONE );
                                        GT_SetGadgetAttrs( ieGadgets[ GD_CHECKED  ], ieWnd, 0l, GTCB_Checked, ieChecked, TAG_DONE );
                                        GT_SetGadgetAttrs( ieGadgets[ GD_TOGGLE ], ieWnd, 0l, GTCB_Checked, ieToggle, TAG_DONE );
                                        if ( ieItem->em_NewMenu.nm_CommKey )
                                            GT_SetGadgetAttrs( ieGadgets[ GD_SHORTCUT ], ieWnd, 0l, GTST_String, ieItem->em_NewMenu.nm_CommKey, TAG_DONE );
                                        else
                                            GT_SetGadgetAttrs( ieGadgets[ GD_SHORTCUT ], ieWnd, 0l, GTST_String, 0l, TAG_DONE );
                                        break;

                                    case    GD_ENTER:
                                        ptr = (( struct StringInfo * )ieGadgets[ GD_ENTER ]->SpecialInfo )->Buffer;

                                        if ( strlen( ptr )) {
                                            if ( NOT ieItem ) {
                                                if ( menu = GetExtMenu( ptr, ieActEd )) {
                                                    GT_SetGadgetAttrs( ieGadgets[ GD_LIST ], ieWnd, 0l, GTLV_Labels, ~0, TAG_DONE );
                                                    SetTheFlags( menu );
                                                    AddTail(( struct List * )ieList, ( struct Node * )menu );
                                                    GT_SetGadgetAttrs( ieGadgets[ GD_LIST ], ieWnd, 0l, GTLV_Labels, ieList, TAG_DONE );
                                                    ieItem = 0l;
                                                }
                                            } else {
                                                if ( ieItem->em_NewMenu.nm_Label != NM_BARLABEL ) {
                                                    GT_SetGadgetAttrs( ieGadgets[ GD_LIST ], ieWnd, 0l, GTLV_Labels, ~0, TAG_DONE );
                                                    strcpy( &ieItem->em_TheMenuName[0], ptr );
                                                    SetTheFlags( ieItem );
                                                    GT_SetGadgetAttrs( ieGadgets[ GD_LIST ], ieWnd, 0l, GTLV_Labels, ieList, TAG_DONE );
                                                    ieItem = 0l;
                                                } else {
                                                    GT_SetGadgetAttrs( ieGadgets[ GD_ENTER ], ieWnd, 0l, GTST_String, "NM_BARLABEL", TAG_DONE );
                                                    DisplayBeep( MainScreen );
                                                }
                                            }
                                            GT_SetGadgetAttrs( ieGadgets[ GD_SHORTCUT ], ieWnd, 0l, GTST_String, 0l, TAG_DONE );
                                        }
                                        break;

                                    case    GD_DISABLED:
                                        FlipFlop( 0l, 0l, 0l, &ieDisabled );
                                        break;

                                    case    GD_CHECKIT:
                                        FlipFlop( 0l, 0l, 0l, &ieCheckit );
                                        break;

                                    case    GD_CHECKED:
                                        FlipFlop( 0l, 0l, 0l, &ieChecked );
                                        break;

                                    case    GD_TOGGLE:
                                        FlipFlop( 0l, 0l, 0l, &ieToggle );
                                        break;

                                    case    GD_DELETE:
                                        Delete:
                                        if ( ieItem ) {
                                            if ( MyRequest( "Excuse me..", "YES|NO", "--> %s <--\nAre you sure you want\nto delete this item?" , ieItem->em_NodeName )) {
                                                GT_SetGadgetAttrs( ieGadgets[ GD_LIST ], ieWnd, 0l, GTLV_Labels, ~0, TAG_DONE );
                                                Remove(( struct Node * )ieItem );
                                                FreeMenu( ieItem );
                                                GT_SetGadgetAttrs( ieGadgets[ GD_LIST ], ieWnd, 0l, GTLV_Labels, ieList, TAG_DONE );
                                                ieItem = 0l;
                                            }
                                        }
                                        break;

                                    case    GD_DONE:
                                        Done:
                                        if ( ieActEd == NM_SUB ) {
                                            SetTheFlags( ieItem );
                                            SetEd( NM_ITEM, 0l );
                                            break;
                                        }
                                        running = FALSE;
                                        break;

                                    case    GD_ITEMED:
                                        Sub:
                                        if ( ieItem ) {
                                            ieParent = ieList;
                                            SetEd( NM_SUB, ieItem );
                                        }
                                        break;

                                    case    GD_BARLABEL:
                                        Label:
                                        if ( menu = GetExtMenu( "", ieActEd )) {
                                            strcpy( &menu->em_TheMenuName[0], "NM_BARLABEL" );
                                            menu->em_NewMenu.nm_Label = NM_BARLABEL;
                                            GT_SetGadgetAttrs( ieGadgets[ GD_LIST ], ieWnd, 0l, GTLV_Labels, ~0, TAG_DONE );
                                            AddTail(( struct List * )ieList, ( struct Node * )menu );
                                            GT_SetGadgetAttrs( ieGadgets[ GD_LIST ], ieWnd, 0l, GTLV_Labels, ieList, TAG_DONE );
                                            ieItem = 0l;
                                        }
                                }
                                break;
                        }
                    }
                } while ( running );
            }
        }
    }

    if ( ieItem )
        SetTheFlags( ieItem );

    if ( ieActEd == NM_ITEM ) {
        if ( NOT ieList->ml_First->em_Next ) {
            if ( dummy = MakeDummy())
                AddTail(( struct List * )ieList, ( struct Node * )dummy );
        }
    }

    Saved = FALSE;

    if ( ieWnd )           CloseWindow( ieWnd );
    if ( ieGList )         FreeGadgets( ieGList );

    ieWnd   = 0l;
    ieGList = 0l;

    ClearMsgPort( meWnd->UserPort );

    return( TRUE );
}
