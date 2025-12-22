/*-- AutoRev header do NOT edit!
*
*   Program         :   GenAsm.c
*   Copyright       :   © Copyright 1991 Jaba Development
*   Author          :   Jan van den Baard
*   Creation Date   :   26-Oct-91
*   Current version :   1.00
*   Translator      :   DICE v2.6
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   26-Oct-91     1.00            Assembler Source Generator.
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
extern struct TagItem            nwTags[];
extern struct TagItem            MainSTags[];
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
extern ULONG                     WindowFlags, WindowIDCMP;
extern UBYTE                    *gc_Kinds[], *gc_Types[];
extern struct ExtMenuList        ExtMenus;

struct FileRequester            *ga_GenA = 0l;

UBYTE                            ga_APatt[32]  = "#?.s";
UBYTE                            ga_AFile[32]  = "unnamed.s";
UBYTE                            ga_APath[256];

UWORD                            ga_TagOffset, ga_GadOffset, ga_ScreenOffset;

struct TagItem                   ga_ATags[] = {
    ASL_Hail,                   (ULONG)"Save Asm Source As...",
    ASL_Window,                 0l,
    ASL_File,                   (ULONG)ga_AFile,
    ASL_Dir,                    (ULONG)ga_APath,
    ASL_Pattern,                (ULONG)ga_APatt,
    ASL_OKText,                 (ULONG)"Save",
    ASL_FuncFlags,              FILF_SAVE | FILF_PATGAD,
    TAG_DONE };

#define STAT                    ( MainPrefs.pr_PrefFlags0 & PRF_STATIC ) == PRF_STATIC
#define RAW                     ( MainPrefs.pr_PrefFlags0 & PRF_RAW ) == PRF_RAW
#define NSTAT                   ( MainPrefs.pr_PrefFlags0 & PRF_STATIC ) != PRF_STATIC
#define NRAW                    ( MainPrefs.pr_PrefFlags0 & PRF_RAW ) != PRF_RAW

/*
 * --- Write a single NewMenu structure.
 */
void WriteAsmNewMenu( BPTR file, struct ExtNewMenu *menu, UWORD num, BOOL what )
{
    ULONG flags;

    if ( what ) {
        MyFPrintf( file, "%sNewMenu%ld:\n", &MainPrefs.pr_ProjectPrefix[0], num );

        if ( NRAW )
            MyFPrintf( file, "    DC.B    %s,0\n", gc_Types[ menu->em_NewMenu.nm_Type ] );
        else
            MyFPrintf( file, "    DC.B    %ld,0\n", menu->em_NewMenu.nm_Type );
        if ( menu->em_NewMenu.nm_Label != NM_BARLABEL )
            MyFPrintf( file, "    DC.L    MName%ld\n", num );
        else {
            if ( NRAW )
                MyFPrintf( file, "    DC.L    NM_BARLABEL,0\n    DC.W    0\n    DC.L    0,0\n\n" );
            else
                MyFPrintf( file, "    DC.L    $FFFFFFFF,0\n    DC.W    0\n    DC.L    0,0\n\n" );
            return;
        }
        if ( menu->em_NewMenu.nm_CommKey )
            MyFPrintf( file, "    DC.L    MComm%ld\n", num );
        else
            MyFPrintf( file, "    DC.L    0\n" );
        if ( flags = menu->em_NewMenu.nm_Flags ) {
            if ( NRAW ) {
                MyFPrintf( file, "    DC.W    " );
                if ( menu->em_NewMenu.nm_Type == NM_TITLE ) {
                    if (( flags & NM_MENUDISABLED ) == NM_MENUDISABLED )
                        MyFPrintf( file, "NM_MENUDISABLED|" );
                }  else {
                    if (( flags & NM_ITEMDISABLED ) == NM_ITEMDISABLED )
                        MyFPrintf( file, "NM_ITEMDISABLED|" );
                }
                if (( flags & CHECKIT ) == CHECKIT )
                    MyFPrintf( file, "CHECKIT|" );
                if (( flags & CHECKED ) == CHECKED )
                    MyFPrintf( file, "CHECKED|" );
                if (( flags & MENUTOGGLE ) == MENUTOGGLE )
                    MyFPrintf( file, "MENUTOGGLE|" );

                Seek( file, -1l, OFFSET_CURRENT );
                MyFPrintf( file, "\n" );
            } else
                MyFPrintf( file, "    DC.W    $%04lx\n", flags );
        } else
            MyFPrintf( file, "    DC.W    0\n" );
        MyFPrintf( file, "    DC.L    %ld,0\n\n", menu->em_NewMenu.nm_MutualExclude );
    } else {

        MyFPrintf( file, "MName%ld:\n    DC.B    '%s',0\n    CNOP    0,2\n\n", num, menu->em_NodeName );

        if ( menu->em_NewMenu.nm_CommKey )
            MyFPrintf( file, "MComm%ld:\n    DC.B    '%s',0\n    CNOP    0,2\n\n", num, &menu->em_ShortCut[0] );
    }
}

/*
 * --- Write the NewMenu structures.
 */
void WriteAsmMenus( BPTR file )
{
    struct ExtNewMenu   *menu, *item, *sub;
    UWORD                num = 0;

    if ( NOT ExtMenus.ml_First->em_Next )
        return;

    for ( menu = ExtMenus.ml_First; menu->em_Next; menu = menu->em_Next ) {
        WriteAsmNewMenu( file, menu, num++, 1 );
        if ( menu->em_Items ) {
            for ( item = menu->em_Items->ml_First;  item->em_Next; item = item->em_Next ) {
                WriteAsmNewMenu( file, item, num++, 1 );
                if ( item->em_Items ) {
                    for ( sub = item->em_Items->ml_First;  sub->em_Next; sub = sub->em_Next )
                        WriteAsmNewMenu( file, item, num++, 1 );
                }
            }
        }
    }
    if ( NRAW )
        MyFPrintf( file, "    DC.B    NM_END,0\n    DC.L    0,0\n    DC.W    0\n    DC.L    0,0\n\n" );
    else
        MyFPrintf( file, "    DC.B    0,0\n    DC.L    0,0\n    DC.W    0\n    DC.L    0,0\n\n" );

    num = 0;

    for ( menu = ExtMenus.ml_First; menu->em_Next; menu = menu->em_Next ) {
        WriteAsmNewMenu( file, menu, num++, 0 );
        if ( menu->em_Items ) {
            for ( item = menu->em_Items->ml_First;  item->em_Next; item = item->em_Next ) {
                WriteAsmNewMenu( file, item, num++, 0 );
                if ( item->em_Items ) {
                    for ( sub = item->em_Items->ml_First;  sub->em_Next; sub = sub->em_Next )
                        WriteAsmNewMenu( file, item, num++, 0 );
                }
            }
        }
    }
}

/*
 * --- Write the GadgetID defines.
 */
void WriteAsmID( BPTR file )
{
    struct ExtNewGadget *eng;

    Renumber();

    for ( eng = Gadgets.gl_First; eng->en_Next; eng = eng->en_Next )
        MyFPrintf( file, "GD_%-32s    EQU    %ld\n", &eng->en_SourceLabel[0], eng->en_NewGadget.ng_GadgetID );
    MyFPrintf( file, "\n" );
}


/*
 * --- Write the necessary xdef's.
 */
void WriteAsmXdef( BPTR file )
{
    MyFPrintf( file, "    XDEF    %sWnd\n", &MainPrefs.pr_ProjectPrefix[0] );
    MyFPrintf( file, "    XDEF    %sScr\n", &MainPrefs.pr_ProjectPrefix[0] );
    MyFPrintf( file, "    XDEF    %sVisualInfo\n", &MainPrefs.pr_ProjectPrefix[0] );

    if ( Gadgets.gl_First->en_Next ) {
        MyFPrintf( file, "    XDEF    %sGList\n", &MainPrefs.pr_ProjectPrefix[0] );
        MyFPrintf( file, "    XDEF    %sGadgets\n", &MainPrefs.pr_ProjectPrefix[0], CountGadgets());
    }

    if ( ExtMenus.ml_First->em_Next )
        MyFPrintf( file, "    XDEF    %sMenus\n", &MainPrefs.pr_ProjectPrefix[0] );

    if ( ws_ZoomF )
        MyFPrintf( file, "    XDEF    %sZoom\n", &MainPrefs.pr_ProjectPrefix[0], ws_ZLeft, ws_ZTop, ws_ZWidth, ws_ZHeight );

    MyFPrintf( file, "    XDEF    %sInitStuff\n", &MainPrefs.pr_ProjectPrefix[0] );
    MyFPrintf( file, "    XDEF    %sCleanStuff\n", &MainPrefs.pr_ProjectPrefix[0] );
    MyFPrintf( file, "\n" );
}

/*
 * --- Write the necessary globals.
 */
