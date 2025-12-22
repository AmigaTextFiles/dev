/****h* RAM:TP.c [1.0] ****************
*
* NAME
*    RAM:TP.c
*
* DESCRIPTION
* 
* SYNOPSIS 
*    TP is a GUI for....
*
* HISTORY
*    Oct-01-2003 - Created this file.
*
* COPYRIGHT
*    RAM:TP.c Oct-01-2003(C) by J.T. Steichen
*
* NOTES
*
*    $VER: RAM:TP.c 1.0 (Oct-01-2003) by J.T. Steichen
************************************************************************
*
*/

#include <stdio.h>
#include <string.h>

#include <exec/types.h>

#include <AmigaDOSErrs.h>

#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/imageclass.h>  // for Image Buttons only
#include <intuition/gadgetclass.h>

#include <libraries/gadtools.h>

#define USE_BOOPSI_IMAGE   1
#define USE_ASL_REQ        1


#ifdef USE_TOOLTYPES
# include <workbench/workbench.h>
# include <workbench/startup.h>
# include <workbench/icon.h>
#endif

#ifdef USE_ASL_REQ
# include <utility/tagitem.h>
# include <dos/dostags.h>
# include <libraries/asl.h>
#endif

#include <graphics/displayinfo.h>
#include <graphics/gfxbase.h>



#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/graphics_protos.h>
#include <clib/utility_protos.h>
#include <clib/diskfont_protos.h>

#include <proto/locale.h>

struct Catalog *catalog = NULL;

#define   CATCOMP_ARRAY    1
#include "TPLocale.h"

#define  MY_LANGUAGE "english"

#include "CPGM:GlobalObjects/CommonFuncs.h"

#define ID_TestBt                           0
#define ID_TestStr                          1
#define ID_TestChk                          2
#define ID_Test_LV                          3
#define ID_TestInt                          4
#define ID_TestTxt                          5
#define ID_TestNum                          6
#define ID_TestPal                          7
#define ID_TestCyc                          8
#define ID_TestSlr                          9
#define ID_Test_MX                          10
#define ID_TestScl                          11
#define ID_GFileBt                          12

#define TP_CNT              13


// ----------------------------------------------------

#ifdef USE_BOOPSI_IMAGE
IMPORT Class    *initGet( void ); // in Boopsi.o

struct IClass   *getClass = NULL;
struct _Object  *getImage = NULL;
#endif

#ifdef USE_TOOLTYPES

IMPORT  struct WBStartup  *_WBenchMsg;
PRIVATE struct DiskObject *diskobj = NULL;

struct Library *IconBase;

#endif

// ----------------------------------------------------

struct IntuitionBase *IntuitionBase;
struct GfxBase       *GfxBase;
struct Library       *GadToolsBase;
struct LocaleBase    *LocaleBase;

// ----------------------------------------------------

PRIVATE char v[] = "\0$VER: RAM:TP.c 1.0 " __AMIGADATE__ " by J.T. Steichen \0";

PRIVATE struct Screen *TPScr        = NULL;
PRIVATE UBYTE         *PubScreenName = "Workbench";
PRIVATE APTR           VisualInfo    = NULL;

PRIVATE struct TextFont     *TPFont = NULL;
PRIVATE struct TextAttr     *Font, Attr;
PRIVATE struct CompFont      CFont = { 0, };

PRIVATE struct Window       *TPWnd   = NULL;
PRIVATE struct Menu         *TPMenus = NULL;
PRIVATE struct Gadget       *TPGList = NULL;
PRIVATE struct Gadget       *TPGadgets[ TP_CNT ] = { 0, };

PRIVATE struct IntuiMessage  TPMsg = { 0, };

PRIVATE UWORD  TPLeft   = 143;
PRIVATE UWORD  TPTop    = 128;
PRIVATE UWORD  TPWidth  = 536;
PRIVATE UWORD  TPHeight = 413;
PRIVATE UBYTE *TPWdt    = NULL;   // WA_Title
PRIVATE UBYTE *ScrTitle = NULL;   // WA_ScreenTitle


#define Test_MX_CNT   3

PRIVATE UBYTE *MX_Test_MX11Lbls[] = {

   "Choice1",
   "Choice2",
   "Choice3",
   NULL
};

#define TestCyc_CNT   3

