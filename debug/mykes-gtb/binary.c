/*-- AutoRev header do NOT edit!
*
*   Program         :   Binary.c
*   Copyright       :   © Copyright 1991 Jaba Development
*   Author          :   Jan van den Baard
*   Creation Date   :   12-Oct-91
*   Current version :   1.00
*   Translator      :   DICE v2.6
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   12-Oct-91     1.00            Binary file routines.
*
*-- REV_END --*/

#include	"defs.h"

extern UBYTE                     MainFontName[ 80 ];
extern struct TextAttr           MainFont;
extern struct Screen            *MainScreen;
extern struct Window            *MainWindow;
extern UBYTE                     MainFileName[ 512 ];
extern UWORD                     MainDriPen[ NUMDRIPENS + 1 ];
extern struct ColorSpec          MainColors[ 33 ];
extern UBYTE                     MainScreenTitle[ 80 ];
extern UBYTE                     MainWindowTitle[ 80 ];
extern struct TagItem            nwTags[ 14 ];
extern struct TagItem            MainSTags[ 12 ];
extern struct ExtGadgetList      Gadgets;
extern UWORD                     ActiveKind;
extern struct Prefs              MainPrefs;
extern BOOL                      Saved;
extern struct NewMenu            Menus[];
extern struct IntuiText         *WindowTxt;
extern BOOL                      ws_InnerW, ws_InnerH, ws_ZoomF, ws_MQueue;
extern BOOL                      ws_RQueue, ws_Adjust, cs_AutoScroll;
extern WORD                      ws_IWidth, ws_IHeight, ws_ZLeft, ws_ZTop;
extern WORD                      ws_ZWidth, ws_ZHeight, ws_MQue, ws_RQue;
extern UWORD                     cs_ScreenType;
extern ULONG                     WindowIDCMP, WindowFlags;
extern struct ExtMenuList        ExtMenus;

/*
 * Icon image data's
 */
UWORD IconData0[] = {
  0x0000,  0x0000,  0x0000,  0x0400,  0x0000,  0x0000,  0x0000,  0x0C00,
  0x0000,  0x0000,  0x0000,  0x0C00,  0x03FF,  0xFFFF,  0xFFFC,  0x0C00,
  0x0300,  0x0000,  0x0000,  0x0C00,  0x0300,  0x0000,  0x0000,  0x0C00,
  0x0306,  0x2A6B,  0x0000,  0x0C00,  0x0308,  0xAA4A,  0x0000,  0x0C00,
  0x0308,  0x0802,  0x2000,  0x0C00,  0x0308,  0x8872,  0x2000,  0x0C00,
  0x0308,  0x8842,  0x2000,  0x0C00,  0x0300,  0x8008,  0x4000,  0x0C00,
  0x0307,  0x9CFB,  0x8000,  0x0C00,  0x0300,  0x0000,  0x0000,  0x0C00,
  0x0300,  0x0000,  0x0000,  0x0C00,  0x0300,  0x0000,  0x0000,  0x0C00,
  0x0300,  0x0000,  0x0000,  0x0C00,  0x0300,  0x0000,  0x0000,  0x0C00,
  0x0200,  0x0000,  0x0000,  0x0C00,  0x0000,  0x0000,  0x0000,  0x0C00,
  0x0000,  0x0000,  0x0000,  0x0C00,  0x7FFF,  0xFFFF,  0xFFFF,  0xFC00,
  0xFFFF,  0xFFFF,  0xFFFF,  0xF800,  0xD555,  0x5555,  0x5555,  0x5000,
  0xD555,  0x5555,  0x5555,  0x5000,  0xD400,  0x0000,  0x0003,  0x5000,
  0xD400,  0x0000,  0x0007,  0x5000,  0xD40E,  0x7DF7,  0x0007,  0x5000,
  0xD411,  0x5494,  0x8007,  0x5000,  0xD410,  0x1084,  0x4007,  0x5000,
  0xD413,  0x10E4,  0x4007,  0x5000,  0xD411,  0x1084,  0x4007,  0x5000,
  0xD411,  0x1094,  0x8007,  0x5000,  0xD40F,  0x39F7,  0x0007,  0x5000,
  0xD400,  0x0000,  0x0207,  0x5000,  0xD400,  0x0000,  0x0707,  0x5000,
  0xD400,  0x0000,  0x3DE7,  0x5000,  0xD400,  0x0000,  0x0707,  0x5000,
  0xD400,  0x0000,  0x0207,  0x5000,  0xD400,  0x0000,  0x0007,  0x5000,
  0xD5FF,  0xFFFF,  0xFFFF,  0x5000,  0xD555,  0x5555,  0x5555,  0x5000,
  0xD555,  0x5555,  0x5555,  0x5000,  0x8000,  0x0000,  0x0000,  0x0000 };

