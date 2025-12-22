/*-- AutoRev header do NOT edit!
*
*   Program         :   main.c
*   Copyright       :   © Copyright 1991 Jaba Development
*   Author          :   Jan van den Baard
*   Creation Date   :   28-Sep-91
*   Current version :   1.0
*   Translator      :   DICE v2.6
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   28-Sep-91     1.0             main routine
*
*-- REV_END --*/

#include	"defs.h"

/*
 * --- External referenced data.
 */
extern struct Window        *MainWindow;
extern struct Screen        *MainScreen;
extern struct RastPort      *MainRP;
extern struct Process       *MainProc;
extern struct Menu          *MainMenus;
extern ULONG                 Class;
extern UWORD                 Code;
extern UBYTE                 MainFileName[512], MainWBStatus[20];
extern APTR                  MainVisualInfo;
extern UBYTE                *MainExtension;
extern struct TextAttr       Topaz80;
extern struct TagItem        MainSTags[];
extern UWORD                 sc_Height;
extern BOOL                  WBenchClose;
extern struct ExtGadgetList  Gadgets;
extern struct Gadget        *MainGList;
extern UWORD                 ActiveKind;
extern struct TagItem        nwTags[];
extern BOOL                  BreakDRAG;
extern struct Prefs          MainPrefs;
extern UBYTE                 MainWindowTitle[80], MainScreenTitle[80];
extern BOOL                  Saved;
extern ULONG                 Args[];
extern struct RDArgs         IArgs, *FArgs;
extern UBYTE                *Template;
extern WORD                  ws_IWidth, ws_IHeight;
extern UBYTE                 bi_SPath[], bi_LPath[];
extern UBYTE                 bi_SFile[], bi_LFile[];
extern struct ExtMenuList    ExtMenus;

APTR	Malloc(ULONG size) {
	ULONG	i;
	UBYTE	*pm = malloc(size);

	if (!pm) return NULL;
	for (i=0; i<size; i++) pm[i] = 0;
	return (APTR)pm;
}

/*
 * --- The main menu strip.
 */
struct NewMenu           Menus[] = {
    /*** the Project menu ***/
    NM_TITLE,   "Project",              0,  0,  0,  0,
    NM_ITEM,    "About",                "?",0,  0,  0,
    NM_ITEM,    NM_BARLABEL,            0,  0,  0,  0,
    NM_ITEM,    "New",                  "N",0,  0,  0,
    NM_ITEM,    NM_BARLABEL,            0,  0,  0,  0,
    NM_ITEM,    "Load",                 "L",0,  0,  0,
    NM_ITEM,    "Save",                 "S",0,  0,  0,
    NM_ITEM,    "Save As..",            "V",0,  0,  0,
    NM_ITEM,    NM_BARLABEL,            0,  0,  0,  0,
    NM_ITEM,    "Generate Source",      0,  0,  0,  0,
    NM_SUB,     "C",                    "C",0,  0,  0,
    NM_SUB,     "Assembler",            "A",0,  0,  0,
    NM_ITEM,    NM_BARLABEL,            0,  0,  0,  0,
    NM_ITEM,    "Preferences",          "P",0,  0,  0,
    NM_ITEM,    NM_BARLABEL,            0,  0,  0,  0,
    NM_ITEM,    MainWBStatus,           "W",0,  0,  0,
    NM_ITEM,    NM_BARLABEL,            0,  0,  0,  0,
    NM_ITEM,    "Quit",                 "Q",0,  0,  0,

    /*** the Gadgets menu ***/
    NM_TITLE,   "Gadgets",              0,  0,  0,  0,
    NM_ITEM,    "Kind",                 0,  0,  0,  0,
    NM_SUB,     "BUTTON",               "1", CHECKIT + CHECKED, ~1,  0,
    NM_SUB,     "CHECKBOX",             "2", CHECKIT,           ~2,  0,
    NM_SUB,     "INTEGER",              "3", CHECKIT,           ~4,  0,
    NM_SUB,     "LISTVIEW",             "4", CHECKIT,           ~8,  0,
    NM_SUB,     "MX",                   "5", CHECKIT,           ~16, 0,
    NM_SUB,     "CYCLE",                "6", CHECKIT,           ~32, 0,
    NM_SUB,     "PALETTE",              "7", CHECKIT,           ~64, 0,
    NM_SUB,     "SCROLLER",             "8", CHECKIT,           ~128,0,
    NM_SUB,     "SLIDER",               "9", CHECKIT,           ~256,0,
    NM_SUB,     "STRING",               "0", CHECKIT,           ~512,0,
    NM_ITEM,    NM_BARLABEL,            0,  0,  0,  0,
    NM_ITEM,    "Move   a gadget",      "M",0,  0,  0,
    NM_ITEM,    "Size   a gadget",      "Z",0,  0,  0,
    NM_ITEM,    "Copy   a gadget",      "O",0,  0,  0,
    NM_ITEM,    "Delete a gadget",      "D",0,  0,  0,
    NM_ITEM,    "Edit   a gadget",      "E",0,  0,  0,
    NM_ITEM,    NM_BARLABEL,            0,  0,  0,  0,
    NM_ITEM,    "Join",                 "J",0,  0,  0,
    NM_ITEM,    "Split",                "Y",0,  0,  0,

