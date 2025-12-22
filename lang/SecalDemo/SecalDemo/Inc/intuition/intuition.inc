include "inc/exec/types.inc";
include "inc/graphics/gfx.inc";
include "inc/graphics/clip.inc";
include "inc/graphics/view.inc";
include "inc/graphics/rastport.inc";
include "inc/graphics/layers.inc";
include "inc/graphics/text.inc";
include "inc/exec/ports.inc";
include "inc/devices/inputevent.inc";
include "inc/utility/tagitem.inc";

struct Menu is
  NextMenu:ulong;
  LeftEdge,TopEdge:word;
  Width,Height:word;
  Flags:uword;
  MenuName:ulong;
  FirstItem:ulong;
  JazzX,JazzY,BeatX,BeatY:word;
;

def MENUENABLED = $0001;

def MIDRAWN = $0100;

struct MenuItem is
  NextItem:ulong;
  LeftEdge,TopEdge:word;
  Width,Height:word;
  Flags:uword;
  MutualExclude:long;
  ItemFill:ulong;
  SelectFill:ulong;
  Command:byte;
  SubItem:ulong;
  NextSelect:uword;
;

def CHECKIT = $0001;
def ITEMTEXT = $0002;
def COMMSEQ = $0004;
def MENUTOGGLE = $0008;
def ITEMENABLED = $0010;

def HIGHFLAGS = $00c0;
def HIGHIMAGE = $0000;
def HIGHCOMP = $0040;
def HIGHBOX = $0080;
def HIGHNONE = $00c0;

def CHECKED = $0100;

def ISDRAWN = $1000;
def HIGHITEM = $2000;
def MENUTOGGLED = $4000;

struct Requester is
  OlderRequest:ulong;
  LeftEdge,TopEdge:word;
  Width,Height:word;
  RelLeft,RelTop:word;
  ReqGadget:ulong;
  ReqBorder:ulong;
  ReqText:ulong;
  Flags:uword;
  BackFill:ubyte;
  ReqLayer:ulong;
  ReqPad1[32]:ubyte;
  ImageBMap:ulong;
  RWindow:ulong;
  ReqImage:ulong;
  ReqPad2[32]:ubyte;
;

def POINTREL = $0001;
def PREDRAWN = $0002;
def NOISYREQ = $0004;
def SIMPLEREQ = $0010;
def USEREQIMAGE = $0020;
def NOREQBACKFILL = $0040;

def REQOFFWINDOW = $1000;
def REQACTIVE = $2000;
def SYSREQUEST = $4000;
def DEFERREFRESH = $8000;

struct Gadget is
  NextGadget:ulong;
  LeftEdge,TopEdge:word;
  Width,Height:word;
  Flags:uword;
  Activation:uword;
  GadgetType:uword;
  GadgetRender:ulong;
  SelectRender:ulong;
  GadgetText:ulong;
  MutualExclude:long;
  SpecialInfo:ulong;
  GadgetID:uword;
  UserData:ulong;
;

struct ExtGadget is
  NextGadget:ulong;
  LeftEdge,TopEdge:word;
  Width,Height:word;
  Flags:uword;
  Activation:uword;
  GadgetType:uword;
  GadgetRender:ulong;
  SelectRender:ulong;
  GadgetText:ulong;
  MutualExclude:long;
  SpecialInfo:ulong;
  GadgetID:uword;
  UserData:ulong;
  MoreFlags:ulong;
  BoundsLeftEdge:word;
  BoundsTopEdge:word;
  BoundsWidth:word;
  BoundsHeight:word;
;

def GFLG_GADGHIGHBITS = $0003;
def GFLG_GADGHCOMP = $0000;
def GFLG_GADGHBOX = $0001;
def GFLG_GADGHIMAGE = $0002;
def GFLG_GADGHNONE = $0003;
def GFLG_GADGIMAGE = $0004;

def GFLG_RELBOTTOM = $0008;
def GFLG_RELRIGHT = $0010;
def GFLG_RELWIDTH = $0020;
def GFLG_RELHEIGHT = $0040;

def GFLG_RELSPECIAL = $4000;
def GFLG_SELECTED = $0080;

def GFLG_DISABLED = $0100;

def GFLG_LABELMASK = $3000;
def GFLG_LABELITEXT = $0000;
def GFLG_LABELSTRING = $1000;
def GFLG_LABELIMAGE = $2000;

def GFLG_TABCYCLE = $0200;

def GFLG_STRINGEXTEND = $0400;

def GFLG_IMAGEDISABLE = $0800;

def GFLG_EXTENDED = $8000;