PRIVATE UBYTE *CY_TestCyc9Lbls[] = {

   "Select1",
   "Select2",
   "Select3",
   NULL
};

#define Test_LV_NUM_ELEMENTS  4
#define ELEMENT_SIZE     80

PRIVATE struct List         Test_LVList   = { 0, };
PRIVATE struct ListViewMem *Test_LV4_lvm = NULL;

#define Test_LV_CNT 4

PRIVATE UBYTE *LV_Test_LV4Lbls[] = {

   "Item1111",
   "Item222",
   "Item33",
   "Item4",
   NULL
};


PRIVATE struct TextAttr helvetica13 = { "helvetica.font", 13, 0x00, 0x62 };

// TTTTTTTTT RAM:TP.c ToolTypes: TTTTTTTTT

#ifdef USE_TOOLTYPES

PRIVATE char Tool1[32]     = "TOOL1";

PRIVATE char DefTool1[128] = "";

PRIVATE char *TTTool1      = &DefTool1[0];

#endif

// TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT

#ifdef USE_ASL_REQ

PRIVATE struct TagItem FileTags[] = {

   ASLFR_Window,          (ULONG) NULL,
   ASLFR_TitleText,       (ULONG) "Obtain a filename...",
   ASLFR_InitialHeight,   400,
   ASLFR_InitialWidth,    500,
   ASLFR_InitialTopEdge,  16,
   ASLFR_InitialLeftEdge, 100,
   ASLFR_PositiveText,    (ULONG) " OKAY! ",
   ASLFR_NegativeText,    (ULONG) " CANCEL! ",
   ASLFR_InitialPattern,  (ULONG) "#?",
   ASLFR_InitialFile,     (ULONG) "",
   ASLFR_InitialDrawer,   (ULONG) "RAM:",
   ASLFR_Flags1,          FRF_DOPATTERNS,
   ASLFR_Flags2,          FRF_REJECTICONS,
   ASLFR_SleepWindow,     1,
   ASLFR_PrivateIDCMP,    1,
   TAG_END 
};

#endif

PRIVATE int NewProjectMI( void );
PRIVATE int OpenPrjMI( void );
PRIVATE int ChkItem1MI( void );
PRIVATE int CheckItem2MI( void );

PRIVATE int Item0( void );

PRIVATE int SubItem1MI( void );
PRIVATE int SubItem2MI( void );
PRIVATE int DisabledItemMI( void );

PRIVATE struct NewMenu TPNMenu[ 14 ] = {

   NM_TITLE, "PROJECT", NULL, 0, 0L, NULL,

    NM_ITEM, "New...", "N", 0x0000, 0L, (APTR) NewProjectMI,

    NM_ITEM, "Open...", 0, 0x0000, 0L, (APTR) OpenPrjMI,

   NM_TITLE, "MENU2", NULL, 0, 0L, NULL,

    NM_ITEM, "CheckedItem1", 0, 0x0109, 0L, (APTR) ChkItem1MI,

    NM_ITEM, "CheckedItem2", 0, 0x0009, 0L, (APTR) CheckItem2MI,

    NM_ITEM, (STRPTR) NM_BARLABEL, NULL, 0, 0L, NULL,
    // ---------------------------------------------

    NM_ITEM, "Item3...", "3", 0x0000, 0L, (APTR) Item0,

   NM_TITLE, "MENU3", NULL, 0, 0L, NULL,

    NM_ITEM, "HaveSubs »", 0, 0x0000, 0L, (APTR) NULL,

     NM_SUB, "SubItem1", "S", 0x0000, 0L, (APTR) SubItem1MI,

     NM_SUB, "SubItem2", 0, 0x0000, 0L, (APTR) SubItem2MI,

    NM_ITEM, "DisabledItemCTEMPLATEFILE=AmigaTalk:GUIBuilder/GenC.template", "D", 0x0010, 0L, (APTR) DisabledItemMI,

   NM_END, NULL, NULL, 0, 0L, NULL

};


PRIVATE struct IntuiText TPIT = {

   2, 5, JAM2,  53, 390, NULL, "Some Test IntuiText", NULL
};


PRIVATE UWORD TPGTypes[13] = {

      BUTTON_KIND,      STRING_KIND,    CHECKBOX_KIND,
    LISTVIEW_KIND,     INTEGER_KIND,        TEXT_KIND,
      NUMBER_KIND,     PALETTE_KIND,       CYCLE_KIND,
      SLIDER_KIND,          MX_KIND,    SCROLLER_KIND,
     GENERIC_KIND,
};