    /*** the Window menu ***/
    NM_TITLE,   "Window",               0,  0,  0,  0,
    NM_ITEM,    "Edit Flags",           "F",0,  0,  0,
    NM_ITEM,    "Edit IDCMP",           "I",0,  0,  0,
    NM_ITEM,    "Edit Tags",            "T",0,  0,  0,
    NM_ITEM,    NM_BARLABEL,            0,  0,  0,  0,
    NM_ITEM,    "Add    a text",        "X",0,  0,  0,
    NM_ITEM,    "Modify a text",        "Y",0,  0,  0,
    NM_ITEM,    "Delete a text",        "K",0,  0,  0,
    NM_ITEM,    "Move   a text",        "H",0,  0,  0,

    /*** the Screen menu ***/
    NM_TITLE,   "Screen",               0,  0,  0,  0,
    NM_ITEM,    "Palette",              "T",0,  0,  0,
    NM_ITEM,    "Get Font",             "G",0,  0,  0,
    NM_ITEM,    "Set DriPens",          "R",0,  0,  0,
    NM_ITEM,    "Edit Tags",            "G",0,  0,  0,

    /*** the Menu menu ***/
    NM_TITLE,   "Menus",                0,  0,  0,  0,
    NM_ITEM,    "Edit Menus",           "<",0,  0,  0,
    NM_ITEM,    "Test Menus",           ">",0,  0,  0,

    NM_END };

/*
 * --- Handle all menu events. This routine also
 * --- handles drag selections.
 */
void HandleMenus( void )
{
    struct IntuiText *t;
    struct MenuItem  *Next;
    UWORD             menu, item, sub, sel = Code;

    while  ( sel != MENUNULL ) {

        menu = MENUNUM( sel );
        item = ITEMNUM( sel );
        sub  = SUBNUM( sel );

        switch ( menu ) {

            case    0:
                switch ( item ) {

                    case    0: /*** About ***/
                        About();
                        break;
                    case    2: /*** New ***/
                        New();
                        break;
                    case    4: /*** Load ***/
                        ReadBinary( TRUE );
                        break;
                    case    5: /*** Save ***/
                        WriteBinary( FALSE );
                        break;
                    case    6: /*** Save As ***/
                        WriteBinary( TRUE );
                        break;
                    case    8: /*** Generate Source ***/
                        switch ( sub ) {

                            case    0: /*** C ***/
                                WriteCSource();
                                break;
                            case    1: /*** Assembler ***/
                                WriteAsmSource();
                                break;
                        }
                        break;
                    case    10: /*** Preferences ***/
                        Preferences();
                        break;
                    case    12: /*** Workbench ***/
                        DoWBench();
                        break;
                    case    14: /*** Quit ***/
                        Quit();
                        break;
                        break;
                }
                break;

            case    1:
                switch ( item ) {

                    case    0:
                        switch ( sub ) {

                            case    0: /*** BUTTON ***/
                                ActiveKind = BUTTON_KIND;
                                break;
                            case    1: /*** CHECKBOX ***/
                                ActiveKind = CHECKBOX_KIND;
                                break;
                            case    2: /*** INTEGER ***/
                                ActiveKind = INTEGER_KIND;
                                break;
                            case    3: /*** LISTVIEW ***/
                                ActiveKind = LISTVIEW_KIND;
                                break;
                            case    4: /*** MX ***/
                                ActiveKind = MX_KIND;
                                break;
                            case    5: /*** CYCLE ***/
                                ActiveKind = CYCLE_KIND;
                                break;
                            case    6: /*** PALETTE ***/
                                ActiveKind = PALETTE_KIND;
                                break;
                            case    7: /*** SCROLLER ***/
                                ActiveKind = SCROLLER_KIND;
                                break;
                            case    8: /*** SLIDER ***/
                                ActiveKind = SLIDER_KIND;
                                break;
                            case    9: /*** STRING ***/
                                ActiveKind = STRING_KIND;
                                break;
                        }
                        break;

                    case    2: /*** Move ***/
                        MoveGadget();
                        break;
                    case    3: /*** Size ***/
                        SizeGadget();
                        break;
                    case    4: /*** Copy ***/
                        CopyGadget();
                        break;
                    case    5: /*** Delete ***/
                        DeleteGadget();
                        break;
                    case    6: /*** Edit ***/
                        EditGadget();
                        break;
                    case    8: /*** Join ***/
                        Join();
                        break;
                    case    9: /*** Split ***/
                        Split();
                        break;
                }
                break;

            case    2:
                switch ( item ) {

                    case    0: /*** Window Flags ***/
                        EditFlags();
                        break;
                    case    1: /*** Window IDCMP ***/
                        EditIDCMP();
                        break;
                    case    2: /*** Window Tags ***/
                        WindowSpecial();
                        break;
                    case    4: /*** Add text ***/
                        PlaceText( EditText( 0l ));
                        RefreshWindow();
                        break;
                    case    5: /*** Modify text ***/
                        t = SelectText();
                        if ( t ) EditText( t );
                        ClearWindow();
                        RefreshWindow();
                        break;
                    case    6: /*** Delete text ***/
                        RemoveText( SelectText());
                        ClearWindow();
                        RefreshWindow();
                        break;
                    case    7: /*** Move text ***/
                        PlaceText( SelectText());
                        ClearWindow();
                        RefreshWindow();
                        break;
                }
                break;

            case    3:
                switch ( item ) {

                    case    0: /*** Screen Palette ***/
                        SetPalette();
                        break;

                    case    1: /*** Get Font ***/
                        GetFont();
                        break;

                    case    2: /*** Edit screen dripens ***/
                        EditDriPens();
                        break;

                    case    3: /*** Edit Screen tags ***/
                        ScreenSpecial();
                        break;
                }
                break;

            case    4:
                switch ( item ) {

                    case    0: /*** Edit Menus ***/
                        MenuEdit();
                        break;
                    case    1: /*** Test Menus ***/
                        TestMenus();
                        break;
                }
                break;
        }

        if ( BreakDRAG ) {
            BreakDRAG = FALSE;
            break;
        } else {
            Next = ItemAddress(  MainMenus, sel );
            sel = Next->NextSelect;
        }
    }
}

