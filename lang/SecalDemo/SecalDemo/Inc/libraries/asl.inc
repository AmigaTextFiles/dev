include "inc/exec/types.inc";
include "inc/exec/nodes.inc";
include "inc/utility/tagitem.inc";
include "inc/workbench/startup.inc";
include "inc/graphics/text.inc";
include "inc/graphics/displayinfo.inc";

def AslName = "asl.library";
def ASL_TB = (TAG_USER+$80000);

def ASL_FileRequest = 0;
def ASL_FontRequest = 1;
def ASL_ScreenModeRequest = 2;

struct FileRequester is
  fr_Reserved0[4]:ubyte;
  fr_File:ulong;
  fr_Drawer:ulong;
  fr_Reserved1[10]:ubyte;
  fr_LeftEdge:word;
  fr_TopEdge:word;
  fr_Width:word;
  fr_Height:word;
  fr_Reserved2[2]:ubyte;
  fr_NumArgs:long;
  fr_ArgList:ulong;
  fr_UserData:ulong;
  fr_Reserved3[8]:ubyte;
  fr_Pattern:ulong;
;

def ASLFR_Window = (ASL_TB+2);
def ASLFR_Screen = (ASL_TB+40);
def ASLFR_PubScreenName = (ASL_TB+41);
def ASLFR_PrivateIDCMP = (ASL_TB+42);
def ASLFR_IntuiMsgFunc = (ASL_TB+70);
def ASLFR_SleepWindow = (ASL_TB+43);
def ASLFR_UserData = (ASL_TB+52);

def ASLFR_TextAttr = (ASL_TB+51);
def ASLFR_Locale = (ASL_TB+50);
def ASLFR_TitleText = (ASL_TB+1);
def ASLFR_PositiveText = (ASL_TB+18);
def ASLFR_NegativeText = (ASL_TB+19);

def ASLFR_InitialLeftEdge = (ASL_TB+3);
def ASLFR_InitialTopEdge = (ASL_TB+4);
def ASLFR_InitialWidth = (ASL_TB+5);
def ASLFR_InitialHeight = (ASL_TB+6);
def ASLFR_InitialFile = (ASL_TB+8);
def ASLFR_InitialDrawer = (ASL_TB+9);
def ASLFR_InitialPattern = (ASL_TB+10);

def ASLFR_Flags1 = (ASL_TB+20);
def ASLFR_Flags2 = (ASL_TB+22);
def ASLFR_DoSaveMode = (ASL_TB+44);
def ASLFR_DoMultiSelect = (ASL_TB+45);
def ASLFR_DoPatterns = (ASL_TB+46);

def ASLFR_DrawersOnly = (ASL_TB+47);
def ASLFR_FilterFunc = (ASL_TB+49);
def ASLFR_RejectIcons = (ASL_TB+60);
def ASLFR_RejectPattern = (ASL_TB+61);
def ASLFR_AcceptPattern = (ASL_TB+62);
def ASLFR_FilterDrawers = (ASL_TB+63);
def ASLFR_HookFunc = (ASL_TB+7);

def FRB_FILTERFUNC = 7;
def FRB_INTUIFUNC = 6;
def FRB_DOSAVEMODE = 5;
def FRB_PRIVATEIDCMP = 4;
def FRB_DOMULTISELECT = 3;
def FRB_DOPATTERNS = 0;

def FRF_FILTERFUNC = (1<<FRB_FILTERFUNC);
def FRF_INTUIFUNC = (1<<FRB_INTUIFUNC);
def FRF_DOSAVEMODE = (1<<FRB_DOSAVEMODE);
def FRF_PRIVATEIDCMP = (1<<FRB_PRIVATEIDCMP);
def FRF_DOMULTISELECT = (1<<FRB_DOMULTISELECT);
def FRF_DOPATTERNS = (1<<FRB_DOPATTERNS);

def FRB_DRAWERSONLY = 0;
def FRB_FILTERDRAWERS = 1;
def FRB_REJECTICONS = 2;

def FRF_DRAWERSONLY = (1<<FRB_DRAWERSONLY);
def FRF_FILTERDRAWERS = (1<<FRB_FILTERDRAWERS);
def FRF_REJECTICONS = (1<<FRB_REJECTICONS);

struct FontRequester is
  fo_Reserved0[8]:ubyte;
  fo_Attr:TextAttr;
  fo_FrontPen:ubyte;
  fo_BackPen:ubyte;
  fo_DrawMode:ubyte;
  fo_Reserved1:ubyte;
  fo_UserData:ulong;
  fo_LeftEdge:word;
  fo_TopEdge:word;
  fo_Width:word;
  fo_Height:word;
  fo_TAttr:TTextAttr;
;

def ASLFO_Window = (ASL_TB+2);
def ASLFO_Screen = (ASL_TB+40);
def ASLFO_PubScreenName = (ASL_TB+41);
def ASLFO_PrivateIDCMP = (ASL_TB+42);
def ASLFO_IntuiMsgFunc = (ASL_TB+70);
def ASLFO_SleepWindow = (ASL_TB+43);
def ASLFO_UserData = (ASL_TB+52);

def ASLFO_TextAttr = (ASL_TB+51);
def ASLFO_Locale = (ASL_TB+50);
def ASLFO_TitleText = (ASL_TB+1);
def ASLFO_PositiveText = (ASL_TB+18);
def ASLFO_NegativeText = (ASL_TB+19);

def ASLFO_InitialLeftEdge = (ASL_TB+3);
def ASLFO_InitialTopEdge = (ASL_TB+4);
def ASLFO_InitialWidth = (ASL_TB+5);
def ASLFO_InitialHeight = (ASL_TB+6);
def ASLFO_InitialName = (ASL_TB+10);
def ASLFO_InitialSize = (ASL_TB+11);
def ASLFO_InitialStyle = (ASL_TB+12);
def ASLFO_InitialFlags = (ASL_TB+13);
def ASLFO_InitialFrontPen = (ASL_TB+14);
def ASLFO_InitialBackPen = (ASL_TB+15);
def ASLFO_InitialDrawMode = (ASL_TB+59);

