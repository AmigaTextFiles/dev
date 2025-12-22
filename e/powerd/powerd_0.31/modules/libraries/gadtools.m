MODULE  'utility/tagitem',
      'intuition/intuition'

ENUM  GENERIC_KIND,
    BUTTON_KIND,
    CHECKBOX_KIND,
    INTEGER_KIND,
    LISTVIEW_KIND,
    MX_KIND,
    NUMBER_KIND,
    CYCLE_KIND,
    PALETTE_KIND,
    SCROLLER_KIND,
    SLIDER_KIND=11,
    STRING_KIND,
    TEXT_KIND,
    NUM_KINDS

CONST ARROWIDCMP=IDCMP_GADGETUP|IDCMP_GADGETDOWN|IDCMP_INTUITICKS|IDCMP_MOUSEBUTTONS,
    BUTTONIDCMP=IDCMP_GADGETUP,
    CHECKBOXIDCMP=IDCMP_GADGETUP,
    INTEGERIDCMP=IDCMP_GADGETUP,
    LISTVIEWIDCMP=IDCMP_GADGETUP|IDCMP_GADGETDOWN|IDCMP_MOUSEMOVE|ARROWIDCMP,
    MXIDCMP=IDCMP_GADGETDOWN,
    NUMBERIDCMP=0,
    CYCLEIDCMP=IDCMP_GADGETUP,
    PALETTEIDCMP=IDCMP_GADGETUP,
    SCROLLERIDCMP=IDCMP_GADGETUP|IDCMP_GADGETDOWN|IDCMP_MOUSEMOVE,
    SLIDERIDCMP=IDCMP_GADGETUP|IDCMP_GADGETDOWN|IDCMP_MOUSEMOVE,
    STRINGIDCMP=IDCMP_GADGETUP,
    TEXTIDCMP=0

OBJECT NewGadget
  LeftEdge:WORD,
  TopEdge:WORD,
  Width:WORD,
  Height:WORD,
  GadgetText:PTR TO UBYTE,
  TextAttr:PTR TO TextAttr,
  GadgetID:UWORD,
  Flags:ULONG,
  VisualInfo:APTR,
  UserData:APTR

SET PLACETEXT_LEFT,
    PLACETEXT_RIGHT,
    PLACETEXT_ABOVE,
    PLACETEXT_BELOW,
    PLACETEXT_IN,
    NG_HIGHLABEL

OBJECT NewMenu
  Type:UBYTE,
  Label:PTR TO CHAR,
  CommKey:PTR TO CHAR,
  Flags:UWORD,
  MutualExclude:LONG,
  UserData:APTR

CONST MENU_IMAGE=128

ENUM NM_END,
    NM_TITLE,
    NM_ITEM,
    NM_SUB,
    NM_IGNORE=64,
    NM_BARLABEL=-1

CONST IM_ITEM=NM_ITEM|MENU_IMAGE,
    IM_SUB=NM_SUB|MENU_IMAGE

CONST NM_MENUDISABLED=MENUENABLED,
    NM_ITEMDISABLED=ITEMENABLED,
    NM_COMMANDSTRING=COMMSEQ
//    NM_FLAGMASK=~(COMMSEQ|ITEMTEXT|HIGHFLAGS),
//    NM_FLAGMASK_V39=~(ITEMTEXT|HIGHFLAGS)
/*
#define GTMENU_USERDATA(menu) (* ( (APTR *)(((struct Menu *)menu)+1) ) )
#define GTMENUITEM_USERDATA(menuitem) (* ( (APTR *)(((struct MenuItem *)menuitem)+1) ) )
*/

ENUM  GTMENU_TRIMMED=1,
    GTMENU_INVALID,
    GTMENU_NOMEM

CONST MX_WIDTH=17,
    MX_HEIGHT=9,
    CHECKBOX_WIDTH=26,
    CHECKBOX_HEIGHT=11