/*
 * --- Allocate and open all resources.
 */
void SetupProgram( long dsp )
{
    BPTR    file;

    if ( NOT OpenLibraries())
        QuitProgram( 20l );

    NewList(( struct List * )&Gadgets );
    NewList(( struct List * )&ExtMenus );

    if ( NOT ModeNotAvailable( PAL_MONITOR_ID )) {
        MainSTags[3].ti_Data = 256;
        sc_Height            = 256;
    } else {
        MainSTags[3].ti_Data = 200;
        sc_Height            = 200;
    }

    if ( file = Open( "DEVS:GadToolsBox.PREFS", MODE_OLDFILE )) {
        Read( file, (char *)&MainPrefs, (long)sizeof( struct Prefs ));
        Close( file );
    }

    if ( NOT dsp ) {
        if ( NOT ScreenSelect())
            QuitProgram( 0l );

        if( NOT ReOpenScreen( TRUE ))
            QuitProgram( 22l );
    }
}

/*
 * --- Deallocate and close all resources.
 */
void QuitProgram( long code )
{
    if ( WBenchClose )
        DoWBench();

    DeleteTexts();
    FreeNewMenus();

    if ( MainMenus ) {
        if ( MainWindow )   ClearMenuStrip( MainWindow );
        FreeMenus( MainMenus );
    }
    if ( MainWindow )
        CloseWindow( MainWindow );
    if ( MainGList )
        FreeGadgets( MainGList );

    FreeScreenInfo( MainScreen );

    if ( MainScreen )
        CloseScreen( MainScreen );

    if ( FArgs )
        FreeArgs( FArgs );

    CloseLibraries();

    exit( code );
}

/*
 * --- Clear the entire edit window.
 */
void ClearWindow( void )
{
    WORD    x, y, x1, y1;

    x  = MainWindow->BorderLeft;
    y  = MainWindow->BorderTop;
    x1 = MainWindow->Width - MainWindow->BorderRight - 1;
    y1 = MainWindow->Height - MainWindow->BorderBottom - 1;

    SetAPen( MainRP, 0);
    SetDrMd( MainRP, JAM1 );
    RectFill( MainRP, x, y, x1, y1 );

    RefreshWindowFrame( MainWindow );
}

/*
 * --- Move a gadget.
 */
void MoveGadget( void )
{
    struct ExtNewGadget *eng;
    struct Gadget       *g;
    WORD                 x, y, w, h, xo, yo, mx, my;
    BOOL                 mm;

    if ( NOT Gadgets.gl_First->en_Next ) return;

    SetTitle( "CLICK ON GADGET TO MOVE..." );

    if ( g = WaitForGadget( MainWindow )) {

        mm = MouseMove( MainWindow, FALSE );

        RemoveAllGadgets();

        eng = FindExtGad( g );

        x = eng->en_NewGadget.ng_LeftEdge - 1;
        y = eng->en_NewGadget.ng_TopEdge  - 1;
        w = eng->en_NewGadget.ng_Width    + 1;
        h = eng->en_NewGadget.ng_Height   + 1;

        Box( x, y, x + w, y + h );

        SetTitle( 0l );
        DisplayGInfo( eng->en_Kind, x + 1, y + 1, x + w - 1, y + h - 1 );

        GetMouseXY( &mx, &my );

        xo = mx - x;
        yo = my - y;

        while ( Code != SELECTDOWN ) {
            while ( ReadIMsg( MainWindow )) {
                if ( Code == SELECTDOWN ) break;
                if ( Class == IDCMP_MENUPICK ) {
                    SetTitle( 0l );
                    DisplayGInfo( eng->en_Kind, x + 1, y + 1, x + w - 1, y + h - 1);
                }
            }
            GetMouseXY( &mx, &my );
            if ( mx != ( x + xo ) || my != ( y + yo )) {
                Box( x, y, x + w, y + h );
                x = mx - xo;
                y = my - yo;
                Box( x, y, x + w, y + h );
                DisplayGInfo( eng->en_Kind, x + 1, y + 1, x + w - 1, y + h - 1 );
            }
        }

        Box( x, y, x + w, y + h );
        eng->en_NewGadget.ng_LeftEdge = x + 1;
        eng->en_NewGadget.ng_TopEdge  = y + 1;
        RemakeAllGadgets();

        if ( mm ) MouseMove( MainWindow, TRUE );
    }
    SetWindowTitles( MainWindow, (char *)-1l, MainScreenTitle );
    ClearMsgPort( MainWindow->UserPort );
    RefreshWindow();
    Saved = FALSE;
}

