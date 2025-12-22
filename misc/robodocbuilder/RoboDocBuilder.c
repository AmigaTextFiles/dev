/****h* RoboDocBuilder.c [3.0] *****************************************
*
* NAME
*    RoboDocBuilder.c
*
* DESCRIPTION
*    Read RoboDocBuilder.guide for more information on how to use this
*    program.
*
* SYNOPSIS 
*    RoboDocBuilder is a GUI for interfacing with RoboDoc.  It replaces
*    my CanDo! deck by the same name.
*
* HISTORY
*    24-Jan-2005 - Ported to AmigaOS4 & gcc.
*    15-Feb-2004 - Created this file.
*
* COPYRIGHT
*    RoboDocBuilder 15-Feb-2004(C) by J.T. Steichen, All Rights Reserved.
*
* NOTES
*    ToolTypes:
*
*      TABSIZE         = 3
*      TOOLEDITOR      = ToolTypesEditorPPC
*      BUILDCOMMAND    = RoboDoc
*      TEMPLATEPATH    = RoboDoc:RoboDocTemplates
*      COMMANDPATH     = C:
*      STRINGIDCHAR    = $
*      DEFAULTEDITOR   = C:Ed
*      DEFAULTLANGUAGE = C     (ASSY | BASIC | FORTRAN | LATEX | TEX | POSTSCRIPT)
*      DEFAULTOUTPUT   = GUIDE (ASCII | HTML | LATEX | RTF)
*
*    $VER: RoboDocBuilder 3.0 (24-Jan-2005) by J.T. Steichen
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
#include <intuition/gadgetclass.h>

#include <libraries/gadtools.h>

#include <workbench/workbench.h>
#include <workbench/startup.h>
#include <workbench/icon.h>

#include <utility/tagitem.h>
#include <dos/dostags.h>
#include <libraries/asl.h>

#include <graphics/displayinfo.h>
#include <graphics/gfxbase.h>

#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/graphics_protos.h>
#include <clib/utility_protos.h>
#include <clib/locale_protos.h>
#include <clib/diskfont_protos.h>

#define    ALLOCATE
# include <Author.h> // For authorName[] & authorEMail[].
#undef     ALLOCATE


#ifdef __amigaos4__

# define __USE_INLINE__

# include <proto/exec.h>
# include <proto/dos.h>
# include <proto/intuition.h>
# include <proto/graphics.h>
# include <proto/gadtools.h>
# include <proto/icon.h>
# include <proto/diskfont.h>
# include <proto/utility.h>
# include <proto/locale.h>

IMPORT struct Library *SysBase;
IMPORT struct Library *DOSBase;
IMPORT struct Library *IntuitionBase;
IMPORT struct Library *GfxBase;
IMPORT struct Library *IconBase;
IMPORT struct Library *DiskfontBase;
IMPORT struct Library *UtilityBase;
IMPORT struct Library *LocaleBase;

PUBLIC struct Library *GadToolsBase;

IMPORT struct ExecIFace      *IExec;
IMPORT struct DOSIFace       *IDOS;
IMPORT struct IntuitionIFace *IIntuition;
IMPORT struct GraphicsIFace  *IGraphics;
IMPORT struct IconIFace      *IIcon;
IMPORT struct DiskfontIFace  *IDiskfont;
IMPORT struct UtilityIFace   *IUtility;
IMPORT struct LocaleIFace    *ILocale;

PUBLIC struct GadToolsIFace  *IGadTools;

IMPORT  struct WBStartup  *__WBenchMsg;

PRIVATE char v[] = "\0$VER: RoboDocBuilderPPC 3.0 " __DATE__ " by J.T. Steichen\0";

#else

# include <proto/locale.h>

struct IntuitionBase *IntuitionBase;
struct GfxBase       *GfxBase;
struct Library       *GadToolsBase;
struct Library       *IconBase;
struct LocaleBase    *LocaleBase;

IMPORT  struct WBStartup  *_WBenchMsg;

PRIVATE char v[] = "\0$VER: RoboDocBuilder 2.0 " __AMIGADATE__ " by J.T. Steichen\0";

#endif

struct Catalog *catalog = NULL;

#define   CATCOMP_ARRAY    1
#include "RoboDocBuilderLocale.h"

#define  MY_LANGUAGE "english"

#include "CPGM:GlobalObjects/CommonFuncs.h"

#define ID_TemplateMX  0
#define ID_InFileStr   1
#define ID_InpASL      2
#define ID_OutputStr   3
#define ID_OutASL      4
#define ID_TabSizeInt  5
#define ID_EditSrcBt   6
#define ID_EditTmpBt   7
#define ID_GenerateBt  8
#define ID_XRefStr     9
#define ID_XRefASL     10
#define ID_GenXRefBt   11
#define ID_UseListBt   12
#define ID_RDDefsLV    13
#define ID_EditRDBt    14

#define RD_CNT         15

#define TAB_GAD        RDGadgets[ ID_TabSizeInt ]
#define INFILE_GAD     RDGadgets[ ID_InFileStr ]
#define OUTFILE_GAD    RDGadgets[ ID_OutputStr ]
#define XREF_GAD       RDGadgets[ ID_XRefStr ]

#define TAB_SIZE       IntBfPtr( TAB_GAD )
#define INFILE_NAME    StrBfPtr( INFILE_GAD )
#define OUTFILE_NAME   StrBfPtr( OUTFILE_GAD )
#define XREFFILE_NAME  StrBfPtr( XREF_GAD )

#define BUFFER_SIZE    256

// ----------------------------------------------------

PRIVATE struct DiskObject *diskobj = NULL;

PRIVATE struct Screen *RDScr        = NULL;
PRIVATE UBYTE         *PubScreenName = "Workbench";
PRIVATE APTR           VisualInfo    = NULL;

PRIVATE struct TextFont     *RDFont = NULL;
PRIVATE struct TextAttr     *Font, Attr;
PRIVATE struct CompFont      CFont = { 0, };

PRIVATE struct Window       *RDWnd   = NULL;
PRIVATE struct Menu         *RDMenus = NULL;
PRIVATE struct Gadget       *RDGList = NULL;
PRIVATE struct Gadget       *RDGadgets[ RD_CNT ] = { NULL, };

PRIVATE struct IntuiMessage  RDMsg = { 0, };

PRIVATE UWORD  RDLeft   = 77;
PRIVATE UWORD  RDTop    = 16;
PRIVATE UWORD  RDWidth  = 615;
PRIVATE UWORD  RDHeight = 490;
PRIVATE UBYTE *RDWdt    = NULL;   // WA_Title
PRIVATE UBYTE *ScrTitle = NULL;   // WA_ScreenTitle

// -------------------------------------------------------

#define RDLV_NUM_ELEMENTS   100
#define ELEMENT_SIZE        80

PRIVATE struct List         RD_List = { 0, };
PRIVATE struct ListViewMem *RD_Lvm  = NULL;

// -------------------------------------------------------

PRIVATE struct TextAttr helvetica13 = { "helvetica.font", 13, 0x00, 0x62 };

// TTTTTTTTT RoboDocBuilder ToolTypes: TTTTTTTTT

PRIVATE char ToolEditor[32]      = "TOOLEDITOR";
PRIVATE char TabSize[32]         = "TABSIZE";
PRIVATE char BuildCmd[32]        = "BUILDCOMMAND";
PRIVATE char TemplatePath[32]    = "TEMPLATEPATH";
PRIVATE char CommandPath[32]     = "COMMANDPATH";
PRIVATE char StringIDChar[32]    = "STRINGIDCHAR";
PRIVATE char DefaultEditor[32]   = "DEFAULTEDITOR";
PRIVATE char DefaultLanguage[32] = "DEFAULTLANGUAGE";
PRIVATE char DefaultOutput[32]   = "DEFAULTOUTPUT";

#ifdef __amigaos4__
PRIVATE char DefToolEditor[128]             = "ToolTypesEditorPPC";
#else
PRIVATE char DefToolEditor[128]             = "ToolTypesEditor";
#endif

PRIVATE char DefBuildCmd[512]               = "RoboDoc";
PRIVATE char DefTemplatePath[ BUFFER_SIZE ] = "RoboDoc:RoboDocTemplates";
PRIVATE char DefCommandPath[ BUFFER_SIZE ]  = "C:";
PRIVATE char DefStringIDChar[128]           = "$";
PRIVATE char DefDefaultEditor[128]          = "C:Ed";
PRIVATE char DefDefaultLanguage[128]        = "C";
PRIVATE char DefDefaultOutput[128]          = "Guide";
PRIVATE int  DefTabSize                     = 3;

PRIVATE char *TTToolEditor      = &DefToolEditor[0];
PRIVATE char *TTBuildCmd        = &DefBuildCmd[0];
PRIVATE char *TTTemplatePath    = &DefTemplatePath[0];
PRIVATE char *TTCommandPath     = &DefCommandPath[0];
PRIVATE char *TTStringIDChar    = &DefStringIDChar[0];
PRIVATE char *TTDefaultEditor   = &DefDefaultEditor[0];
PRIVATE char *TTDefaultLanguage = &DefDefaultLanguage[0];
PRIVATE char *TTDefaultOutput   = &DefDefaultOutput[0];
PRIVATE int   TTTabSize         =  3; // DefTabSize

// TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT

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
   ASLFR_InitialDrawer,   (ULONG) "",
   ASLFR_Flags1,          FRF_DOPATTERNS,
   ASLFR_Flags2,          FRF_REJECTICONS,
   ASLFR_SleepWindow,     1,
   ASLFR_PrivateIDCMP,    1,
   TAG_END 
};

PRIVATE UBYTE programName[80] = "RoboDocBuilder";

PRIVATE UBYTE em[ 2 * BUFFER_SIZE ] = { 0, }, *ErrMsg = &em[0];

PRIVATE UBYTE command[ 4 * BUFFER_SIZE ] = { 0, };

// --------- User-controlled (via GUI) settings: -----------------

PRIVATE int tabSize = 3;

#define MAIN_TEMPLATE 0
#define HEAD_TEMPLATE 1
#define INT_TEMPLATE  2
#define FULL_TEMPLATE 3

PRIVATE int templateType = MAIN_TEMPLATE;

#define SRC_ASSY    0
#define SRC_C       1
#define SRC_BASIC   2
#define SRC_FORTRAN 3
#define SRC_LATEX   4
#define SRC_TEX     5
#define SRC_POST    6
   
PRIVATE int sourceType = SRC_C;

#define OUT_ASCII   0
#define OUT_AGUIDE  1
#define OUT_HTML    2
#define OUT_LATEX   3
#define OUT_RTF     4

PRIVATE int outputType = OUT_AGUIDE;

PRIVATE BOOL sortOutput       = FALSE;
PRIVATE BOOL addTOC           = FALSE;
PRIVATE BOOL includeInternals = FALSE;
PRIVATE BOOL internalOnly     = FALSE;

PRIVATE UBYTE currentPath[        BUFFER_SIZE ] = { 0, }; // Remember the last file path setting.
PRIVATE UBYTE inputFileName[  2 * BUFFER_SIZE ] = { 0, };
PRIVATE UBYTE outputFileName[ 2 * BUFFER_SIZE ] = { 0, };
PRIVATE UBYTE xrefFileName[   2 * BUFFER_SIZE ] = { 0, };

// ----------------------------------------------------------------

PRIVATE int EditToolsMI(      void );
PRIVATE int AboutMI(          void );
PRIVATE int HelpMI(           void );
PRIVATE int QuitMI(           void );
// Source Type »
PRIVATE int AssySrcMI(        void );
PRIVATE int CSrcMI(           void );
PRIVATE int BasicSrcMI(       void );
PRIVATE int FortranSrcMI(     void );
PRIVATE int LatexSrcMI(       void );
PRIVATE int TexSrcMI(         void );
PRIVATE int PostScriptSrcMI(  void );
// Output Type »
PRIVATE int AsciiOutMI(       void );
PRIVATE int AmigaGuideOutMI(  void );
PRIVATE int HtmlOutMI(        void );
PRIVATE int LatexOutMI(       void );
PRIVATE int RtfOutMI(         void );
// BAR_LABEL
PRIVATE int SortedOutMI(      void );
PRIVATE int AddTOCMI(         void );
PRIVATE int IncludeIntDocsMI( void );
PRIVATE int InternalOnlyMI(   void );

PRIVATE struct NewMenu RDNMenu[ 26 ] = {

   NM_TITLE, "PROJECT", NULL, 0, 0L, NULL,

    NM_ITEM, "Edit ToolTypes...", 0, 0x0000, 0L, (APTR) EditToolsMI,

    NM_ITEM, "About..",         "I", 0x0000, 0L, (APTR) AboutMI,

    NM_ITEM, "Help!",           "H", 0x0000, 0L, (APTR) HelpMI,

    NM_ITEM, "Quit",            "Q", 0x0000, 0L, (APTR) QuitMI,

   NM_TITLE, "PREFERENCES", NULL, 0, 0L, NULL,

    NM_ITEM, "Source Type »", 0, 0x0000, 0L, (APTR) NULL,

     NM_SUB, "Assembly",      0, 0x0009, 0L, (APTR) AssySrcMI,

     NM_SUB, "C",             0, 0x0109, 0L, (APTR) CSrcMI,

     NM_SUB, "BASIC",         0, 0x0009, 0L, (APTR) BasicSrcMI,

     NM_SUB, "FORTRAN",       0, 0x0009, 0L, (APTR) FortranSrcMI,

     NM_SUB, "LaTeX",         0, 0x0009, 0L, (APTR) LatexSrcMI,

     NM_SUB, "TeX",           0, 0x0009, 0L, (APTR) TexSrcMI,

     NM_SUB, "PostScript",    0, 0x0009, 0L, (APTR) PostScriptSrcMI,

    NM_ITEM, "Output Type »", 0, 0x0000, 0L, (APTR) NULL,

     NM_SUB, "ASCII",         0, 0x0009, 0L, (APTR) AsciiOutMI,

     NM_SUB, "AmigaGuide",    0, 0x0109, 0L, (APTR) AmigaGuideOutMI,

     NM_SUB, "HTML",          0, 0x0009, 0L, (APTR) HtmlOutMI,

     NM_SUB, "LaTeX",         0, 0x0009, 0L, (APTR) LatexOutMI,

     NM_SUB, "RTF",           0, 0x0009, 0L, (APTR) RtfOutMI,

    NM_ITEM, (STRPTR) NM_BARLABEL, NULL, 0, 0L, NULL,
    // ---------------------------------------------

    NM_ITEM, "Sort Output",            0, 0x0009, 0L, (APTR) SortedOutMI,

    NM_ITEM, "Add Table of Contents",  0, 0x0009, 0L, (APTR) AddTOCMI,

    NM_ITEM, "Include Internal Doc's", 0, 0x0009, 0L, (APTR) IncludeIntDocsMI,

    NM_ITEM, "Internal Doc's only!",   0, 0x0009, 0L, (APTR) InternalOnlyMI,

   NM_END, NULL, NULL, 0, 0L, NULL

};

PRIVATE UWORD RDGTypes[ RD_CNT ] = {

       MX_KIND,   STRING_KIND,  BUTTON_KIND, 
   STRING_KIND,   BUTTON_KIND, INTEGER_KIND, 
   BUTTON_KIND,   BUTTON_KIND,  BUTTON_KIND,
   STRING_KIND,   BUTTON_KIND,  BUTTON_KIND,
   BUTTON_KIND, LISTVIEW_KIND,  BUTTON_KIND,
};

#define TemplateMX_CNT   5

/*
** MX_KIND Gadgets have to use UBYTE *mxChoice[] types of Strings,
** UBYTE mxChoice[][] does not work with GadTools.library!
*/ 