UWORD IconData1[] = {
  0xFFFF,  0xFFFF,  0xFFFF,  0xF800,  0xC000,  0x0000,  0x0000,  0x0000,
  0xC000,  0x0000,  0x0000,  0x0000,  0xC000,  0x0000,  0x0002,  0x0000,
  0xC0FF,  0xFFFF,  0xFFFE,  0x0000,  0xC0F1,  0x8208,  0xFDFE,  0x0000,
  0xC0EE,  0xAB6B,  0x7DFE,  0x0000,  0xC0EF,  0xEF7B,  0xBDFE,  0x0000,
  0xC0EC,  0xEF1B,  0xBDFE,  0x0000,  0xC0EE,  0xEF7B,  0xBDFE,  0x0000,
  0xC0EE,  0xEF6B,  0x7DFE,  0x0000,  0xC0F0,  0xC608,  0xFDFE,  0x0000,
  0xC0FF,  0xFFFF,  0xFDFE,  0x0000,  0xC0FF,  0xFFFF,  0xF8FE,  0x0000,
  0xC0C0,  0x0000,  0x001E,  0x0000,  0xC0FF,  0xFFFF,  0xF8FE,  0x0000,
  0xC0FF,  0xFFFF,  0xFDFE,  0x0000,  0xC0FF,  0xFFFF,  0xFFFE,  0x0000,
  0xC1FF,  0xFFFF,  0xFFFE,  0x0000,  0xC000,  0x0000,  0x0000,  0x0000,
  0xC000,  0x0000,  0x0000,  0x0000,  0x8000,  0x0000,  0x0000,  0x0000,
  0x0000,  0x0000,  0x0000,  0x0400,  0x1555,  0x5555,  0x5555,  0x5C00,
  0x1555,  0x5555,  0x5555,  0x5C00,  0x17FF,  0xFFFF,  0xFFFD,  0x5C00,
  0x17FF,  0xFFFF,  0xFFF9,  0x5C00,  0x17FF,  0xFFFF,  0xFFF9,  0x5C00,
  0x17F9,  0xD594,  0xFFF9,  0x5C00,  0x17F7,  0x55B5,  0xFFF9,  0x5C00,
  0x17F7,  0xF7FD,  0xDFF9,  0x5C00,  0x17F7,  0x778D,  0xDFF9,  0x5C00,
  0x17F7,  0x77BD,  0xDFF9,  0x5C00,  0x17FF,  0x7FF7,  0xBFF9,  0x5C00,
  0x17F8,  0x6304,  0x7FF9,  0x5C00,  0x17FF,  0xFFFF,  0xFFF9,  0x5C00,
  0x17FF,  0xFFFF,  0xFDF9,  0x5C00,  0x17FF,  0xFFFF,  0xFFF9,  0x5C00,
  0x17FF,  0xFFFF,  0xFFF9,  0x5C00,  0x17FF,  0xFFFF,  0xFFF9,  0x5C00,
  0x1600,  0x0000,  0x0001,  0x5C00,  0x1555,  0x5555,  0x5555,  0x5C00,
  0x1555,  0x5555,  0x5555,  0x5C00,  0x7FFF,  0xFFFF,  0xFFFF,  0xFC00 };

struct Image Icon0 = {
  0,0,54,22,2,(UWORD *)&IconData0[0],0x03,0x00,NULL };
struct Image Icon1 = {
  0,0,54,22,2,(UWORD *)&IconData1[0],0x03,0x00,NULL };


struct FileRequester            *bi_Save = 0l;
struct FileRequester            *bi_Load = 0l;

UBYTE                            bi_SPatt[32]   = "#?.g";
UBYTE                            bi_SFile[32]  = "unnamed.g";
UBYTE                            bi_SPath[256];
UBYTE                            bi_LPatt[32]   = "#?.g";
UBYTE                            bi_LFile[32]  = "unnamed.g";
UBYTE                            bi_LPath[256];

struct TagItem                   bi_STags[] = {
    ASL_Hail,                   (ULONG)"Save Binary As...",
    ASL_Window,                 0l,
    ASL_File,                   (ULONG)bi_SFile,
    ASL_Dir,                    (ULONG)bi_SPath,
    ASL_Pattern,                (ULONG)bi_SPatt,
    ASL_OKText,                 (ULONG)"Save",
    ASL_FuncFlags,              FILF_SAVE | FILF_PATGAD,
    TAG_DONE };