/*
 * --- Re-size a gadget.
 */
void SizeGadget( void )
{
    struct ExtNewGadget *eng;
    struct Gadget       *g;
    WORD                 x, y, w, h, xo, yo, mx, my;
    WORD                 minx, miny;
    BOOL                 mm;

    if ( NOT Gadgets.gl_First->en_Next ) return;

    SetTitle( "CLICK ON GADGET TO SIZE..." );

    if ( g = WaitForGadget( MainWindow )) {

        mm = MouseMove( MainWindow, FALSE );

        RemoveAllGadgets();

        eng = FindExtGad( g );

        if ( eng->en_Kind == CHECKBOX_KIND ) {
            MyRequest( "Hey dude...", "OK", "You cannot resize a\n  CHECKBOX kind !" );
            goto noWay;
        } else if ( eng->en_Kind == MX_KIND ) {
            MyRequest( "Hey dude...", "OK", "You cannot resize a\n     MX kind !" );
            goto noWay;
        } else if ( eng->en_Kind == STRING_KIND ) {
            if (( eng->en_SpecialFlags & EGF_ISLOCKED ) == EGF_ISLOCKED ) {
                MyRequest( "Hey dude...", "OK", "You cannot resize a\nJoined string kind !" );
                goto noWay;
            }
        }

        x = eng->en_NewGadget.ng_LeftEdge - 1;
        y = eng->en_NewGadget.ng_TopEdge  - 1;
        w = eng->en_NewGadget.ng_Width    + 1;
        h = eng->en_NewGadget.ng_Height   + 1;

        Box( x, y, x + w, y + h );

        SetTitle( 0l );
        DisplayGInfo( eng->en_Kind , x + 1, y + 1, x + w - 1, y + h - 1 );

        GetMouseXY( &mx, &my );

        switch( eng->en_Kind ) {

            case    BUTTON_KIND:
            case    CYCLE_KIND:
                    minx = MainScreen->RastPort.TxWidth + 8;
                    miny = MainScreen->RastPort.TxHeight + 3;
                    break;

            case    INTEGER_KIND:
            case    STRING_KIND:
                    minx = MainScreen->RastPort.TxWidth  + 13;
                    miny = MainScreen->RastPort.TxHeight + 4;
                    break;

            case    LISTVIEW_KIND:
                    if ( eng->en_ScrollWidth )
                        minx = eng->en_ScrollWidth + 14;
                    else
                        minx = 30;
                    miny = (MainScreen->RastPort.TxHeight << 1) + 9;
                    break;

            case    PALETTE_KIND:
                    if ( MyTagInArray( GTPA_IndicatorWidth, eng->en_Tags )) {
                        minx = eng->en_IndicatorSize + 20;
                        miny = 20;
                    } else {
                        minx = 20;
                        miny =  ( eng->en_IndicatorSize >> 1 ) + 20;
                    }
                    break;

            case    SCROLLER_KIND:
                    if ( NOT MyTagInArray( PGA_Freedom, eng->en_Tags )) {
                        minx = ( eng->en_ArrowSize << 1 ) + 10;
                        miny = 8;
                    } else {
                        minx = 10;
                        miny = (eng->en_ArrowSize << 1) + 10;
                    }
                    break;

            case    SLIDER_KIND:
                    minx = 12;
                    miny = 8;
                    break;
        }

        xo = x + w - mx;
        yo = y + h - my;

        while ( Code != SELECTDOWN ) {
            while ( ReadIMsg( MainWindow )) {
                if ( Code == SELECTDOWN ) break;
                if ( Class == IDCMP_MENUPICK ) {
                    SetTitle( 0l );
                    DisplayGInfo( eng->en_Kind , x + 1, y + 1, x + w - 1, y + h - 1 );
                }
            }
            GetMouseXY( &mx, &my );
            if ( mx != ( x + w - xo ) || my != ( y + h - yo )) {
                Box( x, y, x + w, y + h );
                if (( mx - x + xo ) >= minx ) w = mx - x + xo;
                if (( my - y + yo ) >= miny ) h = my - y + yo;
                Box( x, y, x + w, y + h );
                DisplayGInfo( eng->en_Kind , x + 1, y + 1, x + w - 1, y + h - 1 );
            }
        }

        Box( x, y, x + w, y + h );
        eng->en_NewGadget.ng_Width   = w - 1;
        eng->en_NewGadget.ng_Height  = h - 1;
        noWay:
        RemakeAllGadgets();

        if ( mm ) MouseMove( MainWindow, TRUE );
    }
    SetWindowTitles( MainWindow, (char *)-1l, MainScreenTitle );
    ClearMsgPort( MainWindow->UserPort );
    RefreshWindow();
    Saved = FALSE;
}

