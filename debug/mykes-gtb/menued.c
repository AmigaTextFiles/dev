/*-- AutoRev header do NOT edit!
*
*   Program         :   MenuEd.c
*   Copyright       :   © Copyright 1991 Jaba Development
*   Author          :   Jan van den Baard
*   Creation Date   :   28-Oct-91
*   Current version :   1.00
*   Translator      :   DICE v2.6
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   28-Oct-91     1.00            Menu edit requester.
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
extern struct Window        *MainWindow;
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
#define GD_ITEMED        3
#define GD_DELETE        4
#define GD_DONE          5

/*
 * --- Module data.
 */
struct Window           *meWnd   = NULL;
struct Gadget           *meGList = NULL;
struct Gadget           *meGadgets[3];
struct ExtNewMenu       *meMenu = 0l;

struct ExtMenuList       ExtMenus;
BOOL                     meDisabled = FALSE;

WORD                     meZoom[4];

struct TagItem           menwTags[] = {
    WA_Left,                0l,
    WA_Top,                 0l,
    WA_Width,               0l,
    WA_Height,              0l,
    WA_IDCMP,               IDCMP_CLOSEWINDOW | BUTTONIDCMP | LISTVIEWIDCMP  | CHECKBOXIDCMP | IDCMP_VANILLAKEY | IDCMP_REFRESHWINDOW,
    WA_Flags,               WFLG_DRAGBAR | WFLG_DEPTHGADGET| WFLG_CLOSEGADGET | WFLG_ACTIVATE | WFLG_RMBTRAP | WFLG_SMART_REFRESH,
    WA_Gadgets,             0l,
    WA_Title,               (ULONG)"Edit Menus:",
    WA_AutoAdjust,          TRUE,
    WA_Zoom,                (Tag)meZoom,
    WA_CustomScreen,        0l,
    TAG_DONE };

/*
 * --- Make a dummy item.
 */
struct ExtNewMenu *MakeDummy( void )
{
    struct ExtNewMenu *dummy;

    if ( dummy = ( struct ExtNewMenu * ) Malloc((long)sizeof( struct ExtNewMenu ))) {
        strcpy( &dummy->em_TheMenuName[0], "DUMMY" );
        dummy->em_NewMenu.nm_Label = &dummy->em_TheMenuName[0];
        dummy->em_NodeName         = &dummy->em_TheMenuName[0];
        dummy->em_NewMenu.nm_Type  = NM_ITEM;
        dummy->em_NewMenu.nm_Flags = NM_ITEMDISABLED;
        dummy->em_Dummy            = TRUE;
        return( dummy );
    }
    return( NULL );
}

/*
 * --- Set up a ExtNewMenu
 */
struct ExtNewMenu *GetExtMenu( UBYTE *name, long type )
{
    struct ExtNewMenu   *menu, *dummy;

    if ( menu = ( struct ExtNewMenu * )Malloc( (long)sizeof( struct ExtNewMenu ))) {
        strcpy( &menu->em_TheMenuName[0], name );
        menu->em_NewMenu.nm_Type  = type;
        menu->em_NewMenu.nm_Label = &menu->em_TheMenuName[0];
        menu->em_NodeName         = &menu->em_TheMenuName[0];
        if ( type == NM_TITLE ) {
            if ( menu->em_Items = ( struct ExtMenuList * )Malloc((long)sizeof( struct ExtMenuList ))) {
                NewList(( struct List * )menu->em_Items );
                if ( dummy = MakeDummy()) {
                    menu->em_SpecialFlags |= EMF_HASDUMMY;
                    AddTail(( struct List * )menu->em_Items, ( struct Node * )dummy );
                } else goto noMem;
            } else goto noMem;
        }
        return( menu );
    }
    noMem:
    MyRequest( "Ouch...", "OK", "Out of memory !" );
    return( 0l );
}

/*
 * --- Free the list
 */
void FreeMenuList( struct ExtMenuList *list, long all )
{
    struct ExtNewMenu *tmp;

    while ( tmp = ( struct ExtNewMenu * )RemHead(( struct List * )list ))
        free( tmp );

    if ( all )
        free( list );
}

/*
 * --- Free the items from a menu and the menu.
 */