PRIVATE UBYTE *TemplateTypes[ TemplateMX_CNT ] = {

   NULL, NULL, NULL, NULL, NULL, // Initialized later
};

// The real MX Choice strings are in here:

PRIVATE UBYTE T1[32] = "Edit Main     Template";
PRIVATE UBYTE T2[32] = "Edit Header   Template";
PRIVATE UBYTE T3[32] = "Edit Internal Template";
PRIVATE UBYTE T4[32] = "Edit Full     Template";

PRIVATE int TemplateMXClicked( int whichType );
PRIVATE int InFileStrClicked(  int dummy );
PRIVATE int InpASLClicked(     int dummy );
PRIVATE int OutputStrClicked(  int dummy );
PRIVATE int OutASLClicked(     int dummy );
PRIVATE int TabSizeIntClicked( int dummy );
PRIVATE int EditSrcBtClicked(  int dummy );
PRIVATE int EditTmpBtClicked(  int dummy );
PRIVATE int GenerateBtClicked( int dummy );
PRIVATE int XRefStrClicked(    int dummy );
PRIVATE int XRefASLClicked(    int dummy );
PRIVATE int GenXRefBtClicked(  int dummy );
PRIVATE int UseListBtClicked(  int dummy );
PRIVATE int RDDefsLVClicked(   int dummy );
PRIVATE int EditRDBtClicked(   int dummy );

PRIVATE struct NewGadget RDNGad[ RD_CNT ] = {

   230, 105,  17,   9, NULL, NULL,
   ID_TemplateMX, PLACETEXT_RIGHT, NULL, (APTR) TemplateMXClicked,

   123,  24, 400,  20, "Input Source File:", NULL,
   ID_InFileStr, PLACETEXT_LEFT, NULL, (APTR) InFileStrClicked,

   530,  27,  40,  20, "ASL", NULL,
   ID_InpASL, 0, NULL, (APTR) InpASLClicked,

   123,  50, 400,  20, "Output File:", NULL,
   ID_OutputStr, PLACETEXT_LEFT, NULL, (APTR) OutputStrClicked,

   530,  53,  40,  20, "ASL", NULL,
   ID_OutASL, 0, NULL, (APTR) OutASLClicked,

   123,  78,  41,  21, "Tab Size:", NULL,
   ID_TabSizeInt, PLACETEXT_LEFT, NULL, (APTR) TabSizeIntClicked,

   420,  83, 167,  21, "Edit _Source File...", NULL,
   ID_EditSrcBt, PLACETEXT_IN, NULL, (APTR) EditSrcBtClicked,

   420, 112, 165,  21, "Edit _Template File...", NULL,
   ID_EditTmpBt, PLACETEXT_IN, NULL, (APTR) EditTmpBtClicked,

    23, 141, 166,  21, "_Generate Document!", NULL,
   ID_GenerateBt, PLACETEXT_IN, NULL, (APTR) GenerateBtClicked,

   123, 202, 400,  20, "XRef Output:", NULL,
   ID_XRefStr, PLACETEXT_LEFT, NULL, (APTR) XRefStrClicked,

   530, 205,  40,  20, "ASL", NULL,
   ID_XRefASL, 0, NULL, (APTR) XRefASLClicked,

    46, 232, 137,  21, "Generate _XRef", NULL,
   ID_GenXRefBt, PLACETEXT_IN, NULL, (APTR) GenXRefBtClicked,

   205, 232, 137,  21, "Use XRef list file", NULL,
   ID_UseListBt, PLACETEXT_IN, NULL, (APTR) UseListBtClicked,

   108, 280, 428, 208, "RoboDoc.defaults:", NULL,
   ID_RDDefsLV, NG_HIGHLABEL | PLACETEXT_ABOVE, NULL, (APTR) RDDefsLVClicked,

   420, 141, 165,  21, "Edit _RoboDoc.defaults...", NULL,
   ID_EditRDBt, PLACETEXT_IN, NULL, (APTR) EditRDBtClicked,
};

PRIVATE ULONG RDGTags[] = {

   GTMX_Labels,  (ULONG) TemplateTypes, 
   GTMX_Spacing, 2, 
   TAG_DONE,

   GTST_MaxChars, BUFFER_SIZE, TAG_DONE,

   TAG_DONE,                      // Input ASL Button
   
   GTST_MaxChars, BUFFER_SIZE, TAG_DONE,

   TAG_DONE,                      // Output ASL Button
   
   GA_TabCycle,           FALSE,  // TabSize Integer Gadget
   GTIN_Number,           3, 
   GTIN_MaxChars,         3, 
   STRINGA_Justification, 512, 
   TAG_DONE,

   GT_Underscore, '_', TAG_DONE,

   GT_Underscore, '_', TAG_DONE,

   GT_Underscore, '_', TAG_DONE,

   GTST_MaxChars, BUFFER_SIZE, TAG_DONE,

   TAG_DONE,                      // XRef ASL Button   
   
   GT_Underscore, '_', TAG_DONE,

   TAG_DONE,                      // 'Use XRef list file' Button

   GTLV_Labels,           (ULONG) NULL, 
   LAYOUTA_Spacing,       2, 
   GTLV_ReadOnly,         TRUE, 
   TAG_DONE,

   GT_Underscore, '_', TAG_DONE,
};

PRIVATE struct IntuiText RDIT = {

   2, 0, JAM1, 251,  94, NULL, "Template Types:", NULL
};

// ----------------------------------------------------

/****i* CMsg() [1.0] *************************************************
*
* NAME
*    CMsg()
*
* SYNOPSIS
*    STRPTR msgString = CMsg( int index, STRPTR defaultStr );
*
* DESCRIPTION
*    Obtain a string from the locale catalog file, failing that,
*    return the default string.
**********************************************************************
*
*/

PRIVATE STRPTR CMsg( int strIndex, STRPTR defaultString )
{
   if (catalog) // != NULL)
      return( (STRPTR) GetCatalogStr( catalog, strIndex, defaultString ) );
   else
      return( (STRPTR) defaultString );
}

/****i* SetupCatalog() [1.0] *****************************************
*
* NAME
*    SetupCatalog()
*
* SYNOPSIS
*    void SetupCatalog( void );
*
* DESCRIPTION
*    Initialize the program with the User's native language, assuming
*    that it is NOT English.
**********************************************************************
*
*/

