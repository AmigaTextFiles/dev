/* Main File Unbekannt*/

/* Erstellt mit GadEd V2.0 */
/* Geschrieben von Michael Neumann und Thomas Patschinski */

#include <intuition/intuition.h>
#include <intuition/screens.h>
#include <intuition/gadgetclass.h>
#include <exec/lists.h>
#include <exec/memory.h>
#include <exec/nodes.h>
#include <graphics/rastport.h>
#include <graphics/text.h>
#include <libraries/gadtools.h>
#include <utility/tagitem.h>
#include <string.h>
#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/gadtools.h>
#include <proto/utility.h>
#include <proto/graphics.h>
#include <proto/diskfont.h>

#define waNewLookMenu    TAG_USER+0x30+99
#define gtNewLookMenu    TAG_USER+0x80000+67
#define tagCheckScaled   TAG_USER+0x80000+68
#define tagMxScaled      TAG_USER+0x80000+69
#define tagNumColors     TAG_USER+0x80000+70
#define tagTitlePlace    TAG_USER+0x80000+71
#define tagFrontPen      TAG_USER+0x80000+72
#define tagBackPen       TAG_USER+0x80000+73
#define tagJustification TAG_USER+0x80000+74
#define tagFormat        TAG_USER+0x80000+75
#define tagMaxNumberLen  TAG_USER+0x80000+76
#define tagFrameType     TAG_USER+0x80000+77
#define tagMaxPixelLen   TAG_USER+0x80000+80
#define tagClipped       TAG_USER+0x80000+85

struct List              Liste[2];
struct List              ListViewList00[2];
struct Menu             *Men;
struct Menu             *Menu00;
static struct Gadget    *gad, *congad[2];
static struct Window    *W[2];
static struct Screen    *Screen;
static struct TextFont  *SFont;
static struct TextFont  *WFont[2];
struct Gadget           *G0[28];
struct Gadget           *GPtrs00[28];
static BOOL              OwnScreen;
static void             *Vi;
static WORD              Pens=-1;
static int               OffsetY;
static int               FontXSize, FontYSize;
static int               WinLeft, WinTop, WinWidth, WinHeight;
static int               TagCount;

static struct TextAttr SAttr = {(STRPTR)"topaz-classic.font",8,FS_NORMAL,0};

static Tag STags[] = {
 SA_Top,0,
 SA_Pens,(ULONG)&Pens,
 SA_Width,724,
 SA_Height,564,
 SA_Depth,2,
 SA_DisplayID,0x00029004,
 SA_Title,(ULONG)"Gadget Test Screen",
 SA_Font,(ULONG)&SAttr,
 SA_FullPalette,TRUE,
 SA_ShowTitle,TRUE,
 SA_Overscan,OSCAN_TEXT, TAG_DONE,NULL};

/* Definitionen für Fenster Proc00 */

static struct NewGadget NewG0[] = {
 115,71,67,12,(UBYTE *)"Tel_. Nummer:",&SAttr,0,PLACETEXT_LEFT,NULL,NULL,
 115,83,67,12,(UBYTE *)"_Haus Nummer:",&SAttr,1,PLACETEXT_LEFT|NG_HIGHLABEL,NULL,NULL,
 115,212,234,12,(UBYTE *)"Copyright b_y",&SAttr,2,PLACETEXT_LEFT|NG_HIGHLABEL,NULL,NULL,
 115,224,234,12,(UBYTE *)"Copyright b_y",&SAttr,3,PLACETEXT_LEFT,NULL,NULL,
 15,18,92,21,(UBYTE *)"Button",&SAttr,4,PLACETEXT_IN,NULL,(APTR)1,
 15,39,92,21,(UBYTE *)"_Ok",&SAttr,5,PLACETEXT_IN,NULL,NULL,
 107,18,92,21,(UBYTE *)"_Under",&SAttr,6,PLACETEXT_IN,NULL,(APTR)2,
 107,39,92,21,(UBYTE *)"Special !",&SAttr,7,PLACETEXT_IN,NULL,NULL,
 217,17,26,11,(UBYTE *)"Checkbo_x",&SAttr,8,PLACETEXT_RIGHT|NG_HIGHLABEL,NULL,NULL,
 217,28,26,11,(UBYTE *)"_Gfx",&SAttr,9,PLACETEXT_RIGHT,NULL,NULL,
 217,39,26,11,(UBYTE *)"Text _Modus",&SAttr,10,PLACETEXT_RIGHT,NULL,NULL,
 217,50,26,11,(UBYTE *)"Nicht umschalten",&SAttr,11,PLACETEXT_RIGHT,NULL,NULL,
 393,30,227,49,(UBYTE *)"Info Box",&SAttr,12,PLACETEXT_ABOVE|NG_HIGHLABEL,NULL,NULL,
 393,90,227,71,(UBYTE *)"Screen Mode:",&SAttr,13,PLACETEXT_ABOVE,NULL,NULL,
 248,72,16,8,(UBYTE *)"3.x",&SAttr,14,PLACETEXT_RIGHT|NG_HIGHLABEL,NULL,NULL,
 230,72,16,8,(UBYTE *)"",&SAttr,15,PLACETEXT_LEFT,NULL,NULL,
 89,104,87,10,(UBYTE *)"Fast Ram",&SAttr,16,PLACETEXT_LEFT|NG_HIGHLABEL,NULL,NULL,
 89,114,87,10,(UBYTE *)"Chip Ram",&SAttr,17,PLACETEXT_LEFT|NG_HIGHLABEL,NULL,NULL,
 61,135,122,12,(UBYTE *)"Mo_dus",&SAttr,18,PLACETEXT_LEFT,NULL,NULL,
 61,147,122,12,(UBYTE *)"Mo_dus",&SAttr,19,PLACETEXT_LEFT|NG_HIGHLABEL,NULL,NULL,
 83,167,160,19,(UBYTE *)"Farb_wahl",&SAttr,20,PLACETEXT_LEFT,NULL,NULL,
 83,186,160,19,(UBYTE *)"Farb_wahl",&SAttr,21,PLACETEXT_LEFT|NG_HIGHLABEL,NULL,NULL,
 332,72,24,73,(UBYTE *)"Q",&SAttr,22,PLACETEXT_BELOW|NG_HIGHLABEL,NULL,NULL,
 356,72,24,73,(UBYTE *)"Q",&SAttr,23,PLACETEXT_BELOW,NULL,NULL,
 311,170,281,17,(UBYTE *)"Anfang",&SAttr,24,PLACETEXT_LEFT|NG_HIGHLABEL,NULL,NULL,
 311,187,281,17,(UBYTE *)"Ende",&SAttr,25,PLACETEXT_LEFT,NULL,NULL,
 441,213,184,11,(UBYTE *)"Fix Text",&SAttr,26,PLACETEXT_LEFT|NG_HIGHLABEL,NULL,NULL,
 441,224,184,11,(UBYTE *)"Fix Text",&SAttr,27,PLACETEXT_LEFT,NULL,NULL
};