def ASLFO_Flags = (ASL_TB+20);
def ASLFO_DoFrontPen = (ASL_TB+44);
def ASLFO_DoBackPen = (ASL_TB+45);
def ASLFO_DoStyle = (ASL_TB+46);
def ASLFO_DoDrawMode = (ASL_TB+47);

def ASLFO_FixedWidthOnly = (ASL_TB+48);
def ASLFO_MinHeight = (ASL_TB+16);
def ASLFO_MaxHeight = (ASL_TB+17);
def ASLFO_FilterFunc = (ASL_TB+49);
def ASLFO_HookFunc = (ASL_TB+7);
def ASLFO_MaxFrontPen = (ASL_TB+66);
def ASLFO_MaxBackPen = (ASL_TB+67);

def ASLFO_ModeList = (ASL_TB+21);
def ASLFO_FrontPens = (ASL_TB+64);
def ASLFO_BackPens = (ASL_TB+65);

def FOB_DOFRONTPEN = 0;
def FOB_DOBACKPEN = 1;
def FOB_DOSTYLE = 2;
def FOB_DODRAWMODE = 3;
def FOB_FIXEDWIDTHONLY = 4;
def FOB_PRIVATEIDCMP = 5;
def FOB_INTUIFUNC = 6;
def FOB_FILTERFUNC = 7;

def FOF_DOFRONTPEN = (1<<FOB_DOFRONTPEN);
def FOF_DOBACKPEN = (1<<FOB_DOBACKPEN);
def FOF_DOSTYLE = (1<<FOB_DOSTYLE);
def FOF_DODRAWMODE = (1<<FOB_DODRAWMODE);
def FOF_FIXEDWIDTHONLY = (1<<FOB_FIXEDWIDTHONLY);
def FOF_PRIVATEIDCMP = (1<<FOB_PRIVATEIDCMP);
def FOF_INTUIFUNC = (1<<FOB_INTUIFUNC);
def FOF_FILTERFUNC = (1<<FOB_FILTERFUNC);

struct ScreenModeRequester is
  sm_DisplayID:ulong;
  sm_DisplayWidth:ulong;
  sm_DisplayHeight:ulong;
  sm_DisplayDepth:uword;
  sm_OverscanType:uword;
  sm_AutoScroll:word;
  sm_BitMapWidth:ulong;
  sm_BitMapHeight:ulong;
  sm_LeftEdge:word;
  sm_TopEdge:word;
  sm_Width:word;
  sm_Height:word;
  sm_InfoOpened:word;
  sm_InfoLeftEdge:word;
  sm_InfoTopEdge:word;
  sm_InfoWidth:word;
  sm_InfoHeight:word;
  sm_UserData:ulong;
;

struct DisplayMode is
  dm_Node:Node;
  dm_DimensionInfo:DimensionInfo;
  dm_PropertyFlags:ulong;
;

def ASLSM_Window = (ASL_TB+2);
def ASLSM_Screen = (ASL_TB+40);
def ASLSM_PubScreenName = (ASL_TB+41);
def ASLSM_PrivateIDCMP = (ASL_TB+42);
def ASLSM_IntuiMsgFunc = (ASL_TB+70);
def ASLSM_SleepWindow = (ASL_TB+43);
def ASLSM_UserData = (ASL_TB+52);

def ASLSM_TextAttr = (ASL_TB+51);
def ASLSM_Locale = (ASL_TB+50);
def ASLSM_TitleText = (ASL_TB+1);
def ASLSM_PositiveText = (ASL_TB+18);
def ASLSM_NegativeText = (ASL_TB+19);

def ASLSM_InitialLeftEdge = (ASL_TB+3);
def ASLSM_InitialTopEdge = (ASL_TB+4);
def ASLSM_InitialWidth = (ASL_TB+5);
def ASLSM_InitialHeight = (ASL_TB+6);
def ASLSM_InitialDisplayID = (ASL_TB+100);
def ASLSM_InitialDisplayWidth = (ASL_TB+101);
def ASLSM_InitialDisplayHeight = (ASL_TB+102);
def ASLSM_InitialDisplayDepth = (ASL_TB+103);
def ASLSM_InitialOverscanType = (ASL_TB+104);
def ASLSM_InitialAutoScroll = (ASL_TB+105);
def ASLSM_InitialInfoOpened = (ASL_TB+106);
def ASLSM_InitialInfoLeftEdge = (ASL_TB+107);
def ASLSM_InitialInfoTopEdge = (ASL_TB+108);

def ASLSM_DoWidth = (ASL_TB+109);
def ASLSM_DoHeight = (ASL_TB+110);
def ASLSM_DoDepth = (ASL_TB+111);
def ASLSM_DoOverscanType = (ASL_TB+112);
def ASLSM_DoAutoScroll = (ASL_TB+113);

def ASLSM_PropertyFlags = (ASL_TB+114);
def ASLSM_PropertyMask = (ASL_TB+115);
def ASLSM_MinWidth = (ASL_TB+116);
def ASLSM_MaxWidth = (ASL_TB+117);
def ASLSM_MinHeight = (ASL_TB+118);
def ASLSM_MaxHeight = (ASL_TB+119);
def ASLSM_MinDepth = (ASL_TB+120);
def ASLSM_MaxDepth = (ASL_TB+121);
def ASLSM_FilterFunc = (ASL_TB+122);

def ASLSM_CustomSMList = (ASL_TB+123);

