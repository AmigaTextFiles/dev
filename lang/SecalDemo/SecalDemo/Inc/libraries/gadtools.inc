include "inc/exec/types.inc";
include "inc/utility/tagitem.inc";
include "inc/intuition/intuition.inc";

def GENERIC_KIND = 0;
def BUTTON_KIND = 1;
def CHECKBOX_KIND = 2;
def INTEGER_KIND = 3;
def LISTVIEW_KIND = 4;
def MX_KIND = 5;
def NUMBER_KIND = 6;
def CYCLE_KIND = 7;
def PALETTE_KIND = 8;
def SCROLLER_KIND = 9;

def SLIDER_KIND = 11;
def STRING_KIND = 12;
def TEXT_KIND = 13;

def NUM_KINDS = 14;

def ARROWIDCMP = (IDCMP_GADGETUP|IDCMP_GADGETDOWN|IDCMP_INTUITICKS|IDCMP_MOUSEBUTTONS);

def BUTTONIDCMP = (IDCMP_GADGETUP);
def CHECKBOXIDCMP = (IDCMP_GADGETUP);
def INTEGERIDCMP = (IDCMP_GADGETUP);
def LISTVIEWIDCMP = (IDCMP_GADGETUP|IDCMP_GADGETDOWN|IDCMP_MOUSEMOVE|ARROWIDCMP);

def MXIDCMP = (IDCMP_GADGETDOWN);
def NUMBERIDCMP = (0);
def CYCLEIDCMP = (IDCMP_GADGETUP);
def PALETTEIDCMP = (IDCMP_GADGETUP);

def SCROLLERIDCMP = (IDCMP_GADGETUP|IDCMP_GADGETDOWN|IDCMP_MOUSEMOVE);
def SLIDERIDCMP = (IDCMP_GADGETUP|IDCMP_GADGETDOWN|IDCMP_MOUSEMOVE);
def STRINGIDCMP = (IDCMP_GADGETUP);

def TEXTIDCMP = (0);

struct NewGadget is
  ng_LeftEdge,ng_TopEdge:word;
  ng_Width,ng_Height:word;
  ng_GadgetText:ulong;
  ng_TextAttr:ulong;
  ng_GadgetID:uword;
  ng_Flags:ulong;
  ng_VisualInfo:ulong;
  ng_UserData:ulong;
;

def PLACETEXT_LEFT = $0001;
def PLACETEXT_RIGHT = $0002;
def PLACETEXT_ABOVE = $0004;
def PLACETEXT_BELOW = $0008;
def PLACETEXT_IN = $0010;

def NG_HIGHLABEL = $0020;

struct NewMenu is
  nm_Type:ubyte;
  nm_Label:ulong;
  nm_CommKey:ulong;
  nm_Flags:uword;
  nm_MutualExclude:long;
  nm_UserData:ulong;
;

def MENU_IMAGE = 128;

def NM_TITLE = 1;
def NM_ITEM = 2;
def NM_SUB = 3;

def IM_ITEM = (NM_ITEM|MENU_IMAGE);
def IM_SUB = (NM_SUB|MENU_IMAGE);

def NM_END = 0;

def NM_IGNORE = 64;


def NM_BARLABEL = -1;

def NM_MENUDISABLED = MENUENABLED;
def NM_ITEMDISABLED = ITEMENABLED;

def NM_COMMANDSTRING = COMMSEQ;

def NM_FLAGMASK = (~(COMMSEQ|ITEMTEXT|HIGHFLAGS));
def NM_FLAGMASK_V39 = (~(ITEMTEXT|HIGHFLAGS));

def GTMENU_TRIMMED = $00000001;
def GTMENU_INVALID = $00000002;
def GTMENU_NOMEM = $00000003;

def MX_WIDTH = 17;
def MX_HEIGHT = 9;

def CHECKBOX_WIDTH = 26;
def CHECKBOX_HEIGHT = 11;

def GT_TagBase = (TAG_USER+$80000);

def GTVI_NewWindow = (GT_TagBase+1);
def GTVI_NWTags = (GT_TagBase+2);

def GT_Private0 = (GT_TagBase+3);

def GTCB_Checked = (GT_TagBase+4);

def GTLV_Top = (GT_TagBase+5);
def GTLV_Labels = (GT_TagBase+6);
def GTLV_ReadOnly = (GT_TagBase+7);
def GTLV_ScrollWidth = (GT_TagBase+8);

def GTMX_Labels = (GT_TagBase+9);
def GTMX_Active = (GT_TagBase+10);

def GTTX_Text = (GT_TagBase+11);
def GTTX_CopyText = (GT_TagBase+12);

def GTNM_Number = (GT_TagBase+13);