PRIVATE int TestBtClicked( void );
PRIVATE int TestStrClicked( void );
PRIVATE int TestChkClicked( void );
PRIVATE int Test_LVClicked( void );
PRIVATE int TestIntClicked( void );
PRIVATE int TestTxtClicked( void );
PRIVATE int TestNumClicked( void );
PRIVATE int TestPalClicked( void );
PRIVATE int TestCycClicked( void );
PRIVATE int TestSlrClicked( void );
PRIVATE int Test_MXClicked( void );
PRIVATE int TestSclClicked( void );
PRIVATE int GFileBtClicked( void );

PRIVATE struct NewGadget TPNGad[ TP_CNT ] = {

   143,  39,  97,  27, " _DONE! ", NULL,
   ID_TestBt, PLACETEXT_IN, NULL, (APTR) TestBtClicked,

   104,  81, 219,  23, "String Gadget:", NULL,
   ID_TestStr, PLACETEXT_LEFT, NULL, (APTR) TestStrClicked,

   154, 117,  26,  11, "Test CheckBox", NULL,
   ID_TestChk, NG_HIGHLABEL | PLACETEXT_LEFT, NULL, (APTR) TestChkClicked,

    61, 158, 242, 156, "Test ListView", NULL,
   ID_Test_LV, NG_HIGHLABEL | PLACETEXT_ABOVE, NULL, (APTR) Test_LVClicked,

   356, 122,  71,  17, "Test Integer:", NULL,
   ID_TestInt, PLACETEXT_LEFT, NULL, (APTR) TestIntClicked,

   366,  49,  99,  19, "Test_Text", NULL,
   ID_TestTxt, PLACETEXT_LEFT, NULL, (APTR) TestTxtClicked,

   388, 147,  58,  19, "Test Number", NULL,
   ID_TestNum, PLACETEXT_LEFT, NULL, (APTR) TestNumClicked,

   340, 195, 172, 114, "Test _Palette", NULL,
   ID_TestPal, NG_HIGHLABEL | PLACETEXT_ABOVE, NULL, (APTR) TestPalClicked,

   381,  93,  94,  23, "Cycler", NULL,
   ID_TestCyc, NG_HIGHLABEL | PLACETEXT_ABOVE, NULL, (APTR) TestCycClicked,

    16, 156,  17, 217, "Slider", NULL,
   ID_TestSlr, NG_HIGHLABEL | PLACETEXT_ABOVE, NULL, (APTR) TestSlrClicked,

   139, 324,  17,   9, NULL, NULL,
   ID_Test_MX, PLACETEXT_LEFT, NULL, (APTR) Test_MXClicked,

   200, 359, 234,  19, "Test Scroller", NULL,
   ID_TestScl, NG_HIGHLABEL | PLACETEXT_ABOVE, NULL, (APTR) TestSclClicked,

   454, 304,  20,  14, NULL, NULL,
   ID_GFileBt, 0, NULL, (APTR) GFileBtClicked,

};

PRIVATE ULONG TPGTags[] = {

   GT_Underscore, 95, TAG_DONE,

   GTST_String, (ULONG) "Default Test Text", GTST_MaxChars, 256, STRINGA_Justification, 512, TAG_DONE,

   GTCB_Checked, 1, TAG_DONE,

   GTLV_Labels, (ULONG) &LV_Test_LV4Lbls, LAYOUTA_Spacing, 2, GTLV_ShowSelected, 0, TAG_DONE,

   GTIN_Number, 170, GTIN_MaxChars, 10, STRINGA_Justification, 512, TAG_DONE,

   GTTX_Text, (ULONG) "Default Text", GTTX_Border, 1, TAG_DONE,

   GTNM_Number, 85, GTNM_Border, 1, TAG_DONE,

   GTPA_Depth, 8, GTPA_Color, 1, GTPA_ColorOffset, 3, GT_Underscore, 95, TAG_DONE,

   GTCY_Labels, (ULONG) &CY_TestCyc9Lbls, GTCY_Active, 2, TAG_DONE,

   GA_RelVerify, 1, GA_Immediate, 1, PGA_Freedom, 2, GTSL_Level, 2, GTSL_LevelFormat, (ULONG) "-%ld-", GTSL_MaxLevelLen, 9, GTSL_LevelPlace, 8, TAG_DONE,

   GTMX_Labels, (ULONG) &MX_Test_MX11Lbls, GTMX_Spacing, 4, GTMX_Active, 1, TAG_DONE,

   GA_RelVerify, 1, GTSC_Total, 100, GTSC_Arrows, 8, TAG_DONE,

   GA_Disabled, 1, TAG_DONE,


};


