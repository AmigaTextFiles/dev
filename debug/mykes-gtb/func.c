/*-- AutoRev header do NOT edit!
*
*   Program         :   func.c
*   Copyright       :   © Copyright 1991 Jaba Development
*   Author          :   Jan van den Baard
*   Creation Date   :   21-Sep-91
*   Current version :   1.00
*   Translator      :   DICE v2.6
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   21-Sep-91     1.00            Several functions.
*
*-- REV_END --*/

#include	"defs.h"

/*
 * Refrenced external global data.
 */
extern ULONG                 Class;
extern UWORD                 Qualifier, Code;
extern APTR                  theObject, MainVisualInfo;
extern struct TextAttr       MainFont;
extern struct Screen        *MainScreen;
extern struct Window        *MainWindow;
extern struct RastPort      *MainRP;
extern struct ExtGadgetList  Gadgets;
extern struct Gadget        *MainGList;
extern struct TagItem        MainSTags[];
extern struct Screen        *MainScreen;
extern BOOL                  WBenchClose;
extern UBYTE                 MainWBStatus[20], MainFileName[512];
extern struct ExtGadgetList  Gadgets;
extern UWORD                 CountFrom;
extern UBYTE                *MainExtension;
extern struct StringExtend   Sextend;
extern BOOL                  GadgetsOn;
extern struct Gadget        *MainGList;
extern struct TagItem        nwTags[];
extern struct NewMenu        Menus[];
extern struct Menu          *MainMenus;
extern struct TextAttr       Topaz80;
extern BOOL                  BreakDRAG;
extern struct Prefs          MainPrefs;
extern struct IntuiText     *WindowTxt;
extern BOOL                  Saved;
extern UWORD                 AlertCol;
extern UBYTE                 bi_SFile[], bi_LFile[];

/*
 * --- Reads a message from the window message port.
 * --- Returns TRUE if a message was read and puts the
 * --- message data in the globals. Return FALSE if there
 * --- was no message at the port.
 */
long ReadIMsg( struct Window *iwnd )
{
    struct IntuiMessage *imsg;

    if ( imsg = GT_GetIMsg( iwnd->UserPort )) {

        Class       =   imsg->Class;
        Qualifier   =   imsg->Qualifier;
        Code        =   imsg->Code;
        theObject   =   imsg->IAddress;

        if ( Class == IDCMP_MENUVERIFY )
            MouseMove( MainWindow, FALSE );

        GT_ReplyIMsg( imsg );

        return TRUE;
    }
    return FALSE;
}

/*
 * --- Clears all message from a message port.
 */
void ClearMsgPort( struct MsgPort *mport )
{
    struct IntuiMessage  *msg;

    while ( msg = GT_GetIMsg( mport )) GT_ReplyIMsg( msg );
}

/*
 * --- Create a node with a special userdata field used
 * --- for the listview gadgets of the program. The allocated
 * --- node also makes 100 bytes room for the node name.
 */
struct ListViewNode *MakeNode( UBYTE *name )
{
    struct ListViewNode     *node;

    if ( node = ( struct ListViewNode * )Malloc((long)sizeof( struct ListViewNode ))) {
        node->ln_Name = &node->ln_NameBytes[0];
        strcpy( &node->ln_NameBytes[0], name );
        return( node );
    }
    return( NULL );
}

/*
 * --- Find node 'entry' in list 'list' and
 * --- return a pointer to it.
 */
struct ListViewNode *FindNode( struct List *list , long entry )
{
    struct ListViewNode     *node;
    long                     num;

    for ( node = ( struct ListViewNode * )list->lh_Head, num = 0; num != entry; num++, node = node->ln_Succ );

    return( node );
}

/*
 * --- Free a complete list of nodes allocated with MakeNode();
 */
void FreeList( struct List *list )
{
    struct ListViewNode     *node;

    while ( node = ( struct ListViewNode * )RemHead( list ))
        free(node);
}

/*
 * --- Read the current mouse coordinates. This
 * --- routines also gives correct coordinates
 * --- on GIMMEZEROZERO windows.
 */
