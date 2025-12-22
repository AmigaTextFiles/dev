/****h* GTBTranslator/GTBTranslator.c [2.3] *******************
* 
* NAME
*    GTBTranslator.c
*
* DESCRIPTION
*    Translate GadToolsBox V2.0b output files into either C-
*    source or AmigaTalk source code.
*
* HISTORY
*    15-Dec-2004 - Added Make Project button.
*
*    01-Nov-2004 - Added AmigaOS4 & gcc support.
*
*    13-Nov-2003 - Added conditional code for ListView Gadgets
*                  that do not have any choice strings.
*
*                  Even worse, Execute() & System() have some 
*                  sort of length limitations on the command
*                  string, which necessitated the creation of
*                  gtbGenC() & gtbGenATalk() in outCBtClicked()
*                  outABtClicked().
*
*    01-Oct-2003 - Changed some unused tooltypes to CTEMPLATEFILE
*                  & ATEMPLATEFILE.
*
*    30-Sep-2003 - Added Locale & MakeFile CheckBoxes.
*
*    24-Sep-2003 - Added locale translation support & removed
*                  GadToolsBox font dependency.
*
*    14-Sep-2003 - Created this file
*
* NOTES
*    ToolTypes available:
*
*    SAVEPATH         =AmigaTalk:User
*    GENERATORPROGRAM =AmigaTalk:c/GTBScanner
*    CTEMPLATEFILE    =AmigaTalk:GUIBuilder/GenC.template
*    ATEMPLATEFILE    =AmigaTalk:GUIBuilder/GenATalk.template
*    CENCODER         =AmigaTalk:c/GTBGenC
*    ATALKENCODER     =AmigaTalk:c/GTBGenATalk
*    FILEPATH         =AmigaTalk:User
*    TEXTEDITOR       =C:Ed
*    TEXTVIEWER       =MultiView
*
*    GUI Designed by : Jim Steichen
*    $VER: GTBTranslator.c 2.3 (01-Nov-2004) by J.T. Steichen
***************************************************************
*
*/

#include <stdio.h>
#include <string.h>

#include <exec/types.h>

#include <AmigaDOSErrs.h>

#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/imageclass.h>
#include <intuition/gadgetclass.h>

#include <dos/dostags.h>

#include <libraries/asl.h>
#include <libraries/gadtools.h>

#include <graphics/displayinfo.h>
#include <graphics/gfxbase.h>

#include <workbench/workbench.h>
#include <workbench/startup.h>
#include <workbench/icon.h>

#include <utility/tagitem.h>

#ifndef __amigaos4__

# include <clib/exec_protos.h>
# include <clib/intuition_protos.h>
# include <clib/gadtools_protos.h>
# include <clib/graphics_protos.h>
# include <clib/utility_protos.h>
# include <clib/diskfont_protos.h>

IMPORT struct WBStartup *_WBenchMsg;

PUBLIC struct IntuitionBase *IntuitionBase;
PUBLIC struct GfxBase       *GfxBase;
PUBLIC struct Library       *GadToolsBase;

PRIVATE struct Library      *IconBase    = NULL;
PRIVATE struct Library      *UtilityBase = NULL;

PRIVATE UBYTE v[] = "\0$VER: GTBTranslator 2.3" __AMIGADATE__ " by J.T. Steichen\0";

#else

# define __USE_INLINE__

# include <proto/exec.h>
# include <proto/intuition.h>
# include <proto/gadtools.h>
# include <proto/graphics.h>
# include <proto/utility.h>
# include <proto/diskfont.h>

IMPORT struct WBStartup *__WBenchMsg;

IMPORT struct Library *SysBase;
IMPORT struct Library *IntuitionBase;
IMPORT struct Library *GfxBase;
IMPORT struct Library *DOSBase;
IMPORT struct Library *IconBase;
IMPORT struct Library *UtilityBase;
IMPORT struct Library *LocaleBase;
IMPORT struct Library *DiskfontBase;

IMPORT struct ExecIFace      *IExec;
IMPORT struct DOSIFace       *IDOS;
IMPORT struct IntuitionIFace *IIntuition;
IMPORT struct GraphicsIFace  *IGraphics;
IMPORT struct LocaleIFace    *ILocale;
IMPORT struct UtilityIFace   *IUtility;
IMPORT struct IconIFace      *IIcon;
IMPORT struct DiskfontIFace  *IDiskfont;

PUBLIC struct Library        *GadToolsBase; // Has to be visible to CommonFuncsPPC.o
PUBLIC struct GadToolsIFace  *IGadTools;

PRIVATE UBYTE v[] = "\0$VER: GTBTranslator 2.3" __DATE__ " by J.T. Steichen\0";

#endif

#include <StringFunctions.h>

#include <proto/locale.h>

PUBLIC struct Catalog *catalog = NULL;

#define   CATCOMP_ARRAY    1
#include "GTBProjectLocale.h"

#define  MY_LANGUAGE "english"

#include "CPGM:GlobalObjects/CommonFuncs.h"

#ifndef  StrBfPtr
# define StrBfPtr( g ) (((struct StringInfo *)g->SpecialInfo)->Buffer)
#endif

#define GD_SrcFileStr  0
#define GD_SaveFileStr 1
#define GD_ToolsLV     2
#define GD_EditBt      3
#define GD_ViewBt      4
#define GD_outCBt      5
#define GD_outABt      6
#define GD_ExitBt      7
#define GD_GetSrcFile  8
#define GD_GetSaveFile 9
#define GD_GenMakeChk  10
#define GD_GenLocChk   11
#define GD_EditMkBt    12
#define GD_EditLocBt   13
#define GD_MakePrjBt   14

#define PS_CNT         15

#define TOOLS_LISTVIEW PSGadgets[ GD_ToolsLV     ]
#define SRCFILE_STRGAD PSGadgets[ GD_SrcFileStr  ]
#define SAVFILE_STRGAD PSGadgets[ GD_SaveFileStr ]

#define SRC_FILENAME  StrBfPtr( SRCFILE_STRGAD )
#define SAVE_FILENAME StrBfPtr( SAVFILE_STRGAD )

#define BUFF_SIZE 512

#ifdef   DEBUG
# define DBG(p) p
#else
# define DBG(p)
#endif

// -----------------------------------------------------------

PUBLIC struct CompFont  CFont         = { 0, };
PUBLIC struct TextAttr *Font, Attr    = { 0, };
    
PUBLIC struct TextFont *PSFont        = NULL;
PUBLIC struct Screen   *Scr           = NULL;
PUBLIC UBYTE           *PubScreenName = "Workbench";
PUBLIC APTR             VisualInfo    = NULL;

PUBLIC UBYTE            em[1024], *ErrMsg = &em[0];

// -----------------------------------------------------------

PRIVATE struct Window       *PSWnd = NULL;
PRIVATE struct Gadget       *PSGList = NULL;
PRIVATE struct Gadget       *PSGadgets[ PS_CNT ];
PRIVATE struct IntuiMessage  PSMsg;

PRIVATE UWORD  PSLeft   = 125;
PRIVATE UWORD  PSTop    = 190;
PRIVATE UWORD  PSWidth  = 615;
PRIVATE UWORD  PSHeight = 425;
PRIVATE UBYTE *PSWdt    = NULL; // "GadToolsBox Scanner/Translator:";