static ULONG Kinds0[] = {
 INTEGER_KIND,
 INTEGER_KIND,
 STRING_KIND,
 STRING_KIND,
 BUTTON_KIND,
 BUTTON_KIND,
 BUTTON_KIND,
 BUTTON_KIND,
 CHECKBOX_KIND,
 CHECKBOX_KIND,
 CHECKBOX_KIND,
 CHECKBOX_KIND,
 LISTVIEW_KIND,
 LISTVIEW_KIND,
 MX_KIND,
 MX_KIND,
 NUMBER_KIND,
 NUMBER_KIND,
 CYCLE_KIND,
 CYCLE_KIND,
 PALETTE_KIND,
 PALETTE_KIND,
 SCROLLER_KIND,
 SCROLLER_KIND,
 SLIDER_KIND,
 SLIDER_KIND,
 TEXT_KIND,
 TEXT_KIND
};

static char *MxText0_0[] = {
 (UBYTE *)"_Domino",
 (UBYTE *)"_Pal",
 (UBYTE *)"_Ntsc",
 (UBYTE *)"N_ichts",
 NULL
};

static char *MxText0_1[] = {
 (UBYTE *)"1",
 (UBYTE *)"2",
 (UBYTE *)"4",
 (UBYTE *)"8",
 (UBYTE *)"16",
 (UBYTE *)"32",
 (UBYTE *)"64",
 (UBYTE *)"128",
 (UBYTE *)"256",
 NULL
};

static char *CycleText0_0[] = {
 (UBYTE *)"Pause",
 (UBYTE *)"Step",
 (UBYTE *)"Run",
 NULL
};

static char *CycleText0_1[] = {
 (UBYTE *)"Pause",
 (UBYTE *)"Step",
 (UBYTE *)"Run",
 NULL
};

static Tag Tags0[] = {
 GT_Underscore,'_',
 GTIN_Number,4711,
 STRINGA_ReplaceMode,TRUE,
 STRINGA_ExitHelp,TRUE,
 GA_Immediate,TRUE,
 TAG_DONE,
 GT_Underscore,'_',
 GTIN_Number,1,
 GTIN_MaxChars,7,
 STRINGA_Justification,GACT_STRINGCENTER,
 GA_TabCycle,FALSE,
 TAG_DONE,
 GT_Underscore,'_',
 GTST_String,(ULONG)"Thomas Patschinski",
 STRINGA_ReplaceMode,TRUE,
 STRINGA_Justification,GACT_STRINGCENTER,
 GTST_MaxChars,79,
 GA_Immediate,TRUE,
 GA_TabCycle,FALSE,
 STRINGA_ExitHelp,TRUE,
 TAG_DONE,
 GT_Underscore,'_',
 GTST_String,(ULONG)"Michael Neumann",
 GTST_MaxChars,255,
 GA_TabCycle,FALSE,
 STRINGA_ExitHelp,TRUE,
 TAG_DONE,
 GA_Immediate,TRUE,
 TAG_DONE,
 GT_Underscore,'_',
 TAG_DONE,
 GT_Underscore,'_',
 TAG_DONE,
 GA_Disabled,TRUE,
 TAG_DONE,
 GT_Underscore,'_',
 GTCB_Checked,TRUE,
 tagCheckScaled,TRUE,
 TAG_DONE,
 GT_Underscore,'_',
 TAG_DONE,
 GT_Underscore,'_',
 GTCB_Checked,TRUE,
 TAG_DONE,
 GA_Disabled,TRUE,
 TAG_DONE,
 GTLV_ReadOnly,TRUE,
 GTLV_Labels,(ULONG)&Liste[0],
 LAYOUTA_Spacing,2,
 TAG_DONE,
 GTLV_ScrollWidth,24,
 GTLV_ShowSelected,NULL,
 GTLV_Labels,(ULONG)&Liste[1],
 TAG_DONE,
 GT_Underscore,'_',
 GTMX_Spacing,2,
 GTMX_Labels,(ULONG)&MxText0_0,
 GA_Disabled,TRUE,
 tagTitlePlace,PLACETEXT_BELOW,
 TAG_DONE,
 GTMX_Spacing,2,
 GTMX_Labels,(ULONG)&MxText0_1,
 tagMxScaled,TRUE,
 TAG_DONE,
 GTNM_Border,TRUE,
 GTNM_Number,11893096,
 tagClipped,FALSE,
 TAG_DONE,
 GTNM_Border,TRUE,
 GTNM_Number,1904760,
 tagFrontPen,2,
 tagJustification,2, tagMaxNumberLen,9,
 TAG_DONE,
 GT_Underscore,'_',
 GTCY_Labels,(ULONG)&CycleText0_0,
 TAG_DONE,
 GT_Underscore,'_',
 GA_Disabled,TRUE,
 GTCY_Labels,(ULONG)&CycleText0_1,
 TAG_DONE,
 GT_Underscore,'_',
 GA_Disabled,TRUE,
 GTPA_Depth,2,
 GTPA_IndicatorHeight,0,
 GTPA_IndicatorWidth,0,
 TAG_DONE,
 GT_Underscore,'_',
 GTPA_Depth,2,
 GTPA_IndicatorHeight,0,
 GTPA_IndicatorWidth,0,
 TAG_DONE,
 GA_Disabled,TRUE,
 GTSC_Total,10,
 GTSC_Visible,3,
 GTSC_Arrows,16,
 PGA_Freedom,2,
 GA_RelVerify,TRUE,
 GA_Immediate,TRUE,
 TAG_DONE,
 GTSC_Top,9,
 GTSC_Total,11,
 GTSC_Arrows,16,
 PGA_Freedom,2,
 TAG_DONE,
 GTSL_Level,3,
 GTSL_MaxLevelLen,4,
 GTSL_LevelFormat,(ULONG)"%ld ",
 GTSL_LevelPlace,PLACETEXT_RIGHT,
 tagMaxPixelLen,5,
 tagJustification,1,
 TAG_DONE,
 GA_Disabled,TRUE,
 GTSL_Level,15,
 GTSL_MaxLevelLen,3,
 GTSL_LevelFormat,(ULONG)"%ld ",
 GTSL_LevelPlace,PLACETEXT_RIGHT,
 tagJustification,2,
 TAG_DONE,
 GTTX_Border,TRUE,
 GTTX_Text,(ULONG)"GadEd Version 1.10",
 GTTX_CopyText,TRUE,
 tagFrontPen,2,
 tagBackPen,1,
 TAG_DONE,
 GTTX_Border,TRUE,
 GTTX_Text,(ULONG)"<Empty>",
 tagJustification,2, tagClipped,FALSE,
 TAG_DONE
};