struct TagItem                   bi_LTags[] = {
    ASL_Hail,                   (ULONG)"Load Binary...",
    ASL_Window,                 0l,
    ASL_File,                   (ULONG)bi_LFile,
    ASL_Dir,                    (ULONG)bi_LPath,
    ASL_Pattern,                (ULONG)bi_LPatt,
    ASL_OKText,                 (ULONG)"Load",
    ASL_FuncFlags,              FILF_PATGAD,
    TAG_DONE };

/*
 * --- Write the Binary file icon.
 */
long WriteIcon( void )
{
    struct DiskObject  icon;
    struct Gadget      icon_Gadget;

    setmem(( char * )&icon_Gadget, (long)sizeof( struct Gadget ), 0l );

    icon_Gadget.Width        =   54;
    icon_Gadget.Height       =   22;
    icon_Gadget.Flags        =   GFLG_GADGIMAGE | GFLG_GADGHIMAGE;
    icon_Gadget.Activation   =   GACT_RELVERIFY | GACT_IMMEDIATE;
    icon_Gadget.GadgetType   =   GTYP_BOOLGADGET;
    icon_Gadget.GadgetRender =   (APTR)&Icon0;
    icon_Gadget.SelectRender =   (APTR)&Icon1;

    icon.do_Magic            =   WB_DISKMAGIC;
    icon.do_Version          =   WB_DISKVERSION;
    icon.do_Gadget           =   icon_Gadget;
    icon.do_Type             =   WBPROJECT;
    icon.do_DefaultTool      =   (char *)":GadToolsBox";
    icon.do_ToolTypes        =   NULL;
    icon.do_CurrentX         =   NO_ICON_POSITION;
    icon.do_CurrentY         =   NO_ICON_POSITION;
    icon.do_DrawerData       =   NULL;
    icon.do_ToolWindow       =   NULL;
    icon.do_StackSize        =   8192;

    return( (long)PutDiskObject( MainFileName, &icon ));
}

/*
 * --- Write all NewMenus
 */
void WriteNewMenus( BPTR file )
{
    struct ExtNewMenu   *menu, *item, *sub;
    ULONG                num = 0l;

    for ( menu = ExtMenus.ml_First; menu->em_Next; menu = menu->em_Next ) {
        num++;
        menu->em_NumSlaves = 0;
        for ( item = menu->em_Items->ml_First; item->em_Next;  item = item->em_Next ) {
            menu->em_NumSlaves++;
            item->em_NumSlaves = 0;
            for ( sub = item->em_Items->ml_First; sub->em_Next;  sub = sub->em_Next )
                item->em_NumSlaves++;
        }
    }

    Write( file, (char *)&num, (long)sizeof( ULONG ));

    for ( menu = ExtMenus.ml_First; menu->em_Next; menu = menu->em_Next )
        Write( file, (char *)&menu->em_NewMenu, (long)sizeof( struct ExtNewMenu ) - 14l );

    for ( menu = ExtMenus.ml_First; menu->em_Next; menu = menu->em_Next )  {
        for ( item = menu->em_Items->ml_First; item->em_Next; item = item->em_Next )
            Write( file, (char *)&item->em_NewMenu, (long)sizeof( struct ExtNewMenu ) - 14l );
    }

    for ( menu = ExtMenus.ml_First; menu->em_Next; menu = menu->em_Next )  {
        for ( item = menu->em_Items->ml_First; item->em_Next; item = item->em_Next ) {
            for ( sub = item->em_Items->ml_First; sub->em_Next; sub = sub->em_Next )
                Write( file, (char *)&sub->em_NewMenu, (long)sizeof( struct ExtNewMenu ) - 14l );
        }
    }
}

/*
 * --- Write all IntuiTexts added to the window.
 */
void WriteITexts( BPTR file )
{
    struct IntuiText    *t;
    ULONG                tc = 0l;

    if ( NOT( t = WindowTxt )) {
        Write( file, (char *)&tc, (long)sizeof( ULONG ));
        return;
    }

    while ( t ) {
        tc++;
        t = t->NextText;
    }

    Write( file, (char *)&tc, (long)sizeof( ULONG ));

    t = WindowTxt;

    while ( t ) {
        Write( file, (char *)t, (long)sizeof( struct IntuiText ));
        Write( file, (char *)t->IText, 80l );
        t = t ->NextText;
    }
}

/*
 * --- Write the extra data a specific kind of
 * --- gadget has attached to it.
 */
