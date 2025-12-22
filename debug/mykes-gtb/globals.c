/*-- AutoRev header do NOT edit!
*
*   Program         :   globals.c
*   Copyright       :   © Copyright 1991 Jaba Development
*   Author          :   Jan van den Baard
*   Creation Date   :   22-Sep-91
*   Current version :   1.00
*   Translator      :   DICE v2.6
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   22-Sep-91     1.00            Globals for the program.
*
*-- REV_END --*/

#include	"defs.h"

/*
 * --- Library base pointers. (Module: Resources.c)
 */
struct IntuitionBase        *IntuitionBase  =   NULL;
struct GfxBase              *GfxBase        =   NULL;
struct CxBase               *CxBase         =   NULL;
struct IconBase             *IconBase       =   NULL;
struct UtilityBase          *UtilityBase    =   NULL;
struct AslBase              *AslBase        =   NULL;
struct DiskfontBase         *DiskfontBase   =   NULL;
struct Library		    *GadToolsBase   =   NULL;

/*
 * --- Screen graphics info. (Module: Resources.c)
 */
APTR                         MainVisualInfo =   NULL;
struct DrawInfo             *MainDrawInfo   =   NULL;

/*
 * --- Message info. (Module: func.c)
 */
ULONG                        Class;
UWORD                        Qualifier, Code;
APTR                         theObject;

/*
 * --- Standard topaz 8 font for program requesters and
 * --- definable font for the gadgets/menus.
 */
struct TextAttr              Topaz80 = {
    (STRPTR)"topaz.font", TOPAZ_EIGHTY, FS_NORMAL, FPF_ROMFONT };

UBYTE                        MainFontName[80] = "topaz.font";

struct TextAttr              MainFont = {
    (STRPTR)&MainFontName[0], TOPAZ_EIGHTY, FS_NORMAL, FPF_ROMFONT };


/*
 * --- Main data.
 */
struct Window               *MainWindow = NULL;
struct Screen               *MainScreen = NULL;
struct Menu                 *MainMenus  = NULL;
struct RastPort             *MainRP;

UBYTE                       *MainExtension    = ".g";
UBYTE                        MainWBStatus[20] = "Close Workbench";
UBYTE                        MainFileName[512] = "unnamed.g";
UWORD                        MainEditKind;

UWORD                        MainDriPen[NUMDRIPENS + 1] = {~0};
struct ColorSpec             MainColors[33] = { ~0, 0, 0, 0 };

UBYTE                        MainScreenTitle[80] = "GadToolsBox v1.0 © 1991";
UBYTE                        MainWindowTitle[80] = "Work Window";

#define TOOLS_IDCMP     ARROWIDCMP | BUTTONIDCMP | CHECKBOXIDCMP |\
                        INTEGERIDCMP | LISTVIEWIDCMP | MXIDCMP |\
                        CYCLEIDCMP | PALETTEIDCMP | SCROLLERIDCMP |\
                        SLIDERIDCMP | STRINGIDCMP

struct TagItem           nwTags[] = {
    WA_Left,            10l,
    WA_Top,             15l,
    WA_Width,           200l,
    WA_Height,          50l,
    WA_IDCMP,           IDCMP_NEWSIZE | TOOLS_IDCMP | IDCMP_INACTIVEWINDOW | IDCMP_ACTIVEWINDOW | IDCMP_MOUSEBUTTONS | IDCMP_CLOSEWINDOW | IDCMP_REFRESHWINDOW | IDCMP_MENUPICK | IDCMP_RAWKEY | IDCMP_MENUVERIFY | IDCMP_CHANGEWINDOW,
    WA_Flags,           WFLG_DRAGBAR | WFLG_CLOSEGADGET | WFLG_SIZEGADGET | WFLG_DEPTHGADGET | WFLG_SMART_REFRESH | WFLG_ACTIVATE,
    WA_Title,           (ULONG)MainWindowTitle,
    WA_CustomScreen,    0l,
    WA_MinWidth,        67l,
    WA_MinHeight,       21l,
    WA_MaxWidth,        0l,
    WA_MaxHeight,       0l,
    WA_AutoAdjust,      TRUE,
    TAG_DONE };

struct TagItem               MainSTags[] = {
    SA_Left,            0l,
    SA_Top,             0l,
    SA_Width,           640l,
    SA_Height,          -1l,
    SA_Depth,           2l,
    SA_DisplayID,       DEFAULT_MONITOR_ID | HIRES_KEY,
    SA_Title,           (ULONG)MainScreenTitle,
    SA_Pens,            (ULONG)MainDriPen,
    SA_Type,            CUSTOMSCREEN,
    SA_Font,            (ULONG)&MainFont,
    SA_Colors,          (ULONG)MainColors,
    SA_AutoScroll,      TRUE,
    TAG_DONE  };

struct ExtGadgetList         Gadgets;
struct Gadget               *MainGList = NULL;

BOOL                         WBenchClose = FALSE;
BOOL                         GadgetsOn = FALSE;
UWORD                        CountFrom = 0;

UBYTE                       *PlaceList[] = {
    "IN", "LEFT", "RIGHT", "ABOVE", "BELOW", 0l };

UWORD                        PlaceFlags[] = {
    PLACETEXT_IN, PLACETEXT_LEFT, PLACETEXT_RIGHT,
    PLACETEXT_ABOVE, PLACETEXT_BELOW};

UWORD                        ngFlags;
WORD                         ngLeft, ngTop, ngWidth, ngHeight;

struct StringExtend          Sextend = {
    0l, 1, 0, 1, 2, 0l, 0l, 0l, 0l };

UWORD                        ActiveKind = BUTTON_KIND;

struct Prefs                 MainPrefs ={
    PR_VERSION, PRF_WRITEICON, 0l, 0 };

BOOL                         BreakDRAG  = FALSE;
BOOL                         Saved      = TRUE;

struct IntuiText            *WindowTxt = 0l;

UWORD                        AlertCol;

UBYTE                       *Template  = "Name";
ULONG                        Args[2] = { 0l, 0l };
struct RDArgs                IArgs = { { 0,0,0 },0,0,0,0,RDAF_NOPROMPT };
struct RDArgs               *FArgs = 0l;

ULONG                        WindowIDCMP = IDCMP_CLOSEWINDOW;
ULONG                        WindowFlags = WFLG_DRAGBAR + WFLG_CLOSEGADGET + WFLG_SIZEGADGET + WFLG_DEPTHGADGET + WFLG_SMART_REFRESH;