void GetMouseXY( UWORD *x, UWORD *y )
{
    ULONG   wflg;

    Forbid();
    wflg = MainWindow->Flags;
    Permit();

    if (( wflg & WFLG_GIMMEZEROZERO ) == WFLG_GIMMEZEROZERO ) {
        *x = MainWindow->GZZMouseX;
        *y = MainWindow->GZZMouseY;
    } else {
        *x = MainWindow->MouseX;
        *y = MainWindow->MouseY;
    }
}

/*
 * --- Draw a complemented box in the window.
 */
void Box( UWORD x, UWORD y, UWORD x1, UWORD y1 )
{
    UWORD   tmp;

    if ( x > x1 )   { tmp = x; x = x1; x1 = tmp; }
    if ( y > y1 )   { tmp = y; y = y1; y1 = tmp; }

    SetDrMd( MainRP, JAM1 + COMPLEMENT );

    Move( MainRP, x + 1, y );
    Draw( MainRP, x1, y );
    Draw( MainRP, x1, y1 );
    Draw( MainRP, x, y1 );
    Draw( MainRP, x, y );
}

/*
 * --- Allocate a TagItem array.
 */
struct TagItem  *MakeTagList( long numtags )
{
    struct TagItem  *tags;

    if ( tags = ( struct TagItem * )Malloc( (long)( sizeof( struct TagItem ) * ( numtags + 1 )))) {
        tags[ numtags ].ti_Tag = TAG_DONE;
        return( tags );
    }
    return NULL;
}

/*
 * --- Set the Tag data of a Tag in a TagItem array.
 */
long SetTagData( struct TagItem *tags, Tag tag, Tag data )
{
    while ( tags->ti_Tag != tag ) {
        if ( tags->ti_Tag == TAG_DONE )
            return FALSE;
        tags++;
    }
    tags->ti_Data = data;
    return TRUE;
}

/*
 * --- Find the Tag in a TagItem array.
 * --- The original TagInArray scans the data too which
 * --- results in a TAG_DONE when the data is 0. I don't want this.
 */
long MyTagInArray( Tag tag, struct TagItem *tags )
{
    while ( tags->ti_Tag != tag ) {
        if ( tags->ti_Tag == TAG_DONE )
            return FALSE;
        tags++;
    }
    return TRUE;
}

/*
 * --- Deallocate a TagItem array.
 */
void FreeTagList( struct TagItem *tags, long numtags )
{
    free( tags );
}

/*
 * --- Wait for the user to either click on a gadget or press ESC.
 */
struct Gadget *WaitForGadget( struct Window *wnd )
{
    struct Gadget   *g;
    BOOL             mm = FALSE;

    mm = MouseMove( wnd, FALSE );

    while ( 1 ) {
        WaitPort( wnd->UserPort );
        while( ReadIMsg( wnd )) {
            if ( Class == IDCMP_RAWKEY && Code == 0x45 ) {
                ClearMsgPort( wnd->UserPort );
                return NULL;
            } else if ( Class == IDCMP_GADGETUP || Class == IDCMP_GADGETDOWN ) {
                g = ( struct Gadget * )theObject;
                goto check;
            }
        }
    }

    check:

    if ( Class == IDCMP_GADGETDOWN ) {
        while( Code != SELECTUP ) {
            while ( ReadIMsg( wnd ));
        }
    }

    ClearMsgPort( wnd->UserPort );

    if ( mm ) MouseMove( wnd, TRUE );

    return( g );
}

/*
 * --- (Re)Open the screen. This routine opens the
 * --- used font found in the TextAttr structure MainFont
 * --- because GadTools seems to need to be able to open the font
 * --- using OpenFont() to make some gadgets (Integer & String).
 * --- To let gadtools be able to OpenFont() the font it has
 * --- to be in memory first. So by opening the font before the
 * --- screen is opened the font is in memory and openable with
 * --- OpenFont(). The routine closes the font as soon as all
 * --- gadgets are created. It took me quite a while to figure this
 * --- out because I could write and read a binary OK. But when I
 * --- try'ed to load the same binary the next day GadTools would refuse
 * --- to create the gadgets in the file! And then it struck me......
 * --- The screen did not use the font specified in the file!!!!!
 */