static struct IntuiText IText0[] = {
 3,2,JAM2,267,126,&SAttr,(UBYTE *)"Das ist",NULL,
 1,0,JAM2|INVERSVID,283,144,&SAttr,(UBYTE *)"Intui",NULL,
 1,3,JAM2,291,153,&SAttr,(UBYTE *)"Text",NULL,
 1,2,JAM2,299,135,&SAttr,(UBYTE *)"ein",NULL
};

static struct NewMenu newM0[] = {
 NM_TITLE,(UBYTE *)"Projekt",NULL,0,0,NULL,
 NM_ITEM,(UBYTE *)"About",(UBYTE *)"A",0,0,NULL,
 NM_ITEM,NM_BARLABEL,NULL,0,0,NULL,
 NM_ITEM,(UBYTE *)"Load",(UBYTE *)"L",0,0,NULL,
 NM_ITEM,(UBYTE *)"Save",(UBYTE *)"S",0,0,NULL,
 NM_ITEM,NM_BARLABEL,NULL,0,0,NULL,
 NM_ITEM,(UBYTE *)"Quit",(UBYTE *)"Q",0,0,NULL,
 NM_TITLE,(UBYTE *)"Buffer",NULL,0,0,NULL,
 NM_ITEM,(UBYTE *)"Cut",(UBYTE *)"C",0,0,NULL,
 NM_ITEM,(UBYTE *)"Paste",(UBYTE *)"P",0,0,NULL,
 NM_ITEM,(UBYTE *)"Copy",(UBYTE *)"O",0,0,NULL,
 NM_TITLE,(UBYTE *)"Settings",NULL,0,0,NULL,
 NM_ITEM,(UBYTE *)"Special",NULL,0,0,NULL,
 NM_SUB,(UBYTE *)"Betatester Info",NULL,MENUTOGGLE|CHECKIT|ITEMENABLED,0,NULL,
 NM_SUB,NM_BARLABEL,NULL,0,0,NULL,
 NM_SUB,(UBYTE *)"Extendet Features",NULL,MENUTOGGLE|CHECKIT,0,NULL,
 NM_ITEM,(UBYTE *)"Save Icons",NULL,MENUTOGGLE|CHECKIT|CHECKED,0,NULL,
 NM_ITEM,(UBYTE *)"Use ENV:",NULL,MENUTOGGLE|CHECKIT|CHECKED,0,NULL,
 NM_ITEM,(UBYTE *)"Fast Ram",NULL,MENUTOGGLE|CHECKIT,0,NULL,
 NM_ITEM,NM_BARLABEL,NULL,0,0,NULL,
 NM_ITEM,(UBYTE *)"Asl Requster",NULL,CHECKIT|CHECKED,0,NULL,
 NM_ITEM,(UBYTE *)"OS 3.x",NULL,CHECKIT,0,NULL,
 NM_TITLE,(UBYTE *)"Extendet Menu",NULL,NM_MENUDISABLED,0,NULL,
 NM_ITEM,(UBYTE *)"New 1",NULL,0,0,NULL,
 NM_ITEM,(UBYTE *)"New 2",NULL,0,0,NULL,
 NM_ITEM,NM_BARLABEL,NULL,0,0,NULL,
 NM_ITEM,(UBYTE *)"New 3",NULL,0,0,NULL,
 NM_SUB,(UBYTE *)"New 3_1",NULL,0,0,NULL,
 NM_SUB,(UBYTE *)"New 3_2",NULL,0,0,NULL,
 NM_END,NULL,NULL,0,0,NULL};

static WORD Bevel0[] = {
 7,101,179,27,
 329,68,55,95,
 7,68,179,30,
 7,132,179,31,
 364,210,264,29,
 213,13,171,53,
 7,210,345,29,
 7,165,240,43,
 7,13,203,53,
 188,68,139,95,
 250,165,378,43,
 387,13,241,150
};

static Tag BevelTags0[] = {
 GT_VisualInfo,NULL,
 TAG_DONE,
 GT_VisualInfo,NULL,
 TAG_DONE,
 GT_VisualInfo,NULL,
 TAG_DONE,
 GT_VisualInfo,NULL,
 TAG_DONE,
 GT_VisualInfo,NULL,
 TAG_DONE,
 GT_VisualInfo,NULL,
 TAG_DONE,
 GT_VisualInfo,NULL,
 TAG_DONE,
 GT_VisualInfo,NULL,
 TAG_DONE,
 GT_VisualInfo,NULL,
 TAG_DONE,
 GT_VisualInfo,NULL,
 TAG_DONE,
 GT_VisualInfo,NULL,
 TAG_DONE,
 GT_VisualInfo,NULL,
 TAG_DONE
};

static Tag WTags0[] = {
 WA_CustomScreen,NULL,
 WA_Gadgets,NULL,
 WA_Left,0,
 WA_Top,0,
 WA_Width,0,
 WA_Height,0,
 WA_MinWidth,633,
 WA_MinHeight,243,
 WA_MaxWidth,633,
 WA_MaxHeight,243,
 WA_Title,(ULONG)"Gadget Test Fenster1",
 WA_IDCMP,BUTTONIDCMP|CHECKBOXIDCMP|INTEGERIDCMP|LISTVIEWIDCMP|MXIDCMP|NUMBERIDCMP|CYCLEIDCMP|PALETTEIDCMP|SCROLLERIDCMP|SLIDERIDCMP|STRINGIDCMP|TEXTIDCMP|IDCMP_NEWSIZE|IDCMP_CLOSEWINDOW,
 WA_Flags,WFLG_DRAGBAR|WFLG_DEPTHGADGET|WFLG_CLOSEGADGET|WFLG_ACTIVATE,
 waNewLookMenu,TRUE,
 TAG_DONE,NULL};

/* Definitionen für Fenster Proc01 */