PRIVATE void SetupCatalog( void )
{
   ScrTitle = CMsg( MSG_RD_STITLE, MSG_RD_STITLE_STR ); // WA_ScreenTitle
   RDWdt    = CMsg( MSG_RD_WTITLE, MSG_RD_WTITLE_STR ); // WA_Title

   // MX Gadget selections:

   StringNCopy( &T1[0], CMsg( MSG_TTYPE_Main,     MSG_TTYPE_Main_STR     ), 32 );
   StringNCopy( &T2[0], CMsg( MSG_TTYPE_Header,   MSG_TTYPE_Header_STR   ), 32 );
   StringNCopy( &T3[0], CMsg( MSG_TTYPE_Internal, MSG_TTYPE_Internal_STR ), 32 );
   StringNCopy( &T4[0], CMsg( MSG_TTYPE_Full,     MSG_TTYPE_Full_STR     ), 32 );

   TemplateTypes[0] = &T1[0];
   TemplateTypes[1] = &T2[0];
   TemplateTypes[2] = &T3[0];
   TemplateTypes[3] = &T4[0];
   TemplateTypes[4] = NULL;   // Necessary evil = '\0';
   
   //         MX Gadget = 0
   RDNGad[  1 ].ng_GadgetText = CMsg( MSG_GAD_InFileStr, MSG_GAD_InFileStr_STR );
   RDNGad[  2 ].ng_GadgetText = CMsg( MSG_GAD_InFileASL, MSG_GAD_InFileASL_STR );
   RDNGad[  3 ].ng_GadgetText = CMsg( MSG_GAD_OutputStr, MSG_GAD_OutputStr_STR );
   RDNGad[  4 ].ng_GadgetText = CMsg( MSG_GAD_OutputASL, MSG_GAD_OutputASL_STR );
   RDNGad[  5 ].ng_GadgetText = CMsg( MSG_GAD_TabSizeInt, MSG_GAD_TabSizeInt_STR );
   RDNGad[  6 ].ng_GadgetText = CMsg( MSG_GAD_EditSrcBt,  MSG_GAD_EditSrcBt_STR );
   RDNGad[  7 ].ng_GadgetText = CMsg( MSG_GAD_EditTmpBt,  MSG_GAD_EditTmpBt_STR );
   RDNGad[  8 ].ng_GadgetText = CMsg( MSG_GAD_GenerateBt, MSG_GAD_GenerateBt_STR );
   RDNGad[  9 ].ng_GadgetText = CMsg( MSG_GAD_XRefStr,    MSG_GAD_XRefStr_STR );
   RDNGad[ 10 ].ng_GadgetText = CMsg( MSG_GAD_XRefASL,    MSG_GAD_XRefASL_STR );
   RDNGad[ 11 ].ng_GadgetText = CMsg( MSG_GAD_GenXRefBt, MSG_GAD_GenXRefBt_STR );
   RDNGad[ 12 ].ng_GadgetText = CMsg( MSG_GAD_UseListBt, MSG_GAD_UseListBt_STR );
   RDNGad[ 13 ].ng_GadgetText = CMsg( MSG_GAD_RDDefsLV,  MSG_GAD_RDDefsLV_STR );
   RDNGad[ 14 ].ng_GadgetText = CMsg( MSG_GAD_EditRDBt,  MSG_GAD_EditRDBt_STR );

   // Menus ---------------------------------------------------------

   RDNMenu[  0 ].nm_Label = CMsg( MSG_MENU_PROJECT,  MSG_MENU_PROJECT_STR );
   RDNMenu[  1 ].nm_Label = CMsg( MSG_MENU_Edit,     MSG_MENU_Edit_STR );
   RDNMenu[  2 ].nm_Label = CMsg( MSG_MENU_About,    MSG_MENU_About_STR );
   RDNMenu[  3 ].nm_Label = CMsg( MSG_MENU_Help,     MSG_MENU_Help_STR );
   RDNMenu[  4 ].nm_Label = CMsg( MSG_MENU_Quit,     MSG_MENU_Quit_STR );

   RDNMenu[  5 ].nm_Label = CMsg( MSG_MENU_PREFERENCES, MSG_MENU_PREFERENCES_STR );
   RDNMenu[  6 ].nm_Label = CMsg( MSG_MENU_Source,      MSG_MENU_Source_STR );
   RDNMenu[  7 ].nm_Label = CMsg( MSG_MENU_Assembly,    MSG_MENU_Assembly_STR );
   RDNMenu[  8 ].nm_Label = CMsg( MSG_MENU_C,           MSG_MENU_C_STR );
   RDNMenu[  9 ].nm_Label = CMsg( MSG_MENU_BASIC,       MSG_MENU_BASIC_STR );
   RDNMenu[ 10 ].nm_Label = CMsg( MSG_MENU_FORTRAN,     MSG_MENU_FORTRAN_STR );
   RDNMenu[ 11 ].nm_Label = CMsg( MSG_MENU_LaTeX,       MSG_MENU_LaTeX_STR );
   RDNMenu[ 12 ].nm_Label = CMsg( MSG_MENU_TeX,         MSG_MENU_TeX_STR );
   RDNMenu[ 13 ].nm_Label = CMsg( MSG_MENU_PostScript,  MSG_MENU_PostScript_STR );

   RDNMenu[ 14 ].nm_Label = CMsg( MSG_MENU_Output,     MSG_MENU_Output_STR );
   RDNMenu[ 15 ].nm_Label = CMsg( MSG_MENU_ASCII,      MSG_MENU_ASCII_STR );
   RDNMenu[ 16 ].nm_Label = CMsg( MSG_MENU_AmigaGuide, MSG_MENU_AmigaGuide_STR );
   RDNMenu[ 17 ].nm_Label = CMsg( MSG_MENU_HTML,       MSG_MENU_HTML_STR );
   RDNMenu[ 18 ].nm_Label = CMsg( MSG_MENU_LaTeX,      MSG_MENU_LaTeX_STR );
   RDNMenu[ 19 ].nm_Label = CMsg( MSG_MENU_RTF,        MSG_MENU_RTF_STR );
   // BAR_LABEL ----------------------------------------------------------------
   RDNMenu[ 21 ].nm_Label = CMsg( MSG_MENU_Sort,     MSG_MENU_Sort_STR );
   RDNMenu[ 22 ].nm_Label = CMsg( MSG_MENU_Add,      MSG_MENU_Add_STR );
   RDNMenu[ 23 ].nm_Label = CMsg( MSG_MENU_Include,  MSG_MENU_Include_STR );
   RDNMenu[ 24 ].nm_Label = CMsg( MSG_MENU_Internal, MSG_MENU_Internal_STR );

   FileTags[1].ti_Data = (ULONG) CMsg( MSG_ASL_RTITLE,    MSG_ASL_RTITLE_STR    );
   FileTags[6].ti_Data = (ULONG) CMsg( MSG_ASL_OKAY_BT,   MSG_ASL_OKAY_BT_STR   );
   FileTags[7].ti_Data = (ULONG) CMsg( MSG_ASL_CANCEL_BT, MSG_ASL_CANCEL_BT_STR );

   return;
}

// ----------------------------------------------------------------

/****i* displayMessage() [3.0] ************************************
*
* NAME
*    displayMessage()
*
* SYNOPSIS
*    void displayMessage( char *msg );
*
* DESCRIPTION
*    Change the main GUI Window Title to the msg given for 3
*    seconds, then restore the original title.
*******************************************************************
*
*/

SUBFUNC void displayMessage( char *msg )
{
   DisplayTitle( RDWnd, msg );
   
   Delay( 150 ); // Show message for 3 seconds.
   
   DisplayTitle( RDWnd, RDWdt );
   
   return;
}

/****i* runCommand() [3.0] ****************************************
*
* NAME
*    runCommand()
*
* SYNOPSIS
*    void runCommand( UBYTE *thisCommand );
*
* DESCRIPTION
*    Ask the AmigaOS to run the command given.  If anything
*    other than RETURN_OK is returned, the User will see an 
*    System Error Requester about the returned value.
*******************************************************************
*
*/

SUBFUNC void runCommand( UBYTE *thisCommand )
{
   if (StringLength( thisCommand ) > 0)
      {
      int chk = RETURN_OK;
      
      if ((chk = System( thisCommand, TAG_DONE )) != RETURN_OK)
         {
         sprintf( ErrMsg, CMsg( MSG_FMT_BAD_CMD, MSG_FMT_BAD_CMD_STR ), 
                          thisCommand 
                );
         
         (void) Handle_Problem( ErrMsg, 
                                CMsg( MSG_CHK_TOOL, MSG_CHK_TOOL_STR ), 
                                &chk 
                              );
         }
      }
      
   return;
}

// -----------------------------------------------------------------

/****i* makeTemplateFileName() [3.0] *******************************
*
* NAME
*    makeTemplateFileName()
*
* SYNOPSIS
*    char *templateFileName = makeTemplateFileName( void );
*
* DESCRIPTION
*    Using the TemplatePath ToolType make a path:templateFileName
*    that contains "RoboDoc.defaults".
********************************************************************
*
*/

PRIVATE char RDTemplate[ 2 * BUFFER_SIZE ] = { 0, };

SUBFUNC char *makeTemplateFileName( void )
{
   int len = StringLength( TTTemplatePath ) - 1;
   
   StringNCopy( &RDTemplate[0], TTTemplatePath, BUFFER_SIZE );

   if (TTTemplatePath[len] == ':' || TTTemplatePath[len] == '/')
      {
      StringCat( &RDTemplate[0], "RoboDoc.defaults" );
      }
   else
      {
      StringCat( &RDTemplate[0], "/RoboDoc.defaults" );
      }
      
   return( &RDTemplate[0] );   
}

/****i* ReadInRD_Defaults() [3.0] *********************************
*
* NAME
*    ReadInRD_Defaults()
*
* SYNOPSIS
*    void ReadInRD_Defaults( void );
*
* DESCRIPTION
*    Read in the RoboDoc.defaults file & place the contents in the
*    ListView Gadget.
*******************************************************************
*
*/

SUBFUNC void ReadInRD_Defaults( void )
{
   FILE *defp                = NULL;
   char *fileName            = makeTemplateFileName();
   char  tmp[ ELEMENT_SIZE ] = { 0, };
   int   k                   = 0;

   
   if (!(defp = OpenFile( fileName, "r" ))) // == NULL)
      {
      sprintf( ErrMsg, CMsg( MSG_FMT_NO_FILEOPEN, MSG_FMT_NO_FILEOPEN_STR ), fileName );
      
      UserInfo( ErrMsg, CMsg( MSG_CHK_TOOL, MSG_CHK_TOOL_STR ) );
      
      goto exitReadIn;
      }
     
   for (k = 0; k < RDLV_NUM_ELEMENTS; k++)
      {
      int len = 0;

      tmp[0] = '\0'; // Kill old contents (if any)
            
      fgets( &tmp[0], ELEMENT_SIZE, defp );

      len = StringLength( &tmp[0] ) - 1;

      // ListView Gadgets display newlines as an unknown character, so...

      if (tmp[ len ] == '\n')
         tmp[ len ] = '\0';   // Strip off newline at end of string
      
      if (StringLength( &tmp[0] ) > 0)      
         StringNCopy( &RD_Lvm->lvm_NodeStrs[ k * ELEMENT_SIZE ], &tmp[0], ELEMENT_SIZE );
      else
         break;
      }

   if (defp) // != NULL)
      fclose( defp );

   ModifyListView( RDGadgets[ ID_RDDefsLV ], RDWnd, &RD_List, NULL );

exitReadIn:
      
   return;
}

/****i* resetLVStrings() [3.0] ************************************
*
* NAME
*    resetLVStrings()
*
* SYNOPSIS
*    void resetLVStrings( void );
*
* DESCRIPTION
*    Clear the ListView Gadget contents.
*******************************************************************
*
*/