long ReOpenScreen( long wnd )
{
    struct TextFont     *tf = 0l;
    long                 mm = FALSE;

    if ( MainWindow ) {
        mm = MouseMove( MainWindow, FALSE );
        if ( MainMenus ) {
            ClearMenuStrip( MainWindow );
            FreeMenus( MainMenus );
            BreakDRAG = TRUE;
            MainMenus = 0l;
        }
        RemoveAllGadgets();

        if ( NOT wnd ) {
            nwTags[0].ti_Data   =   (Tag)MainWindow->LeftEdge;
            nwTags[1].ti_Data   =   (Tag)MainWindow->TopEdge;
            nwTags[2].ti_Data   =   (Tag)MainWindow->Width;
            nwTags[3].ti_Data   =   (Tag)MainWindow->Height;
        } else if ( wnd == TRUE ) {
            nwTags[0].ti_Data   =   10l;
            nwTags[1].ti_Data   =   15l;
            nwTags[2].ti_Data   =   200l;
            nwTags[3].ti_Data   =   50l;
        }

        CloseWindow( MainWindow );
        MainWindow = 0l;
    }

    if ( ModeNotAvailable( MainSTags[5].ti_Data )) {
        MyRequest( "Hello, hello..", "OK", "File uses monitor that isn't available.\n    I will use the default monitor!" );
        MainSTags[5].ti_Data = DEFAULT_MONITOR_ID | HIRES_KEY;
    }

    if ( NOT( tf = OpenDiskFont( &MainFont )))
        CopyMem(( char *)&Topaz80, (char *)&MainFont, (long)sizeof( struct TextAttr ));

    if ( MainScreen ) {
        FreeScreenInfo( MainScreen );
        CloseScreen( MainScreen );
        MainScreen = 0l;
    }

    if ( NOT( MainScreen = OpenScreenTagList( 0l, MainSTags )))
        return FALSE;

    if( NOT GetScreenInfo( MainScreen ))
        return FALSE;

    nwTags[7 ].ti_Data =    (Tag)MainScreen;
    nwTags[10].ti_Data =    (Tag)MainScreen->Width;
    nwTags[11].ti_Data =    (Tag)MainScreen->Height;

    if ( NOT( MainWindow = OpenWindowTagList( 0l, nwTags )))
        return FALSE;

    SetMouseQueue( MainWindow, 1l );

    if ( mm )   MouseMove( MainWindow, TRUE );

    if ( NOT( MainMenus = CreateMenus( Menus, GTMN_FrontPen, 0l, TAG_DONE )))
        return FALSE;

    MainRP = MainWindow->RPort;
    LayoutMenus( MainMenus, MainVisualInfo, GTMN_TextAttr, &Topaz80, TAG_DONE );
    SetMenuStrip( MainWindow, MainMenus );

    if ( tf )
        CloseFont( tf );

    return( RemakeAllGadgets());
}

/*
 * --- Open/Close workbench screen.
 */
void DoWBench( void )
{
    if ( NOT WBenchClose ) {
        if ( CloseWorkBench()) {
            WBenchClose = TRUE;
            Forbid();
            strcpy( MainWBStatus, "Open Workbench" );
            Permit();
            return;
        } else
            MyRequest( "GadToolsBox message:", "CONTINUE", "Can't close the Workbench !" );
    } else {
        if( OpenWorkBench()) {
            WBenchClose = FALSE;
            Forbid();
            strcpy( MainWBStatus, "Close Workbench" );
            Permit();
            ScreenToFront( MainScreen );
            return;
        } else
            MyRequest( "GadToolsBox message:", "CONTINUE", "Can't open the Workbench !" );
    }
}

/*
 * --- This routine looks through the list to find
 * --- the ExtNewGadget structure of the gadget.
 */