/*
 * --- Clone a gadget.
 */
void CopyGadget( void )
{
    struct ExtNewGadget *eng, *eng1 = 0l;
    struct TagItem      *tags = 0l;
    struct Gadget       *g;
    WORD                 x, y, w, h, xo, yo, mx, my;
    BOOL                 mm;

    if ( NOT Gadgets.gl_First->en_Next ) return;

    SetTitle( "CLICK ON GADGET TO COPY..." );

    if ( g = WaitForGadget( MainWindow )) {

        RemoveAllGadgets();

        eng = FindExtGad( g );

        if ( eng1 = Malloc((long)sizeof( struct ExtNewGadget ))) {
            if ( tags = MakeTagList( eng->en_NumTags )) {

                CopyMem(( void * )eng, ( void * )eng1, (long)sizeof( struct ExtNewGadget ));
                CopyMem(( void * )eng->en_Tags, ( void * )tags, (long)( eng->en_NumTags * sizeof( struct TagItem )));

                eng1->en_Tags = tags;

                switch ( eng->en_Kind ) {

                    case    STRING_KIND:
                        if ( eng->en_DefString ) {
                            if ( eng1->en_DefString = Malloc( (long)strlen( eng->en_DefString ) + 1)) {
                                strcpy( eng1->en_DefString, eng->en_DefString );
                                SetTagData( tags, GTST_String, (Tag)eng1->en_DefString );
                            } else
                                goto noMem;
                        }
                        break;

                    case    LISTVIEW_KIND:
                        if ( NOT CopyList( eng, eng1 )) goto noMem;
                        break;

                    case    CYCLE_KIND:
                        if ( NOT CopyLabels( eng, eng1, FALSE )) goto noMem;
                        break;

                    case    MX_KIND:
                        if ( NOT CopyLabels( eng, eng1, TRUE )) goto noMem;
                        break;

                    case    SLIDER_KIND:
                        if ( eng->en_LevelFormat ) {
                            if ( eng1->en_LevelFormat = Malloc( (long)strlen( eng->en_LevelFormat ) + 1)) {
                                strcpy( eng1->en_LevelFormat, eng->en_LevelFormat );
                                SetTagData( tags, GTSL_LevelFormat, (Tag)eng1->en_LevelFormat );
                            } else
                                goto noMem;
                        }
                        break;
                }

                x = eng1->en_NewGadget.ng_LeftEdge - 1;
                y = eng1->en_NewGadget.ng_TopEdge  - 1;
                w = eng1->en_NewGadget.ng_Width    + 1;
                h = eng1->en_NewGadget.ng_Height   + 1;

                Box( x, y, x + w, y + h );

                SetTitle( 0l );
                DisplayGInfo( eng->en_Kind, x + 1, y + 1, x + w - 1, y + h - 1 );

                GetMouseXY( &mx, &my );

                xo = mx - x;
                yo = my - y;

                mm = MouseMove( MainWindow, FALSE );

                while ( Code != SELECTDOWN ) {
                    while ( ReadIMsg( MainWindow )) {
                        if ( Code == SELECTDOWN ) break;
                        if ( Class == IDCMP_MENUPICK ) {
                            SetTitle( 0l );
                            DisplayGInfo( eng->en_Kind, x + 1, y + 1, x + w - 1, y + h - 1 );
                        }
                    }
                    GetMouseXY( &mx, &my );
                    if ( mx != ( x + xo ) || my != ( y + yo )) {
                        Box( x, y, x + w, y + h );
                        x = mx - xo;
                        y = my - yo;
                        Box( x, y, x + w, y + h );
                        DisplayGInfo( eng->en_Kind, x + 1, y + 1, x + w - 1, y + h - 1 );
                    }
                }

                if ( mm ) MouseMove( MainWindow, TRUE );

                Box( x, y, x + w, y + h );
                eng1->en_NewGadget.ng_LeftEdge = x + 1;
                eng1->en_NewGadget.ng_TopEdge  = y + 1;
                eng1->en_SpecialFlags         &= ~EGF_USERLABEL;
                AddTail(( struct List * )&Gadgets, ( struct Node * )eng1 );
                Renumber();
                RemakeAllGadgets();
                goto doneIt;
            }
        }
    } else goto doneIt;
    noMem:
    MyRequest( "Oh oh...", "CONTINUE", "Out of memory !" );
    if ( eng )
        FreeExtGad( eng );
    doneIt:
    SetWindowTitles( MainWindow, (char *)-1l, MainScreenTitle );
    ClearMsgPort( MainWindow->UserPort );
    RefreshWindow();
    Saved = FALSE;
}