SUBFUNC void resetLVStrings( void )
{
   int k;
   
   for (k = 0; k < RDLV_NUM_ELEMENTS; k++)
      RD_Lvm->lvm_NodeStrs[ k * ELEMENT_SIZE ] = '\0';

   return;
}
            
// -----------------------------------------------------------------

/****i* OpenRDScreen() [3.0] ***************************************
*
* NAME
*    OpenRDScreen()
*
* SYNOPSIS
*    int success = OpenRDScreen( void )
*
* DESCRIPTION
*    Setup the Program environmental Screen.  Return RETURN_OK
*    if successful, otherwise return a negative number.
********************************************************************
*
*/

PRIVATE BOOL UnlockFlag = FALSE;

PRIVATE int OpenRDScreen( void )
{
   struct Screen *chk = GetActiveScreen();

   if (!(RDFont = OpenDiskFont( &helvetica13 ))) // == NULL)
      return( -5 );

   Font = &Attr;

   if (!(RDScr = LockPubScreen( PubScreenName ))) // == NULL)
      return( -1 );

   if (chk != RDScr)
      {
      UnlockPubScreen( NULL, RDScr );
      RDScr = chk;
      UnlockFlag = FALSE;
      }
   else
      UnlockFlag = TRUE;

   ComputeFont( RDScr, Font, &CFont, 0, 0 );

   if (!(VisualInfo = GetVisualInfo( RDScr, TAG_DONE ))) // == NULL)
      return( -2 );

   return( 0 );
}

/****i* CloseRDScreen() [3.0] **************************************
*
* NAME
*    CloseRDScreen()
*
* SYNOPSIS
*    void CloseRDScreen( void );
*
* DESCRIPTION
*    Return the GUI Screen resources to the OS. 
********************************************************************
*
*/

PRIVATE void CloseRDScreen( void )
{
   if (VisualInfo) // != NULL)
      {
      FreeVisualInfo( VisualInfo );

      VisualInfo = NULL;
      }

   if ((UnlockFlag == TRUE) && RDScr) // != NULL))
      {
      UnlockPubScreen( NULL, RDScr );

      RDScr = NULL;
      }

   if (RDFont) // != NULL) 
      {
      CloseFont( RDFont );

      RDFont = NULL;
      }

   return;
}

/****i* CloseRDWindow() [3.0] **************************************
*
* NAME
*    CloseRDWindow()
*
* SYNOPSIS
*    void CloseRDWindow( void );
*
* DESCRIPTION
*    Return the GUI Window resources to the OS.
********************************************************************
*
*/

PRIVATE void CloseRDWindow( void )
{
   if (RDMenus) // != NULL)
      {
      ClearMenuStrip( RDWnd );
      FreeMenus( RDMenus );
      RDMenus = NULL;
      }

   if (RDWnd) // != NULL)
      {
      CloseWindow( RDWnd );

      RDWnd = NULL;
      }

   if (RDGList) // != NULL)
      {
      FreeGadgets( RDGList );

      RDGList = NULL;
      }

   return;
}

/****i* SetItemFlags() [3.0] ******************************************
*
* NAME
*    SetItemFlags()
*
* SYNOPSIS
*    void SetItemFlags( char *itemTitle, int newFlags );
*
* DESCRIPTION
*    Set the flags for the given menu item (usually CHECKED or ~CHECKED)
*    are the only settings that this function is used for.
***********************************************************************
*
*/

SUBFUNC void SetItemFlags( char *itemTitle, int newFlags )
{
   struct MenuItem *sub = NULL;
   UWORD            oldFlags = 0;
 
   if (!itemTitle)
      return;  
   
   if (StringLength( itemTitle ) < 1)
      return;
                                   // CommonFuncs function:   
   if (!(sub = (struct MenuItem *) CFFindMenuPtr( RDWnd->MenuStrip, itemTitle ))) // == NULL)
      return;

   oldFlags   = sub->Flags & 0x30C0; // Mask off Intuition flags. 

   // Restore oldFlags & add new ones:

   sub->Flags = (newFlags & 0xCF3F) | oldFlags; 
   
   return;
}

/****h* CheckMenuItem() [3.0] *****************************************
*
* NAME
*    CheckMenuItem()
*
* SYNOPSIS
*    void CheckMenuItem( char *miStr, BOOL chkState );
*
* DESCRIPTION
*    Set/reset the check state of menuitem specified by miStr.
***********************************************************************
*
*/

PUBLIC void CheckMenuItem( char *miStr, BOOL chkState )
{
   UWORD menuFlags = CHECKIT | MENUTOGGLE | ITEMTEXT | ITEMENABLED; 

   if (chkState == TRUE)
      menuFlags |= CHECKED;
   else
      menuFlags &= ~CHECKED;

   SetItemFlags( miStr, menuFlags );
   
   return;   
}

/****i* ResetMenuCheck() [2.0] ****************************************
*
* NAME
*    ResetMenuCheck()
*
* SYNOPSIS
*    void ResetMenuCheck( char *menuName );
*
* DESCRIPTION
*    Clear the checkmark for menuitem specified by menuName.
***********************************************************************
*
*/

SUBFUNC void ResetMenuCheck( char *menuName )
{
   SetItemFlags( menuName, CHECKIT | MENUTOGGLE | ITEMTEXT | ITEMENABLED );

   return;
}

/****i* ResetSrcTypeChecks() [3.0] *********************************
*
* NAME
*    ResetSrcTypeChecks()
*
* SYNOPSIS
*    void ResetSrcTypeChecks( void );
*
* DESCRIPTION
*    Clear the checkmarks for all the Source Type menuItems.
********************************************************************
*
*/

SUBFUNC void ResetSrcTypeChecks( void )
{
   ResetMenuCheck( CMsg( MSG_MENU_Assembly,   MSG_MENU_Assembly_STR   ) );
   ResetMenuCheck( CMsg( MSG_MENU_C,          MSG_MENU_C_STR          ) );
   ResetMenuCheck( CMsg( MSG_MENU_BASIC,      MSG_MENU_BASIC_STR      ) );
   ResetMenuCheck( CMsg( MSG_MENU_FORTRAN,    MSG_MENU_FORTRAN_STR    ) );
   ResetMenuCheck( CMsg( MSG_MENU_LaTeX,      MSG_MENU_LaTeX_STR      ) );
   ResetMenuCheck( CMsg( MSG_MENU_TeX,        MSG_MENU_TeX_STR        ) );
   ResetMenuCheck( CMsg( MSG_MENU_PostScript, MSG_MENU_PostScript_STR ) );
   
   return;
}

/****i* ResetOutTypeChecks() [3.0] *********************************
*
* NAME
*    ResetOutTypeChecks()
*
* SYNOPSIS
*    void ResetOutTypeChecks( void );
*
* DESCRIPTION
*    Clear the checkmarks for all the Output Type menuItems.
********************************************************************
*
*/

SUBFUNC void ResetOutTypeChecks( void )
{
   ResetMenuCheck( CMsg( MSG_MENU_ASCII,      MSG_MENU_ASCII_STR      ) );
   ResetMenuCheck( CMsg( MSG_MENU_AmigaGuide, MSG_MENU_AmigaGuide_STR ) );
   ResetMenuCheck( CMsg( MSG_MENU_HTML,       MSG_MENU_HTML_STR       ) );
   ResetMenuCheck( CMsg( MSG_MENU_LaTeX,      MSG_MENU_LaTeX_STR      ) );
   ResetMenuCheck( CMsg( MSG_MENU_RTF,        MSG_MENU_RTF_STR        ) );
   
   return;
}

/****i* AssySrcMI() [3.0] ******************************************
*
* NAME
*    AssySrcMI()
*
* SYNOPSIS
*    int AssySrcMI( void );
*
* DESCRIPTION
*    User has chosen Assembler-type input.  Update the Source Type
*    menuitem checkmarks to reflect this.
********************************************************************
*
*/

PRIVATE int AssySrcMI( void )
{
   ResetSrcTypeChecks();

   CheckMenuItem( CMsg( MSG_MENU_Assembly, MSG_MENU_Assembly_STR ), TRUE );

   sourceType = SRC_ASSY;

   return( TRUE );
}

/****i* CSrcMI() [3.0] *********************************************
*
* NAME
*    CSrcMI()
*
* SYNOPSIS
*    int CSrcMI( void );
*
* DESCRIPTION
*    User has chosen C-type input.  Update the Source Type
*    menuitem checkmarks to reflect this.
********************************************************************
*
*/

PRIVATE int CSrcMI( void )
{
   ResetSrcTypeChecks();

   CheckMenuItem( CMsg( MSG_MENU_C, MSG_MENU_C_STR ), TRUE );

   sourceType = SRC_C;

   return( TRUE );
}

/****i* BasicSrcMI() [3.0] *****************************************
*
* NAME
*    BasicSrcMI()
*
* SYNOPSIS
*    int BasicSrcMI( void );
*
* DESCRIPTION
*    User has chosen BASIC-type input.  Update the Source Type
*    menuitem checkmarks to reflect this.
********************************************************************
*
*/

PRIVATE int BasicSrcMI( void )
{
   ResetSrcTypeChecks();

   CheckMenuItem( CMsg( MSG_MENU_BASIC, MSG_MENU_BASIC_STR ), TRUE );

   sourceType = SRC_BASIC;

   return( TRUE );
}

/****i* FortranSrcMI() [3.0] ***************************************
*
* NAME
*    FortranSrcMI()
*
* SYNOPSIS
*    int FortranSrcMI( void );
*
* DESCRIPTION
*    User has chosen FORTRAN-type input.  Update the Source Type
*    menuitem checkmarks to reflect this.
********************************************************************
*
*/

PRIVATE int FortranSrcMI( void )
{
   ResetSrcTypeChecks();

   CheckMenuItem( CMsg( MSG_MENU_FORTRAN, MSG_MENU_FORTRAN_STR ), TRUE );

   sourceType = SRC_FORTRAN;

   return( TRUE );
}

/****i* LatexSrcMI() [3.0] *****************************************
*
* NAME
*    LatexSrcMI()
*
* SYNOPSIS
*    int LatexSrcMI( void );
*
* DESCRIPTION
*    User has chosen Latex-type input.  Update the Source Type
*    menuitem checkmarks to reflect this.
********************************************************************
*
*/

PRIVATE int LatexSrcMI( void )
{
   ResetSrcTypeChecks();

   CheckMenuItem( CMsg( MSG_MENU_LaTeX, MSG_MENU_LaTeX_STR ), TRUE );

   sourceType = SRC_LATEX;

   return( TRUE );
}

/****i* TexSrcMI() [3.0] *******************************************
*
* NAME
*    TexSrcMI()
*
* SYNOPSIS
*    int TexSrcMI( void );
*
* DESCRIPTION
*    User has chosen TeX-type input.  Update the Source Type
*    menuitem checkmarks to reflect this.
********************************************************************
*
*/

PRIVATE int TexSrcMI( void )
{
   ResetSrcTypeChecks();

   CheckMenuItem( CMsg( MSG_MENU_TeX, MSG_MENU_TeX_STR ), TRUE );

   sourceType = SRC_TEX;

   return( TRUE );
}