struct ExtNewGadget *FindExtGad( struct Gadget *gadget )
{
    struct ExtNewGadget *eng;

    eng = Gadgets.gl_First;

    while ( eng ) {
        if ( eng->en_Gadget == gadget ) break;
        eng = eng->en_Next;
    }

    return( eng );
}

/*
 * --- Renumber all gadget ID's and update the
 * --- non user labels.
 */
void Renumber( void )
{
    struct ExtNewGadget *eng;
    UWORD                id = CountFrom;

    for ( eng = Gadgets.gl_First; eng->en_Next; eng = eng->en_Next ) {
        if (( eng->en_SpecialFlags & EGF_USERLABEL ) != EGF_USERLABEL )
            sprintf( &eng->en_SourceLabel[0], "Gadget%ld", id - CountFrom );
        eng->en_NewGadget.ng_GadgetID = id++;
    }
}

/*
 * --- Append ".G" to the filename if it isn't there.
 */
void CheckSuffix( void )
{
    UBYTE   buf[10];
    UWORD   len;

    if ( strlen( bi_SFile )) {
        len = strlen( MainFileName ) - 2;

        strcpy( buf, &MainFileName[ len ] );

        if ( NOT stricmp( buf, MainExtension ))
            return;

        strcat( MainFileName, MainExtension );
        strcat( bi_SFile, MainExtension );
        strcat( bi_LFile, MainExtension );
    }
}

/*
 * --- Attach a StringExtend structure to a string gadget.
 */
void SetStringGadget( struct Gadget *g )
{
    struct StringInfo   *si;

    si = ( struct StringInfo * )g->SpecialInfo;

    g->Activation |= GACT_STRINGEXTEND;
    si->Extension  = &Sextend;
}

/*
 * --- Remove all gadgets from the window to
 * --- let the program change the contents and list.
 */
void RemoveAllGadgets( void )
{
    if ( MainGList ) {
        if ( GadgetsOn ) {
            RemoveGList( MainWindow, MainGList, -1l );
            GadgetsOn = FALSE;
        }
        FreeGadgets( MainGList );
        MainGList = 0l;
    }
}

/*
 * --- Re-create all gadgets in the list.
 */
long RemakeAllGadgets( void )
{
    struct ExtNewGadget *eng;
    struct Gadget       *g;

    ClearWindow();

    if ( g = CreateContext( &MainGList )) {
        for ( eng = Gadgets.gl_First; eng->en_Next; eng = eng->en_Next ) {
            eng->en_NewGadget.ng_TextAttr   = &MainFont;
            eng->en_NewGadget.ng_VisualInfo = MainVisualInfo;

            SizeAGadget( eng );

            if (( eng->en_SpecialFlags & EGF_NEEDLOCK ) == EGF_NEEDLOCK )
                SetTagData( eng->en_Tags, GTLV_ShowSelected, (Tag)eng->en_Prev->en_Gadget );

            g = CreateGadgetA( eng->en_Kind, g, &eng->en_NewGadget, eng->en_Tags );

            eng->en_Gadget = g;
        }

        if ( g ) {
            AddGList( MainWindow, MainGList, -1l, -1l, 0l );
            RefreshWindow();
            GadgetsOn = TRUE;
            return TRUE;
        }
    }

    MyRequest( "Oh oh...", "CONTINUE", "BIG TROUBLE!\nCould not create the gadgets !" );

    return FALSE;
}

/*
 * --- Deallocate a ExtNewGadget structure plus
 * --- any additional memory a specific kind
 * --- of gadget takes up.
 */
void FreeExtGad( struct ExtNewGadget *eng )
{
    UWORD       cnt;

    if ( eng->en_Tags )
        FreeTagList( eng->en_Tags, eng->en_NumTags );

    switch( eng->en_Kind ) {

        case    STRING_KIND:
            if ( eng->en_DefString )
                free(eng->en_DefString );
            break;

        case    LISTVIEW_KIND:
            FreeList( &eng->en_Entries );
            break;

        case    MX_KIND:
        case    CYCLE_KIND:
            for ( cnt = 0; cnt < 23; cnt++ ) {
                if ( eng->en_Labels[ cnt ] )
                    free( eng->en_Labels[ cnt ] );
            }
            break;

        case    SLIDER_KIND:
            if ( eng->en_LevelFormat )
                free( eng->en_LevelFormat );
            break;
    }

    free( eng );
}