static struct NewGadget NewG1[] = {
 115,71,67,12,(UBYTE *)"Tel_. Nummer:",&SAttr,0,PLACETEXT_LEFT,NULL,NULL,
 115,83,67,12,(UBYTE *)"_Haus Nummer:",&SAttr,1,PLACETEXT_LEFT|NG_HIGHLABEL,NULL,NULL,
 115,212,234,12,(UBYTE *)"Copyright b_y",&SAttr,2,PLACETEXT_LEFT|NG_HIGHLABEL,NULL,NULL,
 115,224,234,12,(UBYTE *)"Copyright b_y",&SAttr,3,PLACETEXT_LEFT,NULL,NULL,
 15,18,92,21,(UBYTE *)"Button",&SAttr,4,PLACETEXT_IN,NULL,(APTR)1,
 15,39,92,21,(UBYTE *)"_Ok",&SAttr,5,PLACETEXT_IN,NULL,NULL,
 107,18,92,21,(UBYTE *)"_Under",&SAttr,6,PLACETEXT_IN,NULL,(APTR)2,
 107,39,92,21,(UBYTE *)"Special !",&SAttr,7,PLACETEXT_IN,NULL,NULL,
 217,17,26,11,(UBYTE *)"Checkbo_x",&SAttr,8,PLACETEXT_RIGHT|NG_HIGHLABEL,NULL,NULL,
 217,28,26,11,(UBYTE *)"_Gfx",&SAttr,9,PLACETEXT_RIGHT,NULL,NULL,
 217,39,26,11,(UBYTE *)"Text _Modus",&SAttr,10,PLACETEXT_RIGHT,NULL,NULL,
 217,50,26,11,(UBYTE *)"Nicht umschalten",&SAttr,11,PLACETEXT_RIGHT,NULL,NULL,
 393,30,227,49,(UBYTE *)"Info Box",&SAttr,12,PLACETEXT_ABOVE|NG_HIGHLABEL,NULL,NULL,
 393,90,227,71,(UBYTE *)"Screen Mode:",&SAttr,13,PLACETEXT_ABOVE,NULL,NULL,
 248,72,16,8,(UBYTE *)"3.x",&SAttr,14,PLACETEXT_RIGHT|NG_HIGHLABEL,NULL,NULL,
 230,72,16,8,(UBYTE *)"",&SAttr,15,PLACETEXT_LEFT,NULL,NULL,
 89,104,87,10,(UBYTE *)"Fast Ram",&SAttr,16,PLACETEXT_LEFT|NG_HIGHLABEL,NULL,NULL,
 89,114,87,10,(UBYTE *)"Chip Ram",&SAttr,17,PLACETEXT_LEFT|NG_HIGHLABEL,NULL,NULL,
 61,135,122,12,(UBYTE *)"Mo_dus",&SAttr,18,PLACETEXT_LEFT,NULL,NULL,
 61,147,122,12,(UBYTE *)"Mo_dus",&SAttr,19,PLACETEXT_LEFT|NG_HIGHLABEL,NULL,NULL,
 83,167,160,19,(UBYTE *)"Farb_wahl",&SAttr,20,PLACETEXT_LEFT,NULL,NULL,
 83,186,160,19,(UBYTE *)"Farb_wahl",&SAttr,21,PLACETEXT_LEFT|NG_HIGHLABEL,NULL,NULL,
 332,72,24,73,(UBYTE *)"Q",&SAttr,22,PLACETEXT_BELOW|NG_HIGHLABEL,NULL,NULL,
 356,72,24,73,(UBYTE *)"Q",&SAttr,23,PLACETEXT_BELOW,NULL,NULL,
 311,170,281,17,(UBYTE *)"Anfang",&SAttr,24,PLACETEXT_LEFT|NG_HIGHLABEL,NULL,NULL,
 311,187,281,17,(UBYTE *)"Ende",&SAttr,25,PLACETEXT_LEFT,NULL,NULL,
 441,213,184,11,(UBYTE *)"Fix Text",&SAttr,26,PLACETEXT_LEFT|NG_HIGHLABEL,NULL,NULL,
 441,224,184,11,(UBYTE *)"Fix Text",&SAttr,27,PLACETEXT_LEFT,NULL,NULL
};

static ULONG Kinds1[] = {
 INTEGER_KIND,
 INTEGER_KIND,
 STRING_KIND,
 STRING_KIND,
 BUTTON_KIND,
 BUTTON_KIND,
 BUTTON_KIND,
 BUTTON_KIND,
 CHECKBOX_KIND,
 CHECKBOX_KIND,
 CHECKBOX_KIND,
 CHECKBOX_KIND,
 LISTVIEW_KIND,
 LISTVIEW_KIND,
 MX_KIND,
 MX_KIND,
 NUMBER_KIND,
 NUMBER_KIND,
 CYCLE_KIND,
 CYCLE_KIND,
 PALETTE_KIND,
 PALETTE_KIND,
 SCROLLER_KIND,
 SCROLLER_KIND,
 SLIDER_KIND,
 SLIDER_KIND,
 TEXT_KIND,
 TEXT_KIND
};

static char *MxText1_0[] = {
 (UBYTE *)"_Domino",
 (UBYTE *)"_Pal",
 (UBYTE *)"_Ntsc",
 (UBYTE *)"N_ichts",
 NULL
};

static char *MxText1_1[] = {
 (UBYTE *)"1",
 (UBYTE *)"2",
 (UBYTE *)"4",
 (UBYTE *)"8",
 (UBYTE *)"16",
 (UBYTE *)"32",
 (UBYTE *)"64",
 (UBYTE *)"128",
 (UBYTE *)"256",
 NULL
};

static char *CycleText1_0[] = {
 (UBYTE *)"Pause",
 (UBYTE *)"Step",
 (UBYTE *)"Run",
 NULL
};

static char *CycleText1_1[] = {
 (UBYTE *)"Pause",
 (UBYTE *)"Step",
 (UBYTE *)"Run",
 NULL
};