PRIVATE struct TextAttr helvetica13 = { "helvetica.font", 13, 0x00, 0x62 };

PRIVATE BOOL   gotSrcFileName  = FALSE;
PRIVATE BOOL   gotSaveFileName = FALSE;

// -----------------------------------------------------------

PRIVATE UBYTE extCommand[ 2 * BUFF_SIZE ] = { 0, };
PRIVATE UBYTE programName[ BUFF_SIZE ]    = "GTBTranslator";

PRIVATE BOOL openedLocaleBase = FALSE;

// TTTTTTTTT ToolTypes: TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT

PRIVATE char CTemplateFile[32]   = "CTEMPLATEFILE";
PRIVATE char ATemplateFile[32]   = "ATEMPLATEFILE";
PRIVATE char SavePath[32]        = "SAVEPATH";
PRIVATE char CEncoder[32]        = "CENCODER";
PRIVATE char ATEncoder[32]       = "ATALKENCODER";
PRIVATE char Program[32]         = "GENERATORPROGRAM";
PRIVATE char FilePath[32]        = "FILEPATH";
PRIVATE char TextEditor[32]      = "TEXTEDITOR";
PRIVATE char TextViewer[32]      = "TEXTVIEWER";

PRIVATE char DefCTemplateFile[128] = "AmigaTalk:GUIBuilder/GenC.template";
PRIVATE char DefATemplateFile[128] = "AmigaTalk:GUIBuilder/GenATalk.template";
PRIVATE char DefSavePath[128]      = "AmigaTalk:User";
#ifdef __amigaos4__
PRIVATE char DefCEncoder[128]      = "AmigaTalk:C/GTBGenCPPC";
PRIVATE char DefATalkEncoder[128]  = "AmigaTalk:C/GTBGenATalkPPC";
PRIVATE char DefProgram[128]       = "AmigaTalk:C/GTBScannerPPC";
#else
PRIVATE char DefCEncoder[128]      = "AmigaTalk:C/GTBGenC";
PRIVATE char DefATalkEncoder[128]  = "AmigaTalk:C/GTBGenATalk";
PRIVATE char DefProgram[128]       = "AmigaTalk:C/GTBScanner";
#endif
PRIVATE char DefFilePath[128]      = "Amigatalk:User";
PRIVATE char DefTextEditor[128]    = "C:Ed";
PRIVATE char DefTextViewer[128]    = "MultiView";

PRIVATE char *TTCTemplateFile    = &DefCTemplateFile[0];
PRIVATE char *TTATemplateFile    = &DefATemplateFile[0];
PRIVATE char *TTSavePath         = &DefSavePath[0];
PRIVATE char *TTCEncoder         = &DefCEncoder[0];
PRIVATE char *TTATEncoder        = &DefATalkEncoder[0];
PRIVATE char *TTProgram          = &DefProgram[0];
PRIVATE char *TTFilePath         = &DefFilePath[0];
PRIVATE char *TTTextEditor       = &DefTextEditor[0];
PRIVATE char *TTTextViewer       = &DefTextViewer[0];

// TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT

PRIVATE struct DiskObject   *diskobj = NULL;

PRIVATE struct TagItem FileTags[] = {

   ASLFR_Window,          (ULONG) NULL,
   ASLFR_TitleText,       (ULONG) "Enter a File Name...",
   ASLFR_InitialDrawer,   (ULONG) "RAM:",
   ASLFR_InitialHeight,   500,
   ASLFR_InitialWidth,    600,
   ASLFR_InitialTopEdge,  16,
   ASLFR_InitialLeftEdge, 100,
   ASLFR_PositiveText,    (ULONG) " OKAY! ",
   ASLFR_NegativeText,    (ULONG) " CANCEL! ",
   ASLFR_InitialPattern,  (ULONG) "#?",
   ASLFR_InitialFile,     (ULONG) "",
   ASLFR_Flags1,          FRF_DOPATTERNS,
   ASLFR_Flags2,          FRF_REJECTICONS,
   ASLFR_SleepWindow,     1,
   ASLFR_PrivateIDCMP,    1,
   TAG_END 
};

// -----------------------------------------------------------

#define TOOLSIZE 80

PRIVATE int                 ToolCount = 0;
PRIVATE struct List         ToolsList = { 0, };
PRIVATE struct ListViewMem *lvm       = NULL;

// -----------------------------------------------------------

PRIVATE ULONG PSGTags[] = {

   GTST_MaxChars, BUFF_SIZE, TAG_DONE,
   GTST_MaxChars, BUFF_SIZE, TAG_DONE,

   GTLV_Labels,   0L, // (ULONG) &ToolsList, 
   GTLV_ReadOnly, TRUE, LAYOUTA_Spacing, 2, 
   TAG_DONE,

   GT_Underscore, '_', TAG_DONE,
   GT_Underscore, '_', TAG_DONE,
   GT_Underscore, '_', TAG_DONE,
   GT_Underscore, '_', TAG_DONE,
   GT_Underscore, '_', TAG_DONE,

   TAG_DONE,
   TAG_DONE,

   GTCB_Checked, TRUE, GT_Underscore, '_', TAG_DONE,
   GTCB_Checked, TRUE, GT_Underscore, '_', TAG_DONE,

   GT_Underscore, '_', TAG_DONE,
   GT_Underscore, '_', TAG_DONE,
   GT_Underscore, '_', TAG_DONE,
};

PRIVATE UWORD PSGTypes[] = {

   STRING_KIND,   STRING_KIND,   LISTVIEW_KIND,
   BUTTON_KIND,   BUTTON_KIND,   BUTTON_KIND,
   BUTTON_KIND,   BUTTON_KIND,   BUTTON_KIND,
   BUTTON_KIND,   CHECKBOX_KIND, CHECKBOX_KIND,   
   BUTTON_KIND,   BUTTON_KIND,   BUTTON_KIND,
};

PRIVATE int SrcFileStrClicked(  void );
PRIVATE int SaveFileStrClicked( void );
PRIVATE int ToolsLVClicked(     void );
PRIVATE int EditBtClicked(      void );
PRIVATE int ViewBtClicked(      void );
PRIVATE int outCBtClicked(      void );
PRIVATE int outABtClicked(      void );
PRIVATE int ExitBtClicked(      void );
PRIVATE int GetSrcFileClicked(  void );
PRIVATE int GetSaveFileClicked( void );
PRIVATE int GenMakeChkClicked(  void );
PRIVATE int GenLocChkClicked(   void );
PRIVATE int EditMkBtClicked(    void );
PRIVATE int EditLocBtClicked(   void );
PRIVATE int MakePrjBtClicked(   void );