CONST GT_TagBase        =TAG_USER+$80000,
    GTVI_NewWindow      =GT_TagBase+1,
    GTVI_NWTags       =GT_TagBase+2,
    GT_Private0       =GT_TagBase+3,
    GTCB_Checked      =GT_TagBase+4,
    GTLV_Top          =GT_TagBase+5,
    GTLV_Labels       =GT_TagBase+6,
    GTLV_ReadOnly     =GT_TagBase+7,
    GTLV_ScrollWidth    =GT_TagBase+8,
    GTMX_Labels       =GT_TagBase+9,
    GTMX_Active       =GT_TagBase+10,
    GTTX_Text       =GT_TagBase+11,
    GTTX_CopyText     =GT_TagBase+12,
    GTNM_Number       =GT_TagBase+13,
    GTCY_Labels       =GT_TagBase+14,
    GTCY_Active       =GT_TagBase+15,
    GTPA_Depth        =GT_TagBase+16,
    GTPA_Color        =GT_TagBase+17,
    GTPA_ColorOffset    =GT_TagBase+18,
    GTPA_IndicatorWidth =GT_TagBase+19,
    GTPA_IndicatorHeight  =GT_TagBase+20,
    GTSC_Top          =GT_TagBase+21,
    GTSC_Total        =GT_TagBase+22,
    GTSC_Visible      =GT_TagBase+23,
    GTSC_Overlap      =GT_TagBase+24,
    GTSL_Min          =GT_TagBase+38,
    GTSL_Max          =GT_TagBase+39,
    GTSL_Level        =GT_TagBase+40,
    GTSL_MaxLevelLen    =GT_TagBase+41,
    GTSL_LevelFormat    =GT_TagBase+42,
    GTSL_LevelPlace   =GT_TagBase+43,
    GTSL_DispFunc     =GT_TagBase+44,
    GTST_String       =GT_TagBase+45,
    GTST_MaxChars     =GT_TagBase+46,
    GTIN_Number       =GT_TagBase+47,
    GTIN_MaxChars     =GT_TagBase+48,
    GTMN_TextAttr     =GT_TagBase+49,
    GTMN_FrontPen     =GT_TagBase+50,
    GTBB_Recessed     =GT_TagBase+51,
    GT_VisualInfo     =GT_TagBase+52,
    GTLV_ShowSelected   =GT_TagBase+53,
    GTLV_Selected     =GT_TagBase+54,
    GT_Reserved1      =GT_TagBase+56,
    GTTX_Border       =GT_TagBase+57,
    GTNM_Border       =GT_TagBase+58,
    GTSC_Arrows       =GT_TagBase+59,
    GTMN_Menu       =GT_TagBase+60,
    GTMX_Spacing      =GT_TagBase+61,
    GTMN_FullMenu     =GT_TagBase+62,   // 37+
    GTMN_SecondaryError =GT_TagBase+63,
    GT_Underscore     =GT_TagBase+64,
    GTST_EditHook     =GT_TagBase+55,
    GTIN_EditHook     =GTST_EditHook,
    GTMN_Checkmark      =GT_TagBase+65,   // 39+
    GTMN_AmigaKey     =GT_TagBase+66,
    GTMN_NewLookMenus   =GT_TagBase+67,
    GTCB_Scaled       =GT_TagBase+68,
    GTMX_Scaled       =GT_TagBase+69,
    GTPA_NumColors      =GT_TagBase+70,
    GTMX_TitlePlace   =GT_TagBase+71,
    GTTX_FrontPen     =GT_TagBase+72,
    GTTX_BackPen      =GT_TagBase+73,
    GTTX_Justification  =GT_TagBase+74,
    GTNM_FrontPen     =GT_TagBase+72,
    GTNM_BackPen      =GT_TagBase+73,
    GTNM_Justification  =GT_TagBase+74,
    GTNM_Format       =GT_TagBase+75,
    GTNM_MaxNumberLen   =GT_TagBase+76,
    GTBB_FrameType      =GT_TagBase+77,
    GTLV_MakeVisible    =GT_TagBase+78,
    GTLV_ItemHeight   =GT_TagBase+79,
    GTSL_MaxPixelLen    =GT_TagBase+80,
    GTSL_Justification  =GT_TagBase+81,
    GTPA_ColorTable   =GT_TagBase+82,
    GTLV_CallBack     =GT_TagBase+83,
    GTLV_MaxPen       =GT_TagBase+84,
    GTTX_Clipped      =GT_TagBase+85,
    GTNM_Clipped      =GT_TagBase+85

ENUM  GTJ_LEFT,
    GTJ_RIGHT,
    GTJ_CENTER

ENUM  BBFT_BUTTON=1,
    BBFT_RIDGE,
    BBFT_ICONDROPBOX

CONST INTERWIDTH=8,
    INTERHEIGHT=4

CONST GADTOOLBIT=$8000
//    GADTOOLMASK=~GADTOOLBIT

CONST LV_DRAW=$202

ENUM  LVCB_OK,
    LVCB_UNKNOWN

ENUM  LVR_NORMAL,
    LVR_SELECTED,
    LVR_NORMALDISABLED,
    LVR_SELECTEDDISABLED=8

OBJECT LVDrawMsg
  MethodID:ULONG,
  RastPort:PTR TO RastPort,
  DrawInfo:PTR TO DrawInfo,
  Bounds:Rectangle,
  State:ULONG