void WriteAsmGlob( BPTR file )
{
    UWORD cnt, ng = CountGadgets();
    UBYTE                fname[32], *ptr;

    strcpy( fname, MainFontName );

    ptr = strchr( fname, '.' );
    *ptr = 0;

    MyFPrintf( file, "%sWnd:\n    DC.L    0\n", &MainPrefs.pr_ProjectPrefix[0] );
    MyFPrintf( file, "%sScr:\n    DC.L    0\n", &MainPrefs.pr_ProjectPrefix[0] );
    MyFPrintf( file, "%sVisualInfo:\n    DC.L    0\n", &MainPrefs.pr_ProjectPrefix[0] );

    if ( Gadgets.gl_First->en_Next ) {
        MyFPrintf( file, "%sGList:\n    DC.L    0\n", &MainPrefs.pr_ProjectPrefix[0] );
        MyFPrintf( file, "%sGadgets:\n", &MainPrefs.pr_ProjectPrefix[0] );

        if ( CountGadgets() == 1 )
            MyFPrintf( file, "%sGadget0:\n    DC.L    0\n", &MainPrefs.pr_ProjectPrefix[0] );
        else {
            for ( cnt = 0; cnt < ng; cnt++ )
                MyFPrintf( file, "%sGadget%ld:\n    DC.L    0\n", &MainPrefs.pr_ProjectPrefix[0], cnt );
        }
    }

    if ( ExtMenus.ml_First->em_Next ) {
        MyFPrintf( file, "%sMenus:\n    DC.L    0\n", &MainPrefs.pr_ProjectPrefix[0] );
        if ( NRAW )  {
            MyFPrintf( file, "%sMTags0:\n    DC.L    GTMN_FrontPen,0,TAG_DONE\n", &MainPrefs.pr_ProjectPrefix[0] );
            MyFPrintf( file, "%sMTags1:\n    DC.L    GTMN_TextAttr,%s%ld,TAG_DONE\n", &MainPrefs.pr_ProjectPrefix[0], fname, MainFont.ta_YSize );
        }  else {
            MyFPrintf( file, "%sMTags0:\n    DC.L    $%08lx,0,$%08lx\n", &MainPrefs.pr_ProjectPrefix[0], GTMN_FrontPen, TAG_DONE );
            MyFPrintf( file, "%sMTags1:\n    DC.L    $%08lx,%s%ld,$%08lx\n", &MainPrefs.pr_ProjectPrefix[0], GTMN_TextAttr, fname, MainFont.ta_YSize, TAG_DONE );
        }
    }

    if ( ws_ZoomF )
        MyFPrintf( file, "%sZoom:\n    DC.W    %ld,%ld,%ld,%ld\n", &MainPrefs.pr_ProjectPrefix[0], ws_ZLeft, ws_ZTop, ws_ZWidth, ws_ZHeight );

    MyFPrintf( file, "%sBufNewGad:\n    DC.W    0,0,0,0\n    DC.L    0,0\n    DC.W    0\n    DC.L    0,0,0\n", &MainPrefs.pr_ProjectPrefix[0] );

    if ( NOT cs_ScreenType )
        MyFPrintf( file, "%sWB:\n    DC.B    'Workbench',0\n", &MainPrefs.pr_ProjectPrefix[0] );

    if  ( NRAW )
        MyFPrintf( file, "%sTD:\n    DC.L    TAG_DONE\n", &MainPrefs.pr_ProjectPrefix[0] );
    else
        MyFPrintf( file, "%sTD:\n    DC.L    $%08lx\n", &MainPrefs.pr_ProjectPrefix[0], TAG_DONE );

    MyFPrintf( file, "\n" );
}

/*
 * --- Write the Asm Gadgets tags.
 */
