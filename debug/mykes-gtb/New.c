/*-- AutoRev header do NOT edit!
*
*   Program         :   New.c
*   Copyright       :   © Copyright 1991 Jaba Development
*   Author          :   Jan van den Baard
*   Creation Date   :   25-Oct-91
*   Current version :   1.00
*   Translator      :   DICE v2.6
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   25-Oct-91     1.00            Reset the program to default.
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
extern UBYTE                     gc_CFile[32], bi_SFile[32], bi_LFile[32];
extern UBYTE                     ga_AFile[32];
extern BOOL                      BreakDRAG;

/*
 * --- New
 */
void New( void )
{
    if ( NOT Saved ) {
        AlertUser( TRUE );
        if ( NOT MyRequest( "hey man", "YES|NO", "Changes not saved !\nNew anyway ?" )) {
            AlertUser( FALSE );
            return;
        }
        AlertUser( FALSE );
    }

    if ( NOT ScreenSelect())
        return;

    strcpy( MainFontName, "topaz.font" );
    MainFont.ta_YSize = TOPAZ_EIGHTY;
    MainFont.ta_Style = FS_NORMAL;
    MainFont.ta_Flags = FPF_ROMFONT;

    strcpy( MainFileName, "unnamed.g" );
    strcpy( bi_SFile, "unnamed.g" );
    strcpy( bi_LFile, "unnamed.g" );
    strcpy( gc_CFile, "unnamed.c" );
    strcpy( ga_AFile, "unnamed.s" );

    MainDriPen[0]            = ~0;
    MainColors[0].ColorIndex = ~0;

    strcpy( MainScreenTitle, "GadToolsBox v1.0 © 1991" );
    strcpy( MainWindowTitle, "Work Window" );

    nwTags[0].ti_Data  = 10l;
    nwTags[1].ti_Data  = 15l;
    nwTags[2].ti_Data  = 200l;
    nwTags[3].ti_Data  = 50l;
    nwTags[5].ti_Data |= WFLG_DRAGBAR | WFLG_CLOSEGADGET | WFLG_SIZEGADGET | WFLG_DEPTHGADGET;
    nwTags[5].ti_Data &= ~( WFLG_SIZEBBOTTOM | WFLG_SIZEBRIGHT );

    DeleteAllGadgets();
    DeleteTexts();
    FreeNewMenus();

    ActiveKind = BUTTON_KIND;

    WindowIDCMP = IDCMP_CLOSEWINDOW;
    WindowFlags = WFLG_DRAGBAR + WFLG_CLOSEGADGET + WFLG_SIZEGADGET + WFLG_DEPTHGADGET + WFLG_SMART_REFRESH;

    ws_InnerW = ws_InnerH = ws_ZoomF = ws_MQueue = FALSE;
    ws_RQueue = ws_Adjust = cs_AutoScroll = FALSE;
    ws_MQue   = ws_RQue   = 1;
    cs_ScreenType = 2;

    BreakDRAG = Saved = TRUE;

    ReOpenScreen( 2l );
}