// ----------------------------------------------------

PRIVATE UBYTE em[512], *ErrMsg = &em[0];

/****i* CMsg() [1.0] *************************************************
*
* NAME
*    STRPTR rval = CMsg( int index, char *defaultStr );
*
* DESCRIPTION
*    Obtain a string from the locale catalog file, failing that,
*    return the default string.
**********************************************************************
*
*/

PRIVATE STRPTR CMsg( int strIndex, char *defaultString )
{
   if (catalog != NULL)
      return( (STRPTR) GetCatalogStr( catalog, strIndex, defaultString ) );
   else
      return( (STRPTR) defaultString );
}

/****i* SetupCatalog() [1.0] *****************************************
*
* NAME
*    SetupCatalog()
*
* DESCRIPTION
**********************************************************************
*
*/

PRIVATE void SetupCatalog( void )
{
   ScrTitle = CMsg( MSG_TP_STITLE, MSG_TP_STITLE_STR ); // WA_ScreenTitle
   TPWdt = CMsg( MSG_TP_WTITLE, MSG_TP_WTITLE_STR ); // WA_Title

   TPNGad[ 0 ].ng_GadgetText = CMsg( MSG_GAD_TestBt, MSG_GAD_TestBt_STR );
   TPNGad[ 1 ].ng_GadgetText = CMsg( MSG_GAD_TestStr, MSG_GAD_TestStr_STR );
   TPNGad[ 2 ].ng_GadgetText = CMsg( MSG_GAD_TestChk, MSG_GAD_TestChk_STR );
   TPNGad[ 3 ].ng_GadgetText = CMsg( MSG_GAD_Test_LV, MSG_GAD_Test_LV_STR );
   TPNGad[ 4 ].ng_GadgetText = CMsg( MSG_GAD_TestInt, MSG_GAD_TestInt_STR );
   TPNGad[ 5 ].ng_GadgetText = CMsg( MSG_GAD_TestTxt, MSG_GAD_TestTxt_STR );
   TPNGad[ 6 ].ng_GadgetText = CMsg( MSG_GAD_TestNum, MSG_GAD_TestNum_STR );
   TPNGad[ 7 ].ng_GadgetText = CMsg( MSG_GAD_TestPal, MSG_GAD_TestPal_STR );
   TPNGad[ 8 ].ng_GadgetText = CMsg( MSG_GAD_TestCyc, MSG_GAD_TestCyc_STR );
   TPNGad[ 9 ].ng_GadgetText = CMsg( MSG_GAD_TestSlr, MSG_GAD_TestSlr_STR );

   TPNGad[ 11 ].ng_GadgetText = CMsg( MSG_GAD_TestScl, MSG_GAD_TestScl_STR );



   TPNMenu[ 1 ].nm_Label = CMsg( MSG_MENU_New, MSG_MENU_New_STR );
   TPNMenu[ 2 ].nm_Label = CMsg( MSG_MENU_Open, MSG_MENU_Open_STR );

   TPNMenu[ 4 ].nm_Label = CMsg( MSG_MENU_CheckedItem1, MSG_MENU_CheckedItem1_STR );
   TPNMenu[ 5 ].nm_Label = CMsg( MSG_MENU_CheckedItem2, MSG_MENU_CheckedItem2_STR );

   TPNMenu[ 7 ].nm_Label = CMsg( MSG_MENU_Item3, MSG_MENU_Item3_STR );


   TPNMenu[ 10 ].nm_Label = CMsg( MSG_MENU_SubItem1, MSG_MENU_SubItem1_STR );
   TPNMenu[ 11 ].nm_Label = CMsg( MSG_MENU_SubItem2, MSG_MENU_SubItem2_STR );
   TPNMenu[ 12 ].nm_Label = CMsg( MSG_MENU_DisabledItem, MSG_MENU_DisabledItem_STR );

#  ifdef USE_ASL_REQ
   FileTags[1].ti_Data = CMsg( MSG_ASL_RTITLE,    MSG_ASL_RTITLE_STR    );
   FileTags[6].ti_Data = CMsg( MSG_ASL_OKAY_BT,   MSG_ASL_OKAY_BT_STR   );
   FileTags[7].ti_Data = CMsg( MSG_ASL_CANCEL_BT, MSG_ASL_CANCEL_BT_STR );
#  endif

   return;
}