/*
 * --- Switch on/off the WFLG_REPORTMOUSE flags.
 * --- (Not using ReportMouse())
 */
long MouseMove( struct Window *wnd, long on )
{
    if ( NOT on ) {
        Forbid();
        if (( wnd->Flags & WFLG_REPORTMOUSE ) == WFLG_REPORTMOUSE ) {
            wnd->Flags &= ~WFLG_REPORTMOUSE;
            Permit();
            return TRUE;
        }
        Permit();
        return FALSE;
    } else {
        Forbid();
        wnd->Flags |= WFLG_REPORTMOUSE;
        Permit();
        if (( MainPrefs.pr_PrefFlags0 & PRF_COORDS ) == PRF_COORDS )
            UpdateCoords( 0l, 0, 0, 0, 0 );
        return TRUE;
    }
}

/*
 * --- FlipFlop a boolean and checkbox gadget ( if specified )
 */
void FlipFlop( struct Window *wnd, struct Gadget **list, long index, BOOL *val )
{
    if ( *val ) *val = FALSE;
    else        *val = TRUE;

    if ( list )
        GT_SetGadgetAttrs( list[ index ], wnd, 0l, GTCB_Checked, (Tag)*val, TAG_DONE );
}

/*
 * --- EnableGadget a gadget ( if specified )
 */
void EnableGadget( struct Window *wnd, struct Gadget **list, long index, BOOL val )
{
        BOOL    off;

        if ( val )  off = FALSE;
        else        off = TRUE;

        GT_SetGadgetAttrs( list[ index ], wnd, 0l, GA_Disabled, (Tag)off, TAG_DONE );
}

/*
 * --- Convert ListViewNodes to gadget labels.
 */
long ListToLabels( struct List *list, struct ExtNewGadget *eng )
{
    struct ListViewNode *node;
    UWORD                cnt, num = 0;

    setmem(( void * )&eng->en_Labels[0], 100l, 0l );

    for ( node = list->lh_Head, cnt = 0; node->ln_Succ; node = node->ln_Succ, cnt++ ) {
        if (  eng->en_Labels[ cnt ] = Malloc( strlen( &node->ln_NameBytes[0] ) + 1 )) {
            strcpy( eng->en_Labels[ cnt ], &node->ln_NameBytes[0] );
            num++;
        } else {
            FreeList( list );
            return FALSE;
        }
    }
    FreeList( list );
    return((long) num );
}

/*
 * --- Convert gadget labels to ListViewNodes.
 */
long LabelsToList( struct List *list, struct ExtNewGadget *eng )
{
    struct ListViewNode *node;
    UWORD                cnt, num = 0;

    NewList( list );

    for ( cnt = 0; cnt < 24;  cnt ++ ) {
        if ( eng->en_Labels[ cnt ] ) {
            if ( node = MakeNode( eng->en_Labels[  cnt ] )) {
                AddTail( list, ( struct Node * )node );
                free( eng->en_Labels[ cnt ] );
                eng->en_Labels[ cnt ] = 0l;
                num++;
            } else {
                FreeList( list );
                return FALSE;
            }
        }
    }
    return((long)num);
}

/*
 * --- Size the gadget to it's minimum width when to small.
 */