/****i* PostScriptSrcMI() [3.0] ************************************
*
* NAME
*    PostScriptSrcMI()
*
* SYNOPSIS
*    int PostScriptSrcMI( void );
*
* DESCRIPTION
*    User has chosen PostScript-type input.  Update the Source Type
*    menuitem checkmarks to reflect this.
********************************************************************
*
*/

PRIVATE int PostScriptSrcMI( void )
{
   ResetSrcTypeChecks();

   CheckMenuItem( CMsg( MSG_MENU_PostScript, MSG_MENU_PostScript_STR ), TRUE );

   sourceType = SRC_POST;

   return( TRUE );
}

/****i* AsciiOutMI() [3.0] *****************************************
*
* NAME
*    AsciiOutMI()
*
* SYNOPSIS
*    int AsciiOutMI( void );
*
* DESCRIPTION
*    User has chosen ASCII-type output.  Update the Output Type
*    menuitem checkmarks to reflect this.
********************************************************************
*
*/

PRIVATE int AsciiOutMI( void )
{
   ResetOutTypeChecks();

   CheckMenuItem( CMsg( MSG_MENU_ASCII, MSG_MENU_ASCII_STR ), TRUE );

   outputType = OUT_ASCII;
   
   return( TRUE );
}

/****i* AmigaGuideOutMI() [3.0] ************************************
*
* NAME
*    AmigaGuideOutMI()
*
* SYNOPSIS
*    int AmigaGuideOutMI( void );
*
* DESCRIPTION
*    User has chosen AmigaGuide-type output.  Update the Output Type
*    menuitem checkmarks to reflect this.
********************************************************************
*
*/

PRIVATE int AmigaGuideOutMI( void )
{
   ResetOutTypeChecks();

   CheckMenuItem( CMsg( MSG_MENU_AmigaGuide, MSG_MENU_AmigaGuide_STR ), TRUE );

   outputType = OUT_AGUIDE;

   return( TRUE );
}

/****i* HtmlOutMI() [3.0] ******************************************
*
* NAME
*    HtmlOutMI()
*
* SYNOPSIS
*    int HtmlOutMI( void );
*
* DESCRIPTION
*    User has chosen HTML-type output.  Update the Output Type
*    menuitem checkmarks to reflect this.
********************************************************************
*
*/

PRIVATE int HtmlOutMI( void )
{
   ResetOutTypeChecks();

   CheckMenuItem( CMsg( MSG_MENU_HTML, MSG_MENU_HTML_STR ), TRUE );

   outputType = OUT_HTML;

   return( TRUE );
}

/****i* LatexOutMI() [3.0] *****************************************
*
* NAME
*    LatexOutMI()
*
* SYNOPSIS
*    int LatexOutMI( void );
*
* DESCRIPTION
*    User has chosen Latex-type output.  Update the Output Type
*    menuitem checkmarks to reflect this.
********************************************************************
*
*/

PRIVATE int LatexOutMI( void )
{
   ResetOutTypeChecks();

   CheckMenuItem( CMsg( MSG_MENU_LaTeX, MSG_MENU_LaTeX_STR ), TRUE );

   outputType = OUT_LATEX;

   return( TRUE );
}

/****i* RtfOutMI() [3.0] *******************************************
*
* NAME
*    RtfOutMI()
*
* SYNOPSIS
*    int RtfOutMI( void );
*
* DESCRIPTION
*    User has chosen Rtf-type output.  Update the Output Type
*    menuitem checkmarks to reflect this.
********************************************************************
*
*/

PRIVATE int RtfOutMI( void )
{
   ResetOutTypeChecks();

   CheckMenuItem( CMsg( MSG_MENU_RTF, MSG_MENU_RTF_STR ), TRUE );

   outputType = OUT_RTF;

   return( TRUE );
}

/****i* EditToolsMI() [3.0] ****************************************
*
* NAME
*    EditToolsMI()
*
* SYNOPSIS
*    int EditToolsMI( void );
*
* DESCRIPTION
*    Run the Editor specified by the ToolTypes Editor ToolType
*    on the program Icon.
********************************************************************
*
*/

PRIVATE int EditToolsMI( void )
{
   sprintf( command, "%s RoboDoc:RoboDocBuilder.info", TTToolEditor );

   runCommand( command );

   return( TRUE );
}

/****i* AboutMI() [3.0] ********************************************
*
* NAME
*    AboutMI()
*
* SYNOPSIS
*    int AboutMI( void );
*
* DESCRIPTION
*    Display some basic program information to the User.
********************************************************************
*
*/
PRIVATE int AboutMI( void )
{
   sprintf( ErrMsg, CMsg( MSG_FMT_ABOUT, MSG_FMT_ABOUT_STR ), 
                    programName, authorName, authorEMail 
          );

   UserInfo( ErrMsg, CMsg( MSG_ABOUT, MSG_ABOUT_STR ) );
      
   return( TRUE );
}

/****i* HelpMI() [3.0] *********************************************
*
* NAME
*    HelpMI()
*
* SYNOPSIS
*    int HelpMI( void );
*
* DESCRIPTION
*    Display the program documentation to the User.
********************************************************************
*
*/

PRIVATE int HelpMI( void )
{
   sprintf( &command[0], "MultiView RoboDoc:RoboDocBuilder.guide" );

   runCommand( command );
      
   return( TRUE );
}

/****i* QuitMI() [3.0] *********************************************
*
* NAME
*    QuitMI()
*
* SYNOPSIS
*    int QuitMI( void );
*
* DESCRIPTION
*    Exit the program.
********************************************************************
*
*/

PRIVATE int QuitMI( void )
{
   return( FALSE );
}

/****i* SortedOutMI() [3.0] ****************************************
*
* NAME
*    SortedOutMI()
*
* SYNOPSIS 
*    int SortedOutMI( void );
*
* DESCRIPTION
*    The User wishes to toggle the state of the Sorted output
*    menuitem.
********************************************************************
*
*/

PRIVATE int SortedOutMI( void )
{
   if ((RDMenus[ 21 ].Flags & CHECKED) != 0)
      {
      CheckMenuItem( TrimSpaces( CMsg( MSG_MENU_Sort, MSG_MENU_Sort_STR ) ), FALSE );
      sortOutput = FALSE;
      }
   else
      {
      CheckMenuItem( TrimSpaces( CMsg( MSG_MENU_Sort, MSG_MENU_Sort_STR ) ), TRUE );
      sortOutput = TRUE;
      }
      
   return( TRUE );
}

/****i* AddTOCMI() [3.0] *******************************************
*
* NAME
*    AddTOCMI()
*
* SYNOPSIS 
*    int AddTOCMI( void );
*
* DESCRIPTION
*    The User wishes to toggle the state of the Add Table of Contents
*    menuitem.
********************************************************************
*
*/

PRIVATE int AddTOCMI( void )
{
   if ((RDMenus[ 22 ].Flags & CHECKED) != 0)
      {
      CheckMenuItem( TrimSpaces( CMsg( MSG_MENU_Add, MSG_MENU_Add_STR ) ), FALSE );
      addTOC = FALSE;      
      }
   else
      {
      CheckMenuItem( TrimSpaces( CMsg( MSG_MENU_Add, MSG_MENU_Add_STR ) ), TRUE );
      addTOC = TRUE;      
      }
      
   return( TRUE );
}

/****i* IncludeIntDocsMI() [3.0] ***********************************
*
* NAME
*    IncludeIntDocsMI()
*
* SYNOPSIS 
*    int IncludeIntDocsMI( void );
*
* DESCRIPTION
*    The User wishes to toggle the state of the Include Internal
*    documents menuitem.
********************************************************************
*
*/

PRIVATE int IncludeIntDocsMI( void )
{
   if ((RDMenus[ 23 ].Flags & CHECKED) != 0)
      {
      CheckMenuItem( TrimSpaces( CMsg( MSG_MENU_Include, MSG_MENU_Include_STR ) ), FALSE );
      includeInternals = FALSE;
      }
   else
      {
      CheckMenuItem( TrimSpaces( CMsg( MSG_MENU_Include, MSG_MENU_Include_STR ) ), TRUE );
      includeInternals = TRUE;
      }

   return( TRUE );
}

/****i* InternalOnlyMI() [3.0] *************************************
*
* NAME
*    InternalOnlyMI()
*
* SYNOPSIS 
*    int InternalOnlyMI( void );
*
* DESCRIPTION
*    The User wishes to toggle the state of the Internal Only
*    documents menuitem.
********************************************************************
*
*/

PRIVATE int InternalOnlyMI( void )
{
   if ((RDMenus[ 24 ].Flags & CHECKED) != 0)
      {
      CheckMenuItem( TrimSpaces( CMsg( MSG_MENU_Internal, MSG_MENU_Internal_STR ) ), FALSE );
      internalOnly = FALSE;   
      }
   else
      {
      CheckMenuItem( TrimSpaces( CMsg( MSG_MENU_Internal, MSG_MENU_Internal_STR ) ), TRUE );
      internalOnly = TRUE;
      }

   return( TRUE );
}

// ---------------------------------------------------------

/****i* setCurrentPath() [3.0] *************************************
*
* NAME
*    setCurrentPath()
*
* SYNOPSIS
*    void setCurrentPath( void );
*
* DESCRIPTION
*    Set the initial drawer for the ASL file requester to the
*    directory that the program was started from.
********************************************************************
*
*/

SUBFUNC void setCurrentPath( void )
{
   if (StringLength( currentPath ) < 1)
      {
      if (NameFromLock( GetProgramDir(), currentPath, BUFFER_SIZE ) == DOSFALSE)
         StringNCopy( currentPath, "RoboDoc:", BUFFER_SIZE );
      }

   SetTagItem( &FileTags[0], ASLFR_InitialDrawer, (ULONG) currentPath );
   
   return;
}
    
/****i* InpASLClicked() [3.0] **************************************
*
* NAME
*    InpASLClicked()
*
* SYNOPSIS
*    int InpASLClicked( int dummy );
*
* DESCRIPTION
*    Display the ASL File Requester to the User in order to obtain
*    a fileName for the source code input.
********************************************************************
*
*/

PRIVATE int InpASLClicked( int dummy )
{
   if (FileReq( inputFileName, &FileTags[0] ) >= 0)
      {
      (void) GetPathName( currentPath, inputFileName, BUFFER_SIZE );
   
      setCurrentPath();
      
      GT_SetGadgetAttrs( INFILE_GAD, RDWnd, NULL, 
                         GTST_String, inputFileName, TAG_DONE 
                       );
      }

   return( TRUE );
}

/****i* OutASLClicked() [3.0] **************************************
*
* NAME
*    OutASLClicked()
*
* SYNOPSIS
*    int OutASLClicked( int dummy );
*
* DESCRIPTION
*    Display the ASL File Requester to the User in order to obtain
*    a fileName for the document output.
********************************************************************
*
*/

PRIVATE int OutASLClicked( int dummy )
{
   if (FileReq( outputFileName, &FileTags[0] ) >= 0)
      {
      (void) GetPathName( currentPath, outputFileName, BUFFER_SIZE );

      setCurrentPath();

      GT_SetGadgetAttrs( OUTFILE_GAD, RDWnd, NULL, 
                         GTST_String, outputFileName, TAG_DONE 
                       );
      }
      
   return( TRUE );
}