def GACT_RELVERIFY = $0001;

def GACT_IMMEDIATE = $0002;

def GACT_ENDGADGET = $0004;

def GACT_FOLLOWMOUSE = $0008;

def GACT_RIGHTBORDER = $0010;
def GACT_LEFTBORDER = $0020;
def GACT_TOPBORDER = $0040;
def GACT_BOTTOMBORDER = $0080;
def GACT_BORDERSNIFF = $8000;

def GACT_TOGGLESELECT = $0100;
def GACT_BOOLEXTEND = $2000;

def GACT_STRINGLEFT = $0000;
def GACT_STRINGCENTER = $0200;
def GACT_STRINGRIGHT = $0400;
def GACT_LONGINT = $0800;
def GACT_ALTKEYMAP = $1000;
def GACT_STRINGEXTEND = $2000;

def GACT_ACTIVEGADGET = $4000;

def GTYP_GADGETTYPE = $fc00;

def GTYP_SCRGADGET = $4000;
def GTYP_GZZGADGET = $2000;
def GTYP_REQGADGET = $1000;

def GTYP_SYSGADGET = $8000;
def GTYP_SYSTYPEMASK = $00f0;

def GTYP_SIZING = $0010;
def GTYP_WDRAGGING = $0020;
def GTYP_SDRAGGING = $0030;
def GTYP_WDEPTH = $0040;
def GTYP_SDEPTH = $0050;
def GTYP_WZOOM = $0060;
def GTYP_SUNUSED = $0070;
def GTYP_CLOSE = $0080;

def GTYP_WUPFRONT = GTYP_WDEPTH;
def GTYP_SUPFRONT = GTYP_SDEPTH;
def GTYP_WDOWNBACK = GTYP_WZOOM;
def GTYP_SDOWNBACK = GTYP_SUNUSED;

def GTYP_GTYPEMASK = $0007;

def GTYP_BOOLGADGET = $0001;
def GTYP_GADGET0002 = $0002;
def GTYP_PROPGADGET = $0003;
def GTYP_STRGADGET = $0004;
def GTYP_CUSTOMGADGET = $0005;

def GMORE_BOUNDS = $00000001;
def GMORE_GADGETHELP = $00000002;
def GMORE_SCROLLRASTER = $00000004;

struct BoolInfo is
  Flags:uword;
  Mask:ulong;
  Reserved:ulong;
;

def BOOLMASK = $0001;

struct PropInfo is
  Flags:uword;
  HorizPot:uword;
  VertPot:uword;
  HorizBody:uword;
  VertBody:uword;
  CWidth:uword;
  CHeight:uword;
  HPotRes,VPotRes:uword;
  LeftBorder:uword;
  TopBorder:uword;
;

def AUTOKNOB = $0001;
def FREEHORIZ = $0002;
def FREEVERT = $0004;
def PROPBORDERLESS = $0008;
def KNOBHIT = $0100;
def PROPNEWLOOK = $0010;

def KNOBHMIN = 6;
def KNOBVMIN = 4;
def MAXBODY = $ffff;
def MAXPOT = $ffff;

struct StringInfo is
  Buffer:ulong;
  UndoBuffer:ulong;
  BufferPos:word;
  MaxChars:word;
  DispPos:word;
  UndoPos:word;
  NumChars:word;
  DispCount:word;
  CLeft,CTop:word;
  Extension:ulong;
  LongInt:long;
  AltKeyMap:ulong;
;

struct IntuiText is
  FrontPen,BackPen:ubyte;
  DrawMode:ubyte;
  LeftEdge:word;
  TopEdge:word;
  ITextFont:ulong;
  IText:ulong;
  NextText:ulong;
;

struct Border is
  LeftEdge,TopEdge:word;
  FrontPen,BackPen:ubyte;
  DrawMode:ubyte;
  Count:byte;
  XY:ulong;
  NextBorder:ulong;
;

struct Image is
  LeftEdge:word;
  TopEdge:word;
  Width:word;
  Height:word;
  Depth:word;
  ImageData:ulong;
  PlanePick,PlaneOnOff:ubyte;
  NextImage:ulong;
;

struct IntuiMessage is
  ExecMessage:Message;
  Class:ulong;
  Code:uword;
  Qualifier:uword;
  IAddress:ulong;
  MouseX,MouseY:word;
  Seconds,Micros:ulong;
  IDCMPWindow:ulong;
  SpecialLink:ulong;
;

struct ExtIntuiMessage is
  eim_IntuiMessage:IntuiMessage;
  eim_TabletData:ulong;
;