// ----------------------------------------------------------------

#ifdef USE_ACTIVE_SCREEN

PRIVATE BOOL UnlockFlag = FALSE;

#endif

PRIVATE int OpenTPScreen( void )
{
#  ifdef USE_ACTIVE_SCREEN

   struct Screen *chk = GetActiveScreen();

#  endif

   if ((TPFont = OpenDiskFont( &helvetica13 )) == NULL)
      return( -5 );

   Font = &Attr;

   if ((TPScr = LockPubScreen( PubScreenName )) == NULL)
      return( -1 );

#   ifdef USE_ACTIVE_SCREEN
   if (chk != TPScr)
      {
      UnlockPubScreen( NULL, TPScr );
      TPScr = chk;
      UnlockFlag = FALSE;
      }
   else
      UnlockFlag = TRUE;
#  endif

   ComputeFont( TPScr, Font, &CFont, 0, 0 );

   if ((VisualInfo = GetVisualInfo( TPScr, TAG_DONE )) == NULL)
      return( -2 );

#  ifdef USE_BOOPSI_IMAGE
   if ((getClass = initGet()) == NULL)
      return( -3 );

   if ((getImage = NewObject( getClass, NULL,
                              GT_VisualInfo, VisualInfo,
                              TAG_DONE )) == NULL)
      return( -4 );
#  endif

   return( 0 );
}

PRIVATE void CloseTPScreen( void )
{
#  ifdef USE_BOOPSI_IMAGE
   if (getImage != NULL)
      {
      DisposeObject( getImage );

      getImage = NULL;
      }

   if (getClass != NULL)
      {
      FreeClass( getClass );

      getClass = NULL;
      }
#  endif

   if (VisualInfo != NULL)
      {
      FreeVisualInfo( VisualInfo );

      VisualInfo = NULL;
      }

#  ifdef USE_ACTIVE_SCREEN
   if ((UnlockFlag == TRUE) && (TPScr != NULL))
      {
      UnlockPubScreen( NULL, TPScr );

      TPScr = NULL;
      }
#  else
   if (TPScr != NULL)
      {
      UnlockPubScreen( NULL, TPScr );

      TPScr = NULL;
      }
#  endif

   if (TPFont != NULL) 
      {
      CloseFont( TPFont );

      TPFont = NULL;
      }

   return;
}

PRIVATE void CloseTPWindow( void )
{
   if (TPMenus != NULL)
      {
      ClearMenuStrip( TPWnd );
      FreeMenus( TPMenus );
      TPMenus = NULL;
      }

   if (TPWnd != NULL)
      {
      CloseWindow( TPWnd );

      TPWnd = NULL;
      }

   if (TPGList != NULL)
      {
      FreeGadgets( TPGList );

      TPGList = NULL;
      }

   return;
}


// ----------------------------------------------------------------

PRIVATE int NewProjectMI( void )
{
   // Action for NewProjectMI:

   return( TRUE );
}

PRIVATE int OpenPrjMI( void )
{
   // Action for OpenPrjMI:

   return( TRUE );
}

PRIVATE int ChkItem1MI( void )
{
   // Action for ChkItem1MI:

   return( TRUE );
}

PRIVATE int CheckItem2MI( void )
{
   // Action for CheckItem2MI:

   return( TRUE );
}

PRIVATE int Item0( void )
{
   // Action for Item0:

   return( TRUE );
}

PRIVATE int SubItem1MI( void )
{
   // Action for SubItem1MI:

   return( TRUE );
}

PRIVATE int SubItem2MI( void )
{
   // Action for SubItem2MI:

   return( TRUE );
}

PRIVATE int DisabledItemMI( void )
{
   // Action for DisabledItemMI:

   return( TRUE );
}