void FreeMenu( struct ExtNewMenu *menu )
{
    struct ExtNewMenu *item;

    if( menu->em_Items ) {
        for ( item = menu->em_Items->ml_First; item->em_Next; item = item->em_Next ) {
            if ( item->em_Items )
                FreeMenuList( item->em_Items, TRUE );
        }
        FreeMenuList( menu->em_Items, TRUE );
    }
    free( menu );
}

/*
 * --- Free all NewMenus.
 */
void FreeNewMenus( void )
{
    struct ExtNewMenu   *menu;

    while ( menu = ( struct ExtNewMenu * )RemHead(( struct List * )&ExtMenus ))
        FreeMenu( menu );
}

/*
 * --- Test the menus.
 */
void TestMenus( void )
{
    struct ExtNewMenu   *menu, *item, *sub;
    struct NewMenu      *strip, *tmp;
    struct Menu         *themenu;
    UWORD                num = 0;

    for ( menu = ExtMenus.ml_First; menu->em_Next; menu = menu->em_Next ) {
        num++;
        for ( item = menu->em_Items->ml_First; item->em_Next;  item = item->em_Next ) {
            num++;
            for ( sub = item->em_Items->ml_First; sub->em_Next;  sub = sub->em_Next )
                num++;
        }
    }

    num++;

    if ( tmp = strip = ( struct NewMenu * )Malloc( (long)sizeof( struct NewMenu ) * num )) {
        for ( menu = ExtMenus.ml_First; menu->em_Next; menu = menu->em_Next ) {
            CopyMem(( char * )&menu->em_NewMenu, tmp++, (long)sizeof( struct NewMenu ));
            for ( item = menu->em_Items->ml_First; item->em_Next;  item = item->em_Next ) {
                CopyMem(( char * )&item->em_NewMenu, tmp++, (long)sizeof( struct NewMenu ));
                for ( sub = item->em_Items->ml_First; sub->em_Next;  sub = sub->em_Next )
                    CopyMem(( char * )&sub->em_NewMenu, tmp++, (long)sizeof( struct NewMenu ));
            }
        }
        tmp->nm_Type = NM_END;
        if ( themenu = CreateMenus( strip, GTMN_FrontPen, 0, TAG_DONE  )) {
            LayoutMenus( themenu, MainVisualInfo, GTMN_TextAttr, &MainFont, TAG_DONE );

            ClearMenuStrip( MainWindow );
            SetMenuStrip( MainWindow, themenu );

            SetTitle( "TESTING MENUS !! ESC TO QUIT..." );

            while ( Code != 0x45 ) {
                WaitPort( MainWindow->UserPort );
                while( ReadIMsg( MainWindow )) {
                    if ( Class == IDCMP_MENUPICK )
                        SetTitle( "TESTING MENUS !! ESC TO QUIT..." );
                }
            }

            ClearMenuStrip( MainWindow );
            ResetMenuStrip( MainWindow, MainMenus );
            FreeMenus( themenu );
            SetWindowTitles( MainWindow, MainWindowTitle, MainScreenTitle );
        }
        free( strip );
    }
}

/*
 * --- Display the Menu Edit requester.
 */