void WriteGadgetXtra( BPTR file, struct ExtNewGadget *eng )
{
    struct ListViewNode *node;
    ULONG                c1, c2, c3;

    switch ( eng->en_Kind ) {

        case    STRING_KIND:
            c1 = 0l;

            if ( eng->en_DefString ) {
                c1 = strlen( eng->en_DefString ) + 1;
                Write( file, (char *)&c1, (long)sizeof( ULONG ));
                Write( file, eng->en_DefString, c1 );
            } else
                Write( file, &c1, (long)sizeof( ULONG ));
            break;

        case    LISTVIEW_KIND:
            c1 = 0l;

            for ( node = eng->en_Entries.lh_Head; node->ln_Succ; node = node->ln_Succ, c1++ );

            Write( file, (char *)&c1, (long)sizeof( ULONG ));

            for ( node = eng->en_Entries.lh_Head; node->ln_Succ; node = node->ln_Succ )
                Write( file, (char *)&node->ln_UserData[0], 116l );
            break;

        case    MX_KIND:
        case    CYCLE_KIND:
            c2 = 0;

            for ( c1 = 0l; c1 < 24l; c1++ ) {
                if ( eng->en_Labels[ c1 ] ) c2++;
            }

            Write( file, (char *)&c2, (long)sizeof( ULONG ));

            if ( c2 ) {
                for ( c1 = 0l; c1 < 24l; c1++ ) {
                    if ( eng->en_Labels[ c1 ] ) {
                        c3 = strlen( eng->en_Labels[ c1 ] ) + 1;
                        Write( file, (char *)&c1, (long)sizeof( ULONG ));
                        Write( file, (char *)&c3, (long)sizeof( ULONG ));
                        Write( file, (char *)eng->en_Labels[ c1 ], c3);
                    }
                }
            }
            break;

        case    SLIDER_KIND:
            c1 = 0l;

            if ( eng->en_LevelFormat ) {
                c1 = strlen( eng->en_LevelFormat ) + 1;
                Write( file, (char *)&c1, (long)sizeof( ULONG ));
                Write( file, eng->en_LevelFormat, c1 );
            } else
                Write( file, (char *)&c1, (long)sizeof( ULONG ));
            break;
    }
}

/*
 * --- Write the gadgets currently in the list.
 */
void WriteGadgets( BPTR file )
{
    struct ExtNewGadget *eng;
    ULONG                num = 0l;

    for ( eng = Gadgets.gl_First; eng->en_Next; eng = eng->en_Next, num++ );

    Write( file, (char *)&num, (long)sizeof( ULONG ));

    for ( eng = Gadgets.gl_First; eng->en_Next; eng = eng->en_Next ) {
        Write( file, (char *)&eng->en_NewGadget, (long)( sizeof( struct ExtNewGadget ) - 16l ));
        Write( file, (char *)eng->en_Tags, (long)( eng->en_NumTags * sizeof( struct TagItem )));
        WriteGadgetXtra( file, eng );
    }
}

/*
 * --- Write the Binary file.
 */