void SizeAGadget( struct ExtNewGadget *eng )
{
    struct NewGadget    *ng = &eng->en_NewGadget;

    switch( eng->en_Kind ) {

        case    BUTTON_KIND:
        case    CYCLE_KIND:
                if ( ng->ng_Width  < ( MainScreen->RastPort.TxWidth + 8 ))
                    ng->ng_Width  = MainScreen->RastPort.TxWidth + 8;
                if ( ng->ng_Height < ( MainScreen->RastPort.TxHeight + 3 ))
                    ng->ng_Height = MainScreen->RastPort.TxHeight + 3;
                break;

        case    INTEGER_KIND:
        case    STRING_KIND:
                if ( ng->ng_Width < ( MainScreen->RastPort.TxWidth + 13 ))
                    ng->ng_Width = MainScreen->RastPort.TxWidth + 13;
                if ( ng->ng_Height < ( MainScreen->RastPort.TxHeight + 4 ))
                    ng->ng_Height = MainScreen->RastPort.TxHeight + 4;

                if ( eng->en_Kind == STRING_KIND ) {
                    if (( eng->en_SpecialFlags & EGF_ISLOCKED ) == EGF_ISLOCKED )
                        eng->en_NewGadget.ng_Width = eng->en_Next->en_NewGadget.ng_Width;
                }

                break;

        case    LISTVIEW_KIND:
                if ( eng->en_ScrollWidth ) {
                    if ( ng->ng_Width < ( eng->en_ScrollWidth + 14 ))
                        ng->ng_Width = eng->en_ScrollWidth + 14;
                } else {
                    if ( ng->ng_Width < 30 )
                        ng->ng_Width = 30;
                }
                if ( ng->ng_Height < (( MainScreen->RastPort.TxHeight << 1 ) + 9 ))
                    ng->ng_Height = ( MainScreen->RastPort.TxHeight << 1 ) + 9;
                break;

        case    PALETTE_KIND:
                if ( MyTagInArray( GTPA_IndicatorWidth, eng->en_Tags )) {
                    if ( ng->ng_Width < ( eng->en_IndicatorSize + 20 ))
                        ng->ng_Width = eng->en_IndicatorSize + 20;
                    if ( ng->ng_Height < 20 )
                        ng->ng_Height = 20;
                } else {
                    if ( ng->ng_Width < 20 )
                        ng->ng_Width = 20;
                    if ( ng->ng_Height < (( eng->en_IndicatorSize >> 1 ) + 20 ))
                        ng->ng_Height = ( eng->en_IndicatorSize >> 1 ) + 20;
                }
                break;

        case    SCROLLER_KIND:
                if ( NOT MyTagInArray( PGA_Freedom, eng->en_Tags )) {
                    if ( ng->ng_Width < (( eng->en_ArrowSize << 1 ) + 10 ))
                        ng->ng_Width = ( eng->en_ArrowSize << 1 ) + 10;
                    if ( ng->ng_Height < 8)
                        ng->ng_Height = 8;
                } else {
                    if ( ng->ng_Width < 10 )
                        ng->ng_Width = 10;
                    if ( ng->ng_Height < ((eng->en_ArrowSize << 1) + 10 ))
                        ng->ng_Height = (eng->en_ArrowSize << 1) + 10;
                }
                break;

        case    SLIDER_KIND:
                if ( ng->ng_Width  < 12 ) ng->ng_Width  = 12;
                if ( ng->ng_Height < 8 ) ng->ng_Height = 8;
                break;
    }
}

/*
 * --- Copy the contents of one list to another.
 */
long CopyList( struct ExtNewGadget *src, struct ExtNewGadget *dst )
{
    struct ListViewNode *node, *tmp;

    NewList( &dst->en_Entries );

    for( tmp = src->en_Entries.lh_Head; tmp->ln_Succ; tmp = tmp->ln_Succ ) {
        if( node = MakeNode( tmp->ln_Name )) {
            node->ln_UserData[0] = tmp->ln_UserData[0];
            AddTail( &dst->en_Entries, ( struct Node * )node);
        } else
            return FALSE;
    }
    SetTagData( dst->en_Tags, GTLV_Labels, (Tag)&dst->en_Entries );
    return TRUE;
}

/*
 * --- Copy the labels of one gadget to another.
 */