static Tag Tags1[] = {
 GT_Underscore,'_',
 GTIN_Number,4711,
 STRINGA_ReplaceMode,TRUE,
 STRINGA_ExitHelp,TRUE,
 GA_Immediate,TRUE,
 TAG_DONE,
 GT_Underscore,'_',
 GTIN_Number,1,
 GTIN_MaxChars,7,
 STRINGA_Justification,GACT_STRINGCENTER,
 GA_TabCycle,FALSE,
 TAG_DONE,
 GT_Underscore,'_',
 GTST_String,(ULONG)"Thomas Patschinski",
 STRINGA_ReplaceMode,TRUE,
 STRINGA_Justification,GACT_STRINGCENTER,
 GTST_MaxChars,79,
 GA_Immediate,TRUE,
 GA_TabCycle,FALSE,
 STRINGA_ExitHelp,TRUE,
 TAG_DONE,
 GT_Underscore,'_',
 GTST_String,(ULONG)"Michael Neumann",
 GTST_MaxChars,255,
 GA_TabCycle,FALSE,
 STRINGA_ExitHelp,TRUE,
 TAG_DONE,
 GA_Immediate,TRUE,
 TAG_DONE,
 GT_Underscore,'_',
 TAG_DONE,
 GT_Underscore,'_',
 TAG_DONE,
 GA_Disabled,TRUE,
 TAG_DONE,
 GT_Underscore,'_',
 GTCB_Checked,TRUE,
 tagCheckScaled,TRUE,
 TAG_DONE,
 GT_Underscore,'_',
 TAG_DONE,
 GT_Underscore,'_',
 GTCB_Checked,TRUE,
 TAG_DONE,
 GA_Disabled,TRUE,
 TAG_DONE,
 GTLV_ReadOnly,TRUE,
 GTLV_Labels,(ULONG)&ListViewList00[0],
 LAYOUTA_Spacing,2,
 TAG_DONE,
 GTLV_ScrollWidth,24,
 GTLV_ShowSelected,NULL,
 GTLV_Labels,(ULONG)&ListViewList00[1],
 TAG_DONE,
 GT_Underscore,'_',
 GTMX_Spacing,2,
 GTMX_Labels,(ULONG)&MxText1_0,
 GA_Disabled,TRUE,
 tagTitlePlace,PLACETEXT_BELOW,
 TAG_DONE,
 GTMX_Spacing,2,
 GTMX_Labels,(ULONG)&MxText1_1,
 tagMxScaled,TRUE,
 TAG_DONE,
 GTNM_Border,TRUE,
 GTNM_Number,11893096,
 tagClipped,FALSE,
 TAG_DONE,
 GTNM_Border,TRUE,
 GTNM_Number,1904760,
 tagFrontPen,2,
 tagJustification,2, tagMaxNumberLen,9,
 TAG_DONE,
 GT_Underscore,'_',
 GTCY_Labels,(ULONG)&CycleText1_0,
 TAG_DONE,
 GT_Underscore,'_',
 GA_Disabled,TRUE,
 GTCY_Labels,(ULONG)&CycleText1_1,
 TAG_DONE,
 GT_Underscore,'_',
 GA_Disabled,TRUE,
 GTPA_Depth,2,
 GTPA_IndicatorHeight,0,
 GTPA_IndicatorWidth,0,
 TAG_DONE,
 GT_Underscore,'_',
 GTPA_Depth,2,
 GTPA_IndicatorHeight,0,
 GTPA_IndicatorWidth,0,
 TAG_DONE,
 GA_Disabled,TRUE,
 GTSC_Total,10,
 GTSC_Visible,3,
 GTSC_Arrows,16,
 PGA_Freedom,2,
 GA_RelVerify,TRUE,
 GA_Immediate,TRUE,
 TAG_DONE,
 GTSC_Top,9,
 GTSC_Total,11,
 GTSC_Arrows,16,
 PGA_Freedom,2,
 TAG_DONE,
 GTSL_Level,3,
 GTSL_MaxLevelLen,4,
 GTSL_LevelFormat,(ULONG)"%ld ",
 GTSL_LevelPlace,PLACETEXT_RIGHT,
 tagMaxPixelLen,5,
 tagJustification,1,
 TAG_DONE,
 GA_Disabled,TRUE,
 GTSL_Level,15,
 GTSL_MaxLevelLen,3,
 GTSL_LevelFormat,(ULONG)"%ld ",
 GTSL_LevelPlace,PLACETEXT_RIGHT,
 tagJustification,2,
 TAG_DONE,
 GTTX_Border,TRUE,
 GTTX_Text,(ULONG)"GadEd Version 1.10",
 GTTX_CopyText,TRUE,
 tagFrontPen,2,
 tagBackPen,1,
 TAG_DONE,
 GTTX_Border,TRUE,
 GTTX_Text,(ULONG)"<Empty>",
 tagJustification,2, tagClipped,FALSE,
 TAG_DONE
};

static struct IntuiText IText1[] = {
 3,2,JAM2,267,126,&SAttr,(UBYTE *)"Das ist",NULL,
 1,0,JAM2|INVERSVID,283,144,&SAttr,(UBYTE *)"Intui",NULL,
 1,3,JAM2,291,153,&SAttr,(UBYTE *)"Text",NULL,
 1,2,JAM2,299,135,&SAttr,(UBYTE *)"ein",NULL
};

static struct NewMenu newM1[] = {
 NM_TITLE,(UBYTE *)"Projekt",NULL,0,0,NULL,
 NM_ITEM,(UBYTE *)"About",(UBYTE *)"A",0,0,NULL,
 NM_ITEM,NM_BARLABEL,NULL,0,0,NULL,
 NM_ITEM,(UBYTE *)"Load",(UBYTE *)"L",0,0,NULL,
 NM_ITEM,(UBYTE *)"Save",(UBYTE *)"S",0,0,NULL,
 NM_ITEM,NM_BARLABEL,NULL,0,0,NULL,
 NM_ITEM,(UBYTE *)"Quit",(UBYTE *)"Q",0,0,NULL,
 NM_TITLE,(UBYTE *)"Buffer",NULL,0,0,NULL,
 NM_ITEM,(UBYTE *)"Cut",(UBYTE *)"C",0,0,NULL,
 NM_ITEM,(UBYTE *)"Paste",(UBYTE *)"P",0,0,NULL,
 NM_ITEM,(UBYTE *)"Copy",(UBYTE *)"O",0,0,NULL,
 NM_TITLE,(UBYTE *)"Settings",NULL,0,0,NULL,
 NM_ITEM,(UBYTE *)"Special",NULL,0,0,NULL,
 NM_SUB,(UBYTE *)"Betatester Info",NULL,MENUTOGGLE|CHECKIT|ITEMENABLED,0,NULL,
 NM_SUB,NM_BARLABEL,NULL,0,0,NULL,
 NM_SUB,(UBYTE *)"Extendet Features",NULL,MENUTOGGLE|CHECKIT,0,NULL,
 NM_ITEM,(UBYTE *)"Save Icons",NULL,MENUTOGGLE|CHECKIT|CHECKED,0,NULL,
 NM_ITEM,(UBYTE *)"Use ENV:",NULL,MENUTOGGLE|CHECKIT|CHECKED,0,NULL,
 NM_ITEM,(UBYTE *)"Fast Ram",NULL,MENUTOGGLE|CHECKIT,0,NULL,
 NM_ITEM,NM_BARLABEL,NULL,0,0,NULL,
 NM_ITEM,(UBYTE *)"Asl Requster",NULL,CHECKIT|CHECKED,0,NULL,
 NM_ITEM,(UBYTE *)"OS 3.x",NULL,CHECKIT,0,NULL,
 NM_TITLE,(UBYTE *)"Extendet Menu",NULL,NM_MENUDISABLED,0,NULL,
 NM_ITEM,(UBYTE *)"New 1",NULL,0,0,NULL,
 NM_ITEM,(UBYTE *)"New 2",NULL,0,0,NULL,
 NM_ITEM,NM_BARLABEL,NULL,0,0,NULL,
 NM_ITEM,(UBYTE *)"New 3",NULL,0,0,NULL,
 NM_SUB,(UBYTE *)"New 3_1",NULL,0,0,NULL,
 NM_SUB,(UBYTE *)"New 3_2",NULL,0,0,NULL,
 NM_END,NULL,NULL,0,0,NULL};

static WORD Bevel1[] = {
 7,101,179,27,
 329,68,55,95,
 7,68,179,30,
 7,132,179,31,
 364,210,264,29,
 213,13,171,53,
 7,210,345,29,
 7,165,240,43,
 7,13,203,53,
 188,68,139,95,
 250,165,378,43,
 387,13,241,150
};