PRIVATE int TestBtClicked( void )
{
   // Action for TestBt:

   return( FALSE );
}

PRIVATE int TestStrClicked( void )
{
   // Action for TestStr:

   return( TRUE );
}

PRIVATE int TestChkClicked( void )
{
   // Action for TestChk:

   return( TRUE );
}

PRIVATE int Test_LVClicked( void )
{
   // Action for Test_LV:

   return( TRUE );
}

PRIVATE int TestIntClicked( void )
{
   // Action for TestInt:

   return( TRUE );
}

PRIVATE int TestTxtClicked( void )
{
   // Action for TestTxt:

   return( TRUE );
}

PRIVATE int TestNumClicked( void )
{
   // Action for TestNum:

   return( TRUE );
}

PRIVATE int TestPalClicked( void )
{
   // Action for TestPal:

   return( TRUE );
}

PRIVATE int TestCycClicked( void )
{
   // Action for TestCyc:

   return( TRUE );
}

PRIVATE int TestSlrClicked( void )
{
   // Action for TestSlr:

   return( TRUE );
}

PRIVATE int Test_MXClicked( void )
{
   // Action for Test_MX:

   return( TRUE );
}

PRIVATE int TestSclClicked( void )
{
   // Action for TestScl:

   return( TRUE );
}

PRIVATE int GFileBtClicked( void )
{
   // Action for GFileBt:

   return( TRUE );
}



// ----------------------------------------------------------------

PRIVATE void BBoxRender( void )
{
   ComputeFont( TPScr, Font, &CFont, TPWidth, TPHeight );

   DrawBevelBox( TPWnd->RPort,
                 CFont.OffX + ComputeX( CFont.FontX,  65 ),
                 CFont.OffY + ComputeY( CFont.FontY, 320 ),
                 ComputeX( CFont.FontX, 116 ),
                 ComputeY( CFont.FontY,  61 ),
                 GT_VisualInfo, VisualInfo,
                 TAG_DONE
               );

   return;
}


PRIVATE void IntuiTextRender( void )
{
  struct IntuiText it;

  ComputeFont( TPScr, Font, &CFont, TPWidth, TPHeight );

  CopyMem( (char *) &TPIT, (char *) &it,
           (long) sizeof( struct IntuiText )
         );

  it.ITextFont = &helvetica13; // ??????????

  it.TopEdge   = CFont.OffY + ComputeY( CFont.FontY, it.TopEdge )
                 - (Font->ta_YSize >> 1);

  PrintIText( TPWnd->RPort, &it, 0, 0 );

  return;
}