PRIVATE struct NewGadget PSNGad[] = {

   130,   7, 360,  19, "Source File:",             NULL, GD_SrcFileStr, 
   PLACETEXT_LEFT, NULL, (APTR) SrcFileStrClicked,
   
   130,  32, 360,  19, "Save to File:",            NULL, GD_SaveFileStr, 
   PLACETEXT_LEFT, NULL, (APTR) SaveFileStrClicked,

    20,  80, 575, 195, "Program ToolTypes:",       NULL, GD_ToolsLV, 
   PLACETEXT_ABOVE | NG_HIGHLABEL, NULL, (APTR) ToolsLVClicked,

    40, 314, 120,  19, "_Edit Output",             NULL, GD_EditBt, 
   PLACETEXT_IN, NULL, (APTR) EditBtClicked,
   
    40, 340, 120,  19, "_View Output",             NULL, GD_ViewBt, 
   PLACETEXT_IN, NULL, (APTR) ViewBtClicked,
   
   330, 285, 130,  19, "Output _C Source",         NULL, GD_outCBt, 
   PLACETEXT_IN, NULL, (APTR) outCBtClicked,
   
   430, 390, 170,  19, "Output _AmigaTalk Source", NULL, GD_outABt, 
   PLACETEXT_IN, NULL, (APTR) outABtClicked,
   
   235, 390, 140,  19, "E_xit Program",            NULL, GD_ExitBt, 
   PLACETEXT_IN, NULL, (APTR) ExitBtClicked,
   
   500,   7,  40,  19, "ASL",                       NULL, GD_GetSrcFile, 
   PLACETEXT_IN, NULL, (APTR) GetSrcFileClicked,
   
   500,  32,  40,  19, "ASL",                       NULL, GD_GetSaveFile, 
   PLACETEXT_IN, NULL, (APTR) GetSaveFileClicked,

   275, 315,  26, 11, "Generate _SMakeFile", NULL, GD_GenMakeChk, 
   PLACETEXT_RIGHT, NULL, (APTR) GenMakeChkClicked,
   
   275, 340,  26, 11, "Generate _Locale",    NULL, GD_GenLocChk, 
   PLACETEXT_RIGHT, NULL, (APTR) GenLocChkClicked,
   
   430, 315,  90, 19, "Edit _MakeFile",      NULL, GD_EditMkBt, 
   PLACETEXT_IN, NULL, (APTR) EditMkBtClicked,
   
   430, 340,  90, 19, "Edit L_ocale",        NULL, GD_EditLocBt, 
   PLACETEXT_IN, NULL, (APTR) EditLocBtClicked,
  
    40, 288, 120, 19, "Make _Project",       NULL, GD_MakePrjBt, 
   PLACETEXT_IN, NULL, (APTR) MakePrjBtClicked,
};

PRIVATE BOOL genLocaleFlag = TRUE;
PRIVATE BOOL genSMakeFlag  = TRUE;

// -----------------------------------------------------------

/****i* CMsg() [1.0] *************************************************
*
* NAME
*    CMsg()
*
* DESCRIPTION
*    Obtain a string from the locale catalog file, failing that,
*    return the default string.
**********************************************************************
*
*/