/*
 * --- Remove and deallocate a gadget.
 */
void DeleteGadget( void )
{
    struct Gadget       *g;
    struct ExtNewGadget *eng;

    if ( NOT Gadgets.gl_First->en_Next ) return;

    SetTitle( "CLICK ON GADGET TO DELETE..." );

    if ( g = WaitForGadget( MainWindow )) {

        RemoveAllGadgets();

        eng = FindExtGad( g );

        Remove(( struct Node * )eng );

        if (( eng->en_SpecialFlags & EGF_NEEDLOCK ) == EGF_NEEDLOCK )
            eng->en_Prev->en_SpecialFlags &= ~EGF_ISLOCKED;
        else if (( eng->en_SpecialFlags & EGF_ISLOCKED ) == EGF_ISLOCKED ) {
            eng->en_Next->en_SpecialFlags &= ~EGF_NEEDLOCK;
            SetTagData( eng->en_Next->en_Tags, GTLV_ShowSelected, 0l );
        }

        FreeExtGad( eng );

        RemakeAllGadgets();
    }
    SetWindowTitles( MainWindow, (char *)-1l, MainScreenTitle );
    ClearMsgPort( MainWindow->UserPort );
    RefreshWindow();
    Saved = FALSE;
}

/*
 * --- Edit a gadget
 */
void EditGadget( void )
{
    struct Gadget       *g;
    struct ExtNewGadget *eng;

    if ( NOT Gadgets.gl_First->en_Next ) return;

    SetTitle( "CLICK ON GADGET TO EDIT..." );

    if ( g = WaitForGadget( MainWindow )) {
        eng = FindExtGad( g );

        switch( eng->en_Kind ) {
            case    BUTTON_KIND:
                EditButton( 0, 0, 0, 0, g );
                break;

            case    CHECKBOX_KIND:
                EditCheckBox( 0, 0, 0, 0, g );
                break;

            case    STRING_KIND:
            case    INTEGER_KIND:
                EditStrInt( 0, 0, 0, 0, g );
                break;

            case    LISTVIEW_KIND:
                EditListView( 0, 0, 0, 0, g);
                break;

            case    MX_KIND:
                EditMX( 0, 0, 0, 0, g );
                break;

            case    CYCLE_KIND:
                EditCycle( 0, 0, 0, 0, g );
                break;

            case    PALETTE_KIND:
                EditPalette( 0, 0, 0, 0, g );
                break;

            case    SCROLLER_KIND:
                EditScroller( 0, 0, 0, 0, g );
                break;

            case    SLIDER_KIND:
                EditSlider( 0, 0, 0, 0, g );
        }
    }
    SetWindowTitles( MainWindow, (char *)-1l, MainScreenTitle );
    RefreshWindow();
}

/*
 * --- Display the mouse size/place info.
 */
void DisplayGInfo( long kind, WORD x, WORD y, WORD x1, WORD y1 )
{
    WORD    tmp;

    switch( kind ) {
        case    CHECKBOX_KIND:
            UpdateCoords( 1, x1 - 25, y1 - 10, 25, 10 );
            break;

        case    MX_KIND:
            UpdateCoords( 1, x1 - 16, y1 - 8, 16, 8 );
            break;

        default:
            if ( x1 < x ) { tmp = x1; x1 = x; x = tmp; }
            if ( y1 < y ) { tmp = y1; y1 = y; y = tmp; }
            UpdateCoords( 1, x, y, x1 - x, y1 - y );
            break;
    }
}

/*
 * --- Joins a String and a ListView Gadget.
 */