void WriteAsmGadgetTags( BPTR file )
{
    struct ExtNewGadget *g;
    UBYTE               *fmt = 0l, *str = 0l;
    UWORD                num;

    for ( g = Gadgets.gl_First, num = 0; g->en_Next; g = g->en_Next, num++ ) {

        MyFPrintf( file, "%sTags:\n", &g->en_SourceLabel[0] );

        if ( NRAW ) {
            switch ( g->en_Kind ) {

                case    BUTTON_KIND:
                    if (( g->en_SpecialFlags & EGF_DISABLED ) == EGF_DISABLED )
                        MyFPrintf( file, "    DC.L    GA_Disabled,1\n" );
                    break;

                case    CHECKBOX_KIND:
                    if (( g->en_SpecialFlags & EGF_CHECKED ) == EGF_CHECKED )
                        MyFPrintf( file, "    DC.L    GTCB_Checked,1\n" );
                    if (( g->en_SpecialFlags & EGF_DISABLED ) == EGF_DISABLED )
                        MyFPrintf( file, "    DC.L    GA_Disabled,1\n" );
                    break;

                case    CYCLE_KIND:
                    MyFPrintf( file, "    DC.L    GTCY_Labels,%sLabels\n", &g->en_SourceLabel[0] );
                    if (( g->en_SpecialFlags & EGF_DISABLED ) == EGF_DISABLED )
                        MyFPrintf( file, "    DC.L    GA_Disabled,1\n" );
                    break;

                case    INTEGER_KIND:
                    MyFPrintf( file, "    DC.L    GTIN_Number,%ld\n", g->en_DefInt );
                    MyFPrintf( file, "    DC.L    GTIN_MaxChars,%ld\n", GetTagData( GTIN_MaxChars, 5l, g->en_Tags ));
                    if (( g->en_SpecialFlags & EGF_DISABLED ) == EGF_DISABLED )
                        MyFPrintf( file, "    DC.L    GA_Disabled,1\n" );
                    break;

                case    LISTVIEW_KIND:
                    if ( g->en_Entries.lh_Head->ln_Succ->ln_Succ )
                        MyFPrintf( file, "    DC.L    GTLV_Labels,%sList\n", &g->en_SourceLabel[0] );
                    else
                        MyFPrintf( file, "    DC.L    GTLV_Labels,$FFFFFFFF\n" );
                    if (( g->en_SpecialFlags & EGF_NEEDLOCK ) == EGF_NEEDLOCK )
                        MyFPrintf( file, "    DC.L    GTLV_ShowSelected,%sGadget%ld\n", &MainPrefs.pr_ProjectPrefix[0], num - 1 );
                    else if (MyTagInArray( GTLV_ShowSelected, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    GTLV_ShowSelected,0\n" );
                    if ( MyTagInArray( GTLV_ScrollWidth, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    GTLV_ScrollWidth,%ld\n", g->en_ScrollWidth );
                    if (( g->en_SpecialFlags & EGF_READONLY ) == EGF_READONLY )
                        MyFPrintf( file, "    DC.L    GTLV_ReadOnly,1\n" );
                    if ( MyTagInArray( LAYOUTA_Spacing, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    LAYOUTA_Spacing,%ld\n", g->en_Spacing );
                    break;

                case    MX_KIND:
                    MyFPrintf( file, "    DC.L    GTMX_Labels,%sLabels\n", &g->en_SourceLabel[0] );
                    if ( MyTagInArray( GTMX_Spacing, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    GTMX_Spacing,%ld\n", g->en_Spacing );
                    break;

                case    PALETTE_KIND:
                    MyFPrintf( file, "    DC.L    GTPA_Depth,%ld\n", MainScreen->BitMap.Depth );
                    if ( MyTagInArray( GTPA_IndicatorWidth, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    GTPA_IndicatorWidth,%ld\n", GetTagData( GTPA_IndicatorWidth, 0l, g->en_Tags ));
                    if ( MyTagInArray( GTPA_IndicatorHeight, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    GTPA_IndicatorHeight,%ld\n", GetTagData( GTPA_IndicatorHeight, 0l, g->en_Tags ));
                    if (( g->en_SpecialFlags & EGF_DISABLED ) == EGF_DISABLED )
                        MyFPrintf( file, "    DC.L    GA_Disabled,1\n" );
                    break;

                case    SCROLLER_KIND:
                    if ( MyTagInArray( GTSC_Top, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    GTSC_Top,%ld\n", GetTagData( GTSC_Top, 0l, g->en_Tags ));
                    if ( MyTagInArray( GTSC_Total, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    GTSC_Total,%ld\n", GetTagData( GTSC_Total, 0l, g->en_Tags ));
                    if ( MyTagInArray( GTSC_Visible, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    GTSC_Visible,%ld\n", GetTagData( GTSC_Visible, 0l, g->en_Tags ));
                    if ( MyTagInArray( GTSC_Arrows, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    GTSC_Arrows,%ld\n", g->en_ArrowSize );
                    if ( MyTagInArray( PGA_Freedom, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    PGA_Freedom,LORIENT_VERT\n" );
                    else
                        MyFPrintf( file, "    DC.L    PGA_Freedom,LORIENT_HORIZ\n" );
                    if ( MyTagInArray( GA_Immediate, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    GA_Immediate,1\n" );
                    if ( MyTagInArray( GA_RelVerify, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    GA_RelVerify,1\n" );
                    if (( g->en_SpecialFlags & EGF_DISABLED ) == EGF_DISABLED )
                        MyFPrintf( file, "    DC.L    GA_Disabled,1\n " );
                    break;

                case    SLIDER_KIND:
                    if ( MyTagInArray( GTSL_Min, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    GTSL_Min,%ld\n", GetTagData( GTSL_Min, 0l, g->en_Tags ));
                    if ( MyTagInArray( GTSL_Max, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    GTSL_Max,%ld\n", GetTagData( GTSL_Max, 0l, g->en_Tags ));
                    if ( MyTagInArray( GTSL_Level, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    GTSL_Level,%ld\n", GetTagData( GTSL_Level, 0l, g->en_Tags ));
                    if ( MyTagInArray( GTSL_MaxLevelLen, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    GTSL_MaxLevelLen,%ld\n", GetTagData( GTSL_MaxLevelLen, 0l, g->en_Tags ));
                    if ( MyTagInArray( GTSL_LevelFormat, g->en_Tags )) {
                        MyFPrintf( file, "    DC.L    GTSL_LevelFormat,%sFormat\n", &g->en_SourceLabel[0] );
                        fmt = g->en_LevelFormat;
                    }
                    if ( MyTagInArray( GTSL_LevelPlace, g->en_Tags )) {
                        MyFPrintf( file, "    DC.L    GTSL_LevelPlace," );
                        WritePlaceFlags( file, (long)GetTagData( GTSL_LevelPlace, 0l, g->en_Tags ), 1l );
                        Seek( file, -2, OFFSET_CURRENT );
                        MyFPrintf( file, "\n" );
                    }
                    if ( MyTagInArray( PGA_Freedom, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    PGA_Freedom,LORIENT_VERT\n" );
                    else
                        MyFPrintf( file, "    DC.L    PGA_Freedom,LORIENT_HORIZ\n" );
                    if ( MyTagInArray( GA_Immediate, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    GA_Immediate,1\n" );
                    if ( MyTagInArray( GA_RelVerify, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    GA_RelVerify,1\n" );
                    if (( g->en_SpecialFlags & EGF_DISABLED ) == EGF_DISABLED )
                        MyFPrintf( file, "    DC.L    GA_Disabled,1\n" );
                    break;

                case    STRING_KIND:
                    if ( g->en_DefString ) {
                        MyFPrintf( file, "    DC.L    GTST_String,%sString\n", &g->en_SourceLabel[0] );
                        str = g->en_DefString;
                    }
                    MyFPrintf( file, "    DC.L    GTST_MaxChars,%ld\n", GetTagData( GTST_MaxChars, 5l, g->en_Tags ));
                    if (( g->en_SpecialFlags & EGF_DISABLED ) == EGF_DISABLED )
                        MyFPrintf( file, "    DC.L    GA_Disabled,1\n" );
                    break;
            }
            if ( MyTagInArray( GT_Underscore,  g->en_Tags ))
                MyFPrintf( file, "    DC.L    GT_Underscore,'_'\n" );

            MyFPrintf( file, "    DC.L    TAG_DONE\n\n" );
        } else {
            switch ( g->en_Kind ) {

                case    BUTTON_KIND:
                    if (( g->en_SpecialFlags & EGF_DISABLED ) == EGF_DISABLED )
                        MyFPrintf( file, "    DC.L    $08lx,1\n", GA_Disabled );
                    break;

                case    CHECKBOX_KIND:
                    if (( g->en_SpecialFlags & EGF_CHECKED ) == EGF_CHECKED )
                        MyFPrintf( file, "    DC.L    $%08lx,1\n", GTCB_Checked );
                    if (( g->en_SpecialFlags & EGF_DISABLED ) == EGF_DISABLED )
                        MyFPrintf( file, "    DC.L    $%08lx,1\n", GA_Disabled );
                    break;

                case    CYCLE_KIND:
                    MyFPrintf( file, "    DC.L    $%08lx,%sLabels\n", GTCY_Labels, &g->en_SourceLabel[0] );
                    if (( g->en_SpecialFlags & EGF_DISABLED ) == EGF_DISABLED )
                        MyFPrintf( file, "    DC.L    $%08lx,1\n", GA_Disabled );
                    break;

                case    INTEGER_KIND:
                    MyFPrintf( file, "    DC.L    $%08lx,%ld\n", GTIN_Number, g->en_DefInt );
                    MyFPrintf( file, "    DC.L    $%08lx,%ld\n", GTIN_MaxChars, GetTagData( GTIN_MaxChars, 5l, g->en_Tags ));
                    if (( g->en_SpecialFlags & EGF_DISABLED ) == EGF_DISABLED )
                        MyFPrintf( file, "    DC.L    %08lx,1\n", GA_Disabled );
                    break;

                case    LISTVIEW_KIND:
                    if ( g->en_Entries.lh_Head->ln_Succ->ln_Succ )
                        MyFPrintf( file, "    DC.L    $%08lx,%sList\n", GTLV_Labels, &g->en_SourceLabel[0] );
                    else
                        MyFPrintf( file, "    DC.L    $%08lx,$FFFFFFFF\n", GTLV_Labels );
                    if (( g->en_SpecialFlags & EGF_NEEDLOCK ) == EGF_NEEDLOCK )
                        MyFPrintf( file, "    DC.L    $%08lx,%sGadget%ld\n", GTLV_ShowSelected, &MainPrefs.pr_ProjectPrefix[0], num - 1 );
                    else if (MyTagInArray( GTLV_ShowSelected, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    $%08lx,0\n", GTLV_ShowSelected );
                    if ( MyTagInArray( GTLV_ScrollWidth, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    $%08lx,%ld\n", GTLV_ScrollWidth, g->en_ScrollWidth );
                    if (( g->en_SpecialFlags & EGF_READONLY ) == EGF_READONLY )
                        MyFPrintf( file, "    DC.L    $%08lx,1\n", GTLV_ReadOnly );
                    if ( MyTagInArray( LAYOUTA_Spacing, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    $%08lx,%ld\n", LAYOUTA_Spacing, g->en_Spacing );
                    break;

                case    MX_KIND:
                    MyFPrintf( file, "    DC.L    $%08lx,%sLabels\n", GTMX_Labels, &g->en_SourceLabel[0] );
                    if ( MyTagInArray( GTMX_Spacing, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    $%08lx,%ld\n", GTMX_Spacing, g->en_Spacing );
                    break;

                case    PALETTE_KIND:
                    MyFPrintf( file, "    DC.L    $%08lx,%ld\n", GTPA_Depth, MainScreen->BitMap.Depth );
                    if ( MyTagInArray( GTPA_IndicatorWidth, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    $%08lx,%ld\n", GTPA_IndicatorWidth, GetTagData( GTPA_IndicatorWidth, 0l, g->en_Tags ));
                    if ( MyTagInArray( GTPA_IndicatorHeight, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    $%08lx,%ld\n", GTPA_IndicatorHeight, GetTagData( GTPA_IndicatorHeight, 0l, g->en_Tags ));
                    if (( g->en_SpecialFlags & EGF_DISABLED ) == EGF_DISABLED )
                        MyFPrintf( file, "    DC.L    $%08lx,1\n", GA_Disabled );
                    break;

                case    SCROLLER_KIND:
                    if ( MyTagInArray( GTSC_Top, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    $%08lx,%ld\n", GTSC_Top, GetTagData( GTSC_Top, 0l, g->en_Tags ));
                    if ( MyTagInArray( GTSC_Total, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    $%08lx,%ld\n", GTSC_Total, GetTagData( GTSC_Total, 0l, g->en_Tags ));
                    if ( MyTagInArray( GTSC_Visible, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    $%08lx,%ld\n", GTSC_Visible, GetTagData( GTSC_Visible, 0l, g->en_Tags ));
                    if ( MyTagInArray( GTSC_Arrows, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    $%08lx,%ld\n", GTSC_Arrows, g->en_ArrowSize );
                    if ( MyTagInArray( PGA_Freedom, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    $%08lx,%ld\n", PGA_Freedom, LORIENT_VERT );
                    else
                        MyFPrintf( file, "    DC.L    $%08lx,%ld\n", PGA_Freedom, LORIENT_HORIZ );
                    if ( MyTagInArray( GA_Immediate, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    $%08lx,1\n", GA_Immediate );
                    if ( MyTagInArray( GA_RelVerify, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    $%08lx,1\n", GA_RelVerify );
                    if (( g->en_SpecialFlags & EGF_DISABLED ) == EGF_DISABLED )
                        MyFPrintf( file, "    DC.L    $%08lx,1\n ", GA_Disabled );
                    break;

                case    SLIDER_KIND:
                    if ( MyTagInArray( GTSL_Min, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    $%08lx,%ld\n", GTSL_Min, GetTagData( GTSL_Min, 0l, g->en_Tags ));
                    if ( MyTagInArray( GTSL_Max, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    $%08lx,%ld\n", GTSL_Max, GetTagData( GTSL_Max, 0l, g->en_Tags ));
                    if ( MyTagInArray( GTSL_Level, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    $%08lx,%ld\n", GTSL_Level, GetTagData( GTSL_Level, 0l, g->en_Tags ));
                    if ( MyTagInArray( GTSL_MaxLevelLen, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    $%08lx,%ld\n", GTSL_MaxLevelLen, GetTagData( GTSL_MaxLevelLen, 0l, g->en_Tags ));
                    if ( MyTagInArray( GTSL_LevelFormat, g->en_Tags )) {
                        MyFPrintf( file, "    DC.L    $%08lx,%sFormat\n", GTSL_LevelFormat, &g->en_SourceLabel[0] );
                        fmt = g->en_LevelFormat;
                    }
                    if ( MyTagInArray( GTSL_LevelPlace, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    $%08lx,$%04lx\n", GTSL_LevelPlace, GetTagData( GTSL_LevelPlace, 0l, g->en_Tags ));
                    if ( MyTagInArray( PGA_Freedom, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    $%08lx,%ld\n", PGA_Freedom, LORIENT_VERT );
                    else
                        MyFPrintf( file, "    DC.L    $%08lx,%ld\n", PGA_Freedom, LORIENT_HORIZ );
                    if ( MyTagInArray( GA_Immediate, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    $%08lx,1\n", GA_Immediate );
                    if ( MyTagInArray( GA_RelVerify, g->en_Tags ))
                        MyFPrintf( file, "    DC.L    $%08lx,1\n", GA_RelVerify );
                    if (( g->en_SpecialFlags & EGF_DISABLED ) == EGF_DISABLED )
                        MyFPrintf( file, "    DC.L    $%08lx,1\n", GA_Disabled );
                    break;

                case    STRING_KIND:
                    if ( g->en_DefString ) {
                        MyFPrintf( file, "    DC.L    $%08lx,%sString\n", GTST_String, &g->en_SourceLabel[0] );
                        str = g->en_DefString;
                    }
                    MyFPrintf( file, "    DC.L    $%08lx,%ld\n", GTST_MaxChars, GetTagData( GTST_MaxChars, 5l, g->en_Tags ));
                    if (( g->en_SpecialFlags & EGF_DISABLED ) == EGF_DISABLED )
                        MyFPrintf( file, "    DC.L    $%08lx,1\n", GA_Disabled );
                    break;
            }
            if ( MyTagInArray( GT_Underscore,  g->en_Tags ))
                MyFPrintf( file, "    DC.L    $%08lx,'_'\n", GT_Underscore );

            MyFPrintf( file, "    DC.L    $%08lx\n\n", TAG_DONE );
        }

        if ( fmt ) {
            MyFPrintf( file, "%sFormat:\n    DC.B    '%s',0\n    CNOP     0,2\n\n", &g->en_SourceLabel[0], g->en_LevelFormat );
            fmt = 0l;
        }

        if ( str ) {
            MyFPrintf( file, "%sString:\n    DC.B    '%s',0\n    CNOP     0,2\n\n", &g->en_SourceLabel[0], g->en_DefString );
            str = 0l;
        }
    }
}

/*
 * --- Write the GadgetTexts.
 */
void WriteAsmGText( BPTR file )
{
    struct ExtNewGadget *eng;

    for ( eng = Gadgets.gl_First; eng->en_Next; eng = eng->en_Next ) {
        if ( eng->en_NewGadget.ng_GadgetText )
            MyFPrintf( file, "%sText:\n    DC.B    '%s',0\n    CNOP    0,2\n\n", &eng->en_SourceLabel[0], &eng->en_GadgetText[0] );
    }
}


/*
 * --- Write the Cycle and Mx lables.
 */
void WriteAsmLabels( BPTR file )
{
    struct ExtNewGadget *eng;
    UWORD                i, c = 0;

    for ( eng = Gadgets.gl_First; eng->en_Next; eng = eng->en_Next ) {
        if ( eng->en_Kind == CYCLE_KIND || eng->en_Kind == MX_KIND ) {
            c = 0;
            MyFPrintf( file, "%sLabels:\n", &eng->en_SourceLabel[0] );
            for ( i = 0; i < 24; i++ ) {
                if ( eng->en_Labels[ i ] )
                    MyFPrintf( file, "    DC.L    %sLab%ld\n", &eng->en_SourceLabel[0], c++ );
            }
            MyFPrintf( file, "    DC.L    0\n\n" );
        }
    }

    for ( eng = Gadgets.gl_First; eng->en_Next; eng = eng->en_Next ) {
        c = 0;
        if ( eng->en_Kind == CYCLE_KIND || eng->en_Kind == MX_KIND ) {
            for ( i = 0; i < 24; i++ ) {
                if ( eng->en_Labels[ i ] )
                    MyFPrintf( file, "%sLab%ld:    DC.B    '%s',0\n    CNOP    0,2\n", &eng->en_SourceLabel[0], c++, eng->en_Labels[i] );
            }
            MyFPrintf( file, "\n" );
        }
    }
}


/*
 * --- Write a single ListView Node.
 */
void WriteAsmNode( BPTR file, struct ExtNewGadget *eng, struct ListViewNode *node, WORD num )
{
    if ( node->ln_Succ != ( struct ListViewNode * )&eng->en_Entries.lh_Tail )
        MyFPrintf( file, "    DC.L    %sNodes%ld\n", &eng->en_SourceLabel[0], num + 1 );
    else
        MyFPrintf( file, "    DC.L    %sList+4\n", &eng->en_SourceLabel[0] );

    if ( node->ln_Pred == ( struct ListViewNode * )&eng->en_Entries )
        MyFPrintf( file, "    DC.L    %sList\n", &eng->en_SourceLabel[0] );
    else
        MyFPrintf( file, "    DC.L    %sNodes%ld\n", &eng->en_SourceLabel[0], num - 1 );

    MyFPrintf( file, "    DC.B    0,0\n    DC.L    %sName%ld\n\n", &eng->en_SourceLabel[0], num );

    MyFPrintf( file, "%sName%ld:\n    DC.B    '%s',0\n    CNOP    0,2\n\n", &eng->en_SourceLabel[0], num, &node->ln_NameBytes[0] );
}

/*
 * --- Write the ListView entries.
 */
void WriteAsmList( BPTR file )
{
    struct ExtNewGadget *eng;
    struct ListViewNode *node, *action;
    WORD                 nodenum;

    for ( eng = Gadgets.gl_First; eng->en_Next; eng = eng->en_Next ) {
        if ( eng->en_Kind == LISTVIEW_KIND ) {

            action = ( struct ListViewNode * )RemHead( &eng->en_Entries );

            if ( eng->en_Entries.lh_Head->ln_Succ ) {
                for ( node = eng->en_Entries.lh_Head, nodenum = 0; node->ln_Succ; node = node->ln_Succ, nodenum++ ) {
                    MyFPrintf( file, "%sNodes%ld:\n", &eng->en_SourceLabel[0], nodenum );
                    WriteAsmNode( file, eng, node, nodenum );
                }
                MyFPrintf( file, "%sList:\n", &eng->en_SourceLabel[0] );
                MyFPrintf( file, "    DC.L    %sNodes0,0,%sNodes%ld\n\n", &eng->en_SourceLabel[0], &eng->en_SourceLabel[0], nodenum - 1 );
            }
            AddHead( &eng->en_Entries, ( struct Node * )action );
        }
    }
}

/*
 * --- Write the TextAttr structure
 */
void WriteAsmTextAttr( BPTR file )
{
    UBYTE                fname[32], *ptr;

    strcpy( fname, MainFontName );

    ptr = strchr( fname, '.' );
    *ptr = 0;

    MyFPrintf( file, "%s%ld:\n", fname, MainFont.ta_YSize );
    MyFPrintf( file, "    DC.L    %sFName%ld\n    DC.W    %ld\n    DC.B    $%02lx,$%02lx\n\n", fname, MainFont.ta_YSize, MainFont.ta_YSize, MainFont.ta_Style, MainFont.ta_Flags );
    MyFPrintf( file, "%sFName%ld:\n    DC.B    '%s',0\n    CNOP    0,2\n\n", fname, MainFont.ta_YSize, MainFontName );
}

/*
 * --- Write the Window Tags.
 */
void WriteAsmWTags( BPTR file )
{
    MyFPrintf( file, "%sWindowTags:\n", &MainPrefs.pr_ProjectPrefix[0] );

    if ( NRAW ) {
        if ( MyTagInArray( WA_Left, nwTags ))
            MyFPrintf( file, "    DC.L    WA_Left,%ld\n", GetTagData( WA_Left, 0l, nwTags ));
        if ( MyTagInArray( WA_Top, nwTags ))
            MyFPrintf( file, "    DC.L    WA_Top,%ld\n", GetTagData( WA_Top, 0l, nwTags ));
        if ( ws_InnerW )
            MyFPrintf( file, "    DC.L    WA_InnerWidth,%ld\n", ws_IWidth );
        else
            MyFPrintf( file, "    DC.L    WA_Width,%ld\n", MainWindow->Width);
        if ( ws_InnerH )
            MyFPrintf( file, "    DC.L    WA_InnerHeight,%ld\n", ws_IHeight );
        else
            MyFPrintf( file, "    DC.L    WA_Height,%ld\n", MainWindow->Height);
        if ( MyTagInArray( WA_DetailPen, nwTags ))
            MyFPrintf( file, "    DC.L    WA_DetailPen,%ld\n", GetTagData( WA_DetailPen, 0l, nwTags ));
        if ( MyTagInArray( WA_BlockPen, nwTags ))
             MyFPrintf( file, "    DC.L    WA_BlockPen,%ld\n", GetTagData( WA_BlockPen, 0l, nwTags ));
        GetGadgetIDCMP();
        MyFPrintf( file, "    DC.L    WA_IDCMP," );
        WriteIDCMPFlags( file, WindowIDCMP, 1l);
        Seek( file, -2l, OFFSET_CURRENT );
        MyFPrintf( file, "\n" );
        if ( MyTagInArray( WA_Flags, nwTags ))
            MyFPrintf( file, "    DC.L    WA_Flags," );
            WriteWindowFlags( file, GetTagData( WA_Flags, 0l, nwTags ), 1l);
            Seek( file, -2l, OFFSET_CURRENT );
            MyFPrintf( file, "\n" );
        if ( Gadgets.gl_First->en_Next )
            MyFPrintf( file, "%sWG:\n    DC.L    WA_Gadgets,0\n", &MainPrefs.pr_ProjectPrefix[0] );
        if ( strlen( MainWindowTitle ))
            MyFPrintf( file, "    DC.L    WA_Title,%sWTitle\n", &MainPrefs.pr_ProjectPrefix[0] );
        if ( strlen( MainScreenTitle ))
            MyFPrintf( file, "    DC.L    WA_ScreenTitle,%sSTitle\n", &MainPrefs.pr_ProjectPrefix[0] );
        if ( cs_ScreenType ) {
            if ( cs_ScreenType == 2 )
                MyFPrintf( file, "%sSC:\n    DC.L    WA_CustomScreen,0\n", &MainPrefs.pr_ProjectPrefix[0] );
            if ( cs_ScreenType == 1 )
                MyFPrintf( file, "%sSC:\n    DC.L    WA_PubScreen,0\n", &MainPrefs.pr_ProjectPrefix[0] );
        }
        if ( MyTagInArray( WA_MinWidth, nwTags ))
            MyFPrintf( file, "    DC.L    WA_MinWidth,%ld\n", GetTagData( WA_MinWidth, 0l, nwTags ));
        if ( MyTagInArray( WA_MinHeight, nwTags ))
            MyFPrintf( file, "    DC.L    WA_MinHeight,%ld\n", GetTagData( WA_MinHeight, 0l, nwTags ));
        if ( MyTagInArray( WA_MaxWidth, nwTags ))
            MyFPrintf( file, "    DC.L    WA_MaxWidth,%ld\n", GetTagData( WA_MaxWidth, 0l, nwTags ));
        if ( MyTagInArray( WA_MaxHeight, nwTags ))
            MyFPrintf( file, "    DC.L    WA_MaxHeight,%ld\n", GetTagData( WA_MaxHeight, 0l, nwTags ));
        if ( ws_ZoomF )
            MyFPrintf( file, "    DC.L    WA_Zoom,%sZoom\n", &MainPrefs.pr_ProjectPrefix[0] );
        if ( ws_MQueue )
            MyFPrintf( file, "    DC.L    WA_MouseQueue,%ld\n", ws_MQue);
        if ( ws_RQueue )
            MyFPrintf( file, "    DC.L    WA_RptQueue,%ld\n", ws_RQue );
        if ( ws_Adjust )
            MyFPrintf( file, "    DC.L    WA_AutoAdjust,1\n" );

        MyFPrintf( file, "    DC.L    TAG_DONE\n\n" );
    } else {
        if ( MyTagInArray( WA_Left, nwTags ))
            MyFPrintf( file, "    DC.L    $%08lx,%ld\n", WA_Left, GetTagData( WA_Left, 0l, nwTags ));
        if ( MyTagInArray( WA_Top, nwTags ))
            MyFPrintf( file, "    DC.L    $%08lx,%ld\n", WA_Top, GetTagData( WA_Top, 0l, nwTags ));
        if ( ws_InnerW )
            MyFPrintf( file, "    DC.L    $%08lx,%ld\n", WA_InnerWidth, ws_IWidth );
        else
            MyFPrintf( file, "    DC.L    $%08lx,%ld\n", WA_Width, MainWindow->Width);
        if ( ws_InnerH )
            MyFPrintf( file, "    DC.L    $%08lx,%ld\n", WA_InnerHeight, ws_IHeight );
        else
            MyFPrintf( file, "    DC.L    $%08lx,%ld\n", WA_Height, MainWindow->Height);
        if ( MyTagInArray( WA_DetailPen, nwTags ))
            MyFPrintf( file, "    DC.L    $%08lx,%ld\n", WA_DetailPen, GetTagData( WA_DetailPen, 0l, nwTags ));
        if ( MyTagInArray( WA_BlockPen, nwTags ))
            MyFPrintf( file, "    DC.L    $%08lx,%ld\n", WA_BlockPen, GetTagData( WA_BlockPen, 0l, nwTags ));
        GetGadgetIDCMP();
        MyFPrintf( file, "    DC.L    $%08lx,$%08lx\n", WA_IDCMP, WindowIDCMP|IDCMP_REFRESHWINDOW );
        if ( MyTagInArray( WA_Flags, nwTags ))
            MyFPrintf( file, "    DC.L    $%08lx,$%08lx\n", WA_Flags, WindowFlags );
        if ( Gadgets.gl_First->en_Next )
            MyFPrintf( file, "%sWG:\n    DC.L    $%08lx,0\n", &MainPrefs.pr_ProjectPrefix[0], WA_Gadgets );
        if ( strlen( MainWindowTitle ))
            MyFPrintf( file, "    DC.L    $%08lx,%sWTitle\n", WA_Title, &MainPrefs.pr_ProjectPrefix[0] );
        if ( strlen( MainScreenTitle ))
            MyFPrintf( file, "    DC.L    $%08lx,%sSTitle\n", WA_ScreenTitle, &MainPrefs.pr_ProjectPrefix[0] );
        if ( cs_ScreenType ) {
            if ( cs_ScreenType == 2 )
                MyFPrintf( file, "%sSC:\n    DC.L    $%08lx,0\n", &MainPrefs.pr_ProjectPrefix[0], WA_CustomScreen );
            if ( cs_ScreenType == 1 )
                MyFPrintf( file, "%sSC:\n    DC.L    $%08lx,0\n", &MainPrefs.pr_ProjectPrefix[0], WA_PubScreen );
        }
        if ( MyTagInArray( WA_MinWidth, nwTags ))
            MyFPrintf( file, "    DC.L    $%08lx,%ld\n", WA_MinWidth, GetTagData( WA_MinWidth, 0l, nwTags ));
        if ( MyTagInArray( WA_MinHeight, nwTags ))
            MyFPrintf( file, "    DC.L    $%08lx,%ld\n", WA_MinHeight, GetTagData( WA_MinHeight, 0l, nwTags ));
        if ( MyTagInArray( WA_MaxWidth, nwTags ))
            MyFPrintf( file, "    DC.L    $%08lx,%ld\n", WA_MaxWidth, GetTagData( WA_MaxWidth, 0l, nwTags ));
        if ( MyTagInArray( WA_MaxHeight, nwTags ))
            MyFPrintf( file, "    DC.L    $%08lx,%ld\n", WA_MaxHeight, GetTagData( WA_MaxHeight, 0l, nwTags ));
        if ( ws_ZoomF )
            MyFPrintf( file, "    DC.L    $%08lx,%sZoom\n", WA_Zoom, &MainPrefs.pr_ProjectPrefix[0] );
        if ( ws_MQueue )
            MyFPrintf( file, "    DC.L    $%08lx,%ld\n", WA_MouseQueue, ws_MQue);
        if ( ws_RQueue )
            MyFPrintf( file, "    DC.L    $%08lx,%ld\n", WA_RptQueue, ws_RQue );
        if ( ws_Adjust )
            MyFPrintf( file, "    DC.L    $%08lx,1\n", WA_AutoAdjust );

        MyFPrintf( file, "    DC.L    $%08lx\n\n", TAG_DONE );
    }

    if ( strlen( MainWindowTitle ))
        MyFPrintf( file, "%sWTitle:\n    DC.B    '%s',0\n    CNOP    0,2\n\n", &MainPrefs.pr_ProjectPrefix[0], &MainWindowTitle[0] );
    if ( strlen( MainScreenTitle ))
        MyFPrintf( file, "%sSTitle:\n    DC.B    '%s',0\n    CNOP    0,2\n\n", &MainPrefs.pr_ProjectPrefix[0], &MainScreenTitle[0] );
}

/*
 * --- Write the Screen Tags and screen specific data.
 */
void WriteAsmSTags( BPTR file )
{
    UWORD           cnt;
    UBYTE           fname[32], *ptr;

    strcpy( fname, MainFontName );

    ptr = strchr( fname, '.' );
    *ptr = 0;

    MyFPrintf( file, "%sScreenColors:\n", &MainPrefs.pr_ProjectPrefix[0] );

    for ( cnt = 0; cnt < 33; cnt++ ) {
        if ( MainColors[ cnt ].ColorIndex != ~0 )
            MyFPrintf( file, "    DC.W    %-2.2ld,$%02lx,$%02lx,$%02lx\n", MainColors[ cnt ].ColorIndex, MainColors[ cnt ].Red, MainColors[ cnt ].Green, MainColors[ cnt ].Blue );
        else {
            MyFPrintf( file, "    DC.W    $FFFF,$00,$00,$00\n\n" );
            break;
        }
    }

    MyFPrintf( file, "%sDriPens:\n    DC.W    ", &MainPrefs.pr_ProjectPrefix[0] );

    for ( cnt = 0; cnt < NUMDRIPENS + 1; cnt++ ) {
        if ( MainDriPen[ cnt ] != ~0 )
            MyFPrintf( file, "%ld,", MainDriPen[ cnt ] );
        else {
            MyFPrintf( file, "$FFFF\n\n" );
            break;
        }
    }

    MyFPrintf( file, "%sScreenTags:\n", &MainPrefs.pr_ProjectPrefix[0] );

    if ( NRAW ) {
        if ( MyTagInArray( SA_Left, MainSTags ))
            MyFPrintf( file, "    DC.L    SA_Left,%ld\n", GetTagData( SA_Left, 0l, MainSTags ));
        if ( MyTagInArray( SA_Top, MainSTags ))
            MyFPrintf( file, "    DC.L    SA_Top,%ld\n", GetTagData( SA_Top, 0l, MainSTags ));
        if ( MyTagInArray( SA_Width, MainSTags ))
            MyFPrintf( file, "    DC.L    SA_Width,%ld\n", GetTagData( SA_Width, 0l, MainSTags ));
        if ( MyTagInArray( SA_Height, MainSTags ))
            MyFPrintf( file, "    DC.L    SA_Height,%ld\n", GetTagData( SA_Height, 0l, MainSTags ));
        if ( MyTagInArray( SA_Depth, MainSTags ))
            MyFPrintf( file, "    DC.L    SA_Depth,%ld\n", GetTagData( SA_Depth, 0l, MainSTags ));
        if ( MyTagInArray( SA_DetailPen, MainSTags ))
            MyFPrintf( file, "    DC.L    SA_DetailPen,%ld\n", GetTagData( SA_DetailPen, 0l, MainSTags ));
        if ( MyTagInArray( SA_BlockPen, MainSTags ))
            MyFPrintf( file, "    DC.L    SA_BlockPen,%ld\n", GetTagData( SA_BlockPen, 0l, MainSTags ));
        if ( MyTagInArray( SA_Colors, MainSTags ))
            MyFPrintf( file, "    DC.L    SA_Colors,%sScreenColors\n", &MainPrefs.pr_ProjectPrefix[0] );
        if ( MyTagInArray( SA_Font, MainSTags ))
            MyFPrintf( file, "    DC.L    SA_Font,%s%ld\n", fname, MainFont.ta_YSize );
        MyFPrintf( file, "    DC.L    SA_Type,CUSTOMSCREEN\n" );
        if ( MyTagInArray( SA_DisplayID, MainSTags )) {
            MyFPrintf( file, "    DC.L    SA_DisplayID," );
            WriteIDFlags( file, GetTagData( SA_DisplayID, 0l, MainSTags ), 1l);
            Seek( file, -2l, OFFSET_CURRENT );
            MyFPrintf( file, "\n" );
        }
        if ( cs_AutoScroll )
            MyFPrintf( file, "    DC.L    SA_AutoScroll,1\n" );
        if ( MyTagInArray( SA_Pens, MainSTags ))
            MyFPrintf( file, "    DC.L    SA_Pens,%sDriPens\n", &MainPrefs.pr_ProjectPrefix[0] );

        MyFPrintf( file, "    DC.L    TAG_DONE\n\n" );
    } else {
        if ( MyTagInArray( SA_Left, MainSTags ))
            MyFPrintf( file, "    DC.L    $%08lx,%ld\n", SA_Left, GetTagData( SA_Left, 0l, MainSTags ));
        if ( MyTagInArray( SA_Top, MainSTags ))
            MyFPrintf( file, "    DC.L    $%08lx,%ld\n", SA_Top, GetTagData( SA_Top, 0l, MainSTags ));
        if ( MyTagInArray( SA_Width, MainSTags ))
            MyFPrintf( file, "    DC.L    $%08lx,%ld\n", SA_Width, GetTagData( SA_Width, 0l, MainSTags ));
        if ( MyTagInArray( SA_Height, MainSTags ))
            MyFPrintf( file, "    DC.L    $%08lx,%ld\n", SA_Height, GetTagData( SA_Height, 0l, MainSTags ));
        if ( MyTagInArray( SA_Depth, MainSTags ))
            MyFPrintf( file, "    DC.L    $%08lx,%ld\n", SA_Depth, GetTagData( SA_Depth, 0l, MainSTags ));
        if ( MyTagInArray( SA_DetailPen, MainSTags ))
            MyFPrintf( file, "    DC.L    $%08lx,%ld\n", SA_DetailPen, GetTagData( SA_DetailPen, 0l, MainSTags ));
        if ( MyTagInArray( SA_BlockPen, MainSTags ))
            MyFPrintf( file, "    DC.L    $%08lx,%ld\n", SA_BlockPen, GetTagData( SA_BlockPen, 0l, MainSTags ));
        if ( MyTagInArray( SA_Colors, MainSTags ))
            MyFPrintf( file, "    DC.L    $%08lx,%sScreenColors\n", SA_Colors, &MainPrefs.pr_ProjectPrefix[0] );
        if ( MyTagInArray( SA_Font, MainSTags ))
            MyFPrintf( file, "    DC.L    $%08lx,%s%ld\n", SA_Font, fname, MainFont.ta_YSize );
        MyFPrintf( file, "    DC.L    $%08lx,$%04lx\n", SA_Type, CUSTOMSCREEN );
        if ( MyTagInArray( SA_DisplayID, MainSTags ))
            MyFPrintf( file, "    DC.L    $%08lx,$%08lx\n", SA_DisplayID, GetTagData( SA_DisplayID, 0l, MainSTags ));
        if ( cs_AutoScroll )
            MyFPrintf( file, "    DC.L    $%08lx,1\n", SA_AutoScroll );
        if ( MyTagInArray( SA_Pens, MainSTags ))
            MyFPrintf( file, "    DC.L    $%08lx,%sDriPens\n", SA_Pens, &MainPrefs.pr_ProjectPrefix[0] );

        MyFPrintf( file, "    DC.L    $%08lx\n\n", TAG_DONE );
    }
}

/*
 * --- Write the C IntuiText structures.
 */
void WriteAsmIText( BPTR file )
{
    struct IntuiText   *t;
    UWORD               i = 0;
    UBYTE               fname[32], *ptr;

    strcpy( fname, MainFontName );

    ptr = strchr( fname, '.' );
    *ptr = 0;

    if ( NOT( t = WindowTxt )) return;

    while ( t ) {
        MyFPrintf( file, "%sText%ld:\n", &MainPrefs.pr_ProjectPrefix[0], i );
        MyFPrintf( file, "    DC.B    %ld,%ld\n", t->FrontPen, t->BackPen );
        if ( NRAW ) {
            MyFPrintf( file, "    DC.B    " );
            WriteCDrMd( file, t->DrawMode, 1l );
            Seek( file, -2l, OFFSET_CURRENT );
            MyFPrintf( file, "\n" );
        } else
            MyFPrintf( file, "    DC.B    $%02lx\n", t->DrawMode );
        MyFPrintf( file, "    DC.B    0\n    DC.W    %ld,%ld\n", t->LeftEdge, t->TopEdge );
        MyFPrintf( file, "    DC.L    %s%ld\n", fname, MainFont.ta_YSize );
        MyFPrintf( file, "    DC.L    %sIText%ld\n", &MainPrefs.pr_ProjectPrefix[0], i );

        if ( t->NextText )
            MyFPrintf( file, "    DC.L    %sText%ld\n\n", &MainPrefs.pr_ProjectPrefix[0], i + 1 );
        else
            MyFPrintf( file, "    DC.L    0\n\n" );

        MyFPrintf( file, "%sIText%ld:\n    DC.B    '%s',0\n    CNOP    0,2\n\n", &MainPrefs.pr_ProjectPrefix[0], i, t->IText );

        i++;
        t = t->NextText;
    }
}

/*
 * --- Write the C Gadgets initialization.
 */
void WriteAsmGadgets( BPTR file )
{
    struct ExtNewGadget *g, *pred;
    struct NewGadget    *ng, *ngp;

    for ( g = Gadgets.gl_First; g->en_Next; g = g->en_Next ) {
        if (( pred = g->en_Prev ) == ( struct ExtNewGadget * )&Gadgets ) {
            pred = 0l;
            ngp  = 0l;
        } else
            ngp = &pred->en_NewGadget;

        ng = &g->en_NewGadget;

        if ( NRAW ) {
            if ( ngp ) {
                if ( g->en_Kind != STRING_KIND ) {
                    if ( ng->ng_LeftEdge != ngp->ng_LeftEdge )
                        MyFPrintf( file, "    move.w  #%ld,gng_LeftEdge(a1)\n", ng->ng_LeftEdge );
                    if ( ng->ng_TopEdge  != ngp->ng_TopEdge )
                        MyFPrintf( file, "    move.w  #%ld,gng_TopEdge(a1)\n", ng->ng_TopEdge );
                } else {
                    if (( g->en_SpecialFlags & EGF_ISLOCKED ) != EGF_ISLOCKED ) {
                        if ( ng->ng_LeftEdge != ngp->ng_LeftEdge )
                            MyFPrintf( file, "    move.w  #%ld,gng_LeftEdge(a1)\n", ng->ng_LeftEdge );
                        if ( ng->ng_TopEdge  != ngp->ng_TopEdge )
                            MyFPrintf( file, "    move.w  #%ld,gng_TopEdge(a1)\n", ng->ng_TopEdge );
                    }
                }

                if ( g->en_Kind != MX_KIND && g->en_Kind != CHECKBOX_KIND ) {
                    if ( ng->ng_Width != ngp->ng_Width )
                        MyFPrintf( file, "    move.w  #%ld,gng_Width(a1)\n", ng->ng_Width );
                    if ( ng->ng_Height != ngp->ng_Height )
                        MyFPrintf( file, "    move.w  #%ld,gng_Height(a1)\n", ng->ng_Height );
                }
                if ( ng->ng_GadgetText ) {
                    if ( strcmp( ng->ng_GadgetText, ngp->ng_GadgetText ))
                        MyFPrintf( file, "    move.l  #%sText,gng_GadgetText(a1)\n", &g->en_SourceLabel[0] );
                } else
                        MyFPrintf( file, "    move.l  #0,gng_GadgetText(a1)\n" );
                MyFPrintf( file, "    move.w  #GD_%s,gng_GadgetID(a1)\n", &g->en_SourceLabel[0] );
                if ( ng->ng_Flags != ngp->ng_Flags ) {
                    MyFPrintf( file, "    move.l  #" );
                    WritePlaceFlags( file, (long)ng->ng_Flags, 1l );
                    Seek( file, -2, OFFSET_CURRENT );
                    MyFPrintf( file, ",gng_Flags(a1)\n" );
                }
            } else {
                MyFPrintf( file, "    move.w  #%ld,gng_LeftEdge(a1)\n", ng->ng_LeftEdge );
                MyFPrintf( file, "    move.w  #%ld,gng_TopEdge(a1)\n", ng->ng_TopEdge );
                MyFPrintf( file, "    move.w  #%ld,gng_Width(a1)\n", ng->ng_Width );
                MyFPrintf( file, "    move.w  #%ld,gng_Height(a1)\n", ng->ng_Height );
                if ( ng->ng_GadgetText )
                    MyFPrintf( file, "    move.l  #%sText,gng_GadgetText(a1)\n", &g->en_SourceLabel[0] );
                else
                    MyFPrintf( file, "    move.l  #0,gng_GadgetText(a1)\n" );
                MyFPrintf( file, "    move.w  #GD_%s,gng_GadgetID(a1)\n", &g->en_SourceLabel[0] );
                MyFPrintf( file, "    move.l  #" );
                WritePlaceFlags( file, ng->ng_Flags, 1l );
                Seek( file, -2l, OFFSET_CURRENT );
                MyFPrintf( file, ",gng_Flags(a1)\n" );
            }
        } else {
            if ( ngp ) {
                if ( g->en_Kind != STRING_KIND ) {
                    if ( ng->ng_LeftEdge != ngp->ng_LeftEdge )
                        MyFPrintf( file, "    move.w  #%ld,(a1)\n", ng->ng_LeftEdge );
                    if ( ng->ng_TopEdge  != ngp->ng_TopEdge )
                        MyFPrintf( file, "    move.w  #%ld,2(a1)\n", ng->ng_TopEdge );
                } else {
                    if (( g->en_SpecialFlags & EGF_ISLOCKED ) != EGF_ISLOCKED ) {
                        if ( ng->ng_LeftEdge != ngp->ng_LeftEdge )
                            MyFPrintf( file, "    move.w  #%ld,(a1)\n", ng->ng_LeftEdge );
                        if ( ng->ng_TopEdge  != ngp->ng_TopEdge )
                            MyFPrintf( file, "    move.w  #%ld,2(a1)\n", ng->ng_TopEdge );
                    }
                }

                if ( g->en_Kind != MX_KIND && g->en_Kind != CHECKBOX_KIND ) {
                    if ( ng->ng_Width != ngp->ng_Width )
                        MyFPrintf( file, "    move.w  #%ld,4(a1)\n", ng->ng_Width );
                    if ( ng->ng_Height != ngp->ng_Height )
                        MyFPrintf( file, "    move.w  #%ld,6(a1)\n", ng->ng_Height );
                }
                if ( ng->ng_GadgetText ) {
                    if ( strcmp( ng->ng_GadgetText, ngp->ng_GadgetText ))
                        MyFPrintf( file, "    move.l  #%sText,8(a1)\n", &g->en_SourceLabel[0] );
                } else
                        MyFPrintf( file, "    move.l  #0,8(a1)\n" );
                MyFPrintf( file, "    move.w  #GD_%s,16(a1)\n", &g->en_SourceLabel[0] );
                if ( ng->ng_Flags != ngp->ng_Flags )
                    MyFPrintf( file, "    move.l  #$%08lx,18(a1)\n", ng->ng_Flags );
            } else {
                MyFPrintf( file, "    move.w  #%ld,(a1)\n", ng->ng_LeftEdge );
                MyFPrintf( file, "    move.w  #%ld,2(a1)\n", ng->ng_TopEdge );
                MyFPrintf( file, "    move.w  #%ld,4(a1)\n", ng->ng_Width );
                MyFPrintf( file, "    move.w  #%ld,6(a1)\n", ng->ng_Height );
                if ( ng->ng_GadgetText )
                    MyFPrintf( file, "    move.l  #%sText,8(a1)\n", &g->en_SourceLabel[0] );
                else
                    MyFPrintf( file, "    move.l  #0,8(a1)\n" );
                MyFPrintf( file, "    move.w  #GD_%s,16(a1)\n", &g->en_SourceLabel[0] );
                MyFPrintf( file, "    move.l  #$%08lx,18(a1)\n", ng->ng_Flags );
            }
        }

        MyFPrintf( file, "    move.l  #%ld,d0\n", g->en_Kind );
        MyFPrintf( file, "    lea.l   %sTags,a2\n", &g->en_SourceLabel[0] );
        MyFPrintf( file, "    jsr     CreateGadgetA(a6)\n" );

        if ( g != Gadgets.gl_Last ) {
            MyFPrintf( file, "    move.l  d0,a0\n" );
            MyFPrintf( file, "    lea.l   %sBufNewGad,a1\n", &MainPrefs.pr_ProjectPrefix[0] );
        }
    }
}

/*
 * --- Write the Assembler cleanup routine.
 */
void WriteAsmCleanup( BPTR file )
{
    MyFPrintf( file, "%sCleanStuff:\n", &MainPrefs.pr_ProjectPrefix[0] );
    MyFPrintf( file, "    movem.l d0-d7/a0-a6,-(sp)\n" );
    if ( ExtMenus.ml_First->em_Next ) {
        MyFPrintf( file, "    move.l   _IntuitionBase,a6\n" );
        MyFPrintf( file, "    move.l   %sMenus,a0\n", &MainPrefs.pr_ProjectPrefix[0] );
        MyFPrintf( file, "    cmpa.l   #0,a0\n" );
        MyFPrintf( file, "    beq      %sNMenu\n", &MainPrefs.pr_ProjectPrefix[0] );
        MyFPrintf( file, "    move.l   %sWnd,a0\n", &MainPrefs.pr_ProjectPrefix[0] );
        MyFPrintf( file, "    jsr      ClearMenuStrip(a6)\n" );
        MyFPrintf( file, "    move.l   _GadToolsBase,a6\n"  );
        MyFPrintf( file, "    move.l   %sMenus,a0\n", &MainPrefs.pr_ProjectPrefix[0] );
        MyFPrintf( file, "    jsr      FreeMenus(a6)\n" );
        MyFPrintf( file, "%sNMenu:\n", &MainPrefs.pr_ProjectPrefix[0] );
    }
    MyFPrintf( file, "    move.l  _IntuitionBase,a6\n" );
    MyFPrintf( file, "    move.l  %sWnd,a0\n", &MainPrefs.pr_ProjectPrefix[0] );
    MyFPrintf( file, "    cmpa.l  #0,a0\n" );
    MyFPrintf( file, "    beq     %sNWnd\n", &MainPrefs.pr_ProjectPrefix[0] );
    MyFPrintf( file, "    jsr     CloseWindow(a6)\n" );
    MyFPrintf( file, "%sNWnd:\n", &MainPrefs.pr_ProjectPrefix[0] );
    if ( Gadgets.gl_First->en_Next ) {
        MyFPrintf( file, "    move.l  _GadToolsBase,a6\n" );
        MyFPrintf( file, "    move.l  %sGList,a0\n", &MainPrefs.pr_ProjectPrefix[0] );
        MyFPrintf( file, "    cmpa.l  #0,a0\n" );
        MyFPrintf( file, "    beq     %sNGad\n", &MainPrefs.pr_ProjectPrefix[0] );
        MyFPrintf( file, "    jsr     FreeGadgets(a6)\n" );
        MyFPrintf( file, "%sNGad:\n", &MainPrefs.pr_ProjectPrefix[0] );
    } else MyFPrintf( file, "    move.l  _GadToolsBase,a6\n" );

    MyFPrintf( file, "    move.l  %sVisualInfo,a0\n", &MainPrefs.pr_ProjectPrefix[0] );
    MyFPrintf( file, "    cmpa.l  #0,a0\n" );
    MyFPrintf( file, "    beq     %sNVis\n", &MainPrefs.pr_ProjectPrefix[0] );
    MyFPrintf( file, "    jsr     FreeVisualInfo(a6)\n" );
    MyFPrintf( file, "%sNVis:\n", &MainPrefs.pr_ProjectPrefix[0] );
    MyFPrintf( file, "    move.l  _IntuitionBase,a6\n" );
    if ( cs_ScreenType == 2 ) {
        MyFPrintf( file, "    move.l  %sScr,a0\n", &MainPrefs.pr_ProjectPrefix[0] );
        MyFPrintf( file, "    cmpa.l  #0,a0\n" );
        MyFPrintf( file, "    beq     %sNScr\n", &MainPrefs.pr_ProjectPrefix[0] );
        MyFPrintf( file, "    jsr     CloseScreen(a6)\n" );
    } else  {
        MyFPrintf( file, "    suba.l  a0,a0\n" );
        MyFPrintf( file, "    move.l  %sScr,a1\n", &MainPrefs.pr_ProjectPrefix[0] );
        MyFPrintf( file, "    cmpa.l  #0,a1\n" );
        MyFPrintf( file, "    beq     %sNScr\n", &MainPrefs.pr_ProjectPrefix[0] );
        MyFPrintf( file, "    jsr     UnlockPubScreen(a6)\n" );
    }
    MyFPrintf( file, "%sNScr:\n", &MainPrefs.pr_ProjectPrefix[0] );
    MyFPrintf( file, "    movem.l (sp)+,d0-d7/a0-a6\n    rts\n" );
}

/*
 * --- Write the Assembler Source file.
 */
long WriteAsmSource( void )
{
    BPTR                file = 0l;
    UBYTE                fname[32], *ptr;

    strcpy( fname, MainFontName );

    ptr  = strchr( fname, '.' );
    *ptr = 0;

    if ( ga_GenA = AllocAslRequest( ASL_FileRequest, TAG_DONE )) {
        ga_ATags[1].ti_Data = (ULONG)MainWindow;
        if ( AslRequest( ga_GenA, ga_ATags )) {

            strcpy( MainFileName, ga_GenA->rf_Dir );
            CheckDirExtension();
            strcat( MainFileName, ga_GenA->rf_File );

            strcpy( ga_APath, ga_GenA->rf_Dir );
            strcpy( ga_AFile, ga_GenA->rf_File );
            strcpy( ga_APatt, ga_GenA->rf_Pat );

            if ( file = MyOpen( MODE_NEWFILE )) {

                SetTitle( "Saving Assembly Source..." );

                SetIoErr( 0l );

                MyFPrintf( file, "*\n*  Source generated with GadToolsBox V1.0\n" );
                MyFPrintf( file, "*  which is (c) Copyright 1991 Jaba Development\n" );
                MyFPrintf( file, "*\n\n" );

                if ( NRAW )  {
                    MyFPrintf( file, "    include 'exec/types.i'\n    include 'intuition/intuition.i'\n" );
                    MyFPrintf( file, "    include 'intuition/gadgetclass.i'\n    include 'libraries/gadtools.i'\n" );
                    MyFPrintf( file, "    include 'graphics/displayinfo.i'\n\n" );
                }

                MyFPrintf( file, "    XREF    _GadToolsBase\n    XREF    _IntuitionBase\n\n" );
                MyFPrintf( file, "OpenScreenTagList    EQU    -612\n" );
                MyFPrintf( file, "OpenWindowTagList    EQU    -606\n" );
                MyFPrintf( file, "CloseScreen          EQU    -66\n" );
                MyFPrintf( file, "CloseWindow          EQU    -72\n" );
                MyFPrintf( file, "PrintIText           EQU    -216\n" );
                MyFPrintf( file, "LockPubScreen        EQU    -510\n" );
                MyFPrintf( file, "UnlockPubScreen      EQU    -516\n" );
                MyFPrintf( file, "SetMenuStrip         EQU    -264\n" );
                MyFPrintf( file, "ClearMenuStrip       EQU    -54\n" );
                MyFPrintf( file, "GetVisualInfoA       EQU    -126\n" );
                MyFPrintf( file, "FreeVisualInfo       EQU    -132\n" );
                MyFPrintf( file, "CreateContext        EQU    -114\n" );
                MyFPrintf( file, "CreateGadgetA        EQU    -30\n" );
                MyFPrintf( file, "GT_RefreshWindow     EQU    -84\n" );
                MyFPrintf( file, "FreeGadgets          EQU    -36\n" );
                MyFPrintf( file, "CreateMenusA         EQU    -48\n" );
                MyFPrintf( file, "LayoutMenusA         EQU    -66\n" );
                MyFPrintf( file, "FreeMenus            EQU    -54\n\n" );

                WriteAsmID( file );

                if ( NSTAT )
                    WriteAsmXdef( file );

                WriteAsmGlob( file);
                WriteAsmGadgetTags( file );
                WriteAsmGText( file );
                WriteAsmLabels( file );
                WriteAsmList( file );
                WriteAsmTextAttr( file );
                WriteAsmWTags( file );

                if ( cs_ScreenType == 2 )
                    WriteAsmSTags( file );

                WriteAsmIText( file );
                if ( ExtMenus.ml_First->em_Next )
                    WriteAsmMenus( file  );

                MyFPrintf( file, "%sInitStuff:\n", &MainPrefs.pr_ProjectPrefix[0] );
                MyFPrintf( file, "    movem.l d1-d7/a0-a6,-(sp)\n" );
                MyFPrintf( file, "    move.l  _IntuitionBase,a6\n" );

                if ( NOT cs_ScreenType ) {
                    MyFPrintf( file, "    lea.l   %sWB,a0\n", &MainPrefs.pr_ProjectPrefix[0] );
                    MyFPrintf( file, "    jsr     LockPubScreen(a6)\n" );
                    MyFPrintf( file, "    move.l  d0,%sScr\n", &MainPrefs.pr_ProjectPrefix[0] );
                    MyFPrintf( file, "    beq     %sSError\n", &MainPrefs.pr_ProjectPrefix[0] );
                } else if ( cs_ScreenType == 1 ) {
                    MyFPrintf( file, "    suba.l  a0,a0\n", &MainPrefs.pr_ProjectPrefix[0] );
                    MyFPrintf( file, "    jsr     LockPubScreen(a6)\n" );
                    MyFPrintf( file, "    move.l  d0,%sScr\n", &MainPrefs.pr_ProjectPrefix[0] );
                    MyFPrintf( file, "    beq     %sSError\n", &MainPrefs.pr_ProjectPrefix[0] );
                    MyFPrintf( file, "    move.l  d0,%sSC+4\n", &MainPrefs.pr_ProjectPrefix[0] );
                } else {
                    MyFPrintf( file, "    suba.l  a0,a0\n" );
                    MyFPrintf( file, "    lea.l   %sScreenTags,a1\n", &MainPrefs.pr_ProjectPrefix[0] );
                    MyFPrintf( file, "    jsr     OpenScreenTagList(a6)\n" );
                    MyFPrintf( file, "    move.l  d0,%sScr\n", &MainPrefs.pr_ProjectPrefix[0] );
                    MyFPrintf( file, "    beq     %sSError\n", &MainPrefs.pr_ProjectPrefix[0] );
                    MyFPrintf( file, "    move.l  d0,%sSC+4\n", &MainPrefs.pr_ProjectPrefix[0] );
                }

                MyFPrintf( file, "    move.l  _GadToolsBase,a6\n" );
                MyFPrintf( file, "    move.l  %sScr,a0\n", &MainPrefs.pr_ProjectPrefix[0] );
                MyFPrintf( file, "    lea.l   %sTD,a1\n", &MainPrefs.pr_ProjectPrefix[0] );
                MyFPrintf( file, "    jsr     GetVisualInfoA(a6)\n" );
                MyFPrintf( file, "    move.l  d0,%sVisualInfo\n", &MainPrefs.pr_ProjectPrefix[0] );
                MyFPrintf( file, "    beq     %sVError\n", &MainPrefs.pr_ProjectPrefix[0] );

                if ( Gadgets.gl_First->en_Next ) {
                    MyFPrintf( file, "    lea.l   %sGList,a0\n", &MainPrefs.pr_ProjectPrefix[0] );
                    MyFPrintf( file, "    jsr     CreateContext(a6)\n" );
                    MyFPrintf( file, "    move.l  d0,a0\n" );
                    MyFPrintf( file, "    beq     %sCError\n", &MainPrefs.pr_ProjectPrefix[0] );

                    MyFPrintf( file, "    lea.l   %sBufNewGad,a1\n", &MainPrefs.pr_ProjectPrefix[0] );

                    if ( NRAW ) {
                        MyFPrintf( file, "    move.l  %sVisualInfo,gng_VisualInfo(a1)\n", &MainPrefs.pr_ProjectPrefix[0] );
                        MyFPrintf( file, "    move.l  #%s%ld,gng_TextAttr(a1)\n", fname, MainFont.ta_YSize );
                    } else {
                        MyFPrintf( file, "    move.l  %sVisualInfo,22(a1)\n", &MainPrefs.pr_ProjectPrefix[0] );
                        MyFPrintf( file, "    move.l  #%s%ld,12(a1)\n", fname, MainFont.ta_YSize );
                    }

                    WriteAsmGadgets( file );

                    MyFPrintf( file, "    tst.l   d0\n" );
                    MyFPrintf( file, "    beq     %sGError\n", &MainPrefs.pr_ProjectPrefix[0] );
                    MyFPrintf( file, "    move.l  %sGList,%sWG+4\n", &MainPrefs.pr_ProjectPrefix[0], &MainPrefs.pr_ProjectPrefix[0] );
                }

                if ( ExtMenus.ml_First->em_Next ) {
                    MyFPrintf( file, "    lea.l   %sNewMenu0,a0\n", &MainPrefs.pr_ProjectPrefix[0] );
                    MyFPrintf( file, "    lea.l   %sMTags0,a1\n", &MainPrefs.pr_ProjectPrefix[0] );
                    MyFPrintf( file, "    jsr     CreateMenusA(a6)\n" );
                    MyFPrintf( file, "    move.l  d0,%sMenus\n", &MainPrefs.pr_ProjectPrefix[0] );
                    MyFPrintf( file, "    beq     %sMError\n", &MainPrefs.pr_ProjectPrefix[0] );
                    MyFPrintf( file, "    move.l  d0,a0\n" );
                    MyFPrintf( file, "    move.l  %sVisualInfo,a1\n", &MainPrefs.pr_ProjectPrefix[0] );
                    MyFPrintf( file, "    lea.l   %sMTags1,a2\n", &MainPrefs.pr_ProjectPrefix[0] );
                    MyFPrintf( file, "    jsr     LayoutMenusA(a6)\n" );
                }

                MyFPrintf( file, "    move.l  _IntuitionBase,a6\n" );
                MyFPrintf( file, "    suba.l  a0,a0\n" );
                MyFPrintf( file, "    lea.l   %sWindowTags,a1\n", &MainPrefs.pr_ProjectPrefix[0] );
                MyFPrintf( file, "    jsr     OpenWindowTagList(a6)\n" );
                MyFPrintf( file, "    move.l  d0,%sWnd\n", &MainPrefs.pr_ProjectPrefix[0] );
                MyFPrintf( file, "    beq     %sWError\n", &MainPrefs.pr_ProjectPrefix[0] );

                if ( ExtMenus.ml_First->em_Next ) {
                    MyFPrintf( file, "    move.l   %sWnd,a0\n", &MainPrefs.pr_ProjectPrefix[0] );
                    MyFPrintf( file, "    move.l   %sMenus,a1\n", &MainPrefs.pr_ProjectPrefix[0] );
                    MyFPrintf( file, "    jsr      SetMenuStrip(a6)\n" );
                }

                MyFPrintf( file, "    move.l  _GadToolsBase,a6\n" );
                MyFPrintf( file, "    move.l  %sWnd,a0\n", &MainPrefs.pr_ProjectPrefix[0] );
                MyFPrintf( file, "    suba.l  a1,a1\n" );
                MyFPrintf( file, "    jsr     GT_RefreshWindow(a6)\n" );

                if ( ws_ZoomF ) {
                    MyFPrintf( file, "    move.w  #%ld,%sZoom\n", MainWindow->LeftEdge, &MainPrefs.pr_ProjectPrefix[0] );
                    MyFPrintf( file, "    move.w  #%ld,%sZoom+2\n", MainWindow->TopEdge, &MainPrefs.pr_ProjectPrefix[0] );
                    MyFPrintf( file, "    move.w  #%ld,%sZoom+4\n", MainWindow->Width, &MainPrefs.pr_ProjectPrefix[0] );
                    MyFPrintf( file, "    move.w  #%ld,%sZoom+6\n", MainWindow->Height, &MainPrefs.pr_ProjectPrefix[0] );
                }

                if ( WindowTxt ) {
                    MyFPrintf( file, "    move.l  _IntuitionBase,a6\n" );
                    MyFPrintf( file, "    move.l  %sWnd,a0\n", &MainPrefs.pr_ProjectPrefix[0] );
                    if ( NRAW )
                        MyFPrintf( file, "    move.l  wd_RPort(a0),a0\n" );
                    else
                        MyFPrintf( file, "    move.l  50(a0),a0\n" );
                    MyFPrintf( file, "    lea.l   %sText0,a1\n", &MainPrefs.pr_ProjectPrefix[0] );
                    MyFPrintf( file, "    moveq   #0,d0\n" );
                    MyFPrintf( file, "    moveq   #0,d1\n" );
                    MyFPrintf( file, "    jsr     PrintIText(a6)\n" );
                }

                MyFPrintf( file, "    moveq   #0,d0\n" );
                MyFPrintf( file, "%sDone:\n    movem.l (sp)+,d1-d7/a0-a6\n    rts\n", &MainPrefs.pr_ProjectPrefix[0] );

                MyFPrintf( file, "%sSError:\n    moveq   #1,d0\n    bra.s   %sDone\n", &MainPrefs.pr_ProjectPrefix[0], &MainPrefs.pr_ProjectPrefix[0] );
                MyFPrintf( file, "%sVError:\n    moveq   #2,d0\n    bra.s   %sDone\n", &MainPrefs.pr_ProjectPrefix[0], &MainPrefs.pr_ProjectPrefix[0] );

                if ( Gadgets.gl_First->en_Next ) {
                    MyFPrintf( file, "%sCError:\n    moveq   #3,d0\n    bra.s   %sDone\n", &MainPrefs.pr_ProjectPrefix[0], &MainPrefs.pr_ProjectPrefix[0] );
                    MyFPrintf( file, "%sGError:\n    moveq   #4,d0\n    bra.s   %sDone\n", &MainPrefs.pr_ProjectPrefix[0], &MainPrefs.pr_ProjectPrefix[0] );
                }

                MyFPrintf( file, "%sWError:\n    moveq   #5,d0\n    bra.s   %sDone\n", &MainPrefs.pr_ProjectPrefix[0], &MainPrefs.pr_ProjectPrefix[0] );
                if ( ExtMenus.ml_First->em_Next )
                    MyFPrintf( file, "%sMError:\n    moveq   #6,d0\n    bra.s   %sDone\n", &MainPrefs.pr_ProjectPrefix[0], &MainPrefs.pr_ProjectPrefix[0] );

                MyFPrintf( file, "\n" );

                WriteAsmCleanup( file );

                MyFPrintf( file, "\n    end\n" );

                Close( file );

                file = 0l;

                if ( IoErr())
                    MyRequest( "Oh oh...", "CONTINUE", "Write Error !" );
            }
        }
    }

    SetWindowTitles( MainWindow, MainWindowTitle, MainScreenTitle );
    RefreshWindow();
    if ( file )     Close( file );
    if ( ga_GenA )  FreeAslRequest( ga_GenA );

    ga_GenA = 0l;

    ClearMsgPort( MainWindow->UserPort );
}