def IDCMP_SIZEVERIFY = $00000001;
def IDCMP_NEWSIZE = $00000002;
def IDCMP_REFRESHWINDOW = $00000004;
def IDCMP_MOUSEBUTTONS = $00000008;
def IDCMP_MOUSEMOVE = $00000010;
def IDCMP_GADGETDOWN = $00000020;
def IDCMP_GADGETUP = $00000040;
def IDCMP_REQSET = $00000080;
def IDCMP_MENUPICK = $00000100;
def IDCMP_CLOSEWINDOW = $00000200;
def IDCMP_RAWKEY = $00000400;
def IDCMP_REQVERIFY = $00000800;
def IDCMP_REQCLEAR = $00001000;
def IDCMP_MENUVERIFY = $00002000;
def IDCMP_NEWPREFS = $00004000;
def IDCMP_DISKINSERTED = $00008000;
def IDCMP_DISKREMOVED = $00010000;
def IDCMP_WBENCHMESSAGE = $00020000;
def IDCMP_ACTIVEWINDOW = $00040000;
def IDCMP_INACTIVEWINDOW = $00080000;
def IDCMP_DELTAMOVE = $00100000;
def IDCMP_VANILLAKEY = $00200000;
def IDCMP_INTUITICKS = $00400000;

def IDCMP_IDCMPUPDATE = $00800000;
def IDCMP_MENUHELP = $01000000;
def IDCMP_CHANGEWINDOW = $02000000;

def IDCMP_GADGETHELP = $04000000;

def IDCMP_LONELYMESSAGE = $80000000;

def CWCODE_MOVESIZE = $0000;
def CWCODE_DEPTH = $0001;

def MENUHOT = $0001;
def MENUCANCEL = $0002;
def MENUWAITING = $0003;

def OKOK = MENUHOT;
def OKABORT = $0004;
def OKCANCEL = MENUCANCEL;

def WBENCHOPEN = $0001;
def WBENCHCLOSE = $0002;

struct IBox is
  Left:word;
  Top:word;
  Width:word;
  Height:word;
;

struct Window is
  NextWindow:ulong;
  LeftEdge,TopEdge:word;
  Width,Height:word;
  MouseY,MouseX:word;
  MinWidth,MinHeight:word;
  MaxWidth,MaxHeight:uword;
  Flags:ulong;
  MenuStrip:ulong;
  Title:ulong;
  FirstRequest:ulong;
  DMRequest:ulong;
  ReqCount:word;
  WScreen:ulong;
  RPort:ulong;
  BorderLeft,BorderTop,BorderRight,BorderBottom:byte;
  BorderRPort:ulong;
  FirstGadget:ulong;
  Parent:ulong;
  Descendant:ulong;
  Pointer:ulong;
  PtrHeight:byte;
  PtrWidth:byte;
  XOffset,YOffset:byte;
  IDCMPFlags:ulong;
  UserPort:ulong;
  WindowPort:ulong;
  MessageKey:ulong;
  DetailPen,BlockPen:ubyte;
  CheckMark:ulong;
  ScreenTitle:ulong;
  GZZMouseX:word;
  GZZMouseY:word;
  GZZWidth:word;
  GZZHeight:word;
  ExtData:ulong;
  UserData:ulong;
  WLayer:ulong;
  IFont:ulong;
  MoreFlags:ulong;
;

def WFLG_SIZEGADGET = $00000001;
def WFLG_DRAGBAR = $00000002;
def WFLG_DEPTHGADGET = $00000004;
def WFLG_CLOSEGADGET = $00000008;

def WFLG_SIZEBRIGHT = $00000010;
def WFLG_SIZEBBOTTOM = $00000020;

def WFLG_REFRESHBITS = $000000c0;
def WFLG_SMART_REFRESH = $00000000;
def WFLG_SIMPLE_REFRESH = $00000040;
def WFLG_SUPER_BITMAP = $00000080;
def WFLG_OTHER_REFRESH = $000000c0;

def WFLG_BACKDROP = $00000100;

def WFLG_REPORTMOUSE = $00000200;

def WFLG_GIMMEZEROZERO = $00000400;

def WFLG_BORDERLESS = $00000800;

def WFLG_ACTIVATE = $00001000;

def WFLG_RMBTRAP = $00010000;
def WFLG_NOCAREREFRESH = $00020000;

def WFLG_NW_EXTENDED = $00040000;

def WFLG_NEWLOOKMENUS = $00200000;

def WFLG_WINDOWACTIVE = $00002000;
def WFLG_INREQUEST = $00004000;
def WFLG_MENUSTATE = $00008000;
def WFLG_WINDOWREFRESH = $01000000;
def WFLG_WBENCHWINDOW = $02000000;
def WFLG_WINDOWTICKED = $04000000;