long WriteBinary( long req )
{
    struct BinHeader    head;
    BPTR                file = 0l;
    BOOL                ok = FALSE;

    if ( req ) {
        if ( bi_Save = AllocAslRequest( ASL_FileRequest, TAG_DONE )) {
            bi_STags[1].ti_Data = (ULONG)MainWindow;
            if ( ok = AslRequest( bi_Save, bi_STags )) {

                strcpy( MainFileName, bi_Save->rf_Dir );
                CheckDirExtension();
                strcat( MainFileName, bi_Save->rf_File );

                CheckSuffix();

                strcpy( bi_SPath, bi_Save->rf_Dir );
                strcpy( bi_SFile, bi_Save->rf_File );
                strcpy( bi_SPatt, bi_Save->rf_Pat );
            }
        }
    } else ok = TRUE;

    if (( MainPrefs.pr_PrefFlags0 & PRF_WRITEICON ) == PRF_WRITEICON ) {
        if ( ok ) WriteIcon();
    }

    if ( ok ) {
        if ( file = MyOpen( MODE_NEWFILE )) {

            SetTitle( "Saving..." );
            setmem( (char *)&head, (long)sizeof( struct BinHeader ), 0l );
            SetIoErr( 0l );

            head.bh_FileType        =   GT_FILETYPE;
            head.bh_Version         =   GT_VERSION;
            head.bh_ActiveKind      =   ActiveKind;

            strcpy( (char *)&head.bh_FontName[0], MainFontName );
            CopyMem( (char *)&MainFont, (char *)&head.bh_Font, (long)sizeof( struct TextAttr ));

            strcpy( (char *)&head.bh_ScreenTitle[0], MainScreenTitle );
            CopyMem( (char *)&MainSTags[0], (char *)&head.bh_ScreenTags[0], (long)( 12 * sizeof( struct TagItem )));
            CopyMem( (char *)&MainColors[0], (char *)&head.bh_Colors[0], (long)( 33 * sizeof( struct ColorSpec )));
            CopyMem( (char *)&MainDriPen[0], (char *)&head.bh_DriPens[0], (long)(( NUMDRIPENS + 1 ) << 1 ));

            nwTags[0].ti_Data   =   MainWindow->LeftEdge;
            nwTags[1].ti_Data   =   MainWindow->TopEdge;
            nwTags[2].ti_Data   =   MainWindow->Width;
            nwTags[3].ti_Data   =   MainWindow->Height;

            strcpy( (char *)&head.bh_WindowTitle[0], MainWindowTitle );
            CopyMem( (char *)&nwTags[0], (char *)&head.bh_WindowTags[0], (long)( 14 * sizeof( struct TagItem )));

            if ( ws_InnerW )    head.bh_Flags0 |= BHF_INNERWIDTH;
            if ( ws_InnerH )    head.bh_Flags0 |= BHF_INNERHEIGHT;
            if ( ws_ZoomF  )    head.bh_Flags0 |= BHF_ZOOM;
            if ( ws_MQueue )    head.bh_Flags0 |= BHF_MOUSEQUEUE;
            if ( ws_RQueue )    head.bh_Flags0 |= BHF_RPTQUEUE;
            if ( ws_Adjust )    head.bh_Flags0 |= BHF_AUTOADJUST;

            if ( cs_AutoScroll      )      head.bh_Flags0 |= BHF_AUTOSCROLL;
            if ( cs_ScreenType == 0 )      head.bh_Flags0 |= BHF_WBENCH;
            else if ( cs_ScreenType == 1 ) head.bh_Flags0 |= BHF_PUBLIC;
            else                           head.bh_Flags0 |= BHF_CUSTOM;

            head.bh_Zoom[ 0 ] = ws_ZLeft;
            head.bh_Zoom[ 1 ] = ws_ZTop;
            head.bh_Zoom[ 2 ] = ws_ZWidth;
            head.bh_Zoom[ 3 ] = ws_ZHeight;

            head.bh_MouseQueue = ws_MQue;
            head.bh_RptQueue   = ws_RQue;

            head.bh_IDCMP      = WindowIDCMP;
            head.bh_Flags      = WindowFlags;

            Write( file, (char *)&head, (long)sizeof( struct BinHeader));
            Write( file, (char *)&MainPrefs, (long)sizeof( struct Prefs ));
            WriteGadgets( file );
            WriteITexts( file );
            WriteNewMenus( file );

            Close( file );

            if ( IoErr())
                MyRequest( "Oh oh...", "CONTINUE", "Write Error !" );
            Saved = TRUE;
        }
    }

    SetWindowTitles( MainWindow, MainWindowTitle, MainScreenTitle );
    RefreshWindow();
    if ( bi_Save )  FreeAslRequest( bi_Save );
    bi_Save = 0l;
    ClearMsgPort( MainWindow->UserPort );
}


/*
 * --- Read all NewMenus
 */
void ReadNewMenus( BPTR file )
{
    struct ExtNewMenu   *menu, *item, *sub;
    ULONG                num = 0l, cnt;

    Read( file, (char *)&num, (long)sizeof( ULONG ));

    if ( NOT num )  return;

    for ( cnt = 0; cnt < num; cnt++ ) {
        if ( menu = ( struct ExtNewMenu * )Malloc((long)sizeof( struct ExtNewMenu ))) {
            Read( file, ( char * )&menu->em_NewMenu, (long)sizeof( struct ExtNewMenu ) - 14 );
            menu->em_NewMenu.nm_Label = &menu->em_TheMenuName[0];
            menu->em_NodeName         = &menu->em_TheMenuName[0];
            AddTail(( struct List * )&ExtMenus, ( struct Node * )menu );
        } else goto noMem;
    }

    for ( menu = ExtMenus.ml_First; menu->em_Next; menu = menu->em_Next ) {
        if ( menu->em_NumSlaves ) {
            if ( menu->em_Items = ( struct ExtMenuList * )Malloc((long)sizeof( struct ExtMenuList ))) {
                NewList(( struct List * )menu->em_Items );
                for ( cnt = 0l; cnt < menu->em_NumSlaves; cnt++ ) {
                    if ( item = ( struct ExtNewMenu * )Malloc((long)sizeof( struct ExtNewMenu ))) {
                        Read( file, ( char * )&item->em_NewMenu, (long)sizeof( struct ExtNewMenu ) - 14 );
                        if ( item->em_NewMenu.nm_Label != NM_BARLABEL )
                            item->em_NewMenu.nm_Label = &item->em_TheMenuName[0];
                        item->em_NodeName         = &item->em_TheMenuName[0];
                        if ( item->em_NewMenu.nm_CommKey )
                            item->em_NewMenu.nm_CommKey = &item->em_ShortCut[0];
                        AddTail(( struct List * )menu->em_Items, ( struct Node * )item );
                    } else goto noMem;
                }
            } else goto noMem;
        }
    }

    for ( menu = ExtMenus.ml_First; menu->em_Next; menu = menu->em_Next ) {
        for ( item = menu->em_Items->ml_First; item->em_Next; item = item->em_Next ) {
            if ( item->em_NumSlaves ) {
                if ( item->em_Items = ( struct ExtMenuList * )Malloc((long)sizeof( struct ExtMenuList ))) {
                    NewList(( struct List * )item->em_Items );
                    for ( cnt = 0l; cnt < item->em_NumSlaves; cnt++ ) {
                        if ( sub = ( struct ExtNewMenu * )Malloc((long)sizeof( struct ExtNewMenu ))) {
                            Read( file, ( char * )&sub->em_NewMenu, (long)sizeof( struct ExtNewMenu ) - 14 );
                            if ( sub->em_NewMenu.nm_Label != NM_BARLABEL )
                                sub->em_NewMenu.nm_Label = &sub->em_TheMenuName[0];
                            sub->em_NodeName         = &sub->em_TheMenuName[0];
                            if ( sub->em_NewMenu.nm_CommKey )
                                sub->em_NewMenu.nm_CommKey = &item->em_ShortCut[0];
                            AddTail(( struct List * )item->em_Items, ( struct Node * )sub );
                        } else goto noMem;
                    }
                } else goto noMem;
            } else item->em_Items = 0l;
        }
    }
    return;

    noMem:
    MyRequest( "wheeeeeeee", "OK", "Out of memory !" );
}