static Tag BevelTags1[] = {
 GT_VisualInfo,NULL,
 TAG_DONE,
 GT_VisualInfo,NULL,
 TAG_DONE,
 GT_VisualInfo,NULL,
 TAG_DONE,
 GT_VisualInfo,NULL,
 TAG_DONE,
 GT_VisualInfo,NULL,
 TAG_DONE,
 GT_VisualInfo,NULL,
 TAG_DONE,
 GT_VisualInfo,NULL,
 TAG_DONE,
 GT_VisualInfo,NULL,
 TAG_DONE,
 GT_VisualInfo,NULL,
 TAG_DONE,
 GT_VisualInfo,NULL,
 TAG_DONE,
 GT_VisualInfo,NULL,
 TAG_DONE,
 GT_VisualInfo,NULL,
 TAG_DONE
};

static Tag WTags1[] = {
 WA_CustomScreen,NULL,
 WA_Gadgets,NULL,
 WA_Left,0,
 WA_Top,0,
 WA_Width,0,
 WA_Height,0,
 WA_MinWidth,633,
 WA_MinHeight,243,
 WA_MaxWidth,633,
 WA_MaxHeight,243,
 WA_Title,(ULONG)"Gadget Test Fenster",
 WA_IDCMP,BUTTONIDCMP|CHECKBOXIDCMP|INTEGERIDCMP|LISTVIEWIDCMP|MXIDCMP|NUMBERIDCMP|CYCLEIDCMP|PALETTEIDCMP|SCROLLERIDCMP|SLIDERIDCMP|STRINGIDCMP|TEXTIDCMP|IDCMP_NEWSIZE|IDCMP_CLOSEWINDOW,
 WA_Flags,WFLG_DRAGBAR|WFLG_DEPTHGADGET|WFLG_CLOSEGADGET|WFLG_ACTIVATE,
 waNewLookMenu,TRUE,
 TAG_DONE,NULL};

BOOL AddNode(struct List *LVList, char *Strg)
{
   char         *NewStr;
   struct Node  *TempNode;

   TempNode=AllocVec(sizeof(struct Node),MEMF_PUBLIC|MEMF_CLEAR);
   if (TempNode==NULL) return (FALSE);
   AddTail(LVList,TempNode);
   NewStr=AllocVec(strlen(Strg)+1,MEMF_PUBLIC|MEMF_CLEAR);
   if (NewStr==NULL) return (FALSE);
   TempNode->ln_Name = NewStr;
   strcpy(NewStr,Strg);
   return (TRUE);
}

int CalcXValue(int number)
{
   return ((FontXSize*number+4)/8);
}

int CalcYValue(int number)
{
   return ((FontYSize*number+4)/8);
}

void CalcFont(int Width,int Height)
{
   OffsetY        = 0;
   FontXSize      = Screen->RastPort.Font->tf_XSize;
   FontYSize      = Screen->RastPort.Font->tf_YSize;
   SAttr.ta_Name  = Screen->RastPort.Font->tf_Message.mn_Node.ln_Name;
   SAttr.ta_YSize = FontYSize;
   if ((Width>0) && (Height>0)) {
      if ((CalcXValue(Width) > Screen->Width) || (CalcYValue(Height) > Screen->Height)) {
         OffsetY        = FontYSize-8;
         SAttr.ta_Name  = (STRPTR)"topaz.font";
         SAttr.ta_YSize = 8;
         FontXSize      = 8;
         FontYSize      = 8;
      }
   }
}

int CenterX(int width)
{
   struct Rectangle rect;
   int   l,w;
   ULONG ID;

   ID = GetVPModeID(&Screen->ViewPort);
   QueryOverscan(ID,&rect,OSCAN_TEXT);
   l = -Screen->LeftEdge;
   w = rect.MaxX-rect.MinX+1;
   return ((w-width)/2+l);
}

int CenterY(int height)
{
   struct Rectangle rect;
   int   t,h;
   ULONG ID;

   ID = GetVPModeID(&Screen->ViewPort);
   QueryOverscan(ID,&rect,OSCAN_TEXT);
   t = -Screen->TopEdge;
   h = rect.MaxY-rect.MinY+1;
   return ((h-height)/2+t);
}

void RefreshProc00(void)
{
   int i;
   int left,top,width,height;
   struct IntuiText TempIText;

   TagCount=0;
   for (i=0;i<12;i++) {
      BevelTags0[TagCount+1]=(ULONG)Vi;
      left   = CalcXValue(Bevel0[i*4]);
      top    = CalcYValue(Bevel0[i*4+1])+OffsetY;
      width  = CalcXValue(Bevel0[i*4+2]);
      height = CalcYValue(Bevel0[i*4+3]);
      DrawBevelBoxA(W[0]->RPort,left,top,width,height,(struct TagItem*)&BevelTags0[TagCount]);
      while (BevelTags0[TagCount]) TagCount+=2;
      TagCount++;
   }

   for (i=0;i<4;i++) {
      TempIText=IText0[i];
      TempIText.LeftEdge  = CalcXValue(TempIText.LeftEdge);
      TempIText.TopEdge   = CalcYValue(TempIText.TopEdge)+OffsetY;
      PrintIText(W[0]->RPort,&TempIText,0,0);
   }
}

void CloseProc00Mask(void)
{
   int          i;
   struct Node *TempNode;

   if (W[0]) {
      CloseWindow(W[0]);
      W[0]=NULL;
   }
   if (Men) {
      ClearMenuStrip(W[0]);
      FreeMenus(Men);
      Men=NULL;
   }
   if (congad[0]) {
      FreeGadgets(congad[0]);
      congad[0]=NULL;
   }
   for (i=0;i<2;i++) {
      TempNode=RemHead(&Liste[i]);
      while (TempNode) {
         if(TempNode->ln_Name) FreeVec(TempNode->ln_Name);
         FreeVec(TempNode);
         TempNode=RemHead(&Liste[i]);
      }
   }
   if (WFont[0]) {
      CloseFont(WFont[0]);
      WFont[0]=NULL;
   }
}

struct Window *InitProc00Mask(struct TagItem *UserTags){
   int i;
   struct NewGadget  TempGadget;
   struct TagItem   *MainList, *UserList, *TempItem;


   if (W[0]) return (NULL);
   NewList(&Liste[0]);
   NewList(&Liste[1]);

   if (!AddNode(&Liste[0],"Mode:      Hires Lace")) {CloseProc00Mask(); return (NULL); } 
   if (!AddNode(&Liste[0],"Auflösung: 800x600")) {CloseProc00Mask(); return (NULL); } 
   if (!AddNode(&Liste[0],"Hori. Frq: 81 Hz")) {CloseProc00Mask(); return (NULL); } 
   if (!AddNode(&Liste[0],"Vert. Frq: 57 kHz")) {CloseProc00Mask(); return (NULL); } 
   if (!AddNode(&Liste[0]," ")) {CloseProc00Mask(); return (NULL); } 
   if (!AddNode(&Liste[0],"Special:   Nicht ziehbar")) {CloseProc00Mask(); return (NULL); } 
   if (!AddNode(&Liste[0],"           Kein Genlock")) {CloseProc00Mask(); return (NULL); } 
   if (!AddNode(&Liste[0],"           WB Like")) {CloseProc00Mask(); return (NULL); } 