long MenuEdit( void )
{
    struct Gadget       *g;
    struct NewGadget     ng;
    BOOL                 running =  TRUE;
    WORD                 l, t, w, h, btop, bleft;
    struct ExtNewMenu   *menu;
    UBYTE               *ptr;

    btop  = MainScreen->WBorTop + MainScreen->RastPort.TxHeight;
    bleft = MainScreen->WBorLeft;

    w = bleft + MainScreen->WBorRight  + 300;
    h = btop  + MainScreen->WBorBottom + 117;
    l = (( MainScreen->Width  >> 1 ) - ( w >> 1 ));
    t = (( MainScreen->Height >> 1 ) - ( h >> 1 ));

    meZoom[0] = 0;
    meZoom[1] = btop;
    meZoom[2] = 200;
    meZoom[3] = btop;

    menwTags[0].ti_Data = l;
    menwTags[1].ti_Data = t;
    menwTags[2].ti_Data = w;
    menwTags[3].ti_Data = h;

    menwTags[10].ti_Data = (Tag)MainScreen;

    if (( MainScreen->Flags & CUSTOMSCREEN) == CUSTOMSCREEN )
        menwTags[10].ti_Tag  = WA_CustomScreen;
    else if (( MainScreen->Flags & PUBLICSCREEN ) == PUBLICSCREEN )
        menwTags[10].ti_Tag  = WA_PubScreen;
    else
        menwTags[10].ti_Tag  = TAG_DONE;

    meDisabled = FALSE;

    if ( g = CreateContext( &meGList )) {

        ng.ng_Width         =   284;
        ng.ng_Height        =   12;
        ng.ng_GadgetText    =   0l;
        ng.ng_GadgetID      =   GD_ENTER;
        ng.ng_TextAttr      =   &Topaz80;
        ng.ng_VisualInfo    =   MainVisualInfo;

        g = CreateGadget( STRING_KIND, g, &ng, GTST_MaxChars, GT_MAXLABELNAME + 1, GT_Underscore, '_', TAG_DONE );

        SetStringGadget( g );

        meGadgets[ GD_ENTER ] = g;

        ng.ng_LeftEdge      =   bleft + 8;
        ng.ng_TopEdge       =   btop + 16;
        ng.ng_Width         =   284;
        ng.ng_Height        =   60;
        ng.ng_GadgetText    =   "Menus:";
        ng.ng_GadgetID      =   GD_LIST;
        ng.ng_Flags         =   PLACETEXT_ABOVE;

        g = CreateGadget( LISTVIEW_KIND, g, &ng, GTLV_Labels, &ExtMenus, GTLV_ShowSelected, meGadgets[ GD_ENTER ], GTLV_Selected, ~0, TAG_DONE );

        meGadgets[ GD_LIST ] = g;

        ng.ng_LeftEdge      =   bleft + 266;
        ng.ng_TopEdge       =   btop + 85;
        ng.ng_GadgetText    =   "_Disabled";
        ng.ng_Flags         =   PLACETEXT_LEFT;
        ng.ng_GadgetID      =   GD_DISABLED;

        g = CreateGadget( CHECKBOX_KIND, g, &ng, GT_Underscore, '_', TAG_DONE );

        meGadgets[ GD_DISABLED ] = g;

        ng.ng_TopEdge       =   btop + 100;
        ng.ng_LeftEdge      =   bleft + 231;
        ng.ng_Width         =   60;
        ng.ng_Height        =   13;
        ng.ng_GadgetText    =   "D_ONE";
        ng.ng_GadgetID      =   GD_DONE;
        ng.ng_Flags         =   PLACETEXT_IN;

        g = CreateGadget( BUTTON_KIND, g, &ng, GT_Underscore, '_', TAG_DONE );

        ng.ng_LeftEdge      =   bleft + 83;
        ng.ng_GadgetText    =   "_ItemEd";
        ng.ng_GadgetID      =   GD_ITEMED;

        g = CreateGadget( BUTTON_KIND, g, &ng, GT_Underscore, '_', TAG_DONE );

        ng.ng_LeftEdge      =   bleft + 158;
        ng.ng_GadgetText    =   "D_elete";
        ng.ng_GadgetID      =   GD_DELETE;

        g = CreateGadget( BUTTON_KIND, g, &ng, GT_Underscore, '_', TAG_DONE );

        if ( g ) {

            menwTags[6].ti_Data = (Tag)meGList;

            if ( meWnd = OpenWindowTagList( NULL, menwTags )) {

                meZoom[0] = l;
                meZoom[1] = t;
                meZoom[2] = w;
                meZoom[3] = h;

                GT_RefreshWindow( meWnd, NULL );

                do {
                    WaitPort( meWnd->UserPort );

                    while ( ReadIMsg( meWnd )) {

                        switch ( Class ) {

                            case    IDCMP_REFRESHWINDOW:
                                GT_BeginRefresh( meWnd );
                                GT_EndRefresh( meWnd, TRUE );
                                break;

                            case    IDCMP_CLOSEWINDOW:
                                running = FALSE;
                                break;

                            case    IDCMP_VANILLAKEY:
                                switch( Code ) {

                                    case    'd':
                                        FlipFlop( meWnd, meGadgets, GD_DISABLED, &meDisabled );
                                        break;

                                    case    'i':
                                        goto Items;

                                    case    'e':
                                        goto Delete;

                                    case    'o':
                                        goto Done;
                                }
                                break;

                            case    IDCMP_GADGETUP:
                                switch ( theObject->GadgetID ) {

                                    case    GD_LIST:
                                        if ( meMenu ) {
                                            if ( meDisabled )
                                                    meMenu->em_NewMenu.nm_Flags |= NM_MENUDISABLED;
                                            else
                                                    meMenu->em_NewMenu.nm_Flags &= ~NM_MENUDISABLED;
                                        }
                                        meMenu = ( struct ExtNewMenu * )FindNode(( struct List * )&ExtMenus, Code );
                                        if (( meMenu->em_NewMenu.nm_Flags & NM_MENUDISABLED ) == NM_MENUDISABLED )
                                            meDisabled = TRUE; else meDisabled = FALSE;

                                        GT_SetGadgetAttrs( meGadgets[ GD_DISABLED ], meWnd, 0l, GTCB_Checked, meDisabled, TAG_DONE );
                                        break;

                                    case    GD_ENTER:
                                        ptr = (( struct StringInfo * )meGadgets[ GD_ENTER ]->SpecialInfo )->Buffer;

                                        if ( strlen( ptr )) {
                                            if ( NOT meMenu ) {
                                                if ( menu = GetExtMenu( ptr, NM_TITLE )) {
                                                    GT_SetGadgetAttrs( meGadgets[ GD_LIST ], meWnd, 0l, GTLV_Labels, ~0, TAG_DONE );
                                                    if ( meDisabled )
                                                        menu->em_NewMenu.nm_Flags |= NM_MENUDISABLED;
                                                    AddTail(( struct List * )&ExtMenus, ( struct Node * )menu );
                                                    GT_SetGadgetAttrs( meGadgets[ GD_LIST ], meWnd, 0l, GTLV_Labels, &ExtMenus, TAG_DONE );
                                                    meMenu = 0l;
                                                }
                                            } else {
                                                GT_SetGadgetAttrs( meGadgets[ GD_LIST ], meWnd, 0l, GTLV_Labels, ~0, TAG_DONE );
                                                strcpy( &meMenu->em_TheMenuName[0], ptr );
                                                if ( meDisabled )
                                                        meMenu->em_NewMenu.nm_Flags |= NM_MENUDISABLED;
                                                else
                                                        meMenu->em_NewMenu.nm_Flags &= ~NM_MENUDISABLED;

                                                GT_SetGadgetAttrs( meGadgets[ GD_LIST ], meWnd, 0l, GTLV_Labels, &ExtMenus, TAG_DONE );
                                                meMenu = 0l;
                                            }
                                        }
                                        break;

                                    case    GD_DISABLED:
                                        FlipFlop( 0l, 0l, 0l, &meDisabled );
                                        break;

                                    case    GD_DELETE:
                                        Delete:
                                        if ( meMenu ) {
                                            if ( MyRequest( "Excuse me..", "YES|NO", "--> %s <--\nAre you sure you want\nto delete this menu ?" , meMenu->em_NodeName )) {
                                                GT_SetGadgetAttrs( meGadgets[ GD_LIST ], meWnd, 0l, GTLV_Labels, ~0, TAG_DONE );
                                                Remove(( struct Node * )meMenu );
                                                FreeMenu( meMenu );
                                                GT_SetGadgetAttrs( meGadgets[ GD_LIST ], meWnd, 0l, GTLV_Labels, &ExtMenus, TAG_DONE );
                                                meMenu = 0l;
                                            }
                                        }
                                        break;

                                    case    GD_ITEMED:
                                        Items:
                                        if ( meMenu ) {
                                            GT_SetGadgetAttrs( meGadgets[ GD_LIST ], meWnd, 0l, GTLV_Labels, ~0, TAG_DONE );
                                            ItemEdit( meMenu );
                                            GT_SetGadgetAttrs( meGadgets[ GD_LIST ], meWnd, 0l, GTLV_Labels, &ExtMenus, TAG_DONE );
                                        }
                                        meMenu = 0l;
                                        break;

                                    case    GD_DONE:
                                        Done:
                                        running = FALSE;
                                        break;
                                }
                                break;
                        }
                    }
                } while ( running );
            }
        }
    }

    if ( meMenu ) {
        if ( meDisabled )
            meMenu->em_NewMenu.nm_Flags |= NM_MENUDISABLED;
        else
            meMenu->em_NewMenu.nm_Flags &= ~NM_MENUDISABLED;
    }

    Saved = FALSE;

    if ( meWnd )           CloseWindow( meWnd );
    if ( meGList )         FreeGadgets( meGList );

    meWnd   = 0l;
    meGList = 0l;

    ClearMsgPort( MainWindow->UserPort );

    return( TRUE );
}