/****i* XRefASLClicked() [3.0] *************************************
*
* NAME
*    XRefASLClicked()
*
* SYNOPSIS
*    int XRefASLClicked( int dummy );
*
* DESCRIPTION
*    Display the ASL File Requester to the User in order to obtain
*    a fileName for the Cross-reference output.
********************************************************************
*
*/

PRIVATE int XRefASLClicked( int dummy )
{
   if (FileReq( xrefFileName, &FileTags[0] ) >= 0)
      {
      (void) GetPathName( currentPath, xrefFileName, BUFFER_SIZE );

      setCurrentPath();
      
      GT_SetGadgetAttrs( XREF_GAD, RDWnd, NULL, 
                         GTST_String, xrefFileName, TAG_DONE 
                       );
      }

   return( TRUE );
}

// ----------------------------------

/****i* InFileStrClicked() [3.0] ***********************************
*
* NAME
*    InFileStrClicked()
*
* SYNOPSIS
*    int InFileStrClicked( int dummy );
*
* DESCRIPTION
*    The User has entered a source code file name directly, so
*    store it for future usage.
********************************************************************
*
*/

PRIVATE int InFileStrClicked( int dummy )
{
   (void) GetPathName( currentPath, INFILE_NAME, BUFFER_SIZE );

   setCurrentPath();
   
   StringNCopy( inputFileName, INFILE_NAME, BUFFER_SIZE );

   return( TRUE );
}

/****i* OutFileStrClicked() [3.0] **********************************
*
* NAME
*    OutFileStrClicked()
*
* SYNOPSIS
*    int OutFileStrClicked( int dummy );
*
* DESCRIPTION
*    The User has entered a destination document file name directly, so
*    store it for future usage.
********************************************************************
*
*/

PRIVATE int OutputStrClicked( int dummy )
{
   (void) GetPathName( currentPath, OUTFILE_NAME, BUFFER_SIZE );

   setCurrentPath();
   
   StringNCopy( outputFileName, OUTFILE_NAME, BUFFER_SIZE );

   return( TRUE );
}

/****i* XRefFileStrClicked() [3.0] *********************************
*
* NAME
*    XRefFileStrClicked()
*
* SYNOPSIS
*    int XRefFileStrClicked( int dummy );
*
* DESCRIPTION
*    The User has entered a cross-reference file name directly, so
*    store it for future usage.
********************************************************************
*
*/

PRIVATE int XRefStrClicked( int dummy )
{
   (void) GetPathName( currentPath, XREFFILE_NAME, BUFFER_SIZE );

   setCurrentPath();
  
   StringNCopy( xrefFileName, XREFFILE_NAME, BUFFER_SIZE );

   return( TRUE );
}

/****i* TabSizeIntClicked() [3.0] **********************************
*
* NAME
*    TabSizeIntClicked()
*
* SYNOPSIS
*    int TabSizeIntClicked( int dummy );
*
* DESCRIPTION
*    The User has entered a new Tab size, so store it for future usage.
********************************************************************
*
*/

PRIVATE int TabSizeIntClicked( int dummy )
{
   tabSize = TAB_SIZE;

   return( TRUE );
}

/****i* TemplateMXClicked() [3.0] **********************************
*
* NAME
*    TemplateMXClicked()
*
* SYNOPSIS
*    int TemplateMXClicked( int whichType );
*
* DESCRIPTION
*    The User has selected a template type (possibly they want to
*    edit a certain type of template), so store it for future usage.
********************************************************************
*
*/

PRIVATE int TemplateMXClicked( int whichType )
{
   templateType = whichType;
   
   return( TRUE );
}

/****i* getSrcType() [2.0] ********************************
*
* NAME
*    getSrcType()
*
* SYNOPSIS
*    UBYTE *srcTypeString = getSrcType( void );
*
* DESCRIPTION
*    Currently, this function is NOT used, but when it 
*    does get used, it translates the sourceType integer
*    into a string that corresponds to the source MenuItem
*    that the user has checked.
***********************************************************
*
*/

SUBFUNC UBYTE *getSrcType( void )
{
   switch (sourceType)
      {
      default:
      case SRC_C:
         return( "C" );

      case SRC_ASSY:
         return( "Assembler" );

      case SRC_BASIC:
         return( "BASIC" );

      case SRC_FORTRAN:
         return( "FORTRAN" );

      case SRC_LATEX:
         return( "LaTeX" );

      case SRC_TEX:
         return( "TeX" );

      case SRC_POST:
         return( "PostScript" );
      }
}

/****i* getOutputType() [2.0] *****************************
*
* NAME
*    getOutputType()
*
* SYNOPSIS
*    UBYTE *outputTypeString = getOutputType( void );
*
* DESCRIPTION
*    This function translates the outputType integer
*    into a string that corresponds to the output MenuItem
*    that the user has checked.
***********************************************************
*
*/

SUBFUNC UBYTE *getOutputType( void )
{
   switch (outputType)
      {
      default:
      case OUT_AGUIDE:
         return( " GUIDE" );
         
      case OUT_ASCII:
         return( " ASCII" );
         
      case OUT_HTML:
         return( " HTML" );
         
      case OUT_LATEX:
         return( " LATEX" );
         
      case OUT_RTF:
         return( " RTF" );
      }
}

/****i* formCommand() [3.0] ****************************************
*
* NAME
*    formCommand()
*
* SYNOPSIS
*    UBYTE *command = formCommand( BOOL genXRef, BOOL useXList );
*
* DESCRIPTION
*    This function builds the RoboDoc command from the options
*    & fileNames set in the GUI by the User.
********************************************************************
*
*/

SUBFUNC UBYTE *formCommand( BOOL genXRef, BOOL useXList )
{
   command[0] = '\0'; // Kill old contents (if any).
   
   if (StringLength( inputFileName ) < 1)
      {
      UserInfo( CMsg( MSG_NO_INP_FILENAME, MSG_NO_INP_FILENAME_STR ), 
                CMsg( MSG_USER_ERROR, MSG_USER_ERROR_STR ) 
              );
      
      goto exitFormCommand;
      }
   else
      {
      if (StringLength( outputFileName ) < 1)
         {
         UserInfo( CMsg( MSG_NO_OUT_FILENAME, MSG_NO_OUT_FILENAME_STR ), 
                   CMsg( MSG_USER_ERROR, MSG_USER_ERROR_STR ) 
                 );
      
         goto exitFormCommand;
         }
      else
         sprintf( &command[0], "%s %s %s -v TABSIZE %d", 
                  TTBuildCmd, inputFileName, outputFileName, tabSize 
                );
      }

   StringCat( command, getOutputType() );
                 
   if (sortOutput == TRUE)
      StringCat( command, " -s" );
      
   if (addTOC == TRUE)
      StringCat( command, " -t" );
      
   if (internalOnly == TRUE)
      StringCat( command, " -io" );
   else if (includeInternals == TRUE)
      StringCat( command, " -i" );

   if (genXRef == TRUE)
      {
      StringCat( command, " -g " );
      StringCat( command, xrefFileName );
      }
      
   if (useXList == TRUE)
      {
      StringCat( command, " -x " );
      StringCat( command, xrefFileName );
      }

exitFormCommand:
      
   return( &command[0] );
}

/****i* GenerateBtClicked() [3.0] **********************************
*
* NAME
*    GenerateBtClicked()
*
* SYNOPSIS
*    int GenerateBtClicked( int dummy );
*
* DESCRIPTION
*    The User wishes to generate the output document, so run the
*    RoboDoc command requested.
********************************************************************
*
*/

PRIVATE int GenerateBtClicked( int dummy )
{
   runCommand( formCommand( FALSE, FALSE ) );

   displayMessage( CMsg( MSG_DONE_GENERATING, MSG_DONE_GENERATING_STR ) );
    
   return( TRUE );
}

/****i* GenXRefBtClicked() [3.0] ***********************************
*
* NAME
*    GenXRefBtClicked()
*
* SYNOPSIS
*    int GenXRefBtClicked( int dummy );
*
* DESCRIPTION
*    The User wishes to generate cross-reference output, so run the
*    RoboDoc command requested.
********************************************************************
*
*/

PRIVATE int GenXRefBtClicked( int dummy )
{
   runCommand( formCommand( TRUE, FALSE ) );

   displayMessage( CMsg( MSG_DONE_GENERATING, MSG_DONE_GENERATING_STR ) );
   
   return( TRUE );
}

/****i* UseListBtClicked() [3.0] ***********************************
*
* NAME
*    UseListBtClicked()
*
* SYNOPSIS
*    int UseListBtClicked( int dummy );
*
* DESCRIPTION
*    The User wishes to use a cross-reference list file, so run the
*    RoboDoc command requested.
********************************************************************
*
*/

PRIVATE int UseListBtClicked( int dummy )
{
   runCommand( formCommand( FALSE, TRUE ) );

   displayMessage( CMsg( MSG_DONE_GENERATING, MSG_DONE_GENERATING_STR ) );
   
   return( TRUE );
}

PRIVATE int RDDefsLVClicked( int dummy )
{
   return( TRUE ); // READ_ONLY so do nothing here
}

/****i* EditRDBtClicked() [3.0] ***********************************
*
* NAME
*    EditRDBtClicked()
*
* SYNOPSIS
*    int EditRDBtClicked( int dummy );
*
* DESCRIPTION
*    The User wishes to change the RoboDoc.defaults file, so run the
*    Default Editor specified in the Editor ToolType to do so.
********************************************************************
*
*/

PRIVATE int EditRDBtClicked( int dummy )
{
   int len = StringLength( TTCommandPath ) - 1;
      
   if (TTCommandPath[len] == ':' || TTCommandPath[len] == '/')
      sprintf( command, "%s %sRoboDoc.defaults", TTDefaultEditor, TTCommandPath );
   else
      sprintf( command, "%s %s/RoboDoc.defaults", TTDefaultEditor, TTCommandPath );

//   WindowToBack( RDWnd );
            
   runCommand( command );

   resetLVStrings(); // Throw away old LV Items.

   ReadInRD_Defaults();

   return( TRUE );
}

/****i* EditSrcBtClicked() [3.0] ***********************************
*
* NAME
*    EditSrcBtClicked()
*
* SYNOPSIS
*    int EditSrcBtClicked( int dummy );
*
* DESCRIPTION
*    The User wishes to change the source code file, so run the
*    Default Editor specified in the Editor ToolType to do so.
********************************************************************
*
*/

PRIVATE int EditSrcBtClicked( int dummy )
{
   if (StringLength( inputFileName ) < 1)
      {
      UserInfo( CMsg( MSG_NO_INP_FILENAME, MSG_NO_INP_FILENAME_STR ), 
                CMsg( MSG_USER_ERROR, MSG_USER_ERROR_STR ) 
              );
      
      goto exitEditCommand;
      }
   else
      {
      sprintf( command, "%s %s", TTDefaultEditor, inputFileName );
         
//      WindowToBack( RDWnd );
   
      runCommand( command );      
      }

exitEditCommand:

   return( TRUE );
}

/****i* EditTmpBtClicked() [2.0] ************************************
*
* NAME
*    EditTmpBtClicked()
*
* SYNOPSIS 
*    int EditTmpBtClicked( int dummy );
*
* DESCRIPTION
*    Currently, Template files only serve as an example of what to
*    place in the User's (C) source files.  When RoboDocBuilder is
*    completed, these templates can be used as Cut&Paste sources
*    for the User's source code files.  The StringIDChar ToolType
*    will specify where to perform useful substitutions.
*********************************************************************
*
*/