   if (!AddNode(&Liste[1],"DOMINO:1280x1024")) {CloseProc00Mask(); return (NULL); } 
   if (!AddNode(&Liste[1],"DOMINO:1024x768")) {CloseProc00Mask(); return (NULL); } 
   if (!AddNode(&Liste[1],"DOMINO:800x600")) {CloseProc00Mask(); return (NULL); } 
   if (!AddNode(&Liste[1],"DOMINO:640x480")) {CloseProc00Mask(); return (NULL); } 
   if (!AddNode(&Liste[1],"PAL:Hires")) {CloseProc00Mask(); return (NULL); } 
   if (!AddNode(&Liste[1],"PAL:Hires Lace")) {CloseProc00Mask(); return (NULL); } 
   if (!AddNode(&Liste[1],"PAL:Superhires")) {CloseProc00Mask(); return (NULL); } 
   if (!AddNode(&Liste[1],"PAL:Superhires Lace")) {CloseProc00Mask(); return (NULL); } 

   WinLeft   = 41;
   WinTop    = 120;
   CalcFont(633,243);
   WinWidth  =  CalcXValue(633);
   WinHeight =  CalcYValue(243)+OffsetY;
   if (WinLeft + WinWidth > Screen->Width)
      WinLeft = Screen->Width - WinWidth;
   if (WinTop + WinHeight > Screen->Height)
      WinTop  = Screen->Height - WinHeight;
   if (!(gad=CreateContext(&congad[0]))) { CloseProc00Mask(); return (NULL); }
   TagCount=0;
   for (i=0;i<28;i++) {
      TempGadget=NewG0[i];
      TempGadget.ng_VisualInfo = Vi;
      TempGadget.ng_LeftEdge   = CalcXValue(TempGadget.ng_LeftEdge);
      TempGadget.ng_TopEdge    = CalcYValue(TempGadget.ng_TopEdge)+OffsetY;
      TempGadget.ng_Width      = CalcXValue(TempGadget.ng_Width);
      TempGadget.ng_Height     = CalcYValue(TempGadget.ng_Height);
      G0[i]=gad=CreateGadgetA(Kinds0[i],gad,&TempGadget,(struct TagItem*)&Tags0[TagCount]);
      if (!gad) {
         CloseProc00Mask(); return (NULL);
      }
      if (Kinds0[i]==BUTTON_KIND) {
         if (TempGadget.ng_UserData)
            gad->Activation |= GACT_TOGGLESELECT;
         if (TempGadget.ng_UserData>(APTR)1)
            gad->Flags |= GFLG_SELECTED;
      }
      while (Tags0[TagCount]) TagCount+=2;
      TagCount++;
   }

   WTags0[1]=(ULONG)Screen;
   WTags0[3]=(ULONG)congad[0];
   WTags0[5]=CenterX(WinWidth);
   WTags0[7]=CenterY(WinHeight);
   WTags0[9]=WinWidth;
   WTags0[11]=WinHeight;
   if (!(MainList=CloneTagItems((struct TagItem*)&WTags0[0]))) {
      CloseProc00Mask(); return (NULL);
   }
   if (!(UserList=CloneTagItems(UserTags))) {
      FreeTagItems(MainList);
      CloseProc00Mask(); return (NULL);
   }
   FilterTagChanges(UserList,MainList,TAGFILTER_NOT);
   TempItem=MainList;
   while (TempItem->ti_Tag) TempItem++;
   TempItem->ti_Tag  = TAG_MORE;
   TempItem->ti_Data = (ULONG)UserList;
   W[0]=OpenWindowTagList(NULL,MainList);
   FreeTagItems(MainList);
   FreeTagItems(UserList);
   if (W[0]) {
      GT_RefreshWindow(W[0],NULL);
      Men=CreateMenus(&newM0[0],TAG_DONE);
      if (LayoutMenus(Men,Vi,gtNewLookMenu,TRUE,TAG_DONE)==FALSE) {CloseProc00Mask(); return (NULL); }
      if (SetMenuStrip(W[0],Men)==FALSE) {CloseProc00Mask(); return (NULL);}
      RefreshProc00();
      return (W[0]);
   }
   else
      return (NULL);
}

struct Gadget *GetProc00GPtr(int Nummer)
{
   if ((Nummer>=0) && (Nummer<=-1))
      return (G0[Nummer]);
   else
      return (NULL);
}

void RefreshProc01(void)
{
   int i;
   int left,top,width,height;
   struct IntuiText TempIText;

   TagCount=0;
   for (i=0;i<12;i++) {
      BevelTags1[TagCount+1]=(ULONG)Vi;
      left   = CalcXValue(Bevel1[i*4]);
      top    = CalcYValue(Bevel1[i*4+1])+OffsetY;
      width  = CalcXValue(Bevel1[i*4+2]);
      height = CalcYValue(Bevel1[i*4+3]);
      DrawBevelBoxA(W[1]->RPort,left,top,width,height,(struct TagItem*)&BevelTags1[TagCount]);
      while (BevelTags1[TagCount]) TagCount+=2;
      TagCount++;
   }

   for (i=0;i<4;i++) {
      TempIText=IText1[i];
      TempIText.LeftEdge  = CalcXValue(TempIText.LeftEdge);
      TempIText.TopEdge   = CalcYValue(TempIText.TopEdge)+OffsetY;
      PrintIText(W[1]->RPort,&TempIText,0,0);
   }
}

void CloseProc01Mask(void)
{
   int          i;
   struct Node *TempNode;

   if (W[1]) {
      CloseWindow(W[1]);
      W[1]=NULL;
   }
   if (Menu00) {
      ClearMenuStrip(W[1]);
      FreeMenus(Menu00);
      Menu00=NULL;
   }
   if (congad[1]) {
      FreeGadgets(congad[1]);
      congad[1]=NULL;
   }
   for (i=0;i<2;i++) {
      TempNode=RemHead(&ListViewList00[i]);
      while (TempNode) {
         if(TempNode->ln_Name) FreeVec(TempNode->ln_Name);
         FreeVec(TempNode);
         TempNode=RemHead(&ListViewList00[i]);
      }
   }
   if (WFont[1]) {
      CloseFont(WFont[1]);
      WFont[1]=NULL;
   }
}

struct Window *InitProc01Mask(struct TagItem *UserTags){
   int i;
   struct NewGadget  TempGadget;
   struct TagItem   *MainList, *UserList, *TempItem;


   if (W[1]) return (NULL);
   NewList(&ListViewList00[0]);
   NewList(&ListViewList00[1]);