void Join( void )
{
    struct ExtNewGadget *lv,  *st;
    struct Gadget       *lvg, *stg;
    struct TagItem      *tags;


    if ( NOT Gadgets.gl_First->en_Next ) return;

    SetTitle( "CLICK ON LISTVIEW TO JOIN..." );

    if ( lvg = WaitForGadget( MainWindow )) {

        lv = FindExtGad( lvg );

        if ( lv->en_Kind != LISTVIEW_KIND ) {
            MyRequest( "Yo..",  "OK", "This isn't a ListView Gadget !" );
            goto done;
        }

        if (( lv->en_SpecialFlags & EGF_NEEDLOCK ) == EGF_NEEDLOCK ) {
            MyRequest( "Yo..", "OK", "This ListView already is joined !" );
            goto done;
        }

        if (( lv->en_SpecialFlags & EGF_READONLY ) == EGF_READONLY ) {
            MyRequest( "Yo..", "OK", "Can't join a Read Only ListView !" );
            goto done;
        }

        SetTitle( "CLICK ON STRING TO JOIN..." );

        if ( stg = WaitForGadget( MainWindow )) {

            st = FindExtGad( stg );

            if ( st->en_Kind != STRING_KIND ) {
                MyRequest( "Yo..",  "OK", "This isn't a String Gadget !" );
                goto done;
            }

            if (( st->en_SpecialFlags & EGF_ISLOCKED ) == EGF_ISLOCKED ) {
                MyRequest( "Yo..", "OK", "This String already is joined !" );
                goto done;
            }

            RemoveAllGadgets();

            Remove(( struct Node * )lv );

            Insert(( struct List * )&Gadgets, ( struct Node * )lv, ( struct Node * )st );

            lv->en_SpecialFlags |= EGF_NEEDLOCK;
            st->en_SpecialFlags |= EGF_ISLOCKED;

            tags = lv->en_Tags;

            while ( 1 ) {
                if ( tags->ti_Tag == GTLV_ShowSelected )
                    break;
                if ( tags->ti_Tag == TAG_DONE ) {
                    tags->ti_Tag  = GTLV_ShowSelected;
                    tags->ti_Data = 0l;
                    tags++;
                    tags->ti_Tag  = TAG_DONE;
                    break;
                }
                tags++;
            }
            Saved = FALSE;
            RemakeAllGadgets();
        }
    }
    done:
    SetWindowTitles( MainWindow, MainWindowTitle, MainScreenTitle );
    ClearMsgPort( MainWindow->UserPort );
    RefreshWindow();
}

/*
 * --- Splits a String and a ListView Gadget.
 */
void Split( void )
{
    struct ExtNewGadget *lv, *glv, *gst;
    struct Gadget       *lvg;

    if ( NOT Gadgets.gl_First->en_Next ) return;

    SetTitle( "CLICK ON GADGET TO SPLIT..." );

    if ( lvg = WaitForGadget( MainWindow )) {

        lv = FindExtGad( lvg );

        if ( lv->en_Kind == LISTVIEW_KIND ) {
            if (( lv->en_SpecialFlags & EGF_NEEDLOCK ) != EGF_NEEDLOCK ) {
                MyRequest( "Yo..", "OK", "This ListView is not joined !" );
                goto done;
            } else {
               gst = lv->en_Prev;
               glv = lv;
            }
        } else if ( lv->en_Kind == STRING_KIND ) {
            if (( lv->en_SpecialFlags & EGF_ISLOCKED ) != EGF_ISLOCKED ) {
                MyRequest( "Yo..", "OK", "This String is not joined !" );
                goto done;
            } else {
                gst = lv;
                glv = gst->en_Next;
            }
        } else {
            MyRequest( "Yo..", "OK", "This gadget is NOT joined !" );
            goto done;
        }

        RemoveAllGadgets();

        gst->en_SpecialFlags &= ~EGF_ISLOCKED;
        glv->en_SpecialFlags &= ~EGF_NEEDLOCK;

        SetTagData( glv->en_Tags, GTLV_ShowSelected, 0l );

        Saved = FALSE;
        RemakeAllGadgets();
    }
    done:
    SetWindowTitles( MainWindow, MainWindowTitle, MainScreenTitle );
    ClearMsgPort( MainWindow->UserPort );
    RefreshWindow();
}

/*
 * --- Parses the filename for the ASL FileRequester.
 */
long ParseName( void )
{
    char    *ptr;
    long     len;

    if ( strlen( MainFileName )) {
        if (( ptr = strrchr( MainFileName, (int)'/' )) || ( ptr = strrchr( MainFileName, (int)':' ))) {
            ptr++;
            strcpy( bi_SFile, ptr );
            strcpy( bi_LFile, ptr );
            len = (long)( ptr - MainFileName);
            strncpy( bi_SPath, MainFileName, len );
            strncpy( bi_LPath, MainFileName, len );

            bi_SPath[ len ] = bi_LPath[ len ] = 0;

            len = strlen( bi_SFile );

            CheckSuffix();

            if ( NOT strlen( bi_SFile )) {
                strcpy( bi_SFile, "unnamed.g" );
                strcpy( bi_LFile, "unnamed.g" );
            }
        } else {
            strcpy( bi_SFile, MainFileName );
            strcpy( bi_LFile, MainFileName );
            CheckSuffix();
            len = strlen( bi_SFile );
        }
    }
    return((long)len );
}

/*
 * --- Main routine. Waits for user input.
 */