PRIVATE STRPTR CMsg( int strIndex, char *defaultString )
{
   if (catalog)
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

PRIVATE int SetupCatalog( void )
{
   PSWdt = CMsg( MSG_GTBT_WTITLE, MSG_GTBT_WTITLE_STR );

   // ToolTypes:
   StringNCopy( SavePath,    CMsg( MSG_GTBT_TT_SAVEPATH, MSG_GTBT_TT_SAVEPATH_STR), 32 );
   StringNCopy( CEncoder,    CMsg( MSG_GTBT_TT_CENCODER, MSG_GTBT_TT_CENCODER_STR), 32 );
   StringNCopy( ATEncoder,   CMsg( MSG_GTBT_TT_AENCODER, MSG_GTBT_TT_AENCODER_STR), 32 );
   StringNCopy( Program,     CMsg( MSG_GTBT_TT_GENPRGM,  MSG_GTBT_TT_GENPRGM_STR ), 32 );
   StringNCopy( FilePath,    CMsg( MSG_GTBT_TT_FILEPATH, MSG_GTBT_TT_FILEPATH_STR), 32 );

   StringNCopy( TextEditor,  CMsg( MSG_GTBT_TT_TEXTEDITOR, MSG_GTBT_TT_TEXTEDITOR_STR), 32 );
   StringNCopy( TextViewer,  CMsg( MSG_GTBT_TT_TEXTVIEWER, MSG_GTBT_TT_TEXTVIEWER_STR), 32 );

   // Gadget Labels:
   PSNGad[ GD_SrcFileStr  ].ng_GadgetText = CMsg( MSG_GTBT_GAD_SRCFILE,  MSG_GTBT_GAD_SRCFILE_STR );
   PSNGad[ GD_SaveFileStr ].ng_GadgetText = CMsg( MSG_GTBT_GAD_SAVEFILE, MSG_GTBT_GAD_SAVEFILE_STR );
   PSNGad[ GD_ToolsLV     ].ng_GadgetText = CMsg( MSG_GTBT_GAD_TOOLS,    MSG_GTBT_GAD_TOOLS_STR );

   PSNGad[ GD_EditBt ].ng_GadgetText = CMsg( MSG_GTBT_GAD_EDITBT, MSG_GTBT_GAD_EDITBT_STR );
   PSNGad[ GD_ViewBt ].ng_GadgetText = CMsg( MSG_GTBT_GAD_VIEWBT, MSG_GTBT_GAD_VIEWBT_STR );
   PSNGad[ GD_outCBt ].ng_GadgetText = CMsg( MSG_GTBT_GAD_OUTCBT, MSG_GTBT_GAD_OUTCBT_STR );
   PSNGad[ GD_outABt ].ng_GadgetText = CMsg( MSG_GTBT_GAD_OUTABT, MSG_GTBT_GAD_OUTABT_STR );
   PSNGad[ GD_ExitBt ].ng_GadgetText = CMsg( MSG_GTBT_GAD_EXITBT, MSG_GTBT_GAD_EXITBT_STR );

   PSNGad[ GD_GenMakeChk ].ng_GadgetText = CMsg( MSG_GMK_GAD, MSG_GMK_GAD_STR );
   PSNGad[ GD_GenLocChk  ].ng_GadgetText = CMsg( MSG_GLC_GAD, MSG_GLC_GAD_STR );

   PSNGad[ GD_EditMkBt  ].ng_GadgetText = CMsg( MSG_EMK_GAD,  MSG_EMK_GAD_STR );
   PSNGad[ GD_EditLocBt ].ng_GadgetText = CMsg( MSG_ELC_GAD,  MSG_ELC_GAD_STR );
   PSNGad[ GD_MakePrjBt ].ng_GadgetText = CMsg( MSG_MPRJ_GAD, MSG_MPRJ_GAD_STR );

   SetTagItem( FileTags, ASLFR_TitleText,    (ULONG) CMsg( MSG_GTBT_ASL_WTITLE,   MSG_GTBT_ASL_WTITLE_STR   ) );
   SetTagItem( FileTags, ASLFR_PositiveText, (ULONG) CMsg( MSG_GTBT_ASL_OKAYBT,   MSG_GTBT_ASL_OKAYBT_STR   ) );
   SetTagItem( FileTags, ASLFR_NegativeText, (ULONG) CMsg( MSG_GTBT_ASL_CANCELBT, MSG_GTBT_ASL_CANCELBT_STR ) );
   
   return( 0 );
}

// -----------------------------------------------------------------

PRIVATE BOOL UnlockFlag = FALSE;

PRIVATE int SetupScreen( void )
{
   struct Screen *chk = GetActiveScreen();
   
   if (!(PSFont = OpenDiskFont( &helvetica13 )))
      return( -5 );

   Font = &Attr;
   
   if (!(Scr = LockPubScreen( PubScreenName )))
      return( -1 );

   if (chk != Scr)
      {
      UnlockPubScreen( NULL, Scr );
      Scr        = chk;
      UnlockFlag = FALSE;      
      }
   else
      UnlockFlag = TRUE;

   ComputeFont( Scr, Font, &CFont, 0, 0 );

   if (!(VisualInfo = GetVisualInfo( Scr, TAG_DONE )))
      return( -2 );

   return( 0 );
}

PRIVATE void CloseDownScreen( void )
{
   if (VisualInfo)
      {
      FreeVisualInfo( VisualInfo );
      VisualInfo = NULL;
      }

   if ((UnlockFlag == TRUE) && Scr)
      {
      UnlockPubScreen( NULL, Scr );
      Scr = NULL;
      }
      
   if (PSFont)
      {
      CloseFont( PSFont );
      PSFont = NULL;
      }

   return;
}

PRIVATE void ClosePSWindow( void )
{
   if (PSWnd)
      {
      CloseWindow( PSWnd );
      PSWnd = NULL;
      }

   if (PSGList)
      {
      FreeGadgets( PSGList );
      PSGList = NULL;
      }

   return;
}

PRIVATE UBYTE savedPath[BUFF_SIZE] = { 0, };
PRIVATE BOOL  savedPathSet         = FALSE;

PRIVATE int ASLClicked( struct Gadget *strGadget, char *pathName )
{
   char UserFileName[ BUFF_SIZE ] = { 0, };
   int  rval                      = FALSE;

   SetTagItem( &FileTags[0], ASLFR_Window, (ULONG) PSWnd );
   
   if (savedPathSet == TRUE)
      {
      FileTags[2].ti_Data = (ULONG) &savedPath[0];
//      SetTagItem( &FileTags[0], ASLFR_InitialDrawer, (ULONG) &savedPath[0] );
      }
   else if (pathName && (StringLength( pathName ) > 0))
      {
      StringNCopy( &savedPath[0], pathName, BUFF_SIZE );

      FileTags[2].ti_Data = (ULONG) &savedPath[0];
//      SetTagItem( &FileTags[0], ASLFR_InitialDrawer, (ULONG) &savedPath[0] );

      savedPathSet = TRUE;
      }
   else
      {
      savedPathSet = FALSE; // Should never happen
      
      FileTags[2].ti_Data = (ULONG) "RAM:";
//      SetTagItem( &FileTags[0], ASLFR_InitialDrawer, (ULONG) "RAM:" );

      StringNCopy( &savedPath[0], "RAM:", 5 );
      }
      
   if (File_DirReq( &UserFileName[0], &savedPath[0], &FileTags[0] ) > 1)
      {
      sprintf( ErrMsg, "%s", &UserFileName[0] );
      
      GT_SetGadgetAttrs( strGadget, PSWnd, NULL, GTST_String, (STRPTR) ErrMsg, TAG_END );

      rval = TRUE;
      }

   return( rval );
}

// -----------------------------------------------------------

PRIVATE int PSCloseWindow( void )
{
   ClosePSWindow();

   return( FALSE );
}

PRIVATE int SrcFileStrClicked( void )
{
   if (StringLength( SRC_FILENAME ) > 0)
      gotSrcFileName = TRUE;
   else
      gotSrcFileName = FALSE;
      
   return( TRUE );
}

PRIVATE char mkfn[BUFF_SIZE], *mkFileName = &mkfn[0];

SUBFUNC void makeMakeFileName( char *fname )
{
   char *cp = mkFileName;
   
   StringNCopy( mkFileName, fname, BUFF_SIZE );
   
   while (*cp != '.' && *cp != '\0')
      cp++;
      
   if (*cp == '.')
      {
      cp++;
      *cp = '\0';

      strncat( cp, "smake", BUFF_SIZE );

      cp += 5;
      *cp = '\0'; // don't know if strncat will do this.
      }
   else if (*cp == '\0')
      {
      cp -= 6;
      *cp = '\0';
      strncat( cp, ".smake", BUFF_SIZE );
      }
      
   return;
}

PRIVATE int GenMakeChkClicked( void )
{
   if ((PSGadgets[ GD_GenMakeChk ]->Flags & GFLG_SELECTED) != FALSE)
      {
      makeMakeFileName( SAVE_FILENAME );

      genSMakeFlag = TRUE;
      }
   else
      {
      genSMakeFlag = FALSE;
      }

   return( TRUE );
}

PRIVATE char lcfn[BUFF_SIZE], *lcFileName = &lcfn[0];

SUBFUNC void makeLocaleFileName( char *fname )
{
   char *cp = lcFileName;
   
   StringNCopy( lcFileName, fname, BUFF_SIZE );
   
   while (*cp != '.' && *cp != '\0')
      cp++;
      
   if (*cp == '.')
      {
      cp++;
      *cp = '\0';

      strncat( cp, "cd", BUFF_SIZE );

      cp += 2;
      *cp = '\0'; // don't know if strncat will do this.
      }
   else if (*cp == '\0')
      {
      cp -= 3;
      *cp = '\0';

      strncat( cp, ".cd", BUFF_SIZE );
      }
      
   return;
}

PRIVATE int GenLocChkClicked( void )
{
   if ((PSGadgets[ GD_GenLocChk ]->Flags & GFLG_SELECTED) != FALSE)
      {
      makeLocaleFileName( SAVE_FILENAME );

      genLocaleFlag = TRUE;
      }
   else
      {
      genLocaleFlag = FALSE;
      }

   return( TRUE );
}

PRIVATE int SaveFileStrClicked( void )
{
   if (StringLength( SAVE_FILENAME ) > 0)
      {
      gotSaveFileName = TRUE;

      makeLocaleFileName( SAVE_FILENAME );
      makeMakeFileName(   SAVE_FILENAME );
      }
   else
      gotSaveFileName = FALSE;
      
   return( TRUE );
}

PRIVATE int EditMkBtClicked( void )
{
   if (StringLength( SAVE_FILENAME ) < 1)   
      {
      UserInfo( CMsg( MSG_GTBT_ENTER_OUT_FNAME, MSG_GTBT_ENTER_OUT_FNAME_STR ),
                CMsg( MSG_GTBP_USER_ERROR, MSG_GTBP_USER_ERROR_STR ) 
              );

      return( (int) TRUE );
      }

   if (StringLength( mkFileName ) < 1)   
      {
      UserInfo( CMsg( MSG_GTBT_USE_GENMAKE, MSG_GTBT_USE_GENMAKE_STR ),
                CMsg( MSG_GTBP_USER_ERROR, MSG_GTBP_USER_ERROR_STR ) 
              );

      return( (int) TRUE );
      }

   StringCopy( &extCommand[0], TTTextEditor );
   StringCat(  &extCommand[0], " " );
   StringCat(  &extCommand[0], mkFileName ); // has path also.
   
//   ScreenToBack( Scr );
   
   if (System( &extCommand[0], TAG_DONE ) < 0)
      {
      sprintf( ErrMsg, 
               CMsg( MSG_GTBT_FMT_TOOL_ERR, MSG_GTBT_FMT_TOOL_ERR_STR ),
               TTTextEditor
             );

      UserInfo( ErrMsg, CMsg( MSG_GTBT_INV_TOOL, MSG_GTBT_INV_TOOL_STR ) );
      }

//   ScreenToFront( Scr );

   return( TRUE );
}

PRIVATE int EditLocBtClicked( void )
{
   if (StringLength( SAVE_FILENAME ) < 1)   
      {
      UserInfo( CMsg( MSG_GTBT_ENTER_OUT_FNAME, MSG_GTBT_ENTER_OUT_FNAME_STR ),
                CMsg( MSG_GTBP_USER_ERROR, MSG_GTBP_USER_ERROR_STR ) 
              );

      return( (int) TRUE );
      }

   if (StringLength( lcFileName ) < 1)   
      {
      UserInfo( CMsg( MSG_GTBT_USE_GENLOCL, MSG_GTBT_USE_GENLOCL_STR ),
                CMsg( MSG_GTBP_USER_ERROR, MSG_GTBP_USER_ERROR_STR ) 
              );

      return( (int) TRUE );
      }

   StringCopy( &extCommand[0], TTTextEditor );
   StringCat(  &extCommand[0], " " );
   StringCat(  &extCommand[0], lcFileName ); // has path also.
   
//   ScreenToBack( Scr );
   
   if (System( &extCommand[0], TAG_DONE ) < 0)
      {
      sprintf( ErrMsg, 
               CMsg( MSG_GTBT_FMT_TOOL_ERR, MSG_GTBT_FMT_TOOL_ERR_STR ),
               TTTextEditor
             );

      UserInfo( ErrMsg, CMsg( MSG_GTBT_INV_TOOL, MSG_GTBT_INV_TOOL_STR ) );
      }

//   ScreenToFront( Scr );

   return( TRUE );
}

// Edit Output Button:

PRIVATE int EditBtClicked( void )
{
   if (StringLength( SAVE_FILENAME ) < 1)   
      {
      UserInfo( CMsg( MSG_GTBT_ENTER_OUT_FNAME, MSG_GTBT_ENTER_OUT_FNAME_STR ),
                CMsg( MSG_GTBP_USER_ERROR, MSG_GTBP_USER_ERROR_STR ) 
              );

      return( (int) TRUE );
      }

   StringCopy( &extCommand[0], TTTextEditor );
   StringCat(  &extCommand[0], " " );
   StringCat(  &extCommand[0], SAVE_FILENAME ); // has path also.
   
//   ScreenToBack( Scr );
   
   if (System( &extCommand[0], TAG_DONE ) < 0)
      {
      sprintf( ErrMsg, 
               CMsg( MSG_GTBT_FMT_TOOL_ERR, MSG_GTBT_FMT_TOOL_ERR_STR ),
               TTTextEditor
             );

      UserInfo( ErrMsg, CMsg( MSG_GTBT_INV_TOOL, MSG_GTBT_INV_TOOL_STR ) );
      }

//   ScreenToFront( Scr );

   return( TRUE );
}

// View Output Button:

PRIVATE int ViewBtClicked( void )
{
   if (StringLength( SAVE_FILENAME ) < 1)   
      {
      UserInfo( CMsg( MSG_GTBT_ENTER_OUT_FNAME, MSG_GTBT_ENTER_OUT_FNAME_STR ),
                CMsg( MSG_GTBP_USER_ERROR, MSG_GTBP_USER_ERROR_STR )
              );

      return( (int) TRUE );
      }

   StringCopy( &extCommand[0], TTTextViewer );
   StringCat(  &extCommand[0], " " );
   StringCat(  &extCommand[0], SAVE_FILENAME ); // has path also.
   
//   ScreenToBack( Scr );
   
   if (System( &extCommand[0], TAG_DONE ) < 0)
      {
      sprintf( ErrMsg, 
               CMsg( MSG_GTBT_FMT_TOOL_ERR, MSG_GTBT_FMT_TOOL_ERR_STR ),
               TTTextViewer
             );

      UserInfo( ErrMsg, CMsg( MSG_GTBT_INV_TOOL, MSG_GTBT_INV_TOOL_STR ) );
      }

//   ScreenToFront( Scr );

   return( TRUE );
}

// Make Project Button: 

PRIVATE int MakePrjBtClicked( void )
{
   int chk = RETURN_OK;
   
   if (StringLength( SRC_FILENAME ) < 1)   
      {
      UserInfo( CMsg( MSG_GTBT_ENTER_IN_FNAME, MSG_GTBT_ENTER_IN_FNAME_STR ),
                CMsg( MSG_GTBP_USER_ERROR, MSG_GTBP_USER_ERROR_STR ) 
              );

      return( (int) TRUE );
      }

   if (StringLength( SAVE_FILENAME ) < 1)   
      {
      UserInfo( CMsg( MSG_GTBT_ENTER_OUT_FNAME, MSG_GTBT_ENTER_OUT_FNAME_STR ),
                CMsg( MSG_GTBP_USER_ERROR, MSG_GTBP_USER_ERROR_STR ) 
              );

      return( (int) TRUE );
      }

   sprintf( &extCommand[0], "%s %s %s", TTProgram, SRC_FILENAME, SAVE_FILENAME );
   
   DBG( fprintf( stderr, ">>>>>>>>>>GTBTranslatorPPC:  Calling:\n   %s\n", extCommand ) );
   
   // Call GTBScannerPPC & convert *.gui to *.ini file:
   if ((chk = System( &extCommand[0], TAG_DONE )) != RETURN_OK)
      {
      sprintf( ErrMsg, CMsg( MSG_GTBT_FMT_TOOL_ERR, MSG_GTBT_FMT_TOOL_ERR_STR ),
                       extCommand
             );

      UserInfo( ErrMsg, CMsg( MSG_GTBT_INV_TOOL, MSG_GTBT_INV_TOOL_STR ) );

      fprintf( stderr, "%s\n  failed with ERROR#: %d", extCommand, chk );
      }

   DBG( fprintf( stderr, ">>>>>>>>>>GTBTranslatorPPC:  exiting MakePrjBtClicked().\n" ) );

   return( TRUE );
}

PRIVATE int outCBtClicked( void )
{
   // Located in GTBGenC.c: 
   IMPORT int gtbGenC( char *iniFile, char *templateFile,
                       BOOL makeFileFlag, BOOL localeFileFlag );
   
   int chk = RETURN_OK;
   
   if (StringLength( SRC_FILENAME ) < 1)   
      {
      UserInfo( CMsg( MSG_GTBT_ENTER_IN_FNAME, MSG_GTBT_ENTER_IN_FNAME_STR ),
                CMsg( MSG_GTBP_USER_ERROR, MSG_GTBP_USER_ERROR_STR ) 
              );

      return( (int) TRUE );
      }

   if (StringLength( SAVE_FILENAME ) < 1)   
      {
      UserInfo( CMsg( MSG_GTBT_ENTER_OUT_FNAME, MSG_GTBT_ENTER_OUT_FNAME_STR ),
                CMsg( MSG_GTBP_USER_ERROR, MSG_GTBP_USER_ERROR_STR ) 
              );

      return( (int) TRUE );
      }


   DBG( fprintf( stderr, "########outCBtClicked():  Calling gtbGenC()...\n" ) );
   // gtbGenC() is now an internal function:
   if ((chk = gtbGenC( SAVE_FILENAME, TTCTemplateFile, genSMakeFlag, genLocaleFlag )) != RETURN_OK)
      {
      sprintf( extCommand, "gtbGenC( %s, %s, %s, %s )",
                         SAVE_FILENAME, TTCTemplateFile, 
                         genSMakeFlag  == TRUE ? "TRUE" : "FALSE", 
                         genLocaleFlag == TRUE ? "TRUE" : "FALSE" 
             );
      
      sprintf( ErrMsg, CMsg( MSG_GTBT_FMT_TOOL_ERR, MSG_GTBT_FMT_TOOL_ERR_STR ),
                       extCommand
             );

      UserInfo( ErrMsg, CMsg( MSG_GTBT_INV_TOOL, MSG_GTBT_INV_TOOL_STR ) );

      fprintf( stderr, "%s\n  failed with ERROR#: %d", extCommand, chk );
      
      return( TRUE );
      }

   DBG( fprintf( stderr, "########returned from gtbGenC() in outCBtClicked()!\n" ) );

   UserInfo( CMsg( MSG_GTBT_PGM_DONE, MSG_GTBT_PGM_DONE_STR ), 
             CMsg( MSG_GTB_STATUS, MSG_GTB_STATUS_STR ) 
           );
   
   return( TRUE );
}

PRIVATE int outABtClicked( void )
{
   // Located in GTBGenATalk.c:
//   IMPORT int gtbGenATalk( char *iniFile, char *tempFile );
   int chk = RETURN_OK;

   if (StringLength( SRC_FILENAME ) < 1)   
      {
      UserInfo( CMsg( MSG_GTBT_ENTER_IN_FNAME, MSG_GTBT_ENTER_IN_FNAME_STR ),
                CMsg( MSG_GTBP_USER_ERROR, MSG_GTBP_USER_ERROR_STR ) 
              );

      return( (int) TRUE );
      }

   if (StringLength( SAVE_FILENAME ) < 1)   
      {
      UserInfo( CMsg( MSG_GTBT_ENTER_OUT_FNAME, MSG_GTBT_ENTER_OUT_FNAME_STR ),
                CMsg( MSG_GTBP_USER_ERROR, MSG_GTBP_USER_ERROR_STR ) 
              );

      return( (int) TRUE );
      }

   // Now we have to call the Code generator:
/*
   if ((chk = gtbGenATalk( SAVE_FILENAME, TTATemplateFile )) != RETURN_OK)
      {
      sprintf( extCommand, "gtbGenATalk( %s, %s )",
                         SAVE_FILENAME, TTATemplateFile 
             );
      
      sprintf( ErrMsg, CMsg( MSG_GTBT_FMT_TOOL_ERR, MSG_GTBT_FMT_TOOL_ERR_STR ),
                       extCommand
             );

      UserInfo( ErrMsg, CMsg( MSG_GTBT_INV_TOOL, MSG_GTBT_INV_TOOL_STR ) );

      fprintf( stderr, "%s\n  failed with ERROR#: %d", extCommand, chk );
      
      return( TRUE );
      }
*/
   UserInfo( CMsg( MSG_GTBT_PGM_DONE, MSG_GTBT_PGM_DONE_STR ), 
             CMsg( MSG_GTB_STATUS, MSG_GTB_STATUS_STR ) 
           );
   
   return( TRUE );
}

PRIVATE int ToolsLVClicked( void )
{
   return( TRUE ); // Don't do anything here (READ-ONLY)
}

PRIVATE int ExitBtClicked( void )
{
   return( PSCloseWindow() );
}

// Top ASL Button (Near Source File: String Gadget):

PRIVATE int GetSrcFileClicked( void )
{
   ULONG w = Scr->Width  - 300 < 300 ? 400 : Scr->Width - 450;
   ULONG h = Scr->Height - 50;
   
   SetTagItem( &FileTags[0], ASLFR_InitialWidth,     w );
   SetTagItem( &FileTags[0], ASLFR_InitialHeight,    h );
   SetTagItem( &FileTags[0], ASLFR_InitialTopEdge,  (ULONG) (Scr->Height - h) / 2 );  
   SetTagItem( &FileTags[0], ASLFR_InitialLeftEdge, (ULONG) (Scr->Width  - w) / 2 );
   SetTagItem( &FileTags[0], ASLFR_InitialPattern,  (ULONG) "#?.gui" );
   
   if (ASLClicked( SRCFILE_STRGAD, TTFilePath ) == TRUE)
      gotSrcFileName = TRUE;
   else
      gotSrcFileName = FALSE;
           
   return( TRUE );
}

// Lower ASL Button (near 'Save to File:' String Gadget):

PRIVATE int GetSaveFileClicked( void )
{
   ULONG w = Scr->Width  - 300 < 300 ? 400 : Scr->Width - 450;
   ULONG h = Scr->Height - 50;
   
   SetTagItem( &FileTags[0], ASLFR_InitialWidth,     w );
   SetTagItem( &FileTags[0], ASLFR_InitialHeight,    h );
   SetTagItem( &FileTags[0], ASLFR_InitialTopEdge,  (ULONG) (Scr->Height - h) / 2 );  
   SetTagItem( &FileTags[0], ASLFR_InitialLeftEdge, (ULONG) (Scr->Width  - w) / 2 );
   SetTagItem( &FileTags[0], ASLFR_InitialPattern,  (ULONG) "#?.ini" );

   savedPathSet = FALSE;

   if (ASLClicked( SAVFILE_STRGAD, TTSavePath ) == TRUE)
      gotSaveFileName = TRUE;
   else
      gotSaveFileName = FALSE;
           
   return( TRUE );
}

// -----------------------------------------------------------

PRIVATE void PSRender( void )
{
   ComputeFont( Scr, Font, &CFont, PSWidth, PSHeight );

   DrawBevelBox( PSWnd->RPort, 
                 CFont.OffX + ComputeX( CFont.FontX, 260 ),
                 CFont.OffY + ComputeY( CFont.FontY, 274 ),
                 ComputeX( CFont.FontX, 279 ),
                 ComputeY( CFont.FontY, 98 ),
                 GT_VisualInfo, VisualInfo, 
                 TAG_DONE 
               );

   DrawBevelBox( PSWnd->RPort, 
                 CFont.OffX + ComputeX( CFont.FontX, 20 ),
                 CFont.OffY + ComputeY( CFont.FontY, 274 ),
                 ComputeX( CFont.FontX, 165 ),
                 ComputeY( CFont.FontY, 98 ),
                 GT_VisualInfo, VisualInfo, 
                 TAG_DONE 
               );

   // Why is this necessary??
   SetWindowTitles( PSWnd, CMsg( MSG_GTBT_WTITLE, MSG_GTBT_WTITLE_STR ),
                           CMsg( MSG_GTBT_STITLE, MSG_GTBT_STITLE_STR ) 
                  );
   return;
}

PRIVATE int OpenPSWindow( void )
{
   struct NewGadget  ng;
   struct Gadget    *g;
   UWORD             lc, tc;
   UWORD             wleft, wtop, ww, wh;

   ComputeFont( Scr, Font, &CFont, PSWidth, PSHeight );
   
   ww = ComputeX( CFont.FontX, PSWidth  );
   wh = ComputeY( CFont.FontY, PSHeight );

   wleft = (Scr->Width  - PSWidth ) / 2;
   wtop  = (Scr->Height - PSHeight) / 2;

   if (!(g = CreateContext( &PSGList )))
      return( -1 );

   for (lc = 0, tc = 0; lc < PS_CNT; lc++) 
      {
      CopyMem( (char *) &PSNGad[ lc ], (char *) &ng, 
               (long) sizeof( struct NewGadget )
             );

      ng.ng_VisualInfo = VisualInfo;
      ng.ng_TextAttr   = &helvetica13; // Font;
      ng.ng_LeftEdge   = CFont.OffX + ComputeX( CFont.FontX, ng.ng_LeftEdge );
      ng.ng_TopEdge    = CFont.OffY + ComputeY( CFont.FontY, ng.ng_TopEdge );
      ng.ng_Width      = ComputeX( CFont.FontX, ng.ng_Width );
      ng.ng_Height     = ComputeY( CFont.FontY, ng.ng_Height);

      PSGadgets[ lc ] = g 
                      = CreateGadgetA( (ULONG) PSGTypes[ lc ], 
                                       g, 
                                       &ng, 
                                       (struct TagItem *) &PSGTags[ tc ] 
                                     );

      while (PSGTags[ tc ] != TAG_DONE) 
         tc += 2;

      tc++;   // Skip over TAG_DONE

      if (!g)
         return( -2 );
      }

   if (!(PSWnd = OpenWindowTags( NULL,

            WA_Left,         wleft,
            WA_Top,          wtop,
            WA_Width,        ww + CFont.OffX + Scr->WBorRight,  // PSWidth,
            WA_Height,       wh + CFont.OffY + Scr->WBorBottom, // PSHeight,

            WA_IDCMP,        STRINGIDCMP | LISTVIEWIDCMP | BUTTONIDCMP
              | IDCMP_GADGETUP | IDCMP_VANILLAKEY | IDCMP_REFRESHWINDOW,

            WA_Flags,        WFLG_DRAGBAR | WFLG_DEPTHGADGET
              | WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_RMBTRAP,

            WA_Gadgets,      PSGList,
            WA_Title,        PSWdt,
            WA_CustomScreen, Scr,
            TAG_DONE )))
      {
      return( -4 );
      }

   PSRender();

   GT_RefreshWindow( PSWnd, NULL );

   return( 0 );
}

PRIVATE int PSVanillaKey( int whichKey )
{
   int rval = TRUE;
   
   switch (whichKey)
      {
      case 'x':
      case 'X':
         rval = ExitBtClicked();
         break;

      case 'e':
      case 'E':
         rval = EditBtClicked();
         break;

      case 'v':
      case 'V':
         rval = ViewBtClicked();
         break;

      case 'c':
      case 'C':
         rval = outCBtClicked();
         break;

      case 'a':
      case 'A':
         rval = outABtClicked();
         break;

      case 's':
      case 'S':
         rval = GenMakeChkClicked();
         break;
   
      case 'l':
      case 'L':
         rval = GenLocChkClicked();
         break;
   
      case 'm':
      case 'M':
         rval = EditMkBtClicked();
         break;
   
      case 'o':
      case 'O':
         rval = EditLocBtClicked();
         break;

      case 'p':
      case 'P':
         rval = MakePrjBtClicked();
         break;
      }

   return( rval );
}

PRIVATE int HandlePSIDCMP( void )
{
   struct IntuiMessage *m;
   int                (*func)( void );
   BOOL                 running = TRUE;

   while (running == TRUE)
      {
      if (!(m = GT_GetIMsg( PSWnd->UserPort )))
         {
         (void) Wait( 1L << PSWnd->UserPort->mp_SigBit );

         continue;
         }

      CopyMem( (char *) m, (char *) &PSMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch (PSMsg.Class) 
         {
         case   IDCMP_REFRESHWINDOW:
            
            GT_BeginRefresh( PSWnd );
            
               PSRender();
            
            GT_EndRefresh( PSWnd, TRUE );
            
            break;

         case   IDCMP_CLOSEWINDOW:
            running = PSCloseWindow();
            break;

         case   IDCMP_VANILLAKEY:
            running = PSVanillaKey( PSMsg.Code );
            break;

         case   IDCMP_GADGETUP:
         case   IDCMP_GADGETDOWN:
            func = (int (*)( void )) ((struct Gadget *) PSMsg.IAddress)->UserData;
            
            if (func) // != NULL)
               running = func();
            
            break;
         }
      }

   return( running );
}

PRIVATE void closeLibraries( void )
{
#  ifdef __amigaos4__
   if (IGadTools)
      DropInterface( (struct Interface *) IGadTools );

   if (GadToolsBase)
      CloseLibrary( GadToolsBase );
#  else
   CloseLibs();

   if (UtilityBase)
      CloseLibrary( (struct Library *) UtilityBase );

   if (IconBase)
      CloseLibrary( IconBase );

   if (LocaleBase && openedLocaleBase == TRUE)
      {
      CloseLibrary( (struct Library *) LocaleBase );
      
      openedLocaleBase = FALSE;
      }
#  endif
      
   return;
}

PRIVATE void ShutdownProgram( void )
{
   if (lvm)
      Guarded_FreeLV( lvm ); // Free old listview space

   ClosePSWindow();
   CloseDownScreen();

   if (catalog)              // catalog can be NULL!
      CloseCatalog( catalog );

   closeLibraries();

   return;
}

PRIVATE int setupErrorNum = RETURN_OK;

// ------------------------------------------------------------------

PRIVATE int openLibraries( void )
{
#  ifndef __amigaos4__
   if (OpenLibs() < 0)
      {
      setupErrorNum = ERROR_INVALID_RESIDENT_LIBRARY;

      return( -1 );
      }
            
   if (!(UtilityBase = OpenLibrary( "utility.library", 39 )))
      {
      CloseLibs();

      setupErrorNum = ERROR_INVALID_RESIDENT_LIBRARY;

      return( -2 );
      }

   if (!(IconBase = OpenLibrary( "icon.library", 37L )))
      {
      CloseLibs();
      CloseLibrary( UtilityBase );

      setupErrorNum = ERROR_INVALID_RESIDENT_LIBRARY;

      return( -3 );
      }

   if (!(LocaleBase = (struct LocaleBase *) OpenLibrary( "locale.library", 39L )))
      {
      closeLibraries();

      setupErrorNum = ERROR_INVALID_RESIDENT_LIBRARY;

      return( -2 );
      }
   else
      openedLocaleBase = TRUE;

#  else
   if ((GadToolsBase = OpenLibrary( "gadtools.library", 50L )))
      {
      if (!(IGadTools = (struct GadToolsIFace *) GetInterface( GadToolsBase, "main", 1, NULL )))
         {
         closeLibraries();

         setupErrorNum = ERROR_INVALID_RESIDENT_LIBRARY;

         return( -2 );
	 }
      }
   else
      {
      closeLibraries();

      setupErrorNum = ERROR_INVALID_RESIDENT_LIBRARY;

      return( -2 );
      }
#  endif

   return( RETURN_OK );
}

PRIVATE int SetupProgram( void )
{
    if (openLibraries() != RETURN_OK)
       return( -1 );

   if (SetupScreen() < 0)
      {
      closeLibraries();

      setupErrorNum = ERROR_ON_OPENING_SCREEN;

      return( -5 );
      }   

   if (OpenPSWindow() < 0)
      {
      ShutdownProgram();

      setupErrorNum = ERROR_ON_OPENING_WINDOW;

      return( -6 );
      }   

   // NULL is for the Locale (from OpenLocale()): 
   catalog = OpenCatalog( NULL, "gtbproject.catalog",
                                OC_BuiltInLanguage, MY_LANGUAGE,
                                TAG_DONE 
                        );

   (void) SetupCatalog();

   return( RETURN_OK );   
}

PRIVATE void *processToolTypes( STRPTR *toolptr )
{
   if (!toolptr)
      return( NULL );

   TTSavePath   = GetToolStr( toolptr, SavePath,  DefSavePath     );
   TTProgram    = GetToolStr( toolptr, Program,   DefProgram      );
   TTCEncoder   = GetToolStr( toolptr, CEncoder,  DefCEncoder     );
   TTATEncoder  = GetToolStr( toolptr, ATEncoder, DefATalkEncoder );
   TTFilePath   = GetToolStr( toolptr, FilePath,  DefFilePath     );
//   DBG( fprintf( stderr, "TTFilePath = '%s'\n", TTFilePath ) );
   
   TTTextEditor = GetToolStr( toolptr, TextEditor, DefTextEditor  );
   TTTextViewer = GetToolStr( toolptr, TextViewer, DefTextViewer  );

   TTCTemplateFile = GetToolStr( toolptr, CTemplateFile, DefCTemplateFile );
   TTATemplateFile = GetToolStr( toolptr, ATemplateFile, DefATemplateFile );

   return( NULL );
}

SUBFUNC int CountTools( void )
{
   STRPTR *toolArray = NULL;
   STRPTR  tool      = NULL;
   int     i         = 20;
   
   if (diskobj)
      toolArray = (STRPTR *) diskobj->do_ToolTypes;
   else
      {
      UserInfo( "diskobj was NULL, returning default tool count value of 20!", "No Icon??" );
      return( i );
      }

   if (!toolArray)
      {
      UserInfo( "toolArray was NULL, returning default tool count value of 20!", "No Icon??" );
      return( i );
      }
   
   if (!(tool = toolArray[0]))
      {
      UserInfo( "toolArray[0] was NULL, returning default tool count value of 20!", " No Icon??" );
      return( i );
      }

   i = 0;

   while (StringLength( (UBYTE *) tool ) > 0) // No workee!
      {
      if (!(tool = toolArray[++i]))
         break;
      }
         
   return( i );
}

PRIVATE int SetupToolsListView( char *pgmName )
{
   STRPTR *toolArray = NULL; // diskobj->do_ToolTypes;
   int     i         = 0;

   if (diskobj)
      toolArray = diskobj->do_ToolTypes;

   if (!*toolArray)
      return( RETURN_OK );
       
   if ((ToolCount = CountTools()) < 1)
      return( RETURN_OK );

//   DBG( fprintf( stderr, "Allocating ListView memory...\n" ) );
   // Allocate memory here.
   if (!(lvm = Guarded_AllocLV( ToolCount, TOOLSIZE )))
      {
      // Memory allocation failure:
      SetReqButtons( CMsg( MSG_GTBT_AARRGG_BUTTON, MSG_GTBT_AARRGG_BUTTON_STR ) );

      UserInfo( CMsg( MSG_GTBT_NO_MEMORY, MSG_GTBT_NO_MEMORY_STR ),
                CMsg( MSG_GTBP_SYSTEM_PROBLEM, MSG_GTBP_SYSTEM_PROBLEM_STR )
              );

      ShutdownProgram();

      return( ERROR_NO_FREE_STORE );
      }

//   DBG( fprintf( stderr, "Setting up ListView...\n" ) );
   SetupList( &ToolsList, lvm ); // setup the listview Gadget Space

   for (i = 0; i < ToolCount; i++)
      {
      StringNCopy( &lvm->lvm_NodeStrs[ i * TOOLSIZE ], *(toolArray + i), TOOLSIZE );
      }

//   DBG( fprintf( stderr, "Modifying ListView...\n" ) );
   ModifyListView( TOOLS_LISTVIEW, PSWnd, &ToolsList, NULL );
   
   return( RETURN_OK );
}

PUBLIC int main( int argc, char **argv )
{
   struct WBArg  *wbarg;
   STRPTR        *toolptr = NULL;

   int            rval    = RETURN_OK;

//   DBG( fprintf( stderr, "Getting program name...\n" ) );
   (void) GetProgramName( programName, 255L );

//   DBG( fprintf( stderr, "Setting up program...\n" ) );
   if (SetupProgram() < 0)
      {
      fprintf( stderr, CMsg( MSG_GTBT_FMT_NO_SETUP, MSG_GTBT_FMT_NO_SETUP_STR ),
                       programName
             );
      
      return( IoErr() );
      }
    
   if (argc == 0)
      {
#     ifndef __amigaos4__
      wbarg   = &(_WBenchMsg->sm_ArgList[ _WBenchMsg->sm_NumArgs - 1 ]);
#     else
      wbarg   = &( __WBenchMsg->sm_ArgList[ __WBenchMsg->sm_NumArgs - 1 ]);
#     endif

      StringNCopy( programName, wbarg->wa_Name, 255 );

      (void) FindIcon( &processToolTypes, diskobj, programName );

      if ((diskobj = GetDiskObject( programName )))
         {
         toolptr = FindTools( diskobj, wbarg->wa_Name, wbarg->wa_Lock );

         processToolTypes( toolptr );
	 }
      }
   else 
      {
//      DBG( fprintf( stderr, "Processing ToolTypes...\n" ) );

      if (!(diskobj = GetDiskObject( argv[0] )))
         {
	 fprintf( stderr, "did NOT find the icon for %s!\n", argv[0] );
      
         rval = RETURN_FAIL;
         
         goto exitProgram; 
	 }

      (void) FindIcon( &processToolTypes, diskobj, argv[0] );
      }

//   DBG( fprintf( stderr, "Setting up Tools ListView...\n" ) );
   if (SetupToolsListView( programName ) != RETURN_OK)
      {
      sprintf( ErrMsg, CMsg( MSG_GTBT_FMT_NO_MEMORY, MSG_GTBT_FMT_NO_MEMORY_STR ),
                       programName
             );
      
      UserInfo( ErrMsg, CMsg( MSG_GTBP_SYSTEM_PROBLEM, MSG_GTBP_SYSTEM_PROBLEM_STR ));

      rval = RETURN_FAIL;
         
      goto exitProgram; 
      }

   SetTagItem( &FileTags[0], ASLFR_InitialPattern, (ULONG) "#?.gui" );
   FileTags[2].ti_Data = (ULONG) TTFilePath;
//   SetTagItem( &FileTags[0], ASLFR_InitialDrawer,  (ULONG) TTFilePath );
	   
   SetNotifyWindow( PSWnd );

//   DBG( fprintf( stderr, "Handling IDCMP...\n" ) );
   
   (void) HandlePSIDCMP();
   
exitProgram:

   if (diskobj)
      FreeDiskObject( diskobj );
   
   ShutdownProgram();
   
   return( rval );
}

/* -------------------- END of GTBTranslator.c file! ----------------- */