PRIVATE int OpenTPWindow( void )
{
   struct NewGadget  ng;
   struct Gadget    *g;
   UWORD             lc, tc;
   UWORD             wleft, wtop, ww, wh;

   ComputeFont( TPScr, Font, &CFont, TPWidth, TPHeight );

   ww = ComputeX( CFont.FontX, TPWidth  );
   wh = ComputeY( CFont.FontY, TPHeight );

   wleft = (TPScr->Width  - TPWidth ) / 2;
   wtop  = (TPScr->Height - TPHeight) / 2;

   if ((g = CreateContext( &TPGList )) == NULL)
      return( -1 );

   for (lc = 0, tc = 0; lc < TP_CNT; lc++)
      {
      CopyMem( (char *) &TPNGad[ lc ], (char *) &ng,
               (long) sizeof( struct NewGadget )
             );

      ng.ng_VisualInfo = VisualInfo;
      ng.ng_TextAttr   = &helvetica13;
      ng.ng_LeftEdge   = CFont.OffX + ComputeX( CFont.FontX, ng.ng_LeftEdge );
      ng.ng_TopEdge    = CFont.OffY + ComputeY( CFont.FontY, ng.ng_TopEdge );

      if (TPGTypes[ lc ] != GENERIC_KIND)
         {
         ng.ng_Width   = ComputeX( CFont.FontX, ng.ng_Width );
         ng.ng_Height  = ComputeY( CFont.FontY, ng.ng_Height);
         }

      TPGadgets[ lc ] = g
                      = CreateGadgetA( (ULONG) TPGTypes[ lc ],
                                       g,
                                       &ng,
                                       (struct TagItem *) &TPGTags[ tc ]
                                     );

      if (TPGTypes[ lc ] == GENERIC_KIND)
         {
         g->Flags        |= GFLG_GADGIMAGE | GFLG_GADGHIMAGE;
         g->Activation   |= GACT_RELVERIFY;
         g->GadgetRender  = (APTR) getImage;
         g->SelectRender  = (APTR) getImage;
         }

      while (TPGTags[ tc ] != TAG_DONE)
         tc += 2;

      tc++;

      if (g == NULL)
         return( -2 );
      }

   if ((TPMenus = CreateMenus( TPNMenu, GTMN_FrontPen, 0L,
                               TAG_DONE )) == NULL)
      return( -3 );

   LayoutMenus( TPMenus, VisualInfo, TAG_DONE );

   if ((TPWnd = OpenWindowTags( NULL,

         WA_Left,          wleft,
         WA_Top,           wtop,
         WA_Width,         ww + CFont.OffX + TPScr->WBorRight,
         WA_Height,        wh + CFont.OffY + TPScr->WBorBottom,

         WA_IDCMP,        BUTTONIDCMP | STRINGIDCMP | CHECKBOXIDCMP | LISTVIEWIDCMP | INTEGERIDCMP | TEXTIDCMP | NUMBERIDCMP | PALETTEIDCMP | CYCLEIDCMP | SLIDERIDCMP | MXIDCMP | SCROLLERIDCMP | 
           IDCMP_CLOSEWINDOW | IDCMP_MENUPICK | IDCMP_VANILLAKEY | IDCMP_REFRESHWINDOW,

         WA_Flags,         WFLG_ACTIVATE | WFLG_SIZEGADGET | WFLG_DRAGBAR | WFLG_DEPTHGADGET
           | WFLG_CLOSEGADGET,

         WA_Gadgets,       TPGList,
         WA_Title,         TPWdt,
         WA_ScreenTitle,   ScrTitle,
         WA_CustomScreen,  TPScr,
         TAG_DONE )) == NULL)
      {
      return( -4 );
      }

   BBoxRender();

   IntuiTextRender();

   SetMenuStrip( TPWnd, TPMenus );

   GT_RefreshWindow( TPWnd, NULL );

   return( 0 );
}


PRIVATE int TPCloseWindow( void )
{
   CloseTPWindow();

   return( FALSE );
}

PRIVATE int TPVanillaKey( int whichKey )
{
   int rval = TRUE;

   switch (whichKey)
      {
      default:
         break;

      }

   return( rval );
}

PRIVATE int HandleTPIDCMP( void )
{
   struct IntuiMessage *m;
   int                (*func)( void );
   BOOL                 running = TRUE;

   if ((m = GT_GetIMsg( TPWnd->UserPort )) == NULL) 
      {
      return( running ); //   (void) Wait( 1L << TPWnd->UserPort->mp_SigBit );
      }

   CopyMem( (char *) m, (char *) &TPMsg, 
            (long) sizeof( struct IntuiMessage )
          );

   GT_ReplyIMsg( m );

   switch (TPMsg.Class)
      {
      case IDCMP_CLOSEWINDOW:
         running = TPCloseWindow();
         break;

      case IDCMP_GADGETDOWN:
      case IDCMP_GADGETUP:
         func = (void *) ((struct Gadget *)TPMsg.IAddress)->UserData;

         if (func != NULL)
            running = func();

         break;

      case IDCMP_MENUPICK:
         if (TPMsg.Code != MENUNULL)
            {
            int (*mfunc)( void );

            struct MenuItem *n = ItemAddress( TPMenus, TPMsg.Code );

            if (n == NULL)
               break;

            mfunc = (void *) (GTMENUITEM_USERDATA( n ));

            if (mfunc == NULL)
               break;

            running = mfunc();
            }

         break;

      case IDCMP_VANILLAKEY:
         running = TPVanillaKey( TPMsg.Code );
         break;

      case IDCMP_REFRESHWINDOW:
         GT_BeginRefresh( TPWnd );

            BBoxRender();
            IntuiTextRender();

         GT_BeginRefresh( TPWnd );

         break;
      }

   return( running );
}


// ----------------------------------------------------------------

PRIVATE void ShutdownProgram( void )
{
   CloseTPWindow();

   CloseTPScreen();

   Guarded_FreeLV( Test_LV4_lvm );
 
   if (catalog != NULL)
      CloseCatalog( catalog );
      
   if (LocaleBase != NULL)
      CloseLibrary( (struct Library *) LocaleBase );

#  ifdef USE_TOOLTYPES
   if (IconBase != NULL)
      CloseLibrary( (struct Library *) IconBase );
#  endif

   CloseLibs();
   
   return;
}