def WFLG_VISITOR = $08000000;
def WFLG_ZOOMED = $10000000;
def WFLG_HASZOOM = $20000000;

def DEFAULTMOUSEQUEUE = (5);

struct NewWindow is
  LeftEdge,TopEdge:word;
  Width,Height:word;
  DetailPen,BlockPen:ubyte;
  IDCMPFlags:ulong;
  Flags:ulong;
  FirstGadget:ulong;
  CheckMark:ulong;
  Title:ulong;
  Screen:ulong;
  BitMap:ulong;
  MinWidth,MinHeight:word;
  MaxWidth,MaxHeight:uword;
  Type:uword;
;

struct ExtNewWindow is
  LeftEdge,TopEdge:word;
  Width,Height:word;
  DetailPen,BlockPen:ubyte;
  IDCMPFlags:ulong;
  Flags:ulong;
  FirstGadget:ulong;
  CheckMark:ulong;
  Title:ulong;
  Screen:ulong;
  BitMap:ulong;
  MinWidth,MinHeight:word;
  MaxWidth,MaxHeight:uword;
  Type:uword;
  Extension:ulong;
;

def WA_Dummy = (TAG_USER+99);

def WA_Left = (WA_Dummy+$01);
def WA_Top = (WA_Dummy+$02);
def WA_Width = (WA_Dummy+$03);
def WA_Height = (WA_Dummy+$04);
def WA_DetailPen = (WA_Dummy+$05);
def WA_BlockPen = (WA_Dummy+$06);
def WA_IDCMP = (WA_Dummy+$07);
def WA_Flags = (WA_Dummy+$08);
def WA_Gadgets = (WA_Dummy+$09);
def WA_Checkmark = (WA_Dummy+$0a);
def WA_Title = (WA_Dummy+$0b);
def WA_ScreenTitle = (WA_Dummy+$0c);
def WA_CustomScreen = (WA_Dummy+$0d);
def WA_SuperBitMap = (WA_Dummy+$0e);
def WA_MinWidth = (WA_Dummy+$0f);
def WA_MinHeight = (WA_Dummy+$10);
def WA_MaxWidth = (WA_Dummy+$11);
def WA_MaxHeight = (WA_Dummy+$12);
def WA_InnerWidth = (WA_Dummy+$13);
def WA_InnerHeight = (WA_Dummy+$14);
def WA_PubScreenName = (WA_Dummy+$15);
def WA_PubScreen = (WA_Dummy+$16);
def WA_PubScreenFallBack = (WA_Dummy+$17);
def WA_WindowName = (WA_Dummy+$18);
def WA_Colors = (WA_Dummy+$19);
def WA_Zoom = (WA_Dummy+$1a);
def WA_MouseQueue = (WA_Dummy+$1b);
def WA_BackFill = (WA_Dummy+$1c);
def WA_RptQueue = (WA_Dummy+$1d);
def WA_SizeGadget = (WA_Dummy+$1e);
def WA_DragBar = (WA_Dummy+$1f);
def WA_DepthGadget = (WA_Dummy+$20);
def WA_CloseGadget = (WA_Dummy+$21);
def WA_Backdrop = (WA_Dummy+$22);
def WA_ReportMouse = (WA_Dummy+$23);
def WA_NoCareRefresh = (WA_Dummy+$24);
def WA_Borderless = (WA_Dummy+$25);
def WA_Activate = (WA_Dummy+$26);
def WA_RMBTrap = (WA_Dummy+$27);
def WA_WBenchWindow = (WA_Dummy+$28);
def WA_SimpleRefresh = (WA_Dummy+$29);
def WA_SmartRefresh = (WA_Dummy+$2a);
def WA_SizeBRight = (WA_Dummy+$2b);
def WA_SizeBBottom = (WA_Dummy+$2c);
def WA_AutoAdjust = (WA_Dummy+$2d);
def WA_GimmeZeroZero = (WA_Dummy+$2e);

def WA_MenuHelp = (WA_Dummy+$2f);

def WA_NewLookMenus = (WA_Dummy+$30);
def WA_AmigaKey = (WA_Dummy+$31);
def WA_NotifyDepth = (WA_Dummy+$32);

def WA_Pointer = (WA_Dummy+$34);
def WA_BusyPointer = (WA_Dummy+$35);
def WA_PointerDelay = (WA_Dummy+$36);
def WA_TabletMessages = (WA_Dummy+$37);
def WA_HelpGroup = (WA_Dummy+$38);
def WA_HelpGroupWindow = (WA_Dummy+$39);