PRIVATE int EditTmpBtClicked( int dummy )
{
   UBYTE tmpName[80] = { 0, };
   
   int len = StringLength( TTTemplatePath ) - 1;

   switch (templateType)
      {
      default:
      case MAIN_TEMPLATE:
         StringCopy( tmpName, "Main.template" );
         break;
   
      case HEAD_TEMPLATE:
         StringCopy( tmpName, "Head.template" );
         break;
   
      case INT_TEMPLATE:
         StringCopy( tmpName, "Internal.template" );
         break;
   
      case FULL_TEMPLATE:
         StringCopy( tmpName, "Full.template" );
         break;
      }

   if (TTTemplatePath[len] == ':' || TTTemplatePath[len] == '/')
      sprintf( command, "%s %s%s", TTDefaultEditor, TTTemplatePath, tmpName );
   else
      sprintf( command, "%s %s/%s", TTDefaultEditor, TTTemplatePath, tmpName );

//   WindowToBack( RDWnd );

   runCommand( command );      

   return( TRUE );
}

// ----------------------------------------------------------------

/****i* BBoxRender() [3.0] *****************************************
*
* NAME
*    BBoxRender()
*
* SYNOPSIS
*    void BBoxRender( void );
*
* DESCRIPTION
*    Draw a Box around the 'Template Types:' Radio Buttons.
********************************************************************
*
*/
PRIVATE void BBoxRender( void )
{
   ComputeFont( RDScr, Font, &CFont, RDWidth, RDHeight );

   DrawBevelBox( RDWnd->RPort,
                 CFont.OffX + ComputeX( CFont.FontX, 212 ),
                 CFont.OffY + ComputeY( CFont.FontY,  83 ),
                 ComputeX( CFont.FontX, 180 ),
                 ComputeY( CFont.FontY,  90 ),
                 GT_VisualInfo, VisualInfo,
                 TAG_DONE
               );

   return;
}

/****i* IntuiTextRender() [3.0] ************************************
*
* NAME
*    IntuiTextRender()
*
* SYNOPSIS
*    void IntuiTextRender( void );
*
* DESCRIPTION
*    Label the 'Template Types:' Radio Buttons.
********************************************************************
*
*/
PRIVATE void IntuiTextRender( void )
{
  struct IntuiText it;

  ComputeFont( RDScr, Font, &CFont, RDWidth, RDHeight );

  CopyMem( (char *) &RDIT, (char *) &it,
           (long) sizeof( struct IntuiText )
         );

  it.ITextFont = &helvetica13;

  it.TopEdge   = CFont.OffY + ComputeY( CFont.FontY, it.TopEdge )
                 - (Font->ta_YSize >> 1);

  PrintIText( RDWnd->RPort, &it, 0, 0 );

  return;
}

/****i* OpenRDWindow() [3.0] ***************************************
*
* NAME
*    OpenRDWindow()
*
* SYNOPSIS
*    int success = OpenRDWindow( void );
*
* DESCRIPTION
*    Setup the GUI Window for the program. 
********************************************************************
*
*/

PRIVATE int OpenRDWindow( void )
{
   struct NewGadget  ng;
   struct Gadget    *g;
   UWORD             lc, tc;
   UWORD             wleft, wtop, ww, wh;

   ComputeFont( RDScr, Font, &CFont, RDWidth, RDHeight );

   ww = ComputeX( CFont.FontX, RDWidth  );
   wh = ComputeY( CFont.FontY, RDHeight );

   wleft = (RDScr->Width  - RDWidth ) / 2;
   wtop  = (RDScr->Height - RDHeight) / 2;

   if (!(g = CreateContext( &RDGList ))) // == NULL)
      return( -1 );

   for (lc = 0, tc = 0; lc < RD_CNT; lc++)
      {
      CopyMem( (char *) &RDNGad[ lc ], (char *) &ng,
               (long) sizeof( struct NewGadget )
             );

      ng.ng_VisualInfo = VisualInfo;
      ng.ng_TextAttr   = &helvetica13;
      ng.ng_LeftEdge   = CFont.OffX + ComputeX( CFont.FontX, ng.ng_LeftEdge );
      ng.ng_TopEdge    = CFont.OffY + ComputeY( CFont.FontY, ng.ng_TopEdge );
      ng.ng_Width      = ComputeX( CFont.FontX, ng.ng_Width );
      ng.ng_Height     = ComputeY( CFont.FontY, ng.ng_Height);

      RDGadgets[ lc ] = g
                      = CreateGadgetA( (ULONG) RDGTypes[ lc ],
                                       g,
                                       &ng,
                                       (struct TagItem *) &RDGTags[ tc ]
                                     );

      while (RDGTags[ tc ] != TAG_DONE)
         tc += 2;

      tc++;

      if (!g) // == NULL)
         return( -2 );
      }

   if (!(RDMenus = CreateMenus( RDNMenu, GTMN_FrontPen, 0L, TAG_DONE ))) // == NULL)
      return( -3 );

   LayoutMenus( RDMenus, VisualInfo, TAG_DONE );

   if (!(RDWnd = OpenWindowTags( NULL,

         WA_Left,          wleft,
         WA_Top,           wtop,
         WA_Width,         ww + CFont.OffX + RDScr->WBorRight,
         WA_Height,        wh + CFont.OffY + RDScr->WBorBottom,

         WA_IDCMP,         STRINGIDCMP | INTEGERIDCMP | MXIDCMP 
           | BUTTONIDCMP | LISTVIEWIDCMP | IDCMP_CLOSEWINDOW 
           | IDCMP_MENUPICK | IDCMP_RAWKEY | IDCMP_REFRESHWINDOW,

         WA_Flags,         WFLG_ACTIVATE | WFLG_DRAGBAR | WFLG_DEPTHGADGET
           | WFLG_CLOSEGADGET,

         WA_Gadgets,       RDGList,
         WA_Title,         RDWdt,
         WA_ScreenTitle,   ScrTitle,
         WA_CustomScreen,  RDScr,
         TAG_DONE ))) // == NULL)
      {
      return( -4 );
      }

   BBoxRender();

   IntuiTextRender();

   SetMenuStrip( RDWnd, RDMenus );

   GT_RefreshWindow( RDWnd, NULL );

   return( 0 );
}

/****i* RDCloseWindow() [3.0] **************************************
*
* NAME
*    RDCloseWindow()
*
* SYNOPSIS
*    int success = RDCloseWindow( void );
*
* DESCRIPTION
*    Return the GUI Window resources to the OS.
********************************************************************
*
*/

PRIVATE int RDCloseWindow( void )
{
   CloseRDWindow();

   return( FALSE );
}

/****i* RDRawKey() [3.0] *******************************************
*
* NAME
*    RDRawKey()
*
* SYNOPSIS
*    int RDRawKey( struct IntuiMessage *msg );
*
* DESCRIPTION
*    Perform GUI Action that the User selected via the keyboard.
*
* NOTES
*    Raw Keys have to be used in order to decode the 'Help' key.
********************************************************************
*
*/
PRIVATE int RDRawKey( struct IntuiMessage *msg )
{
   UWORD whichKey = msg->Code;
   UWORD Quals    = msg->Qualifier & (IEQUALIFIER_LSHIFT | IEQUALIFIER_RSHIFT);
   int   rval     = TRUE;

   switch (whichKey)
      {
      case 0x21: // 's':
         rval = EditSrcBtClicked( 0 );
         break;

      case 0x14: // 't':
         rval = EditTmpBtClicked( 0 );
         break;

      case 0x24: // 'g':
         rval = GenerateBtClicked( 0 );
         break;

      case 0x32: // 'x':
         rval = GenXRefBtClicked( 0 );
         break;

      case 0x13: // 'r':
         rval = EditRDBtClicked( 0 );
         break;

      case 0x17: // 'i':
         rval = AboutMI();
         break;

      case 0x3A: // '?': 
         if (whichKey == 0x3A && Quals != 0)
            rval = HelpMI();

         break;

      case 0x5F: // Help 
      case 0x25: // 'h':
         rval = HelpMI();
         break;

      case 0x10: // 'q':
         rval = QuitMI();
         break;
         
      default:
         break;
      }

   return( rval );
}