def GTCY_Labels = (GT_TagBase+14);
def GTCY_Active = (GT_TagBase+15);

def GTPA_Depth = (GT_TagBase+16);
def GTPA_Color = (GT_TagBase+17);
def GTPA_ColorOffset = (GT_TagBase+18);
def GTPA_IndicatorWidth = (GT_TagBase+19);
def GTPA_IndicatorHeight = (GT_TagBase+20);

def GTSC_Top = (GT_TagBase+21);
def GTSC_Total = (GT_TagBase+22);
def GTSC_Visible = (GT_TagBase+23);
def GTSC_Overlap = (GT_TagBase+24);

def GTSL_Min = (GT_TagBase+38);
def GTSL_Max = (GT_TagBase+39);
def GTSL_Level = (GT_TagBase+40);
def GTSL_MaxLevelLen = (GT_TagBase+41);
def GTSL_LevelFormat = (GT_TagBase+42);
def GTSL_LevelPlace = (GT_TagBase+43);
def GTSL_DispFunc = (GT_TagBase+44);

def GTST_String = (GT_TagBase+45);
def GTST_MaxChars = (GT_TagBase+46);

def GTIN_Number = (GT_TagBase+47);
def GTIN_MaxChars = (GT_TagBase+48);

def GTMN_TextAttr = (GT_TagBase+49);
def GTMN_FrontPen = (GT_TagBase+50);

def GTBB_Recessed = (GT_TagBase+51);

def GT_VisualInfo = (GT_TagBase+52);

def GTLV_ShowSelected = (GT_TagBase+53);
def GTLV_Selected = (GT_TagBase+54);
def GT_Reserved1 = (GT_TagBase+56);

def GTTX_Border = (GT_TagBase+57);
def GTNM_Border = (GT_TagBase+58);

def GTSC_Arrows = (GT_TagBase+59);

def GTMN_Menu = (GT_TagBase+60);
def GTMX_Spacing = (GT_TagBase+61);

def GTMN_FullMenu = (GT_TagBase+62);
def GTMN_SecondaryError = (GT_TagBase+63);
def GT_Underscore = (GT_TagBase+64);
def GTST_EditHook = (GT_TagBase+55);
def GTIN_EditHook = (GTST_EditHook);

def GTMN_Checkmark = (GT_TagBase+65);
def GTMN_AmigaKey = (GT_TagBase+66);
def GTMN_NewLookMenus = (GT_TagBase+67);

def GTCB_Scaled = (GT_TagBase+68);
def GTMX_Scaled = (GT_TagBase+69);

def GTPA_NumColors = (GT_TagBase+70);

def GTMX_TitlePlace = (GT_TagBase+71);

def GTTX_FrontPen = (GT_TagBase+72);
def GTTX_BackPen = (GT_TagBase+73);
def GTTX_Justification = (GT_TagBase+74);

def GTNM_FrontPen = (GT_TagBase+72);
def GTNM_BackPen = (GT_TagBase+73);
def GTNM_Justification = (GT_TagBase+74);
def GTNM_Format = (GT_TagBase+75);
def GTNM_MaxNumberLen = (GT_TagBase+76);

def GTBB_FrameType = (GT_TagBase+77);

def GTLV_MakeVisible = (GT_TagBase+78);
def GTLV_ItemHeight = (GT_TagBase+79);

def GTSL_MaxPixelLen = (GT_TagBase+80);
def GTSL_Justification = (GT_TagBase+81);

def GTPA_ColorTable = (GT_TagBase+82);

def GTLV_CallBack = (GT_TagBase+83);
def GTLV_MaxPen = (GT_TagBase+84);

def GTTX_Clipped = (GT_TagBase+85);
def GTNM_Clipped = (GT_TagBase+85);

def GTJ_LEFT = 0;
def GTJ_RIGHT = 1;
def GTJ_CENTER = 2;

def BBFT_BUTTON = 1;
def BBFT_RIDGE = 2;
def BBFT_ICONDROPBOX = 3;

def INTERWIDTH = 8;
def INTERHEIGHT = 4;

def NWAY_KIND = CYCLE_KIND;
def NWAYIDCMP = CYCLEIDCMP;
def GTNW_Labels = GTCY_Labels;
def GTNW_Active = GTCY_Active;

def LV_DRAW = $202;

def LVCB_OK = 0;
def LVCB_UNKNOWN = 1;

def LVR_NORMAL = 0;
def LVR_SELECTED = 1;
def LVR_NORMALDISABLED = 2;
def LVR_SELECTEDDISABLED = 8;

struct LVDrawMsg is
  lvdm_MethodID:ulong;
  lvdm_RastPort:ulong;
  lvdm_DrawInfo:ulong;
  lvdm_Bounds:Rectangle;
  lvdm_State:ulong;
;