def HC_GADGETHELP = (1);

include "inc/intuition/screens.inc";
include "inc/intuition/preferences.inc";

struct Remember is
  NextRemember:ulong;
  RememberSize:ulong;
  Memory:ulong;
;

struct ColorSpec is
  ColorIndex:word;
  Red:uword;
  Green:uword;
  Blue:uword;
;

struct EasyStruct is
  es_StructSize:ulong;
  es_Flags:ulong;
  es_Title:ulong;
  es_TextFormat:ulong;
  es_GadgetFormat:ulong;
;

def MENUNUM(n) = ((n)&$1f);
def ITEMNUM(n) = (((n)>>5)&$003f);
def SUBNUM(n) = (((n)>>11)&$001f);

def SHIFTMENU(n) = ((n)&$1f);
def SHIFTITEM(n) = (((n)&$3f)<<5);
def SHIFTSUB(n) = (((n)&$1f)<<11);

def FULLMENUNUM(menu,item,sub) = (SHIFTSUB(sub)|SHIFTITEM(item)|SHIFTMENU(menu));

def SRBNUM(n) = ($08-((n)>>4));
def SWBNUM(n) = ($08-((n)&$0f));
def SSBNUM(n) = ($01+((n)>>4));
def SPARNUM(n) = ((n)>>4);
def SHAKNUM(n) = ((n)&$0f);

def NOMENU = $001f;
def NOITEM = $003f;
def NOSUB = $001f;
def MENUNULL = $ffff;

def CHECKWIDTH = 19;
def COMMWIDTH = 27;
def LOWCHECKWIDTH = 13;
def LOWCOMMWIDTH = 16;

def ALERT_TYPE = $80000000;
def RECOVERY_ALERT = $00000000;
def DEADEND_ALERT = $80000000;

def AUTOFRONTPEN = 0;
def AUTOBACKPEN = 1;
def AUTODRAWMODE = JAM2;
def AUTOLEFTEDGE = 6;
def AUTOTOPEDGE = 3;
def AUTOITEXTFONT = NULL;
def AUTONEXTTEXT = NULL;

def SELECTUP = (IECODE_LBUTTON|IECODE_UP_PREFIX);
def SELECTDOWN = (IECODE_LBUTTON);
def MENUUP = (IECODE_RBUTTON|IECODE_UP_PREFIX);
def MENUDOWN = (IECODE_RBUTTON);
def MIDDLEUP = (IECODE_MBUTTON|IECODE_UP_PREFIX);
def MIDDLEDOWN = (IECODE_MBUTTON);
def ALTLEFT = (IEQUALIFIER_LALT);
def ALTRIGHT = (IEQUALIFIER_RALT);
def AMIGALEFT = (IEQUALIFIER_LCOMMAND);
def AMIGARIGHT = (IEQUALIFIER_RCOMMAND);
def AMIGAKEYS = (AMIGALEFT|AMIGARIGHT);

def CURSORUP = $4c;
def CURSORLEFT = $4f;
def CURSORRIGHT = $4e;
def CURSORDOWN = $4d;
def KEYCODE_Q = $10;
def KEYCODE_Z = $31;
def KEYCODE_X = $32;
def KEYCODE_V = $34;
def KEYCODE_B = $35;
def KEYCODE_N = $36;
def KEYCODE_M = $37;
def KEYCODE_LESS = $38;
def KEYCODE_GREATER = $39;

def TABLETA_Dummy = (TAG_USER+$3a000);
def TABLETA_TabletZ = (TABLETA_Dummy+$01);
def TABLETA_RangeZ = (TABLETA_Dummy+$02);
def TABLETA_AngleX = (TABLETA_Dummy+$03);
def TABLETA_AngleY = (TABLETA_Dummy+$04);
def TABLETA_AngleZ = (TABLETA_Dummy+$05);
def TABLETA_Pressure = (TABLETA_Dummy+$06);
def TABLETA_ButtonBits = (TABLETA_Dummy+$07);
def TABLETA_InProximity = (TABLETA_Dummy+$08);
def TABLETA_ResolutionX = (TABLETA_Dummy+$09);
def TABLETA_ResolutionY = (TABLETA_Dummy+$0a);

struct TabletData is
  td_XFraction,td_YFraction:uword;
  td_TabletX,td_TabletY:ulong;
  td_RangeX,td_RangeY:ulong;
  td_TagList:ulong;
;

struct TabletHookData is
  thd_Screen:ulong;
  thd_Width:ulong;
  thd_Height:ulong;
  thd_ScreenChanged:long;
;