PRIVATE int SetupProgram( void )
{
   int rval = RETURN_OK;
   
   if (OpenLibs() < 0)
      {
      rval = ERROR_INVALID_RESIDENT_LIBRARY;
      
      goto exitSetup;
      }
      
#  ifdef USE_TOOLTYPES
   if ((IconBase = OpenLibrary( "icon.library", 37L )) == NULL)
      {
      fprintf( stderr, CMsg( MSG_FMT_LIB_UNOPENED, MSG_FMT_LIB_UNOPENED_STR ),
                       "icon.library", "37" 
             );

      ShutdownProgram();
            
      rval = ERROR_INVALID_RESIDENT_LIBRARY;
      
      goto exitSetup;
      }
#  endif

   if ((LocaleBase = OpenLibrary( "locale.library", 37L )) == NULL)
      {
      fprintf( stderr, CMsg( MSG_FMT_LIB_UNOPENED, MSG_FMT_LIB_UNOPENED_STR ),
                       "locale.library", "37" 
             );

      ShutdownProgram();
            
      rval = ERROR_INVALID_RESIDENT_LIBRARY;
      
      goto exitSetup;
      }

   catalog = OpenCatalog( NULL, "RAM:TP.catalog",
                                OC_BuiltInLanguage, MY_LANGUAGE,
                                TAG_DONE 
                        );

   (void) SetupCatalog();

   if (OpenTPScreen() < 0)
      {
      rval = ERROR_ON_OPENING_SCREEN;

      ShutdownProgram();

      goto exitSetup;
      }

   if (OpenTPWindow() < 0)
      {
      rval = ERROR_ON_OPENING_WINDOW;

      ShutdownProgram();

      goto exitSetup;
      }
   Test_LV4_lvm = Guarded_AllocLV( Test_LV_NUM_ELEMENTS, ELEMENT_SIZE );
   if (Test_LV4_lvm == NULL)
      {
      rval = ERROR_NO_FREE_STORE;

      ShutdownProgram();

      goto exitSetup;
      }
   else
      {
      int k = 0;

      SetupList( &Test_LVList, Test_LV4_lvm );

      for (k = 0; k < Test_LV_NUM_ELEMENTS; k++)
         {
         strncpy( &Test_LV4_lvm->lvm_NodeStrs[ k * ELEMENT_SIZE ],
                   LV_Test_LV4Lbls[ k ], ELEMENT_SIZE
                );
         }

      ModifyListView( TPGadgets[ ID_Test_LV ], TPWnd, &Test_LVList, NULL );
      }


exitSetup:

   return( rval );
}

#ifdef USE_TOOLTYPES
PRIVATE void *processToolTypes( char **toolptr )
{
   if (toolptr == NULL)
      return( NULL );

   // Place your tool grabbers here:

   return( NULL );
}
#endif

PUBLIC int main( int argc, char **argv )
{
#  ifdef USE_TOOLTYPES   
   struct WBArg  *wbarg;
   char         **toolptr = NULL;
#  endif

   int error = RETURN_OK, chk = FALSE;

   if ((error = SetupProgram()) != RETURN_OK)
      {
      return( error );
      }
      
#  ifdef USE_TOOLTYPES   
   if (argc > 0)    // from CLI:
      {
      // We prefer to use the ToolTypes: 
      (void) FindIcon( &processToolTypes, diskobj, argv[0] );
      }
   else             // from Workbench:
      {
      wbarg   = &(_WBenchMsg->sm_ArgList[ _WBenchMsg->sm_NumArgs - 1 ]);
      toolptr = FindTools( diskobj, wbarg->wa_Name, wbarg->wa_Lock );

      processToolTypes( toolptr );
      }
#  endif

   SetNotifyWindow( TPWnd );

   while ((chk = HandleTPIDCMP()) == TRUE)
      ; 

#  ifdef USE_TOOLTYPES
   FreeDiskObject( diskobj );
#  endif
   
   ShutdownProgram();

   return( RETURN_OK );
}

/* --------------- END of RAM:TP.c file! ------------------ */