long CopyLabels( struct ExtNewGadget *src, struct ExtNewGadget *dst, long t )
{
    UWORD   cnt;

    for ( cnt = 0; cnt < 24; cnt ++ ) {
        if ( src->en_Labels[ cnt ] ) {
            if ( dst->en_Labels[ cnt ] = Malloc((long)strlen( src->en_Labels[ cnt ] ) + 1))
                strcpy( dst->en_Labels[ cnt ], src->en_Labels[ cnt ] );
            else
                return FALSE;
        }
    }

    if ( t )    SetTagData( dst->en_Tags, GTMX_Labels, (Tag)&dst->en_Labels[0] );
    else        SetTagData( dst->en_Tags, GTCY_Labels, (Tag)&dst->en_Labels[0] );

    return TRUE;
}

/*
 * --- Check for a file existance. If it exists put a requester up
 * --- and ask to over write when mode if MODE_NEWFILE.
 */
BPTR MyOpen( long mode )
{
    BPTR    file;
    long    rc = TRUE;

    if ( mode == MODE_NEWFILE ) {
        if ( file = Open( MainFileName, MODE_OLDFILE )) {
            AlertUser( TRUE );
            rc = MyRequest( "Excuse me...", "YEP|NOOOO..", "---> %s <---\n\nFile already exists !\nOverwrite it ?", MainFileName );
            AlertUser( FALSE );
            Close( file );
        }
    }

    if ( rc ) return ( Open( MainFileName, mode ));
    return( NULL );
}

/*
 * --- Delete all gadgets.
 */
void DeleteAllGadgets( void )
{
    struct ExtNewGadget *eng;

    RemoveAllGadgets();

    while ( eng = ( struct ExtNewGadget * )RemHead(( struct List * )&Gadgets ))
        FreeExtGad( eng );

    NewList(( struct List * )&Gadgets );
}

/*
 * --- Check if a '/' or a ':' is appended to the dirname.
 */
void CheckDirExtension( void )
{
    UWORD   len = strlen( MainFileName );

    if ( len ) {
        len--;
        if ( MainFileName[ len ] != '/' && MainFileName[ len ] != ':' )
            strcat( MainFileName, "/" );
    }
}

/*
 * --- Refresh the window.
 */
void RefreshWindow( void )
{
    RefreshWindowFrame( MainWindow );

    if ( MainGList ) {
        RefreshGList( MainGList, MainWindow, 0l, -1l );
        GT_RefreshWindow( MainWindow, 0l );
    }

    if ( WindowTxt )
        PrintIText( MainRP, WindowTxt, 0l, 0l );
}

/*
 * --- (Re)Set the allert color.
 */
void AlertUser( long how )
{
    if ( how ) {
        AlertCol = GetRGB4( MainScreen->ViewPort.ColorMap, 0l );
        SetRGB4( &MainScreen->ViewPort, 0l, 0x0F, 0x08, 0x06 );
    } else
        LoadRGB4( &MainScreen->ViewPort, &AlertCol, 2l );
}

/*
 * --- Quit the program.
 */
void Quit( void )
{
    if ( NOT Saved ) {
        AlertUser( TRUE );
        if ( MyRequest( "!!! RED ALERT !!!", "Go Ahead|Nooooo!!!","Changes not saved !\n   Quit anyway ?" ))
            goto quit;
    } else {
        AlertUser( TRUE );
        if ( MyRequest( "Specify...", "YES|NO", "  Are you sure\nYou want to quit?"))
            goto quit;
    }
    AlertUser( FALSE );
    return;
    quit:
    QuitProgram( 0l );
}

/*
 * --- Perform formatted output to a file.
 */
long MyFPrintf( BPTR fh, UBYTE *format, ... )
{
    va_list     args;
    long        ret;

    va_start( args, format );

    ret = VFPrintf( fh, format, (LONG *)args );

    va_end( args );

    return( ret );
}

/*
 * Count the gadgets in the list.
 */
long CountGadgets( void )
{
    struct ExtNewGadget *eng;
    long                 num;

    for ( eng = Gadgets.gl_First, num = 0l; eng->en_Next; eng = eng->en_Next, num++ );

    return( num );
}