void gtb( void ) {
    struct Process          *proc = ( struct Process * )FindTask( 0l );
    UWORD                    l, t, x, y, x1, y1;
    BOOL                     running = TRUE, mm;

    if (( MainPrefs.pr_PrefFlags0 & PRF_COORDS ) == PRF_COORDS )
        MouseMove( MainWindow, TRUE );

    do {
        WaitPort( MainWindow->UserPort );

        while ( ReadIMsg( MainWindow )) {

            switch ( Class ) {

                case    IDCMP_REFRESHWINDOW:
                    GT_BeginRefresh( MainWindow );
                    GT_EndRefresh( MainWindow, TRUE );
                    break;

                case    IDCMP_CLOSEWINDOW:
                    Quit();
                    break;

                case    IDCMP_CHANGEWINDOW:
                    RefreshWindow();
                    ws_IWidth  = MainWindow->Width - MainWindow->BorderLeft - MainWindow->BorderRight;
                    ws_IHeight = MainWindow->Height - MainWindow->BorderTop - MainWindow->BorderBottom;
                    break;

                case    IDCMP_MENUPICK:
                    if (( MainPrefs.pr_PrefFlags0 & PRF_COORDS ) == PRF_COORDS )
                        MouseMove( MainWindow, TRUE );
                    HandleMenus();
                    break;

                case    IDCMP_MOUSEMOVE:
                    if (( MainPrefs.pr_PrefFlags0 & PRF_COORDS ) == PRF_COORDS )
                        UpdateCoords( 0l, 0, 0, 0, 0 );
                    break;

                case    IDCMP_MOUSEBUTTONS:
                    if ( Code == SELECTDOWN ) {
                        GetMouseXY( &x, &y );
                        l = x;
                        t = y;
                        SetTitle( 0l );
                        if ( ActiveKind == CHECKBOX_KIND )
                            Box( x - 25, y - 10, x, y );
                        else if ( ActiveKind == MX_KIND )
                            Box( x - 16, y - 8, x, y );
                        else
                            Box( l, t, x, y );

                        DisplayGInfo( ActiveKind, l, t, x, y );

                        Code = SELECTUP;

                        mm = MouseMove( MainWindow, FALSE );

                        while ( Code != SELECTDOWN ) {
                            while ( ReadIMsg( MainWindow )) {
                                if ( Code  == SELECTDOWN ) break;
                                if ( Class == IDCMP_MENUPICK ) {
                                    SetTitle( 0l );
                                    DisplayGInfo( ActiveKind, l, t, x, y );
                                }
                            }
                            GetMouseXY( &x1, &y1 );

                            if ( x1 != x || y1 != y ) {
                                if ( ActiveKind == CHECKBOX_KIND )
                                    Box( x - 25 , y - 10, x, y );
                                else if ( ActiveKind == MX_KIND )
                                    Box( x - 16, y - 8, x, y );
                                else
                                    Box( l, t, x, y );
                                GetMouseXY( &x, &y );
                                if ( ActiveKind == CHECKBOX_KIND )
                                    Box( x - 25, y - 10, x, y );
                                else if ( ActiveKind == MX_KIND )
                                    Box( x - 16, y - 8, x, y );
                                else
                                    Box( l, t, x, y );
                                DisplayGInfo( ActiveKind, l, t, x, y );
                            }
                        }

                        SetWindowTitles( MainWindow, MainWindowTitle, MainScreenTitle  );

                        if ( mm ) MouseMove( MainWindow, TRUE );

                        switch ( ActiveKind ) {

                            case    BUTTON_KIND:
                                EditButton( l, t, x, y, 0l );
                                break;

                            case    CHECKBOX_KIND:
                                EditCheckBox( x - 25, y - 10, x, y, 0l );
                                break;

                            case    STRING_KIND:
                            case    INTEGER_KIND:
                                EditStrInt( l, t, x, y, 0l );
                                break;

                            case    LISTVIEW_KIND:
                                EditListView( l, t, x, y, 0l );
                                break;

                            case    MX_KIND:
                                EditMX( x - 16, y - 8, x, y, 0l );
                                break;

                            case    CYCLE_KIND:
                                EditCycle( l, t, x, y, 0l );
                                break;

                            case    PALETTE_KIND:
                                EditPalette( l, t, x, y, 0l );
                                break;

                            case    SCROLLER_KIND:
                                EditScroller( l, t, x, y, 0l );
                                break;

                            case    SLIDER_KIND:
                                EditSlider( l, t, x, y, 0l );
                                break;
                        }
                    }
                    break;
            }
        }
     } while ( running );

    QuitProgram(0L);
}

void	wbmain(struct WBStartup *WBMsg) {
	struct WBArg	*wba;

        wba = WBMsg->sm_ArgList;
        if ( wba->wa_Lock ) {
            CurrentDir( wba->wa_Lock );
            if ( WBMsg->sm_NumArgs > 1 ) {
                wba++;
                if ( wba->wa_Lock )
                    CurrentDir( wba->wa_Lock );
                SetupProgram( TRUE );
                strcpy( MainFileName, wba->wa_Name );
                if ( ParseName())
                    ReadBinary( FALSE );
                else
                    ReOpenScreen( 0l );
            } else
                SetupProgram( FALSE );
        } else
            SetupProgram( FALSE );
	gtb();
}

void	main() {
        if ( FArgs = ReadArgs( Template, &Args[0], &IArgs )) {
		if ( Args[0] ) {
                	SetupProgram( TRUE );
                	strcpy( MainFileName, (char *)Args[0] );
                	if( ParseName())
                		ReadBinary( FALSE );
                	else
                		ReOpenScreen( 0l );
            	} else
                	SetupProgram( FALSE );
	} else
            	QuitProgram( 27l );
	gtb();
}