/*
 * --- Read all IntuiTexts added to the window.
 */
void ReadITexts( BPTR file )
{
    struct IntuiText    *t, *t1 = 0l;
    ULONG                tc = 0l, c;

    Read( file, (char *)&tc, (long)sizeof( ULONG ));

    if ( tc ) {
        for ( c = 0; c < tc; c++ ) {
            if ( t = ( struct IntuiText * )Malloc((long)sizeof( struct IntuiText)))
                Read( file, (char *)t, (long)sizeof( struct IntuiText ));
            else goto noMem;
            if ( t->IText = (UBYTE *)Malloc(80l))
                Read( file, (char *)t->IText, 80l );
            else goto noMem;

            if ( NOT WindowTxt ) {
                WindowTxt = t;
                t1 = WindowTxt;
            } else {
                t1->NextText = t;
                t1 = t;
            }
        }
    }

    return;

    noMem:
    MyRequest( "abacadabra", "bye", "Out of memory !" );
    return;
}

/*
 * --- Read the extra data a specific kind of
 * --- gadget has attached to it.
 */
void ReadGadgetXtra( BPTR file, struct ExtNewGadget *eng )
{
    struct ListViewNode *node;
    ULONG                c1, c2, idx, size;

    switch ( eng->en_Kind ) {

        case    STRING_KIND:
            Read( file, (char *)&c1, (long)sizeof( ULONG ));

            if ( c1 ) {
                if ( eng->en_DefString = (UBYTE *)Malloc( c1))
                    Read( file, eng->en_DefString, c1 );
                else
                    goto noMem;
            }
            SetTagData( eng->en_Tags, GTST_String, (Tag)eng->en_DefString );
            break;

        case    LISTVIEW_KIND:
            c1 = 0l;

            Read( file, (char *)&c1, (long)sizeof( ULONG ));

            for ( c2 = 0l; c2 < c1; c2++ ) {
                if ( node = MakeNode( "" )) {
                    Read( file, (char *)&node->ln_UserData[0], 116l );
                    AddTail( &eng->en_Entries, ( struct Node * )node );
                } else
                    goto noMem;
            }
            SetTagData( eng->en_Tags, GTLV_Labels, (Tag)&eng->en_Entries );
            break;

        case    MX_KIND:
        case    CYCLE_KIND:
            Read( file, (char *)&c2, (long)sizeof( ULONG ));

            if ( c2 ) {
                for ( c1 = 0l; c1 < c2; c1++ ) {
                    Read( file, (char *)&idx, (long)sizeof( ULONG ));
                    Read( file, (char *)&size, (long)sizeof( ULONG ));
                    if ( eng->en_Labels[ idx ] = (UBYTE *)Malloc( size))
                        Read( file, (char *)eng->en_Labels[ idx ], size);
                    else
                        goto noMem;
                }
            }
            SetTagData( eng->en_Tags, GTCY_Labels, (Tag)&eng->en_Labels[0] );
            SetTagData( eng->en_Tags, GTMX_Labels, (Tag)&eng->en_Labels[0] );
            break;

        case    SLIDER_KIND:
            Read( file, (char *)&c1, (long)sizeof( ULONG ));

            if ( c1 ) {
                if ( eng->en_LevelFormat = (UBYTE *)Malloc( c1))
                    Read( file, eng->en_LevelFormat, c1 );
                else
                    goto noMem;
            }
            SetTagData( eng->en_Tags, GTSL_LevelFormat, (Tag)eng->en_LevelFormat );
            break;
    }
    return;

    noMem:
    MyRequest( "Oh boy...", "CONTINUE", "Out of memory !" );
    return;
}