   if (!AddNode(&ListViewList00[0],"Mode:      Hires Lace")) {CloseProc01Mask(); return (NULL); } 
   if (!AddNode(&ListViewList00[0],"Auflösung: 800x600")) {CloseProc01Mask(); return (NULL); } 
   if (!AddNode(&ListViewList00[0],"Hori. Frq: 81 Hz")) {CloseProc01Mask(); return (NULL); } 
   if (!AddNode(&ListViewList00[0],"Vert. Frq: 57 kHz")) {CloseProc01Mask(); return (NULL); } 
   if (!AddNode(&ListViewList00[0]," ")) {CloseProc01Mask(); return (NULL); } 
   if (!AddNode(&ListViewList00[0],"Special:   Nicht ziehbar")) {CloseProc01Mask(); return (NULL); } 
   if (!AddNode(&ListViewList00[0],"           Kein Genlock")) {CloseProc01Mask(); return (NULL); } 
   if (!AddNode(&ListViewList00[0],"           WB Like")) {CloseProc01Mask(); return (NULL); } 

   if (!AddNode(&ListViewList00[1],"DOMINO:1280x1024")) {CloseProc01Mask(); return (NULL); } 
   if (!AddNode(&ListViewList00[1],"DOMINO:1024x768")) {CloseProc01Mask(); return (NULL); } 
   if (!AddNode(&ListViewList00[1],"DOMINO:800x600")) {CloseProc01Mask(); return (NULL); } 
   if (!AddNode(&ListViewList00[1],"DOMINO:640x480")) {CloseProc01Mask(); return (NULL); } 
   if (!AddNode(&ListViewList00[1],"PAL:Hires")) {CloseProc01Mask(); return (NULL); } 
   if (!AddNode(&ListViewList00[1],"PAL:Hires Lace")) {CloseProc01Mask(); return (NULL); } 
   if (!AddNode(&ListViewList00[1],"PAL:Superhires")) {CloseProc01Mask(); return (NULL); } 
   if (!AddNode(&ListViewList00[1],"PAL:Superhires Lace")) {CloseProc01Mask(); return (NULL); } 

   WinLeft   = 41;
   WinTop    = 120;
   CalcFont(633,243);
   WinWidth  =  CalcXValue(633);
   WinHeight =  CalcYValue(243)+OffsetY;
   if (WinLeft + WinWidth > Screen->Width)
      WinLeft = Screen->Width - WinWidth;
   if (WinTop + WinHeight > Screen->Height)
      WinTop  = Screen->Height - WinHeight;
   if (!(gad=CreateContext(&congad[1]))) { CloseProc01Mask(); return (NULL); }
   TagCount=0;
   for (i=0;i<28;i++) {
      TempGadget=NewG1[i];
      TempGadget.ng_VisualInfo = Vi;
      TempGadget.ng_LeftEdge   = CalcXValue(TempGadget.ng_LeftEdge);
      TempGadget.ng_TopEdge    = CalcYValue(TempGadget.ng_TopEdge)+OffsetY;
      TempGadget.ng_Width      = CalcXValue(TempGadget.ng_Width);
      TempGadget.ng_Height     = CalcYValue(TempGadget.ng_Height);
      GPtrs00[i]=gad=CreateGadgetA(Kinds1[i],gad,&TempGadget,(struct TagItem*)&Tags1[TagCount]);
      if (!gad) {
         CloseProc01Mask(); return (NULL);
      }
      if (Kinds1[i]==BUTTON_KIND) {
         if (TempGadget.ng_UserData)
            gad->Activation |= GACT_TOGGLESELECT;
         if (TempGadget.ng_UserData>(APTR)1)
            gad->Flags |= GFLG_SELECTED;
      }
      while (Tags1[TagCount]) TagCount+=2;
      TagCount++;
   }

   WTags1[1]=(ULONG)Screen;
   WTags1[3]=(ULONG)congad[1];
   WTags1[5]=CenterX(WinWidth);
   WTags1[7]=CenterY(WinHeight);
   WTags1[9]=WinWidth;
   WTags1[11]=WinHeight;
   if (!(MainList=CloneTagItems((struct TagItem*)&WTags1[0]))) {
      CloseProc01Mask(); return (NULL);
   }
   if (!(UserList=CloneTagItems(UserTags))) {
      FreeTagItems(MainList);
      CloseProc01Mask(); return (NULL);
   }
   FilterTagChanges(UserList,MainList,TAGFILTER_NOT);
   TempItem=MainList;
   while (TempItem->ti_Tag) TempItem++;
   TempItem->ti_Tag  = TAG_MORE;
   TempItem->ti_Data = (ULONG)UserList;
   W[1]=OpenWindowTagList(NULL,MainList);
   FreeTagItems(MainList);
   FreeTagItems(UserList);
   if (W[1]) {
      GT_RefreshWindow(W[1],NULL);
      Menu00=CreateMenus(&newM1[0],TAG_DONE);
      if (LayoutMenus(Menu00,Vi,gtNewLookMenu,TRUE,TAG_DONE)==FALSE) {CloseProc01Mask(); return (NULL); }
      if (SetMenuStrip(W[1],Menu00)==FALSE) {CloseProc01Mask(); return (NULL);}
      RefreshProc01();
      return (W[1]);
   }
   else
      return (NULL);
}

struct Gadget *GetProc01GPtr(int Nummer)
{
   if ((Nummer>=0) && (Nummer<=-1))
      return (GPtrs00[Nummer]);
   else
      return (NULL);
}

void FreeUnbekannt(void)
{
   CloseProc00Mask();
   CloseProc01Mask();
   if (Vi) {
      FreeVisualInfo(Vi);
      Vi=NULL;
   }
   if (OwnScreen) {
      if (Screen) {
         CloseScreen(Screen);
      }
   }
   Screen=NULL;
   if (SFont) {
      CloseFont(SFont);
      SFont=NULL;
   }
}

BOOL InitUnbekannt(struct Screen *S,struct TagItem *UserTags)
{
   struct TagItem *MainList, *UserList, *TempItem;

   if (Screen) return (FALSE);
   if (!S) {
      OwnScreen=TRUE;
      SFont=OpenDiskFont(&SAttr);
      if (!SFont) return (FALSE);
      if (!(MainList=CloneTagItems((struct TagItem*)&STags[0]))) {
         FreeUnbekannt(); return (FALSE);
      }
      if (!(UserList=CloneTagItems(UserTags))) {
         FreeTagItems(MainList);
         FreeUnbekannt(); return (FALSE);
      }
      FilterTagChanges(UserList,MainList,TAGFILTER_NOT);
      TempItem=MainList;
      while (TempItem->ti_Tag) TempItem++;
      TempItem->ti_Tag  = TAG_MORE;
      TempItem->ti_Data = (ULONG)UserList;
      Screen=OpenScreenTagList(NULL,MainList);
      FreeTagItems(MainList);
      FreeTagItems(UserList);
      if(!Screen) {
         FreeUnbekannt();
         return (FALSE);
      }
   }
   else {
      OwnScreen = FALSE;
      Screen=S;
   }
   CalcFont(0,0);
   Vi=GetVisualInfo(Screen,NULL);
   if (!Vi) {
      FreeUnbekannt();
      return (FALSE);
   } else
      return (TRUE);
}