/****i* HandleRDIDCMP() [3.0] **************************************
*
* NAME
*    HandleRDIDCMP()
*
* SYNOPSIS
*    int HandleRDIDCMP( void );
*
* DESCRIPTION
*    Decode Intuition Events that the GUI is interested in.
********************************************************************
*
*/
PRIVATE int HandleRDIDCMP( void )
{
   struct IntuiMessage *m;
   int                (*func)( int );
   BOOL                 running = TRUE;

   while (running == TRUE)
      {
      if (!(m = GT_GetIMsg( RDWnd->UserPort ))) // == NULL) 
         {
         (void) Wait( 1L << RDWnd->UserPort->mp_SigBit );

         continue;
         }

      CopyMem( (char *) m, (char *) &RDMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch (RDMsg.Class)
         {
            case IDCMP_CLOSEWINDOW:
               running = RDCloseWindow();
               break;

            case IDCMP_GADGETDOWN:
            case IDCMP_GADGETUP:
               func = (int (*)( int )) ((struct Gadget *) RDMsg.IAddress)->UserData;

               if (func) // != NULL)
                  running = func( RDMsg.Code );

               break;

            case IDCMP_MENUPICK:
               if (RDMsg.Code != MENUNULL)
                  {
                  int (*mfunc)( void );

                  struct MenuItem *n = ItemAddress( RDMenus, RDMsg.Code );

                  if (n)
                     mfunc = (void *) (GTMENUITEM_USERDATA( n ));

                  if (mfunc)
                     running = mfunc();
                  }

               break;

            case IDCMP_RAWKEY:
               running = RDRawKey( &RDMsg );
               break;

            case IDCMP_REFRESHWINDOW:
               GT_BeginRefresh( RDWnd );

                  BBoxRender();
                  IntuiTextRender();

               GT_EndRefresh( RDWnd, TRUE );

               break;
         }
      }

   return( running );
}

// ----------------------------------------------------------------

/****i* closeLibraries() [3.0] *************************************
*
* NAME
*    closeLibraries()
*
* SYNOPSIS
*    void closeLibraries( void );
*
* DESCRIPTION
*    Close all libraries opened by the program.
********************************************************************
*
*/

SUBFUNC void closeLibraries( void )
{
#  ifdef __SASC
   if (LocaleBase != NULL)
      CloseLibrary( (struct Library *) LocaleBase );

   if (IconBase != NULL)
      CloseLibrary( (struct Library *) IconBase );

   CloseLibs();
#  else
   if (IGadTools)
      DropInterface( (struct Interface *) IGadTools );

   if (GadToolsBase)
      CloseLibrary( GadToolsBase );
#  endif

   return;
}

/****i* ShutdownProgram() [3.0] ************************************
*
* NAME
*    ShutdownProgram()
*
* SYNOPSIS
*    void ShutdownProgram( void );
*
* DESCRIPTION
*    Return all program resources to the OS.
********************************************************************
*
*/

PRIVATE void ShutdownProgram( void )
{
   CloseRDWindow();

   CloseRDScreen();

   Guarded_FreeLV( RD_Lvm );
 
   if (catalog) // != NULL)
      CloseCatalog( catalog );
      
   closeLibraries();
      
   return;
}

/****i* openLibraries() [3.0] **************************************
*
* NAME
*    openLibraries()
*
* SYNOPSIS
*    int openLibraries( void );
*
* DESCRIPTION
*    Open all libraries that the program requires.  Return 
*    RETURN_OK on success, else return ERROR_INVALID_RESIDENT_LIBRARY.
********************************************************************
*
*/

SUBFUNC int openLibraries( void )
{
   int rval = RETURN_OK;
   
#  ifdef __SASC
   if (OpenLibs() < 0)
      {
      rval = ERROR_INVALID_RESIDENT_LIBRARY;
      
      goto exitOpenLibraries;
      }
      
   if (!(IconBase = OpenLibrary( "icon.library", 37L ))) // == NULL)
      {
      fprintf( stderr, CMsg( MSG_FMT_LIB_UNOPENED, MSG_FMT_LIB_UNOPENED_STR ),
                       "icon.library", "37" 
             );

      ShutdownProgram();
            
      rval = ERROR_INVALID_RESIDENT_LIBRARY;
      
      goto exitOpenLibraries;
      }

   if (!(LocaleBase = OpenLibrary( "locale.library", 37L ))) // == NULL)
      {
      fprintf( stderr, CMsg( MSG_FMT_LIB_UNOPENED, MSG_FMT_LIB_UNOPENED_STR ),
                       "locale.library", "37" 
             );

      ShutdownProgram();
            
      rval = ERROR_INVALID_RESIDENT_LIBRARY;
      
      goto exitOpenLibraries;
      }
#  else
   if ((GadToolsBase = OpenLibrary( "gadtools.library", 50L )))
      {
      if (!(IGadTools = (struct GadToolsIFace *) GetInterface( GadToolsBase, "main", 1, NULL )))
         {
         fprintf( stderr, CMsg( MSG_FMT_LIB_UNOPENED, MSG_FMT_LIB_UNOPENED_STR ),
                          "GadToolsIFace", "50" 
                );

         ShutdownProgram();
            
         rval = ERROR_INVALID_RESIDENT_LIBRARY;
      
         goto exitOpenLibraries;
    }
      }
   else
      {
      fprintf( stderr, CMsg( MSG_FMT_LIB_UNOPENED, MSG_FMT_LIB_UNOPENED_STR ),
                       "gadtools.library", "50" 
             );

      ShutdownProgram();
            
      rval = ERROR_INVALID_RESIDENT_LIBRARY;
      
      goto exitOpenLibraries;
      }
#  endif

exitOpenLibraries:

   return( rval );
}

/****i* SetupProgram() [3.0] ***************************************
*
* NAME
*    SetupProgram()
*
* SYNOPSIS
*    int SetupProgram( void );
*
* DESCRIPTION
*    Obtain all necessary System resources for the program.
********************************************************************
*
*/

PRIVATE int SetupProgram( void )
{
   int rval = RETURN_OK;
   
   if ((rval = openLibraries()) != RETURN_OK)
      goto exitSetup;
      
   catalog = OpenCatalog( NULL, "RoboDocBuilder.catalog",
                                OC_BuiltInLanguage, MY_LANGUAGE,
                                TAG_DONE 
                        );

   (void) SetupCatalog();

   if (OpenRDScreen() < 0)
      {
      rval = ERROR_ON_OPENING_SCREEN;

      ShutdownProgram();

      goto exitSetup;
      }

   if (OpenRDWindow() < 0)
      {
      rval = ERROR_ON_OPENING_WINDOW;

      ShutdownProgram();

      goto exitSetup;
      }

   RD_Lvm = Guarded_AllocLV( RDLV_NUM_ELEMENTS, ELEMENT_SIZE );

   if (!RD_Lvm) // == NULL)
      {
      rval = ERROR_NO_FREE_STORE;

      ShutdownProgram();
      }

exitSetup:

   return( rval );
}

/****i* processToolTypes() [3.0] ***********************************
*
* NAME
*    processToolTypes()
*
* SYNOPSIS
*   void *function = processToolTypes( STRPTR *toolptr );
*
* DESCRIPTION
*   Read in all of the Icon ToolTypes from the Icon for the 
*   prgoram to use.
********************************************************************
*
*/

PRIVATE void *processToolTypes( STRPTR *toolptr )
{
   if (!toolptr) // == NULL)
      return( NULL );

   StringNCopy( TabSize,         CMsg( MSG_RD_TT_TABSIZE,    MSG_RD_TT_TABSIZE_STR    ), 32 );
   StringNCopy( ToolEditor,      CMsg( MSG_RD_TT_TOOLEDITOR, MSG_RD_TT_TOOLEDITOR_STR ), 32 );
   StringNCopy( BuildCmd,        CMsg( MSG_RD_TT_BUILDCMD,   MSG_RD_TT_BUILDCMD_STR   ), 32 );
   StringNCopy( TemplatePath,    CMsg( MSG_RD_TT_TMPPATH,    MSG_RD_TT_TMPPATH_STR    ), 32 );
   StringNCopy( CommandPath,     CMsg( MSG_RD_TT_CMDPATH,    MSG_RD_TT_CMDPATH_STR    ), 32 );
   StringNCopy( StringIDChar,    CMsg( MSG_RD_TT_STRIDCHR,   MSG_RD_TT_STRIDCHR_STR   ), 32 );
   StringNCopy( DefaultEditor,   CMsg( MSG_RD_TT_DEFEDITOR,  MSG_RD_TT_DEFEDITOR_STR  ), 32 );
   StringNCopy( DefaultLanguage, CMsg( MSG_RD_TT_DEFLANG,    MSG_RD_TT_DEFLANG_STR    ), 32 );
   StringNCopy( DefaultOutput,   CMsg( MSG_RD_TT_DEFOUTPUT,  MSG_RD_TT_DEFOUTPUT_STR  ), 32 );

   TTTabSize         = GetToolInt( toolptr, TabSize,          DefTabSize            );

   TTBuildCmd        = GetToolStr( toolptr, BuildCmd,        &DefBuildCmd[0]        );
   TTToolEditor      = GetToolStr( toolptr, ToolEditor,      &DefToolEditor[0]      );
   TTTemplatePath    = GetToolStr( toolptr, TemplatePath,    &DefTemplatePath[0]    );
   TTCommandPath     = GetToolStr( toolptr, CommandPath,     &DefCommandPath[0]     );
   TTStringIDChar    = GetToolStr( toolptr, StringIDChar,    &DefStringIDChar[0]    );
   TTDefaultEditor   = GetToolStr( toolptr, DefaultEditor,   &DefDefaultEditor[0]   );
   TTDefaultLanguage = GetToolStr( toolptr, DefaultLanguage, &DefDefaultLanguage[0] );
   TTDefaultOutput   = GetToolStr( toolptr, DefaultOutput,   &DefDefaultOutput[0]   );

   return( NULL );
}

/****i* setupPrefsMenu() [3.0] *************************************
*
* NAME
*    setupPrefsMenu()
*
* SYNOPSIS
*    void setupPrefsMenu( void );
*
* DESCRIPTION
*    Check the Source Type menuitem & the Output Type menuitem
*    that were specified in the ToolTypes in the Icon.
********************************************************************
*
*/

PRIVATE void setupPrefsMenu( void )
{
   if (StringComp( TTDefaultLanguage, "C" ) == 0)
      (void) CSrcMI();
   else if (StringComp( TTDefaultLanguage, "ASSY" ) == 0)
      (void) AssySrcMI();
   else if (StringComp( TTDefaultLanguage, "BASIC" ) == 0)
      (void) BasicSrcMI();
   else if (StringComp( TTDefaultLanguage, "FORTRAN" ) == 0)
      (void) FortranSrcMI();
   else if (StringComp( TTDefaultLanguage, "LATEX" ) == 0)
      (void) LatexSrcMI();
   else if (StringComp( TTDefaultLanguage, "TEX" ) == 0)
      (void) TexSrcMI();
   else if (StringComp( TTDefaultLanguage, "POSTSCRIPT" ) == 0)
      (void) PostScriptSrcMI();
   else
      (void) CSrcMI();

   if (StringComp( TTDefaultOutput, "GUIDE" ) == 0)
      (void) AmigaGuideOutMI();
   else if (StringComp( TTDefaultOutput, "ASCII" ) == 0)
      (void) AsciiOutMI();
   else if (StringComp( TTDefaultOutput, "HTML" ) == 0)
      (void) HtmlOutMI();
   else if (StringComp( TTDefaultOutput, "LATEX" ) == 0)
      (void) LatexOutMI();
   else if (StringComp( TTDefaultOutput, "RTF" ) == 0)
      (void) RtfOutMI();
   else      
      (void) AmigaGuideOutMI();

   return;      
}

/****i* setupEnvironment() [3.0] ***********************************
*
* NAME
*    setupEnvironment()
*
* SYNOPSIS
*    void setupEnvironment( UBYTE *programName );
*
* DESCRIPTION
*    Initialize the GUI to specified ToolType values.
********************************************************************
*
*/

SUBFUNC void setupEnvironment( UBYTE *program )
{
   SetNotifyWindow( RDWnd );

   setupPrefsMenu();

   tabSize = TTTabSize;

   SetTagItem( &FileTags[0], ASLFR_Window, (ULONG) RDWnd );

   GT_SetGadgetAttrs( TAB_GAD, RDWnd, NULL, GTIN_Number, tabSize, TAG_DONE );

   (void) GetPathName( currentPath, program, BUFFER_SIZE );

   setCurrentPath();

   SetupList( &RD_List, RD_Lvm );

   // Has to be done AFTER processToolTypes()!!
   ReadInRD_Defaults();

   return;
}

/****h* main() [3.0] ***********************************************
*
* NAME
*    main()
*
* SYNOPSIS
*    int success = main( int argc, char **argv );
*
* DESCRIPTION
*    Start the RoboDocBuilderPPC program, either from a CLI/Shell,
*    or from Workbench.
********************************************************************
*
*/

PUBLIC int main( int argc, char **argv )
{
   struct WBArg  *wbarg;
   STRPTR        *toolptr = NULL;

   int error = RETURN_OK;

   if ((error = SetupProgram()) != RETURN_OK)
      {
      return( error );
      }
      
   if (argc > 0)    // from CLI:
      {
      // We prefer to use the ToolTypes: 
      (void) FindIcon( &processToolTypes, diskobj, argv[0] );
      
      StringNCopy( programName, argv[0], 80 );
      }
   else             // from Workbench:
      {
#     ifdef __SASC
      wbarg   = &(_WBenchMsg->sm_ArgList[ _WBenchMsg->sm_NumArgs - 1 ]);
#     else
      wbarg   = &(__WBenchMsg->sm_ArgList[ __WBenchMsg->sm_NumArgs - 1 ]);
#     endif

      toolptr = FindTools( diskobj, wbarg->wa_Name, wbarg->wa_Lock );

      processToolTypes( toolptr );

      StringNCopy( programName, wbarg->wa_Name, 80 );
      }

   setupEnvironment( programName );

   (void) HandleRDIDCMP();

   FreeDiskObject( diskobj );
   
   ShutdownProgram();

   return( RETURN_OK );
}

/* --------------- END of RoboDocBuilder.c file! ------------------ */