/*
 * --- Read the gadgets from the file.
 */
void ReadGadgets( BPTR file )
{
    struct ExtNewGadget *eng;
    ULONG                num = 0l, cnt;

    Read( file, (char *)&num, (long)sizeof( ULONG ));

    for ( cnt = 0l; cnt < num; cnt++ ) {
        if ( eng = (struct ExtNewGadget *)Malloc( (long)sizeof( struct ExtNewGadget ))) {
            Read( file, (char *)&eng->en_NewGadget, (long)( sizeof( struct ExtNewGadget ) - 16l ));

            if ( eng->en_NewGadget.ng_GadgetText )
                eng->en_NewGadget.ng_GadgetText = &eng->en_GadgetText[0];

            eng->en_Tags      = 0l;
            eng->en_DefString = 0l;

            NewList( &eng->en_Entries );

            setmem( ( char *)&eng->en_Labels[0], 100l, 0l );

            eng->en_IndicatorSize = 0l;

            if ( eng->en_Tags = MakeTagList( eng->en_NumTags )) {
                Read( file, eng->en_Tags, (long)( eng->en_NumTags * sizeof( struct TagItem )));
                ReadGadgetXtra( file, eng );
            } else goto noMem;
        } else goto noMem;
        AddTail(( struct List * )&Gadgets, ( struct Node * )eng );
    }
    return;

    noMem:
    MyRequest( "Oh boy...", "CONTINUE", "Out of memory !" );
    return;
}

/*
 * --- Read the Binary file.
 */
long ReadBinary( long req)
{
    struct BinHeader    head;
    BPTR                file = 0l;
    BOOL                ok = FALSE;

    if ( NOT Saved ) {
        AlertUser( TRUE );
        if ( NOT MyRequest( "huh?????","So what|Skip this","Changes made not saved !!" )) {
            AlertUser( FALSE );
            return TRUE;
        }
        AlertUser( FALSE );
    }

    if ( req ) {
        if ( bi_Load = AllocAslRequest( ASL_FileRequest, TAG_DONE )) {
            bi_LTags[1].ti_Data = (ULONG)MainWindow;
            if ( ok = AslRequest( bi_Load, bi_LTags )) {

                strcpy( MainFileName, bi_Load->rf_Dir );
                CheckDirExtension();
                strcat( MainFileName, bi_Load->rf_File );

                CheckSuffix();

                strcpy( bi_LPath, bi_Load->rf_Dir );
                strcpy( bi_LFile, bi_Load->rf_File );
                strcpy( bi_LPatt, bi_Load->rf_Pat );
            }
        }
    } else ok = TRUE;

    if ( ok ) {
        if ( file = MyOpen( MODE_OLDFILE )) {

            if ( req ) SetTitle( "Loading..." );
            SetIoErr( 0l );
            DeleteAllGadgets();
            DeleteTexts();
            FreeNewMenus();

            Read( file, (char *)&head, (long)sizeof( struct BinHeader ));

            if ( head.bh_FileType != GT_FILETYPE ) {
                MyRequest( "Huh?", "GOTCHA", "Unknown file type !" );
                if ( req ) goto noShow;
            }

            if ( ActiveKind < NUMBER_KIND )
                Menus[ 19 + ActiveKind ].nm_Flags &= ~CHECKED;
            else if ( ActiveKind < SLIDER_KIND )
                Menus[ 18 + ActiveKind ].nm_Flags &= ~CHECKED;
            else
                Menus[ 17 + ActiveKind ].nm_Flags &= ~CHECKED;

            ActiveKind = head.bh_ActiveKind;

            if ( ActiveKind < NUMBER_KIND )
                Menus[ 19 + ActiveKind ].nm_Flags |= CHECKED;
            else if ( ActiveKind < SLIDER_KIND )
                Menus[ 18 + ActiveKind ].nm_Flags |= CHECKED;
            else
                Menus[ 17 + ActiveKind ].nm_Flags |= CHECKED;

            strcpy( MainFontName, (char *)&head.bh_FontName[0] );
            CopyMem( (char *)&head.bh_Font, (char *)&MainFont, (long)sizeof( struct TextAttr ));

            MainFont.ta_Name = MainFontName;

            strcpy( MainScreenTitle, (char *)&head.bh_ScreenTitle[0] );
            CopyMem( (char *)&head.bh_ScreenTags[0], (char *)&MainSTags[0], (long)( 12 * sizeof( struct TagItem )));
            CopyMem( (char *)&head.bh_Colors[0], (char *)&MainColors[0], (long)( 33 * sizeof( struct ColorSpec )));
            CopyMem( (char *)&head.bh_DriPens[0],  (char *)&MainDriPen[0], (long)(( NUMDRIPENS + 1 ) << 1 ));

            MainSTags[6 ].ti_Data   =   (Tag)&MainScreenTitle[0];
            MainSTags[7 ].ti_Data   =   (Tag)&MainDriPen[0];
            MainSTags[9 ].ti_Data   =   (Tag)&MainFont;
            MainSTags[10].ti_Data   =   (Tag)&MainColors[0];

            strcpy( MainWindowTitle, (char *)&head.bh_WindowTitle[0] );
            CopyMem( (char *)&head.bh_WindowTags[0], (char *)&nwTags[0], (long)( 14 * sizeof( struct TagItem )));

            nwTags[6].ti_Data       =   (Tag)&MainWindowTitle[0];

            if (( head.bh_Flags0 & BHF_INNERWIDTH ) == BHF_INNERWIDTH )
                ws_InnerW = TRUE; else ws_InnerW = FALSE;
            if (( head.bh_Flags0 & BHF_INNERHEIGHT ) == BHF_INNERHEIGHT )
                ws_InnerH = TRUE; else ws_InnerH = FALSE;
            if (( head.bh_Flags0 & BHF_ZOOM ) == BHF_ZOOM )
                ws_ZoomF = TRUE; else ws_ZoomF = FALSE;
            if (( head.bh_Flags0 & BHF_MOUSEQUEUE ) == BHF_MOUSEQUEUE )
                ws_MQueue = TRUE; else ws_MQueue = FALSE;
            if (( head.bh_Flags0 & BHF_RPTQUEUE ) == BHF_RPTQUEUE )
                ws_RQueue = TRUE; else ws_RQueue = FALSE;
            if (( head.bh_Flags0 & BHF_AUTOADJUST ) == BHF_AUTOADJUST )
                ws_Adjust = TRUE; else ws_Adjust = FALSE;


            if (( head.bh_Flags0 & BHF_AUTOSCROLL ) == BHF_AUTOSCROLL )
                cs_AutoScroll = TRUE; else cs_AutoScroll = FALSE;
            if (( head.bh_Flags0 & BHF_WBENCH ) == BHF_WBENCH )
                cs_ScreenType = 0;
            else if (( head.bh_Flags0 & BHF_PUBLIC ) == BHF_PUBLIC )
                cs_ScreenType =1;
            else
                cs_ScreenType = 2;

            ws_ZLeft   = head.bh_Zoom[ 0 ] = ws_ZLeft;
            ws_ZTop    = head.bh_Zoom[ 1 ];
            ws_ZWidth  = head.bh_Zoom[ 2 ];
            ws_ZHeight = head.bh_Zoom[ 3 ];

            ws_MQue = head.bh_MouseQueue;
            ws_RQue = head.bh_RptQueue;

            WindowIDCMP = head.bh_IDCMP;
            WindowFlags = head.bh_Flags;

            Read( file, (char *)&MainPrefs, (long)sizeof( struct Prefs ));
            ReadGadgets( file );
            ReadITexts( file );
            ReadNewMenus( file );

            Close( file );

            if ( IoErr()) {
                MyRequest( "Oh oh...", "CONTINUE", "Read Error !" );
                DeleteAllGadgets();
                if ( req )  goto noShow;
            }
            Saved = TRUE;
        } else {
            MyRequest( "What's up doc ?", "OH", "Could not open %s !", MainFileName );
            if ( req ) goto noShow;
        }
    } else if ( req ) goto noShow;

    ReOpenScreen( 2l );

    noShow:
    SetWindowTitles( MainWindow, MainWindowTitle, MainScreenTitle );
    RefreshWindow();
    ws_IWidth  = MainWindow->Width - MainWindow->BorderLeft - MainWindow->BorderRight;
    ws_IHeight = MainWindow->Height - MainWindow->BorderTop - MainWindow->BorderBottom;

    if ( bi_Load )  FreeAslRequest( bi_Load );
    bi_Load = 0l;
    ClearMsgPort( MainWindow->UserPort );
}
